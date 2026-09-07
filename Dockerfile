# ==========================================
# Etapa 1: Construcción (Builder)
# ==========================================
FROM node:18-alpine AS builder

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar primero los archivos de dependencias para aprovechar el caché de Docker
COPY package.json package-lock.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto del código fuente
COPY . .

# Construir la aplicación para producción (genera la carpeta /build)
RUN npm run build

# ==========================================
# Etapa 2: Producción (Servidor web Nginx)
# ==========================================
FROM nginx:alpine

# Eliminar los archivos por defecto de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copiar los archivos estáticos generados en la Etapa 1 a Nginx
COPY --from=builder /app/build /usr/share/nginx/html

# Exponer el puerto 80 (puerto por defecto de HTTP)
EXPOSE 80

# Comando para iniciar Nginx y mantenerlo en primer plano
CMD ["nginx", "-g", "daemon off;"]

#!/bin/bash
echo "🚀 Starting RDP Setup..."

# Update system
sudo apt update -y

# Install XRDP
sudo apt install -y xrdp

# Install desktop apps
sudo apt install -y firefox chromium-browser

# Create RDP user
sudo useradd -m -s /bin/bash rdpuser
echo "rdpuser:password123" | sudo chpasswd

# Configure XRDP
echo "xfce4-session" | sudo tee /home/rdpuser/.xsession
sudo chown rdpuser:rdpuser /home/rdpuser/.xsession
sudo systemctl enable xrdp

# Create start script
cat > /workspace/start-rdp.sh << 'EOF'
#!/bin/bash
echo "🔥 Starting RDP..."
sudo systemctl start xrdp

# Get connection info
CODESPACE_URL=$(echo $CODESPACE_NAME.github.dev)
echo "=================================="
echo "🌐 Web Desktop: https://$CODESPACE_URL:6080"
echo "📱 RDP Address: $CODESPACE_URL:3389"
echo "👤 Username: rdpuser"
echo "🔑 Password: password123"
echo "=================================="

while true; do
    echo "✅ Server running: $(date)"
    sleep 300
done
EOF

chmod +x /workspace/start-rdp.sh
echo "✅ Setup Complete!"

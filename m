Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0CBS3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:29:43 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38733 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754168Ab0CBS3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:29:38 -0500
Date: Tue, 2 Mar 2010 21:29:36 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] ahci: Factor out PCI specifics from
 ahci_init_controller()
Message-ID: <20100302182936.GG3445@oksana.dev.rtsoft.ru>
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move PCI stuff into ahci_pci_init_controller().

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/ahci.c |   45 +++++++++++++++++++++++++++------------------
 1 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 1afb35e..aaeac15 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1643,11 +1643,34 @@ static void ahci_port_init(struct device *dev, struct ata_port *ap,
 static void ahci_init_controller(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
-	struct pci_dev *pdev = to_pci_dev(host->dev);
 	void __iomem *mmio = hpriv->mmio;
 	int i;
 	void __iomem *port_mmio;
 	u32 tmp;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		port_mmio = ahci_port_base(ap);
+		if (ata_port_is_dummy(ap))
+			continue;
+
+		ahci_port_init(host->dev, ap, i, mmio, port_mmio);
+	}
+
+	tmp = readl(mmio + HOST_CTL);
+	VPRINTK("HOST_CTL 0x%x\n", tmp);
+	writel(tmp | HOST_IRQ_EN, mmio + HOST_CTL);
+	tmp = readl(mmio + HOST_CTL);
+	VPRINTK("HOST_CTL 0x%x\n", tmp);
+}
+
+static void ahci_pci_init_controller(struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	void __iomem *port_mmio;
+	u32 tmp;
 	int mv;
 
 	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
@@ -1666,21 +1689,7 @@ static void ahci_init_controller(struct ata_host *host)
 			writel(tmp, port_mmio + PORT_IRQ_STAT);
 	}
 
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		port_mmio = ahci_port_base(ap);
-		if (ata_port_is_dummy(ap))
-			continue;
-
-		ahci_port_init(host->dev, ap, i, mmio, port_mmio);
-	}
-
-	tmp = readl(mmio + HOST_CTL);
-	VPRINTK("HOST_CTL 0x%x\n", tmp);
-	writel(tmp | HOST_IRQ_EN, mmio + HOST_CTL);
-	tmp = readl(mmio + HOST_CTL);
-	VPRINTK("HOST_CTL 0x%x\n", tmp);
+	ahci_init_controller(host);
 }
 
 static void ahci_dev_config(struct ata_device *dev)
@@ -2511,7 +2520,7 @@ static int ahci_pci_device_resume(struct pci_dev *pdev)
 		if (rc)
 			return rc;
 
-		ahci_init_controller(host);
+		ahci_pci_init_controller(host);
 	}
 
 	ata_host_resume(host);
@@ -3219,7 +3228,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	ahci_init_controller(host);
+	ahci_pci_init_controller(host);
 	ahci_print_info(host);
 
 	pci_set_master(pdev);
-- 
1.7.0


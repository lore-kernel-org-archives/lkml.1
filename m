Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab0CCRRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:17:49 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:37351 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754839Ab0CCRRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:17:45 -0500
Date: Wed, 3 Mar 2010 20:17:43 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] ahci: Factor out PCI specifics from ahci_print_info()
Message-ID: <20100303171743.GG12362@oksana.dev.rtsoft.ru>
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100303171713.GA6322@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce ahci_pci_print_info() that now handles PCI stuff.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/ahci.c |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 439ff90..f904683 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2818,15 +2818,12 @@ static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
 	return 0;
 }
 
-static void ahci_print_info(struct ata_host *host)
+static void ahci_print_info(struct ata_host *host, const char *scc_s)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
-	struct pci_dev *pdev = to_pci_dev(host->dev);
 	void __iomem *mmio = hpriv->mmio;
 	u32 vers, cap, cap2, impl, speed;
 	const char *speed_s;
-	u16 cc;
-	const char *scc_s;
 
 	vers = readl(mmio + HOST_VERSION);
 	cap = hpriv->cap;
@@ -2843,17 +2840,7 @@ static void ahci_print_info(struct ata_host *host)
 	else
 		speed_s = "?";
 
-	pci_read_config_word(pdev, 0x0a, &cc);
-	if (cc == PCI_CLASS_STORAGE_IDE)
-		scc_s = "IDE";
-	else if (cc == PCI_CLASS_STORAGE_SATA)
-		scc_s = "SATA";
-	else if (cc == PCI_CLASS_STORAGE_RAID)
-		scc_s = "RAID";
-	else
-		scc_s = "unknown";
-
-	dev_printk(KERN_INFO, &pdev->dev,
+	dev_info(host->dev,
 		"AHCI %02x%02x.%02x%02x "
 		"%u slots %u ports %s Gbps 0x%x impl %s mode\n"
 		,
@@ -2869,7 +2856,7 @@ static void ahci_print_info(struct ata_host *host)
 		impl,
 		scc_s);
 
-	dev_printk(KERN_INFO, &pdev->dev,
+	dev_info(host->dev,
 		"flags: "
 		"%s%s%s%s%s%s%s"
 		"%s%s%s%s%s%s%s"
@@ -2899,6 +2886,25 @@ static void ahci_print_info(struct ata_host *host)
 		);
 }
 
+static void ahci_pci_print_info(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	u16 cc;
+	const char *scc_s;
+
+	pci_read_config_word(pdev, 0x0a, &cc);
+	if (cc == PCI_CLASS_STORAGE_IDE)
+		scc_s = "IDE";
+	else if (cc == PCI_CLASS_STORAGE_SATA)
+		scc_s = "SATA";
+	else if (cc == PCI_CLASS_STORAGE_RAID)
+		scc_s = "RAID";
+	else
+		scc_s = "unknown";
+
+	ahci_print_info(host, scc_s);
+}
+
 /* On ASUS P5W DH Deluxe, the second port of PCI device 00:1f.2 is
  * hardwired to on-board SIMG 4726.  The chipset is ICH8 and doesn't
  * support PMP and the 4726 either directly exports the device
@@ -3420,7 +3426,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 
 	ahci_pci_init_controller(host);
-	ahci_print_info(host);
+	ahci_pci_print_info(host);
 
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
-- 
1.7.0


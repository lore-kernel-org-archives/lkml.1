Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYCHVXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYCHVXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYCHVVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:21:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:54620 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYCHVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bC8nIUaIRvblCdBs4wZLN8f0qRHZEg9s48o99nphpOxZEkTRvraEKP2zl43JVyYf4VZMirNYIQ6aG/AvBEDA50PjfliHb+cNA0tHIrg2Rsq1lWjCawJucVjGRTkGT94n2ioJy18wtIMIkfQiNMOvouEE9BtAvC1vVR6u9jsHeY8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 6/7] ide: factor out setting PCI bus-mastering from ide_hwif_setup_dma()
Date: Sat, 8 Mar 2008 22:33:18 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803082233.18333.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out setting PCI bus-mastering from ide_hwif_setup_dma()
to ide_pci_set_master() helper.

While at it:

* don't read PCI Command register if not necessary

* use PCI device name instead of hwif->name

* cleanup ide_hwif_setup_dma() a bit

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/setup-pci.c |   61 +++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 24 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -132,6 +132,29 @@ static unsigned long ide_get_or_set_dma_
 out:
 	return dma_base;
 }
+
+/*
+ * Set up BM-DMA capability (PnP BIOS should have done this)
+ */
+static int ide_pci_set_master(struct pci_dev *dev, const char *name)
+{
+	u16 pcicmd;
+
+	pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
+
+	if ((pcicmd & PCI_COMMAND_MASTER) == 0) {
+		pci_set_master(dev);
+
+		if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) ||
+		    (pcicmd & PCI_COMMAND_MASTER) == 0) {
+			printk(KERN_ERR "%s: error updating PCICMD on %s\n",
+					name, pci_name(dev));
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
 void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
@@ -339,36 +362,26 @@ static ide_hwif_t *ide_hwif_configure(st
 void ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u16 pcicmd;
-
-	pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
 
 	if ((d->host_flags & IDE_HFLAG_NO_AUTODMA) == 0 ||
 	    ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE &&
 	     (dev->class & 0x80))) {
 		unsigned long dma_base = ide_get_or_set_dma_base(d, hwif);
-		if (dma_base && !(pcicmd & PCI_COMMAND_MASTER)) {
-			/*
-			 * Set up BM-DMA capability
-			 * (PnP BIOS should have done this)
-			 */
-			pci_set_master(dev);
-			if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) || !(pcicmd & PCI_COMMAND_MASTER)) {
-				printk(KERN_ERR "%s: %s error updating PCICMD\n",
-					hwif->name, d->name);
-				dma_base = 0;
-			}
-		}
-		if (dma_base) {
-			if (d->init_dma)
-				d->init_dma(hwif, dma_base);
-
-			ide_setup_dma(hwif, dma_base);
-		} else {
-			printk(KERN_INFO "%s: %s Bus-Master DMA disabled "
-				"(BIOS)\n", hwif->name, d->name);
-		}
+
+		if (dma_base == 0 || ide_pci_set_master(dev, d->name) < 0)
+			goto out_disabled;
+
+		if (d->init_dma)
+			d->init_dma(hwif, dma_base);
+
+		ide_setup_dma(hwif, dma_base);
 	}
+
+	return;
+
+out_disabled:
+	printk(KERN_INFO "%s: Bus-Master DMA disabled (BIOS) on %s\n",
+			 d->name, pci_name(dev));
 }
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 

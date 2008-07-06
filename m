Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbYGFRi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbYGFRi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbYGFRfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:6801 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbYGFRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=WhLe4fseGfQh/qDQywK0UQWS4YX60U4EZctdUxW86ba4JVj/uysaZv8N2/v0TTaGlM
         cyBhB799pkXZKOeRSl3dTIrO0VXLEgjshEHV5iYowCi7MvoJJb6wHhGW+4YOGEhIID+B
         CetySZexhppQnHv7vFdiiH553i9Jz9/POsnF0=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:22 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/50] siimage: convert to use ->host_priv
Content-Disposition: inline; filename=siimage-convert-to-use-host_priv.patch
Message-ID: <4871023b.1ade660a.3458.6281@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:

* Reserve PCI BAR 5 in siimage_init_one() and remove no longer needed
  setup_mmio_siimage().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/siimage.c |  114 +++++++++++++++++++++++-----------------------
 1 file changed, 58 insertions(+), 56 deletions(-)

Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -127,9 +127,10 @@ static inline unsigned long siimage_seld
 
 static u8 sil_ioread8(struct pci_dev *dev, unsigned long addr)
 {
+	struct ide_host *host = pci_get_drvdata(dev);
 	u8 tmp = 0;
 
-	if (pci_get_drvdata(dev))
+	if (host->host_priv)
 		tmp = readb((void __iomem *)addr);
 	else
 		pci_read_config_byte(dev, addr, &tmp);
@@ -139,9 +140,10 @@ static u8 sil_ioread8(struct pci_dev *de
 
 static u16 sil_ioread16(struct pci_dev *dev, unsigned long addr)
 {
+	struct ide_host *host = pci_get_drvdata(dev);
 	u16 tmp = 0;
 
-	if (pci_get_drvdata(dev))
+	if (host->host_priv)
 		tmp = readw((void __iomem *)addr);
 	else
 		pci_read_config_word(dev, addr, &tmp);
@@ -151,7 +153,9 @@ static u16 sil_ioread16(struct pci_dev *
 
 static void sil_iowrite8(struct pci_dev *dev, u8 val, unsigned long addr)
 {
-	if (pci_get_drvdata(dev))
+	struct ide_host *host = pci_get_drvdata(dev);
+
+	if (host->host_priv)
 		writeb(val, (void __iomem *)addr);
 	else
 		pci_write_config_byte(dev, addr, val);
@@ -159,7 +163,9 @@ static void sil_iowrite8(struct pci_dev 
 
 static void sil_iowrite16(struct pci_dev *dev, u16 val, unsigned long addr)
 {
-	if (pci_get_drvdata(dev))
+	struct ide_host *host = pci_get_drvdata(dev);
+
+	if (host->host_priv)
 		writew(val, (void __iomem *)addr);
 	else
 		pci_write_config_word(dev, addr, val);
@@ -167,7 +173,9 @@ static void sil_iowrite16(struct pci_dev
 
 static void sil_iowrite32(struct pci_dev *dev, u32 val, unsigned long addr)
 {
-	if (pci_get_drvdata(dev))
+	struct ide_host *host = pci_get_drvdata(dev);
+
+	if (host->host_priv)
 		writel(val, (void __iomem *)addr);
 	else
 		pci_write_config_dword(dev, addr, val);
@@ -445,44 +453,6 @@ static void sil_sata_pre_reset(ide_drive
 }
 
 /**
- *	setup_mmio_siimage	-	switch controller into MMIO mode
- *	@dev: PCI device we are configuring
- *	@name: device name
- *
- *	Attempt to put the device into MMIO mode. There are some slight
- *	complications here with certain systems where the MMIO BAR isn't
- *	mapped, so we have to be sure that we can fall back to I/O.
- */
-
-static unsigned int setup_mmio_siimage(struct pci_dev *dev, const char *name)
-{
-	resource_size_t bar5	= pci_resource_start(dev, 5);
-	unsigned long barsize	= pci_resource_len(dev, 5);
-	void __iomem *ioaddr;
-
-	/*
-	 *	Drop back to PIO if we can't map the MMIO. Some	systems
-	 *	seem to get terminally confused in the PCI spaces.
-	 */
-	if (!request_mem_region(bar5, barsize, name)) {
-		printk(KERN_WARNING "siimage: IDE controller MMIO ports not "
-				    "available.\n");
-		return 0;
-	}
-
-	ioaddr = ioremap(bar5, barsize);
-	if (ioaddr == NULL) {
-		release_mem_region(bar5, barsize);
-		return 0;
-	}
-
-	pci_set_master(dev);
-	pci_set_drvdata(dev, (void *) ioaddr);
-
-	return 1;
-}
-
-/**
  *	init_chipset_siimage	-	set up an SI device
  *	@dev: PCI device
  *	@name: device name
@@ -494,17 +464,15 @@ static unsigned int setup_mmio_siimage(s
 static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev,
 						   const char *name)
 {
+	struct ide_host *host = pci_get_drvdata(dev);
+	void __iomem *ioaddr = host->host_priv;
 	unsigned long base, scsc_addr;
-	void __iomem *ioaddr = NULL;
-	u8 rev = dev->revision, tmp, BA5_EN;
+	u8 rev = dev->revision, tmp;
 
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, rev ? 1 : 255);
 
-	pci_read_config_byte(dev, 0x8A, &BA5_EN);
-
-	if ((BA5_EN & 0x01) || pci_resource_start(dev, 5))
-		if (setup_mmio_siimage(dev, name))
-			ioaddr = pci_get_drvdata(dev);
+	if (ioaddr)
+		pci_set_master(dev);
 
 	base = (unsigned long)ioaddr;
 
@@ -592,7 +560,8 @@ static unsigned int __devinit init_chips
 static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	void *addr		= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	void *addr		= host->host_priv;
 	u8 ch			= hwif->channel;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned long base;
@@ -691,16 +660,15 @@ static void __devinit sil_quirkproc(ide_
 static void __devinit init_iops_siimage(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	struct ide_host *host = pci_get_drvdata(dev);
 
 	hwif->hwif_data = NULL;
 
 	/* Pessimal until we finish probing */
 	hwif->rqsize = 15;
 
-	if (pci_get_drvdata(dev) == NULL)
-		return;
-
-	init_mmio_iops_siimage(hwif);
+	if (host->host_priv)
+		init_mmio_iops_siimage(hwif);
 }
 
 /**
@@ -778,8 +746,13 @@ static const struct ide_port_info siimag
 static int __devinit siimage_init_one(struct pci_dev *dev,
 				      const struct pci_device_id *id)
 {
+	void __iomem *ioaddr = NULL;
+	resource_size_t bar5 = pci_resource_start(dev, 5);
+	unsigned long barsize = pci_resource_len(dev, 5);
+	int rc;
 	struct ide_port_info d;
 	u8 idx = id->driver_data;
+	u8 BA5_EN;
 
 	d = siimage_chipsets[idx];
 
@@ -795,7 +768,36 @@ static int __devinit siimage_init_one(st
 		d.host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 	}
 
-	return ide_pci_init_one(dev, &d, NULL);
+	rc = pci_enable_device(dev);
+	if (rc)
+		return rc;
+
+	pci_read_config_byte(dev, 0x8A, &BA5_EN);
+	if ((BA5_EN & 0x01) || bar5) {
+		/*
+		* Drop back to PIO if we can't map the MMIO. Some systems
+		* seem to get terminally confused in the PCI spaces.
+		*/
+		if (!request_mem_region(bar5, barsize, d.name)) {
+			printk(KERN_WARNING "siimage: IDE controller MMIO "
+					    "ports not available.\n");
+		} else {
+			ioaddr = ioremap(bar5, barsize);
+			if (ioaddr == NULL)
+				release_mem_region(bar5, barsize);
+		}
+	}
+
+	rc = ide_pci_init_one(dev, &d, ioaddr);
+	if (rc) {
+		if (ioaddr) {
+			iounmap(ioaddr);
+			release_mem_region(bar5, barsize);
+		}
+		pci_disable_device(dev);
+	}
+
+	return rc;
 }
 
 static const struct pci_device_id siimage_pci_tbl[] = {

-- 


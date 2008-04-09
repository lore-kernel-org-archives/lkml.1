Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYDISjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYDISjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbYDISig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:38:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:62222 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYDISib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OmUc6VBmtaVl5nfX76U/bIdBt/Ds3I5svziR88S4JVE+bPniQBXlA4qHoR40c3vSyh2J3bFigTpnR9KrQTlquFBN5Y1i/gOy4CiBAkZx0WPEKbYxv6KizOQNvFaY/SdMYu2XkHWNQzA9FtpvD7La6XTC3vlskiEuOUXFjjSUSzc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] siimage: add sil_* I/O ops
Date: Wed, 9 Apr 2008 20:51:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804092051.33163.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sil_iowrite{8,16,32}() and sil_ioread{8,16}() helpers, then use them to
merge code accessing configuration registers through PCI and MMIO together.

[ because of this SATA initialization bits from setup_mmio_siimage() are
  moved to init_chipset_siimage() ]

This also cuts code size a bit:

   text    data     bss     dec     hex filename
   4437     164       0    4601    11f9 drivers/ide/pci/siimage.o.before
   3979     164       0    4143    102f drivers/ide/pci/siimage.o.after

While at it:

* Use I/O ops directly instead of using ->IN{B,W} and ->OUT{B,W}.

* Fixup CodingStyle in setup_mmio_siimage().

* Rename 'tmpbyte' variable to 'tmp' in init_chipset_siimage().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/siimage.c |  303 +++++++++++++++++++++-------------------------
 1 file changed, 142 insertions(+), 161 deletions(-)

Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -2,7 +2,7 @@
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2003		Red Hat <alan@redhat.com>
  * Copyright (C) 2007		MontaVista Software, Inc.
- * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2007-2008	Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
  *
@@ -124,6 +124,54 @@ static inline unsigned long siimage_seld
 	return base;
 }
 
+static u8 sil_ioread8(struct pci_dev *dev, unsigned long addr)
+{
+	u8 tmp = 0;
+
+	if (pci_get_drvdata(dev))
+		tmp = readb((void __iomem *)addr);
+	else
+		pci_read_config_byte(dev, addr, &tmp);
+
+	return tmp;
+}
+
+static u16 sil_ioread16(struct pci_dev *dev, unsigned long addr)
+{
+	u16 tmp = 0;
+
+	if (pci_get_drvdata(dev))
+		tmp = readw((void __iomem *)addr);
+	else
+		pci_read_config_word(dev, addr, &tmp);
+
+	return tmp;
+}
+
+static void sil_iowrite8(struct pci_dev *dev, u8 val, unsigned long addr)
+{
+	if (pci_get_drvdata(dev))
+		writeb(val, (void __iomem *)addr);
+	else
+		pci_write_config_byte(dev, addr, val);
+}
+
+static void sil_iowrite16(struct pci_dev *dev, u16 val, unsigned long addr)
+{
+	if (pci_get_drvdata(dev))
+		writew(val, (void __iomem *)addr);
+	else
+		pci_write_config_word(dev, addr, val);
+}
+
+static void sil_iowrite32(struct pci_dev *dev, u32 val, unsigned long addr)
+{
+	if (pci_get_drvdata(dev))
+		writel(val, (void __iomem *)addr);
+	else
+		pci_write_config_dword(dev, addr, val);
+}
+
 /**
  *	sil_udma_filter		-	compute UDMA mask
  *	@drive: IDE device
@@ -139,12 +187,9 @@ static u8 sil_pata_udma_filter(ide_drive
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long base = (unsigned long) hwif->hwif_data;
-	u8 mask = 0, scsc = 0;
+	u8 mask = 0, scsc;
 
-	if (hwif->mmio)
-		scsc = hwif->INB(base + 0x4A);
-	else
-		pci_read_config_byte(dev, 0x8A, &scsc);
+	scsc = sil_ioread8(dev, base + (hwif->mmio ? 0x4A : 0x8A));
 
 	if ((scsc & 0x30) == 0x10)	/* 133 */
 		mask = ATA_UDMA6;
@@ -179,6 +224,7 @@ static void sil_set_pio_mode(ide_drive_t
 	const u16 data_speed[]	= { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
 
 	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	ide_drive_t *pair	= ide_get_paired_drive(drive);
 	u32 speedt		= 0;
 	u16 speedp		= 0;
@@ -203,36 +249,20 @@ static void sil_set_pio_mode(ide_drive_t
 	speedp = data_speed[pio];
 	speedt = tf_speed[tf_pio];
 
-	if (hwif->mmio) {
-		hwif->OUTW(speedp, addr);
-		hwif->OUTW(speedt, tfaddr);
-		/* Now set up IORDY */
-		if (pio > 2)
-			hwif->OUTW(hwif->INW(tfaddr-2)|0x200, tfaddr-2);
-		else
-			hwif->OUTW(hwif->INW(tfaddr-2)&~0x200, tfaddr-2);
-
-		mode = hwif->INB(base + addr_mask);
-		mode &= ~(unit ? 0x30 : 0x03);
-		mode |= (unit ? 0x10 : 0x01);
-		hwif->OUTB(mode, base + addr_mask);
-	} else {
-		struct pci_dev *dev = to_pci_dev(hwif->dev);
+	sil_iowrite16(dev, speedp, addr);
+	sil_iowrite16(dev, speedt, tfaddr);
 
-		pci_write_config_word(dev, addr, speedp);
-		pci_write_config_word(dev, tfaddr, speedt);
-		pci_read_config_word(dev, tfaddr - 2, &speedp);
-		speedp &= ~0x200;
-		/* Set IORDY for mode 3 or 4 */
-		if (pio > 2)
-			speedp |= 0x200;
-		pci_write_config_word(dev, tfaddr - 2, speedp);
-
-		pci_read_config_byte(dev, addr_mask, &mode);
-		mode &= ~(unit ? 0x30 : 0x03);
-		mode |= (unit ? 0x10 : 0x01);
-		pci_write_config_byte(dev, addr_mask, mode);
-	}
+	/* now set up IORDY */
+	speedp = sil_ioread16(dev, tfaddr - 2);
+	speedp &= ~0x200;
+	if (pio > 2)
+		speedp |= 0x200;
+	sil_iowrite16(dev, speedp, tfaddr - 2);
+
+	mode = sil_ioread8(dev, base + addr_mask);
+	mode &= ~(unit ? 0x30 : 0x03);
+	mode |= (unit ? 0x10 : 0x01);
+	sil_iowrite8(dev, mode, base + addr_mask);
 }
 
 /**
@@ -261,17 +291,10 @@ static void sil_set_dma_mode(ide_drive_t
 	unsigned long ma	= siimage_seldev(drive, 0x08);
 	unsigned long ua	= siimage_seldev(drive, 0x0C);
 
-	if (hwif->mmio) {
-		scsc = hwif->INB(base + 0x4A);
-		mode = hwif->INB(base + addr_mask);
-		multi = hwif->INW(ma);
-		ultra = hwif->INW(ua);
-	} else {
-		pci_read_config_byte(dev, 0x8A, &scsc);
-		pci_read_config_byte(dev, addr_mask, &mode);
-		pci_read_config_word(dev, ma, &multi);
-		pci_read_config_word(dev, ua, &ultra);
-	}
+	scsc = sil_ioread8(dev, base + (hwif->mmio ? 0x4A : 0x8A));
+	mode = sil_ioread8(dev, base + addr_mask);
+	multi = sil_ioread16(dev, ma);
+	ultra = sil_ioread16(dev, ua);
 
 	mode &= ~((unit) ? 0x30 : 0x03);
 	ultra &= ~0x3F;
@@ -289,15 +312,9 @@ static void sil_set_dma_mode(ide_drive_t
 		mode |= (unit ? 0x20 : 0x02);
 	}
 
-	if (hwif->mmio) {
-		hwif->OUTB(mode, base + addr_mask);
-		hwif->OUTW(multi, ma);
-		hwif->OUTW(ultra, ua);
-	} else {
-		pci_write_config_byte(dev, addr_mask, mode);
-		pci_write_config_word(dev, ma, multi);
-		pci_write_config_word(dev, ua, ultra);
-	}
+	sil_iowrite8(dev, mode, base + addr_mask);
+	sil_iowrite16(dev, multi, ma);
+	sil_iowrite16(dev, ultra, ua);
 }
 
 /* returns 1 if dma irq issued, 0 otherwise */
@@ -460,26 +477,21 @@ static unsigned int setup_mmio_siimage (
 {
 	resource_size_t bar5	= pci_resource_start(dev, 5);
 	unsigned long barsize	= pci_resource_len(dev, 5);
-	u8 tmpbyte	= 0;
 	void __iomem *ioaddr;
-	u32 tmp, irq_mask;
 
 	/*
 	 *	Drop back to PIO if we can't map the mmio. Some
 	 *	systems seem to get terminally confused in the PCI
 	 *	spaces.
 	 */
-	 
-	if(!request_mem_region(bar5, barsize, name))
-	{
+	if (!request_mem_region(bar5, barsize, name)) {
 		printk(KERN_WARNING "siimage: IDE controller MMIO ports not available.\n");
 		return 0;
 	}
-		
+
 	ioaddr = ioremap(bar5, barsize);
 
-	if (ioaddr == NULL)
-	{
+	if (ioaddr == NULL) {
 		release_mem_region(bar5, barsize);
 		return 0;
 	}
@@ -487,62 +499,6 @@ static unsigned int setup_mmio_siimage (
 	pci_set_master(dev);
 	pci_set_drvdata(dev, (void *) ioaddr);
 
-	if (pdev_is_sata(dev)) {
-		/* make sure IDE0/1 interrupts are not masked */
-		irq_mask = (1 << 22) | (1 << 23);
-		tmp = readl(ioaddr + 0x48);
-		if (tmp & irq_mask) {
-			tmp &= ~irq_mask;
-			writel(tmp, ioaddr + 0x48);
-			readl(ioaddr + 0x48); /* flush */
-		}
-		writel(0, ioaddr + 0x148);
-		writel(0, ioaddr + 0x1C8);
-	}
-
-	writeb(0, ioaddr + 0xB4);
-	writeb(0, ioaddr + 0xF4);
-	tmpbyte = readb(ioaddr + 0x4A);
-
-	switch(tmpbyte & 0x30) {
-		case 0x00:
-			/* In 100 MHz clocking, try and switch to 133 */
-			writeb(tmpbyte|0x10, ioaddr + 0x4A);
-			break;
-		case 0x10:
-			/* On 133Mhz clocking */
-			break;
-		case 0x20:
-			/* On PCIx2 clocking */
-			break;
-		case 0x30:
-			/* Clocking is disabled */
-			/* 133 clock attempt to force it on */
-			writeb(tmpbyte & ~0x20, ioaddr + 0x4A);
-			break;
-	}
-
-	tmpbyte = readb(ioaddr + 0x4A);
-
-	writeb(      0x72, ioaddr + 0xA1);
-	writew(    0x328A, ioaddr + 0xA2);
-	writel(0x62DD62DD, ioaddr + 0xA4);
-	writel(0x43924392, ioaddr + 0xA8);
-	writel(0x40094009, ioaddr + 0xAC);
-	writeb(      0x72, ioaddr + 0xE1);
-	writew(    0x328A, ioaddr + 0xE2);
-	writel(0x62DD62DD, ioaddr + 0xE4);
-	writel(0x43924392, ioaddr + 0xE8);
-	writel(0x40094009, ioaddr + 0xEC);
-
-	if (pdev_is_sata(dev)) {
-		writel(0xFFFF0000, ioaddr + 0x108);
-		writel(0xFFFF0000, ioaddr + 0x188);
-		writel(0x00680000, ioaddr + 0x148);
-		writel(0x00680000, ioaddr + 0x1C8);
-	}
-
-	proc_reports_siimage(dev, (tmpbyte>>4), name);
 	return 1;
 }
 
@@ -557,50 +513,80 @@ static unsigned int setup_mmio_siimage (
 
 static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev, const char *name)
 {
-	u8 rev = dev->revision, tmpbyte = 0, BA5_EN = 0;
+	unsigned long base, scsc_addr;
+	void __iomem *ioaddr = NULL;
+	u8 rev = dev->revision, tmp = 0, BA5_EN = 0;
 
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, rev ? 1 : 255);
 
 	pci_read_config_byte(dev, 0x8A, &BA5_EN);
-	if ((BA5_EN & 0x01) || (pci_resource_start(dev, 5))) {
-		if (setup_mmio_siimage(dev, name)) {
-			return 0;
+
+	if ((BA5_EN & 0x01) || pci_resource_start(dev, 5)) {
+		if (setup_mmio_siimage(dev, name))
+			ioaddr = pci_get_drvdata(dev);
+	}
+
+	base = (unsigned long)ioaddr;
+
+	if (ioaddr && pdev_is_sata(dev)) {
+		u32 tmp32, irq_mask;
+
+		/* make sure IDE0/1 interrupts are not masked */
+		irq_mask = (1 << 22) | (1 << 23);
+		tmp32 = readl(ioaddr + 0x48);
+		if (tmp32 & irq_mask) {
+			tmp32 &= ~irq_mask;
+			writel(tmp32, ioaddr + 0x48);
+			readl(ioaddr + 0x48); /* flush */
 		}
+		writel(0, ioaddr + 0x148);
+		writel(0, ioaddr + 0x1C8);
+	}
+
+	sil_iowrite8(dev, 0, base ? (base + 0xB4) : 0x80);
+	sil_iowrite8(dev, 0, base ? (base + 0xF4) : 0x84);
+
+	scsc_addr = base ? (base + 0x4A) : 0x8A;
+	tmp = sil_ioread8(dev, scsc_addr);
+
+	switch (tmp & 0x30) {
+	case 0x00:
+		/* On 100MHz clocking, try and switch to 133MHz */
+		sil_iowrite8(dev, tmp | 0x10, scsc_addr);
+		break;
+	case 0x30:
+		/* Clocking is disabled, attempt to force 133MHz clocking. */
+		sil_iowrite8(dev, tmp & ~0x20, scsc_addr);
+	case 0x10:
+		/* On 133Mhz clocking. */
+		break;
+	case 0x20:
+		/* On PCIx2 clocking. */
+		break;
+	}
+
+	tmp = sil_ioread8(dev, scsc_addr);
+
+	sil_iowrite8(dev,        0x72, base + 0xA1);
+	sil_iowrite16(dev,     0x328A, base + 0xA2);
+	sil_iowrite32(dev, 0x62DD62DD, base + 0xA4);
+	sil_iowrite32(dev, 0x43924392, base + 0xA8);
+	sil_iowrite32(dev, 0x40094009, base + 0xAC);
+	sil_iowrite8(dev,        0x72, base ? (base + 0xE1) : 0xB1);
+	sil_iowrite16(dev,     0x328A, base ? (base + 0xE2) : 0xB2);
+	sil_iowrite32(dev, 0x62DD62DD, base ? (base + 0xE4) : 0xB4);
+	sil_iowrite32(dev, 0x43924392, base ? (base + 0xE8) : 0xB8);
+	sil_iowrite32(dev, 0x40094009, base ? (base + 0xEC) : 0xBC);
+
+	if (base && pdev_is_sata(dev)) {
+		writel(0xFFFF0000, ioaddr + 0x108);
+		writel(0xFFFF0000, ioaddr + 0x188);
+		writel(0x00680000, ioaddr + 0x148);
+		writel(0x00680000, ioaddr + 0x1C8);
 	}
 
-	pci_write_config_byte(dev, 0x80, 0x00);
-	pci_write_config_byte(dev, 0x84, 0x00);
-	pci_read_config_byte(dev, 0x8A, &tmpbyte);
-	switch(tmpbyte & 0x30) {
-		case 0x00:
-			/* 133 clock attempt to force it on */
-			pci_write_config_byte(dev, 0x8A, tmpbyte|0x10);
-		case 0x30:
-			/* if clocking is disabled */
-			/* 133 clock attempt to force it on */
-			pci_write_config_byte(dev, 0x8A, tmpbyte & ~0x20);
-		case 0x10:
-			/* 133 already */
-			break;
-		case 0x20:
-			/* BIOS set PCI x2 clocking */
-			break;
-	}
-
-	pci_read_config_byte(dev,   0x8A, &tmpbyte);
-
-	pci_write_config_byte(dev,  0xA1, 0x72);
-	pci_write_config_word(dev,  0xA2, 0x328A);
-	pci_write_config_dword(dev, 0xA4, 0x62DD62DD);
-	pci_write_config_dword(dev, 0xA8, 0x43924392);
-	pci_write_config_dword(dev, 0xAC, 0x40094009);
-	pci_write_config_byte(dev,  0xB1, 0x72);
-	pci_write_config_word(dev,  0xB2, 0x328A);
-	pci_write_config_dword(dev, 0xB4, 0x62DD62DD);
-	pci_write_config_dword(dev, 0xB8, 0x43924392);
-	pci_write_config_dword(dev, 0xBC, 0x40094009);
+	proc_reports_siimage(dev, tmp >> 4, name);
 
-	proc_reports_siimage(dev, (tmpbyte>>4), name);
 	return 0;
 }
 
@@ -752,12 +738,7 @@ static u8 __devinit sil_cable_detect(ide
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long addr = siimage_selreg(hwif, 0);
-	u8 ata66 = 0;
-
-	if (pci_get_drvdata(dev) == NULL)
-		pci_read_config_byte(dev, addr, &ata66);
-	else
-		ata66 = hwif->INB(addr);
+	u8 ata66 = sil_ioread8(dev, addr);
 
 	return (ata66 & 0x01) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253Ab0A3Tui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab0A3Tui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653Ab0A3Tub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:50:31 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50554 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0A3Tu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:50:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YRSGsMRfSe6IRXG6deDKnAYY6oPVn1Z3lLb5Xo8QH23AyibP7V2A0fnCyyTT0dPdTw
         fJbZR3kX52rFnXUVIxjVVzQsaw5eOy3hXFCqNFL7f2ZG1b2vy4KtNqv123VENkoxpLKN
         X4yzSy4g4PP3AEk7qBJLBvegOTCFqkp7MxrJs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 30 Jan 2010 20:50:18 +0100
Message-Id: <20100130195018.30779.97514.sendpatchset@localhost>
In-Reply-To: <20100130194918.30779.25485.sendpatchset@localhost>
References: <20100130194918.30779.25485.sendpatchset@localhost>
Subject: [PATCH 9/9] siimage: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] siimage: convert to ide2libata

While at it:
- fix documentation for sil680_sel[reg,dev]() and sil680_set_[pio,dma]mode()
- constify tables in sil680_set_[pio,dma]mode()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sil680.h |   85 +++++++++++----
 drivers/ide/siimage.c     |  260 +---------------------------------------------
 2 files changed, 78 insertions(+), 267 deletions(-)

Index: b/drivers/ata/pata_sil680.h
===================================================================
--- a/drivers/ata/pata_sil680.h
+++ b/drivers/ata/pata_sil680.h
@@ -3,8 +3,9 @@
  *	@hwif: interface
  *	@r: config offset
  *
- *	Turn a config register offset into the right address in either
- *	PCI space or MMIO space to access the control register in question
+ *	Turn a config register offset into the right address in PCI space
+ *	MMIO space to access the control register in question.
+ *
  *	Thankfully this is a configuration operation so isnt performance
  *	criticial.
  */
@@ -21,9 +22,9 @@ static unsigned long sil680_selreg(struc
  *	@hwif: interface
  *	@r: config offset
  *
- *	Turn a config register offset into the right address in either
- *	PCI space or MMIO space to access the control register in question
- *	including accounting for the unit shift.
+ *	Turn a config register offset into the right address in PCI space
+ *	to access the control register in question including accounting for
+ *	the unit shift.
  */
 
 static unsigned long sil680_seldev(struct ata_port *ap, struct ata_device *adev, int r)
@@ -56,7 +57,7 @@ static int sil680_cable_detect(struct at
 }
 
 /**
- *	sil680_set_piomode	-	set initial PIO mode data
+ *	sil680_set_piomode	-	set PIO mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *
@@ -67,8 +68,8 @@ static int sil680_cable_detect(struct at
 
 static void sil680_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	static u16 speed_p[5] = { 0x328A, 0x2283, 0x1104, 0x10C3, 0x10C1 };
-	static u16 speed_t[5] = { 0x328A, 0x2283, 0x1281, 0x10C3, 0x10C1 };
+	static const u16 speed_p[5] = { 0x328A, 0x2283, 0x1104, 0x10C3, 0x10C1 };
+	static const u16 speed_t[5] = { 0x328A, 0x2283, 0x1281, 0x10C3, 0x10C1 };
 
 	unsigned long tfaddr = sil680_selreg(ap, 0x02);
 	unsigned long addr = sil680_seldev(ap, adev, 0x04);
@@ -103,22 +104,23 @@ static void sil680_set_piomode(struct at
 }
 
 /**
- *	sil680_set_dmamode	-	set initial DMA mode data
+ *	sil680_set_dmamode	-	set DMA mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *
- *	Program the MWDMA/UDMA modes for the sil680 k
- *	chipset. The MWDMA mode values are pulled from a lookup table
+ *	Program the MWDMA/UDMA modes for the sil680 chipset.
+ *
+ *	The MWDMA mode values are pulled from a lookup table
  *	while the chipset uses mode number for UDMA.
  */
 
 static void sil680_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	static u8 ultra_table[2][7] = {
+	static const u8 ultra_table[2][7] = {
 		{ 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01, 0xFF },	/* 100MHz */
 		{ 0x0F, 0x0B, 0x07, 0x05, 0x03, 0x02, 0x01 },	/* 133Mhz */
 	};
-	static u16 dma_table[3] = { 0x2208, 0x10C2, 0x10C1 };
+	static const u16 dma_table[3] = { 0x2208, 0x10C2, 0x10C1 };
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned long ma = sil680_seldev(ap, adev, 0x08);
@@ -139,7 +141,9 @@ static void sil680_set_dmamode(struct at
 
 	/* Extract scsc */
 	scsc = (scsc & 0x30) ? 1 : 0;
-
+#ifdef __IDE2LIBATA
+	scsc = is_sata(ap) ? 1 : scsc;
+#endif
 	if (adev->dma_mode >= XFER_UDMA_0) {
 		multi = 0x10C1;
 		ultra |= ultra_table[scsc][adev->dma_mode - XFER_UDMA_0];
@@ -164,17 +168,42 @@ static void sil680_set_dmamode(struct at
 
 static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
 {
+#ifdef __IDE2LIBATA
+	struct ide_host *host = pci_get_drvdata(pdev);
+	void __iomem *ioaddr = host->host_priv;
+	unsigned long base;
+#endif
 	u8 tmpbyte	= 0;
 
 	/* FIXME: double check */
 	pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE,
 			      pdev->revision ? 1 : 255);
-
+#ifdef __IDE2LIBATA
+	if (ioaddr)
+		pci_set_master(pdev);
+
+	base = (unsigned long)ioaddr;
+
+	if (ioaddr && pdev_is_sata(pdev)) {
+		u32 tmp32, irq_mask;
+
+		/* make sure IDE0/1 interrupts are not masked */
+		irq_mask = (1 << 22) | (1 << 23);
+		tmp32 = readl(ioaddr + 0x48);
+		if (tmp32 & irq_mask) {
+			tmp32 &= ~irq_mask;
+			writel(tmp32, ioaddr + 0x48);
+			readl(ioaddr + 0x48); /* flush */
+		}
+		writel(0, ioaddr + 0x148);
+		writel(0, ioaddr + 0x1C8);
+	}
+#endif
 	pci_write_config_byte(pdev, 0x80, 0x00);
 	pci_write_config_byte(pdev, 0x84, 0x00);
 
 	pci_read_config_byte(pdev, 0x8A, &tmpbyte);
-
+#ifndef __IDE2LIBATA
 	dev_dbg(&pdev->dev, "sil680: BA5_EN = %d clock = %02X\n",
 		tmpbyte & 1, tmpbyte & 0x30);
 
@@ -183,7 +212,7 @@ static u8 sil680_init_chip(struct pci_de
 	if (machine_is(cell))
 		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
 #endif
-
+#endif
 	switch (tmpbyte & 0x30) {
 	case 0x00:
 		/* 133 clock attempt to force it on */
@@ -203,9 +232,10 @@ static u8 sil680_init_chip(struct pci_de
 	}
 
 	pci_read_config_byte(pdev,   0x8A, &tmpbyte);
+#ifndef __IDE2LIBATA
 	dev_dbg(&pdev->dev, "sil680: BA5_EN = %d clock = %02X\n",
 		tmpbyte & 1, tmpbyte & 0x30);
-
+#endif
 	pci_write_config_byte(pdev,  0xA1, 0x72);
 	pci_write_config_word(pdev,  0xA2, 0x328A);
 	pci_write_config_dword(pdev, 0xA4, 0x62DD62DD);
@@ -217,6 +247,7 @@ static u8 sil680_init_chip(struct pci_de
 	pci_write_config_dword(pdev, 0xB8, 0x43924392);
 	pci_write_config_dword(pdev, 0xBC, 0x40094009);
 
+#ifndef __IDE2LIBATA
 	switch (tmpbyte & 0x30) {
 	case 0x00:
 		printk(KERN_INFO "sil680: 100MHz clock.\n");
@@ -231,5 +262,23 @@ static u8 sil680_init_chip(struct pci_de
 	case 0x30:
 		printk(KERN_ERR "sil680: Clock disabled ?\n");
 	}
+#else
+	if (base && pdev_is_sata(pdev)) {
+		writel(0xFFFF0000, ioaddr + 0x108);
+		writel(0xFFFF0000, ioaddr + 0x188);
+		writel(0x00680000, ioaddr + 0x148);
+		writel(0x00680000, ioaddr + 0x1C8);
+	}
+
+	/* report the clocking mode of the controller */
+	if (!pdev_is_sata(pdev)) {
+		static const char *clk_str[]
+			= { "== 100", "== 133", "== 2X PCI", "DISABLED!" };
+
+		tmpbyte >>= 4;
+		printk(KERN_INFO DRV_NAME " %s: BASE CLOCK %s\n",
+			pci_name(pdev), clk_str[tmpbyte & 3]);
+	}
+#endif
 	return tmpbyte & 0x30;
 }
Index: b/drivers/ide/siimage.c
===================================================================
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -79,47 +79,6 @@ static inline int is_sata(ide_hwif_t *hw
 }
 
 /**
- *	siimage_selreg		-	return register base
- *	@hwif: interface
- *	@r: config offset
- *
- *	Turn a config register offset into the right address in PCI space
- *	to access the control register in question.
- *
- *	Thankfully this is a configuration operation, so isn't performance
- *	critical.
- */
-
-static unsigned long siimage_selreg(ide_hwif_t *hwif, int r)
-{
-	unsigned long base = 0xA0 + r;
-
-	base += hwif->channel << 4;
-	return base;
-}
-
-/**
- *	siimage_seldev		-	return register base
- *	@hwif: interface
- *	@r: config offset
- *
- *	Turn a config register offset into the right address in PCI space
- *	to access the control register in question including accounting for
- *	the unit shift.
- */
-
-static inline unsigned long siimage_seldev(ide_drive_t *drive, int r)
-{
-	ide_hwif_t *hwif	= drive->hwif;
-	unsigned long base	= 0xA0 + r;
-	u8 unit			= drive->dn & 1;
-
-	base += hwif->channel << 4;
-	base |= unit << unit;
-	return base;
-}
-
-/**
  *	sil_udma_filter		-	compute UDMA mask
  *	@drive: IDE device
  *
@@ -161,110 +120,8 @@ static u8 sil_sata_udma_filter(ide_drive
 	return strstr(m, "Maxtor") ? ATA_UDMA5 : ATA_UDMA6;
 }
 
-/**
- *	sil_set_pio_mode	-	set host controller for PIO mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Load the timing settings for this device mode into the
- *	controller.
- */
-
-static void sil_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	static const u16 tf_speed[]   = { 0x328a, 0x2283, 0x1281, 0x10c3, 0x10c1 };
-	static const u16 data_speed[] = { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
-
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	ide_drive_t *pair	= ide_get_pair_dev(drive);
-	u32 speedt		= 0;
-	u16 speedp		= 0;
-	unsigned long addr	= siimage_seldev(drive, 0x04);
-	unsigned long tfaddr	= siimage_selreg(hwif,	0x02);
-	const u8 pio		= drive->pio_mode - XFER_PIO_0;
-	u8 tf_pio		= pio;
-	u8 addr_mask		= hwif->channel ? 0x84 : 0x80;
-	u8 mode			= 0;
-	u8 unit			= drive->dn & 1;
-
-	/* trim *taskfile* PIO to the slowest of the master/slave */
-	if (pair) {
-		u8 pair_pio = pair->pio_mode - XFER_PIO_0;
-
-		if (pair_pio < tf_pio)
-			tf_pio = pair_pio;
-	}
-
-	/* cheat for now and use the docs */
-	speedp = data_speed[pio];
-	speedt = tf_speed[tf_pio];
-
-	pci_write_config_word(dev, addr, speedp);
-	pci_write_config_word(dev, tfaddr, speedt);
-
-	/* now set up IORDY */
-	pci_read_config_word(dev, tfaddr - 2, &speedp);
-	speedp &= ~0x200;
-
-	pci_read_config_byte(dev, addr_mask, &mode);
-	mode &= ~(unit ? 0x30 : 0x03);
-
-	if (ide_pio_need_iordy(drive, pio)) {
-		speedp |= 0x200;
-		mode |= unit ? 0x10 : 0x01;
-	}
-
-	pci_write_config_word(dev, tfaddr - 2, speedp);
-	pci_write_config_byte(dev, addr_mask, mode);
-}
-
-/**
- *	sil_set_dma_mode	-	set host controller for DMA mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Tune the SiI chipset for the desired DMA mode.
- */
-
-static void sil_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	static const u8 ultra6[] = { 0x0F, 0x0B, 0x07, 0x05, 0x03, 0x02, 0x01 };
-	static const u8 ultra5[] = { 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01 };
-	static const u16 dma[]	 = { 0x2208, 0x10C2, 0x10C1 };
-
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u16 ultra = 0, multi	= 0;
-	u8 mode = 0, unit	= drive->dn & 1;
-	u8 scsc = 0, addr_mask	= hwif->channel ? 0x84 : 0x80;
-	unsigned long ma	= siimage_seldev(drive, 0x08);
-	unsigned long ua	= siimage_seldev(drive, 0x0C);
-	const u8 speed		= drive->dma_mode;
-
-	pci_read_config_byte(dev, 0x8A, &scsc);
-	pci_read_config_byte(dev, addr_mask, &mode);
-	pci_read_config_word(dev, ma, &multi);
-	pci_read_config_word(dev, ua, &ultra);
-
-	mode  &= ~(unit ? 0x30 : 0x03);
-	ultra &= ~0x3F;
-	scsc = ((scsc & 0x30) == 0x00) ? 0 : 1;
-
-	scsc = is_sata(hwif) ? 1 : scsc;
-
-	if (speed >= XFER_UDMA_0) {
-		multi  = dma[2];
-		ultra |= scsc ? ultra6[speed - XFER_UDMA_0] :
-				ultra5[speed - XFER_UDMA_0];
-		mode  |= unit ? 0x30 : 0x03;
-	} else {
-		multi = dma[speed - XFER_MW_DMA_0];
-		mode |= unit ? 0x20 : 0x02;
-	}
-
-	pci_write_config_byte(dev, addr_mask, mode);
-	pci_write_config_word(dev, ma, multi);
-	pci_write_config_word(dev, ua, ultra);
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_sil680.h"
 
 static int sil_test_irq(ide_hwif_t *hwif)
 {
@@ -277,7 +134,7 @@ static int sil_test_irq(ide_hwif_t *hwif
 		addr += 0xA0 + 1 + (hwif->channel << 6);
 		val = readb((void __iomem *)addr);
 	} else {
-		addr = siimage_selreg(hwif, 1);
+		addr = sil680_selreg(hwif, 1);
 		pci_read_config_byte(dev, addr, &val);
 	}
 
@@ -389,84 +246,7 @@ static void sil_sata_pre_reset(ide_drive
 
 static int init_chipset_siimage(struct pci_dev *dev)
 {
-	struct ide_host *host = pci_get_drvdata(dev);
-	void __iomem *ioaddr = host->host_priv;
-	unsigned long base;
-	u8 rev = dev->revision, tmp;
-
-	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, rev ? 1 : 255);
-
-	if (ioaddr)
-		pci_set_master(dev);
-
-	base = (unsigned long)ioaddr;
-
-	if (ioaddr && pdev_is_sata(dev)) {
-		u32 tmp32, irq_mask;
-
-		/* make sure IDE0/1 interrupts are not masked */
-		irq_mask = (1 << 22) | (1 << 23);
-		tmp32 = readl(ioaddr + 0x48);
-		if (tmp32 & irq_mask) {
-			tmp32 &= ~irq_mask;
-			writel(tmp32, ioaddr + 0x48);
-			readl(ioaddr + 0x48); /* flush */
-		}
-		writel(0, ioaddr + 0x148);
-		writel(0, ioaddr + 0x1C8);
-	}
-
-	pci_write_config_byte(dev, 0x80, 0x00);
-	pci_write_config_byte(dev, 0x84, 0x00);
-
-	pci_read_config_byte(dev, 0x8A, &tmp);
-
-	switch (tmp & 0x30) {
-	case 0x00:
-		/* On 100 MHz clocking, try and switch to 133 MHz */
-		pci_write_config_byte(dev, 0x8A, tmp | 0x10);
-		break;
-	case 0x30:
-		/* Clocking is disabled, attempt to force 133MHz clocking. */
-		pci_write_config_byte(dev, 0x8A, tmp & ~0x20);
-	case 0x10:
-		/* On 133Mhz clocking. */
-		break;
-	case 0x20:
-		/* On PCIx2 clocking. */
-		break;
-	}
-
-	pci_read_config_byte(dev, 0x8A, &tmp);
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
-
-	if (base && pdev_is_sata(dev)) {
-		writel(0xFFFF0000, ioaddr + 0x108);
-		writel(0xFFFF0000, ioaddr + 0x188);
-		writel(0x00680000, ioaddr + 0x148);
-		writel(0x00680000, ioaddr + 0x1C8);
-	}
-
-	/* report the clocking mode of the controller */
-	if (!pdev_is_sata(dev)) {
-		static const char *clk_str[] =
-			{ "== 100", "== 133", "== 2X PCI", "DISABLED!" };
-
-		tmp >>= 4;
-		printk(KERN_INFO DRV_NAME " %s: BASE CLOCK %s\n",
-			pci_name(dev), clk_str[tmp & 3]);
-	}
-
+	(void)sil680_init_chip(dev, NULL);
 	return 0;
 }
 
@@ -596,42 +376,24 @@ static void __devinit init_iops_siimage(
 		init_mmio_iops_siimage(hwif);
 }
 
-/**
- *	sil_cable_detect	-	cable detection
- *	@hwif: interface to check
- *
- *	Check for the presence of an ATA66 capable cable on the interface.
- */
-
-static int sil_cable_detect(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	unsigned long addr	= siimage_selreg(hwif, 0);
-	u8 ata66;
-
-	pci_read_config_byte(dev, addr, &ata66);
-
-	return (ata66 & 0x01) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
-}
-
 static const struct ide_port_ops sil_pata_port_ops = {
-	.set_pio_mode		= sil_set_pio_mode,
-	.set_dma_mode		= sil_set_dma_mode,
+	.set_pio_mode		= sil680_set_piomode,
+	.set_dma_mode		= sil680_set_dmamode,
 	.quirkproc		= sil_quirkproc,
 	.test_irq		= sil_test_irq,
 	.udma_filter		= sil_pata_udma_filter,
-	.cable_detect		= sil_cable_detect,
+	.cable_detect		= sil680_cable_detect,
 };
 
 static const struct ide_port_ops sil_sata_port_ops = {
-	.set_pio_mode		= sil_set_pio_mode,
-	.set_dma_mode		= sil_set_dma_mode,
+	.set_pio_mode		= sil680_set_piomode,
+	.set_dma_mode		= sil680_set_dmamode,
 	.reset_poll		= sil_sata_reset_poll,
 	.pre_reset		= sil_sata_pre_reset,
 	.quirkproc		= sil_quirkproc,
 	.test_irq		= sil_test_irq,
 	.udma_filter		= sil_sata_udma_filter,
-	.cable_detect		= sil_cable_detect,
+	.cable_detect		= sil680_cable_detect,
 };
 
 static const struct ide_dma_ops sil_dma_ops = {
@@ -778,6 +540,6 @@ static void __exit siimage_ide_exit(void
 module_init(siimage_ide_init);
 module_exit(siimage_ide_exit);
 
-MODULE_AUTHOR("Andre Hedrick, Alan Cox");
+MODULE_AUTHOR("Andre Hedrick, Alan Cox, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for SiI IDE");
 MODULE_LICENSE("GPL");

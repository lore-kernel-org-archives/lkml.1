Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424Ab0A3Ttw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0A3Ttw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357Ab0A3Ttt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:49:49 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50554 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0A3Ttq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:49:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=m2dGWvJ4RcaC+EyBK+bnA0brbs9NnkVfBhXaTbbFybN6mJYz67BlJemfKIM5uVt6fa
         /zjQUlmYuEZQEbwv7TwTKB8dmYuc9yBecOUt1IUZCwKEO+d3+z+FaJBZFWlP/8y19ogC
         IcwIFGIWzgygH30PKQvP0FF8+AG8xVImiJL1w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 30 Jan 2010 20:49:38 +0100
Message-Id: <20100130194938.30779.1603.sendpatchset@localhost>
In-Reply-To: <20100130194918.30779.25485.sendpatchset@localhost>
References: <20100130194918.30779.25485.sendpatchset@localhost>
Subject: [PATCH 3/9] siimage: cleanup I/O helpers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] siimage: cleanup I/O helpers

No users of sil_io*()/siimage_sel[reg,dev]() helpers except ->test_irq
method are performance critical so convert ->test_irq to use MMIO space
directly if needed and switch the rest to just use PCI space.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/siimage.c |  178 ++++++++++++++++----------------------------------
 1 file changed, 58 insertions(+), 120 deletions(-)

Index: b/drivers/ide/siimage.c
===================================================================
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -2,7 +2,7 @@
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2003		Red Hat
  * Copyright (C) 2007-2008	MontaVista Software, Inc.
- * Copyright (C) 2007-2008	Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2007-2010	Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
  *
@@ -83,21 +83,18 @@ static inline int is_sata(ide_hwif_t *hw
  *	@hwif: interface
  *	@r: config offset
  *
- *	Turn a config register offset into the right address in either
- *	PCI space or MMIO space to access the control register in question
+ *	Turn a config register offset into the right address in PCI space
+ *	to access the control register in question.
+ *
  *	Thankfully this is a configuration operation, so isn't performance
  *	critical.
  */
 
 static unsigned long siimage_selreg(ide_hwif_t *hwif, int r)
 {
-	unsigned long base = (unsigned long)hwif->hwif_data;
+	unsigned long base = 0xA0 + r;
 
-	base += 0xA0 + r;
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		base += hwif->channel << 6;
-	else
-		base += hwif->channel << 4;
+	base += hwif->channel << 4;
 	return base;
 }
 
@@ -106,82 +103,22 @@ static unsigned long siimage_selreg(ide_
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
 
 static inline unsigned long siimage_seldev(ide_drive_t *drive, int r)
 {
 	ide_hwif_t *hwif	= drive->hwif;
-	unsigned long base	= (unsigned long)hwif->hwif_data;
+	unsigned long base	= 0xA0 + r;
 	u8 unit			= drive->dn & 1;
 
-	base += 0xA0 + r;
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		base += hwif->channel << 6;
-	else
-		base += hwif->channel << 4;
+	base += hwif->channel << 4;
 	base |= unit << unit;
 	return base;
 }
 
-static u8 sil_ioread8(struct pci_dev *dev, unsigned long addr)
-{
-	struct ide_host *host = pci_get_drvdata(dev);
-	u8 tmp = 0;
-
-	if (host->host_priv)
-		tmp = readb((void __iomem *)addr);
-	else
-		pci_read_config_byte(dev, addr, &tmp);
-
-	return tmp;
-}
-
-static u16 sil_ioread16(struct pci_dev *dev, unsigned long addr)
-{
-	struct ide_host *host = pci_get_drvdata(dev);
-	u16 tmp = 0;
-
-	if (host->host_priv)
-		tmp = readw((void __iomem *)addr);
-	else
-		pci_read_config_word(dev, addr, &tmp);
-
-	return tmp;
-}
-
-static void sil_iowrite8(struct pci_dev *dev, u8 val, unsigned long addr)
-{
-	struct ide_host *host = pci_get_drvdata(dev);
-
-	if (host->host_priv)
-		writeb(val, (void __iomem *)addr);
-	else
-		pci_write_config_byte(dev, addr, val);
-}
-
-static void sil_iowrite16(struct pci_dev *dev, u16 val, unsigned long addr)
-{
-	struct ide_host *host = pci_get_drvdata(dev);
-
-	if (host->host_priv)
-		writew(val, (void __iomem *)addr);
-	else
-		pci_write_config_word(dev, addr, val);
-}
-
-static void sil_iowrite32(struct pci_dev *dev, u32 val, unsigned long addr)
-{
-	struct ide_host *host = pci_get_drvdata(dev);
-
-	if (host->host_priv)
-		writel(val, (void __iomem *)addr);
-	else
-		pci_write_config_dword(dev, addr, val);
-}
-
 /**
  *	sil_udma_filter		-	compute UDMA mask
  *	@drive: IDE device
@@ -196,12 +133,9 @@ static u8 sil_pata_udma_filter(ide_drive
 {
 	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u8 scsc, mask		= 0;
 
-	base += (hwif->host_flags & IDE_HFLAG_MMIO) ? 0x4A : 0x8A;
-
-	scsc = sil_ioread8(dev, base);
+	pci_read_config_byte(dev, 0x8A, &scsc);
 
 	switch (scsc & 0x30) {
 	case 0x10:	/* 133 */
@@ -247,12 +181,9 @@ static void sil_set_pio_mode(ide_hwif_t
 	u16 speedp		= 0;
 	unsigned long addr	= siimage_seldev(drive, 0x04);
 	unsigned long tfaddr	= siimage_selreg(hwif,	0x02);
-	unsigned long base	= (unsigned long)hwif->hwif_data;
 	const u8 pio		= drive->pio_mode - XFER_PIO_0;
 	u8 tf_pio		= pio;
-	u8 mmio			= (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 addr_mask		= hwif->channel ? (mmio ? 0xF4 : 0x84)
-						: (mmio ? 0xB4 : 0x80);
+	u8 addr_mask		= hwif->channel ? 0x84 : 0x80;
 	u8 mode			= 0;
 	u8 unit			= drive->dn & 1;
 
@@ -268,14 +199,14 @@ static void sil_set_pio_mode(ide_hwif_t
 	speedp = data_speed[pio];
 	speedt = tf_speed[tf_pio];
 
-	sil_iowrite16(dev, speedp, addr);
-	sil_iowrite16(dev, speedt, tfaddr);
+	pci_write_config_word(dev, addr, speedp);
+	pci_write_config_word(dev, tfaddr, speedt);
 
 	/* now set up IORDY */
-	speedp = sil_ioread16(dev, tfaddr - 2);
+	pci_read_config_word(dev, tfaddr - 2, &speedp);
 	speedp &= ~0x200;
 
-	mode = sil_ioread8(dev, base + addr_mask);
+	pci_read_config_byte(dev, addr_mask, &mode);
 	mode &= ~(unit ? 0x30 : 0x03);
 
 	if (ide_pio_need_iordy(drive, pio)) {
@@ -283,8 +214,8 @@ static void sil_set_pio_mode(ide_hwif_t
 		mode |= unit ? 0x10 : 0x01;
 	}
 
-	sil_iowrite16(dev, speedp, tfaddr - 2);
-	sil_iowrite8(dev, mode, base + addr_mask);
+	pci_write_config_word(dev, tfaddr - 2, speedp);
+	pci_write_config_byte(dev, addr_mask, mode);
 }
 
 /**
@@ -302,20 +233,17 @@ static void sil_set_dma_mode(ide_hwif_t
 	static const u16 dma[]	 = { 0x2208, 0x10C2, 0x10C1 };
 
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u16 ultra = 0, multi	= 0;
 	u8 mode = 0, unit	= drive->dn & 1;
-	u8 mmio			= (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 scsc = 0, addr_mask	= hwif->channel ? (mmio ? 0xF4 : 0x84)
-						: (mmio ? 0xB4 : 0x80);
+	u8 scsc = 0, addr_mask	= hwif->channel ? 0x84 : 0x80;
 	unsigned long ma	= siimage_seldev(drive, 0x08);
 	unsigned long ua	= siimage_seldev(drive, 0x0C);
 	const u8 speed		= drive->dma_mode;
 
-	scsc  = sil_ioread8 (dev, base + (mmio ? 0x4A : 0x8A));
-	mode  = sil_ioread8 (dev, base + addr_mask);
-	multi = sil_ioread16(dev, ma);
-	ultra = sil_ioread16(dev, ua);
+	pci_read_config_byte(dev, 0x8A, &scsc);
+	pci_read_config_byte(dev, addr_mask, &mode);
+	pci_read_config_word(dev, ma, &multi);
+	pci_read_config_word(dev, ua, &ultra);
 
 	mode  &= ~(unit ? 0x30 : 0x03);
 	ultra &= ~0x3F;
@@ -333,16 +261,25 @@ static void sil_set_dma_mode(ide_hwif_t
 		mode |= unit ? 0x20 : 0x02;
 	}
 
-	sil_iowrite8 (dev, mode, base + addr_mask);
-	sil_iowrite16(dev, multi, ma);
-	sil_iowrite16(dev, ultra, ua);
+	pci_write_config_byte(dev, addr_mask, mode);
+	pci_write_config_word(dev, ma, multi);
+	pci_write_config_word(dev, ua, ultra);
 }
 
 static int sil_test_irq(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	unsigned long addr	= siimage_selreg(hwif, 1);
-	u8 val			= sil_ioread8(dev, addr);
+	unsigned long addr;
+	u8 val;
+
+	if (hwif->host->host_priv) {
+		addr = (unsigned long)hwif->hwif_data;
+		addr += 0xA0 + 1 + (hwif->channel << 6);
+		val = readb((void __iomem *)addr);
+	} else {
+		addr = siimage_selreg(hwif, 1);
+		pci_read_config_byte(dev, addr, &val);
+	}
 
 	/* Return 1 if INTRQ asserted */
 	return (val & 8) ? 1 : 0;
@@ -454,7 +391,7 @@ static int init_chipset_siimage(struct p
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	void __iomem *ioaddr = host->host_priv;
-	unsigned long base, scsc_addr;
+	unsigned long base;
 	u8 rev = dev->revision, tmp;
 
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, rev ? 1 : 255);
@@ -479,20 +416,19 @@ static int init_chipset_siimage(struct p
 		writel(0, ioaddr + 0x1C8);
 	}
 
-	sil_iowrite8(dev, 0, base ? (base + 0xB4) : 0x80);
-	sil_iowrite8(dev, 0, base ? (base + 0xF4) : 0x84);
+	pci_write_config_byte(dev, 0x80, 0x00);
+	pci_write_config_byte(dev, 0x84, 0x00);
 
-	scsc_addr = base ? (base + 0x4A) : 0x8A;
-	tmp = sil_ioread8(dev, scsc_addr);
+	pci_read_config_byte(dev, 0x8A, &tmp);
 
 	switch (tmp & 0x30) {
 	case 0x00:
 		/* On 100 MHz clocking, try and switch to 133 MHz */
-		sil_iowrite8(dev, tmp | 0x10, scsc_addr);
+		pci_write_config_byte(dev, 0x8A, tmp | 0x10);
 		break;
 	case 0x30:
 		/* Clocking is disabled, attempt to force 133MHz clocking. */
-		sil_iowrite8(dev, tmp & ~0x20, scsc_addr);
+		pci_write_config_byte(dev, 0x8A, tmp & ~0x20);
 	case 0x10:
 		/* On 133Mhz clocking. */
 		break;
@@ -501,18 +437,18 @@ static int init_chipset_siimage(struct p
 		break;
 	}
 
-	tmp = sil_ioread8(dev, scsc_addr);
+	pci_read_config_byte(dev, 0x8A, &tmp);
 
-	sil_iowrite8 (dev,       0x72, base + 0xA1);
-	sil_iowrite16(dev,     0x328A, base + 0xA2);
-	sil_iowrite32(dev, 0x62DD62DD, base + 0xA4);
-	sil_iowrite32(dev, 0x43924392, base + 0xA8);
-	sil_iowrite32(dev, 0x40094009, base + 0xAC);
-	sil_iowrite8 (dev,       0x72, base ? (base + 0xE1) : 0xB1);
-	sil_iowrite16(dev,     0x328A, base ? (base + 0xE2) : 0xB2);
-	sil_iowrite32(dev, 0x62DD62DD, base ? (base + 0xE4) : 0xB4);
-	sil_iowrite32(dev, 0x43924392, base ? (base + 0xE8) : 0xB8);
-	sil_iowrite32(dev, 0x40094009, base ? (base + 0xEC) : 0xBC);
+	pci_write_config_byte(dev,  0xA1, 0x72);
+	pci_write_config_word(dev,  0xA2, 0x328A);
+	pci_write_config_dword(dev, 0xA4, 0x62DD62DD);
+	pci_write_config_dword(dev, 0xA8, 0x43924392);
+	pci_write_config_dword(dev, 0xAC, 0x40094009);
+	pci_write_config_byte(dev,  0xB1, 0x72);
+	pci_write_config_word(dev,  0xB2, 0x328A);
+	pci_write_config_dword(dev, 0xB4, 0x62DD62DD);
+	pci_write_config_dword(dev, 0xB8, 0x43924392);
+	pci_write_config_dword(dev, 0xBC, 0x40094009);
 
 	if (base && pdev_is_sata(dev)) {
 		writel(0xFFFF0000, ioaddr + 0x108);
@@ -671,7 +607,9 @@ static int sil_cable_detect(ide_hwif_t *
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	unsigned long addr	= siimage_selreg(hwif, 0);
-	u8 ata66		= sil_ioread8(dev, addr);
+	u8 ata66;
+
+	pci_read_config_byte(dev, addr, &ata66);
 
 	return (ata66 & 0x01) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }

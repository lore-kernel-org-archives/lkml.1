Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451Ab0A2QOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0A2QOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380Ab0A2QOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:14:42 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0A2QIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:08:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=TjRtP1nCUdB5Es612WVqunwTptptUSOnelEbPZEMxuYSpH6ZpxxNwJdZUsQBo6tO6W
         MWDhHLOKhsl5ea9SMX2Dl6LBT8TWf5MKcsu20IDe+O+0n+7Spw3qLCBx0xBGOnh4cbFC
         wBEr9Wh9tYvhtO6Jt1JZTHsgqAsDwgigU36Dg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:07:56 +0100
Message-Id: <20100129160756.21495.80648.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 45/68] cs5530: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cs5530: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5530.h |   16 ++--
 drivers/ide/cs5530.c      |  149 ++++------------------------------------------
 2 files changed, 25 insertions(+), 140 deletions(-)

Index: b/drivers/ata/pata_cs5530.h
===================================================================
--- a/drivers/ata/pata_cs5530.h
+++ b/drivers/ata/pata_cs5530.h
@@ -1,4 +1,9 @@
 
+static const unsigned int cs5530_pio_timings[2][5] = {
+	{0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010},
+	{0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010}
+};
+
 /**
  *	cs5530_set_piomode		-	PIO setup
  *	@ap: ATA interface
@@ -10,10 +15,6 @@
 
 static void cs5530_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	static const unsigned int cs5530_pio_timings[2][5] = {
-		{0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010},
-		{0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010}
-	};
 	void __iomem *base = cs5530_port_base(ap);
 	u32 tuning;
 	int format;
@@ -44,8 +45,9 @@ static void cs5530_set_dmamode(struct at
 {
 	void __iomem *base = cs5530_port_base(ap);
 	u32 tuning, timing = 0;
+#ifndef __IDE2LIBATA
 	u8 reg;
-
+#endif
 	/* Find out which table to use */
 	tuning = ioread32(base + 0x04);
 
@@ -77,15 +79,15 @@ static void cs5530_set_dmamode(struct at
 		iowrite32(tuning, base + 0x04);
 		iowrite32(timing, base + 0x0C);
 	}
-
+#ifndef __IDE2LIBATA
 	/* Set the DMA capable bit in the BMDMA area */
 	reg = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 	reg |= (1 << (5 + adev->devno));
 	iowrite8(reg, ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 
 	/* Remember the last DMA setup we did */
-
 	ap->private_data = adev;
+#endif
 }
 
 
Index: b/drivers/ide/cs5530.c
===================================================================
--- a/drivers/ide/cs5530.c
+++ b/drivers/ide/cs5530.c
@@ -23,15 +23,19 @@
 
 #define DRV_NAME "cs5530"
 
-/*
- * Here are the standard PIO mode 0-4 timings for each "format".
- * Format-0 uses fast data reg timings, with slower command reg timings.
- * Format-1 uses fast timings for all registers, but won't work with all drives.
- */
-static unsigned int cs5530_pio_timings[2][5] = {
-	{0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010},
-	{0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010}
-};
+static void __iomem *cs5530_port_base(ide_hwif_t *hwif)
+{
+	unsigned long bmdma = hwif->dma_base;
+
+	return (void __iomem *)((bmdma & ~0x0F) + 0x20 + 0x10 * hwif->port_no);
+}
+
+#include <linux/ide2libata.h>
+#define ioread32(p)		inl((unsigned long)p)
+#define iowrite32(v, p)		outl(v, (unsigned long)p)
+#include "../ata/pata_cs5530.h"
+#undef iowrite32
+#undef ioread32
 
 /*
  * After chip reset, the PIO timings are set to 0x0000e132, which is not valid.
@@ -40,26 +44,6 @@ static unsigned int cs5530_pio_timings[2
 #define CS5530_BASEREG(hwif)	(((hwif)->dma_base & ~0xf) + ((hwif)->channel ? 0x30 : 0x20))
 
 /**
- *	cs5530_set_pio_mode	-	set host controller for PIO mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Handles setting of PIO mode for the chipset.
- *
- *	The init_hwif_cs5530() routine guarantees that all drives
- *	will have valid default PIO timings set up before we get here.
- */
-
-static void cs5530_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	unsigned long basereg = CS5530_BASEREG(hwif);
-	unsigned int format = (inl(basereg + 4) >> 31) & 1;
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-
-	outl(cs5530_pio_timings[format][pio], basereg + ((drive->dn & 1)<<3));
-}
-
-/**
  *	cs5530_udma_filter	-	UDMA filter
  *	@drive: drive
  *
@@ -100,34 +84,6 @@ out:
 	return mask;
 }
 
-static void cs5530_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	unsigned long basereg;
-	unsigned int reg, timings = 0;
-
-	switch (drive->dma_mode) {
-		case XFER_UDMA_0:	timings = 0x00921250; break;
-		case XFER_UDMA_1:	timings = 0x00911140; break;
-		case XFER_UDMA_2:	timings = 0x00911030; break;
-		case XFER_MW_DMA_0:	timings = 0x00077771; break;
-		case XFER_MW_DMA_1:	timings = 0x00012121; break;
-		case XFER_MW_DMA_2:	timings = 0x00002020; break;
-	}
-	basereg = CS5530_BASEREG(hwif);
-	reg = inl(basereg + 4);			/* get drive0 config register */
-	timings |= reg & 0x80000000;		/* preserve PIO format bit */
-	if ((drive-> dn & 1) == 0) {		/* are we configuring drive0? */
-		outl(timings, basereg + 4);	/* write drive0 config register */
-	} else {
-		if (timings & 0x00100000)
-			reg |=  0x00100000;	/* enable UDMA timings for both drives */
-		else
-			reg &= ~0x00100000;	/* disable UDMA timings for both drives */
-		outl(reg, basereg + 4);		/* write drive0 config register */
-		outl(timings, basereg + 12);	/* write drive1 config register */
-	}
-}
-
 /**
  *	init_chipset_5530	-	set up 5530 bridge
  *	@dev: PCI device
@@ -137,84 +93,11 @@ static void cs5530_set_dma_mode(ide_hwif
 
 static int init_chipset_cs5530(struct pci_dev *dev)
 {
-	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL;
-
 	if (pci_resource_start(dev, 4) == 0)
 		return -EFAULT;
 
-	dev = NULL;
-	while ((dev = pci_get_device(PCI_VENDOR_ID_CYRIX, PCI_ANY_ID, dev)) != NULL) {
-		switch (dev->device) {
-			case PCI_DEVICE_ID_CYRIX_PCI_MASTER:
-				master_0 = pci_dev_get(dev);
-				break;
-			case PCI_DEVICE_ID_CYRIX_5530_LEGACY:
-				cs5530_0 = pci_dev_get(dev);
-				break;
-		}
-	}
-	if (!master_0) {
-		printk(KERN_ERR DRV_NAME ": unable to locate PCI MASTER function\n");
-		goto out;
-	}
-	if (!cs5530_0) {
-		printk(KERN_ERR DRV_NAME ": unable to locate CS5530 LEGACY function\n");
-		goto out;
-	}
-
-	/*
-	 * Enable BusMaster and MemoryWriteAndInvalidate for the cs5530:
-	 * -->  OR 0x14 into 16-bit PCI COMMAND reg of function 0 of the cs5530
-	 */
-
-	pci_set_master(cs5530_0);
-	pci_try_set_mwi(cs5530_0);
-
-	/*
-	 * Set PCI CacheLineSize to 16-bytes:
-	 * --> Write 0x04 into 8-bit PCI CACHELINESIZE reg of function 0 of the cs5530
-	 */
-
-	pci_write_config_byte(cs5530_0, PCI_CACHE_LINE_SIZE, 0x04);
-
-	/*
-	 * Disable trapping of UDMA register accesses (Win98 hack):
-	 * --> Write 0x5006 into 16-bit reg at offset 0xd0 of function 0 of the cs5530
-	 */
-
-	pci_write_config_word(cs5530_0, 0xd0, 0x5006);
-
-	/*
-	 * Bit-1 at 0x40 enables MemoryWriteAndInvalidate on internal X-bus:
-	 * The other settings are what is necessary to get the register
-	 * into a sane state for IDE DMA operation.
-	 */
-
-	pci_write_config_byte(master_0, 0x40, 0x1e);
-
-	/* 
-	 * Set max PCI burst size (16-bytes seems to work best):
-	 *	   16bytes: set bit-1 at 0x41 (reg value of 0x16)
-	 *	all others: clear bit-1 at 0x41, and do:
-	 *	  128bytes: OR 0x00 at 0x41
-	 *	  256bytes: OR 0x04 at 0x41
-	 *	  512bytes: OR 0x08 at 0x41
-	 *	 1024bytes: OR 0x0c at 0x41
-	 */
-
-	pci_write_config_byte(master_0, 0x41, 0x14);
-
-	/*
-	 * These settings are necessary to get the chip
-	 * into a sane state for IDE DMA operation.
-	 */
+	(void)cs5530_init_chip(&dev->dev);
 
-	pci_write_config_byte(master_0, 0x42, 0x00);
-	pci_write_config_byte(master_0, 0x43, 0xc1);
-
-out:
-	pci_dev_put(master_0);
-	pci_dev_put(cs5530_0);
 	return 0;
 }
 
@@ -240,8 +123,8 @@ static void __devinit init_hwif_cs5530 (
 }
 
 static const struct ide_port_ops cs5530_port_ops = {
-	.set_pio_mode		= cs5530_set_pio_mode,
-	.set_dma_mode		= cs5530_set_dma_mode,
+	.set_pio_mode		= cs5530_set_piomode,
+	.set_dma_mode		= cs5530_set_dmamode,
 	.udma_filter		= cs5530_udma_filter,
 };
 

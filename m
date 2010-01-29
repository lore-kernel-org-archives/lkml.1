Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808Ab0A2QGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0A2QGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502Ab0A2QGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:06:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:12863 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab0A2QGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:06:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tI0EQeyRnWCINkRBDihS8jzJkIYbeXDR4uivpI+VNsZskJs1hc31i7wW06gj5KzZAA
         JrPpLE+Q029Q4a5kYsfYp4GSliWT2Ys6NJn28eATbJxO8i1zvgzB2A7xv65c40r5OnPu
         bPgT+KI08E6DAFK/p2sQpkfuGrFxUzId3gBrY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:06:34 +0100
Message-Id: <20100129160634.21495.70896.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 32/68] alim15x3: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] alim15x3: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_ali.h |   55 +++++++++-
 drivers/ide/alim15x3.c |  260 ++-----------------------------------------------
 2 files changed, 61 insertions(+), 254 deletions(-)

Index: b/drivers/ata/pata_ali.h
===================================================================
--- a/drivers/ata/pata_ali.h
+++ b/drivers/ata/pata_ali.h
@@ -39,7 +39,6 @@ static int ali_cable_override(struct pci
 	return 0;
 }
 
-#ifdef __LINUX_LIBATA_H__
 /**
  *	ali_c2_cable_detect	-	cable detection
  *	@ap: ATA port
@@ -148,7 +147,12 @@ static void ali_set_piomode(struct ata_p
 {
 	struct ata_device *pair = ata_dev_pair(adev);
 	struct ata_timing t;
+#ifndef __IDE2LIBATA
 	unsigned long T =  1000000000 / 33333;	/* PCI clock based */
+#else
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
+	unsigned long T =  1000000 / bus_speed; /* PCI clock based */
+#endif
 
 	ata_timing_compute(adev->id, adev->pio_mode, adev->pio_mode, &t, T, 1);
 	if (pair) {
@@ -183,12 +187,18 @@ static void ali_set_dmamode(struct ata_p
 	static u8 udma_timing[7] = { 0xC, 0xB, 0xA, 0x9, 0x8, 0xF, 0xD };
 	struct ata_device *pair = ata_dev_pair(adev);
 	struct ata_timing t;
+#ifndef __IDE2LIBATA
 	unsigned long T =  1000000000 / 33333;	/* PCI clock based */
+#else
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
+	unsigned long T =  1000000 / bus_speed; /* PCI clock based */
+#endif
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
-
+#ifndef __IDE2LIBATA
 	if (adev->class == ATA_DEV_ATA)
 		ali_fifo_control(ap, adev, 0x08);
+#endif
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
 		ali_program_modes(ap, adev, NULL, udma_timing[adev->dma_mode - XFER_UDMA_0]);
@@ -230,39 +240,73 @@ static int ali_init_chipset(struct devic
 	struct pci_dev *pdev = to_pci_dev(dev);
 	u8 tmp;
 	struct pci_dev *north;
-
+#ifdef __IDE2LIBATA
+	struct pci_dev *ali_isa_bridge = isa_dev;
+#endif
 	/*
 	 * The chipset revision selects the driver operations and
 	 * mode data.
 	 */
 
 	if (pdev->revision <= 0x20) {
+#ifdef __IDE2LIBATA
+		pci_read_config_byte(pdev, 0x4b, &tmp);
+		pci_write_config_byte(pdev, 0x4b, tmp & 0x7F);
+		if (pdev->revision == 0x20) {
+			pci_read_config_byte(pdev, 0x53, &tmp);
+			tmp = (tmp & ~0x02) | 0x01;
+			pci_write_config_byte(pdev, 0x53, tmp);
+			if (isa_dev) {
+				pci_read_config_byte(isa_dev, 0x5e, &tmp);
+				chip_is_1543c_e = ((tmp & 0x1e) == 0x12) ? 1 : 0;
+			}
+		}
+#else
 		pci_read_config_byte(pdev, 0x53, &tmp);
 		tmp |= 0x03;
 		pci_write_config_byte(pdev, 0x53, tmp);
+#endif
 	} else {
+#ifndef __IDE2LIBATA
 		pci_read_config_byte(pdev, 0x4a, &tmp);
 		pci_write_config_byte(pdev, 0x4a, tmp | 0x20);
+#endif
 		pci_read_config_byte(pdev, 0x4B, &tmp);
 		if (pdev->revision < 0xC2)
 			/* 1543-E/F, 1543C-C, 1543C-D, 1543C-E */
 			/* Clear CD-ROM DMA write bit */
 			tmp &= 0x7F;
 		/* Cable and UDMA */
+#ifdef __IDE2LIBATA
+		if (pdev->revision >= 0xc2)
+			tmp |= 0x08;
+#else
 		if (pdev->revision >= 0xc2)
 			tmp |= 0x01;
-		pci_write_config_byte(pdev, 0x4B, tmp | 0x08);
+		tmp |= 0x08;
+#endif
+		pci_write_config_byte(pdev, 0x4B, tmp);
 		/*
 		 * CD_ROM DMA on (0x53 bit 0). Enable this even if we want
 		 * to use PIO. 0x53 bit 1 (rev 20 only) - enable FIFO control
 		 * via 0x54/55.
 		 */
 		pci_read_config_byte(pdev, 0x53, &tmp);
+#ifdef __IDE2LIBATA
+		if (pdev->revision == 0xc7 || pdev->revision == 0xc8)
+#else
 		if (pdev->revision >= 0xc7)
+#endif
 			tmp |= 0x03;
 		else
 			tmp |= 0x01;	/* CD_ROM enable for DMA */
 		pci_write_config_byte(pdev, 0x53, tmp);
+#ifdef __IDE2LIBATA
+		if (pdev->revision < 0xC2 && isa_dev) {
+			pci_read_config_byte(isa_dev, 0x5e, &tmp);
+			chip_is_1543c_e = ((tmp & 0x1e) == 0x12) ? 1 : 0;
+		}
+#endif
 	}
 	north = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
 	if (north && north->vendor == PCI_VENDOR_ID_AL && ali_isa_bridge) {
@@ -275,7 +319,8 @@ static int ali_init_chipset(struct devic
 			pci_write_config_byte(ali_isa_bridge, 0x79, tmp | 0x02);
 	}
 	pci_dev_put(north);
+#ifndef __IDE2LIBATA
 	ata_pci_bmdma_clear_simplex(pdev);
+#endif
 	return 0;
 }
-#endif
Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -47,89 +47,6 @@ static u8 m5229_revision;
 static u8 chip_is_1543c_e;
 static struct pci_dev *isa_dev;
 
-static void ali_fifo_control(ide_hwif_t *hwif, ide_drive_t *drive, int on)
-{
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	int pio_fifo = 0x54 + hwif->channel;
-	u8 fifo;
-	int shift = 4 * (drive->dn & 1);
-
-	pci_read_config_byte(pdev, pio_fifo, &fifo);
-	fifo &= ~(0x0F << shift);
-	fifo |= (on << shift);
-	pci_write_config_byte(pdev, pio_fifo, fifo);
-}
-
-static void ali_program_timings(ide_hwif_t *hwif, ide_drive_t *drive,
-				struct ata_timing *t, u8 ultra)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	int port = hwif->channel ? 0x5c : 0x58;
-	int udmat = 0x56 + hwif->channel;
-	u8 unit = drive->dn & 1, udma;
-	int shift = 4 * unit;
-
-	/* Set up the UDMA */
-	pci_read_config_byte(dev, udmat, &udma);
-	udma &= ~(0x0F << shift);
-	udma |= ultra << shift;
-	pci_write_config_byte(dev, udmat, udma);
-
-	if (t == NULL)
-		return;
-
-	t->setup = clamp_val(t->setup, 1, 8) & 7;
-	t->act8b = clamp_val(t->act8b, 1, 8) & 7;
-	t->rec8b = clamp_val(t->rec8b, 1, 16) & 15;
-	t->active = clamp_val(t->active, 1, 8) & 7;
-	t->recover = clamp_val(t->recover, 1, 16) & 15;
-
-	pci_write_config_byte(dev, port, t->setup);
-	pci_write_config_byte(dev, port + 1, (t->act8b << 4) | t->rec8b);
-	pci_write_config_byte(dev, port + unit + 2,
-			      (t->active << 4) | t->recover);
-}
-
-/**
- *	ali_set_pio_mode	-	set host controller for PIO mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Program the controller for the given PIO mode.
- */
-
-static void ali_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	ide_drive_t *pair = ide_get_pair_dev(drive);
-	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
-	unsigned long T =  1000000 / bus_speed; /* PCI clock based */
-	struct ata_timing t;
-
-	ata_timing_compute(drive->id, drive->pio_mode, drive->pio_mode,
-			&t, T, 1);
-	if (pair) {
-		struct ata_timing p;
-
-		ata_timing_compute(pair->id, pair->pio_mode, pair->pio_mode,
-				&p, T, 1);
-		ata_timing_merge(&p, &t, &t,
-			ATA_TIMING_SETUP | ATA_TIMING_8BIT);
-		if (pair->dma_mode) {
-			ata_timing_compute(pair->id, pair->dma_mode,
-					pair->pio_mode, &p, T, 1);
-			ata_timing_merge(&p, &t, &t,
-				ATA_TIMING_SETUP | ATA_TIMING_8BIT);
-		}
-	}
-
-	/* 
-	 * PIO mode => ATA FIFO on, ATAPI FIFO off
-	 */
-	ali_fifo_control(hwif, drive, (drive->media == ide_disk) ? 0x05 : 0x00);
-
-	ali_program_timings(hwif, drive, &t, 0);
-}
-
 /**
  *	ali_udma_filter		-	compute UDMA mask
  *	@drive: IDE device
@@ -156,54 +73,6 @@ static u8 ali_udma_filter(ide_drive_t *d
 }
 
 /**
- *	ali_set_dma_mode	-	set host controller for DMA mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Configure the hardware for the desired IDE transfer mode.
- */
-
-static void ali_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	static u8 udma_timing[7] = { 0xC, 0xB, 0xA, 0x9, 0x8, 0xF, 0xD };
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	ide_drive_t *pair	= ide_get_pair_dev(drive);
-	int bus_speed		= ide_pci_clk ? ide_pci_clk : 33;
-	unsigned long T		=  1000000 / bus_speed; /* PCI clock based */
-	const u8 speed		= drive->dma_mode;
-	u8 tmpbyte		= 0x00;
-	struct ata_timing t;
-
-	if (speed < XFER_UDMA_0) {
-		ata_timing_compute(drive->id, drive->dma_mode, drive->pio_mode,
-				&t, T, 1);
-		if (pair) {
-			struct ata_timing p;
-
-			ata_timing_compute(pair->id, pair->pio_mode,
-					pair->pio_mode, &p, T, 1);
-			ata_timing_merge(&p, &t, &t,
-				ATA_TIMING_SETUP | ATA_TIMING_8BIT);
-			if (pair->dma_mode) {
-				ata_timing_compute(pair->id, pair->dma_mode,
-						pair->pio_mode, &p, T, 1);
-				ata_timing_merge(&p, &t, &t,
-					ATA_TIMING_SETUP | ATA_TIMING_8BIT);
-			}
-		}
-		ali_program_timings(hwif, drive, &t, 0);
-	} else {
-		ali_program_timings(hwif, drive, NULL,
-				udma_timing[speed - XFER_UDMA_0]);
-		if (speed >= XFER_UDMA_3) {
-			pci_read_config_byte(dev, 0x4b, &tmpbyte);
-			tmpbyte |= 1;
-			pci_write_config_byte(dev, 0x4b, tmpbyte);
-		}
-	}
-}
-
-/**
  *	ali_dma_check	-	DMA check
  *	@drive:	target device
  *	@cmd: command
@@ -220,6 +89,9 @@ static int ali_dma_check(ide_drive_t *dr
 	return 0;
 }
 
+#include <linux/ide2libata.h>
+#include "../ata/pata_ali.h"
+
 /**
  *	init_chipset_ali15x3	-	Initialise an ALi IDE controller
  *	@dev: PCI device
@@ -231,110 +103,20 @@ static int ali_dma_check(ide_drive_t *dr
 static int init_chipset_ali15x3(struct pci_dev *dev)
 {
 	unsigned long flags;
-	u8 tmpbyte;
-	struct pci_dev *north = pci_get_slot(dev->bus, PCI_DEVFN(0,0));
 
 	m5229_revision = dev->revision;
 
 	isa_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 
 	local_irq_save(flags);
+	ali_init_chipset(&dev->dev);
+	local_irq_restore(flags);
 
-	if (m5229_revision < 0xC2) {
-		/*
-		 * revision 0x20 (1543-E, 1543-F)
-		 * revision 0xC0, 0xC1 (1543C-C, 1543C-D, 1543C-E)
-		 * clear CD-ROM DMA write bit, m5229, 0x4b, bit 7
-		 */
-		pci_read_config_byte(dev, 0x4b, &tmpbyte);
-		/*
-		 * clear bit 7
-		 */
-		pci_write_config_byte(dev, 0x4b, tmpbyte & 0x7F);
-		/*
-		 * check m1533, 0x5e, bit 1~4 == 1001 => & 00011110 = 00010010
-		 */
-		if (m5229_revision >= 0x20 && isa_dev) {
-			pci_read_config_byte(isa_dev, 0x5e, &tmpbyte);
-			chip_is_1543c_e = ((tmpbyte & 0x1e) == 0x12) ? 1: 0;
-		}
-		goto out;
-	}
-
-	/*
-	 * 1543C-B?, 1535, 1535D, 1553
-	 * Note 1: not all "motherboard" support this detection
-	 * Note 2: if no udma 66 device, the detection may "error".
-	 *         but in this case, we will not set the device to
-	 *         ultra 66, the detection result is not important
-	 */
-
-	/*
-	 * enable "Cable Detection", m5229, 0x4b, bit3
-	 */
-	pci_read_config_byte(dev, 0x4b, &tmpbyte);
-	pci_write_config_byte(dev, 0x4b, tmpbyte | 0x08);
-
-	/*
-	 * We should only tune the 1533 enable if we are using an ALi
-	 * North bridge. We might have no north found on some zany
-	 * box without a device at 0:0.0. The ALi bridge will be at
-	 * 0:0.0 so if we didn't find one we know what is cooking.
-	 */
-	if (north && north->vendor != PCI_VENDOR_ID_AL)
-		goto out;
-
-	if (m5229_revision < 0xC5 && isa_dev)
-	{	
-		/*
-		 * set south-bridge's enable bit, m1533, 0x79
-		 */
-
-		pci_read_config_byte(isa_dev, 0x79, &tmpbyte);
-		if (m5229_revision == 0xC2) {
-			/*
-			 * 1543C-B0 (m1533, 0x79, bit 2)
-			 */
-			pci_write_config_byte(isa_dev, 0x79, tmpbyte | 0x04);
-		} else if (m5229_revision >= 0xC3) {
-			/*
-			 * 1553/1535 (m1533, 0x79, bit 1)
-			 */
-			pci_write_config_byte(isa_dev, 0x79, tmpbyte | 0x02);
-		}
-	}
-
-out:
-	/*
-	 * CD_ROM DMA on (m5229, 0x53, bit0)
-	 *      Enable this bit even if we want to use PIO.
-	 * PIO FIFO off (m5229, 0x53, bit1)
-	 *      The hardware will use 0x54h and 0x55h to control PIO FIFO.
-	 *	(Not on later devices it seems)
-	 *
-	 *	0x53 changes meaning on later revs - we must no touch
-	 *	bit 1 on them.  Need to check if 0x20 is the right break.
-	 */
-	if (m5229_revision >= 0x20) {
-		pci_read_config_byte(dev, 0x53, &tmpbyte);
-
-		if (m5229_revision <= 0x20)
-			tmpbyte = (tmpbyte & (~0x02)) | 0x01;
-		else if (m5229_revision == 0xc7 || m5229_revision == 0xc8)
-			tmpbyte |= 0x03;
-		else
-			tmpbyte |= 0x01;
-
-		pci_write_config_byte(dev, 0x53, tmpbyte);
-	}
-	pci_dev_put(north);
 	pci_dev_put(isa_dev);
-	local_irq_restore(flags);
+
 	return 0;
 }
 
-#include "../ata/pata_ali.h"
-
 /**
  *	ali_cable_detect	-	cable detection
  *	@hwif: IDE interface
@@ -345,29 +127,9 @@ out:
 
 static int ali_cable_detect(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 cbl = ATA_CBL_PATA40, tmpbyte;
-
-	if (m5229_revision >= 0xC2) {
-		/*
-		 * m5229 80-pin cable detection (from Host View)
-		 *
-		 * 0x4a bit0 is 0 => primary channel has 80-pin
-		 * 0x4a bit1 is 0 => secondary channel has 80-pin
-		 *
-		 * Certain laptops use short but suitable cables
-		 * and don't implement the detect logic.
-		 */
-		if (ali_cable_override(dev))
-			cbl = ATA_CBL_PATA40_SHORT;
-		else {
-			pci_read_config_byte(dev, 0x4a, &tmpbyte);
-			if ((tmpbyte & (1 << hwif->channel)) == 0)
-				cbl = ATA_CBL_PATA80;
-		}
-	}
-
-	return cbl;
+	if (m5229_revision >= 0xC2)
+		return ali_c2_cable_detect(hwif);
+	return ATA_CBL_PATA40;
 }
 
 #ifndef CONFIG_SPARC64
@@ -459,8 +221,8 @@ static int __devinit init_dma_ali15x3(id
 }
 
 static const struct ide_port_ops ali_port_ops = {
-	.set_pio_mode		= ali_set_pio_mode,
-	.set_dma_mode		= ali_set_dma_mode,
+	.set_pio_mode		= ali_set_piomode,
+	.set_dma_mode		= ali_set_dmamode,
 	.udma_filter		= ali_udma_filter,
 	.cable_detect		= ali_cable_detect,
 };

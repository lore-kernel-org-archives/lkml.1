Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815Ab0A2QNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0A2QNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852Ab0A2QNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:13:04 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab0A2QJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:09:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gAPZesyodBZ1OlFEUI7vy52pZsiu3eOiSpi8xYi+dSY1URXuS+N5xBQR8KuyJs56rg
         trOJz7tdKeu+AbS/4WjJc698VeQDz9j2M8QqZb8m8yOJnqbmQALPXOsyzL/fi5Sxa355
         GEvyjT0G/6gvRr9VUmz8y9631akPRhEL7508U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:09:02 +0100
Message-Id: <20100129160902.21495.27731.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 55/68] it821x: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] it821x: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it821x.h |   21 ++
 drivers/ide/it821x.c      |  373 ----------------------------------------------
 2 files changed, 28 insertions(+), 366 deletions(-)

Index: b/drivers/ata/pata_it821x.h
===================================================================
--- a/drivers/ata/pata_it821x.h
+++ b/drivers/ata/pata_it821x.h
@@ -55,7 +55,11 @@ struct it821x_dev {
 	u16	pio[2];			/* Cached PIO values */
 	u16	mwdma[2];		/* Cached MWDMA values */
 	u16	udma[2];		/* Cached UDMA values (per drive) */
+#ifndef __IDE2LIBATA
 	u16	last_device;		/* Master or slave loaded ? */
+#else
+	u16	quirks;
+#endif
 };
 
 #define ATA_66		0
@@ -223,7 +227,21 @@ static void it821x_passthru_set_piomode(
 	struct it821x_dev *itdev = ap->private_data;
 	int unit = adev->devno;
 	int mode_wanted = adev->pio_mode - XFER_PIO_0;
+#ifdef __IDE2LIBATA
+	struct ata_device *pair = ata_dev_pair(adev);
 
+	/*
+	 * Compute the best PIO mode we can for a given device. We must
+	 * pick a speed that does not cause problems with the other device
+	 * on the cable.
+	 */
+	if (pair) {
+		u8 pair_pio = pair->pio_mode - XFER_PIO_0;
+		/* trim PIO to the slowest of the master/slave */
+		if (pair_pio < mode_wanted)
+			mode_wanted = pair_pio;
+	}
+#endif
 	/* We prefer 66Mhz clock for PIO 0-3, don't care for PIO4 */
 	itdev->want[unit][1] = pio_want[mode_wanted];
 	itdev->want[unit][0] = 1;	/* PIO is lowest priority */
@@ -297,11 +315,12 @@ static void it821x_passthru_set_dmamode(
 
 static void it821x_disable_raid(struct pci_dev *pdev)
 {
+#ifndef __IDE2LIBATA
 	/* Neither the RDC nor the IT8211 */
 	if (pdev->vendor != PCI_VENDOR_ID_ITE ||
 			pdev->device != PCI_DEVICE_ID_ITE_8212)
 			return;
-
+#endif
 	/* Reset local CPU, and set BIOS not ready */
 	pci_write_config_byte(pdev, 0x5E, 0x01);
 
Index: b/drivers/ide/it821x.c
===================================================================
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -8,51 +8,6 @@
  *  Documentation:
  *	Datasheet is freely available, some other documents under NDA.
  *
- *  The ITE8212 isn't exactly a standard IDE controller. It has two
- *  modes. In pass through mode then it is an IDE controller. In its smart
- *  mode its actually quite a capable hardware raid controller disguised
- *  as an IDE controller. Smart mode only understands DMA read/write and
- *  identify, none of the fancier commands apply. The IT8211 is identical
- *  in other respects but lacks the raid mode.
- *
- *  Errata:
- *  o	Rev 0x10 also requires master/slave hold the same DMA timings and
- *	cannot do ATAPI MWDMA.
- *  o	The identify data for raid volumes lacks CHS info (technically ok)
- *	but also fails to set the LBA28 and other bits. We fix these in
- *	the IDE probe quirk code.
- *  o	If you write LBA48 sized I/O's (ie > 256 sector) in smart mode
- *	raid then the controller firmware dies
- *  o	Smart mode without RAID doesn't clear all the necessary identify
- *	bits to reduce the command set to the one used
- *
- *  This has a few impacts on the driver
- *  - In pass through mode we do all the work you would expect
- *  - In smart mode the clocking set up is done by the controller generally
- *    but we must watch the other limits and filter.
- *  - There are a few extra vendor commands that actually talk to the
- *    controller but only work PIO with no IRQ.
- *
- *  Vendor areas of the identify block in smart mode are used for the
- *  timing and policy set up. Each HDD in raid mode also has a serial
- *  block on the disk. The hardware extra commands are get/set chip status,
- *  rebuild, get rebuild status.
- *
- *  In Linux the driver supports pass through mode as if the device was
- *  just another IDE controller. If the smart mode is running then
- *  volumes are managed by the controller firmware and each IDE "disk"
- *  is a raid volume. Even more cute - the controller can do automated
- *  hotplug and rebuild.
- *
- *  The pass through controller itself is a little demented. It has a
- *  flaw that it has a single set of PIO/MWDMA timings per channel so
- *  non UDMA devices restrict each others performance. It also has a
- *  single clock source per channel so mixed UDMA100/133 performance
- *  isn't perfect and we have to pick a clock. Thankfully none of this
- *  matters in smart mode. ATAPI DMA is not currently supported.
- *
- *  It seems the smart mode is a win for RAID1/RAID10 but otherwise not.
- *
  *  TODO
  *	-	ATAPI UDMA is ok but not MWDMA it seems
  *	-	RAID configuration ioctls
@@ -69,280 +24,8 @@
 
 #define QUIRK_VORTEX86 1
 
-struct it821x_dev
-{
-	unsigned int smart:1,		/* Are we in smart raid mode */
-		timing10:1;		/* Rev 0x10 */
-	u8	clock_mode;		/* 0, ATA_50 or ATA_66 */
-	u8	want[2][2];		/* Mode/Pri log for master slave */
-	/* We need these for switching the clock when DMA goes on/off
-	   The high byte is the 66Mhz timing */
-	u16	pio[2];			/* Cached PIO values */
-	u16	mwdma[2];		/* Cached MWDMA values */
-	u16	udma[2];		/* Cached UDMA values (per drive) */
-	u16	quirks;
-};
-
-#define ATA_66		0
-#define ATA_50		1
-#define ATA_ANY		2
-
-#define UDMA_OFF	0
-#define MWDMA_OFF	0
-
-/*
- *	We allow users to force the card into non raid mode without
- *	flashing the alternative BIOS. This is also necessary right now
- *	for embedded platforms that cannot run a PC BIOS but are using this
- *	device.
- */
-
-static int it8212_noraid;
-
-/**
- *	it821x_program	-	program the PIO/MWDMA registers
- *	@drive: drive to tune
- *	@timing: timing info
- *
- *	Program the PIO/MWDMA timing for this channel according to the
- *	current clock.
- */
-
-static void it821x_program(ide_drive_t *drive, u16 timing)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	int channel = hwif->channel;
-	u8 conf;
-
-	/* Program PIO/MWDMA timing bits */
-	if(itdev->clock_mode == ATA_66)
-		conf = timing >> 8;
-	else
-		conf = timing & 0xFF;
-
-	pci_write_config_byte(dev, 0x54 + 4 * channel, conf);
-}
-
-/**
- *	it821x_program_udma	-	program the UDMA registers
- *	@drive: drive to tune
- *	@timing: timing info
- *
- *	Program the UDMA timing for this drive according to the
- *	current clock.
- */
-
-static void it821x_program_udma(ide_drive_t *drive, u16 timing)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	int channel = hwif->channel;
-	u8 unit = drive->dn & 1, conf;
-
-	/* Program UDMA timing bits */
-	if(itdev->clock_mode == ATA_66)
-		conf = timing >> 8;
-	else
-		conf = timing & 0xFF;
-
-	if (itdev->timing10 == 0)
-		pci_write_config_byte(dev, 0x56 + 4 * channel + unit, conf);
-	else {
-		pci_write_config_byte(dev, 0x56 + 4 * channel, conf);
-		pci_write_config_byte(dev, 0x56 + 4 * channel + 1, conf);
-	}
-}
-
-/**
- *	it821x_clock_strategy
- *	@drive: drive to set up
- *
- *	Select between the 50 and 66Mhz base clocks to get the best
- *	results for this interface.
- */
-
-static void it821x_clock_strategy(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	ide_drive_t *pair = ide_get_pair_dev(drive);
-	int clock, altclock, sel = 0;
-	u8 unit = drive->dn & 1, v;
-
-	if(itdev->want[0][0] > itdev->want[1][0]) {
-		clock = itdev->want[0][1];
-		altclock = itdev->want[1][1];
-	} else {
-		clock = itdev->want[1][1];
-		altclock = itdev->want[0][1];
-	}
-
-	/*
-	 * if both clocks can be used for the mode with the higher priority
-	 * use the clock needed by the mode with the lower priority
-	 */
-	if (clock == ATA_ANY)
-		clock = altclock;
-
-	/* Nobody cares - keep the same clock */
-	if(clock == ATA_ANY)
-		return;
-	/* No change */
-	if(clock == itdev->clock_mode)
-		return;
-
-	/* Load this into the controller ? */
-	if(clock == ATA_66)
-		itdev->clock_mode = ATA_66;
-	else {
-		itdev->clock_mode = ATA_50;
-		sel = 1;
-	}
-
-	pci_read_config_byte(dev, 0x50, &v);
-	v &= ~(1 << (1 + hwif->channel));
-	v |= sel << (1 + hwif->channel);
-	pci_write_config_byte(dev, 0x50, v);
-
-	/*
-	 *	Reprogram the UDMA/PIO of the pair drive for the switch
-	 *	MWDMA will be dealt with by the dma switcher
-	 */
-	if(pair && itdev->udma[1-unit] != UDMA_OFF) {
-		it821x_program_udma(pair, itdev->udma[1-unit]);
-		it821x_program(pair, itdev->pio[1-unit]);
-	}
-	/*
-	 *	Reprogram the UDMA/PIO of our drive for the switch.
-	 *	MWDMA will be dealt with by the dma switcher
-	 */
-	if(itdev->udma[unit] != UDMA_OFF) {
-		it821x_program_udma(drive, itdev->udma[unit]);
-		it821x_program(drive, itdev->pio[unit]);
-	}
-}
-
-/**
- *	it821x_set_pio_mode	-	set host controller for PIO mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Tune the host to the desired PIO mode taking into the consideration
- *	the maximum PIO mode supported by the other device on the cable.
- */
-
-static void it821x_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	ide_drive_t *pair = ide_get_pair_dev(drive);
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-	u8 unit = drive->dn & 1, set_pio = pio;
-
-	/* Spec says 89 ref driver uses 88 */
-	static u16 pio_timings[]= { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
-	static u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
-
-	/*
-	 * Compute the best PIO mode we can for a given device. We must
-	 * pick a speed that does not cause problems with the other device
-	 * on the cable.
-	 */
-	if (pair) {
-		u8 pair_pio = pair->pio_mode - XFER_PIO_0;
-		/* trim PIO to the slowest of the master/slave */
-		if (pair_pio < set_pio)
-			set_pio = pair_pio;
-	}
-
-	/* We prefer 66Mhz clock for PIO 0-3, don't care for PIO4 */
-	itdev->want[unit][1] = pio_want[set_pio];
-	itdev->want[unit][0] = 1;	/* PIO is lowest priority */
-	itdev->pio[unit] = pio_timings[set_pio];
-	it821x_clock_strategy(drive);
-	it821x_program(drive, itdev->pio[unit]);
-}
-
-/**
- *	it821x_tune_mwdma	-	tune a channel for MWDMA
- *	@drive: drive to set up
- *	@mode_wanted: the target operating mode
- *
- *	Load the timing settings for this device mode into the
- *	controller when doing MWDMA in pass through mode. The caller
- *	must manage the whole lack of per device MWDMA/PIO timings and
- *	the shared MWDMA/PIO timing register.
- */
-
-static void it821x_tune_mwdma(ide_drive_t *drive, u8 mode_wanted)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct it821x_dev *itdev = (void *)ide_get_hwifdata(hwif);
-	u8 unit = drive->dn & 1, channel = hwif->channel, conf;
-
-	static u16 dma[]	= { 0x8866, 0x3222, 0x3121 };
-	static u8 mwdma_want[]	= { ATA_ANY, ATA_66, ATA_ANY };
-
-	itdev->want[unit][1] = mwdma_want[mode_wanted];
-	itdev->want[unit][0] = 2;	/* MWDMA is low priority */
-	itdev->mwdma[unit] = dma[mode_wanted];
-	itdev->udma[unit] = UDMA_OFF;
-
-	/* UDMA bits off - Revision 0x10 do them in pairs */
-	pci_read_config_byte(dev, 0x50, &conf);
-	if (itdev->timing10)
-		conf |= channel ? 0x60: 0x18;
-	else
-		conf |= 1 << (3 + 2 * channel + unit);
-	pci_write_config_byte(dev, 0x50, conf);
-
-	it821x_clock_strategy(drive);
-	/* FIXME: do we need to program this ? */
-	/* it821x_program(drive, itdev->mwdma[unit]); */
-}
-
-/**
- *	it821x_tune_udma	-	tune a channel for UDMA
- *	@drive: drive to set up
- *	@mode_wanted: the target operating mode
- *
- *	Load the timing settings for this device mode into the
- *	controller when doing UDMA modes in pass through.
- */
-
-static void it821x_tune_udma(ide_drive_t *drive, u8 mode_wanted)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	u8 unit = drive->dn & 1, channel = hwif->channel, conf;
-
-	static u16 udma[]	= { 0x4433, 0x4231, 0x3121, 0x2121, 0x1111, 0x2211, 0x1111 };
-	static u8 udma_want[]	= { ATA_ANY, ATA_50, ATA_ANY, ATA_66, ATA_66, ATA_50, ATA_66 };
-
-	itdev->want[unit][1] = udma_want[mode_wanted];
-	itdev->want[unit][0] = 3;	/* UDMA is high priority */
-	itdev->mwdma[unit] = MWDMA_OFF;
-	itdev->udma[unit] = udma[mode_wanted];
-	if(mode_wanted >= 5)
-		itdev->udma[unit] |= 0x8080;	/* UDMA 5/6 select on */
-
-	/* UDMA on. Again revision 0x10 must do the pair */
-	pci_read_config_byte(dev, 0x50, &conf);
-	if (itdev->timing10)
-		conf &= channel ? 0x9F: 0xE7;
-	else
-		conf &= ~ (1 << (3 + 2 * channel + unit));
-	pci_write_config_byte(dev, 0x50, conf);
-
-	it821x_clock_strategy(drive);
-	it821x_program_udma(drive, itdev->udma[unit]);
-
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_it821x.h"
 
 /**
  *	it821x_dma_read	-	DMA hook
@@ -364,9 +47,9 @@ static void it821x_dma_start(ide_drive_t
 	u8 unit = drive->dn & 1;
 
 	if(itdev->mwdma[unit] != MWDMA_OFF)
-		it821x_program(drive, itdev->mwdma[unit]);
+		it821x_program(hwif, drive, itdev->mwdma[unit]);
 	else if(itdev->udma[unit] != UDMA_OFF && itdev->timing10)
-		it821x_program_udma(drive, itdev->udma[unit]);
+		it821x_program_udma(hwif, drive, itdev->udma[unit]);
 	ide_dma_start(drive);
 }
 
@@ -387,34 +70,11 @@ static int it821x_dma_end(ide_drive_t *d
 	u8 unit = drive->dn & 1;
 
 	if(itdev->mwdma[unit] != MWDMA_OFF)
-		it821x_program(drive, itdev->pio[unit]);
+		it821x_program(hwif, drive, itdev->pio[unit]);
 	return ret;
 }
 
 /**
- *	it821x_set_dma_mode	-	set host controller for DMA mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Tune the ITE chipset for the desired DMA mode.
- */
-
-static void it821x_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	const u8 speed = drive->dma_mode;
-
-	/*
-	 * MWDMA tuning is really hard because our MWDMA and PIO
-	 * timings are kept in the same place.  We can switch in the
-	 * host dma on/off callbacks.
-	 */
-	if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_6)
-		it821x_tune_udma(drive, speed - XFER_UDMA_0);
-	else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
-		it821x_tune_mwdma(drive, speed - XFER_MW_DMA_0);
-}
-
-/**
  *	it821x_cable_detect	-	cable detection
  *	@hwif: interface to check
  *
@@ -587,23 +247,6 @@ static void __devinit init_hwif_it821x(i
 	}
 }
 
-static void it8212_disable_raid(struct pci_dev *dev)
-{
-	/* Reset local CPU, and set BIOS not ready */
-	pci_write_config_byte(dev, 0x5E, 0x01);
-
-	/* Set to bypass mode, and reset PCI bus */
-	pci_write_config_byte(dev, 0x50, 0x00);
-	pci_write_config_word(dev, PCI_COMMAND,
-			      PCI_COMMAND_PARITY | PCI_COMMAND_IO |
-			      PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);
-	pci_write_config_word(dev, 0x40, 0xA0F3);
-
-	pci_write_config_dword(dev,0x4C, 0x02040204);
-	pci_write_config_byte(dev, 0x42, 0x36);
-	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
-}
-
 static int init_chipset_it821x(struct pci_dev *dev)
 {
 	u8 conf;
@@ -613,7 +256,7 @@ static int init_chipset_it821x(struct pc
 	if (it8212_noraid) {
 		printk(KERN_INFO DRV_NAME " %s: forcing bypass mode\n",
 			pci_name(dev));
-		it8212_disable_raid(dev);
+		it821x_disable_raid(dev);
 	}
 	pci_read_config_byte(dev, 0x50, &conf);
 	printk(KERN_INFO DRV_NAME " %s: controller in %s mode\n",
@@ -623,8 +266,8 @@ static int init_chipset_it821x(struct pc
 
 static const struct ide_port_ops it821x_port_ops = {
 	/* it821x_set_{pio,dma}_mode() are only used in pass-through mode */
-	.set_pio_mode		= it821x_set_pio_mode,
-	.set_dma_mode		= it821x_set_dma_mode,
+	.set_pio_mode		= it821x_passthru_set_piomode,
+	.set_dma_mode		= it821x_passthru_set_dmamode,
 	.quirkproc		= it821x_quirkproc,
 	.cable_detect		= it821x_cable_detect,
 };

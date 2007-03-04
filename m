Return-Path: <linux-kernel-owner+w=401wt.eu-S1750888AbXCDAnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888AbXCDAnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 19:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXCDAnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 19:43:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:56223 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXCDAnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 19:43:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Z6a0caEr75qxedC3eL8vv+3QEtBXZEgwjc3HnPrS9WkK/yV6bsO7XYjvzetASVLifJJgxHAkmQmRofnvT3D4dcmoVs3jFJm0tMDk7Y2ajq4iu2ybO+DHcAzu4IVLy00NoA8pKvNA73VXiYXvZoGjMQnW5S2qaHUEptVqoOdMYrU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH][pata-2.6 tree] pdc202xx_old: rewrite mode programming code
Date: Sun, 4 Mar 2007 01:49:46 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703040149.46186.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH] pdc202xx_old: rewrite mode programming code

This patch is based on the documentation (I would like to thank Promise
for it) and also partially on the older vendor driver.

Rewrite mode programming code:

* disable 66MHz clock in pdc202xx_tune_chipset() so it is correctly disabled
  even if both devices on the channel are not DMA capable and after reset

* enable/disable IORDY and PREFETCH bits in pdc202xx_tune_chipset()
  as they need to be setup correctly also for PIO only devices, plus IORDY
  wasn't disabled for non-IORDY devices and PREFETCH wasn't disabled for
  ATAPI devices

* remove dead code for setting SYNC_ERDDY_EN bits from config_chipset_for_dma()
  (driver sets ->autotune to 1 so PIO modes are always programmed => lower
   nibble of register A never equals 4 => "chipset_is_set" is always true)

* enable PIO mode programming for all ATAPI devices
  (it was limited to ->media == ide_cdrom devices)

* remove extra reads of registers A/B/C, don't read register D et all

* do clearing / programming of registers A/B/C in one go
  (gets rid of extra PCI config space read/write cycle)

* set initial values of drive_conf/AP/BP/CP variables to zero
  (paranoia for the case when PCI reads fail)

* remove XFER_UDMA6 to XFER_UDMA5 remapping case - it can't happen
  (ide_rate_filter() takes care of it)

* fix XFER_MW_DMA0 timings (they were overclocked, use the official ones)

* fix bitmasks for clearing bits of register B:

  - when programming DMA mode bit 0x10 of register B was cleared which
    resulted in overclocked PIO timing setting (iff PIO0 was used)

  - when programming PIO mode bits 0x18 weren't cleared so suboptimal
    timings were used for PIO1-4 if PIO0 was previously set (bit 0x10)
    and for PIO0/3/4 if PIO1/2 was previously set (bit 0x08)

* add FIXME comment about missing locking for 66MHz clock register

Also while at it:

* remove unused defines

* do a few cosmetic / CodingStyle fixes

* bump driver version

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

 drivers/ide/pci/pdc202xx_old.c |  176 +++++++++--------------------------------
 1 file changed, 42 insertions(+), 134 deletions(-)

Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -1,8 +1,9 @@
 /*
- *  linux/drivers/ide/pci/pdc202xx_old.c	Version 0.36	Sept 11, 2002
+ *  linux/drivers/ide/pci/pdc202xx_old.c	Version 0.50	Mar 3, 2007
  *
  *  Copyright (C) 1998-2002		Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007		MontaVista Software, Inc.
+ *  Copyright (C) 2007			Bartlomiej Zolnierkiewicz
  *
  *  Promise Ultra33 cards with BIOS v1.20 through 1.28 will need this
  *  compiled into the kernel if you have more than one card installed.
@@ -60,45 +61,7 @@ static const char *pdc_quirk_drives[] = 
 	NULL
 };
 
-/* A Register */
-#define	SYNC_ERRDY_EN	0xC0
-
-#define	SYNC_IN		0x80	/* control bit, different for master vs. slave drives */
-#define	ERRDY_EN	0x40	/* control bit, different for master vs. slave drives */
-#define	IORDY_EN	0x20	/* PIO: IOREADY */
-#define	PREFETCH_EN	0x10	/* PIO: PREFETCH */
-
-#define	PA3		0x08	/* PIO"A" timing */
-#define	PA2		0x04	/* PIO"A" timing */
-#define	PA1		0x02	/* PIO"A" timing */
-#define	PA0		0x01	/* PIO"A" timing */
-
-/* B Register */
-
-#define	MB2		0x80	/* DMA"B" timing */
-#define	MB1		0x40	/* DMA"B" timing */
-#define	MB0		0x20	/* DMA"B" timing */
-
-#define	PB4		0x10	/* PIO_FORCE 1:0 */
-
-#define	PB3		0x08	/* PIO"B" timing */	/* PIO flow Control mode */
-#define	PB2		0x04	/* PIO"B" timing */	/* PIO 4 */
-#define	PB1		0x02	/* PIO"B" timing */	/* PIO 3 half */
-#define	PB0		0x01	/* PIO"B" timing */	/* PIO 3 other half */
-
-/* C Register */
-#define	IORDYp_NO_SPEED	0x4F
-#define	SPEED_DIS	0x0F
-
-#define	DMARQp		0x80
-#define	IORDYp		0x40
-#define	DMAR_EN		0x20
-#define	DMAW_EN		0x10
-
-#define	MC3		0x08	/* DMA"C" timing */
-#define	MC2		0x04	/* DMA"C" timing */
-#define	MC1		0x02	/* DMA"C" timing */
-#define	MC0		0x01	/* DMA"C" timing */
+static void pdc_old_disable_66MHz_clock(ide_hwif_t *);
 
 static int pdc202xx_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 {
@@ -107,52 +70,23 @@ static int pdc202xx_tune_chipset (ide_dr
 	u8 drive_pci		= 0x60 + (drive->dn << 2);
 	u8 speed		= ide_rate_filter(drive, xferspeed);
 
-	u32			drive_conf;
-	u8			AP, BP, CP, DP;
+	u32			drive_conf = 0;
+	u8			AP = 0, BP = 0, CP = 0;
 	u8			TA = 0, TB = 0, TC = 0;
 
-	if (drive->media != ide_disk &&
-		drive->media != ide_cdrom && speed < XFER_SW_DMA_0)
-		return -1;
+	/*
+	 * TODO: do this once per channel
+	 */
+	if (dev->device != PCI_DEVICE_ID_PROMISE_20246)
+		pdc_old_disable_66MHz_clock(hwif);
 
 	pci_read_config_dword(dev, drive_pci, &drive_conf);
-	pci_read_config_byte(dev, (drive_pci), &AP);
-	pci_read_config_byte(dev, (drive_pci)|0x01, &BP);
-	pci_read_config_byte(dev, (drive_pci)|0x02, &CP);
-	pci_read_config_byte(dev, (drive_pci)|0x03, &DP);
 
-	if (speed < XFER_SW_DMA_0) {
-		if ((AP & 0x0F) || (BP & 0x07)) {
-			/* clear PIO modes of lower 8421 bits of A Register */
-			pci_write_config_byte(dev, (drive_pci), AP &~0x0F);
-			pci_read_config_byte(dev, (drive_pci), &AP);
-
-			/* clear PIO modes of lower 421 bits of B Register */
-			pci_write_config_byte(dev, (drive_pci)|0x01, BP &~0x07);
-			pci_read_config_byte(dev, (drive_pci)|0x01, &BP);
-
-			pci_read_config_byte(dev, (drive_pci), &AP);
-			pci_read_config_byte(dev, (drive_pci)|0x01, &BP);
-		}
-	} else {
-		if ((BP & 0xF0) && (CP & 0x0F)) {
-			/* clear DMA modes of upper 842 bits of B Register */
-			/* clear PIO forced mode upper 1 bit of B Register */
-			pci_write_config_byte(dev, (drive_pci)|0x01, BP &~0xF0);
-			pci_read_config_byte(dev, (drive_pci)|0x01, &BP);
-
-			/* clear DMA modes of lower 8421 bits of C Register */
-			pci_write_config_byte(dev, (drive_pci)|0x02, CP &~0x0F);
-			pci_read_config_byte(dev, (drive_pci)|0x02, &CP);
-		}
-	}
-
-	pci_read_config_byte(dev, (drive_pci), &AP);
-	pci_read_config_byte(dev, (drive_pci)|0x01, &BP);
-	pci_read_config_byte(dev, (drive_pci)|0x02, &CP);
+	pci_read_config_byte(dev, drive_pci,     &AP);
+	pci_read_config_byte(dev, drive_pci + 1, &BP);
+	pci_read_config_byte(dev, drive_pci + 2, &CP);
 
 	switch(speed) {
-		case XFER_UDMA_6:	speed = XFER_UDMA_5;
 		case XFER_UDMA_5:
 		case XFER_UDMA_4:	TB = 0x20; TC = 0x01; break;
 		case XFER_UDMA_2:	TB = 0x20; TC = 0x01; break;
@@ -161,7 +95,7 @@ static int pdc202xx_tune_chipset (ide_dr
 		case XFER_UDMA_0:
 		case XFER_MW_DMA_2:	TB = 0x60; TC = 0x03; break;
 		case XFER_MW_DMA_1:	TB = 0x60; TC = 0x04; break;
-		case XFER_MW_DMA_0:
+		case XFER_MW_DMA_0:	TB = 0xE0; TC = 0x0F; break;
 		case XFER_SW_DMA_2:	TB = 0x60; TC = 0x05; break;
 		case XFER_SW_DMA_1:	TB = 0x80; TC = 0x06; break;
 		case XFER_SW_DMA_0:	TB = 0xC0; TC = 0x0B; break;
@@ -174,25 +108,39 @@ static int pdc202xx_tune_chipset (ide_dr
 	}
 
 	if (speed < XFER_SW_DMA_0) {
-		pci_write_config_byte(dev, (drive_pci), AP|TA);
-		pci_write_config_byte(dev, (drive_pci)|0x01, BP|TB);
+		/*
+		 * preserve SYNC_INT / ERDDY_EN bits while clearing
+		 * Prefetch_EN / IORDY_EN / PA[3:0] bits of register A
+		 */
+		AP &= ~0x3f;
+		if (drive->id->capability & 4)
+			AP |= 0x20;	/* set IORDY_EN bit */
+		if (drive->media == ide_disk)
+			AP |= 0x10;	/* set Prefetch_EN bit */
+		/* clear PB[4:0] bits of register B */
+		BP &= ~0x1f;
+		pci_write_config_byte(dev, drive_pci,     AP | TA);
+		pci_write_config_byte(dev, drive_pci + 1, BP | TB);
 	} else {
-		pci_write_config_byte(dev, (drive_pci)|0x01, BP|TB);
-		pci_write_config_byte(dev, (drive_pci)|0x02, CP|TC);
+		/* clear MB[2:0] bits of register B */
+		BP &= ~0xe0;
+		/* clear MC[3:0] bits of register C */
+		CP &= ~0x0f;
+		pci_write_config_byte(dev, drive_pci + 1, BP | TB);
+		pci_write_config_byte(dev, drive_pci + 2, CP | TC);
 	}
 
 #if PDC202XX_DEBUG_DRIVE_INFO
 	printk(KERN_DEBUG "%s: %s drive%d 0x%08x ",
 		drive->name, ide_xfer_verbose(speed),
 		drive->dn, drive_conf);
-		pci_read_config_dword(dev, drive_pci, &drive_conf);
+	pci_read_config_dword(dev, drive_pci, &drive_conf);
 	printk("0x%08x\n", drive_conf);
-#endif /* PDC202XX_DEBUG_DRIVE_INFO */
+#endif
 
-	return (ide_config_drive_speed(drive, speed));
+	return ide_config_drive_speed(drive, speed);
 }
 
-
 static void pdc202xx_tune_drive(ide_drive_t *drive, u8 pio)
 {
 	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
@@ -210,6 +158,8 @@ static u8 pdc202xx_old_cable_detect (ide
  * Set the control register to use the 66MHz system
  * clock for UDMA 3/4/5 mode operation when necessary.
  *
+ * FIXME: this register is shared by both channels, some locking is needed
+ *
  * It may also be possible to leave the 66MHz clock on
  * and readjust the timing parameters.
  */
@@ -231,55 +181,13 @@ static void pdc_old_disable_66MHz_clock(
 
 static int config_chipset_for_dma (ide_drive_t *drive)
 {
-	struct hd_driveid *id	= drive->id;
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
-	u32 drive_conf		= 0;
-	u8 drive_pci		= 0x60 + (drive->dn << 2);
-	u8 test1 = 0, test2 = 0, speed = -1;
-	u8 AP = 0;
-
-	if (dev->device != PCI_DEVICE_ID_PROMISE_20246)
-		pdc_old_disable_66MHz_clock(drive->hwif);
-
-	drive_pci = 0x60 + (drive->dn << 2);
-	pci_read_config_dword(dev, drive_pci, &drive_conf);
-	if ((drive_conf != 0x004ff304) && (drive_conf != 0x004ff3c4))
-		goto chipset_is_set;
+	u8 speed = ide_max_dma_mode(drive);
 
-	pci_read_config_byte(dev, drive_pci, &test1);
-	if (!(test1 & SYNC_ERRDY_EN)) {
-		if (drive->select.b.unit & 0x01) {
-			pci_read_config_byte(dev, drive_pci - 4, &test2);
-			if ((test2 & SYNC_ERRDY_EN) &&
-			    !(test1 & SYNC_ERRDY_EN)) {
-				pci_write_config_byte(dev, drive_pci,
-					test1|SYNC_ERRDY_EN);
-			}
-		} else {
-			pci_write_config_byte(dev, drive_pci,
-				test1|SYNC_ERRDY_EN);
-		}
-	}
-
-chipset_is_set:
-
-	pci_read_config_byte(dev, (drive_pci), &AP);
-	if (id->capability & 4) /* IORDY_EN */
-		pci_write_config_byte(dev, (drive_pci), AP|IORDY_EN);
-	pci_read_config_byte(dev, (drive_pci), &AP);
-	if (drive->media == ide_disk)	/* PREFETCH_EN */
-		pci_write_config_byte(dev, (drive_pci), AP|PREFETCH_EN);
-
-	speed = ide_max_dma_mode(drive);
-
-	if (!(speed)) {
-		/* restore original pci-config space */
-		pci_write_config_dword(dev, drive_pci, drive_conf);
+	if (!speed)
 		return 0;
-	}
 
-	(void) hwif->speedproc(drive, speed);
+	(void)pdc202xx_tune_chipset(drive, speed);
+
 	return ide_dma_enable(drive);
 }
 

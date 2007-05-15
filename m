Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbXEPArA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbXEPArA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761643AbXEPAqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:46:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:36716 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760825AbXEPAqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TzMS0BBjQM8NzZejyRnhTKmf5hp/6SdFpNNaAcVt56u6zlu3xKZv80/6nrzDKwh2eBBiLcBVdPWOJZiwNE+Os8Ui0J6/pKeZmcSoZqZHtiuT09o8G8zL9FUbxV+DTw92/2sEaKMPHiBM1DniCJ2eg/8PeTixvOMVMwSSQMk0A28=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates/fixes
Date: Wed, 16 May 2007 01:27:54 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705160127.55430.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This time:

* host driver fixes:
  - pdc202xx_old: mode programming rewrite (a lot of bugs fixed)
  - serverworks/sis5513: PIO mode setup fixes
  - sl82c105: MWDMA0/1 support by Sergei
  - cs5530/sc1200/sl82c105: ->speedproc support ("hdparm -X")

* 2nd part of cleanups basing on DMA tuning rework (which was merged
  in the previous IDE update) - quite straightforward code re-factoring
  (no functionality changes) and removal of no longer needed functions.

  This results in simpler, more generic code and in ~300 LOCs gone.

* some misc fixes/updates


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig            |   15 +---
 drivers/ide/cris/ide-cris.c    |   14 +---
 drivers/ide/ide-dma.c          |   53 +++---------
 drivers/ide/ide-io.c           |    1 +
 drivers/ide/ide-lib.c          |   12 ---
 drivers/ide/ide.c              |    1 +
 drivers/ide/pci/alim15x3.c     |   69 ++--------------
 drivers/ide/pci/cmd64x.c       |   15 +---
 drivers/ide/pci/cs5530.c       |  160 +++++++++++++++++------------------
 drivers/ide/pci/it821x.c       |   21 +-----
 drivers/ide/pci/pdc202xx_new.c |   29 +------
 drivers/ide/pci/pdc202xx_old.c |  184 +++++++++-------------------------------
 drivers/ide/pci/sc1200.c       |  161 +++++++++++++++++------------------
 drivers/ide/pci/scc_pata.c     |   22 +-----
 drivers/ide/pci/serverworks.c  |   77 +++--------------
 drivers/ide/pci/siimage.c      |   24 +-----
 drivers/ide/pci/sis5513.c      |   85 ++++++++-----------
 drivers/ide/pci/sl82c105.c     |   76 ++++++++++++++---
 include/linux/ide.h            |    3 -
 19 files changed, 340 insertions(+), 682 deletions(-)


Alan Cox (1):
      sl82c105: Switch to ref counting API

Bartlomiej Zolnierkiewicz (13):
      pdc202xx_old: rewrite mode programming code (v2)
      serverworks: PIO mode setup fixes
      sis5513: PIO mode setup fixes
      alim15x3: use ide_tune_dma()
      pdc202xx_new: use ide_tune_dma()
      ide: always disable DMA before tuning it
      cs5530/sc1200: add ->udma_filter methods
      ide: use ide_tune_dma() part #2
      cs5530/sc1200: DMA support cleanup
      cs5530/sc1200: add ->speedproc support
      ide: remove ide_dma_enable()
      ide: add missing validity checks for identify words 62 and 63
      ide: remove ide_use_dma()

Jan Engelhardt (1):
      Use menuconfig objects: IDE

Sergei Shtylyov (1):
      sl82c105: add speedproc() method and MWDMA0/1 support


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 9040809..b1a9b81 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -4,13 +4,10 @@
 # Andre Hedrick <andre@linux-ide.org>
 #
 
-if BLOCK
-
-menu "ATA/ATAPI/MFM/RLL support"
-	depends on HAS_IOMEM
-
-config IDE
+menuconfig IDE
 	tristate "ATA/ATAPI/MFM/RLL support"
+	depends on BLOCK
+	depends on HAS_IOMEM
 	---help---
 	  If you say Y here, your kernel will be able to manage low cost mass
 	  storage units such as ATA/(E)IDE and ATAPI units. The most common
@@ -1099,8 +1096,4 @@ config BLK_DEV_HD_ONLY
 config BLK_DEV_HD
 	def_bool BLK_DEV_HD_IDE || BLK_DEV_HD_ONLY
 
-endif
-
-endmenu
-
-endif
+endif # IDE
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index c04cb25..ca0341c 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -1002,18 +1002,6 @@ static int cris_ide_build_dmatable (ide_drive_t *drive)
 	return 1;	/* let the PIO routines handle this weirdness */
 }
 
-static int cris_config_drive_for_dma (ide_drive_t *drive)
-{
-	u8 speed = ide_max_dma_mode(drive);
-
-	if (!speed)
-		return 0;
-
-	speed_cris_ide(drive, speed);
-
-	return ide_dma_enable(drive);
-}
-
 /*
  * cris_dma_intr() is the handler for disk read/write DMA interrupts
  */
@@ -1043,7 +1031,7 @@ static ide_startstop_t cris_dma_intr (ide_drive_t *drive)
 
 static int cris_dma_check(ide_drive_t *drive)
 {
-	if (ide_use_dma(drive) && cris_config_drive_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	return -1;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 5fe8519..b77b7d1 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -670,41 +670,6 @@ int __ide_dma_good_drive (ide_drive_t *drive)
 
 EXPORT_SYMBOL(__ide_dma_good_drive);
 
-int ide_use_dma(ide_drive_t *drive)
-{
-	struct hd_driveid *id = drive->id;
-	ide_hwif_t *hwif = drive->hwif;
-
-	if ((id->capability & 1) == 0 || drive->autodma == 0)
-		return 0;
-
-	/* consult the list of known "bad" drives */
-	if (__ide_dma_bad_drive(drive))
-		return 0;
-
-	/* capable of UltraDMA modes */
-	if (id->field_valid & 4) {
-		if (hwif->ultra_mask & id->dma_ultra)
-			return 1;
-	}
-
-	/* capable of regular DMA modes */
-	if (id->field_valid & 2) {
-		if (hwif->mwdma_mask & id->dma_mword)
-			return 1;
-		if (hwif->swdma_mask & id->dma_1word)
-			return 1;
-	}
-
-	/* consult the list of known "good" drives */
-	if (__ide_dma_good_drive(drive) && id->eide_dma_time < 150)
-		return 1;
-
-	return 0;
-}
-
-EXPORT_SYMBOL_GPL(ide_use_dma);
-
 static const u8 xfer_mode_bases[] = {
 	XFER_UDMA_0,
 	XFER_MW_DMA_0,
@@ -731,10 +696,12 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base)
 			mask &= 0x07;
 		break;
 	case XFER_MW_DMA_0:
-		mask = id->dma_mword & hwif->mwdma_mask;
+		if (id->field_valid & 2)
+			mask = id->dma_mword & hwif->mwdma_mask;
 		break;
 	case XFER_SW_DMA_0:
-		mask = id->dma_1word & hwif->swdma_mask;
+		if (id->field_valid & 2)
+			mask = id->dma_1word & hwif->swdma_mask;
 		break;
 	default:
 		BUG();
@@ -783,8 +750,11 @@ int ide_tune_dma(ide_drive_t *drive)
 {
 	u8 speed;
 
-	/* TODO: use only ide_max_dma_mode() */
-	if (!ide_use_dma(drive))
+	if ((drive->id->capability & 1) == 0 || drive->autodma == 0)
+		return 0;
+
+	/* consult the list of known "bad" drives */
+	if (__ide_dma_bad_drive(drive))
 		return 0;
 
 	speed = ide_max_dma_mode(drive);
@@ -792,9 +762,10 @@ int ide_tune_dma(ide_drive_t *drive)
 	if (!speed)
 		return 0;
 
-	drive->hwif->speedproc(drive, speed);
+	if (drive->hwif->speedproc(drive, speed))
+		return 0;
 
-	return ide_dma_enable(drive);
+	return 1;
 }
 
 EXPORT_SYMBOL_GPL(ide_tune_dma);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 8e56814..bfe8f1b 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -223,6 +223,7 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 			break;
 		if (drive->hwif->ide_dma_check == NULL)
 			break;
+		drive->hwif->dma_off_quietly(drive);
 		ide_set_dma(drive);
 		break;
 	}
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 3be3c69..074bb32 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -111,18 +111,6 @@ u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
 
 EXPORT_SYMBOL(ide_rate_filter);
 
-int ide_dma_enable (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct hd_driveid *id	= drive->id;
-
-	return ((int)	((((id->dma_ultra >> 8) & hwif->ultra_mask) ||
-			  ((id->dma_mword >> 8) & hwif->mwdma_mask) ||
-			  ((id->dma_1word >> 8) & hwif->swdma_mask)) ? 1 : 0));
-}
-
-EXPORT_SYMBOL(ide_dma_enable);
-
 int ide_use_fast_pio(ide_drive_t *drive)
 {
 	struct hd_driveid *id = drive->id;
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index f2b547f..6002713 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -910,6 +910,7 @@ int set_using_dma(ide_drive_t *drive, int arg)
 	err = 0;
 
 	if (arg) {
+		hwif->dma_off_quietly(drive);
 		if (ide_set_dma(drive) || hwif->ide_dma_on(drive))
 			err = -EIO;
 	} else
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 428efda..27525ec 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -455,28 +455,6 @@ static int ali15x3_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	return (ide_config_drive_speed(drive, speed));
 }
 
-
-/**
- *	config_chipset_for_dma	-	set up DMA mode
- *	@drive: drive to configure for
- *
- *	Place a drive into DMA mode and tune the chipset for
- *	the selected speed.
- *
- *	Returns true if DMA mode can be used
- */
- 
-static int config_chipset_for_dma (ide_drive_t *drive)
-{
-	u8 speed = ide_max_dma_mode(drive);
-
-	if (!(speed))
-		return 0;
-
-	(void) ali15x3_tune_chipset(drive, speed);
-	return ide_dma_enable(drive);
-}
-
 /**
  *	ali15x3_config_drive_for_dma	-	configure for DMA
  *	@drive: drive to configure
@@ -487,48 +465,14 @@ static int config_chipset_for_dma (ide_drive_t *drive)
 
 static int ali15x3_config_drive_for_dma(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct hd_driveid *id	= drive->id;
-
-	if ((m5229_revision<=0x20) && (drive->media!=ide_disk))
-		goto ata_pio;
-
 	drive->init_speed = 0;
 
-	if ((id != NULL) && ((id->capability & 1) != 0) && drive->autodma) {
-		/* Consult the list of known "bad" drives */
-		if (__ide_dma_bad_drive(drive))
-			goto ata_pio;
-		if ((id->field_valid & 4) && (m5229_revision >= 0xC2)) {
-			if (id->dma_ultra & hwif->ultra_mask) {
-				/* Force if Capable UltraDMA */
-				int dma = config_chipset_for_dma(drive);
-				if ((id->field_valid & 2) && !dma)
-					goto try_dma_modes;
-			}
-		} else if (id->field_valid & 2) {
-try_dma_modes:
-			if ((id->dma_mword & hwif->mwdma_mask) ||
-			    (id->dma_1word & hwif->swdma_mask)) {
-				/* Force if Capable regular DMA modes */
-				if (!config_chipset_for_dma(drive))
-					goto ata_pio;
-			}
-		} else if (__ide_dma_good_drive(drive) &&
-			   (id->eide_dma_time < 150)) {
-			/* Consult the list of known "good" drives */
-			if (!config_chipset_for_dma(drive))
-				goto ata_pio;
-		} else {
-			goto ata_pio;
-		}
-	} else {
-ata_pio:
-		hwif->tuneproc(drive, 255);
-		return -1;
-	}
+	if (ide_tune_dma(drive))
+		return 0;
 
-	return 0;
+	ali15x3_tune_drive(drive, 255);
+
+	return -1;
 }
 
 /**
@@ -739,7 +683,8 @@ static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 		return;
 	}
 
-	hwif->atapi_dma = 1;
+	if (m5229_revision > 0x20)
+		hwif->atapi_dma = 1;
 
 	if (m5229_revision <= 0x20)
 		hwif->ultra_mask = 0x00; /* no udma */
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 61ea96b..7c57dc6 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -352,22 +352,9 @@ static int cmd64x_tune_chipset (ide_drive_t *drive, u8 speed)
 	return ide_config_drive_speed(drive, speed);
 }
 
-static int config_chipset_for_dma (ide_drive_t *drive)
-{
-	u8 speed = ide_max_dma_mode(drive);
-
-	if (!speed)
-		return 0;
-
-	if (cmd64x_tune_chipset(drive, speed))
-		return 0;
-
-	return ide_dma_enable(drive);
-}
-
 static int cmd64x_config_drive_for_dma (ide_drive_t *drive)
 {
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index b2d7c13..1eec1f3 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -1,10 +1,10 @@
 /*
- * linux/drivers/ide/pci/cs5530.c		Version 0.7	Sept 10, 2002
+ * linux/drivers/ide/pci/cs5530.c		Version 0.73	Mar 10 2007
  *
  * Copyright (C) 2000			Andre Hedrick <andre@linux-ide.org>
- * Ditto of GNU General Public License.
- *
  * Copyright (C) 2000			Mark Lord <mlord@pobox.com>
+ * Copyright (C) 2007			Bartlomiej Zolnierkiewicz
+ *
  * May be copied or modified under the terms of the GNU General Public License
  *
  * Development of this chipset driver was funded
@@ -62,6 +62,14 @@ static unsigned int cs5530_pio_timings[2][5] = {
 #define CS5530_BAD_PIO(timings) (((timings)&~0x80000000)==0x0000e132)
 #define CS5530_BASEREG(hwif)	(((hwif)->dma_base & ~0xf) + ((hwif)->channel ? 0x30 : 0x20))
 
+static void cs5530_tunepio(ide_drive_t *drive, u8 pio)
+{
+	unsigned long basereg = CS5530_BASEREG(drive->hwif);
+	unsigned int format = (inl(basereg + 4) >> 31) & 1;
+
+	outl(cs5530_pio_timings[format][pio], basereg + ((drive->dn & 1)<<3));
+}
+
 /**
  *	cs5530_tuneproc		-	select/set PIO modes
  *
@@ -74,98 +82,78 @@ static unsigned int cs5530_pio_timings[2][5] = {
 
 static void cs5530_tuneproc (ide_drive_t *drive, u8 pio)	/* pio=255 means "autotune" */
 {
-	ide_hwif_t	*hwif = HWIF(drive);
-	unsigned int	format;
-	unsigned long basereg = CS5530_BASEREG(hwif);
-	static u8	modes[5] = { XFER_PIO_0, XFER_PIO_1, XFER_PIO_2, XFER_PIO_3, XFER_PIO_4};
-
 	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
-	if (!cs5530_set_xfer_mode(drive, modes[pio])) {
-		format = (inl(basereg + 4) >> 31) & 1;
-		outl(cs5530_pio_timings[format][pio],
-			basereg+(drive->select.b.unit<<3));
+
+	if (cs5530_set_xfer_mode(drive, XFER_PIO_0 + pio) == 0)
+		cs5530_tunepio(drive, pio);
+}
+
+/**
+ *	cs5530_udma_filter	-	UDMA filter
+ *	@drive: drive
+ *
+ *	cs5530_udma_filter() does UDMA mask filtering for the given drive
+ *	taking into the consideration capabilities of the mate device.
+ *
+ *	The CS5530 specifies that two drives sharing a cable cannot mix
+ *	UDMA/MDMA.  It has to be one or the other, for the pair, though
+ *	different timings can still be chosen for each drive.  We could
+ *	set the appropriate timing bits on the fly, but that might be
+ *	a bit confusing.  So, for now we statically handle this requirement
+ *	by looking at our mate drive to see what it is capable of, before
+ *	choosing a mode for our own drive.
+ *
+ *	Note: This relies on the fact we never fail from UDMA to MWDMA2
+ *	but instead drop to PIO.
+ */
+
+static u8 cs5530_udma_filter(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	ide_drive_t *mate = &hwif->drives[(drive->dn & 1) ^ 1];
+	struct hd_driveid *mateid = mate->id;
+	u8 mask = hwif->ultra_mask;
+
+	if (mate->present == 0)
+		goto out;
+
+	if ((mateid->capability & 1) && __ide_dma_bad_drive(mate) == 0) {
+		if ((mateid->field_valid & 4) && (mateid->dma_ultra & 7))
+			goto out;
+		if ((mateid->field_valid & 2) && (mateid->dma_mword & 7))
+			mask = 0;
 	}
+out:
+	return mask;
 }
 
 /**
- *	cs5530_config_dma	-	select/set DMA and UDMA modes
+ *	cs5530_config_dma	-	set DMA/UDMA mode
  *	@drive: drive to tune
  *
- *	cs5530_config_dma() handles selection/setting of DMA/UDMA modes
- *	for both the chipset and drive. The CS5530 has limitations about
- *	mixing DMA/UDMA on the same cable.
+ *	cs5530_config_dma() handles setting of DMA/UDMA mode
+ *	for both the chipset and drive.
  */
- 
-static int cs5530_config_dma (ide_drive_t *drive)
+
+static int cs5530_config_dma(ide_drive_t *drive)
 {
-	int			udma_ok = 1, mode = 0;
-	ide_hwif_t		*hwif = HWIF(drive);
-	int			unit = drive->select.b.unit;
-	ide_drive_t		*mate = &hwif->drives[unit^1];
-	struct hd_driveid	*id = drive->id;
-	unsigned int		reg, timings = 0;
-	unsigned long		basereg;
+	if (ide_tune_dma(drive))
+		return 0;
 
-	/*
-	 * Default to DMA-off in case we run into trouble here.
-	 */
-	hwif->dma_off_quietly(drive);
+	return 1;
+}
 
-	/*
-	 * The CS5530 specifies that two drives sharing a cable cannot
-	 * mix UDMA/MDMA.  It has to be one or the other, for the pair,
-	 * though different timings can still be chosen for each drive.
-	 * We could set the appropriate timing bits on the fly,
-	 * but that might be a bit confusing.  So, for now we statically
-	 * handle this requirement by looking at our mate drive to see
-	 * what it is capable of, before choosing a mode for our own drive.
-	 *
-	 * Note: This relies on the fact we never fail from UDMA to MWDMA_2
-	 * but instead drop to PIO
-	 */
-	if (mate->present) {
-		struct hd_driveid *mateid = mate->id;
-		if (mateid && (mateid->capability & 1) &&
-		    !__ide_dma_bad_drive(mate)) {
-			if ((mateid->field_valid & 4) &&
-			    (mateid->dma_ultra & 7))
-				udma_ok = 1;
-			else if ((mateid->field_valid & 2) &&
-				 (mateid->dma_mword & 7))
-				udma_ok = 0;
-			else
-				udma_ok = 1;
-		}
-	}
+static int cs5530_tune_chipset(ide_drive_t *drive, u8 mode)
+{
+	unsigned long basereg;
+	unsigned int reg, timings = 0;
 
-	/*
-	 * Now see what the current drive is capable of,
-	 * selecting UDMA only if the mate said it was ok.
-	 */
-	if (id && (id->capability & 1) && drive->autodma &&
-	    !__ide_dma_bad_drive(drive)) {
-		if (udma_ok && (id->field_valid & 4) && (id->dma_ultra & 7)) {
-			if      (id->dma_ultra & 4)
-				mode = XFER_UDMA_2;
-			else if (id->dma_ultra & 2)
-				mode = XFER_UDMA_1;
-			else if (id->dma_ultra & 1)
-				mode = XFER_UDMA_0;
-		}
-		if (!mode && (id->field_valid & 2) && (id->dma_mword & 7)) {
-			if      (id->dma_mword & 4)
-				mode = XFER_MW_DMA_2;
-			else if (id->dma_mword & 2)
-				mode = XFER_MW_DMA_1;
-			else if (id->dma_mword & 1)
-				mode = XFER_MW_DMA_0;
-		}
-	}
+	mode = ide_rate_filter(drive, mode);
 
 	/*
 	 * Tell the drive to switch to the new mode; abort on failure.
 	 */
-	if (!mode || cs5530_set_xfer_mode(drive, mode))
+	if (cs5530_set_xfer_mode(drive, mode))
 		return 1;	/* failure */
 
 	/*
@@ -178,14 +166,21 @@ static int cs5530_config_dma (ide_drive_t *drive)
 		case XFER_MW_DMA_0:	timings = 0x00077771; break;
 		case XFER_MW_DMA_1:	timings = 0x00012121; break;
 		case XFER_MW_DMA_2:	timings = 0x00002020; break;
+		case XFER_PIO_4:
+		case XFER_PIO_3:
+		case XFER_PIO_2:
+		case XFER_PIO_1:
+		case XFER_PIO_0:
+			cs5530_tunepio(drive, mode - XFER_PIO_0);
+			return 0;
 		default:
 			BUG();
 			break;
 	}
-	basereg = CS5530_BASEREG(hwif);
+	basereg = CS5530_BASEREG(drive->hwif);
 	reg = inl(basereg + 4);			/* get drive0 config register */
 	timings |= reg & 0x80000000;		/* preserve PIO format bit */
-	if (unit == 0) {			/* are we configuring drive0? */
+	if ((drive-> dn & 1) == 0) {		/* are we configuring drive0? */
 		outl(timings, basereg + 4);	/* write drive0 config register */
 	} else {
 		if (timings & 0x00100000)
@@ -311,6 +306,8 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
 		hwif->serialized = hwif->mate->serialized = 1;
 
 	hwif->tuneproc = &cs5530_tuneproc;
+	hwif->speedproc = &cs5530_tune_chipset;
+
 	basereg = CS5530_BASEREG(hwif);
 	d0_timings = inl(basereg + 0);
 	if (CS5530_BAD_PIO(d0_timings)) {
@@ -332,6 +329,7 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
 	hwif->ultra_mask = 0x07;
 	hwif->mwdma_mask = 0x07;
 
+	hwif->udma_filter = cs5530_udma_filter;
 	hwif->ide_dma_check = &cs5530_config_dma;
 	if (!noautodma)
 		hwif->autodma = 1;
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 442f658..5faaff8 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -464,25 +464,6 @@ static int it821x_tune_chipset (ide_drive_t *drive, byte xferspeed)
 }
 
 /**
- *	config_chipset_for_dma	-	configure for DMA
- *	@drive: drive to configure
- *
- *	Called by the IDE layer when it wants the timings set up.
- */
-
-static int config_chipset_for_dma (ide_drive_t *drive)
-{
-	u8 speed = ide_max_dma_mode(drive);
-
-	if (speed == 0)
-		return 0;
-
-	it821x_tune_chipset(drive, speed);
-
-	return ide_dma_enable(drive);
-}
-
-/**
  *	it821x_configure_drive_for_dma	-	set up for DMA transfers
  *	@drive: drive we are going to set up
  *
@@ -494,7 +475,7 @@ static int config_chipset_for_dma (ide_drive_t *drive)
 
 static int it821x_config_drive_for_dma (ide_drive_t *drive)
 {
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	it821x_tuneproc(drive, 255);
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 65b1e12..cc0bfdc 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -228,38 +228,11 @@ static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
 	return get_indexed_reg(hwif, 0x0b) & 0x04;
 }
 
-static int config_chipset_for_dma(ide_drive_t *drive)
-{
-	struct hd_driveid *id	= drive->id;
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 speed;
-
-	if (id->capability & 4) {
-		/*
-		 * Set IORDY_EN & PREFETCH_EN (this seems to have
-		 * NO real effect since this register is reloaded
-		 * by hardware when the transfer mode is selected)
-		 */
-		u8 tmp, adj = (drive->dn & 1) ? 0x08 : 0x00;
-
-		tmp = get_indexed_reg(hwif, 0x13 + adj);
-		set_indexed_reg(hwif, 0x13 + adj, tmp | 0x03);
-	}
-
-	speed = ide_max_dma_mode(drive);
-
-	if (!speed)
-		return 0;
-
-	(void) hwif->speedproc(drive, speed);
-	return ide_dma_enable(drive);
-}
-
 static int pdcnew_config_drive_xfer_rate(ide_drive_t *drive)
 {
 	drive->init_speed = 0;
 
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index 7146fe3..2384468 100644
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
@@ -60,45 +61,7 @@ static const char *pdc_quirk_drives[] = {
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
@@ -107,52 +70,25 @@ static int pdc202xx_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	u8 drive_pci		= 0x60 + (drive->dn << 2);
 	u8 speed		= ide_rate_filter(drive, xferspeed);
 
-	u32			drive_conf;
-	u8			AP, BP, CP, DP;
+	u8			AP = 0, BP = 0, CP = 0;
 	u8			TA = 0, TB = 0, TC = 0;
 
-	if (drive->media != ide_disk &&
-		drive->media != ide_cdrom && speed < XFER_SW_DMA_0)
-		return -1;
-
+#if PDC202XX_DEBUG_DRIVE_INFO
+	u32			drive_conf = 0;
 	pci_read_config_dword(dev, drive_pci, &drive_conf);
-	pci_read_config_byte(dev, (drive_pci), &AP);
-	pci_read_config_byte(dev, (drive_pci)|0x01, &BP);
-	pci_read_config_byte(dev, (drive_pci)|0x02, &CP);
-	pci_read_config_byte(dev, (drive_pci)|0x03, &DP);
+#endif
 
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
+	/*
+	 * TODO: do this once per channel
+	 */
+	if (dev->device != PCI_DEVICE_ID_PROMISE_20246)
+		pdc_old_disable_66MHz_clock(hwif);
 
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
@@ -161,7 +97,7 @@ static int pdc202xx_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		case XFER_UDMA_0:
 		case XFER_MW_DMA_2:	TB = 0x60; TC = 0x03; break;
 		case XFER_MW_DMA_1:	TB = 0x60; TC = 0x04; break;
-		case XFER_MW_DMA_0:
+		case XFER_MW_DMA_0:	TB = 0xE0; TC = 0x0F; break;
 		case XFER_SW_DMA_2:	TB = 0x60; TC = 0x05; break;
 		case XFER_SW_DMA_1:	TB = 0x80; TC = 0x06; break;
 		case XFER_SW_DMA_0:	TB = 0xC0; TC = 0x0B; break;
@@ -174,25 +110,39 @@ static int pdc202xx_tune_chipset (ide_drive_t *drive, u8 xferspeed)
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
@@ -210,6 +160,8 @@ static u8 pdc202xx_old_cable_detect (ide_hwif_t *hwif)
  * Set the control register to use the 66MHz system
  * clock for UDMA 3/4/5 mode operation when necessary.
  *
+ * FIXME: this register is shared by both channels, some locking is needed
+ *
  * It may also be possible to leave the 66MHz clock on
  * and readjust the timing parameters.
  */
@@ -229,65 +181,11 @@ static void pdc_old_disable_66MHz_clock(ide_hwif_t *hwif)
 	outb(clock & ~(hwif->channel ? 0x08 : 0x02), clock_reg);
 }
 
-static int config_chipset_for_dma (ide_drive_t *drive)
-{
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
-
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
-		return 0;
-	}
-
-	(void) hwif->speedproc(drive, speed);
-	return ide_dma_enable(drive);
-}
-
 static int pdc202xx_config_drive_xfer_rate (ide_drive_t *drive)
 {
 	drive->init_speed = 0;
 
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index b5ae0c5..523363c 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -1,7 +1,9 @@
 /*
- * linux/drivers/ide/pci/sc1200.c		Version 0.91	28-Jan-2003
+ * linux/drivers/ide/pci/sc1200.c		Version 0.94	Mar 10 2007
  *
  * Copyright (C) 2000-2002		Mark Lord <mlord@pobox.com>
+ * Copyright (C)      2007		Bartlomiej Zolnierkiewicz
+ *
  * May be copied or modified under the terms of the GNU General Public License
  *
  * Development of this chipset driver was funded
@@ -93,64 +95,50 @@ static const unsigned int sc1200_pio_timings[4][5] =
  */
 //#define SC1200_BAD_PIO(timings) (((timings)&~0x80000000)==0x00009172)
 
-static int sc1200_autoselect_dma_mode (ide_drive_t *drive)
+static void sc1200_tunepio(ide_drive_t *drive, u8 pio)
 {
-	int			udma_ok = 1, mode = 0;
-	ide_hwif_t		*hwif = HWIF(drive);
-	int			unit = drive->select.b.unit;
-	ide_drive_t		*mate = &hwif->drives[unit^1];
-	struct hd_driveid	*id = drive->id;
-
-	/*
-	 * The SC1200 specifies that two drives sharing a cable cannot
-	 * mix UDMA/MDMA.  It has to be one or the other, for the pair,
-	 * though different timings can still be chosen for each drive.
-	 * We could set the appropriate timing bits on the fly,
-	 * but that might be a bit confusing.  So, for now we statically
-	 * handle this requirement by looking at our mate drive to see
-	 * what it is capable of, before choosing a mode for our own drive.
-	 */
-	if (mate->present) {
-		struct hd_driveid *mateid = mate->id;
-		if (mateid && (mateid->capability & 1) && !__ide_dma_bad_drive(mate)) {
-			if ((mateid->field_valid & 4) && (mateid->dma_ultra & 7))
-				udma_ok = 1;
-			else if ((mateid->field_valid & 2) && (mateid->dma_mword & 7))
-				udma_ok = 0;
-			else
-				udma_ok = 1;
-		}
-	}
-	/*
-	 * Now see what the current drive is capable of,
-	 * selecting UDMA only if the mate said it was ok.
-	 */
-	if (id && (id->capability & 1) && hwif->autodma && !__ide_dma_bad_drive(drive)) {
-		if (udma_ok && (id->field_valid & 4) && (id->dma_ultra & 7)) {
-			if      (id->dma_ultra & 4)
-				mode = XFER_UDMA_2;
-			else if (id->dma_ultra & 2)
-				mode = XFER_UDMA_1;
-			else if (id->dma_ultra & 1)
-				mode = XFER_UDMA_0;
-		}
-		if (!mode && (id->field_valid & 2) && (id->dma_mword & 7)) {
-			if      (id->dma_mword & 4)
-				mode = XFER_MW_DMA_2;
-			else if (id->dma_mword & 2)
-				mode = XFER_MW_DMA_1;
-			else if (id->dma_mword & 1)
-				mode = XFER_MW_DMA_0;
-		}
-	}
-	return mode;
+	ide_hwif_t *hwif = drive->hwif;
+	struct pci_dev *pdev = hwif->pci_dev;
+	unsigned int basereg = hwif->channel ? 0x50 : 0x40, format = 0;
+
+	pci_read_config_dword(pdev, basereg + 4, &format);
+	format = (format >> 31) & 1;
+	if (format)
+		format += sc1200_get_pci_clock();
+	pci_write_config_dword(pdev, basereg + ((drive->dn & 1) << 3),
+			       sc1200_pio_timings[format][pio]);
 }
 
 /*
- * sc1200_config_dma2() handles selection/setting of DMA/UDMA modes
- * for both the chipset and drive.
+ *	The SC1200 specifies that two drives sharing a cable cannot mix
+ *	UDMA/MDMA.  It has to be one or the other, for the pair, though
+ *	different timings can still be chosen for each drive.  We could
+ *	set the appropriate timing bits on the fly, but that might be
+ *	a bit confusing.  So, for now we statically handle this requirement
+ *	by looking at our mate drive to see what it is capable of, before
+ *	choosing a mode for our own drive.
  */
-static int sc1200_config_dma2 (ide_drive_t *drive, int mode)
+static u8 sc1200_udma_filter(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	ide_drive_t *mate = &hwif->drives[(drive->dn & 1) ^ 1];
+	struct hd_driveid *mateid = mate->id;
+	u8 mask = hwif->ultra_mask;
+
+	if (mate->present == 0)
+		goto out;
+
+	if ((mateid->capability & 1) && __ide_dma_bad_drive(mate) == 0) {
+		if ((mateid->field_valid & 4) && (mateid->dma_ultra & 7))
+			goto out;
+		if ((mateid->field_valid & 2) && (mateid->dma_mword & 7))
+			mask = 0;
+	}
+out:
+	return mask;
+}
+
+static int sc1200_tune_chipset(ide_drive_t *drive, u8 mode)
 {
 	ide_hwif_t		*hwif = HWIF(drive);
 	int			unit = drive->select.b.unit;
@@ -158,20 +146,26 @@ static int sc1200_config_dma2 (ide_drive_t *drive, int mode)
 	unsigned short		pci_clock;
 	unsigned int		basereg = hwif->channel ? 0x50 : 0x40;
 
-	/*
-	 * Default to DMA-off in case we run into trouble here.
-	 */
-	hwif->dma_off_quietly(drive);	/* turn off DMA while we fiddle */
-	outb(inb(hwif->dma_base+2)&~(unit?0x40:0x20), hwif->dma_base+2); /* clear DMA_capable bit */
+	mode = ide_rate_filter(drive, mode);
 
 	/*
 	 * Tell the drive to switch to the new mode; abort on failure.
 	 */
-	if (!mode || sc1200_set_xfer_mode(drive, mode)) {
+	if (sc1200_set_xfer_mode(drive, mode)) {
 		printk("SC1200: set xfer mode failure\n");
 		return 1;	/* failure */
 	}
 
+	switch (mode) {
+	case XFER_PIO_4:
+	case XFER_PIO_3:
+	case XFER_PIO_2:
+	case XFER_PIO_1:
+	case XFER_PIO_0:
+		sc1200_tunepio(drive, mode - XFER_PIO_0);
+		return 0;
+	}
+
 	pci_clock = sc1200_get_pci_clock();
 
 	/*
@@ -224,11 +218,9 @@ static int sc1200_config_dma2 (ide_drive_t *drive, int mode)
 				case PCI_CLK_66:	timings = 0x00015151;	break;
 			}
 			break;
-	}
-
-	if (timings == 0) {
-		printk("%s: sc1200_config_dma: huh? mode=%02x clk=%x \n", drive->name, mode, pci_clock);
-		return 1;	/* failure */
+		default:
+			BUG();
+			break;
 	}
 
 	if (unit == 0) {			/* are we configuring drive0? */
@@ -239,8 +231,6 @@ static int sc1200_config_dma2 (ide_drive_t *drive, int mode)
 		pci_write_config_dword(hwif->pci_dev, basereg+12, timings);
 	}
 
-	outb(inb(hwif->dma_base+2)|(unit?0x40:0x20), hwif->dma_base+2);	/* set DMA_capable bit */
-
 	return 0;	/* success */
 }
 
@@ -250,7 +240,10 @@ static int sc1200_config_dma2 (ide_drive_t *drive, int mode)
  */
 static int sc1200_config_dma (ide_drive_t *drive)
 {
-	return sc1200_config_dma2(drive, sc1200_autoselect_dma_mode(drive));
+	if (ide_tune_dma(drive))
+		return 0;
+
+	return 1;
 }
 
 
@@ -290,10 +283,11 @@ static int sc1200_ide_dma_end (ide_drive_t *drive)
 static void sc1200_tuneproc (ide_drive_t *drive, byte pio)	/* mode=255 means "autotune" */
 {
 	ide_hwif_t	*hwif = HWIF(drive);
-	unsigned int	format;
-	static byte	modes[5] = {XFER_PIO_0, XFER_PIO_1, XFER_PIO_2, XFER_PIO_3, XFER_PIO_4};
 	int		mode = -1;
 
+	/*
+	 * bad abuse of ->tuneproc interface
+	 */
 	switch (pio) {
 		case 200: mode = XFER_UDMA_0;	break;
 		case 201: mode = XFER_UDMA_1;	break;
@@ -304,20 +298,17 @@ static void sc1200_tuneproc (ide_drive_t *drive, byte pio)	/* mode=255 means "au
 	}
 	if (mode != -1) {
 		printk("SC1200: %s: changing (U)DMA mode\n", drive->name);
-		(void)sc1200_config_dma2(drive, mode);
+		hwif->dma_off_quietly(drive);
+		if (sc1200_tune_chipset(drive, mode) == 0)
+			hwif->dma_host_on(drive);
 		return;
 	}
 
 	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
 	printk("SC1200: %s: setting PIO mode%d\n", drive->name, pio);
-	if (!sc1200_set_xfer_mode(drive, modes[pio])) {
-		unsigned int basereg = hwif->channel ? 0x50 : 0x40;
-		pci_read_config_dword (hwif->pci_dev, basereg+4, &format);
-		format = (format >> 31) & 1;
-		if (format)
-			format += sc1200_get_pci_clock();
-		pci_write_config_dword(hwif->pci_dev, basereg + (drive->select.b.unit << 3), sc1200_pio_timings[format][pio]);
- 	}
+
+	if (sc1200_set_xfer_mode(drive, XFER_PIO_0 + pio) == 0)
+		sc1200_tunepio(drive, pio);
 }
 
 #ifdef CONFIG_PM
@@ -438,12 +429,12 @@ static int sc1200_resume (struct pci_dev *dev)
 		for (d = 0; d < MAX_DRIVES; ++d) {
 			ide_drive_t *drive = &(hwif->drives[d]);
 			if (drive->present && !__ide_dma_bad_drive(drive)) {
-				int was_using_dma = drive->using_dma;
+				int enable_dma = drive->using_dma;
 				hwif->dma_off_quietly(drive);
-				sc1200_config_dma(drive);
-				if (!was_using_dma && drive->using_dma) {
-					hwif->dma_off_quietly(drive);
-				}
+				if (sc1200_config_dma(drive))
+					enable_dma = 0;
+				if (enable_dma)
+					hwif->dma_host_on(drive);
 			}
 		}
 	}
@@ -461,11 +452,13 @@ static void __devinit init_hwif_sc1200 (ide_hwif_t *hwif)
 		hwif->serialized = hwif->mate->serialized = 1;
 	hwif->autodma = 0;
 	if (hwif->dma_base) {
+		hwif->udma_filter = sc1200_udma_filter;
 		hwif->ide_dma_check = &sc1200_config_dma;
 		hwif->ide_dma_end   = &sc1200_ide_dma_end;
         	if (!noautodma)
                 	hwif->autodma = 1;
 		hwif->tuneproc = &sc1200_tuneproc;
+		hwif->speedproc = &sc1200_tune_chipset;
 	}
         hwif->atapi_dma = 1;
         hwif->ultra_mask = 0x07;
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index cbf9363..55bc0a3 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -322,26 +322,6 @@ static int scc_tune_chipset(ide_drive_t *drive, byte xferspeed)
 }
 
 /**
- *	scc_config_chipset_for_dma	-	configure for DMA
- *	@drive: drive to configure
- *
- *	Called by scc_config_drive_for_dma().
- */
-
-static int scc_config_chipset_for_dma(ide_drive_t *drive)
-{
-	u8 speed = ide_max_dma_mode(drive);
-
-	if (!speed)
-		return 0;
-
-	if (scc_tune_chipset(drive, speed))
-		return 0;
-
-	return ide_dma_enable(drive);
-}
-
-/**
  *	scc_configure_drive_for_dma	-	set up for DMA transfers
  *	@drive: drive we are going to set up
  *
@@ -354,7 +334,7 @@ static int scc_config_chipset_for_dma(ide_drive_t *drive)
 
 static int scc_config_drive_for_dma(ide_drive_t *drive)
 {
-	if (ide_use_dma(drive) && scc_config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index 2fa6d92..6234f80 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -1,9 +1,10 @@
 /*
- * linux/drivers/ide/pci/serverworks.c		Version 0.8	 25 Ebr 2003
+ * linux/drivers/ide/pci/serverworks.c		Version 0.9	Mar 4 2007
  *
  * Copyright (C) 1998-2000 Michel Aubry
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
  * Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
+ * Copyright (C)      2007 Bartlomiej Zolnierkiewicz
  * Portions copyright (c) 2001 Sun Microsystems
  *
  *
@@ -136,19 +137,14 @@ static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-	u8 speed;
-	u8 pio			= ide_get_best_pio_mode(drive, 255, 5, NULL);
+	u8 speed		= ide_rate_filter(drive, xferspeed);
+	u8 pio			= ide_get_best_pio_mode(drive, 255, 4, NULL);
 	u8 unit			= (drive->select.b.unit & 0x01);
 	u8 csb5			= svwks_csb_check(dev);
 	u8 ultra_enable		= 0, ultra_timing = 0;
 	u8 dma_timing		= 0, pio_timing = 0;
 	u16 csb5_pio		= 0;
 
-	if (xferspeed == 255)	/* PIO auto-tuning */
-		speed = XFER_PIO_0 + pio;
-	else
-		speed = ide_rate_filter(drive, xferspeed);
-
 	/* If we are about to put a disk into UDMA mode we screwed up.
 	   Our code assumes we never _ever_ do this on an OSB4 */
 	   
@@ -231,6 +227,9 @@ oem_setup_failed:
 		case XFER_MW_DMA_2:
 		case XFER_MW_DMA_1:
 		case XFER_MW_DMA_0:
+			/*
+			 * TODO: always setup PIO mode so this won't be needed
+			 */
 			pio_timing |= pio_modes[pio];
 			csb5_pio   |= (pio << (4*drive->dn));
 			dma_timing |= dma_modes[speed - XFER_MW_DMA_0];
@@ -242,6 +241,9 @@ oem_setup_failed:
 		case XFER_UDMA_2:
 		case XFER_UDMA_1:
 		case XFER_UDMA_0:
+			/*
+			 * TODO: always setup PIO mode so this won't be needed
+			 */
 			pio_timing   |= pio_modes[pio];
 			csb5_pio     |= (pio << (4*drive->dn));
 			dma_timing   |= dma_modes[2];
@@ -262,72 +264,21 @@ oem_setup_failed:
 	return (ide_config_drive_speed(drive, speed));
 }
 
-static void config_chipset_for_pio (ide_drive_t *drive)
-{
-	u16 eide_pio_timing[6] = {960, 480, 240, 180, 120, 90};
-	u16 xfer_pio = drive->id->eide_pio_modes;
-	u8 timing, speed, pio;
-
-	pio = ide_get_best_pio_mode(drive, 255, 5, NULL);
-
-	if (xfer_pio > 4)
-		xfer_pio = 0;
-
-	if (drive->id->eide_pio_iordy > 0)
-		for (xfer_pio = 5;
-			xfer_pio>0 &&
-			drive->id->eide_pio_iordy>eide_pio_timing[xfer_pio];
-			xfer_pio--);
-	else
-		xfer_pio = (drive->id->eide_pio_modes & 4) ? 0x05 :
-			   (drive->id->eide_pio_modes & 2) ? 0x04 :
-			   (drive->id->eide_pio_modes & 1) ? 0x03 :
-			   (drive->id->tPIO & 2) ? 0x02 :
-			   (drive->id->tPIO & 1) ? 0x01 : xfer_pio;
-
-	timing = (xfer_pio >= pio) ? xfer_pio : pio;
-
-	switch(timing) {
-		case 4: speed = XFER_PIO_4;break;
-		case 3: speed = XFER_PIO_3;break;
-		case 2: speed = XFER_PIO_2;break;
-		case 1: speed = XFER_PIO_1;break;
-		default:
-			speed = (!drive->id->tPIO) ? XFER_PIO_0 : XFER_PIO_SLOW;
-			break;
-	}
-	(void) svwks_tune_chipset(drive, speed);
-	drive->current_speed = speed;
-}
-
 static void svwks_tune_drive (ide_drive_t *drive, u8 pio)
 {
-	if(pio == 255)
-		(void) svwks_tune_chipset(drive, 255);
-	else
-		(void) svwks_tune_chipset(drive, (XFER_PIO_0 + pio));
-}
-
-static int config_chipset_for_dma (ide_drive_t *drive)
-{
-	u8 speed = ide_max_dma_mode(drive);
-
-	if (!(speed))
-		speed = XFER_PIO_0 + ide_get_best_pio_mode(drive, 255, 5, NULL);
-
-	(void) svwks_tune_chipset(drive, speed);
-	return ide_dma_enable(drive);
+	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	(void)svwks_tune_chipset(drive, XFER_PIO_0 + pio);
 }
 
 static int svwks_config_drive_xfer_rate (ide_drive_t *drive)
 {
 	drive->init_speed = 0;
 
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		config_chipset_for_pio(drive);
+		svwks_tune_drive(drive, 255);
 
 	return -1;
 }
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index d09e74c..1a4444e 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -375,28 +375,6 @@ static int siimage_tune_chipset (ide_drive_t *drive, byte xferspeed)
 }
 
 /**
- *	config_chipset_for_dma	-	configure for DMA
- *	@drive: drive to configure
- *
- *	Called by the IDE layer when it wants the timings set up.
- *	For the CMD680 we also need to set up the PIO timings and
- *	enable DMA.
- */
- 
-static int config_chipset_for_dma (ide_drive_t *drive)
-{
-	u8 speed = ide_max_dma_mode(drive);
-
-	if (!speed)
-		return 0;
-
-	if (siimage_tune_chipset(drive, speed))
-		return 0;
-
-	return ide_dma_enable(drive);
-}
-
-/**
  *	siimage_configure_drive_for_dma	-	set up for DMA transfers
  *	@drive: drive we are going to set up
  *
@@ -408,7 +386,7 @@ static int config_chipset_for_dma (ide_drive_t *drive)
  
 static int siimage_config_drive_for_dma (ide_drive_t *drive)
 {
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 2bde1b9..bb6cc4a 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -1,9 +1,11 @@
 /*
- * linux/drivers/ide/pci/sis5513.c	Version 0.16ac+vp	Jun 18, 2003
+ * linux/drivers/ide/pci/sis5513.c	Version 0.20	Mar 4, 2007
  *
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2002		Lionel Bouton <Lionel.Bouton@inet6.fr>, Maintainer
  * Copyright (C) 2003		Vojtech Pavlik <vojtech@suse.cz>
+ * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
+ *
  * May be copied or modified under the terms of the GNU General Public License
  *
  *
@@ -448,36 +450,15 @@ static void config_drive_art_rwp (ide_drive_t *drive)
 		pci_write_config_byte(dev, 0x4b, reg4bh|rw_prefetch);
 }
 
-
 /* Set per-drive active and recovery time */
 static void config_art_rwp_pio (ide_drive_t *drive, u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 
-	u8			timing, drive_pci, test1, test2;
-
-	u16 eide_pio_timing[6] = {600, 390, 240, 180, 120, 90};
-	u16 xfer_pio = drive->id->eide_pio_modes;
+	u8 drive_pci, test1, test2;
 
 	config_drive_art_rwp(drive);
-	pio = ide_get_best_pio_mode(drive, 255, pio, NULL);
-
-	if (xfer_pio> 4)
-		xfer_pio = 0;
-
-	if (drive->id->eide_pio_iordy > 0) {
-		for (xfer_pio = 5;
-			(xfer_pio > 0) &&
-			(drive->id->eide_pio_iordy > eide_pio_timing[xfer_pio]);
-			xfer_pio--);
-	} else {
-		xfer_pio = (drive->id->eide_pio_modes & 4) ? 0x05 :
-			   (drive->id->eide_pio_modes & 2) ? 0x04 :
-			   (drive->id->eide_pio_modes & 1) ? 0x03 : xfer_pio;
-	}
-
-	timing = (xfer_pio >= pio) ? xfer_pio : pio;
 
 	/* In pre ATA_133 case, drives sit at 0x40 + 4*drive->dn */
 	drive_pci = 0x40;
@@ -500,17 +481,18 @@ static void config_art_rwp_pio (ide_drive_t *drive, u8 pio)
 		test1 &= ~0x0F;
 		test2 &= ~0x07;
 
-		switch(timing) {
+		switch(pio) {
 			case 4:		test1 |= 0x01; test2 |= 0x03; break;
 			case 3:		test1 |= 0x03; test2 |= 0x03; break;
 			case 2:		test1 |= 0x04; test2 |= 0x04; break;
 			case 1:		test1 |= 0x07; test2 |= 0x06; break;
+			case 0:		/* PIO0: register setting == X000 */
 			default:	break;
 		}
 		pci_write_config_byte(dev, drive_pci, test1);
 		pci_write_config_byte(dev, drive_pci+1, test2);
 	} else if (chipset_family < ATA_133) {
-		switch(timing) { /*		active  recovery
+		switch(pio) { /*		active  recovery
 						  v     v */
 			case 4:		test1 = 0x30|0x01; break;
 			case 3:		test1 = 0x30|0x03; break;
@@ -525,24 +507,28 @@ static void config_art_rwp_pio (ide_drive_t *drive, u8 pio)
 		pci_read_config_dword(dev, drive_pci, &test3);
 		test3 &= 0xc0c00fff;
 		if (test3 & 0x08) {
-			test3 |= (unsigned long)ini_time_value[ATA_133][timing] << 12;
-			test3 |= (unsigned long)act_time_value[ATA_133][timing] << 16;
-			test3 |= (unsigned long)rco_time_value[ATA_133][timing] << 24;
+			test3 |= ini_time_value[ATA_133][pio] << 12;
+			test3 |= act_time_value[ATA_133][pio] << 16;
+			test3 |= rco_time_value[ATA_133][pio] << 24;
 		} else {
-			test3 |= (unsigned long)ini_time_value[ATA_100][timing] << 12;
-			test3 |= (unsigned long)act_time_value[ATA_100][timing] << 16;
-			test3 |= (unsigned long)rco_time_value[ATA_100][timing] << 24;
+			test3 |= ini_time_value[ATA_100][pio] << 12;
+			test3 |= act_time_value[ATA_100][pio] << 16;
+			test3 |= rco_time_value[ATA_100][pio] << 24;
 		}
 		pci_write_config_dword(dev, drive_pci, test3);
 	}
 }
 
-static int config_chipset_for_pio (ide_drive_t *drive, u8 pio)
+static int sis5513_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	if (pio == 255)
-		pio = ide_find_best_mode(drive, XFER_PIO | XFER_EPIO) - XFER_PIO_0;
+	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
 	config_art_rwp_pio(drive, pio);
-	return ide_config_drive_speed(drive, XFER_PIO_0 + min_t(u8, pio, 4));
+	return ide_config_drive_speed(drive, XFER_PIO_0 + pio);
+}
+
+static void sis5513_tuneproc(ide_drive_t *drive, u8 pio)
+{
+	(void)sis5513_tune_drive(drive, pio);
 }
 
 static int sis5513_tune_chipset (ide_drive_t *drive, u8 xferspeed)
@@ -622,25 +608,26 @@ static int sis5513_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		case XFER_SW_DMA_1:
 		case XFER_SW_DMA_0:
 			break;
-		case XFER_PIO_4: return((int) config_chipset_for_pio(drive, 4));
-		case XFER_PIO_3: return((int) config_chipset_for_pio(drive, 3));
-		case XFER_PIO_2: return((int) config_chipset_for_pio(drive, 2));
-		case XFER_PIO_1: return((int) config_chipset_for_pio(drive, 1));
+		case XFER_PIO_4:
+		case XFER_PIO_3:
+		case XFER_PIO_2:
+		case XFER_PIO_1:
 		case XFER_PIO_0:
-		default:	 return((int) config_chipset_for_pio(drive, 0));	
+			return sis5513_tune_drive(drive, speed - XFER_PIO_0);
+		default:
+			BUG();
+			break;
 	}
 
-	return ((int) ide_config_drive_speed(drive, speed));
-}
-
-static void sis5513_tune_drive (ide_drive_t *drive, u8 pio)
-{
-	(void) config_chipset_for_pio(drive, pio);
+	return ide_config_drive_speed(drive, speed);
 }
 
 static int sis5513_config_xfer_rate(ide_drive_t *drive)
 {
-	config_art_rwp_pio(drive, 5);
+	/*
+	 * TODO: always set PIO mode and remove this
+	 */
+	sis5513_tuneproc(drive, 255);
 
 	drive->init_speed = 0;
 
@@ -648,7 +635,7 @@ static int sis5513_config_xfer_rate(ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		sis5513_tune_drive(drive, 5);
+		sis5513_tuneproc(drive, 255);
 
 	return -1;
 }
@@ -836,7 +823,7 @@ static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 	if (!hwif->irq)
 		hwif->irq = hwif->channel ? 15 : 14;
 
-	hwif->tuneproc = &sis5513_tune_drive;
+	hwif->tuneproc = &sis5513_tuneproc;
 	hwif->speedproc = &sis5513_tune_chipset;
 
 	if (!(hwif->dma_base)) {
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index fe3b4b9..7c383d9 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -82,7 +82,14 @@ static u8 sl82c105_tune_pio(ide_drive_t *drive, u8 pio)
 
 	pio = ide_get_best_pio_mode(drive, pio, 5, &p);
 
-	drive->drive_data = drv_ctrl = get_pio_timings(&p);
+	drv_ctrl = get_pio_timings(&p);
+
+	/*
+	 * Store the PIO timings so that we can restore them
+	 * in case DMA will be turned off...
+	 */
+	drive->drive_data &= 0xffff0000;
+	drive->drive_data |= drv_ctrl;
 
 	if (!drive->using_dma) {
 		/*
@@ -100,17 +107,55 @@ static u8 sl82c105_tune_pio(ide_drive_t *drive, u8 pio)
 }
 
 /*
- * Configure the drive for DMA.
- * We'll program the chipset only when DMA is actually turned on.
+ * Configure the drive and chipset for a new transfer speed.
  */
-static int config_for_dma(ide_drive_t *drive)
+static int sl82c105_tune_chipset(ide_drive_t *drive, u8 speed)
 {
-	DBG(("config_for_dma(drive:%s)\n", drive->name));
+	static u16 mwdma_timings[] = {0x0707, 0x0201, 0x0200};
+	u16 drv_ctrl;
 
-	if (ide_config_drive_speed(drive, XFER_MW_DMA_2) != 0)
-		return 0;
+ 	DBG(("sl82c105_tune_chipset(drive:%s, speed:%s)\n",
+	     drive->name, ide_xfer_verbose(speed)));
 
-	return ide_dma_enable(drive);
+	speed = ide_rate_filter(drive, speed);
+
+	switch (speed) {
+	case XFER_MW_DMA_2:
+	case XFER_MW_DMA_1:
+	case XFER_MW_DMA_0:
+		drv_ctrl = mwdma_timings[speed - XFER_MW_DMA_0];
+
+		/*
+		 * Store the DMA timings so that we can actually program
+		 * them when DMA will be turned on...
+		 */
+		drive->drive_data &= 0x0000ffff;
+		drive->drive_data |= (unsigned long)drv_ctrl << 16;
+
+		/*
+		 * If we are already using DMA, we just reprogram
+		 * the drive control register.
+		 */
+		if (drive->using_dma) {
+			struct pci_dev *dev	= HWIF(drive)->pci_dev;
+			int reg 		= 0x44 + drive->dn * 4;
+
+			pci_write_config_word(dev, reg, drv_ctrl);
+		}
+		break;
+	case XFER_PIO_5:
+	case XFER_PIO_4:
+	case XFER_PIO_3:
+	case XFER_PIO_2:
+	case XFER_PIO_1:
+	case XFER_PIO_0:
+		(void) sl82c105_tune_pio(drive, speed - XFER_PIO_0);
+		break;
+	default:
+		return -1;
+	}
+
+	return ide_config_drive_speed(drive, speed);
 }
 
 /*
@@ -120,7 +165,7 @@ static int sl82c105_ide_dma_check(ide_drive_t *drive)
 {
 	DBG(("sl82c105_ide_dma_check(drive:%s)\n", drive->name));
 
-	if (ide_use_dma(drive) && config_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	return -1;
@@ -219,7 +264,7 @@ static int sl82c105_ide_dma_on(ide_drive_t *drive)
 
 	rc = __ide_dma_on(drive);
 	if (rc == 0) {
-		pci_write_config_word(dev, reg, 0x0200);
+		pci_write_config_word(dev, reg, drive->drive_data >> 16);
 
 		printk(KERN_INFO "%s: DMA enabled\n", drive->name);
 	}
@@ -304,7 +349,7 @@ static unsigned int sl82c105_bridge_revision(struct pci_dev *dev)
 	/*
 	 * The bridge should be part of the same device, but function 0.
 	 */
-	bridge = pci_find_slot(dev->bus->number,
+	bridge = pci_get_bus_and_slot(dev->bus->number,
 			       PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
 	if (!bridge)
 		return -1;
@@ -314,13 +359,15 @@ static unsigned int sl82c105_bridge_revision(struct pci_dev *dev)
 	 */
 	if (bridge->vendor != PCI_VENDOR_ID_WINBOND ||
 	    bridge->device != PCI_DEVICE_ID_WINBOND_83C553 ||
-	    bridge->class >> 8 != PCI_CLASS_BRIDGE_ISA)
+	    bridge->class >> 8 != PCI_CLASS_BRIDGE_ISA) {
+	    	pci_dev_put(bridge);
 		return -1;
-
+	}
 	/*
 	 * We need to find function 0's revision, not function 1
 	 */
 	pci_read_config_byte(bridge, PCI_REVISION_ID, &rev);
+	pci_dev_put(bridge);
 
 	return rev;
 }
@@ -357,6 +404,7 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 	DBG(("init_hwif_sl82c105(hwif: ide%d)\n", hwif->index));
 
 	hwif->tuneproc		= &sl82c105_tune_drive;
+	hwif->speedproc 	= &sl82c105_tune_chipset;
 	hwif->selectproc	= &sl82c105_selectproc;
 	hwif->resetproc 	= &sl82c105_resetproc;
 
@@ -388,7 +436,7 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 	}
 
 	hwif->atapi_dma  = 1;
-	hwif->mwdma_mask = 0x04;
+	hwif->mwdma_mask = 0x07;
 
 	hwif->ide_dma_check		= &sl82c105_ide_dma_check;
 	hwif->ide_dma_on		= &sl82c105_ide_dma_on;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index df4e6a5..07aba87 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1281,7 +1281,6 @@ struct drive_list_entry {
 int ide_in_drive_list(struct hd_driveid *, const struct drive_list_entry *);
 int __ide_dma_bad_drive(ide_drive_t *);
 int __ide_dma_good_drive(ide_drive_t *);
-int ide_use_dma(ide_drive_t *);
 u8 ide_max_dma_mode(ide_drive_t *);
 int ide_tune_dma(ide_drive_t *);
 void ide_dma_off(ide_drive_t *);
@@ -1309,7 +1308,6 @@ extern int __ide_dma_timeout(ide_drive_t *);
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
 #else
-static inline int ide_use_dma(ide_drive_t *drive) { return 0; }
 static inline u8 ide_max_dma_mode(ide_drive_t *drive) { return 0; }
 static inline int ide_tune_dma(ide_drive_t *drive) { return 0; }
 static inline void ide_dma_off(ide_drive_t *drive) { ; }
@@ -1357,7 +1355,6 @@ static inline void ide_set_hwifdata (ide_hwif_t * hwif, void *data)
 
 /* ide-lib.c */
 u8 ide_rate_filter(ide_drive_t *, u8);
-extern int ide_dma_enable(ide_drive_t *drive);
 extern char *ide_xfer_verbose(u8 xfer_rate);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
 extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);

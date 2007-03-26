Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbXCZVEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbXCZVEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXCZVEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:04:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:33160 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbXCZVEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WK4SwD1ZB0/Uam+xdlk8g6pxHgkKs8viq7pKF3mn1jvvzLSTwACj/awjBCBJ7dzz8qdG2LGKcYBnaG9aKXxSLQu6q0trzNYZ2wLWqsHpdd3haiI7zW2n8nNFOH35Umhl9c2SC/hJFGS1m+4R3zLkHiILL4iMKtDhYF2VksE1MnM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes for 2.6.21-rc5
Date: Mon, 26 Mar 2007 23:11:55 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703262311.55728.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig            |    6 ++++--
 drivers/ide/ide-io.c           |   32 +++++++++++++++++++++-----------
 drivers/ide/ide-iops.c         |   11 +++++++++--
 drivers/ide/ide.c              |   37 ++++++++++++++++++++++++++++++-------
 drivers/ide/pci/pdc202xx_new.c |    3 ++-
 include/linux/ide.h            |    1 +
 6 files changed, 67 insertions(+), 23 deletions(-)


Albert Lee (1):
      pdc202xx_new: Enable ATAPI DMA

Bartlomiej Zolnierkiewicz (2):
      ide: revert "ide: fix drive side 80c cable check, take 2" for now
      ide: fix locking for manual DMA enable/disable ("hdparm -d")

Patrick Ringl (1):
      ide: cosmetic adaption of drivers/ide/Kconfig concerning SATA

Suleiman Souhlal (1):
      ide: use correct IDE error recovery


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 8f1fd01..ca2e4f8 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -103,8 +103,10 @@ config BLK_DEV_IDE_SATA
 	---help---
 	  There are two drivers for Serial ATA controllers.
 
-	  The main driver, "libata", exists inside the SCSI subsystem
-	  and supports most modern SATA controllers.
+	  The main driver, "libata", uses the SCSI subsystem
+	  and supports most modern SATA controllers. In order to use it
+	  you may take a look at "Serial ATA (prod) and Parallel ATA
+	  (experimental) drivers".
 
 	  The IDE driver (which you are currently configuring) supports
 	  a few first-generation SATA controllers.
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c193553..0e02800 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -519,21 +519,24 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ && hwif->err_stops_fifo == 0)
 		try_to_flush_leftover_data(drive);
 
+	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
+		ide_kill_rq(drive, rq);
+		return ide_stopped;
+	}
+
 	if (hwif->INB(IDE_STATUS_REG) & (BUSY_STAT|DRQ_STAT))
-		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE, IDE_COMMAND_REG);
+		rq->errors |= ERROR_RESET;
 
-	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq))
-		ide_kill_rq(drive, rq);
-	else {
-		if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
-			++rq->errors;
-			return ide_do_reset(drive);
-		}
-		if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
-			drive->special.b.recalibrate = 1;
+	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
 		++rq->errors;
+		return ide_do_reset(drive);
 	}
+
+	if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
+		drive->special.b.recalibrate = 1;
+
+	++rq->errors;
+
 	return ide_stopped;
 }
 
@@ -1025,6 +1028,13 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 	if (!drive->special.all) {
 		ide_driver_t *drv;
 
+		/*
+		 * We reset the drive so we need to issue a SETFEATURES.
+		 * Do it _after_ do_special() restored device parameters.
+		 */
+		if (drive->current_speed == 0xff)
+			ide_config_drive_speed(drive, drive->desired_speed);
+
 		if (rq->cmd_type == REQ_TYPE_ATA_CMD ||
 		    rq->cmd_type == REQ_TYPE_ATA_TASK ||
 		    rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index bd513f5..1ee53a5 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -583,8 +583,12 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 	if(!(drive->id->hw_config & 0x4000))
 		return 0;
 #endif /* CONFIG_IDEDMA_IVB */
-	if (!(drive->id->hw_config & 0x2000))
-		return 0;
+	/*
+	 * FIXME:
+	 * - change master/slave IDENTIFY order
+	 * - force bit13 (80c cable present) check
+	 *   (unless the slave device is pre-ATA3)
+	 */
 	return 1;
 }
 
@@ -1090,6 +1094,9 @@ static void pre_reset(ide_drive_t *drive)
 	if (HWIF(drive)->pre_reset != NULL)
 		HWIF(drive)->pre_reset(drive);
 
+	if (drive->current_speed != 0xff)
+		drive->desired_speed = drive->current_speed;
+	drive->current_speed = 0xff;
 }
 
 /*
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 695610f..a6f098f 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1124,17 +1124,40 @@ static int set_io_32bit(ide_drive_t *drive, int arg)
 static int set_using_dma (ide_drive_t *drive, int arg)
 {
 #ifdef CONFIG_BLK_DEV_IDEDMA
+	ide_hwif_t *hwif = drive->hwif;
+	int err = -EPERM;
+
 	if (!drive->id || !(drive->id->capability & 1))
-		return -EPERM;
-	if (HWIF(drive)->ide_dma_check == NULL)
-		return -EPERM;
+		goto out;
+
+	if (hwif->ide_dma_check == NULL)
+		goto out;
+
+	err = -EBUSY;
+	if (ide_spin_wait_hwgroup(drive))
+		goto out;
+	/*
+	 * set ->busy flag, unlock and let it ride
+	 */
+	hwif->hwgroup->busy = 1;
+	spin_unlock_irq(&ide_lock);
+
+	err = 0;
+
 	if (arg) {
-		if (ide_set_dma(drive))
-			return -EIO;
-		if (HWIF(drive)->ide_dma_on(drive)) return -EIO;
+		if (ide_set_dma(drive) || hwif->ide_dma_on(drive))
+			err = -EIO;
 	} else
 		ide_dma_off(drive);
-	return 0;
+
+	/*
+	 * lock, clear ->busy flag and unlock before leaving
+	 */
+	spin_lock_irq(&ide_lock);
+	hwif->hwgroup->busy = 0;
+	spin_unlock_irq(&ide_lock);
+out:
+	return err;
 #else
 	return -EPERM;
 #endif
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 6ceb25b..ace9892 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -255,7 +255,7 @@ static int config_chipset_for_dma(ide_drive_t *drive)
 		printk(KERN_WARNING "%s reduced to Ultra33 mode.\n", drive->name);
 	}
 
-	if (drive->media != ide_disk)
+	if (drive->media != ide_disk && drive->media != ide_cdrom)
 		return 0;
 
 	if (id->capability & 4) {
@@ -545,6 +545,7 @@ static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
 
+	hwif->atapi_dma  = 1;
 	hwif->ultra_mask = 0x7f;
 	hwif->mwdma_mask = 0x07;
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 34f2676..58564a1 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -615,6 +615,7 @@ typedef struct ide_drive_s {
         u8	init_speed;	/* transfer rate set at boot */
         u8	pio_speed;      /* unused by core, used by some drivers for fallback from DMA */
         u8	current_speed;	/* current transfer rate set */
+	u8	desired_speed;	/* desired transfer rate set */
         u8	dn;		/* now wide spread use */
         u8	wcache;		/* status of write cache */
 	u8	acoustic;	/* acoustic management */

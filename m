Return-Path: <linux-kernel-owner+w=401wt.eu-S1751056AbXBUBnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbXBUBnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbXBUBmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:42:37 -0500
Received: from hub.freebsd.org ([69.147.83.54]:24715 "EHLO hub.freebsd.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbXBUBmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:42:06 -0500
X-Greylist: delayed 1362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 20:42:06 EST
Date: Wed, 21 Feb 2007 01:23:04 +0000
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Use correct IDE error recovery
Message-ID: <20070221012304.GC1777@freefall.freebsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IDE error recovery is using WIN_IDLEIMMEDIATE which was only valid for
IDE V1 and IDE V2.  Modern drives will not be able to recover using
this error handling.  The correct thing to do is issue a SRST followed
by a SET_FEATURES.

Signed-off-by:	Suleiman Souhlal <suleiman@google.com>

---
 drivers/ide/ide-io.c   |   35 +++++++++++-----
 drivers/ide/ide-iops.c |  105 ++++++++++++++++++++++++++++--------------------
 include/linux/ide.h    |    2 +
 3 files changed, 88 insertions(+), 54 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c193553..2f05b4d 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -519,21 +519,21 @@ static ide_startstop_t ide_ata_error(ide
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
+	++rq->errors;
+
 	return ide_stopped;
 }
 
@@ -586,6 +586,13 @@ EXPORT_SYMBOL_GPL(__ide_error);
  *	both new-style (taskfile) and old style command handling here.
  *	In the case of taskfile command handling there is work left to
  *	do
+ *	This used to send a idle immediate to the drive if the drive was
+ *	busy or had drq set.  This violates the ATA spec (can only send IDLE
+ *	immediate when drive is not busy) and really hoses up some drives.
+ *	We've changed it to just do a SRST followed by a set features (set
+ *	udma mode) it those cases.  This is what Western Digital recommends
+ *	for error recovery and what Western Digital says Windows does.  It
+ *	also does not violate the ATA spec as far as I can tell.
  */
  
 ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
@@ -1004,6 +1011,12 @@ #endif
 		goto kill_rq;
 	}
 
+	/* We reset the drive so we need to issue a SETFEATURES. */
+	if ((drive->current_speed == 0xff) &&
+	    ((rq->cmd_type == REQ_TYPE_ATA_CMD) ||
+	    (rq->cmd_type == REQ_TYPE_ATA_TASK)))
+		ide_config_drive_speed_irq(drive, drive->desired_speed);
+
 	block    = rq->sector;
 	if (blk_fs_request(rq) &&
 	    (drive->media == ide_disk || drive->media == ide_floppy)) {
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 35ab3af..e0573cb 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -731,6 +731,30 @@ #else
 #endif
 }
 
+static void ide_drive_speed_changed(ide_drive_t *drive, u8 speed)
+{
+	switch(speed) {
+		case XFER_UDMA_7:   drive->id->dma_ultra |= 0x8080; break;
+		case XFER_UDMA_6:   drive->id->dma_ultra |= 0x4040; break;
+		case XFER_UDMA_5:   drive->id->dma_ultra |= 0x2020; break;
+		case XFER_UDMA_4:   drive->id->dma_ultra |= 0x1010; break;
+		case XFER_UDMA_3:   drive->id->dma_ultra |= 0x0808; break;
+		case XFER_UDMA_2:   drive->id->dma_ultra |= 0x0404; break;
+		case XFER_UDMA_1:   drive->id->dma_ultra |= 0x0202; break;
+		case XFER_UDMA_0:   drive->id->dma_ultra |= 0x0101; break;
+		case XFER_MW_DMA_2: drive->id->dma_mword |= 0x0404; break;
+		case XFER_MW_DMA_1: drive->id->dma_mword |= 0x0202; break;
+		case XFER_MW_DMA_0: drive->id->dma_mword |= 0x0101; break;
+		case XFER_SW_DMA_2: drive->id->dma_1word |= 0x0404; break;
+		case XFER_SW_DMA_1: drive->id->dma_1word |= 0x0202; break;
+		case XFER_SW_DMA_0: drive->id->dma_1word |= 0x0101; break;
+		default: break;
+	}
+	if (!drive->init_speed)
+		drive->init_speed = speed;
+	drive->current_speed = speed;
+}
+
 /*
  * Similar to ide_wait_stat(), except it never calls ide_error internally.
  * This is a kludge to handle the new ide_config_drive_speed() function,
@@ -742,32 +766,12 @@ #endif
  *
  * const char *msg == consider adding for verbose errors.
  */
-int ide_config_drive_speed (ide_drive_t *drive, u8 speed)
+int ide_config_drive_speed_irq(ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	int	i, error	= 1;
 	u8 stat;
 
-	/*
-	 * Just use ide_wait_cmd() if the drive has been initialized and we
-	 * aren't in an interrupt handler, to avoid changing the xfer speed
-	 * while requests are in flight.
-	 *
-	 * If we are in an interrupt, it should be safe to issue
-	 * SETFEATURES manually, since there shouldn't be any requests in
-	 * flight.
-	 */
-	if (drive->queue != NULL && !in_interrupt()) {
-		error = ide_wait_cmd(drive, WIN_SETFEATURES, speed,
-		    SETFEATURES_XFER, 0, NULL);
-		if (error) {
-			stat = hwif->INB(IDE_STATUS_REG);
-			ide_dump_status(drive, "set_drive_speed_status", stat);
-			return (error);
-		}
-		goto done;
-	}
-
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if (hwif->ide_dma_check)	 /* check if host supports DMA */
 		hwif->dma_host_off(drive);
@@ -839,28 +843,39 @@ #ifdef CONFIG_BLK_DEV_IDEDMA
 		hwif->dma_off_quietly(drive);
 #endif
 
-done:
-	switch(speed) {
-		case XFER_UDMA_7:   drive->id->dma_ultra |= 0x8080; break;
-		case XFER_UDMA_6:   drive->id->dma_ultra |= 0x4040; break;
-		case XFER_UDMA_5:   drive->id->dma_ultra |= 0x2020; break;
-		case XFER_UDMA_4:   drive->id->dma_ultra |= 0x1010; break;
-		case XFER_UDMA_3:   drive->id->dma_ultra |= 0x0808; break;
-		case XFER_UDMA_2:   drive->id->dma_ultra |= 0x0404; break;
-		case XFER_UDMA_1:   drive->id->dma_ultra |= 0x0202; break;
-		case XFER_UDMA_0:   drive->id->dma_ultra |= 0x0101; break;
-		case XFER_MW_DMA_2: drive->id->dma_mword |= 0x0404; break;
-		case XFER_MW_DMA_1: drive->id->dma_mword |= 0x0202; break;
-		case XFER_MW_DMA_0: drive->id->dma_mword |= 0x0101; break;
-		case XFER_SW_DMA_2: drive->id->dma_1word |= 0x0404; break;
-		case XFER_SW_DMA_1: drive->id->dma_1word |= 0x0202; break;
-		case XFER_SW_DMA_0: drive->id->dma_1word |= 0x0101; break;
-		default: break;
-	}
-	if (!drive->init_speed)
-		drive->init_speed = speed;
-	drive->current_speed = speed;
-	return error;
+		ide_drive_speed_changed(drive, speed);
+
+		return (error);
+}
+
+int ide_config_drive_speed (ide_drive_t *drive, u8 speed)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	int error;
+	u8 stat;
+
+	/*
+	 * Just use ide_wait_cmd() if the drive has been initialized and we
+	 * aren't in an interrupt handler, to avoid changing the xfer speed
+	 * while requests are in flight.
+	 *
+	 * If we are in an interrupt, it should be safe to issue
+	 * SETFEATURES manually, since there shouldn't be any requests in
+	 * flight.
+	 */
+	if (drive->queue != NULL && !in_interrupt()) {
+		error = ide_wait_cmd(drive, WIN_SETFEATURES, speed,
+		    SETFEATURES_XFER, 0, NULL);
+		if (error) {
+			stat = hwif->INB(IDE_STATUS_REG);
+			ide_dump_status(drive, "set_drive_speed_status", stat);
+			return (error);
+		}
+		ide_drive_speed_changed(drive, speed);
+	} else
+		error = ide_config_drive_speed_irq(drive, speed);
+
+	return (error);
 }
 
 EXPORT_SYMBOL(ide_config_drive_speed);
@@ -1093,6 +1108,10 @@ static void pre_reset(ide_drive_t *drive
 	if (HWIF(drive)->pre_reset != NULL)
 		HWIF(drive)->pre_reset(drive);
 
+	/* Make sure we issue a SETFEATURES before the next request. */
+	if (drive->current_speed != 0xff)
+		drive->desired_speed = drive->current_speed;
+	drive->current_speed = 0xff;
 }
 
 /*
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 3861753..c7f6027 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -616,6 +616,7 @@ typedef struct ide_drive_s {
         u8	init_speed;	/* transfer rate set at boot */
         u8	pio_speed;      /* unused by core, used by some drivers for fallback from DMA */
         u8	current_speed;	/* current transfer rate set */
+        u8	desired_speed;	/* desired transfer rate set */
         u8	dn;		/* now wide spread use */
         u8	wcache;		/* status of write cache */
 	u8	acoustic;	/* acoustic management */
@@ -1184,6 +1185,7 @@ extern int system_bus_clock(void);
 extern int ide_driveid_update(ide_drive_t *);
 extern int ide_ata66_check(ide_drive_t *, ide_task_t *);
 extern int ide_config_drive_speed(ide_drive_t *, u8);
+extern int ide_config_drive_speed_irq(ide_drive_t *, u8);
 extern u8 eighty_ninty_three (ide_drive_t *);
 extern int set_transfer(ide_drive_t *, ide_task_t *);
 extern int taskfile_lib_get_identify(ide_drive_t *drive, u8 *);


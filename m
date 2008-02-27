Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbYB0SWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbYB0SWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYB0SVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:21:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:47474 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbYB0SVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:21:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=g9H0YTIlCdaiZGukeaUTT9ifdIfNtBVK2vqpfqSfVDfbfMvfItpn5z0/9Ry18n22cQI1IR567WoptWvPaJz1bLg0s3WO0cOUIf4PLkWoMYsMh8txJhEcu9xWF+4XTdStC72pKjeZsP1U2hSbPeJuf3DJl3THRO9Z4Eic+6qxig8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 3/5] ide-cd: fixup comments
Date: Wed, 27 Feb 2008 19:20:47 +0100
Message-Id: <1204136449-9490-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |  401 ++++++++++++++++++++++++--------------------------
 1 files changed, 192 insertions(+), 209 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index bb7944b..bb501a4 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -39,7 +39,8 @@
 #include <linux/mutex.h>
 #include <linux/bcd.h>
 
-#include <scsi/scsi.h>	/* For SCSI -> ATAPI command conversion */
+/* For SCSI -> ATAPI command conversion */
+#include <scsi/scsi.h>
 
 #include <linux/irq.h>
 #include <linux/io.h>
@@ -77,12 +78,11 @@ static void ide_cd_put(struct cdrom_info *cd)
 	mutex_unlock(&idecd_ref_mutex);
 }
 
-/****************************************************************************
+/*
  * Generic packet command support and error handling routines.
  */
 
-/* Mark that we've seen a media change, and invalidate our internal
-   buffers. */
+/* Mark that we've seen a media change and invalidate our internal buffers. */
 static void cdrom_saw_media_change(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
@@ -105,9 +105,8 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 		break;
 	case NOT_READY:
 		/*
-		 * don't care about tray state messages for
-		 * e.g. capacity commands or in-progress or
-		 * becoming ready
+		 * don't care about tray state messages for e.g. capacity
+		 * commands or in-progress or becoming ready
 		 */
 		if (sense->asc == 0x3a || sense->asc == 0x04)
 			break;
@@ -115,8 +114,8 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 		break;
 	case ILLEGAL_REQUEST:
 		/*
-		 * don't log START_STOP unit with LoEj set, since
-		 * we cannot reliably check if drive can auto-close
+		 * don't log START_STOP unit with LoEj set, since we cannot
+		 * reliably check if drive can auto-close
 		 */
 		if (rq->cmd[0] == GPCMD_START_STOP_UNIT && sense->asc == 0x24)
 			break;
@@ -124,9 +123,9 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 		break;
 	case UNIT_ATTENTION:
 		/*
-		 * Make good and sure we've seen this potential media
-		 * change. Some drives (i.e. Creative) fail to present
-		 * the correct sense key in the error register.
+		 * Make good and sure we've seen this potential media change.
+		 * Some drives (i.e. Creative) fail to present the correct sense
+		 * key in the error register.
 		 */
 		cdrom_saw_media_change(drive);
 		break;
@@ -151,15 +150,16 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 		return;
 
 	/*
-	 * If a read toc is executed for a CD-R or CD-RW medium where
-	 * the first toc has not been recorded yet, it will fail with
-	 * 05/24/00 (which is a confusing error)
+	 * If a read toc is executed for a CD-R or CD-RW medium where the first
+	 * toc has not been recorded yet, it will fail with 05/24/00 (which is a
+	 * confusing error)
 	 */
 	if (failed_command && failed_command->cmd[0] == GPCMD_READ_TOC_PMA_ATIP)
 		if (sense->sense_key == 0x05 && sense->asc == 0x24)
 			return;
 
-	if (sense->error_code == 0x70) {	/* Current Error */
+	/* current error */
+	if (sense->error_code == 0x70) {
 		switch (sense->sense_key) {
 		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:
@@ -178,7 +178,8 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 			if (bio_sectors < 4)
 				bio_sectors = 4;
 			if (drive->queue->hardsect_size == 2048)
-				sector <<= 2;	/* Device sector size is 2K */
+				/* device sector size is 2K */
+				sector <<= 2;
 			sector &= ~(bio_sectors - 1);
 			valid = (sector - failed_command->sector) << 9;
 
@@ -194,9 +195,7 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 	ide_cd_log_error(drive->name, failed_command, sense);
 }
 
-/*
- * Initialize a ide-cd packet command request
- */
+/* Initialize a ide-cd packet command request */
 void ide_cd_init_rq(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *cd = drive->driver_data;
@@ -252,7 +251,7 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 			}
 			cdrom_analyze_sense_data(drive, failed, sense);
 			/*
-			 * now end failed request
+			 * now end the failed request
 			 */
 			if (blk_fs_request(failed)) {
 				if (ide_end_dequeued_request(drive, failed, 0,
@@ -287,14 +286,17 @@ static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 sta
 	ide_dump_status(drive, msg, stat);
 }
 
-/* Returns 0 if the request should be continued.
-   Returns 1 if the request was ended. */
+/*
+ * Returns:
+ * 0: if the request should be continued.
+ * 1: if the request was ended.
+ */
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 	int stat, err, sense_key;
 
-	/* Check for errors. */
+	/* check for errors. */
 	stat = ide_read_status(drive);
 
 	if (stat_ret)
@@ -303,7 +305,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	if (OK_STAT(stat, good_stat, BAD_R_STAT))
 		return 0;
 
-	/* Get the IDE error register. */
+	/* get the IDE error register. */
 	err = ide_read_error(drive);
 	sense_key = err >> 4;
 
@@ -313,10 +315,11 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	}
 
 	if (blk_sense_request(rq)) {
-		/* We got an error trying to get sense info
-		   from the drive (probably while trying
-		   to recover from a former error).  Just give up. */
-
+		/*
+		 * We got an error trying to get sense info from the drive
+		 * (probably while trying to recover from a former error).
+		 * Just give up.
+		 */
 		rq->cmd_flags |= REQ_FAILED;
 		cdrom_end_request(drive, 0);
 		ide_error(drive, "request sense failure", stat);
@@ -332,13 +335,12 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		if (blk_pc_request(rq) && !rq->errors)
 			rq->errors = SAM_STAT_CHECK_CONDITION;
 
-		/* Check for tray open. */
+		/* check for tray open. */
 		if (sense_key == NOT_READY) {
 			cdrom_saw_media_change(drive);
 		} else if (sense_key == UNIT_ATTENTION) {
-			/* Check for media change. */
+			/* check for media change. */
 			cdrom_saw_media_change(drive);
-			/*printk("%s: media changed\n",drive->name);*/
 			return 0;
 		} else if (sense_key == ILLEGAL_REQUEST &&
 			   rq->cmd[0] == GPCMD_START_STOP_UNIT) {
@@ -350,7 +352,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 			 * cdrom_log_sense() knows this!
 			 */
 		} else if (!(rq->cmd_flags & REQ_QUIET)) {
-			/* Otherwise, print an error. */
+			/* otherwise, print an error. */
 			ide_dump_status(drive, "packet command error", stat);
 		}
 
@@ -366,25 +368,27 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	} else if (blk_fs_request(rq)) {
 		int do_end_request = 0;
 
-		/* Handle errors from READ and WRITE requests. */
+		/* handle errors from READ and WRITE requests. */
 
 		if (blk_noretry_request(rq))
 			do_end_request = 1;
 
 		if (sense_key == NOT_READY) {
-			/* Tray open. */
+			/* tray open. */
 			if (rq_data_dir(rq) == READ) {
 				cdrom_saw_media_change(drive);
 
-				/* Fail the request. */
+				/* fail the request. */
 				printk("%s: tray open\n", drive->name);
 				do_end_request = 1;
 			} else {
 				struct cdrom_info *info = drive->driver_data;
 
-				/* allow the drive 5 seconds to recover, some
+				/*
+				 * allow the drive 5 seconds to recover, some
 				 * devices will return this error while flushing
-				 * data from cache */
+				 * data from cache.
+				 */
 				if (!rq->errors)
 					info->write_timeout = jiffies + ATAPI_WAIT_WRITE_BUSY;
 				rq->errors = 1;
@@ -394,8 +398,8 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 					unsigned long flags;
 
 					/*
-					 * take a breather relying on the
-					 * unplug timer to kick us again
+					 * take a breather relying on the unplug
+					 * timer to kick us again
 					 */
 					spin_lock_irqsave(&ide_lock, flags);
 					blk_plug_device(drive->queue);
@@ -404,55 +408,54 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 				}
 			}
 		} else if (sense_key == UNIT_ATTENTION) {
-			/* Media change. */
+			/* media change. */
 			cdrom_saw_media_change (drive);
 
 			/*
-			 * Arrange to retry the request.
-			 * But be sure to give up if we've retried
-			 * too many times.
+			 * Arrange to retry the request but be sure to give up
+			 * if we've retried too many times.
 			 */
 			if (++rq->errors > ERROR_MAX)
 				do_end_request = 1;
 		} else if (sense_key == ILLEGAL_REQUEST ||
 			   sense_key == DATA_PROTECT) {
 			/*
-			 * No point in retrying after an illegal
-			 * request or data protect error.
+			 * No point in retrying after an illegal request or data
+			 * protect error.
 			 */
 			ide_dump_status_no_sense(drive, "command error", stat);
 			do_end_request = 1;
 		} else if (sense_key == MEDIUM_ERROR) {
 			/*
 			 * No point in re-trying a zillion times on a bad
-			 * sector... If we got here the error is not correctable
+			 * sector. If we got here the error is not correctable.
 			 */
 			ide_dump_status_no_sense(drive, "media error (bad sector)", stat);
 			do_end_request = 1;
 		} else if (sense_key == BLANK_CHECK) {
-			/* Disk appears blank ?? */
+			/* disk appears blank ?? */
 			ide_dump_status_no_sense(drive, "media error (blank)", stat);
 			do_end_request = 1;
 		} else if ((err & ~ABRT_ERR) != 0) {
-			/* Go to the default handler
-			   for other errors. */
+			/* go to the default handler for other errors. */
 			ide_error(drive, "cdrom_decode_status", stat);
 			return 1;
 		} else if ((++rq->errors > ERROR_MAX)) {
-			/* We've racked up too many retries.  Abort. */
+			/* we've racked up too many retries, abort. */
 			do_end_request = 1;
 		}
 
-		/* End a request through request sense analysis when we have
-		   sense data. We need this in order to perform end of media
-		   processing */
-
+		/*
+		 * End a request through request sense analysis when we have
+		 * sense data. We need this in order to perform end of media
+		 * processing.
+		 */
 		if (do_end_request)
 			goto end_request;
 
 		/*
-		 * If we got a CHECK_CONDITION status,
-		 * queue a request sense command.
+		 * If we got a CHECK_CONDITION status, queue
+		 * a request sense command.
 		 */
 		if (stat & ERR_STAT)
 			cdrom_queue_request_sense(drive, NULL, NULL);
@@ -461,7 +464,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		cdrom_end_request(drive, 0);
 	}
 
-	/* Retry, or handle the next request. */
+	/* retry, or handle the next request. */
 	return 1;
 
 end_request:
@@ -486,10 +489,10 @@ static int cdrom_timer_expiry(ide_drive_t *drive)
 	unsigned long wait = 0;
 
 	/*
-	 * Some commands are *slow* and normally take a long time to
-	 * complete. Usually we can use the ATAPI "disconnect" to bypass
-	 * this, but not all commands/drives support that. Let
-	 * ide_timer_expiry keep polling us for these.
+	 * Some commands are *slow* and normally take a long time to complete.
+	 * Usually we can use the ATAPI "disconnect" to bypass this, but not all
+	 * commands/drives support that. Let ide_timer_expiry keep polling us
+	 * for these.
 	 */
 	switch (rq->cmd[0]) {
 	case GPCMD_BLANK:
@@ -508,13 +511,14 @@ static int cdrom_timer_expiry(ide_drive_t *drive)
 	return wait;
 }
 
-/* Set up the device registers for transferring a packet command on DEV,
-   expecting to later transfer XFERLEN bytes.  HANDLER is the routine
-   which actually transfers the command to the drive.  If this is a
-   drq_interrupt device, this routine will arrange for HANDLER to be
-   called when the interrupt from the drive arrives.  Otherwise, HANDLER
-   will be called immediately after the drive is prepared for the transfer. */
-
+/*
+ * Set up the device registers for transferring a packet command on DEV,
+ * expecting to later transfer XFERLEN bytes.  HANDLER is the routine
+ * which actually transfers the command to the drive.  If this is a
+ * drq_interrupt device, this routine will arrange for HANDLER to be
+ * called when the interrupt from the drive arrives.  Otherwise, HANDLER
+ * will be called immediately after the drive is prepared for the transfer.
+ */
 static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 						  int xferlen,
 						  ide_handler_t *handler)
@@ -523,7 +527,7 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 	struct cdrom_info *info = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 
-	/* Wait for the controller to be idle. */
+	/* wait for the controller to be idle. */
 	if (ide_wait_stat(&startstop, drive, 0, BUSY_STAT, WAIT_READY))
 		return startstop;
 
@@ -531,7 +535,7 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 	if (info->dma)
 		info->dma = !hwif->dma_setup(drive);
 
-	/* Set up the controller registers. */
+	/* set up the controller registers. */
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL |
 			   IDE_TFLAG_NO_SELECT_MASK, xferlen, info->dma);
 
@@ -557,11 +561,12 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 	}
 }
 
-/* Send a packet command to DRIVE described by CMD_BUF and CMD_LEN.
-   The device registers must have already been prepared
-   by cdrom_start_packet_command.
-   HANDLER is the interrupt handler to call when the command completes
-   or there's data ready. */
+/*
+ * Send a packet command to DRIVE described by CMD_BUF and CMD_LEN. The device
+ * registers must have already been prepared by cdrom_start_packet_command.
+ * HANDLER is the interrupt handler to call when the command completes or
+ * there's data ready.
+ */
 #define ATAPI_MIN_CDB_BYTES 12
 static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 					  struct request *rq,
@@ -573,24 +578,26 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 	ide_startstop_t startstop;
 
 	if (info->cd_flags & IDE_CD_FLAG_DRQ_INTERRUPT) {
-		/* Here we should have been called after receiving an interrupt
-		   from the device.  DRQ should how be set. */
+		/*
+		 * Here we should have been called after receiving an interrupt
+		 * from the device.  DRQ should how be set.
+		 */
 
-		/* Check for errors. */
+		/* check for errors. */
 		if (cdrom_decode_status(drive, DRQ_STAT, NULL))
 			return ide_stopped;
 
-		/* Ok, next interrupt will be DMA interrupt. */
+		/* ok, next interrupt will be DMA interrupt. */
 		if (info->dma)
 			drive->waiting_for_dma = 1;
 	} else {
-		/* Otherwise, we must wait for DRQ to get set. */
+		/* otherwise, we must wait for DRQ to get set. */
 		if (ide_wait_stat(&startstop, drive, DRQ_STAT,
 				BUSY_STAT, WAIT_READY))
 			return startstop;
 	}
 
-	/* Arm the interrupt handler. */
+	/* arm the interrupt handler. */
 	ide_set_handler(drive, handler, rq->timeout, cdrom_timer_expiry);
 
 	/* ATAPI commands get padded out to 12 bytes minimum */
@@ -598,20 +605,19 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 	if (cmd_len < ATAPI_MIN_CDB_BYTES)
 		cmd_len = ATAPI_MIN_CDB_BYTES;
 
-	/* Send the command to the device. */
+	/* send the command to the device. */
 	HWIF(drive)->atapi_output_bytes(drive, rq->cmd, cmd_len);
 
-	/* Start the DMA if need be */
+	/* start the DMA if need be */
 	if (info->dma)
 		hwif->dma_start(drive);
 
 	return ide_started;
 }
 
-/****************************************************************************
+/*
  * Block read functions.
  */
-
 static void ide_cd_pad_transfer(ide_drive_t *drive, xfer_func_t *xf, int len)
 {
 	while (len > 0) {
@@ -649,20 +655,21 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 		ide_hwif_t *hwif = drive->hwif;
 		xfer_func_t *xf;
 
-		/* Whoops... */
+		/* whoops... */
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
 				drive->name, __func__);
 
 		xf = rw ? hwif->atapi_output_bytes : hwif->atapi_input_bytes;
 		ide_cd_pad_transfer(drive, xf, len);
 	} else  if (rw == 0 && ireason == 1) {
-		/* Some drives (ASUS) seem to tell us that status
-		 * info is available. just get it and ignore.
+		/*
+		 * Some drives (ASUS) seem to tell us that status info is
+		 * available. just get it and ignore.
 		 */
 		(void)ide_read_status(drive);
 		return 0;
 	} else {
-		/* Drive wants a command packet, or invalid ireason... */
+		/* drive wants a command packet, or invalid ireason... */
 		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
 				drive->name, __func__, ireason);
 	}
@@ -702,10 +709,10 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
 
 /*
- * Routine to send a read/write packet command to the drive.
- * This is usually called directly from cdrom_start_{read,write}().
- * However, for drq_interrupt devices, it is called from an interrupt
- * when the drive is ready to accept the command.
+ * Routine to send a read/write packet command to the drive. This is usually
+ * called directly from cdrom_start_{read,write}(). However, for drq_interrupt
+ * devices, it is called from an interrupt when the drive is ready to accept
+ * the command.
  */
 static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 {
@@ -727,7 +734,7 @@ static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 		 * is larger than the buffer size.
 		 */
 		if (nskip > 0) {
-			/* Sanity check... */
+			/* sanity check... */
 			if (rq->current_nr_sectors !=
 			    bio_cur_sectors(rq->bio)) {
 				printk(KERN_ERR "%s: %s: buffer botch (%u)\n",
@@ -744,10 +751,10 @@ static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 		/* the immediate bit */
 		rq->cmd[1] = 1 << 3;
 #endif
-	/* Set up the command */
+	/* set up the command */
 	rq->timeout = ATAPI_WAIT_PC;
 
-	/* Send the command to the drive and return. */
+	/* send the command to the drive and return. */
 	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
 
@@ -768,12 +775,7 @@ static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 
 	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER)) {
 		if (--retry == 0) {
-			/*
-			 * this condition is far too common, to bother
-			 * users about it
-			 */
-			/* printk("%s: disabled DSC seek overlap\n", drive->name);*/
-			drive->dsc_overlap = 0;
+				drive->dsc_overlap = 0;
 		}
 	}
 	return ide_stopped;
@@ -804,8 +806,8 @@ static ide_startstop_t cdrom_start_seek(ide_drive_t *drive, unsigned int block)
 }
 
 /*
- * Fix up a possibly partially-processed request so that we can
- * start it over entirely, or even put it back on the request queue.
+ * Fix up a possibly partially-processed request so that we can start it over
+ * entirely, or even put it back on the request queue.
  */
 static void restore_request(struct request *rq)
 {
@@ -822,10 +824,9 @@ static void restore_request(struct request *rq)
 	rq->q->prep_rq_fn(rq->q, rq);
 }
 
-/****************************************************************************
- * Execute all other packet commands.
+/*
+ * All other packet commands.
  */
-
 static void ide_cd_request_sense_fixup(struct request *rq)
 {
 	/*
@@ -849,7 +850,7 @@ int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
 	if (rq->sense == NULL)
 		rq->sense = &sense;
 
-	/* Start of retry loop. */
+	/* start of retry loop. */
 	do {
 		int error;
 		unsigned long time = jiffies;
@@ -858,41 +859,45 @@ int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
 		error = ide_do_drive_cmd(drive, rq, ide_wait);
 		time = jiffies - time;
 
-		/* FIXME: we should probably abort/retry or something
-		 * in case of failure */
+		/*
+		 * FIXME: we should probably abort/retry or something in case of
+		 * failure.
+		 */
 		if (rq->cmd_flags & REQ_FAILED) {
-			/* The request failed.  Retry if it was due to a unit
-			   attention status
-			   (usually means media was changed). */
+			/*
+			 * The request failed.  Retry if it was due to a unit
+			 * attention status (usually means media was changed).
+			 */
 			struct request_sense *reqbuf = rq->sense;
 
 			if (reqbuf->sense_key == UNIT_ATTENTION)
 				cdrom_saw_media_change(drive);
 			else if (reqbuf->sense_key == NOT_READY &&
 				 reqbuf->asc == 4 && reqbuf->ascq != 4) {
-				/* The drive is in the process of loading
-				   a disk.  Retry, but wait a little to give
-				   the drive time to complete the load. */
+				/*
+				 * The drive is in the process of loading
+				 * a disk.  Retry, but wait a little to give
+				 * the drive time to complete the load.
+				 */
 				ssleep(2);
 			} else {
-				/* Otherwise, don't retry. */
+				/* otherwise, don't retry. */
 				retries = 0;
 			}
 			--retries;
 		}
 
-		/* End of retry loop. */
+		/* end of retry loop. */
 	} while ((rq->cmd_flags & REQ_FAILED) && retries >= 0);
 
-	/* Return an error if the command failed. */
+	/* return an error if the command failed. */
 	return (rq->cmd_flags & REQ_FAILED) ? -EIO : 0;
 }
 
 /*
- * Called from blk_end_request_callback() after the data of the request
- * is completed and before the request is completed.
- * By returning value '1', blk_end_request_callback() returns immediately
- * without completing the request.
+ * Called from blk_end_request_callback() after the data of the request is
+ * completed and before the request itself is completed. By returning value '1',
+ * blk_end_request_callback() returns immediately without completing it.
  */
 static int cdrom_newpc_intr_dummy_cb(struct request *rq)
 {
@@ -911,7 +916,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	unsigned int timeout;
 	u8 lowcyl, highcyl;
 
-	/* Check for errors. */
+	/* check for errors. */
 	dma = info->dma;
 	if (dma) {
 		info->dma = 0;
@@ -926,9 +931,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	if (cdrom_decode_status(drive, 0, &stat))
 		return ide_stopped;
 
-	/*
-	 * using dma, transfer is complete now
-	 */
+	/* using dma, transfer is complete now */
 	if (dma) {
 		if (dma_error)
 			return ide_error(drive, "dma error", stat);
@@ -939,9 +942,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		goto end_request;
 	}
 
-	/*
-	 * ok we fall to pio :/
-	 */
+	/* ok we fall to pio :/	 */
 	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]) & 0x3;
 	lowcyl  = hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
 	highcyl = hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]);
@@ -952,9 +953,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	if (thislen > len)
 		thislen = len;
 
-	/*
-	 * If DRQ is clear, the command has completed.
-	 */
+	/* If DRQ is clear, the command has completed. */
 	if ((stat & DRQ_STAT) == 0) {
 		if (blk_fs_request(rq)) {
 			/*
@@ -975,15 +974,13 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			return ide_stopped;
 		} else if (!blk_pc_request(rq)) {
 			ide_cd_request_sense_fixup(rq);
-			/* Complain if we still have data left to transfer. */
+			/* complain if we still have data left to transfer. */
 			uptodate = rq->data_len ? 0 : 1;
 		}
 		goto end_request;
 	}
 
-	/*
-	 * check which way to transfer data
-	 */
+	/* check which way to transfer data */
 	if (ide_cd_check_ireason(drive, rq, len, ireason, write))
 		return ide_stopped;
 
@@ -1019,16 +1016,12 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		xferfunc = HWIF(drive)->atapi_input_bytes;
 	}
 
-	/*
-	 * transfer data
-	 */
+	/* transfer data */
 	while (thislen > 0) {
 		u8 *ptr = blk_fs_request(rq) ? NULL : rq->data;
 		int blen = rq->data_len;
 
-		/*
-		 * bio backed?
-		 */
+		/* bio backed? */
 		if (rq->bio) {
 			if (blk_fs_request(rq)) {
 				ptr = rq->buffer;
@@ -1043,7 +1036,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			if (blk_fs_request(rq) && !write)
 				/*
 				 * If the buffers are full, pipe the rest into
-				 * oblivion. */
+				 * oblivion.
+				 */
 				ide_cd_drain_data(drive, thislen >> 9);
 			else {
 				printk(KERN_ERR "%s: confused, missing data\n",
@@ -1090,9 +1084,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			rq->sense_len += blen;
 	}
 
-	/*
-	 * pad, if necessary
-	 */
+	/* pad, if necessary */
 	if (!blk_fs_request(rq) && len > 0)
 		ide_cd_pad_transfer(drive, xferfunc, len);
 
@@ -1136,9 +1128,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 		queue_hardsect_size(drive->queue) >> SECTOR_BITS;
 
 	if (write) {
-		/*
-		 * disk has become write protected
-		 */
+		/* disk has become write protected */
 		if (cd->disk->policy) {
 			cdrom_end_request(drive, 0);
 			return ide_stopped;
@@ -1151,9 +1141,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 		restore_request(rq);
 	}
 
-	/*
-	 * use DMA, if possible / writes *must* be hardware frame aligned
-	 */
+	/* use DMA, if possible / writes *must* be hardware frame aligned */
 	if ((rq->nr_sectors & (sectors_per_frame - 1)) ||
 	    (rq->sector & (sectors_per_frame - 1))) {
 		if (write) {
@@ -1167,7 +1155,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	if (write)
 		cd->devinfo.media_written = 1;
 
-	/* Start sending the read/write request to the drive. */
+	/* start sending the read/write request to the drive. */
 	return cdrom_start_packet_command(drive, 32768, cdrom_start_rw_cont);
 }
 
@@ -1192,9 +1180,7 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 
 	info->dma = 0;
 
-	/*
-	 * sg request
-	 */
+	/* sg request */
 	if (rq->bio) {
 		int mask = drive->queue->dma_alignment;
 		unsigned long addr = (unsigned long) page_address(bio_page(rq->bio));
@@ -1211,11 +1197,11 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 			info->dma = 0;
 	}
 
-	/* Start sending the command to the drive. */
+	/* start sending the command to the drive. */
 	return cdrom_start_packet_command(drive, rq->data_len, cdrom_do_newpc_cont);
 }
 
-/****************************************************************************
+/*
  * cdrom driver request routine.
  */
 static ide_startstop_t
@@ -1248,9 +1234,8 @@ ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq, sector_t block)
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
 		return cdrom_do_block_pc(drive, rq);
 	} else if (blk_special_request(rq)) {
-		/*
-		 * right now this can only be a reset...
-		 */
+
+		/* right now this can only be a reset... */
 		cdrom_end_request(drive, 1);
 		return ide_stopped;
 	}
@@ -1262,16 +1247,15 @@ ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq, sector_t block)
 
 
 
-/****************************************************************************
+/*
  * Ioctl handling.
  *
- * Routines which queue packet commands take as a final argument a pointer
- * to a request_sense struct.  If execution of the command results
- * in an error with a CHECK CONDITION status, this structure will be filled
- * with the results of the subsequent request sense command.  The pointer
- * can also be NULL, in which case no sense information is returned.
+ * Routines which queue packet commands take as a final argument a pointer to a
+ * request_sense struct. If execution of the command results in an error with a
+ * CHECK CONDITION status, this structure will be filled with the results of the
+ * subsequent request sense command. The pointer can also be NULL, in which case
+ * no sense information is returned.
  */
-
 static
 void msf_from_bcd(struct atapi_msf *msf)
 {
@@ -1293,8 +1277,8 @@ int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
 	req.cmd_flags |= REQ_QUIET;
 
 	/*
-	 * Sanyo 3 CD changer uses byte 7 of TEST_UNIT_READY to
-	 * switch CDs instead of supporting the LOAD_UNLOAD opcode.
+	 * Sanyo 3 CD changer uses byte 7 of TEST_UNIT_READY to switch CDs
+	 * instead of supporting the LOAD_UNLOAD opcode.
 	 */
 	req.cmd[7] = cdi->sanyo_slot % 3;
 
@@ -1370,7 +1354,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	unsigned long sectors_per_frame = SECTORS_PER_FRAME;
 
 	if (toc == NULL) {
-		/* Try to allocate space. */
+		/* try to allocate space */
 		toc = kmalloc(sizeof(struct atapi_toc), GFP_KERNEL);
 		if (toc == NULL) {
 			printk(KERN_ERR "%s: No cdrom TOC buffer!\n", drive->name);
@@ -1379,27 +1363,29 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		info->toc = toc;
 	}
 
-	/* Check to see if the existing data is still valid.
-	   If it is, just return. */
+	/*
+	 * Check to see if the existing data is still valid. If it is,
+	 * just return.
+	 */
 	(void) cdrom_check_status(drive, sense);
 
 	if (info->cd_flags & IDE_CD_FLAG_TOC_VALID)
 		return 0;
 
-	/* Try to get the total cdrom capacity and sector size. */
+	/* try to get the total cdrom capacity and sector size. */
 	stat = cdrom_read_capacity(drive, &toc->capacity, &sectors_per_frame,
 				   sense);
 	if (stat)
 		toc->capacity = 0x1fffff;
 
 	set_capacity(info->disk, toc->capacity * sectors_per_frame);
-	/* Save a private copy of te TOC capacity for error handling */
+	/* save a private copy of the TOC capacity for error handling */
 	drive->probed_capacity = toc->capacity * sectors_per_frame;
 
 	blk_queue_hardsect_size(drive->queue,
 				sectors_per_frame << SECTOR_BITS);
 
-	/* First read just the header, so we know how long the TOC is. */
+	/* first read just the header, so we know how long the TOC is. */
 	stat = cdrom_read_tocentry(drive, 0, 1, 0, (char *) &toc->hdr,
 				    sizeof(struct atapi_toc_header), sense);
 	if (stat)
@@ -1416,7 +1402,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	if (ntracks > MAX_TRACKS)
 		ntracks = MAX_TRACKS;
 
-	/* Now read the whole schmeer. */
+	/* now read the whole schmeer. */
 	stat = cdrom_read_tocentry(drive, toc->hdr.first_track, 1, 0,
 				  (char *)&toc->hdr,
 				   sizeof(struct atapi_toc_header) +
@@ -1424,15 +1410,18 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 				   sizeof(struct atapi_toc_entry), sense);
 
 	if (stat && toc->hdr.first_track > 1) {
-		/* Cds with CDI tracks only don't have any TOC entries,
-		   despite of this the returned values are
-		   first_track == last_track = number of CDI tracks + 1,
-		   so that this case is indistinguishable from the same
-		   layout plus an additional audio track.
-		   If we get an error for the regular case, we assume
-		   a CDI without additional audio tracks. In this case
-		   the readable TOC is empty (CDI tracks are not included)
-		   and only holds the Leadout entry. Heiko Eißfeldt */
+		/*
+		 * Cds with CDI tracks only don't have any TOC entries, despite
+		 * of this the returned values are
+		 * first_track == last_track = number of CDI tracks + 1,
+		 * so that this case is indistinguishable from the same layout
+		 * plus an additional audio track. If we get an error for the
+		 * regular case, we assume a CDI without additional audio
+		 * tracks. In this case the readable TOC is empty (CDI tracks
+		 * are not included) and only holds the Leadout entry.
+		 *
+		 * Heiko Eißfeldt.
+		 */
 		ntracks = 0;
 		stat = cdrom_read_tocentry(drive, CDROM_LEADOUT, 1, 0,
 					   (char *)&toc->hdr,
@@ -1473,9 +1462,8 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 						  toc->ent[i].addr.msf.frame);
 	}
 
-	/* Read the multisession information. */
 	if (toc->hdr.first_track != CDROM_LEADOUT) {
-		/* Read the multisession information. */
+		/* read the multisession information. */
 		stat = cdrom_read_tocentry(drive, 0, 0, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp), sense);
 		if (stat)
@@ -1488,7 +1476,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	}
 
 	if (info->cd_flags & IDE_CD_FLAG_TOCADDR_AS_BCD) {
-		/* Re-read multisession information using MSF format */
+		/* re-read multisession information using MSF format */
 		stat = cdrom_read_tocentry(drive, 0, 1, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp), sense);
 		if (stat)
@@ -1502,7 +1490,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 
 	toc->xa_flag = (ms_tmp.hdr.first_track != ms_tmp.hdr.last_track);
 
-	/* Now try to get the total cdrom capacity. */
+	/* now try to get the total cdrom capacity. */
 	stat = cdrom_get_last_written(cdi, &last_written);
 	if (!stat && (last_written > toc->capacity)) {
 		toc->capacity = last_written;
@@ -1527,7 +1515,8 @@ int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
 
 	init_cdrom_command(&cgc, buf, size, CGC_DATA_UNKNOWN);
-	do { /* we seem to get stat=0x01,err=0x00 the first time (??) */
+	do {
+		/* we seem to get stat=0x01,err=0x00 the first time (??) */
 		stat = cdrom_mode_sense(cdi, &cgc, GPMODE_CAPABILITIES_PAGE, 0);
 		if (!stat)
 			break;
@@ -1622,11 +1611,10 @@ int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	}
 
 	/*
-	 * we have to cheat a little here. the packet will eventually
-	 * be queued with ide_cdrom_packet(), which extracts the
-	 * drive from cdi->handle. Since this device hasn't been
-	 * registered with the Uniform layer yet, it can't do this.
-	 * Same goes for cdi->ops.
+	 * we have to cheat a little here. the packet will eventually be queued
+	 * with ide_cdrom_packet(), which extracts the drive from cdi->handle.
+	 * Since this device hasn't been registered with the Uniform layer yet,
+	 * it can't do this. Same goes for cdi->ops.
 	 */
 	cdi->handle = drive;
 	cdi->ops = &ide_cdrom_dops;
@@ -1695,9 +1683,7 @@ int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	return nslots;
 }
 
-/*
- * standard prep_rq_fn that builds 10 byte cmds
- */
+/* standard prep_rq_fn that builds 10 byte cmds */
 static int ide_cdrom_prep_fs(struct request_queue *q, struct request *rq)
 {
 	int hard_sect = queue_hardsect_size(q);
@@ -1736,9 +1722,7 @@ static int ide_cdrom_prep_pc(struct request *rq)
 {
 	u8 *c = rq->cmd;
 
-	/*
-	 * Transform 6-byte read/write commands to the 10-byte version
-	 */
+	/* Transform 6-byte read/write commands to the 10-byte version */
 	if (c[0] == READ_6 || c[0] == WRITE_6) {
 		c[8] = c[4];
 		c[5] = c[3];
@@ -1902,13 +1886,12 @@ int ide_cdrom_setup(ide_drive_t *drive)
 		 id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
 		cd->cd_flags |= IDE_CD_FLAG_TOCTRACKS_AS_BCD;
 	else if (cd->cd_flags & IDE_CD_FLAG_SANYO_3CD)
-		cdi->sanyo_slot = 3;	/* 3 => use CD in slot 0 */
+		/* 3 => use CD in slot 0 */
+		cdi->sanyo_slot = 3;
 
 	nslots = ide_cdrom_probe_capabilities(drive);
 
-	/*
-	 * set correct block size
-	 */
+	/* set correct block size */
 	blk_queue_hardsect_size(drive->queue, CD_FRAMESIZE);
 
 	if (drive->autotune == IDE_TUNE_DEFAULT ||
@@ -2093,7 +2076,7 @@ static struct block_device_operations idecd_ops = {
 	.revalidate_disk	= idecd_revalidate_disk
 };
 
-/* options */
+/* module options */
 static char *ignore;
 
 module_param(ignore, charp, 0400);
-- 
1.5.4.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1764266AbZDBG7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764266AbZDBG7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbZDBG6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:58:51 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:51138 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbZDBG6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KVEQxm0Ftpd4hlpPINHBUJJRRGW9h8DgiZSLADjORJ9EyiKSk5MWRDyxBtgwGR9cGk
         AIsdUjzL+cvlrTFNSKjMt2mIvWtxWqXFLFzfU5qlOl5tdCGW/g8FzAqUqA9nL90efByR
         HTx0L1l86eYPcp4gxAuFiYcPE3wZ2oLexEpsQ=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide-cd: cleanup cdrom_decode_status
Date: Thu,  2 Apr 2009 08:58:38 +0200
Message-Id: <1238655519-10074-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- have (almost) equal handling of commands based solely on sense_key

- carve out an ide_cd_breathe()-helper for fs write requests

- make code more readable

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |  238 ++++++++++++++++++++++---------------------------
 1 files changed, 107 insertions(+), 131 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index a4afd90..8387dbf 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -266,6 +266,38 @@ static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 }
 
 /*
+ * Allow the drive 5 seconds to recover; some devices will return NOT_READY
+ * while flushing data from cache
+ */
+static int ide_cd_breathe(ide_drive_t *drive, struct request *rq)
+{
+
+	struct cdrom_info *info = drive->driver_data;
+
+	if (!rq->errors)
+		info->write_timeout = jiffies +	ATAPI_WAIT_WRITE_BUSY;
+
+	rq->errors = 1;
+
+	if (time_after(jiffies, info->write_timeout))
+		return 1;
+	else {
+		struct request_queue *q = drive->queue;
+		unsigned long flags;
+
+		/*
+		 * take a breather relying on the unplug timer to kick us again
+		 */
+
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_plug_device(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+
+		return 0;
+	}
+}
+
+/*
  * Returns:
  * 0: if the request should be continued.
  * 1: if the request will be going through error recovery.
@@ -275,14 +307,15 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
-	int err, sense_key;
+	int err, sense_key, do_end_request;
 
 	/* get the IDE error register */
 	err = ide_read_error(drive);
 	sense_key = err >> 4;
 
-	ide_debug_log(IDE_DBG_RQ, "cmd[0]: 0x%x, rq->cmd_type: 0x%x, err: 0x%x",
-				  rq->cmd[0], rq->cmd_type, err);
+	ide_debug_log(IDE_DBG_RQ, "cmd: 0x%x, rq->cmd_type: 0x%x, err: 0x%x, "
+				  "stat 0x%x",
+				  rq->cmd[0], rq->cmd_type, err, stat);
 
 	if (blk_sense_request(rq)) {
 		/*
@@ -292,151 +325,93 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		 */
 		rq->cmd_flags |= REQ_FAILED;
 		return 2;
-	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
-		/* All other functions, except for READ. */
+	}
 
-		/*
-		 * if we have an error, pass back CHECK_CONDITION as the
-		 * scsi status byte
-		 */
-		if (blk_pc_request(rq) && !rq->errors)
-			rq->errors = SAM_STAT_CHECK_CONDITION;
+	/* if we got an error, pass CHECK_CONDITION as the scsi status byte */
+	if (blk_pc_request(rq) && !rq->errors)
+		rq->errors = SAM_STAT_CHECK_CONDITION;
 
-		/* check for tray open */
-		if (sense_key == NOT_READY) {
-			cdrom_saw_media_change(drive);
-		} else if (sense_key == UNIT_ATTENTION) {
-			/* check for media change */
+	if (blk_noretry_request(rq))
+			do_end_request = 1;
+
+	switch (sense_key) {
+	case NOT_READY:
+		if (blk_fs_request(rq) && (rq_data_dir(rq) == WRITE)) {
+			if (!ide_cd_breathe(drive, rq))
+				return 1;
+		} else {
 			cdrom_saw_media_change(drive);
-			return 0;
-		} else if (sense_key == ILLEGAL_REQUEST &&
-			   rq->cmd[0] == GPCMD_START_STOP_UNIT) {
-			/*
-			 * Don't print error message for this condition--
-			 * SFF8090i indicates that 5/24/00 is the correct
-			 * response to a request to close the tray if the
-			 * drive doesn't have that capability.
-			 * cdrom_log_sense() knows this!
-			 */
-		} else if (!(rq->cmd_flags & REQ_QUIET)) {
-			/* otherwise, print an error */
-			ide_dump_status(drive, "packet command error", stat);
+			printk(KERN_ERR PFX "%s: tray open\n", drive->name);
 		}
+		do_end_request = 1;
+		break;
 
-		rq->cmd_flags |= REQ_FAILED;
+	case UNIT_ATTENTION:
+		cdrom_saw_media_change(drive);
+		if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC)
+			return 0;
+		break;
 
+	case ILLEGAL_REQUEST:
+	case DATA_PROTECT:
 		/*
-		 * instead of playing games with moving completions around,
-		 * remove failed request completely and end it when the
-		 * request sense has completed
+		 * Don't print error message for this condition since SFF8090i
+		 * indicates that 5/24/00 is the correct response to a request
+		 * to close the tray if the drive doesn't have that capability.
+		 *
+		 * cdrom_log_sense() knows this!
 		 */
-		goto end_request;
-
-	} else if (blk_fs_request(rq)) {
-		int do_end_request = 0;
-
-		/* handle errors from READ and WRITE requests */
-
-		if (blk_noretry_request(rq))
+		if (rq->cmd[0] != GPCMD_START_STOP_UNIT) {
+			ide_dump_status(drive, "command error", stat);
 			do_end_request = 1;
+		}
+		break;
 
-		if (sense_key == NOT_READY) {
-			/* tray open */
-			if (rq_data_dir(rq) == READ) {
-				cdrom_saw_media_change(drive);
-
-				/* fail the request */
-				printk(KERN_ERR PFX "%s: tray open\n",
-						drive->name);
-				do_end_request = 1;
-			} else {
-				struct cdrom_info *info = drive->driver_data;
+	case MEDIUM_ERROR:
+		/*
+		 * No point in re-trying a zillion times on a bad sector. If we
+		 * got here the error is not correctable.
+		 */
+		ide_dump_status(drive, "media error (bad sector)", stat);
+		do_end_request = 1;
+		break;
 
-				/*
-				 * Allow the drive 5 seconds to recover, some
-				 * devices will return this error while flushing
-				 * data from cache.
-				 */
-				if (!rq->errors)
-					info->write_timeout = jiffies +
-							ATAPI_WAIT_WRITE_BUSY;
-				rq->errors = 1;
-				if (time_after(jiffies, info->write_timeout))
-					do_end_request = 1;
-				else {
-					struct request_queue *q = drive->queue;
-					unsigned long flags;
-
-					/*
-					 * take a breather relying on the unplug
-					 * timer to kick us again
-					 */
-					spin_lock_irqsave(q->queue_lock, flags);
-					blk_plug_device(q);
-					spin_unlock_irqrestore(q->queue_lock, flags);
-
-					return 1;
-				}
-			}
-		} else if (sense_key == UNIT_ATTENTION) {
-			/* media change */
-			cdrom_saw_media_change(drive);
+	case BLANK_CHECK:
+		/* disk appears blank ?? */
+		ide_dump_status(drive, "media error (blank)", stat);
+		do_end_request = 1;
+		break;
 
-			/*
-			 * Arrange to retry the request but be sure to give up
-			 * if we've retried too many times.
-			 */
-			if (++rq->errors > ERROR_MAX)
-				do_end_request = 1;
-		} else if (sense_key == ILLEGAL_REQUEST ||
-			   sense_key == DATA_PROTECT) {
-			/*
-			 * No point in retrying after an illegal request or data
-			 * protect error.
-			 */
-			ide_dump_status(drive, "command error", stat);
-			do_end_request = 1;
-		} else if (sense_key == MEDIUM_ERROR) {
-			/*
-			 * No point in re-trying a zillion times on a bad
-			 * sector. If we got here the error is not correctable.
-			 */
-			ide_dump_status(drive, "media error (bad sector)",
-					stat);
-			do_end_request = 1;
-		} else if (sense_key == BLANK_CHECK) {
-			/* disk appears blank ?? */
-			ide_dump_status(drive, "media error (blank)", stat);
-			do_end_request = 1;
-		} else if ((err & ~ATA_ABORTED) != 0) {
+	default:
+		if (err & ~ATA_ABORTED) {
 			/* go to the default handler for other errors */
 			ide_error(drive, "cdrom_decode_status", stat);
 			return 1;
-		} else if ((++rq->errors > ERROR_MAX)) {
-			/* we've racked up too many retries, abort */
-			do_end_request = 1;
 		}
 
-		/*
-		 * End a request through request sense analysis when we have
-		 * sense data. We need this in order to perform end of media
-		 * processing.
-		 */
-		if (do_end_request)
-			goto end_request;
+		if (!(rq->cmd_flags & REQ_QUIET)) {
+			ide_dump_status(drive, "command error", stat);
+			blk_dump_rq_flags(rq, PFX "failing rq");
+		}
+		do_end_request = 1;
+		break;
+	}
 
-		/*
-		 * If we got a CHECK_CONDITION status, queue
-		 * a request sense command.
-		 */
-		if (stat & ATA_ERR)
-			cdrom_queue_request_sense(drive, NULL, NULL);
-		return 1;
-	} else {
-		blk_dump_rq_flags(rq, PFX "bad rq");
-		return 2;
+	/* we've racked up too many retries, abort */
+	if (++rq->errors > ERROR_MAX)
+		do_end_request = 1;
+
+	if (do_end_request) {
+		rq->cmd_flags |= REQ_FAILED;
+		goto end_request;
 	}
 
+	/* If we got a CHECK_CONDITION status, queue a request sense command. */
+	if (stat & ATA_ERR)
+		cdrom_queue_request_sense(drive, NULL, NULL);
+
+	return 1;
+
 end_request:
 	if (stat & ATA_ERR) {
 		struct request_queue *q = drive->queue;
@@ -614,14 +589,15 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	struct request *rq = hwif->rq;
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, thislen, uptodate = 0;
-	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc, nsectors;
+	int write, uninitialized_var(rc), nsectors;
 	int sense = blk_sense_request(rq);
 	unsigned int timeout;
 	u16 len;
 	u8 ireason, stat;
 
-	ide_debug_log(IDE_DBG_PC, "cmd[0]: 0x%x, write: 0x%x",
-				  rq->cmd[0], write);
+	write = (rq_data_dir(rq) == WRITE) ? 1 : 0;
+
+	ide_debug_log(IDE_DBG_PC, "cmd: 0x%x, write: 0x%x", rq->cmd[0], write);
 
 	/* check for errors */
 	dma = drive->dma;
-- 
1.6.2.1


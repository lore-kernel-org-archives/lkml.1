Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbZDCH7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbZDCH7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbZDCH6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:58:54 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:46681 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZDCH6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:58:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ghi6hGN9r/5lVfXYBo9h2mQB2BO8l1O47lWEfqMdBFM/tOJ3Vza20sdVn6AINaRuE2
         U61yDwmewQJ8cv3UuZOhdX33CcPqBX7gtvtzmm6dbfR3Ik2EGrIXt9CkdMDbwRiTlgKx
         q63t7Ivm+VvqsU8mJX/XlRMDlSZu2athUjT00=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide-cd: cleanup cdrom_decode_status
Date: Fri,  3 Apr 2009 09:58:38 +0200
Message-Id: <1238745519-19389-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have (almost) equal handling of commands based solely on sense_key
by merging the different handling logic for pc and fs requests and
retaining old behavior, at the same time. As a result, this makes the
code more readable and eases later changes.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |  178 ++++++++++++++++++++-----------------------------
 1 files changed, 73 insertions(+), 105 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 7bbdeb7..bc37027 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -311,14 +311,15 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
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
@@ -328,126 +329,94 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
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
+			if (ide_cd_breathe(drive, rq))
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
+	case MEDIUM_ERROR:
+		/*
+		 * No point in re-trying a zillion times on a bad sector. If we
+		 * got here the error is not correctable.
+		 */
+		ide_dump_status(drive, "media error (bad sector)", stat);
+		do_end_request = 1;
+		break;
 
-				/* fail the request */
-				printk(KERN_ERR PFX "%s: tray open\n",
-						drive->name);
-			} else {
-				if (ide_cd_breathe(drive, rq))
-					return 1;
-			}
-			do_end_request = 1;
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
+		do_end_request = 1;
+		break;
+	}
+
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
@@ -631,8 +600,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	u16 len;
 	u8 ireason, stat;
 
-	ide_debug_log(IDE_DBG_PC, "cmd[0]: 0x%x, write: 0x%x",
-				  rq->cmd[0], write);
+	ide_debug_log(IDE_DBG_PC, "cmd: 0x%x, write: 0x%x", rq->cmd[0], write);
 
 	/* check for errors */
 	dma = drive->dma;
-- 
1.6.2.1


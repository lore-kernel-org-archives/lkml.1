Return-Path: <linux-kernel-owner+w=401wt.eu-S936627AbZDCT4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936627AbZDCT4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935477AbZDCTyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:54:44 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63523 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936470AbZDCTym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=OuO6HDzqU/J3b2dmlkLRnXA1ol5ilJzgprz+ThbeZ8Nr3hp7/lSeTvenXnyLHXL0hp
         +k05zCgI9X066YDTlnrzhB2c5N+DKXvoFf4p76/oxtJLyHTloTFCIFAcZTVF6Oxqevho
         P9ykTBYzbDXdMz2zvG1XAC23YeDIxrb6gnTXw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Apr 2009 21:58:24 +0200
Message-Id: <20090403195824.31438.50814.sendpatchset@localhost.localdomain>
In-Reply-To: <20090403195757.31438.16866.sendpatchset@localhost.localdomain>
References: <20090403195757.31438.16866.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/5] ide-cd: fix intendation in cdrom_decode_status()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: fix intendation in cdrom_decode_status()

Based on earlier work by Borislav Petkov.

Fix intendation in cdrom_decode_status(), no real code changes.

While at it:
- beautify comments

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |  190 ++++++++++++++++++++++++---------------------------
 1 file changed, 90 insertions(+), 100 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -311,7 +311,7 @@ static int cdrom_decode_status(ide_drive
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
-	int err, sense_key;
+	int err, sense_key, do_end_request = 0;
 
 	/* get the IDE error register */
 	err = ide_read_error(drive);
@@ -329,118 +329,108 @@ static int cdrom_decode_status(ide_drive
 		 */
 		rq->cmd_flags |= REQ_FAILED;
 		return 2;
-	} else {
-		int do_end_request = 0;
-
-		/*
-		 * if we have an error, pass back CHECK_CONDITION as the
-		 * scsi status byte
-		 */
-		if (blk_pc_request(rq) && !rq->errors)
-			rq->errors = SAM_STAT_CHECK_CONDITION;
-
-		if (blk_noretry_request(rq))
-			do_end_request = 1;
-
-		switch (sense_key) {
-		case NOT_READY:
-			if (blk_fs_request(rq) == 0 ||
-			    rq_data_dir(rq) == READ) {
-				cdrom_saw_media_change(drive);
+	}
 
-				if (blk_fs_request(rq) &&
-				    (rq->cmd_flags & REQ_QUIET) == 0)
-					printk(KERN_ERR PFX "%s: tray open\n",
-						drive->name);
-			} else {
-				if (ide_cd_breathe(drive, rq))
-					return 1;
-			}
-			do_end_request = 1;
-			break;
-		case UNIT_ATTENTION:
+	/* if we got an error, pass CHECK_CONDITION as the SCSI status byte */
+	if (blk_pc_request(rq) && !rq->errors)
+		rq->errors = SAM_STAT_CHECK_CONDITION;
+
+	if (blk_noretry_request(rq))
+		do_end_request = 1;
+
+	switch (sense_key) {
+	case NOT_READY:
+		if (blk_fs_request(rq) == 0 || rq_data_dir(rq) == READ) {
 			cdrom_saw_media_change(drive);
 
-			if (blk_fs_request(rq) == 0)
-				return 0;
-			/*
-			 * Arrange to retry the request but be sure to give up
-			 * if we've retried too many times.
-			 */
-			if (++rq->errors > ERROR_MAX)
-				do_end_request = 1;
-			break;
-		case ILLEGAL_REQUEST:
-			/*
-			 * Don't print error message for this condition--
-			 * SFF8090i indicates that 5/24/00 is the correct
-			 * response to a request to close the tray if the
-			 * drive doesn't have that capability.
-			 * cdrom_log_sense() knows this!
-			 */
-			if (rq->cmd[0] == GPCMD_START_STOP_UNIT)
-				break;
-			/* fall-through */
-		case DATA_PROTECT:
-			/*
-			 * No point in retrying after an illegal request or data
-			 * protect error.
-			 */
-			if ((rq->cmd_flags & REQ_QUIET) == 0)
-				ide_dump_status(drive, "command error", stat);
-			do_end_request = 1;
-			break;
-		case MEDIUM_ERROR:
-			/*
-			 * No point in re-trying a zillion times on a bad
-			 * sector. If we got here the error is not correctable.
-			 */
-			if ((rq->cmd_flags & REQ_QUIET) == 0)
-				ide_dump_status(drive, "media error "
-						"(bad sector)", stat);
-			do_end_request = 1;
-			break;
-		case BLANK_CHECK:
-			/* disk appears blank ?? */
-			if ((rq->cmd_flags & REQ_QUIET) == 0)
-				ide_dump_status(drive, "media error (blank)",
-						stat);
-			do_end_request = 1;
-			break;
-		default:
-			if (blk_fs_request(rq) == 0)
-				break;
-			if (err & ~ATA_ABORTED) {
-				/* go to the default handler for other errors */
-				ide_error(drive, "cdrom_decode_status", stat);
+			if (blk_fs_request(rq) &&
+			    (rq->cmd_flags & REQ_QUIET) == 0)
+				printk(KERN_ERR PFX "%s: tray open\n",
+					drive->name);
+		} else {
+			if (ide_cd_breathe(drive, rq))
 				return 1;
-			} else if (++rq->errors > ERROR_MAX)
-				/* we've racked up too many retries, abort */
-				do_end_request = 1;
 		}
+		do_end_request = 1;
+		break;
+	case UNIT_ATTENTION:
+		cdrom_saw_media_change(drive);
 
-		if (blk_fs_request(rq) == 0) {
-			rq->cmd_flags |= REQ_FAILED;
+		if (blk_fs_request(rq) == 0)
+			return 0;
+		/*
+		 * Arrange to retry the request but be sure to give up if we've
+		 * retried too many times.
+		 */
+		if (++rq->errors > ERROR_MAX)
 			do_end_request = 1;
-		}
-
+		break;
+	case ILLEGAL_REQUEST:
 		/*
-		 * End a request through request sense analysis when we have
-		 * sense data. We need this in order to perform end of media
-		 * processing.
+		 * Don't print error message for this condition -- SFF8090i
+		 * indicates that 5/24/00 is the correct response to a request
+		 * to close the tray if the drive doesn't have that capability.
+		 *
+		 * cdrom_log_sense() knows this!
 		 */
-		if (do_end_request)
-			goto end_request;
-
+		if (rq->cmd[0] == GPCMD_START_STOP_UNIT)
+			break;
+		/* fall-through */
+	case DATA_PROTECT:
 		/*
-		 * If we got a CHECK_CONDITION status, queue
-		 * a request sense command.
+		 * No point in retrying after an illegal request or data
+		 * protect error.
 		 */
-		if (stat & ATA_ERR)
-			cdrom_queue_request_sense(drive, NULL, NULL);
-		return 1;
+		if ((rq->cmd_flags & REQ_QUIET) == 0)
+			ide_dump_status(drive, "command error", stat);
+		do_end_request = 1;
+		break;
+	case MEDIUM_ERROR:
+		/*
+		 * No point in re-trying a zillion times on a bad sector.
+		 * If we got here the error is not correctable.
+		 */
+		if ((rq->cmd_flags & REQ_QUIET) == 0)
+			ide_dump_status(drive, "media error "
+					"(bad sector)", stat);
+		do_end_request = 1;
+		break;
+	case BLANK_CHECK:
+		/* disk appears blank? */
+		if ((rq->cmd_flags & REQ_QUIET) == 0)
+			ide_dump_status(drive, "media error (blank)",
+					stat);
+		do_end_request = 1;
+		break;
+	default:
+		if (blk_fs_request(rq) == 0)
+			break;
+		if (err & ~ATA_ABORTED) {
+			/* go to the default handler for other errors */
+			ide_error(drive, "cdrom_decode_status", stat);
+			return 1;
+		} else if (++rq->errors > ERROR_MAX)
+			/* we've racked up too many retries, abort */
+			do_end_request = 1;
 	}
 
+	if (blk_fs_request(rq) == 0) {
+		rq->cmd_flags |= REQ_FAILED;
+		do_end_request = 1;
+	}
+
+	/*
+	 * End a request through request sense analysis when we have sense data.
+	 * We need this in order to perform end of media processing.
+	 */
+	if (do_end_request)
+		goto end_request;
+
+	/* if we got a CHECK_CONDITION status, queue a request sense command */
+	if (stat & ATA_ERR)
+		cdrom_queue_request_sense(drive, NULL, NULL);
+	return 1;
+
 end_request:
 	if (stat & ATA_ERR) {
 		struct request_queue *q = drive->queue;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbZDEICf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbZDEICf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 04:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbZDEICR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 04:02:17 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:46550 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816AbZDEICP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 04:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=rbaQWY3M3OPdwlonZZTcfwPwLP37YKAlBg0s8zhs6+ci4X/eWY8wDn05nC5AjUoCNN
         zaS/oZRvOcB6ggj+AjInI7kfPHm7GJ8l3C9Sz+FniFBiu4MHJ3AKF0FmzJGTDcBGMdiE
         wAfmQ0SXwfaocy3Ix1EPSK9192IMmUCo6ReRA=
Date: Sun, 5 Apr 2009 10:02:09 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ide-cd: fix intendation in cdrom_decode_status()
Message-ID: <20090405080209.GA6433@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090403195757.31438.16866.sendpatchset@localhost.localdomain> <20090403195824.31438.50814.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090403195824.31438.50814.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 09:58:24PM +0200, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide-cd: fix intendation in cdrom_decode_status()a

Rediffed & lightly tested the whole series:

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sun, 5 Apr 2009 09:59:42 +0200
Subject: [PATCH] ide-cd: fix intendation in cdrom_decode_status()

Fix intendation in cdrom_decode_status(), no real code changes.

While at it:
- beautify comments

There should be no functional changes caused by this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |  186 ++++++++++++++++++++++++--------------------------
 1 files changed, 89 insertions(+), 97 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index ffbaa6d..2989aa8 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -311,7 +311,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
-	int err, sense_key;
+	int err, sense_key, do_end_request = 0;
 	u8 quiet = rq->cmd_flags & REQ_QUIET;
 
 	/* get the IDE error register */
@@ -330,116 +330,108 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
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
+	}
 
-		if (blk_noretry_request(rq))
-			do_end_request = 1;
+	/* if we have an error, pass CHECK_CONDITION as the SCSI status byte */
+	if (blk_pc_request(rq) && !rq->errors)
+		rq->errors = SAM_STAT_CHECK_CONDITION;
 
-		switch (sense_key) {
-		case NOT_READY:
-			if (blk_fs_request(rq) == 0 ||
-			    rq_data_dir(rq) == READ) {
-				cdrom_saw_media_change(drive);
+	if (blk_noretry_request(rq))
+		do_end_request = 1;
 
-				if (blk_fs_request(rq) && !quiet)
-					printk(KERN_ERR PFX "%s: tray open\n",
-						drive->name);
-			} else {
-				if (ide_cd_breathe(drive, rq))
-					return 1;
-			}
-			do_end_request = 1;
-			break;
-		case UNIT_ATTENTION:
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
-			if (!quiet)
-				ide_dump_status(drive, "command error", stat);
-			do_end_request = 1;
-			break;
-		case MEDIUM_ERROR:
-			/*
-			 * No point in re-trying a zillion times on a bad
-			 * sector. If we got here the error is not correctable.
-			 */
-			if (!quiet)
-				ide_dump_status(drive, "media error "
-						"(bad sector)",	stat);
-			do_end_request = 1;
-			break;
-		case BLANK_CHECK:
-			/* disk appears blank ?? */
-			if (!quiet)
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
+			if (blk_fs_request(rq) && !quiet)
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
-			do_end_request = 1;
-		}
+		if (blk_fs_request(rq) == 0)
+			return 0;
 
 		/*
-		 * End a request through request sense analysis when we have
-		 * sense data. We need this in order to perform end of media
-		 * processing.
+		 * Arrange to retry the request but be sure to give up if we've
+		 * retried too many times.
 		 */
-		if (do_end_request)
-			goto end_request;
-
+		if (++rq->errors > ERROR_MAX)
+			do_end_request = 1;
+		break;
+	case ILLEGAL_REQUEST:
+		/*
+		 * Don't print error message for this condition -- SFF8090i
+		 * indicates that 5/24/00 is the correct response to a request
+		 * to close the tray if the drive doesn't have that capability.
+		 *
+		 * cdrom_log_sense() knows this!
+		 */
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
+		if (!quiet)
+			ide_dump_status(drive, "command error", stat);
+		do_end_request = 1;
+		break;
+	case MEDIUM_ERROR:
+		/*
+		 * No point in re-trying a zillion times on a bad sector.
+		 * If we got here the error is not correctable.
+		 */
+		if (!quiet)
+			ide_dump_status(drive, "media error "
+					"(bad sector)", stat);
+		do_end_request = 1;
+		break;
+	case BLANK_CHECK:
+		/* disk appears blank? */
+		if (!quiet)
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
+
+
+	}
+
+	if (blk_fs_request(rq) == 0) {
+		rq->cmd_flags |= REQ_FAILED;
+		do_end_request = 1;
 	}
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
 
 end_request:
 	if (stat & ATA_ERR) {
-- 
1.6.2.1


-- 
Regards/Gruss,
    Boris.

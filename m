Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYFLGmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYFLGmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYFLGlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:9186 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYFLGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=H7dfVtB4xRLYEsB4i3v6RUkqbGrLG/FuIiiqBHxe4w1zNQaLQpow42FLRz1FD82ymw
         xMBU3nw0OKLP1RLaxjuxGNG9/s3hIqbSSwCoQtThKrLjn8UrDvTwKdaaaUiio43NlYun
         wj5CYi4Q2ytCEMDOMHMQVxdN5Rte1wYLFLNRY=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 04/18] ide-cd: cdrom_decode_status: factor out fs request error handling code
Date: Thu, 12 Jun 2008 08:40:56 +0200
Message-Id: <1213252870-20474-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... into cdrom_handle_failed_fs_req(). There's a slight change in internal
functionality in the case when we have sense NOT_READY and the request is WRITE: the
original function cdrom_decode_status returned 1 in this case, which means "request
was ended." We accomplish the same by returning 0 instead, which falls through in the
if..else block and the surrounding cdrom_decode_status() returns 1 at the end instead
of jumping to the end_request label as is in all the other cases, so no change
in obvious functionality.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |  206 +++++++++++++++++++++++++++-----------------------
 1 files changed, 111 insertions(+), 95 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 16c4ce9..e63eea2 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -314,12 +314,115 @@ static int cdrom_handle_failed_pc_req(ide_drive_t *drive, struct request *rq,
 	return 1;
 }
 
-
 /*
- * Returns:
- * 0: if the request should be continued.
- * 1: if the request was ended.
+ * Handle errors from READ and WRITE requests. Do a request sense analysis when
+ * we have sense data. We need this in order to perform end of media processing.
  */
+static int cdrom_handle_failed_fs_req(ide_drive_t *drive, struct request *rq,
+				      int sense_key, int stat)
+{
+	int err = 0;
+
+	if (blk_noretry_request(rq))
+		err = 1;
+
+	switch (sense_key) {
+	case NOT_READY:
+		/* tray open */
+		if (rq_data_dir(rq) == READ) {
+			cdrom_saw_media_change(drive);
+
+			/* fail the request */
+			printk(KERN_ERR "%s: tray open\n", drive->name);
+			err = 1;
+		} else {
+			struct cdrom_info *info = drive->driver_data;
+
+			/*
+			 * Allow the drive 5 seconds to recover, some devices
+			 * will return this error while flushing data from
+			 * cache.
+			 */
+			if (!rq->errors)
+				info->write_timeout = jiffies +
+						      ATAPI_WAIT_WRITE_BUSY;
+			rq->errors = 1;
+
+			if (time_after(jiffies, info->write_timeout))
+				err = 1;
+			else {
+				unsigned long flags;
+
+				/*
+				 * take a breather relying on the unplug timer
+				 * to kick us again
+				 */
+				spin_lock_irqsave(&ide_lock, flags);
+				blk_plug_device(drive->queue);
+				spin_unlock_irqrestore(&ide_lock, flags);
+				err = 0;
+			}
+		}
+		break;
+
+	case UNIT_ATTENTION:
+		/* media change */
+		cdrom_saw_media_change(drive);
+
+		/*
+		 * Arrange to retry the request but be sure to give up if we've
+		 * retried too many times.
+		 */
+		if (++rq->errors > ERROR_MAX)
+			err = 1;
+		break;
+
+	case ILLEGAL_REQUEST:
+	case DATA_PROTECT:
+
+		/*
+		 * No point in retrying after an illegal request or data
+		 * protect error.
+		 */
+		ide_dump_status_no_sense(drive, "command error", stat);
+		err = 1;
+		break;
+
+	case MEDIUM_ERROR:
+
+		/*
+		 * No point in re-trying a zillion times on a bad sector. If we
+		 * got here the error is not correctable.
+		 */
+		ide_dump_status_no_sense(drive, "media error (bad sector)",
+					 stat);
+		err = 1;
+		break;
+
+	case BLANK_CHECK:
+
+		/* disk appears blank ?? */
+		ide_dump_status_no_sense(drive, "media error (blank)", stat);
+		err = 1;
+		break;
+
+	default:
+		break;
+	}
+
+	if ((err & ~ABRT_ERR) != 0) {
+		/* go to the default handler for other errors */
+		ide_error(drive, "cdrom_handle_failed_fs_req", stat);
+		err = 1;
+	} else if ((++rq->errors > ERROR_MAX))
+
+		/* we've racked up too many retries, abort */
+		err = 1;
+
+	return err;
+}
+
+/* Returns 0 if the request should be continued, 1 otherwise. */
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
 	struct request *rq = HWGROUP(drive)->rq;
@@ -363,104 +466,17 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 			return 0;
 
 	} else if (blk_fs_request(rq)) {
-		int do_end_request = 0;
-
-		/* handle errors from READ and WRITE requests */
-
-		if (blk_noretry_request(rq))
-			do_end_request = 1;
-
-		if (sense_key == NOT_READY) {
-			/* tray open */
-			if (rq_data_dir(rq) == READ) {
-				cdrom_saw_media_change(drive);
 
-				/* fail the request */
-				printk(KERN_ERR "%s: tray open\n", drive->name);
-				do_end_request = 1;
-			} else {
-				struct cdrom_info *info = drive->driver_data;
-
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
-					unsigned long flags;
-
-					/*
-					 * take a breather relying on the unplug
-					 * timer to kick us again
-					 */
-					spin_lock_irqsave(&ide_lock, flags);
-					blk_plug_device(drive->queue);
-					spin_unlock_irqrestore(&ide_lock,
-								flags);
-					return 1;
-				}
-			}
-		} else if (sense_key == UNIT_ATTENTION) {
-			/* media change */
-			cdrom_saw_media_change(drive);
-
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
-			ide_dump_status_no_sense(drive, "command error", stat);
-			do_end_request = 1;
-		} else if (sense_key == MEDIUM_ERROR) {
-			/*
-			 * No point in re-trying a zillion times on a bad
-			 * sector. If we got here the error is not correctable.
-			 */
-			ide_dump_status_no_sense(drive,
-						 "media error (bad sector)",
-						 stat);
-			do_end_request = 1;
-		} else if (sense_key == BLANK_CHECK) {
-			/* disk appears blank ?? */
-			ide_dump_status_no_sense(drive, "media error (blank)",
-						 stat);
-			do_end_request = 1;
-		} else if ((err & ~ABRT_ERR) != 0) {
-			/* go to the default handler for other errors */
-			ide_error(drive, "cdrom_decode_status", stat);
-			return 1;
-		} else if ((++rq->errors > ERROR_MAX)) {
-			/* we've racked up too many retries, abort */
-			do_end_request = 1;
-		}
-
-		/*
-		 * End a request through request sense analysis when we have
-		 * sense data. We need this in order to perform end of media
-		 * processing.
-		 */
-		if (do_end_request)
+		if (cdrom_handle_failed_fs_req(drive, rq, sense_key, stat))
 			goto end_request;
 
 		/*
-		 * If we got a CHECK_CONDITION status, queue
-		 * a request sense command.
+		 * If we got a CHECK_CONDITION status, queue a request sense
+		 * command.
 		 */
 		if (stat & ERR_STAT)
 			cdrom_queue_request_sense(drive, NULL, NULL);
+
 	} else {
 		blk_dump_rq_flags(rq, "ide-cd: bad rq");
 		cdrom_end_request(drive, 0);
-- 
1.5.5.1


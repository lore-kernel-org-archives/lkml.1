Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYFLGmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYFLGmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbYFLGlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:8685 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYFLGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=r/LdPdB4kP28SdWZLxmAGhd6jXEPgZQMEC1wesuYEAGREvMQO5UlMY5FFT0dKDZhBH
         agmT1/pkVFX31gQ4XFWdryZbgNh+YlHR1JNG816tBmsoMV9hui8VGIjSSCbOf80Nqtbs
         N5UB7BB0lXqfiEnsi+Cu0B2Pien6pypsVkbqI=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 03/18] ide-cd: cdrom_decode_status: factor out block pc error handling code
Date: Thu, 12 Jun 2008 08:40:55 +0200
Message-Id: <1213252870-20474-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... into cdrom_handle_failed_pc_req().

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   81 +++++++++++++++++++++++++++----------------------
 1 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 2f0c9d4..16c4ce9 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -273,6 +273,48 @@ static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 st)
 	ide_dump_status(drive, msg, st);
 }
 
+/* All other functions, except for READ. */
+static int cdrom_handle_failed_pc_req(ide_drive_t *drive, struct request *rq,
+				      int sense_key, int stat)
+{
+	/*
+	 * if we have an error, pass back CHECK_CONDITION as the scsi status
+	 * byte
+	 */
+	if (blk_pc_request(rq) && !rq->errors)
+		rq->errors = SAM_STAT_CHECK_CONDITION;
+
+	/* check for tray open */
+	if (sense_key == NOT_READY) {
+		cdrom_saw_media_change(drive);
+	} else if (sense_key == UNIT_ATTENTION) {
+		/* check for media change */
+		cdrom_saw_media_change(drive);
+		return 0;
+	} else if (sense_key == ILLEGAL_REQUEST &&
+			rq->cmd[0] == GPCMD_START_STOP_UNIT) {
+
+		/*
+		 * Don't print error message for this condition - SFF8090i
+		 * indicates that 5/24/00 is the correct response to a request
+		 * to close the tray if the drive doesn't have that capability.
+		 * cdrom_log_sense() knows this!
+		 */
+	} else if (!(rq->cmd_flags & REQ_QUIET)) {
+		/* otherwise, print an error */
+		ide_dump_status(drive, "packet command error", stat);
+	}
+
+	rq->cmd_flags |= REQ_FAILED;
+
+	/* instead of playing games with moving completions around, remove
+	 * failed request completely and end it when the request sense has
+	 * completed.
+	 */
+	return 1;
+}
+
+
 /*
  * Returns:
  * 0: if the request should be continued.
@@ -314,44 +356,11 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		return 1;
 
 	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
-		/* All other functions, except for READ. */
 
-		/*
-		 * if we have an error, pass back CHECK_CONDITION as the
-		 * scsi status byte
-		 */
-		if (blk_pc_request(rq) && !rq->errors)
-			rq->errors = SAM_STAT_CHECK_CONDITION;
-
-		/* check for tray open */
-		if (sense_key == NOT_READY) {
-			cdrom_saw_media_change(drive);
-		} else if (sense_key == UNIT_ATTENTION) {
-			/* check for media change */
-			cdrom_saw_media_change(drive);
+		if (cdrom_handle_failed_pc_req(drive, rq, sense_key, stat))
+			goto end_request;
+		else
 			return 0;
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
-		}
-
-		rq->cmd_flags |= REQ_FAILED;
-
-		/*
-		 * instead of playing games with moving completions around,
-		 * remove failed request completely and end it when the
-		 * request sense has completed
-		 */
-		goto end_request;
 
 	} else if (blk_fs_request(rq)) {
 		int do_end_request = 0;
-- 
1.5.5.1


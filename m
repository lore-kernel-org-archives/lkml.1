Return-Path: <linux-kernel-owner+w=401wt.eu-S936568AbZDCTzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936568AbZDCTzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936280AbZDCTyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:54:37 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37371 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935526AbZDCTye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=UApz4ctmmF9CtWiMBAjBgk33M24ubKCufcdfDQST8mu1pcU3IMArEfRvcJZzlykKWE
         LZoleVZ1lZuV9bNO9Rz2FTRiqm7RT2n2KsCRhcaQPtgUyQBXfAGAjQOcVBg3zi1w3OaQ
         glTwXMdGSAv0R87CSt0hw/ZrDqOUp2ONlI+28=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Apr 2009 21:58:17 +0200
Message-Id: <20090403195817.31438.45522.sendpatchset@localhost.localdomain>
In-Reply-To: <20090403195757.31438.16866.sendpatchset@localhost.localdomain>
References: <20090403195757.31438.16866.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/5] ide-cd: unify handling of fs and pc requests in cdrom_decode_status()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: unify handling of fs and pc requests in cdrom_decode_status()

Based on earlier work by Borislav Petkov.

Unify handling of fs and pc requests in cdrom_decode_status().

While at it:
- remove unreachable code

The only change in functionality is that for pc requests more
detailed error message will be printed for following sense keys:
* ILLEGAL_REQUEST
* DATA_PROTECT
* MEDIUM_ERROR
* BLANK_CHECK

Cc: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   70 ++++++++++++++++++---------------------------------
 1 file changed, 25 insertions(+), 45 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -329,8 +329,8 @@ static int cdrom_decode_status(ide_drive
 		 */
 		rq->cmd_flags |= REQ_FAILED;
 		return 2;
-	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
-		/* All other functions, except for READ. */
+	} else {
+		int do_end_request = 0;
 
 		/*
 		 * if we have an error, pass back CHECK_CONDITION as the
@@ -339,53 +339,17 @@ static int cdrom_decode_status(ide_drive
 		if (blk_pc_request(rq) && !rq->errors)
 			rq->errors = SAM_STAT_CHECK_CONDITION;
 
-		switch (sense_key) {
-		case NOT_READY:
-			cdrom_saw_media_change(drive);
-			break;
-		case UNIT_ATTENTION:
-			cdrom_saw_media_change(drive);
-			return 0;
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
-		default:
-			if ((rq->cmd_flags & REQ_QUIET) == 0)
-				ide_dump_status(drive, "packet command error",
-						stat);
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
-
-	} else if (blk_fs_request(rq)) {
-		int do_end_request = 0;
-
-		/* handle errors from READ and WRITE requests */
-
 		if (blk_noretry_request(rq))
 			do_end_request = 1;
 
 		switch (sense_key) {
 		case NOT_READY:
-			if (rq_data_dir(rq) == READ) {
+			if (blk_fs_request(rq) == 0 ||
+			    rq_data_dir(rq) == READ) {
 				cdrom_saw_media_change(drive);
 
-				if ((rq->cmd_flags & REQ_QUIET) == 0)
+				if (blk_fs_request(rq) &&
+				    (rq->cmd_flags & REQ_QUIET) == 0)
 					printk(KERN_ERR PFX "%s: tray open\n",
 						drive->name);
 			} else {
@@ -397,6 +361,8 @@ static int cdrom_decode_status(ide_drive
 		case UNIT_ATTENTION:
 			cdrom_saw_media_change(drive);
 
+			if (blk_fs_request(rq) == 0)
+				return 0;
 			/*
 			 * Arrange to retry the request but be sure to give up
 			 * if we've retried too many times.
@@ -405,6 +371,16 @@ static int cdrom_decode_status(ide_drive
 				do_end_request = 1;
 			break;
 		case ILLEGAL_REQUEST:
+			/*
+			 * Don't print error message for this condition--
+			 * SFF8090i indicates that 5/24/00 is the correct
+			 * response to a request to close the tray if the
+			 * drive doesn't have that capability.
+			 * cdrom_log_sense() knows this!
+			 */
+			if (rq->cmd[0] == GPCMD_START_STOP_UNIT)
+				break;
+			/* fall-through */
 		case DATA_PROTECT:
 			/*
 			 * No point in retrying after an illegal request or data
@@ -432,6 +408,8 @@ static int cdrom_decode_status(ide_drive
 			do_end_request = 1;
 			break;
 		default:
+			if (blk_fs_request(rq) == 0)
+				break;
 			if (err & ~ATA_ABORTED) {
 				/* go to the default handler for other errors */
 				ide_error(drive, "cdrom_decode_status", stat);
@@ -441,6 +419,11 @@ static int cdrom_decode_status(ide_drive
 				do_end_request = 1;
 		}
 
+		if (blk_fs_request(rq) == 0) {
+			rq->cmd_flags |= REQ_FAILED;
+			do_end_request = 1;
+		}
+
 		/*
 		 * End a request through request sense analysis when we have
 		 * sense data. We need this in order to perform end of media
@@ -456,9 +439,6 @@ static int cdrom_decode_status(ide_drive
 		if (stat & ATA_ERR)
 			cdrom_queue_request_sense(drive, NULL, NULL);
 		return 1;
-	} else {
-		blk_dump_rq_flags(rq, PFX "bad rq");
-		return 2;
 	}
 
 end_request:

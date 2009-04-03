Return-Path: <linux-kernel-owner+w=401wt.eu-S936536AbZDCTzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936536AbZDCTzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935346AbZDCTya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:54:30 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37371 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934034AbZDCTy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PEWB0w+fUXCkImi+CTXqcdF9g1Rrzvi7LIAj/mq55MVdCUdTV+LT/8gIR9T/YPczVv
         W+F3Uj+J0xRIO51ejcBRUBxUL8GtBoSXQoi/mnvHkh7PpEJyL1NItOuGUBUUweWVZWWB
         A1Hv/7kjHTwPqYXUaGRvhUCGSJag68CfEZsok=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Apr 2009 21:58:10 +0200
Message-Id: <20090403195810.31438.66965.sendpatchset@localhost.localdomain>
In-Reply-To: <20090403195757.31438.16866.sendpatchset@localhost.localdomain>
References: <20090403195757.31438.16866.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/5] ide-cd: convert cdrom_decode_status() to use switch statements
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: convert cdrom_decode_status() to use switch statements

Based on earlier work by Borislav Petkov.

Convert cdrom_decode_status() to use switch statements in
preparation to unify handling of fs and pc requests.

While at it:
- remove superfluous comments and do minor CodingStyle fixups

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   57 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -339,15 +339,14 @@ static int cdrom_decode_status(ide_drive
 		if (blk_pc_request(rq) && !rq->errors)
 			rq->errors = SAM_STAT_CHECK_CONDITION;
 
-		/* check for tray open */
-		if (sense_key == NOT_READY) {
+		switch (sense_key) {
+		case NOT_READY:
 			cdrom_saw_media_change(drive);
-		} else if (sense_key == UNIT_ATTENTION) {
-			/* check for media change */
+			break;
+		case UNIT_ATTENTION:
 			cdrom_saw_media_change(drive);
 			return 0;
-		} else if (sense_key == ILLEGAL_REQUEST &&
-			   rq->cmd[0] == GPCMD_START_STOP_UNIT) {
+		case ILLEGAL_REQUEST:
 			/*
 			 * Don't print error message for this condition--
 			 * SFF8090i indicates that 5/24/00 is the correct
@@ -355,9 +354,13 @@ static int cdrom_decode_status(ide_drive
 			 * drive doesn't have that capability.
 			 * cdrom_log_sense() knows this!
 			 */
-		} else if (!(rq->cmd_flags & REQ_QUIET)) {
-			/* otherwise, print an error */
-			ide_dump_status(drive, "packet command error", stat);
+			if (rq->cmd[0] == GPCMD_START_STOP_UNIT)
+				break;
+			/* fall-through */
+		default:
+			if ((rq->cmd_flags & REQ_QUIET) == 0)
+				ide_dump_status(drive, "packet command error",
+						stat);
 		}
 
 		rq->cmd_flags |= REQ_FAILED;
@@ -377,12 +380,11 @@ static int cdrom_decode_status(ide_drive
 		if (blk_noretry_request(rq))
 			do_end_request = 1;
 
-		if (sense_key == NOT_READY) {
-			/* tray open */
+		switch (sense_key) {
+		case NOT_READY:
 			if (rq_data_dir(rq) == READ) {
 				cdrom_saw_media_change(drive);
 
-				/* fail the request */
 				if ((rq->cmd_flags & REQ_QUIET) == 0)
 					printk(KERN_ERR PFX "%s: tray open\n",
 						drive->name);
@@ -391,8 +393,8 @@ static int cdrom_decode_status(ide_drive
 					return 1;
 			}
 			do_end_request = 1;
-		} else if (sense_key == UNIT_ATTENTION) {
-			/* media change */
+			break;
+		case UNIT_ATTENTION:
 			cdrom_saw_media_change(drive);
 
 			/*
@@ -401,8 +403,9 @@ static int cdrom_decode_status(ide_drive
 			 */
 			if (++rq->errors > ERROR_MAX)
 				do_end_request = 1;
-		} else if (sense_key == ILLEGAL_REQUEST ||
-			   sense_key == DATA_PROTECT) {
+			break;
+		case ILLEGAL_REQUEST:
+		case DATA_PROTECT:
 			/*
 			 * No point in retrying after an illegal request or data
 			 * protect error.
@@ -410,7 +413,8 @@ static int cdrom_decode_status(ide_drive
 			if ((rq->cmd_flags & REQ_QUIET) == 0)
 				ide_dump_status(drive, "command error", stat);
 			do_end_request = 1;
-		} else if (sense_key == MEDIUM_ERROR) {
+			break;
+		case MEDIUM_ERROR:
 			/*
 			 * No point in re-trying a zillion times on a bad
 			 * sector. If we got here the error is not correctable.
@@ -419,19 +423,22 @@ static int cdrom_decode_status(ide_drive
 				ide_dump_status(drive, "media error "
 						"(bad sector)", stat);
 			do_end_request = 1;
-		} else if (sense_key == BLANK_CHECK) {
+			break;
+		case BLANK_CHECK:
 			/* disk appears blank ?? */
 			if ((rq->cmd_flags & REQ_QUIET) == 0)
 				ide_dump_status(drive, "media error (blank)",
 						stat);
 			do_end_request = 1;
-		} else if ((err & ~ATA_ABORTED) != 0) {
-			/* go to the default handler for other errors */
-			ide_error(drive, "cdrom_decode_status", stat);
-			return 1;
-		} else if ((++rq->errors > ERROR_MAX)) {
-			/* we've racked up too many retries, abort */
-			do_end_request = 1;
+			break;
+		default:
+			if (err & ~ATA_ABORTED) {
+				/* go to the default handler for other errors */
+				ide_error(drive, "cdrom_decode_status", stat);
+				return 1;
+			} else if (++rq->errors > ERROR_MAX)
+				/* we've racked up too many retries, abort */
+				do_end_request = 1;
 		}
 
 		/*

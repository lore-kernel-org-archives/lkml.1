Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZBAT2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZBAT2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbZBAT1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:27:17 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:21944 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZBAT1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:27:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=f/dU3nNMBHFE2t7O5xSkSfo2s7KCE9hVle2UDBJ+wWOtNps8wQYQyHM1ghHHtySx2U
         uPNLy54V2nrKFRh/AsYJLsVj+cJbOkdl15hbqBJbjFSiXyxSZEvo5FntEKMIx+8W/g3z
         9oWNFZfzcGHSuEU3R22xquwcpRYS6v9FwmOQY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 20:28:07 +0100
Message-Id: <20090201192807.1592.37491.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
References: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/8] ide: use ->end_request only for private device driver requests
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use ->end_request only for private device driver requests

* Move IDE{FLOPPY,TAPE}_ERROR_* defines to <linux/ide.h> and rename them
  to IDE_DRV_ERROR_*.

* Handle ->end_request special cases for floppy/tape media in ide_kill_rq().

* Call ->end_request only for private device driver requests.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c   |    7 ++-----
 drivers/ide/ide-io.c       |    7 ++++++-
 drivers/ide/ide-tape.c     |   19 +++++++------------
 drivers/ide/ide-taskfile.c |   16 +++-------------
 include/linux/ide.h        |    7 +++++++
 5 files changed, 25 insertions(+), 31 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -61,9 +61,6 @@
  */
 #define IDEFLOPPY_PC_DELAY	(HZ/20)	/* default delay for ZIP 100 (50ms) */
 
-/* Error code returned in rq->errors to the higher part of the driver. */
-#define	IDEFLOPPY_ERROR_GENERAL		101
-
 /*
  * Used to finish servicing a request. For read/write requests, we will call
  * ide_end_request to pass to the next buffer.
@@ -77,7 +74,7 @@ static int ide_floppy_end_request(ide_dr
 
 	switch (uptodate) {
 	case 0:
-		error = IDEFLOPPY_ERROR_GENERAL;
+		error = IDE_DRV_ERROR_GENERAL;
 		break;
 
 	case 1:
@@ -183,7 +180,7 @@ static ide_startstop_t idefloppy_issue_p
 		if (!(pc->flags & PC_FLAG_SUPPRESS_ERROR))
 			ide_floppy_report_error(floppy, pc);
 		/* Giving up */
-		pc->error = IDEFLOPPY_ERROR_GENERAL;
+		pc->error = IDE_DRV_ERROR_GENERAL;
 
 		drive->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -174,7 +174,12 @@ EXPORT_SYMBOL(ide_complete_rq);
 
 void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 {
-	if (rq->rq_disk) {
+	drive->failed_pc = NULL;
+
+	if (drive->media == ide_tape)
+		rq->errors = IDE_DRV_ERROR_GENERAL;
+
+	if (blk_special_request(rq) && rq->rq_disk) {
 		struct ide_driver *drv;
 
 		drv = *(struct ide_driver **)rq->rq_disk->private_data;
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -152,11 +152,6 @@ struct idetape_bh {
 #define IDETAPE_LU_RETENSION_MASK	2
 #define IDETAPE_LU_EOT_MASK		4
 
-/* Error codes returned in rq->errors to the higher part of the driver. */
-#define IDETAPE_ERROR_GENERAL		101
-#define IDETAPE_ERROR_FILEMARK		102
-#define IDETAPE_ERROR_EOD		103
-
 /* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
 #define IDETAPE_BLOCK_DESCRIPTOR	0
 #define IDETAPE_CAPABILITIES_PAGE	0x2a
@@ -422,19 +417,19 @@ static void idetape_analyze_error(ide_dr
 		}
 	}
 	if (pc->c[0] == READ_6 && (sense[2] & 0x80)) {
-		pc->error = IDETAPE_ERROR_FILEMARK;
+		pc->error = IDE_DRV_ERROR_FILEMARK;
 		pc->flags |= PC_FLAG_ABORT;
 	}
 	if (pc->c[0] == WRITE_6) {
 		if ((sense[2] & 0x40) || (tape->sense_key == 0xd
 		     && tape->asc == 0x0 && tape->ascq == 0x2)) {
-			pc->error = IDETAPE_ERROR_EOD;
+			pc->error = IDE_DRV_ERROR_EOD;
 			pc->flags |= PC_FLAG_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		if (tape->sense_key == 8) {
-			pc->error = IDETAPE_ERROR_EOD;
+			pc->error = IDE_DRV_ERROR_EOD;
 			pc->flags |= PC_FLAG_ABORT;
 		}
 		if (!(pc->flags & PC_FLAG_ABORT) &&
@@ -474,7 +469,7 @@ static int idetape_end_request(ide_drive
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	switch (uptodate) {
-	case 0:	error = IDETAPE_ERROR_GENERAL; break;
+	case 0: error = IDE_DRV_ERROR_GENERAL; break;
 	case 1: error = 0; break;
 	default: error = uptodate;
 	}
@@ -669,7 +664,7 @@ static ide_startstop_t idetape_issue_pc(
 						tape->ascq);
 			}
 			/* Giving up */
-			pc->error = IDETAPE_ERROR_GENERAL;
+			pc->error = IDE_DRV_ERROR_GENERAL;
 		}
 		drive->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
@@ -730,7 +725,7 @@ static ide_startstop_t idetape_media_acc
 		}
 		pc->error = 0;
 	} else {
-		pc->error = IDETAPE_ERROR_GENERAL;
+		pc->error = IDE_DRV_ERROR_GENERAL;
 		drive->failed_pc = NULL;
 	}
 	drive->pc_callback(drive, 0);
@@ -1210,7 +1205,7 @@ static int idetape_queue_rw_tail(ide_dri
 
 	if (tape->merge_bh)
 		idetape_init_merge_buffer(tape);
-	if (errors == IDETAPE_ERROR_GENERAL)
+	if (errors == IDE_DRV_ERROR_GENERAL)
 		return -EIO;
 	return ret;
 }
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -311,12 +311,8 @@ static ide_startstop_t task_error(ide_dr
 			break;
 		}
 
-		if (sectors > 0) {
-			struct ide_driver *drv;
-
-			drv = *(struct ide_driver **)rq->rq_disk->private_data;
-			drv->end_request(drive, 1, sectors);
-		}
+		if (sectors > 0)
+			ide_end_request(drive, 1, sectors);
 	}
 	return ide_error(drive, s, stat);
 }
@@ -333,13 +329,7 @@ void task_end_request(ide_drive_t *drive
 		return;
 	}
 
-	if (rq->rq_disk) {
-		struct ide_driver *drv;
-
-		drv = *(struct ide_driver **)rq->rq_disk->private_data;;
-		drv->end_request(drive, 1, rq->nr_sectors);
-	} else
-		ide_end_request(drive, 1, rq->nr_sectors);
+	ide_end_request(drive, 1, rq->nr_sectors);
 }
 
 /*
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -40,6 +40,13 @@
 #define ERROR_RESET	3	/* Reset controller every 4th retry */
 #define ERROR_RECAL	1	/* Recalibrate every 2nd retry */
 
+/* Error codes returned in rq->errors to the higher part of the driver. */
+enum {
+	IDE_DRV_ERROR_GENERAL	= 101,
+	IDE_DRV_ERROR_FILEMARK	= 102,
+	IDE_DRV_ERROR_EOD	= 103,
+};
+
 /*
  * Definitions for accessing IDE controller registers
  */

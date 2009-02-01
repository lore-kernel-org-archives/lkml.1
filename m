Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbZBAT27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbZBAT27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZBAT1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:27:24 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:53959 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbZBAT1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=o266NTr3pHoBAtztMYBCR/i/7zchgs42qmXCW7WdZM6Y8BVLqD7nqxjIDva6QRMtwa
         y2gKutnRgEPVXafwbUfMRcSnfFRWigMBTSkqh+s4TwQ1wYIYCCQBABBTViIIl3htbvGq
         blnKFCnB1N0IE6RNqyAz5ASXJnw956o1YhU58=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 20:28:14 +0100
Message-Id: <20090201192814.1592.94679.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
References: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/8] ide-{floppy,tape}: cleanup ide*_end_request()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-{floppy,tape}: cleanup ide*_end_request()

* ide*_end_request() is only called with uptodate == 0 or uptodate == 1
  so cleanup it accordingly.

* Inline ide*_end_request() content at call sites so the only user left
  is ->end_request method.

* ->end_request is now used only for private driver requests so remove
  handling of other requests from ide*_end_request().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   66 ++++++++++++++++++++++-------------------------
 drivers/ide/ide-tape.c   |   40 +++++++++++++++-------------
 2 files changed, 53 insertions(+), 53 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -62,40 +62,21 @@
 #define IDEFLOPPY_PC_DELAY	(HZ/20)	/* default delay for ZIP 100 (50ms) */
 
 /*
- * Used to finish servicing a request. For read/write requests, we will call
- * ide_end_request to pass to the next buffer.
+ * Used to finish servicing a private request.
  */
 static int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
 	struct request *rq = drive->hwif->rq;
-	int error;
 
 	ide_debug_log(IDE_DBG_FUNC, "enter");
 
-	switch (uptodate) {
-	case 0:
-		error = IDE_DRV_ERROR_GENERAL;
-		break;
-
-	case 1:
-		error = 0;
-		break;
-
-	default:
-		error = uptodate;
-	}
-
-	if (error)
+	if (uptodate == 0)
 		drive->failed_pc = NULL;
 
-	if (!blk_special_request(rq)) {
-		/* our real local end request function */
-		ide_end_request(drive, uptodate, nsecs);
-		return 0;
-	}
-	rq->errors = error;
-	/* fixme: need to move this local also */
+	rq->errors = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
+
 	ide_complete_rq(drive, 0);
+
 	return 0;
 }
 
@@ -106,13 +87,14 @@ static void idefloppy_update_buffers(ide
 	struct bio *bio = rq->bio;
 
 	while ((bio = rq->bio) != NULL)
-		ide_floppy_end_request(drive, 1, 0);
+		ide_end_request(drive, 1, 0);
 }
 
 static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->pc;
+	struct request *rq = pc->rq;
 	int uptodate = pc->error ? 0 : 1;
 
 	ide_debug_log(IDE_DBG_FUNC, "enter");
@@ -121,7 +103,7 @@ static void ide_floppy_callback(ide_driv
 		drive->failed_pc = NULL;
 
 	if (pc->c[0] == GPCMD_READ_10 || pc->c[0] == GPCMD_WRITE_10 ||
-	    (pc->rq && blk_pc_request(pc->rq)))
+	    (rq && blk_pc_request(rq)))
 		uptodate = 1; /* FIXME */
 	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
 		u8 *buf = pc->buf;
@@ -145,7 +127,14 @@ static void ide_floppy_callback(ide_driv
 			       "Aborting request!\n");
 	}
 
-	ide_floppy_end_request(drive, uptodate, 0);
+	if (uptodate == 0)
+		drive->failed_pc = NULL;
+
+	if (blk_special_request(rq)) {
+		rq->errors = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
+		ide_complete_rq(drive, 0);
+	} else
+		ide_end_request(drive, uptodate, 0);
 }
 
 static void ide_floppy_report_error(struct ide_disk_obj *floppy,
@@ -286,21 +275,25 @@ static ide_startstop_t ide_floppy_do_req
 					: "dev?"));
 
 	if (rq->errors >= ERROR_MAX) {
-		if (drive->failed_pc)
+		if (drive->failed_pc) {
 			ide_floppy_report_error(floppy, drive->failed_pc);
-		else
+			drive->failed_pc = NULL;
+		} else
 			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
 
-		ide_floppy_end_request(drive, 0, 0);
-		return ide_stopped;
+		if (blk_special_request(rq)) {
+			rq->errors = IDE_DRV_ERROR_GENERAL;
+			ide_complete_rq(drive, 0);
+			return ide_stopped;
+		} else
+			goto out_end;
 	}
 	if (blk_fs_request(rq)) {
 		if (((long)rq->sector % floppy->bs_factor) ||
 		    (rq->nr_sectors % floppy->bs_factor)) {
 			printk(KERN_ERR PFX "%s: unsupported r/w rq size\n",
 				drive->name);
-			ide_floppy_end_request(drive, 0, 0);
-			return ide_stopped;
+			goto out_end;
 		}
 		pc = &floppy->queued_pc;
 		idefloppy_create_rw_cmd(drive, pc, rq, (unsigned long)block);
@@ -311,8 +304,7 @@ static ide_startstop_t ide_floppy_do_req
 		idefloppy_blockpc_cmd(floppy, pc, rq);
 	} else {
 		blk_dump_rq_flags(rq, PFX "unsupported command in queue");
-		ide_floppy_end_request(drive, 0, 0);
-		return ide_stopped;
+		goto out_end;
 	}
 
 	ide_init_sg_cmd(drive, rq);
@@ -324,6 +316,10 @@ static ide_startstop_t ide_floppy_do_req
 	pc->rq = rq;
 
 	return idefloppy_issue_pc(drive, pc);
+out_end:
+	drive->failed_pc = NULL;
+	ide_end_request(drive, 0, 0);
+	return ide_stopped;
 }
 
 /*
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -464,23 +464,13 @@ static void ide_tape_kfree_buffer(idetap
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 {
 	struct request *rq = drive->hwif->rq;
-	int error;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	switch (uptodate) {
-	case 0: error = IDE_DRV_ERROR_GENERAL; break;
-	case 1: error = 0; break;
-	default: error = uptodate;
-	}
-	rq->errors = error;
-	if (error)
-		drive->failed_pc = NULL;
+	rq->errors = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
 
-	if (!blk_special_request(rq)) {
-		ide_end_request(drive, uptodate, nr_sects);
-		return 0;
-	}
+	if (uptodate == 0)
+		drive->failed_pc = NULL;
 
 	ide_complete_rq(drive, 0);
 
@@ -493,7 +483,9 @@ static void ide_tape_callback(ide_drive_
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->pc;
+	struct request *rq = drive->hwif->rq;
 	int uptodate = pc->error ? 0 : 1;
+	int err = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
@@ -510,7 +502,6 @@ static void ide_tape_callback(ide_drive_
 			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
 					"itself - Aborting request!\n");
 	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
-		struct request *rq = drive->hwif->rq;
 		int blocks = pc->xferred / tape->blk_size;
 
 		tape->avg_size += blocks * tape->blk_size;
@@ -525,8 +516,10 @@ static void ide_tape_callback(ide_drive_
 		tape->first_frame += blocks;
 		rq->current_nr_sectors -= blocks;
 
-		if (pc->error)
-			uptodate = pc->error;
+		if (pc->error) {
+			uptodate = 0;
+			err = pc->error;
+		}
 	} else if (pc->c[0] == READ_POSITION && uptodate) {
 		u8 *readpos = pc->buf;
 
@@ -540,6 +533,7 @@ static void ide_tape_callback(ide_drive_
 					 "to the tape\n");
 			clear_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
 			uptodate = 0;
+			err = IDE_DRV_ERROR_GENERAL;
 		} else {
 			debug_log(DBG_SENSE, "Block Location - %u\n",
 					be32_to_cpup((__be32 *)&readpos[4]));
@@ -550,7 +544,15 @@ static void ide_tape_callback(ide_drive_
 		}
 	}
 
-	idetape_end_request(drive, uptodate, 0);
+	rq->errors = err;
+
+	if (uptodate == 0)
+		drive->failed_pc = NULL;
+
+	if (blk_special_request(rq))
+		ide_complete_rq(drive, 0);
+	else
+		ide_end_request(drive, uptodate, 0);
 }
 
 /*
@@ -794,7 +796,9 @@ static ide_startstop_t idetape_do_reques
 		if (rq != postponed_rq) {
 			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
 					"Two DSC requests were queued\n");
-			idetape_end_request(drive, 0, 0);
+			rq->errors = IDE_DRV_ERROR_GENERAL;
+			drive->failed_pc = NULL;
+			ide_complete_rq(drive, 0);
 			return ide_stopped;
 		}
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZBAT22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZBAT22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZBAT1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:27:12 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:51320 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZBAT1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:27:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NTHx0SWmqlGm8LGc+EPjI+dnEPQpRIP/wptw2fH25thw8cWBTtnhv5eZMzPo+Wt55y
         Q5A9cBkjwQ3SQLP0Nvq+GpR3CZbUumCQ3q9sP6CM7BB9yaHhZMhruEBdcTq+iV7MndnC
         VaaEdKp1ijud+P5ELBUWQ+owwPUoC3VL8FBdU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 20:28:00 +0100
Message-Id: <20090201192800.1592.20438.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
References: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/8] ide: move ->failed_pc to ide_drive_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move ->failed_pc to ide_drive_t

Move ->failed_pc from struct ide_{disk,tape}_obj to ide_drive_t.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   21 ++++++++++-----------
 drivers/ide/ide-gd.h     |    2 --
 drivers/ide/ide-tape.c   |   29 ++++++++++-------------------
 include/linux/ide.h      |    3 +++
 4 files changed, 23 insertions(+), 32 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -70,7 +70,6 @@
  */
 static int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
-	struct ide_disk_obj *floppy = drive->driver_data;
 	struct request *rq = drive->hwif->rq;
 	int error;
 
@@ -90,7 +89,7 @@ static int ide_floppy_end_request(ide_dr
 	}
 
 	if (error)
-		floppy->failed_pc = NULL;
+		drive->failed_pc = NULL;
 
 	if (!blk_special_request(rq)) {
 		/* our real local end request function */
@@ -121,8 +120,8 @@ static void ide_floppy_callback(ide_driv
 
 	ide_debug_log(IDE_DBG_FUNC, "enter");
 
-	if (floppy->failed_pc == pc)
-		floppy->failed_pc = NULL;
+	if (drive->failed_pc == pc)
+		drive->failed_pc = NULL;
 
 	if (pc->c[0] == GPCMD_READ_10 || pc->c[0] == GPCMD_WRITE_10 ||
 	    (pc->rq && blk_pc_request(pc->rq)))
@@ -137,9 +136,9 @@ static void ide_floppy_callback(ide_driv
 			floppy->progress_indication = buf[15] & 0x80 ?
 				(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
 
-			if (floppy->failed_pc)
+			if (drive->failed_pc)
 				ide_debug_log(IDE_DBG_PC, "pc = %x",
-					      floppy->failed_pc->c[0]);
+					      drive->failed_pc->c[0]);
 
 			ide_debug_log(IDE_DBG_SENSE, "sense key = %x, asc = %x,"
 				      "ascq = %x", floppy->sense_key,
@@ -173,9 +172,9 @@ static ide_startstop_t idefloppy_issue_p
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 
-	if (floppy->failed_pc == NULL &&
+	if (drive->failed_pc == NULL &&
 	    pc->c[0] != GPCMD_REQUEST_SENSE)
-		floppy->failed_pc = pc;
+		drive->failed_pc = pc;
 
 	/* Set the current packet command */
 	drive->pc = pc;
@@ -186,7 +185,7 @@ static ide_startstop_t idefloppy_issue_p
 		/* Giving up */
 		pc->error = IDEFLOPPY_ERROR_GENERAL;
 
-		floppy->failed_pc = NULL;
+		drive->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
 		return ide_stopped;
 	}
@@ -290,8 +289,8 @@ static ide_startstop_t ide_floppy_do_req
 					: "dev?"));
 
 	if (rq->errors >= ERROR_MAX) {
-		if (floppy->failed_pc)
-			ide_floppy_report_error(floppy, floppy->failed_pc);
+		if (drive->failed_pc)
+			ide_floppy_report_error(floppy, drive->failed_pc);
 		else
 			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
 
Index: b/drivers/ide/ide-gd.h
===================================================================
--- a/drivers/ide/ide-gd.h
+++ b/drivers/ide/ide-gd.h
@@ -20,8 +20,6 @@ struct ide_disk_obj {
 	struct kref		kref;
 	unsigned int		openers;	/* protected by BKL for now */
 
-	/* Last failed packet command */
-	struct ide_atapi_pc *failed_pc;
 	/* used for blk_{fs,pc}_request() requests */
 	struct ide_atapi_pc queued_pc;
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -171,14 +171,6 @@ typedef struct ide_tape_obj {
 	struct gendisk		*disk;
 	struct kref		kref;
 
-	/*
-	 *	failed_pc points to the last failed packet command, or contains
-	 *	NULL if we do not need to retry any packet command. This is
-	 *	required since an additional packet command is needed before the
-	 *	retry, to get detailed information on what went wrong.
-	 */
-	/* Last failed packet command */
-	struct ide_atapi_pc *failed_pc;
 	/* used by REQ_IDETAPE_{READ,WRITE} requests */
 	struct ide_atapi_pc queued_pc;
 
@@ -397,7 +389,7 @@ static void idetape_update_buffers(ide_d
 static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc *pc = tape->failed_pc;
+	struct ide_atapi_pc *pc = drive->failed_pc;
 
 	tape->sense_key = sense[2] & 0xF;
 	tape->asc       = sense[12];
@@ -477,7 +469,6 @@ static void ide_tape_kfree_buffer(idetap
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 {
 	struct request *rq = drive->hwif->rq;
-	idetape_tape_t *tape = drive->driver_data;
 	int error;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
@@ -489,7 +480,7 @@ static int idetape_end_request(ide_drive
 	}
 	rq->errors = error;
 	if (error)
-		tape->failed_pc = NULL;
+		drive->failed_pc = NULL;
 
 	if (!blk_special_request(rq)) {
 		ide_end_request(drive, uptodate, nr_sects);
@@ -514,8 +505,8 @@ static void ide_tape_callback(ide_drive_
 	if (dsc)
 		ide_tape_handle_dsc(drive);
 
-	if (tape->failed_pc == pc)
-		tape->failed_pc = NULL;
+	if (drive->failed_pc == pc)
+		drive->failed_pc = NULL;
 
 	if (pc->c[0] == REQUEST_SENSE) {
 		if (uptodate)
@@ -653,8 +644,8 @@ static ide_startstop_t idetape_issue_pc(
 			"Two request sense in serial were issued\n");
 	}
 
-	if (tape->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
-		tape->failed_pc = pc;
+	if (drive->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
+		drive->failed_pc = pc;
 
 	/* Set the current packet command */
 	drive->pc = pc;
@@ -680,7 +671,7 @@ static ide_startstop_t idetape_issue_pc(
 			/* Giving up */
 			pc->error = IDETAPE_ERROR_GENERAL;
 		}
-		tape->failed_pc = NULL;
+		drive->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
 		return ide_stopped;
 	}
@@ -740,7 +731,7 @@ static ide_startstop_t idetape_media_acc
 		pc->error = 0;
 	} else {
 		pc->error = IDETAPE_ERROR_GENERAL;
-		tape->failed_pc = NULL;
+		drive->failed_pc = NULL;
 	}
 	drive->pc_callback(drive, 0);
 	return ide_stopped;
@@ -799,8 +790,8 @@ static ide_startstop_t idetape_do_reques
 	}
 
 	/* Retry a failed packet command */
-	if (tape->failed_pc && drive->pc->c[0] == REQUEST_SENSE) {
-		pc = tape->failed_pc;
+	if (drive->failed_pc && drive->pc->c[0] == REQUEST_SENSE) {
+		pc = drive->failed_pc;
 		goto out;
 	}
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -609,6 +609,9 @@ struct ide_drive_s {
 	/* current packet command */
 	struct ide_atapi_pc *pc;
 
+	/* last failed packet command */
+	struct ide_atapi_pc *failed_pc;
+
 	/* callback for packet commands */
 	void (*pc_callback)(struct ide_drive_s *, int);
 

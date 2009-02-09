Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbZBIUBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbZBIUBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbZBIUAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:00:06 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:24537 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbZBIUAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:00:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=SMXu0QMkbAGAB+AMwdICaLZyLcwa7t0HU7dsVSP4+lW0kQRIlrW0fYO5esLhH/hhAn
         6YUeVCKBUqHGVyYuLae0umq/s1MiZJ1D1LNbsWmS5nlTqoWPXa2ngYFQNrAnueeRfOZ3
         tzKv2uTFjAdEgpVzi+7omu0KBtBtxVpvvX0qM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 09 Feb 2009 21:01:13 +0100
Message-Id: <20090209200113.7985.38988.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
References: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/9] ide: pass error value to ide_complete_rq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: pass error value to ide_complete_rq()

Set rq->errors at ide_complete_rq() call sites and then pass
error value to ide_complete_rq().

[ Some rq->errors assignments look really wrong but this patch
  leaves them alone to not introduce too many changes at once. ]

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c    |    5 +++--
 drivers/ide/ide-eh.c       |    5 +++--
 drivers/ide/ide-floppy.c   |    2 +-
 drivers/ide/ide-io.c       |   19 +++++++++----------
 drivers/ide/ide-tape.c     |    2 +-
 drivers/ide/ide-taskfile.c |    4 +++-
 include/linux/ide.h        |    2 +-
 7 files changed, 21 insertions(+), 18 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -390,9 +390,10 @@ static ide_startstop_t ide_pc_intr(ide_d
 		if (uptodate == 0)
 			drive->failed_pc = NULL;
 
-		if (blk_special_request(rq))
+		if (blk_special_request(rq)) {
+			rq->errors = 0;
 			ide_complete_rq(drive, 0);
-		else
+		} else
 			ide_end_request(drive, uptodate, 0);
 
 		return ide_stopped;
Index: b/drivers/ide/ide-eh.c
===================================================================
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -123,17 +123,18 @@ ide_startstop_t ide_error(ide_drive_t *d
 
 	/* retry only "normal" I/O: */
 	if (!blk_fs_request(rq)) {
-		rq->errors = 1;
 		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 			struct ide_cmd *cmd = rq->special;
 
 			if (cmd)
 				ide_complete_cmd(drive, cmd, stat, err);
 		} else if (blk_pm_request(rq)) {
+			rq->errors = 1;
 			ide_complete_pm_rq(drive, rq);
 			return ide_stopped;
 		}
-		ide_complete_rq(drive, err);
+		rq->errors = err;
+		ide_complete_rq(drive, err ? -EIO : 0);
 		return ide_stopped;
 	}
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -260,7 +260,7 @@ static ide_startstop_t ide_floppy_do_req
 			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
 
 		if (blk_special_request(rq)) {
-			rq->errors = IDE_DRV_ERROR_GENERAL;
+			rq->errors = 0;
 			ide_complete_rq(drive, 0);
 			return ide_stopped;
 		} else
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -140,17 +140,14 @@ void ide_complete_cmd(ide_drive_t *drive
 		kfree(cmd);
 }
 
-void ide_complete_rq(ide_drive_t *drive, u8 err)
+void ide_complete_rq(ide_drive_t *drive, int error)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
 
 	hwif->rq = NULL;
 
-	rq->errors = err;
-
-	if (unlikely(blk_end_request(rq, (rq->errors ? -EIO : 0),
-				     blk_rq_bytes(rq))))
+	if (unlikely(blk_end_request(rq, error, blk_rq_bytes(rq))))
 		BUG();
 }
 EXPORT_SYMBOL(ide_complete_rq);
@@ -162,13 +159,14 @@ void ide_kill_rq(ide_drive_t *drive, str
 
 	drive->failed_pc = NULL;
 
-	if ((media == ide_floppy && drv_req) || media == ide_tape)
-		rq->errors = IDE_DRV_ERROR_GENERAL;
-
-	if ((media == ide_floppy || media == ide_tape) && drv_req)
+	if ((media == ide_floppy || media == ide_tape) && drv_req) {
+		rq->errors = 0;
 		ide_complete_rq(drive, 0);
-	else
+	} else {
+		if (media == ide_tape)
+			rq->errors = IDE_DRV_ERROR_GENERAL;
 		ide_end_request(drive, 0, 0);
+	}
 }
 
 static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
@@ -308,6 +306,7 @@ static ide_startstop_t execute_drive_cmd
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
+	rq->errors = 0;
 	ide_complete_rq(drive, 0);
 
  	return ide_stopped;
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -774,8 +774,8 @@ static ide_startstop_t idetape_do_reques
 		if (rq != postponed_rq) {
 			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
 					"Two DSC requests were queued\n");
-			rq->errors = IDE_DRV_ERROR_GENERAL;
 			drive->failed_pc = NULL;
+			rq->errors = 0;
 			ide_complete_rq(drive, 0);
 			return ide_stopped;
 		}
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -289,10 +289,12 @@ static void ide_error_cmd(ide_drive_t *d
 
 void ide_finish_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat)
 {
+	struct request *rq = drive->hwif->rq;
 	u8 err = ide_read_error(drive);
 
 	ide_complete_cmd(drive, cmd, stat, err);
-	ide_complete_rq(drive, err);
+	rq->errors = err;
+	ide_complete_rq(drive, err ? -EIO : 0);
 }
 
 /*
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1163,7 +1163,7 @@ extern int ide_devset_execute(ide_drive_
 			      const struct ide_devset *setting, int arg);
 
 void ide_complete_cmd(ide_drive_t *, struct ide_cmd *, u8, u8);
-void ide_complete_rq(ide_drive_t *, u8);
+void ide_complete_rq(ide_drive_t *, int);
 
 void ide_tf_dump(const char *, struct ide_taskfile *);
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZBEVfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZBEVfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZBEVeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:34:46 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:37242 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZBEVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=QE/1GKe+lQNXpdfBZU4BMQdL0LR+MznKY5afIl8dD7wFoviombBi680XQRR8KFLW3n
         zD2Y+W4OAqh63hO6JYeClpdRUlfsQJEYVl1/6jI1cn4it5cdztIb7kTOZEGqishQrzl5
         3nHEbixMJrIsGwCLie7dvakAWZD14JiO2dPaM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: move request type specific code from ide_end_drive_cmd() to callers (v2)
Date: Thu, 5 Feb 2009 21:29:40 +0100
User-Agent: KMail/1.10.4 (Linux/2.6.29-rc3-next-20090204; KDE/4.1.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902052129.40866.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move request type specific code from ide_end_drive_cmd() to callers (v2)

* Move request type specific code from ide_end_drive_cmd() to callers.

* Remove stale ide_end_drive_cmd() documentation and drop no longer
  used 'stat' argument.  Then rename the function to ide_complete_rq().

v2:
* Fix handling of blk_pm_request() requests in task_no_data_intr().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch for the one posted before -- it fixes the bug catched
during pre-merge re-audit phase

[ no point in resending whole patchset as its fixed version is in
  pata-2.6 tree now ]

 drivers/ide/ide-eh.c       |   11 ++++++++++-
 drivers/ide/ide-floppy.c   |    2 +-
 drivers/ide/ide-io.c       |   36 ++++++------------------------------
 drivers/ide/ide-tape.c     |    2 +-
 drivers/ide/ide-taskfile.c |   26 +++++++++++++++++++-------
 include/linux/ide.h        |    3 ++-
 6 files changed, 39 insertions(+), 41 deletions(-)

Index: b/drivers/ide/ide-eh.c
===================================================================
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -124,7 +124,16 @@ ide_startstop_t ide_error(ide_drive_t *d
 	/* retry only "normal" I/O: */
 	if (!blk_fs_request(rq)) {
 		rq->errors = 1;
-		ide_end_drive_cmd(drive, stat, err);
+		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
+			ide_task_t *task = rq->special;
+
+			if (task)
+				ide_complete_task(drive, task, stat, err);
+		} else if (blk_pm_request(rq)) {
+			ide_complete_pm_rq(drive, rq);
+			return ide_stopped;
+		}
+		ide_complete_rq(drive, err);
 		return ide_stopped;
 	}
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -101,7 +101,7 @@ static int ide_floppy_end_request(ide_dr
 	}
 	rq->errors = error;
 	/* fixme: need to move this local also */
-	ide_end_drive_cmd(drive, 0, 0);
+	ide_complete_rq(drive, 0);
 	return 0;
 }
 
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -144,8 +144,7 @@ int ide_end_dequeued_request(ide_drive_t
 }
 EXPORT_SYMBOL_GPL(ide_end_dequeued_request);
 
-static void ide_complete_task(ide_drive_t *drive, ide_task_t *task,
-			      u8 stat, u8 err)
+void ide_complete_task(ide_drive_t *drive, ide_task_t *task, u8 stat, u8 err)
 {
 	struct ide_taskfile *tf = &task->tf;
 
@@ -158,35 +157,11 @@ static void ide_complete_task(ide_drive_
 		kfree(task);
 }
 
-/**
- *	ide_end_drive_cmd	-	end an explicit drive command
- *	@drive: command 
- *	@stat: status bits
- *	@err: error bits
- *
- *	Clean up after success/failure of an explicit drive command.
- *	These get thrown onto the queue so they are synchronized with
- *	real I/O operations on the drive.
- *
- *	In LBA48 mode we have to read the register set twice to get
- *	all the extra information out.
- */
- 
-void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
+void ide_complete_rq(ide_drive_t *drive, u8 err)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
 
-	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
-		ide_task_t *task = (ide_task_t *)rq->special;
-
-		if (task)
-			ide_complete_task(drive, task, stat, err);
-	} else if (blk_pm_request(rq)) {
-		ide_complete_pm_rq(drive, rq);
-		return;
-	}
-
 	hwif->rq = NULL;
 
 	rq->errors = err;
@@ -195,7 +170,7 @@ void ide_end_drive_cmd (ide_drive_t *dri
 				     blk_rq_bytes(rq))))
 		BUG();
 }
-EXPORT_SYMBOL(ide_end_drive_cmd);
+EXPORT_SYMBOL(ide_complete_rq);
 
 void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 {
@@ -358,8 +333,9 @@ static ide_startstop_t execute_drive_cmd
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
-	ide_end_drive_cmd(drive, hwif->tp_ops->read_status(hwif),
-			  ide_read_error(drive));
+	(void)hwif->tp_ops->read_status(hwif);
+
+	ide_complete_rq(drive, ide_read_error(drive));
 
  	return ide_stopped;
 }
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -502,7 +502,7 @@ static int idetape_end_request(ide_drive
 
 	spin_lock_irqsave(&tape->lock, flags);
 
-	ide_end_drive_cmd(drive, 0, 0);
+	ide_complete_rq(drive, 0);
 
 	spin_unlock_irqrestore(&tape->lock, flags);
 	return 0;
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -147,12 +147,9 @@ static ide_startstop_t task_no_data_intr
 			}
 		}
 		return ide_error(drive, "task_no_data_intr", stat);
-		/* calls ide_end_drive_cmd */
 	}
 
-	if (!custom)
-		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
-	else if (tf->command == ATA_CMD_IDLEIMMEDIATE) {
+	if (custom && tf->command == ATA_CMD_IDLEIMMEDIATE) {
 		hwif->tp_ops->tf_read(drive, task);
 		if (tf->lbal != 0xc4) {
 			printk(KERN_ERR "%s: head unload failed!\n",
@@ -160,10 +157,22 @@ static ide_startstop_t task_no_data_intr
 			ide_tf_dump(drive->name, tf);
 		} else
 			drive->dev_flags |= IDE_DFLAG_PARKED;
-		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
-	} else if (tf->command == ATA_CMD_SET_MULTI)
+	} else if (custom && tf->command == ATA_CMD_SET_MULTI)
 		drive->mult_count = drive->mult_req;
 
+	if (custom == 0 || tf->command == ATA_CMD_IDLEIMMEDIATE) {
+		struct request *rq = hwif->rq;
+		u8 err = ide_read_error(drive);
+
+		if (blk_pm_request(rq))
+			ide_complete_pm_rq(drive, rq);
+		else {
+			if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
+				ide_complete_task(drive, task, stat, err);
+			ide_complete_rq(drive, err);
+		}
+	}
+
 	return ide_stopped;
 }
 
@@ -321,9 +330,12 @@ static ide_startstop_t task_error(ide_dr
 void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 {
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
+		ide_task_t *task = rq->special;
 		u8 err = ide_read_error(drive);
 
-		ide_end_drive_cmd(drive, stat, err);
+		if (task)
+			ide_complete_task(drive, task, stat, err);
+		ide_complete_rq(drive, err);
 		return;
 	}
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1155,7 +1155,8 @@ extern ide_startstop_t ide_do_reset (ide
 extern int ide_devset_execute(ide_drive_t *drive,
 			      const struct ide_devset *setting, int arg);
 
-extern void ide_end_drive_cmd(ide_drive_t *, u8, u8);
+void ide_complete_task(ide_drive_t *, ide_task_t *, u8, u8);
+void ide_complete_rq(ide_drive_t *, u8);
 
 void ide_tf_dump(const char *, struct ide_taskfile *);
 

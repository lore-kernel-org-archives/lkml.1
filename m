Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYAUXBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYAUXBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbYAUXBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:01:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:19287 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbYAUXBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:01:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=xtKq3lzV7mCMXl2NfmrdSBy0W4KdK74CYeXHZQvExPIahWl/iH/9f4FouW7y+4T9W99LvOwCMWZjtG92REV2FHqh2//7jDQE15BEgWQ9i228CuuUyQ1v6l/17zEICY3FXVHxpGZ3ujcD1l3hwnjRA1B5KJSYgL301XuHxKdTXPM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-disk: use do_rw_taskfile() (take 2)
Date: Tue, 22 Jan 2008 00:13:46 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801220013.46413.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Add IDE_TFLAG_DMA_PIO_FALLBACK taskfile flag to indicate the need
  to skip loading taskfile registers in do_rw_taskfile().

* Export do_rw_taskfile().

* Convert __ide_do_rw_disk() to use do_rw_taskfile().

* Unexport ide_tf_load().

* Unexport {pre_task_out,task_in}_intr() and make it static.

* Remove incorrect comment about do_rw_taskfile() from <linux/ide.h>.

There should be no functionality changes caused by this patch.

v2:
* Add missing blk_fs_request() check to task_dma_ok() (for VDMA).

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch for the one in the IDE quilt tree

 drivers/ide/ide-disk.c     |   29 ++++++++++-------------------
 drivers/ide/ide-taskfile.c |   16 ++++++++--------
 include/linux/ide.h        |    9 ++-------
 3 files changed, 20 insertions(+), 34 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -185,6 +185,7 @@ static ide_startstop_t __ide_do_rw_disk(
 	u8 lba48		= (drive->addressing == 1) ? 1 : 0;
 	ide_task_t		task;
 	struct ide_taskfile	*tf = &task.tf;
+	ide_startstop_t		rc;
 
 	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && lba48 && dma) {
 		if (block + rq->nr_sectors > 1ULL << 28)
@@ -252,32 +253,22 @@ static ide_startstop_t __ide_do_rw_disk(
 		task.tf_flags |= IDE_TFLAG_WRITE;
 
 	ide_tf_set_cmd(drive, &task, dma);
+	if (!dma)
+		hwif->data_phase = task.data_phase;
+	task.rq = rq;
 
-	ide_tf_load(drive, &task);
+	rc = do_rw_taskfile(drive, &task);
 
-	if (dma) {
-		if (!hwif->dma_setup(drive)) {
-			hwif->dma_exec_cmd(drive, tf->command);
-			hwif->dma_start(drive);
-			return ide_started;
-		}
+	if (rc == ide_stopped && dma) {
 		/* fallback to PIO */
+		task.tf_flags |= IDE_TFLAG_DMA_PIO_FALLBACK;
 		ide_tf_set_cmd(drive, &task, 0);
+		hwif->data_phase = task.data_phase;
 		ide_init_sg_cmd(drive, rq);
+		rc = do_rw_taskfile(drive, &task);
 	}
 
-	hwif->data_phase = task.data_phase;
-
-	if (rq_data_dir(rq) == READ) {
-		ide_execute_command(drive, tf->command, &task_in_intr,
-				    WAIT_WORSTCASE, NULL);
-		return ide_started;
-	} else {
-		hwif->OUTBSYNC(drive, tf->command, IDE_COMMAND_REG);
-		ndelay(400);	/* FIXME */
-
-		return pre_task_out_intr(drive, rq);
-	}
+	return rc;
 }
 
 /*
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -114,8 +114,6 @@ void ide_tf_load(ide_drive_t *drive, ide
 		hwif->OUTB((tf->device & HIHI) | drive->select.all, IDE_SELECT_REG);
 }
 
-EXPORT_SYMBOL_GPL(ide_tf_load);
-
 int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
 {
 	ide_task_t args;
@@ -133,7 +131,7 @@ int taskfile_lib_get_identify (ide_drive
 
 static int inline task_dma_ok(ide_task_t *task)
 {
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (blk_fs_request(task->rq) || (task->tf_flags & IDE_TFLAG_FLAGGED))
 		return 1;
 
 	switch (task->tf.command) {
@@ -154,6 +152,8 @@ static ide_startstop_t task_no_data_intr
 static ide_startstop_t set_geometry_intr(ide_drive_t *);
 static ide_startstop_t recal_intr(ide_drive_t *);
 static ide_startstop_t set_multmode_intr(ide_drive_t *);
+static ide_startstop_t pre_task_out_intr(ide_drive_t *, struct request *);
+static ide_startstop_t task_in_intr(ide_drive_t *);
 
 ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 {
@@ -173,7 +173,8 @@ ide_startstop_t do_rw_taskfile (ide_driv
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		task->tf_flags |= IDE_TFLAG_FLAGGED_SET_IN_FLAGS;
 
-	ide_tf_load(drive, task);
+	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0)
+		ide_tf_load(drive, task);
 
 	switch (task->data_phase) {
 	case TASKFILE_MULTI_OUT:
@@ -208,6 +209,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 		return ide_started;
 	}
 }
+EXPORT_SYMBOL_GPL(do_rw_taskfile);
 
 /*
  * set_multmode_intr() is invoked on completion of a WIN_SETMULT cmd.
@@ -446,7 +448,7 @@ static void task_end_request(ide_drive_t
 /*
  * Handler for command with PIO data-in phase (Read/Read Multiple).
  */
-ide_startstop_t task_in_intr (ide_drive_t *drive)
+static ide_startstop_t task_in_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = HWGROUP(drive)->rq;
@@ -477,7 +479,6 @@ ide_startstop_t task_in_intr (ide_drive_
 
 	return ide_started;
 }
-EXPORT_SYMBOL(task_in_intr);
 
 /*
  * Handler for command with PIO data-out phase (Write/Write Multiple).
@@ -507,7 +508,7 @@ static ide_startstop_t task_out_intr (id
 	return ide_started;
 }
 
-ide_startstop_t pre_task_out_intr (ide_drive_t *drive, struct request *rq)
+static ide_startstop_t pre_task_out_intr(ide_drive_t *drive, struct request *rq)
 {
 	ide_startstop_t startstop;
 
@@ -528,7 +529,6 @@ ide_startstop_t pre_task_out_intr (ide_d
 
 	return ide_started;
 }
-EXPORT_SYMBOL(pre_task_out_intr);
 
 int ide_raw_taskfile(ide_drive_t *drive, ide_task_t *task, u8 *buf, u16 nsect)
 {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -912,6 +912,7 @@ enum {
 	IDE_TFLAG_FLAGGED_SET_IN_FLAGS	= (1 << 16),
 	IDE_TFLAG_IN_DATA		= (1 << 17),
 	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 18),
+	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 19),
 };
 
 struct ide_taskfile {
@@ -965,13 +966,7 @@ extern int drive_is_ready(ide_drive_t *)
 
 void ide_pktcmd_tf_load(ide_drive_t *, u32, u16, u8);
 
-/*
- * taskfile io for disks for now...and builds request from ide_ioctl
- */
-extern ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
-
-extern ide_startstop_t task_in_intr(ide_drive_t *);
-extern ide_startstop_t pre_task_out_intr(ide_drive_t *, struct request *);
+ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
 int ide_raw_taskfile(ide_drive_t *, ide_task_t *, u8 *, u16);
 int ide_no_data_taskfile(ide_drive_t *, ide_task_t *);

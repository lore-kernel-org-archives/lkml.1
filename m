Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZBARxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZBARxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbZBARt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:49:56 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:54728 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbZBARty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:49:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=GDlfoBTYzYtYGI1/VaVBAKGhgKXQl4w0/KEBxQUUuKrsGOKVAwCEIb99srqDBLhak5
         rdXJnyNXhsKL0hD2WnTaeGmyPMyCCEK5/oPC+E/vOS49hGbaQPma/ce6jc7q0DusxX0Q
         nAWWYKQYAxlifNqEJ+LHW9TyHsycJEMT89XVQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:50:47 +0100
Message-Id: <20090201175047.19144.40543.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/15] ide: remove ->data_phase field from ide_hwif_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove ->data_phase field from ide_hwif_t

* Always use hwif->task->data_phase and remove ->data_phase
  field from ide_hwif_t.

* Remove superfluous REQ_TYPE_ATA_TASKFILE check from
  ide_pio_datablock() while at it.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c     |    3 ---
 drivers/ide/ide-io.c       |    5 +----
 drivers/ide/ide-park.c     |    2 +-
 drivers/ide/ide-taskfile.c |   18 ++++++++----------
 include/linux/ide.h        |    3 ---
 5 files changed, 10 insertions(+), 21 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -160,8 +160,6 @@ static ide_startstop_t __ide_do_rw_disk(
 		task.tf_flags |= IDE_TFLAG_WRITE;
 
 	ide_tf_set_cmd(drive, &task, dma);
-	if (!dma)
-		hwif->data_phase = task.data_phase;
 	task.rq = rq;
 
 	rc = do_rw_taskfile(drive, &task);
@@ -170,7 +168,6 @@ static ide_startstop_t __ide_do_rw_disk(
 		/* fallback to PIO */
 		task.tf_flags |= IDE_TFLAG_DMA_PIO_FALLBACK;
 		ide_tf_set_cmd(drive, &task, 0);
-		hwif->data_phase = task.data_phase;
 		ide_init_sg_cmd(drive, rq);
 		rc = do_rw_taskfile(drive, &task);
 	}
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -306,13 +306,10 @@ EXPORT_SYMBOL_GPL(ide_init_sg_cmd);
 static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 		struct request *rq)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	ide_task_t *task = rq->special;
 
 	if (task) {
-		hwif->data_phase = task->data_phase;
-
-		switch (hwif->data_phase) {
+		switch (task->data_phase) {
 		case TASKFILE_MULTI_OUT:
 		case TASKFILE_OUT:
 		case TASKFILE_MULTI_IN:
Index: b/drivers/ide/ide-park.c
===================================================================
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -81,7 +81,7 @@ ide_startstop_t ide_do_park_unpark(ide_d
 
 	task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	task.rq = rq;
-	drive->hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
+	task.data_phase = TASKFILE_NO_DATA;
 	return do_rw_taskfile(drive, &task);
 }
 
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -261,21 +261,18 @@ static void ide_pio_multi(ide_drive_t *d
 static void ide_pio_datablock(ide_drive_t *drive, struct request *rq,
 				     unsigned int write)
 {
+	ide_task_t *task = &drive->hwif->task;
 	u8 saved_io_32bit = drive->io_32bit;
 
 	if (rq->bio)	/* fs request */
 		rq->errors = 0;
 
-	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
-		ide_task_t *task = rq->special;
-
-		if (task->tf_flags & IDE_TFLAG_IO_16BIT)
-			drive->io_32bit = 0;
-	}
+	if (task->tf_flags & IDE_TFLAG_IO_16BIT)
+		drive->io_32bit = 0;
 
 	touch_softlockup_watchdog();
 
-	switch (drive->hwif->data_phase) {
+	switch (task->data_phase) {
 	case TASKFILE_MULTI_IN:
 	case TASKFILE_MULTI_OUT:
 		ide_pio_multi(drive, rq, write);
@@ -293,9 +290,10 @@ static ide_startstop_t task_error(ide_dr
 {
 	if (rq->bio) {
 		ide_hwif_t *hwif = drive->hwif;
+		ide_task_t *task = &hwif->task;
 		int sectors = hwif->nsect - hwif->nleft;
 
-		switch (hwif->data_phase) {
+		switch (task->data_phase) {
 		case TASKFILE_IN:
 			if (hwif->nleft)
 				break;
@@ -427,14 +425,14 @@ static ide_startstop_t task_out_intr (id
 
 static ide_startstop_t pre_task_out_intr(ide_drive_t *drive, struct request *rq)
 {
-	ide_hwif_t *hwif = drive->hwif;
+	ide_task_t *task = &drive->hwif->task;
 	ide_startstop_t startstop;
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
 			drive->name,
-			hwif->data_phase == TASKFILE_MULTI_OUT ? "MULT" : "",
+			task->data_phase == TASKFILE_MULTI_OUT ? "MULT" : "",
 			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
 		return startstop;
 	}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -767,9 +767,6 @@ typedef struct hwif_s {
 	int sg_nents;			/* Current number of entries in it */
 	int sg_dma_direction;		/* dma transfer direction */
 
-	/* data phase of the active command (currently only valid for PIO/DMA) */
-	int		data_phase;
-
 	struct ide_task_s task;		/* current command */
 
 	unsigned int nsect;

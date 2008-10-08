Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYJHUch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYJHUch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbYJHUbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:31:40 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:44022 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbYJHUbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:31:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=RP7YTaoz/94l540D8L8Q/+pUmJDFEJhkViEc6JoqRBImqvoOwyHElqsRYH73CkG+fe
         RV1eNaHIzCLyk3ruo3hIyMXcN8V0HpWWX84fBPD2C9Q/u1z0oOrvDRNGqBTZ9KPxFpHH
         0YBmVPghMqbaSB39GUDMmx7vQ2YZiWdvt/zOQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 08 Oct 2008 22:30:02 +0200
Message-Id: <20081008203002.19112.519.sendpatchset@localhost.localdomain>
In-Reply-To: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/7] ide: ide_hwgroup_t.rq doesn't need an ide_lock held
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: ide_hwgroup_t.rq doesn't need an ide_lock held

While at it:
- no need to check for hwgroup presence in ide_dump_opcode()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c  |   12 ++++++++----
 drivers/ide/ide-io.c  |   40 +++++++++++++++++++---------------------
 drivers/ide/ide-lib.c |    7 +------
 3 files changed, 28 insertions(+), 31 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -317,7 +317,8 @@ static void ide_dump_status_no_sense(ide
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
+	ide_hwgroup_t *hwgroup = hwif->hwgroup;
+	struct request *rq = hwgroup->rq;
 	int stat, err, sense_key;
 
 	/* check for errors */
@@ -508,9 +509,10 @@ end_request:
 
 		spin_lock_irqsave(&ide_lock, flags);
 		blkdev_dequeue_request(rq);
-		HWGROUP(drive)->rq = NULL;
 		spin_unlock_irqrestore(&ide_lock, flags);
 
+		hwgroup->rq = NULL;
+
 		cdrom_queue_request_sense(drive, rq->sense, rq);
 	} else
 		cdrom_end_request(drive, 0);
@@ -950,7 +952,8 @@ static int cdrom_newpc_intr_dummy_cb(str
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = HWGROUP(drive)->rq;
+	ide_hwgroup_t *hwgroup = hwif->hwgroup;
+	struct request *rq = hwgroup->rq;
 	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, stat, thislen, uptodate = 0;
@@ -1157,8 +1160,9 @@ end_request:
 		spin_lock_irqsave(&ide_lock, flags);
 		if (__blk_end_request(rq, 0, dlen))
 			BUG();
-		HWGROUP(drive)->rq = NULL;
 		spin_unlock_irqrestore(&ide_lock, flags);
+
+		hwgroup->rq = NULL;
 	} else {
 		if (!uptodate)
 			rq->cmd_flags |= REQ_FAILED;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -107,17 +107,10 @@ static int __ide_end_request(ide_drive_t
 int ide_end_request (ide_drive_t *drive, int uptodate, int nr_sectors)
 {
 	unsigned int nr_bytes = nr_sectors << 9;
-	struct request *rq;
+	struct request *rq = drive->hwif->hwgroup->rq;
 	unsigned long flags;
 	int ret = 1;
 
-	/*
-	 * room for locking improvements here, the calls below don't
-	 * need the queue lock held at all
-	 */
-	spin_lock_irqsave(&ide_lock, flags);
-	rq = HWGROUP(drive)->rq;
-
 	if (!nr_bytes) {
 		if (blk_pc_request(rq))
 			nr_bytes = rq->data_len;
@@ -125,9 +118,10 @@ int ide_end_request (ide_drive_t *drive,
 			nr_bytes = rq->hard_cur_sectors << 9;
 	}
 
+	spin_lock_irqsave(&ide_lock, flags);
 	ret = __ide_end_request(drive, rq, uptodate, nr_bytes, 1);
-
 	spin_unlock_irqrestore(&ide_lock, flags);
+
 	return ret;
 }
 EXPORT_SYMBOL(ide_end_request);
@@ -241,8 +235,9 @@ int ide_end_dequeued_request(ide_drive_t
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&ide_lock, flags);
 	BUG_ON(!blk_rq_started(rq));
+
+	spin_lock_irqsave(&ide_lock, flags);
 	ret = __ide_end_request(drive, rq, uptodate, nr_sectors << 9, 0);
 	spin_unlock_irqrestore(&ide_lock, flags);
 
@@ -274,7 +269,11 @@ static void ide_complete_pm_request (ide
 		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
 		blk_start_queue(drive->queue);
 	}
-	HWGROUP(drive)->rq = NULL;
+	spin_unlock_irqrestore(&ide_lock, flags);
+
+	drive->hwif->hwgroup->rq = NULL;
+
+	spin_lock_irqsave(&ide_lock, flags);
 	if (__blk_end_request(rq, 0, 0))
 		BUG();
 	spin_unlock_irqrestore(&ide_lock, flags);
@@ -296,12 +295,9 @@ static void ide_complete_pm_request (ide
  
 void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 {
+	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+	struct request *rq = hwgroup->rq;
 	unsigned long flags;
-	struct request *rq;
-
-	spin_lock_irqsave(&ide_lock, flags);
-	rq = HWGROUP(drive)->rq;
-	spin_unlock_irqrestore(&ide_lock, flags);
 
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *task = (ide_task_t *)rq->special;
@@ -332,15 +328,16 @@ void ide_end_drive_cmd (ide_drive_t *dri
 		return;
 	}
 
-	spin_lock_irqsave(&ide_lock, flags);
-	HWGROUP(drive)->rq = NULL;
+	hwgroup->rq = NULL;
+
 	rq->errors = err;
+
+	spin_lock_irqsave(&ide_lock, flags);
 	if (unlikely(__blk_end_request(rq, (rq->errors ? -EIO : 0),
 				       blk_rq_bytes(rq))))
 		BUG();
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
-
 EXPORT_SYMBOL(ide_end_drive_cmd);
 
 static void ide_kill_rq(ide_drive_t *drive, struct request *rq)
@@ -1489,11 +1486,12 @@ out:
 
 void ide_do_drive_cmd(ide_drive_t *drive, struct request *rq)
 {
+	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
 	unsigned long flags;
-	ide_hwgroup_t *hwgroup = HWGROUP(drive);
 
-	spin_lock_irqsave(&ide_lock, flags);
 	hwgroup->rq = NULL;
+
+	spin_lock_irqsave(&ide_lock, flags);
 	__elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 1);
 	__generic_unplug_device(drive->queue);
 	spin_unlock_irqrestore(&ide_lock, flags);
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -277,14 +277,9 @@ int ide_set_xfer_rate(ide_drive_t *drive
 
 static void ide_dump_opcode(ide_drive_t *drive)
 {
-	struct request *rq;
+	struct request *rq = drive->hwif->hwgroup->rq;
 	ide_task_t *task = NULL;
 
-	spin_lock(&ide_lock);
-	rq = NULL;
-	if (HWGROUP(drive))
-		rq = HWGROUP(drive)->rq;
-	spin_unlock(&ide_lock);
 	if (!rq)
 		return;
 

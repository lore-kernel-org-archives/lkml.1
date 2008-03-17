Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYCQGoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYCQGoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbYCQGm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:42:27 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:30088 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbYCQGli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=U1VJBINDDI8aUVc0m05nYnQpAouxSgr0nVszzWPO9xxXS2QUdNGfn4s7xKuaqmc08gBxk6ocfw+xFpGKAl6vdBW5tc1u5XxOVzQpUsWCCv/TXlVuvBlAs2mjdlaWTpYKW/Z/nfYR2BKJh/HHLN7BnOzv9w5L+T97gXIwlSxQagQ=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 10/17] ide-tape: remove remaining pipeline functionality
Date: Mon, 17 Mar 2008 07:41:23 +0100
Message-Id: <1205736090-4435-11-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is using now solely its own request queue.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  103 +-----------------------------------------------
 1 files changed, 2 insertions(+), 101 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index a85866a..c612c8c 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -642,28 +642,6 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	}
 }
 
-static void idetape_activate_next_stage(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *stage = tape->next_stage;
-	struct request *rq = &stage->rq;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	if (stage == NULL) {
-		printk(KERN_ERR "ide-tape: bug: Trying to activate a non"
-				" existing stage\n");
-		return;
-	}
-
-	rq->rq_disk = tape->disk;
-	rq->buffer = NULL;
-	rq->special = (void *)stage->bh;
-	tape->active_data_rq = rq;
-	tape->active_stage = stage;
-	tape->next_stage = stage->next;
-}
-
 /* Free a stage along with its related buffers completely. */
 static void __idetape_kfree_stage(idetape_stage_t *stage)
 {
@@ -1541,28 +1519,6 @@ static void idetape_init_merge_stage(idetape_tape_t *tape)
 	}
 }
 
-/* Install a completion in a pending request and sleep until it is serviced. The
- * caller should ensure that the request will not be serviced before we install
- * the completion (usually by disabling interrupts).
- */
-static void idetape_wait_for_request(ide_drive_t *drive, struct request *rq)
-{
-	DECLARE_COMPLETION_ONSTACK(wait);
-	idetape_tape_t *tape = drive->driver_data;
-
-	if (rq == NULL || !blk_special_request(rq)) {
-		printk(KERN_ERR "ide-tape: bug: Trying to sleep on non-valid"
-				 " request\n");
-		return;
-	}
-	rq->end_io_data = &wait;
-	rq->end_io = blk_end_sync_rq;
-	spin_unlock_irq(&tape->lock);
-	wait_for_completion(&wait);
-	/* The stage and its struct request have been deallocated */
-	spin_lock_irq(&tape->lock);
-}
-
 static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -1806,19 +1762,6 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 	return (tape->blk_size * (blocks-rq.current_nr_sectors));
 }
 
-/* start servicing the pipeline stages, starting from tape->next_stage. */
-static void idetape_plug_pipeline(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	if (tape->next_stage == NULL)
-		return;
-	if (!test_and_set_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-		idetape_activate_next_stage(drive);
-		(void) ide_do_drive_cmd(drive, tape->active_data_rq, ide_end);
-	}
-}
-
 static void idetape_create_inquiry_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
@@ -1860,45 +1803,11 @@ static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
 
 	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
-	/* Attempt to allocate a new stage. Beware possible race conditions. */
-	while (1) {
-		spin_lock_irqsave(&tape->lock, flags);
-		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-			idetape_wait_for_request(drive, tape->active_data_rq);
-			spin_unlock_irqrestore(&tape->lock, flags);
-		} else {
-			spin_unlock_irqrestore(&tape->lock, flags);
-			idetape_plug_pipeline(drive);
-			if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
-					&tape->flags))
-				continue;
-			return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
-						blocks, tape->merge_stage->bh);
-		}
-	}
-}
-
-/*
- * Wait until all pending pipeline requests are serviced. Typically called on
- * device close.
- */
-static void idetape_wait_for_pipeline(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-
-	while (tape->next_stage || test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
-						&tape->flags)) {
-		idetape_plug_pipeline(drive);
-		spin_lock_irqsave(&tape->lock, flags);
-		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags))
-			idetape_wait_for_request(drive, tape->active_data_rq);
-		spin_unlock_irqrestore(&tape->lock, flags);
-	}
+	return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
+				     blocks, tape->merge_stage->bh);
 }
 
 static int idetape_init_read(ide_drive_t *drive, int max_stages)
@@ -1909,7 +1818,6 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 	/* Initialize read operation */
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
 		if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-			idetape_wait_for_pipeline(drive);
 			idetape_flush_tape_buffers(drive);
 		}
 		if (tape->merge_stage || tape->merge_stage_size) {
@@ -1947,7 +1855,6 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 			tape->insert_time = jiffies;
 			tape->insert_size = 0;
 			tape->insert_speed = 0;
-			idetape_plug_pipeline(drive);
 		}
 	}
 	return 0;
@@ -2428,7 +2335,6 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
 
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-		idetape_wait_for_pipeline(drive);
 		idetape_flush_tape_buffers(drive);
 	}
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
@@ -2578,7 +2484,6 @@ static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	idetape_wait_for_pipeline(drive);
 	tape->merge_stage = __idetape_kmalloc_stage(tape, 1, 0);
 	if (tape->merge_stage != NULL) {
 		idetape_pad_zeros(drive, tape->blk_size *
@@ -2605,10 +2510,6 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		idetape_write_release(drive, minor);
-	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
-		if (minor >= 128)
-			idetape_wait_for_pipeline(drive);
-	}
 
 	if (minor < 128 && test_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags))
 		(void) idetape_rewind_tape(drive);
-- 
1.5.4.1


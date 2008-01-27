Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYA0Jt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYA0Jt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYA0JtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:00 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58579 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751794AbYA0Js5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:48:57 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 06/32] ide-tape: remove IDETAPE_DEBUG_BUGS
Date: Sun, 27 Jan 2008 10:47:54 +0100
Message-Id: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   42 ++----------------------------------------
 1 files changed, 2 insertions(+), 40 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index dbececc..efb9d25 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -107,7 +107,6 @@ typedef struct os_dat_s {
  *	The following are used to debug the driver:
  *
  *	Setting IDETAPE_DEBUG_LOG to 1 will log driver flow control.
- *	Setting IDETAPE_DEBUG_BUGS to 1 will enable self-sanity checks in
  *	some places.
  *
  *	Setting them to 0 will restore normal operation mode:
@@ -121,7 +120,6 @@ typedef struct os_dat_s {
  *	esthetic.
  */
 #define IDETAPE_DEBUG_LOG		0
-#define IDETAPE_DEBUG_BUGS		1
 
 /*
  *	After each failed packet command we issue a request sense command
@@ -847,14 +845,12 @@ static void idetape_input_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigne
 	int count;
 
 	while (bcount) {
-#if IDETAPE_DEBUG_BUGS
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_input_buffers\n");
 			idetape_discard_data(drive, bcount);
 			return;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		count = min((unsigned int)(bh->b_size - atomic_read(&bh->b_count)), bcount);
 		HWIF(drive)->atapi_input_bytes(drive, bh->b_data + atomic_read(&bh->b_count), count);
 		bcount -= count;
@@ -874,13 +870,11 @@ static void idetape_output_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsign
 	int count;
 
 	while (bcount) {
-#if IDETAPE_DEBUG_BUGS
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_output_buffers\n");
 			return;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
 		HWIF(drive)->atapi_output_bytes(drive, pc->b_data, count);
 		bcount -= count;
@@ -905,13 +899,11 @@ static void idetape_update_buffers (idetape_pc_t *pc)
 	if (test_bit(PC_WRITING, &pc->flags))
 		return;
 	while (bcount) {
-#if IDETAPE_DEBUG_BUGS
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_update_buffers\n");
 			return;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		count = min((unsigned int)bh->b_size, (unsigned int)bcount);
 		atomic_set(&bh->b_count, count);
 		if (atomic_read(&bh->b_count) == bh->b_size)
@@ -1067,12 +1059,10 @@ static void idetape_active_next_stage (ide_drive_t *drive)
 	if (tape->debug_level >= 4)
 		printk(KERN_INFO "ide-tape: Reached idetape_active_next_stage\n");
 #endif /* IDETAPE_DEBUG_LOG */
-#if IDETAPE_DEBUG_BUGS
 	if (stage == NULL) {
 		printk(KERN_ERR "ide-tape: bug: Trying to activate a non existing stage\n");
 		return;
 	}
-#endif /* IDETAPE_DEBUG_BUGS */	
 
 	rq->rq_disk = tape->disk;
 	rq->buffer = NULL;
@@ -1147,28 +1137,24 @@ static void idetape_remove_stage_head (ide_drive_t *drive)
 	if (tape->debug_level >= 4)
 		printk(KERN_INFO "ide-tape: Reached idetape_remove_stage_head\n");
 #endif /* IDETAPE_DEBUG_LOG */
-#if IDETAPE_DEBUG_BUGS
 	if (tape->first_stage == NULL) {
 		printk(KERN_ERR "ide-tape: bug: tape->first_stage is NULL\n");
-		return;		
+		return;
 	}
 	if (tape->active_stage == tape->first_stage) {
 		printk(KERN_ERR "ide-tape: bug: Trying to free our active pipeline stage\n");
 		return;
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 	stage = tape->first_stage;
 	tape->first_stage = stage->next;
 	idetape_kfree_stage(tape, stage);
 	tape->nr_stages--;
 	if (tape->first_stage == NULL) {
 		tape->last_stage = NULL;
-#if IDETAPE_DEBUG_BUGS
 		if (tape->next_stage != NULL)
 			printk(KERN_ERR "ide-tape: bug: tape->next_stage != NULL\n");
 		if (tape->nr_stages)
 			printk(KERN_ERR "ide-tape: bug: nr_stages should be 0 now\n");
-#endif /* IDETAPE_DEBUG_BUGS */
 	}
 }
 
@@ -1656,13 +1642,11 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 	int dma_ok = 0;
 	u16 bcount;
 
-#if IDETAPE_DEBUG_BUGS
 	if (tape->pc->c[0] == IDETAPE_REQUEST_SENSE_CMD &&
 	    pc->c[0] == IDETAPE_REQUEST_SENSE_CMD) {
 		printk(KERN_ERR "ide-tape: possible ide-tape.c bug - "
 			"Two request sense in serial were issued\n");
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 
 	if (tape->failed_pc == NULL && pc->c[0] != IDETAPE_REQUEST_SENSE_CMD)
 		tape->failed_pc = pc;
@@ -1973,7 +1957,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	    tape->pc->c[0] == IDETAPE_REQUEST_SENSE_CMD) {
 		return idetape_issue_packet_command(drive, tape->failed_pc);
 	}
-#if IDETAPE_DEBUG_BUGS
 	if (postponed_rq != NULL)
 		if (rq != postponed_rq) {
 			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
@@ -1981,7 +1964,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 			idetape_end_request(drive, 0, 0);
 			return ide_stopped;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 
 	tape->postponed_rq = NULL;
 
@@ -2168,13 +2150,11 @@ static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *
 	int ret = 0;
 
 	while (n) {
-#if IDETAPE_DEBUG_BUGS
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_copy_stage_from_user\n");
 			return 1;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		count = min((unsigned int)(bh->b_size - atomic_read(&bh->b_count)), (unsigned int)n);
 		if (copy_from_user(bh->b_data + atomic_read(&bh->b_count), buf, count))
 			ret = 1;
@@ -2198,13 +2178,11 @@ static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, i
 	int ret = 0;
 
 	while (n) {
-#if IDETAPE_DEBUG_BUGS
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_copy_stage_to_user\n");
 			return 1;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		count = min(tape->b_count, n);
 		if  (copy_to_user(buf, tape->b_data, count))
 			ret = 1;
@@ -2284,12 +2262,10 @@ static void idetape_wait_for_request (ide_drive_t *drive, struct request *rq)
 	DECLARE_COMPLETION_ONSTACK(wait);
 	idetape_tape_t *tape = drive->driver_data;
 
-#if IDETAPE_DEBUG_BUGS
 	if (rq == NULL || !blk_special_request(rq)) {
 		printk (KERN_ERR "ide-tape: bug: Trying to sleep on non-valid request\n");
 		return;
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 	rq->end_io_data = &wait;
 	rq->end_io = blk_end_sync_rq;
 	spin_unlock_irq(&tape->spinlock);
@@ -2604,12 +2580,10 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 	if (tape->debug_level >= 2)
 		printk(KERN_INFO "ide-tape: idetape_queue_rw_tail: cmd=%d\n",cmd);
 #endif /* IDETAPE_DEBUG_LOG */
-#if IDETAPE_DEBUG_BUGS
 	if (idetape_pipeline_active(tape)) {
 		printk(KERN_ERR "ide-tape: bug: the pipeline is active in idetape_queue_rw_tail\n");
 		return (0);
 	}
-#endif /* IDETAPE_DEBUG_BUGS */	
 
 	idetape_init_rq(&rq, cmd);
 	rq.rq_disk = tape->disk;
@@ -2794,8 +2768,7 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	idetape_tape_t *tape = drive->driver_data;
 	int blocks, min;
 	struct idetape_bh *bh;
-	
-#if IDETAPE_DEBUG_BUGS
+
 	if (tape->chrdev_direction != idetape_direction_write) {
 		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline, but we are not writing.\n");
 		return;
@@ -2804,7 +2777,6 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 		printk(KERN_ERR "ide-tape: bug: merge_buffer too big\n");
 		tape->merge_stage_size = tape->stage_size;
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 	if (tape->merge_stage_size) {
 		blocks = tape->merge_stage_size / tape->tape_block_size;
 		if (tape->merge_stage_size % tape->tape_block_size) {
@@ -2849,7 +2821,6 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	 *	 can be totally different on the next backup).
 	 */
 	tape->max_stages = tape->min_pipeline;
-#if IDETAPE_DEBUG_BUGS
 	if (tape->first_stage != NULL ||
 	    tape->next_stage != NULL ||
 	    tape->last_stage != NULL ||
@@ -2860,7 +2831,6 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 			tape->first_stage, tape->next_stage,
 			tape->last_stage, tape->nr_stages);
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 }
 
 static void idetape_restart_speed_control (ide_drive_t *drive)
@@ -2891,12 +2861,10 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 			idetape_empty_write_pipeline(drive);
 			idetape_flush_tape_buffers(drive);
 		}
-#if IDETAPE_DEBUG_BUGS
 		if (tape->merge_stage || tape->merge_stage_size) {
 			printk (KERN_ERR "ide-tape: merge_stage_size should be 0 now\n");
 			tape->merge_stage_size = 0;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
 			return -ENOMEM;
 		tape->chrdev_direction = idetape_direction_read;
@@ -2997,12 +2965,10 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 		tape->pipeline_head++;
 		calculate_speeds(drive);
 	}
-#if IDETAPE_DEBUG_BUGS
 	if (bytes_read > blocks * tape->tape_block_size) {
 		printk(KERN_ERR "ide-tape: bug: trying to return more bytes than requested\n");
 		bytes_read = blocks * tape->tape_block_size;
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 	return (bytes_read);
 }
 
@@ -3301,13 +3267,11 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	if (tape->chrdev_direction != idetape_direction_write) {
 		if (tape->chrdev_direction == idetape_direction_read)
 			idetape_discard_read_pipeline(drive, 1);
-#if IDETAPE_DEBUG_BUGS
 		if (tape->merge_stage || tape->merge_stage_size) {
 			printk(KERN_ERR "ide-tape: merge_stage_size "
 				"should be 0 now\n");
 			tape->merge_stage_size = 0;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
 			return -ENOMEM;
 		tape->chrdev_direction = idetape_direction_write;
@@ -3335,12 +3299,10 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	if (tape->restart_speed_control_req)
 		idetape_restart_speed_control(drive);
 	if (tape->merge_stage_size) {
-#if IDETAPE_DEBUG_BUGS
 		if (tape->merge_stage_size >= tape->stage_size) {
 			printk(KERN_ERR "ide-tape: bug: merge buffer too big\n");
 			tape->merge_stage_size = 0;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		actually_written = min((unsigned int)(tape->stage_size - tape->merge_stage_size), (unsigned int)count);
 		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, actually_written))
 				ret = -EFAULT;
-- 
1.5.3.7


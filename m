Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbYBDNs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbYBDNs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbYBDNnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:43:11 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:58405 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbYBDNnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:43:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=STiUPmdHV6KsGIY/LaM+B16cGsCJMWoB6o6JhYCIBO3Yvq6qYfew9Aqgepbg5OX3kbjMoBtx9TwZHRTXozPDDQqjw/48dfMJkDLU/xFPJg3JT4KJ2zVv2A7V6wLNEXezbjrR8HAH9/c5yIoHA/F2YZ6+sxkeplK6yONSZIgP1OU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 20/22] ide-tape: cleanup the remaining codestyle issues
Date: Mon,  4 Feb 2008 14:40:38 +0100
Message-Id: <1202132440-26648-21-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... thus decreasing checkpatch.pl errors to 0.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  801 ++++++++++++++++++++++++++++--------------------
 1 files changed, 468 insertions(+), 333 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 7e998c4..5c88885 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -486,7 +486,7 @@ enum {
  * The variables below are used for the character device interface. Additional
  * state variables are defined in our ide_drive_t structure.
  */
-static struct ide_tape_obj * idetape_devs[MAX_HWIFS * MAX_DRIVES];
+static struct ide_tape_obj *idetape_devs[MAX_HWIFS * MAX_DRIVES];
 
 #define ide_tape_f(file) ((file)->private_data)
 
@@ -502,20 +502,21 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 	return tape;
 }
 
-static int idetape_chrdev_release (struct inode *inode, struct file *filp);
-static void idetape_write_release (ide_drive_t *drive, unsigned int minor);
+static int idetape_chrdev_release(struct inode *inode, struct file *filp);
+static void idetape_write_release(ide_drive_t *drive, unsigned int minor);
 
 /*
  * Too bad. The drive wants to send us data which we are not ready to accept.
  * Just throw it away.
  */
-static void idetape_discard_data (ide_drive_t *drive, unsigned int bcount)
+static void idetape_discard_data(ide_drive_t *drive, unsigned int bcount)
 {
 	while (bcount--)
 		(void) HWIF(drive)->INB(IDE_DATA_REG);
 }
 
-static void idetape_input_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigned int bcount)
+static void idetape_input_buffers(ide_drive_t *drive, idetape_pc_t *pc,
+		unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
@@ -527,8 +528,11 @@ static void idetape_input_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigne
 			idetape_discard_data(drive, bcount);
 			return;
 		}
-		count = min((unsigned int)(bh->b_size - atomic_read(&bh->b_count)), bcount);
-		HWIF(drive)->atapi_input_bytes(drive, bh->b_data + atomic_read(&bh->b_count), count);
+		count = min(
+			(unsigned int)(bh->b_size - atomic_read(&bh->b_count)),
+			bcount);
+		HWIF(drive)->atapi_input_bytes(drive, bh->b_data +
+					atomic_read(&bh->b_count), count);
 		bcount -= count;
 		atomic_add(count, &bh->b_count);
 		if (atomic_read(&bh->b_count) == bh->b_size) {
@@ -540,15 +544,16 @@ static void idetape_input_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigne
 	pc->bh = bh;
 }
 
-static void idetape_output_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigned int bcount)
+static void idetape_output_buffers(ide_drive_t *drive, idetape_pc_t *pc,
+		unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
 
 	while (bcount) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_output_buffers\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return;
 		}
 		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
@@ -557,7 +562,8 @@ static void idetape_output_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsign
 		pc->b_data += count;
 		pc->b_count -= count;
 		if (!pc->b_count) {
-			pc->bh = bh = bh->b_reqnext;
+			pc->bh	= bh->b_reqnext;
+			bh	= bh->b_reqnext;
 			if (bh) {
 				pc->b_data = bh->b_data;
 				pc->b_count = atomic_read(&bh->b_count);
@@ -566,7 +572,7 @@ static void idetape_output_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsign
 	}
 }
 
-static void idetape_update_buffers (idetape_pc_t *pc)
+static void idetape_update_buffers(idetape_pc_t *pc)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
@@ -576,8 +582,8 @@ static void idetape_update_buffers (idetape_pc_t *pc)
 		return;
 	while (bcount) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_update_buffers\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return;
 		}
 		count = min((unsigned int)bh->b_size, (unsigned int)bcount);
@@ -617,7 +623,7 @@ static struct request *ide_tape_alloc_rq(void)
 	return rq;
 }
 
-static void idetape_init_pc (idetape_pc_t *pc)
+static void idetape_init_pc(idetape_pc_t *pc)
 {
 	memset(pc->c, 0, 12);
 	pc->retries = 0;
@@ -712,7 +718,7 @@ static void idetape_activate_next_stage(ide_drive_t *drive)
 }
 
 /* Free a stage along with its related buffers completely. */
-static void __idetape_kfree_stage (idetape_stage_t *stage)
+static void __idetape_kfree_stage(idetape_stage_t *stage)
 {
 	struct idetape_bh *prev_bh, *bh = stage->bh;
 	int size;
@@ -733,7 +739,7 @@ static void __idetape_kfree_stage (idetape_stage_t *stage)
 	kfree(stage);
 }
 
-static void idetape_kfree_stage (idetape_tape_t *tape, idetape_stage_t *stage)
+static void idetape_kfree_stage(idetape_tape_t *tape, idetape_stage_t *stage)
 {
 	__idetape_kfree_stage(stage);
 }
@@ -742,7 +748,7 @@ static void idetape_kfree_stage (idetape_tape_t *tape, idetape_stage_t *stage)
  * Remove tape->first_stage from the pipeline. The caller should avoid race
  * conditions.
  */
-static void idetape_remove_stage_head (ide_drive_t *drive)
+static void idetape_remove_stage_head(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *stage;
@@ -765,9 +771,11 @@ static void idetape_remove_stage_head (ide_drive_t *drive)
 	if (tape->first_stage == NULL) {
 		tape->last_stage = NULL;
 		if (tape->next_stage != NULL)
-			printk(KERN_ERR "ide-tape: bug: tape->next_stage != NULL\n");
+			printk(KERN_ERR "ide-tape: bug: tape->next_stage !="
+					" NULL\n");
 		if (tape->nr_stages)
-			printk(KERN_ERR "ide-tape: bug: nr_stages should be 0 now\n");
+			printk(KERN_ERR "ide-tape: bug: nr_stages should be 0 "
+					"now\n");
 	}
 }
 
@@ -813,9 +821,9 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	switch (uptodate) {
-		case 0:	error = IDETAPE_ERROR_GENERAL; break;
-		case 1: error = 0; break;
-		default: error = uptodate;
+	case 0:	error = IDETAPE_ERROR_GENERAL; break;
+	case 1: error = 0; break;
+	default: error = uptodate;
 	}
 	rq->errors = error;
 	if (error)
@@ -839,7 +847,8 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 			if (error) {
 				tape->flags |= IDETAPE_FL_PIPELINE_ERR;
 				if (error == IDETAPE_ERROR_EOD)
-					idetape_abort_pipeline(drive, active_stage);
+					idetape_abort_pipeline(drive,
+								active_stage);
 			}
 		} else if (rq->cmd[0] & REQ_IDETAPE_READ) {
 			if (error == IDETAPE_ERROR_EOD) {
@@ -884,7 +893,7 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	return 0;
 }
 
-static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_request_sense_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -894,15 +903,16 @@ static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
 		idetape_analyze_error(drive, tape->pc->buffer);
 		idetape_end_request(drive, 1, 0);
 	} else {
-		printk(KERN_ERR "ide-tape: Error in REQUEST SENSE itself - Aborting request!\n");
+		printk(KERN_ERR "ide-tape: Error in REQUEST SENSE itself - "
+				"Aborting request!\n");
 		idetape_end_request(drive, 0, 0);
 	}
 	return ide_stopped;
 }
 
-static void idetape_create_request_sense_cmd (idetape_pc_t *pc)
+static void idetape_create_request_sense_cmd(idetape_pc_t *pc)
 {
-	idetape_init_pc(pc);	
+	idetape_init_pc(pc);
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = 20;
 	pc->request_transfer = 20;
@@ -928,7 +938,8 @@ static void idetape_init_rq(struct request *rq, u8 cmd)
  * handling functions should queue request to the lower level part and wait for
  * their completion using idetape_queue_pc_tail or idetape_queue_rw_tail.
  */
-static void idetape_queue_pc_head (ide_drive_t *drive, idetape_pc_t *pc,struct request *rq)
+static void idetape_queue_pc_head(ide_drive_t *drive, idetape_pc_t *pc,
+		struct request *rq)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 
@@ -970,7 +981,7 @@ static ide_startstop_t idetape_retry_pc(ide_drive_t *drive)
  * Postpone the current request so that ide.c will be able to service requests
  * from another device on the same hwgroup while we are polling for DSC.
  */
-static void idetape_postpone_request (ide_drive_t *drive)
+static void idetape_postpone_request(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -999,7 +1010,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	idetape_io_buf *iobuf;
 	unsigned int temp;
 #if SIMULATE_ERRORS
-	static int error_sim_count = 0;
+	static int error_sim_count;
 #endif
 	u16 bcount;
 	u8 stat, ireason;
@@ -1200,8 +1211,9 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	ide_startstop_t startstop;
 	u8 ireason;
 
-	if (ide_wait_stat(&startstop,drive,DRQ_STAT,BUSY_STAT,WAIT_READY)) {
-		printk(KERN_ERR "ide-tape: Strange, packet command initiated yet DRQ isn't asserted\n");
+	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
+		printk(KERN_ERR "ide-tape: Strange, packet command initiated "
+				"yet DRQ isn't asserted\n");
 		return startstop;
 	}
 	ireason = hwif->INB(IDE_IREASON_REG);
@@ -1308,7 +1320,7 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	}
 }
 
-static ide_startstop_t idetape_pc_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_pc_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -1319,7 +1331,7 @@ static ide_startstop_t idetape_pc_callback (ide_drive_t *drive)
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
-static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
+static void idetape_create_mode_sense_cmd(idetape_pc_t *pc, u8 page_code)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = MODE_SENSE;
@@ -1350,39 +1362,56 @@ static void idetape_calculate_speeds(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	if (time_after(jiffies, tape->controlled_pipeline_head_time + 120 * HZ)) {
-		tape->controlled_previous_pipeline_head = tape->controlled_last_pipeline_head;
-		tape->controlled_previous_head_time = tape->controlled_pipeline_head_time;
+	if (time_after(jiffies,
+			tape->controlled_pipeline_head_time + 120 * HZ)) {
+		tape->controlled_previous_pipeline_head =
+			tape->controlled_last_pipeline_head;
+		tape->controlled_previous_head_time =
+			tape->controlled_pipeline_head_time;
 		tape->controlled_last_pipeline_head = tape->pipeline_head;
 		tape->controlled_pipeline_head_time = jiffies;
 	}
 	if (time_after(jiffies, tape->controlled_pipeline_head_time + 60 * HZ))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head - tape->controlled_last_pipeline_head) * 32 * HZ / (jiffies - tape->controlled_pipeline_head_time);
+		tape->controlled_pipeline_head_speed = (tape->pipeline_head -
+				tape->controlled_last_pipeline_head) * 32 * HZ /
+				(jiffies - tape->controlled_pipeline_head_time);
 	else if (time_after(jiffies, tape->controlled_previous_head_time))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head - tape->controlled_previous_pipeline_head) * 32 * HZ / (jiffies - tape->controlled_previous_head_time);
+		tape->controlled_pipeline_head_speed = (tape->pipeline_head -
+				tape->controlled_previous_pipeline_head) * 32 *
+			HZ / (jiffies - tape->controlled_previous_head_time);
 
-	if (tape->nr_pending_stages < tape->max_stages /*- 1 */) {
+	if (tape->nr_pending_stages < tape->max_stages/*- 1 */) {
 		/* -1 for read mode error recovery */
-		if (time_after(jiffies, tape->uncontrolled_previous_head_time + 10 * HZ)) {
+		if (time_after(jiffies, tape->uncontrolled_previous_head_time +
+					10 * HZ)) {
 			tape->uncontrolled_pipeline_head_time = jiffies;
-			tape->uncontrolled_pipeline_head_speed = (tape->pipeline_head - tape->uncontrolled_previous_pipeline_head) * 32 * HZ / (jiffies - tape->uncontrolled_previous_head_time);
+			tape->uncontrolled_pipeline_head_speed =
+				(tape->pipeline_head -
+				 tape->uncontrolled_previous_pipeline_head) *
+				32 * HZ / (jiffies -
+					tape->uncontrolled_previous_head_time);
 		}
 	} else {
 		tape->uncontrolled_previous_head_time = jiffies;
 		tape->uncontrolled_previous_pipeline_head = tape->pipeline_head;
-		if (time_after(jiffies, tape->uncontrolled_pipeline_head_time + 30 * HZ)) {
+		if (time_after(jiffies, tape->uncontrolled_pipeline_head_time +
+					30 * HZ))
 			tape->uncontrolled_pipeline_head_time = jiffies;
-		}
+
 	}
-	tape->pipeline_head_speed = max(tape->uncontrolled_pipeline_head_speed, tape->controlled_pipeline_head_speed);
+	tape->pipeline_head_speed = max(tape->uncontrolled_pipeline_head_speed,
+					tape->controlled_pipeline_head_speed);
 
 	if (tape->speed_control == 1) {
 		if (tape->nr_pending_stages >= tape->max_stages / 2)
 			tape->max_insert_speed = tape->pipeline_head_speed +
-				(1100 - tape->pipeline_head_speed) * 2 * (tape->nr_pending_stages - tape->max_stages / 2) / tape->max_stages;
+				(1100 - tape->pipeline_head_speed) * 2 *
+				(tape->nr_pending_stages - tape->max_stages / 2)
+				/ tape->max_stages;
 		else
 			tape->max_insert_speed = 500 +
-				(tape->pipeline_head_speed - 500) * 2 * tape->nr_pending_stages / tape->max_stages;
+				(tape->pipeline_head_speed - 500) * 2 *
+				tape->nr_pending_stages / tape->max_stages;
 
 		if (tape->nr_pending_stages >= tape->max_stages * 99 / 100)
 			tape->max_insert_speed = 5000;
@@ -1392,7 +1421,7 @@ static void idetape_calculate_speeds(ide_drive_t *drive)
 	tape->max_insert_speed = max(tape->max_insert_speed, 500);
 }
 
-static ide_startstop_t idetape_media_access_finished (ide_drive_t *drive)
+static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc = tape->pc;
@@ -1418,7 +1447,7 @@ static ide_startstop_t idetape_media_access_finished (ide_drive_t *drive)
 	return pc->callback(drive);
 }
 
-static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
@@ -1434,9 +1463,11 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 		tape->insert_size = 0;
 	}
 	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ / (jiffies - tape->insert_time);
+		tape->insert_speed = tape->insert_size / 1024 * HZ /
+					(jiffies - tape->insert_time);
 	if (time_after_eq(jiffies, tape->avg_time + HZ)) {
-		tape->avg_speed = tape->avg_size * HZ / (jiffies - tape->avg_time) / 1024;
+		tape->avg_speed = tape->avg_size * HZ /
+				(jiffies - tape->avg_time) / 1024;
 		tape->avg_size = 0;
 		tape->avg_time = jiffies;
 	}
@@ -1452,7 +1483,8 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
+static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+		unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_6;
@@ -1491,7 +1523,8 @@ static void idetape_create_read_buffer_cmd(idetape_tape_t *tape,
 	pc->buffer_size = size;
 }
 
-static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
+static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+		unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_6;
@@ -1531,9 +1564,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 
 	/* Retry a failed packet command */
 	if (tape->failed_pc != NULL &&
-	    tape->pc->c[0] == REQUEST_SENSE) {
+	    tape->pc->c[0] == REQUEST_SENSE)
 		return idetape_issue_pc(drive, tape->failed_pc);
-	}
+
 	if (postponed_rq != NULL)
 		if (rq != postponed_rq) {
 			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
@@ -1559,7 +1592,8 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 
 	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ / (jiffies - tape->insert_time);
+		tape->insert_speed = tape->insert_size / 1024 * HZ /
+					(jiffies - tape->insert_time);
 	idetape_calculate_speeds(drive);
 	if ((tape->flags & IDETAPE_FL_IGNORE_DSC) && (stat & SEEK_STAT) == 0) {
 		tape->flags &= ~IDETAPE_FL_IGNORE_DSC;
@@ -1576,7 +1610,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 			} else {
 				return ide_do_reset(drive);
 			}
-		} else if (time_after(jiffies, tape->dsc_polling_start + IDETAPE_DSC_MA_THRESHOLD))
+		} else if (time_after(jiffies,
+					tape->dsc_polling_start +
+					IDETAPE_DSC_MA_THRESHOLD))
 			tape->dsc_poll_freq = IDETAPE_DSC_MA_SLOW;
 		idetape_postpone_request(drive);
 		return ide_stopped;
@@ -1634,7 +1670,7 @@ err:
 }
 
 /* Pipeline related functions */
-static inline int idetape_pipeline_active (idetape_tape_t *tape)
+static inline int idetape_pipeline_active(idetape_tape_t *tape)
 {
 	int rc1, rc2;
 
@@ -1655,22 +1691,26 @@ static inline int idetape_pipeline_active (idetape_tape_t *tape)
  * Pipeline stages are optional and are used to increase performance. If we
  * can't allocate them, we'll manage without them.
  */
-static idetape_stage_t *__idetape_kmalloc_stage (idetape_tape_t *tape, int full, int clear)
+static idetape_stage_t *__idetape_kmalloc_stage(idetape_tape_t *tape, int full,
+		int clear)
 {
 	idetape_stage_t *stage;
 	struct idetape_bh *prev_bh, *bh;
 	int pages = tape->pages_per_stage;
 	char *b_data = NULL;
 
-	if ((stage = kmalloc(sizeof (idetape_stage_t),GFP_KERNEL)) == NULL)
+	stage = kmalloc(sizeof(idetape_stage_t), GFP_KERNEL);
+	if (!stage)
 		return NULL;
 	stage->next = NULL;
 
-	bh = stage->bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+	stage->bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+	bh = stage->bh;
 	if (bh == NULL)
 		goto abort;
 	bh->b_reqnext = NULL;
-	if ((bh->b_data = (char *) __get_free_page (GFP_KERNEL)) == NULL)
+	bh->b_data = (char *) __get_free_page(GFP_KERNEL);
+	if (!bh->b_data)
 		goto abort;
 	if (clear)
 		memset(bh->b_data, 0, PAGE_SIZE);
@@ -1678,7 +1718,8 @@ static idetape_stage_t *__idetape_kmalloc_stage (idetape_tape_t *tape, int full,
 	atomic_set(&bh->b_count, full ? bh->b_size : 0);
 
 	while (--pages) {
-		if ((b_data = (char *) __get_free_page (GFP_KERNEL)) == NULL)
+		b_data = (char *) __get_free_page(GFP_KERNEL);
+		if (!b_data)
 			goto abort;
 		if (clear)
 			memset(b_data, 0, PAGE_SIZE);
@@ -1696,7 +1737,8 @@ static idetape_stage_t *__idetape_kmalloc_stage (idetape_tape_t *tape, int full,
 			continue;
 		}
 		prev_bh = bh;
-		if ((bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL)) == NULL) {
+		bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+		if (!bh) {
 			free_page((unsigned long) b_data);
 			goto abort;
 		}
@@ -1715,7 +1757,7 @@ abort:
 	return NULL;
 }
 
-static idetape_stage_t *idetape_kmalloc_stage (idetape_tape_t *tape)
+static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
 {
 	idetape_stage_t *cache_stage = tape->cache_stage;
 
@@ -1730,7 +1772,8 @@ static idetape_stage_t *idetape_kmalloc_stage (idetape_tape_t *tape)
 	return __idetape_kmalloc_stage(tape, 0, 0);
 }
 
-static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *stage, const char __user *buf, int n)
+static int idetape_copy_stage_from_user(idetape_tape_t *tape,
+		idetape_stage_t *stage, const char __user *buf, int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -1738,12 +1781,15 @@ static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *
 
 	while (n) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_copy_stage_from_user\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return 1;
 		}
-		count = min((unsigned int)(bh->b_size - atomic_read(&bh->b_count)), (unsigned int)n);
-		if (copy_from_user(bh->b_data + atomic_read(&bh->b_count), buf, count))
+		count = min((unsigned int)
+				(bh->b_size - atomic_read(&bh->b_count)),
+				(unsigned int)n);
+		if (copy_from_user(bh->b_data + atomic_read(&bh->b_count), buf,
+				count))
 			ret = 1;
 		n -= count;
 		atomic_add(count, &bh->b_count);
@@ -1758,7 +1804,8 @@ static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *
 	return ret;
 }
 
-static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, idetape_stage_t *stage, int n)
+static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
+		idetape_stage_t *stage, int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -1766,8 +1813,8 @@ static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, i
 
 	while (n) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_copy_stage_to_user\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return 1;
 		}
 		count = min(tape->b_count, n);
@@ -1778,7 +1825,8 @@ static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, i
 		tape->b_count -= count;
 		buf += count;
 		if (!tape->b_count) {
-			tape->bh = bh = bh->b_reqnext;
+			tape->bh = bh->b_reqnext;
+			bh = bh->b_reqnext;
 			if (bh) {
 				tape->b_data = bh->b_data;
 				tape->b_count = atomic_read(&bh->b_count);
@@ -1788,10 +1836,10 @@ static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, i
 	return ret;
 }
 
-static void idetape_init_merge_stage (idetape_tape_t *tape)
+static void idetape_init_merge_stage(idetape_tape_t *tape)
 {
 	struct idetape_bh *bh = tape->merge_stage->bh;
-	
+
 	tape->bh = bh;
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		atomic_set(&bh->b_count, 0);
@@ -1801,7 +1849,7 @@ static void idetape_init_merge_stage (idetape_tape_t *tape)
 	}
 }
 
-static void idetape_switch_buffers (idetape_tape_t *tape, idetape_stage_t *stage)
+static void idetape_switch_buffers(idetape_tape_t *tape, idetape_stage_t *stage)
 {
 	struct idetape_bh *tmp;
 
@@ -1812,7 +1860,7 @@ static void idetape_switch_buffers (idetape_tape_t *tape, idetape_stage_t *stage
 }
 
 /* Add a new stage at the end of the pipeline. */
-static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
+static void idetape_add_stage_tail(ide_drive_t *drive, idetape_stage_t *stage)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -1822,9 +1870,10 @@ static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
 	spin_lock_irqsave(&tape->lock, flags);
 	stage->next = NULL;
 	if (tape->last_stage != NULL)
-		tape->last_stage->next=stage;
+		tape->last_stage->next = stage;
 	else
-		tape->first_stage = tape->next_stage=stage;
+		tape->first_stage = stage;
+		tape->next_stage  = stage;
 	tape->last_stage = stage;
 	if (tape->next_stage == NULL)
 		tape->next_stage = tape->last_stage;
@@ -1837,13 +1886,14 @@ static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
  * caller should ensure that the request will not be serviced before we install
  * the completion (usually by disabling interrupts).
  */
-static void idetape_wait_for_request (ide_drive_t *drive, struct request *rq)
+static void idetape_wait_for_request(ide_drive_t *drive, struct request *rq)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	idetape_tape_t *tape = drive->driver_data;
 
 	if (rq == NULL || !blk_special_request(rq)) {
-		printk (KERN_ERR "ide-tape: bug: Trying to sleep on non-valid request\n");
+		printk(KERN_ERR "ide-tape: bug: Trying to sleep on non-valid"
+				 " request\n");
 		return;
 	}
 	rq->end_io_data = &wait;
@@ -1893,7 +1943,8 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
  * Write a filemark if write_filemark=1. Flush the device buffers without
  * writing a filemark otherwise.
  */
-static void idetape_create_write_filemark_cmd (ide_drive_t *drive, idetape_pc_t *pc,int write_filemark)
+static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
+		idetape_pc_t *pc, int write_filemark)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_FILEMARKS;
@@ -1922,7 +1973,7 @@ static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
  * request list without waiting for it to be serviced! In that case, we usually
  * use idetape_queue_pc_head().
  */
-static int __idetape_queue_pc_tail (ide_drive_t *drive, idetape_pc_t *pc)
+static int __idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 	struct request rq;
@@ -1933,7 +1984,8 @@ static int __idetape_queue_pc_tail (ide_drive_t *drive, idetape_pc_t *pc)
 	return ide_do_drive_cmd(drive, &rq, ide_wait);
 }
 
-static void idetape_create_load_unload_cmd (ide_drive_t *drive, idetape_pc_t *pc,int cmd)
+static void idetape_create_load_unload_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+		int cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = START_STOP;
@@ -1960,7 +2012,8 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 			/* no media */
 			if (load_attempted)
 				return -ENOMEDIUM;
-			idetape_create_load_unload_cmd(drive, &pc, IDETAPE_LU_LOAD_MASK);
+			idetape_create_load_unload_cmd(drive, &pc,
+							IDETAPE_LU_LOAD_MASK);
 			__idetape_queue_pc_tail(drive, &pc);
 			load_attempted = 1;
 		/* not about to be ready */
@@ -1972,24 +2025,25 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	return -EIO;
 }
 
-static int idetape_queue_pc_tail (ide_drive_t *drive,idetape_pc_t *pc)
+static int idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	return __idetape_queue_pc_tail(drive, pc);
 }
 
-static int idetape_flush_tape_buffers (ide_drive_t *drive)
+static int idetape_flush_tape_buffers(ide_drive_t *drive)
 {
 	idetape_pc_t pc;
 	int rc;
 
 	idetape_create_write_filemark_cmd(drive, &pc, 0);
-	if ((rc = idetape_queue_pc_tail(drive, &pc)))
+	rc = idetape_queue_pc_tail(drive, &pc);
+	if (rc)
 		return rc;
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	return 0;
 }
 
-static void idetape_create_read_position_cmd (idetape_pc_t *pc)
+static void idetape_create_read_position_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_POSITION;
@@ -1997,7 +2051,7 @@ static void idetape_create_read_position_cmd (idetape_pc_t *pc)
 	pc->callback = &idetape_read_position_callback;
 }
 
-static int idetape_read_position (ide_drive_t *drive)
+static int idetape_read_position(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
@@ -2012,7 +2066,8 @@ static int idetape_read_position (ide_drive_t *drive)
 	return position;
 }
 
-static void idetape_create_locate_cmd (ide_drive_t *drive, idetape_pc_t *pc, unsigned int block, u8 partition, int skip)
+static void idetape_create_locate_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+		unsigned int block, u8 partition, int skip)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = POSITION_TO_ELEMENT;
@@ -2023,7 +2078,8 @@ static void idetape_create_locate_cmd (ide_drive_t *drive, idetape_pc_t *pc, uns
 	pc->callback = &idetape_pc_callback;
 }
 
-static int idetape_create_prevent_cmd (ide_drive_t *drive, idetape_pc_t *pc, int prevent)
+static int idetape_create_prevent_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+		int prevent)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -2038,7 +2094,7 @@ static int idetape_create_prevent_cmd (ide_drive_t *drive, idetape_pc_t *pc, int
 	return 1;
 }
 
-static int __idetape_discard_read_pipeline (ide_drive_t *drive)
+static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2077,7 +2133,7 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 	while (tape->first_stage != NULL) {
 		struct request *rq_ptr = &tape->first_stage->rq;
 
-		cnt += rq_ptr->nr_sectors - rq_ptr->current_nr_sectors; 
+		cnt += rq_ptr->nr_sectors - rq_ptr->current_nr_sectors;
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
 			++cnt;
 		idetape_remove_stage_head(drive);
@@ -2093,7 +2149,8 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
  * all higher level operations, we queue the commands at the tail of the request
  * queue and wait for their completion.
  */
-static int idetape_position_tape (ide_drive_t *drive, unsigned int block, u8 partition, int skip)
+static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
+		u8 partition, int skip)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int retval;
@@ -2111,7 +2168,8 @@ static int idetape_position_tape (ide_drive_t *drive, unsigned int block, u8 par
 	return (idetape_queue_pc_tail(drive, &pc));
 }
 
-static void idetape_discard_read_pipeline (ide_drive_t *drive, int restore_position)
+static void idetape_discard_read_pipeline(ide_drive_t *drive,
+				int restore_position)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int cnt;
@@ -2122,7 +2180,8 @@ static void idetape_discard_read_pipeline (ide_drive_t *drive, int restore_posit
 		position = idetape_read_position(drive);
 		seek = position > cnt ? position - cnt : 0;
 		if (idetape_position_tape(drive, seek, 0, 0)) {
-			printk(KERN_INFO "ide-tape: %s: position_tape failed in discard_pipeline()\n", tape->name);
+			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
+					 " discard_pipeline()\n", tape->name);
 			return;
 		}
 	}
@@ -2132,7 +2191,8 @@ static void idetape_discard_read_pipeline (ide_drive_t *drive, int restore_posit
  * Generate a read/write request for the block device interface and wait for it
  * to be serviced.
  */
-static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct idetape_bh *bh)
+static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
+		struct idetape_bh *bh)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request rq;
@@ -2149,7 +2209,8 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 	rq.rq_disk = tape->disk;
 	rq.special = (void *)bh;
 	rq.sector = tape->first_frame;
-	rq.nr_sectors = rq.current_nr_sectors = blocks;
+	rq.nr_sectors		= blocks;
+	rq.current_nr_sectors	= blocks;
 	(void) ide_do_drive_cmd(drive, &rq, ide_wait);
 
 	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
@@ -2176,15 +2237,16 @@ static void idetape_plug_pipeline(ide_drive_t *drive)
 	}
 }
 
-static void idetape_create_inquiry_cmd (idetape_pc_t *pc)
+static void idetape_create_inquiry_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = INQUIRY;
-	pc->c[4] = pc->request_transfer = 254;
+	pc->c[4] = 254;
+	pc->request_transfer = 254;
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_create_rewind_cmd (ide_drive_t *drive, idetape_pc_t *pc)
+static void idetape_create_rewind_cmd(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = REZERO_UNIT;
@@ -2192,7 +2254,7 @@ static void idetape_create_rewind_cmd (ide_drive_t *drive, idetape_pc_t *pc)
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_create_erase_cmd (idetape_pc_t *pc)
+static void idetape_create_erase_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = ERASE;
@@ -2201,7 +2263,7 @@ static void idetape_create_erase_cmd (idetape_pc_t *pc)
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_create_space_cmd (idetape_pc_t *pc,int count, u8 cmd)
+static void idetape_create_space_cmd(idetape_pc_t *pc, int count, u8 cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = SPACE;
@@ -2211,7 +2273,7 @@ static void idetape_create_space_cmd (idetape_pc_t *pc,int count, u8 cmd)
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_wait_first_stage (ide_drive_t *drive)
+static void idetape_wait_first_stage(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2235,7 +2297,7 @@ static void idetape_wait_first_stage (ide_drive_t *drive)
  * 3. If we still can't allocate a stage, fallback to non-pipelined operation
  * mode for this request.
  */
-static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
+static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *new_stage;
@@ -2259,14 +2321,16 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 			 * The machine is short on memory. Fallback to non-
 			 * pipelined operation mode for this request.
 			 */
-			return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks, tape->merge_stage->bh);
+			return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
+						blocks, tape->merge_stage->bh);
 		}
 	}
 	rq = &new_stage->rq;
 	idetape_init_rq(rq, REQ_IDETAPE_WRITE);
 	/* Doesn't actually matter - We always assume sequential access */
 	rq->sector = tape->first_frame;
-	rq->nr_sectors = rq->current_nr_sectors = blocks;
+	rq->current_nr_sectors = blocks;
+	rq->nr_sectors = blocks;
 
 	idetape_switch_buffers(tape, new_stage);
 	idetape_add_stage_tail(drive, new_stage);
@@ -2304,7 +2368,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
  * Wait until all pending pipeline requests are serviced. Typically called on
  * device close.
  */
-static void idetape_wait_for_pipeline (ide_drive_t *drive)
+static void idetape_wait_for_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2318,14 +2382,15 @@ static void idetape_wait_for_pipeline (ide_drive_t *drive)
 	}
 }
 
-static void idetape_empty_write_pipeline (ide_drive_t *drive)
+static void idetape_empty_write_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int blocks, min;
 	struct idetape_bh *bh;
 
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
-		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline, but we are not writing.\n");
+		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline,"
+				" but we are not writing.\n");
 		return;
 	}
 	if (tape->merge_stage_size > tape->stage_size) {
@@ -2348,12 +2413,14 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 			bh = tape->bh;
 			while (i) {
 				if (bh == NULL) {
-
-					printk(KERN_INFO "ide-tape: bug, bh NULL\n");
+					printk(KERN_INFO "ide-tape: bug,"
+							 " bh NULL\n");
 					break;
 				}
-				min = min(i, (unsigned int)(bh->b_size - atomic_read(&bh->b_count)));
-				memset(bh->b_data + atomic_read(&bh->b_count), 0, min);
+				min = min(i, (unsigned int)(bh->b_size -
+						atomic_read(&bh->b_count)));
+				memset(bh->b_data + atomic_read(&bh->b_count),
+						0, min);
 				atomic_add(min, &bh->b_count);
 				i -= min;
 				bh = bh->b_reqnext;
@@ -2389,18 +2456,22 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	}
 }
 
-static void idetape_restart_speed_control (ide_drive_t *drive)
+static void idetape_restart_speed_control(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
 	tape->restart_speed_control_req = 0;
 	tape->pipeline_head = 0;
 	tape->controlled_last_pipeline_head = 0;
-	tape->controlled_previous_pipeline_head = tape->uncontrolled_previous_pipeline_head = 0;
-	tape->pipeline_head_speed = tape->controlled_pipeline_head_speed = 5000;
+	tape->controlled_previous_pipeline_head = 0;
+	tape->uncontrolled_previous_pipeline_head = 0;
+	tape->controlled_pipeline_head_speed = 5000;
+	tape->pipeline_head_speed = 5000;
 	tape->uncontrolled_pipeline_head_speed = 0;
-	tape->controlled_pipeline_head_time = tape->uncontrolled_pipeline_head_time = jiffies;
-	tape->controlled_previous_head_time = tape->uncontrolled_previous_head_time = jiffies;
+	tape->controlled_pipeline_head_time =
+		tape->uncontrolled_pipeline_head_time = jiffies;
+	tape->controlled_previous_head_time =
+		tape->uncontrolled_previous_head_time = jiffies;
 }
 
 static int idetape_init_read(ide_drive_t *drive, int max_stages)
@@ -2418,10 +2489,12 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 			idetape_flush_tape_buffers(drive);
 		}
 		if (tape->merge_stage || tape->merge_stage_size) {
-			printk (KERN_ERR "ide-tape: merge_stage_size should be 0 now\n");
+			printk(KERN_ERR "ide-tape: merge_stage_size should be"
+					 " 0 now\n");
 			tape->merge_stage_size = 0;
 		}
-		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
+		tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0);
+		if (!tape->merge_stage)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_READ;
 
@@ -2432,7 +2505,9 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 		 * drives (Seagate STT3401A) will return an error.
 		 */
 		if (drive->dsc_overlap) {
-			bytes_read = idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, 0, tape->merge_stage->bh);
+			bytes_read = idetape_queue_rw_tail(drive,
+							REQ_IDETAPE_READ, 0,
+							tape->merge_stage->bh);
 			if (bytes_read < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
@@ -2445,7 +2520,8 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 		idetape_restart_speed_control(drive);
 	idetape_init_rq(&rq, REQ_IDETAPE_READ);
 	rq.sector = tape->first_frame;
-	rq.nr_sectors = rq.current_nr_sectors = blocks;
+	rq.current_nr_sectors = blocks;
+	rq.nr_sectors = blocks;
 	if (!(tape->flags & IDETAPE_FL_PIPELINE_ERR) &&
 			tape->nr_stages < max_stages) {
 		new_stage = idetape_kmalloc_stage(tape);
@@ -2473,7 +2549,7 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
  * Called from idetape_chrdev_read() to service a character device read request
  * and add read-ahead requests to our pipeline.
  */
-static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
+static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2498,7 +2574,8 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 	rq_ptr = &tape->first_stage->rq;
 	bytes_read = tape->blk_size * (rq_ptr->nr_sectors -
 					rq_ptr->current_nr_sectors);
-	rq_ptr->nr_sectors = rq_ptr->current_nr_sectors = 0;
+	rq_ptr->nr_sectors = 0;
+	rq_ptr->current_nr_sectors = 0;
 
 
 	if (rq_ptr->errors == IDETAPE_ERROR_EOD)
@@ -2514,13 +2591,14 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 		idetape_calculate_speeds(drive);
 	}
 	if (bytes_read > blocks * tape->blk_size) {
-		printk(KERN_ERR "ide-tape: bug: trying to return more bytes than requested\n");
+		printk(KERN_ERR "ide-tape: bug: trying to return more bytes"
+				" than requested\n");
 		bytes_read = blocks * tape->blk_size;
 	}
 	return (bytes_read);
 }
 
-static void idetape_pad_zeros (ide_drive_t *drive, int bcount)
+static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct idetape_bh *bh;
@@ -2534,16 +2612,18 @@ static void idetape_pad_zeros (ide_drive_t *drive, int bcount)
 		bcount -= count;
 		blocks = count / tape->blk_size;
 		while (count) {
-			atomic_set(&bh->b_count, min(count, (unsigned int)bh->b_size));
+			atomic_set(&bh->b_count,
+				min(count, (unsigned int)bh->b_size));
 			memset(bh->b_data, 0, atomic_read(&bh->b_count));
 			count -= atomic_read(&bh->b_count);
 			bh = bh->b_reqnext;
 		}
-		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks, tape->merge_stage->bh);
+		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks,
+					tape->merge_stage->bh);
 	}
 }
 
-static int idetape_pipeline_size (ide_drive_t *drive)
+static int idetape_pipeline_size(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *stage;
@@ -2568,7 +2648,7 @@ static int idetape_pipeline_size (ide_drive_t *drive)
  * Rewinds the tape to the Beginning Of the current Partition (BOP). We
  * currently support only one partition.
  */
-static int idetape_rewind_tape (ide_drive_t *drive)
+static int idetape_rewind_tape(ide_drive_t *drive)
 {
 	int retval;
 	idetape_pc_t pc;
@@ -2590,7 +2670,8 @@ static int idetape_rewind_tape (ide_drive_t *drive)
 }
 
 /* mtio.h compatible commands should be issued to the chrdev interface. */
-static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned long arg)
+static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
+		unsigned long arg)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	void __user *argp = (void __user *)arg;
@@ -2604,20 +2685,20 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	switch (cmd) {
-		case 0x0340:
-			if (copy_from_user(&config, argp, sizeof(config)))
-				return -EFAULT;
-			tape->best_dsc_rw_freq = config.dsc_rw_frequency;
-			tape->max_stages = config.nr_stages;
-			break;
-		case 0x0350:
-			config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
-			config.nr_stages = tape->max_stages; 
-			if (copy_to_user(argp, &config, sizeof(config)))
-				return -EFAULT;
-			break;
-		default:
-			return -EIO;
+	case 0x0340:
+		if (copy_from_user(&config, argp, sizeof(config)))
+			return -EFAULT;
+		tape->best_dsc_rw_freq = config.dsc_rw_frequency;
+		tape->max_stages = config.nr_stages;
+		break;
+	case 0x0350:
+		config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
+		config.nr_stages = tape->max_stages;
+		if (copy_to_user(argp, &config, sizeof(config)))
+			return -EFAULT;
+		break;
+	default:
+		return -EIO;
 	}
 	return 0;
 }
@@ -2629,12 +2710,13 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
  * support MTFSFM when the filemark is in our internal pipeline even if the tape
  * doesn't support spacing over filemarks in the reverse direction.
  */
-static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_count)
+static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
+		int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
 	unsigned long flags;
-	int retval,count=0;
+	int retval, count = 0;
 	int sprev = !!(tape->caps[4] & 0x20);
 
 	if (mt_count == 0)
@@ -2642,7 +2724,7 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 	if (MTBSF == mt_op || MTBSFM == mt_op) {
 		if (!sprev)
 			return -EIO;
-		mt_count = - mt_count;
+		mt_count = -mt_count;
 	}
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
@@ -2677,7 +2759,8 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 				tape->next_stage = tape->first_stage->next;
 			} else
 				spin_unlock_irqrestore(&tape->lock, flags);
-			if (tape->first_stage->rq.errors == IDETAPE_ERROR_FILEMARK)
+			if (tape->first_stage->rq.errors ==
+					IDETAPE_ERROR_FILEMARK)
 				++count;
 			idetape_remove_stage_head(drive);
 		}
@@ -2689,21 +2772,25 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 	 * the space command.
 	 */
 	switch (mt_op) {
-		case MTFSF:
-		case MTBSF:
-			idetape_create_space_cmd(&pc,mt_count-count,IDETAPE_SPACE_OVER_FILEMARK);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTFSFM:
-		case MTBSFM:
-			if (!sprev)
-				return (-EIO);
-			retval = idetape_space_over_filemarks(drive, MTFSF, mt_count-count);
-			if (retval) return (retval);
-			count = (MTBSFM == mt_op ? 1 : -1);
-			return (idetape_space_over_filemarks(drive, MTFSF, count));
-		default:
-			printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",mt_op);
+	case MTFSF:
+	case MTBSF:
+		idetape_create_space_cmd(&pc, mt_count-count,
+					IDETAPE_SPACE_OVER_FILEMARK);
+		return (idetape_queue_pc_tail(drive, &pc));
+	case MTFSFM:
+	case MTBSFM:
+		if (!sprev)
 			return (-EIO);
+		retval = idetape_space_over_filemarks(drive, MTFSF,
+							mt_count-count);
+		if (retval)
+			return (retval);
+		count = (MTBSFM == mt_op ? 1 : -1);
+		return (idetape_space_over_filemarks(drive, MTFSF, count));
+	default:
+		printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",
+				mt_op);
+		return (-EIO);
 	}
 }
 
@@ -2723,12 +2810,12 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
  * (slightly) increased driver overhead, but will no longer hit performance.
  * This is not applicable to Onstream.
  */
-static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
+static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 				    size_t count, loff_t *ppos)
 {
 	struct ide_tape_obj *tape = ide_tape_f(file);
 	ide_drive_t *drive = tape->drive;
-	ssize_t bytes_read,temp, actually_read = 0, rc;
+	ssize_t bytes_read, temp, actually_read = 0, rc;
 	ssize_t ret = 0;
 	u16 ctl = *(u16 *)&tape->caps[12];
 
@@ -2746,8 +2833,10 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 	if (count == 0)
 		return (0);
 	if (tape->merge_stage_size) {
-		actually_read = min((unsigned int)(tape->merge_stage_size), (unsigned int)count);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, actually_read))
+		actually_read = min((unsigned int)(tape->merge_stage_size),
+				(unsigned int)count);
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+						actually_read))
 			ret = -EFAULT;
 		buf += actually_read;
 		tape->merge_stage_size -= actually_read;
@@ -2757,7 +2846,8 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, bytes_read))
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+						bytes_read))
 			ret = -EFAULT;
 		buf += bytes_read;
 		count -= bytes_read;
@@ -2768,7 +2858,8 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		if (bytes_read <= 0)
 			goto finish;
 		temp = min((unsigned long)count, (unsigned long)bytes_read);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, temp))
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+						temp))
 			ret = -EFAULT;
 		actually_read += temp;
 		tape->merge_stage_size = bytes_read-temp;
@@ -2784,7 +2875,7 @@ finish:
 	return (ret) ? ret : actually_read;
 }
 
-static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
+static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 				     size_t count, loff_t *ppos)
 {
 	struct ide_tape_obj *tape = ide_tape_f(file);
@@ -2808,7 +2899,8 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 				"should be 0 now\n");
 			tape->merge_stage_size = 0;
 		}
-		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
+		tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0);
+		if (!tape->merge_stage)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_WRITE;
 		idetape_init_merge_stage(tape);
@@ -2820,7 +2912,9 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 		 * drives (Seagate STT3401A) will return an error.
 		 */
 		if (drive->dsc_overlap) {
-			ssize_t retval = idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, 0, tape->merge_stage->bh);
+			ssize_t retval = idetape_queue_rw_tail(drive,
+							REQ_IDETAPE_WRITE, 0,
+							tape->merge_stage->bh);
 			if (retval < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
@@ -2835,11 +2929,14 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 		idetape_restart_speed_control(drive);
 	if (tape->merge_stage_size) {
 		if (tape->merge_stage_size >= tape->stage_size) {
-			printk(KERN_ERR "ide-tape: bug: merge buffer too big\n");
+			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
 			tape->merge_stage_size = 0;
 		}
-		actually_written = min((unsigned int)(tape->stage_size - tape->merge_stage_size), (unsigned int)count);
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, actually_written))
+		actually_written = min((unsigned int)
+				(tape->stage_size - tape->merge_stage_size),
+				(unsigned int)count);
+		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
+						actually_written))
 				ret = -EFAULT;
 		buf += actually_written;
 		tape->merge_stage_size += actually_written;
@@ -2855,7 +2952,8 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	}
 	while (count >= tape->stage_size) {
 		ssize_t retval;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, tape->stage_size))
+		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
+						tape->stage_size))
 			ret = -EFAULT;
 		buf += tape->stage_size;
 		count -= tape->stage_size;
@@ -2866,14 +2964,15 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	}
 	if (count) {
 		actually_written += count;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, count))
+		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
+						count))
 			ret = -EFAULT;
 		tape->merge_stage_size += count;
 	}
 	return (ret) ? ret : actually_written;
 }
 
-static int idetape_write_filemark (ide_drive_t *drive)
+static int idetape_write_filemark(ide_drive_t *drive)
 {
 	idetape_pc_t pc;
 
@@ -2904,110 +3003,117 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
-	int i,retval;
+	int i, retval;
 
 	debug_log(DBG_ERR, "Handling MTIOCTOP ioctl: mt_op=%d, mt_count=%d\n",
 			mt_op, mt_count);
 	/* Commands which need our pipelined read-ahead stages. */
 	switch (mt_op) {
-		case MTFSF:
-		case MTFSFM:
-		case MTBSF:
-		case MTBSFM:
-			if (!mt_count)
-				return (0);
-			return (idetape_space_over_filemarks(drive,mt_op,mt_count));
-		default:
-			break;
+	case MTFSF:
+	case MTFSFM:
+	case MTBSF:
+	case MTBSFM:
+		if (!mt_count)
+			return (0);
+		return (idetape_space_over_filemarks(drive, mt_op, mt_count));
+	default:
+		break;
 	}
 	switch (mt_op) {
-		case MTWEOF:
-			if (tape->write_prot)
-				return -EACCES;
-			idetape_discard_read_pipeline(drive, 1);
-			for (i = 0; i < mt_count; i++) {
-				retval = idetape_write_filemark(drive);
-				if (retval)
-					return retval;
-			}
-			return (0);
-		case MTREW:
-			idetape_discard_read_pipeline(drive, 0);
-			if (idetape_rewind_tape(drive))
+	case MTWEOF:
+		if (tape->write_prot)
+			return -EACCES;
+		idetape_discard_read_pipeline(drive, 1);
+		for (i = 0; i < mt_count; i++) {
+			retval = idetape_write_filemark(drive);
+			if (retval)
+				return retval;
+		}
+		return (0);
+	case MTREW:
+		idetape_discard_read_pipeline(drive, 0);
+		if (idetape_rewind_tape(drive))
+			return -EIO;
+		return 0;
+	case MTLOAD:
+		idetape_discard_read_pipeline(drive, 0);
+		idetape_create_load_unload_cmd(drive, &pc,
+						IDETAPE_LU_LOAD_MASK);
+		return (idetape_queue_pc_tail(drive, &pc));
+	case MTUNLOAD:
+	case MTOFFL:
+		/*
+		 * If door is locked, attempt to unlock before
+		 * attempting to eject.
+		 */
+		if (tape->door_locked) {
+			if (idetape_create_prevent_cmd(drive, &pc, 0))
+				if (!idetape_queue_pc_tail(drive, &pc))
+					tape->door_locked = DOOR_UNLOCKED;
+		}
+		idetape_discard_read_pipeline(drive, 0);
+		idetape_create_load_unload_cmd(drive, &pc,
+						!IDETAPE_LU_LOAD_MASK);
+		retval = idetape_queue_pc_tail(drive, &pc);
+		if (!retval)
+			tape->flags &= ~IDETAPE_FL_MEDIUM_PRESENT;
+		return retval;
+	case MTNOP:
+		idetape_discard_read_pipeline(drive, 0);
+		return (idetape_flush_tape_buffers(drive));
+	case MTRETEN:
+		idetape_discard_read_pipeline(drive, 0);
+		idetape_create_load_unload_cmd(drive, &pc,
+			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
+		return (idetape_queue_pc_tail(drive, &pc));
+	case MTEOM:
+		idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
+		return (idetape_queue_pc_tail(drive, &pc));
+	case MTERASE:
+		(void) idetape_rewind_tape(drive);
+		idetape_create_erase_cmd(&pc);
+		return (idetape_queue_pc_tail(drive, &pc));
+	case MTSETBLK:
+		if (mt_count) {
+			if (mt_count < tape->blk_size ||
+			    mt_count % tape->blk_size)
 				return -EIO;
+			tape->user_bs_factor = mt_count /
+						tape->blk_size;
+			tape->flags &= ~IDETAPE_FL_DETECT_BS;
+		} else
+			tape->flags |= IDETAPE_FL_DETECT_BS;
+		return 0;
+	case MTSEEK:
+		idetape_discard_read_pipeline(drive, 0);
+		return idetape_position_tape(drive,
+					mt_count * tape->user_bs_factor,
+					tape->partition, 0);
+	case MTSETPART:
+		idetape_discard_read_pipeline(drive, 0);
+		return (idetape_position_tape(drive, 0, mt_count, 0));
+	case MTFSR:
+	case MTBSR:
+	case MTLOCK:
+		if (!idetape_create_prevent_cmd(drive, &pc, 1))
 			return 0;
-		case MTLOAD:
-			idetape_discard_read_pipeline(drive, 0);
-			idetape_create_load_unload_cmd(drive, &pc, IDETAPE_LU_LOAD_MASK);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTUNLOAD:
-		case MTOFFL:
-			/*
-			 * If door is locked, attempt to unlock before
-			 * attempting to eject.
-			 */
-			if (tape->door_locked) {
-				if (idetape_create_prevent_cmd(drive, &pc, 0))
-					if (!idetape_queue_pc_tail(drive, &pc))
-						tape->door_locked = DOOR_UNLOCKED;
-			}
-			idetape_discard_read_pipeline(drive, 0);
-			idetape_create_load_unload_cmd(drive, &pc,!IDETAPE_LU_LOAD_MASK);
-			retval = idetape_queue_pc_tail(drive, &pc);
-			if (!retval)
-				tape->flags &= ~IDETAPE_FL_MEDIUM_PRESENT;
+		retval = idetape_queue_pc_tail(drive, &pc);
+		if (retval)
 			return retval;
-		case MTNOP:
-			idetape_discard_read_pipeline(drive, 0);
-			return (idetape_flush_tape_buffers(drive));
-		case MTRETEN:
-			idetape_discard_read_pipeline(drive, 0);
-			idetape_create_load_unload_cmd(drive, &pc,IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTEOM:
-			idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTERASE:
-			(void) idetape_rewind_tape(drive);
-			idetape_create_erase_cmd(&pc);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTSETBLK:
-			if (mt_count) {
-				if (mt_count < tape->blk_size ||
-				    mt_count % tape->blk_size)
-					return -EIO;
-				tape->user_bs_factor = mt_count /
-							tape->blk_size;
-				tape->flags &= ~IDETAPE_FL_DETECT_BS;
-			} else
-				tape->flags |= IDETAPE_FL_DETECT_BS;
-			return 0;
-		case MTSEEK:
-			idetape_discard_read_pipeline(drive, 0);
-			return idetape_position_tape(drive, mt_count * tape->user_bs_factor, tape->partition, 0);
-		case MTSETPART:
-			idetape_discard_read_pipeline(drive, 0);
-			return (idetape_position_tape(drive, 0, mt_count, 0));
-		case MTFSR:
-		case MTBSR:
-		case MTLOCK:
-			if (!idetape_create_prevent_cmd(drive, &pc, 1))
-				return 0;
-			retval = idetape_queue_pc_tail(drive, &pc);
-			if (retval) return retval;
-			tape->door_locked = DOOR_EXPLICITLY_LOCKED;
-			return 0;
-		case MTUNLOCK:
-			if (!idetape_create_prevent_cmd(drive, &pc, 0))
-				return 0;
-			retval = idetape_queue_pc_tail(drive, &pc);
-			if (retval) return retval;
-			tape->door_locked = DOOR_UNLOCKED;
+		tape->door_locked = DOOR_EXPLICITLY_LOCKED;
+		return 0;
+	case MTUNLOCK:
+		if (!idetape_create_prevent_cmd(drive, &pc, 0))
 			return 0;
-		default:
-			printk(KERN_ERR "ide-tape: MTIO operation %d not "
-				"supported\n", mt_op);
-			return (-EIO);
+		retval = idetape_queue_pc_tail(drive, &pc);
+		if (retval)
+			return retval;
+		tape->door_locked = DOOR_UNLOCKED;
+		return 0;
+	default:
+		printk(KERN_ERR "ide-tape: MTIO operation %d not "
+			"supported\n", mt_op);
+		return (-EIO);
 	}
 }
 
@@ -3037,37 +3143,38 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
 		block_offset = idetape_pipeline_size(drive) /
 			(tape->blk_size * tape->user_bs_factor);
-		if ((position = idetape_read_position(drive)) < 0)
+		position = idetape_read_position(drive);
+		if (position < 0)
 			return -EIO;
 	}
 	switch (cmd) {
-		case MTIOCTOP:
-			if (copy_from_user(&mtop, argp, sizeof (struct mtop)))
-				return -EFAULT;
-			return (idetape_mtioctop(drive,mtop.mt_op,mtop.mt_count));
-		case MTIOCGET:
-			memset(&mtget, 0, sizeof (struct mtget));
-			mtget.mt_type = MT_ISSCSI2;
-			mtget.mt_blkno = position / tape->user_bs_factor - block_offset;
-			mtget.mt_dsreg =
-				((tape->blk_size * tape->user_bs_factor)
-				 << MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK;
-
-			if (tape->drv_write_prot) {
-				mtget.mt_gstat |= GMT_WR_PROT(0xffffffff);
-			}
-			if (copy_to_user(argp, &mtget, sizeof(struct mtget)))
-				return -EFAULT;
-			return 0;
-		case MTIOCPOS:
-			mtpos.mt_blkno = position / tape->user_bs_factor - block_offset;
-			if (copy_to_user(argp, &mtpos, sizeof(struct mtpos)))
-				return -EFAULT;
-			return 0;
-		default:
-			if (tape->chrdev_dir == IDETAPE_DIR_READ)
-				idetape_discard_read_pipeline(drive, 1);
-			return idetape_blkdev_ioctl(drive, cmd, arg);
+	case MTIOCTOP:
+		if (copy_from_user(&mtop, argp, sizeof(struct mtop)))
+			return -EFAULT;
+		return (idetape_mtioctop(drive, mtop.mt_op, mtop.mt_count));
+	case MTIOCGET:
+		memset(&mtget, 0, sizeof(struct mtget));
+		mtget.mt_type = MT_ISSCSI2;
+		mtget.mt_blkno = position / tape->user_bs_factor - block_offset;
+		mtget.mt_dsreg =
+			((tape->blk_size * tape->user_bs_factor)
+			 << MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK;
+
+		if (tape->drv_write_prot)
+			mtget.mt_gstat |= GMT_WR_PROT(0xffffffff);
+
+		if (copy_to_user(argp, &mtget, sizeof(struct mtget)))
+			return -EFAULT;
+		return 0;
+	case MTIOCPOS:
+		mtpos.mt_blkno = position / tape->user_bs_factor - block_offset;
+		if (copy_to_user(argp, &mtpos, sizeof(struct mtpos)))
+			return -EFAULT;
+		return 0;
+	default:
+		if (tape->chrdev_dir == IDETAPE_DIR_READ)
+			idetape_discard_read_pipeline(drive, 1);
+		return idetape_blkdev_ioctl(drive, cmd, arg);
 	}
 }
 
@@ -3096,7 +3203,7 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
 }
 
-static int idetape_chrdev_open (struct inode *inode, struct file *filp)
+static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 {
 	unsigned int minor = iminor(inode), i = minor & ~0xc0;
 	ide_drive_t *drive;
@@ -3182,7 +3289,7 @@ out_put_tape:
 	return retval;
 }
 
-static void idetape_write_release (ide_drive_t *drive, unsigned int minor)
+static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -3199,7 +3306,7 @@ static void idetape_write_release (ide_drive_t *drive, unsigned int minor)
 	idetape_flush_tape_buffers(drive);
 }
 
-static int idetape_chrdev_release (struct inode *inode, struct file *filp)
+static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 {
 	struct ide_tape_obj *tape = ide_tape_f(filp);
 	ide_drive_t *drive = tape->drive;
@@ -3308,7 +3415,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
  * Ask the tape about its various parameters. In particular, we will adjust our
  * data transfer buffer	size to the recommended value as returned by the tape.
  */
-static void idetape_get_mode_sense_results (ide_drive_t *drive)
+static void idetape_get_mode_sense_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
@@ -3355,17 +3462,24 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 }
 
 #ifdef CONFIG_IDE_PROC_FS
-static void idetape_add_settings (ide_drive_t *drive)
+static void idetape_add_settings(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
 	ide_add_setting(drive, "buffer", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 2, (u16 *)&tape->caps[16], NULL);
-	ide_add_setting(drive,	"pipeline_min",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->min_pipeline,			NULL);
-	ide_add_setting(drive,	"pipeline",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_stages,			NULL);
-	ide_add_setting(drive,	"pipeline_max",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_pipeline,			NULL);
-	ide_add_setting(drive,	"pipeline_used",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_stages,			NULL);
-	ide_add_setting(drive,	"pipeline_pending",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_pending_stages,		NULL);
+	ide_add_setting(drive, "pipeline_min", SETTING_RW, TYPE_INT, 1, 0xffff,
+			tape->stage_size / 1024, 1, &tape->min_pipeline, NULL);
+	ide_add_setting(drive, "pipeline", SETTING_RW, TYPE_INT, 1, 0xffff,
+			tape->stage_size / 1024, 1, &tape->max_stages, NULL);
+	ide_add_setting(drive, "pipeline_max", SETTING_RW, TYPE_INT, 1,	0xffff,
+			tape->stage_size / 1024, 1, &tape->max_pipeline, NULL);
+	ide_add_setting(drive, "pipeline_used",	SETTING_READ, TYPE_INT, 0,
+			0xffff,	tape->stage_size / 1024, 1, &tape->nr_stages,
+			NULL);
+	ide_add_setting(drive, "pipeline_pending", SETTING_READ, TYPE_INT, 0,
+			0xffff, tape->stage_size / 1024, 1,
+			&tape->nr_pending_stages, NULL);
 	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 1, (u16 *)&tape->caps[14], NULL);
 	ide_add_setting(drive, "stage", SETTING_READ, TYPE_INT,	0, 0xffff, 1,
@@ -3373,10 +3487,16 @@ static void idetape_add_settings (ide_drive_t *drive)
 	ide_add_setting(drive, "tdsc", SETTING_RW, TYPE_INT, IDETAPE_DSC_RW_MIN,
 			IDETAPE_DSC_RW_MAX, 1000, HZ, &tape->best_dsc_rw_freq,
 			NULL);
-	ide_add_setting(drive,	"dsc_overlap",		SETTING_RW,	TYPE_BYTE,	0,			1,			1,				1,		&drive->dsc_overlap,			NULL);
-	ide_add_setting(drive,	"pipeline_head_speed_c",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->controlled_pipeline_head_speed,	NULL);
-	ide_add_setting(drive,	"pipeline_head_speed_u",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->uncontrolled_pipeline_head_speed,NULL);
-	ide_add_setting(drive,	"avg_speed",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->avg_speed,			NULL);
+	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1,
+			1, &drive->dsc_overlap, NULL);
+	ide_add_setting(drive, "pipeline_head_speed_c", SETTING_READ, TYPE_INT,
+			0, 0xffff, 1, 1, &tape->controlled_pipeline_head_speed,
+			NULL);
+	ide_add_setting(drive, "pipeline_head_speed_u", SETTING_READ, TYPE_INT,
+			0, 0xffff, 1, 1,
+			&tape->uncontrolled_pipeline_head_speed, NULL);
+	ide_add_setting(drive, "avg_speed", SETTING_READ, TYPE_INT, 0, 0xffff,
+			1, 1, &tape->avg_speed, NULL);
 	ide_add_setting(drive, "debug_mask", SETTING_RW, TYPE_INT, 0, 0xffff, 1,
 			1, &tape->debug_mask, NULL);
 }
@@ -3394,7 +3514,7 @@ static inline void idetape_add_settings(ide_drive_t *drive) { ; }
  * this point ide.c already assigned us an irq, so that we can queue requests
  * here and wait for their completion.
  */
-static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
+static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 {
 	unsigned long t1, tmid, tn, t;
 	int speed;
@@ -3426,7 +3546,9 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	if (((gcw[0] & 0x60) >> 5) == 1)
 		tape->flags |= IDETAPE_FL_DRQ_INTERRUPT;
 
-	tape->min_pipeline = tape->max_pipeline = tape->max_stages = 10;
+	tape->min_pipeline = 10;
+	tape->max_pipeline = 10;
+	tape->max_stages   = 10;
 
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
@@ -3452,13 +3574,20 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 
 	/* Limit memory use for pipeline to 10% of physical memory */
 	si_meminfo(&si);
-	if (tape->max_stages * tape->stage_size > si.totalram * si.mem_unit / 10)
-		tape->max_stages = si.totalram * si.mem_unit / (10 * tape->stage_size);
+	if (tape->max_stages * tape->stage_size >
+			si.totalram * si.mem_unit / 10)
+		tape->max_stages =
+			si.totalram * si.mem_unit / (10 * tape->stage_size);
+
 	tape->max_stages   = min(tape->max_stages, IDETAPE_MAX_PIPELINE_STAGES);
 	tape->min_pipeline = min(tape->max_stages, IDETAPE_MIN_PIPELINE_STAGES);
-	tape->max_pipeline = min(tape->max_stages * 2, IDETAPE_MAX_PIPELINE_STAGES);
-	if (tape->max_stages == 0)
-		tape->max_stages = tape->min_pipeline = tape->max_pipeline = 1;
+	tape->max_pipeline =
+		min(tape->max_stages * 2, IDETAPE_MAX_PIPELINE_STAGES);
+	if (tape->max_stages == 0) {
+		tape->max_stages   = 1;
+		tape->min_pipeline = 1;
+		tape->max_pipeline = 1;
+	}
 
 	t1 = (tape->stage_size * HZ) / (speed * 1000);
 	tmid = (*(u16 *)&tape->caps[16] * 32 * HZ) / (speed * 125);
@@ -3510,7 +3639,8 @@ static void ide_tape_release(struct kref *kref)
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
 	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor));
-	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor + 128));
+	device_destroy(idetape_sysfs_class,
+			MKDEV(IDETAPE_MAJOR, tape->minor + 128));
 	idetape_devs[tape->minor] = NULL;
 	g->private_data = NULL;
 	put_disk(g);
@@ -3574,7 +3704,8 @@ static int idetape_open(struct inode *inode, struct file *filp)
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_tape_obj *tape;
 
-	if (!(tape = ide_tape_get(disk)))
+	tape = ide_tape_get(disk);
+	if (!tape)
 		return -ENXIO;
 
 	return 0;
@@ -3621,17 +3752,20 @@ static int ide_tape_probe(ide_drive_t *drive)
 		goto failed;
 	if (drive->media != ide_tape)
 		goto failed;
-	if (!idetape_identify_device (drive)) {
-		printk(KERN_ERR "ide-tape: %s: not supported by this version of ide-tape\n", drive->name);
+	if (!idetape_identify_device(drive)) {
+		printk(KERN_ERR "ide-tape: %s: not supported by this version of"
+				" the driver\n", drive->name);
 		goto failed;
 	}
 	if (drive->scsi) {
-		printk("ide-tape: passing drive %s to ide-scsi emulation.\n", drive->name);
+		printk("ide-tape: passing drive %s to ide-scsi emulation.\n",
+				drive->name);
 		goto failed;
 	}
-	tape = kzalloc(sizeof (idetape_tape_t), GFP_KERNEL);
+	tape = kzalloc(sizeof(idetape_tape_t), GFP_KERNEL);
 	if (tape == NULL) {
-		printk(KERN_ERR "ide-tape: %s: Can't allocate a tape structure\n", drive->name);
+		printk(KERN_ERR "ide-tape: %s: Can't allocate a tape struct\n",
+				drive->name);
 		goto failed;
 	}
 
@@ -3677,7 +3811,7 @@ failed:
 	return -ENODEV;
 }
 
-static void __exit idetape_exit (void)
+static void __exit idetape_exit(void)
 {
 	driver_unregister(&idetape_driver.gen_driver);
 	class_destroy(idetape_sysfs_class);
@@ -3696,7 +3830,8 @@ static int __init idetape_init(void)
 	}
 
 	if (register_chrdev(IDETAPE_MAJOR, "ht", &idetape_fops)) {
-		printk(KERN_ERR "ide-tape: Failed to register character device interface\n");
+		printk(KERN_ERR "ide-tape: Failed to register chrdev"
+				" interface\n");
 		error = -EBUSY;
 		goto out_free_class;
 	}
-- 
1.5.3.7


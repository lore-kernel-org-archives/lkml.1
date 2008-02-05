Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYBEBRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYBEBRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbYBEBPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:15:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:51905 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510AbYBEBPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:15:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=AjRZXTHEXfwIK0dX0BDpstVKgZluaT+mk0TFCGR/broH8i2TLi3HtKG70xS1eR7YGp8Awb3+4AlQ6GyBbWYyueg2wzHFy5b1cYNbGpn8YenDteBqI+wH07DsjHl8NJDH+zNOX96ALzDUkhGeCVfedWWv5YmX5DCnkn/w+OdB6cM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 20/22] ide-tape: cleanup the remaining codestyle issues
Date: Tue, 5 Feb 2008 02:27:44 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <1202132440-26648-21-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1202132440-26648-21-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802050227.44357.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2008, Borislav Petkov wrote:
> ... thus decreasing checkpatch.pl errors to 0.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

I did a couple of changes while merging the patch...
(I hope that I didn't break something in the process :)

From: Borislav Petkov <petkovbb@googlemail.com>
Subject: [PATCH 20/22] ide-tape: cleanup the remaining codestyle issues

... thus decreasing checkpatch.pl errors to 0.

Bart:
- remove needless function prototypes while at it
- remove needless parentheses while at it
- add missing KERN_ level to ide_tape_probe()
- other minor fixups

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |  830 ++++++++++++++++++++++++++++---------------------
 1 file changed, 479 insertions(+), 351 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -506,7 +506,7 @@ enum {
  * The variables below are used for the character device interface. Additional
  * state variables are defined in our ide_drive_t structure.
  */
-static struct ide_tape_obj * idetape_devs[MAX_HWIFS * MAX_DRIVES];
+static struct ide_tape_obj *idetape_devs[MAX_HWIFS * MAX_DRIVES];
 
 #define ide_tape_f(file) ((file)->private_data)
 
@@ -522,20 +522,18 @@ static struct ide_tape_obj *ide_tape_chr
 	return tape;
 }
 
-static int idetape_chrdev_release (struct inode *inode, struct file *filp);
-static void idetape_write_release (ide_drive_t *drive, unsigned int minor);
-
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
+				  unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
@@ -547,8 +545,11 @@ static void idetape_input_buffers (ide_d
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
@@ -560,15 +561,16 @@ static void idetape_input_buffers (ide_d
 	pc->bh = bh;
 }
 
-static void idetape_output_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigned int bcount)
+static void idetape_output_buffers(ide_drive_t *drive, idetape_pc_t *pc,
+				   unsigned int bcount)
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
@@ -577,7 +579,8 @@ static void idetape_output_buffers (ide_
 		pc->b_data += count;
 		pc->b_count -= count;
 		if (!pc->b_count) {
-			pc->bh = bh = bh->b_reqnext;
+			bh = bh->b_reqnext;
+			pc->bh = bh;
 			if (bh) {
 				pc->b_data = bh->b_data;
 				pc->b_count = atomic_read(&bh->b_count);
@@ -586,7 +589,7 @@ static void idetape_output_buffers (ide_
 	}
 }
 
-static void idetape_update_buffers (idetape_pc_t *pc)
+static void idetape_update_buffers(idetape_pc_t *pc)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
@@ -596,8 +599,8 @@ static void idetape_update_buffers (idet
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
@@ -615,14 +618,14 @@ static void idetape_update_buffers (idet
  *	driver. A storage space for a maximum of IDETAPE_PC_STACK packet
  *	commands is allocated at initialization time.
  */
-static idetape_pc_t *idetape_next_pc_storage (ide_drive_t *drive)
+static idetape_pc_t *idetape_next_pc_storage(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
 	debug_log(DBG_PCRQ_STACK, "pc_stack_index=%d\n", tape->pc_stack_index);
 
 	if (tape->pc_stack_index == IDETAPE_PC_STACK)
-		tape->pc_stack_index=0;
+		tape->pc_stack_index = 0;
 	return (&tape->pc_stack[tape->pc_stack_index++]);
 }
 
@@ -631,26 +634,26 @@ static idetape_pc_t *idetape_next_pc_sto
  *	Since we queue packet commands in the request queue, we need to
  *	allocate a request, along with the allocation of a packet command.
  */
- 
+
 /**************************************************************
  *                                                            *
  *  This should get fixed to use kmalloc(.., GFP_ATOMIC)      *
  *  followed later on by kfree().   -ml                       *
  *                                                            *
  **************************************************************/
- 
-static struct request *idetape_next_rq_storage (ide_drive_t *drive)
+
+static struct request *idetape_next_rq_storage(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
 	debug_log(DBG_PCRQ_STACK, "rq_stack_index=%d\n", tape->rq_stack_index);
 
 	if (tape->rq_stack_index == IDETAPE_PC_STACK)
-		tape->rq_stack_index=0;
+		tape->rq_stack_index = 0;
 	return (&tape->rq_stack[tape->rq_stack_index++]);
 }
 
-static void idetape_init_pc (idetape_pc_t *pc)
+static void idetape_init_pc(idetape_pc_t *pc)
 {
 	memset(pc->c, 0, 12);
 	pc->retries = 0;
@@ -746,7 +749,7 @@ static void idetape_activate_next_stage(
 }
 
 /* Free a stage along with its related buffers completely. */
-static void __idetape_kfree_stage (idetape_stage_t *stage)
+static void __idetape_kfree_stage(idetape_stage_t *stage)
 {
 	struct idetape_bh *prev_bh, *bh = stage->bh;
 	int size;
@@ -767,7 +770,7 @@ static void __idetape_kfree_stage (ideta
 	kfree(stage);
 }
 
-static void idetape_kfree_stage (idetape_tape_t *tape, idetape_stage_t *stage)
+static void idetape_kfree_stage(idetape_tape_t *tape, idetape_stage_t *stage)
 {
 	__idetape_kfree_stage(stage);
 }
@@ -776,7 +779,7 @@ static void idetape_kfree_stage (idetape
  * Remove tape->first_stage from the pipeline. The caller should avoid race
  * conditions.
  */
-static void idetape_remove_stage_head (ide_drive_t *drive)
+static void idetape_remove_stage_head(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *stage;
@@ -799,9 +802,11 @@ static void idetape_remove_stage_head (i
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
 
@@ -847,9 +852,9 @@ static int idetape_end_request(ide_drive
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
@@ -873,7 +878,8 @@ static int idetape_end_request(ide_drive
 			if (error) {
 				set_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
 				if (error == IDETAPE_ERROR_EOD)
-					idetape_abort_pipeline(drive, active_stage);
+					idetape_abort_pipeline(drive,
+								active_stage);
 			}
 		} else if (rq->cmd[0] & REQ_IDETAPE_READ) {
 			if (error == IDETAPE_ERROR_EOD) {
@@ -906,9 +912,6 @@ static int idetape_end_request(ide_drive
 		}
 	}
 	ide_end_drive_cmd(drive, 0, 0);
-//	blkdev_dequeue_request(rq);
-//	drive->rq = NULL;
-//	end_that_request_last(rq);
 
 	if (remove_stage)
 		idetape_remove_stage_head(drive);
@@ -918,7 +921,7 @@ static int idetape_end_request(ide_drive
 	return 0;
 }
 
-static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_request_sense_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -928,15 +931,16 @@ static ide_startstop_t idetape_request_s
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
@@ -965,7 +969,8 @@ static void idetape_init_rq(struct reque
  * handling functions should queue request to the lower level part and wait for
  * their completion using idetape_queue_pc_tail or idetape_queue_rw_tail.
  */
-static void idetape_queue_pc_head (ide_drive_t *drive, idetape_pc_t *pc,struct request *rq)
+static void idetape_queue_pc_head(ide_drive_t *drive, idetape_pc_t *pc,
+				  struct request *rq)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 
@@ -999,7 +1004,7 @@ static ide_startstop_t idetape_retry_pc 
  * Postpone the current request so that ide.c will be able to service requests
  * from another device on the same hwgroup while we are polling for DSC.
  */
-static void idetape_postpone_request (ide_drive_t *drive)
+static void idetape_postpone_request(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -1027,7 +1032,7 @@ static ide_startstop_t idetape_pc_intr(i
 	idetape_io_buf *iobuf;
 	unsigned int temp;
 #if SIMULATE_ERRORS
-	static int error_sim_count = 0;
+	static int error_sim_count;
 #endif
 	u16 bcount;
 	u8 stat, ireason;
@@ -1228,8 +1233,9 @@ static ide_startstop_t idetape_transfer_
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
@@ -1336,7 +1342,7 @@ static ide_startstop_t idetape_issue_pc(
 	}
 }
 
-static ide_startstop_t idetape_pc_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_pc_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -1347,7 +1353,7 @@ static ide_startstop_t idetape_pc_callba
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
-static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
+static void idetape_create_mode_sense_cmd(idetape_pc_t *pc, u8 page_code)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = MODE_SENSE;
@@ -1378,39 +1384,56 @@ static void idetape_calculate_speeds(ide
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
@@ -1420,7 +1443,7 @@ static void idetape_calculate_speeds(ide
 	tape->max_insert_speed = max(tape->max_insert_speed, 500);
 }
 
-static ide_startstop_t idetape_media_access_finished (ide_drive_t *drive)
+static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc = tape->pc;
@@ -1447,7 +1470,7 @@ static ide_startstop_t idetape_media_acc
 	return pc->callback(drive);
 }
 
-static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
@@ -1463,9 +1486,11 @@ static ide_startstop_t idetape_rw_callba
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
@@ -1481,7 +1506,8 @@ static ide_startstop_t idetape_rw_callba
 	return ide_stopped;
 }
 
-static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
+static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+		unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_6;
@@ -1520,7 +1546,8 @@ static void idetape_create_read_buffer_c
 	pc->buffer_size = size;
 }
 
-static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
+static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+		unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_6;
@@ -1559,10 +1586,9 @@ static ide_startstop_t idetape_do_reques
 	}
 
 	/* Retry a failed packet command */
-	if (tape->failed_pc != NULL &&
-	    tape->pc->c[0] == REQUEST_SENSE) {
+	if (tape->failed_pc && tape->pc->c[0] == REQUEST_SENSE)
 		return idetape_issue_pc(drive, tape->failed_pc);
-	}
+
 	if (postponed_rq != NULL)
 		if (rq != postponed_rq) {
 			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
@@ -1588,7 +1614,8 @@ static ide_startstop_t idetape_do_reques
 	}
 
 	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ / (jiffies - tape->insert_time);
+		tape->insert_speed = tape->insert_size / 1024 * HZ /
+					(jiffies - tape->insert_time);
 	idetape_calculate_speeds(drive);
 	if (!test_and_clear_bit(IDETAPE_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
@@ -1605,7 +1632,9 @@ static ide_startstop_t idetape_do_reques
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
@@ -1614,14 +1643,16 @@ static ide_startstop_t idetape_do_reques
 		tape->buffer_head++;
 		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
-		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
+		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors,
+					(struct idetape_bh *)rq->special);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 		tape->buffer_head++;
 		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
-		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
+		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors,
+					 (struct idetape_bh *)rq->special);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_READ_BUFFER) {
@@ -1647,7 +1678,7 @@ out:
 }
 
 /* Pipeline related functions */
-static inline int idetape_pipeline_active (idetape_tape_t *tape)
+static inline int idetape_pipeline_active(idetape_tape_t *tape)
 {
 	int rc1, rc2;
 
@@ -1668,22 +1699,26 @@ static inline int idetape_pipeline_activ
  * Pipeline stages are optional and are used to increase performance. If we
  * can't allocate them, we'll manage without them.
  */
-static idetape_stage_t *__idetape_kmalloc_stage (idetape_tape_t *tape, int full, int clear)
+static idetape_stage_t *__idetape_kmalloc_stage(idetape_tape_t *tape, int full,
+						int clear)
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
@@ -1691,7 +1726,8 @@ static idetape_stage_t *__idetape_kmallo
 	atomic_set(&bh->b_count, full ? bh->b_size : 0);
 
 	while (--pages) {
-		if ((b_data = (char *) __get_free_page (GFP_KERNEL)) == NULL)
+		b_data = (char *) __get_free_page(GFP_KERNEL);
+		if (!b_data)
 			goto abort;
 		if (clear)
 			memset(b_data, 0, PAGE_SIZE);
@@ -1709,7 +1745,8 @@ static idetape_stage_t *__idetape_kmallo
 			continue;
 		}
 		prev_bh = bh;
-		if ((bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL)) == NULL) {
+		bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+		if (!bh) {
 			free_page((unsigned long) b_data);
 			goto abort;
 		}
@@ -1728,7 +1765,7 @@ abort:
 	return NULL;
 }
 
-static idetape_stage_t *idetape_kmalloc_stage (idetape_tape_t *tape)
+static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
 {
 	idetape_stage_t *cache_stage = tape->cache_stage;
 
@@ -1743,7 +1780,8 @@ static idetape_stage_t *idetape_kmalloc_
 	return __idetape_kmalloc_stage(tape, 0, 0);
 }
 
-static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *stage, const char __user *buf, int n)
+static int idetape_copy_stage_from_user(idetape_tape_t *tape,
+		idetape_stage_t *stage, const char __user *buf, int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -1751,12 +1789,15 @@ static int idetape_copy_stage_from_user 
 
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
@@ -1771,7 +1812,8 @@ static int idetape_copy_stage_from_user 
 	return ret;
 }
 
-static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, idetape_stage_t *stage, int n)
+static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
+		idetape_stage_t *stage, int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -1779,8 +1821,8 @@ static int idetape_copy_stage_to_user (i
 
 	while (n) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_copy_stage_to_user\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return 1;
 		}
 		count = min(tape->b_count, n);
@@ -1791,7 +1833,8 @@ static int idetape_copy_stage_to_user (i
 		tape->b_count -= count;
 		buf += count;
 		if (!tape->b_count) {
-			tape->bh = bh = bh->b_reqnext;
+			bh = bh->b_reqnext;
+			tape->bh = bh;
 			if (bh) {
 				tape->b_data = bh->b_data;
 				tape->b_count = atomic_read(&bh->b_count);
@@ -1801,10 +1844,10 @@ static int idetape_copy_stage_to_user (i
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
@@ -1814,7 +1857,7 @@ static void idetape_init_merge_stage (id
 	}
 }
 
-static void idetape_switch_buffers (idetape_tape_t *tape, idetape_stage_t *stage)
+static void idetape_switch_buffers(idetape_tape_t *tape, idetape_stage_t *stage)
 {
 	struct idetape_bh *tmp;
 
@@ -1825,7 +1868,7 @@ static void idetape_switch_buffers (idet
 }
 
 /* Add a new stage at the end of the pipeline. */
-static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
+static void idetape_add_stage_tail(ide_drive_t *drive, idetape_stage_t *stage)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -1835,9 +1878,10 @@ static void idetape_add_stage_tail (ide_
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
@@ -1850,13 +1894,14 @@ static void idetape_add_stage_tail (ide_
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
@@ -1905,7 +1950,8 @@ static ide_startstop_t idetape_read_posi
  * Write a filemark if write_filemark=1. Flush the device buffers without
  * writing a filemark otherwise.
  */
-static void idetape_create_write_filemark_cmd (ide_drive_t *drive, idetape_pc_t *pc,int write_filemark)
+static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
+		idetape_pc_t *pc, int write_filemark)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_FILEMARKS;
@@ -1934,7 +1980,7 @@ static void idetape_create_test_unit_rea
  * to the request list without waiting for it to be serviced! In that case, we
  * usually use idetape_queue_pc_head().
  */
-static int __idetape_queue_pc_tail (ide_drive_t *drive, idetape_pc_t *pc)
+static int __idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 	struct request rq;
@@ -1945,7 +1991,8 @@ static int __idetape_queue_pc_tail (ide_
 	return ide_do_drive_cmd(drive, &rq, ide_wait);
 }
 
-static void idetape_create_load_unload_cmd (ide_drive_t *drive, idetape_pc_t *pc,int cmd)
+static void idetape_create_load_unload_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+		int cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = START_STOP;
@@ -1972,7 +2019,8 @@ static int idetape_wait_ready(ide_drive_
 			/* no media */
 			if (load_attempted)
 				return -ENOMEDIUM;
-			idetape_create_load_unload_cmd(drive, &pc, IDETAPE_LU_LOAD_MASK);
+			idetape_create_load_unload_cmd(drive, &pc,
+							IDETAPE_LU_LOAD_MASK);
 			__idetape_queue_pc_tail(drive, &pc);
 			load_attempted = 1;
 		/* not about to be ready */
@@ -1984,24 +2032,25 @@ static int idetape_wait_ready(ide_drive_
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
@@ -2009,7 +2058,7 @@ static void idetape_create_read_position
 	pc->callback = &idetape_read_position_callback;
 }
 
-static int idetape_read_position (ide_drive_t *drive)
+static int idetape_read_position(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
@@ -2024,7 +2073,8 @@ static int idetape_read_position (ide_dr
 	return position;
 }
 
-static void idetape_create_locate_cmd (ide_drive_t *drive, idetape_pc_t *pc, unsigned int block, u8 partition, int skip)
+static void idetape_create_locate_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+		unsigned int block, u8 partition, int skip)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = POSITION_TO_ELEMENT;
@@ -2035,7 +2085,8 @@ static void idetape_create_locate_cmd (i
 	pc->callback = &idetape_pc_callback;
 }
 
-static int idetape_create_prevent_cmd (ide_drive_t *drive, idetape_pc_t *pc, int prevent)
+static int idetape_create_prevent_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+				      int prevent)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -2050,7 +2101,7 @@ static int idetape_create_prevent_cmd (i
 	return 1;
 }
 
-static int __idetape_discard_read_pipeline (ide_drive_t *drive)
+static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2086,7 +2137,7 @@ static int __idetape_discard_read_pipeli
 	while (tape->first_stage != NULL) {
 		struct request *rq_ptr = &tape->first_stage->rq;
 
-		cnt += rq_ptr->nr_sectors - rq_ptr->current_nr_sectors; 
+		cnt += rq_ptr->nr_sectors - rq_ptr->current_nr_sectors;
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
 			++cnt;
 		idetape_remove_stage_head(drive);
@@ -2102,7 +2153,8 @@ static int __idetape_discard_read_pipeli
  * all higher level operations, we queue the commands at the tail of the request
  * queue and wait for their completion.
  */
-static int idetape_position_tape (ide_drive_t *drive, unsigned int block, u8 partition, int skip)
+static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
+		u8 partition, int skip)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int retval;
@@ -2120,7 +2172,8 @@ static int idetape_position_tape (ide_dr
 	return (idetape_queue_pc_tail(drive, &pc));
 }
 
-static void idetape_discard_read_pipeline (ide_drive_t *drive, int restore_position)
+static void idetape_discard_read_pipeline(ide_drive_t *drive,
+					  int restore_position)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int cnt;
@@ -2131,7 +2184,8 @@ static void idetape_discard_read_pipelin
 		position = idetape_read_position(drive);
 		seek = position > cnt ? position - cnt : 0;
 		if (idetape_position_tape(drive, seek, 0, 0)) {
-			printk(KERN_INFO "ide-tape: %s: position_tape failed in discard_pipeline()\n", tape->name);
+			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
+					 " discard_pipeline()\n", tape->name);
 			return;
 		}
 	}
@@ -2141,7 +2195,8 @@ static void idetape_discard_read_pipelin
  * Generate a read/write request for the block device interface and wait for it
  * to be serviced.
  */
-static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct idetape_bh *bh)
+static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
+				 struct idetape_bh *bh)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request rq;
@@ -2158,7 +2213,8 @@ static int idetape_queue_rw_tail(ide_dri
 	rq.rq_disk = tape->disk;
 	rq.special = (void *)bh;
 	rq.sector = tape->first_frame;
-	rq.nr_sectors = rq.current_nr_sectors = blocks;
+	rq.nr_sectors		= blocks;
+	rq.current_nr_sectors	= blocks;
 	(void) ide_do_drive_cmd(drive, &rq, ide_wait);
 
 	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
@@ -2185,15 +2241,16 @@ static void idetape_plug_pipeline(ide_dr
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
@@ -2201,7 +2258,7 @@ static void idetape_create_rewind_cmd (i
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_create_erase_cmd (idetape_pc_t *pc)
+static void idetape_create_erase_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = ERASE;
@@ -2210,7 +2267,7 @@ static void idetape_create_erase_cmd (id
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_create_space_cmd (idetape_pc_t *pc,int count, u8 cmd)
+static void idetape_create_space_cmd(idetape_pc_t *pc, int count, u8 cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = SPACE;
@@ -2220,7 +2277,7 @@ static void idetape_create_space_cmd (id
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_wait_first_stage (ide_drive_t *drive)
+static void idetape_wait_first_stage(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2244,7 +2301,7 @@ static void idetape_wait_first_stage (id
  * 3. If we still can't allocate a stage, fallback to non-pipelined operation
  * mode for this request.
  */
-static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
+static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *new_stage;
@@ -2268,14 +2325,16 @@ static int idetape_add_chrdev_write_requ
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
@@ -2311,7 +2370,7 @@ static int idetape_add_chrdev_write_requ
  * Wait until all pending pipeline requests are serviced. Typically called on
  * device close.
  */
-static void idetape_wait_for_pipeline (ide_drive_t *drive)
+static void idetape_wait_for_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2325,14 +2384,15 @@ static void idetape_wait_for_pipeline (i
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
@@ -2355,12 +2415,14 @@ static void idetape_empty_write_pipeline
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
@@ -2396,18 +2458,22 @@ static void idetape_empty_write_pipeline
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
@@ -2425,10 +2491,12 @@ static int idetape_init_read(ide_drive_t
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
 
@@ -2439,7 +2507,9 @@ static int idetape_init_read(ide_drive_t
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
@@ -2452,7 +2522,8 @@ static int idetape_init_read(ide_drive_t
 		idetape_restart_speed_control(drive);
 	idetape_init_rq(&rq, REQ_IDETAPE_READ);
 	rq.sector = tape->first_frame;
-	rq.nr_sectors = rq.current_nr_sectors = blocks;
+	rq.nr_sectors = blocks;
+	rq.current_nr_sectors = blocks;
 	if (!test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags) &&
 	    tape->nr_stages < max_stages) {
 		new_stage = idetape_kmalloc_stage(tape);
@@ -2480,7 +2551,7 @@ static int idetape_init_read(ide_drive_t
  * Called from idetape_chrdev_read() to service a character device read request
  * and add read-ahead requests to our pipeline.
  */
-static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
+static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2505,8 +2576,8 @@ static int idetape_add_chrdev_read_reque
 	rq_ptr = &tape->first_stage->rq;
 	bytes_read = tape->blk_size * (rq_ptr->nr_sectors -
 					rq_ptr->current_nr_sectors);
-	rq_ptr->nr_sectors = rq_ptr->current_nr_sectors = 0;
-
+	rq_ptr->nr_sectors = 0;
+	rq_ptr->current_nr_sectors = 0;
 
 	if (rq_ptr->errors == IDETAPE_ERROR_EOD)
 		return 0;
@@ -2521,13 +2592,14 @@ static int idetape_add_chrdev_read_reque
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
@@ -2541,16 +2613,18 @@ static void idetape_pad_zeros (ide_drive
 		bcount -= count;
 		blocks = count / tape->blk_size;
 		while (count) {
-			atomic_set(&bh->b_count, min(count, (unsigned int)bh->b_size));
+			atomic_set(&bh->b_count,
+				   min(count, (unsigned int)bh->b_size));
 			memset(bh->b_data, 0, atomic_read(&bh->b_count));
 			count -= atomic_read(&bh->b_count);
 			bh = bh->b_reqnext;
 		}
-		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks, tape->merge_stage->bh);
+		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks,
+				      tape->merge_stage->bh);
 	}
 }
 
-static int idetape_pipeline_size (ide_drive_t *drive)
+static int idetape_pipeline_size(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *stage;
@@ -2575,7 +2649,7 @@ static int idetape_pipeline_size (ide_dr
  * Rewinds the tape to the Beginning Of the current Partition (BOP). We
  * currently support only one partition.
  */
-static int idetape_rewind_tape (ide_drive_t *drive)
+static int idetape_rewind_tape(ide_drive_t *drive)
 {
 	int retval;
 	idetape_pc_t pc;
@@ -2597,7 +2671,8 @@ static int idetape_rewind_tape (ide_driv
 }
 
 /* mtio.h compatible commands should be issued to the chrdev interface. */
-static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned long arg)
+static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
+				unsigned long arg)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	void __user *argp = (void __user *)arg;
@@ -2611,20 +2686,20 @@ static int idetape_blkdev_ioctl(ide_driv
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
@@ -2636,12 +2711,13 @@ static int idetape_blkdev_ioctl(ide_driv
  * support MTFSFM when the filemark is in our internal pipeline even if the tape
  * doesn't support spacing over filemarks in the reverse direction.
  */
-static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_count)
+static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
+					int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
 	unsigned long flags;
-	int retval,count=0;
+	int retval, count = 0;
 	int sprev = !!(tape->caps[4] & 0x20);
 
 	if (mt_count == 0)
@@ -2649,7 +2725,7 @@ static int idetape_space_over_filemarks 
 	if (MTBSF == mt_op || MTBSFM == mt_op) {
 		if (!sprev)
 			return -EIO;
-		mt_count = - mt_count;
+		mt_count = -mt_count;
 	}
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
@@ -2682,7 +2758,8 @@ static int idetape_space_over_filemarks 
 				tape->next_stage = tape->first_stage->next;
 			} else
 				spin_unlock_irqrestore(&tape->lock, flags);
-			if (tape->first_stage->rq.errors == IDETAPE_ERROR_FILEMARK)
+			if (tape->first_stage->rq.errors ==
+					IDETAPE_ERROR_FILEMARK)
 				++count;
 			idetape_remove_stage_head(drive);
 		}
@@ -2694,25 +2771,28 @@ static int idetape_space_over_filemarks 
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
-			return (-EIO);
+	case MTFSF:
+	case MTBSF:
+		idetape_create_space_cmd(&pc, mt_count - count,
+					 IDETAPE_SPACE_OVER_FILEMARK);
+		return idetape_queue_pc_tail(drive, &pc);
+	case MTFSFM:
+	case MTBSFM:
+		if (!sprev)
+			return -EIO;
+		retval = idetape_space_over_filemarks(drive, MTFSF,
+						      mt_count - count);
+		if (retval)
+			return retval;
+		count = (MTBSFM == mt_op ? 1 : -1);
+		return idetape_space_over_filemarks(drive, MTFSF, count);
+	default:
+		printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",
+				mt_op);
+		return -EIO;
 	}
 }
 
-
 /*
  * Our character device read / write functions.
  *
@@ -2728,12 +2808,12 @@ static int idetape_space_over_filemarks 
  * (slightly) increased driver overhead, but will no longer hit performance.
  * This is not applicable to Onstream.
  */
-static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
-				    size_t count, loff_t *ppos)
+static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
+				   size_t count, loff_t *ppos)
 {
 	struct ide_tape_obj *tape = ide_tape_f(file);
 	ide_drive_t *drive = tape->drive;
-	ssize_t bytes_read,temp, actually_read = 0, rc;
+	ssize_t bytes_read, temp, actually_read = 0, rc;
 	ssize_t ret = 0;
 	u16 ctl = *(u16 *)&tape->caps[12];
 
@@ -2751,8 +2831,10 @@ static ssize_t idetape_chrdev_read (stru
 	if (count == 0)
 		return (0);
 	if (tape->merge_stage_size) {
-		actually_read = min((unsigned int)(tape->merge_stage_size), (unsigned int)count);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, actually_read))
+		actually_read = min((unsigned int)(tape->merge_stage_size),
+				    (unsigned int)count);
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+					       actually_read))
 			ret = -EFAULT;
 		buf += actually_read;
 		tape->merge_stage_size -= actually_read;
@@ -2762,7 +2844,8 @@ static ssize_t idetape_chrdev_read (stru
 		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, bytes_read))
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+					       bytes_read))
 			ret = -EFAULT;
 		buf += bytes_read;
 		count -= bytes_read;
@@ -2773,7 +2856,8 @@ static ssize_t idetape_chrdev_read (stru
 		if (bytes_read <= 0)
 			goto finish;
 		temp = min((unsigned long)count, (unsigned long)bytes_read);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, temp))
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+					       temp))
 			ret = -EFAULT;
 		actually_read += temp;
 		tape->merge_stage_size = bytes_read-temp;
@@ -2786,10 +2870,10 @@ finish:
 		return 0;
 	}
 
-	return (ret) ? ret : actually_read;
+	return ret ? ret : actually_read;
 }
 
-static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
+static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 				     size_t count, loff_t *ppos)
 {
 	struct ide_tape_obj *tape = ide_tape_f(file);
@@ -2813,7 +2897,8 @@ static ssize_t idetape_chrdev_write (str
 				"should be 0 now\n");
 			tape->merge_stage_size = 0;
 		}
-		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
+		tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0);
+		if (!tape->merge_stage)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_WRITE;
 		idetape_init_merge_stage(tape);
@@ -2825,7 +2910,9 @@ static ssize_t idetape_chrdev_write (str
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
@@ -2840,11 +2927,14 @@ static ssize_t idetape_chrdev_write (str
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
+						 actually_written))
 				ret = -EFAULT;
 		buf += actually_written;
 		tape->merge_stage_size += actually_written;
@@ -2860,7 +2950,8 @@ static ssize_t idetape_chrdev_write (str
 	}
 	while (count >= tape->stage_size) {
 		ssize_t retval;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, tape->stage_size))
+		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
+						 tape->stage_size))
 			ret = -EFAULT;
 		buf += tape->stage_size;
 		count -= tape->stage_size;
@@ -2871,14 +2962,15 @@ static ssize_t idetape_chrdev_write (str
 	}
 	if (count) {
 		actually_written += count;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, count))
+		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
+						 count))
 			ret = -EFAULT;
 		tape->merge_stage_size += count;
 	}
-	return (ret) ? ret : actually_written;
+	return ret ? ret : actually_written;
 }
 
-static int idetape_write_filemark (ide_drive_t *drive)
+static int idetape_write_filemark(ide_drive_t *drive)
 {
 	idetape_pc_t pc;
 
@@ -2909,110 +3001,117 @@ static int idetape_mtioctop(ide_drive_t 
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
-	int i,retval;
+	int i, retval;
 
 	debug_log(DBG_ERR, "Handling MTIOCTOP ioctl: mt_op=%d, mt_count=%d\n",
 			mt_op, mt_count);
+
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
+			return 0;
+		return idetape_space_over_filemarks(drive, mt_op, mt_count);
+	default:
+		break;
 	}
+
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
+		return 0;
+	case MTREW:
+		idetape_discard_read_pipeline(drive, 0);
+		if (idetape_rewind_tape(drive))
+			return -EIO;
+		return 0;
+	case MTLOAD:
+		idetape_discard_read_pipeline(drive, 0);
+		idetape_create_load_unload_cmd(drive, &pc,
+					       IDETAPE_LU_LOAD_MASK);
+		return idetape_queue_pc_tail(drive, &pc);
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
+					      !IDETAPE_LU_LOAD_MASK);
+		retval = idetape_queue_pc_tail(drive, &pc);
+		if (!retval)
+			clear_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
+		return retval;
+	case MTNOP:
+		idetape_discard_read_pipeline(drive, 0);
+		return idetape_flush_tape_buffers(drive);
+	case MTRETEN:
+		idetape_discard_read_pipeline(drive, 0);
+		idetape_create_load_unload_cmd(drive, &pc,
+			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
+		return idetape_queue_pc_tail(drive, &pc);
+	case MTEOM:
+		idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
+		return idetape_queue_pc_tail(drive, &pc);
+	case MTERASE:
+		(void)idetape_rewind_tape(drive);
+		idetape_create_erase_cmd(&pc);
+		return idetape_queue_pc_tail(drive, &pc);
+	case MTSETBLK:
+		if (mt_count) {
+			if (mt_count < tape->blk_size ||
+			    mt_count % tape->blk_size)
 				return -EIO;
+			tape->user_bs_factor = mt_count / tape->blk_size;
+			clear_bit(IDETAPE_DETECT_BS, &tape->flags);
+		} else
+			set_bit(IDETAPE_DETECT_BS, &tape->flags);
+		return 0;
+	case MTSEEK:
+		idetape_discard_read_pipeline(drive, 0);
+		return idetape_position_tape(drive,
+			mt_count * tape->user_bs_factor, tape->partition, 0);
+	case MTSETPART:
+		idetape_discard_read_pipeline(drive, 0);
+		return idetape_position_tape(drive, 0, mt_count, 0);
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
-				clear_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
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
-				clear_bit(IDETAPE_DETECT_BS, &tape->flags);
-			} else
-				set_bit(IDETAPE_DETECT_BS, &tape->flags);
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
+		printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",
+				mt_op);
+		return -EIO;
 	}
 }
 
@@ -3042,37 +3141,38 @@ static int idetape_chrdev_ioctl(struct i
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
+	case MTIOCTOP:
+		if (copy_from_user(&mtop, argp, sizeof(struct mtop)))
+			return -EFAULT;
+		return idetape_mtioctop(drive, mtop.mt_op, mtop.mt_count);
+	case MTIOCGET:
+		memset(&mtget, 0, sizeof(struct mtget));
+		mtget.mt_type = MT_ISSCSI2;
+		mtget.mt_blkno = position / tape->user_bs_factor - block_offset;
+		mtget.mt_dsreg =
+			((tape->blk_size * tape->user_bs_factor)
+			 << MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK;
 
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
 
@@ -3101,7 +3201,7 @@ static void ide_tape_get_bsize_from_bdes
 	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
 }
 
-static int idetape_chrdev_open (struct inode *inode, struct file *filp)
+static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 {
 	unsigned int minor = iminor(inode), i = minor & ~0xc0;
 	ide_drive_t *drive;
@@ -3185,7 +3285,7 @@ out_put_tape:
 	return retval;
 }
 
-static void idetape_write_release (ide_drive_t *drive, unsigned int minor)
+static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -3202,7 +3302,7 @@ static void idetape_write_release (ide_d
 	idetape_flush_tape_buffers(drive);
 }
 
-static int idetape_chrdev_release (struct inode *inode, struct file *filp)
+static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 {
 	struct ide_tape_obj *tape = ide_tape_f(filp);
 	ide_drive_t *drive = tape->drive;
@@ -3309,7 +3409,7 @@ static void idetape_get_inquiry_results(
  * Ask the tape about its various parameters. In particular, we will adjust our
  * data transfer buffer	size to the recommended value as returned by the tape.
  */
-static void idetape_get_mode_sense_results (ide_drive_t *drive)
+static void idetape_get_mode_sense_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
@@ -3356,17 +3456,24 @@ static void idetape_get_mode_sense_resul
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
@@ -3374,10 +3481,16 @@ static void idetape_add_settings (ide_dr
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
@@ -3396,7 +3509,7 @@ static inline void idetape_add_settings(
  * Note that at this point ide.c already assigned us an irq, so that we can
  * queue requests here and wait for their completion.
  */
-static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
+static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 {
 	unsigned long t1, tmid, tn, t;
 	int speed;
@@ -3429,7 +3542,9 @@ static void idetape_setup (ide_drive_t *
 	if (((gcw[0] & 0x60) >> 5) == 1)
 		set_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags);
 
-	tape->min_pipeline = tape->max_pipeline = tape->max_stages = 10;
+	tape->min_pipeline = 10;
+	tape->max_pipeline = 10;
+	tape->max_stages   = 10;
 
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
@@ -3455,13 +3570,20 @@ static void idetape_setup (ide_drive_t *
 
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
@@ -3513,7 +3635,8 @@ static void ide_tape_release(struct kref
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
 	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor));
-	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor + 128));
+	device_destroy(idetape_sysfs_class,
+			MKDEV(IDETAPE_MAJOR, tape->minor + 128));
 	idetape_devs[tape->minor] = NULL;
 	g->private_data = NULL;
 	put_disk(g);
@@ -3577,7 +3700,8 @@ static int idetape_open(struct inode *in
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_tape_obj *tape;
 
-	if (!(tape = ide_tape_get(disk)))
+	tape = ide_tape_get(disk);
+	if (!tape)
 		return -ENXIO;
 
 	return 0;
@@ -3624,17 +3748,20 @@ static int ide_tape_probe(ide_drive_t *d
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
+		printk(KERN_INFO "ide-tape: passing drive %s to ide-scsi"
+				 " emulation.\n", drive->name);
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
 
@@ -3680,7 +3807,7 @@ failed:
 	return -ENODEV;
 }
 
-static void __exit idetape_exit (void)
+static void __exit idetape_exit(void)
 {
 	driver_unregister(&idetape_driver.gen_driver);
 	class_destroy(idetape_sysfs_class);
@@ -3699,7 +3826,8 @@ static int __init idetape_init(void)
 	}
 
 	if (register_chrdev(IDETAPE_MAJOR, "ht", &idetape_fops)) {
-		printk(KERN_ERR "ide-tape: Failed to register character device interface\n");
+		printk(KERN_ERR "ide-tape: Failed to register chrdev"
+				" interface\n");
 		error = -EBUSY;
 		goto out_free_class;
 	}

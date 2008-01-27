Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbYA0J54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbYA0J54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbYA0Jty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:54 -0500
Received: from [212.23.103.76] ([212.23.103.76]:59097 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756330AbYA0Jtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:43 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 23/32] ide-tape: struct idetape_tape_t: shorten member names
Date: Sun, 27 Jan 2008 10:48:11 +0100
Message-Id: <1201427300-3954-18-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Some member names are self-explanatory, so remove their respective
comments. Also, explain the exact purpose of struct members in comments
in the struct definition instead of using excessively long member names
thus replacing then with a shorter, more handy version.

Finally, remove unused members:
- last_frame_position: only being written to once
- firmware_revision: used once, remove from struct idetape_tape_t and deal with
it locally
- firmware_revision_num: only written to once
- tape_still_time_begin: completely unused
- tape_still_time: never written to; remove corresponding code chunk
- uncontrolled_last_pipeline_head: only once written to

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |  673 +++++++++++++++++++++++------------------------
 1 files changed, 329 insertions(+), 344 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 4690f71..31edb0c 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -240,9 +240,9 @@ typedef struct idetape_stage_s {
 } idetape_stage_t;
 
 /*
- *	Most of our global data which we need to save even as we leave the
- *	driver due to an interrupt or a timer event is stored in a variable
- *	of type idetape_tape_t, defined below.
+ * Most of our global data which we need to save even as we leave the driver due
+ * to an interrupt or a timer event is stored in a variable of type
+ * idetape_tape_t, defined below.
  */
 typedef struct ide_tape_obj {
 	ide_drive_t	*drive;
@@ -251,42 +251,41 @@ typedef struct ide_tape_obj {
 	struct kref	kref;
 
 	/*
-	 *	Since a typical character device operation requires more
-	 *	than one packet command, we provide here enough memory
-	 *	for the maximum of interconnected packet commands.
-	 *	The packet commands are stored in the circular array pc_stack.
-	 *	pc_stack_index points to the last used entry, and warps around
-	 *	to the start when we get to the last array entry.
-	 *
-	 *	pc points to the current processed packet command.
-	 *
-	 *	failed_pc points to the last failed packet command, or contains
-	 *	NULL if we do not need to retry any packet command. This is
-	 *	required since an additional packet command is needed before the
-	 *	retry, to get detailed information on what went wrong.
+	 * Since a typical chrdev operation requires more than one packet
+	 * command, we provide here enough memory for the maximum of
+	 * interconnected packet commands. The packet commands are stored in the
+	 * circular array pc_stack. pc_stack_index points to the last used
+	 * entry, and warps around to the start when we get to the last array
+	 * entry.
 	 */
-	/* Current packet command */
+
+	/* current packet command */
 	idetape_pc_t *pc;
-	/* Last failed packet command */
+
+	/*
+	 * the last failed packet command, or NULL if we do not need to retry
+	 * any packet command. This is required since an additional packet
+	 * command is needed before the	retry, to get detailed information on
+	 * what went wrong.
+	 */
 	idetape_pc_t *failed_pc;
-	/* Packet command stack */
+
 	idetape_pc_t pc_stack[IDETAPE_PC_STACK];
 	/* Next free packet command storage space */
-	int pc_stack_index;
+	int pc_stack_idx;
 	struct request rq_stack[IDETAPE_PC_STACK];
 	/* We implement a circular array */
-	int rq_stack_index;
+	int rq_stack_idx;
 
 	/*
-	 *	DSC polling variables.
+	 * DSC polling variables.
 	 *
-	 *	While polling for DSC we use postponed_rq to postpone the
-	 *	current request so that ide.c will be able to service
-	 *	pending requests on the other device. Note that at most
-	 *	we will have only one DSC (usually data transfer) request
-	 *	in the device request queue. Additional requests can be
-	 *	queued in our internal pipeline, but they will be visible
-	 *	to ide.c only one at a time.
+	 * While polling for DSC we use postponed_rq to postpone the current
+	 * request so that ide.c will be able to service pending requests on the
+	 * other device. Note that at most we will have only one DSC (usually
+	 * data transfer) request in the device request queue. Additional
+	 * requests can be queued in our internal pipeline, but they will be
+	 * visible to ide.c only one at a time.
 	 */
 	struct request *postponed_rq;
 	/* The time in which we started polling for DSC */
@@ -294,85 +293,67 @@ typedef struct ide_tape_obj {
 	/* Timer used to poll for dsc */
 	struct timer_list dsc_timer;
 	/* Read/Write dsc polling frequency */
-	unsigned long best_dsc_rw_frequency;
-	/* The current polling frequency */
-	unsigned long dsc_polling_frequency;
-	/* Maximum waiting time */
+	unsigned long best_dsc_rw_freq;
+	unsigned long dsc_poll_freq;
 	unsigned long dsc_timeout;
 
-	/*
-	 *	Read position information
-	 */
+	/* Read position information */
 	u8 partition;
 	/* Current block */
-	unsigned int first_frame_position;
-	unsigned int last_frame_position;
+	unsigned int first_frm_pos;
 	unsigned int blocks_in_buffer;
 
-	/*
-	 *	Last error information
-	 */
+	/* Last error information */
 	u8 sense_key, asc, ascq;
 
-	/*
-	 *	Character device operation
-	 */
+	/* chrdev operation */
 	unsigned int minor;
 	/* device name */
 	char name[4];
-	/* Current character device data transfer direction */
-	idetape_chrdev_dir_t chrdev_direction;
+	/* current chrdev data transfer direction */
+	idetape_chrdev_dir_t chrdev_dir;
 
-	/*
-	 *	Device information
-	 */
-	/* Usually 512 or 1024 bytes */
-	unsigned short tape_block_size;
+	/* tape block size, usually 512 or 1024 bytes */
+	unsigned short blk_sz;
 	int user_bs_factor;
 
 	/* Copy of the tape's Capabilities and Mechanical Page */
 	u8 caps[20];
 
 	/*
-	 *	Active data transfer request parameters.
+	 * Active data transfer request parameters.
 	 *
-	 *	At most, there is only one ide-tape originated data transfer
-	 *	request in the device request queue. This allows ide.c to
-	 *	easily service requests from the other device when we
-	 *	postpone our active request. In the pipelined operation
-	 *	mode, we use our internal pipeline structure to hold
-	 *	more data requests.
+	 * At most, there is only one ide-tape originated data transfer	request
+	 * in the device request queue. This allows ide.c to easily service
+	 * requests from the other device when we postpone our active request.
+	 * In the pipelined operation mode, we use our internal pipeline
+	 * structure to hold more data requests.
 	 *
-	 *	The data buffer size is chosen based on the tape's
-	 *	recommendation.
+	 * The data buffer size is chosen based on the tape's recommendation.
 	 */
-	/* Pointer to the request which is waiting in the device request queue */
-	struct request *active_data_request;
-	/* Data buffer size (chosen based on the tape's recommendation */
+	/* active data request */
+	struct request *act_data_rq;
+	/* Data buffer size chosen based on the tape's recommendation */
 	int stage_size;
 	idetape_stage_t *merge_stage;
-	int merge_stage_size;
+	int merge_stage_sz;
 	struct idetape_bh *bh;
 	char *b_data;
 	int b_count;
-	
+
 	/*
-	 *	Pipeline parameters.
+	 * Pipeline parameters.
 	 *
-	 *	To accomplish non-pipelined mode, we simply set the following
-	 *	variables to zero (or NULL, where appropriate).
+	 * To accomplish non-pipelined mode, we simply set the following
+	 * variables to zero (or NULL, where appropriate).
 	 */
-	/* Number of currently used stages */
 	int nr_stages;
-	/* Number of pending stages */
 	int nr_pending_stages;
 	/* We will not allocate more than this number of stages */
 	int max_stages, min_pipeline, max_pipeline;
 	/* The first stage which will be removed from the pipeline */
 	idetape_stage_t *first_stage;
-	/* The currently active stage */
 	idetape_stage_t *active_stage;
-	/* Will be serviced after the currently active request */
 	idetape_stage_t *next_stage;
 	/* New requests will be added to the pipeline here */
 	idetape_stage_t *last_stage;
@@ -385,21 +366,16 @@ typedef struct ide_tape_obj {
 	/* Status/Action flags: long for set_bit */
 	unsigned long flags;
 	/* protects the ide-tape queue */
-	spinlock_t spinlock;
+	spinlock_t que_lock;
 
-	/*
-	 * Measures average tape speed
-	 */
+	/* Measure average tape speed */
 	unsigned long avg_time;
 	int avg_size;
 	int avg_speed;
 
 	char vendor_id[10];
 	char product_id[18];
-	char firmware_revision[6];
-	int firmware_revision_num;
 
-	/* the door is currently locked */
 	int door_locked;
 	/* the tape hardware is write protected */
 	char drv_write_prot;
@@ -407,11 +383,9 @@ typedef struct ide_tape_obj {
 	char write_prot;
 
 	/*
-	 * Limit the number of times a request can
-	 * be postponed, to avoid an infinite postpone
-	 * deadlock.
+	 * Limit the number of times a request can be postponed, to avoid an
+	 * infinite postpone deadlock.
 	 */
-	/* request postpone count limit */
 	int postpone_cnt;
 
 	/*
@@ -426,49 +400,39 @@ typedef struct ide_tape_obj {
 	int tape_head;
 	int last_tape_head;
 
-	/*
-	 * Speed control at the tape buffers input/output
-	 */
-	unsigned long insert_time;
-	int insert_size;
-	int insert_speed;
-	int max_insert_speed;
-	int measure_insert_time;
+	/* Speed control at the tape buffers input/output */
+	ulong ins_time;
+	int ins_size;
+	int ins_speed;
+	int max_ins_speed;
+	/* measure insert time */
+	int m_ins_time;
+
+	/* Speed regulation negative feedback loop */
+	int speed_ctl;
+	/* pipeline head speed */
+	int pipe_hspeed;
+	/* controlled pipeline head speed */
+	int pipe_ctl_hspeed;
+	/* uncontrolled pipeline head speed */
+	int unctl_pipe_hspeed;
+	/* controlled last pipeline head */
+	int ctl_last_pipe_h;
+	/* uncontrolled pipeline head time */
+	ulong unctl_pipe_htime;
+	/* controlled pipeline head time */
+	ulong ctl_pipe_htime;
+	/* controlled previous pipeline head */
+	int ctl_prev_pipe_h;
+	/* uncontrolled previous pipeline head */
+	int unctl_prev_pipe_h;
+	/* controlled previous head time */
+	ulong ctl_prev_htime;
+	/* uncontrolled previous head time */
+	ulong unctl_prev_htime;
+	/* restart speed control req */
+	int rs_speed_ctl_rq;
 
-	/*
-	 * Measure tape still time, in milliseconds
-	 */
-	unsigned long tape_still_time_begin;
-	int tape_still_time;
-
-	/*
-	 * Speed regulation negative feedback loop
-	 */
-	int speed_control;
-	int pipeline_head_speed;
-	int controlled_pipeline_head_speed;
-	int uncontrolled_pipeline_head_speed;
-	int controlled_last_pipeline_head;
-	int uncontrolled_last_pipeline_head;
-	unsigned long uncontrolled_pipeline_head_time;
-	unsigned long controlled_pipeline_head_time;
-	int controlled_previous_pipeline_head;
-	int uncontrolled_previous_pipeline_head;
-	unsigned long controlled_previous_head_time;
-	unsigned long uncontrolled_previous_head_time;
-	int restart_speed_control_req;
-
-        /*
-         * Debug_level determines amount of debugging output;
-         * can be changed using /proc/ide/hdx/settings
-         * 0 : almost no debugging output
-         * 1 : 0+output errors only
-         * 2 : 1+output all sensekey/asc
-         * 3 : 2+follow all chrdev related procedures
-         * 4 : 3+follow all procedures
-         * 5 : 4+include pc_stack rq_stack info
-         * 6 : 5+USE_COUNT updates
-         */
          u32 debug_level;
 } idetape_tape_t;
 
@@ -714,11 +678,11 @@ static idetape_pc_t *idetape_next_pc_storage (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	debug_log(DBG_PCRQ_STACK, "pc_stack_index=%d\n", tape->pc_stack_index);
+	debug_log(DBG_PCRQ_STACK, "pc_stack_index=%d\n", tape->pc_stack_idx);
 
-	if (tape->pc_stack_index == IDETAPE_PC_STACK)
-		tape->pc_stack_index=0;
-	return (&tape->pc_stack[tape->pc_stack_index++]);
+	if (tape->pc_stack_idx == IDETAPE_PC_STACK)
+		tape->pc_stack_idx = 0;
+	return (&tape->pc_stack[tape->pc_stack_idx++]);
 }
 
 /*
@@ -738,11 +702,11 @@ static struct request *idetape_next_rq_storage (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	debug_log(DBG_PCRQ_STACK, "rq_stack_index=%d\n", tape->rq_stack_index);
+	debug_log(DBG_PCRQ_STACK, "rq_stack_index=%d\n", tape->rq_stack_idx);
 
-	if (tape->rq_stack_index == IDETAPE_PC_STACK)
-		tape->rq_stack_index=0;
-	return (&tape->rq_stack[tape->rq_stack_index++]);
+	if (tape->rq_stack_idx == IDETAPE_PC_STACK)
+		tape->rq_stack_idx = 0;
+	return (&tape->rq_stack[tape->rq_stack_idx++]);
 }
 
 /*
@@ -779,7 +743,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	/* Correct pc->xferred by asking the tape.	 */
 	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
 		pc->xferred = pc->rq_xfer -
-			tape->tape_block_size *
+			tape->blk_sz *
 			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
 		idetape_update_buffers(pc);
 	}
@@ -840,7 +804,7 @@ static void idetape_activate_next_stage(ide_drive_t *drive)
 	rq->rq_disk = tape->disk;
 	rq->buffer = NULL;
 	rq->special = (void *)stage->bh;
-	tape->active_data_request = rq;
+	tape->act_data_rq = rq;
 	tape->active_stage = stage;
 	tape->next_stage = stage->next;
 }
@@ -982,13 +946,13 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		return 0;
 	}
 
-	spin_lock_irqsave(&tape->spinlock, flags);
+	spin_lock_irqsave(&tape->que_lock, flags);
 
 	/* The request was a pipelined data transfer request */
-	if (tape->active_data_request == rq) {
+	if (tape->act_data_rq == rq) {
 		active_stage = tape->active_stage;
 		tape->active_stage = NULL;
-		tape->active_data_request = NULL;
+		tape->act_data_rq = NULL;
 		tape->nr_pending_stages--;
 		if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 			remove_stage = 1;
@@ -1009,7 +973,8 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 			/*
 			 * Insert the next request into the request queue.
 			 */
-			(void) ide_do_drive_cmd(drive, tape->active_data_request, ide_end);
+			(void) ide_do_drive_cmd(drive, tape->act_data_rq,
+					ide_end);
 		} else if (!error) {
 				idetape_increase_max_pipeline_stages(drive);
 		}
@@ -1021,9 +986,9 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 
 	if (remove_stage)
 		idetape_remove_stage_head(drive);
-	if (tape->active_data_request == NULL)
+	if (tape->act_data_rq == NULL)
 		clear_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+	spin_unlock_irqrestore(&tape->que_lock, flags);
 	return 0;
 }
 
@@ -1120,7 +1085,7 @@ static void idetape_postpone_request (ide_drive_t *drive)
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	tape->postponed_rq = HWGROUP(drive)->rq;
-	ide_stall_queue(drive, tape->dsc_polling_frequency);
+	ide_stall_queue(drive, tape->dsc_poll_freq);
 }
 
 /*
@@ -1219,7 +1184,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 		    (stat & SEEK_STAT) == 0) {
 			/* Media access command */
 			tape->dsc_polling_start = jiffies;
-			tape->dsc_polling_frequency = IDETAPE_DSC_MA_FAST;
+			tape->dsc_poll_freq = IDETAPE_DSC_MA_FAST;
 			tape->dsc_timeout = jiffies + IDETAPE_DSC_MA_TIMEOUT;
 			/* Allow ide.c to handle other requests */
 			idetape_postpone_request(drive);
@@ -1502,48 +1467,58 @@ static void calculate_speeds(ide_drive_t *drive)
 	idetape_tape_t *tape = drive->driver_data;
 	int full = 125, empty = 75;
 
-	if (time_after(jiffies, tape->controlled_pipeline_head_time + 120 * HZ)) {
-		tape->controlled_previous_pipeline_head = tape->controlled_last_pipeline_head;
-		tape->controlled_previous_head_time = tape->controlled_pipeline_head_time;
-		tape->controlled_last_pipeline_head = tape->pipeline_head;
-		tape->controlled_pipeline_head_time = jiffies;
-	}
-	if (time_after(jiffies, tape->controlled_pipeline_head_time + 60 * HZ))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head - tape->controlled_last_pipeline_head) * 32 * HZ / (jiffies - tape->controlled_pipeline_head_time);
-	else if (time_after(jiffies, tape->controlled_previous_head_time))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head - tape->controlled_previous_pipeline_head) * 32 * HZ / (jiffies - tape->controlled_previous_head_time);
+	if (time_after(jiffies, tape->ctl_pipe_htime + 120 * HZ)) {
+		tape->ctl_prev_pipe_h = tape->ctl_last_pipe_h;
+		tape->ctl_prev_htime = tape->ctl_pipe_htime;
+		tape->ctl_last_pipe_h = tape->pipeline_head;
+		tape->ctl_pipe_htime = jiffies;
+	}
+	if (time_after(jiffies, tape->ctl_pipe_htime + 60 * HZ))
+		tape->pipe_ctl_hspeed =
+			(tape->pipeline_head - tape->ctl_last_pipe_h) * 32 *
+			HZ / (jiffies - tape->ctl_pipe_htime);
+	else if (time_after(jiffies, tape->ctl_prev_htime))
+		tape->pipe_ctl_hspeed =
+			(tape->pipeline_head - tape->ctl_prev_pipe_h) * 32 *
+			HZ / (jiffies - tape->ctl_prev_htime);
 
 	if (tape->nr_pending_stages < tape->max_stages /*- 1 */) {
 		/* -1 for read mode error recovery */
-		if (time_after(jiffies, tape->uncontrolled_previous_head_time + 10 * HZ)) {
-			tape->uncontrolled_pipeline_head_time = jiffies;
-			tape->uncontrolled_pipeline_head_speed = (tape->pipeline_head - tape->uncontrolled_previous_pipeline_head) * 32 * HZ / (jiffies - tape->uncontrolled_previous_head_time);
+		if (time_after(jiffies, tape->unctl_prev_htime + 10 * HZ)) {
+			tape->unctl_pipe_htime = jiffies;
+			tape->unctl_pipe_hspeed =
+				(tape->pipeline_head - tape->unctl_prev_pipe_h)
+				* 32 * HZ / (jiffies - tape->unctl_prev_htime);
 		}
 	} else {
-		tape->uncontrolled_previous_head_time = jiffies;
-		tape->uncontrolled_previous_pipeline_head = tape->pipeline_head;
-		if (time_after(jiffies, tape->uncontrolled_pipeline_head_time + 30 * HZ)) {
-			tape->uncontrolled_pipeline_head_time = jiffies;
-		}
-	}
-	tape->pipeline_head_speed = max(tape->uncontrolled_pipeline_head_speed, tape->controlled_pipeline_head_speed);
-	if (tape->speed_control == 0) {
-		tape->max_insert_speed = 5000;
-	} else if (tape->speed_control == 1) {
+		tape->unctl_prev_htime = jiffies;
+		tape->unctl_prev_pipe_h = tape->pipeline_head;
+		if (time_after(jiffies, tape->unctl_pipe_htime + 30 * HZ))
+			tape->unctl_pipe_htime = jiffies;
+	}
+	tape->pipe_hspeed = max(tape->unctl_pipe_hspeed, tape->pipe_ctl_hspeed);
+	if (tape->speed_ctl == 0) {
+		tape->max_ins_speed = 5000;
+	} else if (tape->speed_ctl == 1) {
 		if (tape->nr_pending_stages >= tape->max_stages / 2)
-			tape->max_insert_speed = tape->pipeline_head_speed +
-				(1100 - tape->pipeline_head_speed) * 2 * (tape->nr_pending_stages - tape->max_stages / 2) / tape->max_stages;
+			tape->max_ins_speed = tape->pipe_hspeed +
+				(1100 - tape->pipe_hspeed) * 2 *
+				(tape->nr_pending_stages - tape->max_stages / 2)
+				/ tape->max_stages;
 		else
-			tape->max_insert_speed = 500 +
-				(tape->pipeline_head_speed - 500) * 2 * tape->nr_pending_stages / tape->max_stages;
+			tape->max_ins_speed = 500 +
+				(tape->pipe_hspeed - 500) * 2 *
+				tape->nr_pending_stages / tape->max_stages;
 		if (tape->nr_pending_stages >= tape->max_stages * 99 / 100)
-			tape->max_insert_speed = 5000;
-	} else if (tape->speed_control == 2) {
-		tape->max_insert_speed = tape->pipeline_head_speed * empty / 100 +
-			(tape->pipeline_head_speed * full / 100 - tape->pipeline_head_speed * empty / 100) * tape->nr_pending_stages / tape->max_stages;
+			tape->max_ins_speed = 5000;
+	} else if (tape->speed_ctl == 2) {
+		tape->max_ins_speed = tape->pipe_hspeed * empty / 100 +
+			(tape->pipe_hspeed * full / 100 - tape->pipe_hspeed *
+			 empty / 100) * tape->nr_pending_stages
+			/ tape->max_stages;
 	} else
-		tape->max_insert_speed = tape->speed_control;
-	tape->max_insert_speed = max(tape->max_insert_speed, 500);
+		tape->max_ins_speed = tape->speed_ctl;
+	tape->max_ins_speed = max(tape->max_ins_speed, 500);
 }
 
 static ide_startstop_t idetape_media_access_finished (ide_drive_t *drive)
@@ -1576,27 +1551,29 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
-	int blocks = tape->pc->xferred / tape->tape_block_size;
-
-	tape->avg_size += blocks * tape->tape_block_size;
-	tape->insert_size += blocks * tape->tape_block_size;
-	if (tape->insert_size > 1024 * 1024)
-		tape->measure_insert_time = 1;
-	if (tape->measure_insert_time) {
-		tape->measure_insert_time = 0;
-		tape->insert_time = jiffies;
-		tape->insert_size = 0;
-	}
-	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ / (jiffies - tape->insert_time);
+	int blocks = tape->pc->xferred / tape->blk_sz;
+
+	tape->avg_size += blocks * tape->blk_sz;
+	tape->ins_size += blocks * tape->blk_sz;
+	if (tape->ins_size > 1024 * 1024)
+		tape->m_ins_time = 1;
+	if (tape->m_ins_time) {
+		tape->m_ins_time = 0;
+		tape->ins_time = jiffies;
+		tape->ins_size = 0;
+	}
+	if (time_after(jiffies, tape->ins_time))
+		tape->ins_speed = tape->ins_size / 1024 * HZ /
+			(jiffies - tape->ins_time);
 	if (time_after_eq(jiffies, tape->avg_time + HZ)) {
-		tape->avg_speed = tape->avg_size * HZ / (jiffies - tape->avg_time) / 1024;
+		tape->avg_speed = tape->avg_size * HZ /
+			(jiffies - tape->avg_time) / 1024;
 		tape->avg_size = 0;
 		tape->avg_time = jiffies;
 	}
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	tape->first_frame_position += blocks;
+	tape->first_frm_pos += blocks;
 	rq->current_nr_sectors -= blocks;
 
 	if (!tape->pc->error)
@@ -1616,7 +1593,7 @@ static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsi
 	pc->bh = bh;
 	atomic_set(&bh->b_count, 0);
 	pc->buffer = NULL;
-	pc->buf_size = length * tape->tape_block_size;
+	pc->buf_size = length * tape->blk_sz;
 	pc->rq_xfer = pc->buf_size;
 	if (pc->rq_xfer == tape->stage_size)
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
@@ -1655,7 +1632,7 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, uns
 	pc->b_data = bh->b_data;
 	pc->b_count = atomic_read(&bh->b_count);
 	pc->buffer = NULL;
-	pc->rq_xfer = pc->buf_size = length * tape->tape_block_size;
+	pc->rq_xfer = pc->buf_size = length * tape->blk_sz;
 	if (pc->rq_xfer == tape->stage_size)
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
@@ -1716,16 +1693,15 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		drive->post_reset = 0;
 	}
 
-	if (tape->tape_still_time > 100 && tape->tape_still_time < 200)
-		tape->measure_insert_time = 1;
-	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ / (jiffies - tape->insert_time);
+	if (time_after(jiffies, tape->ins_time))
+		tape->ins_speed = tape->ins_size / 1024 * HZ /
+			(jiffies - tape->ins_time);
 	calculate_speeds(drive);
 	if (!test_and_clear_bit(IDETAPE_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
-			tape->dsc_polling_frequency = tape->best_dsc_rw_frequency;
+			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
 			tape->dsc_timeout = jiffies + IDETAPE_DSC_RW_TIMEOUT;
 		} else if (time_after(jiffies, tape->dsc_timeout)) {
 			printk(KERN_ERR "ide-tape: %s: DSC timeout\n",
@@ -1737,7 +1713,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 				return ide_do_reset(drive);
 			}
 		} else if (time_after(jiffies, tape->dsc_polling_start + IDETAPE_DSC_MA_THRESHOLD))
-			tape->dsc_polling_frequency = IDETAPE_DSC_MA_SLOW;
+			tape->dsc_poll_freq = IDETAPE_DSC_MA_SLOW;
 		idetape_postpone_request(drive);
 		return ide_stopped;
 	}
@@ -1784,7 +1760,7 @@ static inline int idetape_pipeline_active (idetape_tape_t *tape)
 	int rc1, rc2;
 
 	rc1 = test_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
-	rc2 = (tape->active_data_request != NULL);
+	rc2 = (tape->act_data_rq != NULL);
 	return rc1;
 }
 
@@ -1938,7 +1914,7 @@ static void idetape_init_merge_stage (idetape_tape_t *tape)
 	struct idetape_bh *bh = tape->merge_stage->bh;
 	
 	tape->bh = bh;
-	if (tape->chrdev_direction == idetape_dir_write)
+	if (tape->chrdev_dir == idetape_dir_write)
 		atomic_set(&bh->b_count, 0);
 	else {
 		tape->b_data = bh->b_data;
@@ -1966,7 +1942,7 @@ static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	spin_lock_irqsave(&tape->spinlock, flags);
+	spin_lock_irqsave(&tape->que_lock, flags);
 	stage->next = NULL;
 	if (tape->last_stage != NULL)
 		tape->last_stage->next=stage;
@@ -1977,7 +1953,7 @@ static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
 		tape->next_stage = tape->last_stage;
 	tape->nr_stages++;
 	tape->nr_pending_stages++;
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+	spin_unlock_irqrestore(&tape->que_lock, flags);
 }
 
 /*
@@ -1998,10 +1974,10 @@ static void idetape_wait_for_request (ide_drive_t *drive, struct request *rq)
 	}
 	rq->end_io_data = &wait;
 	rq->end_io = blk_end_sync_rq;
-	spin_unlock_irq(&tape->spinlock);
+	spin_unlock_irq(&tape->que_lock);
 	wait_for_completion(&wait);
 	/* The stage and its struct request have been deallocated */
-	spin_lock_irq(&tape->spinlock);
+	spin_lock_irq(&tape->que_lock);
 }
 
 static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
@@ -2028,10 +2004,8 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 					be32_to_cpu(*(u32 *)&readpos[4]));
 
 			tape->partition = readpos[1];
-			tape->first_frame_position =
+			tape->first_frm_pos =
 				be32_to_cpu(*(u32 *)&readpos[4]);
-			tape->last_frame_position =
-				be32_to_cpu(*(u32 *)&readpos[8]);
 			tape->blocks_in_buffer = readpos[15];
 			set_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 1, 0);
@@ -2173,7 +2147,7 @@ static int idetape_read_position (ide_drive_t *drive)
 	idetape_create_read_position_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc))
 		return -1;
-	position = tape->first_frame_position;
+	position = tape->first_frm_pos;
 	return position;
 }
 
@@ -2209,14 +2183,14 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 	unsigned long flags;
 	int cnt;
 
-	if (tape->chrdev_direction != idetape_dir_read)
+	if (tape->chrdev_dir != idetape_dir_read)
 		return 0;
 
 	/* Remove merge stage. */
-	cnt = tape->merge_stage_size / tape->tape_block_size;
+	cnt = tape->merge_stage_sz / tape->blk_sz;
 	if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
 		++cnt;		/* Filemarks count as 1 sector */
-	tape->merge_stage_size = 0;
+	tape->merge_stage_sz = 0;
 	if (tape->merge_stage != NULL) {
 		__idetape_kfree_stage(tape->merge_stage);
 		tape->merge_stage = NULL;
@@ -2224,17 +2198,17 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 
 	/* Clear pipeline flags. */
 	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
-	tape->chrdev_direction = idetape_dir_none;
+	tape->chrdev_dir = idetape_dir_none;
 
 	/* Remove pipeline stages. */
 	if (tape->first_stage == NULL)
 		return 0;
 
-	spin_lock_irqsave(&tape->spinlock, flags);
+	spin_lock_irqsave(&tape->que_lock, flags);
 	tape->next_stage = NULL;
 	if (idetape_pipeline_active(tape))
-		idetape_wait_for_request(drive, tape->active_data_request);
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+		idetape_wait_for_request(drive, tape->act_data_rq);
+	spin_unlock_irqrestore(&tape->que_lock, flags);
 
 	while (tape->first_stage != NULL) {
 		struct request *rq_ptr = &tape->first_stage->rq;
@@ -2264,7 +2238,7 @@ static int idetape_position_tape (ide_drive_t *drive, unsigned int block, u8 par
 	int retval;
 	idetape_pc_t pc;
 
-	if (tape->chrdev_direction == idetape_dir_read)
+	if (tape->chrdev_dir == idetape_dir_read)
 		__idetape_discard_read_pipeline(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
@@ -2313,7 +2287,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 	idetape_init_rq(&rq, cmd);
 	rq.rq_disk = tape->disk;
 	rq.special = (void *)bh;
-	rq.sector = tape->first_frame_position;
+	rq.sector = tape->first_frm_pos;
 	rq.nr_sectors = rq.current_nr_sectors = blocks;
 	(void) ide_do_drive_cmd(drive, &rq, ide_wait);
 
@@ -2324,7 +2298,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 		idetape_init_merge_stage(tape);
 	if (rq.errors == IDETAPE_ERROR_GENERAL)
 		return -EIO;
-	return (tape->tape_block_size * (blocks-rq.current_nr_sectors));
+	return (tape->blk_sz * (blocks-rq.current_nr_sectors));
 }
 
 /*
@@ -2340,7 +2314,7 @@ static void idetape_insert_pipeline_into_queue (ide_drive_t *drive)
 	if (!idetape_pipeline_active(tape)) {
 		set_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
 		idetape_activate_next_stage(drive);
-		(void) ide_do_drive_cmd(drive, tape->active_data_request, ide_end);
+		(void) ide_do_drive_cmd(drive, tape->act_data_rq, ide_end);
 	}
 }
 
@@ -2386,10 +2360,10 @@ static void idetape_wait_first_stage (ide_drive_t *drive)
 
 	if (tape->first_stage == NULL)
 		return;
-	spin_lock_irqsave(&tape->spinlock, flags);
+	spin_lock_irqsave(&tape->que_lock, flags);
 	if (tape->active_stage == tape->first_stage)
-		idetape_wait_for_request(drive, tape->active_data_request);
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+		idetape_wait_for_request(drive, tape->act_data_rq);
+	spin_unlock_irqrestore(&tape->que_lock, flags);
 }
 
 /*
@@ -2417,12 +2391,12 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	 *	Pay special attention to possible race conditions.
 	 */
 	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
-		spin_lock_irqsave(&tape->spinlock, flags);
+		spin_lock_irqsave(&tape->que_lock, flags);
 		if (idetape_pipeline_active(tape)) {
-			idetape_wait_for_request(drive, tape->active_data_request);
-			spin_unlock_irqrestore(&tape->spinlock, flags);
+			idetape_wait_for_request(drive, tape->act_data_rq);
+			spin_unlock_irqrestore(&tape->que_lock, flags);
 		} else {
-			spin_unlock_irqrestore(&tape->spinlock, flags);
+			spin_unlock_irqrestore(&tape->que_lock, flags);
 			idetape_insert_pipeline_into_queue(drive);
 			if (idetape_pipeline_active(tape))
 				continue;
@@ -2436,7 +2410,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	rq = &new_stage->rq;
 	idetape_init_rq(rq, REQ_IDETAPE_WRITE);
 	/* Doesn't actually matter - We always assume sequential access */
-	rq->sector = tape->first_frame_position;
+	rq->sector = tape->first_frm_pos;
 	rq->nr_sectors = rq->current_nr_sectors = blocks;
 
 	idetape_switch_buffers(tape, new_stage);
@@ -2453,11 +2427,12 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	 */
 	if (!idetape_pipeline_active(tape)) {
 		if (tape->nr_stages >= tape->max_stages * 9 / 10 ||
-		    tape->nr_stages >= tape->max_stages - tape->uncontrolled_pipeline_head_speed * 3 * 1024 / tape->tape_block_size) {
-			tape->measure_insert_time = 1;
-			tape->insert_time = jiffies;
-			tape->insert_size = 0;
-			tape->insert_speed = 0;
+		    tape->nr_stages >= tape->max_stages -
+		    tape->unctl_pipe_hspeed * 3 * 1024 / tape->blk_sz) {
+			tape->m_ins_time = 1;
+			tape->ins_time = jiffies;
+			tape->ins_size = 0;
+			tape->ins_speed = 0;
 			idetape_insert_pipeline_into_queue(drive);
 		}
 	}
@@ -2478,10 +2453,10 @@ static void idetape_wait_for_pipeline (ide_drive_t *drive)
 
 	while (tape->next_stage || idetape_pipeline_active(tape)) {
 		idetape_insert_pipeline_into_queue(drive);
-		spin_lock_irqsave(&tape->spinlock, flags);
+		spin_lock_irqsave(&tape->que_lock, flags);
 		if (idetape_pipeline_active(tape))
-			idetape_wait_for_request(drive, tape->active_data_request);
-		spin_unlock_irqrestore(&tape->spinlock, flags);
+			idetape_wait_for_request(drive, tape->act_data_rq);
+		spin_unlock_irqrestore(&tape->que_lock, flags);
 	}
 }
 
@@ -2491,21 +2466,21 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	int blocks, min;
 	struct idetape_bh *bh;
 
-	if (tape->chrdev_direction != idetape_dir_write) {
+	if (tape->chrdev_dir != idetape_dir_write) {
 		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline, but we are not writing.\n");
 		return;
 	}
-	if (tape->merge_stage_size > tape->stage_size) {
+	if (tape->merge_stage_sz > tape->stage_size) {
 		printk(KERN_ERR "ide-tape: bug: merge_buffer too big\n");
-		tape->merge_stage_size = tape->stage_size;
+		tape->merge_stage_sz = tape->stage_size;
 	}
-	if (tape->merge_stage_size) {
-		blocks = tape->merge_stage_size / tape->tape_block_size;
-		if (tape->merge_stage_size % tape->tape_block_size) {
+	if (tape->merge_stage_sz) {
+		blocks = tape->merge_stage_sz / tape->blk_sz;
+		if (tape->merge_stage_sz % tape->blk_sz) {
 			unsigned int i;
 
 			blocks++;
-			i = tape->tape_block_size - tape->merge_stage_size % tape->tape_block_size;
+			i = tape->blk_sz - tape->merge_stage_sz % tape->blk_sz;
 			bh = tape->bh->b_reqnext;
 			while (bh) {
 				atomic_set(&bh->b_count, 0);
@@ -2526,7 +2501,7 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 			}
 		}
 		(void) idetape_add_chrdev_write_request(drive, blocks);
-		tape->merge_stage_size = 0;
+		tape->merge_stage_sz = 0;
 	}
 	idetape_wait_for_pipeline(drive);
 	if (tape->merge_stage != NULL) {
@@ -2534,7 +2509,7 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 		tape->merge_stage = NULL;
 	}
 	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
-	tape->chrdev_direction = idetape_dir_none;
+	tape->chrdev_dir = idetape_dir_none;
 
 	/*
 	 *	On the next backup, perform the feedback loop again.
@@ -2559,14 +2534,14 @@ static void idetape_restart_speed_control (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	tape->restart_speed_control_req = 0;
+	tape->rs_speed_ctl_rq = 0;
 	tape->pipeline_head = 0;
-	tape->controlled_last_pipeline_head = tape->uncontrolled_last_pipeline_head = 0;
-	tape->controlled_previous_pipeline_head = tape->uncontrolled_previous_pipeline_head = 0;
-	tape->pipeline_head_speed = tape->controlled_pipeline_head_speed = 5000;
-	tape->uncontrolled_pipeline_head_speed = 0;
-	tape->controlled_pipeline_head_time = tape->uncontrolled_pipeline_head_time = jiffies;
-	tape->controlled_previous_head_time = tape->uncontrolled_previous_head_time = jiffies;
+	tape->ctl_last_pipe_h = 0;
+	tape->ctl_prev_pipe_h = tape->unctl_prev_pipe_h = 0;
+	tape->pipe_hspeed = tape->pipe_ctl_hspeed = 5000;
+	tape->unctl_pipe_hspeed = 0;
+	tape->ctl_pipe_htime = tape->unctl_pipe_htime = jiffies;
+	tape->ctl_prev_htime = tape->unctl_prev_htime = jiffies;
 }
 
 static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
@@ -2578,18 +2553,18 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 	u16 blocks = *(u16 *)&tape->caps[12];
 
 	/* Initialize read operation */
-	if (tape->chrdev_direction != idetape_dir_read) {
-		if (tape->chrdev_direction == idetape_dir_write) {
+	if (tape->chrdev_dir != idetape_dir_read) {
+		if (tape->chrdev_dir == idetape_dir_write) {
 			idetape_empty_write_pipeline(drive);
 			idetape_flush_tape_buffers(drive);
 		}
-		if (tape->merge_stage || tape->merge_stage_size) {
+		if (tape->merge_stage || tape->merge_stage_sz) {
 			printk (KERN_ERR "ide-tape: merge_stage_size should be 0 now\n");
-			tape->merge_stage_size = 0;
+			tape->merge_stage_sz = 0;
 		}
 		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
 			return -ENOMEM;
-		tape->chrdev_direction = idetape_dir_read;
+		tape->chrdev_dir = idetape_dir_read;
 
 		/*
 		 *	Issue a read 0 command to ensure that DSC handshake
@@ -2603,15 +2578,15 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 			if (bytes_read < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
-				tape->chrdev_direction = idetape_dir_none;
+				tape->chrdev_dir = idetape_dir_none;
 				return bytes_read;
 			}
 		}
 	}
-	if (tape->restart_speed_control_req)
+	if (tape->rs_speed_ctl_rq)
 		idetape_restart_speed_control(drive);
 	idetape_init_rq(&rq, REQ_IDETAPE_READ);
-	rq.sector = tape->first_frame_position;
+	rq.sector = tape->first_frm_pos;
 	rq.nr_sectors = rq.current_nr_sectors = blocks;
 	if (!test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags) &&
 	    tape->nr_stages < max_stages) {
@@ -2626,10 +2601,10 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 	}
 	if (!idetape_pipeline_active(tape)) {
 		if (tape->nr_pending_stages >= 3 * max_stages / 4) {
-			tape->measure_insert_time = 1;
-			tape->insert_time = jiffies;
-			tape->insert_size = 0;
-			tape->insert_speed = 0;
+			tape->m_ins_time = 1;
+			tape->ins_time = jiffies;
+			tape->ins_size = 0;
+			tape->ins_speed = 0;
 			idetape_insert_pipeline_into_queue(drive);
 		}
 	}
@@ -2668,7 +2643,8 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 	}
 	idetape_wait_first_stage(drive);
 	rq_ptr = &tape->first_stage->rq;
-	bytes_read = tape->tape_block_size * (rq_ptr->nr_sectors - rq_ptr->current_nr_sectors);
+	bytes_read = tape->blk_sz *
+		(rq_ptr->nr_sectors - rq_ptr->current_nr_sectors);
 	rq_ptr->nr_sectors = rq_ptr->current_nr_sectors = 0;
 
 
@@ -2678,15 +2654,15 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 		idetape_switch_buffers(tape, tape->first_stage);
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
 			set_bit(IDETAPE_FILEMARK, &tape->flags);
-		spin_lock_irqsave(&tape->spinlock, flags);
+		spin_lock_irqsave(&tape->que_lock, flags);
 		idetape_remove_stage_head(drive);
-		spin_unlock_irqrestore(&tape->spinlock, flags);
+		spin_unlock_irqrestore(&tape->que_lock, flags);
 		tape->pipeline_head++;
 		calculate_speeds(drive);
 	}
-	if (bytes_read > blocks * tape->tape_block_size) {
+	if (bytes_read > blocks * tape->blk_sz) {
 		printk(KERN_ERR "ide-tape: bug: trying to return more bytes than requested\n");
-		bytes_read = blocks * tape->tape_block_size;
+		bytes_read = blocks * tape->blk_sz;
 	}
 	return (bytes_read);
 }
@@ -2703,7 +2679,7 @@ static void idetape_pad_zeros (ide_drive_t *drive, int bcount)
 		bh = tape->merge_stage->bh;
 		count = min(tape->stage_size, bcount);
 		bcount -= count;
-		blocks = count / tape->tape_block_size;
+		blocks = count / tape->blk_sz;
 		while (count) {
 			atomic_set(&bh->b_count, min(count, (unsigned int)bh->b_size));
 			memset(bh->b_data, 0, atomic_read(&bh->b_count));
@@ -2725,12 +2701,12 @@ static int idetape_pipeline_size (ide_drive_t *drive)
 	stage = tape->first_stage;
 	while (stage != NULL) {
 		rq = &stage->rq;
-		size += tape->tape_block_size * (rq->nr_sectors-rq->current_nr_sectors);
+		size += tape->blk_sz * (rq->nr_sectors-rq->current_nr_sectors);
 		if (rq->errors == IDETAPE_ERROR_FILEMARK)
-			size += tape->tape_block_size;
+			size += tape->blk_sz;
 		stage = stage->next;
 	}
-	size += tape->merge_stage_size;
+	size += tape->merge_stage_sz;
 	return size;
 }
 
@@ -2779,11 +2755,11 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
 		case 0x0340:
 			if (copy_from_user(&config, argp, sizeof (idetape_config_t)))
 				return -EFAULT;
-			tape->best_dsc_rw_frequency = config.dsc_rw_frequency;
+			tape->best_dsc_rw_freq = config.dsc_rw_frequency;
 			tape->max_stages = config.nr_stages;
 			break;
 		case 0x0350:
-			config.dsc_rw_frequency = (int) tape->best_dsc_rw_frequency;
+			config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
 			config.nr_stages = tape->max_stages; 
 			if (copy_to_user(argp, &config, sizeof (idetape_config_t)))
 				return -EFAULT;
@@ -2819,12 +2795,12 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 		mt_count = - mt_count;
 	}
 
-	if (tape->chrdev_direction == idetape_dir_read) {
+	if (tape->chrdev_dir == idetape_dir_read) {
 		/*
 		 *	We have a read-ahead buffer. Scan it for crossed
 		 *	filemarks.
 		 */
-		tape->merge_stage_size = 0;
+		tape->merge_stage_sz = 0;
 		if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
 			++count;
 		while (tape->first_stage != NULL) {
@@ -2833,7 +2809,7 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 					set_bit(IDETAPE_FILEMARK, &tape->flags);
 				return 0;
 			}
-			spin_lock_irqsave(&tape->spinlock, flags);
+			spin_lock_irqsave(&tape->que_lock, flags);
 			if (tape->first_stage == tape->active_stage) {
 				/*
 				 *	We have reached the active stage in the read pipeline.
@@ -2845,11 +2821,11 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 				 *	__idetape_discard_read_pipeline(), for example.
 				 */
 				tape->next_stage = NULL;
-				spin_unlock_irqrestore(&tape->spinlock, flags);
+				spin_unlock_irqrestore(&tape->que_lock, flags);
 				idetape_wait_first_stage(drive);
 				tape->next_stage = tape->first_stage->next;
 			} else
-				spin_unlock_irqrestore(&tape->spinlock, flags);
+				spin_unlock_irqrestore(&tape->que_lock, flags);
 			if (tape->first_stage->rq.errors == IDETAPE_ERROR_FILEMARK)
 				++count;
 			idetape_remove_stage_head(drive);
@@ -2909,22 +2885,22 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
-	if (tape->chrdev_direction != idetape_dir_read) {
+	if (tape->chrdev_dir != idetape_dir_read) {
 		if (test_bit(IDETAPE_DETECT_BS, &tape->flags))
-			if (count > tape->tape_block_size &&
-			    (count % tape->tape_block_size) == 0)
-				tape->user_bs_factor = count / tape->tape_block_size;
+			if (count > tape->blk_sz &&
+			    (count % tape->blk_sz) == 0)
+				tape->user_bs_factor = count / tape->blk_sz;
 	}
 	if ((rc = idetape_initiate_read(drive, tape->max_stages)) < 0)
 		return rc;
 	if (count == 0)
 		return (0);
-	if (tape->merge_stage_size) {
-		actually_read = min((unsigned int)(tape->merge_stage_size), (unsigned int)count);
+	if (tape->merge_stage_sz) {
+		actually_read = min((uint)(tape->merge_stage_sz), (uint)count);
 		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, actually_read))
 			ret = -EFAULT;
 		buf += actually_read;
-		tape->merge_stage_size -= actually_read;
+		tape->merge_stage_sz -= actually_read;
 		count -= actually_read;
 	}
 	while (count >= tape->stage_size) {
@@ -2945,7 +2921,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, temp))
 			ret = -EFAULT;
 		actually_read += temp;
-		tape->merge_stage_size = bytes_read-temp;
+		tape->merge_stage_sz = bytes_read-temp;
 	}
 finish:
 	if (!actually_read && test_bit(IDETAPE_FILEMARK, &tape->flags)) {
@@ -2974,17 +2950,17 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	/* Initialize write operation */
-	if (tape->chrdev_direction != idetape_dir_write) {
-		if (tape->chrdev_direction == idetape_dir_read)
+	if (tape->chrdev_dir != idetape_dir_write) {
+		if (tape->chrdev_dir == idetape_dir_read)
 			idetape_discard_read_pipeline(drive, 1);
-		if (tape->merge_stage || tape->merge_stage_size) {
+		if (tape->merge_stage || tape->merge_stage_sz) {
 			printk(KERN_ERR "ide-tape: merge_stage_size "
 				"should be 0 now\n");
-			tape->merge_stage_size = 0;
+			tape->merge_stage_sz = 0;
 		}
 		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
 			return -ENOMEM;
-		tape->chrdev_direction = idetape_dir_write;
+		tape->chrdev_dir = idetape_dir_write;
 		idetape_init_merge_stage(tape);
 
 		/*
@@ -2999,30 +2975,31 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 			if (retval < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
-				tape->chrdev_direction = idetape_dir_none;
+				tape->chrdev_dir = idetape_dir_none;
 				return retval;
 			}
 		}
 	}
 	if (count == 0)
 		return (0);
-	if (tape->restart_speed_control_req)
+	if (tape->rs_speed_ctl_rq)
 		idetape_restart_speed_control(drive);
-	if (tape->merge_stage_size) {
-		if (tape->merge_stage_size >= tape->stage_size) {
+	if (tape->merge_stage_sz) {
+		if (tape->merge_stage_sz >= tape->stage_size) {
 			printk(KERN_ERR "ide-tape: bug: merge buffer too big\n");
-			tape->merge_stage_size = 0;
+			tape->merge_stage_sz = 0;
 		}
-		actually_written = min((unsigned int)(tape->stage_size - tape->merge_stage_size), (unsigned int)count);
+		actually_written = min((uint)(tape->stage_size -
+					tape->merge_stage_sz), (uint)count);
 		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, actually_written))
 				ret = -EFAULT;
 		buf += actually_written;
-		tape->merge_stage_size += actually_written;
+		tape->merge_stage_sz += actually_written;
 		count -= actually_written;
 
-		if (tape->merge_stage_size == tape->stage_size) {
+		if (tape->merge_stage_sz == tape->stage_size) {
 			ssize_t retval;
-			tape->merge_stage_size = 0;
+			tape->merge_stage_sz = 0;
 			retval = idetape_add_chrdev_write_request(drive, ctl);
 			if (retval <= 0)
 				return (retval);
@@ -3043,7 +3020,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 		actually_written += count;
 		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, count))
 			ret = -EFAULT;
-		tape->merge_stage_size += count;
+		tape->merge_stage_sz += count;
 	}
 	return (ret) ? ret : actually_written;
 }
@@ -3199,9 +3176,10 @@ static int idetape_mtioctop (ide_drive_t *drive,short mt_op,int mt_count)
 			return (idetape_queue_pc_tail(drive, &pc));
 		case MTSETBLK:
 			if (mt_count) {
-				if (mt_count < tape->tape_block_size || mt_count % tape->tape_block_size)
+				if (mt_count < tape->blk_sz ||
+						mt_count % tape->blk_sz)
 					return -EIO;
-				tape->user_bs_factor = mt_count / tape->tape_block_size;
+				tape->user_bs_factor = mt_count / tape->blk_sz;
 				clear_bit(IDETAPE_DETECT_BS, &tape->flags);
 			} else
 				set_bit(IDETAPE_DETECT_BS, &tape->flags);
@@ -3265,18 +3243,19 @@ static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigne
 	struct mtop mtop;
 	struct mtget mtget;
 	struct mtpos mtpos;
-	int block_offset = 0, position = tape->first_frame_position;
+	int block_offset = 0, position = tape->first_frm_pos;
 	void __user *argp = (void __user *)arg;
 
 	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
 
-	tape->restart_speed_control_req = 1;
-	if (tape->chrdev_direction == idetape_dir_write) {
+	tape->rs_speed_ctl_rq = 1;
+	if (tape->chrdev_dir == idetape_dir_write) {
 		idetape_empty_write_pipeline(drive);
 		idetape_flush_tape_buffers(drive);
 	}
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
-		block_offset = idetape_pipeline_size(drive) / (tape->tape_block_size * tape->user_bs_factor);
+		block_offset = idetape_pipeline_size(drive) /
+			(tape->blk_sz * tape->user_bs_factor);
 		if ((position = idetape_read_position(drive)) < 0)
 			return -EIO;
 	}
@@ -3289,7 +3268,9 @@ static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigne
 			memset(&mtget, 0, sizeof (struct mtget));
 			mtget.mt_type = MT_ISSCSI2;
 			mtget.mt_blkno = position / tape->user_bs_factor - block_offset;
-			mtget.mt_dsreg = ((tape->tape_block_size * tape->user_bs_factor) << MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK;
+			mtget.mt_dsreg = ((tape->blk_sz * tape->user_bs_factor)
+					<< MT_ST_BLKSIZE_SHIFT)
+				& MT_ST_BLKSIZE_MASK;
 			if (tape->drv_write_prot) {
 				mtget.mt_gstat |= GMT_WR_PROT(0xffffffff);
 			}
@@ -3302,7 +3283,7 @@ static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigne
 				return -EFAULT;
 			return 0;
 		default:
-			if (tape->chrdev_direction == idetape_dir_read)
+			if (tape->chrdev_dir == idetape_dir_read)
 				idetape_discard_read_pipeline(drive, 1);
 			return idetape_blkdev_ioctl(drive, cmd, arg);
 	}
@@ -3321,14 +3302,14 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
 	if (idetape_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
-		if (tape->tape_block_size == 0) {
+		if (tape->blk_sz == 0) {
 			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
 					"block size, assuming 32k\n");
-			tape->tape_block_size =  32768;
+			tape->blk_sz =  32768;
 		}
 		return;
 	}
-	tape->tape_block_size = (pc.buffer[4 + 5] << 16) +
+	tape->blk_sz = (pc.buffer[4 + 5] << 16) +
 				(pc.buffer[4 + 6] << 8)  +
 				pc.buffer[4 + 7];
 
@@ -3381,7 +3362,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	if (!test_bit(IDETAPE_ADDRESS_VALID, &tape->flags))
 		(void)idetape_rewind_tape(drive);
 
-	if (tape->chrdev_direction != idetape_dir_read)
+	if (tape->chrdev_dir != idetape_dir_read)
 		clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
 
 	/* Read block size and write protect status from drive. */
@@ -3406,7 +3387,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	/*
 	 * Lock the tape drive door so user can't eject.
 	 */
-	if (tape->chrdev_direction == idetape_dir_none) {
+	if (tape->chrdev_dir == idetape_dir_none) {
 		if (idetape_create_prevent_cmd(drive, &pc, 1)) {
 			if (!idetape_queue_pc_tail(drive, &pc)) {
 				if (tape->door_locked != DOOR_EXPLICITLY_LOCKED)
@@ -3415,7 +3396,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 		}
 	}
 	idetape_restart_speed_control(drive);
-	tape->restart_speed_control_req = 0;
+	tape->rs_speed_ctl_rq = 0;
 	return 0;
 
 out_put_tape:
@@ -3430,7 +3411,8 @@ static void idetape_write_release (ide_drive_t *drive, unsigned int minor)
 	idetape_empty_write_pipeline(drive);
 	tape->merge_stage = __idetape_kmalloc_stage(tape, 1, 0);
 	if (tape->merge_stage != NULL) {
-		idetape_pad_zeros(drive, tape->tape_block_size * (tape->user_bs_factor - 1));
+		idetape_pad_zeros(drive, tape->blk_sz *
+				(tape->user_bs_factor - 1));
 		__idetape_kfree_stage(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
@@ -3454,9 +3436,9 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 
 	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
-	if (tape->chrdev_direction == idetape_dir_write)
+	if (tape->chrdev_dir == idetape_dir_write)
 		idetape_write_release(drive, minor);
-	if (tape->chrdev_direction == idetape_dir_read) {
+	if (tape->chrdev_dir == idetape_dir_read) {
 		if (minor < 128)
 			idetape_discard_read_pipeline(drive, 1);
 		else
@@ -3468,7 +3450,7 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 	}
 	if (minor < 128 && test_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags))
 		(void) idetape_rewind_tape(drive);
-	if (tape->chrdev_direction == idetape_dir_none) {
+	if (tape->chrdev_dir == idetape_dir_none) {
 		if (tape->door_locked == DOOR_LOCKED) {
 			if (idetape_create_prevent_cmd(drive, &pc, 0)) {
 				if (!idetape_queue_pc_tail(drive, &pc))
@@ -3520,9 +3502,9 @@ static int idetape_identify_device (ide_drive_t *drive)
 
 static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
-	char *r;
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
+	char fw_rev[6];
 
 	idetape_create_inquiry_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc)) {
@@ -3532,18 +3514,15 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	}
 	memcpy(tape->vendor_id, &pc.buffer[8], 8);
 	memcpy(tape->product_id, &pc.buffer[16], 16);
-	memcpy(tape->firmware_revision, &pc.buffer[32], 4);
+	memcpy(fw_rev, &pc.buffer[32], 4);
 
 	ide_fixstring(tape->vendor_id, 10, 0);
 	ide_fixstring(tape->product_id, 18, 0);
-	ide_fixstring(tape->firmware_revision, 6, 0);
-	r = tape->firmware_revision;
-	if (*(r + 1) == '.')
-		tape->firmware_revision_num = (*r - '0') * 100 +
-			(*(r + 2) - '0') * 10 +	*(r + 3) - '0';
+	ide_fixstring(fw_rev, 6, 0);
+
 	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
 			drive->name, tape->name, tape->vendor_id,
-			tape->product_id, tape->firmware_revision);
+			tape->product_id, fw_rev);
 }
 
 /*
@@ -3561,7 +3540,7 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 	if (idetape_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
 				" some default values\n");
-		tape->tape_block_size = 512;
+		tape->blk_sz = 512;
 		put_unaligned(52,   (u16 *)&tape->caps[12]);
 		put_unaligned(540,  (u16 *)&tape->caps[14]);
 		put_unaligned(6*52, (u16 *)&tape->caps[16]);
@@ -3591,9 +3570,9 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 
 	memcpy(&tape->caps, caps, 20);
 	if (!!(caps[7] & 0x02))
-		tape->tape_block_size = 512;
+		tape->blk_sz = 512;
 	else if (!!(caps[7] & 0x04))
-		tape->tape_block_size = 1024;
+		tape->blk_sz = 1024;
 
 }
 
@@ -3615,10 +3594,14 @@ static void idetape_add_settings (ide_drive_t *drive)
 	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 1, (u16 *)&tape->caps[14], NULL);
 	ide_add_setting(drive,	"stage",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1024,		&tape->stage_size,			NULL);
-	ide_add_setting(drive,	"tdsc",			SETTING_RW,	TYPE_INT,	IDETAPE_DSC_RW_MIN,	IDETAPE_DSC_RW_MAX,	1000,				HZ,		&tape->best_dsc_rw_frequency,		NULL);
+	ide_add_setting(drive, "tdsc", SETTING_RW, TYPE_INT, IDETAPE_DSC_RW_MIN,
+			IDETAPE_DSC_RW_MAX, 1000, HZ, &tape->best_dsc_rw_freq,
+			NULL);
 	ide_add_setting(drive,	"dsc_overlap",		SETTING_RW,	TYPE_BYTE,	0,			1,			1,				1,		&drive->dsc_overlap,			NULL);
-	ide_add_setting(drive,	"pipeline_head_speed_c",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->controlled_pipeline_head_speed,	NULL);
-	ide_add_setting(drive,	"pipeline_head_speed_u",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->uncontrolled_pipeline_head_speed,NULL);
+	ide_add_setting(drive, "pipeline_head_speed_c", SETTING_READ, TYPE_INT,
+			0, 0xffff, 1, 1, &tape->pipe_ctl_hspeed, NULL);
+	ide_add_setting(drive, "pipeline_head_speed_u", SETTING_READ, TYPE_INT,
+			0, 0xffff, 1, 1, &tape->unctl_pipe_hspeed, NULL);
 	ide_add_setting(drive,	"avg_speed",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->avg_speed,			NULL);
 	ide_add_setting(drive,	"debug_level",		SETTING_RW,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->debug_level,			NULL);
 }
@@ -3647,7 +3630,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	struct sysinfo si;
 	u16 *ctl = (u16 *)&tape->caps[12];
 
-	spin_lock_init(&tape->spinlock);
+	spin_lock_init(&tape->que_lock);
 	drive->dsc_overlap = 1;
 	if (drive->hwif->host_flags & IDE_HFLAG_NO_DSC) {
 		printk(KERN_INFO "ide-tape: %s: disabling DSC overlap\n",
@@ -3661,10 +3644,10 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->name[0] = 'h';
 	tape->name[1] = 't';
 	tape->name[2] = '0' + minor;
-	tape->chrdev_direction = idetape_dir_none;
+	tape->chrdev_dir = idetape_dir_none;
 	tape->pc = tape->pc_stack;
-	tape->max_insert_speed = 10000;
-	tape->speed_control = 1;
+	tape->max_ins_speed = 10000;
+	tape->speed_ctl = 1;
 	*((unsigned short *) &gcw) = drive->id->config;
 	if (gcw.drq_type == 1)
 		set_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags);
@@ -3675,11 +3658,11 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	idetape_get_mode_sense_results(drive);
 	ide_tape_get_bsize_from_bdesc(drive);
 	tape->user_bs_factor = 1;
-	tape->stage_size = *ctl * tape->tape_block_size;
+	tape->stage_size = *ctl * tape->blk_sz;
 	while (tape->stage_size > 0xffff) {
 		printk(KERN_NOTICE "ide-tape: decreasing stage size\n");
 		*ctl /= 2;
-		tape->stage_size = *ctl * tape->tape_block_size;
+		tape->stage_size = *ctl * tape->blk_sz;
 	}
 	stage_size = tape->stage_size;
 	tape->pages_per_stage = stage_size / PAGE_SIZE;
@@ -3718,14 +3701,16 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	 *	Ensure that the number we got makes sense; limit
 	 *	it within IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
 	 */
-	tape->best_dsc_rw_frequency = max_t(unsigned long, min_t(unsigned long, t, IDETAPE_DSC_RW_MAX), IDETAPE_DSC_RW_MIN);
+	tape->best_dsc_rw_freq = max_t(ulong,
+			min_t(ulong, t, IDETAPE_DSC_RW_MAX),
+			IDETAPE_DSC_RW_MIN);
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
 		"%dkB pipeline, %lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
 		(*(u16 *)&tape->caps[16] * 512) / tape->stage_size,
 		tape->stage_size / 1024,
 		tape->max_stages * tape->stage_size / 1024,
-		tape->best_dsc_rw_frequency * 1000 / HZ,
+		tape->best_dsc_rw_freq * 1000 / HZ,
 		drive->using_dma ? ", DMA":"");
 
 	idetape_add_settings(drive);
@@ -3748,7 +3733,7 @@ static void ide_tape_release(struct kref *kref)
 	ide_drive_t *drive = tape->drive;
 	struct gendisk *g = tape->disk;
 
-	BUG_ON(tape->first_stage != NULL || tape->merge_stage_size);
+	BUG_ON(tape->first_stage != NULL || tape->merge_stage_sz);
 
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
-- 
1.5.3.7


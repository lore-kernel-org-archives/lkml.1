Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbYCIRNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbYCIRNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYCIRKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:10:41 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:9332 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbYCIRKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:10:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=pI2QO9jqrJMtm7ll8YxUlEGbxZY5L2pE1ThJZmW2k99gfniPbO0mhiPhykD2kt3ggrbwAOuI42vPq4xZPbXGM43yvX6XNoe62E3UAHbbT/A3OUwdym7j/1bL9zgNECIcJsVr4lkk93JRdXbflvc9FogkmjNcS/MZiIT0qssxlz8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 3/4] ide-tape remove pipeline speed/control calculations
Date: Sun,  9 Mar 2008 18:10:31 +0100
Message-Id: <1205082632-3418-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205082632-3418-1-git-send-email-petkovbb@gmail.com>
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pipeline handling calculations in idetape_calculate_speeds() can
go since they do not have any effect on other functionality besides:

1. info is only being exported through /proc as a read-only item
(controlled_pipeline_head_speed, uncontrolled_pipeline_head_speed)

2. used in idetape_restart_speed_control() which, in turn, is unrelated to
other code

3. used only for pipeline frames number accounting (tape->pipeline_head),
also unused elsewhere.

4.some variables are:
        only written to: tape->buffer_head;
        unused: tape->tape_head, tape->last_tape_head

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  131 ------------------------------------------------
 1 files changed, 0 insertions(+), 131 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 46a5f95..a06d83f 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -84,9 +84,6 @@ enum {
  * We start from MIN maximum stages (we will not even use MIN stages if we don't
  * need them), increment it by RATE*(MAX-MIN) whenever we sense that the
  * pipeline is empty, until we reach the optimum value or until we reach MAX.
- *
- * Setting the following parameter to 0 is illegal: the pipelined mode cannot be
- * disabled (idetape_calculate_speeds() divides by tape->max_stages.)
  */
 #define IDETAPE_MIN_PIPELINE_STAGES	  1
 #define IDETAPE_MAX_PIPELINE_STAGES	400
@@ -392,39 +389,12 @@ typedef struct ide_tape_obj {
 	 */
 	int postpone_cnt;
 
-	/*
-	 * Measures number of frames:
-	 *
-	 * 1. written/read to/from the driver pipeline (pipeline_head).
-	 * 2. written/read to/from the tape buffers (idetape_bh).
-	 * 3. written/read by the tape to/from the media (tape_head).
-	 */
-	int pipeline_head;
-	int buffer_head;
-	int tape_head;
-	int last_tape_head;
-
 	/* Speed control at the tape buffers input/output */
 	unsigned long insert_time;
 	int insert_size;
 	int insert_speed;
-	int max_insert_speed;
 	int measure_insert_time;
 
-	/* Speed regulation negative feedback loop */
-	int speed_control;
-	int pipeline_head_speed;
-	int controlled_pipeline_head_speed;
-	int uncontrolled_pipeline_head_speed;
-	int controlled_last_pipeline_head;
-	unsigned long uncontrolled_pipeline_head_time;
-	unsigned long controlled_pipeline_head_time;
-	int controlled_previous_pipeline_head;
-	int uncontrolled_previous_pipeline_head;
-	unsigned long controlled_previous_head_time;
-	unsigned long uncontrolled_previous_head_time;
-	int restart_speed_control_req;
-
 	u32 debug_mask;
 } idetape_tape_t;
 
@@ -1333,69 +1303,6 @@ static void idetape_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_calculate_speeds(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	if (time_after(jiffies,
-			tape->controlled_pipeline_head_time + 120 * HZ)) {
-		tape->controlled_previous_pipeline_head =
-			tape->controlled_last_pipeline_head;
-		tape->controlled_previous_head_time =
-			tape->controlled_pipeline_head_time;
-		tape->controlled_last_pipeline_head = tape->pipeline_head;
-		tape->controlled_pipeline_head_time = jiffies;
-	}
-	if (time_after(jiffies, tape->controlled_pipeline_head_time + 60 * HZ))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head -
-				tape->controlled_last_pipeline_head) * 32 * HZ /
-				(jiffies - tape->controlled_pipeline_head_time);
-	else if (time_after(jiffies, tape->controlled_previous_head_time))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head -
-				tape->controlled_previous_pipeline_head) * 32 *
-			HZ / (jiffies - tape->controlled_previous_head_time);
-
-	if (tape->nr_pending_stages < tape->max_stages/*- 1 */) {
-		/* -1 for read mode error recovery */
-		if (time_after(jiffies, tape->uncontrolled_previous_head_time +
-					10 * HZ)) {
-			tape->uncontrolled_pipeline_head_time = jiffies;
-			tape->uncontrolled_pipeline_head_speed =
-				(tape->pipeline_head -
-				 tape->uncontrolled_previous_pipeline_head) *
-				32 * HZ / (jiffies -
-					tape->uncontrolled_previous_head_time);
-		}
-	} else {
-		tape->uncontrolled_previous_head_time = jiffies;
-		tape->uncontrolled_previous_pipeline_head = tape->pipeline_head;
-		if (time_after(jiffies, tape->uncontrolled_pipeline_head_time +
-					30 * HZ))
-			tape->uncontrolled_pipeline_head_time = jiffies;
-
-	}
-	tape->pipeline_head_speed = max(tape->uncontrolled_pipeline_head_speed,
-					tape->controlled_pipeline_head_speed);
-
-	if (tape->speed_control == 1) {
-		if (tape->nr_pending_stages >= tape->max_stages / 2)
-			tape->max_insert_speed = tape->pipeline_head_speed +
-				(1100 - tape->pipeline_head_speed) * 2 *
-				(tape->nr_pending_stages - tape->max_stages / 2)
-				/ tape->max_stages;
-		else
-			tape->max_insert_speed = 500 +
-				(tape->pipeline_head_speed - 500) * 2 *
-				tape->nr_pending_stages / tape->max_stages;
-
-		if (tape->nr_pending_stages >= tape->max_stages * 99 / 100)
-			tape->max_insert_speed = 5000;
-	} else
-		tape->max_insert_speed = tape->speed_control;
-
-	tape->max_insert_speed = max(tape->max_insert_speed, 500);
-}
-
 static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -1548,7 +1455,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	if (time_after(jiffies, tape->insert_time))
 		tape->insert_speed = tape->insert_size / 1024 * HZ /
 					(jiffies - tape->insert_time);
-	idetape_calculate_speeds(drive);
 	if (!test_and_clear_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
@@ -1572,7 +1478,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		return ide_stopped;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_READ) {
-		tape->buffer_head++;
 		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
 		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors,
@@ -1580,7 +1485,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
-		tape->buffer_head++;
 		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
 		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors,
@@ -2312,24 +2216,6 @@ static void idetape_empty_write_pipeline(ide_drive_t *drive)
 	}
 }
 
-static void idetape_restart_speed_control(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	tape->restart_speed_control_req = 0;
-	tape->pipeline_head = 0;
-	tape->controlled_last_pipeline_head = 0;
-	tape->controlled_previous_pipeline_head = 0;
-	tape->uncontrolled_previous_pipeline_head = 0;
-	tape->controlled_pipeline_head_speed = 5000;
-	tape->pipeline_head_speed = 5000;
-	tape->uncontrolled_pipeline_head_speed = 0;
-	tape->controlled_pipeline_head_time =
-		tape->uncontrolled_pipeline_head_time = jiffies;
-	tape->controlled_previous_head_time =
-		tape->uncontrolled_previous_head_time = jiffies;
-}
-
 static int idetape_init_read(ide_drive_t *drive, int max_stages)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -2372,8 +2258,6 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 			}
 		}
 	}
-	if (tape->restart_speed_control_req)
-		idetape_restart_speed_control(drive);
 	idetape_init_rq(&rq, REQ_IDETAPE_READ);
 	rq.sector = tape->first_frame;
 	rq.nr_sectors = blocks;
@@ -2442,8 +2326,6 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 		spin_lock_irqsave(&tape->lock, flags);
 		idetape_remove_stage_head(drive);
 		spin_unlock_irqrestore(&tape->lock, flags);
-		tape->pipeline_head++;
-		idetape_calculate_speeds(drive);
 	}
 	if (bytes_read > blocks * tape->blk_size) {
 		printk(KERN_ERR "ide-tape: bug: trying to return more bytes"
@@ -2778,8 +2660,6 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	}
 	if (count == 0)
 		return (0);
-	if (tape->restart_speed_control_req)
-		idetape_restart_speed_control(drive);
 	if (tape->merge_stage_size) {
 		if (tape->merge_stage_size >= tape->stage_size) {
 			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
@@ -2988,7 +2868,6 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 
 	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
 
-	tape->restart_speed_control_req = 1;
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
 		idetape_empty_write_pipeline(drive);
 		idetape_flush_tape_buffers(drive);
@@ -3131,8 +3010,6 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 			}
 		}
 	}
-	idetape_restart_speed_control(drive);
-	tape->restart_speed_control_req = 0;
 	return 0;
 
 out_put_tape:
@@ -3335,12 +3212,6 @@ static void idetape_add_settings(ide_drive_t *drive)
 			NULL);
 	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1,
 			1, &drive->dsc_overlap, NULL);
-	ide_add_setting(drive, "pipeline_head_speed_c", SETTING_READ, TYPE_INT,
-			0, 0xffff, 1, 1, &tape->controlled_pipeline_head_speed,
-			NULL);
-	ide_add_setting(drive, "pipeline_head_speed_u", SETTING_READ, TYPE_INT,
-			0, 0xffff, 1, 1,
-			&tape->uncontrolled_pipeline_head_speed, NULL);
 	ide_add_setting(drive, "avg_speed", SETTING_READ, TYPE_INT, 0, 0xffff,
 			1, 1, &tape->avg_speed, NULL);
 	ide_add_setting(drive, "debug_mask", SETTING_RW, TYPE_INT, 0, 0xffff, 1,
@@ -3386,8 +3257,6 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->name[2] = '0' + minor;
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 	tape->pc = tape->pc_stack;
-	tape->max_insert_speed = 10000;
-	tape->speed_control = 1;
 	*((unsigned short *) &gcw) = drive->id->config;
 
 	/* Command packet DRQ type */
-- 
1.5.4.1


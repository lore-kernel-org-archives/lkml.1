Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbYA0J6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbYA0J6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbYA0Jt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:59 -0500
Received: from [212.23.103.76] ([212.23.103.76]:59288 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757233AbYA0Jtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:55 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 24/32] ide-tape: remove unreachable code chunk
Date: Sun, 27 Jan 2008 10:48:12 +0100
Message-Id: <1201427300-3954-19-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

tape->speed_ctl is set to 1 in idetape_setup(), but, in calculate_speeds() its
value is tested for being 0, 1, or 2. Remove the if-branches where
tape->speed_ctl != 1 since they are never executed.

Also, rename calculate_speeds() by adding driver's prefix as is with the other
function names.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 31edb0c..eab552e 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -61,7 +61,8 @@
  *	the optimum value or until we reach MAX.
  *
  *	Setting the following parameter to 0 is illegal: the pipelined mode
- *	cannot be disabled (calculate_speeds() divides by tape->max_stages.)
+ *	cannot be disabled (idetape_calculate_speeds() divides by
+ *	tape->max_stages.)
  */
 #define IDETAPE_MIN_PIPELINE_STAGES	  1
 #define IDETAPE_MAX_PIPELINE_STAGES	400
@@ -1462,10 +1463,9 @@ static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
 	pc->callback = &idetape_pc_callback;
 }
 
-static void calculate_speeds(ide_drive_t *drive)
+static void idetape_calculate_speeds(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	int full = 125, empty = 75;
 
 	if (time_after(jiffies, tape->ctl_pipe_htime + 120 * HZ)) {
 		tape->ctl_prev_pipe_h = tape->ctl_last_pipe_h;
@@ -1497,9 +1497,8 @@ static void calculate_speeds(ide_drive_t *drive)
 			tape->unctl_pipe_htime = jiffies;
 	}
 	tape->pipe_hspeed = max(tape->unctl_pipe_hspeed, tape->pipe_ctl_hspeed);
-	if (tape->speed_ctl == 0) {
-		tape->max_ins_speed = 5000;
-	} else if (tape->speed_ctl == 1) {
+
+	if (tape->speed_ctl == 1) {
 		if (tape->nr_pending_stages >= tape->max_stages / 2)
 			tape->max_ins_speed = tape->pipe_hspeed +
 				(1100 - tape->pipe_hspeed) * 2 *
@@ -1511,13 +1510,9 @@ static void calculate_speeds(ide_drive_t *drive)
 				tape->nr_pending_stages / tape->max_stages;
 		if (tape->nr_pending_stages >= tape->max_stages * 99 / 100)
 			tape->max_ins_speed = 5000;
-	} else if (tape->speed_ctl == 2) {
-		tape->max_ins_speed = tape->pipe_hspeed * empty / 100 +
-			(tape->pipe_hspeed * full / 100 - tape->pipe_hspeed *
-			 empty / 100) * tape->nr_pending_stages
-			/ tape->max_stages;
 	} else
 		tape->max_ins_speed = tape->speed_ctl;
+
 	tape->max_ins_speed = max(tape->max_ins_speed, 500);
 }
 
@@ -1696,7 +1691,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	if (time_after(jiffies, tape->ins_time))
 		tape->ins_speed = tape->ins_size / 1024 * HZ /
 			(jiffies - tape->ins_time);
-	calculate_speeds(drive);
+	idetape_calculate_speeds(drive);
 	if (!test_and_clear_bit(IDETAPE_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
@@ -2416,7 +2411,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	idetape_switch_buffers(tape, new_stage);
 	idetape_add_stage_tail(drive, new_stage);
 	tape->pipeline_head++;
-	calculate_speeds(drive);
+	idetape_calculate_speeds(drive);
 
 	/*
 	 *	Estimate whether the tape has stopped writing by checking
@@ -2658,7 +2653,7 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 		idetape_remove_stage_head(drive);
 		spin_unlock_irqrestore(&tape->que_lock, flags);
 		tape->pipeline_head++;
-		calculate_speeds(drive);
+		idetape_calculate_speeds(drive);
 	}
 	if (bytes_read > blocks * tape->blk_sz) {
 		printk(KERN_ERR "ide-tape: bug: trying to return more bytes than requested\n");
-- 
1.5.3.7


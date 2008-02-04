Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbYBDNnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbYBDNnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbYBDNmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:17 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:3718 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbYBDNmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Qn2Cd6paneOCATHiHnhw7ZxJnl0OHKAkUTVmO7+xgXOyxasmSjXEHX5xnIxOZelSsBuZDyrSm1B1ba7CY1rXnoByHA8uvJKGZwLm5c6nIAzyeI5952vAVh5DBr5VCTrrbRe4bimuuGwhTcTYXxcwMfQRzAgkMn9uBvzSTxP3Stg=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 03/22] ide-tape: remove unreachable code chunk
Date: Mon,  4 Feb 2008 14:40:21 +0100
Message-Id: <1202132440-26648-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tape->speed_control is set to 1 in idetape_setup(), but, in calculate_speeds()
its value is tested for being 0, 1, or 2. Remove the if-branches where
tape->speed_control != 1 since they are never executed. Also, rename
calculate_speeds() by adding driver's prefix as is with the other function names.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index c8c57ab..b15dd17 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -87,7 +87,8 @@ enum {
  *	the optimum value or until we reach MAX.
  *
  *	Setting the following parameter to 0 is illegal: the pipelined mode
- *	cannot be disabled (calculate_speeds() divides by tape->max_stages.)
+ *	cannot be disabled (idetape_calculate_speeds() divides by
+ *	tape->max_stages.)
  */
 #define IDETAPE_MIN_PIPELINE_STAGES	  1
 #define IDETAPE_MAX_PIPELINE_STAGES	400
@@ -1475,10 +1476,9 @@ static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
 	pc->callback = &idetape_pc_callback;
 }
 
-static void calculate_speeds(ide_drive_t *drive)
+static void idetape_calculate_speeds(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	int full = 125, empty = 75;
 
 	if (time_after(jiffies, tape->controlled_pipeline_head_time + 120 * HZ)) {
 		tape->controlled_previous_pipeline_head = tape->controlled_last_pipeline_head;
@@ -1505,22 +1505,20 @@ static void calculate_speeds(ide_drive_t *drive)
 		}
 	}
 	tape->pipeline_head_speed = max(tape->uncontrolled_pipeline_head_speed, tape->controlled_pipeline_head_speed);
-	if (tape->speed_control == 0) {
-		tape->max_insert_speed = 5000;
-	} else if (tape->speed_control == 1) {
+
+	if (tape->speed_control == 1) {
 		if (tape->nr_pending_stages >= tape->max_stages / 2)
 			tape->max_insert_speed = tape->pipeline_head_speed +
 				(1100 - tape->pipeline_head_speed) * 2 * (tape->nr_pending_stages - tape->max_stages / 2) / tape->max_stages;
 		else
 			tape->max_insert_speed = 500 +
 				(tape->pipeline_head_speed - 500) * 2 * tape->nr_pending_stages / tape->max_stages;
+
 		if (tape->nr_pending_stages >= tape->max_stages * 99 / 100)
 			tape->max_insert_speed = 5000;
-	} else if (tape->speed_control == 2) {
-		tape->max_insert_speed = tape->pipeline_head_speed * empty / 100 +
-			(tape->pipeline_head_speed * full / 100 - tape->pipeline_head_speed * empty / 100) * tape->nr_pending_stages / tape->max_stages;
 	} else
 		tape->max_insert_speed = tape->speed_control;
+
 	tape->max_insert_speed = max(tape->max_insert_speed, 500);
 }
 
@@ -1697,7 +1695,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		tape->measure_insert_time = 1;
 	if (time_after(jiffies, tape->insert_time))
 		tape->insert_speed = tape->insert_size / 1024 * HZ / (jiffies - tape->insert_time);
-	calculate_speeds(drive);
+	idetape_calculate_speeds(drive);
 	if (!test_and_clear_bit(IDETAPE_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
@@ -2419,7 +2417,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	idetape_switch_buffers(tape, new_stage);
 	idetape_add_stage_tail(drive, new_stage);
 	tape->pipeline_head++;
-	calculate_speeds(drive);
+	idetape_calculate_speeds(drive);
 
 	/*
 	 *	Estimate whether the tape has stopped writing by checking
@@ -2659,7 +2657,7 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 		idetape_remove_stage_head(drive);
 		spin_unlock_irqrestore(&tape->spinlock, flags);
 		tape->pipeline_head++;
-		calculate_speeds(drive);
+		idetape_calculate_speeds(drive);
 	}
 	if (bytes_read > blocks * tape->tape_block_size) {
 		printk(KERN_ERR "ide-tape: bug: trying to return more bytes than requested\n");
-- 
1.5.3.7


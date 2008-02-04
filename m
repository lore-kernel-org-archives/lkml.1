Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbYBDNrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbYBDNrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:47:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYBDNmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:5818 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbYBDNmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Q9Q+5vQr0GYgQGzTXtVeVuVuhbwkYYCC4I5TOmscw7ti3eOxwaV1uzesTIIP5mOJHvCIGbFJ5JzfUMxjm9KzDEcDMnkzY7zTMuRVVfeU5u8Hb0oSG0TqTABL14dZexWkcqln9AkpXFZJYEL8z0kcTz6PIrvf5C7wQkaDg96FqdE=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 10/22] ide-tape: shorten some function names
Date: Mon,  4 Feb 2008 14:40:28 +0100
Message-Id: <1202132440-26648-11-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index ae2c76d..4fee160 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1053,7 +1053,7 @@ static void idetape_postpone_request (ide_drive_t *drive)
  * command. We will transfer some of the data (as requested by the drive) and
  * will re-point interrupt handler to us. When data transfer is finished, we
  * will act according to the algorithm described before
- * idetape_issue_packet_command.
+ * idetape_issue_pc.
  */
 
 typedef void idetape_io_buf(ide_drive_t *, idetape_pc_t *, unsigned int);
@@ -1233,7 +1233,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
  *
  *	The handling will be done in three stages:
  *
- *	1.	idetape_issue_packet_command will send the packet command to the
+ *	1.	idetape_issue_pc will send the packet command to the
  *		drive, and will set the interrupt handler to idetape_pc_intr.
  *
  *	2.	On each interrupt, idetape_pc_intr will be called. This step
@@ -1308,7 +1308,7 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	return ide_started;
 }
 
-static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape_pc_t *pc)
+static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
@@ -1614,7 +1614,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	 */
 	if (tape->failed_pc != NULL &&
 	    tape->pc->c[0] == REQUEST_SENSE) {
-		return idetape_issue_packet_command(drive, tape->failed_pc);
+		return idetape_issue_pc(drive, tape->failed_pc);
 	}
 	if (postponed_rq != NULL)
 		if (rq != postponed_rq) {
@@ -1707,7 +1707,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 	BUG();
 out:
-	return idetape_issue_packet_command(drive, pc);
+	return idetape_issue_pc(drive, pc);
 
 err:
 	printk(KERN_ERR "ide-tape: Error processing request %u\n", rq->cmd[0]);
@@ -2263,11 +2263,8 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 	return (tape->blk_size * (blocks-rq.current_nr_sectors));
 }
 
-/*
- *	idetape_insert_pipeline_into_queue is used to start servicing the
- *	pipeline stages, starting from tape->next_stage.
- */
-static void idetape_insert_pipeline_into_queue (ide_drive_t *drive)
+/* start servicing the pipeline stages, starting from tape->next_stage. */
+static void idetape_plug_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -2359,7 +2356,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 			spin_unlock_irqrestore(&tape->lock, flags);
 		} else {
 			spin_unlock_irqrestore(&tape->lock, flags);
-			idetape_insert_pipeline_into_queue(drive);
+			idetape_plug_pipeline(drive);
 			if (idetape_pipeline_active(tape))
 				continue;
 			/*
@@ -2396,7 +2393,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 			tape->insert_time = jiffies;
 			tape->insert_size = 0;
 			tape->insert_speed = 0;
-			idetape_insert_pipeline_into_queue(drive);
+			idetape_plug_pipeline(drive);
 		}
 	}
 	if (test_and_clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
@@ -2415,7 +2412,7 @@ static void idetape_wait_for_pipeline (ide_drive_t *drive)
 	unsigned long flags;
 
 	while (tape->next_stage || idetape_pipeline_active(tape)) {
-		idetape_insert_pipeline_into_queue(drive);
+		idetape_plug_pipeline(drive);
 		spin_lock_irqsave(&tape->lock, flags);
 		if (idetape_pipeline_active(tape))
 			idetape_wait_for_request(drive, tape->active_data_rq);
@@ -2508,7 +2505,7 @@ static void idetape_restart_speed_control (ide_drive_t *drive)
 	tape->controlled_previous_head_time = tape->uncontrolled_previous_head_time = jiffies;
 }
 
-static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
+static int idetape_init_read(ide_drive_t *drive, int max_stages)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *new_stage;
@@ -2569,7 +2566,7 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 			tape->insert_time = jiffies;
 			tape->insert_size = 0;
 			tape->insert_speed = 0;
-			idetape_insert_pipeline_into_queue(drive);
+			idetape_plug_pipeline(drive);
 		}
 	}
 	return 0;
@@ -2599,7 +2596,7 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 	 * Wait for the next block to be available at the head
 	 * of the pipeline
 	 */
-	idetape_initiate_read(drive, tape->max_stages);
+	idetape_init_read(drive, tape->max_stages);
 	if (tape->first_stage == NULL) {
 		if (test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
 			return 0;
@@ -2862,7 +2859,8 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
 	}
-	if ((rc = idetape_initiate_read(drive, tape->max_stages)) < 0)
+	rc = idetape_init_read(drive, tape->max_stages);
+	if (rc < 0)
 		return rc;
 	if (count == 0)
 		return (0);
-- 
1.5.3.7


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762521AbYCAJDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762521AbYCAJDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbYCAI7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:6285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbYCAI7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=pqSHc0vV90DfQOyR4EGpto4mymMsS6vVgFJt06d0NzF6JjKZ30uCMyeOjvUOhMSRQKxD2sStv+jQF0ax3pHj24nQGdZ7i6e5W1thyVFPu2m9BRPYECz4DXzLVYPsxy8wH07iU3WdW8wHy/5HzH8UW8Rj6uYG0U5ddoG8xLzsoVc=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 13/24] ide-tape: remove pipeline-specific code from idetape_chrdev_release
Date: Sat,  1 Mar 2008 09:58:37 +0100
Message-Id: <1204361928-30229-14-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, remove orphaned functions idetape_{discard_read,plug,wait_for}_pipeline.
Furthermore, tape->cache_stage becomes also unused, so remove it too. Finally,
simplify 4-level-nested if-condition into a single compound one in
idetape_chrdev_release().

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   78 +++++-------------------------------------------
 1 files changed, 8 insertions(+), 70 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3e80515..3cb6e3d 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -366,7 +366,6 @@ typedef struct ide_tape_obj {
 	/* New requests will be added to the pipeline here */
 	idetape_stage_t *last_stage;
 	/* Optional free stage which we can use */
-	idetape_stage_t *cache_stage;
 	int pages_per_stage;
 	/* Wasted space in each stage */
 	int excess_bh_size;
@@ -2045,25 +2044,6 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 	return (idetape_queue_pc_tail(drive, &pc));
 }
 
-static void idetape_discard_read_pipeline(ide_drive_t *drive,
-					  int restore_position)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	int cnt;
-	int seek, position;
-
-	cnt = __idetape_discard_read_pipeline(drive);
-	if (restore_position) {
-		position = idetape_read_position(drive);
-		seek = position > cnt ? position - cnt : 0;
-		if (idetape_position_tape(drive, seek, 0, 0)) {
-			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
-					 " discard_pipeline()\n", tape->name);
-			return;
-		}
-	}
-}
-
 /*
  * Generate a read/write request for the block device interface and wait for it
  * to be serviced.
@@ -2093,19 +2073,6 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
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
@@ -2154,25 +2121,6 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 					tape->merge_stage->bh);
 }
 
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
-}
-
 static void idetape_restart_speed_control(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -2875,26 +2823,16 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		idetape_write_release(drive, minor);
-	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
-		if (minor < 128)
-			idetape_discard_read_pipeline(drive, 1);
-		else
-			idetape_wait_for_pipeline(drive);
-	}
-	if (tape->cache_stage != NULL) {
-		__idetape_kfree_stage(tape->cache_stage);
-		tape->cache_stage = NULL;
-	}
+
 	if (minor < 128 && test_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags))
 		(void) idetape_rewind_tape(drive);
-	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
-		if (tape->door_locked == DOOR_LOCKED) {
-			if (idetape_create_prevent_cmd(drive, &pc, 0)) {
-				if (!idetape_queue_pc_tail(drive, &pc))
-					tape->door_locked = DOOR_UNLOCKED;
-			}
-		}
-	}
+
+	if (tape->chrdev_dir == IDETAPE_DIR_NONE &&
+	    tape->door_locked == DOOR_LOCKED &&
+	    idetape_create_prevent_cmd(drive, &pc, 0) &&
+	    !idetape_queue_pc_tail(drive, &pc))
+		tape->door_locked = DOOR_UNLOCKED;
+
 	clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
 	ide_tape_put(tape);
 	unlock_kernel();
-- 
1.5.4.1


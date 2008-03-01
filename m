Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYCAJGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYCAJGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbYCAI7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:65331 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634AbYCAI7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=pHP0zWbcI9nlJwaZAk6dS0xENlGgllzUKYvRWigmejjP+/8kPu0NCp3IAfPzQZxZhanQ2oJXw9uf619g2yT4kJIFhUH27x9GBUs+XSbEhoiac/RVX0DR3kpmRSCbxRMhkL4lPYJQYwyH6a4hWCnHbHTlcEfGV4BzR7P9cvVGhsM=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 17/24] ide-tape: remove pipeline-specific code from idetape_chrdev_open
Date: Sat,  1 Mar 2008 09:58:41 +0100
Message-Id: <1204361928-30229-18-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a result, remove orphaned idetape_restart_speed_control. Also, unnest
if-condition in idetape_chrdev_open.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   38 ++++++--------------------------------
 1 files changed, 6 insertions(+), 32 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index cfc11bb..5f57bdb 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -424,7 +424,6 @@ typedef struct ide_tape_obj {
 	int uncontrolled_previous_pipeline_head;
 	unsigned long controlled_previous_head_time;
 	unsigned long uncontrolled_previous_head_time;
-	int restart_speed_control_req;
 
 	u32 debug_mask;
 } idetape_tape_t;
@@ -1838,24 +1837,6 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 					tape->merge_stage->bh);
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
 static int idetape_init_read(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -2470,9 +2451,6 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	if (!test_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags))
 		(void)idetape_rewind_tape(drive);
 
-	if (tape->chrdev_dir != IDETAPE_DIR_READ)
-		clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
-
 	/* Read block size and write protect status from drive. */
 	ide_tape_get_bsize_from_bdesc(drive);
 
@@ -2493,16 +2471,12 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	}
 
 	/* Lock the tape drive door so user can't eject. */
-	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
-		if (idetape_create_prevent_cmd(drive, &pc, 1)) {
-			if (!idetape_queue_pc_tail(drive, &pc)) {
-				if (tape->door_locked != DOOR_EXPLICITLY_LOCKED)
-					tape->door_locked = DOOR_LOCKED;
-			}
-		}
-	}
-	idetape_restart_speed_control(drive);
-	tape->restart_speed_control_req = 0;
+	if (tape->chrdev_dir == IDETAPE_DIR_NONE &&
+	    idetape_create_prevent_cmd(drive, &pc, 1) &&
+	    !idetape_queue_pc_tail(drive, &pc) &&
+	    tape->door_locked != DOOR_EXPLICITLY_LOCKED)
+		tape->door_locked = DOOR_LOCKED;
+
 	return 0;
 
 out_put_tape:
-- 
1.5.4.1


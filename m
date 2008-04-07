Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYDGEqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYDGEqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 00:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYDGEpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 00:45:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:37456 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYDGEot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 00:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=N6yxNErQDU4woK5VRieVJ+MHd0kMSC2sfAOQgiVrHnFjTqfnDA9cl0ynOXTyU7uEoQfqaeE8Tgtl0TupJJufXKFTKMKKKESaY+JNhA2gJFa2pucFu1K6q7ns9V024MRYzUFPrAesmoMY0vOIEhd4gyR8P4M2RU5LFXTstWk2fSc=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/6] ide-tape: mv idetape_discard_read_pipeline ide_tape_discard_merge_buffer
Date: Mon,  7 Apr 2008 06:45:00 +0200
Message-Id: <1207543504-27888-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
References: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, rename its __-low level helper too.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 0cd0684..ecc11c1 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1641,7 +1641,7 @@ static int idetape_create_prevent_cmd(ide_drive_t *drive,
 	return 1;
 }
 
-static void __idetape_discard_read_pipeline(ide_drive_t *drive)
+static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -1672,7 +1672,7 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 	struct ide_atapi_pc pc;
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ)
-		__idetape_discard_read_pipeline(drive);
+		__ide_tape_discard_merge_buffer(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
 	retval = idetape_queue_pc_tail(drive, &pc);
@@ -1683,19 +1683,19 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 	return (idetape_queue_pc_tail(drive, &pc));
 }
 
-static void idetape_discard_read_pipeline(ide_drive_t *drive,
+static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
 					  int restore_position)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int seek, position;
 
-	__idetape_discard_read_pipeline(drive);
+	__ide_tape_discard_merge_buffer(drive);
 	if (restore_position) {
 		position = idetape_read_position(drive);
 		seek = position > 0 ? position : 0;
 		if (idetape_position_tape(drive, seek, 0, 0)) {
 			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
-					 " discard_pipeline()\n", tape->name);
+					 " %s\n", tape->name, __func__);
 			return;
 		}
 	}
@@ -1996,7 +1996,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 		tape->merge_stage_size = 0;
 		if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 			++count;
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 	}
 
 	/*
@@ -2121,7 +2121,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	/* Initialize write operation */
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
 		if (tape->chrdev_dir == IDETAPE_DIR_READ)
-			idetape_discard_read_pipeline(drive, 1);
+			ide_tape_discard_merge_buffer(drive, 1);
 		if (tape->merge_stage || tape->merge_stage_size) {
 			printk(KERN_ERR "ide-tape: merge_stage_size "
 				"should be 0 now\n");
@@ -2246,7 +2246,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 	case MTWEOF:
 		if (tape->write_prot)
 			return -EACCES;
-		idetape_discard_read_pipeline(drive, 1);
+		ide_tape_discard_merge_buffer(drive, 1);
 		for (i = 0; i < mt_count; i++) {
 			retval = idetape_write_filemark(drive);
 			if (retval)
@@ -2254,12 +2254,12 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		}
 		return 0;
 	case MTREW:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		if (idetape_rewind_tape(drive))
 			return -EIO;
 		return 0;
 	case MTLOAD:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 					       IDETAPE_LU_LOAD_MASK);
 		return idetape_queue_pc_tail(drive, &pc);
@@ -2274,7 +2274,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 				if (!idetape_queue_pc_tail(drive, &pc))
 					tape->door_locked = DOOR_UNLOCKED;
 		}
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 					      !IDETAPE_LU_LOAD_MASK);
 		retval = idetape_queue_pc_tail(drive, &pc);
@@ -2282,10 +2282,10 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			clear_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
 		return retval;
 	case MTNOP:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		return idetape_flush_tape_buffers(drive);
 	case MTRETEN:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
 		return idetape_queue_pc_tail(drive, &pc);
@@ -2307,11 +2307,11 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			set_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
 		return 0;
 	case MTSEEK:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		return idetape_position_tape(drive,
 			mt_count * tape->user_bs_factor, tape->partition, 0);
 	case MTSETPART:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		return idetape_position_tape(drive, 0, mt_count, 0);
 	case MTFSR:
 	case MTBSR:
@@ -2393,7 +2393,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 		return 0;
 	default:
 		if (tape->chrdev_dir == IDETAPE_DIR_READ)
-			idetape_discard_read_pipeline(drive, 1);
+			ide_tape_discard_merge_buffer(drive, 1);
 		return idetape_blkdev_ioctl(drive, cmd, arg);
 	}
 }
@@ -2535,7 +2535,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 		idetape_write_release(drive, minor);
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		if (minor < 128)
-			idetape_discard_read_pipeline(drive, 1);
+			ide_tape_discard_merge_buffer(drive, 1);
 	}
 
 	if (minor < 128 && test_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags))
-- 
1.5.4.1


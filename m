Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYBDNnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYBDNnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbYBDNmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:27420 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbYBDNmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=nDmOyRF0JAJnthUk+0OCOf3NALo5ZVub6xKsTbXS3sY4eMfipcMIlztJiOpQfhtXO3XdtqtJKO2BO/ClXhZs+7XBibs+3mOtIKTjuBvEa+mdepysGYO7g2QEMY1YdrIDSP93U2KqIF8SVR/O/mlT6tALwg6r7ibaJ5r7YuYN8BE=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 05/22] ide-tape: remove typedef idetape_chrdev_direction_t
Date: Mon,  4 Feb 2008 14:40:23 +0100
Message-Id: <1202132440-26648-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. and replace it with plain enums.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   62 ++++++++++++++++++++++++-----------------------
 1 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 2857965..e0e8184 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -184,11 +184,13 @@ enum {
 /*
  *	For general magnetic tape device compatibility.
  */
-typedef enum {
-	idetape_direction_none,
-	idetape_direction_read,
-	idetape_direction_write
-} idetape_chrdev_direction_t;
+
+/* tape directions */
+enum {
+	IDETAPE_DIR_NONE  = (1 << 0),
+	IDETAPE_DIR_READ  = (1 << 1),
+	IDETAPE_DIR_WRITE = (1 << 2),
+};
 
 struct idetape_bh {
 	u32 b_size;
@@ -324,7 +326,7 @@ typedef struct ide_tape_obj {
 	/* device name */
 	char name[4];
 	/* Current character device data transfer direction */
-	idetape_chrdev_direction_t chrdev_direction;
+	u8 chrdev_dir;
 
 	/*
 	 *	Device information
@@ -1916,7 +1918,7 @@ static void idetape_init_merge_stage (idetape_tape_t *tape)
 	struct idetape_bh *bh = tape->merge_stage->bh;
 	
 	tape->bh = bh;
-	if (tape->chrdev_direction == idetape_direction_write)
+	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		atomic_set(&bh->b_count, 0);
 	else {
 		tape->b_data = bh->b_data;
@@ -2187,7 +2189,7 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 	unsigned long flags;
 	int cnt;
 
-	if (tape->chrdev_direction != idetape_direction_read)
+	if (tape->chrdev_dir != IDETAPE_DIR_READ)
 		return 0;
 
 	/* Remove merge stage. */
@@ -2202,7 +2204,7 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 
 	/* Clear pipeline flags. */
 	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
-	tape->chrdev_direction = idetape_direction_none;
+	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
 	/* Remove pipeline stages. */
 	if (tape->first_stage == NULL)
@@ -2242,7 +2244,7 @@ static int idetape_position_tape (ide_drive_t *drive, unsigned int block, u8 par
 	int retval;
 	idetape_pc_t pc;
 
-	if (tape->chrdev_direction == idetape_direction_read)
+	if (tape->chrdev_dir == IDETAPE_DIR_READ)
 		__idetape_discard_read_pipeline(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
@@ -2469,7 +2471,7 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	int blocks, min;
 	struct idetape_bh *bh;
 
-	if (tape->chrdev_direction != idetape_direction_write) {
+	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
 		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline, but we are not writing.\n");
 		return;
 	}
@@ -2512,7 +2514,7 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 		tape->merge_stage = NULL;
 	}
 	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
-	tape->chrdev_direction = idetape_direction_none;
+	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
 	/*
 	 *	On the next backup, perform the feedback loop again.
@@ -2556,8 +2558,8 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 	u16 blocks = *(u16 *)&tape->caps[12];
 
 	/* Initialize read operation */
-	if (tape->chrdev_direction != idetape_direction_read) {
-		if (tape->chrdev_direction == idetape_direction_write) {
+	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
+		if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
 			idetape_empty_write_pipeline(drive);
 			idetape_flush_tape_buffers(drive);
 		}
@@ -2567,7 +2569,7 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 		}
 		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
 			return -ENOMEM;
-		tape->chrdev_direction = idetape_direction_read;
+		tape->chrdev_dir = IDETAPE_DIR_READ;
 
 		/*
 		 *	Issue a read 0 command to ensure that DSC handshake
@@ -2581,7 +2583,7 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 			if (bytes_read < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
-				tape->chrdev_direction = idetape_direction_none;
+				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return bytes_read;
 			}
 		}
@@ -2802,7 +2804,7 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 		mt_count = - mt_count;
 	}
 
-	if (tape->chrdev_direction == idetape_direction_read) {
+	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		/*
 		 *	We have a read-ahead buffer. Scan it for crossed
 		 *	filemarks.
@@ -2892,7 +2894,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
-	if (tape->chrdev_direction != idetape_direction_read) {
+	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
 		if (test_bit(IDETAPE_DETECT_BS, &tape->flags))
 			if (count > tape->tape_block_size &&
 			    (count % tape->tape_block_size) == 0)
@@ -2957,8 +2959,8 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	/* Initialize write operation */
-	if (tape->chrdev_direction != idetape_direction_write) {
-		if (tape->chrdev_direction == idetape_direction_read)
+	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
+		if (tape->chrdev_dir == IDETAPE_DIR_READ)
 			idetape_discard_read_pipeline(drive, 1);
 		if (tape->merge_stage || tape->merge_stage_size) {
 			printk(KERN_ERR "ide-tape: merge_stage_size "
@@ -2967,7 +2969,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 		}
 		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
 			return -ENOMEM;
-		tape->chrdev_direction = idetape_direction_write;
+		tape->chrdev_dir = IDETAPE_DIR_WRITE;
 		idetape_init_merge_stage(tape);
 
 		/*
@@ -2982,7 +2984,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 			if (retval < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
-				tape->chrdev_direction = idetape_direction_none;
+				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return retval;
 			}
 		}
@@ -3188,7 +3190,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
 
 	tape->restart_speed_control_req = 1;
-	if (tape->chrdev_direction == idetape_direction_write) {
+	if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
 		idetape_empty_write_pipeline(drive);
 		idetape_flush_tape_buffers(drive);
 	}
@@ -3219,7 +3221,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 				return -EFAULT;
 			return 0;
 		default:
-			if (tape->chrdev_direction == idetape_direction_read)
+			if (tape->chrdev_dir == IDETAPE_DIR_READ)
 				idetape_discard_read_pipeline(drive, 1);
 			return idetape_blkdev_ioctl(drive, cmd, arg);
 	}
@@ -3297,7 +3299,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	if (!test_bit(IDETAPE_ADDRESS_VALID, &tape->flags))
 		(void)idetape_rewind_tape(drive);
 
-	if (tape->chrdev_direction != idetape_direction_read)
+	if (tape->chrdev_dir != IDETAPE_DIR_READ)
 		clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
 
 	/* Read block size and write protect status from drive. */
@@ -3322,7 +3324,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	/*
 	 * Lock the tape drive door so user can't eject.
 	 */
-	if (tape->chrdev_direction == idetape_direction_none) {
+	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (idetape_create_prevent_cmd(drive, &pc, 1)) {
 			if (!idetape_queue_pc_tail(drive, &pc)) {
 				if (tape->door_locked != DOOR_EXPLICITLY_LOCKED)
@@ -3370,9 +3372,9 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 
 	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
-	if (tape->chrdev_direction == idetape_direction_write)
+	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		idetape_write_release(drive, minor);
-	if (tape->chrdev_direction == idetape_direction_read) {
+	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		if (minor < 128)
 			idetape_discard_read_pipeline(drive, 1);
 		else
@@ -3384,7 +3386,7 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 	}
 	if (minor < 128 && test_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags))
 		(void) idetape_rewind_tape(drive);
-	if (tape->chrdev_direction == idetape_direction_none) {
+	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (tape->door_locked == DOOR_LOCKED) {
 			if (idetape_create_prevent_cmd(drive, &pc, 0)) {
 				if (!idetape_queue_pc_tail(drive, &pc))
@@ -3577,7 +3579,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->name[0] = 'h';
 	tape->name[1] = 't';
 	tape->name[2] = '0' + minor;
-	tape->chrdev_direction = idetape_direction_none;
+	tape->chrdev_dir = IDETAPE_DIR_NONE;
 	tape->pc = tape->pc_stack;
 	tape->max_insert_speed = 10000;
 	tape->speed_control = 1;
-- 
1.5.3.7


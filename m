Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbZCYOUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbZCYOUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760978AbZCYOSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:18:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:57746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761520AbZCYOSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:18:10 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/10] ide-tape: kill idetape_bh
Date: Wed, 25 Mar 2009 23:17:48 +0900
Message-Id: <1237990673-8358-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237990673-8358-1-git-send-email-tj@kernel.org>
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 14:18:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: kill now unnecessary idetape_bh

With everything using standard mechanisms, there is no need for
idetape_bh anymore.  Kill it and use tape->buf, cur and valid to
describe data buffer instead.

Changes worth mentioning are...

* idetape_queue_rq_tail() now always queue tape->buf and and adjusts
  buffer state properly before completion.

* idetape_pad_zeros() clears the buffer only once.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ide/ide-tape.c |  296 +++++++++++++-----------------------------------
 1 files changed, 81 insertions(+), 215 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index dd37fd7..e7f351b 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -131,12 +131,6 @@ enum {
 	IDETAPE_DIR_WRITE = (1 << 2),
 };
 
-struct idetape_bh {
-	u32 b_size;
-	atomic_t b_count;
-	char *b_data;
-};
-
 /* Tape door status */
 #define DOOR_UNLOCKED			0
 #define DOOR_LOCKED			1
@@ -218,14 +212,12 @@ typedef struct ide_tape_obj {
 
 	/* Data buffer size chosen based on the tape's recommendation */
 	int buffer_size;
-	/* merge buffer */
-	struct idetape_bh *merge_bh;
-	/* size of the merge buffer */
-	int merge_bh_size;
-	/* pointer to current buffer head within the merge buffer */
-	struct idetape_bh *bh;
-	char *b_data;
-	int b_count;
+	/* Staging buffer of buffer_size bytes */
+	void *buf;
+	/* The read/write cursor */
+	void *cur;
+	/* The number of valid bytes in buf */
+	size_t valid;
 
 	/* Measures average tape speed */
 	unsigned long avg_time;
@@ -351,15 +343,6 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	}
 }
 
-/* Free data buffers completely. */
-static void ide_tape_kfree_buffer(idetape_tape_t *tape)
-{
-	struct idetape_bh *bh = tape->merge_bh;
-
-	kfree(bh->b_data);
-	kfree(bh);
-}
-
 static void ide_tape_handle_dsc(ide_drive_t *);
 
 static int ide_tape_callback(ide_drive_t *drive, int dsc)
@@ -605,7 +588,6 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 				   struct ide_atapi_pc *pc, struct request *rq,
 				   u8 opcode)
 {
-	struct idetape_bh *bh = (struct idetape_bh *)rq->special;
 	unsigned int length = rq->current_nr_sectors;
 
 	ide_init_pc(pc);
@@ -618,14 +600,11 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 	if (pc->req_xfer == tape->buffer_size)
 		pc->flags |= PC_FLAG_DMA_OK;
 
-	if (opcode == READ_6) {
+	if (opcode == READ_6)
 		pc->c[0] = READ_6;
-		atomic_set(&bh->b_count, 0);
-	} else if (opcode == WRITE_6) {
+	else if (opcode == WRITE_6) {
 		pc->c[0] = WRITE_6;
 		pc->flags |= PC_FLAG_WRITING;
-		pc->b_data = bh->b_data;
-		pc->b_count = atomic_read(&bh->b_count);
 	}
 
 	memcpy(rq->cmd, pc->c, 12);
@@ -747,89 +726,6 @@ out:
 }
 
 /*
- * It returns a pointer to the newly allocated buffer, or NULL in case
- * of failure.
- */
-static struct idetape_bh *ide_tape_kmalloc_buffer(idetape_tape_t *tape,
-						  int full)
-{
-	struct idetape_bh *bh;
-
-	bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
-	if (!bh)
-		return NULL;
-
-	bh->b_data = kmalloc(tape->buffer_size, GFP_KERNEL);
-	if (!bh->b_data) {
-		kfree(bh);
-		return NULL;
-	}
-
-	bh->b_size = tape->buffer_size;
-	atomic_set(&bh->b_count, full ? bh->b_size : 0);
-
-	return bh;
-}
-
-static int idetape_copy_stage_from_user(idetape_tape_t *tape,
-					const char __user *buf, int n)
-{
-	struct idetape_bh *bh = tape->bh;
-	int ret = 0;
-
-	if (n) {
-		if (bh == NULL || n > bh->b_size - atomic_read(&bh->b_count)) {
-			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
-					__func__);
-			return 1;
-		}
-		if (copy_from_user(bh->b_data + atomic_read(&bh->b_count), buf,
-				   n))
-			ret = 1;
-		atomic_add(n, &bh->b_count);
-		if (atomic_read(&bh->b_count) == bh->b_size)
-			tape->bh = NULL;
-	}
-
-	return ret;
-}
-
-static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
-				      int n)
-{
-	struct idetape_bh *bh = tape->bh;
-	int ret = 0;
-
-	if (n) {
-		if (bh == NULL || n > tape->b_count) {
-			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
-					__func__);
-			return 1;
-		}
-		if (copy_to_user(buf, tape->b_data, n))
-			ret = 1;
-		tape->b_data += n;
-		tape->b_count -= n;
-		if (!tape->b_count)
-			tape->bh = NULL;
-	}
-	return ret;
-}
-
-static void idetape_init_merge_buffer(idetape_tape_t *tape)
-{
-	struct idetape_bh *bh = tape->merge_bh;
-	tape->bh = tape->merge_bh;
-
-	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
-		atomic_set(&bh->b_count, 0);
-	else {
-		tape->b_data = bh->b_data;
-		tape->b_count = atomic_read(&bh->b_count);
-	}
-}
-
-/*
  * Write a filemark if write_filemark=1. Flush the device buffers without
  * writing a filemark otherwise.
  */
@@ -926,10 +822,10 @@ static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 		return;
 
 	clear_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags);
-	tape->merge_bh_size = 0;
-	if (tape->merge_bh != NULL) {
-		ide_tape_kfree_buffer(tape);
-		tape->merge_bh = NULL;
+	tape->valid = 0;
+	if (tape->buf != NULL) {
+		kfree(tape->buf);
+		tape->buf = NULL;
 	}
 
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
@@ -983,8 +879,7 @@ static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
  * Generate a read/write request for the block device interface and wait for it
  * to be serviced.
  */
-static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
-				 struct idetape_bh *bh)
+static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	size_t size = blocks * tape->blk_size;
@@ -1001,7 +896,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 	rq->sector = tape->first_frame;
 
 	if (size) {
-		ret = blk_rq_map_kern(drive->queue, rq, bh->b_data, size,
+		ret = blk_rq_map_kern(drive->queue, rq, tape->buf, size,
 				      __GFP_WAIT);
 		if (ret)
 			goto out_put;
@@ -1009,17 +904,17 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 
 	blk_execute_rq(drive->queue, tape->disk, rq, 0);
 
-	/* calculate the number of transferred bytes and update bh */
+	/* calculate the number of transferred bytes and update buffer state */
 	size -= rq->data_len;
+	tape->cur = tape->buf;
 	if (cmd == REQ_IDETAPE_READ)
-		atomic_add(size, &bh->b_count);
+		tape->valid = size;
+	else
+		tape->valid = 0;
 
 	ret = size;
 	if (rq->errors == IDE_DRV_ERROR_GENERAL)
 		ret = -EIO;
-
-	if (tape->merge_bh)
-		idetape_init_merge_buffer(tape);
 out_put:
 	blk_put_request(rq);
 	return ret;
@@ -1061,49 +956,33 @@ static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 /* Queue up a character device originated write request. */
 static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 {
-	idetape_tape_t *tape = drive->driver_data;
-
 	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
-	return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
-				     blocks, tape->merge_bh);
+	return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks);
 }
 
 static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int blocks;
-	struct idetape_bh *bh;
 
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
 		printk(KERN_ERR "ide-tape: bug: Trying to empty merge buffer"
 				" but we are not writing.\n");
 		return;
 	}
-	if (tape->merge_bh_size > tape->buffer_size) {
-		printk(KERN_ERR "ide-tape: bug: merge_buffer too big\n");
-		tape->merge_bh_size = tape->buffer_size;
-	}
-	if (tape->merge_bh_size) {
-		blocks = tape->merge_bh_size / tape->blk_size;
-		if (tape->merge_bh_size % tape->blk_size) {
-			unsigned int i = tape->blk_size -
-				tape->merge_bh_size % tape->blk_size;
+	if (tape->buf) {
+		blocks = tape->valid / tape->blk_size;
+		if (tape->valid % tape->blk_size) {
 			blocks++;
-			bh = tape->bh;
-			if (bh) {
-				memset(bh->b_data + atomic_read(&bh->b_count),
-				       0, i);
-				atomic_add(i, &bh->b_count);
-			} else
-				printk(KERN_INFO "ide-tape: bug, bh NULL\n");
+			memset(tape->buf + tape->valid, 0,
+			       tape->blk_size - tape->valid % tape->blk_size);
 		}
 		(void) idetape_add_chrdev_write_request(drive, blocks);
-		tape->merge_bh_size = 0;
 	}
-	if (tape->merge_bh != NULL) {
-		ide_tape_kfree_buffer(tape);
-		tape->merge_bh = NULL;
+	if (tape->buf != NULL) {
+		kfree(tape->buf);
+		tape->buf = NULL;
 	}
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 }
@@ -1119,15 +998,15 @@ static int idetape_init_read(ide_drive_t *drive)
 			ide_tape_flush_merge_buffer(drive);
 			idetape_flush_tape_buffers(drive);
 		}
-		if (tape->merge_bh || tape->merge_bh_size) {
-			printk(KERN_ERR "ide-tape: merge_bh_size should be"
-					 " 0 now\n");
-			tape->merge_bh_size = 0;
+		if (tape->buf || tape->valid) {
+			printk(KERN_ERR "ide-tape: valid should be 0 now\n");
+			tape->valid = 0;
 		}
-		tape->merge_bh = ide_tape_kmalloc_buffer(tape, 0);
-		if (!tape->merge_bh)
+		tape->buf = kmalloc(tape->buffer_size, GFP_KERNEL);
+		if (!tape->buf)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_READ;
+		tape->cur = tape->buf;
 
 		/*
 		 * Issue a read 0 command to ensure that DSC handshake is
@@ -1137,11 +1016,10 @@ static int idetape_init_read(ide_drive_t *drive)
 		 */
 		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
 			bytes_read = idetape_queue_rw_tail(drive,
-							REQ_IDETAPE_READ, 0,
-							tape->merge_bh);
+							REQ_IDETAPE_READ, 0);
 			if (bytes_read < 0) {
-				ide_tape_kfree_buffer(tape);
-				tape->merge_bh = NULL;
+				kfree(tape->buf);
+				tape->buf = NULL;
 				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return bytes_read;
 			}
@@ -1154,8 +1032,6 @@ static int idetape_init_read(ide_drive_t *drive)
 /* called from idetape_chrdev_read() to service a chrdev read request. */
 static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 {
-	idetape_tape_t *tape = drive->driver_data;
-
 	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
 	/* If we are at a filemark, return a read length of 0 */
@@ -1164,27 +1040,21 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 
 	idetape_init_read(drive);
 
-	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
-				     tape->merge_bh);
+	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks);
 }
 
 static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	struct idetape_bh *bh = tape->merge_bh;
-	int blocks;
+
+	memset(tape->buf, 0, tape->buffer_size);
 
 	while (bcount) {
-		unsigned int count;
+		unsigned int count = min(tape->buffer_size, bcount);
 
-		count = min(tape->buffer_size, bcount);
+		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
+				      count / tape->blk_size);
 		bcount -= count;
-		blocks = count / tape->blk_size;
-		atomic_set(&bh->b_count, count);
-		memset(bh->b_data, 0, atomic_read(&bh->b_count));
-
-		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks,
-				      tape->merge_bh);
 	}
 }
 
@@ -1264,7 +1134,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	}
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
-		tape->merge_bh_size = 0;
+		tape->valid = 0;
 		if (test_and_clear_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
 			++count;
 		ide_tape_discard_merge_buffer(drive, 0);
@@ -1330,20 +1200,20 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		return rc;
 	if (count == 0)
 		return (0);
-	if (tape->merge_bh_size) {
-		actually_read = min((unsigned int)(tape->merge_bh_size),
-				    (unsigned int)count);
-		if (idetape_copy_stage_to_user(tape, buf, actually_read))
+	if (tape->valid) {
+		actually_read = min_t(unsigned int, tape->valid, count);
+		if (copy_to_user(buf, tape->cur, actually_read))
 			ret = -EFAULT;
 		buf += actually_read;
-		tape->merge_bh_size -= actually_read;
 		count -= actually_read;
+		tape->cur += actually_read;
+		tape->valid -= actually_read;
 	}
 	while (count >= tape->buffer_size) {
 		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
-		if (idetape_copy_stage_to_user(tape, buf, bytes_read))
+		if (copy_to_user(buf, tape->cur, bytes_read))
 			ret = -EFAULT;
 		buf += bytes_read;
 		count -= bytes_read;
@@ -1354,10 +1224,11 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		if (bytes_read <= 0)
 			goto finish;
 		temp = min((unsigned long)count, (unsigned long)bytes_read);
-		if (idetape_copy_stage_to_user(tape, buf, temp))
+		if (copy_to_user(buf, tape->cur, temp))
 			ret = -EFAULT;
 		actually_read += temp;
-		tape->merge_bh_size = bytes_read-temp;
+		tape->cur += temp;
+		tape->valid -= temp;
 	}
 finish:
 	if (!actually_read && test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags)) {
@@ -1389,16 +1260,15 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
 		if (tape->chrdev_dir == IDETAPE_DIR_READ)
 			ide_tape_discard_merge_buffer(drive, 1);
-		if (tape->merge_bh || tape->merge_bh_size) {
-			printk(KERN_ERR "ide-tape: merge_bh_size "
-				"should be 0 now\n");
-			tape->merge_bh_size = 0;
+		if (tape->buf || tape->valid) {
+			printk(KERN_ERR "ide-tape: valid should be 0 now\n");
+			tape->valid = 0;
 		}
-		tape->merge_bh = ide_tape_kmalloc_buffer(tape, 0);
-		if (!tape->merge_bh)
+		tape->buf = kmalloc(tape->buffer_size, GFP_KERNEL);
+		if (!tape->buf)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_WRITE;
-		idetape_init_merge_buffer(tape);
+		tape->cur = tape->buf;
 
 		/*
 		 * Issue a write 0 command to ensure that DSC handshake is
@@ -1408,11 +1278,10 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		 */
 		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
 			ssize_t retval = idetape_queue_rw_tail(drive,
-							REQ_IDETAPE_WRITE, 0,
-							tape->merge_bh);
+							REQ_IDETAPE_WRITE, 0);
 			if (retval < 0) {
-				ide_tape_kfree_buffer(tape);
-				tape->merge_bh = NULL;
+				kfree(tape->buf);
+				tape->buf = NULL;
 				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return retval;
 			}
@@ -1420,23 +1289,19 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	}
 	if (count == 0)
 		return (0);
-	if (tape->merge_bh_size) {
-		if (tape->merge_bh_size >= tape->buffer_size) {
-			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
-			tape->merge_bh_size = 0;
-		}
-		actually_written = min((unsigned int)
-				(tape->buffer_size - tape->merge_bh_size),
-				(unsigned int)count);
-		if (idetape_copy_stage_from_user(tape, buf, actually_written))
-				ret = -EFAULT;
+	if (tape->valid < tape->buffer_size) {
+		actually_written = min_t(unsigned int,
+					 tape->buffer_size - tape->valid,
+					 count);
+		if (copy_from_user(tape->cur, buf, actually_written))
+			ret = -EFAULT;
 		buf += actually_written;
-		tape->merge_bh_size += actually_written;
 		count -= actually_written;
+		tape->cur += actually_written;
+		tape->valid += actually_written;
 
-		if (tape->merge_bh_size == tape->buffer_size) {
+		if (tape->valid == tape->buffer_size) {
 			ssize_t retval;
-			tape->merge_bh_size = 0;
 			retval = idetape_add_chrdev_write_request(drive, ctl);
 			if (retval <= 0)
 				return (retval);
@@ -1444,7 +1309,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	}
 	while (count >= tape->buffer_size) {
 		ssize_t retval;
-		if (idetape_copy_stage_from_user(tape, buf, tape->buffer_size))
+		if (copy_from_user(tape->cur, buf, tape->buffer_size))
 			ret = -EFAULT;
 		buf += tape->buffer_size;
 		count -= tape->buffer_size;
@@ -1455,9 +1320,10 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	}
 	if (count) {
 		actually_written += count;
-		if (idetape_copy_stage_from_user(tape, buf, count))
+		if (copy_from_user(tape->cur, buf, count))
 			ret = -EFAULT;
-		tape->merge_bh_size += count;
+		tape->cur += count;
+		tape->valid += count;
 	}
 	return ret ? ret : actually_written;
 }
@@ -1620,7 +1486,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 		idetape_flush_tape_buffers(drive);
 	}
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
-		block_offset = tape->merge_bh_size /
+		block_offset = tape->valid /
 			(tape->blk_size * tape->user_bs_factor);
 		position = idetape_read_position(drive);
 		if (position < 0)
@@ -1768,12 +1634,12 @@ static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 	idetape_tape_t *tape = drive->driver_data;
 
 	ide_tape_flush_merge_buffer(drive);
-	tape->merge_bh = ide_tape_kmalloc_buffer(tape, 1);
-	if (tape->merge_bh != NULL) {
+	tape->buf = kmalloc(tape->buffer_size, GFP_KERNEL);
+	if (tape->buf != NULL) {
 		idetape_pad_zeros(drive, tape->blk_size *
 				(tape->user_bs_factor - 1));
-		ide_tape_kfree_buffer(tape);
-		tape->merge_bh = NULL;
+		kfree(tape->buf);
+		tape->buf = NULL;
 	}
 	idetape_write_filemark(drive);
 	idetape_flush_tape_buffers(drive);
@@ -2039,7 +1905,7 @@ static void ide_tape_release(struct device *dev)
 	ide_drive_t *drive = tape->drive;
 	struct gendisk *g = tape->disk;
 
-	BUG_ON(tape->merge_bh_size);
+	BUG_ON(tape->valid);
 
 	drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	drive->driver_data = NULL;
-- 
1.6.0.2


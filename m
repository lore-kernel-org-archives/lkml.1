Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbYC2Rri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbYC2Rri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbYC2RqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:46:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:51409 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbYC2RqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Qt86gihO/N9ii/xe+HQjpBXj2fjO0K9jVbo2EocEJGaCJ47+J+rvJ8W5ATnI6HsdVFwh5DGHracJJLy/hVXgy5Vh6atTMpz2jyb0XCWjeGzwZKE3MwIEJivat6Lh9k82i0shDsp/AxkyxfDtHYZI2JDcPoDisgWR9WwRw70rqS8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 5/5] ide-tape: remove the last remains of pipelining
Date: Sat, 29 Mar 2008 18:46:09 +0100
Message-Id: <1206812769-10065-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1206812769-10065-1-git-send-email-petkovbb@gmail.com>
References: <1206812769-10065-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the tape->merge_stage pipeline stage into tape->bh, a singly
linked list of idetape_bh's, each of which is a tag attached to one or more pages
serving as a data buffer for chrdev requests. In particular,

1. makes tape->bh the data buffer of size tape->buffer_size which is computed
from the Continuous Transfer Limit value in the caps page and the tape block
size. The chrdev rw routines use this buffer as an intermediary location to
shuffle data to and from.

2. mv tape->merge_stage_size => tape->cur_buf_size as it contains the offset
within tape->bh

3. get rid of pipeline stage idetape_stage_t, tape->merge_stage
and pipeline-related functions __idetape_discard_read_pipeline(),
idetape_discard_read_pipeline(), idetape_empty_write_pipeline()

4. code chunk "if (tape->merge_stage_size) {...}" in idetape_chrdev_read() is not
needed since tape->merge_stage_size, tape->cur_buf_size resp., is zeroed out in
idetape_init_read() couple of lines above.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  267 ++++++++++++------------------------------------
 1 files changed, 65 insertions(+), 202 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index dcaefef..c7507c7 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -215,13 +215,6 @@ enum {
 	IDETAPE_FLAG_MEDIUM_PRESENT	= (1 << 6),
 };
 
-/* A pipeline stage. */
-typedef struct idetape_stage_s {
-	struct request rq;			/* The corresponding request */
-	struct idetape_bh *bh;			/* The data buffers */
-	struct idetape_stage_s *next;		/* Pointer to the next stage */
-} idetape_stage_t;
-
 /*
  * Most of our global data which we need to save even as we leave the driver due
  * to an interrupt or a timer event is stored in the struct defined below.
@@ -309,8 +302,7 @@ typedef struct ide_tape_obj {
 
 	/* Data buffer size chosen based on the tape's recommendation */
 	int buffer_size;
-	idetape_stage_t *merge_stage;
-	int merge_stage_size;
+	int cur_buf_size;
 	struct idetape_bh *bh;
 	char *b_data;
 	int b_count;
@@ -584,9 +576,9 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 }
 
 /* Free data buffers completely. */
-static void ide_tape_kfree_buffer(idetape_stage_t *stage)
+static void ide_tape_kfree_buffer(idetape_tape_t *tape)
 {
-	struct idetape_bh *prev_bh, *bh = stage->bh;
+	struct idetape_bh *prev_bh, *bh = tape->bh;
 
 	while (bh) {
 		u32 size = bh->b_size;
@@ -603,7 +595,7 @@ static void ide_tape_kfree_buffer(idetape_stage_t *stage)
 		bh = bh->b_reqnext;
 		kfree(prev_bh);
 	}
-	kfree(stage);
+	kfree(bh);
 }
 
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
@@ -1297,22 +1289,16 @@ out:
  * It returns a pointer to the newly allocated buffer, or NULL in case of
  * failure.
  */
-static idetape_stage_t *ide_tape_kmalloc_buffer(idetape_tape_t *tape, int full,
-						int clear)
+static struct idetape_bh *ide_tape_kmalloc_buffer(idetape_tape_t *tape,
+						  int full, int clear)
 {
-	idetape_stage_t *stage;
-	struct idetape_bh *prev_bh, *bh;
+	struct idetape_bh *prev_bh, *bh, *tape_bh;
 	int pages = tape->pages_per_buffer;
 	unsigned int order, b_allocd;
 	char *b_data = NULL;
 
-	stage = kmalloc(sizeof(idetape_stage_t), GFP_KERNEL);
-	if (!stage)
-		return NULL;
-	stage->next = NULL;
-
-	stage->bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
-	bh = stage->bh;
+	tape_bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+	bh = tape_bh;
 	if (bh == NULL)
 		goto abort;
 
@@ -1372,9 +1358,9 @@ static idetape_stage_t *ide_tape_kmalloc_buffer(idetape_tape_t *tape, int full,
 	bh->b_size -= tape->excess_bh_size;
 	if (full)
 		atomic_sub(tape->excess_bh_size, &bh->b_count);
-	return stage;
+	return tape_bh;
 abort:
-	ide_tape_kfree_buffer(stage);
+	ide_tape_kfree_buffer(tape);
 	return NULL;
 }
 
@@ -1442,9 +1428,9 @@ static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
 	return ret;
 }
 
-static void idetape_init_merge_stage(idetape_tape_t *tape)
+static void ide_tape_init_data_buf(idetape_tape_t *tape)
 {
-	struct idetape_bh *bh = tape->merge_stage->bh;
+	struct idetape_bh *bh = tape->bh;
 
 	tape->bh = bh;
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
@@ -1640,25 +1626,6 @@ static int idetape_create_prevent_cmd(ide_drive_t *drive,
 	return 1;
 }
 
-static int __idetape_discard_read_pipeline(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	if (tape->chrdev_dir != IDETAPE_DIR_READ)
-		return 0;
-
-	clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
-	tape->merge_stage_size = 0;
-	if (tape->merge_stage != NULL) {
-		ide_tape_kfree_buffer(tape->merge_stage);
-		tape->merge_stage = NULL;
-	}
-
-	tape->chrdev_dir = IDETAPE_DIR_NONE;
-
-	return 0;
-}
-
 /*
  * Position the tape to the requested block using the LOCATE packet command.
  * A READ POSITION command is then issued to check where we are positioned. Like
@@ -1668,12 +1635,9 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 		u8 partition, int skip)
 {
-	idetape_tape_t *tape = drive->driver_data;
-	int retval;
 	struct ide_atapi_pc pc;
+	int retval;
 
-	if (tape->chrdev_dir == IDETAPE_DIR_READ)
-		__idetape_discard_read_pipeline(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
 	retval = idetape_queue_pc_tail(drive, &pc);
@@ -1684,25 +1648,6 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
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
@@ -1726,8 +1671,8 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
 		return 0;
 
-	if (tape->merge_stage)
-		idetape_init_merge_stage(tape);
+	if (tape->bh)
+		ide_tape_init_data_buf(tape);
 	if (rq.errors == IDETAPE_ERROR_GENERAL)
 		return -EIO;
 	return (tape->blk_size * (blocks-rq.current_nr_sectors));
@@ -1778,61 +1723,7 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
 	return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
-				     blocks, tape->merge_stage->bh);
-}
-
-static void idetape_empty_write_pipeline(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	int blocks, min;
-	struct idetape_bh *bh;
-
-	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
-		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline,"
-				" but we are not writing.\n");
-		return;
-	}
-	if (tape->merge_stage_size > tape->buffer_size) {
-		printk(KERN_ERR "ide-tape: bug: merge_buffer too big\n");
-		tape->merge_stage_size = tape->buffer_size;
-	}
-	if (tape->merge_stage_size) {
-		blocks = tape->merge_stage_size / tape->blk_size;
-		if (tape->merge_stage_size % tape->blk_size) {
-			unsigned int i;
-
-			blocks++;
-			i = tape->blk_size - tape->merge_stage_size %
-				tape->blk_size;
-			bh = tape->bh->b_reqnext;
-			while (bh) {
-				atomic_set(&bh->b_count, 0);
-				bh = bh->b_reqnext;
-			}
-			bh = tape->bh;
-			while (i) {
-				if (bh == NULL) {
-					printk(KERN_INFO "ide-tape: bug,"
-							 " bh NULL\n");
-					break;
-				}
-				min = min(i, (unsigned int)(bh->b_size -
-						atomic_read(&bh->b_count)));
-				memset(bh->b_data + atomic_read(&bh->b_count),
-						0, min);
-				atomic_add(min, &bh->b_count);
-				i -= min;
-				bh = bh->b_reqnext;
-			}
-		}
-		(void) idetape_add_chrdev_write_request(drive, blocks);
-		tape->merge_stage_size = 0;
-	}
-	if (tape->merge_stage != NULL) {
-		ide_tape_kfree_buffer(tape->merge_stage);
-		tape->merge_stage = NULL;
-	}
-	tape->chrdev_dir = IDETAPE_DIR_NONE;
+				     blocks, tape->bh);
 }
 
 static int idetape_init_read(ide_drive_t *drive)
@@ -1842,17 +1733,16 @@ static int idetape_init_read(ide_drive_t *drive)
 
 	/* Initialize read operation */
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
-		if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-			idetape_empty_write_pipeline(drive);
+		if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 			idetape_flush_tape_buffers(drive);
+
+		if (tape->cur_buf_size) {
+			printk(KERN_ERR "ide-tape: cur_buf_size should be"
+					" 0 now\n");
+			tape->cur_buf_size = 0;
 		}
-		if (tape->merge_stage || tape->merge_stage_size) {
-			printk(KERN_ERR "ide-tape: merge_stage_size should be"
-					 " 0 now\n");
-			tape->merge_stage_size = 0;
-		}
-		tape->merge_stage = ide_tape_kmalloc_buffer(tape, 0, 0);
-		if (!tape->merge_stage)
+		tape->bh = ide_tape_kmalloc_buffer(tape, 0, 0);
+		if (!tape->bh)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_READ;
 
@@ -1865,10 +1755,10 @@ static int idetape_init_read(ide_drive_t *drive)
 		if (drive->dsc_overlap) {
 			bytes_read = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_READ, 0,
-							tape->merge_stage->bh);
+							tape->bh);
 			if (bytes_read < 0) {
-				ide_tape_kfree_buffer(tape->merge_stage);
-				tape->merge_stage = NULL;
+				ide_tape_kfree_buffer(tape);
+				tape->bh = NULL;
 				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return bytes_read;
 			}
@@ -1892,7 +1782,7 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	idetape_init_read(drive);
 
 	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
-				     tape->merge_stage->bh);
+				     tape->bh);
 }
 
 static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
@@ -1904,7 +1794,7 @@ static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 	while (bcount) {
 		unsigned int count;
 
-		bh = tape->merge_stage->bh;
+		bh = tape->bh;
 		count = min(tape->buffer_size, bcount);
 		bcount -= count;
 		blocks = count / tape->blk_size;
@@ -1916,7 +1806,7 @@ static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 			bh = bh->b_reqnext;
 		}
 		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks,
-				      tape->merge_stage->bh);
+				      tape->bh);
 	}
 }
 
@@ -1995,16 +1885,11 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	}
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
-		tape->merge_stage_size = 0;
+		tape->cur_buf_size = 0;
 		if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 			++count;
-		idetape_discard_read_pipeline(drive, 0);
 	}
 
-	/*
-	 * The filemark was not found in our internal pipeline;	now we can issue
-	 * the space command.
-	 */
 	switch (mt_op) {
 	case MTFSF:
 	case MTBSF:
@@ -2065,15 +1950,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		return rc;
 	if (count == 0)
 		return (0);
-	if (tape->merge_stage_size) {
-		actually_read = min((unsigned int)(tape->merge_stage_size),
-				    (unsigned int)count);
-		if (idetape_copy_stage_to_user(tape, buf, actually_read))
-			ret = -EFAULT;
-		buf += actually_read;
-		tape->merge_stage_size -= actually_read;
-		count -= actually_read;
-	}
+
 	while (count >= tape->buffer_size) {
 		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
@@ -2092,7 +1969,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		if (idetape_copy_stage_to_user(tape, buf, temp))
 			ret = -EFAULT;
 		actually_read += temp;
-		tape->merge_stage_size = bytes_read-temp;
+		tape->cur_buf_size = bytes_read-temp;
 	}
 finish:
 	if (!actually_read && test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags)) {
@@ -2122,18 +1999,16 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 
 	/* Initialize write operation */
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
-		if (tape->chrdev_dir == IDETAPE_DIR_READ)
-			idetape_discard_read_pipeline(drive, 1);
-		if (tape->merge_stage || tape->merge_stage_size) {
-			printk(KERN_ERR "ide-tape: merge_stage_size "
-				"should be 0 now\n");
-			tape->merge_stage_size = 0;
+		if (tape->cur_buf_size) {
+			printk(KERN_ERR "ide-tape: cur_buf_size should be "
+					"0 now\n");
+			tape->cur_buf_size = 0;
 		}
-		tape->merge_stage = ide_tape_kmalloc_buffer(tape, 0, 0);
-		if (!tape->merge_stage)
+		tape->bh = ide_tape_kmalloc_buffer(tape, 0, 0);
+		if (!tape->bh)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_WRITE;
-		idetape_init_merge_stage(tape);
+		ide_tape_init_data_buf(tape);
 
 		/*
 		 * Issue a write 0 command to ensure that DSC handshake is
@@ -2144,39 +2019,42 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		if (drive->dsc_overlap) {
 			ssize_t retval = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_WRITE, 0,
-							tape->merge_stage->bh);
+							tape->bh);
 			if (retval < 0) {
-				ide_tape_kfree_buffer(tape->merge_stage);
-				tape->merge_stage = NULL;
+				ide_tape_kfree_buffer(tape);
+				tape->bh = NULL;
 				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return retval;
 			}
 		}
 	}
 	if (count == 0)
-		return (0);
-	if (tape->merge_stage_size) {
-		if (tape->merge_stage_size >= tape->buffer_size) {
+		return 0;
+
+	if (tape->cur_buf_size) {
+		if (tape->cur_buf_size >= tape->buffer_size) {
 			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
-			tape->merge_stage_size = 0;
+			tape->cur_buf_size = 0;
 		}
 		actually_written = min((unsigned int)
-				(tape->buffer_size - tape->merge_stage_size),
+				(tape->buffer_size - tape->cur_buf_size),
 				(unsigned int)count);
 		if (idetape_copy_stage_from_user(tape, buf, actually_written))
 				ret = -EFAULT;
 		buf += actually_written;
-		tape->merge_stage_size += actually_written;
+		tape->cur_buf_size += actually_written;
 		count -= actually_written;
 
-		if (tape->merge_stage_size == tape->buffer_size) {
+		/* buffer full, flush data to tape */
+		if (tape->cur_buf_size == tape->buffer_size) {
 			ssize_t retval;
-			tape->merge_stage_size = 0;
+			tape->cur_buf_size = 0;
 			retval = idetape_add_chrdev_write_request(drive, ctl);
 			if (retval <= 0)
 				return (retval);
 		}
 	}
+
 	while (count >= tape->buffer_size) {
 		ssize_t retval;
 		if (idetape_copy_stage_from_user(tape, buf, tape->buffer_size))
@@ -2188,11 +2066,12 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		if (retval <= 0)
 			return (retval);
 	}
+
 	if (count) {
 		actually_written += count;
 		if (idetape_copy_stage_from_user(tape, buf, count))
 			ret = -EFAULT;
-		tape->merge_stage_size += count;
+		tape->cur_buf_size += count;
 	}
 	return ret ? ret : actually_written;
 }
@@ -2248,7 +2127,6 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 	case MTWEOF:
 		if (tape->write_prot)
 			return -EACCES;
-		idetape_discard_read_pipeline(drive, 1);
 		for (i = 0; i < mt_count; i++) {
 			retval = idetape_write_filemark(drive);
 			if (retval)
@@ -2256,12 +2134,10 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		}
 		return 0;
 	case MTREW:
-		idetape_discard_read_pipeline(drive, 0);
 		if (idetape_rewind_tape(drive))
 			return -EIO;
 		return 0;
 	case MTLOAD:
-		idetape_discard_read_pipeline(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 					       IDETAPE_LU_LOAD_MASK);
 		return idetape_queue_pc_tail(drive, &pc);
@@ -2276,7 +2152,6 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 				if (!idetape_queue_pc_tail(drive, &pc))
 					tape->door_locked = DOOR_UNLOCKED;
 		}
-		idetape_discard_read_pipeline(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 					      !IDETAPE_LU_LOAD_MASK);
 		retval = idetape_queue_pc_tail(drive, &pc);
@@ -2284,10 +2159,8 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			clear_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
 		return retval;
 	case MTNOP:
-		idetape_discard_read_pipeline(drive, 0);
 		return idetape_flush_tape_buffers(drive);
 	case MTRETEN:
-		idetape_discard_read_pipeline(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
 		return idetape_queue_pc_tail(drive, &pc);
@@ -2309,11 +2182,9 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			set_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
 		return 0;
 	case MTSEEK:
-		idetape_discard_read_pipeline(drive, 0);
 		return idetape_position_tape(drive,
 			mt_count * tape->user_bs_factor, tape->partition, 0);
 	case MTSETPART:
-		idetape_discard_read_pipeline(drive, 0);
 		return idetape_position_tape(drive, 0, mt_count, 0);
 	case MTFSR:
 	case MTBSR:
@@ -2358,12 +2229,11 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 
 	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
 
-	if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-		idetape_empty_write_pipeline(drive);
+	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		idetape_flush_tape_buffers(drive);
-	}
+
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
-		block_offset = tape->merge_stage_size /
+		block_offset = tape->cur_buf_size /
 			(tape->blk_size * tape->user_bs_factor);
 		position = idetape_read_position(drive);
 		if (position < 0)
@@ -2394,8 +2264,6 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 			return -EFAULT;
 		return 0;
 	default:
-		if (tape->chrdev_dir == IDETAPE_DIR_READ)
-			idetape_discard_read_pipeline(drive, 1);
 		return idetape_blkdev_ioctl(drive, cmd, arg);
 	}
 }
@@ -2508,13 +2376,12 @@ static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	idetape_empty_write_pipeline(drive);
-	tape->merge_stage = ide_tape_kmalloc_buffer(tape, 1, 0);
-	if (tape->merge_stage != NULL) {
+	tape->bh = ide_tape_kmalloc_buffer(tape, 1, 0);
+	if (tape->bh) {
 		idetape_pad_zeros(drive, tape->blk_size *
 				(tape->user_bs_factor - 1));
-		ide_tape_kfree_buffer(tape->merge_stage);
-		tape->merge_stage = NULL;
+		ide_tape_kfree_buffer(tape);
+		tape->bh = NULL;
 	}
 	idetape_write_filemark(drive);
 	idetape_flush_tape_buffers(drive);
@@ -2535,10 +2402,6 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		idetape_write_release(drive, minor);
-	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
-		if (minor < 128)
-			idetape_discard_read_pipeline(drive, 1);
-	}
 
 	if (minor < 128 && test_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags))
 		(void) idetape_rewind_tape(drive);
@@ -2792,7 +2655,7 @@ static void ide_tape_release(struct kref *kref)
 	ide_drive_t *drive = tape->drive;
 	struct gendisk *g = tape->disk;
 
-	BUG_ON(tape->merge_stage_size);
+	BUG_ON(tape->cur_buf_size);
 
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
-- 
1.5.4.1


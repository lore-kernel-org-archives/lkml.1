Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYDGErT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYDGErT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 00:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbYDGEpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 00:45:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:36969 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYDGEox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 00:44:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=O90OK/vh7baDpMcxn7RIyRek3LzuTBvfr75i0DBl0UzCszEif4lVutQW9v3GHoLcrR8ME0GIud+XCv9AngLJgV0+ZABuVCELdOfEXmfPMQ6VZQz6XE5PYccCXV7mxVTknMftdw5ogrbZ7JVYGYj1zVhTMQmbsR4M4y5OfyXqMCY=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 5/6] ide-tape: remove tape->merge_stage
Date: Mon,  7 Apr 2008 06:45:03 +0200
Message-Id: <1207543504-27888-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
References: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the pipeline merge stage but retain the chrdev req caching
functionality by using a merge buffer tape->merge_bh which is flushed in chunks
of several blocks at a time. Also, remove last references to pipelining, e.g.
typedef idetape_stage_s.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  107 ++++++++++++++++++++---------------------------
 1 files changed, 46 insertions(+), 61 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index d7fee6e..78a76a0 100644
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
@@ -309,9 +302,11 @@ typedef struct ide_tape_obj {
 
 	/* Data buffer size chosen based on the tape's recommendation */
 	int buffer_size;
-	idetape_stage_t *merge_stage;
+	/* merge buffer */
+	struct idetape_bh *merge_bh;
 	/* size of the merge buffer */
 	int merge_bh_size;
+	/* pointer to current buffer head within the merge buffer */
 	struct idetape_bh *bh;
 	char *b_data;
 	int b_count;
@@ -585,9 +580,9 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 }
 
 /* Free data buffers completely. */
-static void ide_tape_kfree_buffer(idetape_stage_t *stage)
+static void ide_tape_kfree_buffer(idetape_tape_t *tape)
 {
-	struct idetape_bh *prev_bh, *bh = stage->bh;
+	struct idetape_bh *prev_bh, *bh = tape->merge_bh;
 
 	while (bh) {
 		u32 size = bh->b_size;
@@ -605,7 +600,7 @@ static void ide_tape_kfree_buffer(idetape_stage_t *stage)
 		bh = bh->b_reqnext;
 		kfree(prev_bh);
 	}
-	kfree(stage);
+	kfree(tape->merge_bh);
 }
 
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
@@ -1299,22 +1294,16 @@ out:
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
+	struct idetape_bh *prev_bh, *bh, *merge_bh;
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
+	merge_bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+	bh = merge_bh;
 	if (bh == NULL)
 		goto abort;
 
@@ -1374,9 +1363,9 @@ static idetape_stage_t *ide_tape_kmalloc_buffer(idetape_tape_t *tape, int full,
 	bh->b_size -= tape->excess_bh_size;
 	if (full)
 		atomic_sub(tape->excess_bh_size, &bh->b_count);
-	return stage;
+	return merge_bh;
 abort:
-	ide_tape_kfree_buffer(stage);
+	ide_tape_kfree_buffer(tape);
 	return NULL;
 }
 
@@ -1444,11 +1433,11 @@ static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
 	return ret;
 }
 
-static void idetape_init_merge_stage(idetape_tape_t *tape)
+static void idetape_init_merge_buffer(idetape_tape_t *tape)
 {
-	struct idetape_bh *bh = tape->merge_stage->bh;
+	struct idetape_bh *bh = tape->merge_bh;
+	tape->bh = tape->merge_bh;
 
-	tape->bh = bh;
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		atomic_set(&bh->b_count, 0);
 	else {
@@ -1651,9 +1640,9 @@ static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 
 	clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
 	tape->merge_bh_size = 0;
-	if (tape->merge_stage != NULL) {
-		ide_tape_kfree_buffer(tape->merge_stage);
-		tape->merge_stage = NULL;
+	if (tape->merge_bh != NULL) {
+		ide_tape_kfree_buffer(tape);
+		tape->merge_bh = NULL;
 	}
 
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
@@ -1725,8 +1714,8 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
 		return 0;
 
-	if (tape->merge_stage)
-		idetape_init_merge_stage(tape);
+	if (tape->merge_bh)
+		idetape_init_merge_buffer(tape);
 	if (rq.errors == IDETAPE_ERROR_GENERAL)
 		return -EIO;
 	return (tape->blk_size * (blocks-rq.current_nr_sectors));
@@ -1777,7 +1766,7 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
 	return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
-				     blocks, tape->merge_stage->bh);
+				     blocks, tape->merge_bh);
 }
 
 static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
@@ -1787,7 +1776,7 @@ static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 	struct idetape_bh *bh;
 
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
-		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline,"
+		printk(KERN_ERR "ide-tape: bug: Trying to empty merge buffer"
 				" but we are not writing.\n");
 		return;
 	}
@@ -1827,9 +1816,9 @@ static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 		(void) idetape_add_chrdev_write_request(drive, blocks);
 		tape->merge_bh_size = 0;
 	}
-	if (tape->merge_stage != NULL) {
-		ide_tape_kfree_buffer(tape->merge_stage);
-		tape->merge_stage = NULL;
+	if (tape->merge_bh != NULL) {
+		ide_tape_kfree_buffer(tape);
+		tape->merge_bh = NULL;
 	}
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 }
@@ -1845,13 +1834,13 @@ static int idetape_init_read(ide_drive_t *drive)
 			ide_tape_flush_merge_buffer(drive);
 			idetape_flush_tape_buffers(drive);
 		}
-		if (tape->merge_stage || tape->merge_bh_size) {
+		if (tape->merge_bh || tape->merge_bh_size) {
 			printk(KERN_ERR "ide-tape: merge_bh_size should be"
 					 " 0 now\n");
 			tape->merge_bh_size = 0;
 		}
-		tape->merge_stage = ide_tape_kmalloc_buffer(tape, 0, 0);
-		if (!tape->merge_stage)
+		tape->merge_bh = ide_tape_kmalloc_buffer(tape, 0, 0);
+		if (!tape->merge_bh)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_READ;
 
@@ -1864,10 +1853,10 @@ static int idetape_init_read(ide_drive_t *drive)
 		if (drive->dsc_overlap) {
 			bytes_read = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_READ, 0,
-							tape->merge_stage->bh);
+							tape->merge_bh);
 			if (bytes_read < 0) {
-				ide_tape_kfree_buffer(tape->merge_stage);
-				tape->merge_stage = NULL;
+				ide_tape_kfree_buffer(tape);
+				tape->merge_bh = NULL;
 				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return bytes_read;
 			}
@@ -1891,7 +1880,7 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	idetape_init_read(drive);
 
 	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
-				     tape->merge_stage->bh);
+				     tape->merge_bh);
 }
 
 static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
@@ -1903,7 +1892,7 @@ static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 	while (bcount) {
 		unsigned int count;
 
-		bh = tape->merge_stage->bh;
+		bh = tape->merge_bh;
 		count = min(tape->buffer_size, bcount);
 		bcount -= count;
 		blocks = count / tape->blk_size;
@@ -1915,7 +1904,7 @@ static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 			bh = bh->b_reqnext;
 		}
 		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks,
-				      tape->merge_stage->bh);
+				      tape->merge_bh);
 	}
 }
 
@@ -2000,10 +1989,6 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 		ide_tape_discard_merge_buffer(drive, 0);
 	}
 
-	/*
-	 * The filemark was not found in our internal pipeline;	now we can issue
-	 * the space command.
-	 */
 	switch (mt_op) {
 	case MTFSF:
 	case MTBSF:
@@ -2123,16 +2108,16 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
 		if (tape->chrdev_dir == IDETAPE_DIR_READ)
 			ide_tape_discard_merge_buffer(drive, 1);
-		if (tape->merge_stage || tape->merge_bh_size) {
+		if (tape->merge_bh || tape->merge_bh_size) {
 			printk(KERN_ERR "ide-tape: merge_bh_size "
 				"should be 0 now\n");
 			tape->merge_bh_size = 0;
 		}
-		tape->merge_stage = ide_tape_kmalloc_buffer(tape, 0, 0);
-		if (!tape->merge_stage)
+		tape->merge_bh = ide_tape_kmalloc_buffer(tape, 0, 0);
+		if (!tape->merge_bh)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_WRITE;
-		idetape_init_merge_stage(tape);
+		idetape_init_merge_buffer(tape);
 
 		/*
 		 * Issue a write 0 command to ensure that DSC handshake is
@@ -2143,10 +2128,10 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		if (drive->dsc_overlap) {
 			ssize_t retval = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_WRITE, 0,
-							tape->merge_stage->bh);
+							tape->merge_bh);
 			if (retval < 0) {
-				ide_tape_kfree_buffer(tape->merge_stage);
-				tape->merge_stage = NULL;
+				ide_tape_kfree_buffer(tape);
+				tape->merge_bh = NULL;
 				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return retval;
 			}
@@ -2508,12 +2493,12 @@ static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 	idetape_tape_t *tape = drive->driver_data;
 
 	ide_tape_flush_merge_buffer(drive);
-	tape->merge_stage = ide_tape_kmalloc_buffer(tape, 1, 0);
-	if (tape->merge_stage != NULL) {
+	tape->merge_bh = ide_tape_kmalloc_buffer(tape, 1, 0);
+	if (tape->merge_bh != NULL) {
 		idetape_pad_zeros(drive, tape->blk_size *
 				(tape->user_bs_factor - 1));
-		ide_tape_kfree_buffer(tape->merge_stage);
-		tape->merge_stage = NULL;
+		ide_tape_kfree_buffer(tape);
+		tape->merge_bh = NULL;
 	}
 	idetape_write_filemark(drive);
 	idetape_flush_tape_buffers(drive);
-- 
1.5.4.1


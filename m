Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYDGEqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYDGEqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 00:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYDGEpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 00:45:02 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:13177 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbYDGEou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 00:44:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=i26lU0b5sPkAcEzBtyErE2ExjC0U//z3JfxJBSRpnz5QA59mS3v96utScNk3P6OHd7zZWbSyaQ/XpFXy14TMdS1IznxhK+Hlx1BUmqLCfXQXTal8MgWUtas3ho+QHUqqGUZ+izJISPDoozyc0Zxqg9ze6eK3dB0s/n+/WOt4Y1U=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 4/6] ide-tape: mv tape->merge_stage_size tape->merge_bh_size
Date: Mon,  7 Apr 2008 06:45:02 +0200
Message-Id: <1207543504-27888-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
References: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the size of the merge buffer.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   61 ++++++++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index d5ca673..d7fee6e 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -310,7 +310,8 @@ typedef struct ide_tape_obj {
 	/* Data buffer size chosen based on the tape's recommendation */
 	int buffer_size;
 	idetape_stage_t *merge_stage;
-	int merge_stage_size;
+	/* size of the merge buffer */
+	int merge_bh_size;
 	struct idetape_bh *bh;
 	char *b_data;
 	int b_count;
@@ -1649,7 +1650,7 @@ static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 		return;
 
 	clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
-	tape->merge_stage_size = 0;
+	tape->merge_bh_size = 0;
 	if (tape->merge_stage != NULL) {
 		ide_tape_kfree_buffer(tape->merge_stage);
 		tape->merge_stage = NULL;
@@ -1790,17 +1791,17 @@ static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 				" but we are not writing.\n");
 		return;
 	}
-	if (tape->merge_stage_size > tape->buffer_size) {
+	if (tape->merge_bh_size > tape->buffer_size) {
 		printk(KERN_ERR "ide-tape: bug: merge_buffer too big\n");
-		tape->merge_stage_size = tape->buffer_size;
+		tape->merge_bh_size = tape->buffer_size;
 	}
-	if (tape->merge_stage_size) {
-		blocks = tape->merge_stage_size / tape->blk_size;
-		if (tape->merge_stage_size % tape->blk_size) {
+	if (tape->merge_bh_size) {
+		blocks = tape->merge_bh_size / tape->blk_size;
+		if (tape->merge_bh_size % tape->blk_size) {
 			unsigned int i;
 
 			blocks++;
-			i = tape->blk_size - tape->merge_stage_size %
+			i = tape->blk_size - tape->merge_bh_size %
 				tape->blk_size;
 			bh = tape->bh->b_reqnext;
 			while (bh) {
@@ -1824,7 +1825,7 @@ static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 			}
 		}
 		(void) idetape_add_chrdev_write_request(drive, blocks);
-		tape->merge_stage_size = 0;
+		tape->merge_bh_size = 0;
 	}
 	if (tape->merge_stage != NULL) {
 		ide_tape_kfree_buffer(tape->merge_stage);
@@ -1844,10 +1845,10 @@ static int idetape_init_read(ide_drive_t *drive)
 			ide_tape_flush_merge_buffer(drive);
 			idetape_flush_tape_buffers(drive);
 		}
-		if (tape->merge_stage || tape->merge_stage_size) {
-			printk(KERN_ERR "ide-tape: merge_stage_size should be"
+		if (tape->merge_stage || tape->merge_bh_size) {
+			printk(KERN_ERR "ide-tape: merge_bh_size should be"
 					 " 0 now\n");
-			tape->merge_stage_size = 0;
+			tape->merge_bh_size = 0;
 		}
 		tape->merge_stage = ide_tape_kmalloc_buffer(tape, 0, 0);
 		if (!tape->merge_stage)
@@ -1993,7 +1994,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	}
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
-		tape->merge_stage_size = 0;
+		tape->merge_bh_size = 0;
 		if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 			++count;
 		ide_tape_discard_merge_buffer(drive, 0);
@@ -2063,13 +2064,13 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		return rc;
 	if (count == 0)
 		return (0);
-	if (tape->merge_stage_size) {
-		actually_read = min((unsigned int)(tape->merge_stage_size),
+	if (tape->merge_bh_size) {
+		actually_read = min((unsigned int)(tape->merge_bh_size),
 				    (unsigned int)count);
 		if (idetape_copy_stage_to_user(tape, buf, actually_read))
 			ret = -EFAULT;
 		buf += actually_read;
-		tape->merge_stage_size -= actually_read;
+		tape->merge_bh_size -= actually_read;
 		count -= actually_read;
 	}
 	while (count >= tape->buffer_size) {
@@ -2090,7 +2091,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		if (idetape_copy_stage_to_user(tape, buf, temp))
 			ret = -EFAULT;
 		actually_read += temp;
-		tape->merge_stage_size = bytes_read-temp;
+		tape->merge_bh_size = bytes_read-temp;
 	}
 finish:
 	if (!actually_read && test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags)) {
@@ -2122,10 +2123,10 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
 		if (tape->chrdev_dir == IDETAPE_DIR_READ)
 			ide_tape_discard_merge_buffer(drive, 1);
-		if (tape->merge_stage || tape->merge_stage_size) {
-			printk(KERN_ERR "ide-tape: merge_stage_size "
+		if (tape->merge_stage || tape->merge_bh_size) {
+			printk(KERN_ERR "ide-tape: merge_bh_size "
 				"should be 0 now\n");
-			tape->merge_stage_size = 0;
+			tape->merge_bh_size = 0;
 		}
 		tape->merge_stage = ide_tape_kmalloc_buffer(tape, 0, 0);
 		if (!tape->merge_stage)
@@ -2153,23 +2154,23 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	}
 	if (count == 0)
 		return (0);
-	if (tape->merge_stage_size) {
-		if (tape->merge_stage_size >= tape->buffer_size) {
+	if (tape->merge_bh_size) {
+		if (tape->merge_bh_size >= tape->buffer_size) {
 			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
-			tape->merge_stage_size = 0;
+			tape->merge_bh_size = 0;
 		}
 		actually_written = min((unsigned int)
-				(tape->buffer_size - tape->merge_stage_size),
+				(tape->buffer_size - tape->merge_bh_size),
 				(unsigned int)count);
 		if (idetape_copy_stage_from_user(tape, buf, actually_written))
 				ret = -EFAULT;
 		buf += actually_written;
-		tape->merge_stage_size += actually_written;
+		tape->merge_bh_size += actually_written;
 		count -= actually_written;
 
-		if (tape->merge_stage_size == tape->buffer_size) {
+		if (tape->merge_bh_size == tape->buffer_size) {
 			ssize_t retval;
-			tape->merge_stage_size = 0;
+			tape->merge_bh_size = 0;
 			retval = idetape_add_chrdev_write_request(drive, ctl);
 			if (retval <= 0)
 				return (retval);
@@ -2190,7 +2191,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		actually_written += count;
 		if (idetape_copy_stage_from_user(tape, buf, count))
 			ret = -EFAULT;
-		tape->merge_stage_size += count;
+		tape->merge_bh_size += count;
 	}
 	return ret ? ret : actually_written;
 }
@@ -2361,7 +2362,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 		idetape_flush_tape_buffers(drive);
 	}
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
-		block_offset = tape->merge_stage_size /
+		block_offset = tape->merge_bh_size /
 			(tape->blk_size * tape->user_bs_factor);
 		position = idetape_read_position(drive);
 		if (position < 0)
@@ -2790,7 +2791,7 @@ static void ide_tape_release(struct kref *kref)
 	ide_drive_t *drive = tape->drive;
 	struct gendisk *g = tape->disk;
 
-	BUG_ON(tape->merge_stage_size);
+	BUG_ON(tape->merge_bh_size);
 
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
-- 
1.5.4.1


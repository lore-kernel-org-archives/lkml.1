Return-Path: <linux-kernel-owner+w=401wt.eu-S1762524AbZCYOUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762524AbZCYOUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761752AbZCYOSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:18:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:57748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761563AbZCYOSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:18:10 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] ide-tape: use byte size instead of sectors on rw issue functions
Date: Wed, 25 Mar 2009 23:17:50 +0900
Message-Id: <1237990673-8358-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237990673-8358-1-git-send-email-tj@kernel.org>
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 14:18:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Byte size is what most issue functions deal with, make
idetape_queue_rw_tail() and its wrappers take byte size instead of
sector counts.  idetape_chrdev_read() and write() functions are
converted to use tape->buffer_size instead of ctl from tape->cap.

This cleans up code a little bit and will ease the next r/w
reimplementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ide/ide-tape.c |   45 ++++++++++++++++++++-------------------------
 1 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index c013954..5fc3282 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -879,15 +879,15 @@ static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
  * Generate a read/write request for the block device interface and wait for it
  * to be serviced.
  */
-static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks)
+static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	size_t size = blocks * tape->blk_size;
 	struct request *rq;
 	int ret;
 
 	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
 	BUG_ON(cmd != REQ_IDETAPE_READ && cmd != REQ_IDETAPE_WRITE);
+	BUG_ON(size < 0 || size % tape->blk_size);
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
@@ -954,17 +954,16 @@ static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 }
 
 /* Queue up a character device originated write request. */
-static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
+static int idetape_add_chrdev_write_request(ide_drive_t *drive, int size)
 {
 	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
-	return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks);
+	return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, size);
 }
 
 static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	int blocks;
 
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
 		printk(KERN_ERR "ide-tape: bug: Trying to empty merge buffer"
@@ -972,15 +971,10 @@ static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 		return;
 	}
 	if (tape->buf) {
-		blocks = tape->valid / tape->blk_size;
-		if (tape->valid % tape->blk_size) {
-			blocks++;
-			memset(tape->buf + tape->valid, 0,
-			       tape->blk_size - tape->valid % tape->blk_size);
-		}
-		(void) idetape_add_chrdev_write_request(drive, blocks);
-	}
-	if (tape->buf != NULL) {
+		size_t aligned = roundup(tape->valid, tape->blk_size);
+
+		memset(tape->cur + tape->valid, 0, aligned - tape->valid);
+		idetape_add_chrdev_write_request(drive, aligned);
 		kfree(tape->buf);
 		tape->buf = NULL;
 	}
@@ -1034,9 +1028,9 @@ static int idetape_init_rw(ide_drive_t *drive, int dir)
 }
 
 /* called from idetape_chrdev_read() to service a chrdev read request. */
-static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
+static int idetape_add_chrdev_read_request(ide_drive_t *drive, int size)
 {
-	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
+	debug_log(DBG_PROCS, "Enter %s, %d bytes\n", __func__, size);
 
 	/* If we are at a filemark, return a read length of 0 */
 	if (test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
@@ -1044,7 +1038,7 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 
 	idetape_init_rw(drive, IDETAPE_DIR_READ);
 
-	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks);
+	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, size);
 }
 
 static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
@@ -1056,8 +1050,7 @@ static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 	while (bcount) {
 		unsigned int count = min(tape->buffer_size, bcount);
 
-		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
-				      count / tape->blk_size);
+		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, count);
 		bcount -= count;
 	}
 }
@@ -1189,7 +1182,6 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	ide_drive_t *drive = tape->drive;
 	ssize_t bytes_read, temp, actually_read = 0, rc;
 	ssize_t ret = 0;
-	u16 ctl = *(u16 *)&tape->caps[12];
 
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
@@ -1214,7 +1206,8 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		tape->valid -= actually_read;
 	}
 	while (count >= tape->buffer_size) {
-		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
+		bytes_read = idetape_add_chrdev_read_request(drive,
+							     tape->buffer_size);
 		if (bytes_read <= 0)
 			goto finish;
 		if (copy_to_user(buf, tape->cur, bytes_read))
@@ -1224,7 +1217,8 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		actually_read += bytes_read;
 	}
 	if (count) {
-		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
+		bytes_read = idetape_add_chrdev_read_request(drive,
+							     tape->buffer_size);
 		if (bytes_read <= 0)
 			goto finish;
 		temp = min((unsigned long)count, (unsigned long)bytes_read);
@@ -1252,7 +1246,6 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	ide_drive_t *drive = tape->drive;
 	ssize_t actually_written = 0;
 	ssize_t ret = 0;
-	u16 ctl = *(u16 *)&tape->caps[12];
 	int rc;
 
 	/* The drive is write protected. */
@@ -1280,7 +1273,8 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 
 		if (tape->valid == tape->buffer_size) {
 			ssize_t retval;
-			retval = idetape_add_chrdev_write_request(drive, ctl);
+			retval = idetape_add_chrdev_write_request(drive,
+							tape->buffer_size);
 			if (retval <= 0)
 				return (retval);
 		}
@@ -1291,7 +1285,8 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 			ret = -EFAULT;
 		buf += tape->buffer_size;
 		count -= tape->buffer_size;
-		retval = idetape_add_chrdev_write_request(drive, ctl);
+		retval = idetape_add_chrdev_write_request(drive,
+							  tape->buffer_size);
 		actually_written += tape->buffer_size;
 		if (retval <= 0)
 			return (retval);
-- 
1.6.0.2


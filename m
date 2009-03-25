Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbZCYOUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbZCYOUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761727AbZCYOST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:18:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:57745 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761483AbZCYOSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:18:09 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] ide-tape: unify r/w init paths
Date: Wed, 25 Mar 2009 23:17:49 +0900
Message-Id: <1237990673-8358-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237990673-8358-1-git-send-email-tj@kernel.org>
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 14:18:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Read and write init paths are almost identical.  Unify them into
idetape_init_rw().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ide/ide-tape.c |  106 +++++++++++++++++++-----------------------------
 1 files changed, 42 insertions(+), 64 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index e7f351b..c013954 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -987,42 +987,46 @@ static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 }
 
-static int idetape_init_read(ide_drive_t *drive)
+static int idetape_init_rw(ide_drive_t *drive, int dir)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	int bytes_read;
 
-	/* Initialize read operation */
-	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
-		if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-			ide_tape_flush_merge_buffer(drive);
-			idetape_flush_tape_buffers(drive);
-		}
-		if (tape->buf || tape->valid) {
-			printk(KERN_ERR "ide-tape: valid should be 0 now\n");
-			tape->valid = 0;
-		}
-		tape->buf = kmalloc(tape->buffer_size, GFP_KERNEL);
-		if (!tape->buf)
-			return -ENOMEM;
-		tape->chrdev_dir = IDETAPE_DIR_READ;
-		tape->cur = tape->buf;
+	if (tape->chrdev_dir == dir)
+		return 0;
 
-		/*
-		 * Issue a read 0 command to ensure that DSC handshake is
-		 * switched from completion mode to buffer available mode.
-		 * No point in issuing this if DSC overlap isn't supported, some
-		 * drives (Seagate STT3401A) will return an error.
-		 */
-		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
-			bytes_read = idetape_queue_rw_tail(drive,
-							REQ_IDETAPE_READ, 0);
-			if (bytes_read < 0) {
-				kfree(tape->buf);
-				tape->buf = NULL;
-				tape->chrdev_dir = IDETAPE_DIR_NONE;
-				return bytes_read;
-			}
+	if (tape->chrdev_dir == IDETAPE_DIR_READ)
+		ide_tape_discard_merge_buffer(drive, 1);
+	else if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
+		ide_tape_flush_merge_buffer(drive);
+		idetape_flush_tape_buffers(drive);
+	}
+
+	if (tape->buf || tape->valid) {
+		printk(KERN_ERR "ide-tape: valid should be 0 now\n");
+		tape->valid = 0;
+	}
+
+	tape->buf = kmalloc(tape->buffer_size, GFP_KERNEL);
+	if (!tape->buf)
+		return -ENOMEM;
+	tape->chrdev_dir = dir;
+	tape->cur = tape->buf;
+
+	/*
+	 * Issue a 0 rw command to ensure that DSC handshake is
+	 * switched from completion mode to buffer available mode.  No
+	 * point in issuing this if DSC overlap isn't supported, some
+	 * drives (Seagate STT3401A) will return an error.
+	 */
+	if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
+		int rc;
+
+		rc = idetape_queue_rw_tail(drive, dir, 0);
+		if (rc < 0) {
+			kfree(tape->buf);
+			tape->buf = NULL;
+			tape->chrdev_dir = IDETAPE_DIR_NONE;
+			return rc;
 		}
 	}
 
@@ -1038,7 +1042,7 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	if (test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
 		return 0;
 
-	idetape_init_read(drive);
+	idetape_init_rw(drive, IDETAPE_DIR_READ);
 
 	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks);
 }
@@ -1195,7 +1199,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
 	}
-	rc = idetape_init_read(drive);
+	rc = idetape_init_rw(drive, IDETAPE_DIR_READ);
 	if (rc < 0)
 		return rc;
 	if (count == 0)
@@ -1249,6 +1253,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	ssize_t actually_written = 0;
 	ssize_t ret = 0;
 	u16 ctl = *(u16 *)&tape->caps[12];
+	int rc;
 
 	/* The drive is write protected. */
 	if (tape->write_prot)
@@ -1257,36 +1262,9 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	/* Initialize write operation */
-	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
-		if (tape->chrdev_dir == IDETAPE_DIR_READ)
-			ide_tape_discard_merge_buffer(drive, 1);
-		if (tape->buf || tape->valid) {
-			printk(KERN_ERR "ide-tape: valid should be 0 now\n");
-			tape->valid = 0;
-		}
-		tape->buf = kmalloc(tape->buffer_size, GFP_KERNEL);
-		if (!tape->buf)
-			return -ENOMEM;
-		tape->chrdev_dir = IDETAPE_DIR_WRITE;
-		tape->cur = tape->buf;
-
-		/*
-		 * Issue a write 0 command to ensure that DSC handshake is
-		 * switched from completion mode to buffer available mode. No
-		 * point in issuing this if DSC overlap isn't supported, some
-		 * drives (Seagate STT3401A) will return an error.
-		 */
-		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
-			ssize_t retval = idetape_queue_rw_tail(drive,
-							REQ_IDETAPE_WRITE, 0);
-			if (retval < 0) {
-				kfree(tape->buf);
-				tape->buf = NULL;
-				tape->chrdev_dir = IDETAPE_DIR_NONE;
-				return retval;
-			}
-		}
-	}
+	rc = idetape_init_rw(drive, IDETAPE_DIR_WRITE);
+	if (rc < 0)
+		return rc;
 	if (count == 0)
 		return (0);
 	if (tape->valid < tape->buffer_size) {
-- 
1.6.0.2


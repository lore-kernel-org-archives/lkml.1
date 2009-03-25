Return-Path: <linux-kernel-owner+w=401wt.eu-S1762555AbZCYOVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762555AbZCYOVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZCYOSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:18:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:57750 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761631AbZCYOSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:18:11 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] ide-tape: simplify read/write functions
Date: Wed, 25 Mar 2009 23:17:51 +0900
Message-Id: <1237990673-8358-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237990673-8358-1-git-send-email-tj@kernel.org>
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 14:18:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

idetape_chrdev_read/write() functions are unnecessarily complex when
everything can be handled in a single loop.  Collapse
idetape_add_chrdev_read/write_request() into the rw functions and
simplify the implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ide/ide-tape.c |  149 ++++++++++++++++--------------------------------
 1 files changed, 50 insertions(+), 99 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 5fc3282..95e9131 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -953,14 +953,6 @@ static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 }
 
-/* Queue up a character device originated write request. */
-static int idetape_add_chrdev_write_request(ide_drive_t *drive, int size)
-{
-	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
-
-	return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, size);
-}
-
 static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -974,7 +966,7 @@ static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 		size_t aligned = roundup(tape->valid, tape->blk_size);
 
 		memset(tape->cur + tape->valid, 0, aligned - tape->valid);
-		idetape_add_chrdev_write_request(drive, aligned);
+		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, aligned);
 		kfree(tape->buf);
 		tape->buf = NULL;
 	}
@@ -1027,20 +1019,6 @@ static int idetape_init_rw(ide_drive_t *drive, int dir)
 	return 0;
 }
 
-/* called from idetape_chrdev_read() to service a chrdev read request. */
-static int idetape_add_chrdev_read_request(ide_drive_t *drive, int size)
-{
-	debug_log(DBG_PROCS, "Enter %s, %d bytes\n", __func__, size);
-
-	/* If we are at a filemark, return a read length of 0 */
-	if (test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
-		return 0;
-
-	idetape_init_rw(drive, IDETAPE_DIR_READ);
-
-	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, size);
-}
-
 static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -1180,8 +1158,9 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 {
 	struct ide_tape_obj *tape = file->private_data;
 	ide_drive_t *drive = tape->drive;
-	ssize_t bytes_read, temp, actually_read = 0, rc;
+	size_t done = 0;
 	ssize_t ret = 0;
+	int rc;
 
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
@@ -1191,52 +1170,43 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
 	}
+
 	rc = idetape_init_rw(drive, IDETAPE_DIR_READ);
 	if (rc < 0)
 		return rc;
-	if (count == 0)
-		return (0);
-	if (tape->valid) {
-		actually_read = min_t(unsigned int, tape->valid, count);
-		if (copy_to_user(buf, tape->cur, actually_read))
-			ret = -EFAULT;
-		buf += actually_read;
-		count -= actually_read;
-		tape->cur += actually_read;
-		tape->valid -= actually_read;
-	}
-	while (count >= tape->buffer_size) {
-		bytes_read = idetape_add_chrdev_read_request(drive,
-							     tape->buffer_size);
-		if (bytes_read <= 0)
-			goto finish;
-		if (copy_to_user(buf, tape->cur, bytes_read))
-			ret = -EFAULT;
-		buf += bytes_read;
-		count -= bytes_read;
-		actually_read += bytes_read;
-	}
-	if (count) {
-		bytes_read = idetape_add_chrdev_read_request(drive,
-							     tape->buffer_size);
-		if (bytes_read <= 0)
-			goto finish;
-		temp = min((unsigned long)count, (unsigned long)bytes_read);
-		if (copy_to_user(buf, tape->cur, temp))
+
+	while (done < count) {
+		size_t todo;
+
+		/* refill if staging buffer is empty */
+		if (!tape->valid) {
+			/* If we are at a filemark, nothing more to read */
+			if (test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
+				break;
+			/* read */
+			if (idetape_queue_rw_tail(drive, REQ_IDETAPE_READ,
+						  tape->buffer_size) <= 0)
+				break;
+		}
+
+		/* copy out */
+		todo = min_t(size_t, count - done, tape->valid);
+		if (copy_to_user(buf + done, tape->cur, todo))
 			ret = -EFAULT;
-		actually_read += temp;
-		tape->cur += temp;
-		tape->valid -= temp;
+
+		tape->cur += todo;
+		tape->valid -= todo;
+		done += todo;
 	}
-finish:
-	if (!actually_read && test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags)) {
+
+	if (!done && test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags)) {
 		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
 
 		idetape_space_over_filemarks(drive, MTFSF, 1);
 		return 0;
 	}
 
-	return ret ? ret : actually_read;
+	return ret ? ret : done;
 }
 
 static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
@@ -1244,7 +1214,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 {
 	struct ide_tape_obj *tape = file->private_data;
 	ide_drive_t *drive = tape->drive;
-	ssize_t actually_written = 0;
+	size_t done = 0;
 	ssize_t ret = 0;
 	int rc;
 
@@ -1258,47 +1228,28 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	rc = idetape_init_rw(drive, IDETAPE_DIR_WRITE);
 	if (rc < 0)
 		return rc;
-	if (count == 0)
-		return (0);
-	if (tape->valid < tape->buffer_size) {
-		actually_written = min_t(unsigned int,
-					 tape->buffer_size - tape->valid,
-					 count);
-		if (copy_from_user(tape->cur, buf, actually_written))
-			ret = -EFAULT;
-		buf += actually_written;
-		count -= actually_written;
-		tape->cur += actually_written;
-		tape->valid += actually_written;
-
-		if (tape->valid == tape->buffer_size) {
-			ssize_t retval;
-			retval = idetape_add_chrdev_write_request(drive,
-							tape->buffer_size);
-			if (retval <= 0)
-				return (retval);
-		}
-	}
-	while (count >= tape->buffer_size) {
-		ssize_t retval;
-		if (copy_from_user(tape->cur, buf, tape->buffer_size))
-			ret = -EFAULT;
-		buf += tape->buffer_size;
-		count -= tape->buffer_size;
-		retval = idetape_add_chrdev_write_request(drive,
-							  tape->buffer_size);
-		actually_written += tape->buffer_size;
-		if (retval <= 0)
-			return (retval);
-	}
-	if (count) {
-		actually_written += count;
-		if (copy_from_user(tape->cur, buf, count))
+
+	while (done < count) {
+		size_t todo;
+
+		/* flush if staging buffer is full */
+		if (tape->valid == tape->buffer_size &&
+		    idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
+					  tape->buffer_size) <= 0)
+			return rc;
+
+		/* copy in */
+		todo = min_t(size_t, count - done,
+			     tape->buffer_size - tape->valid);
+		if (copy_from_user(tape->cur, buf + done, todo))
 			ret = -EFAULT;
-		tape->cur += count;
-		tape->valid += count;
+
+		tape->cur += todo;
+		tape->valid += todo;
+		done += todo;
 	}
-	return ret ? ret : actually_written;
+
+	return ret ? ret : done;
 }
 
 static int idetape_write_filemark(ide_drive_t *drive)
-- 
1.6.0.2


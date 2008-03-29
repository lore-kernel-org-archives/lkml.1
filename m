Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYC2RrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYC2RrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYC2RqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:46:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:49389 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbYC2RqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=BdSShP56fTmSviA45awcyjWrrhSytdzDwAVfwX+t0MWyJVvTAcpc2m3pwDA9NSWhSt6b0PjQyR7LJRWf2M2R562XcCo556Xgz7AVntIsOmIZVZ6Z3TFVc6VtiLSSzTnEySr3kKMPYHpf/qswJ41nhpLMfXSZvFLT1aRdCZnF8aE=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/5] ide-tape: mv tape->stage_size  tape->buffer_size
Date: Sat, 29 Mar 2008 18:46:06 +0100
Message-Id: <1206812769-10065-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1206812769-10065-1-git-send-email-petkovbb@gmail.com>
References: <1206812769-10065-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   58 ++++++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index b5ec669..7fa0cc0 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -308,7 +308,7 @@ typedef struct ide_tape_obj {
 	 */
 
 	/* Data buffer size chosen based on the tape's recommendation */
-	int stage_size;
+	int buffer_size;
 	idetape_stage_t *merge_stage;
 	int merge_stage_size;
 	struct idetape_bh *bh;
@@ -1168,7 +1168,7 @@ static void idetape_create_read_cmd(idetape_tape_t *tape,
 	pc->buf = NULL;
 	pc->buf_size = length * tape->blk_size;
 	pc->req_xfer = pc->buf_size;
-	if (pc->req_xfer == tape->stage_size)
+	if (pc->req_xfer == tape->buffer_size)
 		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
@@ -1188,7 +1188,7 @@ static void idetape_create_write_cmd(idetape_tape_t *tape,
 	pc->buf = NULL;
 	pc->buf_size = length * tape->blk_size;
 	pc->req_xfer = pc->buf_size;
-	if (pc->req_xfer == tape->stage_size)
+	if (pc->req_xfer == tape->buffer_size)
 		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
@@ -1291,7 +1291,7 @@ out:
 
 /*
  * The function below uses __get_free_pages to allocate a data buffer of size
- * tape->stage_size (or a bit more). We attempt to combine sequential pages as
+ * tape->buffer_size (or a bit more). We attempt to combine sequential pages as
  * much as possible.
  *
  * It returns a pointer to the newly allocated buffer, or NULL in case of
@@ -1792,9 +1792,9 @@ static void idetape_empty_write_pipeline(ide_drive_t *drive)
 				" but we are not writing.\n");
 		return;
 	}
-	if (tape->merge_stage_size > tape->stage_size) {
+	if (tape->merge_stage_size > tape->buffer_size) {
 		printk(KERN_ERR "ide-tape: bug: merge_buffer too big\n");
-		tape->merge_stage_size = tape->stage_size;
+		tape->merge_stage_size = tape->buffer_size;
 	}
 	if (tape->merge_stage_size) {
 		blocks = tape->merge_stage_size / tape->blk_size;
@@ -1905,7 +1905,7 @@ static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 		unsigned int count;
 
 		bh = tape->merge_stage->bh;
-		count = min(tape->stage_size, bcount);
+		count = min(tape->buffer_size, bcount);
 		bcount -= count;
 		blocks = count / tape->blk_size;
 		while (count) {
@@ -2074,7 +2074,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		tape->merge_stage_size -= actually_read;
 		count -= actually_read;
 	}
-	while (count >= tape->stage_size) {
+	while (count >= tape->buffer_size) {
 		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
@@ -2156,12 +2156,12 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	if (count == 0)
 		return (0);
 	if (tape->merge_stage_size) {
-		if (tape->merge_stage_size >= tape->stage_size) {
+		if (tape->merge_stage_size >= tape->buffer_size) {
 			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
 			tape->merge_stage_size = 0;
 		}
 		actually_written = min((unsigned int)
-				(tape->stage_size - tape->merge_stage_size),
+				(tape->buffer_size - tape->merge_stage_size),
 				(unsigned int)count);
 		if (idetape_copy_stage_from_user(tape, buf, actually_written))
 				ret = -EFAULT;
@@ -2169,7 +2169,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		tape->merge_stage_size += actually_written;
 		count -= actually_written;
 
-		if (tape->merge_stage_size == tape->stage_size) {
+		if (tape->merge_stage_size == tape->buffer_size) {
 			ssize_t retval;
 			tape->merge_stage_size = 0;
 			retval = idetape_add_chrdev_write_request(drive, ctl);
@@ -2177,14 +2177,14 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 				return (retval);
 		}
 	}
-	while (count >= tape->stage_size) {
+	while (count >= tape->buffer_size) {
 		ssize_t retval;
-		if (idetape_copy_stage_from_user(tape, buf, tape->stage_size))
+		if (idetape_copy_stage_from_user(tape, buf, tape->buffer_size))
 			ret = -EFAULT;
-		buf += tape->stage_size;
-		count -= tape->stage_size;
+		buf += tape->buffer_size;
+		count -= tape->buffer_size;
 		retval = idetape_add_chrdev_write_request(drive, ctl);
-		actually_written += tape->stage_size;
+		actually_written += tape->buffer_size;
 		if (retval <= 0)
 			return (retval);
 	}
@@ -2678,8 +2678,8 @@ static void idetape_add_settings(ide_drive_t *drive)
 			1, 2, (u16 *)&tape->caps[16], NULL);
 	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 1, (u16 *)&tape->caps[14], NULL);
-	ide_add_setting(drive, "stage", SETTING_READ, TYPE_INT,	0, 0xffff, 1,
-			1024, &tape->stage_size, NULL);
+	ide_add_setting(drive, "buffer_size", SETTING_READ, TYPE_INT, 0, 0xffff,
+			1, 1024, &tape->buffer_size, NULL);
 	ide_add_setting(drive, "tdsc", SETTING_RW, TYPE_INT, IDETAPE_DSC_RW_MIN,
 			IDETAPE_DSC_RW_MAX, 1000, HZ, &tape->best_dsc_rw_freq,
 			NULL);
@@ -2709,7 +2709,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 {
 	unsigned long t;
 	int speed;
-	int stage_size;
+	int buffer_size;
 	u8 gcw[2];
 	u16 *ctl = (u16 *)&tape->caps[12];
 
@@ -2739,23 +2739,23 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	idetape_get_mode_sense_results(drive);
 	ide_tape_get_bsize_from_bdesc(drive);
 	tape->user_bs_factor = 1;
-	tape->stage_size = *ctl * tape->blk_size;
-	while (tape->stage_size > 0xffff) {
+	tape->buffer_size = *ctl * tape->blk_size;
+	while (tape->buffer_size > 0xffff) {
 		printk(KERN_NOTICE "ide-tape: decreasing stage size\n");
 		*ctl /= 2;
-		tape->stage_size = *ctl * tape->blk_size;
+		tape->buffer_size = *ctl * tape->blk_size;
 	}
-	stage_size = tape->stage_size;
-	tape->pages_per_stage = stage_size / PAGE_SIZE;
-	if (stage_size % PAGE_SIZE) {
+	buffer_size = tape->buffer_size;
+	tape->pages_per_stage = buffer_size / PAGE_SIZE;
+	if (buffer_size % PAGE_SIZE) {
 		tape->pages_per_stage++;
-		tape->excess_bh_size = PAGE_SIZE - stage_size % PAGE_SIZE;
+		tape->excess_bh_size = PAGE_SIZE - buffer_size % PAGE_SIZE;
 	}
 
 	/* select the "best" DSC read/write polling freq */
 	speed = max(*(u16 *)&tape->caps[14], *(u16 *)&tape->caps[8]);
 
-	t = (IDETAPE_FIFO_THRESHOLD * tape->stage_size * HZ) / (speed * 1000);
+	t = (IDETAPE_FIFO_THRESHOLD * tape->buffer_size * HZ) / (speed * 1000);
 
 	/*
 	 * Ensure that the number we got makes sense; limit it within
@@ -2767,8 +2767,8 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
 		"%lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
-		(*(u16 *)&tape->caps[16] * 512) / tape->stage_size,
-		tape->stage_size / 1024,
+		(*(u16 *)&tape->caps[16] * 512) / tape->buffer_size,
+		tape->buffer_size / 1024,
 		tape->best_dsc_rw_freq * 1000 / HZ,
 		drive->using_dma ? ", DMA":"");
 
-- 
1.5.4.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762007AbYCAJBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007AbYCAJBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbYCAI7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:64804 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbYCAI7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=WBUvGLw3Uwm76n2Idequ6HqE1BHnlVnpyYEc/e+eNLv8Ski9X+8C4jHfou3sElU3S7IAohcnSNTtKv0cmtMcks+XMV732VMSp92RuZB/clrdQnXHiy4isBD+4lbxRyJkmRdLLEaIxJgJgigvbPXAap++q5YEa7f+RyiXQ3Xayrk=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [RFCPATCH 10/24] ide-tape: remove pipeline-specific code from idetape_chrdev_ioctl
Date: Sat,  1 Mar 2008 09:58:34 +0100
Message-Id: <1204361928-30229-11-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function used to compute the block_offset in order to write it
into mtget.mt_blkno, among others, by going over the stages still
present in the pipeline and adding the sectors left to submit in each
request. This was being done in idetape_pipeline_size() so remove it.
Since we do non-pipelined operation only, compute the offset now
from the sectors left to submit in the currently active request.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   39 +++++++++------------------------------
 1 files changed, 9 insertions(+), 30 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index dd11c7b..447b7b4 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2353,27 +2353,6 @@ static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 	}
 }
 
-static int idetape_pipeline_size(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *stage;
-	struct request *rq;
-	int size = 0;
-
-	idetape_wait_for_pipeline(drive);
-	stage = tape->first_stage;
-	while (stage != NULL) {
-		rq = &stage->rq;
-		size += tape->blk_size * (rq->nr_sectors -
-				rq->current_nr_sectors);
-		if (rq->errors == IDETAPE_ERROR_FILEMARK)
-			size += tape->blk_size;
-		stage = stage->next;
-	}
-	size += tape->merge_stage_size;
-	return size;
-}
-
 /*
  * Rewinds the tape to the Beginning Of the current Partition (BOP). We
  * currently support only one partition.
@@ -2779,7 +2758,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 
 /*
  * Our character device ioctls. General mtio.h magnetic io commands are
- * supported here, and not in the corresponding block interface. Our own
+ * supported here and not in the corresponding block interface. Our own
  * ide-tape ioctls are supported on both interfaces.
  */
 static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
@@ -2795,18 +2774,20 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 
 	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
 
-	tape->restart_speed_control_req = 1;
-	if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-		idetape_empty_write_pipeline(drive);
+	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		idetape_flush_tape_buffers(drive);
-	}
+
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
-		block_offset = idetape_pipeline_size(drive) /
-			(tape->blk_size * tape->user_bs_factor);
+		struct request *rq = tape->active_data_rq;
+
+		block_offset = (rq->nr_sectors - rq->current_nr_sectors) /
+			       (tape->blk_size * tape->user_bs_factor);
+
 		position = idetape_read_position(drive);
 		if (position < 0)
 			return -EIO;
 	}
+
 	switch (cmd) {
 	case MTIOCTOP:
 		if (copy_from_user(&mtop, argp, sizeof(struct mtop)))
@@ -2832,8 +2813,6 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 			return -EFAULT;
 		return 0;
 	default:
-		if (tape->chrdev_dir == IDETAPE_DIR_READ)
-			idetape_discard_read_pipeline(drive, 1);
 		return idetape_blkdev_ioctl(drive, cmd, arg);
 	}
 }
-- 
1.5.4.1


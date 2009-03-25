Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbZCYOSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbZCYOSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761496AbZCYOSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:18:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:57731 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbZCYOSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:18:06 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] ide-tape: use standard data transfer mechanism
Date: Wed, 25 Mar 2009 23:17:47 +0900
Message-Id: <1237990673-8358-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237990673-8358-1-git-send-email-tj@kernel.org>
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 14:18:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use standard way to transfer data

Now that data area is represented with bio, there is no need to use
custom data transfer methods.  Drop idetape_io_buffers() and
idetape_update_buffers().  pc->bh is set to null to tell ide-atapi to
use standard data transfer mechanism and idetape_bh byte counts are
updated by the issuer on completion using the residual count.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ide/ide-tape.c |   84 +++--------------------------------------------
 1 files changed, 6 insertions(+), 78 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index bd0e839..dd37fd7 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -292,65 +292,6 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 	return tape;
 }
 
-static int idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				  unsigned int bcount)
-{
-	struct idetape_bh *bh = pc->bh;
-	int count;
-
-	if (bcount && bh) {
-		count = min(
-			(unsigned int)(bh->b_size - atomic_read(&bh->b_count)),
-			bcount);
-		drive->hwif->tp_ops->input_data(drive, NULL, bh->b_data +
-					atomic_read(&bh->b_count), count);
-		bcount -= count;
-		atomic_add(count, &bh->b_count);
-		if (atomic_read(&bh->b_count) == bh->b_size)
-			pc->bh = NULL;
-	}
-
-	return bcount;
-}
-
-static int idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				   unsigned int bcount)
-{
-	struct idetape_bh *bh = pc->bh;
-	int count;
-
-	if (bcount && bh) {
-		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
-		drive->hwif->tp_ops->output_data(drive, NULL, pc->b_data, count);
-		bcount -= count;
-		pc->b_data += count;
-		pc->b_count -= count;
-		if (!pc->b_count)
-			pc->bh = NULL;
-	}
-
-	return bcount;
-}
-
-static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
-{
-	struct idetape_bh *bh = pc->bh;
-	unsigned int bcount = pc->xferred;
-
-	if (pc->flags & PC_FLAG_WRITING)
-		return;
-	if (bcount) {
-		if (bh == NULL || bcount > bh->b_size) {
-			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
-					__func__);
-			return;
-		}
-		atomic_set(&bh->b_count, bcount);
-		if (atomic_read(&bh->b_count) == bh->b_size)
-			pc->bh = NULL;
-	}
-}
-
 /*
  * called on each failed packet command retry to analyze the request sense. We
  * currently do not utilize this information.
@@ -368,12 +309,10 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
 	/* Correct pc->xferred by asking the tape.	 */
-	if (pc->flags & PC_FLAG_DMA_ERROR) {
+	if (pc->flags & PC_FLAG_DMA_ERROR)
 		pc->xferred = pc->req_xfer -
 			tape->blk_size *
 			get_unaligned_be32(&sense[3]);
-		idetape_update_buffers(drive, pc);
-	}
 
 	/*
 	 * If error was the result of a zero-length read or write command,
@@ -520,19 +459,6 @@ static void ide_tape_handle_dsc(ide_drive_t *drive)
 	idetape_postpone_request(drive);
 }
 
-static int ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				unsigned int bcount, int write)
-{
-	unsigned int bleft;
-
-	if (write)
-		bleft = idetape_output_buffers(drive, pc, bcount);
-	else
-		bleft = idetape_input_buffers(drive, pc, bcount);
-
-	return bcount - bleft;
-}
-
 /*
  * Packet Command Interface
  *
@@ -685,7 +611,7 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 	ide_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
-	pc->bh = bh;
+	pc->bh = NULL;
 	pc->buf = NULL;
 	pc->buf_size = length * tape->blk_size;
 	pc->req_xfer = pc->buf_size;
@@ -1083,7 +1009,11 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 
 	blk_execute_rq(drive->queue, tape->disk, rq, 0);
 
+	/* calculate the number of transferred bytes and update bh */
 	size -= rq->data_len;
+	if (cmd == REQ_IDETAPE_READ)
+		atomic_add(size, &bh->b_count);
+
 	ret = size;
 	if (rq->errors == IDE_DRV_ERROR_GENERAL)
 		ret = -EIO;
@@ -2037,8 +1967,6 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	u16 *ctl = (u16 *)&tape->caps[12];
 
 	drive->pc_callback	 = ide_tape_callback;
-	drive->pc_update_buffers = idetape_update_buffers;
-	drive->pc_io_buffers	 = ide_tape_io_buffers;
 
 	drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
 
-- 
1.6.0.2


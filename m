Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYCIRNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYCIRNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbYCIRKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:10:44 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:9332 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbYCIRKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=V4D3kRxXi1jVnlOTTqZDTmbLDfHuxKfjwRyY+2p/QRrfDd2mTVADUVVcWDJSu0f0C60OnVHdtMILqQlXNAlZwAgjf4C6dmLmPQzpssMcmTetJv56hZjAYetGlruWgU4qL5uHEcTBx2T8uZKdBcjXVu9SFG+Atdsxaogr39+codQ=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/4] ide-tape: remove pipeline-specific code from idetape_add_chrdev_write_request
Date: Sun,  9 Mar 2008 18:10:30 +0100
Message-Id: <1205082632-3418-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205082632-3418-1-git-send-email-petkovbb@gmail.com>
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refrain from adding more write requests to the pipeline and queue them
directly on the device's request queue instead. Prior to that flush all
penging stages in the pipeline through idetape_wait_for_pipeline().

The remaining pipeline stage allocation code is used for the next current
pipeline stage (tape->merge_stage) and data buffer for an upcoming
request. The so allocated pipeline stage is rewired into the tape struct
thru idetape_switch_buffers() and used during the next request for
copying user data into it (see e.g. idetape_chrdev_write()). In case the
allocation fails, the current request is still attempted prior to failing.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  103 ++++++++++++------------------------------------
 1 files changed, 26 insertions(+), 77 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 32ba6c8..46a5f95 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2194,83 +2194,6 @@ static void idetape_wait_first_stage(ide_drive_t *drive)
 }
 
 /*
- * Try to add a character device originated write request to our pipeline. In
- * case we don't succeed, we revert to non-pipelined operation mode for this
- * request. In order to accomplish that, we
- *
- * 1. Try to allocate a new pipeline stage.
- * 2. If we can't, wait for more and more requests to be serviced and try again
- * each time.
- * 3. If we still can't allocate a stage, fallback to non-pipelined operation
- * mode for this request.
- */
-static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *new_stage;
-	unsigned long flags;
-	struct request *rq;
-
-	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
-
-	/* Attempt to allocate a new stage. Beware possible race conditions. */
-	while ((new_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL) {
-		spin_lock_irqsave(&tape->lock, flags);
-		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-			idetape_wait_for_request(drive, tape->active_data_rq);
-			spin_unlock_irqrestore(&tape->lock, flags);
-		} else {
-			spin_unlock_irqrestore(&tape->lock, flags);
-			idetape_plug_pipeline(drive);
-			if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
-					&tape->flags))
-				continue;
-			/*
-			 * The machine is short on memory. Fallback to non-
-			 * pipelined operation mode for this request.
-			 */
-			return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
-						blocks, tape->merge_stage->bh);
-		}
-	}
-	rq = &new_stage->rq;
-	idetape_init_rq(rq, REQ_IDETAPE_WRITE);
-	/* Doesn't actually matter - We always assume sequential access */
-	rq->sector = tape->first_frame;
-	rq->current_nr_sectors = blocks;
-	rq->nr_sectors = blocks;
-
-	idetape_switch_buffers(tape, new_stage);
-	idetape_add_stage_tail(drive, new_stage);
-	tape->pipeline_head++;
-	idetape_calculate_speeds(drive);
-
-	/*
-	 * Estimate whether the tape has stopped writing by checking if our
-	 * write pipeline is currently empty. If we are not writing anymore,
-	 * wait for the pipeline to be almost completely full (90%) before
-	 * starting to service requests, so that we will be able to keep up with
-	 * the higher speeds of the tape.
-	 */
-	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-		if (tape->nr_stages >= tape->max_stages * 9 / 10 ||
-			tape->nr_stages >= tape->max_stages -
-			tape->uncontrolled_pipeline_head_speed * 3 * 1024 /
-			tape->blk_size) {
-			tape->measure_insert_time = 1;
-			tape->insert_time = jiffies;
-			tape->insert_size = 0;
-			tape->insert_speed = 0;
-			idetape_plug_pipeline(drive);
-		}
-	}
-	if (test_and_clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
-		/* Return a deferred error */
-		return -EIO;
-	return blocks;
-}
-
-/*
  * Wait until all pending pipeline requests are serviced. Typically called on
  * device close.
  */
@@ -2289,6 +2212,32 @@ static void idetape_wait_for_pipeline(ide_drive_t *drive)
 	}
 }
 
+/* Queue up a character device originated write request. */
+static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
+{
+	idetape_tape_t *tape = drive->driver_data;
+	idetape_stage_t *new_stage;
+
+	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
+
+	idetape_wait_for_pipeline(drive);
+
+	idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks,
+			      tape->merge_stage->bh);
+	__idetape_kfree_stage(tape->merge_stage);
+
+	new_stage = __idetape_kmalloc_stage(tape, 0, 0);
+	if (!new_stage) {
+		printk(KERN_ERR "ide-tape: %s: cannot alloc request buffer.\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	idetape_switch_buffers(tape, new_stage);
+
+	return blocks;
+}
+
 static void idetape_empty_write_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-- 
1.5.4.1


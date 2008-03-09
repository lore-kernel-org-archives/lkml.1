Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbYCIROZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbYCIROZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYCIRKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:10:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:58865 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbYCIRKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=UHuIcuG9yC/AuHAM4LQQa7dX+JNb1u6WGzpgLyKxADiQ2uMXq/n8EJp9ztmkZNFtOUePwYaS7VR8bakmvhg6LF9GrmLXN+PzYxrwIjHIhlbtaZ+23SYtEbZUQJ/MsUgHla4SAa0tPTjG5nABVWtY0PhqgKaObHwlviVvww5uZuU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 4/4] ide-tape: remove pipeline-specific code from idetape_add_chrdev_read_request()
Date: Sun,  9 Mar 2008 18:10:32 +0100
Message-Id: <1205082632-3418-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205082632-3418-1-git-send-email-petkovbb@gmail.com>
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to do away with queueing read requests on the pipeline, several things
have to be done:

1. Do not allocate additional pipeline stages in idetape_init_read() until
(tape->nr_stages < max_stages) and do only read operation preparations. As a
collateral result, idetape_add_stage_tail() becomes unused so remove it.

2. Wait for all queued pipeline requests to complete before queueing
the read request's buffer directly thru idetape_queue_rw_tail()

3. Do next request buffer allocation (tape->merge_stage)

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   81 +++++++++++++-----------------------------------
 1 files changed, 22 insertions(+), 59 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index a06d83f..5afcbf4 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1673,29 +1673,6 @@ static void idetape_switch_buffers(idetape_tape_t *tape, idetape_stage_t *stage)
 	idetape_init_merge_stage(tape);
 }
 
-/* Add a new stage at the end of the pipeline. */
-static void idetape_add_stage_tail(ide_drive_t *drive, idetape_stage_t *stage)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	spin_lock_irqsave(&tape->lock, flags);
-	stage->next = NULL;
-	if (tape->last_stage != NULL)
-		tape->last_stage->next = stage;
-	else
-		tape->first_stage = stage;
-		tape->next_stage  = stage;
-	tape->last_stage = stage;
-	if (tape->next_stage == NULL)
-		tape->next_stage = tape->last_stage;
-	tape->nr_stages++;
-	tape->nr_pending_stages++;
-	spin_unlock_irqrestore(&tape->lock, flags);
-}
-
 /* Install a completion in a pending request and sleep until it is serviced. The
  * caller should ensure that the request will not be serviced before we install
  * the completion (usually by disabling interrupts).
@@ -2219,10 +2196,7 @@ static void idetape_empty_write_pipeline(ide_drive_t *drive)
 static int idetape_init_read(ide_drive_t *drive, int max_stages)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *new_stage;
-	struct request rq;
 	int bytes_read;
-	u16 blocks = *(u16 *)&tape->caps[12];
 
 	/* Initialize read operation */
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
@@ -2258,21 +2232,7 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 			}
 		}
 	}
-	idetape_init_rq(&rq, REQ_IDETAPE_READ);
-	rq.sector = tape->first_frame;
-	rq.nr_sectors = blocks;
-	rq.current_nr_sectors = blocks;
-	if (!test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags) &&
-	    tape->nr_stages < max_stages) {
-		new_stage = __idetape_kmalloc_stage(tape, 0, 0);
-		while (new_stage != NULL) {
-			new_stage->rq = rq;
-			idetape_add_stage_tail(drive, new_stage);
-			if (tape->nr_stages >= max_stages)
-				break;
-			new_stage = __idetape_kmalloc_stage(tape, 0, 0);
-		}
-	}
+
 	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 		if (tape->nr_pending_stages >= 3 * max_stages / 4) {
 			tape->measure_insert_time = 1;
@@ -2292,7 +2252,7 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
+	idetape_stage_t *new_stage;
 	struct request *rq_ptr;
 	int bytes_read;
 
@@ -2302,31 +2262,34 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	if (test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 		return 0;
 
-	/* Wait for the next block to reach the head of the pipeline. */
 	idetape_init_read(drive, tape->max_stages);
-	if (tape->first_stage == NULL) {
-		if (test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
-			return 0;
-		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
-					tape->merge_stage->bh);
-	}
-	idetape_wait_first_stage(drive);
-	rq_ptr = &tape->first_stage->rq;
-	bytes_read = tape->blk_size * (rq_ptr->nr_sectors -
-					rq_ptr->current_nr_sectors);
-	rq_ptr->nr_sectors = 0;
-	rq_ptr->current_nr_sectors = 0;
 
+	idetape_wait_for_pipeline(drive);
+
+	if (test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
+		return 0;
+
+	bytes_read = idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
+					   tape->merge_stage->bh);
+
+	rq_ptr = &tape->merge_stage->rq;
 	if (rq_ptr->errors == IDETAPE_ERROR_EOD)
 		return 0;
 	else {
-		idetape_switch_buffers(tape, tape->first_stage);
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
 			set_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
-		spin_lock_irqsave(&tape->lock, flags);
-		idetape_remove_stage_head(drive);
-		spin_unlock_irqrestore(&tape->lock, flags);
+
+		__idetape_kfree_stage(tape->merge_stage);
+
+		new_stage = __idetape_kmalloc_stage(tape, 0, 0);
+		if (!new_stage) {
+			printk(KERN_ERR "ide-tape: %s: cannot alloc request "
+					"buffer.\n", __func__);
+			return -ENOMEM;
+		}
+		idetape_switch_buffers(tape, new_stage);
 	}
+
 	if (bytes_read > blocks * tape->blk_size) {
 		printk(KERN_ERR "ide-tape: bug: trying to return more bytes"
 				" than requested\n");
-- 
1.5.4.1


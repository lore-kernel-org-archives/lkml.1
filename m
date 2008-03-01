Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYCAJG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYCAJG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbYCAI7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:6285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbYCAI7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=PWfH/n0wDmA9wM4a7kFFmQDxuMrvQWETwK23HT9PwmOcoiooYLFbcx29czlhXXJwbWyhT7eRb61c6Wo1dRUCoxtDBLJY1UxZkIXgx2zQZopHZ20kd4y+OtN46l2pqi1WGkJ66Df132onc3SGCiTUE9o8C/N6rHOU4VRuoiRh/GM=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 15/24] ide-tape: remove pipeline-specific code from idetape_end_request
Date: Sat,  1 Mar 2008 09:58:39 +0100
Message-Id: <1204361928-30229-16-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a result, remove orphaned

idetape_activate_next_stage
idetape_remove_stage_head
idetape_abort_pipeline
idetape_wait_for_request
idetape_kfree_stage

too.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  172 +-----------------------------------------------
 1 files changed, 1 insertions(+), 171 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index a3a45b5..93e42e6 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -673,28 +673,6 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	}
 }
 
-static void idetape_activate_next_stage(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *stage = tape->next_stage;
-	struct request *rq = &stage->rq;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	if (stage == NULL) {
-		printk(KERN_ERR "ide-tape: bug: Trying to activate a non"
-				" existing stage\n");
-		return;
-	}
-
-	rq->rq_disk = tape->disk;
-	rq->buffer = NULL;
-	rq->special = (void *)stage->bh;
-	tape->active_data_rq = rq;
-	tape->active_stage = stage;
-	tape->next_stage = stage->next;
-}
-
 /* Free a stage along with its related buffers completely. */
 static void __idetape_kfree_stage(idetape_stage_t *stage)
 {
@@ -717,84 +695,12 @@ static void __idetape_kfree_stage(idetape_stage_t *stage)
 	kfree(stage);
 }
 
-static void idetape_kfree_stage(idetape_tape_t *tape, idetape_stage_t *stage)
-{
-	__idetape_kfree_stage(stage);
-}
-
-/*
- * Remove tape->first_stage from the pipeline. The caller should avoid race
- * conditions.
- */
-static void idetape_remove_stage_head(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *stage;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	if (tape->first_stage == NULL) {
-		printk(KERN_ERR "ide-tape: bug: tape->first_stage is NULL\n");
-		return;
-	}
-	if (tape->active_stage == tape->first_stage) {
-		printk(KERN_ERR "ide-tape: bug: Trying to free our active "
-				"pipeline stage\n");
-		return;
-	}
-	stage = tape->first_stage;
-	tape->first_stage = stage->next;
-	idetape_kfree_stage(tape, stage);
-	tape->nr_stages--;
-	if (tape->first_stage == NULL) {
-		tape->last_stage = NULL;
-		if (tape->next_stage != NULL)
-			printk(KERN_ERR "ide-tape: bug: tape->next_stage !="
-					" NULL\n");
-		if (tape->nr_stages)
-			printk(KERN_ERR "ide-tape: bug: nr_stages should be 0 "
-					"now\n");
-	}
-}
-
-/*
- * This will free all the pipeline stages starting from new_last_stage->next
- * to the end of the list, and point tape->last_stage to new_last_stage.
- */
-static void idetape_abort_pipeline(ide_drive_t *drive,
-				   idetape_stage_t *new_last_stage)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *stage = new_last_stage->next;
-	idetape_stage_t *nstage;
-
-	debug_log(DBG_PROCS, "%s: Enter %s\n", tape->name, __func__);
-
-	while (stage) {
-		nstage = stage->next;
-		idetape_kfree_stage(tape, stage);
-		--tape->nr_stages;
-		--tape->nr_pending_stages;
-		stage = nstage;
-	}
-	if (new_last_stage)
-		new_last_stage->next = NULL;
-	tape->last_stage = new_last_stage;
-	tape->next_stage = NULL;
-}
-
-/*
- * Finish servicing a request and insert a pending pipeline request into the
- * main device queue.
- */
+/* Finish servicing a request. */
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
 	int error;
-	int remove_stage = 0;
-	idetape_stage_t *active_stage;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
@@ -812,61 +718,8 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		return 0;
 	}
 
-	spin_lock_irqsave(&tape->lock, flags);
-
-	/* The request was a pipelined data transfer request */
-	if (tape->active_data_rq == rq) {
-		active_stage = tape->active_stage;
-		tape->active_stage = NULL;
-		tape->active_data_rq = NULL;
-		tape->nr_pending_stages--;
-		if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
-			remove_stage = 1;
-			if (error) {
-				set_bit(IDETAPE_FLAG_PIPELINE_ERR,
-					&tape->flags);
-				if (error == IDETAPE_ERROR_EOD)
-					idetape_abort_pipeline(drive,
-								active_stage);
-			}
-		} else if (rq->cmd[0] & REQ_IDETAPE_READ) {
-			if (error == IDETAPE_ERROR_EOD) {
-				set_bit(IDETAPE_FLAG_PIPELINE_ERR,
-					&tape->flags);
-				idetape_abort_pipeline(drive, active_stage);
-			}
-		}
-		if (tape->next_stage != NULL) {
-			idetape_activate_next_stage(drive);
-
-			/* Insert the next request into the request queue. */
-			(void)ide_do_drive_cmd(drive, tape->active_data_rq,
-						ide_end);
-		} else if (!error) {
-			/*
-			 * This is a part of the feedback loop which tries to
-			 * find the optimum number of stages. We are starting
-			 * from a minimum maximum number of stages, and if we
-			 * sense that the pipeline is empty, we try to increase
-			 * it, until we reach the user compile time memory
-			 * limit.
-			 */
-			int i = (tape->max_pipeline - tape->min_pipeline) / 10;
-
-			tape->max_stages += max(i, 1);
-			tape->max_stages = max(tape->max_stages,
-						tape->min_pipeline);
-			tape->max_stages = min(tape->max_stages,
-						tape->max_pipeline);
-		}
-	}
 	ide_end_drive_cmd(drive, 0, 0);
 
-	if (remove_stage)
-		idetape_remove_stage_head(drive);
-	if (tape->active_data_rq == NULL)
-		clear_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
-	spin_unlock_irqrestore(&tape->lock, flags);
 	return 0;
 }
 
@@ -1760,29 +1613,6 @@ static void idetape_init_merge_stage(idetape_tape_t *tape)
 	}
 }
 
-/*
- * Install a completion in a pending request and sleep until it is serviced. The
- * caller should ensure that the request will not be serviced before we install
- * the completion (usually by disabling interrupts).
- */
-static void idetape_wait_for_request(ide_drive_t *drive, struct request *rq)
-{
-	DECLARE_COMPLETION_ONSTACK(wait);
-	idetape_tape_t *tape = drive->driver_data;
-
-	if (rq == NULL || !blk_special_request(rq)) {
-		printk(KERN_ERR "ide-tape: bug: Trying to sleep on non-valid"
-				 " request\n");
-		return;
-	}
-	rq->end_io_data = &wait;
-	rq->end_io = blk_end_sync_rq;
-	spin_unlock_irq(&tape->lock);
-	wait_for_completion(&wait);
-	/* The stage and its struct request have been deallocated */
-	spin_lock_irq(&tape->lock);
-}
-
 static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-- 
1.5.4.1


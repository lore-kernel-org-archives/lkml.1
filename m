Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbYCAJL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbYCAJL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759349AbYCAJAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 04:00:03 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:55634 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYCAI7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Qq5hNsyabJX7VYuvkwai1D6P/gdWd+BA9obMLsZtTL/Cua3W62ZxhZCdaSFaKQX/D3Wn04s19aVtkUc/uq+pPtIYw78SneKhs10zxokUQOdyAIzdFPf2KjSQ84YzxldXJ2Q9/SqgXp/LHhR8wBKh6aGooewH3I/OEVMv++jUxUo=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 03/24] ide-tape: remove pipeline-specific code from idetape_add_chrdev_read_request
Date: Sat,  1 Mar 2008 09:58:27 +0100
Message-Id: <1204361928-30229-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We fall back to non-pipelined operation through idetape_queue_rw_tail with cmd
set to REQ_IDETAPE_READ. Also, remove idetape_switch_buffers() since it becomes
unused.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   46 +---------------------------------------------
 1 files changed, 1 insertions(+), 45 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index abf3efa..e919d41 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1776,16 +1776,6 @@ static void idetape_init_merge_stage(idetape_tape_t *tape)
 	}
 }
 
-static void idetape_switch_buffers(idetape_tape_t *tape, idetape_stage_t *stage)
-{
-	struct idetape_bh *tmp;
-
-	tmp = stage->bh;
-	stage->bh = tape->merge_stage->bh;
-	tape->merge_stage->bh = tmp;
-	idetape_init_merge_stage(tape);
-}
-
 /* Add a new stage at the end of the pipeline. */
 static void idetape_add_stage_tail(ide_drive_t *drive, idetape_stage_t *stage)
 {
@@ -2403,9 +2393,6 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-	struct request *rq_ptr;
-	int bytes_read;
 
 	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
@@ -2413,39 +2400,8 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	if (test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 		return 0;
 
-	/* Wait for the next block to reach the head of the pipeline. */
-	idetape_init_read(drive, tape->max_stages);
-	if (tape->first_stage == NULL) {
-		if (test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
-			return 0;
-		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
+	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
 					tape->merge_stage->bh);
-	}
-	idetape_wait_first_stage(drive);
-	rq_ptr = &tape->first_stage->rq;
-	bytes_read = tape->blk_size * (rq_ptr->nr_sectors -
-					rq_ptr->current_nr_sectors);
-	rq_ptr->nr_sectors = 0;
-	rq_ptr->current_nr_sectors = 0;
-
-	if (rq_ptr->errors == IDETAPE_ERROR_EOD)
-		return 0;
-	else {
-		idetape_switch_buffers(tape, tape->first_stage);
-		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
-			set_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
-		spin_lock_irqsave(&tape->lock, flags);
-		idetape_remove_stage_head(drive);
-		spin_unlock_irqrestore(&tape->lock, flags);
-		tape->pipeline_head++;
-		idetape_calculate_speeds(drive);
-	}
-	if (bytes_read > blocks * tape->blk_size) {
-		printk(KERN_ERR "ide-tape: bug: trying to return more bytes"
-				" than requested\n");
-		bytes_read = blocks * tape->blk_size;
-	}
-	return (bytes_read);
 }
 
 static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
-- 
1.5.4.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbYCAI75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbYCAI75 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 03:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYCAI7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:08 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:13335 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYCAI7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=NGbM3rjEdel7i1RewuMUKkNpMRfbH0WoysjIn8D392gkL5CZYUB04id2x3I0GF07B7XLMkA8v7Pw8ZBJCtRdfapkRN8gvAFxe7Mqah0nM/P6D8hrkPtZoNgNmwNEyJB8m5dap7AG3eaV1ytni7ifFsMT5tv/E76vipgK0gn1rsU=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 14/24] ide-tape: remove __idetape_discard_read_pipeline
Date: Sat,  1 Mar 2008 09:58:38 +0100
Message-Id: <1204361928-30229-15-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   49 ------------------------------------------------
 1 files changed, 0 insertions(+), 49 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3cb6e3d..a3a45b5 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1973,52 +1973,6 @@ static int idetape_create_prevent_cmd(ide_drive_t *drive,
 	return 1;
 }
 
-static int __idetape_discard_read_pipeline(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-	int cnt;
-
-	if (tape->chrdev_dir != IDETAPE_DIR_READ)
-		return 0;
-
-	/* Remove merge stage. */
-	cnt = tape->merge_stage_size / tape->blk_size;
-	if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
-		++cnt;		/* Filemarks count as 1 sector */
-	tape->merge_stage_size = 0;
-	if (tape->merge_stage != NULL) {
-		__idetape_kfree_stage(tape->merge_stage);
-		tape->merge_stage = NULL;
-	}
-
-	/* Clear pipeline flags. */
-	clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
-	tape->chrdev_dir = IDETAPE_DIR_NONE;
-
-	/* Remove pipeline stages. */
-	if (tape->first_stage == NULL)
-		return 0;
-
-	spin_lock_irqsave(&tape->lock, flags);
-	tape->next_stage = NULL;
-	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags))
-		idetape_wait_for_request(drive, tape->active_data_rq);
-	spin_unlock_irqrestore(&tape->lock, flags);
-
-	while (tape->first_stage != NULL) {
-		struct request *rq_ptr = &tape->first_stage->rq;
-
-		cnt += rq_ptr->nr_sectors - rq_ptr->current_nr_sectors;
-		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
-			++cnt;
-		idetape_remove_stage_head(drive);
-	}
-	tape->nr_pending_stages = 0;
-	tape->max_stages = tape->min_pipeline;
-	return cnt;
-}
-
 /*
  * Position the tape to the requested block using the LOCATE packet command.
  * A READ POSITION command is then issued to check where we are positioned. Like
@@ -2028,12 +1982,9 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 		u8 partition, int skip)
 {
-	idetape_tape_t *tape = drive->driver_data;
 	int retval;
 	struct ide_atapi_pc pc;
 
-	if (tape->chrdev_dir == IDETAPE_DIR_READ)
-		__idetape_discard_read_pipeline(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
 	retval = idetape_queue_pc_tail(drive, &pc);
-- 
1.5.4.1


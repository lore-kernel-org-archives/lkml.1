Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYCAJHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYCAJHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbYCAI71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:27 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:55344 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbYCAI7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=HrMgFB0CbsbdGkJoGRaLjLH//dNNTRAKtWaSUQFsoqyq8CXj40Pwp6+peF3CwIfSvNVlN9R8ZDHEpBTHyknsSJJaYfkC8VreExFT9OcbL3EQvinEuo/wREMbzxwZPjiEd9R04cXFCDJR+xtHFtzWq9c9tsRIvXADh/DMLI2XTuk=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 05/24] ide-tape: cleanup pipeline-specific code from idetape_init_read
Date: Sat,  1 Mar 2008 09:58:29 +0100
Message-Id: <1204361928-30229-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, remove idetape_kmalloc_stage() and idetape_add_stage_tail() since they've
become unused, as a result.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   73 +++--------------------------------------------
 1 files changed, 5 insertions(+), 68 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 4a064c1..6bca29b 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1684,21 +1684,6 @@ abort:
 	return NULL;
 }
 
-static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
-{
-	idetape_stage_t *cache_stage = tape->cache_stage;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	if (tape->nr_stages >= tape->max_stages)
-		return NULL;
-	if (cache_stage != NULL) {
-		tape->cache_stage = NULL;
-		return cache_stage;
-	}
-	return __idetape_kmalloc_stage(tape, 0, 0);
-}
-
 static int idetape_copy_stage_from_user(idetape_tape_t *tape,
 					const char __user *buf, int n)
 {
@@ -1776,30 +1761,8 @@ static void idetape_init_merge_stage(idetape_tape_t *tape)
 	}
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
-/* Install a completion in a pending request and sleep until it is serviced. The
+/*
+ * Install a completion in a pending request and sleep until it is serviced. The
  * caller should ensure that the request will not be serviced before we install
  * the completion (usually by disabling interrupts).
  */
@@ -2318,17 +2281,12 @@ static void idetape_restart_speed_control(ide_drive_t *drive)
 static int idetape_init_read(ide_drive_t *drive, int max_stages)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *new_stage;
 	struct request rq;
 	int bytes_read;
 	u16 blocks = *(u16 *)&tape->caps[12];
 
 	/* Initialize read operation */
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
-		if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-			idetape_empty_write_pipeline(drive);
-			idetape_flush_tape_buffers(drive);
-		}
 		if (tape->merge_stage || tape->merge_stage_size) {
 			printk(KERN_ERR "ide-tape: merge_stage_size should be"
 					 " 0 now\n");
@@ -2347,8 +2305,8 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 		 */
 		if (drive->dsc_overlap) {
 			bytes_read = idetape_queue_rw_tail(drive,
-							REQ_IDETAPE_READ, 0,
-							tape->merge_stage->bh);
+							 REQ_IDETAPE_READ, 0,
+							 tape->merge_stage->bh);
 			if (bytes_read < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
@@ -2357,32 +2315,11 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 			}
 		}
 	}
-	if (tape->restart_speed_control_req)
-		idetape_restart_speed_control(drive);
 	idetape_init_rq(&rq, REQ_IDETAPE_READ);
 	rq.sector = tape->first_frame;
 	rq.nr_sectors = blocks;
 	rq.current_nr_sectors = blocks;
-	if (!test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags) &&
-	    tape->nr_stages < max_stages) {
-		new_stage = idetape_kmalloc_stage(tape);
-		while (new_stage != NULL) {
-			new_stage->rq = rq;
-			idetape_add_stage_tail(drive, new_stage);
-			if (tape->nr_stages >= max_stages)
-				break;
-			new_stage = idetape_kmalloc_stage(tape);
-		}
-	}
-	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-		if (tape->nr_pending_stages >= 3 * max_stages / 4) {
-			tape->measure_insert_time = 1;
-			tape->insert_time = jiffies;
-			tape->insert_size = 0;
-			tape->insert_speed = 0;
-			idetape_plug_pipeline(drive);
-		}
-	}
+
 	return 0;
 }
 
-- 
1.5.4.1


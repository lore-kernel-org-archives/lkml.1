Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYCJXOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYCJXOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbYCJXNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:13:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:55390 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbYCJXNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=US7QuGIwLOmyP0vJwE3mK7oPIbsWANzbHXOutqrH9j7xzbsxEurHbn7Xrg8xGsK2uMuh9nR1t8/EqypHB0LXk3WX2BDAEFGJCpA0PLVkGKc1HRD4xDS2S9Nu3oxItvo8LgwKbsaUuWWtuwEvflEd/FQxV4ybsKZBhwomh7RjrLY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 4/4] ide-tape: remove pipeline-specific code from idetape_add_chrdev_read_request()
Date: Tue, 11 Mar 2008 00:25:50 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com> <1205082632-3418-5-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205082632-3418-5-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803110025.51072.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 March 2008, Borislav Petkov wrote:
> In order to do away with queueing read requests on the pipeline, several things
> have to be done:
> 
> 1. Do not allocate additional pipeline stages in idetape_init_read() until
> (tape->nr_stages < max_stages) and do only read operation preparations. As a
> collateral result, idetape_add_stage_tail() becomes unused so remove it.
> 
> 2. Wait for all queued pipeline requests to complete before queueing

Hmm, but we've just removed all pipeline requests with this patch?

[ ->first_stage and ->next_stage are always NULL after this patch which makes
  it possible to remove the rest of (now never executed) code for pipeline
  support, same for idetape_plug_pipeline() and IDETAPE_FLAG_PIPELINE* flags ]

> the read request's buffer directly thru idetape_queue_rw_tail()
> 
> 3. Do next request buffer allocation (tape->merge_stage)

Isn't idetape_init_read() taking care of 3.?

> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

Seems like we can get away with:

From: Borislav Petkov <petkovbb@googlemail.com>
Subject: [PATCH 4/4] ide-tape: remove pipeline-specific code from idetape_add_chrdev_read_request()

In order to do away with queueing read requests on the pipeline, several things
have to be done:

1. Do not allocate additional pipeline stages in idetape_init_read() until
(tape->nr_stages < max_stages) and do only read operation preparations. As a
collateral result, idetape_add_stage_tail() becomes unused so remove it.

2. Queue the read request's buffer directly thru idetape_queue_rw_tail().

3. Remove now unused idetape_kmalloc_stage() and idetape_switch_buffers().

[bart: simplify the original patch]

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |   96 ++-----------------------------------------------
 1 file changed, 5 insertions(+), 91 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1586,15 +1586,6 @@ abort:
 	return NULL;
 }
 
-static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
-{
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	if (tape->nr_stages >= tape->max_stages)
-		return NULL;
-	return __idetape_kmalloc_stage(tape, 0, 0);
-}
-
 static int idetape_copy_stage_from_user(idetape_tape_t *tape,
 		idetape_stage_t *stage, const char __user *buf, int n)
 {
@@ -1672,39 +1663,6 @@ static void idetape_init_merge_stage(ide
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
@@ -2228,10 +2186,7 @@ static void idetape_empty_write_pipeline
 static int idetape_init_read(ide_drive_t *drive, int max_stages)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *new_stage;
-	struct request rq;
 	int bytes_read;
-	u16 blocks = *(u16 *)&tape->caps[12];
 
 	/* Initialize read operation */
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
@@ -2267,21 +2222,7 @@ static int idetape_init_read(ide_drive_t
 			}
 		}
 	}
-	idetape_init_rq(&rq, REQ_IDETAPE_READ);
-	rq.sector = tape->first_frame;
-	rq.nr_sectors = blocks;
-	rq.current_nr_sectors = blocks;
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
+
 	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 		if (tape->nr_pending_stages >= 3 * max_stages / 4) {
 			tape->measure_insert_time = 1;
@@ -2301,9 +2242,6 @@ static int idetape_init_read(ide_drive_t
 static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-	struct request *rq_ptr;
-	int bytes_read;
 
 	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
@@ -2311,37 +2249,13 @@ static int idetape_add_chrdev_read_reque
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
 
-	if (rq_ptr->errors == IDETAPE_ERROR_EOD)
+	if (test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
 		return 0;
-	else {
-		idetape_switch_buffers(tape, tape->first_stage);
-		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
-			set_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
-		spin_lock_irqsave(&tape->lock, flags);
-		idetape_remove_stage_head(drive);
-		spin_unlock_irqrestore(&tape->lock, flags);
-	}
-	if (bytes_read > blocks * tape->blk_size) {
-		printk(KERN_ERR "ide-tape: bug: trying to return more bytes"
-				" than requested\n");
-		bytes_read = blocks * tape->blk_size;
-	}
-	return (bytes_read);
+
+	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
+				     tape->merge_stage->bh);
 }
 
 static void idetape_pad_zeros(ide_drive_t *drive, int bcount)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYK1EeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYK1EeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYK1Eci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:32:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:45262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226AbYK1Ecg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:32:36 -0500
From: Tejun Heo <tj@kernel.org>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] block: reorganize QUEUE_ORDERED_* constants
Date: Fri, 28 Nov 2008 13:32:02 +0900
Message-Id: <1227846727-24980-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227846727-24980-1-git-send-email-tj@kernel.org>
References: <1227846727-24980-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Nov 2008 04:32:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out ordering type (drain,) and action masks (preflush,
postflush, fua) from visible ordering mode selectors
(QUEUE_ORDERED_*).  Ordering types are now named QUEUE_ORDERED_BY_*
while action masks are named QUEUE_ORDERED_DO_*.

This change is necessary to add QUEUE_ORDERED_DO_BAR and make it
optional to improve empty barrier implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-barrier.c    |   20 ++++++++++----------
 include/linux/blkdev.h |   39 +++++++++++++++++++++++----------------
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 6e72d66..1d7adc7 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -24,8 +24,8 @@
 int blk_queue_ordered(struct request_queue *q, unsigned ordered,
 		      prepare_flush_fn *prepare_flush_fn)
 {
-	if (ordered & (QUEUE_ORDERED_PREFLUSH | QUEUE_ORDERED_POSTFLUSH) &&
-	    prepare_flush_fn == NULL) {
+	if (!prepare_flush_fn && (ordered & (QUEUE_ORDERED_DO_PREFLUSH |
+					     QUEUE_ORDERED_DO_POSTFLUSH))) {
 		printk(KERN_ERR "%s: prepare_flush_fn required\n", __func__);
 		return -EINVAL;
 	}
@@ -134,7 +134,7 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	struct request *rq;
 	rq_end_io_fn *end_io;
 
-	if (which == QUEUE_ORDERED_PREFLUSH) {
+	if (which == QUEUE_ORDERED_DO_PREFLUSH) {
 		rq = &q->pre_flush_rq;
 		end_io = pre_flush_end_io;
 	} else {
@@ -167,7 +167,7 @@ static inline struct request *start_ordered(struct request_queue *q,
 	blk_rq_init(q, rq);
 	if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
 		rq->cmd_flags |= REQ_RW;
-	if (q->ordered & QUEUE_ORDERED_FUA)
+	if (q->ordered & QUEUE_ORDERED_DO_FUA)
 		rq->cmd_flags |= REQ_FUA;
 	init_request_from_bio(rq, q->orig_bar_rq->bio);
 	rq->end_io = bar_end_io;
@@ -181,20 +181,20 @@ static inline struct request *start_ordered(struct request_queue *q,
 	 * there will be no data written between the pre and post flush.
 	 * Hence a single flush will suffice.
 	 */
-	if ((q->ordered & QUEUE_ORDERED_POSTFLUSH) && !blk_empty_barrier(rq))
-		queue_flush(q, QUEUE_ORDERED_POSTFLUSH);
+	if ((q->ordered & QUEUE_ORDERED_DO_POSTFLUSH) && !blk_empty_barrier(rq))
+		queue_flush(q, QUEUE_ORDERED_DO_POSTFLUSH);
 	else
 		q->ordseq |= QUEUE_ORDSEQ_POSTFLUSH;
 
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 
-	if (q->ordered & QUEUE_ORDERED_PREFLUSH) {
-		queue_flush(q, QUEUE_ORDERED_PREFLUSH);
+	if (q->ordered & QUEUE_ORDERED_DO_PREFLUSH) {
+		queue_flush(q, QUEUE_ORDERED_DO_PREFLUSH);
 		rq = &q->pre_flush_rq;
 	} else
 		q->ordseq |= QUEUE_ORDSEQ_PREFLUSH;
 
-	if ((q->ordered & QUEUE_ORDERED_TAG) || q->in_flight == 0)
+	if ((q->ordered & QUEUE_ORDERED_BY_TAG) || q->in_flight == 0)
 		q->ordseq |= QUEUE_ORDSEQ_DRAIN;
 	else
 		rq = NULL;
@@ -237,7 +237,7 @@ int blk_do_ordered(struct request_queue *q, struct request **rqp)
 	    rq != &q->pre_flush_rq && rq != &q->post_flush_rq)
 		return 1;
 
-	if (q->ordered & QUEUE_ORDERED_TAG) {
+	if (q->ordered & QUEUE_ORDERED_BY_TAG) {
 		/* Ordered by tag.  Blocking the next barrier is enough. */
 		if (is_barrier && rq != &q->bar_rq)
 			*rqp = NULL;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bedeea2..7f9cd08 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -523,22 +523,29 @@ enum {
 	 * TAG_FLUSH	: ordering by tag w/ pre and post flushes
 	 * TAG_FUA	: ordering by tag w/ pre flush and FUA write
 	 */
-	QUEUE_ORDERED_NONE	= 0x00,
-	QUEUE_ORDERED_DRAIN	= 0x01,
-	QUEUE_ORDERED_TAG	= 0x02,
-
-	QUEUE_ORDERED_PREFLUSH	= 0x10,
-	QUEUE_ORDERED_POSTFLUSH	= 0x20,
-	QUEUE_ORDERED_FUA	= 0x40,
-
-	QUEUE_ORDERED_DRAIN_FLUSH = QUEUE_ORDERED_DRAIN |
-			QUEUE_ORDERED_PREFLUSH | QUEUE_ORDERED_POSTFLUSH,
-	QUEUE_ORDERED_DRAIN_FUA	= QUEUE_ORDERED_DRAIN |
-			QUEUE_ORDERED_PREFLUSH | QUEUE_ORDERED_FUA,
-	QUEUE_ORDERED_TAG_FLUSH	= QUEUE_ORDERED_TAG |
-			QUEUE_ORDERED_PREFLUSH | QUEUE_ORDERED_POSTFLUSH,
-	QUEUE_ORDERED_TAG_FUA	= QUEUE_ORDERED_TAG |
-			QUEUE_ORDERED_PREFLUSH | QUEUE_ORDERED_FUA,
+	QUEUE_ORDERED_BY_DRAIN		= 0x01,
+	QUEUE_ORDERED_BY_TAG		= 0x02,
+	QUEUE_ORDERED_DO_PREFLUSH	= 0x10,
+	QUEUE_ORDERED_DO_POSTFLUSH	= 0x40,
+	QUEUE_ORDERED_DO_FUA		= 0x80,
+
+	QUEUE_ORDERED_NONE		= 0x00,
+
+	QUEUE_ORDERED_DRAIN		= QUEUE_ORDERED_BY_DRAIN,
+	QUEUE_ORDERED_DRAIN_FLUSH	= QUEUE_ORDERED_DRAIN |
+					  QUEUE_ORDERED_DO_PREFLUSH |
+					  QUEUE_ORDERED_DO_POSTFLUSH,
+	QUEUE_ORDERED_DRAIN_FUA		= QUEUE_ORDERED_DRAIN |
+					  QUEUE_ORDERED_DO_PREFLUSH |
+					  QUEUE_ORDERED_DO_FUA,
+
+	QUEUE_ORDERED_TAG		= QUEUE_ORDERED_BY_TAG,
+	QUEUE_ORDERED_TAG_FLUSH		= QUEUE_ORDERED_TAG |
+					  QUEUE_ORDERED_DO_PREFLUSH |
+					  QUEUE_ORDERED_DO_POSTFLUSH,
+	QUEUE_ORDERED_TAG_FUA		= QUEUE_ORDERED_TAG |
+					  QUEUE_ORDERED_DO_PREFLUSH |
+					  QUEUE_ORDERED_DO_FUA,
 
 	/*
 	 * Ordered operation sequence
-- 
1.5.6


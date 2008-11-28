Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbYK1Eco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbYK1Eco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYK1EcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:32:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:45253 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYK1EcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:32:18 -0500
From: Tejun Heo <tj@kernel.org>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] block: make every barrier action optional
Date: Fri, 28 Nov 2008 13:32:04 +0900
Message-Id: <1227846727-24980-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227846727-24980-1-git-send-email-tj@kernel.org>
References: <1227846727-24980-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Nov 2008 04:32:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In all barrier sequences, the barrier write itself was always assumed
to be issued and thus didn't have corresponding control flag.  This
patch adds QUEUE_ORDERED_DO_BAR and unify action mask handling in
start_ordered() such that any barrier action can be skipped.

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-barrier.c    |   41 ++++++++++++++++++++++++-----------------
 include/linux/blkdev.h |    7 +++++--
 2 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 43d479a..1efabf8 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -158,19 +158,10 @@ static inline struct request *start_ordered(struct request_queue *q,
 	q->ordered = q->next_ordered;
 	q->ordseq |= QUEUE_ORDSEQ_STARTED;
 
-	/*
-	 * Prep proxy barrier request.
-	 */
+	/* stash away the original request */
 	elv_dequeue_request(q, rq);
 	q->orig_bar_rq = rq;
-	rq = &q->bar_rq;
-	blk_rq_init(q, rq);
-	if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
-		rq->cmd_flags |= REQ_RW;
-	if (q->ordered & QUEUE_ORDERED_DO_FUA)
-		rq->cmd_flags |= REQ_FUA;
-	init_request_from_bio(rq, q->orig_bar_rq->bio);
-	rq->end_io = bar_end_io;
+	rq = NULL;
 
 	/*
 	 * Queue ordered sequence.  As we stack them at the head, we
@@ -181,12 +172,28 @@ static inline struct request *start_ordered(struct request_queue *q,
 	 * there will be no data written between the pre and post flush.
 	 * Hence a single flush will suffice.
 	 */
-	if ((q->ordered & QUEUE_ORDERED_DO_POSTFLUSH) && !blk_empty_barrier(rq))
+	if ((q->ordered & QUEUE_ORDERED_DO_POSTFLUSH) &&
+	    !blk_empty_barrier(q->orig_bar_rq)) {
 		queue_flush(q, QUEUE_ORDERED_DO_POSTFLUSH);
-	else
+		rq = &q->post_flush_rq;
+	} else
 		q->ordseq |= QUEUE_ORDSEQ_POSTFLUSH;
 
-	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
+	if (q->ordered & QUEUE_ORDERED_DO_BAR) {
+		rq = &q->bar_rq;
+
+		/* initialize proxy request and queue it */
+		blk_rq_init(q, rq);
+		if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
+			rq->cmd_flags |= REQ_RW;
+		if (q->ordered & QUEUE_ORDERED_DO_FUA)
+			rq->cmd_flags |= REQ_FUA;
+		init_request_from_bio(rq, q->orig_bar_rq->bio);
+		rq->end_io = bar_end_io;
+
+		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
+	} else
+		q->ordseq |= QUEUE_ORDSEQ_BAR;
 
 	if (q->ordered & QUEUE_ORDERED_DO_PREFLUSH) {
 		queue_flush(q, QUEUE_ORDERED_DO_PREFLUSH);
@@ -194,10 +201,10 @@ static inline struct request *start_ordered(struct request_queue *q,
 	} else
 		q->ordseq |= QUEUE_ORDSEQ_PREFLUSH;
 
-	if ((q->ordered & QUEUE_ORDERED_BY_TAG) || q->in_flight == 0)
-		q->ordseq |= QUEUE_ORDSEQ_DRAIN;
-	else
+	if ((q->ordered & QUEUE_ORDERED_BY_DRAIN) && q->in_flight)
 		rq = NULL;
+	else
+		q->ordseq |= QUEUE_ORDSEQ_DRAIN;
 
 	return rq;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7f9cd08..076620d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -526,12 +526,14 @@ enum {
 	QUEUE_ORDERED_BY_DRAIN		= 0x01,
 	QUEUE_ORDERED_BY_TAG		= 0x02,
 	QUEUE_ORDERED_DO_PREFLUSH	= 0x10,
+	QUEUE_ORDERED_DO_BAR		= 0x20,
 	QUEUE_ORDERED_DO_POSTFLUSH	= 0x40,
 	QUEUE_ORDERED_DO_FUA		= 0x80,
 
 	QUEUE_ORDERED_NONE		= 0x00,
 
-	QUEUE_ORDERED_DRAIN		= QUEUE_ORDERED_BY_DRAIN,
+	QUEUE_ORDERED_DRAIN		= QUEUE_ORDERED_BY_DRAIN |
+					  QUEUE_ORDERED_DO_BAR,
 	QUEUE_ORDERED_DRAIN_FLUSH	= QUEUE_ORDERED_DRAIN |
 					  QUEUE_ORDERED_DO_PREFLUSH |
 					  QUEUE_ORDERED_DO_POSTFLUSH,
@@ -539,7 +541,8 @@ enum {
 					  QUEUE_ORDERED_DO_PREFLUSH |
 					  QUEUE_ORDERED_DO_FUA,
 
-	QUEUE_ORDERED_TAG		= QUEUE_ORDERED_BY_TAG,
+	QUEUE_ORDERED_TAG		= QUEUE_ORDERED_BY_TAG |
+					  QUEUE_ORDERED_DO_BAR,
 	QUEUE_ORDERED_TAG_FLUSH		= QUEUE_ORDERED_TAG |
 					  QUEUE_ORDERED_DO_PREFLUSH |
 					  QUEUE_ORDERED_DO_POSTFLUSH,
-- 
1.5.6


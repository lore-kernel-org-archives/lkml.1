Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZCPCbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZCPCbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZCPC3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:44292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbZCPC3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:17 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/17] block: don't set REQ_NOMERGE unnecessarily
Date: Mon, 16 Mar 2009 11:28:49 +0900
Message-Id: <1237170540-19130-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

RQ_NOMERGE_FLAGS already clears defines which REQ flags aren't
mergeable.  There is no reason to specify it superflously.  It only
adds to confusion.  Don't set REQ_NOMERGE for barriers and requests
with specific queueing directive.  REQ_NOMERGE is now exclusively used
by the merging code.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |    5 +----
 block/blk-exec.c |    1 -
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7c2d836..d7b2cc9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1077,16 +1077,13 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	if (bio_failfast_driver(bio))
 		req->cmd_flags |= REQ_FAILFAST_DRIVER;
 
-	/*
-	 * REQ_BARRIER implies no merging, but lets make it explicit
-	 */
 	if (unlikely(bio_discard(bio))) {
 		req->cmd_flags |= REQ_DISCARD;
 		if (bio_barrier(bio))
 			req->cmd_flags |= REQ_SOFTBARRIER;
 		req->q->prepare_discard_fn(req->q, req);
 	} else if (unlikely(bio_barrier(bio)))
-		req->cmd_flags |= (REQ_HARDBARRIER | REQ_NOMERGE);
+		req->cmd_flags |= REQ_HARDBARRIER;
 
 	if (bio_sync(bio))
 		req->cmd_flags |= REQ_RW_SYNC;
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 6af716d..49557e9 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -51,7 +51,6 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 
 	rq->rq_disk = bd_disk;
-	rq->cmd_flags |= REQ_NOMERGE;
 	rq->end_io = done;
 	WARN_ON(irqs_disabled());
 	spin_lock_irq(q->queue_lock);
-- 
1.6.0.2


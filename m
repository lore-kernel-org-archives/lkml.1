Return-Path: <linux-kernel-owner+w=401wt.eu-S1031040AbXDXIQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031040AbXDXIQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031046AbXDXIQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:16:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41218 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbXDXIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:39 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/15] cfq-iosched: improve preemption for cooperating tasks
Date: Tue, 24 Apr 2007 10:15:29 +0200
Message-Id: <11774025432284-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When testing the syslet async io approach, I discovered that CFQ
sometimes didn't perform as well as expected. cfq_should_preempt()
needs to better check for cooperating tasks, so fix that by allowing
preemption of an equal priority queue if the recently queued request
is as good a candidate for IO as the one we are currently waiting for.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9e37971..a683d00 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -861,15 +861,11 @@ static int cfq_arm_slice_timer(struct cfq_data *cfqd)
 
 static void cfq_dispatch_insert(request_queue_t *q, struct request *rq)
 {
-	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
 	cfq_remove_request(rq);
 	cfqq->on_dispatch[rq_is_sync(rq)]++;
 	elv_dispatch_sort(q, rq);
-
-	rq = list_entry(q->queue_head.prev, struct request, queuelist);
-	cfqd->last_sector = rq->sector + rq->nr_sectors;
 }
 
 /*
@@ -1579,6 +1575,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 		   struct request *rq)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
+	sector_t dist;
 
 	if (cfq_class_idle(new_cfqq))
 		return 0;
@@ -1588,14 +1585,14 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 
 	if (cfq_class_idle(cfqq))
 		return 1;
-	if (!cfq_cfqq_wait_request(new_cfqq))
-		return 0;
+
 	/*
 	 * if the new request is sync, but the currently running queue is
 	 * not, let the sync request have priority.
 	 */
 	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
 		return 1;
+
 	/*
 	 * So both queues are sync. Let the new request get disk time if
 	 * it's a metadata request and the current queue is doing regular IO.
@@ -1603,6 +1600,21 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (rq_is_meta(rq) && !cfqq->meta_pending)
 		return 1;
 
+	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
+		return 0;
+
+	/*
+	 * if this request is as-good as one we would expect from the
+	 * current cfqq, let it preempt
+	 */
+	if (rq->sector > cfqd->last_sector)
+		dist = rq->sector - cfqd->last_sector;
+	else
+		dist = cfqd->last_sector - rq->sector;
+
+	if (dist <= cfqd->active_cic->seek_mean)
+		return 1;
+
 	return 0;
 }
 
@@ -1719,6 +1731,8 @@ static void cfq_completed_request(request_queue_t *q, struct request *rq)
 	cfqq->on_dispatch[sync]--;
 	cfqq->service_last = now;
 
+	cfqd->last_sector = rq->hard_sector + rq->hard_nr_sectors;
+
 	if (!cfq_class_idle(cfqq))
 		cfqd->last_end_request = now;
 
-- 
1.5.1.1.190.g74474


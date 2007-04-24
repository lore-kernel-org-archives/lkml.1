Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbXDXISa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbXDXISa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031054AbXDXIQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:16:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41225 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbXDXIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:39 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/15] cfq-iosched: minor updates
Date: Tue, 24 Apr 2007 10:15:31 +0200
Message-Id: <11774025432443-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Move the queue_new flag clear to when the queue is selected
- Only select the non-first queue in cfq_get_best_queue(), if there's
  a substantial difference between the best and first.
- Get rid of ->busy_rr
- Only select a close cooperator, if the current queue is known to take
  a while to "think".

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   81 +++++++++++---------------------------------------
 1 files changed, 18 insertions(+), 63 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3883ba8..04fea76 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -70,7 +70,6 @@ struct cfq_data {
 	 * rr list of queues with requests and the count of them
 	 */
 	struct list_head rr_list[CFQ_PRIO_LISTS];
-	struct list_head busy_rr;
 	struct list_head cur_rr;
 	struct list_head idle_rr;
 	unsigned long cur_rr_tick;
@@ -410,59 +409,18 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 static void cfq_resort_be_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 				int preempted)
 {
-	struct list_head *list, *n;
-	struct cfq_queue *__cfqq;
-	int add_tail = 0;
-
-	/*
-	 * if cfqq has requests in flight, don't allow it to be
-	 * found in cfq_set_active_queue before it has finished them.
-	 * this is done to increase fairness between a process that
-	 * has lots of io pending vs one that only generates one
-	 * sporadically or synchronously
-	 */
-	if (cfqq->dispatched)
-		list = &cfqd->busy_rr;
-	else if (cfqq->ioprio == (cfqd->cur_prio + 1) &&
-		 cfq_cfqq_sync(cfqq) &&
-		 (time_before(cfqd->prio_time, cfqq->service_last) ||
-		  cfq_cfqq_queue_new(cfqq) || preempted)) {
-		list = &cfqd->cur_rr;
-		add_tail = 1;
-	} else
-		list = &cfqd->rr_list[cfqq->ioprio];
-
-	if (!cfq_cfqq_sync(cfqq) || add_tail) {
-		/*
-		 * async queue always goes to the end. this wont be overly
-		 * unfair to writes, as the sort of the sync queue wont be
-		 * allowed to pass the async queue again.
-		 */
-		list_add_tail(&cfqq->cfq_list, list);
-	} else if (preempted || cfq_cfqq_queue_new(cfqq)) {
-		/*
-		 * If this queue was preempted or is new (never been serviced),
-		 * let it be added first for fairness but beind other new
-		 * queues.
-		 */
-		n = list;
-		while (n->next != list) {
-			__cfqq = list_entry_cfqq(n->next);
-			if (!cfq_cfqq_queue_new(__cfqq))
-				break;
+	if (!cfq_cfqq_sync(cfqq))
+		list_add_tail(&cfqq->cfq_list, &cfqd->rr_list[cfqq->ioprio]);
+	else {
+		struct list_head *n = &cfqd->rr_list[cfqq->ioprio];
 
-			n = n->next;
-		}
-		list_add(&cfqq->cfq_list, n);
-	} else {
 		/*
 		 * sort by last service, but don't cross a new or async
-		 * queue. we don't cross a new queue because it hasn't been
-		 * service before, and we don't cross an async queue because
-		 * it gets added to the end on expire.
+		 * queue. we don't cross a new queue because it hasn't
+		 * been service before, and we don't cross an async
+		 * queue because it gets added to the end on expire.
 		 */
-		n = list;
-		while ((n = n->prev) != list) {
+		while ((n = n->prev) != &cfqd->rr_list[cfqq->ioprio]) {
 			struct cfq_queue *__c = list_entry_cfqq(n);
 
 			if (!cfq_cfqq_sync(__c) || !__c->service_last)
@@ -719,6 +677,7 @@ __cfq_set_active_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		cfq_clear_cfqq_must_alloc_slice(cfqq);
 		cfq_clear_cfqq_fifo_expire(cfqq);
 		cfq_mark_cfqq_slice_new(cfqq);
+		cfq_clear_cfqq_queue_new(cfqq);
 		cfqq->rr_tick = cfqd->cur_rr_tick;
 	}
 
@@ -737,7 +696,6 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	cfq_clear_cfqq_must_dispatch(cfqq);
 	cfq_clear_cfqq_wait_request(cfqq);
-	cfq_clear_cfqq_queue_new(cfqq);
 
 	/*
 	 * store what was left of this slice, if the queue idled out
@@ -839,13 +797,15 @@ static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
 static struct cfq_queue *cfq_get_best_queue(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = NULL, *__cfqq;
-	sector_t best = -1, dist;
+	sector_t best = -1, first = -1, dist;
 
 	list_for_each_entry(__cfqq, &cfqd->cur_rr, cfq_list) {
 		if (!__cfqq->next_rq || !cfq_cfqq_sync(__cfqq))
 			continue;
 
 		dist = cfq_dist_from_last(cfqd, __cfqq->next_rq);
+		if (first == -1)
+			first = dist;
 		if (dist < best) {
 			best = dist;
 			cfqq = __cfqq;
@@ -853,9 +813,11 @@ static struct cfq_queue *cfq_get_best_queue(struct cfq_data *cfqd)
 	}
 
 	/*
-	 * Only async queue(s) available, grab first entry
+	 * Only async queue(s) available, grab first entry. Do the same
+	 * if the difference between the first and best isn't more than
+	 * twice, to obey fairness.
 	 */
-	if (!cfqq)
+	if (!cfqq || (best && first != best && ((first / best) < 4)))
 		cfqq = list_entry_cfqq(cfqd->cur_rr.next);
 
 	return cfqq;
@@ -872,12 +834,6 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 		 * are spliced
 		 */
 		cfqq = cfq_get_best_queue(cfqd);
-	} else if (!list_empty(&cfqd->busy_rr)) {
-		/*
-		 * If no new queues are available, check if the busy list has
-		 * some before falling back to idle io.
-		 */
-		cfqq = list_entry_cfqq(cfqd->busy_rr.next);
 	} else if (!list_empty(&cfqd->idle_rr)) {
 		/*
 		 * if we have idle queues and no rt or be queues had pending
@@ -998,7 +954,8 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	/*
 	 * See if this prio level has a good candidate
 	 */
-	if (cfq_close_cooperator(cfqd, cfqq))
+	if (cfq_close_cooperator(cfqd, cfqq) &&
+	    (sample_valid(cic->ttime_samples) && cic->ttime_mean > 2))
 		return;
 
 	cfq_mark_cfqq_must_dispatch(cfqq);
@@ -1178,7 +1135,6 @@ cfq_forced_dispatch(struct cfq_data *cfqd)
 	for (i = 0; i < CFQ_PRIO_LISTS; i++)
 		dispatched += cfq_forced_dispatch_cfqqs(&cfqd->rr_list[i]);
 
-	dispatched += cfq_forced_dispatch_cfqqs(&cfqd->busy_rr);
 	dispatched += cfq_forced_dispatch_cfqqs(&cfqd->cur_rr);
 	dispatched += cfq_forced_dispatch_cfqqs(&cfqd->idle_rr);
 
@@ -2174,7 +2130,6 @@ static void *cfq_init_queue(request_queue_t *q)
 	for (i = 0; i < CFQ_PRIO_LISTS; i++)
 		INIT_LIST_HEAD(&cfqd->rr_list[i]);
 
-	INIT_LIST_HEAD(&cfqd->busy_rr);
 	INIT_LIST_HEAD(&cfqd->cur_rr);
 	INIT_LIST_HEAD(&cfqd->idle_rr);
 	INIT_LIST_HEAD(&cfqd->cic_list);
-- 
1.5.1.1.190.g74474


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbZL3WYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbZL3WYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 17:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZL3WYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 17:24:05 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:42372 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZL3WYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 17:24:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=S/EkmkwUzW44scnGxLWYgcYk/xDdjg7BxYZJ+OFZ5JdpaugDuEU8vJQNvs5qXnnit2
         SFCxsVNeKkJnitf4yi5pXdkOx3XmZE8ygODHWkPSl5gK12ydMtkeA+/Eq+BjLb2aVzC1
         p4LHgEf7dGjmOEhJglQC5g6WqhF7OkMwMB4EU=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [PATCH] cfq-iosched: requests "in flight" vs "in driver" clarification
Date: Wed, 30 Dec 2009 23:24:19 +0100
Message-Id: <1262211859-11863-1-git-send-email-czoccolo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <20091230211643.GO4489@kernel.dk>
References: <20091230211643.GO4489@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Counters for requests "in flight" and "in driver" are used asymmetrically
in cfq_may_dispatch, and have slightly different meaning.
We split the rq_in_flight counter (was sync_flight) to count both sync
and async requests, in order to use this one, which is more accurate in
some corner cases.
The rq_in_driver counter is coalesced, since individual sync/async counts
are not used any more.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   44 ++++++++++++++++++--------------------------
 1 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7da9391..c6d5678 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -227,8 +227,8 @@ struct cfq_data {
 
 	unsigned int busy_queues;
 
-	int rq_in_driver[2];
-	int sync_flight;
+	int rq_in_driver;
+	int rq_in_flight[2];
 
 	/*
 	 * queue-depth detection
@@ -419,11 +419,6 @@ static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
 static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
 						struct io_context *);
 
-static inline int rq_in_driver(struct cfq_data *cfqd)
-{
-	return cfqd->rq_in_driver[0] + cfqd->rq_in_driver[1];
-}
-
 static inline struct cfq_queue *cic_to_cfqq(struct cfq_io_context *cic,
 					    bool is_sync)
 {
@@ -1423,9 +1418,9 @@ static void cfq_activate_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 
-	cfqd->rq_in_driver[rq_is_sync(rq)]++;
+	cfqd->rq_in_driver++;
 	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "activate rq, drv=%d",
-						rq_in_driver(cfqd));
+						cfqd->rq_in_driver);
 
 	cfqd->last_position = blk_rq_pos(rq) + blk_rq_sectors(rq);
 }
@@ -1433,12 +1428,11 @@ static void cfq_activate_request(struct request_queue *q, struct request *rq)
 static void cfq_deactivate_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
-	const int sync = rq_is_sync(rq);
 
-	WARN_ON(!cfqd->rq_in_driver[sync]);
-	cfqd->rq_in_driver[sync]--;
+	WARN_ON(!cfqd->rq_in_driver);
+	cfqd->rq_in_driver--;
 	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "deactivate rq, drv=%d",
-						rq_in_driver(cfqd));
+						cfqd->rq_in_driver);
 }
 
 static void cfq_remove_request(struct request *rq)
@@ -1876,8 +1870,7 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	cfqq->dispatched++;
 	elv_dispatch_sort(q, rq);
 
-	if (cfq_cfqq_sync(cfqq))
-		cfqd->sync_flight++;
+	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
 	cfqq->nr_sectors += blk_rq_sectors(rq);
 }
 
@@ -2224,13 +2217,13 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	/*
 	 * Drain async requests before we start sync IO
 	 */
-	if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
+	if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_flight[BLK_RW_ASYNC])
 		return false;
 
 	/*
 	 * If this is an async queue and we have sync IO in flight, let it wait
 	 */
-	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
+	if (cfqd->rq_in_flight[BLK_RW_SYNC] && !cfq_cfqq_sync(cfqq))
 		return false;
 
 	max_dispatch = cfqd->cfq_quantum;
@@ -3220,14 +3213,14 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 
-	if (rq_in_driver(cfqd) > cfqd->hw_tag_est_depth)
-		cfqd->hw_tag_est_depth = rq_in_driver(cfqd);
+	if (cfqd->rq_in_driver > cfqd->hw_tag_est_depth)
+		cfqd->hw_tag_est_depth = cfqd->rq_in_driver;
 
 	if (cfqd->hw_tag == 1)
 		return;
 
 	if (cfqd->rq_queued <= CFQ_HW_QUEUE_MIN &&
-	    rq_in_driver(cfqd) <= CFQ_HW_QUEUE_MIN)
+	    cfqd->rq_in_driver <= CFQ_HW_QUEUE_MIN)
 		return;
 
 	/*
@@ -3237,7 +3230,7 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
 	 */
 	if (cfqq && cfq_cfqq_idle_window(cfqq) &&
 	    cfqq->dispatched + cfqq->queued[0] + cfqq->queued[1] <
-	    CFQ_HW_QUEUE_MIN && rq_in_driver(cfqd) < CFQ_HW_QUEUE_MIN)
+	    CFQ_HW_QUEUE_MIN && cfqd->rq_in_driver < CFQ_HW_QUEUE_MIN)
 		return;
 
 	if (cfqd->hw_tag_samples++ < 50)
@@ -3290,13 +3283,12 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 
 	cfq_update_hw_tag(cfqd);
 
-	WARN_ON(!cfqd->rq_in_driver[sync]);
+	WARN_ON(!cfqd->rq_in_driver);
 	WARN_ON(!cfqq->dispatched);
-	cfqd->rq_in_driver[sync]--;
+	cfqd->rq_in_driver--;
 	cfqq->dispatched--;
 
-	if (cfq_cfqq_sync(cfqq))
-		cfqd->sync_flight--;
+	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
 	if (sync) {
 		RQ_CIC(rq)->last_end_request = now;
@@ -3350,7 +3342,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		}
 	}
 
-	if (!rq_in_driver(cfqd))
+	if (!cfqd->rq_in_driver)
 		cfq_schedule_dispatch(cfqd);
 }
 
-- 
1.6.4.4


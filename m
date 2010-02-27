Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968542Ab0B0QCu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:02:50 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37886 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968514Ab0B0QCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:02:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=e+i/oTibkWKSLUSxuegYQSN9Hp3rFJqHys/p513FXDFptALnANFYAkfzhzRyz2CI/Y
         jK4lB0GiPe3fiJgo1pSED9rtxi73km7+xP7V6NDOYFLJvG0CXABjUYqLGO518WpRbeoz
         6rOSnIEWmEnDLcbvY7KoraK6f6x6cx1gfjIBQ=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [PATCH] cfq-iosched: requests "in flight" vs "in driver" clarification
Date: Sat, 27 Feb 2010 17:03:09 +0100
Message-Id: <1267286589-316-1-git-send-email-czoccolo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
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
index 10eb286..eed649c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -223,8 +223,8 @@ struct cfq_data {
 
 	unsigned int busy_queues;
 
-	int rq_in_driver[2];
-	int sync_flight;
+	int rq_in_driver;
+	int rq_in_flight[2];
 
 	/*
 	 * queue-depth detection
@@ -417,11 +417,6 @@ static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
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
@@ -1415,9 +1410,9 @@ static void cfq_activate_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 
-	cfqd->rq_in_driver[rq_is_sync(rq)]++;
+	cfqd->rq_in_driver++;
 	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "activate rq, drv=%d",
-						rq_in_driver(cfqd));
+						cfqd->rq_in_driver);
 
 	cfqd->last_position = blk_rq_pos(rq) + blk_rq_sectors(rq);
 }
@@ -1425,12 +1420,11 @@ static void cfq_activate_request(struct request_queue *q, struct request *rq)
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
@@ -1873,8 +1867,7 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	cfqq->dispatched++;
 	elv_dispatch_sort(q, rq);
 
-	if (cfq_cfqq_sync(cfqq))
-		cfqd->sync_flight++;
+	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
 	cfqq->nr_sectors += blk_rq_sectors(rq);
 }
 
@@ -2221,13 +2214,13 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
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
@@ -3210,14 +3203,14 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
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
@@ -3227,7 +3220,7 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
 	 */
 	if (cfqq && cfq_cfqq_idle_window(cfqq) &&
 	    cfqq->dispatched + cfqq->queued[0] + cfqq->queued[1] <
-	    CFQ_HW_QUEUE_MIN && rq_in_driver(cfqd) < CFQ_HW_QUEUE_MIN)
+	    CFQ_HW_QUEUE_MIN && cfqd->rq_in_driver < CFQ_HW_QUEUE_MIN)
 		return;
 
 	if (cfqd->hw_tag_samples++ < 50)
@@ -3280,13 +3273,12 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 
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
@@ -3340,7 +3332,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		}
 	}
 
-	if (!rq_in_driver(cfqd))
+	if (!cfqd->rq_in_driver)
 		cfq_schedule_dispatch(cfqd);
 }
 
-- 
1.6.4.4


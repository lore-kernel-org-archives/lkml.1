Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZGBUT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZGBUT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZGBUTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:19:50 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45680 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975AbZGBUTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:19:49 -0400
Date: Thu, 2 Jul 2009 22:19:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFT] cfq-iosched: drain device before switching to a sync
	queue
Message-ID: <20090702201952.GG23611@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CFQ used to do something to this effect earlier and it should help sync
IO make quicker progress in the presence of async writeout. IOW, it
should make your desktop and apps more responsive while writeout is
happening. Now I have improved the patch to only care about the case
where we have async IO in flight and start to process sync IO.

I'd like for people to give this a test spin. Both to see if it makes
everything more snappy, but also on the benchmark side to see if it
hurts any known test cases. Essentially it'll disable NCQ/TCQ across
queues sync vs async queues.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 87276eb..57ed6fc 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -140,7 +140,7 @@ struct cfq_data {
 	 */
 	unsigned int busy_rt_queues;
 
-	int rq_in_driver;
+	int rq_in_driver[2];
 	int sync_flight;
 
 	/*
@@ -239,6 +239,11 @@ static struct cfq_queue *cfq_get_queue(struct cfq_data *, int,
 static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
 						struct io_context *);
 
+static inline int rq_in_driver(struct cfq_data *cfqd)
+{
+	return cfqd->rq_in_driver[0] + cfqd->rq_in_driver[1];
+}
+
 static inline struct cfq_queue *cic_to_cfqq(struct cfq_io_context *cic,
 					    int is_sync)
 {
@@ -760,9 +765,9 @@ static void cfq_activate_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 
-	cfqd->rq_in_driver++;
+	cfqd->rq_in_driver[rq_is_sync(rq)]++;
 	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "activate rq, drv=%d",
-						cfqd->rq_in_driver);
+						rq_in_driver(cfqd));
 
 	cfqd->last_position = blk_rq_pos(rq) + blk_rq_sectors(rq);
 }
@@ -770,11 +775,12 @@ static void cfq_activate_request(struct request_queue *q, struct request *rq)
 static void cfq_deactivate_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
+	const int sync = rq_is_sync(rq);
 
-	WARN_ON(!cfqd->rq_in_driver);
-	cfqd->rq_in_driver--;
+	WARN_ON(!cfqd->rq_in_driver[sync]);
+	cfqd->rq_in_driver[sync]--;
 	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "deactivate rq, drv=%d",
-						cfqd->rq_in_driver);
+						rq_in_driver(cfqd));
 }
 
 static void cfq_remove_request(struct request *rq)
@@ -1080,7 +1086,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	/*
 	 * still requests with the driver, don't idle
 	 */
-	if (cfqd->rq_in_driver)
+	if (rq_in_driver(cfqd))
 		return;
 
 	/*
@@ -1312,6 +1318,12 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 		return 0;
 
 	/*
+	 * Drain async requests before we start sync IO
+	 */
+	if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
+		return 0;
+
+	/*
 	 * If this is an async queue and we have sync IO in flight, let it wait
 	 */
 	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
@@ -2130,11 +2142,11 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
  */
 static void cfq_update_hw_tag(struct cfq_data *cfqd)
 {
-	if (cfqd->rq_in_driver > cfqd->rq_in_driver_peak)
-		cfqd->rq_in_driver_peak = cfqd->rq_in_driver;
+	if (rq_in_driver(cfqd) > cfqd->rq_in_driver_peak)
+		cfqd->rq_in_driver_peak = rq_in_driver(cfqd);
 
 	if (cfqd->rq_queued <= CFQ_HW_QUEUE_MIN &&
-	    cfqd->rq_in_driver <= CFQ_HW_QUEUE_MIN)
+	    rq_in_driver(cfqd) <= CFQ_HW_QUEUE_MIN)
 		return;
 
 	if (cfqd->hw_tag_samples++ < 50)
@@ -2161,9 +2173,9 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 
 	cfq_update_hw_tag(cfqd);
 
-	WARN_ON(!cfqd->rq_in_driver);
+	WARN_ON(!cfqd->rq_in_driver[sync]);
 	WARN_ON(!cfqq->dispatched);
-	cfqd->rq_in_driver--;
+	cfqd->rq_in_driver[sync]--;
 	cfqq->dispatched--;
 
 	if (cfq_cfqq_sync(cfqq))
@@ -2197,7 +2209,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 			cfq_arm_slice_timer(cfqd);
 	}
 
-	if (!cfqd->rq_in_driver)
+	if (!rq_in_driver(cfqd))
 		cfq_schedule_dispatch(cfqd);
 }
 

-- 
Jens Axboe


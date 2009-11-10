Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZKJNy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZKJNy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZKJNy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:54:57 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:42040 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbZKJNy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:54:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=f2FaB9Y5ysv/PqRZnkCtvdaNiwTKszgpmUoU7ms2S57k3OcWEoADVYF5xGrTNWUuts
         pnbTctpq5cAvjRtz4Es9E6OGk4Ji1homyZsN+tDsg4uGGzj5X+Yq66oaunPgDGic7qzx
         LTWXEt7v0aFnlFMrz6NzBlKcG7HI8JCXdj46U=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC, PATCH] cfq-iosched: remove redundant queuing detection code
Date: Tue, 10 Nov 2009 14:54:57 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911101454.57522.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core block layer already has code to detect presence of command
queuing devices. We convert cfq to use that instead of re-doing the
computation.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   55 ++------------------------------------------------
 1 files changed, 3 insertions(+), 52 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 829d87d..a185742 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -186,14 +186,6 @@ struct cfq_data {
 	int sync_flight;
 
 	/*
-	 * queue-depth detection
-	 */
-	int rq_queued;
-	int hw_tag;
-	int hw_tag_samples;
-	int rq_in_driver_peak;
-
-	/*
 	 * idle window management
 	 */
 	struct timer_list idle_slice_timer;
@@ -912,7 +904,6 @@ static void cfq_remove_request(struct request *rq)
 	list_del_init(&rq->queuelist);
 	cfq_del_rq_rb(rq);
 
-	cfqq->cfqd->rq_queued--;
 	if (rq_is_meta(rq)) {
 		WARN_ON(!cfqq->meta_pending);
 		cfqq->meta_pending--;
@@ -1227,7 +1218,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * for devices that support queuing, otherwise we still have a problem
 	 * with sync vs async workloads.
 	 */
-	if (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag)
+	if (blk_queue_nonrot(cfqd->queue) && blk_queue_queuing(cfqd->queue))
 		return;
 
 	WARN_ON(!RB_EMPTY_ROOT(&cfqq->sort_list));
@@ -1273,7 +1264,8 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
 	    service_tree_for(cfqd->serving_prio, SYNC_NOIDLE_WORKLOAD, cfqd)
 		->count > 0) {
-		if (blk_queue_nonrot(cfqd->queue) || cfqd->hw_tag)
+		if (blk_queue_nonrot(cfqd->queue) ||
+		    blk_queue_queuing(cfqd->queue))
 			return;
 		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
 	}
@@ -2462,7 +2454,6 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 {
 	struct cfq_io_context *cic = RQ_CIC(rq);
 
-	cfqd->rq_queued++;
 	if (rq_is_meta(rq))
 		cfqq->meta_pending++;
 
@@ -2518,43 +2509,6 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	cfq_rq_enqueued(cfqd, cfqq, rq);
 }
 
-/*
- * Update hw_tag based on peak queue depth over 50 samples under
- * sufficient load.
- */
-static void cfq_update_hw_tag(struct cfq_data *cfqd)
-{
-	struct cfq_queue *cfqq = cfqd->active_queue;
-
-	if (rq_in_driver(cfqd) > cfqd->rq_in_driver_peak)
-		cfqd->rq_in_driver_peak = rq_in_driver(cfqd);
-
-	if (cfqd->rq_queued <= CFQ_HW_QUEUE_MIN &&
-	    rq_in_driver(cfqd) <= CFQ_HW_QUEUE_MIN)
-		return;
-
-	/*
-	 * If active queue hasn't enough requests and can idle, cfq might not
-	 * dispatch sufficient requests to hardware. Don't zero hw_tag in this
-	 * case
-	 */
-	if (cfqq && cfq_cfqq_idle_window(cfqq) &&
-	    cfqq->dispatched + cfqq->queued[0] + cfqq->queued[1] <
-	    CFQ_HW_QUEUE_MIN && rq_in_driver(cfqd) < CFQ_HW_QUEUE_MIN)
-		return;
-
-	if (cfqd->hw_tag_samples++ < 50)
-		return;
-
-	if (cfqd->rq_in_driver_peak >= CFQ_HW_QUEUE_MIN)
-		cfqd->hw_tag = 1;
-	else
-		cfqd->hw_tag = 0;
-
-	cfqd->hw_tag_samples = 0;
-	cfqd->rq_in_driver_peak = 0;
-}
-
 static void cfq_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
@@ -2565,8 +2519,6 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	now = jiffies;
 	cfq_log_cfqq(cfqd, cfqq, "complete");
 
-	cfq_update_hw_tag(cfqd);
-
 	WARN_ON(!cfqd->rq_in_driver[sync]);
 	WARN_ON(!cfqq->dispatched);
 	cfqd->rq_in_driver[sync]--;
@@ -2959,7 +2911,6 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->cfq_latency = 1;
-	cfqd->hw_tag = 1;
 	cfqd->last_end_sync_rq = jiffies;
 	return cfqd;
 }
-- 
1.6.2.5



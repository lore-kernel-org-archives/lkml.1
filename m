Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYHVGnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYHVGnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYHVGm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:42:57 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:37857 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754341AbYHVGm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:42:56 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 22 Aug 2008 16:42:42 +1000
Message-ID: <48AE5FE2.2060003@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.14 (X11/20080618)
MIME-Version: 1.0
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cfq-iosched: fix queue depth detection
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

This patch fixes a bug in the hw_tag detection logic causing a huge performance
hit under certain workloads on real queuing devices.  For example, an FIO load
of 16k direct random reads on an 8-disk hardware RAID yields about 2 MiB/s on
default CFQ, while noop achieves over 20 MiB/s.

While the solution is pretty ugly, it does have the advantage of adapting to
queue depth changes.  Such a situation might occur if the queue depth is
configured in userspace late in the boot process.

Thanks,
  Aaron.

--

CFQ's detection of queueing devices assumes a non-queuing device and detects
if the queue depth reaches a certain threshold.  Under some workloads (e.g.
synchronous reads), CFQ effectively forces a unit queue depth, thus defeating
the detection logic.  This leads to poor performance on queuing hardware,
since the idle window remains enabled.

This patch inverts the sense of the logic: assume a queuing-capable device,
and detect if the depth does not exceed the threshold.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
---
 block/cfq-iosched.c |   47 ++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1e2aff8..01ebb75 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -39,6 +39,7 @@ static int cfq_slice_idle = HZ / 125;
 #define CFQ_MIN_TT		(2)
 
 #define CFQ_SLICE_SCALE		(5)
+#define CFQ_HW_QUEUE_MIN	(5)
 
 #define RQ_CIC(rq)		\
 	((struct cfq_io_context *) (rq)->elevator_private)
@@ -86,7 +87,14 @@ struct cfq_data {
 
 	int rq_in_driver;
 	int sync_flight;
+
+	/*
+	 * queue-depth detection
+	 */
+	int rq_queued;
 	int hw_tag;
+	int hw_tag_samples;
+	int rq_in_driver_peak;
 
 	/*
 	 * idle window management
@@ -654,15 +662,6 @@ static void cfq_activate_request(struct request_queue *q, struct request *rq)
 	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "activate rq, drv=%d",
 						cfqd->rq_in_driver);
 
-	/*
-	 * If the depth is larger 1, it really could be queueing. But lets
-	 * make the mark a little higher - idling could still be good for
-	 * low queueing, and a low queueing number could also just indicate
-	 * a SCSI mid layer like behaviour where limit+1 is often seen.
-	 */
-	if (!cfqd->hw_tag && cfqd->rq_in_driver > 4)
-		cfqd->hw_tag = 1;
-
 	cfqd->last_position = rq->hard_sector + rq->hard_nr_sectors;
 }
 
@@ -686,6 +685,7 @@ static void cfq_remove_request(struct request *rq)
 	list_del_init(&rq->queuelist);
 	cfq_del_rq_rb(rq);
 
+	cfqq->cfqd->rq_queued--;
 	if (rq_is_meta(rq)) {
 		WARN_ON(!cfqq->meta_pending);
 		cfqq->meta_pending--;
@@ -1833,6 +1833,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 {
 	struct cfq_io_context *cic = RQ_CIC(rq);
 
+	cfqd->rq_queued++;
 	if (rq_is_meta(rq))
 		cfqq->meta_pending++;
 
@@ -1880,6 +1881,31 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	cfq_rq_enqueued(cfqd, cfqq, rq);
 }
 
+/*
+ * Update hw_tag based on peak queue depth over 50 samples under
+ * sufficient load.
+ */
+static void cfq_update_hw_tag(struct cfq_data *cfqd)
+{
+	if (cfqd->rq_in_driver > cfqd->rq_in_driver_peak)
+		cfqd->rq_in_driver_peak = cfqd->rq_in_driver;
+
+	if (cfqd->rq_queued <= CFQ_HW_QUEUE_MIN &&
+	    cfqd->rq_in_driver <= CFQ_HW_QUEUE_MIN)
+		return;
+
+	if (cfqd->hw_tag_samples++ < 50)
+		return;
+
+	if (cfqd->rq_in_driver_peak >= CFQ_HW_QUEUE_MIN)
+		cfqd->hw_tag = 1;
+	else
+		cfqd->hw_tag = 0;
+
+	cfqd->hw_tag_samples = 0;
+	cfqd->rq_in_driver_peak = 0;
+}
+
 static void cfq_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
@@ -1890,6 +1916,8 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	now = jiffies;
 	cfq_log_cfqq(cfqd, cfqq, "complete");
 
+	cfq_update_hw_tag(cfqd);
+
 	WARN_ON(!cfqd->rq_in_driver);
 	WARN_ON(!cfqq->dispatched);
 	cfqd->rq_in_driver--;
@@ -2200,6 +2228,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_slice[1] = cfq_slice_sync;
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
+	cfqd->hw_tag = 1;
 
 	return cfqd;
 }
-- 
1.5.4.5

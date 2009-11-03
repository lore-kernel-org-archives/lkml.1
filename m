Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZKCXoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZKCXoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZKCXow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbZKCXou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:50 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 17/20] blkio: Wait for queue to get backlogged before it expires
Date: Tue,  3 Nov 2009 18:43:54 -0500
Message-Id: <1257291837-6246-18-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o CFQ expires a cfqq if it has consumed its time slice. Expiry also means that
  queue gets deleted from service tree. For the sequential IO, most of the time
  a new IO comes almost immediately and cfqq gets backlogged again.

o This additiona dequeuing creates issues. dequeuing means that associated
  group will also be removed from service tree and we select a new queue and
  new group for dispatch and vdisktime jump takes place and group looses its
  fair share.

o One solution is to wait for queue to get busy if it is empty at the time
  of expiry and cfq plans to idle on the queue (it expects new request to come
  with-in 8ms).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   81 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 020d6dd..b7ef953 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -411,6 +411,21 @@ cfq_weight_slice(struct cfq_data *cfqd, int sync, unsigned int weight)
 	return cfq_delta(base_slice, weight, BLKIO_WEIGHT_DEFAULT);
 }
 
+/*
+ * We need to wrap this check in cfq_cfqq_slice_new(), since ->slice_end
+ * isn't valid until the first request from the dispatch is activated
+ * and the slice time set.
+ */
+static inline bool cfq_slice_used(struct cfq_queue *cfqq)
+{
+	if (cfq_cfqq_slice_new(cfqq))
+		return 0;
+	if (time_before(jiffies, cfqq->slice_end))
+		return 0;
+
+	return 1;
+}
+
 static inline void
 cfq_init_cfqe_parent(struct cfq_entity *cfqe, struct cfq_entity *p_cfqe)
 {
@@ -425,6 +440,17 @@ cfq_init_cfqe_parent(struct cfq_entity *cfqe, struct cfq_entity *p_cfqe)
 
 #define cfqe_is_cfqq(cfqe)     (!(cfqe)->my_sd)
 
+static inline bool cfqq_should_wait_busy(struct cfq_queue *cfqq)
+{
+	if (!RB_EMPTY_ROOT(&cfqq->sort_list) || !cfq_cfqq_idle_window(cfqq))
+		return false;
+
+	if (cfqq->dispatched && !cfq_slice_used(cfqq))
+		return false;
+
+	return true;
+}
+
 static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 {
 	if (blkg)
@@ -635,6 +661,11 @@ static void cfq_release_cfq_groups(struct cfq_data *cfqd) {}
 static inline void cfq_get_cfqg_ref(struct cfq_group *cfqg) {}
 static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
 
+static inline bool cfqq_should_wait_busy(struct cfq_queue *cfqq)
+{
+	return false;
+}
+
 static inline struct cfq_data *cfqd_of(struct cfq_entity *cfqe)
 {
 	return cfqq_of(cfqe)->cfqd;
@@ -722,21 +753,6 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 }
 
 /*
- * We need to wrap this check in cfq_cfqq_slice_new(), since ->slice_end
- * isn't valid until the first request from the dispatch is activated
- * and the slice time set.
- */
-static inline bool cfq_slice_used(struct cfq_queue *cfqq)
-{
-	if (cfq_cfqq_slice_new(cfqq))
-		return 0;
-	if (time_before(jiffies, cfqq->slice_end))
-		return 0;
-
-	return 1;
-}
-
-/*
  * Lifted from AS - choose which of rq1 and rq2 that is best served now.
  * We choose the request that is closest to the head right now. Distance
  * behind the head is penalized and only allowed to a certain extent.
@@ -1647,19 +1663,22 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	return cfqq;
 }
 
-static void cfq_arm_slice_timer(struct cfq_data *cfqd)
+static bool cfq_arm_slice_timer(struct cfq_data *cfqd, int reset)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 	struct cfq_io_context *cic;
 	unsigned long sl;
 
+	/* If idle timer is already armed, nothing to do */
+	if (!reset && timer_pending(&cfqd->idle_slice_timer))
+		return true;
 	/*
 	 * SSD device without seek penalty, disable idling. But only do so
 	 * for devices that support queuing, otherwise we still have a problem
 	 * with sync vs async workloads.
 	 */
 	if (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag)
-		return;
+		return false;
 
 	WARN_ON(!RB_EMPTY_ROOT(&cfqq->sort_list));
 	WARN_ON(cfq_cfqq_slice_new(cfqq));
@@ -1668,20 +1687,20 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * idle is disabled, either manually or by past process history
 	 */
 	if (!cfqd->cfq_slice_idle || !cfq_cfqq_idle_window(cfqq))
-		return;
+		return false;
 
 	/*
 	 * still requests with the driver, don't idle
 	 */
 	if (rq_in_driver(cfqd))
-		return;
+		return false;
 
 	/*
 	 * task has exited, don't wait
 	 */
 	cic = cfqd->active_cic;
 	if (!cic || !atomic_read(&cic->ioc->nr_tasks))
-		return;
+		return false;
 
 	/*
 	 * If our average think time is larger than the remaining time
@@ -1690,7 +1709,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 */
 	if (sample_valid(cic->ttime_samples) &&
 	    (cfqq->slice_end - jiffies < cic->ttime_mean))
-		return;
+		return false;
 
 	cfq_mark_cfqq_wait_request(cfqq);
 
@@ -1704,7 +1723,8 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
-	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
+	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu reset=%d", sl, reset);
+	return true;
 }
 
 /*
@@ -1775,6 +1795,12 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	if (!cfqd->rq_queued)
 		return NULL;
 
+	/* Wait for a queue to get busy before we expire it */
+	if (cfqq_should_wait_busy(cfqq) && cfq_arm_slice_timer(cfqd, 0)) {
+		cfqq = NULL;
+		goto keep_queue;
+	}
+
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
@@ -2786,8 +2812,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			    cfqd->busy_queues > 1) {
 				del_timer(&cfqd->idle_slice_timer);
 			__blk_run_queue(cfqd->queue);
-			}
-			cfq_mark_cfqq_must_dispatch(cfqq);
+			} else
+				cfq_mark_cfqq_must_dispatch(cfqq);
 		}
 	} else if (cfq_should_preempt(cfqd, cfqq, rq)) {
 		/*
@@ -2886,10 +2912,13 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		 * of idling.
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
-			cfq_slice_expired(cfqd);
+			if (!cfqq_should_wait_busy(cfqq))
+				cfq_slice_expired(cfqd);
+			else
+				cfq_arm_slice_timer(cfqd, 1);
 		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq, 1) &&
 			 sync && !rq_noidle(rq))
-			cfq_arm_slice_timer(cfqd);
+			cfq_arm_slice_timer(cfqd, 1);
 	}
 
 	if (!rq_in_driver(cfqd))
-- 
1.6.2.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZKMRlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZKMRlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932164AbZKMRlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:41:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbZKMRlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:41:01 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
Subject: [PATCH 15/16] blkio: Idle on a group for some time on rotational media
Date: Fri, 13 Nov 2009 12:40:14 -0500
Message-Id: <1258134015-21632-16-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o If a group is not continuously backlogged, then it will be deleted from
  service tree and loose it share. For example, if a single random seeky
  reader or a single sequential reader is running in group.

o One solution is to let group loose it share if it is not backlogged and
  other solution is to wait a bit for the slow group so that it can get its
  time slice. This patch implements waiting for a group to wait a bit.

o This waiting is disabled for NCQ SSDs.

o This patch also intorduces the tunable "group_idle" which can enable/disable
  group idling manually.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |  142 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 95 insertions(+), 47 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5feffdc..557cce5 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -265,6 +265,7 @@ struct cfq_data {
 	unsigned int cfq_slice_async_rq;
 	unsigned int cfq_slice_idle;
 	unsigned int cfq_latency;
+	unsigned int cfq_group_idle;
 
 	struct list_head cic_list;
 
@@ -890,6 +891,37 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	blkiocg_update_blkio_group_stats(&cfqg->blkg, service, sectors);
 }
 
+/*
+ * Determine whether we should enforce idle window for this queue.
+ */
+
+static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	enum wl_prio_t prio = cfqq_prio(cfqq);
+	struct cfq_rb_root *service_tree = cfqq->service_tree;
+
+	/* We never do for idle class queues. */
+	if (prio == IDLE_WORKLOAD)
+		return false;
+
+	/* We do for queues that were marked with idle window flag. */
+	if (cfq_cfqq_idle_window(cfqq))
+		return true;
+
+	/*
+	 * Otherwise, we do only if they are the last ones
+	 * in their service tree.
+	 */
+	if (!service_tree)
+		service_tree = service_tree_for(cfqq->cfqg, prio,
+						cfqq_type(cfqq), cfqd);
+
+	if (service_tree->count == 0)
+		return true;
+
+	return (service_tree->count == 1 && cfq_rb_first(service_tree) == cfqq);
+}
+
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 {
@@ -1060,6 +1092,22 @@ void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
+static inline bool cfqq_should_wait_busy(struct cfq_queue *cfqq)
+{
+	/* Group idling is disabled */
+	if (!cfqq->cfqd->cfq_group_idle)
+		return false;
+
+	/* cfqq group still has got more requests to dispatch */
+	if (!RB_EMPTY_ROOT(&cfqq->sort_list) || cfqq->cfqg->nr_cfqq > 1)
+		return false;
+
+	if (!cfq_should_idle(cfqq->cfqd, cfqq))
+		return false;
+
+	return true;
+}
+
 #else /* GROUP_IOSCHED */
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 {
@@ -1072,6 +1120,10 @@ cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
 
 static void cfq_release_cfq_groups(struct cfq_data *cfqd) {}
 static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
+static inline bool cfqq_should_wait_busy(struct cfq_queue *cfqq)
+{
+	return false;
+}
 
 #endif /* GROUP_IOSCHED */
 
@@ -1724,51 +1776,24 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	return cfqq;
 }
 
-/*
- * Determine whether we should enforce idle window for this queue.
- */
-
-static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
-{
-	enum wl_prio_t prio = cfqq_prio(cfqq);
-	struct cfq_rb_root *service_tree = cfqq->service_tree;
-
-	/* We never do for idle class queues. */
-	if (prio == IDLE_WORKLOAD)
-		return false;
-
-	/* We do for queues that were marked with idle window flag. */
-	if (cfq_cfqq_idle_window(cfqq))
-		return true;
-
-	/*
-	 * Otherwise, we do only if they are the last ones
-	 * in their service tree.
-	 */
-	if (!service_tree)
-		service_tree = service_tree_for(cfqq->cfqg, prio,
-						cfqq_type(cfqq), cfqd);
-
-	if (service_tree->count == 0)
-		return true;
-
-	return (service_tree->count == 1 && cfq_rb_first(service_tree) == cfqq);
-}
-
-static void cfq_arm_slice_timer(struct cfq_data *cfqd)
+static bool cfq_arm_slice_timer(struct cfq_data *cfqd, int wait_busy)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 	struct cfq_io_context *cic;
 	unsigned long sl;
 	struct cfq_rb_root *st;
 
+	/* If idle timer is already armed, nothing to do */
+	if (wait_busy && timer_pending(&cfqd->idle_slice_timer))
+		return true;
+
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
@@ -1777,29 +1802,29 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * idle is disabled, either manually or by past process history
 	 */
 	if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
-		return;
+		return false;
 
 	/*
 	 * still requests with the driver, don't idle
 	 */
-	if (rq_in_driver(cfqd))
-		return;
+	if (rq_in_driver(cfqd) && !wait_busy)
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
 	 * slice, then don't idle. This avoids overrunning the allotted
 	 * time slice.
 	 */
-	if (sample_valid(cic->ttime_samples) &&
+	if (!wait_busy && sample_valid(cic->ttime_samples) &&
 	    (cfqq->slice_end - jiffies < cic->ttime_mean))
-		return;
+		return false;
 
 	cfq_mark_cfqq_wait_request(cfqq);
 
@@ -1812,14 +1837,19 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 */
 	st = service_tree_for(cfqq->cfqg, cfqd->serving_prio,
 				SYNC_NOIDLE_WORKLOAD, cfqd);
-	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD && st->count > 0) {
+	if (!wait_busy && cfqd->serving_type == SYNC_NOIDLE_WORKLOAD
+	    && st->count > 0) {
 		if (blk_queue_nonrot(cfqd->queue) || cfqd->hw_tag)
-			return;
+			return false;
 		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
 	}
 
+	if (wait_busy)
+		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
+
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
-	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
+	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu wait_busy=%d", sl, wait_busy);
+	return true;
 }
 
 /*
@@ -2076,6 +2106,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 
 	if (!cfqd->rq_queued)
 		return NULL;
+
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
@@ -2114,6 +2145,16 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	}
 
 expire:
+	/*
+	 * Wait for a group to get busy before we expire it. No wait
+	 * is done for NCQ SSDs. Do a small wait of 2ms on rotational
+	 * media in the hope that group will get backlogged again and
+	 * not loose its fair share.
+	 */
+	if (cfqq_should_wait_busy(cfqq) && cfq_arm_slice_timer(cfqd, 1)) {
+		cfqq = NULL;
+		goto keep_queue;
+	}
 	cfq_slice_expired(cfqd, 0);
 new_queue:
 	/*
@@ -3119,9 +3160,9 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE ||
 			    cfqd->busy_queues > 1) {
 				del_timer(&cfqd->idle_slice_timer);
-			__blk_run_queue(cfqd->queue);
-			}
-			cfq_mark_cfqq_must_dispatch(cfqq);
+				__blk_run_queue(cfqd->queue);
+			} else
+				cfq_mark_cfqq_must_dispatch(cfqq);
 		}
 	} else if (cfq_should_preempt(cfqd, cfqq, rq)) {
 		/*
@@ -3231,10 +3272,13 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		 * of idling.
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
-			cfq_slice_expired(cfqd, 1);
+			if (!cfqq_should_wait_busy(cfqq))
+				cfq_slice_expired(cfqd, 0);
+			else
+				cfq_arm_slice_timer(cfqd, 1);
 		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq) &&
 			 sync && !rq_noidle(rq))
-			cfq_arm_slice_timer(cfqd);
+			cfq_arm_slice_timer(cfqd, 0);
 	}
 
 	if (!rq_in_driver(cfqd))
@@ -3616,6 +3660,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->cfq_latency = 1;
+	cfqd->cfq_group_idle = 1;
 	cfqd->hw_tag = 1;
 	cfqd->last_end_sync_rq = jiffies;
 	return cfqd;
@@ -3686,6 +3731,7 @@ SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
 SHOW_FUNCTION(cfq_low_latency_show, cfqd->cfq_latency, 0);
+SHOW_FUNCTION(cfq_group_idle_show, cfqd->cfq_group_idle, 0);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -3718,6 +3764,7 @@ STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
 		UINT_MAX, 0);
 STORE_FUNCTION(cfq_low_latency_store, &cfqd->cfq_latency, 0, 1, 0);
+STORE_FUNCTION(cfq_group_idle_store, &cfqd->cfq_group_idle, 0, 1, 0);
 #undef STORE_FUNCTION
 
 #define CFQ_ATTR(name) \
@@ -3734,6 +3781,7 @@ static struct elv_fs_entry cfq_attrs[] = {
 	CFQ_ATTR(slice_async_rq),
 	CFQ_ATTR(slice_idle),
 	CFQ_ATTR(low_latency),
+	CFQ_ATTR(group_idle),
 	__ATTR_NULL
 };
 
-- 
1.6.2.5


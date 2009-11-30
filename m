Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbZK3DBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbZK3DBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZK3DBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbZK3DAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:54 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 04/21] blkio: Keep queue on service tree until we expire it
Date: Sun, 29 Nov 2009 21:59:11 -0500
Message-Id: <1259549968-10369-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Currently cfqq deletes a queue from service tree if it is empty (even if
  we might idle on the queue). This patch keeps the queue on service tree
  hence associated group remains on the service tree until we decide that
  we are not going to idle on the queue and expire it.

o This just helps in time accounting for queue/group and in implementation
  of rest of the patches.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   70 +++++++++++++++++++++++++++++++++++---------------
 1 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index c73ff44..a0d0a83 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -391,7 +391,7 @@ static int cfq_queue_empty(struct request_queue *q)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 
-	return !cfqd->busy_queues;
+	return !cfqd->rq_queued;
 }
 
 /*
@@ -845,7 +845,6 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 static void cfq_del_rq_rb(struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
-	struct cfq_data *cfqd = cfqq->cfqd;
 	const int sync = rq_is_sync(rq);
 
 	BUG_ON(!cfqq->queued[sync]);
@@ -853,8 +852,17 @@ static void cfq_del_rq_rb(struct request *rq)
 
 	elv_rb_del(&cfqq->sort_list, rq);
 
-	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
-		cfq_del_cfqq_rr(cfqd, cfqq);
+	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list)) {
+		/*
+		 * Queue will be deleted from service tree when we actually
+		 * expire it later. Right now just remove it from prio tree
+		 * as it is empty.
+		 */
+		if (cfqq->p_root) {
+			rb_erase(&cfqq->p_node, cfqq->p_root);
+			cfqq->p_root = NULL;
+		}
+	}
 }
 
 static void cfq_add_rq_rb(struct request *rq)
@@ -1068,6 +1076,9 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
 	}
 
+	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
+		cfq_del_cfqq_rr(cfqd, cfqq);
+
 	cfq_resort_rr_list(cfqd, cfqq);
 
 	if (cfqq == cfqd->active_queue)
@@ -1097,11 +1108,30 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 		service_tree_for(cfqd->serving_group, cfqd->serving_prio,
 					cfqd->serving_type, cfqd);
 
+	if (!cfqd->rq_queued)
+		return NULL;
+
 	if (RB_EMPTY_ROOT(&service_tree->rb))
 		return NULL;
 	return cfq_rb_first(service_tree);
 }
 
+static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
+{
+	struct cfq_group *cfqg = &cfqd->root_group;
+	struct cfq_queue *cfqq;
+	int i, j;
+	struct cfq_rb_root *st;
+
+	if (!cfqd->rq_queued)
+		return NULL;
+
+	for_each_cfqg_st(cfqg, i, j, st)
+		if ((cfqq = cfq_rb_first(st)) != NULL)
+			return cfqq;
+	return NULL;
+}
+
 /*
  * Get and set a new active queue for service.
  */
@@ -1234,6 +1264,9 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	enum wl_prio_t prio = cfqq_prio(cfqq);
 	struct cfq_rb_root *service_tree = cfqq->service_tree;
 
+	BUG_ON(!service_tree);
+	BUG_ON(!service_tree->count);
+
 	/* We never do for idle class queues. */
 	if (prio == IDLE_WORKLOAD)
 		return false;
@@ -1246,14 +1279,7 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * Otherwise, we do only if they are the last ones
 	 * in their service tree.
 	 */
-	if (!service_tree)
-		service_tree = service_tree_for(cfqq->cfqg, prio,
-						cfqq_type(cfqq), cfqd);
-
-	if (service_tree->count == 0)
-		return true;
-
-	return (service_tree->count == 1 && cfq_rb_first(service_tree) == cfqq);
+	return service_tree->count == 1;
 }
 
 static void cfq_arm_slice_timer(struct cfq_data *cfqd)
@@ -1530,6 +1556,8 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	if (!cfqq)
 		goto new_queue;
 
+	if (!cfqd->rq_queued)
+		return NULL;
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
@@ -1592,6 +1620,9 @@ static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 	}
 
 	BUG_ON(!list_empty(&cfqq->fifo));
+
+	/* By default cfqq is not expired if it is empty. Do it explicitly */
+	__cfq_slice_expired(cfqq->cfqd, cfqq, 0);
 	return dispatched;
 }
 
@@ -1603,14 +1634,9 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq;
 	int dispatched = 0;
-	int i, j;
-	struct cfq_group *cfqg = &cfqd->root_group;
-	struct cfq_rb_root *st;
 
-	for_each_cfqg_st(cfqg, i, j, st) {
-		while ((cfqq = cfq_rb_first(st)) != NULL)
-			dispatched += __cfq_forced_dispatch_cfqq(cfqq);
-	}
+	while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL)
+		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 
 	cfq_slice_expired(cfqd, 0);
 	BUG_ON(cfqd->busy_queues);
@@ -1779,13 +1805,13 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	cfq_log_cfqq(cfqd, cfqq, "put_queue");
 	BUG_ON(rb_first(&cfqq->sort_list));
 	BUG_ON(cfqq->allocated[READ] + cfqq->allocated[WRITE]);
-	BUG_ON(cfq_cfqq_on_rr(cfqq));
 
 	if (unlikely(cfqd->active_queue == cfqq)) {
 		__cfq_slice_expired(cfqd, cfqq, 0);
 		cfq_schedule_dispatch(cfqd);
 	}
 
+	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	kmem_cache_free(cfq_pool, cfqq);
 }
 
@@ -2447,9 +2473,11 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (cfq_class_idle(cfqq))
 		return true;
 
+	/* Allow preemption only if we are idling on sync-noidle tree */
 	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
 	    cfqq_type(new_cfqq) == SYNC_NOIDLE_WORKLOAD &&
-	    new_cfqq->service_tree->count == 1)
+	    new_cfqq->service_tree->count == 2 &&
+	    RB_EMPTY_ROOT(&cfqq->sort_list))
 		return true;
 
 	/*
-- 
1.6.2.5


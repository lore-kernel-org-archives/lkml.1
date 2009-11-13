Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZKMRnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZKMRnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbZKMRmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:42:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbZKMRlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:41:00 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
Subject: [PATCH 02/16] blkio: Keep queue on service tree until we expire it
Date: Fri, 13 Nov 2009 12:40:01 -0500
Message-Id: <1258134015-21632-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
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
 block/cfq-iosched.c |   72 +++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index aebb205..d099880 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -374,7 +374,7 @@ static int cfq_queue_empty(struct request_queue *q)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 
-	return !cfqd->busy_queues;
+	return !cfqd->rq_queued;
 }
 
 /*
@@ -557,6 +557,10 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2,
  */
 static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
 {
+	/* Service tree is empty */
+	if (!root->count)
+		return NULL;
+
 	if (!root->left)
 		root->left = rb_first(&root->rb);
 
@@ -819,7 +823,6 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 static void cfq_del_rq_rb(struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
-	struct cfq_data *cfqd = cfqq->cfqd;
 	const int sync = rq_is_sync(rq);
 
 	BUG_ON(!cfqq->queued[sync]);
@@ -827,8 +830,17 @@ static void cfq_del_rq_rb(struct request *rq)
 
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
@@ -1042,6 +1054,9 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
 	}
 
+	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
+		cfq_del_cfqq_rr(cfqd, cfqq);
+
 	cfq_resort_rr_list(cfqd, cfqq);
 
 	if (cfqq == cfqd->active_queue)
@@ -1065,17 +1080,43 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
  * Get next queue for service. Unless we have a queue preemption,
  * we'll simply select the first cfqq in the service tree.
  */
-static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
+static struct cfq_queue *__cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *service_tree =
 		service_tree_for(cfqd->serving_group, cfqd->serving_prio,
 					cfqd->serving_type, cfqd);
 
+	if (!cfqd->rq_queued)
+		return NULL;
+
 	if (RB_EMPTY_ROOT(&service_tree->rb))
 		return NULL;
 	return cfq_rb_first(service_tree);
 }
 
+static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
+{
+	struct cfq_group *cfqg = &cfqd->root_group;
+	struct cfq_queue *cfqq;
+	int i, j;
+
+	if (!cfqd->rq_queued)
+		return NULL;
+
+	for (i = 0; i < 2; ++i) {
+		for (j = 0; j < 3; ++j) {
+			cfqq = cfq_rb_first(&cfqg->service_trees[i][j]);
+			if (cfqq)
+				return cfqq;
+		}
+	}
+
+	cfqq = cfq_rb_first(&cfqg->service_tree_idle);
+	if (cfqq)
+		return cfqq;
+	return NULL;
+}
+
 /*
  * Get and set a new active queue for service.
  */
@@ -1083,7 +1124,7 @@ static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd,
 					      struct cfq_queue *cfqq)
 {
 	if (!cfqq)
-		cfqq = cfq_get_next_queue(cfqd);
+		cfqq = __cfq_get_next_queue(cfqd);
 
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
@@ -1517,6 +1558,8 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	if (!cfqq)
 		goto new_queue;
 
+	if (!cfqd->rq_queued)
+		return NULL;
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
@@ -1579,6 +1622,10 @@ static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 	}
 
 	BUG_ON(!list_empty(&cfqq->fifo));
+
+	/* By default cfqq is not expired if it is empty. Do it explicitly */
+	__cfq_slice_expired(cfqq->cfqd, cfqq, 0);
+
 	return dispatched;
 }
 
@@ -1590,16 +1637,8 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq;
 	int dispatched = 0;
-	int i, j;
-	struct cfq_group *cfqg = &cfqd->root_group;
-
-	for (i = 0; i < 2; ++i)
-		for (j = 0; j < 3; ++j)
-			while ((cfqq = cfq_rb_first(&cfqg->service_trees[i][j]))
-				!= NULL)
-				dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 
-	while ((cfqq = cfq_rb_first(&cfqg->service_tree_idle)) != NULL)
+	while ((cfqq = cfq_get_next_queue(cfqd)) != NULL)
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 
 	cfq_slice_expired(cfqd, 0);
@@ -1770,13 +1809,14 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	cfq_log_cfqq(cfqd, cfqq, "put_queue");
 	BUG_ON(rb_first(&cfqq->sort_list));
 	BUG_ON(cfqq->allocated[READ] + cfqq->allocated[WRITE]);
-	BUG_ON(cfq_cfqq_on_rr(cfqq));
 
 	if (unlikely(cfqd->active_queue == cfqq)) {
 		__cfq_slice_expired(cfqd, cfqq, 0);
 		cfq_schedule_dispatch(cfqd);
 	}
 
+	BUG_ON(cfq_cfqq_on_rr(cfqq));
+
 	kmem_cache_free(cfq_pool, cfqq);
 }
 
-- 
1.6.2.5


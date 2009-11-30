Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZK3DAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZK3DAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZK3DAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:00:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbZK3DAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 19/21] blkio: Implement group_isolation tunable
Date: Sun, 29 Nov 2009 21:59:26 -0500
Message-Id: <1259549968-10369-20-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o If a group is running only a random reader, then it will not have enough
  traffic to keep disk busy and we will reduce overall throughput. This
  should result in better latencies for random reader though. If we don't
  idle on random reader service tree, then this random reader will experience
  large latencies if there are other groups present in system with sequential
  readers running in these.

o One solution suggested by corrado is that by default keep the random readers
  or sync-noidle workload in root group so that during one dispatch round
  we idle only once on sync-noidle tree. This means that all the sync-idle
  workload queues will be in their respective group and we will see service
  differentiation in those but not on sync-noidle workload.

o Provide a tunable group_isolation. If set, this will make sure that even
  sync-noidle queues go in their respective group and we wait on these. This
  provides stronger isolation between groups but at the expense of throughput
  if group does not have enough traffic to keep the disk busy.

o By default group_isolation = 0

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ba052cf..e87f0d1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -143,6 +143,7 @@ struct cfq_queue {
 	struct cfq_rb_root *service_tree;
 	struct cfq_queue *new_cfqq;
 	struct cfq_group *cfqg;
+	struct cfq_group *orig_cfqg;
 	/* Sectors dispatched in current dispatch round */
 	unsigned long nr_sectors;
 };
@@ -272,6 +273,7 @@ struct cfq_data {
 	unsigned int cfq_slice_async_rq;
 	unsigned int cfq_slice_idle;
 	unsigned int cfq_latency;
+	unsigned int cfq_group_isolation;
 
 	struct list_head cic_list;
 
@@ -1122,6 +1124,33 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct cfq_rb_root *service_tree;
 	int left;
 	int new_cfqq = 1;
+	int group_changed = 0;
+
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	if (!cfqd->cfq_group_isolation
+	    && cfqq_type(cfqq) == SYNC_NOIDLE_WORKLOAD
+	    && cfqq->cfqg && cfqq->cfqg != &cfqd->root_group) {
+		/* Move this cfq to root group */
+		cfq_log_cfqq(cfqd, cfqq, "moving to root group");
+		if (!RB_EMPTY_NODE(&cfqq->rb_node))
+			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
+		cfqq->orig_cfqg = cfqq->cfqg;
+		cfqq->cfqg = &cfqd->root_group;
+		atomic_inc(&cfqd->root_group.ref);
+		group_changed = 1;
+	} else if (!cfqd->cfq_group_isolation
+		   && cfqq_type(cfqq) == SYNC_WORKLOAD && cfqq->orig_cfqg) {
+		/* cfqq is sequential now needs to go to its original group */
+		BUG_ON(cfqq->cfqg != &cfqd->root_group);
+		if (!RB_EMPTY_NODE(&cfqq->rb_node))
+			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
+		cfq_put_cfqg(cfqq->cfqg);
+		cfqq->cfqg = cfqq->orig_cfqg;
+		cfqq->orig_cfqg = NULL;
+		group_changed = 1;
+		cfq_log_cfqq(cfqd, cfqq, "moved to origin group");
+	}
+#endif
 
 	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
 						cfqq_type(cfqq), cfqd);
@@ -1192,7 +1221,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	rb_link_node(&cfqq->rb_node, parent, p);
 	rb_insert_color(&cfqq->rb_node, &service_tree->rb);
 	service_tree->count++;
-	if (add_front || !new_cfqq)
+	if ((add_front || !new_cfqq) && !group_changed)
 		return;
 	cfq_group_service_tree_add(cfqd, cfqq->cfqg);
 }
@@ -2359,6 +2388,8 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	kmem_cache_free(cfq_pool, cfqq);
 	cfq_put_cfqg(cfqg);
+	if (cfqq->orig_cfqg)
+		cfq_put_cfqg(cfqq->orig_cfqg);
 }
 
 /*
@@ -3672,6 +3703,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->cfq_latency = 1;
+	cfqd->cfq_group_isolation = 0;
 	cfqd->hw_tag = -1;
 	cfqd->last_end_sync_rq = jiffies;
 	return cfqd;
@@ -3742,6 +3774,7 @@ SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
 SHOW_FUNCTION(cfq_low_latency_show, cfqd->cfq_latency, 0);
+SHOW_FUNCTION(cfq_group_isolation_show, cfqd->cfq_group_isolation, 0);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -3774,6 +3807,7 @@ STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
 		UINT_MAX, 0);
 STORE_FUNCTION(cfq_low_latency_store, &cfqd->cfq_latency, 0, 1, 0);
+STORE_FUNCTION(cfq_group_isolation_store, &cfqd->cfq_group_isolation, 0, 1, 0);
 #undef STORE_FUNCTION
 
 #define CFQ_ATTR(name) \
@@ -3790,6 +3824,7 @@ static struct elv_fs_entry cfq_attrs[] = {
 	CFQ_ATTR(slice_async_rq),
 	CFQ_ATTR(slice_idle),
 	CFQ_ATTR(low_latency),
+	CFQ_ATTR(group_isolation),
 	__ATTR_NULL
 };
 
-- 
1.6.2.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZK3DAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZK3DAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZK3DAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:00:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZK3DAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 10/21] blkio: Dynamic cfq group creation based on cgroup tasks belongs to
Date: Sun, 29 Nov 2009 21:59:17 -0500
Message-Id: <1259549968-10369-11-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Determine the cgroup IO submitting task belongs to and create the cfq
  group if it does not exist already.

o Also link cfqq and associated cfq group.

o Currently all async IO is mapped to root group.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |  111 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 100 insertions(+), 11 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5a75f81..3706f19 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -188,6 +188,10 @@ struct cfq_group {
 	unsigned long saved_workload_slice;
 	enum wl_type_t saved_workload;
 	enum wl_prio_t saved_serving_prio;
+	struct blkio_group blkg;
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	struct hlist_node cfqd_node;
+#endif
 };
 
 /*
@@ -273,8 +277,13 @@ struct cfq_data {
 	struct cfq_queue oom_cfqq;
 
 	unsigned long last_end_sync_rq;
+
+	/* List of cfq groups being managed on this device*/
+	struct hlist_head cfqg_list;
 };
 
+static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
+
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
 					    enum wl_prio_t prio,
 					    enum wl_type_t type,
@@ -883,6 +892,89 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		cfqg->saved_workload_slice = 0;
 }
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
+{
+	if (blkg)
+		return container_of(blkg, struct cfq_group, blkg);
+	return NULL;
+}
+
+static struct cfq_group *
+cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
+{
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
+	struct cfq_group *cfqg = NULL;
+	void *key = cfqd;
+	int i, j;
+	struct cfq_rb_root *st;
+
+	/* Do we need to take this reference */
+	if (!css_tryget(&blkcg->css))
+		return NULL;;
+
+	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+	if (cfqg || !create)
+		goto done;
+
+	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
+	if (!cfqg)
+		goto done;
+
+	cfqg->weight = blkcg->weight;
+	for_each_cfqg_st(cfqg, i, j, st)
+		*st = CFQ_RB_ROOT;
+	RB_CLEAR_NODE(&cfqg->rb_node);
+
+	/* Add group onto cgroup list */
+	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd);
+
+	/* Add group on cfqd list */
+	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
+
+done:
+	css_put(&blkcg->css);
+	return cfqg;
+}
+
+/*
+ * Search for the cfq group current task belongs to. If create = 1, then also
+ * create the cfq group if it does not exist. request_queue lock must be held.
+ */
+static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+{
+	struct cgroup *cgroup;
+	struct cfq_group *cfqg = NULL;
+
+	rcu_read_lock();
+	cgroup = task_cgroup(current, blkio_subsys_id);
+	cfqg = cfq_find_alloc_cfqg(cfqd, cgroup, create);
+	if (!cfqg && create)
+		cfqg = &cfqd->root_group;
+	rcu_read_unlock();
+	return cfqg;
+}
+
+static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
+{
+	/* Currently, all async queues are mapped to root group */
+	if (!cfq_cfqq_sync(cfqq))
+		cfqg = &cfqq->cfqd->root_group;
+
+	cfqq->cfqg = cfqg;
+}
+#else /* GROUP_IOSCHED */
+static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+{
+	return &cfqd->root_group;
+}
+static inline void
+cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
+	cfqq->cfqg = cfqg;
+}
+
+#endif /* GROUP_IOSCHED */
+
 /*
  * The cfqd->service_trees holds all pending cfq_queue's that have
  * requests waiting to be processed. It is sorted in the order that
@@ -1374,7 +1466,7 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 
 static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
 {
-	struct cfq_group *cfqg = &cfqd->root_group;
+	struct cfq_group *cfqg;
 	struct cfq_queue *cfqq;
 	int i, j;
 	struct cfq_rb_root *st;
@@ -1382,6 +1474,10 @@ static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
 	if (!cfqd->rq_queued)
 		return NULL;
 
+	cfqg = cfq_get_next_cfqg(cfqd);
+	if (!cfqg)
+		return NULL;
+
 	for_each_cfqg_st(cfqg, i, j, st)
 		if ((cfqq = cfq_rb_first(st)) != NULL)
 			return cfqq;
@@ -2392,16 +2488,6 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfqq->pid = pid;
 }
 
-static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
-{
-	cfqq->cfqg = cfqg;
-}
-
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
-{
-	return &cfqd->root_group;
-}
-
 static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
@@ -3316,6 +3402,9 @@ static void *cfq_init_queue(struct request_queue *q)
 	/* Give preference to root group over other groups */
 	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd);
+#endif
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
 	 * zeroed cfqd on alloc), but better be safe in case someone decides
-- 
1.6.2.5


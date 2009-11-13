Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbZKMRlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbZKMRlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZKMRl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:41:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbZKMRlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:41:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
Subject: [PATCH 08/16] blkio: Dynamic cfq group creation based on cgroup tasks belongs to
Date: Fri, 13 Nov 2009 12:40:07 -0500
Message-Id: <1258134015-21632-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Determine the cgroup IO submitting task belongs to and create the cfq
  group if it does not exist already.

o Also link cfqq and associated cfq group.

o Currently all async IO is mapped to root group.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 102 insertions(+), 11 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4c05d45..9653caf 100644
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
@@ -267,8 +271,13 @@ struct cfq_data {
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
@@ -858,6 +867,91 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
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
+
+	for (i = 0; i < 2; ++i)
+		for (j = 0; j < 3; ++j)
+			cfqg->service_trees[i][j] = CFQ_RB_ROOT;
+	cfqg->service_tree_idle = CFQ_RB_ROOT;
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
@@ -1350,13 +1444,17 @@ static struct cfq_queue *__cfq_get_next_queue(struct cfq_data *cfqd)
 
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
-	struct cfq_group *cfqg = &cfqd->root_group;
+	struct cfq_group *cfqg;
 	struct cfq_queue *cfqq;
 	int i, j;
 
 	if (!cfqd->rq_queued)
 		return NULL;
 
+	cfqg = cfq_get_next_cfqg(cfqd);
+	if (!cfqg)
+		return NULL;
+
 	for (i = 0; i < 2; ++i) {
 		for (j = 0; j < 3; ++j) {
 			cfqq = cfq_rb_first(&cfqg->service_trees[i][j]);
@@ -2395,16 +2493,6 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
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
@@ -3299,6 +3387,9 @@ static void *cfq_init_queue(struct request_queue *q)
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbZKCXqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbZKCXqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZKCXox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbZKCXov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 08/20] blkio: Add support for dynamic creation of cfq_groups
Date: Tue,  3 Nov 2009 18:43:45 -0500
Message-Id: <1257291837-6246-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o So far we assumed there is one cfq_group in the system (root group). This
  patch introduces the code to map requests to their cgroup and create more
  cfq_groups dynamically and keep track of these groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |  123 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 111 insertions(+), 12 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 8ec8a82..4481917 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -145,6 +145,7 @@ struct cfq_group {
 	struct cfq_sched_data sched_data;
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	struct blkio_group blkg;
+	struct hlist_node cfqd_node;
 #endif
 };
 
@@ -212,6 +213,9 @@ struct cfq_data {
 	struct cfq_queue oom_cfqq;
 
 	unsigned long last_end_sync_rq;
+
+	/* List of cfq groups being managed on this device*/
+	struct hlist_head cfqg_list;
 };
 
 enum cfqq_state_flags {
@@ -286,13 +290,14 @@ static inline struct cfq_group *cfqg_of(struct cfq_entity *cfqe)
 }
 
 static inline void
-init_cfqe_service_tree(struct cfq_data *cfqd, struct cfq_entity *cfqe)
+init_cfqe_service_tree(struct cfq_entity *cfqe, struct cfq_entity *p_cfqe)
 {
+	struct cfq_group *p_cfqg = cfqg_of(p_cfqe);
 	unsigned short idx = cfqe->ioprio_class - 1;
 
 	BUG_ON(idx >= IO_IOPRIO_CLASSES);
 
-	cfqe->st = &cfqd->root_group.sched_data.service_tree[idx];
+	cfqe->st = &p_cfqg->sched_data.service_tree[idx];
 }
 
 static inline s64
@@ -372,16 +377,93 @@ cfq_weight_slice(struct cfq_data *cfqd, int sync, unsigned int weight)
 	return cfq_delta(base_slice, weight, BLKIO_WEIGHT_DEFAULT);
 }
 
+static inline void
+cfq_init_cfqe_parent(struct cfq_entity *cfqe, struct cfq_entity *p_cfqe)
+{
+	cfqe->parent = p_cfqe;
+	init_cfqe_service_tree(cfqe, p_cfqe);
+}
+
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 /* check for entity->parent so that loop is not executed for root entity. */
 #define for_each_entity(entity)	\
 	for (; entity && entity->parent; entity = entity->parent)
 
+static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
+{
+	if (blkg)
+		return container_of(blkg, struct cfq_group, blkg);
+	return NULL;
+}
+
 static inline struct cfq_sched_data *
 cfq_entity_sched_data(struct cfq_entity *cfqe)
 {
 	return &cfqg_of(parent_entity(cfqe))->sched_data;
 }
+
+static void cfq_init_cfqg(struct cfq_group *cfqg, struct blkio_cgroup *blkcg)
+{
+	struct cfq_entity *cfqe = &cfqg->entity;
+
+	cfqe->weight = blkcg->weight;
+	cfqe->ioprio_class = blkcg->ioprio_class;
+	cfqe->ioprio_class_changed = 1;
+	cfqe->my_sd = &cfqg->sched_data;
+}
+
+static struct cfq_group *
+cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
+{
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
+	struct cfq_group *cfqg = NULL;
+	void *key = cfqd;
+
+	/* Do we need to take this reference */
+	if (!css_tryget(&blkcg->css))
+		return NULL;;
+
+	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+	if (cfqg || !create)
+		goto done;
+
+	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC |  __GFP_ZERO,
+					cfqd->queue->node);
+	if (!cfqg)
+		goto done;
+
+	cfq_init_cfqg(cfqg, blkcg);
+	cfq_init_cfqe_parent(&cfqg->entity, &cfqd->root_group.entity);
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
+ * create the cfq group if it does not exist.
+ * Should be called under request queue lock.
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
 #else /* CONFIG_CFQ_GROUP_IOSCHED */
 #define for_each_entity(entity)	\
 	for (; entity != NULL; entity = NULL)
@@ -397,6 +479,11 @@ cfq_entity_sched_data(struct cfq_entity *cfqe)
 
 	return &cfqd->root_group.sched_data;
 }
+
+static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+{
+	return &cfqd->root_group;
+}
 #endif /* CONFIG_CFQ_GROUP_IOSCHED */
 
 static inline int rq_in_driver(struct cfq_data *cfqd)
@@ -624,14 +711,11 @@ place_cfqe(struct cfq_service_tree *st, struct cfq_entity *cfqe, int add_front)
 static inline void cfqe_update_ioprio_class(struct cfq_entity *cfqe)
 {
 	if (unlikely(cfqe->ioprio_class_changed)) {
-		struct cfq_queue *cfqq = cfqq_of(cfqe);
-		struct cfq_data *cfqd = cfqq->cfqd;
-
 		/*
 		 * Re-initialize the service tree pointer as ioprio class
 		 * change will lead to service tree change.
 		 */
-		init_cfqe_service_tree(cfqd, cfqe);
+		init_cfqe_service_tree(cfqe, parent_entity(cfqe));
 		cfqe->ioprio_class_changed = 0;
 		cfqe->vdisktime = 0;
 	}
@@ -1229,16 +1313,19 @@ static struct cfq_entity *cfq_get_next_entity(struct cfq_sched_data *sd)
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_entity *cfqe = NULL;
+	struct cfq_sched_data *sd;
 
 	if (!cfqd->rq_queued)
 		return NULL;
 
-	cfqe = cfq_get_next_entity(&cfqd->root_group.sched_data);
+	sd = &cfqd->root_group.sched_data;
+	for (; sd ; sd = cfqe->my_sd) {
+		cfqe = cfq_get_next_entity(sd);
+		if (!cfqe)
+			return NULL;
+	}
 
-	if (cfqe)
-		return cfqq_of(cfqe);
-	else
-		return NULL;
+	return cfqq_of(cfqe);
 }
 
 /*
@@ -2012,8 +2099,17 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfq_mark_cfqq_sync(cfqq);
 	}
 	cfqq->pid = pid;
-	cfqq->entity.parent = &cfqd->root_group.entity;
+}
+
+static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
+{
 	cfqq->entity.my_sd = NULL;
+
+	/* Currently, all async queues are mapped to root group */
+	if (!cfq_cfqq_sync(cfqq))
+		cfqg = &cfqq->cfqd->root_group;
+
+	cfq_init_cfqe_parent(&cfqq->entity, &cfqg->entity);
 }
 
 static struct cfq_queue *
@@ -2022,8 +2118,10 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 {
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
 	struct cfq_io_context *cic;
+	struct cfq_group *cfqg;
 
 retry:
+	cfqg = cfq_get_cfqg(cfqd, 1);
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
@@ -2054,6 +2152,7 @@ retry:
 		if (cfqq) {
 			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
 			cfq_init_prio_data(cfqq, ioc);
+			cfq_link_cfqq_cfqg(cfqq, cfqg);
 			cfq_log_cfqq(cfqd, cfqq, "alloced");
 		} else
 			cfqq = &cfqd->oom_cfqq;
-- 
1.6.2.5


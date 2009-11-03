Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZKCXqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZKCXqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZKCXoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbZKCXoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 07/20] blkio: Provide capablity to enqueue/dequeue group entities
Date: Tue,  3 Nov 2009 18:43:44 -0500
Message-Id: <1257291837-6246-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o This patch embeds cfq_entity object in cfq_group and provides helper routines
  so that group entities can be scheduled.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |  110 +++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 93 insertions(+), 17 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index bc99163..8ec8a82 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -79,6 +79,7 @@ struct cfq_service_tree {
 #define CFQ_RB_ROOT	(struct cfq_service_tree) { RB_ROOT, NULL, 0, NULL}
 
 struct cfq_sched_data {
+	unsigned int nr_active;
 	struct cfq_service_tree service_tree[IO_IOPRIO_CLASSES];
 };
 
@@ -89,6 +90,10 @@ struct cfq_entity {
 	struct cfq_service_tree *st;
 	unsigned short ioprio_class;
 	bool ioprio_class_changed;
+	struct cfq_entity *parent;
+	bool on_st;
+	/* Points to the sched_data of group entity. Null for cfqq */
+	struct cfq_sched_data *my_sd;
 };
 
 /*
@@ -136,6 +141,7 @@ struct cfq_queue {
 
 /* Per cgroup grouping structure */
 struct cfq_group {
+	struct cfq_entity entity;
 	struct cfq_sched_data sched_data;
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	struct blkio_group blkg;
@@ -260,9 +266,23 @@ static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
 static void cfq_put_queue(struct cfq_queue *cfqq);
 static struct cfq_entity *__cfq_get_next_entity(struct cfq_service_tree *st);
 
+static inline struct cfq_entity *parent_entity(struct cfq_entity *cfqe)
+{
+	return cfqe->parent;
+}
+
 static inline struct cfq_queue *cfqq_of(struct cfq_entity *cfqe)
 {
-	return container_of(cfqe, struct cfq_queue, entity);
+	if (!cfqe->my_sd)
+		return container_of(cfqe, struct cfq_queue, entity);
+	return NULL;
+}
+
+static inline struct cfq_group *cfqg_of(struct cfq_entity *cfqe)
+{
+	if (cfqe->my_sd)
+		return container_of(cfqe, struct cfq_group, entity);
+	return NULL;
 }
 
 static inline void
@@ -352,6 +372,33 @@ cfq_weight_slice(struct cfq_data *cfqd, int sync, unsigned int weight)
 	return cfq_delta(base_slice, weight, BLKIO_WEIGHT_DEFAULT);
 }
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+/* check for entity->parent so that loop is not executed for root entity. */
+#define for_each_entity(entity)	\
+	for (; entity && entity->parent; entity = entity->parent)
+
+static inline struct cfq_sched_data *
+cfq_entity_sched_data(struct cfq_entity *cfqe)
+{
+	return &cfqg_of(parent_entity(cfqe))->sched_data;
+}
+#else /* CONFIG_CFQ_GROUP_IOSCHED */
+#define for_each_entity(entity)	\
+	for (; entity != NULL; entity = NULL)
+static inline struct cfq_data *cfqd_of(struct cfq_entity *cfqe)
+{
+	return cfqq_of(cfqe)->cfqd;
+}
+
+static inline struct cfq_sched_data *
+cfq_entity_sched_data(struct cfq_entity *cfqe)
+{
+	struct cfq_data *cfqd = cfqd_of(cfqe);
+
+	return &cfqd->root_group.sched_data;
+}
+#endif /* CONFIG_CFQ_GROUP_IOSCHED */
+
 static inline int rq_in_driver(struct cfq_data *cfqd)
 {
 	return cfqd->rq_in_driver[0] + cfqd->rq_in_driver[1];
@@ -606,16 +653,28 @@ static void __dequeue_cfqe(struct cfq_service_tree *st, struct cfq_entity *cfqe)
 static void dequeue_cfqe(struct cfq_entity *cfqe)
 {
 	struct cfq_service_tree *st = cfqe->st;
+	struct cfq_sched_data *sd = cfq_entity_sched_data(cfqe);
 
 	if (st->active == cfqe)
 		st->active = NULL;
 
 	__dequeue_cfqe(st, cfqe);
+	sd->nr_active--;
+	cfqe->on_st = 0;
 }
 
 static void dequeue_cfqq(struct cfq_queue *cfqq)
 {
-	dequeue_cfqe(&cfqq->entity);
+	struct cfq_entity *cfqe = &cfqq->entity;
+
+	for_each_entity(cfqe) {
+		struct cfq_sched_data *sd = cfq_entity_sched_data(cfqe);
+
+		dequeue_cfqe(cfqe);
+		/* Do not dequeue parent if it has other entities under it */
+		if (sd->nr_active)
+			break;
+	}
 }
 
 static void __enqueue_cfqe(struct cfq_service_tree *st, struct cfq_entity *cfqe,
@@ -653,6 +712,10 @@ static void __enqueue_cfqe(struct cfq_service_tree *st, struct cfq_entity *cfqe,
 
 static void enqueue_cfqe(struct cfq_entity *cfqe)
 {
+	struct cfq_sched_data *sd = cfq_entity_sched_data(cfqe);
+
+	cfqe->on_st = 1;
+	sd->nr_active++;
 	cfqe_update_ioprio_class(cfqe);
 	place_cfqe(cfqe->st, cfqe, 0);
 	__enqueue_cfqe(cfqe->st, cfqe, 0);
@@ -660,7 +723,13 @@ static void enqueue_cfqe(struct cfq_entity *cfqe)
 
 static void enqueue_cfqq(struct cfq_queue *cfqq)
 {
-	enqueue_cfqe(&cfqq->entity);
+	struct cfq_entity *cfqe = &cfqq->entity;
+
+	for_each_entity(cfqe) {
+		if (cfqe->on_st)
+			break;
+		enqueue_cfqe(cfqe);
+	}
 }
 
 /* Requeue a cfqq which is already on the service tree */
@@ -687,14 +756,22 @@ static void requeue_cfqq(struct cfq_queue *cfqq, int add_front)
 
 static void cfqe_served(struct cfq_entity *cfqe, unsigned long served)
 {
-	/*
-	 * Can't update entity disk time while it is on sorted rb-tree
-	 * as vdisktime is used as key.
-	 */
-	__dequeue_cfqe(cfqe->st, cfqe);
-	cfqe->vdisktime += cfq_delta_fair(served, cfqe);
-	update_min_vdisktime(cfqe->st);
-	__enqueue_cfqe(cfqe->st, cfqe, 0);
+	for_each_entity(cfqe) {
+		/*
+		 * Can't update entity disk time while it is on sorted rb-tree
+		 * as vdisktime is used as key.
+		 */
+		__dequeue_cfqe(cfqe->st, cfqe);
+		cfqe->vdisktime += cfq_delta_fair(served, cfqe);
+		update_min_vdisktime(cfqe->st);
+		__enqueue_cfqe(cfqe->st, cfqe, 0);
+
+		/* If entity prio class has changed, take that into account */
+		if (unlikely(cfqe->ioprio_class_changed)) {
+			dequeue_cfqe(cfqe);
+			enqueue_cfqe(cfqe);
+		}
+	}
 }
 
 static void cfqq_served(struct cfq_queue *cfqq, unsigned long served)
@@ -708,12 +785,6 @@ static void cfqq_served(struct cfq_queue *cfqq, unsigned long served)
 	 */
 	served = cfq_prio_to_slice(cfqq->cfqd, cfqq);
 	cfqe_served(&cfqq->entity, served);
-
-	/* If cfqq prio class has changed, take that into account */
-	if (unlikely(cfqq->entity.ioprio_class_changed)) {
-		dequeue_cfqq(cfqq);
-		enqueue_cfqq(cfqq);
-	}
 }
 
 /*
@@ -1941,6 +2012,8 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfq_mark_cfqq_sync(cfqq);
 	}
 	cfqq->pid = pid;
+	cfqq->entity.parent = &cfqd->root_group.entity;
+	cfqq->entity.my_sd = NULL;
 }
 
 static struct cfq_queue *
@@ -2707,6 +2780,9 @@ static void cfq_init_root_group(struct cfq_data *cfqd)
 	struct cfq_group *cfqg = &cfqd->root_group;
 	int i;
 
+	cfqg->entity.parent = NULL;
+	cfqg->entity.my_sd = &cfqg->sched_data;
+
 	for (i = 0; i < IO_IOPRIO_CLASSES; i++)
 		cfqg->sched_data.service_tree[i] = CFQ_RB_ROOT;
 }
-- 
1.6.2.5


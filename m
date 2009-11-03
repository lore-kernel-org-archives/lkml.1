Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZKCXqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZKCXqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZKCXqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:46:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbZKCXov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 10/20] blkio: Implement cfq group deletion and reference counting support
Date: Tue,  3 Nov 2009 18:43:47 -0500
Message-Id: <1257291837-6246-11-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o With dynamic cfq_groups, comes the need of making sure cfq_groups can be
  freed when either elevator exits or one decides to delete the cgroup.

o This patch takes care of elevator exit and cgroup deletion paths and also
  implements cfq_group reference counting so that a cgroup can be removed
  even if there are backlogged requests in the associated cfq_groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Nauman Rafique <nauman@google.com>
---
 block/blk-cgroup.c  |   66 +++++++++++++++++++++++-
 block/blk-cgroup.h  |    2 +
 block/cfq-iosched.c |  143 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 208 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 0d52a2c..a62b8a3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -16,6 +16,7 @@
 extern void cfq_update_blkio_group_weight(struct blkio_group *, unsigned int);
 extern void cfq_update_blkio_group_ioprio_class(struct blkio_group *,
 		unsigned short);
+extern void cfq_delink_blkio_group(void *, struct blkio_group *);
 
 struct blkio_cgroup blkio_root_cgroup = {
 	.weight = BLKIO_WEIGHT_DEFAULT,
@@ -35,14 +36,43 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 
 	spin_lock_irqsave(&blkcg->lock, flags);
 	rcu_assign_pointer(blkg->key, key);
+	blkg->blkcg_id = css_id(&blkcg->css);
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
 	spin_unlock_irqrestore(&blkcg->lock, flags);
 }
 
+static void __blkiocg_del_blkio_group(struct blkio_group *blkg)
+{
+	hlist_del_init_rcu(&blkg->blkcg_node);
+	blkg->blkcg_id = 0;
+}
+
+/*
+ * returns 0 if blkio_group was still on cgroup list. Otherwise returns 1
+ * indicating that blk_group was unhashed by the time we got to it.
+ */
 int blkiocg_del_blkio_group(struct blkio_group *blkg)
 {
-	/* Implemented later */
-	return 0;
+	struct blkio_cgroup *blkcg;
+	unsigned long flags;
+	struct cgroup_subsys_state *css;
+	int ret = 1;
+
+	rcu_read_lock();
+	css = css_lookup(&blkio_subsys, blkg->blkcg_id);
+	if (!css)
+		goto out;
+
+	blkcg = container_of(css, struct blkio_cgroup, css);
+	spin_lock_irqsave(&blkcg->lock, flags);
+	if (!hlist_unhashed(&blkg->blkcg_node)) {
+		__blkiocg_del_blkio_group(blkg);
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&blkcg->lock, flags);
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 /* called under rcu_read_lock(). */
@@ -135,8 +165,40 @@ static int blkiocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 {
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
+	unsigned long flags;
+	struct blkio_group *blkg;
+	void *key;
 
+	rcu_read_lock();
+remove_entry:
+	spin_lock_irqsave(&blkcg->lock, flags);
+
+	if (hlist_empty(&blkcg->blkg_list)) {
+		spin_unlock_irqrestore(&blkcg->lock, flags);
+		goto done;
+	}
+
+	blkg = hlist_entry(blkcg->blkg_list.first, struct blkio_group,
+				blkcg_node);
+	key = rcu_dereference(blkg->key);
+	__blkiocg_del_blkio_group(blkg);
+
+	spin_unlock_irqrestore(&blkcg->lock, flags);
+
+	/*
+	 * This blkio_group is being delinked as associated cgroup is going
+	 * away. Let all the IO controlling policies know about this event.
+	 *
+	 * Currently this is static call to one io controlling policy. Once
+	 * we have more policies in place, we need some dynamic registration
+	 * of callback function.
+	 */
+	cfq_delink_blkio_group(key, blkg);
+	goto remove_entry;
+done:
 	free_css_id(&blkio_subsys, &blkcg->css);
+	rcu_read_unlock();
+
 	kfree(blkcg);
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 49ca84b..2bf736b 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -25,12 +25,14 @@ struct blkio_group {
 	/* An rcu protected unique identifier for the group */
 	void *key;
 	struct hlist_node blkcg_node;
+	unsigned short blkcg_id;
 };
 
 #define BLKIO_WEIGHT_MIN	100
 #define BLKIO_WEIGHT_MAX	1000
 #define BLKIO_WEIGHT_DEFAULT	500
 
+extern struct blkio_cgroup blkio_root_cgroup;
 struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 				struct blkio_group *blkg, void *key);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3c0fa1b..b9a052b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -146,6 +146,7 @@ struct cfq_group {
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	struct blkio_group blkg;
 	struct hlist_node cfqd_node;
+	atomic_t ref;
 #endif
 };
 
@@ -295,8 +296,18 @@ init_cfqe_service_tree(struct cfq_entity *cfqe, struct cfq_entity *p_cfqe)
 	struct cfq_group *p_cfqg = cfqg_of(p_cfqe);
 	unsigned short idx = cfqe->ioprio_class - 1;
 
-	BUG_ON(idx >= IO_IOPRIO_CLASSES);
+	/*
+	 * ioprio class of the entity has not been initialized yet, don't
+	 * init service tree right now. This can happen in the case of
+	 * oom_cfqq which will inherit its class and prio once first request
+	 * gets queued in and at that point of time prio update will make
+	 * sure that service tree gets initialized before queue gets onto
+	 * tree.
+	 */
+	if (cfqe->ioprio_class == IOPRIO_CLASS_NONE)
+		return;
 
+	BUG_ON(idx >= IO_IOPRIO_CLASSES);
 	cfqe->st = &p_cfqg->sched_data.service_tree[idx];
 }
 
@@ -402,6 +413,16 @@ cfq_entity_sched_data(struct cfq_entity *cfqe)
 	return &cfqg_of(parent_entity(cfqe))->sched_data;
 }
 
+static inline struct cfq_group *cfqq_to_cfqg(struct cfq_queue *cfqq)
+{
+	return cfqg_of(parent_entity(&cfqq->entity));
+}
+
+static inline void cfq_get_cfqg_ref(struct cfq_group *cfqg)
+{
+	atomic_inc(&cfqg->ref);
+}
+
 static void cfq_init_cfqg(struct cfq_group *cfqg, struct blkio_cgroup *blkcg)
 {
 	struct cfq_entity *cfqe = &cfqg->entity;
@@ -435,6 +456,14 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	cfq_init_cfqg(cfqg, blkcg);
 	cfq_init_cfqe_parent(&cfqg->entity, &cfqd->root_group.entity);
 
+	/*
+	 * Take the initial reference that will be released on destroy
+	 * This can be thought of a joint reference by cgroup and
+	 * elevator which will be dropped by either elevator exit
+	 * or cgroup deletion path depending on who is exiting first.
+	 */
+	cfq_get_cfqg_ref(cfqg);
+
 	/* Add group onto cgroup list */
 	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd);
 
@@ -482,9 +511,87 @@ void cfq_update_blkio_group_ioprio_class(struct blkio_group *blkg,
 	smp_wmb();
 	cfqg->entity.ioprio_class_changed = 1;
 }
+
+static void cfq_put_cfqg(struct cfq_group *cfqg)
+{
+	struct cfq_service_tree *st;
+	int i;
+
+	BUG_ON(atomic_read(&cfqg->ref) <= 0);
+	if (!atomic_dec_and_test(&cfqg->ref))
+		return;
+
+	for (i = 0; i < IO_IOPRIO_CLASSES; i++) {
+		st = cfqg->sched_data.service_tree + i;
+		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
+		BUG_ON(st->active != NULL);
+	}
+
+	kfree(cfqg);
+}
+
+static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
+{
+	/* Something wrong if we are trying to remove same group twice */
+	BUG_ON(hlist_unhashed(&cfqg->cfqd_node));
+
+	hlist_del_init(&cfqg->cfqd_node);
+
+	/*
+	 * Put the reference taken at the time of creation so that when all
+	 * queues are gone, group can be destroyed.
+	 */
+	cfq_put_cfqg(cfqg);
+}
+
+static void cfq_release_cfq_groups(struct cfq_data *cfqd)
+{
+	struct hlist_node *pos, *n;
+	struct cfq_group *cfqg;
+
+	hlist_for_each_entry_safe(cfqg, pos, n, &cfqd->cfqg_list, cfqd_node) {
+		/*
+		 * If cgroup removal path got to blk_group first and removed
+		 * it from cgroup list, then it will take care of destroying
+		 * cfqg also.
+		 */
+		if (!blkiocg_del_blkio_group(&cfqg->blkg))
+			cfq_destroy_cfqg(cfqd, cfqg);
+	}
+}
+
+/*
+ * Blk cgroup controller notification saying that blkio_group object is being
+ * delinked as associated cgroup object is going away. That also means that
+ * no new IO will come in this group. So get rid of this group as soon as
+ * any pending IO in the group is finished.
+ *
+ * This function is called under rcu_read_lock(). key is the rcu protected
+ * pointer. That means "key" is a valid cfq_data pointer as long as we are rcu
+ * read lock.
+ *
+ * "key" was fetched from blkio_group under blkio_cgroup->lock. That means
+ * it should not be NULL as even if elevator was exiting, cgroup deltion
+ * path got to it first.
+ */
+void cfq_delink_blkio_group(void *key, struct blkio_group *blkg)
+{
+	unsigned long  flags;
+	struct cfq_data *cfqd = key;
+
+	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+	cfq_destroy_cfqg(cfqd, cfqg_of_blkg(blkg));
+	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
+}
+
 #else /* CONFIG_CFQ_GROUP_IOSCHED */
 #define for_each_entity(entity)	\
 	for (; entity != NULL; entity = NULL)
+
+static void cfq_release_cfq_groups(struct cfq_data *cfqd) {}
+static inline void cfq_get_cfqg_ref(struct cfq_group *cfqg) {}
+static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
+
 static inline struct cfq_data *cfqd_of(struct cfq_entity *cfqe)
 {
 	return cfqq_of(cfqe)->cfqd;
@@ -498,6 +605,11 @@ cfq_entity_sched_data(struct cfq_entity *cfqe)
 	return &cfqd->root_group.sched_data;
 }
 
+static inline struct cfq_group *cfqq_to_cfqg(struct cfq_queue *cfqq)
+{
+	return &cfqq->cfqd->root_group;
+}
+
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 {
 	return &cfqd->root_group;
@@ -1818,11 +1930,13 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
  * task holds one reference to the queue, dropped when task exits. each rq
  * in-flight on this queue also holds a reference, dropped when rq is freed.
  *
+ * Each cfq queue took a reference on the parent group. Drop it now.
  * queue lock must be held here.
  */
 static void cfq_put_queue(struct cfq_queue *cfqq)
 {
 	struct cfq_data *cfqd = cfqq->cfqd;
+	struct cfq_group *cfqg;
 
 	BUG_ON(atomic_read(&cfqq->ref) <= 0);
 
@@ -1832,6 +1946,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	cfq_log_cfqq(cfqd, cfqq, "put_queue");
 	BUG_ON(rb_first(&cfqq->sort_list));
 	BUG_ON(cfqq->allocated[READ] + cfqq->allocated[WRITE]);
+	cfqg = cfqq_to_cfqg(cfqq);
 
 	if (unlikely(cfqd->active_queue == cfqq)) {
 		__cfq_slice_expired(cfqd, cfqq);
@@ -1841,6 +1956,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 
 	kmem_cache_free(cfq_pool, cfqq);
+	cfq_put_cfqg(cfqg);
 }
 
 /*
@@ -2128,6 +2244,9 @@ static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 		cfqg = &cfqq->cfqd->root_group;
 
 	cfq_init_cfqe_parent(&cfqq->entity, &cfqg->entity);
+
+	/* cfqq reference on cfqg */
+	cfq_get_cfqg_ref(cfqg);
 }
 
 static struct cfq_queue *
@@ -2902,6 +3021,23 @@ static void cfq_init_root_group(struct cfq_data *cfqd)
 
 	for (i = 0; i < IO_IOPRIO_CLASSES; i++)
 		cfqg->sched_data.service_tree[i] = CFQ_RB_ROOT;
+
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	atomic_set(&cfqg->ref, 0);
+	/*
+	 * Take a reference to root group which we never drop. This is just
+	 * to make sure that cfq_put_cfqg() does not try to kfree root group
+	 */
+	cfq_get_cfqg_ref(cfqg);
+	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd);
+#endif
+}
+
+static void cfq_exit_root_group(struct cfq_data *cfqd)
+{
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	blkiocg_del_blkio_group(&cfqd->root_group.blkg);
+#endif
 }
 
 static void cfq_exit_queue(struct elevator_queue *e)
@@ -2926,10 +3062,14 @@ static void cfq_exit_queue(struct elevator_queue *e)
 
 	cfq_put_async_queues(cfqd);
 
+	cfq_release_cfq_groups(cfqd);
+	cfq_exit_root_group(cfqd);
 	spin_unlock_irq(q->queue_lock);
 
 	cfq_shutdown_timer_wq(cfqd);
 
+	/* Wait for cfqg->blkg->key accessors to exit their grace periods. */
+	synchronize_rcu();
 	kfree(cfqd);
 }
 
@@ -2959,6 +3099,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	 */
 	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
 	atomic_inc(&cfqd->oom_cfqq.ref);
+	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_group);
 
 	INIT_LIST_HEAD(&cfqd->cic_list);
 
-- 
1.6.2.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZKLXfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZKLXfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZKLXfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:35:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbZKLXe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:34:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 10/16] blkio: Take care of cgroup deletion and cfq group reference counting
Date: Thu, 12 Nov 2009 18:32:30 -0500
Message-Id: <1258068756-10766-11-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o One can choose to change elevator or delete a cgroup. Implement group
  reference counting so that both elevator exit and cgroup deletion can
  take place gracefully.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Nauman Rafique <nauman@google.com>
---
 block/blk-cgroup.c  |   66 +++++++++++++++++++++++++++++++-
 block/blk-cgroup.h  |    1 +
 block/cfq-iosched.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 169 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4f6afd7..0426ab6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -13,6 +13,8 @@
 #include <linux/ioprio.h>
 #include "blk-cgroup.h"
 
+extern void cfq_unlink_blkio_group(void *, struct blkio_group *);
+
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 
 struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
@@ -28,14 +30,43 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 
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
@@ -97,8 +128,39 @@ static int blkiocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
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
+	 * This blkio_group is being unlinked as associated cgroup is going
+	 * away. Let all the IO controlling policies know about this event.
+	 *
+	 * Currently this is static call to one io controlling policy. Once
+	 * we have more policies in place, we need some dynamic registration
+	 * of callback function.
+	 */
+	cfq_unlink_blkio_group(key, blkg);
+	goto remove_entry;
+done:
 	free_css_id(&blkio_subsys, &blkcg->css);
+	rcu_read_unlock();
 	kfree(blkcg);
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ba5703f..cd50a2f 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -26,6 +26,7 @@ struct blkio_group {
 	/* An rcu protected unique identifier for the group */
 	void *key;
 	struct hlist_node blkcg_node;
+	unsigned short blkcg_id;
 };
 
 #define BLKIO_WEIGHT_MIN	100
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 788c1ff..de21882 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -190,6 +190,7 @@ struct cfq_group {
 	struct blkio_group blkg;
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	struct hlist_node cfqd_node;
+	atomic_t ref;
 #endif
 };
 
@@ -886,6 +887,14 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	cfqg->service_tree_idle = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
 
+	/*
+	 * Take the initial reference that will be released on destroy
+	 * This can be thought of a joint reference by cgroup and
+	 * elevator which will be dropped by either elevator exit
+	 * or cgroup deletion path depending on who is exiting first.
+	 */
+	atomic_set(&cfqg->ref, 1);
+
 	/* Add group onto cgroup list */
 	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd);
 
@@ -922,7 +931,86 @@ static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 		cfqg = &cfqq->cfqd->root_group;
 
 	cfqq->cfqg = cfqg;
+	/* cfqq reference on cfqg */
+	atomic_inc(&cfqq->cfqg->ref);
+}
+
+static void cfq_put_cfqg(struct cfq_group *cfqg)
+{
+	struct cfq_rb_root *st;
+	int i, j;
+
+	BUG_ON(atomic_read(&cfqg->ref) <= 0);
+	if (!atomic_dec_and_test(&cfqg->ref))
+		return;
+
+	for (i = 0; i < 2; ++i)
+		for (j = 0; j < 3; ++j) {
+			st = &cfqg->service_trees[i][j];
+			BUG_ON(!RB_EMPTY_ROOT(&st->rb));
+			BUG_ON(st->active != NULL);
+		}
+
+	BUG_ON(!RB_EMPTY_ROOT(&cfqg->service_tree_idle.rb));
+	BUG_ON(cfqg->service_tree_idle.active != NULL);
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
 }
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
+void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
+{
+	unsigned long  flags;
+	struct cfq_data *cfqd = key;
+
+	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+	cfq_destroy_cfqg(cfqd, cfqg_of_blkg(blkg));
+	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
+}
+
 #else /* GROUP_IOSCHED */
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 {
@@ -933,6 +1021,9 @@ cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
 	cfqq->cfqg = cfqg;
 }
 
+static void cfq_release_cfq_groups(struct cfq_data *cfqd) {}
+static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
+
 #endif /* GROUP_IOSCHED */
 
 /*
@@ -2161,11 +2252,13 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
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
 
@@ -2175,6 +2268,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	cfq_log_cfqq(cfqd, cfqq, "put_queue");
 	BUG_ON(rb_first(&cfqq->sort_list));
 	BUG_ON(cfqq->allocated[READ] + cfqq->allocated[WRITE]);
+	cfqg = cfqq->cfqg;
 
 	if (unlikely(cfqd->active_queue == cfqq)) {
 		__cfq_slice_expired(cfqd, cfqq, 0);
@@ -2184,6 +2278,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 
 	kmem_cache_free(cfq_pool, cfqq);
+	cfq_put_cfqg(cfqg);
 }
 
 /*
@@ -3337,11 +3432,15 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	}
 
 	cfq_put_async_queues(cfqd);
+	cfq_release_cfq_groups(cfqd);
+	blkiocg_del_blkio_group(&cfqd->root_group.blkg);
 
 	spin_unlock_irq(q->queue_lock);
 
 	cfq_shutdown_timer_wq(cfqd);
 
+	/* Wait for cfqg->blkg->key accessors to exit their grace periods. */
+	synchronize_rcu();
 	kfree(cfqd);
 }
 
@@ -3371,6 +3470,11 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
+	/*
+	 * Take a reference to root group which we never drop. This is just
+	 * to make sure that cfq_put_cfqg() does not try to kfree root group
+	 */
+	atomic_set(&cfqg->ref, 1);
 	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd);
 #endif
 	/*
-- 
1.6.2.5


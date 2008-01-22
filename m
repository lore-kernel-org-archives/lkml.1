Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbYAVJ4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbYAVJ4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbYAVJyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:54:39 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8786 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbYAVJy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:54:28 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: knikanth@novell.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/6] block: cfq: make the io contect sharing lockless
Date: Tue, 22 Jan 2008 10:49:19 +0100
Message-Id: <1200995361-24001-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.rc2.84.gf85fd
In-Reply-To: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The io context sharing introduced a per-ioc spinlock, that would protect
the cfq io context lookup. That is a regression from the original, since
we never needed any locking there because the ioc/cic were process private.

The cic lookup is changed from an rbtree construct to a radix tree, which
we can then use RCU to make the reader side lockless. That is the performance
critical path, modifying the radix tree is only done on process creation
(when that process first does IO, actually) and on process exit (if that
process has done IO).

As it so happens, radix trees are also much faster for this type of
lookup where the key is a pointer. It's a very sparse tree.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c       |  267 +++++++++++++++++++++++++--------------------
 block/ll_rw_blk.c         |   41 +++++---
 include/linux/iocontext.h |    6 +-
 3 files changed, 177 insertions(+), 137 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index dba52b6..8830893 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -200,7 +200,7 @@ CFQ_CFQQ_FNS(sync);
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, int,
 				       struct io_context *, gfp_t);
-static struct cfq_io_context *cfq_cic_rb_lookup(struct cfq_data *,
+static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
 						struct io_context *);
 
 static inline struct cfq_queue *cic_to_cfqq(struct cfq_io_context *cic,
@@ -609,7 +609,7 @@ cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
-	cic = cfq_cic_rb_lookup(cfqd, tsk->io_context);
+	cic = cfq_cic_lookup(cfqd, tsk->io_context);
 	if (!cic)
 		return NULL;
 
@@ -721,7 +721,7 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	 * Lookup the cfqq that this bio will be queued with. Allow
 	 * merge only if rq is queued there.
 	 */
-	cic = cfq_cic_rb_lookup(cfqd, current->io_context);
+	cic = cfq_cic_lookup(cfqd, current->io_context);
 	if (!cic)
 		return 0;
 
@@ -1170,29 +1170,74 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	kmem_cache_free(cfq_pool, cfqq);
 }
 
-static void cfq_free_io_context(struct io_context *ioc)
+/*
+ * Call func for each cic attached to this ioc. Returns number of cic's seen.
+ */
+#define CIC_GANG_NR	16
+static unsigned int
+call_for_each_cic(struct io_context *ioc,
+		  void (*func)(struct io_context *, struct cfq_io_context *))
 {
-	struct cfq_io_context *__cic;
-	struct rb_node *n;
-	int freed = 0;
+	struct cfq_io_context *cics[CIC_GANG_NR];
+	unsigned long index = 0;
+	unsigned int called = 0;
+	int nr;
 
-	ioc->ioc_data = NULL;
+	rcu_read_lock();
 
-	spin_lock(&ioc->lock);
+	do {
+		int i;
 
-	while ((n = rb_first(&ioc->cic_root)) != NULL) {
-		__cic = rb_entry(n, struct cfq_io_context, rb_node);
-		rb_erase(&__cic->rb_node, &ioc->cic_root);
-		kmem_cache_free(cfq_ioc_pool, __cic);
-		freed++;
-	}
+		/*
+		 * Perhaps there's a better way - this just gang lookups from
+		 * 0 to the end, restarting after each CIC_GANG_NR from the
+		 * last key + 1.
+		 */
+		nr = radix_tree_gang_lookup(&ioc->radix_root, (void **) cics,
+						index, CIC_GANG_NR);
+		if (!nr)
+			break;
+
+		called += nr;
+		index = 1 + (unsigned long) cics[nr - 1]->key;
+
+		for (i = 0; i < nr; i++)
+			func(ioc, cics[i]);
+	} while (nr == CIC_GANG_NR);
+
+	rcu_read_unlock();
+
+	return called;
+}
+
+static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
+{
+	unsigned long flags;
+
+	BUG_ON(!cic->dead_key);
+
+	spin_lock_irqsave(&ioc->lock, flags);
+	radix_tree_delete(&ioc->radix_root, cic->dead_key);
+	spin_unlock_irqrestore(&ioc->lock, flags);
+
+	kmem_cache_free(cfq_ioc_pool, cic);
+}
+
+static void cfq_free_io_context(struct io_context *ioc)
+{
+	int freed;
+
+	/*
+	 * ioc->refcount is zero here, so no more cic's are allowed to be
+	 * linked into this ioc. So it should be ok to iterate over the known
+	 * list, we will see all cic's since no new ones are added.
+	 */
+	freed = call_for_each_cic(ioc, cic_free_func);
 
 	elv_ioc_count_mod(ioc_count, -freed);
 
 	if (ioc_gone && !elv_ioc_count_read(ioc_count))
 		complete(ioc_gone);
-
-	spin_unlock(&ioc->lock);
 }
 
 static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
@@ -1209,7 +1254,12 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 					 struct cfq_io_context *cic)
 {
 	list_del_init(&cic->queue_list);
+
+	/*
+	 * Make sure key == NULL is seen for dead queues
+	 */
 	smp_wmb();
+	cic->dead_key = (unsigned long) cic->key;
 	cic->key = NULL;
 
 	if (cic->cfqq[ASYNC]) {
@@ -1223,16 +1273,18 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 	}
 }
 
-static void cfq_exit_single_io_context(struct cfq_io_context *cic)
+static void cfq_exit_single_io_context(struct io_context *ioc,
+				       struct cfq_io_context *cic)
 {
 	struct cfq_data *cfqd = cic->key;
 
 	if (cfqd) {
 		struct request_queue *q = cfqd->queue;
+		unsigned long flags;
 
-		spin_lock_irq(q->queue_lock);
+		spin_lock_irqsave(q->queue_lock, flags);
 		__cfq_exit_single_io_context(cfqd, cic);
-		spin_unlock_irq(q->queue_lock);
+		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }
 
@@ -1242,24 +1294,8 @@ static void cfq_exit_single_io_context(struct cfq_io_context *cic)
  */
 static void cfq_exit_io_context(struct io_context *ioc)
 {
-	struct cfq_io_context *__cic;
-	struct rb_node *n;
-
-	ioc->ioc_data = NULL;
-
-	spin_lock(&ioc->lock);
-	/*
-	 * put the reference this task is holding to the various queues
-	 */
-	n = rb_first(&ioc->cic_root);
-	while (n != NULL) {
-		__cic = rb_entry(n, struct cfq_io_context, rb_node);
-
-		cfq_exit_single_io_context(__cic);
-		n = rb_next(n);
-	}
-
-	spin_unlock(&ioc->lock);
+	rcu_assign_pointer(ioc->ioc_data, NULL);
+	call_for_each_cic(ioc, cfq_exit_single_io_context);
 }
 
 static struct cfq_io_context *
@@ -1323,7 +1359,8 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 	cfq_clear_cfqq_prio_changed(cfqq);
 }
 
-static inline void changed_ioprio(struct cfq_io_context *cic)
+static inline void changed_ioprio(struct io_context *ioc,
+				  struct cfq_io_context *cic)
 {
 	struct cfq_data *cfqd = cic->key;
 	struct cfq_queue *cfqq;
@@ -1353,22 +1390,8 @@ static inline void changed_ioprio(struct cfq_io_context *cic)
 
 static void cfq_ioc_set_ioprio(struct io_context *ioc)
 {
-	struct cfq_io_context *cic;
-	struct rb_node *n;
-
-	spin_lock(&ioc->lock);
-
+	call_for_each_cic(ioc, changed_ioprio);
 	ioc->ioprio_changed = 0;
-
-	n = rb_first(&ioc->cic_root);
-	while (n != NULL) {
-		cic = rb_entry(n, struct cfq_io_context, rb_node);
-
-		changed_ioprio(cic);
-		n = rb_next(n);
-	}
-
-	spin_unlock(&ioc->lock);
 }
 
 static struct cfq_queue *
@@ -1379,7 +1402,7 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, int is_sync,
 	struct cfq_io_context *cic;
 
 retry:
-	cic = cfq_cic_rb_lookup(cfqd, ioc);
+	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
 
@@ -1480,28 +1503,42 @@ cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct io_context *ioc,
 	return cfqq;
 }
 
+static void cfq_cic_free(struct cfq_io_context *cic)
+{
+	kmem_cache_free(cfq_ioc_pool, cic);
+	elv_ioc_count_dec(ioc_count);
+
+	if (ioc_gone && !elv_ioc_count_read(ioc_count))
+		complete(ioc_gone);
+}
+
 /*
  * We drop cfq io contexts lazily, so we may find a dead one.
  */
 static void
-cfq_drop_dead_cic(struct io_context *ioc, struct cfq_io_context *cic)
+cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
+		  struct cfq_io_context *cic)
 {
+	unsigned long flags;
+
 	WARN_ON(!list_empty(&cic->queue_list));
 
+	spin_lock_irqsave(&ioc->lock, flags);
+
 	if (ioc->ioc_data == cic)
-		ioc->ioc_data = NULL;
+		rcu_assign_pointer(ioc->ioc_data, NULL);
 
-	rb_erase(&cic->rb_node, &ioc->cic_root);
-	kmem_cache_free(cfq_ioc_pool, cic);
-	elv_ioc_count_dec(ioc_count);
+	radix_tree_delete(&ioc->radix_root, (unsigned long) cfqd);
+	spin_unlock_irqrestore(&ioc->lock, flags);
+
+	cfq_cic_free(cic);
 }
 
 static struct cfq_io_context *
-cfq_cic_rb_lookup(struct cfq_data *cfqd, struct io_context *ioc)
+cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 {
-	struct rb_node *n;
 	struct cfq_io_context *cic;
-	void *k, *key = cfqd;
+	void *k;
 
 	if (unlikely(!ioc))
 		return NULL;
@@ -1509,79 +1546,65 @@ cfq_cic_rb_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 	/*
 	 * we maintain a last-hit cache, to avoid browsing over the tree
 	 */
-	cic = ioc->ioc_data;
+	cic = rcu_dereference(ioc->ioc_data);
 	if (cic && cic->key == cfqd)
 		return cic;
 
-	spin_lock(&ioc->lock);
-restart:
-	n = ioc->cic_root.rb_node;
-	while (n) {
-		cic = rb_entry(n, struct cfq_io_context, rb_node);
+	do {
+		rcu_read_lock();
+		cic = radix_tree_lookup(&ioc->radix_root, (unsigned long) cfqd);
+		rcu_read_unlock();
+		if (!cic)
+			break;
 		/* ->key must be copied to avoid race with cfq_exit_queue() */
 		k = cic->key;
 		if (unlikely(!k)) {
-			cfq_drop_dead_cic(ioc, cic);
-			goto restart;
+			cfq_drop_dead_cic(cfqd, ioc, cic);
+			continue;
 		}
 
-		if (key < k)
-			n = n->rb_left;
-		else if (key > k)
-			n = n->rb_right;
-		else {
-			ioc->ioc_data = cic;
-			spin_unlock(&ioc->lock);
-			return cic;
-		}
-	}
+		rcu_assign_pointer(ioc->ioc_data, cic);
+		break;
+	} while (1);
 
-	spin_unlock(&ioc->lock);
-	return NULL;
+	return cic;
 }
 
-static inline void
+/*
+ * Add cic into ioc, using cfqd as the search key. This enables us to lookup
+ * the process specific cfq io context when entered from the block layer.
+ * Also adds the cic to a per-cfqd list, used when this queue is removed.
+ */
+static inline int
 cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
-	     struct cfq_io_context *cic)
+	     struct cfq_io_context *cic, gfp_t gfp_mask)
 {
-	struct rb_node **p;
-	struct rb_node *parent;
-	struct cfq_io_context *__cic;
 	unsigned long flags;
-	void *k;
+	int ret;
 
-	spin_lock(&ioc->lock);
-	cic->ioc = ioc;
-	cic->key = cfqd;
+	ret = radix_tree_preload(gfp_mask);
+	if (!ret) {
+		cic->ioc = ioc;
+		cic->key = cfqd;
 
-restart:
-	parent = NULL;
-	p = &ioc->cic_root.rb_node;
-	while (*p) {
-		parent = *p;
-		__cic = rb_entry(parent, struct cfq_io_context, rb_node);
-		/* ->key must be copied to avoid race with cfq_exit_queue() */
-		k = __cic->key;
-		if (unlikely(!k)) {
-			cfq_drop_dead_cic(ioc, __cic);
-			goto restart;
-		}
+		spin_lock_irqsave(&ioc->lock, flags);
+		ret = radix_tree_insert(&ioc->radix_root,
+						(unsigned long) cfqd, cic);
+		spin_unlock_irqrestore(&ioc->lock, flags);
 
-		if (cic->key < k)
-			p = &(*p)->rb_left;
-		else if (cic->key > k)
-			p = &(*p)->rb_right;
-		else
-			BUG();
+		radix_tree_preload_end();
+
+		if (!ret) {
+			spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+			list_add(&cic->queue_list, &cfqd->cic_list);
+			spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
+		}
 	}
 
-	rb_link_node(&cic->rb_node, parent, p);
-	rb_insert_color(&cic->rb_node, &ioc->cic_root);
+	if (ret)
+		printk(KERN_ERR "cfq: cic link failed!\n");
 
-	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
-	list_add(&cic->queue_list, &cfqd->cic_list);
-	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
-	spin_unlock(&ioc->lock);
+	return ret;
 }
 
 /*
@@ -1601,7 +1624,7 @@ cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 	if (!ioc)
 		return NULL;
 
-	cic = cfq_cic_rb_lookup(cfqd, ioc);
+	cic = cfq_cic_lookup(cfqd, ioc);
 	if (cic)
 		goto out;
 
@@ -1609,13 +1632,17 @@ cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 	if (cic == NULL)
 		goto err;
 
-	cfq_cic_link(cfqd, ioc, cic);
+	if (cfq_cic_link(cfqd, ioc, cic, gfp_mask))
+		goto err_free;
+
 out:
 	smp_read_barrier_depends();
 	if (unlikely(ioc->ioprio_changed))
 		cfq_ioc_set_ioprio(ioc);
 
 	return cic;
+err_free:
+	cfq_cic_free(cic);
 err:
 	put_io_context(ioc);
 	return NULL;
@@ -1909,7 +1936,7 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 	 * so just lookup a possibly existing queue, or return 'may queue'
 	 * if that fails
 	 */
-	cic = cfq_cic_rb_lookup(cfqd, tsk->io_context);
+	cic = cfq_cic_lookup(cfqd, tsk->io_context);
 	if (!cic)
 		return ELV_MQUEUE_MAY;
 
@@ -2174,7 +2201,7 @@ static int __init cfq_slab_setup(void)
 	if (!cfq_pool)
 		goto fail;
 
-	cfq_ioc_pool = KMEM_CACHE(cfq_io_context, 0);
+	cfq_ioc_pool = KMEM_CACHE(cfq_io_context, SLAB_DESTROY_BY_RCU);
 	if (!cfq_ioc_pool)
 		goto fail;
 
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index ca8b228..2a84a09 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3831,6 +3831,16 @@ int __init blk_dev_init(void)
 	return 0;
 }
 
+static void cfq_dtor(struct io_context *ioc)
+{
+	struct cfq_io_context *cic[1];
+	int r;
+
+	r = radix_tree_gang_lookup(&ioc->radix_root, (void **) cic, 0, 1);
+	if (r > 0)
+		cic[0]->dtor(ioc);
+}
+
 /*
  * IO Context helper functions
  */
@@ -3842,18 +3852,11 @@ int put_io_context(struct io_context *ioc)
 	BUG_ON(atomic_read(&ioc->refcount) == 0);
 
 	if (atomic_dec_and_test(&ioc->refcount)) {
-		struct cfq_io_context *cic;
-
 		rcu_read_lock();
 		if (ioc->aic && ioc->aic->dtor)
 			ioc->aic->dtor(ioc->aic);
-		if (ioc->cic_root.rb_node != NULL) {
-			struct rb_node *n = rb_first(&ioc->cic_root);
-
-			cic = rb_entry(n, struct cfq_io_context, rb_node);
-			cic->dtor(ioc);
-		}
 		rcu_read_unlock();
+		cfq_dtor(ioc);
 
 		kmem_cache_free(iocontext_cachep, ioc);
 		return 1;
@@ -3862,11 +3865,23 @@ int put_io_context(struct io_context *ioc)
 }
 EXPORT_SYMBOL(put_io_context);
 
+static void cfq_exit(struct io_context *ioc)
+{
+	struct cfq_io_context *cic[1];
+	int r;
+
+	rcu_read_lock();
+	r = radix_tree_gang_lookup(&ioc->radix_root, (void **) cic, 0, 1);
+	rcu_read_unlock();
+
+	if (r > 0)
+		cic[0]->exit(ioc);
+}
+
 /* Called by the exitting task */
 void exit_io_context(void)
 {
 	struct io_context *ioc;
-	struct cfq_io_context *cic;
 
 	task_lock(current);
 	ioc = current->io_context;
@@ -3876,11 +3891,7 @@ void exit_io_context(void)
 	if (atomic_dec_and_test(&ioc->nr_tasks)) {
 		if (ioc->aic && ioc->aic->exit)
 			ioc->aic->exit(ioc->aic);
-		if (ioc->cic_root.rb_node != NULL) {
-			cic = rb_entry(rb_first(&ioc->cic_root),
-				struct cfq_io_context, rb_node);
-			cic->exit(ioc);
-		}
+		cfq_exit(ioc);
 
 		put_io_context(ioc);
 	}
@@ -3900,7 +3911,7 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 		ret->last_waited = jiffies; /* doesn't matter... */
 		ret->nr_batch_requests = 0; /* because this is 0 */
 		ret->aic = NULL;
-		ret->cic_root.rb_node = NULL;
+		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
 		ret->ioc_data = NULL;
 	}
 
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index cd44d45..593b222 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -1,6 +1,8 @@
 #ifndef IOCONTEXT_H
 #define IOCONTEXT_H
 
+#include <linux/radix-tree.h>
+
 /*
  * This is the per-process anticipatory I/O scheduler state.
  */
@@ -29,8 +31,8 @@ struct as_io_context {
 
 struct cfq_queue;
 struct cfq_io_context {
-	struct rb_node rb_node;
 	void *key;
+	unsigned long dead_key;
 
 	struct cfq_queue *cfqq[2];
 
@@ -74,7 +76,7 @@ struct io_context {
 	int nr_batch_requests;     /* Number of requests left in the batch */
 
 	struct as_io_context *aic;
-	struct rb_root cic_root;
+	struct radix_tree_root radix_root;
 	void *ioc_data;
 };
 
-- 
1.5.4.rc2.84.gf85fd


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbXKYQSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbXKYQSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 11:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXKYQSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 11:18:16 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36685 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752336AbXKYQSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 11:18:15 -0500
Date: Sun, 25 Nov 2007 17:18:01 +0100
From: Adrian Bunk <bunk@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make I/O schedulers non-modular
Message-ID: <20071125161801.GB21947@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There isn't any big advantage and doesn't seem to be much usage of 
modular schedulers.

OTOH, the overhead made the kernel image of an x86 defconfig (that 
doesn't use modular schedulers) bigger by nearly 2 kB.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 block/Kconfig.iosched    |   12 ++++----
 block/as-iosched.c       |   32 -----------------------
 block/cfq-iosched.c      |   29 --------------------
 block/deadline-iosched.c |   10 -------
 block/elevator.c         |   54 +--------------------------------------
 block/ll_rw_blk.c        |    8 -----
 block/noop-iosched.c     |   11 -------
 include/linux/elevator.h |   26 ------------------
 kernel/sched.c           |    1
 9 files changed, 8 insertions(+), 175 deletions(-)

424b43bdb56389a6dd2f6bd5c3c6d519ff3ffe2d 
diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 7e803fc..c720bee 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -13,7 +13,7 @@ config IOSCHED_NOOP
 	  the kernel.
 
 config IOSCHED_AS
-	tristate "Anticipatory I/O scheduler"
+	bool "Anticipatory I/O scheduler"
 	default y
 	---help---
 	  The anticipatory I/O scheduler is generally a good choice for most
@@ -22,7 +22,7 @@ config IOSCHED_AS
 	  especially some database loads.
 
 config IOSCHED_DEADLINE
-	tristate "Deadline I/O scheduler"
+	bool "Deadline I/O scheduler"
 	default y
 	---help---
 	  The deadline I/O scheduler is simple and compact, and is often as
@@ -32,7 +32,7 @@ config IOSCHED_DEADLINE
 	  anticipatory I/O scheduler and so is a good choice.
 
 config IOSCHED_CFQ
-	tristate "CFQ I/O scheduler"
+	bool "CFQ I/O scheduler"
 	default y
 	---help---
 	  The CFQ I/O scheduler tries to distribute bandwidth equally
@@ -48,13 +48,13 @@ choice
 	  block devices.
 
 	config DEFAULT_AS
-		bool "Anticipatory" if IOSCHED_AS=y
+		bool "Anticipatory" if IOSCHED_AS
 
 	config DEFAULT_DEADLINE
-		bool "Deadline" if IOSCHED_DEADLINE=y
+		bool "Deadline" if IOSCHED_DEADLINE
 
 	config DEFAULT_CFQ
-		bool "CFQ" if IOSCHED_CFQ=y
+		bool "CFQ" if IOSCHED_CFQ
 
 	config DEFAULT_NOOP
 		bool "No-op"
diff --git a/block/as-iosched.c b/block/as-iosched.c
index dc715a5..2ebf12e 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -149,9 +149,6 @@ enum arq_state {
 #define RQ_STATE(rq)	((enum arq_state)(rq)->elevator_private2)
 #define RQ_SET_STATE(rq, state)	((rq)->elevator_private2 = (void *) state)
 
-static DEFINE_PER_CPU(unsigned long, ioc_count);
-static struct completion *ioc_gone;
-
 static void as_move_to_dispatch(struct as_data *ad, struct request *rq);
 static void as_antic_stop(struct as_data *ad);
 
@@ -163,16 +160,6 @@ static void as_antic_stop(struct as_data *ad);
 static void free_as_io_context(struct as_io_context *aic)
 {
 	kfree(aic);
-	elv_ioc_count_dec(ioc_count);
-	if (ioc_gone && !elv_ioc_count_read(ioc_count))
-		complete(ioc_gone);
-}
-
-static void as_trim(struct io_context *ioc)
-{
-	if (ioc->aic)
-		free_as_io_context(ioc->aic);
-	ioc->aic = NULL;
 }
 
 /* Called when the task exits */
@@ -200,7 +187,6 @@ static struct as_io_context *alloc_as_io_context(void)
 		ret->seek_total = 0;
 		ret->seek_samples = 0;
 		ret->seek_mean = 0;
-		elv_ioc_count_inc(ioc_count);
 	}
 
 	return ret;
@@ -1453,12 +1439,10 @@ static struct elevator_type iosched_as = {
 		.elevator_may_queue_fn =	as_may_queue,
 		.elevator_init_fn =		as_init_queue,
 		.elevator_exit_fn =		as_exit_queue,
-		.trim =				as_trim,
 	},
 
 	.elevator_attrs = as_attrs,
 	.elevator_name = "anticipatory",
-	.elevator_owner = THIS_MODULE,
 };
 
 static int __init as_init(void)
@@ -1466,21 +1450,5 @@ static int __init as_init(void)
 	return elv_register(&iosched_as);
 }
 
-static void __exit as_exit(void)
-{
-	DECLARE_COMPLETION_ONSTACK(all_gone);
-	elv_unregister(&iosched_as);
-	ioc_gone = &all_gone;
-	/* ioc_gone's update must be visible before reading ioc_count */
-	smp_wmb();
-	if (elv_ioc_count_read(ioc_count))
-		wait_for_completion(ioc_gone);
-	synchronize_rcu();
-}
-
 module_init(as_init);
-module_exit(as_exit);
 
-MODULE_AUTHOR("Nick Piggin");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("anticipatory IO scheduler");
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 0b4a479..72f6f8a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -43,9 +43,6 @@ static int cfq_slice_idle = HZ / 125;
 static struct kmem_cache *cfq_pool;
 static struct kmem_cache *cfq_ioc_pool;
 
-static DEFINE_PER_CPU(unsigned long, ioc_count);
-static struct completion *ioc_gone;
-
 #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
 #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
 #define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
@@ -1184,11 +1181,6 @@ static void cfq_free_io_context(struct io_context *ioc)
 		kmem_cache_free(cfq_ioc_pool, __cic);
 		freed++;
 	}
-
-	elv_ioc_count_mod(ioc_count, -freed);
-
-	if (ioc_gone && !elv_ioc_count_read(ioc_count))
-		complete(ioc_gone);
 }
 
 static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
@@ -1267,7 +1259,6 @@ cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 		INIT_LIST_HEAD(&cic->queue_list);
 		cic->dtor = cfq_free_io_context;
 		cic->exit = cfq_exit_io_context;
-		elv_ioc_count_inc(ioc_count);
 	}
 
 	return cic;
@@ -1483,7 +1474,6 @@ cfq_drop_dead_cic(struct io_context *ioc, struct cfq_io_context *cic)
 
 	rb_erase(&cic->rb_node, &ioc->cic_root);
 	kmem_cache_free(cfq_ioc_pool, cic);
-	elv_ioc_count_dec(ioc_count);
 }
 
 static struct cfq_io_context *
@@ -2270,11 +2260,9 @@ static struct elevator_type iosched_cfq = {
 		.elevator_may_queue_fn =	cfq_may_queue,
 		.elevator_init_fn =		cfq_init_queue,
 		.elevator_exit_fn =		cfq_exit_queue,
-		.trim =				cfq_free_io_context,
 	},
 	.elevator_attrs =	cfq_attrs,
 	.elevator_name =	"cfq",
-	.elevator_owner =	THIS_MODULE,
 };
 
 static int __init cfq_init(void)
@@ -2299,22 +2287,5 @@ static int __init cfq_init(void)
 	return ret;
 }
 
-static void __exit cfq_exit(void)
-{
-	DECLARE_COMPLETION_ONSTACK(all_gone);
-	elv_unregister(&iosched_cfq);
-	ioc_gone = &all_gone;
-	/* ioc_gone's update must be visible before reading ioc_count */
-	smp_wmb();
-	if (elv_ioc_count_read(ioc_count))
-		wait_for_completion(ioc_gone);
-	synchronize_rcu();
-	cfq_slab_kill();
-}
-
 module_init(cfq_init);
-module_exit(cfq_exit);
 
-MODULE_AUTHOR("Jens Axboe");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Completely Fair Queueing IO scheduler");
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index a054eef..7538aa0 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -462,7 +462,6 @@ static struct elevator_type iosched_deadline = {
 
 	.elevator_attrs = deadline_attrs,
 	.elevator_name = "deadline",
-	.elevator_owner = THIS_MODULE,
 };
 
 static int __init deadline_init(void)
@@ -470,14 +469,5 @@ static int __init deadline_init(void)
 	return elv_register(&iosched_deadline);
 }
 
-static void __exit deadline_exit(void)
-{
-	elv_unregister(&iosched_deadline);
-}
-
 module_init(deadline_init);
-module_exit(deadline_exit);
 
-MODULE_AUTHOR("Jens Axboe");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("deadline IO scheduler");
diff --git a/block/elevator.c b/block/elevator.c
index 446aea2..77c4ed0 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -90,7 +90,6 @@ inline int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 
 	return 1;
 }
-EXPORT_SYMBOL(elv_rq_merge_ok);
 
 static inline int elv_try_merge(struct request *__rq, struct bio *bio)
 {
@@ -121,11 +120,6 @@ static struct elevator_type *elevator_find(const char *name)
 	return NULL;
 }
 
-static void elevator_put(struct elevator_type *e)
-{
-	module_put(e->elevator_owner);
-}
-
 static struct elevator_type *elevator_get(const char *name)
 {
 	struct elevator_type *e;
@@ -133,8 +127,6 @@ static struct elevator_type *elevator_get(const char *name)
 	spin_lock(&elv_list_lock);
 
 	e = elevator_find(name);
-	if (e && !try_module_get(e->elevator_owner))
-		e = NULL;
 
 	spin_unlock(&elv_list_lock);
 
@@ -201,7 +193,6 @@ static elevator_t *elevator_alloc(struct request_queue *q,
 	return eq;
 err:
 	kfree(eq);
-	elevator_put(e);
 	return NULL;
 }
 
@@ -209,7 +200,6 @@ static void elevator_release(struct kobject *kobj)
 {
 	elevator_t *e = container_of(kobj, elevator_t, kobj);
 
-	elevator_put(e->elevator_type);
 	kfree(e->hash);
 	kfree(e);
 }
@@ -356,8 +346,6 @@ struct request *elv_rb_add(struct rb_root *root, struct request *rq)
 	return NULL;
 }
 
-EXPORT_SYMBOL(elv_rb_add);
-
 void elv_rb_del(struct rb_root *root, struct request *rq)
 {
 	BUG_ON(RB_EMPTY_NODE(&rq->rb_node));
@@ -365,8 +353,6 @@ void elv_rb_del(struct rb_root *root, struct request *rq)
 	RB_CLEAR_NODE(&rq->rb_node);
 }
 
-EXPORT_SYMBOL(elv_rb_del);
-
 struct request *elv_rb_find(struct rb_root *root, sector_t sector)
 {
 	struct rb_node *n = root->rb_node;
@@ -386,8 +372,6 @@ struct request *elv_rb_find(struct rb_root *root, sector_t sector)
 	return NULL;
 }
 
-EXPORT_SYMBOL(elv_rb_find);
-
 /*
  * Insert rq into dispatch queue of q.  Queue lock must be held on
  * entry.  rq is sort instead into the dispatch queue. To be used by
@@ -428,8 +412,6 @@ void elv_dispatch_sort(struct request_queue *q, struct request *rq)
 	list_add(&rq->queuelist, entry);
 }
 
-EXPORT_SYMBOL(elv_dispatch_sort);
-
 /*
  * Insert rq into dispatch queue of q.  Queue lock must be held on
  * entry.  rq is added to the back of the dispatch queue. To be used by
@@ -449,8 +431,6 @@ void elv_dispatch_add_tail(struct request_queue *q, struct request *rq)
 	list_add_tail(&rq->queuelist, &q->queue_head);
 }
 
-EXPORT_SYMBOL(elv_dispatch_add_tail);
-
 int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 {
 	elevator_t *e = q->elevator;
@@ -960,7 +940,7 @@ void elv_unregister_queue(struct request_queue *q)
 		__elv_unregister_queue(q->elevator);
 }
 
-int elv_register(struct elevator_type *e)
+int __init elv_register(struct elevator_type *e)
 {
 	char *def = "";
 
@@ -977,31 +957,6 @@ int elv_register(struct elevator_type *e)
 	printk(KERN_INFO "io scheduler %s registered%s\n", e->elevator_name, def);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(elv_register);
-
-void elv_unregister(struct elevator_type *e)
-{
-	struct task_struct *g, *p;
-
-	/*
-	 * Iterate every thread in the process to remove the io contexts.
-	 */
-	if (e->ops.trim) {
-		read_lock(&tasklist_lock);
-		do_each_thread(g, p) {
-			task_lock(p);
-			if (p->io_context)
-				e->ops.trim(p->io_context);
-			task_unlock(p);
-		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
-	}
-
-	spin_lock(&elv_list_lock);
-	list_del_init(&e->list);
-	spin_unlock(&elv_list_lock);
-}
-EXPORT_SYMBOL_GPL(elv_unregister);
 
 /*
  * switch to new_e io scheduler. be careful not to introduce deadlocks -
@@ -1101,10 +1056,8 @@ ssize_t elv_iosched_store(struct request_queue *q, const char *name,
 		return -EINVAL;
 	}
 
-	if (!strcmp(elevator_name, q->elevator->elevator_type->elevator_name)) {
-		elevator_put(e);
+	if (!strcmp(elevator_name, q->elevator->elevator_type->elevator_name))
 		return count;
-	}
 
 	if (!elevator_switch(q, e))
 		printk(KERN_ERR "elevator: switch to %s failed\n",elevator_name);
@@ -1142,8 +1095,6 @@ struct request *elv_rb_former_request(struct request_queue *q,
 	return NULL;
 }
 
-EXPORT_SYMBOL(elv_rb_former_request);
-
 struct request *elv_rb_latter_request(struct request_queue *q,
 				      struct request *rq)
 {
@@ -1155,4 +1106,3 @@ struct request *elv_rb_latter_request(struct request_queue *q,
 	return NULL;
 }
 
-EXPORT_SYMBOL(elv_rb_latter_request);
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 3b927be..5f74942 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2264,7 +2264,6 @@ void blk_start_queueing(struct request_queue *q)
 	else
 		__generic_unplug_device(q);
 }
-EXPORT_SYMBOL(blk_start_queueing);
 
 /**
  * blk_requeue_request - put a request back on queue
@@ -3794,13 +3793,10 @@ int kblockd_schedule_work(struct work_struct *work)
 	return queue_work(kblockd_workqueue, work);
 }
 
-EXPORT_SYMBOL(kblockd_schedule_work);
-
 void kblockd_flush_work(struct work_struct *work)
 {
 	cancel_work_sync(work);
 }
-EXPORT_SYMBOL(kblockd_flush_work);
 
 int __init blk_dev_init(void)
 {
@@ -3858,7 +3854,6 @@ void put_io_context(struct io_context *ioc)
 		kmem_cache_free(iocontext_cachep, ioc);
 	}
 }
-EXPORT_SYMBOL(put_io_context);
 
 /* Called by the exitting task */
 void exit_io_context(void)
@@ -3931,7 +3926,6 @@ struct io_context *get_io_context(gfp_t gfp_flags, int node)
 		atomic_inc(&ret->refcount);
 	return ret;
 }
-EXPORT_SYMBOL(get_io_context);
 
 void copy_io_context(struct io_context **pdst, struct io_context **psrc)
 {
@@ -3945,7 +3939,6 @@ void copy_io_context(struct io_context **pdst, struct io_context **psrc)
 		*pdst = src;
 	}
 }
-EXPORT_SYMBOL(copy_io_context);
 
 void swap_io_context(struct io_context **ioc1, struct io_context **ioc2)
 {
@@ -3954,7 +3947,6 @@ void swap_io_context(struct io_context **ioc1, struct io_context **ioc2)
 	*ioc1 = *ioc2;
 	*ioc2 = temp;
 }
-EXPORT_SYMBOL(swap_io_context);
 
 /*
  * sysfs parts below
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index 7563d8a..be8ea5f 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -96,7 +96,6 @@ static struct elevator_type elevator_noop = {
 		.elevator_exit_fn		= noop_exit_queue,
 	},
 	.elevator_name = "noop",
-	.elevator_owner = THIS_MODULE,
 };
 
 static int __init noop_init(void)
@@ -104,15 +103,5 @@ static int __init noop_init(void)
 	return elv_register(&elevator_noop);
 }
 
-static void __exit noop_exit(void)
-{
-	elv_unregister(&elevator_noop);
-}
-
 module_init(noop_init);
-module_exit(noop_exit);
-
 
-MODULE_AUTHOR("Jens Axboe");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("No-op IO scheduler");
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index e8f4213..cc36d23 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -55,7 +55,6 @@ struct elevator_ops
 
 	elevator_init_fn *elevator_init_fn;
 	elevator_exit_fn *elevator_exit_fn;
-	void (*trim)(struct io_context *);
 };
 
 #define ELV_NAME_MAX	(16)
@@ -75,7 +74,6 @@ struct elevator_type
 	struct elevator_ops ops;
 	struct elv_fs_entry *elevator_attrs;
 	char elevator_name[ELV_NAME_MAX];
-	struct module *elevator_owner;
 };
 
 /*
@@ -120,7 +118,6 @@ extern void elv_put_request(struct request_queue *, struct request *);
  * io scheduler registration
  */
 extern int elv_register(struct elevator_type *);
-extern void elv_unregister(struct elevator_type *);
 
 /*
  * io scheduler sysfs switching
@@ -184,28 +181,5 @@ enum {
 	INIT_LIST_HEAD(&(rq)->donelist);	\
 	} while (0)
 
-/*
- * io context count accounting
- */
-#define elv_ioc_count_mod(name, __val)				\
-	do {							\
-		preempt_disable();				\
-		__get_cpu_var(name) += (__val);			\
-		preempt_enable();				\
-	} while (0)
-
-#define elv_ioc_count_inc(name)	elv_ioc_count_mod(name, 1)
-#define elv_ioc_count_dec(name)	elv_ioc_count_mod(name, -1)
-
-#define elv_ioc_count_read(name)				\
-({								\
-	unsigned long __val = 0;				\
-	int __cpu;						\
-	smp_wmb();						\
-	for_each_possible_cpu(__cpu)				\
-		__val += per_cpu(name, __cpu);			\
-	__val;							\
-})
-
 #endif /* CONFIG_BLOCK */
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 38933ca..4a90d8c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4173,7 +4173,6 @@ int task_nice(const struct task_struct *p)
 {
 	return TASK_NICE(p);
 }
-EXPORT_SYMBOL_GPL(task_nice);
 
 /**
  * idle_cpu - is a given cpu idle currently?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936032Ab0BZMRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:17:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:43550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935989Ab0BZMPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:15:21 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 39/43] fscache: convert operation to use workqueue instead of slow-work
Date: Fri, 26 Feb 2010 21:23:16 +0900
Message-Id: <1267187000-18791-40-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make fscache operation to use only workqueue instead of combination of
workqueue and slow-work.  FSCACHE_OP_SLOW is dropped and
FSCACHE_OP_FAST is renamed to FSCACHE_OP_ASYNC and uses newly added
fscache_op_wq workqueue to execute op->processor().
fscache_operation_init_slow() is dropped and fscache_operation_init()
now takes @processor argument directly.

* Non reentrant multi-cpu workqueue is used.

* fscache_retrieval_work() is no longer necessary as OP_ASYNC now does
  the equivalent thing.

* sysctl fscache.operation_max_active added to control concurrency.
  The default value is nr_cpus clamped between 2 and WQ_MAX_ACTIVE.

NOT_SIGNED_OFF_YET
Cc: David Howells <dhowells@redhat.com>
---
 fs/cachefiles/rdwr.c          |    4 +-
 fs/fscache/internal.h         |    1 +
 fs/fscache/main.c             |   39 ++++++++++++++++++++++++
 fs/fscache/operation.c        |   67 +++++------------------------------------
 fs/fscache/page.c             |   36 +++++-----------------
 include/linux/fscache-cache.h |   36 ++++++----------------
 6 files changed, 68 insertions(+), 115 deletions(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 1d83325..43bbe57 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -421,7 +421,7 @@ int cachefiles_read_or_alloc_page(struct fscache_retrieval *op,
 	shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
 
 	op->op.flags &= FSCACHE_OP_KEEP_FLAGS;
-	op->op.flags |= FSCACHE_OP_FAST;
+	op->op.flags |= FSCACHE_OP_ASYNC;
 	op->op.processor = cachefiles_read_copier;
 
 	pagevec_init(&pagevec, 0);
@@ -728,7 +728,7 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 	pagevec_init(&pagevec, 0);
 
 	op->op.flags &= FSCACHE_OP_KEEP_FLAGS;
-	op->op.flags |= FSCACHE_OP_FAST;
+	op->op.flags |= FSCACHE_OP_ASYNC;
 	op->op.processor = cachefiles_read_copier;
 
 	INIT_LIST_HEAD(&backpages);
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 11f5bf3..2603b24 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -83,6 +83,7 @@ extern unsigned fscache_defer_create;
 extern unsigned fscache_debug;
 extern struct kobject *fscache_root;
 extern struct workqueue_struct *fscache_object_wq;
+extern struct workqueue_struct *fscache_op_wq;
 DECLARE_PER_CPU(wait_queue_head_t, fscache_object_cong_wait);
 
 static inline bool fscache_object_congested(void)
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 07ab4eb..9250470 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -42,11 +42,13 @@ MODULE_PARM_DESC(fscache_debug,
 
 struct kobject *fscache_root;
 struct workqueue_struct *fscache_object_wq;
+struct workqueue_struct *fscache_op_wq;
 
 DEFINE_PER_CPU(wait_queue_head_t, fscache_object_cong_wait);
 
 /* these values serve as lower bounds, will be adjusted in fscache_init() */
 static unsigned fscache_object_max_active = 4;
+static unsigned fscache_op_max_active = 2;
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fscache_sysctl_header;
@@ -74,6 +76,14 @@ ctl_table fscache_sysctls[] = {
 		.proc_handler	= fscache_max_active_sysctl,
 		.extra1		= &fscache_object_wq,
 	},
+	{
+		.procname	= "operation_max_active",
+		.data		= &fscache_op_max_active,
+		.maxlen		= sizeof(unsigned),
+		.mode		= 0644,
+		.proc_handler	= fscache_max_active_sysctl,
+		.extra1		= &fscache_op_wq,
+	},
 	{}
 };
 
@@ -102,6 +112,21 @@ static bool fscache_object_show_work(struct seq_file *m,
 		   fscache_object_states_short[object->state]);
 	return true;
 }
+
+/*
+ * describe an operation for slow-work debugging
+ */
+static bool fscache_op_show_work(struct seq_file *m,
+				 struct work_struct *work, bool running)
+{
+	struct fscache_operation *op =
+		container_of(work, struct fscache_operation, work);
+
+	seq_printf(m, "FSC: OBJ%x OP%x: %s/%s fl=%lx",
+		   op->object->debug_id, op->debug_id,
+		   op->name, op->state, op->flags);
+	return true;
+}
 #endif
 
 /*
@@ -127,8 +152,19 @@ static int __init fscache_init(void)
 	if (!fscache_object_wq)
 		goto error_object_wq;
 
+	fscache_op_max_active = clamp_val(fscache_object_max_active / 2,
+					  fscache_op_max_active, WQ_MAX_ACTIVE);
+
+	ret = -ENOMEM;
+	fscache_op_wq =
+		__create_workqueue("fscache_operation", WQ_NON_REENTRANT,
+				   fscache_op_max_active);
+	if (!fscache_op_wq)
+		goto error_op_wq;
+
 #ifdef CONFIG_WORKQUEUE_DEBUGFS
 	workqueue_set_show_work(fscache_object_wq, fscache_object_show_work);
+	workqueue_set_show_work(fscache_op_wq, fscache_op_show_work);
 #endif
 
 	for_each_possible_cpu(cpu)
@@ -173,6 +209,8 @@ error_sysctl:
 #endif
 	fscache_proc_cleanup();
 error_proc:
+	destroy_workqueue(fscache_op_wq);
+error_op_wq:
 	destroy_workqueue(fscache_object_wq);
 error_object_wq:
 	slow_work_unregister_user(THIS_MODULE);
@@ -193,6 +231,7 @@ static void __exit fscache_exit(void)
 	kmem_cache_destroy(fscache_cookie_jar);
 	unregister_sysctl_table(fscache_sysctl_header);
 	fscache_proc_cleanup();
+	destroy_workqueue(fscache_op_wq);
 	destroy_workqueue(fscache_object_wq);
 	slow_work_unregister_user(THIS_MODULE);
 	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index 313e79a..c673b32 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -41,16 +41,12 @@ void fscache_enqueue_operation(struct fscache_operation *op)
 
 	fscache_stat(&fscache_n_op_enqueue);
 	switch (op->flags & FSCACHE_OP_TYPE) {
-	case FSCACHE_OP_FAST:
-		_debug("queue fast");
+	case FSCACHE_OP_ASYNC:
+		_debug("queue async");
 		atomic_inc(&op->usage);
-		if (!schedule_work(&op->fast_work))
+		if (!queue_work(fscache_op_wq, &op->work))
 			fscache_put_operation(op);
 		break;
-	case FSCACHE_OP_SLOW:
-		_debug("queue slow");
-		slow_work_enqueue(&op->slow_work);
-		break;
 	case FSCACHE_OP_MYTHREAD:
 		_debug("queue for caller's attention");
 		break;
@@ -454,36 +450,13 @@ void fscache_operation_gc(struct work_struct *work)
 }
 
 /*
- * allow the slow work item processor to get a ref on an operation
- */
-static int fscache_op_get_ref(struct slow_work *work)
-{
-	struct fscache_operation *op =
-		container_of(work, struct fscache_operation, slow_work);
-
-	atomic_inc(&op->usage);
-	return 0;
-}
-
-/*
- * allow the slow work item processor to discard a ref on an operation
- */
-static void fscache_op_put_ref(struct slow_work *work)
-{
-	struct fscache_operation *op =
-		container_of(work, struct fscache_operation, slow_work);
-
-	fscache_put_operation(op);
-}
-
-/*
- * execute an operation using the slow thread pool to provide processing context
- * - the caller holds a ref to this object, so we don't need to hold one
+ * execute an operation using fs_op_wq to provide processing context -
+ * the caller holds a ref to this object, so we don't need to hold one
  */
-static void fscache_op_execute(struct slow_work *work)
+void fscache_op_work_func(struct work_struct *work)
 {
 	struct fscache_operation *op =
-		container_of(work, struct fscache_operation, slow_work);
+		container_of(work, struct fscache_operation, work);
 	unsigned long start;
 
 	_enter("{OBJ%x OP%x,%d}",
@@ -493,31 +466,7 @@ static void fscache_op_execute(struct slow_work *work)
 	start = jiffies;
 	op->processor(op);
 	fscache_hist(fscache_ops_histogram, start);
+	fscache_put_operation(op);
 
 	_leave("");
 }
-
-/*
- * describe an operation for slow-work debugging
- */
-#ifdef CONFIG_SLOW_WORK_PROC
-static void fscache_op_desc(struct slow_work *work, struct seq_file *m)
-{
-	struct fscache_operation *op =
-		container_of(work, struct fscache_operation, slow_work);
-
-	seq_printf(m, "FSC: OBJ%x OP%x: %s/%s fl=%lx",
-		   op->object->debug_id, op->debug_id,
-		   op->name, op->state, op->flags);
-}
-#endif
-
-const struct slow_work_ops fscache_op_slow_work_ops = {
-	.owner		= THIS_MODULE,
-	.get_ref	= fscache_op_get_ref,
-	.put_ref	= fscache_op_put_ref,
-	.execute	= fscache_op_execute,
-#ifdef CONFIG_SLOW_WORK_PROC
-	.desc		= fscache_op_desc,
-#endif
-};
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index c598ea4..3d02944 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -104,7 +104,7 @@ bool __fscache_maybe_release_page(struct fscache_cookie *cookie,
 
 page_busy:
 	/* we might want to wait here, but that could deadlock the allocator as
-	 * the slow-work threads writing to the cache may all end up sleeping
+	 * the work threads writing to the cache may all end up sleeping
 	 * on memory allocation */
 	fscache_stat(&fscache_n_store_vmscan_busy);
 	return false;
@@ -187,9 +187,8 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
 		return -ENOMEM;
 	}
 
-	fscache_operation_init(op, NULL);
-	fscache_operation_init_slow(op, fscache_attr_changed_op);
-	op->flags = FSCACHE_OP_SLOW | (1 << FSCACHE_OP_EXCLUSIVE);
+	fscache_operation_init(op, fscache_attr_changed_op, NULL);
+	op->flags = FSCACHE_OP_ASYNC | (1 << FSCACHE_OP_EXCLUSIVE);
 	fscache_set_op_name(op, "Attr");
 
 	spin_lock(&cookie->lock);
@@ -217,24 +216,6 @@ nobufs:
 EXPORT_SYMBOL(__fscache_attr_changed);
 
 /*
- * handle secondary execution given to a retrieval op on behalf of the
- * cache
- */
-static void fscache_retrieval_work(struct work_struct *work)
-{
-	struct fscache_retrieval *op =
-		container_of(work, struct fscache_retrieval, op.fast_work);
-	unsigned long start;
-
-	_enter("{OP%x}", op->op.debug_id);
-
-	start = jiffies;
-	op->op.processor(&op->op);
-	fscache_hist(fscache_ops_histogram, start);
-	fscache_put_operation(&op->op);
-}
-
-/*
  * release a retrieval op reference
  */
 static void fscache_release_retrieval_op(struct fscache_operation *_op)
@@ -268,13 +249,12 @@ static struct fscache_retrieval *fscache_alloc_retrieval(
 		return NULL;
 	}
 
-	fscache_operation_init(&op->op, fscache_release_retrieval_op);
+	fscache_operation_init(&op->op, NULL, fscache_release_retrieval_op);
 	op->op.flags	= FSCACHE_OP_MYTHREAD | (1 << FSCACHE_OP_WAITING);
 	op->mapping	= mapping;
 	op->end_io_func	= end_io_func;
 	op->context	= context;
 	op->start_time	= jiffies;
-	INIT_WORK(&op->op.fast_work, fscache_retrieval_work);
 	INIT_LIST_HEAD(&op->to_do);
 	fscache_set_op_name(&op->op, "Retr");
 	return op;
@@ -798,9 +778,9 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	if (!op)
 		goto nomem;
 
-	fscache_operation_init(&op->op, fscache_release_write_op);
-	fscache_operation_init_slow(&op->op, fscache_write_op);
-	op->op.flags = FSCACHE_OP_SLOW | (1 << FSCACHE_OP_WAITING);
+	fscache_operation_init(&op->op, fscache_write_op,
+			       fscache_release_write_op);
+	op->op.flags = FSCACHE_OP_ASYNC | (1 << FSCACHE_OP_WAITING);
 	fscache_set_op_name(&op->op, "Write1");
 
 	ret = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
@@ -855,7 +835,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	fscache_stat(&fscache_n_store_ops);
 	fscache_stat(&fscache_n_stores_ok);
 
-	/* the slow work queue now carries its own ref on the object */
+	/* the work queue now carries its own ref on the object */
 	fscache_put_operation(&op->op);
 	_leave(" = 0");
 	return 0;
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index be9293d..aed1cf5 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -77,18 +77,14 @@ typedef void (*fscache_operation_release_t)(struct fscache_operation *op);
 typedef void (*fscache_operation_processor_t)(struct fscache_operation *op);
 
 struct fscache_operation {
-	union {
-		struct work_struct fast_work;	/* record for fast ops */
-		struct slow_work slow_work;	/* record for (very) slow ops */
-	};
+	struct work_struct	work;		/* record for async ops */
 	struct list_head	pend_link;	/* link in object->pending_ops */
 	struct fscache_object	*object;	/* object to be operated upon */
 
 	unsigned long		flags;
 #define FSCACHE_OP_TYPE		0x000f	/* operation type */
-#define FSCACHE_OP_FAST		0x0001	/* - fast op, processor may not sleep for disk */
-#define FSCACHE_OP_SLOW		0x0002	/* - (very) slow op, processor may sleep for disk */
-#define FSCACHE_OP_MYTHREAD	0x0003	/* - processing is done be issuing thread, not pool */
+#define FSCACHE_OP_ASYNC	0x0001	/* - async op, processor may sleep for disk */
+#define FSCACHE_OP_MYTHREAD	0x0002	/* - processing is done be issuing thread, not pool */
 #define FSCACHE_OP_WAITING	4	/* cleared when op is woken */
 #define FSCACHE_OP_EXCLUSIVE	5	/* exclusive op, other ops must wait */
 #define FSCACHE_OP_DEAD		6	/* op is now dead */
@@ -106,7 +102,7 @@ struct fscache_operation {
 	/* operation releaser */
 	fscache_operation_release_t release;
 
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_WORKQUEUE_DEBUGFS
 	const char *name;		/* operation name */
 	const char *state;		/* operation state */
 #define fscache_set_op_name(OP, N)	do { (OP)->name  = (N); } while(0)
@@ -118,7 +114,7 @@ struct fscache_operation {
 };
 
 extern atomic_t fscache_op_debug_id;
-extern const struct slow_work_ops fscache_op_slow_work_ops;
+extern void fscache_op_work_func(struct work_struct *work);
 
 extern void fscache_enqueue_operation(struct fscache_operation *);
 extern void fscache_put_operation(struct fscache_operation *);
@@ -129,33 +125,21 @@ extern void fscache_put_operation(struct fscache_operation *);
  * @release: The release function to assign
  *
  * Do basic initialisation of an operation.  The caller must still set flags,
- * object, either fast_work or slow_work if necessary, and processor if needed.
+ * object and processor if needed.
  */
 static inline void fscache_operation_init(struct fscache_operation *op,
-					  fscache_operation_release_t release)
+					fscache_operation_processor_t processor,
+					fscache_operation_release_t release)
 {
+	INIT_WORK(&op->work, fscache_op_work_func);
 	atomic_set(&op->usage, 1);
 	op->debug_id = atomic_inc_return(&fscache_op_debug_id);
+	op->processor = processor;
 	op->release = release;
 	INIT_LIST_HEAD(&op->pend_link);
 	fscache_set_op_state(op, "Init");
 }
 
-/**
- * fscache_operation_init_slow - Do additional initialisation of a slow op
- * @op: The operation to initialise
- * @processor: The processor function to assign
- *
- * Do additional initialisation of an operation as required for slow work.
- */
-static inline
-void fscache_operation_init_slow(struct fscache_operation *op,
-				 fscache_operation_processor_t processor)
-{
-	op->processor = processor;
-	slow_work_init(&op->slow_work, &fscache_op_slow_work_ops);
-}
-
 /*
  * data read operation
  */
-- 
1.6.4.2


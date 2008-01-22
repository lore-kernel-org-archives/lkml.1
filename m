Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbYAVJzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbYAVJzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbYAVJyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:54:36 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8778 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418AbYAVJy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:54:28 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: knikanth@novell.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/6] ioprio: move io priority from task_struct to io_context
Date: Tue, 22 Jan 2008 10:49:16 +0100
Message-Id: <1200995361-24001-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.rc2.84.gf85fd
In-Reply-To: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where it belongs and then it doesn't take up space for a
process that doesn't do IO.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c       |   34 +++++++++----------
 block/ll_rw_blk.c         |   42 ++++++++++++++++-------
 fs/ioprio.c               |   29 ++++++++++++----
 include/linux/blkdev.h    |   75 +------------------------------------------
 include/linux/init_task.h |    1 -
 include/linux/iocontext.h |   79 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ioprio.h    |   13 ++++---
 include/linux/sched.h     |    1 -
 kernel/fork.c             |   31 +++++++++++++++---
 9 files changed, 179 insertions(+), 126 deletions(-)
 create mode 100644 include/linux/iocontext.h

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 13553e0..533af75 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -199,7 +199,7 @@ CFQ_CFQQ_FNS(sync);
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, int,
-				       struct task_struct *, gfp_t);
+				       struct io_context *, gfp_t);
 static struct cfq_io_context *cfq_cic_rb_lookup(struct cfq_data *,
 						struct io_context *);
 
@@ -1273,7 +1273,7 @@ cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 	return cic;
 }
 
-static void cfq_init_prio_data(struct cfq_queue *cfqq)
+static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 {
 	struct task_struct *tsk = current;
 	int ioprio_class;
@@ -1281,7 +1281,7 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq)
 	if (!cfq_cfqq_prio_changed(cfqq))
 		return;
 
-	ioprio_class = IOPRIO_PRIO_CLASS(tsk->ioprio);
+	ioprio_class = IOPRIO_PRIO_CLASS(ioc->ioprio);
 	switch (ioprio_class) {
 		default:
 			printk(KERN_ERR "cfq: bad prio %x\n", ioprio_class);
@@ -1293,11 +1293,11 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq)
 			cfqq->ioprio_class = IOPRIO_CLASS_BE;
 			break;
 		case IOPRIO_CLASS_RT:
-			cfqq->ioprio = task_ioprio(tsk);
+			cfqq->ioprio = task_ioprio(ioc);
 			cfqq->ioprio_class = IOPRIO_CLASS_RT;
 			break;
 		case IOPRIO_CLASS_BE:
-			cfqq->ioprio = task_ioprio(tsk);
+			cfqq->ioprio = task_ioprio(ioc);
 			cfqq->ioprio_class = IOPRIO_CLASS_BE;
 			break;
 		case IOPRIO_CLASS_IDLE:
@@ -1330,8 +1330,7 @@ static inline void changed_ioprio(struct cfq_io_context *cic)
 	cfqq = cic->cfqq[ASYNC];
 	if (cfqq) {
 		struct cfq_queue *new_cfqq;
-		new_cfqq = cfq_get_queue(cfqd, ASYNC, cic->ioc->task,
-					 GFP_ATOMIC);
+		new_cfqq = cfq_get_queue(cfqd, ASYNC, cic->ioc, GFP_ATOMIC);
 		if (new_cfqq) {
 			cic->cfqq[ASYNC] = new_cfqq;
 			cfq_put_queue(cfqq);
@@ -1363,13 +1362,13 @@ static void cfq_ioc_set_ioprio(struct io_context *ioc)
 
 static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, int is_sync,
-		     struct task_struct *tsk, gfp_t gfp_mask)
+		     struct io_context *ioc, gfp_t gfp_mask)
 {
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
 	struct cfq_io_context *cic;
 
 retry:
-	cic = cfq_cic_rb_lookup(cfqd, tsk->io_context);
+	cic = cfq_cic_rb_lookup(cfqd, ioc);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
 
@@ -1412,7 +1411,7 @@ retry:
 		cfq_mark_cfqq_prio_changed(cfqq);
 		cfq_mark_cfqq_queue_new(cfqq);
 
-		cfq_init_prio_data(cfqq);
+		cfq_init_prio_data(cfqq, ioc);
 	}
 
 	if (new_cfqq)
@@ -1439,11 +1438,11 @@ cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
 }
 
 static struct cfq_queue *
-cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct task_struct *tsk,
+cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct io_context *ioc,
 	      gfp_t gfp_mask)
 {
-	const int ioprio = task_ioprio(tsk);
-	const int ioprio_class = task_ioprio_class(tsk);
+	const int ioprio = task_ioprio(ioc);
+	const int ioprio_class = task_ioprio_class(ioc);
 	struct cfq_queue **async_cfqq = NULL;
 	struct cfq_queue *cfqq = NULL;
 
@@ -1453,7 +1452,7 @@ cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct task_struct *tsk,
 	}
 
 	if (!cfqq) {
-		cfqq = cfq_find_alloc_queue(cfqd, is_sync, tsk, gfp_mask);
+		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, gfp_mask);
 		if (!cfqq)
 			return NULL;
 	}
@@ -1793,7 +1792,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
-	cfq_init_prio_data(cfqq);
+	cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
 
 	cfq_add_rq_rb(rq);
 
@@ -1900,7 +1899,7 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 
 	cfqq = cic_to_cfqq(cic, rw & REQ_RW_SYNC);
 	if (cfqq) {
-		cfq_init_prio_data(cfqq);
+		cfq_init_prio_data(cfqq, cic->ioc);
 		cfq_prio_boost(cfqq);
 
 		return __cfq_may_queue(cfqq);
@@ -1938,7 +1937,6 @@ static int
 cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
-	struct task_struct *tsk = current;
 	struct cfq_io_context *cic;
 	const int rw = rq_data_dir(rq);
 	const int is_sync = rq_is_sync(rq);
@@ -1956,7 +1954,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq) {
-		cfqq = cfq_get_queue(cfqd, is_sync, tsk, gfp_mask);
+		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
 
 		if (!cfqq)
 			goto queue_fail;
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 8b91994..bcd0354 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3882,6 +3882,26 @@ void exit_io_context(void)
 	put_io_context(ioc);
 }
 
+struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
+{
+	struct io_context *ret;
+
+	ret = kmem_cache_alloc_node(iocontext_cachep, gfp_flags, node);
+	if (ret) {
+		atomic_set(&ret->refcount, 1);
+		ret->task = current;
+		ret->ioprio_changed = 0;
+		ret->ioprio = 0;
+		ret->last_waited = jiffies; /* doesn't matter... */
+		ret->nr_batch_requests = 0; /* because this is 0 */
+		ret->aic = NULL;
+		ret->cic_root.rb_node = NULL;
+		ret->ioc_data = NULL;
+	}
+
+	return ret;
+}
+
 /*
  * If the current task has no IO context then create one and initialise it.
  * Otherwise, return its existing IO context.
@@ -3899,16 +3919,8 @@ static struct io_context *current_io_context(gfp_t gfp_flags, int node)
 	if (likely(ret))
 		return ret;
 
-	ret = kmem_cache_alloc_node(iocontext_cachep, gfp_flags, node);
+	ret = alloc_io_context(gfp_flags, node);
 	if (ret) {
-		atomic_set(&ret->refcount, 1);
-		ret->task = current;
-		ret->ioprio_changed = 0;
-		ret->last_waited = jiffies; /* doesn't matter... */
-		ret->nr_batch_requests = 0; /* because this is 0 */
-		ret->aic = NULL;
-		ret->cic_root.rb_node = NULL;
-		ret->ioc_data = NULL;
 		/* make sure set_task_ioprio() sees the settings above */
 		smp_wmb();
 		tsk->io_context = ret;
@@ -3925,10 +3937,14 @@ static struct io_context *current_io_context(gfp_t gfp_flags, int node)
  */
 struct io_context *get_io_context(gfp_t gfp_flags, int node)
 {
-	struct io_context *ret;
-	ret = current_io_context(gfp_flags, node);
-	if (likely(ret))
-		atomic_inc(&ret->refcount);
+	struct io_context *ret = NULL;
+
+	do {
+		ret = current_io_context(gfp_flags, node);
+		if (unlikely(!ret))
+			break;
+	} while (!atomic_inc_not_zero(&ret->refcount));
+
 	return ret;
 }
 EXPORT_SYMBOL(get_io_context);
diff --git a/fs/ioprio.c b/fs/ioprio.c
index e4e01bc..a760040 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -41,18 +41,29 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
 		return err;
 
 	task_lock(task);
+	do {
+		ioc = task->io_context;
+		/* see wmb() in current_io_context() */
+		smp_read_barrier_depends();
+		if (ioc)
+			break;
 
-	task->ioprio = ioprio;
-
-	ioc = task->io_context;
-	/* see wmb() in current_io_context() */
-	smp_read_barrier_depends();
+		ioc = alloc_io_context(GFP_ATOMIC, -1);
+		if (!ioc) {
+			err = -ENOMEM;
+			break;
+		}
+		task->io_context = ioc;
+		ioc->task = task;
+	} while (1);
 
-	if (ioc)
+	if (!err) {
+		ioc->ioprio = ioprio;
 		ioc->ioprio_changed = 1;
+	}
 
 	task_unlock(task);
-	return 0;
+	return err;
 }
 
 asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
@@ -148,7 +159,9 @@ static int get_task_ioprio(struct task_struct *p)
 	ret = security_task_getioprio(p);
 	if (ret)
 		goto out;
-	ret = p->ioprio;
+	ret = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, IOPRIO_NORM);
+	if (p->io_context)
+		ret = p->io_context->ioprio;
 out:
 	return ret;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d18ee67..d61c6f5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -34,83 +34,10 @@ struct sg_io_hdr;
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_MAX_RQ	128	/* Default maximum */
 
-/*
- * This is the per-process anticipatory I/O scheduler state.
- */
-struct as_io_context {
-	spinlock_t lock;
-
-	void (*dtor)(struct as_io_context *aic); /* destructor */
-	void (*exit)(struct as_io_context *aic); /* called on task exit */
-
-	unsigned long state;
-	atomic_t nr_queued; /* queued reads & sync writes */
-	atomic_t nr_dispatched; /* number of requests gone to the drivers */
-
-	/* IO History tracking */
-	/* Thinktime */
-	unsigned long last_end_request;
-	unsigned long ttime_total;
-	unsigned long ttime_samples;
-	unsigned long ttime_mean;
-	/* Layout pattern */
-	unsigned int seek_samples;
-	sector_t last_request_pos;
-	u64 seek_total;
-	sector_t seek_mean;
-};
-
-struct cfq_queue;
-struct cfq_io_context {
-	struct rb_node rb_node;
-	void *key;
-
-	struct cfq_queue *cfqq[2];
-
-	struct io_context *ioc;
-
-	unsigned long last_end_request;
-	sector_t last_request_pos;
-
-	unsigned long ttime_total;
-	unsigned long ttime_samples;
-	unsigned long ttime_mean;
-
-	unsigned int seek_samples;
-	u64 seek_total;
-	sector_t seek_mean;
-
-	struct list_head queue_list;
-
-	void (*dtor)(struct io_context *); /* destructor */
-	void (*exit)(struct io_context *); /* called on task exit */
-};
-
-/*
- * This is the per-process I/O subsystem state.  It is refcounted and
- * kmalloc'ed. Currently all fields are modified in process io context
- * (apart from the atomic refcount), so require no locking.
- */
-struct io_context {
-	atomic_t refcount;
-	struct task_struct *task;
-
-	unsigned int ioprio_changed;
-
-	/*
-	 * For request batching
-	 */
-	unsigned long last_waited; /* Time last woken after wait for request */
-	int nr_batch_requests;     /* Number of requests left in the batch */
-
-	struct as_io_context *aic;
-	struct rb_root cic_root;
-	void *ioc_data;
-};
-
 void put_io_context(struct io_context *ioc);
 void exit_io_context(void);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
+struct io_context *alloc_io_context(gfp_t, int);
 void copy_io_context(struct io_context **pdst, struct io_context **psrc);
 void swap_io_context(struct io_context **ioc1, struct io_context **ioc2);
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index cae35b6..7011480 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -133,7 +133,6 @@ extern struct group_info init_groups;
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
 	.run_list	= LIST_HEAD_INIT(tsk.run_list),			\
-	.ioprio		= 0,						\
 	.time_slice	= HZ,						\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	.ptrace_children= LIST_HEAD_INIT(tsk.ptrace_children),		\
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
new file mode 100644
index 0000000..186807e
--- /dev/null
+++ b/include/linux/iocontext.h
@@ -0,0 +1,79 @@
+#ifndef IOCONTEXT_H
+#define IOCONTEXT_H
+
+/*
+ * This is the per-process anticipatory I/O scheduler state.
+ */
+struct as_io_context {
+	spinlock_t lock;
+
+	void (*dtor)(struct as_io_context *aic); /* destructor */
+	void (*exit)(struct as_io_context *aic); /* called on task exit */
+
+	unsigned long state;
+	atomic_t nr_queued; /* queued reads & sync writes */
+	atomic_t nr_dispatched; /* number of requests gone to the drivers */
+
+	/* IO History tracking */
+	/* Thinktime */
+	unsigned long last_end_request;
+	unsigned long ttime_total;
+	unsigned long ttime_samples;
+	unsigned long ttime_mean;
+	/* Layout pattern */
+	unsigned int seek_samples;
+	sector_t last_request_pos;
+	u64 seek_total;
+	sector_t seek_mean;
+};
+
+struct cfq_queue;
+struct cfq_io_context {
+	struct rb_node rb_node;
+	void *key;
+
+	struct cfq_queue *cfqq[2];
+
+	struct io_context *ioc;
+
+	unsigned long last_end_request;
+	sector_t last_request_pos;
+
+	unsigned long ttime_total;
+	unsigned long ttime_samples;
+	unsigned long ttime_mean;
+
+	unsigned int seek_samples;
+	u64 seek_total;
+	sector_t seek_mean;
+
+	struct list_head queue_list;
+
+	void (*dtor)(struct io_context *); /* destructor */
+	void (*exit)(struct io_context *); /* called on task exit */
+};
+
+/*
+ * This is the per-process I/O subsystem state.  It is refcounted and
+ * kmalloc'ed. Currently all fields are modified in process io context
+ * (apart from the atomic refcount), so require no locking.
+ */
+struct io_context {
+	atomic_t refcount;
+	struct task_struct *task;
+
+	unsigned short ioprio;
+	unsigned short ioprio_changed;
+
+	/*
+	 * For request batching
+	 */
+	unsigned long last_waited; /* Time last woken after wait for request */
+	int nr_batch_requests;     /* Number of requests left in the batch */
+
+	struct as_io_context *aic;
+	struct rb_root cic_root;
+	void *ioc_data;
+};
+
+#endif
diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index baf2938..2a3bb1b 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -2,6 +2,7 @@
 #define IOPRIO_H
 
 #include <linux/sched.h>
+#include <linux/iocontext.h>
 
 /*
  * Gives us 8 prio classes with 13-bits of data for each class
@@ -45,18 +46,18 @@ enum {
  * the cpu scheduler nice value to an io priority
  */
 #define IOPRIO_NORM	(4)
-static inline int task_ioprio(struct task_struct *task)
+static inline int task_ioprio(struct io_context *ioc)
 {
-	if (ioprio_valid(task->ioprio))
-		return IOPRIO_PRIO_DATA(task->ioprio);
+	if (ioprio_valid(ioc->ioprio))
+		return IOPRIO_PRIO_DATA(ioc->ioprio);
 
 	return IOPRIO_NORM;
 }
 
-static inline int task_ioprio_class(struct task_struct *task)
+static inline int task_ioprio_class(struct io_context *ioc)
 {
-	if (ioprio_valid(task->ioprio))
-		return IOPRIO_PRIO_CLASS(task->ioprio);
+	if (ioprio_valid(ioc->ioprio))
+		return IOPRIO_PRIO_CLASS(ioc->ioprio);
 
 	return IOPRIO_CLASS_BE;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cc14656..638250c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -939,7 +939,6 @@ struct task_struct {
 	struct hlist_head preempt_notifiers;
 #endif
 
-	unsigned short ioprio;
 	/*
 	 * fpu_counter contains the number of consecutive context switches
 	 * that the FPU is used. If this is over a threshold, the lazy fpu
diff --git a/kernel/fork.c b/kernel/fork.c
index 8dd8ff2..9961fb7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -51,6 +51,7 @@
 #include <linux/random.h>
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
+#include <linux/blkdev.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -791,6 +792,25 @@ out:
 	return error;
 }
 
+static int copy_io(struct task_struct *tsk)
+{
+	struct io_context *ioc = current->io_context;
+
+	if (!ioc)
+		return 0;
+
+	if (ioprio_valid(ioc->ioprio)) {
+		tsk->io_context = alloc_io_context(GFP_KERNEL, -1);
+		if (unlikely(!tsk->io_context))
+			return -ENOMEM;
+
+		tsk->io_context->task = tsk;
+		tsk->io_context->ioprio = ioc->ioprio;
+	}
+
+	return 0;
+}
+
 /*
  *	Helper to unshare the files of the current task.
  *	We don't want to expose copy_files internals to
@@ -1147,15 +1167,17 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_mm;
 	if ((retval = copy_namespaces(clone_flags, p)))
 		goto bad_fork_cleanup_keys;
+	if ((retval = copy_io(p)))
+		goto bad_fork_cleanup_namespaces;
 	retval = copy_thread(0, clone_flags, stack_start, stack_size, p, regs);
 	if (retval)
-		goto bad_fork_cleanup_namespaces;
+		goto bad_fork_cleanup_io;
 
 	if (pid != &init_struct_pid) {
 		retval = -ENOMEM;
 		pid = alloc_pid(task_active_pid_ns(p));
 		if (!pid)
-			goto bad_fork_cleanup_namespaces;
+			goto bad_fork_cleanup_io;
 
 		if (clone_flags & CLONE_NEWPID) {
 			retval = pid_ns_prepare_proc(task_active_pid_ns(p));
@@ -1224,9 +1246,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	/* Need tasklist lock for parent etc handling! */
 	write_lock_irq(&tasklist_lock);
 
-	/* for sys_ioprio_set(IOPRIO_WHO_PGRP) */
-	p->ioprio = current->ioprio;
-
 	/*
 	 * The task hasn't been attached yet, so its cpus_allowed mask will
 	 * not be changed, nor will its assigned CPU.
@@ -1317,6 +1336,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
+bad_fork_cleanup_io:
+	put_io_context(p->io_context);
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
 bad_fork_cleanup_keys:
-- 
1.5.4.rc2.84.gf85fd


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZJ2IzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZJ2IzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZJ2Iy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:54:59 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55863 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZJ2Iy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:54:57 -0400
Date: Thu, 29 Oct 2009 09:55:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: jack@suse.cz, wfg@mail.ustc.edu.cn, chris.mason@oracle.com
Subject: writeback tracing
Message-ID: <20091029085501.GA10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a first stab at providing some general writeback tracing
infrastructure. I'd like some input on whatever trace points you think
would be interesting. The goal would be to ensure that we never again
have to do debug printk() patches to trace this stuff.

Patch is against latest -git.

commit 607eadcebf9f137ec445cb9883312c821b37a3a7
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Thu Oct 29 10:54:00 2009 +0100

    writeback: initial tracing support
    
    Trace queue/sched/exec parts of the writeback loop.
    
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9d5360c..056dd07 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -25,7 +25,9 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <linux/ftrace.h>
 #include "internal.h"
+#include <trace/events/writeback.h>
 
 #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
 
@@ -34,33 +36,6 @@
  */
 int nr_pdflush_threads;
 
-/*
- * Passed into wb_writeback(), essentially a subset of writeback_control
- */
-struct wb_writeback_args {
-	long nr_pages;
-	struct super_block *sb;
-	enum writeback_sync_modes sync_mode;
-	int for_kupdate:1;
-	int range_cyclic:1;
-	int for_background:1;
-};
-
-/*
- * Work items for the bdi_writeback threads
- */
-struct bdi_work {
-	struct list_head list;		/* pending work list */
-	struct rcu_head rcu_head;	/* for RCU free/clear of work */
-
-	unsigned long seen;		/* threads that have seen this work */
-	atomic_t pending;		/* number of threads still to do work */
-
-	struct wb_writeback_args args;	/* writeback arguments */
-
-	unsigned long state;		/* flag bits, see WS_* */
-};
-
 enum {
 	WS_USED_B = 0,
 	WS_ONSTACK_B,
@@ -135,6 +110,8 @@ static void wb_work_complete(struct bdi_work *work)
 
 static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
 {
+	trace_writeback_clear(work);
+
 	/*
 	 * The caller has retrieved the work arguments from this work,
 	 * drop our reference. If this is the last ref, delete and free it
@@ -170,12 +147,16 @@ static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
 	 * If the default thread isn't there, make sure we add it. When
 	 * it gets created and wakes up, we'll run this work.
 	 */
-	if (unlikely(list_empty_careful(&bdi->wb_list)))
+	if (unlikely(list_empty_careful(&bdi->wb_list))) {
+		trace_writeback_sched(bdi, work, "default");
 		wake_up_process(default_backing_dev_info.wb.task);
-	else {
+	} else {
 		struct bdi_writeback *wb = &bdi->wb;
+		struct task_struct *task = wb->task;
 
-		if (wb->task)
+		trace_writeback_sched(bdi, work, task ? "task" : "notask");
+
+		if (task)
 			wake_up_process(wb->task);
 	}
 }
@@ -202,6 +183,7 @@ static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (work) {
 		bdi_work_init(work, args);
+		trace_writeback_queue(bdi, args);
 		bdi_queue_work(bdi, work);
 	} else {
 		struct bdi_writeback *wb = &bdi->wb;
@@ -235,6 +217,7 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
 	bdi_work_init(&work, &args);
 	work.state |= WS_ONSTACK;
 
+	trace_writeback_queue(bdi, &args);
 	bdi_queue_work(bdi, &work);
 	bdi_wait_on_work_clear(&work);
 }
@@ -901,6 +884,8 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 		if (force_wait)
 			work->args.sync_mode = args.sync_mode = WB_SYNC_ALL;
 
+		trace_writeback_exec(work);
+
 		/*
 		 * If this isn't a data integrity operation, just notify
 		 * that we have seen this work and we are now starting it.
@@ -936,9 +921,13 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 	unsigned long wait_jiffies = -1UL;
 	long pages_written;
 
+	trace_writeback_thread_start(1);
+
 	while (!kthread_should_stop()) {
 		pages_written = wb_do_writeback(wb, 0);
 
+		trace_writeback_pages_written(pages_written);
+
 		if (pages_written)
 			last_active = jiffies;
 		else if (wait_jiffies != -1UL) {
@@ -959,6 +948,8 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 		try_to_freeze();
 	}
 
+	trace_writeback_thread_start(0);
+
 	return 0;
 }
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 66ebddc..b12a077 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -22,6 +22,33 @@ enum writeback_sync_modes {
 };
 
 /*
+ * Passed into wb_writeback(), essentially a subset of writeback_control
+ */
+struct wb_writeback_args {
+	long nr_pages;
+	struct super_block *sb;
+	enum writeback_sync_modes sync_mode;
+	int for_kupdate:1;
+	int range_cyclic:1;
+	int for_background:1;
+};
+
+/*
+ * Work items for the bdi_writeback threads
+ */
+struct bdi_work {
+	struct list_head list;		/* pending work list */
+	struct rcu_head rcu_head;	/* for RCU free/clear of work */
+
+	unsigned long seen;		/* threads that have seen this work */
+	atomic_t pending;		/* number of threads still to do work */
+
+	struct wb_writeback_args args;	/* writeback arguments */
+
+	unsigned long state;		/* flag bits, see WS_* */
+};
+
+/*
  * A control structure which tells the writeback code what to do.  These are
  * always on the stack, and hence need no locking.  They are always initialised
  * in a manner such that unspecified fields are set to zero.
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
new file mode 100644
index 0000000..d58c75b
--- /dev/null
+++ b/include/trace/events/writeback.h
@@ -0,0 +1,172 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM writeback
+
+#if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_WRITEBACK_H
+
+#include <linux/backing-dev.h>
+#include <linux/writeback.h>
+
+TRACE_EVENT(writeback_queue,
+
+	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_args *args),
+
+	TP_ARGS(bdi, args),
+
+	TP_STRUCT__entry(
+		__array(char,		name,		16)
+		__field(long,		nr_pages)
+		__field(int,		sb)
+		__field(int,		sync_mode)
+		__field(int,		for_kupdate)
+		__field(int,		range_cyclic)
+		__field(int,		for_background)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name, dev_name(bdi->dev), 16);
+		__entry->nr_pages	= args->nr_pages;
+		__entry->sb		= !!args->sb;
+		__entry->for_kupdate	= args->for_kupdate;
+		__entry->range_cyclic	= args->range_cyclic;
+		__entry->for_background	= args->for_background;
+	),
+
+	TP_printk("%s: pages=%ld, sb=%d, kupdate=%d, range_cyclic=%d "
+		  "for_background=%d", __entry->name, __entry->nr_pages,
+			__entry->sb, __entry->for_kupdate,
+			__entry->range_cyclic, __entry->for_background)
+);
+
+TRACE_EVENT(writeback_sched,
+
+	TP_PROTO(struct backing_dev_info *bdi, struct bdi_work *work,
+		 const char *msg),
+
+	TP_ARGS(bdi, work, msg),
+
+	TP_STRUCT__entry(
+		__array(char,			name,		16)
+		__field(unsigned int,		work)
+		__array(char,			task,		8)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name, dev_name(bdi->dev), 16);
+		__entry->work = (unsigned long) work & 0xffff;
+		snprintf(__entry->task, 8, "%s", msg);
+	),
+
+	TP_printk("work=%x, task=%s", __entry->work, __entry->task)
+);
+
+TRACE_EVENT(writeback_exec,
+
+	TP_PROTO(struct bdi_work *work),
+
+	TP_ARGS(work),
+
+	TP_STRUCT__entry(
+		__field(unsigned int,	work)
+		__field(long,		nr_pages)
+		__field(int,		sb)
+		__field(int,		sync_mode)
+		__field(int,		for_kupdate)
+		__field(int,		range_cyclic)
+		__field(int,		for_background)
+	),
+
+	TP_fast_assign(
+		__entry->work		= (unsigned long) work & 0xffff;
+		__entry->nr_pages	= work->args.nr_pages;
+		__entry->sb		= !!work->args.sb;
+		__entry->for_kupdate	= work->args.for_kupdate;
+		__entry->range_cyclic	= work->args.range_cyclic;
+		__entry->for_background	= work->args.for_background;
+
+	),
+
+	TP_printk("work=%x pages=%ld, sb=%d, kupdate=%d, range_cyclic=%d"
+		  " for_background=%d", __entry->work,
+			__entry->nr_pages, __entry->sb, __entry->for_kupdate,
+			__entry->range_cyclic, __entry->for_background)
+);
+
+TRACE_EVENT(writeback_clear,
+
+	TP_PROTO(struct bdi_work *work),
+
+	TP_ARGS(work),
+
+	TP_STRUCT__entry(
+		__field(struct bdi_work *,	work)
+		__field(int,			refs)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+		__entry->refs		= atomic_read(&work->pending);
+	),
+
+	TP_printk("work=%p, refs=%d", __entry->work, __entry->refs)
+);
+
+TRACE_EVENT(writeback_pages_written,
+
+	TP_PROTO(long pages_written),
+
+	TP_ARGS(pages_written),
+
+	TP_STRUCT__entry(
+		__field(long,		pages)
+	),
+
+	TP_fast_assign(
+		__entry->pages		= pages_written;
+	),
+
+	TP_printk("%ld", __entry->pages)
+);
+
+
+TRACE_EVENT(writeback_thread_start,
+
+	TP_PROTO(int start),
+
+	TP_ARGS(start),
+
+	TP_STRUCT__entry(
+		__field(int,	start)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+	),
+
+	TP_printk("%s", __entry->start ? "started" : "exited")
+);
+
+TRACE_EVENT(writeback_bdi_register,
+
+	TP_PROTO(const char *name, int start),
+
+	TP_ARGS(name, start),
+
+	TP_STRUCT__entry(
+		__array(char,	name,		16)
+		__field(int,	start)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name, name, 16);
+		__entry->start = start;
+	),
+
+	TP_printk("%s: %s", __entry->name,
+			__entry->start ? "registered" : "unregistered")
+);
+
+#endif /* _TRACE_WRITEBACK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 5a37e20..4f53a6d 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -11,6 +11,9 @@
 #include <linux/writeback.h>
 #include <linux/device.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/writeback.h>
+
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
 }
@@ -570,6 +573,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 
 	bdi_debug_register(bdi, dev_name(dev));
 	set_bit(BDI_registered, &bdi->state);
+	trace_writeback_bdi_register(dev_name(dev), 1);
 exit:
 	return ret;
 }
@@ -613,6 +617,7 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
+		trace_writeback_bdi_register(dev_name(bdi->dev), 0);
 		if (!bdi_cap_flush_forker(bdi))
 			bdi_wb_shutdown(bdi);
 		bdi_debug_unregister(bdi);

-- 
Jens Axboe


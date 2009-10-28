Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbZJ1Jzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbZJ1Jzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZJ1Jze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:55:34 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41954 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZJ1Jzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:55:33 -0400
Date: Wed, 28 Oct 2009 10:55:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32-rc5: surprise removal of USB mass storage, and whole
	system goes to hell
Message-ID: <20091028095537.GD10727@kernel.dk>
References: <20091027211951.GA21967@elf.ucw.cz> <alpine.LRH.2.00.0910280212510.25075@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0910280212510.25075@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28 2009, Jiri Kosina wrote:
> On Tue, 27 Oct 2009, Pavel Machek wrote:
> 
> > I did remove one harddrive w/o unmounting, and now the whole system
> > becomes unusable :-(: (whole dmesg attached).
> > 
> > Stuff like "sync" hangs, and I'll probably have to reboot soon.
> 
> From the traces it seems that it might be related to the new per-bdi 
> writeback stuff ... adding Jens to CC.

It looks like the IO isn't being errored on the device side, or perhaps
it just got stuck. Pavel, if you can reproduce, please try with this
tracing patch. Apply it, and then do something ala:

# cd /sys/kernel/debug/tracing
# echo 0 events/enable
# echo 1 events/writeback/enable
# echo 0 > trace

then start the act of reproducing, and finally

# cat trace > /tmp/foo

and send the output of foo here. Thanks!

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9d5360c..2643a4f 100644
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
+		trace_writeback_sched(work, "default");
 		wake_up_process(default_backing_dev_info.wb.task);
-	else {
+	} else {
 		struct bdi_writeback *wb = &bdi->wb;
+		struct task_struct *task = wb->task;
 
-		if (wb->task)
+		trace_writeback_sched(work, task ? "task" : "notask");
+
+		if (task)
 			wake_up_process(wb->task);
 	}
 }
@@ -202,6 +183,7 @@ static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (work) {
 		bdi_work_init(work, args);
+		trace_writeback_queue(args);
 		bdi_queue_work(bdi, work);
 	} else {
 		struct bdi_writeback *wb = &bdi->wb;
@@ -235,6 +217,7 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
 	bdi_work_init(&work, &args);
 	work.state |= WS_ONSTACK;
 
+	trace_writeback_queue(&args);
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
 
+	trace_writeback_thread_start_stop(1);
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
 
+	trace_writeback_thread_start_stop(0);
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
index 0000000..0f951de
--- /dev/null
+++ b/include/trace/events/writeback.h
@@ -0,0 +1,147 @@
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
+	TP_PROTO(struct wb_writeback_args *args),
+
+	TP_ARGS(args),
+
+	TP_STRUCT__entry(
+		__field(long,		nr_pages)
+		__field(int,		sb)
+		__field(int,		sync_mode)
+		__field(int,		for_kupdate)
+		__field(int,		range_cyclic)
+		__field(int,		for_background)
+	),
+
+	TP_fast_assign(
+		__entry->nr_pages	= args->nr_pages;
+		__entry->sb		= !!args->sb;
+		__entry->for_kupdate	= args->for_kupdate;
+		__entry->range_cyclic	= args->range_cyclic;
+		__entry->for_background	= args->for_background;
+	),
+
+	TP_printk("pages=%ld, sb=%d, kupdate=%d, range_cyclic=%d "
+		  "for_background=%d", __entry->nr_pages, __entry->sb,
+			__entry->for_kupdate, __entry->range_cyclic,
+			__entry->for_background)
+);
+
+TRACE_EVENT(writeback_sched,
+
+	TP_PROTO(struct bdi_work *work, const char *msg),
+
+	TP_ARGS(work, msg),
+
+	TP_STRUCT__entry(
+		__field(struct bdi_work *,	work)
+		__array(char,			task,		8)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+		snprintf(__entry->task, 8, "%s", msg);
+	),
+
+	TP_printk("work=%p, task=%s", __entry->work, __entry->task)
+);
+
+TRACE_EVENT(writeback_exec,
+
+	TP_PROTO(struct bdi_work *work),
+
+	TP_ARGS(work),
+
+	TP_STRUCT__entry(
+		__field(struct bdi_work *,	work)
+		__field(long,		nr_pages)
+		__field(int,		sb)
+		__field(int,		sync_mode)
+		__field(int,		for_kupdate)
+		__field(int,		range_cyclic)
+		__field(int,		for_background)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+		__entry->nr_pages	= work->args.nr_pages;
+		__entry->sb		= !!work->args.sb;
+		__entry->for_kupdate	= work->args.for_kupdate;
+		__entry->range_cyclic	= work->args.range_cyclic;
+		__entry->for_background	= work->args.for_background;
+
+	),
+
+	TP_printk("work=%p pages=%ld, sb=%d, kupdate=%d, range_cyclic=%d"
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
+TRACE_EVENT(writeback_thread_start_stop,
+
+	TP_PROTO(int start),
+
+	TP_ARGS(start),
+
+	TP_STRUCT__entry(
+		__field(int, start)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+	),
+
+	TP_printk("%s", __entry->start ? "started" : "exited")
+);
+
+#endif /* _TRACE_WRITEBACK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 5a37e20..b951e0a 100644
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

-- 
Jens Axboe


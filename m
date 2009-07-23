Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZGWTWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZGWTWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZGWTWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:22:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48190 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbZGWTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:13 -0400
Message-Id: <20090723191956.792214119@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:44 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/13] perf_counter: full task tracing
Content-Disposition: inline; filename=perf-event-exit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to distinguish between no samples due to
inactivity and no samples due to task ended, Arjan asked for
PERF_EVENT_EXIT events.

This patch (again) changes the PERF_EVENT_FORK to be emitted on every
clone, and adds PERF_EVENT_EXIT to be emitted on task exit, after the
task's counters have been closed.

This task tracing is controlled through: attr.comm || attr.mmap and
through the new attr.task field.

Suggested-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    5 +-
 kernel/fork.c                |    4 -
 kernel/perf_counter.c        |   87 ++++++++++++++++++++++++++++---------------
 3 files changed, 63 insertions(+), 33 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -181,8 +181,9 @@ struct perf_counter_attr {
 				freq           :  1, /* use freq, not period  */
 				inherit_stat   :  1, /* per task counts       */
 				enable_on_exec :  1, /* next exec enables     */
+				task           :  1, /* trace fork/exit       */
 
-				__reserved_1   : 51;
+				__reserved_1   : 50;
 
 	__u32			wakeup_events;	/* wakeup every n events */
 	__u32			__reserved_2;
@@ -323,9 +324,11 @@ enum perf_event_type {
 	 * struct {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
+	 *	u32				tid, ptid;
 	 * };
 	 */
 	PERF_EVENT_FORK			= 7,
+	PERF_EVENT_EXIT			= 4,
 
 	/*
 	 * struct {
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1268,6 +1268,7 @@ static struct task_struct *copy_process(
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
+	perf_counter_fork(p);
 	return p;
 
 bad_fork_free_pid:
@@ -1409,9 +1410,6 @@ long do_fork(unsigned long clone_flags,
 			init_completion(&vfork);
 		}
 
-		if (!(clone_flags & CLONE_THREAD))
-			perf_counter_fork(p);
-
 		audit_finish_fork(p);
 		tracehook_report_clone(regs, clone_flags, nr, p);
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -42,6 +42,7 @@ static int perf_overcommit __read_mostly
 static atomic_t nr_counters __read_mostly;
 static atomic_t nr_mmap_counters __read_mostly;
 static atomic_t nr_comm_counters __read_mostly;
+static atomic_t nr_task_counters __read_mostly;
 
 /*
  * perf counter paranoia level:
@@ -1654,6 +1655,8 @@ static void free_counter(struct perf_cou
 			atomic_dec(&nr_mmap_counters);
 		if (counter->attr.comm)
 			atomic_dec(&nr_comm_counters);
+		if (counter->attr.task)
+			atomic_dec(&nr_task_counters);
 	}
 
 	if (counter->destroy)
@@ -2819,10 +2822,12 @@ perf_counter_read_event(struct perf_coun
 }
 
 /*
- * fork tracking
+ * task tracking -- fork/exit
+ *
+ * enabled by: attr.comm | attr.mmap | attr.task
  */
 
-struct perf_fork_event {
+struct perf_task_event {
 	struct task_struct	*task;
 
 	struct {
@@ -2830,37 +2835,42 @@ struct perf_fork_event {
 
 		u32				pid;
 		u32				ppid;
+		u32				tid;
+		u32				ptid;
 	} event;
 };
 
-static void perf_counter_fork_output(struct perf_counter *counter,
-				     struct perf_fork_event *fork_event)
+static void perf_counter_task_output(struct perf_counter *counter,
+				     struct perf_task_event *task_event)
 {
 	struct perf_output_handle handle;
-	int size = fork_event->event.header.size;
-	struct task_struct *task = fork_event->task;
+	int size = task_event->event.header.size;
+	struct task_struct *task = task_event->task;
 	int ret = perf_output_begin(&handle, counter, size, 0, 0);
 
 	if (ret)
 		return;
 
-	fork_event->event.pid = perf_counter_pid(counter, task);
-	fork_event->event.ppid = perf_counter_pid(counter, task->real_parent);
+	task_event->event.pid = perf_counter_pid(counter, task);
+	task_event->event.ppid = perf_counter_pid(counter, task->real_parent);
 
-	perf_output_put(&handle, fork_event->event);
+	task_event->event.tid = perf_counter_tid(counter, task);
+	task_event->event.ptid = perf_counter_tid(counter, task->real_parent);
+
+	perf_output_put(&handle, task_event->event);
 	perf_output_end(&handle);
 }
 
-static int perf_counter_fork_match(struct perf_counter *counter)
+static int perf_counter_task_match(struct perf_counter *counter)
 {
-	if (counter->attr.comm || counter->attr.mmap)
+	if (counter->attr.comm || counter->attr.mmap || counter->attr.task)
 		return 1;
 
 	return 0;
 }
 
-static void perf_counter_fork_ctx(struct perf_counter_context *ctx,
-				  struct perf_fork_event *fork_event)
+static void perf_counter_task_ctx(struct perf_counter_context *ctx,
+				  struct perf_task_event *task_event)
 {
 	struct perf_counter *counter;
 
@@ -2869,19 +2879,19 @@ static void perf_counter_fork_ctx(struct
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
-		if (perf_counter_fork_match(counter))
-			perf_counter_fork_output(counter, fork_event);
+		if (perf_counter_task_match(counter))
+			perf_counter_task_output(counter, task_event);
 	}
 	rcu_read_unlock();
 }
 
-static void perf_counter_fork_event(struct perf_fork_event *fork_event)
+static void perf_counter_task_event(struct perf_task_event *task_event)
 {
 	struct perf_cpu_context *cpuctx;
 	struct perf_counter_context *ctx;
 
 	cpuctx = &get_cpu_var(perf_cpu_context);
-	perf_counter_fork_ctx(&cpuctx->ctx, fork_event);
+	perf_counter_task_ctx(&cpuctx->ctx, task_event);
 	put_cpu_var(perf_cpu_context);
 
 	rcu_read_lock();
@@ -2891,32 +2901,40 @@ static void perf_counter_fork_event(stru
 	 */
 	ctx = rcu_dereference(current->perf_counter_ctxp);
 	if (ctx)
-		perf_counter_fork_ctx(ctx, fork_event);
+		perf_counter_task_ctx(ctx, task_event);
 	rcu_read_unlock();
 }
 
-void perf_counter_fork(struct task_struct *task)
+static void perf_counter_task(struct task_struct *task, int new)
 {
-	struct perf_fork_event fork_event;
+	struct perf_task_event task_event;
 
 	if (!atomic_read(&nr_comm_counters) &&
-	    !atomic_read(&nr_mmap_counters))
+	    !atomic_read(&nr_mmap_counters) &&
+	    !atomic_read(&nr_task_counters))
 		return;
 
-	fork_event = (struct perf_fork_event){
+	task_event = (struct perf_task_event){
 		.task	= task,
 		.event  = {
 			.header = {
-				.type = PERF_EVENT_FORK,
+				.type = new ? PERF_EVENT_FORK : PERF_EVENT_EXIT,
 				.misc = 0,
-				.size = sizeof(fork_event.event),
+				.size = sizeof(task_event.event),
 			},
 			/* .pid  */
 			/* .ppid */
+			/* .tid  */
+			/* .ptid */
 		},
 	};
 
-	perf_counter_fork_event(&fork_event);
+	perf_counter_task_event(&task_event);
+}
+
+void perf_counter_fork(struct task_struct *task)
+{
+	perf_counter_task(task, 1);
 }
 
 /*
@@ -3899,6 +3917,8 @@ done:
 			atomic_inc(&nr_mmap_counters);
 		if (counter->attr.comm)
 			atomic_inc(&nr_comm_counters);
+		if (counter->attr.task)
+			atomic_inc(&nr_task_counters);
 	}
 
 	return counter;
@@ -4260,8 +4280,10 @@ void perf_counter_exit_task(struct task_
 	struct perf_counter_context *child_ctx;
 	unsigned long flags;
 
-	if (likely(!child->perf_counter_ctxp))
+	if (likely(!child->perf_counter_ctxp)) {
+		perf_counter_task(child, 0);
 		return;
+	}
 
 	local_irq_save(flags);
 	/*
@@ -4279,15 +4301,22 @@ void perf_counter_exit_task(struct task_
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	spin_lock(&child_ctx->lock);
-	child->perf_counter_ctxp = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get
 	 * swapped to another process while we're removing all
 	 * the counters from it.
 	 */
 	unclone_ctx(child_ctx);
-	spin_unlock(&child_ctx->lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&child_ctx->lock, flags);
+
+	/*
+	 * Report the task dead after unscheduling the counters so that we
+	 * won't get any samples after PERF_EVENT_EXIT. We can however still
+	 * get a few PERF_EVENT_READ events.
+	 */
+	perf_counter_task(child, 0);
+
+	child->perf_counter_ctxp = NULL;
 
 	/*
 	 * We can recurse on the same lock type through:

-- 


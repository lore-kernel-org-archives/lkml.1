Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZETM3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZETM3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbZETM2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:28:50 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:38981 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbZETM2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:28:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18963.63352.489273.92145@cargo.ozlabs.ibm.com>
Date: Wed, 20 May 2009 22:28:40 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH] perf_counter: dynamically allocate tasks' perf_counter_context struct
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces the struct perf_counter_context in the task_struct with
a pointer to a dynamically allocated perf_counter_context struct.  The
main reason for doing is this is to allow us to transfer a
perf_counter_context from one task to another when we do lazy PMU
switching in a later patch.

This has a few side-benefits: the task_struct becomes a little smaller,
we save some memory because only tasks that have perf_counters attached
get a perf_counter_context allocated for them, and we can remove the
inclusion of <linux/perf_counter.h> in sched.h, meaning that we don't
end up recompiling nearly everything whenever perf_counter.h changes.

As well as the pointer to the perf_counter_context in the task_struct,
this adds a mutex to provide mutual exclusion between writers of the
pointer.

The perf_counter_context structures are reference-counted and freed
when the last reference is dropped.  A context can have references
from its task, counters and the perf_cpu_context for the cpu where
the task is running.  Counters can outlive the task so it is possible
that a context will be freed well after its task has exited.

This removes the task pointer from the perf_counter struct.  The task
pointer was not used anywhere and would make it harder to move a
context from one task to another.  Anything that needed to know which
task a counter was attached to was already using counter->ctx->task.

The __perf_counter_init_context function moves up in perf_counter.c
so that it can be called from find_get_context, and now initializes
the refcount, but is otherwise unchanged.

We were potentially calling list_del_counter twice: once from
__perf_counter_exit_task when the task exits and once from
__perf_counter_remove_from_context when the counter's fd gets closed.
This adds a check in list_del_counter so it doesn't do anything if
the counter has already been removed from the lists.

Since perf_counter_task_sched_in doesn't do anything if the task doesn't
have a context, and leaves cpuctx->task_ctx = NULL, this adds code to
__perf_install_in_context to set cpuctx->task_ctx if necessary, i.e. in
the case where the current task adds the first counter to itself and
thus creates a context for itself.

This also adds similar code to __perf_counter_enable to handle a
similar situation which can arise when the counters have been disabled
using prctl; that also leaves cpuctx->task_ctx = NULL.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/x86/kernel/apic/apic.c  |    1 +
 include/linux/init_task.h    |    8 +--
 include/linux/perf_counter.h |    5 +-
 include/linux/sched.h        |    7 +-
 kernel/exit.c                |    3 +-
 kernel/fork.c                |    1 +
 kernel/perf_counter.c        |  180 ++++++++++++++++++++++++++++++------------
 7 files changed, 141 insertions(+), 64 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e9021a9..b4f6440 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -14,6 +14,7 @@
  *	Mikael Pettersson	:	PM converted to driver model.
  */
 
+#include <linux/perf_counter.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
 #include <linux/acpi_pmtmr.h>
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 503afaa..2ce8efc 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -110,12 +110,8 @@ extern struct cred init_cred;
 
 #ifdef CONFIG_PERF_COUNTERS
 # define INIT_PERF_COUNTERS(tsk)					\
-	.perf_counter_ctx.counter_list =				\
-		LIST_HEAD_INIT(tsk.perf_counter_ctx.counter_list),	\
-	.perf_counter_ctx.event_list =					\
-		LIST_HEAD_INIT(tsk.perf_counter_ctx.event_list),	\
-	.perf_counter_ctx.lock =					\
-		__SPIN_LOCK_UNLOCKED(tsk.perf_counter_ctx.lock),
+	.perf_counter_mutex =						\
+		__MUTEX_INITIALIZER(tsk.perf_counter_mutex),
 #else
 # define INIT_PERF_COUNTERS(tsk)
 #endif
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 13cb2fb..312d271 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -441,7 +441,6 @@ struct perf_counter {
 	struct hw_perf_counter		hw;
 
 	struct perf_counter_context	*ctx;
-	struct task_struct		*task;
 	struct file			*filp;
 
 	struct perf_counter		*parent;
@@ -490,7 +489,6 @@ struct perf_counter {
  * Used as a container for task counters and CPU counters as well:
  */
 struct perf_counter_context {
-#ifdef CONFIG_PERF_COUNTERS
 	/*
 	 * Protect the states of the counters in the list,
 	 * nr_active, and the list:
@@ -516,7 +514,8 @@ struct perf_counter_context {
 	 */
 	u64			time;
 	u64			timestamp;
-#endif
+
+	atomic_t		refcount;
 };
 
 /**
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ff59d12..904e239 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -71,7 +71,6 @@ struct sched_param {
 #include <linux/path.h>
 #include <linux/compiler.h>
 #include <linux/completion.h>
-#include <linux/perf_counter.h>
 #include <linux/pid.h>
 #include <linux/percpu.h>
 #include <linux/topology.h>
@@ -99,6 +98,7 @@ struct robust_list_head;
 struct bio;
 struct bts_tracer;
 struct fs_struct;
+struct perf_counter_context;
 
 /*
  * List of flags we want to share for kernel threads,
@@ -1387,7 +1387,10 @@ struct task_struct {
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
 #endif
-	struct perf_counter_context perf_counter_ctx;
+#ifdef CONFIG_PERF_COUNTERS
+	struct perf_counter_context *perf_counter_ctx;
+	struct mutex perf_counter_mutex;
+#endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *mempolicy;
 	short il_next;
diff --git a/kernel/exit.c b/kernel/exit.c
index f9dfedd..e8335cc 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -48,6 +48,7 @@
 #include <linux/tracehook.h>
 #include <linux/fs_struct.h>
 #include <linux/init_task.h>
+#include <linux/perf_counter.h>
 #include <trace/sched.h>
 
 #include <asm/uaccess.h>
@@ -159,7 +160,7 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
 
 #ifdef CONFIG_PERF_COUNTERS
-	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
+	WARN_ON_ONCE(tsk->perf_counter_ctx);
 #endif
 	trace_sched_process_free(tsk);
 	put_task_struct(tsk);
diff --git a/kernel/fork.c b/kernel/fork.c
index d32fef4..e72a09f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -63,6 +63,7 @@
 #include <linux/fs_struct.h>
 #include <trace/sched.h>
 #include <linux/magic.h>
+#include <linux/perf_counter.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 4d8f973..fa7aa90 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -118,11 +118,17 @@ list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	ctx->nr_counters++;
 }
 
+/*
+ * Remove a counter from the lists for its context.
+ * Must be called with counter->mutex and ctx->mutex held.
+ */
 static void
 list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 {
 	struct perf_counter *sibling, *tmp;
 
+	if (list_empty(&counter->list_entry))
+		return;
 	ctx->nr_counters--;
 
 	list_del_init(&counter->list_entry);
@@ -211,8 +217,6 @@ static void __perf_counter_remove_from_context(void *info)
 
 	counter_sched_out(counter, cpuctx, ctx);
 
-	counter->task = NULL;
-
 	/*
 	 * Protect the list operation against NMI by disabling the
 	 * counters on a global level. NOP for non NMI based counters.
@@ -279,7 +283,6 @@ retry:
 	 */
 	if (!list_empty(&counter->list_entry)) {
 		list_del_counter(counter, ctx);
-		counter->task = NULL;
 	}
 	spin_unlock_irq(&ctx->lock);
 }
@@ -568,11 +571,17 @@ static void __perf_install_in_context(void *info)
 	 * If this is a task context, we need to check whether it is
 	 * the current task context of this cpu. If not it has been
 	 * scheduled out before the smp call arrived.
+	 * Or possibly this is the right context but it isn't
+	 * on this cpu because it had no counters.
 	 */
-	if (ctx->task && cpuctx->task_ctx != ctx)
-		return;
+	if (ctx->task && cpuctx->task_ctx != ctx) {
+		if (cpuctx->task_ctx || ctx->task != current)
+			return;
+		cpuctx->task_ctx = ctx;
+	}
 
 	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->is_active = 1;
 	update_context_time(ctx);
 
 	/*
@@ -653,7 +662,6 @@ perf_install_in_context(struct perf_counter_context *ctx,
 		return;
 	}
 
-	counter->task = task;
 retry:
 	task_oncpu_function_call(task, __perf_install_in_context,
 				 counter);
@@ -693,10 +701,14 @@ static void __perf_counter_enable(void *info)
 	 * If this is a per-task counter, need to check whether this
 	 * counter's task is the current task on this cpu.
 	 */
-	if (ctx->task && cpuctx->task_ctx != ctx)
-		return;
+	if (ctx->task && cpuctx->task_ctx != ctx) {
+		if (cpuctx->task_ctx || ctx->task != current)
+			return;
+		cpuctx->task_ctx = ctx;
+	}
 
 	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->is_active = 1;
 	update_context_time(ctx);
 
 	counter->prev_state = counter->state;
@@ -834,6 +846,17 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 	spin_unlock(&ctx->lock);
 }
 
+static void get_ctx(struct perf_counter_context *ctx)
+{
+	atomic_inc(&ctx->refcount);
+}
+
+static void put_ctx(struct perf_counter_context *ctx)
+{
+	if (atomic_dec_and_test(&ctx->refcount))
+		kfree(ctx);
+}
+
 /*
  * Called from scheduler to remove the counters of the current task,
  * with interrupts disabled.
@@ -848,10 +871,10 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 void perf_counter_task_sched_out(struct task_struct *task, int cpu)
 {
 	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
-	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+	struct perf_counter_context *ctx = task->perf_counter_ctx;
 	struct pt_regs *regs;
 
-	if (likely(!cpuctx->task_ctx))
+	if (likely(!ctx || !cpuctx->task_ctx))
 		return;
 
 	update_context_time(ctx);
@@ -861,6 +884,7 @@ void perf_counter_task_sched_out(struct task_struct *task, int cpu)
 	__perf_counter_sched_out(ctx, cpuctx);
 
 	cpuctx->task_ctx = NULL;
+	put_ctx(ctx);
 }
 
 static void __perf_counter_task_sched_out(struct perf_counter_context *ctx)
@@ -869,6 +893,7 @@ static void __perf_counter_task_sched_out(struct perf_counter_context *ctx)
 
 	__perf_counter_sched_out(ctx, cpuctx);
 	cpuctx->task_ctx = NULL;
+	put_ctx(ctx);
 }
 
 static void perf_counter_cpu_sched_out(struct perf_cpu_context *cpuctx)
@@ -956,8 +981,11 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 void perf_counter_task_sched_in(struct task_struct *task, int cpu)
 {
 	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
-	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+	struct perf_counter_context *ctx = task->perf_counter_ctx;
 
+	if (likely(!ctx))
+		return;
+	get_ctx(ctx);
 	__perf_counter_sched_in(ctx, cpuctx, cpu);
 	cpuctx->task_ctx = ctx;
 }
@@ -972,11 +1000,11 @@ static void perf_counter_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
 int perf_counter_task_disable(void)
 {
 	struct task_struct *curr = current;
-	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter_context *ctx = curr->perf_counter_ctx;
 	struct perf_counter *counter;
 	unsigned long flags;
 
-	if (likely(!ctx->nr_counters))
+	if (!ctx || !ctx->nr_counters)
 		return 0;
 
 	local_irq_save(flags);
@@ -1007,12 +1035,12 @@ int perf_counter_task_disable(void)
 int perf_counter_task_enable(void)
 {
 	struct task_struct *curr = current;
-	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter_context *ctx = curr->perf_counter_ctx;
 	struct perf_counter *counter;
 	unsigned long flags;
 	int cpu;
 
-	if (likely(!ctx->nr_counters))
+	if (!ctx || !ctx->nr_counters)
 		return 0;
 
 	local_irq_save(flags);
@@ -1111,20 +1139,23 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 		return;
 
 	cpuctx = &per_cpu(perf_cpu_context, cpu);
-	ctx = &curr->perf_counter_ctx;
+	ctx = curr->perf_counter_ctx;
 
 	perf_adjust_freq(&cpuctx->ctx);
-	perf_adjust_freq(ctx);
+	if (ctx)
+		perf_adjust_freq(ctx);
 
 	perf_counter_cpu_sched_out(cpuctx);
-	__perf_counter_task_sched_out(ctx);
+	if (ctx)
+		__perf_counter_task_sched_out(ctx);
 
 	rotate_ctx(&cpuctx->ctx);
-	if (ctx->rr_allowed)
+	if (ctx && ctx->rr_allowed)
 		rotate_ctx(ctx);
 
 	perf_counter_cpu_sched_in(cpuctx, cpu);
-	perf_counter_task_sched_in(curr, cpu);
+	if (ctx)
+		perf_counter_task_sched_in(curr, cpu);
 }
 
 /*
@@ -1160,6 +1191,23 @@ static u64 perf_counter_read(struct perf_counter *counter)
 	return atomic64_read(&counter->count);
 }
 
+/*
+ * Initialize the perf_counter context in a task_struct:
+ */
+static void
+__perf_counter_init_context(struct perf_counter_context *ctx,
+			    struct task_struct *task)
+{
+	memset(ctx, 0, sizeof(*ctx));
+	spin_lock_init(&ctx->lock);
+	mutex_init(&ctx->mutex);
+	INIT_LIST_HEAD(&ctx->counter_list);
+	INIT_LIST_HEAD(&ctx->event_list);
+	atomic_set(&ctx->refcount, 1);
+	ctx->rr_allowed = 1;
+	ctx->task = task;
+}
+
 static void put_context(struct perf_counter_context *ctx)
 {
 	if (ctx->task)
@@ -1209,15 +1257,30 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 	if (!task)
 		return ERR_PTR(-ESRCH);
 
-	ctx = &task->perf_counter_ctx;
-	ctx->task = task;
-
 	/* Reuse ptrace permission checks for now. */
 	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
-		put_context(ctx);
+		put_task_struct(task);
 		return ERR_PTR(-EACCES);
 	}
 
+	ctx = task->perf_counter_ctx;
+	if (!ctx) {
+		ctx = kmalloc(sizeof(struct perf_counter_context), GFP_KERNEL);
+		if (!ctx) {
+			put_task_struct(task);
+			return ERR_PTR(-ENOMEM);
+		}
+		__perf_counter_init_context(ctx, task);
+		mutex_lock(&task->perf_counter_mutex);
+		if (!task->perf_counter_ctx) {
+			task->perf_counter_ctx = ctx;
+		} else {
+			kfree(ctx);
+			ctx = task->perf_counter_ctx;
+		}
+		mutex_unlock(&task->perf_counter_mutex);
+	}
+
 	return ctx;
 }
 
@@ -1226,6 +1289,7 @@ static void free_counter_rcu(struct rcu_head *head)
 	struct perf_counter *counter;
 
 	counter = container_of(head, struct perf_counter, rcu_head);
+	put_ctx(counter->ctx);
 	kfree(counter);
 }
 
@@ -2231,7 +2295,7 @@ static void perf_counter_comm_event(struct perf_comm_event *comm_event)
 	perf_counter_comm_ctx(&cpuctx->ctx, comm_event);
 	put_cpu_var(perf_cpu_context);
 
-	perf_counter_comm_ctx(&current->perf_counter_ctx, comm_event);
+	perf_counter_comm_ctx(current->perf_counter_ctx, comm_event);
 }
 
 void perf_counter_comm(struct task_struct *task)
@@ -2240,7 +2304,9 @@ void perf_counter_comm(struct task_struct *task)
 
 	if (!atomic_read(&nr_comm_tracking))
 		return;
-       
+	if (!current->perf_counter_ctx)
+		return;
+
 	comm_event = (struct perf_comm_event){
 		.task	= task,
 		.event  = {
@@ -2356,7 +2422,7 @@ got_name:
 	perf_counter_mmap_ctx(&cpuctx->ctx, mmap_event);
 	put_cpu_var(perf_cpu_context);
 
-	perf_counter_mmap_ctx(&current->perf_counter_ctx, mmap_event);
+	perf_counter_mmap_ctx(current->perf_counter_ctx, mmap_event);
 
 	kfree(buf);
 }
@@ -2368,6 +2434,8 @@ void perf_counter_mmap(unsigned long addr, unsigned long len,
 
 	if (!atomic_read(&nr_mmap_tracking))
 		return;
+	if (!current->perf_counter_ctx)
+		return;
 
 	mmap_event = (struct perf_mmap_event){
 		.file   = file,
@@ -2933,6 +3001,7 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	counter->group_leader		= group_leader;
 	counter->pmu			= NULL;
 	counter->ctx			= ctx;
+	get_ctx(ctx);
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
 	if (hw_event->disabled)
@@ -3098,22 +3167,6 @@ err_put_context:
 }
 
 /*
- * Initialize the perf_counter context in a task_struct:
- */
-static void
-__perf_counter_init_context(struct perf_counter_context *ctx,
-			    struct task_struct *task)
-{
-	memset(ctx, 0, sizeof(*ctx));
-	spin_lock_init(&ctx->lock);
-	mutex_init(&ctx->mutex);
-	INIT_LIST_HEAD(&ctx->counter_list);
-	INIT_LIST_HEAD(&ctx->event_list);
-	ctx->rr_allowed = 1;
-	ctx->task = task;
-}
-
-/*
  * inherit a counter from parent task to child task:
  */
 static struct perf_counter *
@@ -3144,7 +3197,6 @@ inherit_counter(struct perf_counter *parent_counter,
 	/*
 	 * Link it up in the child's context:
 	 */
-	child_counter->task = child;
 	add_counter_to_ctx(child_counter, child_ctx);
 
 	child_counter->parent = parent_counter;
@@ -3243,6 +3295,12 @@ __perf_counter_exit_task(struct task_struct *child,
 	struct perf_counter *parent_counter;
 
 	/*
+	 * Protect against concurrent operations on child_counter
+	 * due its fd getting closed, etc.
+	 */
+	mutex_lock(&child_counter->mutex);
+
+	/*
 	 * If we do not self-reap then we have to wait for the
 	 * child task to unschedule (it will happen for sure),
 	 * so that its counter is at its final count. (This
@@ -3277,6 +3335,7 @@ __perf_counter_exit_task(struct task_struct *child,
 		perf_enable();
 		local_irq_restore(flags);
 	}
+	mutex_unlock(&child_counter->mutex);
 
 	parent_counter = child_counter->parent;
 	/*
@@ -3295,6 +3354,8 @@ __perf_counter_exit_task(struct task_struct *child,
  *
  * Note: we may be running in child context, but the PID is not hashed
  * anymore so new counters will not be added.
+ * (XXX not sure that is true when we get called from flush_old_exec.
+ *  -- paulus)
  */
 void perf_counter_exit_task(struct task_struct *child)
 {
@@ -3303,10 +3364,11 @@ void perf_counter_exit_task(struct task_struct *child)
 
 	WARN_ON_ONCE(child != current);
 
-	child_ctx = &child->perf_counter_ctx;
+	child_ctx = child->perf_counter_ctx;
 
-	if (likely(!child_ctx->nr_counters))
+	if (likely(!child_ctx))
 		return;
+	mutex_lock(&child_ctx->mutex);
 
 again:
 	list_for_each_entry_safe(child_counter, tmp, &child_ctx->counter_list,
@@ -3320,6 +3382,13 @@ again:
 	 */
 	if (!list_empty(&child_ctx->counter_list))
 		goto again;
+
+	mutex_unlock(&child_ctx->mutex);
+
+	mutex_lock(&child->perf_counter_mutex);
+	child->perf_counter_ctx = NULL;
+	mutex_unlock(&child->perf_counter_mutex);
+	put_ctx(child_ctx);
 }
 
 /*
@@ -3331,19 +3400,26 @@ void perf_counter_init_task(struct task_struct *child)
 	struct perf_counter *counter;
 	struct task_struct *parent = current;
 
-	child_ctx  =  &child->perf_counter_ctx;
-	parent_ctx = &parent->perf_counter_ctx;
-
-	__perf_counter_init_context(child_ctx, child);
+	mutex_init(&child->perf_counter_mutex);
+	child->perf_counter_ctx = NULL;
 
 	/*
 	 * This is executed from the parent task context, so inherit
-	 * counters that have been marked for cloning:
+	 * counters that have been marked for cloning.
+	 * First allocate and initialize a context for the child.
 	 */
 
-	if (likely(!parent_ctx->nr_counters))
+	child_ctx = kmalloc(sizeof(struct perf_counter_context), GFP_KERNEL);
+	if (!child_ctx)
 		return;
 
+	parent_ctx = parent->perf_counter_ctx;
+	if (likely(!parent_ctx || !parent_ctx->nr_counters))
+		return;
+
+	__perf_counter_init_context(child_ctx, child);
+	child->perf_counter_ctx = child_ctx;
+
 	/*
 	 * Lock the parent list. No need to lock the child - not PID
 	 * hashed yet and not running, so nobody can access it.
-- 
1.6.0.4


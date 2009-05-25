Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZEYLHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZEYLHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZEYLHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:07:06 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:45557 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbZEYLHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:07:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18970.31699.559802.462479@cargo.ozlabs.ibm.com>
Date: Mon, 25 May 2009 21:06:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
In-Reply-To: <1243247887.26820.651.camel@twins>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	<18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	<1243000016.6582.574.camel@laptop>
	<18969.58137.356360.144339@cargo.ozlabs.ibm.com>
	<1243247887.26820.651.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> I'm currently staring at something like the below, trying to find races
> etc.. ;-)
[snip]
>  	next_ctx = next->perf_counter_ctxp;
>  	if (next_ctx && context_equiv(ctx, next_ctx)) {
> +		ctx->task = NULL;
> +		next_ctx->task = NULL;

Trouble is, ctx->task == NULL is used as an indication that this is a
per-cpu context in various places.

Also, in find_get_context, we have a lifetime problem because *ctx
could get swapped and then freed underneath us immediately after we
read task->perf_counter_ctxp.  So we need a lock in the task_struct
that stops sched_out from swapping the context underneath us.  That
led me to the patch below, which I'm about to test... :)  It does the
unclone in find_get_context; we don't actually need it on remove
because we have no way to remove an inherited counter from a task
without the task exiting.

Paul.

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 353c0ac..96b0a73 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -110,6 +110,8 @@ extern struct cred init_cred;
 
 #ifdef CONFIG_PERF_COUNTERS
 # define INIT_PERF_COUNTERS(tsk)					\
+	.perf_counter_ctx_lock =					\
+		__SPIN_LOCK_UNLOCKED(tsk.perf_counter_ctx_lock),	\
 	.perf_counter_mutex = 						\
 		 __MUTEX_INITIALIZER(tsk.perf_counter_mutex),		\
 	.perf_counter_list = LIST_HEAD_INIT(tsk.perf_counter_list),
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 2ddf5e3..77cbbe7 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -531,8 +531,8 @@ struct perf_counter_context {
 	 * been cloned (inherited) from a common ancestor.
 	 */
 	struct perf_counter_context *parent_ctx;
-	u32			parent_gen;
-	u32			generation;
+	u64			parent_gen;
+	u64			generation;
 };
 
 /**
diff --git a/include/linux/sched.h b/include/linux/sched.h
index bc9326d..717830e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1389,6 +1389,7 @@ struct task_struct {
 #endif
 #ifdef CONFIG_PERF_COUNTERS
 	struct perf_counter_context *perf_counter_ctxp;
+	spinlock_t perf_counter_ctx_lock;
 	struct mutex perf_counter_mutex;
 	struct list_head perf_counter_list;
 #endif
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index cb40625..4c19404 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -211,22 +211,6 @@ group_sched_out(struct perf_counter *group_counter,
 }
 
 /*
- * Mark this context as not being a clone of another.
- * Called when counters are added to or removed from this context.
- * We also increment our generation number so that anything that
- * was cloned from this context before this will not match anything
- * cloned from this context after this.
- */
-static void unclone_ctx(struct perf_counter_context *ctx)
-{
-	++ctx->generation;
-	if (!ctx->parent_ctx)
-		return;
-	put_ctx(ctx->parent_ctx);
-	ctx->parent_ctx = NULL;
-}
-
-/*
  * Cross CPU call to remove a performance counter
  *
  * We disable the counter on the hardware level first. After that we
@@ -280,13 +264,16 @@ static void __perf_counter_remove_from_context(void *info)
  *
  * CPU counters are removed with a smp call. For task counters we only
  * call when the task is on a CPU.
+ *
+ * If counter->ctx is a cloned context, callers must make sure that
+ * every task struct that counter->ctx->task could possibly point to
+ * remains valid.
  */
 static void perf_counter_remove_from_context(struct perf_counter *counter)
 {
 	struct perf_counter_context *ctx = counter->ctx;
 	struct task_struct *task = ctx->task;
 
-	unclone_ctx(ctx);
 	if (!task) {
 		/*
 		 * Per cpu counters are removed via an smp call and
@@ -409,6 +396,10 @@ static void __perf_counter_disable(void *info)
 
 /*
  * Disable a counter.
+ *
+ * If counter->ctx is a cloned context, callers must make sure that
+ * every task struct that counter->ctx->task could possibly point to
+ * remains valid.
  */
 static void perf_counter_disable(struct perf_counter *counter)
 {
@@ -793,6 +784,10 @@ static void __perf_counter_enable(void *info)
 
 /*
  * Enable a counter.
+ *
+ * If counter->ctx is a cloned context, callers must make sure that
+ * every task struct that counter->ctx->task could possibly point to
+ * remains valid.
  */
 static void perf_counter_enable(struct perf_counter *counter)
 {
@@ -932,12 +927,32 @@ void perf_counter_task_sched_out(struct task_struct *task,
 	regs = task_pt_regs(task);
 	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
 
+	/*
+	 * Note: task->perf_counter_ctxp and next->perf_counter_ctxp
+	 * can't change underneath us here if we see them non-NULL,
+	 * because this is the only place where we change which
+	 * context a task points to, and the scheduler will ensure
+	 * that this code isn't being called for either of these tasks
+	 * on any other cpu at the same time.
+	 */
 	next_ctx = next->perf_counter_ctxp;
 	if (next_ctx && context_equiv(ctx, next_ctx)) {
+		/*
+		 * Lock the contexts of both the old and new tasks so that we
+		 * don't change things underneath find_get_context etc.
+		 * We don't need to be careful about the order in which we
+		 * lock the tasks because no other cpu could be trying to lock
+		 * both of these tasks -- this is the only place where we lock
+		 * two tasks.
+		 */
+		spin_lock(&task->perf_counter_ctx_lock);
+		spin_lock(&next->perf_counter_ctx_lock);
 		task->perf_counter_ctxp = next_ctx;
 		next->perf_counter_ctxp = ctx;
 		ctx->task = next;
 		next_ctx->task = task;
+		spin_unlock(&next->perf_counter_ctx_lock);
+		spin_unlock(&task->perf_counter_ctx_lock);
 		return;
 	}
 
@@ -1067,6 +1082,7 @@ static void perf_counter_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
 	__perf_counter_sched_in(ctx, cpuctx, cpu);
 }
 
+// XXX doesn't do inherited counters too?
 int perf_counter_task_enable(void)
 {
 	struct perf_counter *counter;
@@ -1079,6 +1095,7 @@ int perf_counter_task_enable(void)
 	return 0;
 }
 
+// XXX doesn't do inherited counters too?
 int perf_counter_task_disable(void)
 {
 	struct perf_counter *counter;
@@ -1108,6 +1125,7 @@ static void perf_adjust_freq(struct perf_counter_context *ctx)
 		if (!counter->hw_event.freq || !counter->hw_event.irq_freq)
 			continue;
 
+		// XXX does this assume we got a whole tick worth of counts?
 		events = HZ * counter->hw.interrupts * counter->hw.irq_period;
 		period = div64_u64(events, counter->hw_event.irq_freq);
 
@@ -1238,7 +1256,6 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 {
 	struct perf_cpu_context *cpuctx;
 	struct perf_counter_context *ctx;
-	struct perf_counter_context *tctx;
 	struct task_struct *task;
 
 	/*
@@ -1284,30 +1301,42 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 		return ERR_PTR(-EACCES);
 	}
 
+	/*
+	 * Taking this lock stops the context-switch code from switching
+	 * our context to another task.  We also use the lock to solve
+	 * the race where two tasks allocate a context at the same time.
+	 */
+	spin_lock(&task->perf_counter_ctx_lock);
 	ctx = task->perf_counter_ctxp;
 	if (!ctx) {
+		spin_unlock(&task->perf_counter_ctx_lock);
 		ctx = kmalloc(sizeof(struct perf_counter_context), GFP_KERNEL);
 		if (!ctx) {
 			put_task_struct(task);
 			return ERR_PTR(-ENOMEM);
 		}
 		__perf_counter_init_context(ctx, task);
-		/*
-		 * Make sure other cpus see correct values for *ctx
-		 * once task->perf_counter_ctxp is visible to them.
-		 */
-		smp_wmb();
-		tctx = cmpxchg(&task->perf_counter_ctxp, NULL, ctx);
-		if (tctx) {
+		spin_lock(&task->perf_counter_ctx_lock);
+		if (task->perf_counter_ctxp) {
 			/*
 			 * We raced with some other task; use
 			 * the context they set.
 			 */
 			kfree(ctx);
-			ctx = tctx;
+			ctx = task->perf_counter_ctxp;
 		}
 	}
 
+	/*
+	 * Since we're about to add another counter to this context,
+	 * it won't be a clone of another context any longer.
+	 */
+	++ctx->generation;
+	if (ctx->parent_ctx) {
+		put_ctx(ctx->parent_ctx);
+		ctx->parent_ctx = NULL;
+	}
+
 	return ctx;
 }
 
@@ -1360,7 +1389,7 @@ static int perf_release(struct inode *inode, struct file *file)
 	put_task_struct(counter->owner);
 
 	free_counter(counter);
-	put_context(ctx);
+	put_context(ctx);		// XXX use after free?
 
 	return 0;
 }
@@ -1382,7 +1411,7 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 	if (counter->state == PERF_COUNTER_STATE_ERROR)
 		return 0;
 
-	mutex_lock(&counter->child_mutex);
+	mutex_lock(&counter->child_mutex);	// XXX doesn't exclude sync_child_counter, so why?
 	values[0] = perf_counter_read(counter);
 	n = 1;
 	if (counter->hw_event.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
@@ -1450,6 +1479,12 @@ static void perf_counter_for_each_sibling(struct perf_counter *counter,
 	mutex_unlock(&ctx->mutex);
 }
 
+/*
+ * Holding the top-level counter's child_mutex means that any
+ * descendant process that has inherited this counter will block
+ * in sync_child_counter, thus satisfying the task existence requirements
+ * of perf_counter_enable/disable.
+ */
 static void perf_counter_for_each_child(struct perf_counter *counter,
 					void (*func)(struct perf_counter *))
 {
@@ -3395,15 +3430,14 @@ void perf_counter_exit_task(struct task_struct *child)
 
 	WARN_ON_ONCE(child != current);
 
-	child_ctx = child->perf_counter_ctxp;
-
-	if (likely(!child_ctx))
+	if (likely(!child->perf_counter_ctxp))
 		return;
 
-	local_irq_save(flags);
+	spin_lock_irqsave(&child->perf_counter_ctx_lock, flags);
+	child_ctx = child->perf_counter_ctxp;
 	__perf_counter_task_sched_out(child_ctx);
 	child->perf_counter_ctxp = NULL;
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&child->perf_counter_ctx_lock, flags);
 
 	mutex_lock(&child_ctx->mutex);
 

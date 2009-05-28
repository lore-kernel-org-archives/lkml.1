Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZE1KcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZE1KcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZE1KcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:32:17 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:44678 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbZE1KcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:32:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18974.26663.618300.184845@cargo.ozlabs.ibm.com>
Date: Thu, 28 May 2009 20:32:07 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v4] perf_counter: Fix race in attaching counters to
   tasks and exiting
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 564c2b21 ("perf_counter: Optimize context switch between
identical inherited contexts") introduced a race where it is possible
that a counter being attached to a task could get attached to the
wrong task, if the task is one that has inherited its context from
another task via fork.  This happens because the optimized context
switch could switch the context to another task after find_get_context
has read task->perf_counter_ctxp.  In fact, it's possible that the
context could then get freed, if the other task then exits.

This fixes the problem by protecting both the context switch and the
critical code in find_get_context with spinlocks.  The context switch
locks the cxt->lock of both the outgoing and incoming contexts before
swapping them.  That means that once code such as find_get_context
has obtained the spinlock for the context associated with a task,
the context can't get swapped to another task.  However, the context
may have been swapped in the interval between reading
task->perf_counter_ctxp and getting the lock, so it is necessary to
check and retry.

To make sure that none of the contexts being looked at in
find_get_context can get freed, this changes the context freeing code
to use RCU.  Thus an rcu_read_lock() is sufficient to ensure that no
contexts can get freed.  This part of the patch is lifted from a patch
posted by Peter Zijlstra.

This also adds a check to make sure that we can't add a counter to a
task that is exiting.

There is also a race between perf_counter_exit_task and
find_get_context; this solves the race by moving the get_ctx that
was in perf_counter_alloc into the locked region in find_get_context,
so that once find_get_context has got the context for a task, it
won't get freed even if the task calls perf_counter_exit_task.  It
doesn't matter if new top-level (non-inherited) counters get attached
to the context after perf_counter_exit_task has detached the context
from the task.  They will just stay there and never get scheduled in
until the counters' fds get closed, and then perf_release will remove
them from the context and eventually free the context.

With this, we are now doing the unclone in find_get_context rather
than when a counter was added to or removed from a context (actually,
we were missing the unclone_ctx() call when adding a counter to a
context).  We don't need to unclone when removing a counter from a
context because we have no way to remove a counter from a cloned
context.

This also takes out the smp_wmb() in find_get_context, which Peter
Zijlstra pointed out was unnecessary because the cmpxchg implies a
full barrier anyway.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
v4: added a missing get_task_struct in perf_counter_init_task

 include/linux/perf_counter.h |    5 +-
 kernel/perf_counter.c        |  204 +++++++++++++++++++++++++++++------------
 2 files changed, 147 insertions(+), 62 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 2b16ed3..35dc996 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -541,8 +541,9 @@ struct perf_counter_context {
 	 * been cloned (inherited) from a common ancestor.
 	 */
 	struct perf_counter_context *parent_ctx;
-	u32			parent_gen;
-	u32			generation;
+	u64			parent_gen;
+	u64			generation;
+	struct rcu_head		rcu_head;
 };
 
 /**
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 367299f..473d85f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -103,12 +103,22 @@ static void get_ctx(struct perf_counter_context *ctx)
 	atomic_inc(&ctx->refcount);
 }
 
+static void free_ctx(struct rcu_head *head)
+{
+	struct perf_counter_context *ctx;
+
+	ctx = container_of(head, struct perf_counter_context, rcu_head);
+	if (ctx->task)
+		put_task_struct(ctx->task);
+	kfree(ctx);
+}
+
 static void put_ctx(struct perf_counter_context *ctx)
 {
 	if (atomic_dec_and_test(&ctx->refcount)) {
 		if (ctx->parent_ctx)
 			put_ctx(ctx->parent_ctx);
-		kfree(ctx);
+		call_rcu(&ctx->rcu_head, free_ctx);
 	}
 }
 
@@ -212,22 +222,6 @@ group_sched_out(struct perf_counter *group_counter,
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
@@ -281,13 +275,19 @@ static void __perf_counter_remove_from_context(void *info)
  *
  * CPU counters are removed with a smp call. For task counters we only
  * call when the task is on a CPU.
+ *
+ * If counter->ctx is a cloned context, callers must make sure that
+ * every task struct that counter->ctx->task could possibly point to
+ * remains valid.  This is OK when called from perf_release since
+ * that only calls us on the top-level context, which can't be a clone.
+ * When called from perf_counter_exit_task, it's OK because the
+ * context has been detached from its task.
  */
 static void perf_counter_remove_from_context(struct perf_counter *counter)
 {
 	struct perf_counter_context *ctx = counter->ctx;
 	struct task_struct *task = ctx->task;
 
-	unclone_ctx(ctx);
 	if (!task) {
 		/*
 		 * Per cpu counters are removed via an smp call and
@@ -410,6 +410,16 @@ static void __perf_counter_disable(void *info)
 
 /*
  * Disable a counter.
+ *
+ * If counter->ctx is a cloned context, callers must make sure that
+ * every task struct that counter->ctx->task could possibly point to
+ * remains valid.  This condition is satisifed when called through
+ * perf_counter_for_each_child or perf_counter_for_each because they
+ * hold the top-level counter's child_mutex, so any descendant that
+ * goes to exit will block in sync_child_counter.
+ * When called from perf_pending_counter it's OK because counter->ctx
+ * is the current context on this CPU and preemption is disabled,
+ * hence we can't get into perf_counter_task_sched_out for this context.
  */
 static void perf_counter_disable(struct perf_counter *counter)
 {
@@ -794,6 +804,12 @@ static void __perf_counter_enable(void *info)
 
 /*
  * Enable a counter.
+ *
+ * If counter->ctx is a cloned context, callers must make sure that
+ * every task struct that counter->ctx->task could possibly point to
+ * remains valid.  This condition is satisfied when called through
+ * perf_counter_for_each_child or perf_counter_for_each as described
+ * for perf_counter_disable.
  */
 static void perf_counter_enable(struct perf_counter *counter)
 {
@@ -923,7 +939,9 @@ void perf_counter_task_sched_out(struct task_struct *task,
 	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
 	struct perf_counter_context *ctx = task->perf_counter_ctxp;
 	struct perf_counter_context *next_ctx;
+	struct perf_counter_context *parent;
 	struct pt_regs *regs;
+	int do_switch = 1;
 
 	regs = task_pt_regs(task);
 	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
@@ -932,18 +950,39 @@ void perf_counter_task_sched_out(struct task_struct *task,
 		return;
 
 	update_context_time(ctx);
+
+	rcu_read_lock();
+	parent = rcu_dereference(ctx->parent_ctx);
 	next_ctx = next->perf_counter_ctxp;
-	if (next_ctx && context_equiv(ctx, next_ctx)) {
-		task->perf_counter_ctxp = next_ctx;
-		next->perf_counter_ctxp = ctx;
-		ctx->task = next;
-		next_ctx->task = task;
-		return;
+	if (parent && next_ctx &&
+	    rcu_dereference(next_ctx->parent_ctx) == parent) {
+		/*
+		 * Looks like the two contexts are clones, so we might be
+		 * able to optimize the context switch.  We lock both
+		 * contexts and check that they are clones under the
+		 * lock (including re-checking that neither has been
+		 * uncloned in the meantime).  It doesn't matter which
+		 * order we take the locks because no other cpu could
+		 * be trying to lock both of these tasks.
+		 */
+		spin_lock(&ctx->lock);
+		spin_lock(&next_ctx->lock);
+		if (context_equiv(ctx, next_ctx)) {
+			task->perf_counter_ctxp = next_ctx;
+			next->perf_counter_ctxp = ctx;
+			ctx->task = next;
+			next_ctx->task = task;
+			do_switch = 0;
+		}
+		spin_unlock(&next_ctx->lock);
+		spin_unlock(&ctx->lock);
 	}
+	rcu_read_unlock();
 
-	__perf_counter_sched_out(ctx, cpuctx);
-
-	cpuctx->task_ctx = NULL;
+	if (do_switch) {
+		__perf_counter_sched_out(ctx, cpuctx);
+		cpuctx->task_ctx = NULL;
+	}
 }
 
 static void __perf_counter_task_sched_out(struct perf_counter_context *ctx)
@@ -1215,18 +1254,13 @@ __perf_counter_init_context(struct perf_counter_context *ctx,
 	ctx->task = task;
 }
 
-static void put_context(struct perf_counter_context *ctx)
-{
-	if (ctx->task)
-		put_task_struct(ctx->task);
-}
-
 static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 {
 	struct perf_cpu_context *cpuctx;
 	struct perf_counter_context *ctx;
-	struct perf_counter_context *tctx;
+	struct perf_counter_context *parent_ctx;
 	struct task_struct *task;
+	int err;
 
 	/*
 	 * If cpu is not a wildcard then this is a percpu counter:
@@ -1249,6 +1283,7 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 
 		cpuctx = &per_cpu(perf_cpu_context, cpu);
 		ctx = &cpuctx->ctx;
+		get_ctx(ctx);
 
 		return ctx;
 	}
@@ -1265,37 +1300,78 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 	if (!task)
 		return ERR_PTR(-ESRCH);
 
+	/*
+	 * Can't attach counters to a dying task.
+	 */
+	err = -ESRCH;
+	if (task->flags & PF_EXITING)
+		goto errout;
+
 	/* Reuse ptrace permission checks for now. */
-	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
-		put_task_struct(task);
-		return ERR_PTR(-EACCES);
+	err = -EACCES;
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+		goto errout;
+
+	rcu_read_lock();
+ retry:
+	ctx = rcu_dereference(task->perf_counter_ctxp);
+	if (ctx) {
+		/*
+		 * If this context is a clone of another, it might
+		 * get swapped for another underneath us by
+		 * perf_counter_task_sched_out, though the
+		 * rcu_read_lock() protects us from any context
+		 * getting freed.  Lock the context and check if it
+		 * got swapped before we could get the lock, and retry
+		 * if so.  If we locked the right context, then it
+		 * can't get swapped on us any more and we can
+		 * unclone it if necessary.
+		 * Once it's not a clone things will be stable.
+		 */
+		spin_lock(&ctx->lock);
+		if (ctx != rcu_dereference(task->perf_counter_ctxp)) {
+			spin_unlock(&ctx->lock);
+			goto retry;
+		}
+		parent_ctx = ctx->parent_ctx;
+		if (parent_ctx) {
+			put_ctx(parent_ctx);
+			ctx->parent_ctx = NULL;		/* no longer a clone */
+		}
+		++ctx->generation;
+		/*
+		 * Get an extra reference before dropping the lock so that
+		 * this context won't get freed if the task exits.
+		 */
+		get_ctx(ctx);
+		spin_unlock(&ctx->lock);
 	}
+	rcu_read_unlock();
 
-	ctx = task->perf_counter_ctxp;
 	if (!ctx) {
 		ctx = kmalloc(sizeof(struct perf_counter_context), GFP_KERNEL);
-		if (!ctx) {
-			put_task_struct(task);
-			return ERR_PTR(-ENOMEM);
-		}
+		err = -ENOMEM;
+		if (!ctx)
+			goto errout;
 		__perf_counter_init_context(ctx, task);
-		/*
-		 * Make sure other cpus see correct values for *ctx
-		 * once task->perf_counter_ctxp is visible to them.
-		 */
-		smp_wmb();
-		tctx = cmpxchg(&task->perf_counter_ctxp, NULL, ctx);
-		if (tctx) {
+		get_ctx(ctx);
+		if (cmpxchg(&task->perf_counter_ctxp, NULL, ctx)) {
 			/*
 			 * We raced with some other task; use
 			 * the context they set.
 			 */
 			kfree(ctx);
-			ctx = tctx;
+			goto retry;
 		}
+		get_task_struct(task);
 	}
 
+	put_task_struct(task);
 	return ctx;
+
+ errout:
+	put_task_struct(task);
+	return ERR_PTR(err);
 }
 
 static void free_counter_rcu(struct rcu_head *head)
@@ -1303,7 +1379,6 @@ static void free_counter_rcu(struct rcu_head *head)
 	struct perf_counter *counter;
 
 	counter = container_of(head, struct perf_counter, rcu_head);
-	put_ctx(counter->ctx);
 	kfree(counter);
 }
 
@@ -1324,6 +1399,7 @@ static void free_counter(struct perf_counter *counter)
 	if (counter->destroy)
 		counter->destroy(counter);
 
+	put_ctx(counter->ctx);
 	call_rcu(&counter->rcu_head, free_counter_rcu);
 }
 
@@ -1347,7 +1423,6 @@ static int perf_release(struct inode *inode, struct file *file)
 	put_task_struct(counter->owner);
 
 	free_counter(counter);
-	put_context(ctx);
 
 	return 0;
 }
@@ -1437,6 +1512,12 @@ static void perf_counter_for_each_sibling(struct perf_counter *counter,
 	mutex_unlock(&ctx->mutex);
 }
 
+/*
+ * Holding the top-level counter's child_mutex means that any
+ * descendant process that has inherited this counter will block
+ * in sync_child_counter if it goes to exit, thus satisfying the
+ * task existence requirements of perf_counter_enable/disable.
+ */
 static void perf_counter_for_each_child(struct perf_counter *counter,
 					void (*func)(struct perf_counter *))
 {
@@ -3124,8 +3205,6 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	counter->ctx			= ctx;
 	counter->oncpu			= -1;
 
-	get_ctx(ctx);
-
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
 	if (hw_event->disabled)
 		counter->state = PERF_COUNTER_STATE_OFF;
@@ -3290,7 +3369,7 @@ err_free_put_context:
 	kfree(counter);
 
 err_put_context:
-	put_context(ctx);
+	put_ctx(ctx);
 
 	goto out_fput;
 }
@@ -3322,6 +3401,7 @@ inherit_counter(struct perf_counter *parent_counter,
 					   group_leader, GFP_KERNEL);
 	if (IS_ERR(child_counter))
 		return child_counter;
+	get_ctx(child_ctx);
 
 	/*
 	 * Make the child state follow the state of the parent counter,
@@ -3439,11 +3519,6 @@ __perf_counter_exit_task(struct task_struct *child,
 
 /*
  * When a child task exits, feed back counter values to parent counters.
- *
- * Note: we may be running in child context, but the PID is not hashed
- * anymore so new counters will not be added.
- * (XXX not sure that is true when we get called from flush_old_exec.
- *  -- paulus)
  */
 void perf_counter_exit_task(struct task_struct *child)
 {
@@ -3458,7 +3533,15 @@ void perf_counter_exit_task(struct task_struct *child)
 
 	local_irq_save(flags);
 	__perf_counter_task_sched_out(child_ctx);
+
+	/*
+	 * Take the context lock here so that if find_get_context is
+	 * reading child->perf_counter_ctxp, we wait until it has
+	 * incremented the context's refcount before we do put_ctx below.
+	 */
+	spin_lock(&child_ctx->lock);
 	child->perf_counter_ctxp = NULL;
+	spin_unlock(&child_ctx->lock);
 	local_irq_restore(flags);
 
 	mutex_lock(&child_ctx->mutex);
@@ -3513,6 +3596,7 @@ int perf_counter_init_task(struct task_struct *child)
 
 	__perf_counter_init_context(child_ctx, child);
 	child->perf_counter_ctxp = child_ctx;
+	get_task_struct(child);
 
 	/*
 	 * Lock the parent list. No need to lock the child - not PID
-- 
1.6.0.4


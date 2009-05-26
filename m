Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZEZMaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZEZMaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZEZMaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:30:04 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:51221 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZEZMaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:30:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18971.57536.580490.918501@cargo.ozlabs.ibm.com>
Date: Tue, 26 May 2009 22:29:52 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH] perf_counter: Fix race in attaching counters to tasks
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
critical code in find_get_context with a spinlock.  We use the
ctx->lock of the parent context for this because it will be common
between any pair of contexts that might get swapped.  Thus
perf_counter_task_sched_out only needs to take one lock to exclude
find_get_context from getting the wrong context for either the old
task or the new task.

To make sure that none of the contexts being looked at in
find_get_context can get freed, this changes the context freeing code
to use RCU.  Thus an rcu_read_lock() is sufficient to ensure that no
contexts can get freed.  This part of the patch is lifted from a patch
posted by Peter Zijlstra.

This also adds a check to make sure that we can't add a counter to a
task that is exiting.  This solves a race between
perf_counter_exit_task and find_get_context; it ensures that
find_get_context can't attach a new context to a task after
perf_counter_exit_task has disposed of the task's context.

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
index 367299f..469ffe2 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -103,12 +103,20 @@ static void get_ctx(struct perf_counter_context *ctx)
 	atomic_inc(&ctx->refcount);
 }
 
+static void free_ctx(struct rcu_head *head)
+{
+	struct perf_counter_context *ctx;
+
+	ctx = container_of(head, struct perf_counter_context, rcu_head);
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
 
@@ -212,22 +220,6 @@ group_sched_out(struct perf_counter *group_counter,
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
@@ -281,13 +273,16 @@ static void __perf_counter_remove_from_context(void *info)
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
@@ -410,6 +405,10 @@ static void __perf_counter_disable(void *info)
 
 /*
  * Disable a counter.
+ *
+ * If counter->ctx is a cloned context, callers must make sure that
+ * every task struct that counter->ctx->task could possibly point to
+ * remains valid.
  */
 static void perf_counter_disable(struct perf_counter *counter)
 {
@@ -794,6 +793,10 @@ static void __perf_counter_enable(void *info)
 
 /*
  * Enable a counter.
+ *
+ * If counter->ctx is a cloned context, callers must make sure that
+ * every task struct that counter->ctx->task could possibly point to
+ * remains valid.
  */
 static void perf_counter_enable(struct perf_counter *counter)
 {
@@ -923,7 +926,9 @@ void perf_counter_task_sched_out(struct task_struct *task,
 	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
 	struct perf_counter_context *ctx = task->perf_counter_ctxp;
 	struct perf_counter_context *next_ctx;
+	struct perf_counter_context *parent;
 	struct pt_regs *regs;
+	int do_switch = 1;
 
 	regs = task_pt_regs(task);
 	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
@@ -932,18 +937,36 @@ void perf_counter_task_sched_out(struct task_struct *task,
 		return;
 
 	update_context_time(ctx);
-	next_ctx = next->perf_counter_ctxp;
-	if (next_ctx && context_equiv(ctx, next_ctx)) {
-		task->perf_counter_ctxp = next_ctx;
-		next->perf_counter_ctxp = ctx;
-		ctx->task = next;
-		next_ctx->task = task;
-		return;
-	}
 
-	__perf_counter_sched_out(ctx, cpuctx);
+	rcu_read_lock();
+	parent = rcu_dereference(ctx->parent_ctx);
+	next_ctx = rcu_dereference(next->perf_counter_ctxp);
+	if (parent && next_ctx &&
+	    rcu_dereference(next_ctx->parent_ctx) == parent) {
+		/*
+		 * Looks like the two contexts are clones, so we might be
+		 * able to optimize the context switch.  We lock the
+		 * parent context because it represents a common point
+		 * connected to both the incoming and outgoing contexts
+		 * in the case where we can optimize.  Then we check
+		 * under the lock whether they really are clones.
+		 */
+		spin_lock(&parent->lock);
+		if (context_equiv(ctx, next_ctx)) {
+			task->perf_counter_ctxp = next_ctx;
+			next->perf_counter_ctxp = ctx;
+			ctx->task = next;
+			next_ctx->task = task;
+			do_switch = 0;
+		}
+		spin_unlock(&parent->lock);
+	}
+	rcu_read_unlock();
 
-	cpuctx->task_ctx = NULL;
+	if (do_switch) {
+		__perf_counter_sched_out(ctx, cpuctx);
+		cpuctx->task_ctx = NULL;
+	}
 }
 
 static void __perf_counter_task_sched_out(struct perf_counter_context *ctx)
@@ -1226,6 +1249,7 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 	struct perf_cpu_context *cpuctx;
 	struct perf_counter_context *ctx;
 	struct perf_counter_context *tctx;
+	struct perf_counter_context *parent_ctx;
 	struct task_struct *task;
 
 	/*
@@ -1271,7 +1295,41 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 		return ERR_PTR(-EACCES);
 	}
 
-	ctx = task->perf_counter_ctxp;
+	rcu_read_lock();
+	ctx = rcu_dereference(task->perf_counter_ctxp);
+	if (ctx) {
+		parent_ctx = rcu_dereference(ctx->parent_ctx);
+		if (parent_ctx) {
+			/*
+			 * This context appears to be a clone of another,
+			 * so it might get swapped for another underneath
+			 * us by perf_counter_task_sched_out, though the
+			 * rcu_read_lock() protects us from any context
+			 * getting freed.  Lock the parent context, which
+			 * will prevent our context from getting swapped,
+			 * then reload the pointers and unclone the context.
+			 * Once it's not a clone things will be stable.
+			 */
+			spin_lock(&parent_ctx->lock);
+			ctx = task->perf_counter_ctxp;
+			if (ctx && ctx->parent_ctx) {
+				put_ctx(ctx->parent_ctx);
+				ctx->parent_ctx = NULL;
+			}
+			spin_unlock(&parent_ctx->lock);
+		}
+	}
+	rcu_read_unlock();
+
+	/*
+	 * Can't attach counters to a dying task.
+	 * Have to check this after loading ctx.
+	 */
+	if (task->flags & PF_EXITING) {
+		put_task_struct(task);
+		return ERR_PTR(-ESRCH);
+	}
+
 	if (!ctx) {
 		ctx = kmalloc(sizeof(struct perf_counter_context), GFP_KERNEL);
 		if (!ctx) {
@@ -1279,11 +1337,6 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 			return ERR_PTR(-ENOMEM);
 		}
 		__perf_counter_init_context(ctx, task);
-		/*
-		 * Make sure other cpus see correct values for *ctx
-		 * once task->perf_counter_ctxp is visible to them.
-		 */
-		smp_wmb();
 		tctx = cmpxchg(&task->perf_counter_ctxp, NULL, ctx);
 		if (tctx) {
 			/*
@@ -1295,6 +1348,7 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 		}
 	}
 
+	++ctx->generation;
 	return ctx;
 }
 
@@ -1303,7 +1357,6 @@ static void free_counter_rcu(struct rcu_head *head)
 	struct perf_counter *counter;
 
 	counter = container_of(head, struct perf_counter, rcu_head);
-	put_ctx(counter->ctx);
 	kfree(counter);
 }
 
@@ -1324,6 +1377,7 @@ static void free_counter(struct perf_counter *counter)
 	if (counter->destroy)
 		counter->destroy(counter);
 
+	put_ctx(counter->ctx);
 	call_rcu(&counter->rcu_head, free_counter_rcu);
 }
 
@@ -1437,6 +1491,12 @@ static void perf_counter_for_each_sibling(struct perf_counter *counter,
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
@@ -3449,17 +3509,13 @@ void perf_counter_exit_task(struct task_struct *child)
 {
 	struct perf_counter *child_counter, *tmp;
 	struct perf_counter_context *child_ctx;
-	unsigned long flags;
 
 	child_ctx = child->perf_counter_ctxp;
-
 	if (likely(!child_ctx))
 		return;
 
-	local_irq_save(flags);
 	__perf_counter_task_sched_out(child_ctx);
 	child->perf_counter_ctxp = NULL;
-	local_irq_restore(flags);
 
 	mutex_lock(&child_ctx->mutex);
 

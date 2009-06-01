Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZFAHxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZFAHxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZFAHx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:53:28 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55083 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbZFAHx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:53:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18979.34748.755674.596386@cargo.ozlabs.ibm.com>
Date: Mon, 1 Jun 2009 17:48:12 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Provide functions for locking and pinning the context for a task
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This abstracts out the code for locking the context associated with a
task.  Because the context might get transferred from one task to
another concurrently, we have to check after locking the context that
it is still the right context for the task and retry if not.  This
was open-coded in find_get_context() and perf_counter_init_task().

This adds a further function for pinning the context for a task, i.e.
marking it so it can't be transferred to another task.  This adds a
'pin_count' field to struct perf_counter_context to indicate that a
context is pinned, instead of the previous method of setting the
parent_gen count to all 1s.  Pinning the context with a pin_count is
easier to undo and doesn't require saving the parent_gen value.  This
also adds a perf_unpin_context() to undo the effect of
perf_pin_task_context() and changes perf_counter_init_task to use it.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 include/linux/perf_counter.h |    1 +
 kernel/perf_counter.c        |  128 ++++++++++++++++++++++++------------------
 2 files changed, 75 insertions(+), 54 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 519a41b..81ec79c 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -543,6 +543,7 @@ struct perf_counter_context {
 	struct perf_counter_context *parent_ctx;
 	u64			parent_gen;
 	u64			generation;
+	int			pin_count;
 	struct rcu_head		rcu_head;
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 79c3f26..da8dfef 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -123,6 +123,69 @@ static void put_ctx(struct perf_counter_context *ctx)
 }
 
 /*
+ * Get the perf_counter_context for a task and lock it.
+ * This has to cope with with the fact that until it is locked,
+ * the context could get moved to another task.
+ */
+static struct perf_counter_context *perf_lock_task_context(
+				struct task_struct *task, unsigned long *flags)
+{
+	struct perf_counter_context *ctx;
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
+		 * can't get swapped on us any more.
+		 */
+		spin_lock_irqsave(&ctx->lock, *flags);
+		if (ctx != rcu_dereference(task->perf_counter_ctxp)) {
+			spin_unlock_irqrestore(&ctx->lock, *flags);
+			goto retry;
+		}
+	}
+	rcu_read_unlock();
+	return ctx;
+}
+
+/*
+ * Get the context for a task and increment its pin_count so it
+ * can't get swapped to another task.  This also increments its
+ * reference count so that the context can't get freed.
+ */
+static struct perf_counter_context *perf_pin_task_context(struct task_struct *task)
+{
+	struct perf_counter_context *ctx;
+	unsigned long flags;
+
+	ctx = perf_lock_task_context(task, &flags);
+	if (ctx) {
+		++ctx->pin_count;
+		get_ctx(ctx);
+		spin_unlock_irqrestore(&ctx->lock, flags);
+	}
+	return ctx;
+}
+
+static void perf_unpin_context(struct perf_counter_context *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	--ctx->pin_count;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+	put_ctx(ctx);
+}
+
+/*
  * Add a counter from the lists for its context.
  * Must be called with ctx->mutex and ctx->lock held.
  */
@@ -916,7 +979,7 @@ static int context_equiv(struct perf_counter_context *ctx1,
 {
 	return ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx
 		&& ctx1->parent_gen == ctx2->parent_gen
-		&& ctx1->parent_gen != ~0ull;
+		&& !ctx1->pin_count && !ctx2->pin_count;
 }
 
 /*
@@ -1271,6 +1334,7 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 	struct perf_counter_context *ctx;
 	struct perf_counter_context *parent_ctx;
 	struct task_struct *task;
+	unsigned long flags;
 	int err;
 
 	/*
@@ -1323,28 +1387,9 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto errout;
 
- retry_lock:
-	rcu_read_lock();
  retry:
-	ctx = rcu_dereference(task->perf_counter_ctxp);
+	ctx = perf_lock_task_context(task, &flags);
 	if (ctx) {
-		/*
-		 * If this context is a clone of another, it might
-		 * get swapped for another underneath us by
-		 * perf_counter_task_sched_out, though the
-		 * rcu_read_lock() protects us from any context
-		 * getting freed.  Lock the context and check if it
-		 * got swapped before we could get the lock, and retry
-		 * if so.  If we locked the right context, then it
-		 * can't get swapped on us any more and we can
-		 * unclone it if necessary.
-		 * Once it's not a clone things will be stable.
-		 */
-		spin_lock_irq(&ctx->lock);
-		if (ctx != rcu_dereference(task->perf_counter_ctxp)) {
-			spin_unlock_irq(&ctx->lock);
-			goto retry;
-		}
 		parent_ctx = ctx->parent_ctx;
 		if (parent_ctx) {
 			put_ctx(parent_ctx);
@@ -1355,9 +1400,8 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 		 * this context won't get freed if the task exits.
 		 */
 		get_ctx(ctx);
-		spin_unlock_irq(&ctx->lock);
+		spin_unlock_irqrestore(&ctx->lock, flags);
 	}
-	rcu_read_unlock();
 
 	if (!ctx) {
 		ctx = kmalloc(sizeof(struct perf_counter_context), GFP_KERNEL);
@@ -1372,7 +1416,7 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 			 * the context they set.
 			 */
 			kfree(ctx);
-			goto retry_lock;
+			goto retry;
 		}
 		get_task_struct(task);
 	}
@@ -3667,7 +3711,6 @@ int perf_counter_init_task(struct task_struct *child)
 	struct perf_counter *counter;
 	struct task_struct *parent = current;
 	int inherited_all = 1;
-	u64 cloned_gen;
 	int ret = 0;
 
 	child->perf_counter_ctxp = NULL;
@@ -3693,32 +3736,17 @@ int perf_counter_init_task(struct task_struct *child)
 	get_task_struct(child);
 
 	/*
-	 * If the parent's context is a clone, temporarily set its
-	 * parent_gen to an impossible value (all 1s) so it won't get
-	 * swapped under us.  The rcu_read_lock makes sure that
-	 * parent_ctx continues to exist even if it gets swapped to
-	 * another process and then freed while we are trying to get
-	 * its lock.
+	 * If the parent's context is a clone, pin it so it won't get
+	 * swapped under us.
 	 */
-	rcu_read_lock();
- retry:
-	parent_ctx = rcu_dereference(parent->perf_counter_ctxp);
+	parent_ctx = perf_pin_task_context(parent);
+
 	/*
 	 * No need to check if parent_ctx != NULL here; since we saw
 	 * it non-NULL earlier, the only reason for it to become NULL
 	 * is if we exit, and since we're currently in the middle of
 	 * a fork we can't be exiting at the same time.
 	 */
-	spin_lock_irq(&parent_ctx->lock);
-	if (parent_ctx != rcu_dereference(parent->perf_counter_ctxp)) {
-		spin_unlock_irq(&parent_ctx->lock);
-		goto retry;
-	}
-	cloned_gen = parent_ctx->parent_gen;
-	if (parent_ctx->parent_ctx)
-		parent_ctx->parent_gen = ~0ull;
-	spin_unlock_irq(&parent_ctx->lock);
-	rcu_read_unlock();
 
 	/*
 	 * Lock the parent list. No need to lock the child - not PID
@@ -3759,7 +3787,7 @@ int perf_counter_init_task(struct task_struct *child)
 		cloned_ctx = rcu_dereference(parent_ctx->parent_ctx);
 		if (cloned_ctx) {
 			child_ctx->parent_ctx = cloned_ctx;
-			child_ctx->parent_gen = cloned_gen;
+			child_ctx->parent_gen = parent_ctx->parent_gen;
 		} else {
 			child_ctx->parent_ctx = parent_ctx;
 			child_ctx->parent_gen = parent_ctx->generation;
@@ -3769,15 +3797,7 @@ int perf_counter_init_task(struct task_struct *child)
 
 	mutex_unlock(&parent_ctx->mutex);
 
-	/*
-	 * Restore the clone status of the parent.
-	 */
-	if (parent_ctx->parent_ctx) {
-		spin_lock_irq(&parent_ctx->lock);
-		if (parent_ctx->parent_ctx)
-			parent_ctx->parent_gen = cloned_gen;
-		spin_unlock_irq(&parent_ctx->lock);
-	}
+	perf_unpin_context(parent_ctx);
 
 	return ret;
 }
-- 
1.6.0.4


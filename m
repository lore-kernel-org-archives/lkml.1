Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbZE2MEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbZE2MEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbZE2MEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:04:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:33027 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204AbZE2MEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:04:13 -0400
Date: Fri, 29 May 2009 12:03:33 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18975.31580.520676.619896@drongo.ozlabs.ibm.com>
References: <18975.31580.520676.619896@drongo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: Don't swap contexts containing locked mutex
Message-ID: <tip-ad3a37de81c45f6c20d410ece86004b98f7b6d84@git.kernel.org>
Git-Commit-ID: ad3a37de81c45f6c20d410ece86004b98f7b6d84
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 12:03:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad3a37de81c45f6c20d410ece86004b98f7b6d84
Gitweb:     http://git.kernel.org/tip/ad3a37de81c45f6c20d410ece86004b98f7b6d84
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Fri, 29 May 2009 16:06:20 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 11:02:46 +0200

perf_counter: Don't swap contexts containing locked mutex

Peter Zijlstra pointed out that under some circumstances, we can take
the mutex in a context or a counter and then swap that context or
counter to another task, potentially leading to lock order inversions
or the mutexes not protecting what they are supposed to protect.

This fixes the problem by making sure that we never take a mutex in a
context or counter which could get swapped to another task.  Most of
the cases where we take a mutex is on a top-level counter or context,
i.e. a counter which has an fd associated with it or a context that
contains such a counter.  This adds WARN_ON_ONCE statements to verify
that.

The two cases where we need to take the mutex on a context that is a
clone of another are in perf_counter_exit_task and
perf_counter_init_task.  The perf_counter_exit_task case is solved by
uncloning the context before starting to remove the counters from it.
The perf_counter_init_task is a little trickier; we temporarily
disable context swapping for the parent (forking) task by setting its
ctx->parent_gen to the all-1s value after locking the context, if it
is a cloned context, and restore the ctx->parent_gen value at the end
if the context didn't get uncloned in the meantime.

This also moves the increment of the context generation count to be
within the same critical section, protected by the context mutex, that
adds the new counter to the context.  That way, taking the mutex is
sufficient to ensure that both the counter list and the generation
count are stable.

[ Impact: fix hangs, races with inherited and PID counters ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <18975.31580.520676.619896@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   89 +++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 79 insertions(+), 10 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 52e5a15..db843f8 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -919,7 +919,8 @@ static int context_equiv(struct perf_counter_context *ctx1,
 			 struct perf_counter_context *ctx2)
 {
 	return ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx
-		&& ctx1->parent_gen == ctx2->parent_gen;
+		&& ctx1->parent_gen == ctx2->parent_gen
+		&& ctx1->parent_gen != ~0ull;
 }
 
 /*
@@ -1339,7 +1340,6 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 			put_ctx(parent_ctx);
 			ctx->parent_ctx = NULL;		/* no longer a clone */
 		}
-		++ctx->generation;
 		/*
 		 * Get an extra reference before dropping the lock so that
 		 * this context won't get freed if the task exits.
@@ -1414,6 +1414,7 @@ static int perf_release(struct inode *inode, struct file *file)
 
 	file->private_data = NULL;
 
+	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_counter_remove_from_context(counter);
 	mutex_unlock(&ctx->mutex);
@@ -1445,6 +1446,7 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 	if (counter->state == PERF_COUNTER_STATE_ERROR)
 		return 0;
 
+	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	mutex_lock(&counter->child_mutex);
 	values[0] = perf_counter_read(counter);
 	n = 1;
@@ -1504,6 +1506,7 @@ static void perf_counter_for_each_sibling(struct perf_counter *counter,
 	struct perf_counter_context *ctx = counter->ctx;
 	struct perf_counter *sibling;
 
+	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	counter = counter->group_leader;
 
@@ -1524,6 +1527,7 @@ static void perf_counter_for_each_child(struct perf_counter *counter,
 {
 	struct perf_counter *child;
 
+	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	mutex_lock(&counter->child_mutex);
 	func(counter);
 	list_for_each_entry(child, &counter->child_list, child_list)
@@ -1536,6 +1540,7 @@ static void perf_counter_for_each(struct perf_counter *counter,
 {
 	struct perf_counter *child;
 
+	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	mutex_lock(&counter->child_mutex);
 	perf_counter_for_each_sibling(counter, func);
 	list_for_each_entry(child, &counter->child_list, child_list)
@@ -1741,6 +1746,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_counter *counter = vma->vm_file->private_data;
 
+	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	if (atomic_dec_and_mutex_lock(&counter->mmap_count,
 				      &counter->mmap_mutex)) {
 		struct user_struct *user = current_user();
@@ -1788,6 +1794,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
 
+	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	mutex_lock(&counter->mmap_mutex);
 	if (atomic_inc_not_zero(&counter->mmap_count)) {
 		if (nr_pages != counter->data->nr_pages)
@@ -3349,8 +3356,10 @@ SYSCALL_DEFINE5(perf_counter_open,
 		goto err_free_put_context;
 
 	counter->filp = counter_file;
+	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, counter, cpu);
+	++ctx->generation;
 	mutex_unlock(&ctx->mutex);
 
 	counter->owner = current;
@@ -3436,6 +3445,7 @@ inherit_counter(struct perf_counter *parent_counter,
 	/*
 	 * Link this into the parent counter's child list
 	 */
+	WARN_ON_ONCE(parent_counter->ctx->parent_ctx);
 	mutex_lock(&parent_counter->child_mutex);
 	list_add_tail(&child_counter->child_list, &parent_counter->child_list);
 	mutex_unlock(&parent_counter->child_mutex);
@@ -3485,6 +3495,7 @@ static void sync_child_counter(struct perf_counter *child_counter,
 	/*
 	 * Remove this counter from the parent's list
 	 */
+	WARN_ON_ONCE(parent_counter->ctx->parent_ctx);
 	mutex_lock(&parent_counter->child_mutex);
 	list_del_init(&child_counter->child_list);
 	mutex_unlock(&parent_counter->child_mutex);
@@ -3527,12 +3538,17 @@ void perf_counter_exit_task(struct task_struct *child)
 	struct perf_counter_context *child_ctx;
 	unsigned long flags;
 
-	child_ctx = child->perf_counter_ctxp;
-
-	if (likely(!child_ctx))
+	if (likely(!child->perf_counter_ctxp))
 		return;
 
 	local_irq_save(flags);
+	/*
+	 * We can't reschedule here because interrupts are disabled,
+	 * and either child is current or it is a task that can't be
+	 * scheduled, so we are now safe from rescheduling changing
+	 * our context.
+	 */
+	child_ctx = child->perf_counter_ctxp;
 	__perf_counter_task_sched_out(child_ctx);
 
 	/*
@@ -3542,6 +3558,15 @@ void perf_counter_exit_task(struct task_struct *child)
 	 */
 	spin_lock(&child_ctx->lock);
 	child->perf_counter_ctxp = NULL;
+	if (child_ctx->parent_ctx) {
+		/*
+		 * This context is a clone; unclone it so it can't get
+		 * swapped to another process while we're removing all
+		 * the counters from it.
+		 */
+		put_ctx(child_ctx->parent_ctx);
+		child_ctx->parent_ctx = NULL;
+	}
 	spin_unlock(&child_ctx->lock);
 	local_irq_restore(flags);
 
@@ -3571,9 +3596,11 @@ again:
 int perf_counter_init_task(struct task_struct *child)
 {
 	struct perf_counter_context *child_ctx, *parent_ctx;
+	struct perf_counter_context *cloned_ctx;
 	struct perf_counter *counter;
 	struct task_struct *parent = current;
 	int inherited_all = 1;
+	u64 cloned_gen;
 	int ret = 0;
 
 	child->perf_counter_ctxp = NULL;
@@ -3581,8 +3608,7 @@ int perf_counter_init_task(struct task_struct *child)
 	mutex_init(&child->perf_counter_mutex);
 	INIT_LIST_HEAD(&child->perf_counter_list);
 
-	parent_ctx = parent->perf_counter_ctxp;
-	if (likely(!parent_ctx || !parent_ctx->nr_counters))
+	if (likely(!parent->perf_counter_ctxp))
 		return 0;
 
 	/*
@@ -3600,6 +3626,34 @@ int perf_counter_init_task(struct task_struct *child)
 	get_task_struct(child);
 
 	/*
+	 * If the parent's context is a clone, temporarily set its
+	 * parent_gen to an impossible value (all 1s) so it won't get
+	 * swapped under us.  The rcu_read_lock makes sure that
+	 * parent_ctx continues to exist even if it gets swapped to
+	 * another process and then freed while we are trying to get
+	 * its lock.
+	 */
+	rcu_read_lock();
+ retry:
+	parent_ctx = rcu_dereference(parent->perf_counter_ctxp);
+	/*
+	 * No need to check if parent_ctx != NULL here; since we saw
+	 * it non-NULL earlier, the only reason for it to become NULL
+	 * is if we exit, and since we're currently in the middle of
+	 * a fork we can't be exiting at the same time.
+	 */
+	spin_lock_irq(&parent_ctx->lock);
+	if (parent_ctx != rcu_dereference(parent->perf_counter_ctxp)) {
+		spin_unlock_irq(&parent_ctx->lock);
+		goto retry;
+	}
+	cloned_gen = parent_ctx->parent_gen;
+	if (parent_ctx->parent_ctx)
+		parent_ctx->parent_gen = ~0ull;
+	spin_unlock_irq(&parent_ctx->lock);
+	rcu_read_unlock();
+
+	/*
 	 * Lock the parent list. No need to lock the child - not PID
 	 * hashed yet and not running, so nobody can access it.
 	 */
@@ -3630,10 +3684,15 @@ int perf_counter_init_task(struct task_struct *child)
 		/*
 		 * Mark the child context as a clone of the parent
 		 * context, or of whatever the parent is a clone of.
+		 * Note that if the parent is a clone, it could get
+		 * uncloned at any point, but that doesn't matter
+		 * because the list of counters and the generation
+		 * count can't have changed since we took the mutex.
 		 */
-		if (parent_ctx->parent_ctx) {
-			child_ctx->parent_ctx = parent_ctx->parent_ctx;
-			child_ctx->parent_gen = parent_ctx->parent_gen;
+		cloned_ctx = rcu_dereference(parent_ctx->parent_ctx);
+		if (cloned_ctx) {
+			child_ctx->parent_ctx = cloned_ctx;
+			child_ctx->parent_gen = cloned_gen;
 		} else {
 			child_ctx->parent_ctx = parent_ctx;
 			child_ctx->parent_gen = parent_ctx->generation;
@@ -3643,6 +3702,16 @@ int perf_counter_init_task(struct task_struct *child)
 
 	mutex_unlock(&parent_ctx->mutex);
 
+	/*
+	 * Restore the clone status of the parent.
+	 */
+	if (parent_ctx->parent_ctx) {
+		spin_lock_irq(&parent_ctx->lock);
+		if (parent_ctx->parent_ctx)
+			parent_ctx->parent_gen = cloned_gen;
+		spin_unlock_irq(&parent_ctx->lock);
+	}
+
 	return ret;
 }
 

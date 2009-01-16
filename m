Return-Path: <linux-kernel-owner+w=401wt.eu-S1765138AbZAPKm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765138AbZAPKm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZAPKmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:42:17 -0500
Received: from ozlabs.org ([203.10.76.45]:47868 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbZAPKmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:42:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18800.25726.604410.232889@cargo.ozlabs.ibm.com>
Date: Fri, 16 Jan 2009 21:42:06 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH] perf_counter: Add counter enable/disable ioctls
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: New perf_counter features

This primarily adds a way for perf_counter users to enable and disable
counters and groups.  Enabling or disabling a counter or group also
enables or disables all of the child counters that have been cloned
from it to monitor children of the task monitored by the top-level
counter.  The userspace interface to enable/disable counters is via
ioctl on the counter file descriptor.

Along the way this extends the code that handles child counters to
handle child counter groups properly.  A group with multiple counters
will be cloned to child tasks if and only if the group leader has the
hw_event.inherit bit set - if it is set the whole group is cloned as a
group in the child task.

In order to be able to enable or disable all child counters of a given
top-level counter, we need a way to find them all.  Hence I have added
a child_list field to struct perf_counter, which is the head of the
list of children for a top-level counter, or the link in that list for
a child counter.  That list is protected by the perf_counter.mutex
field.

This also adds a mutex to the perf_counter_context struct.  Previously
the list of counters was protected just by the lock field in the
context, which meant that perf_counter_init_task had to take that lock
and then take whatever lock/mutex protects the top-level counter's
child_list.  But the counter enable/disable functions need to take
that lock in order to traverse the list, then for each counter take
the lock in that counter's context in order to change the counter's
state safely, which will lead to a deadlock.

To solve this, we now have both a mutex and a spinlock in the context,
and taking either is sufficient to ensure the list of counters can't
change - you have to take both before changing the list.  Now
perf_counter_init_task takes the mutex instead of the lock (which
incidentally means that inherit_counter can use GFP_KERNEL instead of
GFP_ATOMIC) and thus avoids the possible deadlock.  Similarly the new
enable/disable functions can take the mutex while traversing the list
of child counters without incurring a possible deadlock when the
counter manipulation code locks the context for a child counter.

We also had an misfeature that the first counter added to a context
would possibly not go on until the next sched-in, because we were
using ctx->nr_active to detect if the context was running on a CPU.
But nr_active is the number of active counters, and if that was zero
(because the context didn't have any counters yet) it would look like
the context wasn't running on a cpu and so the retry code in
__perf_install_in_context wouldn't retry.  So this adds an 'is_active'
field that is set when the context is on a CPU, even if it has no
counters.  The is_active field is only used for task contexts, not for
per-cpu contexts.

If we enable a subsidiary counter in a group that is active on a CPU,
and the arch code can't enable the counter, then we have to pull the
whole group off the CPU.  We do this with group_sched_out, which gets
moved up in the file so it comes before all its callers.  This also
adds similar logic to __perf_install_in_context so that the "all on,
or none" invariant of groups is preserved when adding a new counter to
a group.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This is not in my git tree yet because I haven't tested these new
features (well, it builds and boots and passes simple tests, but I
haven't tested the new ioctls yet).

I have to admit to a small element of cargo-cult programming in
__perf_counter_enable and __perf_counter_disable: I put calls to
curr_rq_lock_irq_save/restore in there because I was following the
model of __perf_install_in_context, but I don't know what they do
(beyond disabling/restoring interrupts) or why they are needed.  What
are they there for?

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 7ab8e5f..33ba9fe 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -14,6 +14,7 @@
 #define _LINUX_PERF_COUNTER_H
 
 #include <asm/atomic.h>
+#include <asm/ioctl.h>
 
 #ifdef CONFIG_PERF_COUNTERS
 # include <asm/perf_counter.h>
@@ -95,6 +96,12 @@ struct perf_counter_hw_event {
 };
 
 /*
+ * Ioctls that can be done on a perf counter fd:
+ */
+#define PERF_COUNTER_IOC_ENABLE		_IO('$', 0)
+#define PERF_COUNTER_IOC_DISABLE	_IO('$', 1)
+
+/*
  * Kernel-internal data types:
  */
 
@@ -173,8 +180,10 @@ struct perf_counter {
 	struct file			*filp;
 
 	struct perf_counter		*parent;
+	struct list_head		child_list;
+
 	/*
-	 * Protect attach/detach:
+	 * Protect attach/detach and child_list:
 	 */
 	struct mutex			mutex;
 
@@ -199,13 +208,21 @@ struct perf_counter {
 struct perf_counter_context {
 #ifdef CONFIG_PERF_COUNTERS
 	/*
-	 * Protect the list of counters:
+	 * Protect the states of the counters in the list,
+	 * nr_active, and the list:
 	 */
 	spinlock_t		lock;
+	/*
+	 * Protect the list of counters.  Locking either mutex or lock
+	 * is sufficient to ensure the list doesn't change; to change
+	 * the list you need to lock both the mutex and the spinlock.
+	 */
+	struct mutex		mutex;
 
 	struct list_head	counter_list;
 	int			nr_counters;
 	int			nr_active;
+	int			is_active;
 	struct task_struct	*task;
 #endif
 };
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index faf671b..36407f3 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -112,6 +112,28 @@ counter_sched_out(struct perf_counter *counter,
 		cpuctx->exclusive = 0;
 }
 
+static void
+group_sched_out(struct perf_counter *group_counter,
+		struct perf_cpu_context *cpuctx,
+		struct perf_counter_context *ctx)
+{
+	struct perf_counter *counter;
+
+	if (group_counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return;
+
+	counter_sched_out(group_counter, cpuctx, ctx);
+
+	/*
+	 * Schedule out siblings (if any):
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry)
+		counter_sched_out(counter, cpuctx, ctx);
+
+	if (group_counter->hw_event.exclusive)
+		cpuctx->exclusive = 0;
+}
+
 /*
  * Cross CPU call to remove a performance counter
  *
@@ -168,7 +190,7 @@ static void __perf_counter_remove_from_context(void *info)
 /*
  * Remove the counter from a task's (or a CPU's) list of counters.
  *
- * Must be called with counter->mutex held.
+ * Must be called with counter->mutex and ctx->mutex held.
  *
  * CPU counters are removed with a smp call. For task counters we only
  * call when the task is on a CPU.
@@ -215,6 +237,99 @@ retry:
 	spin_unlock_irq(&ctx->lock);
 }
 
+/*
+ * Cross CPU call to disable a performance counter
+ */
+static void __perf_counter_disable(void *info)
+{
+	struct perf_counter *counter = info;
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter_context *ctx = counter->ctx;
+	unsigned long flags;
+
+	/*
+	 * If this is a per-task counter, need to check whether this
+	 * counter's task is the current task on this cpu.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	/*
+	 * If the counter is on, turn it off.
+	 * If it is in error state, leave it in error state.
+	 */
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
+		if (counter == counter->group_leader)
+			group_sched_out(counter, cpuctx, ctx);
+		else
+			counter_sched_out(counter, cpuctx, ctx);
+		counter->state = PERF_COUNTER_STATE_OFF;
+	}
+
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+/*
+ * Disable a counter.
+ */
+static void perf_counter_disable(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		/*
+		 * Disable the counter on the cpu that it's on
+		 */
+		smp_call_function_single(counter->cpu, __perf_counter_disable,
+					 counter, 1);
+		return;
+	}
+
+ retry:
+	task_oncpu_function_call(task, __perf_counter_disable, counter);
+
+	spin_lock_irq(&ctx->lock);
+	/*
+	 * If the counter is still active, we need to retry the cross-call.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
+		spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * Since we have the lock this context can't be scheduled
+	 * in, so we can change the state safely.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+		counter->state = PERF_COUNTER_STATE_OFF;
+
+	spin_unlock_irq(&ctx->lock);
+}
+
+/*
+ * Disable a counter and all its children.
+ */
+static void perf_counter_disable_family(struct perf_counter *counter)
+{
+	struct perf_counter *child;
+
+	perf_counter_disable(counter);
+
+	/*
+	 * Lock the mutex to protect the list of children
+	 */
+	mutex_lock(&counter->mutex);
+	list_for_each_entry(child, &counter->child_list, child_list)
+		perf_counter_disable(child);
+	mutex_unlock(&counter->mutex);
+}
+
 static int
 counter_sched_in(struct perf_counter *counter,
 		 struct perf_cpu_context *cpuctx,
@@ -302,6 +417,7 @@ static void __perf_install_in_context(void *info)
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_counter *counter = info;
 	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_counter *leader = counter->group_leader;
 	int cpu = smp_processor_id();
 	unsigned long flags;
 	u64 perf_flags;
@@ -328,22 +444,39 @@ static void __perf_install_in_context(void *info)
 	ctx->nr_counters++;
 
 	/*
+	 * Don't put the counter on if it is disabled or if
+	 * it is in a group and the group isn't on.
+	 */
+	if (counter->state != PERF_COUNTER_STATE_INACTIVE ||
+	    (leader != counter && leader->state != PERF_COUNTER_STATE_ACTIVE))
+		goto unlock;
+
+	/*
 	 * An exclusive counter can't go on if there are already active
 	 * hardware counters, and no hardware counter can go on if there
 	 * is already an exclusive counter on.
 	 */
-	if (counter->state == PERF_COUNTER_STATE_INACTIVE &&
-	    !group_can_go_on(counter, cpuctx, 1))
+	if (!group_can_go_on(counter, cpuctx, 1))
 		err = -EEXIST;
 	else
 		err = counter_sched_in(counter, cpuctx, ctx, cpu);
 
-	if (err && counter->hw_event.pinned)
-		counter->state = PERF_COUNTER_STATE_ERROR;
+	if (err) {
+		/*
+		 * This counter couldn't go on.  If it is in a group
+		 * then we have to pull the whole group off.
+		 * If the counter group is pinned then put it in error state.
+		 */
+		if (leader != counter)
+			group_sched_out(leader, cpuctx, ctx);
+		if (leader->hw_event.pinned)
+			leader->state = PERF_COUNTER_STATE_ERROR;
+	}
 
 	if (!err && !ctx->task && cpuctx->max_pertask)
 		cpuctx->max_pertask--;
 
+ unlock:
 	hw_perf_restore(perf_flags);
 
 	spin_unlock(&ctx->lock);
@@ -359,6 +492,8 @@ static void __perf_install_in_context(void *info)
  * If the counter is attached to a task which is on a CPU we use a smp
  * call to enable it in the task context. The task might have been
  * scheduled away, but we check this in the smp call again.
+ *
+ * Must be called with ctx->mutex held.
  */
 static void
 perf_install_in_context(struct perf_counter_context *ctx,
@@ -387,7 +522,7 @@ retry:
 	/*
 	 * we need to retry the smp call.
 	 */
-	if (ctx->nr_active && list_empty(&counter->list_entry)) {
+	if (ctx->is_active && list_empty(&counter->list_entry)) {
 		spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
@@ -404,26 +539,131 @@ retry:
 	spin_unlock_irq(&ctx->lock);
 }
 
-static void
-group_sched_out(struct perf_counter *group_counter,
-		struct perf_cpu_context *cpuctx,
-		struct perf_counter_context *ctx)
+/*
+ * Cross CPU call to enable a performance counter
+ */
+static void __perf_counter_enable(void *info)
 {
-	struct perf_counter *counter;
+	struct perf_counter *counter = info;
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_counter *leader = counter->group_leader;
+	unsigned long flags;
+	int err;
 
-	if (group_counter->state != PERF_COUNTER_STATE_ACTIVE)
+	/*
+	 * If this is a per-task counter, need to check whether this
+	 * counter's task is the current task on this cpu.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	counter_sched_out(group_counter, cpuctx, ctx);
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
+		goto unlock;
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
 
 	/*
-	 * Schedule out siblings (if any):
+	 * If the counter is in a group and isn't the group leader,
+	 * then don't put it on unless the group is on.
 	 */
-	list_for_each_entry(counter, &group_counter->sibling_list, list_entry)
-		counter_sched_out(counter, cpuctx, ctx);
+	if (leader != counter && leader->state != PERF_COUNTER_STATE_ACTIVE)
+		goto unlock;
 
-	if (group_counter->hw_event.exclusive)
-		cpuctx->exclusive = 0;
+	if (!group_can_go_on(counter, cpuctx, 1))
+		err = -EEXIST;
+	else
+		err = counter_sched_in(counter, cpuctx, ctx,
+				       smp_processor_id());
+
+	if (err) {
+		/*
+		 * If this counter can't go on and it's part of a
+		 * group, then the whole group has to come off.
+		 */
+		if (leader != counter)
+			group_sched_out(leader, cpuctx, ctx);
+		if (leader->hw_event.pinned)
+			leader->state = PERF_COUNTER_STATE_ERROR;
+	}
+
+ unlock:
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+/*
+ * Enable a counter.
+ */
+static void perf_counter_enable(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		/*
+		 * Enable the counter on the cpu that it's on
+		 */
+		smp_call_function_single(counter->cpu, __perf_counter_enable,
+					 counter, 1);
+		return;
+	}
+
+	spin_lock_irq(&ctx->lock);
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
+		goto out;
+
+	/*
+	 * If the counter is in error state, clear that first.
+	 * That way, if we see the counter in error state below, we
+	 * know that it has gone back into error state, as distinct
+	 * from the task having been scheduled away before the
+	 * cross-call arrived.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ERROR)
+		counter->state = PERF_COUNTER_STATE_OFF;
+
+ retry:
+	spin_unlock_irq(&ctx->lock);
+	task_oncpu_function_call(task, __perf_counter_enable, counter);
+
+	spin_lock_irq(&ctx->lock);
+
+	/*
+	 * If the context is active and the counter is still off,
+	 * we need to retry the cross-call.
+	 */
+	if (ctx->is_active && counter->state == PERF_COUNTER_STATE_OFF)
+		goto retry;
+
+	/*
+	 * Since we have the lock this context can't be scheduled
+	 * in, so we can change the state safely.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_OFF)
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+ out:
+	spin_unlock_irq(&ctx->lock);
+}
+
+/*
+ * Enable a counter and all its children.
+ */
+static void perf_counter_enable_family(struct perf_counter *counter)
+{
+	struct perf_counter *child;
+
+	perf_counter_enable(counter);
+
+	/*
+	 * Lock the mutex to protect the list of children
+	 */
+	mutex_lock(&counter->mutex);
+	list_for_each_entry(child, &counter->child_list, child_list)
+		perf_counter_enable(child);
+	mutex_unlock(&counter->mutex);
 }
 
 void __perf_counter_sched_out(struct perf_counter_context *ctx,
@@ -432,16 +672,18 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 	struct perf_counter *counter;
 	u64 flags;
 
+	spin_lock(&ctx->lock);
+	ctx->is_active = 0;
 	if (likely(!ctx->nr_counters))
-		return;
+		goto out;
 
-	spin_lock(&ctx->lock);
 	flags = hw_perf_save_disable();
 	if (ctx->nr_active) {
 		list_for_each_entry(counter, &ctx->counter_list, list_entry)
 			group_sched_out(counter, cpuctx, ctx);
 	}
 	hw_perf_restore(flags);
+ out:
 	spin_unlock(&ctx->lock);
 }
 
@@ -528,10 +770,11 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 	u64 flags;
 	int can_add_hw = 1;
 
+	spin_lock(&ctx->lock);
+	ctx->is_active = 1;
 	if (likely(!ctx->nr_counters))
-		return;
+		goto out;
 
-	spin_lock(&ctx->lock);
 	flags = hw_perf_save_disable();
 
 	/*
@@ -578,6 +821,7 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 		}
 	}
 	hw_perf_restore(flags);
+ out:
 	spin_unlock(&ctx->lock);
 }
 
@@ -896,12 +1140,14 @@ static int perf_release(struct inode *inode, struct file *file)
 
 	file->private_data = NULL;
 
+	mutex_lock(&ctx->mutex);
 	mutex_lock(&counter->mutex);
 
 	perf_counter_remove_from_context(counter);
 	put_context(ctx);
 
 	mutex_unlock(&counter->mutex);
+	mutex_unlock(&ctx->mutex);
 
 	kfree(counter);
 
@@ -1053,10 +1299,29 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	return events;
 }
 
+static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct perf_counter *counter = file->private_data;
+	int err;
+
+	switch (cmd) {
+	case PERF_COUNTER_IOC_ENABLE:
+		perf_counter_enable_family(counter);
+		break;
+	case PERF_COUNTER_IOC_DISABLE:
+		perf_counter_disable_family(counter);
+		break;
+	default:
+		err = -ENOTTY;
+	}
+	return err;
+}
+
 static const struct file_operations perf_fops = {
 	.release		= perf_release,
 	.read			= perf_read,
 	.poll			= perf_poll,
+	.unlocked_ioctl		= perf_ioctl,
 };
 
 static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
@@ -1348,6 +1613,8 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	INIT_LIST_HEAD(&counter->sibling_list);
 	init_waitqueue_head(&counter->waitq);
 
+	INIT_LIST_HEAD(&counter->child_list);
+
 	counter->irqdata		= &counter->data[0];
 	counter->usrdata		= &counter->data[1];
 	counter->cpu			= cpu;
@@ -1452,7 +1719,9 @@ sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr __user,
 		goto err_free_put_context;
 
 	counter->filp = counter_file;
+	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, counter, cpu);
+	mutex_unlock(&ctx->mutex);
 
 	fput_light(counter_file, fput_needed2);
 
@@ -1479,6 +1748,7 @@ __perf_counter_init_context(struct perf_counter_context *ctx,
 {
 	memset(ctx, 0, sizeof(*ctx));
 	spin_lock_init(&ctx->lock);
+	mutex_init(&ctx->mutex);
 	INIT_LIST_HEAD(&ctx->counter_list);
 	ctx->task = task;
 }
@@ -1486,20 +1756,30 @@ __perf_counter_init_context(struct perf_counter_context *ctx,
 /*
  * inherit a counter from parent task to child task:
  */
-static int
+static struct perf_counter *
 inherit_counter(struct perf_counter *parent_counter,
 	      struct task_struct *parent,
 	      struct perf_counter_context *parent_ctx,
 	      struct task_struct *child,
+	      struct perf_counter *group_leader,
 	      struct perf_counter_context *child_ctx)
 {
 	struct perf_counter *child_counter;
 
+	/*
+	 * Instead of creating recursive hierarchies of counters,
+	 * we link inherited counters back to the original parent,
+	 * which has a filp for sure, which we use as the reference
+	 * count:
+	 */
+	if (parent_counter->parent)
+		parent_counter = parent_counter->parent;
+
 	child_counter = perf_counter_alloc(&parent_counter->hw_event,
-					    parent_counter->cpu, NULL,
-					    GFP_ATOMIC);
+					    parent_counter->cpu, group_leader,
+					    GFP_KERNEL);
 	if (!child_counter)
-		return -ENOMEM;
+		return NULL;
 
 	/*
 	 * Link it up in the child's context:
@@ -1523,16 +1803,74 @@ inherit_counter(struct perf_counter *parent_counter,
 	 */
 	atomic_long_inc(&parent_counter->filp->f_count);
 
+	if (parent_counter) {
+		/*
+		 * Link this into the parent counter's child list
+		 */
+		mutex_lock(&parent_counter->mutex);
+		list_add_tail(&child_counter->child_list,
+			      &parent_counter->child_list);
+		mutex_unlock(&parent_counter->mutex);
+	}
+
+	return child_counter;
+}
+
+static int inherit_group(struct perf_counter *parent_counter,
+	      struct task_struct *parent,
+	      struct perf_counter_context *parent_ctx,
+	      struct task_struct *child,
+	      struct perf_counter_context *child_ctx)
+{
+	struct perf_counter *leader;
+	struct perf_counter *sub;
+
+	leader = inherit_counter(parent_counter, parent, parent_ctx,
+				 child, NULL, child_ctx);
+	if (!leader)
+		return -ENOMEM;
+	list_for_each_entry(sub, &parent_counter->sibling_list, list_entry) {
+		if (!inherit_counter(sub, parent, parent_ctx,
+				     child, leader, child_ctx))
+			return -ENOMEM;
+	}
 	return 0;
 }
 
+static void sync_child_counter(struct perf_counter *child_counter,
+			       struct perf_counter *parent_counter)
+{
+	u64 parent_val, child_val;
+
+	parent_val = atomic64_read(&parent_counter->count);
+	child_val = atomic64_read(&child_counter->count);
+
+	/*
+	 * Add back the child's count to the parent's count:
+	 */
+	atomic64_add(child_val, &parent_counter->count);
+
+	/*
+	 * Remove this counter from the parent's list
+	 */
+	mutex_lock(&parent_counter->mutex);
+	list_del_init(&child_counter->child_list);
+	mutex_unlock(&parent_counter->mutex);
+
+	/*
+	 * Release the parent counter, if this was the last
+	 * reference to it.
+	 */
+	fput(parent_counter->filp);
+}
+
 static void
 __perf_counter_exit_task(struct task_struct *child,
 			 struct perf_counter *child_counter,
 			 struct perf_counter_context *child_ctx)
 {
 	struct perf_counter *parent_counter;
-	u64 parent_val, child_val;
+	struct perf_counter *sub, *tmp;
 
 	/*
 	 * If we do not self-reap then we have to wait for the
@@ -1561,7 +1899,7 @@ __perf_counter_exit_task(struct task_struct *child,
 
 		cpuctx = &__get_cpu_var(perf_cpu_context);
 
-		counter_sched_out(child_counter, cpuctx, child_ctx);
+		group_sched_out(child_counter, cpuctx, child_ctx);
 
 		list_del_init(&child_counter->list_entry);
 
@@ -1577,26 +1915,23 @@ __perf_counter_exit_task(struct task_struct *child,
 	 * that are still around due to the child reference. These
 	 * counters need to be zapped - but otherwise linger.
 	 */
-	if (!parent_counter)
-		return;
-
-	parent_val = atomic64_read(&parent_counter->count);
-	child_val = atomic64_read(&child_counter->count);
-
-	/*
-	 * Add back the child's count to the parent's count:
-	 */
-	atomic64_add(child_val, &parent_counter->count);
-
-	fput(parent_counter->filp);
+	if (parent_counter) {
+		sync_child_counter(child_counter, parent_counter);
+		list_for_each_entry_safe(sub, tmp, &child_counter->sibling_list,
+					 list_entry) {
+			if (sub->parent)
+				sync_child_counter(sub, sub->parent);
+			kfree(sub);
+		}
+	}
 
 	kfree(child_counter);
 }
 
 /*
- * When a child task exist, feed back counter values to parent counters.
+ * When a child task exits, feed back counter values to parent counters.
  *
- * Note: we are running in child context, but the PID is not hashed
+ * Note: we may be running in child context, but the PID is not hashed
  * anymore so new counters will not be added.
  */
 void perf_counter_exit_task(struct task_struct *child)
@@ -1620,9 +1955,8 @@ void perf_counter_exit_task(struct task_struct *child)
 void perf_counter_init_task(struct task_struct *child)
 {
 	struct perf_counter_context *child_ctx, *parent_ctx;
-	struct perf_counter *counter, *parent_counter;
+	struct perf_counter *counter;
 	struct task_struct *parent = current;
-	unsigned long flags;
 
 	child_ctx  =  &child->perf_counter_ctx;
 	parent_ctx = &parent->perf_counter_ctx;
@@ -1641,32 +1975,22 @@ void perf_counter_init_task(struct task_struct *child)
 	 * Lock the parent list. No need to lock the child - not PID
 	 * hashed yet and not running, so nobody can access it.
 	 */
-	spin_lock_irqsave(&parent_ctx->lock, flags);
+	mutex_lock(&parent_ctx->mutex);
 
 	/*
 	 * We dont have to disable NMIs - we are only looking at
 	 * the list, not manipulating it:
 	 */
 	list_for_each_entry(counter, &parent_ctx->counter_list, list_entry) {
-		if (!counter->hw_event.inherit || counter->group_leader != counter)
+		if (!counter->hw_event.inherit)
 			continue;
 
-		/*
-		 * Instead of creating recursive hierarchies of counters,
-		 * we link inheritd counters back to the original parent,
-		 * which has a filp for sure, which we use as the reference
-		 * count:
-		 */
-		parent_counter = counter;
-		if (counter->parent)
-			parent_counter = counter->parent;
-
-		if (inherit_counter(parent_counter, parent,
+		if (inherit_group(counter, parent,
 				  parent_ctx, child, child_ctx))
 			break;
 	}
 
-	spin_unlock_irqrestore(&parent_ctx->lock, flags);
+	mutex_unlock(&parent_ctx->mutex);
 }
 
 static void __cpuinit perf_counter_init_cpu(int cpu)
@@ -1692,11 +2016,15 @@ static void __perf_counter_exit_cpu(void *info)
 
 	list_for_each_entry_safe(counter, tmp, &ctx->counter_list, list_entry)
 		__perf_counter_remove_from_context(counter);
-
 }
 static void perf_counter_exit_cpu(int cpu)
 {
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &cpuctx->ctx;
+
+	mutex_lock(&ctx->mutex);
 	smp_call_function_single(cpu, __perf_counter_exit_cpu, NULL, 1);
+	mutex_unlock(&ctx->mutex);
 }
 #else
 static inline void perf_counter_exit_cpu(int cpu) { }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbZANJZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbZANJZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbZANJYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:24:51 -0500
Received: from ozlabs.org ([203.10.76.45]:40870 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbZANJYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:24:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18797.44875.470975.535175@cargo.ozlabs.ibm.com>
Date: Wed, 14 Jan 2009 20:24:27 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH] perf_counter: Add support for pinned and exclusive counter groups
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: New perf_counter features

A pinned counter group is one that the user wants to have on the CPU
whenever possible, i.e. whenever the associated task is running, for
a per-task group, or always for a per-cpu group.  If the system
cannot satisfy that, it puts the group into an error state where
it is not scheduled any more and reads from it return EOF (i.e. 0
bytes read).  The group can be released from error state and made
readable again using prctl(PR_TASK_PERF_COUNTERS_ENABLE).  When we
have finer-grained enable/disable controls on counters we'll be able
to reset the error state on individual groups.

An exclusive group is one that the user wants to be the only group
using the CPU performance monitor hardware whenever it is on.  The
counter group scheduler will not schedule an exclusive group if there
are already other groups on the CPU and will not schedule other groups
onto the CPU if there is an exclusive group scheduled (that statement
does not apply to groups containing only software counters, which can
always go on and which do not prevent an exclusive group from going on).
With an exclusive group, we will be able to let users program PMU
registers at a low level without the concern that those settings will
perturb other measurements.

Along the way this reorganizes things a little:
- is_software_counter() is moved to perf_counter.h.
- cpuctx->active_oncpu now records the number of hardware counters on
  the CPU, i.e. it now excludes software counters.  Nothing was reading
  cpuctx->active_oncpu before, so this change is harmless.
- A new cpuctx->exclusive field records whether we currently have an
  exclusive group on the CPU.
- counter_sched_out moves higher up in perf_counter.c and gets called
  from __perf_counter_remove_from_context and __perf_counter_exit_task,
  where we used to have essentially the same code.
- __perf_counter_sched_in now goes through the counter list twice, doing
  the pinned counters in the first loop and the non-pinned counters in
  the second loop, in order to give the pinned counters the best chance
  to be scheduled in.

Note that only a group leader can be exclusive or pinned, and that
attribute applies to the whole group.  This avoids some awkwardness in
some corner cases (e.g. where a group leader is closed and the other
group members get added to the context list).  If we want to relax that
restriction later, we can, and it is easier to relax a restriction than
to apply a new one.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
What this doesn't handle is when a pinned counter gets inherited and
goes into error state in the child.  The sensible thing would be to
put the parent counter into error state in __perf_counter_exit_task,
but that might mean taking it off the PMU on some other CPU, and I was
nervous about doing anything substantial to parent_counter.  Maybe
what we need instead of an error value for counter->state is a
separate error flag that can be set atomically by exiting children.
BTW, I think we need an smp_wmb after updating parent_counter->count,
so that when the parent sees the child has exited it is guaranteed to
see the updated ->count value.

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 85ad259..5b02113 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -36,14 +36,6 @@ void perf_counter_print_debug(void)
 }
 
 /*
- * Return 1 for a software counter, 0 for a hardware counter
- */
-static inline int is_software_counter(struct perf_counter *counter)
-{
-	return !counter->hw_event.raw && counter->hw_event.type < 0;
-}
-
-/*
  * Read one performance monitor counter (PMC).
  */
 static unsigned long read_pmc(int idx)
@@ -443,6 +435,7 @@ int hw_perf_group_sched_in(struct perf_counter *group_leader,
 	 */
 	for (i = n0; i < n0 + n; ++i)
 		cpuhw->counter[i]->hw.config = cpuhw->events[i];
+	cpuctx->active_oncpu += n;
 	n = 1;
 	counter_sched_in(group_leader, cpu);
 	list_for_each_entry(sub, &group_leader->sibling_list, list_entry) {
@@ -451,7 +444,6 @@ int hw_perf_group_sched_in(struct perf_counter *group_leader,
 			++n;
 		}
 	}
-	cpuctx->active_oncpu += n;
 	ctx->nr_active += n;
 
 	return 1;
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index b21d1ea..7ab8e5f 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -86,7 +86,10 @@ struct perf_counter_hw_event {
 				nmi	     :  1, /* NMI sampling        */
 				raw	     :  1, /* raw event type      */
 				inherit	     :  1, /* children inherit it */
-				__reserved_1 : 28;
+				pinned	     :  1, /* must always be on PMU */
+				exclusive    :  1, /* only counter on PMU */
+
+				__reserved_1 : 26;
 
 	u64			__reserved_2;
 };
@@ -141,6 +144,7 @@ struct hw_perf_counter_ops {
  * enum perf_counter_active_state - the states of a counter
  */
 enum perf_counter_active_state {
+	PERF_COUNTER_STATE_ERROR	= -2,
 	PERF_COUNTER_STATE_OFF		= -1,
 	PERF_COUNTER_STATE_INACTIVE	=  0,
 	PERF_COUNTER_STATE_ACTIVE	=  1,
@@ -214,6 +218,7 @@ struct perf_cpu_context {
 	struct perf_counter_context	*task_ctx;
 	int				active_oncpu;
 	int				max_pertask;
+	int				exclusive;
 };
 
 /*
@@ -240,6 +245,14 @@ extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_counter_context *ctx, int cpu);
 
+/*
+ * Return 1 for a software counter, 0 for a hardware counter
+ */
+static inline int is_software_counter(struct perf_counter *counter)
+{
+	return !counter->hw_event.raw && counter->hw_event.type < 0;
+}
+
 #else
 static inline void
 perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 52f2f52..faf671b 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -93,6 +93,25 @@ list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	}
 }
 
+static void
+counter_sched_out(struct perf_counter *counter,
+		  struct perf_cpu_context *cpuctx,
+		  struct perf_counter_context *ctx)
+{
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return;
+
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	counter->hw_ops->disable(counter);
+	counter->oncpu = -1;
+
+	if (!is_software_counter(counter))
+		cpuctx->active_oncpu--;
+	ctx->nr_active--;
+	if (counter->hw_event.exclusive || !cpuctx->active_oncpu)
+		cpuctx->exclusive = 0;
+}
+
 /*
  * Cross CPU call to remove a performance counter
  *
@@ -118,14 +137,9 @@ static void __perf_counter_remove_from_context(void *info)
 	curr_rq_lock_irq_save(&flags);
 	spin_lock(&ctx->lock);
 
-	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
-		counter->state = PERF_COUNTER_STATE_INACTIVE;
-		counter->hw_ops->disable(counter);
-		ctx->nr_active--;
-		cpuctx->active_oncpu--;
-		counter->task = NULL;
-		counter->oncpu = -1;
-	}
+	counter_sched_out(counter, cpuctx, ctx);
+
+	counter->task = NULL;
 	ctx->nr_counters--;
 
 	/*
@@ -207,7 +221,7 @@ counter_sched_in(struct perf_counter *counter,
 		 struct perf_counter_context *ctx,
 		 int cpu)
 {
-	if (counter->state == PERF_COUNTER_STATE_OFF)
+	if (counter->state <= PERF_COUNTER_STATE_OFF)
 		return 0;
 
 	counter->state = PERF_COUNTER_STATE_ACTIVE;
@@ -223,13 +237,64 @@ counter_sched_in(struct perf_counter *counter,
 		return -EAGAIN;
 	}
 
-	cpuctx->active_oncpu++;
+	if (!is_software_counter(counter))
+		cpuctx->active_oncpu++;
 	ctx->nr_active++;
 
+	if (counter->hw_event.exclusive)
+		cpuctx->exclusive = 1;
+
 	return 0;
 }
 
 /*
+ * Return 1 for a group consisting entirely of software counters,
+ * 0 if the group contains any hardware counters.
+ */
+static int is_software_only_group(struct perf_counter *leader)
+{
+	struct perf_counter *counter;
+
+	if (!is_software_counter(leader))
+		return 0;
+	list_for_each_entry(counter, &leader->sibling_list, list_entry)
+		if (!is_software_counter(counter))
+			return 0;
+	return 1;
+}
+
+/*
+ * Work out whether we can put this counter group on the CPU now.
+ */
+static int group_can_go_on(struct perf_counter *counter,
+			   struct perf_cpu_context *cpuctx,
+			   int can_add_hw)
+{
+	/*
+	 * Groups consisting entirely of software counters can always go on.
+	 */
+	if (is_software_only_group(counter))
+		return 1;
+	/*
+	 * If an exclusive group is already on, no other hardware
+	 * counters can go on.
+	 */
+	if (cpuctx->exclusive)
+		return 0;
+	/*
+	 * If this group is exclusive and there are already
+	 * counters on the CPU, it can't go on.
+	 */
+	if (counter->hw_event.exclusive && cpuctx->active_oncpu)
+		return 0;
+	/*
+	 * Otherwise, try to add it if all previous groups were able
+	 * to go on.
+	 */
+	return can_add_hw;
+}
+
+/*
  * Cross CPU call to install and enable a performance counter
  */
 static void __perf_install_in_context(void *info)
@@ -240,6 +305,7 @@ static void __perf_install_in_context(void *info)
 	int cpu = smp_processor_id();
 	unsigned long flags;
 	u64 perf_flags;
+	int err;
 
 	/*
 	 * If this is a task context, we need to check whether it is
@@ -261,9 +327,21 @@ static void __perf_install_in_context(void *info)
 	list_add_counter(counter, ctx);
 	ctx->nr_counters++;
 
-	counter_sched_in(counter, cpuctx, ctx, cpu);
+	/*
+	 * An exclusive counter can't go on if there are already active
+	 * hardware counters, and no hardware counter can go on if there
+	 * is already an exclusive counter on.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_INACTIVE &&
+	    !group_can_go_on(counter, cpuctx, 1))
+		err = -EEXIST;
+	else
+		err = counter_sched_in(counter, cpuctx, ctx, cpu);
+
+	if (err && counter->hw_event.pinned)
+		counter->state = PERF_COUNTER_STATE_ERROR;
 
-	if (!ctx->task && cpuctx->max_pertask)
+	if (!err && !ctx->task && cpuctx->max_pertask)
 		cpuctx->max_pertask--;
 
 	hw_perf_restore(perf_flags);
@@ -327,22 +405,6 @@ retry:
 }
 
 static void
-counter_sched_out(struct perf_counter *counter,
-		  struct perf_cpu_context *cpuctx,
-		  struct perf_counter_context *ctx)
-{
-	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
-		return;
-
-	counter->state = PERF_COUNTER_STATE_INACTIVE;
-	counter->hw_ops->disable(counter);
-	counter->oncpu = -1;
-
-	cpuctx->active_oncpu--;
-	ctx->nr_active--;
-}
-
-static void
 group_sched_out(struct perf_counter *group_counter,
 		struct perf_cpu_context *cpuctx,
 		struct perf_counter_context *ctx)
@@ -359,6 +421,9 @@ group_sched_out(struct perf_counter *group_counter,
 	 */
 	list_for_each_entry(counter, &group_counter->sibling_list, list_entry)
 		counter_sched_out(counter, cpuctx, ctx);
+
+	if (group_counter->hw_event.exclusive)
+		cpuctx->exclusive = 0;
 }
 
 void __perf_counter_sched_out(struct perf_counter_context *ctx,
@@ -455,30 +520,6 @@ group_error:
 	return -EAGAIN;
 }
 
-/*
- * Return 1 for a software counter, 0 for a hardware counter
- */
-static inline int is_software_counter(struct perf_counter *counter)
-{
-	return !counter->hw_event.raw && counter->hw_event.type < 0;
-}
-
-/*
- * Return 1 for a group consisting entirely of software counters,
- * 0 if the group contains any hardware counters.
- */
-static int is_software_only_group(struct perf_counter *leader)
-{
-	struct perf_counter *counter;
-
-	if (!is_software_counter(leader))
-		return 0;
-	list_for_each_entry(counter, &leader->sibling_list, list_entry)
-		if (!is_software_counter(counter))
-			return 0;
-	return 1;
-}
-
 static void
 __perf_counter_sched_in(struct perf_counter_context *ctx,
 			struct perf_cpu_context *cpuctx, int cpu)
@@ -492,22 +533,49 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 
 	spin_lock(&ctx->lock);
 	flags = hw_perf_save_disable();
+
+	/*
+	 * First go through the list and put on any pinned groups
+	 * in order to give them the best chance of going on.
+	 */
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (counter->state <= PERF_COUNTER_STATE_OFF ||
+		    !counter->hw_event.pinned)
+			continue;
+		if (counter->cpu != -1 && counter->cpu != cpu)
+			continue;
+
+		if (group_can_go_on(counter, cpuctx, 1))
+			group_sched_in(counter, cpuctx, ctx, cpu);
+
+		/*
+		 * If this pinned group hasn't been scheduled,
+		 * put it in error state.
+		 */
+		if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+			counter->state = PERF_COUNTER_STATE_ERROR;
+	}
+
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
 		/*
+		 * Ignore counters in OFF or ERROR state, and
+		 * ignore pinned counters since we did them already.
+		 */
+		if (counter->state <= PERF_COUNTER_STATE_OFF ||
+		    counter->hw_event.pinned)
+			continue;
+
+		/*
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of counters:
 		 */
 		if (counter->cpu != -1 && counter->cpu != cpu)
 			continue;
 
-		/*
-		 * If we scheduled in a group atomically and exclusively,
-		 * or if this group can't go on, don't add any more
-		 * hardware counters.
-		 */
-		if (can_add_hw || is_software_only_group(counter))
+		if (group_can_go_on(counter, cpuctx, can_add_hw)) {
 			if (group_sched_in(counter, cpuctx, ctx, cpu))
 				can_add_hw = 0;
+		}
 	}
 	hw_perf_restore(flags);
 	spin_unlock(&ctx->lock);
@@ -567,8 +635,10 @@ int perf_counter_task_disable(void)
 	 */
 	perf_flags = hw_perf_save_disable();
 
-	list_for_each_entry(counter, &ctx->counter_list, list_entry)
-		counter->state = PERF_COUNTER_STATE_OFF;
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (counter->state != PERF_COUNTER_STATE_ERROR)
+			counter->state = PERF_COUNTER_STATE_OFF;
+	}
 
 	hw_perf_restore(perf_flags);
 
@@ -607,7 +677,7 @@ int perf_counter_task_enable(void)
 	perf_flags = hw_perf_save_disable();
 
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
-		if (counter->state != PERF_COUNTER_STATE_OFF)
+		if (counter->state > PERF_COUNTER_STATE_OFF)
 			continue;
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
 		counter->hw_event.disabled = 0;
@@ -849,6 +919,14 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 	if (count != sizeof(cntval))
 		return -EINVAL;
 
+	/*
+	 * Return end-of-file for a read on a counter that is in
+	 * error state (i.e. because it was pinned but it couldn't be
+	 * scheduled on to the CPU at some point).
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ERROR)
+		return 0;
+
 	mutex_lock(&counter->mutex);
 	cntval = perf_counter_read(counter);
 	mutex_unlock(&counter->mutex);
@@ -884,7 +962,7 @@ perf_read_irq_data(struct perf_counter	*counter,
 {
 	struct perf_data *irqdata, *usrdata;
 	DECLARE_WAITQUEUE(wait, current);
-	ssize_t res;
+	ssize_t res, res2;
 
 	irqdata = counter->irqdata;
 	usrdata = counter->usrdata;
@@ -905,6 +983,9 @@ perf_read_irq_data(struct perf_counter	*counter,
 		if (signal_pending(current))
 			break;
 
+		if (counter->state == PERF_COUNTER_STATE_ERROR)
+			break;
+
 		spin_unlock_irq(&counter->waitq.lock);
 		schedule();
 		spin_lock_irq(&counter->waitq.lock);
@@ -913,7 +994,8 @@ perf_read_irq_data(struct perf_counter	*counter,
 	__set_current_state(TASK_RUNNING);
 	spin_unlock_irq(&counter->waitq.lock);
 
-	if (usrdata->len + irqdata->len < count)
+	if (usrdata->len + irqdata->len < count &&
+	    counter->state != PERF_COUNTER_STATE_ERROR)
 		return -ERESTARTSYS;
 read_pending:
 	mutex_lock(&counter->mutex);
@@ -925,11 +1007,12 @@ read_pending:
 
 	/* Switch irq buffer: */
 	usrdata = perf_switch_irq_data(counter);
-	if (perf_copy_usrdata(usrdata, buf + res, count - res) < 0) {
+	res2 = perf_copy_usrdata(usrdata, buf + res, count - res);
+	if (res2 < 0) {
 		if (!res)
 			res = -EFAULT;
 	} else {
-		res = count;
+		res += res2;
 	}
 out:
 	mutex_unlock(&counter->mutex);
@@ -1348,6 +1431,11 @@ sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr __user,
 		 */
 		if (group_leader->ctx != ctx)
 			goto err_put_context;
+		/*
+		 * Only a group leader can be exclusive or pinned
+		 */
+		if (hw_event.exclusive || hw_event.pinned)
+			goto err_put_context;
 	}
 
 	ret = -EINVAL;
@@ -1473,13 +1561,7 @@ __perf_counter_exit_task(struct task_struct *child,
 
 		cpuctx = &__get_cpu_var(perf_cpu_context);
 
-		if (child_counter->state == PERF_COUNTER_STATE_ACTIVE) {
-			child_counter->state = PERF_COUNTER_STATE_INACTIVE;
-			child_counter->hw_ops->disable(child_counter);
-			cpuctx->active_oncpu--;
-			child_ctx->nr_active--;
-			child_counter->oncpu = -1;
-		}
+		counter_sched_out(child_counter, cpuctx, child_ctx);
 
 		list_del_init(&child_counter->list_entry);
 

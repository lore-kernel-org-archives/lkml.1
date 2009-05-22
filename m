Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbZEVK2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbZEVK2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZEVK2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:28:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:51777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700AbZEVK2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:28:41 -0400
Date: Fri, 22 May 2009 10:27:58 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
References: <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: Optimize context switch between identical inherited contexts
Message-ID: <tip-564c2b210add41df9a3a5aaa365c1d97cff6110d@git.kernel.org>
Git-Commit-ID: 564c2b210add41df9a3a5aaa365c1d97cff6110d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 22 May 2009 10:27:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  564c2b210add41df9a3a5aaa365c1d97cff6110d
Gitweb:     http://git.kernel.org/tip/564c2b210add41df9a3a5aaa365c1d97cff6110d
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Fri, 22 May 2009 14:27:22 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 May 2009 12:18:20 +0200

perf_counter: Optimize context switch between identical inherited contexts

When monitoring a process and its descendants with a set of inherited
counters, we can often get the situation in a context switch where
both the old (outgoing) and new (incoming) process have the same set
of counters, and their values are ultimately going to be added together.
In that situation it doesn't matter which set of counters are used to
count the activity for the new process, so there is really no need to
go through the process of reading the hardware counters and updating
the old task's counters and then setting up the PMU for the new task.

This optimizes the context switch in this situation.  Instead of
scheduling out the perf_counter_context for the old task and
scheduling in the new context, we simply transfer the old context
to the new task and keep using it without interruption.  The new
context gets transferred to the old task.  This means that both
tasks still have a valid perf_counter_context, so no special case
is introduced when the old task gets scheduled in again, either on
this CPU or another CPU.

The equivalence of contexts is detected by keeping a pointer in
each cloned context pointing to the context it was cloned from.
To cope with the situation where a context is changed by adding
or removing counters after it has been cloned, we also keep a
generation number on each context which is incremented every time
a context is changed.  When a context is cloned we take a copy
of the parent's generation number, and two cloned contexts are
equivalent only if they have the same parent and the same
generation number.  In order that the parent context pointer
remains valid (and is not reused), we increment the parent
context's reference count for each context cloned from it.

Since we don't have individual fds for the counters in a cloned
context, the only thing that can make two clones of a given parent
different after they have been cloned is enabling or disabling all
counters with prctl.  To account for this, we keep a count of the
number of enabled counters in each context.  Two contexts must have
the same number of enabled counters to be considered equivalent.

Here are some measurements of the context switch time as measured with
the lat_ctx benchmark from lmbench, comparing the times obtained with
and without this patch series:

		-----Unmodified-----		With this patch series
Counters:	none	2 HW	4H+4S	none	2 HW	4H+4S

2 processes:
Average		3.44	6.45	11.24	3.12	3.39	3.60
St dev		0.04	0.04	0.13	0.05	0.17	0.19

8 processes:
Average		6.45	8.79	14.00	5.57	6.23	7.57
St dev		1.27	1.04	0.88	1.42	1.46	1.42

32 processes:
Average		5.56	8.43	13.78	5.28	5.55	7.15
St dev		0.41	0.47	0.53	0.54	0.57	0.81

The numbers are the mean and standard deviation of 20 runs of
lat_ctx.  The "none" columns are lat_ctx run directly without any
counters.  The "2 HW" columns are with lat_ctx run under perfstat,
counting cycles and instructions.  The "4H+4S" columns are lat_ctx run
under perfstat with 4 hardware counters and 4 software counters
(cycles, instructions, cache references, cache misses, task
clock, context switch, cpu migrations, and page faults).

[ Impact: performance optimization of counter context-switches ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   12 ++++-
 kernel/perf_counter.c        |  109 ++++++++++++++++++++++++++++++++++++-----
 kernel/sched.c               |    2 +-
 3 files changed, 107 insertions(+), 16 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 0713090..4cae01a 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -513,6 +513,7 @@ struct perf_counter_context {
 	struct list_head	event_list;
 	int			nr_counters;
 	int			nr_active;
+	int			nr_enabled;
 	int			is_active;
 	atomic_t		refcount;
 	struct task_struct	*task;
@@ -522,6 +523,14 @@ struct perf_counter_context {
 	 */
 	u64			time;
 	u64			timestamp;
+
+	/*
+	 * These fields let us detect when two contexts have both
+	 * been cloned (inherited) from a common ancestor.
+	 */
+	struct perf_counter_context *parent_ctx;
+	u32			parent_gen;
+	u32			generation;
 };
 
 /**
@@ -552,7 +561,8 @@ extern int perf_max_counters;
 extern const struct pmu *hw_perf_counter_init(struct perf_counter *counter);
 
 extern void perf_counter_task_sched_in(struct task_struct *task, int cpu);
-extern void perf_counter_task_sched_out(struct task_struct *task, int cpu);
+extern void perf_counter_task_sched_out(struct task_struct *task,
+					struct task_struct *next, int cpu);
 extern void perf_counter_task_tick(struct task_struct *task, int cpu);
 extern void perf_counter_init_task(struct task_struct *child);
 extern void perf_counter_exit_task(struct task_struct *child);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 06ea3ea..c100554 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -104,8 +104,11 @@ static void get_ctx(struct perf_counter_context *ctx)
 
 static void put_ctx(struct perf_counter_context *ctx)
 {
-	if (atomic_dec_and_test(&ctx->refcount))
+	if (atomic_dec_and_test(&ctx->refcount)) {
+		if (ctx->parent_ctx)
+			put_ctx(ctx->parent_ctx);
 		kfree(ctx);
+	}
 }
 
 static void
@@ -127,6 +130,8 @@ list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 
 	list_add_rcu(&counter->event_entry, &ctx->event_list);
 	ctx->nr_counters++;
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
+		ctx->nr_enabled++;
 }
 
 /*
@@ -141,6 +146,8 @@ list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	if (list_empty(&counter->list_entry))
 		return;
 	ctx->nr_counters--;
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
+		ctx->nr_enabled--;
 
 	list_del_init(&counter->list_entry);
 	list_del_rcu(&counter->event_entry);
@@ -204,6 +211,22 @@ group_sched_out(struct perf_counter *group_counter,
 }
 
 /*
+ * Mark this context as not being a clone of another.
+ * Called when counters are added to or removed from this context.
+ * We also increment our generation number so that anything that
+ * was cloned from this context before this will not match anything
+ * cloned from this context after this.
+ */
+static void unclone_ctx(struct perf_counter_context *ctx)
+{
+	++ctx->generation;
+	if (!ctx->parent_ctx)
+		return;
+	put_ctx(ctx->parent_ctx);
+	ctx->parent_ctx = NULL;
+}
+
+/*
  * Cross CPU call to remove a performance counter
  *
  * We disable the counter on the hardware level first. After that we
@@ -263,6 +286,7 @@ static void perf_counter_remove_from_context(struct perf_counter *counter)
 	struct perf_counter_context *ctx = counter->ctx;
 	struct task_struct *task = ctx->task;
 
+	unclone_ctx(ctx);
 	if (!task) {
 		/*
 		 * Per cpu counters are removed via an smp call and
@@ -378,6 +402,7 @@ static void __perf_counter_disable(void *info)
 		else
 			counter_sched_out(counter, cpuctx, ctx);
 		counter->state = PERF_COUNTER_STATE_OFF;
+		ctx->nr_enabled--;
 	}
 
 	spin_unlock_irqrestore(&ctx->lock, flags);
@@ -419,6 +444,7 @@ static void perf_counter_disable(struct perf_counter *counter)
 	if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
 		update_counter_times(counter);
 		counter->state = PERF_COUNTER_STATE_OFF;
+		ctx->nr_enabled--;
 	}
 
 	spin_unlock_irq(&ctx->lock);
@@ -727,6 +753,7 @@ static void __perf_counter_enable(void *info)
 		goto unlock;
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
 	counter->tstamp_enabled = ctx->time - counter->total_time_enabled;
+	ctx->nr_enabled++;
 
 	/*
 	 * If the counter is in a group and isn't the group leader,
@@ -817,6 +844,7 @@ static void perf_counter_enable(struct perf_counter *counter)
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
 		counter->tstamp_enabled =
 			ctx->time - counter->total_time_enabled;
+		ctx->nr_enabled++;
 	}
  out:
 	spin_unlock_irq(&ctx->lock);
@@ -862,6 +890,25 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 }
 
 /*
+ * Test whether two contexts are equivalent, i.e. whether they
+ * have both been cloned from the same version of the same context
+ * and they both have the same number of enabled counters.
+ * If the number of enabled counters is the same, then the set
+ * of enabled counters should be the same, because these are both
+ * inherited contexts, therefore we can't access individual counters
+ * in them directly with an fd; we can only enable/disable all
+ * counters via prctl, or enable/disable all counters in a family
+ * via ioctl, which will have the same effect on both contexts.
+ */
+static int context_equiv(struct perf_counter_context *ctx1,
+			 struct perf_counter_context *ctx2)
+{
+	return ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx
+		&& ctx1->parent_gen == ctx2->parent_gen
+		&& ctx1->nr_enabled == ctx2->nr_enabled;
+}
+
+/*
  * Called from scheduler to remove the counters of the current task,
  * with interrupts disabled.
  *
@@ -872,10 +919,12 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
  * accessing the counter control register. If a NMI hits, then it will
  * not restart the counter.
  */
-void perf_counter_task_sched_out(struct task_struct *task, int cpu)
+void perf_counter_task_sched_out(struct task_struct *task,
+				 struct task_struct *next, int cpu)
 {
 	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
 	struct perf_counter_context *ctx = task->perf_counter_ctxp;
+	struct perf_counter_context *next_ctx;
 	struct pt_regs *regs;
 
 	if (likely(!ctx || !cpuctx->task_ctx))
@@ -885,6 +934,16 @@ void perf_counter_task_sched_out(struct task_struct *task, int cpu)
 
 	regs = task_pt_regs(task);
 	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
+
+	next_ctx = next->perf_counter_ctxp;
+	if (next_ctx && context_equiv(ctx, next_ctx)) {
+		task->perf_counter_ctxp = next_ctx;
+		next->perf_counter_ctxp = ctx;
+		ctx->task = next;
+		next_ctx->task = task;
+		return;
+	}
+
 	__perf_counter_sched_out(ctx, cpuctx);
 
 	cpuctx->task_ctx = NULL;
@@ -998,6 +1057,8 @@ void perf_counter_task_sched_in(struct task_struct *task, int cpu)
 
 	if (likely(!ctx))
 		return;
+	if (cpuctx->task_ctx == ctx)
+		return;
 	__perf_counter_sched_in(ctx, cpuctx, cpu);
 	cpuctx->task_ctx = ctx;
 }
@@ -3253,6 +3314,16 @@ inherit_counter(struct perf_counter *parent_counter,
 		return child_counter;
 
 	/*
+	 * Make the child state follow the state of the parent counter,
+	 * not its hw_event.disabled bit.  We hold the parent's mutex,
+	 * so we won't race with perf_counter_{en,dis}able_family.
+	 */
+	if (parent_counter->state >= PERF_COUNTER_STATE_INACTIVE)
+		child_counter->state = PERF_COUNTER_STATE_INACTIVE;
+	else
+		child_counter->state = PERF_COUNTER_STATE_OFF;
+
+	/*
 	 * Link it up in the child's context:
 	 */
 	add_counter_to_ctx(child_counter, child_ctx);
@@ -3277,16 +3348,6 @@ inherit_counter(struct perf_counter *parent_counter,
 	mutex_lock(&parent_counter->mutex);
 	list_add_tail(&child_counter->child_list, &parent_counter->child_list);
 
-	/*
-	 * Make the child state follow the state of the parent counter,
-	 * not its hw_event.disabled bit.  We hold the parent's mutex,
-	 * so we won't race with perf_counter_{en,dis}able_family.
-	 */
-	if (parent_counter->state >= PERF_COUNTER_STATE_INACTIVE)
-		child_counter->state = PERF_COUNTER_STATE_INACTIVE;
-	else
-		child_counter->state = PERF_COUNTER_STATE_OFF;
-
 	mutex_unlock(&parent_counter->mutex);
 
 	return child_counter;
@@ -3429,6 +3490,7 @@ void perf_counter_init_task(struct task_struct *child)
 	struct perf_counter_context *child_ctx, *parent_ctx;
 	struct perf_counter *counter;
 	struct task_struct *parent = current;
+	int inherited_all = 1;
 
 	child->perf_counter_ctxp = NULL;
 
@@ -3463,12 +3525,31 @@ void perf_counter_init_task(struct task_struct *child)
 		if (counter != counter->group_leader)
 			continue;
 
-		if (!counter->hw_event.inherit)
+		if (!counter->hw_event.inherit) {
+			inherited_all = 0;
 			continue;
+		}
 
 		if (inherit_group(counter, parent,
-				  parent_ctx, child, child_ctx))
+				  parent_ctx, child, child_ctx)) {
+			inherited_all = 0;
 			break;
+		}
+	}
+
+	if (inherited_all) {
+		/*
+		 * Mark the child context as a clone of the parent
+		 * context, or of whatever the parent is a clone of.
+		 */
+		if (parent_ctx->parent_ctx) {
+			child_ctx->parent_ctx = parent_ctx->parent_ctx;
+			child_ctx->parent_gen = parent_ctx->parent_gen;
+		} else {
+			child_ctx->parent_ctx = parent_ctx;
+			child_ctx->parent_gen = parent_ctx->generation;
+		}
+		get_ctx(child_ctx->parent_ctx);
 	}
 
 	mutex_unlock(&parent_ctx->mutex);
diff --git a/kernel/sched.c b/kernel/sched.c
index 419a39d..4c0d58b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5091,7 +5091,7 @@ need_resched_nonpreemptible:
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
-		perf_counter_task_sched_out(prev, cpu);
+		perf_counter_task_sched_out(prev, next, cpu);
 
 		rq->nr_switches++;
 		rq->curr = next;

Return-Path: <linux-kernel-owner+w=401wt.eu-S934302AbZLFSFC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302AbZLFSFC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:05:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934247AbZLFSE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:04:58 -0500
Received: from www.tglx.de ([62.245.132.106]:33328 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934249AbZLFSEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:04:07 -0500
Message-Id: <20091206111958.146106628@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:03:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 22/23] perf_event: Convert to raw_spinlock
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=perf-convert-to-core-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/perf_event.h |    2 
 kernel/hw_breakpoint.c     |    4 -
 kernel/perf_event.c        |  106 ++++++++++++++++++++++-----------------------
 3 files changed, 56 insertions(+), 56 deletions(-)

Index: linux-2.6-tip/include/linux/perf_event.h
===================================================================
--- linux-2.6-tip.orig/include/linux/perf_event.h
+++ linux-2.6-tip/include/linux/perf_event.h
@@ -685,7 +685,7 @@ struct perf_event_context {
 	 * Protect the states of the events in the list,
 	 * nr_active, and the list:
 	 */
-	spinlock_t			lock;
+	raw_spinlock_t			lock;
 	/*
 	 * Protect the list of events.  Locking either mutex or lock
 	 * is sufficient to ensure the list doesn't change; to change
Index: linux-2.6-tip/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip/kernel/hw_breakpoint.c
@@ -130,7 +130,7 @@ static void toggle_bp_task_slot(struct t
 
 	list = &ctx->event_list;
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	raw_spin_lock_irqsave(&ctx->lock, flags);
 
 	/*
 	 * The current breakpoint counter is not included in the list
@@ -141,7 +141,7 @@ static void toggle_bp_task_slot(struct t
 			count++;
 	}
 
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	raw_spin_unlock_irqrestore(&ctx->lock, flags);
 
 	if (WARN_ONCE(count < 0, "No breakpoint counter found in the counter list"))
 		return;
Index: linux-2.6-tip/kernel/perf_event.c
===================================================================
--- linux-2.6-tip.orig/kernel/perf_event.c
+++ linux-2.6-tip/kernel/perf_event.c
@@ -203,14 +203,14 @@ perf_lock_task_context(struct task_struc
 		 * if so.  If we locked the right context, then it
 		 * can't get swapped on us any more.
 		 */
-		spin_lock_irqsave(&ctx->lock, *flags);
+		raw_spin_lock_irqsave(&ctx->lock, *flags);
 		if (ctx != rcu_dereference(task->perf_event_ctxp)) {
-			spin_unlock_irqrestore(&ctx->lock, *flags);
+			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
 			goto retry;
 		}
 
 		if (!atomic_inc_not_zero(&ctx->refcount)) {
-			spin_unlock_irqrestore(&ctx->lock, *flags);
+			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
 			ctx = NULL;
 		}
 	}
@@ -231,7 +231,7 @@ static struct perf_event_context *perf_p
 	ctx = perf_lock_task_context(task, &flags);
 	if (ctx) {
 		++ctx->pin_count;
-		spin_unlock_irqrestore(&ctx->lock, flags);
+		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 	return ctx;
 }
@@ -240,9 +240,9 @@ static void perf_unpin_context(struct pe
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	raw_spin_lock_irqsave(&ctx->lock, flags);
 	--ctx->pin_count;
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	put_ctx(ctx);
 }
 
@@ -427,7 +427,7 @@ static void __perf_event_remove_from_con
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	spin_lock(&ctx->lock);
+	raw_spin_lock(&ctx->lock);
 	/*
 	 * Protect the list operation against NMI by disabling the
 	 * events on a global level.
@@ -449,7 +449,7 @@ static void __perf_event_remove_from_con
 	}
 
 	perf_enable();
-	spin_unlock(&ctx->lock);
+	raw_spin_unlock(&ctx->lock);
 }
 
 
@@ -488,12 +488,12 @@ retry:
 	task_oncpu_function_call(task, __perf_event_remove_from_context,
 				 event);
 
-	spin_lock_irq(&ctx->lock);
+	raw_spin_lock_irq(&ctx->lock);
 	/*
 	 * If the context is active we need to retry the smp call.
 	 */
 	if (ctx->nr_active && !list_empty(&event->group_entry)) {
-		spin_unlock_irq(&ctx->lock);
+		raw_spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
 
@@ -504,7 +504,7 @@ retry:
 	 */
 	if (!list_empty(&event->group_entry))
 		list_del_event(event, ctx);
-	spin_unlock_irq(&ctx->lock);
+	raw_spin_unlock_irq(&ctx->lock);
 }
 
 /*
@@ -535,7 +535,7 @@ static void __perf_event_disable(void *i
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	spin_lock(&ctx->lock);
+	raw_spin_lock(&ctx->lock);
 
 	/*
 	 * If the event is on, turn it off.
@@ -551,7 +551,7 @@ static void __perf_event_disable(void *i
 		event->state = PERF_EVENT_STATE_OFF;
 	}
 
-	spin_unlock(&ctx->lock);
+	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -584,12 +584,12 @@ static void perf_event_disable(struct pe
  retry:
 	task_oncpu_function_call(task, __perf_event_disable, event);
 
-	spin_lock_irq(&ctx->lock);
+	raw_spin_lock_irq(&ctx->lock);
 	/*
 	 * If the event is still active, we need to retry the cross-call.
 	 */
 	if (event->state == PERF_EVENT_STATE_ACTIVE) {
-		spin_unlock_irq(&ctx->lock);
+		raw_spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
 
@@ -602,7 +602,7 @@ static void perf_event_disable(struct pe
 		event->state = PERF_EVENT_STATE_OFF;
 	}
 
-	spin_unlock_irq(&ctx->lock);
+	raw_spin_unlock_irq(&ctx->lock);
 }
 
 static int
@@ -770,7 +770,7 @@ static void __perf_install_in_context(vo
 		cpuctx->task_ctx = ctx;
 	}
 
-	spin_lock(&ctx->lock);
+	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	update_context_time(ctx);
 
@@ -820,7 +820,7 @@ static void __perf_install_in_context(vo
  unlock:
 	perf_enable();
 
-	spin_unlock(&ctx->lock);
+	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -856,12 +856,12 @@ retry:
 	task_oncpu_function_call(task, __perf_install_in_context,
 				 event);
 
-	spin_lock_irq(&ctx->lock);
+	raw_spin_lock_irq(&ctx->lock);
 	/*
 	 * we need to retry the smp call.
 	 */
 	if (ctx->is_active && list_empty(&event->group_entry)) {
-		spin_unlock_irq(&ctx->lock);
+		raw_spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
 
@@ -872,7 +872,7 @@ retry:
 	 */
 	if (list_empty(&event->group_entry))
 		add_event_to_ctx(event, ctx);
-	spin_unlock_irq(&ctx->lock);
+	raw_spin_unlock_irq(&ctx->lock);
 }
 
 /*
@@ -917,7 +917,7 @@ static void __perf_event_enable(void *in
 		cpuctx->task_ctx = ctx;
 	}
 
-	spin_lock(&ctx->lock);
+	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	update_context_time(ctx);
 
@@ -959,7 +959,7 @@ static void __perf_event_enable(void *in
 	}
 
  unlock:
-	spin_unlock(&ctx->lock);
+	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -985,7 +985,7 @@ static void perf_event_enable(struct per
 		return;
 	}
 
-	spin_lock_irq(&ctx->lock);
+	raw_spin_lock_irq(&ctx->lock);
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
 		goto out;
 
@@ -1000,10 +1000,10 @@ static void perf_event_enable(struct per
 		event->state = PERF_EVENT_STATE_OFF;
 
  retry:
-	spin_unlock_irq(&ctx->lock);
+	raw_spin_unlock_irq(&ctx->lock);
 	task_oncpu_function_call(task, __perf_event_enable, event);
 
-	spin_lock_irq(&ctx->lock);
+	raw_spin_lock_irq(&ctx->lock);
 
 	/*
 	 * If the context is active and the event is still off,
@@ -1020,7 +1020,7 @@ static void perf_event_enable(struct per
 		__perf_event_mark_enabled(event, ctx);
 
  out:
-	spin_unlock_irq(&ctx->lock);
+	raw_spin_unlock_irq(&ctx->lock);
 }
 
 static int perf_event_refresh(struct perf_event *event, int refresh)
@@ -1042,7 +1042,7 @@ void __perf_event_sched_out(struct perf_
 {
 	struct perf_event *event;
 
-	spin_lock(&ctx->lock);
+	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 0;
 	if (likely(!ctx->nr_events))
 		goto out;
@@ -1055,7 +1055,7 @@ void __perf_event_sched_out(struct perf_
 	}
 	perf_enable();
  out:
-	spin_unlock(&ctx->lock);
+	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -1193,8 +1193,8 @@ void perf_event_task_sched_out(struct ta
 		 * order we take the locks because no other cpu could
 		 * be trying to lock both of these tasks.
 		 */
-		spin_lock(&ctx->lock);
-		spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);
+		raw_spin_lock(&ctx->lock);
+		raw_spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);
 		if (context_equiv(ctx, next_ctx)) {
 			/*
 			 * XXX do we need a memory barrier of sorts
@@ -1208,8 +1208,8 @@ void perf_event_task_sched_out(struct ta
 
 			perf_event_sync_stat(ctx, next_ctx);
 		}
-		spin_unlock(&next_ctx->lock);
-		spin_unlock(&ctx->lock);
+		raw_spin_unlock(&next_ctx->lock);
+		raw_spin_unlock(&ctx->lock);
 	}
 	rcu_read_unlock();
 
@@ -1251,7 +1251,7 @@ __perf_event_sched_in(struct perf_event_
 	struct perf_event *event;
 	int can_add_hw = 1;
 
-	spin_lock(&ctx->lock);
+	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	if (likely(!ctx->nr_events))
 		goto out;
@@ -1306,7 +1306,7 @@ __perf_event_sched_in(struct perf_event_
 	}
 	perf_enable();
  out:
-	spin_unlock(&ctx->lock);
+	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -1370,7 +1370,7 @@ static void perf_ctx_adjust_freq(struct 
 	struct hw_perf_event *hwc;
 	u64 interrupts, freq;
 
-	spin_lock(&ctx->lock);
+	raw_spin_lock(&ctx->lock);
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
@@ -1425,7 +1425,7 @@ static void perf_ctx_adjust_freq(struct 
 			perf_enable();
 		}
 	}
-	spin_unlock(&ctx->lock);
+	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -1438,7 +1438,7 @@ static void rotate_ctx(struct perf_event
 	if (!ctx->nr_events)
 		return;
 
-	spin_lock(&ctx->lock);
+	raw_spin_lock(&ctx->lock);
 	/*
 	 * Rotate the first entry last (works just fine for group events too):
 	 */
@@ -1449,7 +1449,7 @@ static void rotate_ctx(struct perf_event
 	}
 	perf_enable();
 
-	spin_unlock(&ctx->lock);
+	raw_spin_unlock(&ctx->lock);
 }
 
 void perf_event_task_tick(struct task_struct *curr, int cpu)
@@ -1498,7 +1498,7 @@ static void perf_event_enable_on_exec(st
 
 	__perf_event_task_sched_out(ctx);
 
-	spin_lock(&ctx->lock);
+	raw_spin_lock(&ctx->lock);
 
 	list_for_each_entry(event, &ctx->group_list, group_entry) {
 		if (!event->attr.enable_on_exec)
@@ -1516,7 +1516,7 @@ static void perf_event_enable_on_exec(st
 	if (enabled)
 		unclone_ctx(ctx);
 
-	spin_unlock(&ctx->lock);
+	raw_spin_unlock(&ctx->lock);
 
 	perf_event_task_sched_in(task, smp_processor_id());
  out:
@@ -1542,10 +1542,10 @@ static void __perf_event_read(void *info
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	spin_lock(&ctx->lock);
+	raw_spin_lock(&ctx->lock);
 	update_context_time(ctx);
 	update_event_times(event);
-	spin_unlock(&ctx->lock);
+	raw_spin_unlock(&ctx->lock);
 
 	event->pmu->read(event);
 }
@@ -1563,10 +1563,10 @@ static u64 perf_event_read(struct perf_e
 		struct perf_event_context *ctx = event->ctx;
 		unsigned long flags;
 
-		spin_lock_irqsave(&ctx->lock, flags);
+		raw_spin_lock_irqsave(&ctx->lock, flags);
 		update_context_time(ctx);
 		update_event_times(event);
-		spin_unlock_irqrestore(&ctx->lock, flags);
+		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
 	return atomic64_read(&event->count);
@@ -1580,7 +1580,7 @@ __perf_event_init_context(struct perf_ev
 			    struct task_struct *task)
 {
 	memset(ctx, 0, sizeof(*ctx));
-	spin_lock_init(&ctx->lock);
+	raw_spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
 	INIT_LIST_HEAD(&ctx->group_list);
 	INIT_LIST_HEAD(&ctx->event_list);
@@ -1650,7 +1650,7 @@ static struct perf_event_context *find_g
 	ctx = perf_lock_task_context(task, &flags);
 	if (ctx) {
 		unclone_ctx(ctx);
-		spin_unlock_irqrestore(&ctx->lock, flags);
+		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
 	if (!ctx) {
@@ -1988,7 +1988,7 @@ static int perf_event_period(struct perf
 	if (!value)
 		return -EINVAL;
 
-	spin_lock_irq(&ctx->lock);
+	raw_spin_lock_irq(&ctx->lock);
 	if (event->attr.freq) {
 		if (value > sysctl_perf_event_sample_rate) {
 			ret = -EINVAL;
@@ -2001,7 +2001,7 @@ static int perf_event_period(struct perf
 		event->hw.sample_period = value;
 	}
 unlock:
-	spin_unlock_irq(&ctx->lock);
+	raw_spin_unlock_irq(&ctx->lock);
 
 	return ret;
 }
@@ -4998,7 +4998,7 @@ void perf_event_exit_task(struct task_st
 	 * reading child->perf_event_ctxp, we wait until it has
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
-	spin_lock(&child_ctx->lock);
+	raw_spin_lock(&child_ctx->lock);
 	child->perf_event_ctxp = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get
@@ -5007,7 +5007,7 @@ void perf_event_exit_task(struct task_st
 	 */
 	unclone_ctx(child_ctx);
 	update_context_time(child_ctx);
-	spin_unlock_irqrestore(&child_ctx->lock, flags);
+	raw_spin_unlock_irqrestore(&child_ctx->lock, flags);
 
 	/*
 	 * Report the task dead after unscheduling the events so that we
@@ -5291,11 +5291,11 @@ perf_set_reserve_percpu(struct sysdev_cl
 	perf_reserved_percpu = val;
 	for_each_online_cpu(cpu) {
 		cpuctx = &per_cpu(perf_cpu_context, cpu);
-		spin_lock_irq(&cpuctx->ctx.lock);
+		raw_spin_lock_irq(&cpuctx->ctx.lock);
 		mpt = min(perf_max_events - cpuctx->ctx.nr_events,
 			  perf_max_events - perf_reserved_percpu);
 		cpuctx->max_pertask = mpt;
-		spin_unlock_irq(&cpuctx->ctx.lock);
+		raw_spin_unlock_irq(&cpuctx->ctx.lock);
 	}
 	spin_unlock(&perf_resource_lock);
 



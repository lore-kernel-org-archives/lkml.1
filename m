Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0BGLb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:31:56 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47003 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933698Ab0BGLbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:31:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vay3Zal7o/9Dwa5lvvnJ3FlU7/qlSope4RG1bpA9Gtab5PQ3ELOW6tdWo6GFLc7SJ3
         mVPvGyxqL34ux4HKN+FFTa4MpSbHFzCHjAT9VJWuJNVPOXnuroMsIUeeXguuLyDMbTyR
         EUGZKB+Wv02HejItXqAyiNjpDqGPQWTMOvVik=
From: highguy@gmail.com
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       andrea@suse.de, tglx@linutronix.de, akpm@linux-foundation.org,
       peterz@infradead.org, Stijn Devriendt <HIGHGuY@gmail.com>
Subject: [PATCH 6/6] Add PERF_COUNT_SW_RUNNABLE_TASKS
Date: Sun,  7 Feb 2010 12:30:59 +0100
Message-Id: <1265542259-5596-7-git-send-email-HIGHGuY@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265542259-5596-6-git-send-email-HIGHGuY@gmail.com>
References: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-2-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-3-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-4-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-5-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-6-git-send-email-HIGHGuY@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stijn Devriendt <HIGHGuY@gmail.com>

---
 include/linux/perf_event.h |   17 ++++-
 include/linux/sched.h      |    1 +
 kernel/perf_event.c        |  180 ++++++++++++++++++++++++++++++++++++++------
 kernel/sched.c             |    7 ++
 4 files changed, 178 insertions(+), 27 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 084f322..10e56f2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -105,6 +105,7 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
 	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
+	PERF_COUNT_SW_RUNNABLE_TASKS            = 9,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
@@ -456,6 +457,7 @@ enum perf_callchain_context {
 #include <linux/pid_namespace.h>
 #include <linux/workqueue.h>
 #include <asm/atomic.h>
+#include <linux/poll.h>
 
 #define PERF_MAX_STACK_DEPTH		255
 
@@ -519,6 +521,8 @@ struct pmu {
 	int (*reset)                    (struct perf_event *event);
 	void (*wakeup)                  (struct perf_event *event);
 	u64 (*read)                     (struct perf_event *event);
+	void (*init)			(struct perf_event *event);
+	unsigned int (*poll)            (struct perf_event *event, struct file* file, poll_table *wait);
 };
 
 /**
@@ -826,13 +830,20 @@ static inline int is_software_event(struct perf_event *event)
 
 extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
-extern void __perf_sw_event(u32, s64, int, struct pt_regs *, u64);
+extern void __perf_sw_event(u32, s64, int, struct pt_regs *, u64, 
+			struct task_struct* task, int cpu);
+static inline void
+perf_sw_event_target(u32 event_id, s64 nr, int nmi, struct pt_regs *regs,
+		u64 addr, struct task_struct* task, int cpu)
+{
+	if (atomic_read(&perf_swevent_enabled[event_id]))
+		__perf_sw_event(event_id, nr, nmi, regs, addr, task, cpu);
+}
 
 static inline void
 perf_sw_event(u32 event_id, s64 nr, int nmi, struct pt_regs *regs, u64 addr)
 {
-	if (atomic_read(&perf_swevent_enabled[event_id]))
-		__perf_sw_event(event_id, nr, nmi, regs, addr);
+	perf_sw_event_target(event_id, nr, nmi, regs, addr, current, smp_processor_id());
 }
 
 extern void __perf_event_mmap(struct vm_area_struct *vma);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f2f842d..dce2213 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -138,6 +138,7 @@ extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
+extern unsigned long nr_running_cpu(int cpu);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(void);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 08885d0..5f4f23d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -743,6 +743,18 @@ static void add_event_to_ctx(struct perf_event *event,
 	event->tstamp_stopped = ctx->time;
 }
 
+static void __perf_event_init_event(struct perf_event* event)
+{
+}
+
+static void perf_event_init_event(struct perf_event* event)
+{
+	if (event->pmu->init)
+		event->pmu->init(event);
+	else
+		__perf_event_init_event(event);
+}
+
 /*
  * Cross CPU call to install and enable a performance event
  *
@@ -782,6 +794,8 @@ static void __perf_install_in_context(void *info)
 
 	add_event_to_ctx(event, ctx);
 
+	perf_event_init_event(event);
+
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		goto unlock;
 
@@ -1593,7 +1607,7 @@ static u64 perf_event_update(struct perf_event *event)
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
-	return perf_event_read(event);
+	return __perf_event_read(event);
 }
 
 /*
@@ -1931,18 +1945,26 @@ perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	return perf_read_hw(event, buf, count);
 }
 
-static unsigned int perf_poll(struct file *file, poll_table *wait)
+static unsigned int __perf_poll(struct perf_event *event, struct file *file, poll_table *wait)
 {
-	struct perf_event *event = file->private_data;
 	unsigned int events = atomic_xchg(&event->poll, 0);
 
+	/*if (events)
+		printk("Events: POLLIN=%u\n", events&POLLIN);*/
+
 	if (event->attr.threshold)
 	{
 		u64 count = perf_event_read(event);
-		if (count < event->attr.min_threshold)
+		if (count <= event->attr.max_threshold)
+		{
 			events |= POLLIN;
-		else if (count > event->attr.max_threshold)
+			//printk(KERN_CONT "+");
+		}
+		else //if (count > event->attr.max_threshold)
+		{
 			events &= ~POLLIN;
+			//printk(KERN_CONT "-");
+		}
 	}
 
 	poll_wait(file, &event->waitq, wait);
@@ -1950,8 +1972,23 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	return events;
 }
 
-static void perf_event_reset_noop(struct perf_event *event)
+static unsigned int perf_rt_poll(struct perf_event *event, struct file *file, poll_table *wait)
+{
+	return __perf_poll((event->parent ? event->parent : event), file, wait);
+}
+
+static unsigned int perf_poll(struct file* file, poll_table *wait)
+{
+	struct perf_event *event = file->private_data;
+	if (event->pmu->poll)
+		return event->pmu->poll(event, file, wait);
+	else
+		return __perf_poll(event, file, wait);
+}
+
+static int perf_event_reset_noop(struct perf_event *event)
 {
+	return 0;
 }
 
 static void __perf_event_reset(struct perf_event *event)
@@ -2568,7 +2605,10 @@ void perf_event_wakeup(struct perf_event *event)
 	if (event->pmu->wakeup)
 		event->pmu->wakeup(event);
 	else
+	{
+		atomic_set(&event->poll, POLLIN);
 		wake_up_all(&event->waitq);
+	}
 
 	if (event->pending_kill) {
 		kill_fasync(&event->fasync, SIGIO, event->pending_kill);
@@ -2719,8 +2759,6 @@ static void __perf_output_wakeup(struct perf_event* event, int nmi)
 {
 	if (event->attr.threshold && perf_event_read(event) > event->attr.max_threshold)
 		return;
-	
-	atomic_set(&event->poll, POLLIN);
 
 	if (nmi) {
 		event->pending_wakeup = 1;
@@ -3767,7 +3805,18 @@ int perf_event_overflow(struct perf_event *event, int nmi,
 
 static void perf_event_wakeup_one(struct perf_event *event)
 {
-	wake_up(&event->waitq);
+	struct perf_event *wakeup_event = event->parent ? event->parent : event;
+	s64 wakeup_count = event->attr.max_threshold - __perf_event_read(wakeup_event);
+
+	if (wakeup_count < 1)
+		wakeup_count = 1;
+
+	atomic_set(&wakeup_event->poll, POLLIN);
+
+	if (event->attr.threshold && wakeup_count == 1)
+		wake_up(&wakeup_event->waitq);
+	else
+		wake_up_all(&wakeup_event->waitq);
 }
 
 static u64 __perf_event_add(struct perf_event *event, s64 count)
@@ -3783,7 +3832,7 @@ static u64 perf_event_add(struct perf_event *event, s64 count)
 		return __perf_event_add(event, count);
 }
 
-static u64 perf_event_add_parent(struct perf_event *event, u64 count)
+static u64 perf_event_add_parent(struct perf_event *event, s64 count)
 {
 	return event->parent ? __perf_event_add(event->parent, count) : __perf_event_add(event, count);
 }
@@ -3864,6 +3913,22 @@ static void perf_swevent_add(struct perf_event *event, s64 nr,
 
 	perf_event_add(event, nr);
 
+	BUG_ON(perf_event_read(event) == (u64)-1);
+
+	if (event->attr.config == PERF_COUNT_SW_RUNNABLE_TASKS) {
+		if (event->ctx->task)
+		{
+		}
+		else
+		{
+			if (atomic64_read(&event->count) != nr_running_cpu(event->cpu))
+			{
+				printk("count = %lu <-> nr_running_cpu = %lu", atomic64_read(&event->count), nr_running_cpu(event->cpu));
+				BUG();
+			}
+		}
+	}
+
 	if (!regs)
 		return;
 
@@ -3932,7 +3997,7 @@ static int perf_swevent_match(struct perf_event *event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (event->cpu != -1 && event->cpu != smp_processor_id() && event_id != PERF_COUNT_SW_RUNNABLE_TASKS)
 		return 0;
 
 	if (!perf_swevent_is_counting(event))
@@ -4006,27 +4071,27 @@ EXPORT_SYMBOL_GPL(perf_swevent_put_recursion_context);
 static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 				    s64 nr, int nmi,
 				    struct perf_sample_data *data,
-				    struct pt_regs *regs)
+				    struct pt_regs *regs,
+				    struct task_struct* task,
+				    int cpu)
 {
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
 
-	cpuctx = &__get_cpu_var(perf_cpu_context);
+	cpuctx = &per_cpu(perf_cpu_context, cpu);
 	rcu_read_lock();
 	perf_swevent_ctx_event(&cpuctx->ctx, type, event_id,
 				 nr, nmi, data, regs);
-	/*
-	 * doesn't really matter which of the child contexts the
-	 * events ends up in.
-	 */
-	ctx = rcu_dereference(current->perf_event_ctxp);
+
+	ctx = rcu_dereference(task->perf_event_ctxp);
 	if (ctx)
 		perf_swevent_ctx_event(ctx, type, event_id, nr, nmi, data, regs);
 	rcu_read_unlock();
 }
 
 void __perf_sw_event(u32 event_id, s64 nr, int nmi,
-			    struct pt_regs *regs, u64 addr)
+			    struct pt_regs *regs, u64 addr,
+			    struct task_struct* task, int cpu)
 {
 	struct perf_sample_data data;
 	int rctx;
@@ -4038,12 +4103,12 @@ void __perf_sw_event(u32 event_id, s64 nr, int nmi,
 	data.addr = addr;
 	data.raw  = NULL;
 
-	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi, &data, regs);
+	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi, &data, regs, task, cpu);
 
 	perf_swevent_put_recursion_context(rctx);
 }
 
-static void perf_swevent_read(struct perf_event *event)
+static void perf_swevent_update(struct perf_event *event)
 {
 }
 
@@ -4066,10 +4131,61 @@ static void perf_swevent_disable(struct perf_event *event)
 static const struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
-	.update		= perf_swevent_read,
+	.update		= perf_swevent_update,
 	.unthrottle	= perf_swevent_unthrottle,
 };
 
+static int perf_rt_enable(struct perf_event* event)
+{
+	return 0;
+}
+
+static void perf_rt_init_event(struct perf_event* event)
+{
+	if (event->ctx->task)
+	{
+		perf_event_add(event, event->ctx->task->state == 0);
+	}
+	else
+		atomic64_set(&event->count, nr_running_cpu(smp_processor_id()));
+}
+
+static void perf_rt_disable(struct perf_event* event)
+{
+	/* Nothing to do */
+}
+
+static void perf_rt_unthrottle(struct perf_event* event)
+{
+	/* Nothing to do */
+}
+
+static void perf_rt_update(struct perf_event* event)
+{
+	/* Nothing to do */	
+}
+
+static u64 perf_event_read_parent(struct perf_event* event)
+{
+	if (event->parent)
+		return __perf_event_read(event->parent);
+	else
+		return __perf_event_read(event);
+}
+
+static const struct pmu perf_ops_runnable_tasks = {
+	.enable		= perf_rt_enable,
+	.disable	= perf_rt_disable,
+	.update		= perf_rt_update,
+	.unthrottle	= perf_rt_unthrottle,
+	.read		= perf_event_read_parent,
+	.add		= perf_event_add_parent,
+	.reset		= perf_event_reset_noop,
+	.wakeup		= perf_event_wakeup_one,
+	.init		= perf_rt_init_event,
+	.poll           = perf_rt_poll,
+};
+
 /*
  * hrtimer based swevent callback
  */
@@ -4267,7 +4383,7 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 
 	/* Trace events already protected against recursion */
 	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
-				&data, regs);
+				&data, regs, current, smp_processor_id());
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
 
@@ -4404,6 +4520,13 @@ static void sw_perf_event_destroy(struct perf_event *event)
 	atomic_dec(&perf_swevent_enabled[event_id]);
 }
 
+static void sw_rt_perf_event_destroy(struct perf_event *event)
+{
+	BUG_ON(event->parent && __perf_event_read(event) != (u64)0);
+	sw_perf_event_destroy(event);
+}
+
+
 static const struct pmu *sw_perf_event_init(struct perf_event *event)
 {
 	const struct pmu *pmu = NULL;
@@ -4445,6 +4568,13 @@ static const struct pmu *sw_perf_event_init(struct perf_event *event)
 		}
 		pmu = &perf_ops_generic;
 		break;
+	case PERF_COUNT_SW_RUNNABLE_TASKS:
+		if (!event->parent) {
+			atomic_inc(&perf_swevent_enabled[event_id]);
+			event->destroy = sw_rt_perf_event_destroy;
+		}
+		pmu = &perf_ops_runnable_tasks;
+		break;
 	}
 
 	return pmu;
@@ -4743,7 +4873,7 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EACCES;
 	}
 
-	if (attr.threshold && (attr.freq || attr.watermark))
+	if (attr.threshold && (attr.freq || attr.watermark || attr.min_threshold > attr.max_threshold))
 		return -EINVAL;
 	
 	if (attr.freq) {
@@ -4944,6 +5074,8 @@ inherit_event(struct perf_event *parent_event,
 	 */
 	add_event_to_ctx(child_event, child_ctx);
 
+	perf_event_init_event(child_event);
+
 	/*
 	 * Get a reference to the parent filp - we will fput it
 	 * when the child event exits. This is safe to do because
diff --git a/kernel/sched.c b/kernel/sched.c
index 87f1f47..53c679c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1967,6 +1967,7 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 
 	enqueue_task(rq, p, wakeup);
 	inc_nr_running(rq);
+	perf_sw_event_target(PERF_COUNT_SW_RUNNABLE_TASKS, 1, 1, task_pt_regs(p), 0, p, cpu_of(rq));
 }
 
 /*
@@ -1979,6 +1980,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
 
 	dequeue_task(rq, p, sleep);
 	dec_nr_running(rq);
+	perf_sw_event_target(PERF_COUNT_SW_RUNNABLE_TASKS, -1, 1, task_pt_regs(p), 0, p, cpu_of(rq));
 }
 
 /**
@@ -2932,6 +2934,11 @@ unsigned long nr_running(void)
 	return sum;
 }
 
+unsigned long nr_running_cpu(int cpu)
+{
+	return cpu_rq(cpu)->nr_running;
+}
+
 unsigned long nr_uninterruptible(void)
 {
 	unsigned long i, sum = 0;
-- 
1.6.6


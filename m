Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbZCMND0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbZCMND0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbZCMNCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:02:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:54024 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936AbZCMNCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:02:10 -0400
Date: Fri, 13 Mar 2009 13:01:24 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112301.569153875@chello.nl>
References: <20090313112301.569153875@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: software counter event infrastructure
Message-ID: <tip-60b71eab21b8b5d6de1d4746f009ddd0f1568ddb@git.kernel.org>
Git-Commit-ID: 60b71eab21b8b5d6de1d4746f009ddd0f1568ddb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:01:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60b71eab21b8b5d6de1d4746f009ddd0f1568ddb
Gitweb:     http://git.kernel.org/tip/60b71eab21b8b5d6de1d4746f009ddd0f1568ddb
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:32 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 13:59:09 +0100

perf_counter: software counter event infrastructure

Provide generic software counter infrastructure that supports
software events.

This will be used to allow sample based profiling based on software
events such as pagefaults. The current infrastructure can only
provide a count of such events, no place information.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090313112301.569153875@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    6 ++
 kernel/perf_counter.c        |  201 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 207 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index dde5645..c910074 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -126,6 +126,7 @@ struct hw_perf_counter {
 	unsigned long			counter_base;
 	int				nmi;
 	unsigned int			idx;
+	atomic64_t			count; /* software */
 	atomic64_t			prev_count;
 	u64				irq_period;
 	atomic64_t			period_left;
@@ -283,6 +284,8 @@ static inline int is_software_counter(struct perf_counter *counter)
 	return !counter->hw_event.raw && counter->hw_event.type < 0;
 }
 
+extern void perf_swcounter_event(enum hw_event_types, u64, int, struct pt_regs *);
+
 #else
 static inline void
 perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
@@ -299,6 +302,9 @@ static inline void hw_perf_restore(u64 ctrl)			{ }
 static inline u64 hw_perf_save_disable(void)		      { return 0; }
 static inline int perf_counter_task_disable(void)	{ return -EINVAL; }
 static inline int perf_counter_task_enable(void)	{ return -EINVAL; }
+
+static inline void perf_swcounter_event(enum hw_event_types event, u64 nr,
+					int nmi struct pt_regs *regs) { }
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0fe22c9..eeb1b46 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1328,6 +1328,185 @@ static const struct file_operations perf_fops = {
 	.compat_ioctl		= perf_ioctl,
 };
 
+/*
+ * Generic software counter infrastructure
+ */
+
+static void perf_swcounter_update(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	u64 prev, now;
+	s64 delta;
+
+again:
+	prev = atomic64_read(&hwc->prev_count);
+	now = atomic64_read(&hwc->count);
+	if (atomic64_cmpxchg(&hwc->prev_count, prev, now) != prev)
+		goto again;
+
+	delta = now - prev;
+
+	atomic64_add(delta, &counter->count);
+	atomic64_sub(delta, &hwc->period_left);
+}
+
+static void perf_swcounter_set_period(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	s64 left = atomic64_read(&hwc->period_left);
+	s64 period = hwc->irq_period;
+
+	if (unlikely(left <= -period)) {
+		left = period;
+		atomic64_set(&hwc->period_left, left);
+	}
+
+	if (unlikely(left <= 0)) {
+		left += period;
+		atomic64_add(period, &hwc->period_left);
+	}
+
+	atomic64_set(&hwc->prev_count, -left);
+	atomic64_set(&hwc->count, -left);
+}
+
+static void perf_swcounter_save_and_restart(struct perf_counter *counter)
+{
+	perf_swcounter_update(counter);
+	perf_swcounter_set_period(counter);
+}
+
+static void perf_swcounter_store_irq(struct perf_counter *counter, u64 data)
+{
+	struct perf_data *irqdata = counter->irqdata;
+
+	if (irqdata->len > PERF_DATA_BUFLEN - sizeof(u64)) {
+		irqdata->overrun++;
+	} else {
+		u64 *p = (u64 *) &irqdata->data[irqdata->len];
+
+		*p = data;
+		irqdata->len += sizeof(u64);
+	}
+}
+
+static void perf_swcounter_handle_group(struct perf_counter *sibling)
+{
+	struct perf_counter *counter, *group_leader = sibling->group_leader;
+
+	list_for_each_entry(counter, &group_leader->sibling_list, list_entry) {
+		perf_swcounter_update(counter);
+		perf_swcounter_store_irq(sibling, counter->hw_event.type);
+		perf_swcounter_store_irq(sibling, atomic64_read(&counter->count));
+	}
+}
+
+static void perf_swcounter_interrupt(struct perf_counter *counter,
+				     int nmi, struct pt_regs *regs)
+{
+	perf_swcounter_save_and_restart(counter);
+
+	switch (counter->hw_event.record_type) {
+	case PERF_RECORD_SIMPLE:
+		break;
+
+	case PERF_RECORD_IRQ:
+		perf_swcounter_store_irq(counter, instruction_pointer(regs));
+		break;
+
+	case PERF_RECORD_GROUP:
+		perf_swcounter_handle_group(counter);
+		break;
+	}
+
+	if (nmi) {
+		counter->wakeup_pending = 1;
+		set_tsk_thread_flag(current, TIF_PERF_COUNTERS);
+	} else
+		wake_up(&counter->waitq);
+}
+
+static int perf_swcounter_match(struct perf_counter *counter,
+				enum hw_event_types event,
+				struct pt_regs *regs)
+{
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return 0;
+
+	if (counter->hw_event.raw)
+		return 0;
+
+	if (counter->hw_event.type != event)
+		return 0;
+
+	if (counter->hw_event.exclude_user && user_mode(regs))
+		return 0;
+
+	if (counter->hw_event.exclude_kernel && !user_mode(regs))
+		return 0;
+
+	return 1;
+}
+
+static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
+				     enum hw_event_types event, u64 nr,
+				     int nmi, struct pt_regs *regs)
+{
+	struct perf_counter *counter;
+	unsigned long flags;
+	int neg;
+
+	if (list_empty(&ctx->counter_list))
+		return;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+
+	/*
+	 * XXX: make counter_list RCU safe
+	 */
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (perf_swcounter_match(counter, event, regs)) {
+			neg = atomic64_add_negative(nr, &counter->hw.count);
+			if (counter->hw.irq_period && !neg)
+				perf_swcounter_interrupt(counter, nmi, regs);
+		}
+	}
+
+	spin_unlock_irqrestore(&ctx->lock, flags);
+}
+
+void perf_swcounter_event(enum hw_event_types event, u64 nr,
+			  int nmi, struct pt_regs *regs)
+{
+	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
+
+	perf_swcounter_ctx_event(&cpuctx->ctx, event, nr, nmi, regs);
+	if (cpuctx->task_ctx)
+		perf_swcounter_ctx_event(cpuctx->task_ctx, event, nr, nmi, regs);
+
+	put_cpu_var(perf_cpu_context);
+}
+
+static void perf_swcounter_read(struct perf_counter *counter)
+{
+	perf_swcounter_update(counter);
+}
+
+static int perf_swcounter_enable(struct perf_counter *counter)
+{
+	perf_swcounter_set_period(counter);
+	return 0;
+}
+
+static void perf_swcounter_disable(struct perf_counter *counter)
+{
+	perf_swcounter_update(counter);
+}
+
+/*
+ * Software counter: cpu wall time clock
+ */
+
 static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
 {
 	int cpu = raw_smp_processor_id();
@@ -1365,6 +1544,10 @@ static const struct hw_perf_counter_ops perf_ops_cpu_clock = {
 };
 
 /*
+ * Software counter: task time clock
+ */
+
+/*
  * Called from within the scheduler:
  */
 static u64 task_clock_perf_counter_val(struct perf_counter *counter, int update)
@@ -1420,6 +1603,10 @@ static const struct hw_perf_counter_ops perf_ops_task_clock = {
 	.read		= task_clock_perf_counter_read,
 };
 
+/*
+ * Software counter: page faults
+ */
+
 #ifdef CONFIG_VM_EVENT_COUNTERS
 #define cpu_page_faults()	__get_cpu_var(vm_event_states).event[PGFAULT]
 #else
@@ -1473,6 +1660,10 @@ static const struct hw_perf_counter_ops perf_ops_page_faults = {
 	.read		= page_faults_perf_counter_read,
 };
 
+/*
+ * Software counter: context switches
+ */
+
 static u64 get_context_switches(struct perf_counter *counter)
 {
 	struct task_struct *curr = counter->ctx->task;
@@ -1521,6 +1712,10 @@ static const struct hw_perf_counter_ops perf_ops_context_switches = {
 	.read		= context_switches_perf_counter_read,
 };
 
+/*
+ * Software counter: cpu migrations
+ */
+
 static inline u64 get_cpu_migrations(struct perf_counter *counter)
 {
 	struct task_struct *curr = counter->ctx->task;
@@ -1572,7 +1767,9 @@ static const struct hw_perf_counter_ops perf_ops_cpu_migrations = {
 static const struct hw_perf_counter_ops *
 sw_perf_counter_init(struct perf_counter *counter)
 {
+	struct perf_counter_hw_event *hw_event = &counter->hw_event;
 	const struct hw_perf_counter_ops *hw_ops = NULL;
+	struct hw_perf_counter *hwc = &counter->hw;
 
 	/*
 	 * Software counters (currently) can't in general distinguish
@@ -1618,6 +1815,10 @@ sw_perf_counter_init(struct perf_counter *counter)
 	default:
 		break;
 	}
+
+	if (hw_ops)
+		hwc->irq_period = hw_event->irq_period;
+
 	return hw_ops;
 }
 

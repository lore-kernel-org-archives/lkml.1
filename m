Return-Path: <linux-kernel-owner+w=401wt.eu-S1761231AbZCSTq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761231AbZCSTq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbZCSTn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:43:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53497 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbZCSTnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:43:21 -0400
Message-Id: <20090319194233.836807573@chello.nl>
References: <20090319192610.660857280@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 20:26:18 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/10] perf_counter: revamp syscall input ABI
Content-Disposition: inline; filename=perf_counter-input-abi.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware/software classification in hw_event->type became a little strained
due to the addition of tracepoint tracing.

Instead split up the field and provide a type field to explicitly specify the
counter type, while using the event_id field to specify which event to use.

Raw counters still work as before, only the raw config now goes into raw_event.

Updated userspace at:
  http://programming.kicks-ass.net/misc/perf_counter/

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_counter.c |    4 -
 arch/x86/kernel/cpu/perf_counter.c |   10 +--
 include/linux/perf_counter.h       |   93 +++++++++++++++++++++++--------------
 kernel/perf_counter.c              |   83 +++++++++++++++++++--------------
 4 files changed, 116 insertions(+), 74 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -602,7 +602,7 @@ hw_perf_counter_init(struct perf_counter
 		return NULL;
 	if ((s64)counter->hw_event.irq_period < 0)
 		return NULL;
-	ev = counter->hw_event.type;
+	ev = counter->hw_event.event_id;
 	if (!counter->hw_event.raw) {
 		if (ev >= ppmu->n_generic ||
 		    ppmu->generic_events[ev] == 0)
@@ -692,7 +692,7 @@ static void perf_handle_group(struct per
 	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
 		if (sub != counter)
 			sub->hw_ops->read(sub);
-		perf_store_irq_data(counter, sub->hw_event.type);
+		perf_store_irq_data(counter, sub->hw_event.event_config);
 		perf_store_irq_data(counter, atomic64_read(&sub->count));
 	}
 }
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -217,15 +217,15 @@ static int __hw_perf_counter_init(struct
 	/*
 	 * Raw event type provide the config in the event structure
 	 */
-	if (hw_event->raw) {
-		hwc->config |= pmc_ops->raw_event(hw_event->type);
+	if (hw_event->raw_type) {
+		hwc->config |= pmc_ops->raw_event(hw_event->raw_event_id);
 	} else {
-		if (hw_event->type >= pmc_ops->max_events)
+		if (hw_event->event_id >= pmc_ops->max_events)
 			return -EINVAL;
 		/*
 		 * The generic map:
 		 */
-		hwc->config |= pmc_ops->event_map(hw_event->type);
+		hwc->config |= pmc_ops->event_map(hw_event->event_id);
 	}
 	counter->wakeup_pending = 0;
 
@@ -715,7 +715,7 @@ perf_handle_group(struct perf_counter *s
 	list_for_each_entry(counter, &group_leader->sibling_list, list_entry) {
 
 		x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
-		perf_store_irq_data(sibling, counter->hw_event.type);
+		perf_store_irq_data(sibling, counter->hw_event.event_config);
 		perf_store_irq_data(sibling, atomic64_read(&counter->count));
 	}
 }
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -21,56 +21,81 @@
  */
 
 /*
- * Generalized performance counter event types, used by the hw_event.type
- * parameter of the sys_perf_counter_open() syscall:
+ * hw_event.type
  */
-enum hw_event_types {
+enum perf_event_types {
+	PERF_TYPE_HARDWARE		= 0,
+	PERF_TYPE_SOFTWARE		= 1,
+	PERF_TYPE_TRACEPOINT		= 2,
+
 	/*
-	 * Common hardware events, generalized by the kernel:
+	 * available TYPE space, raw is the max value.
 	 */
-	PERF_COUNT_CPU_CYCLES		=  0,
-	PERF_COUNT_INSTRUCTIONS		=  1,
-	PERF_COUNT_CACHE_REFERENCES	=  2,
-	PERF_COUNT_CACHE_MISSES		=  3,
-	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
-	PERF_COUNT_BRANCH_MISSES	=  5,
-	PERF_COUNT_BUS_CYCLES		=  6,
 
-	PERF_HW_EVENTS_MAX		=  7,
+	PERF_TYPE_RAW			= 128,
+};
 
+/*
+ * Generalized performance counter event types, used by the hw_event.event_id
+ * parameter of the sys_perf_counter_open() syscall:
+ */
+enum hw_event_ids {
 	/*
-	 * Special "software" counters provided by the kernel, even if
-	 * the hardware does not support performance counters. These
-	 * counters measure various physical and sw events of the
-	 * kernel (and allow the profiling of them as well):
+	 * Common hardware events, generalized by the kernel:
 	 */
-	PERF_COUNT_CPU_CLOCK		= -1,
-	PERF_COUNT_TASK_CLOCK		= -2,
-	PERF_COUNT_PAGE_FAULTS		= -3,
-	PERF_COUNT_CONTEXT_SWITCHES	= -4,
-	PERF_COUNT_CPU_MIGRATIONS	= -5,
-	PERF_COUNT_PAGE_FAULTS_MIN	= -6,
-	PERF_COUNT_PAGE_FAULTS_MAJ	= -7,
+	PERF_COUNT_CPU_CYCLES		= 0,
+	PERF_COUNT_INSTRUCTIONS		= 1,
+	PERF_COUNT_CACHE_REFERENCES	= 2,
+	PERF_COUNT_CACHE_MISSES		= 3,
+	PERF_COUNT_BRANCH_INSTRUCTIONS	= 4,
+	PERF_COUNT_BRANCH_MISSES	= 5,
+	PERF_COUNT_BUS_CYCLES		= 6,
 
-	PERF_SW_EVENTS_MIN		= -8,
+	PERF_HW_EVENTS_MAX		= 7,
+};
+
+/*
+ * Special "software" counters provided by the kernel, even if the hardware
+ * does not support performance counters. These counters measure various
+ * physical and sw events of the kernel (and allow the profiling of them as
+ * well):
+ */
+enum sw_event_ids {
+	PERF_COUNT_CPU_CLOCK		= 0,
+	PERF_COUNT_TASK_CLOCK		= 1,
+	PERF_COUNT_PAGE_FAULTS		= 2,
+	PERF_COUNT_CONTEXT_SWITCHES	= 3,
+	PERF_COUNT_CPU_MIGRATIONS	= 4,
+	PERF_COUNT_PAGE_FAULTS_MIN	= 5,
+	PERF_COUNT_PAGE_FAULTS_MAJ	= 6,
 
-	PERF_TP_EVENTS_MIN		= -65536
+	PERF_SW_EVENTS_MAX		= 7,
 };
 
 /*
  * IRQ-notification data record type:
  */
 enum perf_counter_record_type {
-	PERF_RECORD_SIMPLE		=  0,
-	PERF_RECORD_IRQ			=  1,
-	PERF_RECORD_GROUP		=  2,
+	PERF_RECORD_SIMPLE		= 0,
+	PERF_RECORD_IRQ			= 1,
+	PERF_RECORD_GROUP		= 2,
 };
 
 /*
  * Hardware event to monitor via a performance monitoring counter:
  */
 struct perf_counter_hw_event {
-	__s64			type;
+	union {
+		struct {
+			__u64			event_id	: 56,
+						type		:  8;
+		};
+		struct {
+			__u64			raw_event_id	: 63,
+						raw_type	:  1;
+		};
+		__u64		event_config;
+	};
 
 	__u64			irq_period;
 	__u64			record_type;
@@ -78,7 +103,6 @@ struct perf_counter_hw_event {
 
 	__u64			disabled       :  1, /* off by default        */
 				nmi	       :  1, /* NMI sampling          */
-				raw	       :  1, /* raw event type        */
 				inherit	       :  1, /* children inherit it   */
 				pinned	       :  1, /* must always be on PMU */
 				exclusive      :  1, /* only group on PMU     */
@@ -87,7 +111,7 @@ struct perf_counter_hw_event {
 				exclude_hv     :  1, /* ditto hypervisor      */
 				exclude_idle   :  1, /* don't count when idle */
 
-				__reserved_1   : 54;
+				__reserved_1   : 55;
 
 	__u32			extra_config_len;
 	__u32			__reserved_4;
@@ -298,10 +322,11 @@ extern int hw_perf_group_sched_in(struct
  */
 static inline int is_software_counter(struct perf_counter *counter)
 {
-	return !counter->hw_event.raw && counter->hw_event.type < 0;
+	return !counter->hw_event.raw_type &&
+		counter->hw_event.type != PERF_TYPE_HARDWARE;
 }
 
-extern void perf_swcounter_event(enum hw_event_types, u64, int, struct pt_regs *);
+extern void perf_swcounter_event(u32, u64, int, struct pt_regs *);
 
 #else
 static inline void
@@ -320,7 +345,7 @@ static inline u64 hw_perf_save_disable(v
 static inline int perf_counter_task_disable(void)	{ return -EINVAL; }
 static inline int perf_counter_task_enable(void)	{ return -EINVAL; }
 
-static inline void perf_swcounter_event(enum hw_event_types event, u64 nr,
+static inline void perf_swcounter_event(u32 event, u64 nr,
 					int nmi, struct pt_regs *regs)	{ }
 #endif
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1395,12 +1395,6 @@ static void perf_swcounter_set_period(st
 	atomic64_set(&hwc->count, -left);
 }
 
-static void perf_swcounter_save_and_restart(struct perf_counter *counter)
-{
-	perf_swcounter_update(counter);
-	perf_swcounter_set_period(counter);
-}
-
 static void perf_swcounter_store_irq(struct perf_counter *counter, u64 data)
 {
 	struct perf_data *irqdata = counter->irqdata;
@@ -1421,7 +1415,7 @@ static void perf_swcounter_handle_group(
 
 	list_for_each_entry(counter, &group_leader->sibling_list, list_entry) {
 		counter->hw_ops->read(counter);
-		perf_swcounter_store_irq(sibling, counter->hw_event.type);
+		perf_swcounter_store_irq(sibling, counter->hw_event.event_config);
 		perf_swcounter_store_irq(sibling, atomic64_read(&counter->count));
 	}
 }
@@ -1477,21 +1471,25 @@ static enum hrtimer_restart perf_swcount
 static void perf_swcounter_overflow(struct perf_counter *counter,
 				    int nmi, struct pt_regs *regs)
 {
-	perf_swcounter_save_and_restart(counter);
+	perf_swcounter_update(counter);
+	perf_swcounter_set_period(counter);
 	perf_swcounter_interrupt(counter, nmi, regs);
 }
 
 static int perf_swcounter_match(struct perf_counter *counter,
-				enum hw_event_types event,
-				struct pt_regs *regs)
+				enum perf_event_types type,
+				u32 event, struct pt_regs *regs)
 {
 	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
 		return 0;
 
-	if (counter->hw_event.raw)
+	if (counter->hw_event.raw_type)
+		return 0;
+
+	if (counter->hw_event.type != type)
 		return 0;
 
-	if (counter->hw_event.type != event)
+	if (counter->hw_event.event_id != event)
 		return 0;
 
 	if (counter->hw_event.exclude_user && user_mode(regs))
@@ -1512,8 +1510,8 @@ static void perf_swcounter_add(struct pe
 }
 
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
-				     enum hw_event_types event, u64 nr,
-				     int nmi, struct pt_regs *regs)
+				     enum perf_event_types type, u32 event,
+				     u64 nr, int nmi, struct pt_regs *regs)
 {
 	struct perf_counter *counter;
 
@@ -1522,24 +1520,31 @@ static void perf_swcounter_ctx_event(str
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
-		if (perf_swcounter_match(counter, event, regs))
+		if (perf_swcounter_match(counter, type, event, regs))
 			perf_swcounter_add(counter, nr, nmi, regs);
 	}
 	rcu_read_unlock();
 }
 
-void perf_swcounter_event(enum hw_event_types event, u64 nr,
-			  int nmi, struct pt_regs *regs)
+static void __perf_swcounter_event(enum perf_event_types type, u32 event,
+				   u64 nr, int nmi, struct pt_regs *regs)
 {
 	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
 
-	perf_swcounter_ctx_event(&cpuctx->ctx, event, nr, nmi, regs);
-	if (cpuctx->task_ctx)
-		perf_swcounter_ctx_event(cpuctx->task_ctx, event, nr, nmi, regs);
+	perf_swcounter_ctx_event(&cpuctx->ctx, type, event, nr, nmi, regs);
+	if (cpuctx->task_ctx) {
+		perf_swcounter_ctx_event(cpuctx->task_ctx, type, event,
+				nr, nmi, regs);
+	}
 
 	put_cpu_var(perf_cpu_context);
 }
 
+void perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs)
+{
+	__perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi, regs);
+}
+
 static void perf_swcounter_read(struct perf_counter *counter)
 {
 	perf_swcounter_update(counter);
@@ -1733,8 +1738,12 @@ static const struct hw_perf_counter_ops 
 #ifdef CONFIG_EVENT_PROFILE
 void perf_tpcounter_event(int event_id)
 {
-	perf_swcounter_event(PERF_TP_EVENTS_MIN + event_id, 1, 1,
-			task_pt_regs(current));
+	struct pt_regs *regs = get_irq_regs();
+
+	if (!regs)
+		regs = task_pt_regs(current);
+
+	__perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, regs);
 }
 
 extern int ftrace_profile_enable(int);
@@ -1742,15 +1751,13 @@ extern void ftrace_profile_disable(int);
 
 static void tp_perf_counter_destroy(struct perf_counter *counter)
 {
-	int event_id = counter->hw_event.type - PERF_TP_EVENTS_MIN;
-
-	ftrace_profile_disable(event_id);
+	ftrace_profile_disable(counter->hw_event.event_id);
 }
 
 static const struct hw_perf_counter_ops *
 tp_perf_counter_init(struct perf_counter *counter)
 {
-	int event_id = counter->hw_event.type - PERF_TP_EVENTS_MIN;
+	int event_id = counter->hw_event.event_id;
 	int ret;
 
 	ret = ftrace_profile_enable(event_id);
@@ -1758,6 +1765,7 @@ tp_perf_counter_init(struct perf_counter
 		return NULL;
 
 	counter->destroy = tp_perf_counter_destroy;
+	counter->hw.irq_period = counter->hw_event.irq_period;
 
 	return &perf_ops_generic;
 }
@@ -1783,7 +1791,7 @@ sw_perf_counter_init(struct perf_counter
 	 * to be kernel events, and page faults are never hypervisor
 	 * events.
 	 */
-	switch (counter->hw_event.type) {
+	switch (counter->hw_event.event_id) {
 	case PERF_COUNT_CPU_CLOCK:
 		hw_ops = &perf_ops_cpu_clock;
 
@@ -1813,9 +1821,6 @@ sw_perf_counter_init(struct perf_counter
 		if (!counter->hw_event.exclude_kernel)
 			hw_ops = &perf_ops_cpu_migrations;
 		break;
-	default:
-		hw_ops = tp_perf_counter_init(counter);
-		break;
 	}
 
 	if (hw_ops)
@@ -1870,10 +1875,22 @@ perf_counter_alloc(struct perf_counter_h
 		counter->state = PERF_COUNTER_STATE_OFF;
 
 	hw_ops = NULL;
-	if (!hw_event->raw && hw_event->type < 0)
-		hw_ops = sw_perf_counter_init(counter);
-	else
+
+	if (hw_event->raw_type)
+		hw_ops = hw_perf_counter_init(counter);
+	else switch (hw_event->type) {
+	case PERF_TYPE_HARDWARE:
 		hw_ops = hw_perf_counter_init(counter);
+		break;
+
+	case PERF_TYPE_SOFTWARE:
+		hw_ops = sw_perf_counter_init(counter);
+		break;
+
+	case PERF_TYPE_TRACEPOINT:
+		hw_ops = tp_perf_counter_init(counter);
+		break;
+	}
 
 	if (!hw_ops) {
 		kfree(counter);

-- 


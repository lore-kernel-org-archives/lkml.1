Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbZCTK1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbZCTK1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762305AbZCTK0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:26:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:35231 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762289AbZCTK0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:26:08 -0400
Date: Fri, 20 Mar 2009 10:25:26 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319194233.836807573@chello.nl>
References: <20090319194233.836807573@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: revamp syscall input ABI
Message-ID: <tip-db3a944aca35ae6117ede92876990767676c3f55@git.kernel.org>
Git-Commit-ID: db3a944aca35ae6117ede92876990767676c3f55
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:25:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db3a944aca35ae6117ede92876990767676c3f55
Gitweb:     http://git.kernel.org/tip/db3a944aca35ae6117ede92876990767676c3f55
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 19 Mar 2009 20:26:18 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:15:13 +0100

perf_counter: revamp syscall input ABI

Impact: modify ABI

The hardware/software classification in hw_event->type became a little
strained due to the addition of tracepoint tracing.

Instead split up the field and provide a type field to explicitly specify
the counter type, while using the event_id field to specify which event to
use.

Raw counters still work as before, only the raw config now goes into
raw_event.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090319194233.836807573@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    4 +-
 arch/x86/kernel/cpu/perf_counter.c |   10 ++--
 include/linux/perf_counter.h       |   95 ++++++++++++++++++++++-------------
 kernel/perf_counter.c              |   83 +++++++++++++++++++------------
 4 files changed, 117 insertions(+), 75 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 5008762..26f69dc 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -602,7 +602,7 @@ hw_perf_counter_init(struct perf_counter *counter)
 		return NULL;
 	if ((s64)counter->hw_event.irq_period < 0)
 		return NULL;
-	ev = counter->hw_event.type;
+	ev = counter->hw_event.event_id;
 	if (!counter->hw_event.raw) {
 		if (ev >= ppmu->n_generic ||
 		    ppmu->generic_events[ev] == 0)
@@ -692,7 +692,7 @@ static void perf_handle_group(struct perf_counter *counter)
 	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
 		if (sub != counter)
 			sub->hw_ops->read(sub);
-		perf_store_irq_data(counter, sub->hw_event.type);
+		perf_store_irq_data(counter, sub->hw_event.event_config);
 		perf_store_irq_data(counter, atomic64_read(&sub->count));
 	}
 }
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 6cba9d4..d844ae4 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -217,15 +217,15 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
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
 
@@ -715,7 +715,7 @@ perf_handle_group(struct perf_counter *sibling, u64 *status, u64 *overflown)
 	list_for_each_entry(counter, &group_leader->sibling_list, list_entry) {
 
 		x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
-		perf_store_irq_data(sibling, counter->hw_event.type);
+		perf_store_irq_data(sibling, counter->hw_event.event_config);
 		perf_store_irq_data(sibling, atomic64_read(&counter->count));
 	}
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 065984c..8f93949 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
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
-
-	PERF_SW_EVENTS_MIN		= -8,
+	PERF_COUNT_CPU_CYCLES		= 0,
+	PERF_COUNT_INSTRUCTIONS		= 1,
+	PERF_COUNT_CACHE_REFERENCES	= 2,
+	PERF_COUNT_CACHE_MISSES		= 3,
+	PERF_COUNT_BRANCH_INSTRUCTIONS	= 4,
+	PERF_COUNT_BRANCH_MISSES	= 5,
+	PERF_COUNT_BUS_CYCLES		= 6,
+
+	PERF_HW_EVENTS_MAX		= 7,
+};
 
-	PERF_TP_EVENTS_MIN		= -65536
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
+
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
@@ -298,10 +322,11 @@ extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
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
@@ -320,7 +345,7 @@ static inline u64 hw_perf_save_disable(void)		      { return 0; }
 static inline int perf_counter_task_disable(void)	{ return -EINVAL; }
 static inline int perf_counter_task_enable(void)	{ return -EINVAL; }
 
-static inline void perf_swcounter_event(enum hw_event_types event, u64 nr,
+static inline void perf_swcounter_event(u32 event, u64 nr,
 					int nmi, struct pt_regs *regs)	{ }
 #endif
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0bbe3e4..68a56a6 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1395,12 +1395,6 @@ static void perf_swcounter_set_period(struct perf_counter *counter)
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
@@ -1421,7 +1415,7 @@ static void perf_swcounter_handle_group(struct perf_counter *sibling)
 
 	list_for_each_entry(counter, &group_leader->sibling_list, list_entry) {
 		counter->hw_ops->read(counter);
-		perf_swcounter_store_irq(sibling, counter->hw_event.type);
+		perf_swcounter_store_irq(sibling, counter->hw_event.event_config);
 		perf_swcounter_store_irq(sibling, atomic64_read(&counter->count));
 	}
 }
@@ -1477,21 +1471,25 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
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
@@ -1512,8 +1510,8 @@ static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
 }
 
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
-				     enum hw_event_types event, u64 nr,
-				     int nmi, struct pt_regs *regs)
+				     enum perf_event_types type, u32 event,
+				     u64 nr, int nmi, struct pt_regs *regs)
 {
 	struct perf_counter *counter;
 
@@ -1522,24 +1520,31 @@ static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 
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
@@ -1733,8 +1738,12 @@ static const struct hw_perf_counter_ops perf_ops_cpu_migrations = {
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
@@ -1758,6 +1765,7 @@ tp_perf_counter_init(struct perf_counter *counter)
 		return NULL;
 
 	counter->destroy = tp_perf_counter_destroy;
+	counter->hw.irq_period = counter->hw_event.irq_period;
 
 	return &perf_ops_generic;
 }
@@ -1783,7 +1791,7 @@ sw_perf_counter_init(struct perf_counter *counter)
 	 * to be kernel events, and page faults are never hypervisor
 	 * events.
 	 */
-	switch (counter->hw_event.type) {
+	switch (counter->hw_event.event_id) {
 	case PERF_COUNT_CPU_CLOCK:
 		hw_ops = &perf_ops_cpu_clock;
 
@@ -1813,9 +1821,6 @@ sw_perf_counter_init(struct perf_counter *counter)
 		if (!counter->hw_event.exclude_kernel)
 			hw_ops = &perf_ops_cpu_migrations;
 		break;
-	default:
-		hw_ops = tp_perf_counter_init(counter);
-		break;
 	}
 
 	if (hw_ops)
@@ -1870,10 +1875,22 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
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

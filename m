Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZCMNEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZCMNEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758439AbZCMNCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:02:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:54068 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436AbZCMNCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:02:37 -0400
Date: Fri, 13 Mar 2009 13:01:52 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112301.862384083@chello.nl>
References: <20090313112301.862384083@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: hrtimer based sampling for software time events
Message-ID: <tip-7484b45d2db110fe69c2cbb09c785a0a19767604@git.kernel.org>
Git-Commit-ID: 7484b45d2db110fe69c2cbb09c785a0a19767604
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:01:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7484b45d2db110fe69c2cbb09c785a0a19767604
Gitweb:     http://git.kernel.org/tip/7484b45d2db110fe69c2cbb09c785a0a19767604
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:35 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 13:59:11 +0100

perf_counter: hrtimer based sampling for software time events

Use hrtimers to profile timer based sampling for the software time
counters.

This allows platforms without hardware counter support to still
perform sample based profiling.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090313112301.862384083@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   20 +++++--
 kernel/perf_counter.c        |  123 +++++++++++++++++++++++++++++-------------
 2 files changed, 100 insertions(+), 43 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 61e26cc..16de5c0 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -114,6 +114,7 @@ struct perf_counter_hw_event {
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
+#include <linux/hrtimer.h>
 #include <asm/atomic.h>
 
 struct task_struct;
@@ -123,12 +124,19 @@ struct task_struct;
  */
 struct hw_perf_counter {
 #ifdef CONFIG_PERF_COUNTERS
-	u64				config;
-	unsigned long			config_base;
-	unsigned long			counter_base;
-	int				nmi;
-	unsigned int			idx;
-	atomic64_t			count; /* software */
+	union {
+		struct { /* hardware */
+			u64				config;
+			unsigned long			config_base;
+			unsigned long			counter_base;
+			int				nmi;
+			unsigned int			idx;
+		};
+		union { /* software */
+			atomic64_t			count;
+			struct hrtimer			hrtimer;
+		};
+	};
 	atomic64_t			prev_count;
 	u64				irq_period;
 	atomic64_t			period_left;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 68950a3..f9330d5 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1395,7 +1395,7 @@ static void perf_swcounter_handle_group(struct perf_counter *sibling)
 	struct perf_counter *counter, *group_leader = sibling->group_leader;
 
 	list_for_each_entry(counter, &group_leader->sibling_list, list_entry) {
-		perf_swcounter_update(counter);
+		counter->hw_ops->read(counter);
 		perf_swcounter_store_irq(sibling, counter->hw_event.type);
 		perf_swcounter_store_irq(sibling, atomic64_read(&counter->count));
 	}
@@ -1404,8 +1404,6 @@ static void perf_swcounter_handle_group(struct perf_counter *sibling)
 static void perf_swcounter_interrupt(struct perf_counter *counter,
 				     int nmi, struct pt_regs *regs)
 {
-	perf_swcounter_save_and_restart(counter);
-
 	switch (counter->hw_event.record_type) {
 	case PERF_RECORD_SIMPLE:
 		break;
@@ -1426,6 +1424,38 @@ static void perf_swcounter_interrupt(struct perf_counter *counter,
 		wake_up(&counter->waitq);
 }
 
+static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
+{
+	struct perf_counter *counter;
+	struct pt_regs *regs;
+
+	counter	= container_of(hrtimer, struct perf_counter, hw.hrtimer);
+	counter->hw_ops->read(counter);
+
+	regs = get_irq_regs();
+	/*
+	 * In case we exclude kernel IPs or are somehow not in interrupt
+	 * context, provide the next best thing, the user IP.
+	 */
+	if ((counter->hw_event.exclude_kernel || !regs) &&
+			!counter->hw_event.exclude_user)
+		regs = task_pt_regs(current);
+
+	if (regs)
+		perf_swcounter_interrupt(counter, 0, regs);
+
+	hrtimer_forward_now(hrtimer, ns_to_ktime(counter->hw.irq_period));
+
+	return HRTIMER_RESTART;
+}
+
+static void perf_swcounter_overflow(struct perf_counter *counter,
+				    int nmi, struct pt_regs *regs)
+{
+	perf_swcounter_save_and_restart(counter);
+	perf_swcounter_interrupt(counter, nmi, regs);
+}
+
 static int perf_swcounter_match(struct perf_counter *counter,
 				enum hw_event_types event,
 				struct pt_regs *regs)
@@ -1448,13 +1478,20 @@ static int perf_swcounter_match(struct perf_counter *counter,
 	return 1;
 }
 
+static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
+			       int nmi, struct pt_regs *regs)
+{
+	int neg = atomic64_add_negative(nr, &counter->hw.count);
+	if (counter->hw.irq_period && !neg)
+		perf_swcounter_overflow(counter, nmi, regs);
+}
+
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 				     enum hw_event_types event, u64 nr,
 				     int nmi, struct pt_regs *regs)
 {
 	struct perf_counter *counter;
 	unsigned long flags;
-	int neg;
 
 	if (list_empty(&ctx->counter_list))
 		return;
@@ -1465,11 +1502,8 @@ static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 	 * XXX: make counter_list RCU safe
 	 */
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
-		if (perf_swcounter_match(counter, event, regs)) {
-			neg = atomic64_add_negative(nr, &counter->hw.count);
-			if (counter->hw.irq_period && !neg)
-				perf_swcounter_interrupt(counter, nmi, regs);
-		}
+		if (perf_swcounter_match(counter, event, regs))
+			perf_swcounter_add(counter, nr, nmi, regs);
 	}
 
 	spin_unlock_irqrestore(&ctx->lock, flags);
@@ -1513,14 +1547,6 @@ static const struct hw_perf_counter_ops perf_ops_generic = {
  * Software counter: cpu wall time clock
  */
 
-static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
-{
-	int cpu = raw_smp_processor_id();
-
-	atomic64_set(&counter->hw.prev_count, cpu_clock(cpu));
-	return 0;
-}
-
 static void cpu_clock_perf_counter_update(struct perf_counter *counter)
 {
 	int cpu = raw_smp_processor_id();
@@ -1533,8 +1559,26 @@ static void cpu_clock_perf_counter_update(struct perf_counter *counter)
 	atomic64_add(now - prev, &counter->count);
 }
 
+static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	int cpu = raw_smp_processor_id();
+
+	atomic64_set(&hwc->prev_count, cpu_clock(cpu));
+	if (hwc->irq_period) {
+		hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		hwc->hrtimer.function = perf_swcounter_hrtimer;
+		__hrtimer_start_range_ns(&hwc->hrtimer,
+				ns_to_ktime(hwc->irq_period), 0,
+				HRTIMER_MODE_REL, 0);
+	}
+
+	return 0;
+}
+
 static void cpu_clock_perf_counter_disable(struct perf_counter *counter)
 {
+	hrtimer_cancel(&counter->hw.hrtimer);
 	cpu_clock_perf_counter_update(counter);
 }
 
@@ -1580,27 +1624,33 @@ static void task_clock_perf_counter_update(struct perf_counter *counter, u64 now
 	atomic64_add(delta, &counter->count);
 }
 
-static void task_clock_perf_counter_read(struct perf_counter *counter)
-{
-	u64 now = task_clock_perf_counter_val(counter, 1);
-
-	task_clock_perf_counter_update(counter, now);
-}
-
 static int task_clock_perf_counter_enable(struct perf_counter *counter)
 {
-	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
-		atomic64_set(&counter->hw.prev_count,
-			     task_clock_perf_counter_val(counter, 0));
+	struct hw_perf_counter *hwc = &counter->hw;
+
+	atomic64_set(&hwc->prev_count, task_clock_perf_counter_val(counter, 0));
+	if (hwc->irq_period) {
+		hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		hwc->hrtimer.function = perf_swcounter_hrtimer;
+		__hrtimer_start_range_ns(&hwc->hrtimer,
+				ns_to_ktime(hwc->irq_period), 0,
+				HRTIMER_MODE_REL, 0);
+	}
 
 	return 0;
 }
 
 static void task_clock_perf_counter_disable(struct perf_counter *counter)
 {
-	u64 now = task_clock_perf_counter_val(counter, 0);
+	hrtimer_cancel(&counter->hw.hrtimer);
+	task_clock_perf_counter_update(counter,
+			task_clock_perf_counter_val(counter, 0));
+}
 
-	task_clock_perf_counter_update(counter, now);
+static void task_clock_perf_counter_read(struct perf_counter *counter)
+{
+	task_clock_perf_counter_update(counter,
+			task_clock_perf_counter_val(counter, 1));
 }
 
 static const struct hw_perf_counter_ops perf_ops_task_clock = {
@@ -1729,16 +1779,12 @@ sw_perf_counter_init(struct perf_counter *counter)
 	 */
 	switch (counter->hw_event.type) {
 	case PERF_COUNT_CPU_CLOCK:
-		if (!(counter->hw_event.exclude_user ||
-		      counter->hw_event.exclude_kernel ||
-		      counter->hw_event.exclude_hv))
-			hw_ops = &perf_ops_cpu_clock;
+		hw_ops = &perf_ops_cpu_clock;
+
+		if (hw_event->irq_period && hw_event->irq_period < 10000)
+			hw_event->irq_period = 10000;
 		break;
 	case PERF_COUNT_TASK_CLOCK:
-		if (counter->hw_event.exclude_user ||
-		    counter->hw_event.exclude_kernel ||
-		    counter->hw_event.exclude_hv)
-			break;
 		/*
 		 * If the user instantiates this as a per-cpu counter,
 		 * use the cpu_clock counter instead.
@@ -1747,6 +1793,9 @@ sw_perf_counter_init(struct perf_counter *counter)
 			hw_ops = &perf_ops_task_clock;
 		else
 			hw_ops = &perf_ops_cpu_clock;
+
+		if (hw_event->irq_period && hw_event->irq_period < 10000)
+			hw_event->irq_period = 10000;
 		break;
 	case PERF_COUNT_PAGE_FAULTS:
 	case PERF_COUNT_PAGE_FAULTS_MIN:

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZEYPlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZEYPlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZEYPkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:40:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37875 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZEYPko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:40:44 -0400
Message-Id: <20090525153931.703093461@chello.nl>
References: <20090525153902.692238765@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 25 May 2009 17:39:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 3/3] perf_counter: generic per counter interrupt throttle
Content-Disposition: inline; filename=perf_counter-generic-throttle.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a generic per counter interrupt throttle.

This uses the perf_counter_overflow() quick disable to throttle a specific
counter when its going too fast when a pmu->unthrottle() method is provided
which can undo the quick disable.

Power needs to implement both the quick disable and the unthrottle method.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |   13 ++++++++
 include/linux/perf_counter.h       |   11 ++++++
 kernel/perf_counter.c              |   59 ++++++++++++++++++++++++++++++++++---
 kernel/sysctl.c                    |    8 +++++
 4 files changed, 87 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -267,6 +267,15 @@ enum perf_event_type {
 	PERF_EVENT_PERIOD		= 4,
 
 	/*
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 * 	u64				time;
+	 * };
+	 */
+	PERF_EVENT_THROTTLE		= 5,
+	PERF_EVENT_UNTHROTTLE		= 6,
+
+	/*
 	 * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
 	 * will be PERF_RECORD_*
 	 *
@@ -367,6 +376,7 @@ struct pmu {
 	int (*enable)			(struct perf_counter *counter);
 	void (*disable)			(struct perf_counter *counter);
 	void (*read)			(struct perf_counter *counter);
+	void (*unthrottle)		(struct perf_counter *counter);
 };
 
 /**
@@ -613,6 +623,7 @@ extern struct perf_callchain_entry *perf
 
 extern int sysctl_perf_counter_priv;
 extern int sysctl_perf_counter_mlock;
+extern int sysctl_perf_counter_limit;
 
 extern void perf_counter_init(void);
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -46,6 +46,7 @@ static atomic_t nr_comm_tracking __read_
 
 int sysctl_perf_counter_priv __read_mostly; /* do we need to be privileged */
 int sysctl_perf_counter_mlock __read_mostly = 512; /* 'free' kb per user */
+int sysctl_perf_counter_limit __read_mostly = 100000; /* max NMIs per second */
 
 /*
  * Lock for (sysadmin-configurable) counter reservations:
@@ -1091,12 +1092,15 @@ int perf_counter_task_disable(void)
 	return 0;
 }
 
+#define MAX_INTERRUPTS (~0ULL)
+
+static void perf_log_throttle(struct perf_counter *counter, int enable);
 static void perf_log_period(struct perf_counter *counter, u64 period);
 
 static void perf_adjust_freq(struct perf_counter_context *ctx)
 {
 	struct perf_counter *counter;
-	u64 irq_period;
+	u64 interrupts, irq_period;
 	u64 events, period;
 	s64 delta;
 
@@ -1105,10 +1109,19 @@ static void perf_adjust_freq(struct perf
 		if (counter->state != PERF_COUNTER_STATE_ACTIVE)
 			continue;
 
+		interrupts = counter->hw.interrupts;
+		counter->hw.interrupts = 0;
+
+		if (interrupts == MAX_INTERRUPTS) {
+			perf_log_throttle(counter, 1);
+			counter->pmu->unthrottle(counter);
+			interrupts = 2*sysctl_perf_counter_limit/HZ;
+		}
+
 		if (!counter->hw_event.freq || !counter->hw_event.irq_freq)
 			continue;
 
-		events = HZ * counter->hw.interrupts * counter->hw.irq_period;
+		events = HZ * interrupts * counter->hw.irq_period;
 		period = div64_u64(events, counter->hw_event.irq_freq);
 
 		delta = (s64)(1 + period - counter->hw.irq_period);
@@ -1122,7 +1135,6 @@ static void perf_adjust_freq(struct perf
 		perf_log_period(counter, irq_period);
 
 		counter->hw.irq_period = irq_period;
-		counter->hw.interrupts = 0;
 	}
 	spin_unlock(&ctx->lock);
 }
@@ -2545,6 +2557,35 @@ static void perf_log_period(struct perf_
 }
 
 /*
+ * IRQ throttle logging
+ */
+
+static void perf_log_throttle(struct perf_counter *counter, int enable)
+{
+	struct perf_output_handle handle;
+	int ret;
+
+	struct {
+		struct perf_event_header	header;
+		u64				time;
+	} throttle_event = {
+		.header = {
+			.type = PERF_EVENT_THROTTLE + 1,
+			.misc = 0,
+			.size = sizeof(throttle_event),
+		},
+		.time = sched_clock(),
+	};
+
+	ret = perf_output_begin(&handle, counter, sizeof(throttle_event), 0, 0);
+	if (ret)
+		return;
+
+	perf_output_put(&handle, throttle_event);
+	perf_output_end(&handle);
+}
+
+/*
  * Generic counter overflow handling.
  */
 
@@ -2552,9 +2593,19 @@ int perf_counter_overflow(struct perf_co
 			  int nmi, struct pt_regs *regs, u64 addr)
 {
 	int events = atomic_read(&counter->event_limit);
+	int throttle = counter->pmu->unthrottle != NULL;
 	int ret = 0;
 
-	counter->hw.interrupts++;
+	if (!throttle) {
+		counter->hw.interrupts++;
+	} else if (counter->hw.interrupts != MAX_INTERRUPTS) {
+		counter->hw.interrupts++;
+		if (HZ*counter->hw.interrupts > (u64)sysctl_perf_counter_limit) {
+			counter->hw.interrupts = MAX_INTERRUPTS;
+			perf_log_throttle(counter, 0);
+			ret = 1;
+		}
+	}
 
 	/*
 	 * XXX event_limit might not quite work as expected on inherited
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -939,6 +939,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "perf_counter_int_limit",
+		.data		= &sysctl_perf_counter_limit,
+		.maxlen		= sizeof(sysctl_perf_counter_limit),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 /*
  * NOTE: do not add new entries to this table unless you have read
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -623,6 +623,18 @@ try_generic:
 	return 0;
 }
 
+static void x86_pmu_unthrottle(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+
+	if (WARN_ON_ONCE(hwc->idx >= X86_PMC_IDX_MAX ||
+				cpuc->counters[hwc->idx] != counter))
+		return;
+
+	x86_pmu.enable(hwc, hwc->idx);
+}
+
 void perf_counter_print_debug(void)
 {
 	u64 ctrl, status, overflow, pmc_ctrl, pmc_count, prev_left, fixed;
@@ -1038,6 +1050,7 @@ static const struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
 	.read		= x86_pmu_read,
+	.unthrottle	= x86_pmu_unthrottle,
 };
 
 const struct pmu *hw_perf_counter_init(struct perf_counter *counter)

-- 


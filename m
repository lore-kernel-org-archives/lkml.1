Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0CCQp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:45:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42720 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab0CCQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:45:23 -0500
Message-Id: <20100303164306.072186867@chello.nl>
References: <20100303163936.906011640@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 03 Mar 2010 17:39:39 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 03/11] perf, x86: Change x86_pmu.{enable,disable} calling convention
Content-Disposition: inline; filename=perf-x86-cleanup-args2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the ful perf_event into the x86_pmu functions so that those may
make use of more than the hw_perf_event, and while doing this, remove
the superfluous second argument.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c       |   31 +++++++++++++++----------------
 arch/x86/kernel/cpu/perf_event_intel.c |   30 +++++++++++++++++-------------
 arch/x86/kernel/cpu/perf_event_p6.c    |   10 ++++++----
 3 files changed, 38 insertions(+), 33 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -133,8 +133,8 @@ struct x86_pmu {
 	int		(*handle_irq)(struct pt_regs *);
 	void		(*disable_all)(void);
 	void		(*enable_all)(void);
-	void		(*enable)(struct hw_perf_event *, int);
-	void		(*disable)(struct hw_perf_event *, int);
+	void		(*enable)(struct perf_event *);
+	void		(*disable)(struct perf_event *);
 	unsigned	eventsel;
 	unsigned	perfctr;
 	u64		(*event_map)(int);
@@ -840,7 +840,7 @@ void hw_perf_enable(void)
 			set_bit(hwc->idx, cpuc->active_mask);
 			cpuc->events[hwc->idx] = event;
 
-			x86_pmu.enable(hwc, hwc->idx);
+			x86_pmu.enable(event);
 			perf_event_update_userpage(event);
 		}
 		cpuc->n_added = 0;
@@ -853,15 +853,16 @@ void hw_perf_enable(void)
 	x86_pmu.enable_all();
 }
 
-static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc)
 {
-	(void)checking_wrmsrl(hwc->config_base + idx,
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx,
 			      hwc->config | ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
-static inline void x86_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+static inline void x86_pmu_disable_event(struct perf_event *event)
 {
-	(void)checking_wrmsrl(hwc->config_base + idx, hwc->config);
+	struct hw_perf_event *hwc = &event->hw;
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx, hwc->config);
 }
 
 static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
@@ -922,11 +923,11 @@ x86_perf_event_set_period(struct perf_ev
 	return ret;
 }
 
-static void x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static void x86_pmu_enable_event(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	if (cpuc->enabled)
-		__x86_pmu_enable_event(hwc, idx);
+		__x86_pmu_enable_event(&event->hw);
 }
 
 /*
@@ -969,13 +970,11 @@ static int x86_pmu_enable(struct perf_ev
 
 static int x86_pmu_start(struct perf_event *event)
 {
-	struct hw_perf_event *hwc = &event->hw;
-
-	if (hwc->idx == -1)
+	if (event->hw.idx == -1)
 		return -EAGAIN;
 
 	x86_perf_event_set_period(event);
-	x86_pmu.enable(hwc, hwc->idx);
+	x86_pmu.enable(event);
 
 	return 0;
 }
@@ -989,7 +988,7 @@ static void x86_pmu_unthrottle(struct pe
 				cpuc->events[hwc->idx] != event))
 		return;
 
-	x86_pmu.enable(hwc, hwc->idx);
+	x86_pmu.enable(event);
 }
 
 void perf_event_print_debug(void)
@@ -1054,7 +1053,7 @@ static void x86_pmu_stop(struct perf_eve
 	 * could reenable again:
 	 */
 	clear_bit(idx, cpuc->active_mask);
-	x86_pmu.disable(hwc, idx);
+	x86_pmu.disable(event);
 
 	/*
 	 * Drain the remaining delta count out of a event
@@ -1123,7 +1122,7 @@ static int x86_pmu_handle_irq(struct pt_
 			continue;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			x86_pmu.disable(hwc, idx);
+			x86_pmu.disable(event);
 	}
 
 	if (handled)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -548,9 +548,9 @@ static inline void intel_pmu_ack_status(
 }
 
 static inline void
-intel_pmu_disable_fixed(struct hw_perf_event *hwc, int __idx)
+intel_pmu_disable_fixed(struct hw_perf_event *hwc)
 {
-	int idx = __idx - X86_PMC_IDX_FIXED;
+	int idx = hwc->idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, mask;
 
 	mask = 0xfULL << (idx * 4);
@@ -622,26 +622,28 @@ static void intel_pmu_drain_bts_buffer(v
 }
 
 static inline void
-intel_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+intel_pmu_disable_event(struct perf_event *event)
 {
-	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		intel_pmu_disable_bts();
 		intel_pmu_drain_bts_buffer();
 		return;
 	}
 
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
-		intel_pmu_disable_fixed(hwc, idx);
+		intel_pmu_disable_fixed(hwc);
 		return;
 	}
 
-	x86_pmu_disable_event(hwc, idx);
+	x86_pmu_disable_event(event);
 }
 
 static inline void
-intel_pmu_enable_fixed(struct hw_perf_event *hwc, int __idx)
+intel_pmu_enable_fixed(struct hw_perf_event *hwc)
 {
-	int idx = __idx - X86_PMC_IDX_FIXED;
+	int idx = hwc->idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, bits, mask;
 	int err;
 
@@ -671,9 +673,11 @@ intel_pmu_enable_fixed(struct hw_perf_ev
 	err = checking_wrmsrl(hwc->config_base, ctrl_val);
 }
 
-static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static void intel_pmu_enable_event(struct perf_event *event)
 {
-	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		if (!__get_cpu_var(cpu_hw_events).enabled)
 			return;
 
@@ -682,11 +686,11 @@ static void intel_pmu_enable_event(struc
 	}
 
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
-		intel_pmu_enable_fixed(hwc, idx);
+		intel_pmu_enable_fixed(hwc);
 		return;
 	}
 
-	__x86_pmu_enable_event(hwc, idx);
+	__x86_pmu_enable_event(hwc);
 }
 
 /*
@@ -774,7 +778,7 @@ again:
 		data.period = event->hw.last_period;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			intel_pmu_disable_event(&event->hw, bit);
+			intel_pmu_disable_event(event);
 	}
 
 	intel_pmu_ack_status(ack);
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_p6.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_p6.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_p6.c
@@ -77,27 +77,29 @@ static void p6_pmu_enable_all(void)
 }
 
 static inline void
-p6_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+p6_pmu_disable_event(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
 	u64 val = P6_NOP_EVENT;
 
 	if (cpuc->enabled)
 		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
-	(void)checking_wrmsrl(hwc->config_base + idx, val);
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx, val);
 }
 
-static void p6_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static void p6_pmu_enable_event(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
 	if (cpuc->enabled)
 		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
-	(void)checking_wrmsrl(hwc->config_base + idx, val);
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx, val);
 }
 
 static __initconst struct x86_pmu p6_pmu = {

-- 


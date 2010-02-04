Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab0BDJ5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:57:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:60145 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758118Ab0BDJ51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:57:27 -0500
Date: Thu, 4 Feb 2010 09:56:57 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events, x86: Implement intel core solo/duo support
Message-ID: <tip-8c48e444191de0ff84e85d41180d7bc3e74f14ef@git.kernel.org>
Git-Commit-ID: 8c48e444191de0ff84e85d41180d7bc3e74f14ef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:56:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c48e444191de0ff84e85d41180d7bc3e74f14ef
Gitweb:     http://git.kernel.org/tip/8c48e444191de0ff84e85d41180d7bc3e74f14ef
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 29 Jan 2010 13:25:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:59:49 +0100

perf_events, x86: Implement intel core solo/duo support

Implement Intel Core Solo/Duo, aka.
Intel Architectural Performance Monitoring Version 1.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |  133 +++++++++++++++++--------------------
 1 files changed, 61 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1846ead..5b91992 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -228,6 +228,17 @@ static const u64 intel_perfmon_event_map[] =
 
 static struct event_constraint intel_core_event_constraints[] =
 {
+	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
+	INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
+	INTEL_EVENT_CONSTRAINT(0x13, 0x2), /* DIV */
+	INTEL_EVENT_CONSTRAINT(0x14, 0x1), /* CYCLES_DIV_BUSY */
+	INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
+	INTEL_EVENT_CONSTRAINT(0xc1, 0x1), /* FP_COMP_INSTR_RET */
+	EVENT_CONSTRAINT_END
+};
+
+static struct event_constraint intel_core2_event_constraints[] =
+{
 	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
 	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
 	INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
@@ -1216,7 +1227,7 @@ static void intel_pmu_disable_all(void)
 		intel_pmu_disable_bts();
 }
 
-static void amd_pmu_disable_all(void)
+static void x86_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
@@ -1226,11 +1237,11 @@ static void amd_pmu_disable_all(void)
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
-		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		rdmsrl(x86_pmu.eventsel + idx, val);
 		if (!(val & ARCH_PERFMON_EVENTSEL0_ENABLE))
 			continue;
 		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
-		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		wrmsrl(x86_pmu.eventsel + idx, val);
 	}
 }
 
@@ -1278,7 +1289,7 @@ static void intel_pmu_enable_all(void)
 	}
 }
 
-static void amd_pmu_enable_all(void)
+static void x86_pmu_enable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
@@ -1292,7 +1303,7 @@ static void amd_pmu_enable_all(void)
 
 		val = event->hw.config;
 		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		wrmsrl(x86_pmu.eventsel + idx, val);
 	}
 }
 
@@ -1546,7 +1557,7 @@ static inline void intel_pmu_ack_status(u64 ack)
 	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
 }
 
-static inline void x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 {
 	(void)checking_wrmsrl(hwc->config_base + idx,
 			      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE);
@@ -1598,12 +1609,6 @@ intel_pmu_disable_event(struct hw_perf_event *hwc, int idx)
 	x86_pmu_disable_event(hwc, idx);
 }
 
-static inline void
-amd_pmu_disable_event(struct hw_perf_event *hwc, int idx)
-{
-	x86_pmu_disable_event(hwc, idx);
-}
-
 static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
 
 /*
@@ -1723,15 +1728,14 @@ static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 		return;
 	}
 
-	x86_pmu_enable_event(hwc, idx);
+	__x86_pmu_enable_event(hwc, idx);
 }
 
-static void amd_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static void x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-
 	if (cpuc->enabled)
-		x86_pmu_enable_event(hwc, idx);
+		__x86_pmu_enable_event(hwc, idx);
 }
 
 /*
@@ -1988,50 +1992,6 @@ static void intel_pmu_reset(void)
 	local_irq_restore(flags);
 }
 
-static int p6_pmu_handle_irq(struct pt_regs *regs)
-{
-	struct perf_sample_data data;
-	struct cpu_hw_events *cpuc;
-	struct perf_event *event;
-	struct hw_perf_event *hwc;
-	int idx, handled = 0;
-	u64 val;
-
-	data.addr = 0;
-	data.raw = NULL;
-
-	cpuc = &__get_cpu_var(cpu_hw_events);
-
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
-		if (!test_bit(idx, cpuc->active_mask))
-			continue;
-
-		event = cpuc->events[idx];
-		hwc = &event->hw;
-
-		val = x86_perf_event_update(event, hwc, idx);
-		if (val & (1ULL << (x86_pmu.event_bits - 1)))
-			continue;
-
-		/*
-		 * event overflow
-		 */
-		handled		= 1;
-		data.period	= event->hw.last_period;
-
-		if (!x86_perf_event_set_period(event, hwc, idx))
-			continue;
-
-		if (perf_event_overflow(event, 1, &data, regs))
-			p6_pmu_disable_event(hwc, idx);
-	}
-
-	if (handled)
-		inc_irq_stat(apic_perf_irqs);
-
-	return handled;
-}
-
 /*
  * This handler is triggered by the local APIC, so the APIC IRQ handling
  * rules apply:
@@ -2098,7 +2058,7 @@ again:
 	return 1;
 }
 
-static int amd_pmu_handle_irq(struct pt_regs *regs)
+static int x86_pmu_handle_irq(struct pt_regs *regs)
 {
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc;
@@ -2133,7 +2093,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 			continue;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			amd_pmu_disable_event(hwc, idx);
+			x86_pmu.disable(hwc, idx);
 	}
 
 	if (handled)
@@ -2374,7 +2334,7 @@ static __read_mostly struct notifier_block perf_event_nmi_notifier = {
 
 static __initconst struct x86_pmu p6_pmu = {
 	.name			= "p6",
-	.handle_irq		= p6_pmu_handle_irq,
+	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= p6_pmu_disable_all,
 	.enable_all		= p6_pmu_enable_all,
 	.enable			= p6_pmu_enable_event,
@@ -2401,6 +2361,29 @@ static __initconst struct x86_pmu p6_pmu = {
 	.event_constraints	= intel_p6_event_constraints
 };
 
+static __initconst struct x86_pmu core_pmu = {
+	.name			= "core",
+	.handle_irq		= x86_pmu_handle_irq,
+	.disable_all		= x86_pmu_disable_all,
+	.enable_all		= x86_pmu_enable_all,
+	.enable			= x86_pmu_enable_event,
+	.disable		= x86_pmu_disable_event,
+	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
+	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
+	.event_map		= intel_pmu_event_map,
+	.raw_event		= intel_pmu_raw_event,
+	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
+	.apic			= 1,
+	/*
+	 * Intel PMCs cannot be accessed sanely above 32 bit width,
+	 * so we install an artificial 1<<31 period regardless of
+	 * the generic event period:
+	 */
+	.max_period		= (1ULL << 31) - 1,
+	.get_event_constraints	= intel_get_event_constraints,
+	.event_constraints	= intel_core_event_constraints,
+};
+
 static __initconst struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -2427,11 +2410,11 @@ static __initconst struct x86_pmu intel_pmu = {
 
 static __initconst struct x86_pmu amd_pmu = {
 	.name			= "AMD",
-	.handle_irq		= amd_pmu_handle_irq,
-	.disable_all		= amd_pmu_disable_all,
-	.enable_all		= amd_pmu_enable_all,
-	.enable			= amd_pmu_enable_event,
-	.disable		= amd_pmu_disable_event,
+	.handle_irq		= x86_pmu_handle_irq,
+	.disable_all		= x86_pmu_disable_all,
+	.enable_all		= x86_pmu_enable_all,
+	.enable			= x86_pmu_enable_event,
+	.disable		= x86_pmu_disable_event,
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
 	.event_map		= amd_pmu_event_map,
@@ -2498,9 +2481,10 @@ static __init int intel_pmu_init(void)
 
 	version = eax.split.version_id;
 	if (version < 2)
-		return -ENODEV;
+		x86_pmu = core_pmu;
+	else
+		x86_pmu = intel_pmu;
 
-	x86_pmu				= intel_pmu;
 	x86_pmu.version			= version;
 	x86_pmu.num_events		= eax.split.num_events;
 	x86_pmu.event_bits		= eax.split.bit_width;
@@ -2510,12 +2494,17 @@ static __init int intel_pmu_init(void)
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
 	 * assume at least 3 events:
 	 */
-	x86_pmu.num_events_fixed	= max((int)edx.split.num_events_fixed, 3);
+	if (version > 1)
+		x86_pmu.num_events_fixed = max((int)edx.split.num_events_fixed, 3);
 
 	/*
 	 * Install the hw-cache-events table:
 	 */
 	switch (boot_cpu_data.x86_model) {
+	case 14: /* 65 nm core solo/duo, "Yonah" */
+		pr_cont("Core events, ");
+		break;
+
 	case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
 	case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
 	case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
@@ -2523,7 +2512,7 @@ static __init int intel_pmu_init(void)
 		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
-		x86_pmu.event_constraints = intel_core_event_constraints;
+		x86_pmu.event_constraints = intel_core2_event_constraints;
 		pr_cont("Core2 events, ");
 		break;
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZD2Kz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZD2Kz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbZD2KvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:24 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:23631
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755425AbZD2KvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:10 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KIUZGU-04-0XA-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/29] x86/perfcounters: rename struct pmc_x86_ops into struct x86_pmu
Date: Wed, 29 Apr 2009 12:47:04 +0200
Message-ID: <1241002046-8832-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0305 (UTC) FILETIME=[5B98D490:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames struct pmc_x86_ops into struct x86_pmu. It
introduces a structure to describe an x86 model specific pmu
(performance monitoring unit). It may contain ops and data. The new
name of the structure fits better, is shorter, and thus better to
handle. Where it was appropriate, names of function and variable have
been changed too.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |  135 ++++++++++++++++++------------------
 1 files changed, 68 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 95de980..808a1a1 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -44,9 +44,9 @@ struct cpu_hw_counters {
 };
 
 /*
- * struct pmc_x86_ops - performance counter x86 ops
+ * struct x86_pmu - generic x86 pmu
  */
-struct pmc_x86_ops {
+struct x86_pmu {
 	u64		(*save_disable_all)(void);
 	void		(*restore_all)(u64);
 	u64		(*get_status)(u64);
@@ -60,7 +60,7 @@ struct pmc_x86_ops {
 	int		max_events;
 };
 
-static struct pmc_x86_ops *pmc_ops __read_mostly;
+static struct x86_pmu *x86_pmu __read_mostly;
 
 static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters) = {
 	.enabled = 1,
@@ -82,12 +82,12 @@ static const u64 intel_perfmon_event_map[] =
   [PERF_COUNT_BUS_CYCLES]		= 0x013c,
 };
 
-static u64 pmc_intel_event_map(int event)
+static u64 intel_pmu_event_map(int event)
 {
 	return intel_perfmon_event_map[event];
 }
 
-static u64 pmc_intel_raw_event(u64 event)
+static u64 intel_pmu_raw_event(u64 event)
 {
 #define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
 #define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
@@ -114,12 +114,12 @@ static const u64 amd_perfmon_event_map[] =
   [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
 };
 
-static u64 pmc_amd_event_map(int event)
+static u64 amd_pmu_event_map(int event)
 {
 	return amd_perfmon_event_map[event];
 }
 
-static u64 pmc_amd_raw_event(u64 event)
+static u64 amd_pmu_raw_event(u64 event)
 {
 #define K7_EVNTSEL_EVENT_MASK	0x7000000FFULL
 #define K7_EVNTSEL_UNIT_MASK	0x00000FF00ULL
@@ -184,12 +184,12 @@ static bool reserve_pmc_hardware(void)
 		disable_lapic_nmi_watchdog();
 
 	for (i = 0; i < nr_counters_generic; i++) {
-		if (!reserve_perfctr_nmi(pmc_ops->perfctr + i))
+		if (!reserve_perfctr_nmi(x86_pmu->perfctr + i))
 			goto perfctr_fail;
 	}
 
 	for (i = 0; i < nr_counters_generic; i++) {
-		if (!reserve_evntsel_nmi(pmc_ops->eventsel + i))
+		if (!reserve_evntsel_nmi(x86_pmu->eventsel + i))
 			goto eventsel_fail;
 	}
 
@@ -197,13 +197,13 @@ static bool reserve_pmc_hardware(void)
 
 eventsel_fail:
 	for (i--; i >= 0; i--)
-		release_evntsel_nmi(pmc_ops->eventsel + i);
+		release_evntsel_nmi(x86_pmu->eventsel + i);
 
 	i = nr_counters_generic;
 
 perfctr_fail:
 	for (i--; i >= 0; i--)
-		release_perfctr_nmi(pmc_ops->perfctr + i);
+		release_perfctr_nmi(x86_pmu->perfctr + i);
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		enable_lapic_nmi_watchdog();
@@ -216,8 +216,8 @@ static void release_pmc_hardware(void)
 	int i;
 
 	for (i = 0; i < nr_counters_generic; i++) {
-		release_perfctr_nmi(pmc_ops->perfctr + i);
-		release_evntsel_nmi(pmc_ops->eventsel + i);
+		release_perfctr_nmi(x86_pmu->perfctr + i);
+		release_evntsel_nmi(x86_pmu->eventsel + i);
 	}
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
@@ -293,14 +293,14 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	 * Raw event type provide the config in the event structure
 	 */
 	if (perf_event_raw(hw_event)) {
-		hwc->config |= pmc_ops->raw_event(perf_event_config(hw_event));
+		hwc->config |= x86_pmu->raw_event(perf_event_config(hw_event));
 	} else {
-		if (perf_event_id(hw_event) >= pmc_ops->max_events)
+		if (perf_event_id(hw_event) >= x86_pmu->max_events)
 			return -EINVAL;
 		/*
 		 * The generic map:
 		 */
-		hwc->config |= pmc_ops->event_map(perf_event_id(hw_event));
+		hwc->config |= x86_pmu->event_map(perf_event_id(hw_event));
 	}
 
 	counter->destroy = hw_perf_counter_destroy;
@@ -308,7 +308,7 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	return 0;
 }
 
-static u64 pmc_intel_save_disable_all(void)
+static u64 intel_pmu_save_disable_all(void)
 {
 	u64 ctrl;
 
@@ -318,7 +318,7 @@ static u64 pmc_intel_save_disable_all(void)
 	return ctrl;
 }
 
-static u64 pmc_amd_save_disable_all(void)
+static u64 amd_pmu_save_disable_all(void)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 	int enabled, idx;
@@ -327,7 +327,8 @@ static u64 pmc_amd_save_disable_all(void)
 	cpuc->enabled = 0;
 	/*
 	 * ensure we write the disable before we start disabling the
-	 * counters proper, so that pcm_amd_enable() does the right thing.
+	 * counters proper, so that amd_pmu_enable_counter() does the
+	 * right thing.
 	 */
 	barrier();
 
@@ -351,19 +352,19 @@ u64 hw_perf_save_disable(void)
 	if (unlikely(!perf_counters_initialized))
 		return 0;
 
-	return pmc_ops->save_disable_all();
+	return x86_pmu->save_disable_all();
 }
 /*
  * Exported because of ACPI idle
  */
 EXPORT_SYMBOL_GPL(hw_perf_save_disable);
 
-static void pmc_intel_restore_all(u64 ctrl)
+static void intel_pmu_restore_all(u64 ctrl)
 {
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
 }
 
-static void pmc_amd_restore_all(u64 ctrl)
+static void amd_pmu_restore_all(u64 ctrl)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 	int idx;
@@ -391,14 +392,14 @@ void hw_perf_restore(u64 ctrl)
 	if (unlikely(!perf_counters_initialized))
 		return;
 
-	pmc_ops->restore_all(ctrl);
+	x86_pmu->restore_all(ctrl);
 }
 /*
  * Exported because of ACPI idle
  */
 EXPORT_SYMBOL_GPL(hw_perf_restore);
 
-static u64 pmc_intel_get_status(u64 mask)
+static u64 intel_pmu_get_status(u64 mask)
 {
 	u64 status;
 
@@ -407,7 +408,7 @@ static u64 pmc_intel_get_status(u64 mask)
 	return status;
 }
 
-static u64 pmc_amd_get_status(u64 mask)
+static u64 amd_pmu_get_status(u64 mask)
 {
 	u64 status = 0;
 	int idx;
@@ -432,15 +433,15 @@ static u64 hw_perf_get_status(u64 mask)
 	if (unlikely(!perf_counters_initialized))
 		return 0;
 
-	return pmc_ops->get_status(mask);
+	return x86_pmu->get_status(mask);
 }
 
-static void pmc_intel_ack_status(u64 ack)
+static void intel_pmu_ack_status(u64 ack)
 {
 	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
 }
 
-static void pmc_amd_ack_status(u64 ack)
+static void amd_pmu_ack_status(u64 ack)
 {
 }
 
@@ -449,16 +450,16 @@ static void hw_perf_ack_status(u64 ack)
 	if (unlikely(!perf_counters_initialized))
 		return;
 
-	pmc_ops->ack_status(ack);
+	x86_pmu->ack_status(ack);
 }
 
-static void pmc_intel_enable(int idx, u64 config)
+static void intel_pmu_enable_counter(int idx, u64 config)
 {
 	wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx,
 			config | ARCH_PERFMON_EVENTSEL0_ENABLE);
 }
 
-static void pmc_amd_enable(int idx, u64 config)
+static void amd_pmu_enable_counter(int idx, u64 config)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 
@@ -474,15 +475,15 @@ static void hw_perf_enable(int idx, u64 config)
 	if (unlikely(!perf_counters_initialized))
 		return;
 
-	pmc_ops->enable(idx, config);
+	x86_pmu->enable(idx, config);
 }
 
-static void pmc_intel_disable(int idx, u64 config)
+static void intel_pmu_disable_counter(int idx, u64 config)
 {
 	wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx, config);
 }
 
-static void pmc_amd_disable(int idx, u64 config)
+static void amd_pmu_disable_counter(int idx, u64 config)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 
@@ -496,7 +497,7 @@ static void hw_perf_disable(int idx, u64 config)
 	if (unlikely(!perf_counters_initialized))
 		return;
 
-	pmc_ops->disable(idx, config);
+	x86_pmu->disable(idx, config);
 }
 
 static inline void
@@ -613,11 +614,11 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 
 	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
 
-	if (unlikely(event == pmc_ops->event_map(PERF_COUNT_INSTRUCTIONS)))
+	if (unlikely(event == x86_pmu->event_map(PERF_COUNT_INSTRUCTIONS)))
 		return X86_PMC_IDX_FIXED_INSTRUCTIONS;
-	if (unlikely(event == pmc_ops->event_map(PERF_COUNT_CPU_CYCLES)))
+	if (unlikely(event == x86_pmu->event_map(PERF_COUNT_CPU_CYCLES)))
 		return X86_PMC_IDX_FIXED_CPU_CYCLES;
-	if (unlikely(event == pmc_ops->event_map(PERF_COUNT_BUS_CYCLES)))
+	if (unlikely(event == x86_pmu->event_map(PERF_COUNT_BUS_CYCLES)))
 		return X86_PMC_IDX_FIXED_BUS_CYCLES;
 
 	return -1;
@@ -661,8 +662,8 @@ try_generic:
 			set_bit(idx, cpuc->used);
 			hwc->idx = idx;
 		}
-		hwc->config_base  = pmc_ops->eventsel;
-		hwc->counter_base = pmc_ops->perfctr;
+		hwc->config_base  = x86_pmu->eventsel;
+		hwc->counter_base = x86_pmu->perfctr;
 	}
 
 	perf_counters_lapic_init(hwc->nmi);
@@ -710,8 +711,8 @@ void perf_counter_print_debug(void)
 	pr_info("CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used);
 
 	for (idx = 0; idx < nr_counters_generic; idx++) {
-		rdmsrl(pmc_ops->eventsel + idx, pmc_ctrl);
-		rdmsrl(pmc_ops->perfctr  + idx, pmc_count);
+		rdmsrl(x86_pmu->eventsel + idx, pmc_ctrl);
+		rdmsrl(x86_pmu->perfctr  + idx, pmc_count);
 
 		prev_left = per_cpu(prev_left[idx], cpu);
 
@@ -918,35 +919,35 @@ static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
 	.priority		= 1
 };
 
-static struct pmc_x86_ops pmc_intel_ops = {
-	.save_disable_all	= pmc_intel_save_disable_all,
-	.restore_all		= pmc_intel_restore_all,
-	.get_status		= pmc_intel_get_status,
-	.ack_status		= pmc_intel_ack_status,
-	.enable			= pmc_intel_enable,
-	.disable		= pmc_intel_disable,
+static struct x86_pmu intel_pmu = {
+	.save_disable_all	= intel_pmu_save_disable_all,
+	.restore_all		= intel_pmu_restore_all,
+	.get_status		= intel_pmu_get_status,
+	.ack_status		= intel_pmu_ack_status,
+	.enable			= intel_pmu_enable_counter,
+	.disable		= intel_pmu_disable_counter,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
 	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
-	.event_map		= pmc_intel_event_map,
-	.raw_event		= pmc_intel_raw_event,
+	.event_map		= intel_pmu_event_map,
+	.raw_event		= intel_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
 };
 
-static struct pmc_x86_ops pmc_amd_ops = {
-	.save_disable_all	= pmc_amd_save_disable_all,
-	.restore_all		= pmc_amd_restore_all,
-	.get_status		= pmc_amd_get_status,
-	.ack_status		= pmc_amd_ack_status,
-	.enable			= pmc_amd_enable,
-	.disable		= pmc_amd_disable,
+static struct x86_pmu amd_pmu = {
+	.save_disable_all	= amd_pmu_save_disable_all,
+	.restore_all		= amd_pmu_restore_all,
+	.get_status		= amd_pmu_get_status,
+	.ack_status		= amd_pmu_ack_status,
+	.enable			= amd_pmu_enable_counter,
+	.disable		= amd_pmu_disable_counter,
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
-	.event_map		= pmc_amd_event_map,
-	.raw_event		= pmc_amd_raw_event,
+	.event_map		= amd_pmu_event_map,
+	.raw_event		= amd_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
 };
 
-static struct pmc_x86_ops *pmc_intel_init(void)
+static struct x86_pmu *intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
 	union cpuid10_eax eax;
@@ -977,10 +978,10 @@ static struct pmc_x86_ops *pmc_intel_init(void)
 	nr_counters_fixed = edx.split.num_counters_fixed;
 	counter_value_mask = (1ULL << eax.split.bit_width) - 1;
 
-	return &pmc_intel_ops;
+	return &intel_pmu;
 }
 
-static struct pmc_x86_ops *pmc_amd_init(void)
+static struct x86_pmu *amd_pmu_init(void)
 {
 	nr_counters_generic = 4;
 	nr_counters_fixed = 0;
@@ -989,22 +990,22 @@ static struct pmc_x86_ops *pmc_amd_init(void)
 
 	pr_info("AMD Performance Monitoring support detected.\n");
 
-	return &pmc_amd_ops;
+	return &amd_pmu;
 }
 
 void __init init_hw_perf_counters(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_INTEL:
-		pmc_ops = pmc_intel_init();
+		x86_pmu = intel_pmu_init();
 		break;
 	case X86_VENDOR_AMD:
-		pmc_ops = pmc_amd_init();
+		x86_pmu = amd_pmu_init();
 		break;
 	default:
 		return;
 	}
-	if (!pmc_ops)
+	if (!x86_pmu)
 		return;
 
 	pr_info("... num counters:    %d\n", nr_counters_generic);
-- 
1.6.1.3



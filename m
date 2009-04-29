Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbZD2NJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbZD2NJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZD2NGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:06:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:44560 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499AbZD2NGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:06:36 -0400
Date: Wed, 29 Apr 2009 13:05:58 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-15-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-15-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: make x86_pmu data a static struct
Message-ID: <tip-4a06bd8508f65ad1dd5cd2046b85694813fa36a2@git.kernel.org>
Git-Commit-ID: 4a06bd8508f65ad1dd5cd2046b85694813fa36a2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:06:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a06bd8508f65ad1dd5cd2046b85694813fa36a2
Gitweb:     http://git.kernel.org/tip/4a06bd8508f65ad1dd5cd2046b85694813fa36a2
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:07 +0200

perf_counter, x86: make x86_pmu data a static struct

Instead of using a pointer to reference to the x86 pmu we now have one
single data structure that is initialized at the beginning. This saves
the pointer access when using this memory.

[ Impact: micro-optimization ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-15-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   50 ++++++++++++++++++------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 7c72a94..68597d7 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -60,7 +60,7 @@ struct x86_pmu {
 	int		max_events;
 };
 
-static struct x86_pmu *x86_pmu __read_mostly;
+static struct x86_pmu x86_pmu __read_mostly;
 
 static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters) = {
 	.enabled = 1,
@@ -184,12 +184,12 @@ static bool reserve_pmc_hardware(void)
 		disable_lapic_nmi_watchdog();
 
 	for (i = 0; i < nr_counters_generic; i++) {
-		if (!reserve_perfctr_nmi(x86_pmu->perfctr + i))
+		if (!reserve_perfctr_nmi(x86_pmu.perfctr + i))
 			goto perfctr_fail;
 	}
 
 	for (i = 0; i < nr_counters_generic; i++) {
-		if (!reserve_evntsel_nmi(x86_pmu->eventsel + i))
+		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
 			goto eventsel_fail;
 	}
 
@@ -197,13 +197,13 @@ static bool reserve_pmc_hardware(void)
 
 eventsel_fail:
 	for (i--; i >= 0; i--)
-		release_evntsel_nmi(x86_pmu->eventsel + i);
+		release_evntsel_nmi(x86_pmu.eventsel + i);
 
 	i = nr_counters_generic;
 
 perfctr_fail:
 	for (i--; i >= 0; i--)
-		release_perfctr_nmi(x86_pmu->perfctr + i);
+		release_perfctr_nmi(x86_pmu.perfctr + i);
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		enable_lapic_nmi_watchdog();
@@ -216,8 +216,8 @@ static void release_pmc_hardware(void)
 	int i;
 
 	for (i = 0; i < nr_counters_generic; i++) {
-		release_perfctr_nmi(x86_pmu->perfctr + i);
-		release_evntsel_nmi(x86_pmu->eventsel + i);
+		release_perfctr_nmi(x86_pmu.perfctr + i);
+		release_evntsel_nmi(x86_pmu.eventsel + i);
 	}
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
@@ -297,14 +297,14 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	 * Raw event type provide the config in the event structure
 	 */
 	if (perf_event_raw(hw_event)) {
-		hwc->config |= x86_pmu->raw_event(perf_event_config(hw_event));
+		hwc->config |= x86_pmu.raw_event(perf_event_config(hw_event));
 	} else {
-		if (perf_event_id(hw_event) >= x86_pmu->max_events)
+		if (perf_event_id(hw_event) >= x86_pmu.max_events)
 			return -EINVAL;
 		/*
 		 * The generic map:
 		 */
-		hwc->config |= x86_pmu->event_map(perf_event_id(hw_event));
+		hwc->config |= x86_pmu.event_map(perf_event_id(hw_event));
 	}
 
 	counter->destroy = hw_perf_counter_destroy;
@@ -356,7 +356,7 @@ u64 hw_perf_save_disable(void)
 	if (unlikely(!perf_counters_initialized))
 		return 0;
 
-	return x86_pmu->save_disable_all();
+	return x86_pmu.save_disable_all();
 }
 /*
  * Exported because of ACPI idle
@@ -396,7 +396,7 @@ void hw_perf_restore(u64 ctrl)
 	if (unlikely(!perf_counters_initialized))
 		return;
 
-	x86_pmu->restore_all(ctrl);
+	x86_pmu.restore_all(ctrl);
 }
 /*
  * Exported because of ACPI idle
@@ -441,7 +441,7 @@ static void hw_perf_enable(int idx, u64 config)
 	if (unlikely(!perf_counters_initialized))
 		return;
 
-	x86_pmu->enable(idx, config);
+	x86_pmu.enable(idx, config);
 }
 
 static void intel_pmu_disable_counter(int idx, u64 config)
@@ -463,7 +463,7 @@ static void hw_perf_disable(int idx, u64 config)
 	if (unlikely(!perf_counters_initialized))
 		return;
 
-	x86_pmu->disable(idx, config);
+	x86_pmu.disable(idx, config);
 }
 
 static inline void
@@ -580,11 +580,11 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 
 	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
 
-	if (unlikely(event == x86_pmu->event_map(PERF_COUNT_INSTRUCTIONS)))
+	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_INSTRUCTIONS)))
 		return X86_PMC_IDX_FIXED_INSTRUCTIONS;
-	if (unlikely(event == x86_pmu->event_map(PERF_COUNT_CPU_CYCLES)))
+	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_CPU_CYCLES)))
 		return X86_PMC_IDX_FIXED_CPU_CYCLES;
-	if (unlikely(event == x86_pmu->event_map(PERF_COUNT_BUS_CYCLES)))
+	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_BUS_CYCLES)))
 		return X86_PMC_IDX_FIXED_BUS_CYCLES;
 
 	return -1;
@@ -628,8 +628,8 @@ try_generic:
 			set_bit(idx, cpuc->used);
 			hwc->idx = idx;
 		}
-		hwc->config_base  = x86_pmu->eventsel;
-		hwc->counter_base = x86_pmu->perfctr;
+		hwc->config_base  = x86_pmu.eventsel;
+		hwc->counter_base = x86_pmu.perfctr;
 	}
 
 	perf_counters_lapic_init(hwc->nmi);
@@ -677,8 +677,8 @@ void perf_counter_print_debug(void)
 	pr_info("CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used);
 
 	for (idx = 0; idx < nr_counters_generic; idx++) {
-		rdmsrl(x86_pmu->eventsel + idx, pmc_ctrl);
-		rdmsrl(x86_pmu->perfctr  + idx, pmc_count);
+		rdmsrl(x86_pmu.eventsel + idx, pmc_ctrl);
+		rdmsrl(x86_pmu.perfctr  + idx, pmc_count);
 
 		prev_left = per_cpu(prev_left[idx], cpu);
 
@@ -819,7 +819,7 @@ void smp_perf_counter_interrupt(struct pt_regs *regs)
 	irq_enter();
 	apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
 	ack_APIC_irq();
-	x86_pmu->handle_irq(regs, 0);
+	x86_pmu.handle_irq(regs, 0);
 	irq_exit();
 }
 
@@ -876,7 +876,7 @@ perf_counter_nmi_handler(struct notifier_block *self,
 	regs = args->regs;
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	ret = x86_pmu->handle_irq(regs, 1);
+	ret = x86_pmu.handle_irq(regs, 1);
 
 	return ret ? NOTIFY_STOP : NOTIFY_OK;
 }
@@ -940,7 +940,7 @@ static int intel_pmu_init(void)
 	pr_info("... bit width:       %d\n", eax.split.bit_width);
 	pr_info("... mask length:     %d\n", eax.split.mask_length);
 
-	x86_pmu = &intel_pmu;
+	x86_pmu = intel_pmu;
 
 	nr_counters_generic = eax.split.num_counters;
 	nr_counters_fixed = edx.split.num_counters_fixed;
@@ -951,7 +951,7 @@ static int intel_pmu_init(void)
 
 static int amd_pmu_init(void)
 {
-	x86_pmu = &amd_pmu;
+	x86_pmu = amd_pmu;
 
 	nr_counters_generic = 4;
 	nr_counters_fixed = 0;

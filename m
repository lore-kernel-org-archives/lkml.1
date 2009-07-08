Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbZGHLQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbZGHLQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZGHLP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:15:59 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:16845 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbZGHLP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:15:58 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [patch] perf_counter: Add p6 PMU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0907071559200.30742@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0907071559200.30742@pianoman.cluster.toy>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 13:15:51 +0200
Message-Id: <1247051751.9777.49.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 16:06 -0400, Vince Weaver wrote:
> OK, so I lied, I found time to throw together a p6 PMU patch.
> I've tested it on a Pentium III and it seems to be working.
> 
> I'm sure the patch still needs a lot of work.  I'm not sure how to 
> implement p6_pmu_enable_all().  There is no support for the various 
> cache-related counters.
> 
> The code is based on the info in the Intel Software Developer's Manual Vol 
> 3B, with some comments and code taken from the relevant perfmon2 patches.
> 
> There's a lot of overlap between the p6, intel, and amd methods.  Not sure 
> if it would be wise to merge up some of the common code.
> 
> I do have Pentium Pro, PII, and PIII hardware to test this on.  I also 
> have a Yonah-based laptop, but it might have architectural perfmon version 
> 1 despite being a p6-related core.
> 
> Let's hope this version of pine I am using doesn't do something stupid to 
> the whitespace in the patch.
> 
> Signed-off-by: Vince Weaver <vince@deater.net>

I did the below on top and it does indeed seem to work.. still testing.

---
Subject: perf_counter: cleanup/fix the P6 pmu support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jul 08 10:21:41 CEST 2009

 - event 0x43:
        All loads from any memory type. All stores to any memory type.
        Each part of a split is counted separately. The internal logic
        counts not only memory loads and stores, but also internal
        retries.
        
   doesn't sound like the right kind of event.. but then, it doesn't
   have anything better either.

 - s/CORE_/P6_/ for the evntsel masks

 - completed p6_pmu_{enable,disable}_all()
   enable_all was empty and disable_all would destroy the configuration.
   Neither would touch cpuc->enabled even though p6_pmu_enable_counter()
   relies on it.

 - changed p6_pmu_disable_counter() to simply clear the configuration
   but not touch the EN bit depending on the cpuc->enabled state.

 - counters have an effective width of 32 bits: 0-31.

 - fixed p6_pmu_init() error handling (my machine needs the lapic bit
   so it triggered).

 - remove the rmb() in userspace since ia32 machines tend to not have
   lfence and will trap with SIGILL.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_counter.c |   93 +++++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 35 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c	2009-07-08 12:56:59.000000000 +0200
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c	2009-07-08 12:57:53.000000000 +0200
@@ -72,7 +72,7 @@ static const u64 p6_perfmon_event_map[] 
 {
   [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,
   [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0043,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0000,
   [PERF_COUNT_HW_CACHE_MISSES]		= 0x0000,
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
@@ -86,20 +86,20 @@ static u64 p6_pmu_event_map(int event)
 
 static u64 p6_pmu_raw_event(u64 event)
 {
-#define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
-#define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
-#define CORE_EVNTSEL_EDGE_MASK		0x00040000ULL
-#define CORE_EVNTSEL_INV_MASK		0x00800000ULL
-#define CORE_EVNTSEL_COUNTER_MASK	0xFF000000ULL
+#define P6_EVNTSEL_EVENT_MASK		0x000000FFULL
+#define P6_EVNTSEL_UNIT_MASK		0x0000FF00ULL
+#define P6_EVNTSEL_EDGE_MASK		0x00040000ULL
+#define P6_EVNTSEL_INV_MASK		0x00800000ULL
+#define P6_EVNTSEL_COUNTER_MASK		0xFF000000ULL
+
+#define P6_EVNTSEL_MASK			\
+	(P6_EVNTSEL_EVENT_MASK |	\
+	 P6_EVNTSEL_UNIT_MASK  |	\
+	 P6_EVNTSEL_EDGE_MASK  |	\
+	 P6_EVNTSEL_INV_MASK   |	\
+	 P6_EVNTSEL_COUNTER_MASK)
 
-#define CORE_EVNTSEL_MASK		\
-	(CORE_EVNTSEL_EVENT_MASK |	\
-	 CORE_EVNTSEL_UNIT_MASK  |	\
-	 CORE_EVNTSEL_EDGE_MASK  |	\
-	 CORE_EVNTSEL_INV_MASK  |	\
-	 CORE_EVNTSEL_COUNTER_MASK)
-
-	return event & CORE_EVNTSEL_MASK;
+	return event & P6_EVNTSEL_MASK;
 }
 
 
@@ -766,8 +766,19 @@ static int __hw_perf_counter_init(struct
 
 static void p6_pmu_disable_all(void)
 {
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	unsigned long val;
+
+	if (!cpuc->enabled)
+		return;
+
+	cpuc->enabled = 0;
+	barrier();
+
 	/* p6 only has one enable register */
-	wrmsrl(MSR_P6_EVNTSEL0, 0);
+	rdmsrl(MSR_P6_EVNTSEL0, val);
+	val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+	wrmsrl(MSR_P6_EVNTSEL0, val);
 }
 
 static void intel_pmu_disable_all(void)
@@ -813,6 +824,19 @@ void hw_perf_disable(void)
 
 static void p6_pmu_enable_all(void)
 {
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	unsigned long val;
+
+	if (cpuc->enabled)
+		return;
+
+	cpuc->enabled = 1;
+	barrier();
+
+	/* p6 only has one enable register */
+	rdmsrl(MSR_P6_EVNTSEL0, val);
+	val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	wrmsrl(MSR_P6_EVNTSEL0, val);
 }
 
 static void intel_pmu_enable_all(void)
@@ -867,16 +891,13 @@ static inline void intel_pmu_ack_status(
 
 static inline void x86_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 {
-	int err;
-	err = checking_wrmsrl(hwc->config_base + idx,
+	(void)checking_wrmsrl(hwc->config_base + idx,
 			      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE);
 }
 
 static inline void x86_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 {
-	int err;
-	err = checking_wrmsrl(hwc->config_base + idx,
-			      hwc->config);
+	(void)checking_wrmsrl(hwc->config_base + idx, hwc->config);
 }
 
 static inline void
@@ -884,19 +905,24 @@ intel_pmu_disable_fixed(struct hw_perf_c
 {
 	int idx = __idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, mask;
-	int err;
 
 	mask = 0xfULL << (idx * 4);
 
 	rdmsrl(hwc->config_base, ctrl_val);
 	ctrl_val &= ~mask;
-	err = checking_wrmsrl(hwc->config_base, ctrl_val);
+	(void)checking_wrmsrl(hwc->config_base, ctrl_val);
 }
 
 static inline void
 p6_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 {
-	x86_pmu_disable_counter(hwc, idx);
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	unsigned long val = ARCH_PERFMON_EVENTSEL0_ENABLE;
+
+	if (!cpuc->enabled)
+		val = 0;
+
+	(void)checking_wrmsrl(hwc->config_base + idx, val);
 }
 
 static inline void
@@ -1247,14 +1273,13 @@ static int p6_pmu_handle_irq(struct pt_r
 	struct cpu_hw_counters *cpuc;
 	struct perf_counter *counter;
 	struct hw_perf_counter *hwc;
-	int cpu, idx, handled = 0;
+	int idx, handled = 0;
 	u64 val;
 
 	data.regs = regs;
 	data.addr = 0;
 
-	cpu = smp_processor_id();
-	cpuc = &per_cpu(cpu_hw_counters, cpu);
+	cpuc = &__get_cpu_var(cpu_hw_counters);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		if (!test_bit(idx, cpuc->active_mask))
@@ -1294,14 +1319,13 @@ static int intel_pmu_handle_irq(struct p
 {
 	struct perf_sample_data data;
 	struct cpu_hw_counters *cpuc;
-	int bit, cpu, loops;
+	int bit, loops;
 	u64 ack, status;
 
 	data.regs = regs;
 	data.addr = 0;
 
-	cpu = smp_processor_id();
-	cpuc = &per_cpu(cpu_hw_counters, cpu);
+	cpuc = &__get_cpu_var(cpu_hw_counters);
 
 	perf_disable();
 	status = intel_pmu_get_status();
@@ -1358,14 +1382,13 @@ static int amd_pmu_handle_irq(struct pt_
 	struct cpu_hw_counters *cpuc;
 	struct perf_counter *counter;
 	struct hw_perf_counter *hwc;
-	int cpu, idx, handled = 0;
+	int idx, handled = 0;
 	u64 val;
 
 	data.regs = regs;
 	data.addr = 0;
 
-	cpu = smp_processor_id();
-	cpuc = &per_cpu(cpu_hw_counters, cpu);
+	cpuc = &__get_cpu_var(cpu_hw_counters);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		if (!test_bit(idx, cpuc->active_mask))
@@ -1480,13 +1503,12 @@ static struct x86_pmu p6_pmu = {
 	/*
 	 * Counters have 40 bits implemented. However they are designed such
 	 * that bits [32-39] are sign extensions of bit 31. As such the
-	 * effective width of a counter for P6-like PMU is 31 bits only.
-	 *
+	 * effective width of a counter for P6-like PMU is 32 bits only.
 	 *
 	 * See IA-32 Intel Architecture Software developer manual Vol 3B
 	 */
-	.counter_bits		= 31,
-	.counter_mask		= (1ULL << 31) - 1,
+	.counter_bits		= 32,
+	.counter_mask		= (1ULL << 32) - 1,
 };
 
 static struct x86_pmu intel_pmu = {
@@ -1541,17 +1563,17 @@ static int p6_pmu_init(void)
 	case 13:
 		/* for Pentium M, we need to check if PMU exist */
 		rdmsr(MSR_IA32_MISC_ENABLE, low, high);
-		if (low & (1U << 7))
+		if (low & MSR_IA32_MISC_ENABLE_EMON)
 			break;
 	default:
 		pr_cont("unsupported p6 CPU model %d ",
 			boot_cpu_data.x86_model);
-		return -1;
+		return -ENODEV;
 	}
 
 	if (!cpu_has_apic) {
 		pr_info("no Local APIC, try rebooting with lapic");
-		return -1;
+		return -ENODEV;
 	}
 
 	x86_pmu				= p6_pmu;
@@ -1568,10 +1590,8 @@ static int intel_pmu_init(void)
 	int version;
 
 	/* check for P6 processor family */
-	if (boot_cpu_data.x86 == 6) {
-		p6_pmu_init();
-		return 0;
-	}
+	if (boot_cpu_data.x86 == 6)
+		return p6_pmu_init();
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
 		return -ENODEV;
Index: linux-2.6/tools/perf/perf.h
===================================================================
--- linux-2.6.orig/tools/perf/perf.h	2009-07-08 12:57:50.000000000 +0200
+++ linux-2.6/tools/perf/perf.h	2009-07-08 12:57:53.000000000 +0200
@@ -1,7 +1,13 @@
 #ifndef _PERF_PERF_H
 #define _PERF_PERF_H
 
-#if defined(__x86_64__) || defined(__i386__)
+#if defined(__i386__)
+#include "../../arch/x86/include/asm/unistd.h"
+#define rmb()		asm volatile("" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#endif
+
+#if defined(__x86_64__)
 #include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");



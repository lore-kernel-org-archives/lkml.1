Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab0BHPg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:36:26 -0500
Received: from smtp-out.google.com ([216.239.33.17]:38566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab0BHPgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:36:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=jOborfWy9LZDRGaiwsiY5oZhvugUN8GyfwY1MEkE6zpM3wNFYM2LArHhqLYyaHWoI
	QxmM3e5QG+re11OYMkZqg==
Message-ID: <4b702f70.1818d00a.0508.4f7e@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 8 Feb 2010 16:10:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf_events: support for Intel bus-cycles/unhalted_ref_cycles events
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	On Intel Core, Nehalem, Atom, there are multiple events to count
	elapsed cycles:

	- unhalted_core_cycles: elapsed cycles, correlation to time not
	  maintained with time when frequency scaling operates

	- unhalted_reference_cycles: elasped cycles, correlation to time
	  constant, regardless of frequency scaling.

	- cpu_clk_unhalted:bus: counts bus cycles.
	  Ratio with unhalted_reference_cycles constant.

	Perf_events relies on event codes to identify events and map them
	onto the correct counter. There is an issue with fixed counter only
	events because they have no specific event codes. Instead, the code
	relies on them being measurable also on generic counters, therefore
	having an event code. The event scheduling first tries to use the
	generic counter, then the fixed counter.

	The problem is that for bus-cycles (code 0x013c), measuring the event
	in a generic counter or in fixed counter 2 does not measure the same
	thing. In a generic counter, 0x13c measures bus cycles, but when fixed
	counter is used it measurs unhalted_reference_cycles. Thus, there is
	an issue to name the event to measure in fixed counter 2, yet it is quite
	useful.

	This patch enables the distinction of bus-cycles and ref-cycles leveraging
	the generic PMU events and in particular PERF_COUNT_HW_BUS_CYCLES. The event
	is encoded specially by the kernel such that, though it uses 0x013c, the
	scheduling code will force it onto the generic counters, thereby measuring
	actual bus cycles. Then, the regular 0x13c code is constrained to the fixed
	counter 2 only, thereby measuring ref-cycles. The special is also alvailable
	from user mode. It leverages unused Intel config bits (bit 32).

	Note that an alternative approach would be to introduce a new generic PMU
	event to distinguish between CORE_CYCLES and REF_CYCLES.

	The results with perf is:

	$ perf stat -e cycles,bus-cycles,r10000013c noploop 10
	noploop for 10 seconds

 	Performance counter stats for 'noploop 10':

    	23695472504 cycles                  
     	2632830132  bus-cycles              
     	2632830132  raw 0x10000013c         

   	10.000692965  seconds time elapsed

	With a libpfm4 tool which understand symbol PMU-specific events:

	$ task -g -e unhalted_reference_cycles,unhalted_core_cycles,\
		     instructions_retired,perf_count_hw_bus_cycles noploop 10
	 noploop for 10 seconds
         23565758184 unhalted_reference_cycles
         23565787569 unhalted_core_cycles
         23560689959 instructions_retired
          2618418665 perf_count_hw_bus_cycles

	Signed-off-by: Stephane Eranian <eranian@google.com>
--
 include/asm/perf_event.h |    5 --
 kernel/cpu/perf_event.c  |   91 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 82 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index befd172..3df219d 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -50,7 +50,7 @@
 	 INTEL_ARCH_INV_MASK| \
 	 INTEL_ARCH_EDGE_MASK|\
 	 INTEL_ARCH_UNIT_MASK|\
-	 INTEL_ARCH_EVTSEL_MASK)
+	 INTEL_ARCH_EVENT_MASK)
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
@@ -98,15 +98,12 @@ union cpuid10_edx {
 
 /* Instr_Retired.Any: */
 #define MSR_ARCH_PERFMON_FIXED_CTR0			0x309
-#define X86_PMC_IDX_FIXED_INSTRUCTIONS			(X86_PMC_IDX_FIXED + 0)
 
 /* CPU_CLK_Unhalted.Core: */
 #define MSR_ARCH_PERFMON_FIXED_CTR1			0x30a
-#define X86_PMC_IDX_FIXED_CPU_CYCLES			(X86_PMC_IDX_FIXED + 1)
 
 /* CPU_CLK_Unhalted.Ref: */
 #define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
-#define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
 
 /*
  * We model BTS tracing as another fixed-mode PMC.
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a920f17..3ec4f9c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -75,8 +75,8 @@ struct event_constraint {
 		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 		u64		idxmsk64[1];
 	};
-	int	code;
-	int	cmask;
+	u64	code;
+	u64	cmask;
 	int	weight;
 };
 
@@ -217,6 +217,36 @@ static struct event_constraint intel_p6_event_constraints[] =
 };
 
 /*
+ * event 0x13c can be interpreted as:
+ * - unhalted_reference_cycles (fixed counter 2)
+ * - cpu_clk_unhalted:ref_p (generic counters)
+ *
+ * The problem is that depending on where the
+ * event is programmed, it does not quite count
+ * the same thing.
+ *
+ * In fixed counter2, it counts cycles at TSC
+ * and unmodified by frequency scaling.
+ *
+ * In a generic counter, it counts cycles at
+ * bus frequency. The ratio with TSC is constant.
+ *
+ * To solve the naming issues, we leverage the generic
+ * PMU event PERF_COUNT_HW_BUS_CYCLES and constrained
+ * it to a generic counter, thereby counting actual bus
+ * cycles. When the event is passed as 0x13c (RAW), then
+ * it counts at TSC, thus unhalted_reference_cycles.
+ *
+ * In order to distinguish the two situations, we use
+ * a reserved bits in the config MSR to add a special
+ * marker which is the checked when constraints are
+ * retrieved.
+ */
+#define INTEL_SPECIAL_BUS_EVENT		(1ULL<<32)
+#define INTEL_SPECIAL_EVENT_MASK	(INTEL_SPECIAL_BUS_EVENT)
+#define INTEL_BUS_EVENT			(0x013cULL | INTEL_SPECIAL_BUS_EVENT)
+
+/*
  * Intel PerfMon v3. Used on Core2 and later.
  */
 static const u64 intel_perfmon_event_map[] =
@@ -227,7 +257,7 @@ static const u64 intel_perfmon_event_map[] =
   [PERF_COUNT_HW_CACHE_MISSES]		= 0x412e,
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
-  [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
+  [PERF_COUNT_HW_BUS_CYCLES]		= INTEL_BUS_EVENT,
 };
 
 static struct event_constraint intel_core_event_constraints[] =
@@ -243,8 +273,9 @@ static struct event_constraint intel_core_event_constraints[] =
 
 static struct event_constraint intel_core2_event_constraints[] =
 {
-	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
-	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0x00c0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0x003c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0x013c, (1ULL<<34)), /* UNHALTED_REFERENCE_CYCLES */
 	INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
 	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
 	INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
@@ -261,6 +292,7 @@ static struct event_constraint intel_nehalem_event_constraints[] =
 {
 	FIXED_EVENT_CONSTRAINT(0xc0, (0xf|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
 	FIXED_EVENT_CONSTRAINT(0x3c, (0xf|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0x013c, (1ULL<<34)), /* UNHALTED_REFERENCE_CYCLES */
 	INTEL_EVENT_CONSTRAINT(0x40, 0x3), /* L1D_CACHE_LD */
 	INTEL_EVENT_CONSTRAINT(0x41, 0x3), /* L1D_CACHE_ST */
 	INTEL_EVENT_CONSTRAINT(0x42, 0x3), /* L1D_CACHE_LOCK */
@@ -282,10 +314,17 @@ static struct event_constraint intel_westmere_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
+static struct event_constraint intel_atom_event_constraints[] =
+{
+	FIXED_EVENT_CONSTRAINT(0x00c0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0x003c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0x013c, (1ULL<<34)), /* UNHALTED_REFERENCE_CYCLES */
+};
+
 static struct event_constraint intel_gen_event_constraints[] =
 {
-	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
-	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0xc0, (1ULL<<32)), /* INSTRUCTIONS_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0x3c, (1ULL<<33)), /* UNHALTED_CORE_CYCLES */
 	EVENT_CONSTRAINT_END
 };
 
@@ -686,7 +725,8 @@ static u64 intel_pmu_raw_event(u64 hw_event)
 	 INTEL_ARCH_UNIT_MASK   |	\
 	 INTEL_ARCH_EDGE_MASK   |	\
 	 INTEL_ARCH_INV_MASK    |	\
-	 INTEL_ARCH_CNT_MASK)
+	 INTEL_ARCH_CNT_MASK	|	\
+	 INTEL_SPECIAL_EVENT_MASK)
 
 	return hw_event & CORE_EVNTSEL_MASK;
 }
@@ -1740,6 +1780,8 @@ static void p6_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 
 static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 {
+	u64 config = hwc->config;
+
 	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
 		if (!__get_cpu_var(cpu_hw_events).enabled)
 			return;
@@ -1753,7 +1795,11 @@ static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 		return;
 	}
 
-	__x86_pmu_enable_event(hwc, idx);
+	/* cleanup any special encoding in the upper half (special events) */
+	config = (config & ~INTEL_SPECIAL_EVENT_MASK) |
+		 ARCH_PERFMON_EVENTSEL0_ENABLE;
+
+	(void)checking_wrmsrl(hwc->config_base + idx, config);
 }
 
 static void x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
@@ -2200,6 +2246,16 @@ static struct event_constraint unconstrained;
 static struct event_constraint bts_constraint =
 	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
 
+static struct event_constraint intel_bus_event_constraint =
+	EVENT_CONSTRAINT(0, 0x3, 0);
+
+static inline bool
+is_intel_special_bus_event(struct perf_event *event)
+{
+	u64 config = event->hw.config;
+	return (config & INTEL_BUS_EVENT) == INTEL_BUS_EVENT;
+}
+
 static struct event_constraint *
 intel_special_constraints(struct perf_event *event)
 {
@@ -2213,6 +2269,10 @@ intel_special_constraints(struct perf_event *event)
 
 		return &bts_constraint;
 	}
+	/* special handling for bus cycles */
+	if (is_intel_special_bus_event(event) && x86_pmu.version >= 2)
+		return &intel_bus_event_constraint;
+
 	return NULL;
 }
 
@@ -2481,6 +2541,7 @@ static __init int p6_pmu_init(void)
 
 static __init int intel_pmu_init(void)
 {
+	struct event_constraint *c;
 	union cpuid10_edx edx;
 	union cpuid10_eax eax;
 	unsigned int unused;
@@ -2553,7 +2614,7 @@ static __init int intel_pmu_init(void)
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
-		x86_pmu.event_constraints = intel_gen_event_constraints;
+		x86_pmu.event_constraints = intel_atom_event_constraints;
 		pr_cont("Atom events, ");
 		break;
 
@@ -2570,6 +2631,16 @@ static __init int intel_pmu_init(void)
 		 * default constraints for v2 and up
 		 */
 		x86_pmu.event_constraints = intel_gen_event_constraints;
+
+		/* does not handle unhalted_reference_cycles */
+		for_each_event_constraint(c, x86_pmu.event_constraints) {
+			if (c->cmask != INTEL_ARCH_FIXED_MASK)
+				continue;
+
+			c->idxmsk64[0] |= (1ULL << x86_pmu.num_events) - 1;
+			c->weight += x86_pmu.num_events;
+		}
+
 		pr_cont("generic architected perfmon, ");
 	}
 	return 0;

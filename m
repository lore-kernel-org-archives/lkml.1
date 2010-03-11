Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab0CKTMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:12:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35548 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab0CKTMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:12:36 -0500
Date: Thu, 11 Mar 2010 20:12:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100311191204.GA368@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf archive: Don't try to collect files without a build-id

Frederic Weisbecker (5):
      perf lock: Drop the buffers multiplexing dependency
      perf: Remove pointless breakpoint union
      x86/hw-breakpoints: Remove the name field
      hw-breakpoints: Remove stub unthrottle callback
      x86/stacktrace: Don't dereference bad frame pointers

Hitoshi Mitake (1):
      perf lock: Fix and add misc documentally things

Ingo Molnar (1):
      MAINTAINERS: Add Arnaldo as tools/perf/ co-maintainer

Peter Zijlstra (3):
      perf, x86: Restrict the ANY flag
      perf_events, x86: Fixup fixed counter constraints
      perf: Provide generic perf_sample_data initialization

Robert Richter (3):
      perf, x86: make IBS macros available in perf_event.h
      perf, x86: add some IBS macros to perf_event.h
      perf, x86: rename macro in ARCH_PERFMON_EVENTSEL_ENABLE

Tejun Heo (1):
      percpu: Add __percpu sparse annotations to hw_breakpoint

Tom Zanussi (2):
      perf trace/scripting: Remove extraneous header read
      perf trace: Don't use pager if scripting

Will Deacon (1):
      perf, ARM: Modify kuser rmb() call to compile for Thumb-2


 MAINTAINERS                             |    1 +
 arch/arm/kernel/perf_event.c            |    4 +-
 arch/powerpc/kernel/perf_event.c        |    8 +-
 arch/sparc/kernel/perf_event.c          |    2 +-
 arch/x86/include/asm/hw_breakpoint.h    |    1 -
 arch/x86/include/asm/perf_event.h       |   16 +++-
 arch/x86/kernel/cpu/perf_event.c        |   39 ++++++---
 arch/x86/kernel/cpu/perf_event_intel.c  |   37 +++++---
 arch/x86/kernel/cpu/perf_event_p6.c     |    8 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c  |    2 +-
 arch/x86/kernel/dumpstack_64.c          |   10 ++-
 arch/x86/kernel/hw_breakpoint.c         |   12 ---
 arch/x86/oprofile/op_model_amd.c        |   23 ++----
 arch/x86/oprofile/op_model_ppro.c       |    6 +-
 include/linux/hw_breakpoint.h           |    8 +-
 include/linux/perf_event.h              |   27 +++++-
 kernel/hw_breakpoint.c                  |   11 +--
 kernel/perf_event.c                     |   36 ++------
 lib/Kconfig.debug                       |    8 ++
 samples/hw_breakpoint/data_breakpoint.c |    6 +-
 tools/perf/Documentation/perf-lock.txt  |   29 ++++++
 tools/perf/builtin-lock.c               |  148 ++++++++++++++++++++++++++++++-
 tools/perf/builtin-trace.c              |    4 +-
 tools/perf/command-list.txt             |    1 +
 tools/perf/perf-archive.sh              |    3 +-
 tools/perf/perf.h                       |    4 +-
 tools/perf/util/probe-event.c           |    2 +-
 27 files changed, 327 insertions(+), 129 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-lock.txt

diff --git a/MAINTAINERS b/MAINTAINERS
index c8a8b1f..14d5c4c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4293,6 +4293,7 @@ PERFORMANCE EVENTS SUBSYSTEM
 M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
+M:	Arnaldo Carvalho de Melo <acme@redhat.com>
 S:	Supported
 F:	kernel/perf_event.c
 F:	include/linux/perf_event.h
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index c54ceb3..3875d99 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -965,7 +965,7 @@ armv6pmu_handle_irq(int irq_num,
 	 */
 	armv6_pmcr_write(pmcr);
 
-	data.addr = 0;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 	for (idx = 0; idx <= armpmu->num_events; ++idx) {
@@ -1945,7 +1945,7 @@ static irqreturn_t armv7pmu_handle_irq(int irq_num, void *dev)
 	 */
 	regs = get_irq_regs();
 
-	data.addr = 0;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 	for (idx = 0; idx <= armpmu->num_events; ++idx) {
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index b6cf8f1..5120bd4 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1164,10 +1164,10 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 	 * Finally record data if requested.
 	 */
 	if (record) {
-		struct perf_sample_data data = {
-			.addr	= ~0ULL,
-			.period	= event->hw.last_period,
-		};
+		struct perf_sample_data data;
+
+		perf_sample_data_init(&data, ~0ULL);
+		data.period = event->hw.last_period;
 
 		if (event->attr.sample_type & PERF_SAMPLE_ADDR)
 			perf_get_data_addr(regs, &data.addr);
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 9f2b2ba..6504208 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1189,7 +1189,7 @@ static int __kprobes perf_event_nmi_handler(struct notifier_block *self,
 
 	regs = args->regs;
 
-	data.addr = 0;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 0675a7c..2a1bd8f 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -10,7 +10,6 @@
  * (display/resolving)
  */
 struct arch_hw_breakpoint {
-	char		*name; /* Contains name of the symbol to set bkpt */
 	unsigned long	address;
 	u8		len;
 	u8		type;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index befd172..db6109a 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -18,7 +18,7 @@
 #define MSR_ARCH_PERFMON_EVENTSEL0			     0x186
 #define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
 
-#define ARCH_PERFMON_EVENTSEL0_ENABLE			  (1 << 22)
+#define ARCH_PERFMON_EVENTSEL_ENABLE			  (1 << 22)
 #define ARCH_PERFMON_EVENTSEL_ANY			  (1 << 21)
 #define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
 #define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
@@ -50,7 +50,7 @@
 	 INTEL_ARCH_INV_MASK| \
 	 INTEL_ARCH_EDGE_MASK|\
 	 INTEL_ARCH_UNIT_MASK|\
-	 INTEL_ARCH_EVTSEL_MASK)
+	 INTEL_ARCH_EVENT_MASK)
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
@@ -117,6 +117,18 @@ union cpuid10_edx {
  */
 #define X86_PMC_IDX_FIXED_BTS				(X86_PMC_IDX_FIXED + 16)
 
+/* IbsFetchCtl bits/masks */
+#define IBS_FETCH_RAND_EN		(1ULL<<57)
+#define IBS_FETCH_VAL			(1ULL<<49)
+#define IBS_FETCH_ENABLE		(1ULL<<48)
+#define IBS_FETCH_CNT			0xFFFF0000ULL
+#define IBS_FETCH_MAX_CNT		0x0000FFFFULL
+
+/* IbsOpCtl bits */
+#define IBS_OP_CNT_CTL			(1ULL<<19)
+#define IBS_OP_VAL			(1ULL<<18)
+#define IBS_OP_ENABLE			(1ULL<<17)
+#define IBS_OP_MAX_CNT			0x0000FFFFULL
 
 #ifdef CONFIG_PERF_EVENTS
 extern void init_hw_perf_events(void);
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b1fbdee..42aafd1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -73,10 +73,10 @@ struct debug_store {
 struct event_constraint {
 	union {
 		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-		u64		idxmsk64[1];
+		u64		idxmsk64;
 	};
-	int	code;
-	int	cmask;
+	u64	code;
+	u64	cmask;
 	int	weight;
 };
 
@@ -103,7 +103,7 @@ struct cpu_hw_events {
 };
 
 #define __EVENT_CONSTRAINT(c, n, m, w) {\
-	{ .idxmsk64[0] = (n) },		\
+	{ .idxmsk64 = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
 	.weight = (w),			\
@@ -116,7 +116,7 @@ struct cpu_hw_events {
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVTSEL_MASK)
 
 #define FIXED_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, INTEL_ARCH_FIXED_MASK)
+	EVENT_CONSTRAINT(c, (1ULL << (32+n)), INTEL_ARCH_FIXED_MASK)
 
 #define EVENT_CONSTRAINT_END		\
 	EVENT_CONSTRAINT(0, 0, 0)
@@ -503,6 +503,9 @@ static int __hw_perf_event_init(struct perf_event *event)
 	 */
 	if (attr->type == PERF_TYPE_RAW) {
 		hwc->config |= x86_pmu.raw_event(attr->config);
+		if ((hwc->config & ARCH_PERFMON_EVENTSEL_ANY) &&
+		    perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		return 0;
 	}
 
@@ -553,9 +556,9 @@ static void x86_pmu_disable_all(void)
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 		rdmsrl(x86_pmu.eventsel + idx, val);
-		if (!(val & ARCH_PERFMON_EVENTSEL0_ENABLE))
+		if (!(val & ARCH_PERFMON_EVENTSEL_ENABLE))
 			continue;
-		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(x86_pmu.eventsel + idx, val);
 	}
 }
@@ -590,7 +593,7 @@ static void x86_pmu_enable_all(void)
 			continue;
 
 		val = event->hw.config;
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(x86_pmu.eventsel + idx, val);
 	}
 }
@@ -612,8 +615,8 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 
 	for (i = 0; i < n; i++) {
-		constraints[i] =
-		  x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
+		c = x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
+		constraints[i] = c;
 	}
 
 	/*
@@ -853,7 +856,7 @@ void hw_perf_enable(void)
 static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 {
 	(void)checking_wrmsrl(hwc->config_base + idx,
-			      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE);
+			      hwc->config | ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
 static inline void x86_pmu_disable_event(struct hw_perf_event *hwc, int idx)
@@ -1094,8 +1097,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 	int idx, handled = 0;
 	u64 val;
 
-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1347,6 +1349,7 @@ static void __init pmu_check_apic(void)
 
 void __init init_hw_perf_events(void)
 {
+	struct event_constraint *c;
 	int err;
 
 	pr_info("Performance Events: ");
@@ -1395,6 +1398,16 @@ void __init init_hw_perf_events(void)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_events) - 1,
 				   0, x86_pmu.num_events);
 
+	if (x86_pmu.event_constraints) {
+		for_each_event_constraint(c, x86_pmu.event_constraints) {
+			if (c->cmask != INTEL_ARCH_FIXED_MASK)
+				continue;
+
+			c->idxmsk64 |= (1ULL << x86_pmu.num_events) - 1;
+			c->weight += x86_pmu.num_events;
+		}
+	}
+
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.event_bits);
 	pr_info("... generic registers:      %d\n",     x86_pmu.num_events);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 977e754..44b60c8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1,7 +1,7 @@
 #ifdef CONFIG_CPU_SUP_INTEL
 
 /*
- * Intel PerfMon v3. Used on Core2 and later.
+ * Intel PerfMon, used on Core and later.
  */
 static const u64 intel_perfmon_event_map[] =
 {
@@ -27,8 +27,14 @@ static struct event_constraint intel_core_event_constraints[] =
 
 static struct event_constraint intel_core2_event_constraints[] =
 {
-	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
-	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
+	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
+	/*
+	 * Core2 has Fixed Counter 2 listed as CPU_CLK_UNHALTED.REF and event
+	 * 0x013c as CPU_CLK_UNHALTED.BUS and specifies there is a fixed
+	 * ratio between these counters.
+	 */
+	/* FIXED_EVENT_CONSTRAINT(0x013c, 2),  CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
 	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
 	INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
@@ -37,14 +43,16 @@ static struct event_constraint intel_core2_event_constraints[] =
 	INTEL_EVENT_CONSTRAINT(0x18, 0x1), /* IDLE_DURING_DIV */
 	INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
 	INTEL_EVENT_CONSTRAINT(0xa1, 0x1), /* RS_UOPS_DISPATCH_CYCLES */
+	INTEL_EVENT_CONSTRAINT(0xc9, 0x1), /* ITLB_MISS_RETIRED (T30-9) */
 	INTEL_EVENT_CONSTRAINT(0xcb, 0x1), /* MEM_LOAD_RETIRED */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_nehalem_event_constraints[] =
 {
-	FIXED_EVENT_CONSTRAINT(0xc0, (0xf|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
-	FIXED_EVENT_CONSTRAINT(0x3c, (0xf|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
+	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
+	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x40, 0x3), /* L1D_CACHE_LD */
 	INTEL_EVENT_CONSTRAINT(0x41, 0x3), /* L1D_CACHE_ST */
 	INTEL_EVENT_CONSTRAINT(0x42, 0x3), /* L1D_CACHE_LOCK */
@@ -58,8 +66,9 @@ static struct event_constraint intel_nehalem_event_constraints[] =
 
 static struct event_constraint intel_westmere_event_constraints[] =
 {
-	FIXED_EVENT_CONSTRAINT(0xc0, (0xf|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
-	FIXED_EVENT_CONSTRAINT(0x3c, (0xf|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
+	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
+	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
 	INTEL_EVENT_CONSTRAINT(0x60, 0x1), /* OFFCORE_REQUESTS_OUTSTANDING */
 	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
@@ -68,8 +77,9 @@ static struct event_constraint intel_westmere_event_constraints[] =
 
 static struct event_constraint intel_gen_event_constraints[] =
 {
-	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
-	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
+	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
+	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
 	EVENT_CONSTRAINT_END
 };
 
@@ -580,10 +590,9 @@ static void intel_pmu_drain_bts_buffer(void)
 
 	ds->bts_index = ds->bts_buffer_base;
 
+	perf_sample_data_init(&data, 0);
 
 	data.period	= event->hw.last_period;
-	data.addr	= 0;
-	data.raw	= NULL;
 	regs.ip		= 0;
 
 	/*
@@ -732,8 +741,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	int bit, loops;
 	u64 ack, status;
 
-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -935,7 +943,7 @@ static __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_nehalem_event_constraints;
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
-	case 28:
+	case 28: /* Atom */
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -951,6 +959,7 @@ static __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_westmere_event_constraints;
 		pr_cont("Westmere events, ");
 		break;
+
 	default:
 		/*
 		 * default constraints for v2 and up
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 1ca5ba0..a4e67b9 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -62,7 +62,7 @@ static void p6_pmu_disable_all(void)
 
 	/* p6 only has one enable register */
 	rdmsrl(MSR_P6_EVNTSEL0, val);
-	val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+	val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 	wrmsrl(MSR_P6_EVNTSEL0, val);
 }
 
@@ -72,7 +72,7 @@ static void p6_pmu_enable_all(void)
 
 	/* p6 only has one enable register */
 	rdmsrl(MSR_P6_EVNTSEL0, val);
-	val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 	wrmsrl(MSR_P6_EVNTSEL0, val);
 }
 
@@ -83,7 +83,7 @@ p6_pmu_disable_event(struct hw_perf_event *hwc, int idx)
 	u64 val = P6_NOP_EVENT;
 
 	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)checking_wrmsrl(hwc->config_base + idx, val);
 }
@@ -95,7 +95,7 @@ static void p6_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 
 	val = hwc->config;
 	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)checking_wrmsrl(hwc->config_base + idx, val);
 }
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 74f4e85..fb329e9 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -680,7 +680,7 @@ static int setup_intel_arch_watchdog(unsigned nmi_hz)
 	cpu_nmi_set_wd_enabled();
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	evntsel |= ARCH_PERFMON_EVENTSEL_ENABLE;
 	wrmsr(evntsel_msr, evntsel, 0);
 	intel_arch_wd_ops.checkbit = 1ULL << (eax.split.bit_width - 1);
 	return 1;
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index dce99ab..d5e2a2e 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -120,9 +120,15 @@ fixup_bp_irq_link(unsigned long bp, unsigned long *stack,
 {
 #ifdef CONFIG_FRAME_POINTER
 	struct stack_frame *frame = (struct stack_frame *)bp;
+	unsigned long next;
 
-	if (!in_irq_stack(stack, irq_stack, irq_stack_end))
-		return (unsigned long)frame->next_frame;
+	if (!in_irq_stack(stack, irq_stack, irq_stack_end)) {
+		if (!probe_kernel_address(&frame->next_frame, next))
+			return next;
+		else
+			WARN_ONCE(1, "Perf: bad frame pointer = %p in "
+				  "callchain\n", &frame->next_frame);
+	}
 #endif
 	return bp;
 }
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index dca2802..d6cc065 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -344,13 +344,6 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
 	}
 
 	/*
-	 * For kernel-addresses, either the address or symbol name can be
-	 * specified.
-	 */
-	if (info->name)
-		info->address = (unsigned long)
-				kallsyms_lookup_name(info->name);
-	/*
 	 * Check that the low-order bits of the address are appropriate
 	 * for the alignment implied by len.
 	 */
@@ -535,8 +528,3 @@ void hw_breakpoint_pmu_read(struct perf_event *bp)
 {
 	/* TODO */
 }
-
-void hw_breakpoint_pmu_unthrottle(struct perf_event *bp)
-{
-	/* TODO */
-}
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 6a58256..090cbbe 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -46,17 +46,6 @@
 
 static unsigned long reset_value[NUM_VIRT_COUNTERS];
 
-/* IbsFetchCtl bits/masks */
-#define IBS_FETCH_RAND_EN		(1ULL<<57)
-#define IBS_FETCH_VAL			(1ULL<<49)
-#define IBS_FETCH_ENABLE		(1ULL<<48)
-#define IBS_FETCH_CNT_MASK		0xFFFF0000ULL
-
-/* IbsOpCtl bits */
-#define IBS_OP_CNT_CTL			(1ULL<<19)
-#define IBS_OP_VAL			(1ULL<<18)
-#define IBS_OP_ENABLE			(1ULL<<17)
-
 #define IBS_FETCH_SIZE			6
 #define IBS_OP_SIZE			12
 
@@ -182,7 +171,7 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 			continue;
 		}
 		rdmsrl(msrs->controls[i].addr, val);
-		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
 			op_x86_warn_in_use(i);
 		val &= model->reserved;
 		wrmsrl(msrs->controls[i].addr, val);
@@ -290,7 +279,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
-			ctl &= ~(IBS_FETCH_VAL | IBS_FETCH_CNT_MASK);
+			ctl &= ~(IBS_FETCH_VAL | IBS_FETCH_CNT);
 			ctl |= IBS_FETCH_ENABLE;
 			wrmsrl(MSR_AMD64_IBSFETCHCTL, ctl);
 		}
@@ -330,7 +319,7 @@ static inline void op_amd_start_ibs(void)
 		return;
 
 	if (ibs_config.fetch_enabled) {
-		val = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
+		val = (ibs_config.max_cnt_fetch >> 4) & IBS_FETCH_MAX_CNT;
 		val |= ibs_config.rand_en ? IBS_FETCH_RAND_EN : 0;
 		val |= IBS_FETCH_ENABLE;
 		wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
@@ -352,7 +341,7 @@ static inline void op_amd_start_ibs(void)
 			 * avoid underflows.
 			 */
 			ibs_op_ctl = min(ibs_op_ctl + IBS_RANDOM_MAXCNT_OFFSET,
-					 0xFFFFULL);
+					 IBS_OP_MAX_CNT);
 		}
 		if (ibs_caps & IBS_CAPS_OPCNT && ibs_config.dispatched_ops)
 			ibs_op_ctl |= IBS_OP_CNT_CTL;
@@ -409,7 +398,7 @@ static void op_amd_start(struct op_msrs const * const msrs)
 		if (!reset_value[op_x86_phys_to_virt(i)])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
 
@@ -429,7 +418,7 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 		if (!reset_value[op_x86_phys_to_virt(i)])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
-		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
 
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 5d1727b..2bf90fa 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -88,7 +88,7 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 			continue;
 		}
 		rdmsrl(msrs->controls[i].addr, val);
-		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
 			op_x86_warn_in_use(i);
 		val &= model->reserved;
 		wrmsrl(msrs->controls[i].addr, val);
@@ -166,7 +166,7 @@ static void ppro_start(struct op_msrs const * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		if (reset_value[i]) {
 			rdmsrl(msrs->controls[i].addr, val);
-			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+			val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 			wrmsrl(msrs->controls[i].addr, val);
 		}
 	}
@@ -184,7 +184,7 @@ static void ppro_stop(struct op_msrs const * const msrs)
 		if (!reset_value[i])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
-		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
 }
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 5977b72..c70d27a 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -66,14 +66,14 @@ register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	triggered,
 				int cpu);
 
-extern struct perf_event **
+extern struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered);
 
 extern int register_perf_hw_breakpoint(struct perf_event *bp);
 extern int __register_perf_hw_breakpoint(struct perf_event *bp);
 extern void unregister_hw_breakpoint(struct perf_event *bp);
-extern void unregister_wide_hw_breakpoint(struct perf_event **cpu_events);
+extern void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events);
 
 extern int dbg_reserve_bp_slot(struct perf_event *bp);
 extern int dbg_release_bp_slot(struct perf_event *bp);
@@ -100,7 +100,7 @@ static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	 triggered,
 				int cpu)		{ return NULL; }
-static inline struct perf_event **
+static inline struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered)	{ return NULL; }
 static inline int
@@ -109,7 +109,7 @@ static inline int
 __register_perf_hw_breakpoint(struct perf_event *bp) 	{ return -ENOSYS; }
 static inline void unregister_hw_breakpoint(struct perf_event *bp)	{ }
 static inline void
-unregister_wide_hw_breakpoint(struct perf_event **cpu_events)		{ }
+unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events)	{ }
 static inline int
 reserve_bp_slot(struct perf_event *bp)			{return -ENOSYS; }
 static inline void release_bp_slot(struct perf_event *bp) 		{ }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7b18b4f..6f8cd7d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -487,9 +487,8 @@ struct hw_perf_event {
 			struct hrtimer	hrtimer;
 		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-		union { /* breakpoint */
-			struct arch_hw_breakpoint	info;
-		};
+		/* breakpoint */
+		struct arch_hw_breakpoint	info;
 #endif
 	};
 	atomic64_t			prev_count;
@@ -802,6 +801,13 @@ struct perf_sample_data {
 	struct perf_raw_record		*raw;
 };
 
+static inline
+void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
+{
+	data->addr = addr;
+	data->raw  = NULL;
+}
+
 extern void perf_output_sample(struct perf_output_handle *handle,
 			       struct perf_event_header *header,
 			       struct perf_sample_data *data,
@@ -858,6 +864,21 @@ extern int sysctl_perf_event_paranoid;
 extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
 
+static inline bool perf_paranoid_tracepoint_raw(void)
+{
+	return sysctl_perf_event_paranoid > -1;
+}
+
+static inline bool perf_paranoid_cpu(void)
+{
+	return sysctl_perf_event_paranoid > 0;
+}
+
+static inline bool perf_paranoid_kernel(void)
+{
+	return sysctl_perf_event_paranoid > 1;
+}
+
 extern void perf_event_init(void);
 extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record, int entry_size);
 extern void perf_bp_event(struct perf_event *event, void *data);
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 967e661..03808ed 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -413,17 +413,17 @@ EXPORT_SYMBOL_GPL(unregister_hw_breakpoint);
  *
  * @return a set of per_cpu pointers to perf events
  */
-struct perf_event **
+struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered)
 {
-	struct perf_event **cpu_events, **pevent, *bp;
+	struct perf_event * __percpu *cpu_events, **pevent, *bp;
 	long err;
 	int cpu;
 
 	cpu_events = alloc_percpu(typeof(*cpu_events));
 	if (!cpu_events)
-		return ERR_PTR(-ENOMEM);
+		return (void __percpu __force *)ERR_PTR(-ENOMEM);
 
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
@@ -451,7 +451,7 @@ fail:
 	put_online_cpus();
 
 	free_percpu(cpu_events);
-	return ERR_PTR(err);
+	return (void __percpu __force *)ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
 
@@ -459,7 +459,7 @@ EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
  * unregister_wide_hw_breakpoint - unregister a wide breakpoint in the kernel
  * @cpu_events: the per cpu set of events to unregister
  */
-void unregister_wide_hw_breakpoint(struct perf_event **cpu_events)
+void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events)
 {
 	int cpu;
 	struct perf_event **pevent;
@@ -489,5 +489,4 @@ struct pmu perf_ops_bp = {
 	.enable		= arch_install_hw_breakpoint,
 	.disable	= arch_uninstall_hw_breakpoint,
 	.read		= hw_breakpoint_pmu_read,
-	.unthrottle	= hw_breakpoint_pmu_unthrottle
 };
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f40560b..4393b9e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -56,21 +56,6 @@ static atomic_t nr_task_events __read_mostly;
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
-static inline bool perf_paranoid_tracepoint_raw(void)
-{
-	return sysctl_perf_event_paranoid > -1;
-}
-
-static inline bool perf_paranoid_cpu(void)
-{
-	return sysctl_perf_event_paranoid > 0;
-}
-
-static inline bool perf_paranoid_kernel(void)
-{
-	return sysctl_perf_event_paranoid > 1;
-}
-
 int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
 
 /*
@@ -4123,8 +4108,7 @@ void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 	if (rctx < 0)
 		return;
 
-	data.addr = addr;
-	data.raw  = NULL;
+	perf_sample_data_init(&data, addr);
 
 	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi, &data, regs);
 
@@ -4169,11 +4153,10 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	struct perf_event *event;
 	u64 period;
 
-	event	= container_of(hrtimer, struct perf_event, hw.hrtimer);
+	event = container_of(hrtimer, struct perf_event, hw.hrtimer);
 	event->pmu->read(event);
 
-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);
 	data.period = event->hw.last_period;
 	regs = get_irq_regs();
 	/*
@@ -4337,17 +4320,15 @@ static const struct pmu perf_ops_task_clock = {
 void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 			  int entry_size)
 {
+	struct pt_regs *regs = get_irq_regs();
+	struct perf_sample_data data;
 	struct perf_raw_record raw = {
 		.size = entry_size,
 		.data = record,
 	};
 
-	struct perf_sample_data data = {
-		.addr = addr,
-		.raw = &raw,
-	};
-
-	struct pt_regs *regs = get_irq_regs();
+	perf_sample_data_init(&data, addr);
+	data.raw = &raw;
 
 	if (!regs)
 		regs = task_pt_regs(current);
@@ -4463,8 +4444,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 	struct perf_sample_data sample;
 	struct pt_regs *regs = data;
 
-	sample.raw = NULL;
-	sample.addr = bp->attr.bp_addr;
+	perf_sample_data_init(&sample, bp->attr.bp_addr);
 
 	if (!perf_exclude_event(bp, regs))
 		perf_swevent_add(bp, 1, 1, &sample, regs);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b520ec1..8e5ec5e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -532,6 +532,14 @@ config LOCK_STAT
 
 	 For more details, see Documentation/lockstat.txt
 
+	 This also enables lock events required by "perf lock",
+	 subcommand of perf.
+	 If you want to use "perf lock", you also need to turn on
+	 CONFIG_EVENT_TRACING.
+
+	 CONFIG_LOCK_STAT defines "contended" and "acquired" lock events.
+	 (CONFIG_LOCKDEP defines "acquire" and "release" events.)
+
 config DEBUG_LOCKDEP
 	bool "Lock dependency engine debugging"
 	depends on DEBUG_KERNEL && LOCKDEP
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index c69cbe9..bd0f337 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -34,7 +34,7 @@
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
 
-struct perf_event **sample_hbp;
+struct perf_event * __percpu *sample_hbp;
 
 static char ksym_name[KSYM_NAME_LEN] = "pid_max";
 module_param_string(ksym, ksym_name, KSYM_NAME_LEN, S_IRUGO);
@@ -61,8 +61,8 @@ static int __init hw_break_module_init(void)
 	attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
 
 	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler);
-	if (IS_ERR(sample_hbp)) {
-		ret = PTR_ERR(sample_hbp);
+	if (IS_ERR((void __force *)sample_hbp)) {
+		ret = PTR_ERR((void __force *)sample_hbp);
 		goto fail;
 	}
 
diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
new file mode 100644
index 0000000..b317102
--- /dev/null
+++ b/tools/perf/Documentation/perf-lock.txt
@@ -0,0 +1,29 @@
+perf-lock(1)
+============
+
+NAME
+----
+perf-lock - Analyze lock events
+
+SYNOPSIS
+--------
+[verse]
+'perf lock' {record|report|trace}
+
+DESCRIPTION
+-----------
+You can analyze various lock behaviours
+and statistics with this 'perf lock' command.
+
+  'perf lock record <command>' records lock events
+  between start and end <command>. And this command
+  produces the file "perf.data" which contains tracing
+  results of lock events.
+
+  'perf lock trace' shows raw lock events.
+
+  'perf lock report' reports statistical data.
+
+SEE ALSO
+--------
+linkperf:perf[1]
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index fb9ab2a..e12c844 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -460,6 +460,150 @@ process_raw_event(void *data, int cpu,
 		process_lock_release_event(data, event, cpu, timestamp, thread);
 }
 
+struct raw_event_queue {
+	u64			timestamp;
+	int			cpu;
+	void			*data;
+	struct thread		*thread;
+	struct list_head	list;
+};
+
+static LIST_HEAD(raw_event_head);
+
+#define FLUSH_PERIOD	(5 * NSEC_PER_SEC)
+
+static u64 flush_limit = ULLONG_MAX;
+static u64 last_flush = 0;
+struct raw_event_queue *last_inserted;
+
+static void flush_raw_event_queue(u64 limit)
+{
+	struct raw_event_queue *tmp, *iter;
+
+	list_for_each_entry_safe(iter, tmp, &raw_event_head, list) {
+		if (iter->timestamp > limit)
+			return;
+
+		if (iter == last_inserted)
+			last_inserted = NULL;
+
+		process_raw_event(iter->data, iter->cpu, iter->timestamp,
+				  iter->thread);
+
+		last_flush = iter->timestamp;
+		list_del(&iter->list);
+		free(iter->data);
+		free(iter);
+	}
+}
+
+static void __queue_raw_event_end(struct raw_event_queue *new)
+{
+	struct raw_event_queue *iter;
+
+	list_for_each_entry_reverse(iter, &raw_event_head, list) {
+		if (iter->timestamp < new->timestamp) {
+			list_add(&new->list, &iter->list);
+			return;
+		}
+	}
+
+	list_add(&new->list, &raw_event_head);
+}
+
+static void __queue_raw_event_before(struct raw_event_queue *new,
+				     struct raw_event_queue *iter)
+{
+	list_for_each_entry_continue_reverse(iter, &raw_event_head, list) {
+		if (iter->timestamp < new->timestamp) {
+			list_add(&new->list, &iter->list);
+			return;
+		}
+	}
+
+	list_add(&new->list, &raw_event_head);
+}
+
+static void __queue_raw_event_after(struct raw_event_queue *new,
+				     struct raw_event_queue *iter)
+{
+	list_for_each_entry_continue(iter, &raw_event_head, list) {
+		if (iter->timestamp > new->timestamp) {
+			list_add_tail(&new->list, &iter->list);
+			return;
+		}
+	}
+	list_add_tail(&new->list, &raw_event_head);
+}
+
+/* The queue is ordered by time */
+static void __queue_raw_event(struct raw_event_queue *new)
+{
+	if (!last_inserted) {
+		__queue_raw_event_end(new);
+		return;
+	}
+
+	/*
+	 * Most of the time the current event has a timestamp
+	 * very close to the last event inserted, unless we just switched
+	 * to another event buffer. Having a sorting based on a list and
+	 * on the last inserted event that is close to the current one is
+	 * probably more efficient than an rbtree based sorting.
+	 */
+	if (last_inserted->timestamp >= new->timestamp)
+		__queue_raw_event_before(new, last_inserted);
+	else
+		__queue_raw_event_after(new, last_inserted);
+}
+
+static void queue_raw_event(void *data, int raw_size, int cpu,
+			    u64 timestamp, struct thread *thread)
+{
+	struct raw_event_queue *new;
+
+	if (flush_limit == ULLONG_MAX)
+		flush_limit = timestamp + FLUSH_PERIOD;
+
+	if (timestamp < last_flush) {
+		printf("Warning: Timestamp below last timeslice flush\n");
+		return;
+	}
+
+	new = malloc(sizeof(*new));
+	if (!new)
+		die("Not enough memory\n");
+
+	new->timestamp = timestamp;
+	new->cpu = cpu;
+	new->thread = thread;
+
+	new->data = malloc(raw_size);
+	if (!new->data)
+		die("Not enough memory\n");
+
+	memcpy(new->data, data, raw_size);
+
+	__queue_raw_event(new);
+	last_inserted = new;
+
+	/*
+	 * We want to have a slice of events covering 2 * FLUSH_PERIOD
+	 * If FLUSH_PERIOD is big enough, it ensures every events that occured
+	 * in the first half of the timeslice have all been buffered and there
+	 * are none remaining (we need that because of the weakly ordered
+	 * event recording we have). Then once we reach the 2 * FLUSH_PERIOD
+	 * timeslice, we flush the first half to be gentle with the memory
+	 * (the second half can still get new events in the middle, so wait
+	 * another period to flush it)
+	 */
+	if (new->timestamp > flush_limit &&
+		new->timestamp - flush_limit > FLUSH_PERIOD) {
+		flush_limit += FLUSH_PERIOD;
+		flush_raw_event_queue(flush_limit);
+	}
+}
+
 static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct thread *thread;
@@ -480,7 +624,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	if (profile_cpu != -1 && profile_cpu != (int) data.cpu)
 		return 0;
 
-	process_raw_event(data.raw_data, data.cpu, data.time, thread);
+	queue_raw_event(data.raw_data, data.raw_size, data.cpu, data.time, thread);
 
 	return 0;
 }
@@ -576,6 +720,7 @@ static void __cmd_report(void)
 	setup_pager();
 	select_key();
 	read_events();
+	flush_raw_event_queue(ULLONG_MAX);
 	sort_result();
 	print_result();
 }
@@ -608,7 +753,6 @@ static const char *record_args[] = {
 	"record",
 	"-a",
 	"-R",
-	"-M",
 	"-f",
 	"-m", "1024",
 	"-c", "1",
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5db687f..407041d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -573,7 +573,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 
 	if (symbol__init() < 0)
 		return -1;
-	setup_pager();
+	if (!script_name)
+		setup_pager();
 
 	session = perf_session__new(input_name, O_RDONLY, 0);
 	if (session == NULL)
@@ -608,7 +609,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			return -1;
 		}
 
-		perf_header__read(&session->header, input);
 		err = scripting_ops->generate_script("perf-trace");
 		goto out;
 	}
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 9afcff2..db6ee94 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -18,3 +18,4 @@ perf-top			mainporcelain common
 perf-trace			mainporcelain common
 perf-probe			mainporcelain common
 perf-kmem			mainporcelain common
+perf-lock			mainporcelain common
diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
index 45fbe2f..910468e 100644
--- a/tools/perf/perf-archive.sh
+++ b/tools/perf/perf-archive.sh
@@ -9,8 +9,9 @@ fi
 
 DEBUGDIR=~/.debug/
 BUILDIDS=$(mktemp /tmp/perf-archive-buildids.XXXXXX)
+NOBUILDID=0000000000000000000000000000000000000000
 
-perf buildid-list -i $PERF_DATA --with-hits > $BUILDIDS
+perf buildid-list -i $PERF_DATA --with-hits | grep -v "^$NOBUILDID " > $BUILDIDS
 if [ ! -s $BUILDIDS ] ; then
 	echo "perf archive: no build-ids found"
 	rm -f $BUILDIDS
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 75f941b..6fb379b 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -65,9 +65,7 @@
  * Use the __kuser_memory_barrier helper in the CPU helper page. See
  * arch/arm/kernel/entry-armv.S in the kernel source for details.
  */
-#define rmb()		asm volatile("mov r0, #0xffff0fff; mov lr, pc;" \
-				     "sub pc, r0, #95" ::: "r0", "lr", "cc", \
-				     "memory")
+#define rmb()		((void(*)(void))0xffff0fa0)()
 #define cpu_relax()	asm volatile("":::"memory")
 #endif
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index c971e81..53181db 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -508,8 +508,8 @@ void show_perf_probe_events(void)
 	struct str_node *ent;
 
 	setup_pager();
-
 	memset(&pp, 0, sizeof(pp));
+
 	fd = open_kprobe_events(O_RDONLY, 0);
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 	close(fd);

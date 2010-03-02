Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0CBObu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:31:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:43185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab0CBObs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:31:48 -0500
Date: Tue, 2 Mar 2010 14:31:06 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events, x86: Fixup fixed counter constraints
Message-ID: <tip-b622d644c7d61a5cb95b74e7b143c263bed21f0a@git.kernel.org>
Git-Commit-ID: b622d644c7d61a5cb95b74e7b143c263bed21f0a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 14:31:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b622d644c7d61a5cb95b74e7b143c263bed21f0a
Gitweb:     http://git.kernel.org/tip/b622d644c7d61a5cb95b74e7b143c263bed21f0a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 1 Feb 2010 15:36:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Mar 2010 15:06:47 +0100

perf_events, x86: Fixup fixed counter constraints

Patch 1da53e0230 ("perf_events, x86: Improve x86 event scheduling")
lost us one of the fixed purpose counters and then ed8777fc13
("perf_events, x86: Fix event constraint masks") broke it even
further.

Widen the fixed event mask to event+umask and specify the full config
for each of the 3 fixed purpose counters. Then let the init code fill
out the placement for the GP regs based on the cpuid info.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event.h      |    2 +-
 arch/x86/kernel/cpu/perf_event.c       |   25 ++++++++++++++++++-------
 arch/x86/kernel/cpu/perf_event_intel.c |   31 +++++++++++++++++++++----------
 3 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 80e6936..db6109a 100644
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
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index aab2e1c..bfc43fa 100644
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
@@ -615,8 +615,8 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 
 	for (i = 0; i < n; i++) {
-		constraints[i] =
-		  x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
+		c = x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
+		constraints[i] = c;
 	}
 
 	/*
@@ -1350,6 +1350,7 @@ static void __init pmu_check_apic(void)
 
 void __init init_hw_perf_events(void)
 {
+	struct event_constraint *c;
 	int err;
 
 	pr_info("Performance Events: ");
@@ -1398,6 +1399,16 @@ void __init init_hw_perf_events(void)
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
index cf6590c..4fbdfe5 100644
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
 
@@ -935,7 +945,7 @@ static __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_nehalem_event_constraints;
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
-	case 28:
+	case 28: /* Atom */
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -951,6 +961,7 @@ static __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_westmere_event_constraints;
 		pr_cont("Westmere events, ");
 		break;
+
 	default:
 		/*
 		 * default constraints for v2 and up

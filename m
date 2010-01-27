Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219Ab0A0WOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0A0WOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165Ab0A0WOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:14:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40926 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab0A0WOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:14:07 -0500
Message-Id: <20100127221122.151865645@chello.nl>
References: <20100127220745.027096123@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 27 Jan 2010 23:07:48 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] perf_events: x86: Implement westmere support
Content-Disposition: inline; filename=perf-westmere.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new Intel documentation includes Westmere arch specific event
maps that are significantly different from the Nehalem ones. Add
support for this generation.

Found the CPUID model numbers on wikipedia.

Also ammend some Nehalem constraints, spotted those when looking for
the differences between Nehalem and Westmere.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c |  124 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 117 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -244,18 +244,26 @@ static struct event_constraint intel_cor
 
 static struct event_constraint intel_nehalem_event_constraints[] =
 {
-	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
-	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0xc0, (0xf|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0x3c, (0xf|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
 	INTEL_EVENT_CONSTRAINT(0x40, 0x3), /* L1D_CACHE_LD */
 	INTEL_EVENT_CONSTRAINT(0x41, 0x3), /* L1D_CACHE_ST */
 	INTEL_EVENT_CONSTRAINT(0x42, 0x3), /* L1D_CACHE_LOCK */
 	INTEL_EVENT_CONSTRAINT(0x43, 0x3), /* L1D_ALL_REF */
+	INTEL_EVENT_CONSTRAINT(0x48, 0x3), /* L1D_PEND_MISS */
 	INTEL_EVENT_CONSTRAINT(0x4e, 0x3), /* L1D_PREFETCH */
-	INTEL_EVENT_CONSTRAINT(0x4c, 0x3), /* LOAD_HIT_PRE */
 	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
-	INTEL_EVENT_CONSTRAINT(0x52, 0x3), /* L1D_CACHE_PREFETCH_LOCK_FB_HIT */
-	INTEL_EVENT_CONSTRAINT(0x53, 0x3), /* L1D_CACHE_LOCK_FB_HIT */
-	INTEL_EVENT_CONSTRAINT(0xc5, 0x3), /* CACHE_LOCK_CYCLES */
+	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
+	EVENT_CONSTRAINT_END
+};
+
+static struct event_constraint intel_westmere_event_constraints[] =
+{
+	FIXED_EVENT_CONSTRAINT(0xc0, (0xf|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0x3c, (0xf|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
+	INTEL_EVENT_CONSTRAINT(0x60, 0x1), /* OFFCORE_REQUESTS_OUTSTANDING */
+	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
 	EVENT_CONSTRAINT_END
 };
 
@@ -286,6 +294,97 @@ static u64 __read_mostly hw_cache_event_
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
+static __initconst u64 westmere_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x010b, /* MEM_INST_RETIRED.LOADS       */
+		[ C(RESULT_MISS)   ] = 0x0151, /* L1D.REPL                     */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x020b, /* MEM_INST_RETURED.STORES      */
+		[ C(RESULT_MISS)   ] = 0x0251, /* L1D.M_REPL                   */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x014e, /* L1D_PREFETCH.REQUESTS        */
+		[ C(RESULT_MISS)   ] = 0x024e, /* L1D_PREFETCH.MISS            */
+	},
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0380, /* L1I.READS                    */
+		[ C(RESULT_MISS)   ] = 0x0280, /* L1I.MISSES                   */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0324, /* L2_RQSTS.LOADS               */
+		[ C(RESULT_MISS)   ] = 0x0224, /* L2_RQSTS.LD_MISS             */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0c24, /* L2_RQSTS.RFOS                */
+		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS            */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x4f2e, /* LLC Reference                */
+		[ C(RESULT_MISS)   ] = 0x412e, /* LLC Misses                   */
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x010b, /* MEM_INST_RETIRED.LOADS       */
+		[ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.ANY         */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x020b, /* MEM_INST_RETURED.STORES      */
+		[ C(RESULT_MISS)   ] = 0x010c, /* MEM_STORE_RETIRED.DTLB_MISS  */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01c0, /* INST_RETIRED.ANY_P           */
+		[ C(RESULT_MISS)   ] = 0x0185, /* ITLB_MISSES.ANY              */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+ [ C(BPU ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ALL_BRANCHES */
+		[ C(RESULT_MISS)   ] = 0x03e8, /* BPU_CLEARS.ANY               */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+};
+
 static __initconst u64 nehalem_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -2430,7 +2529,9 @@ static __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_core_event_constraints;
 		pr_cont("Core2 events, ");
 		break;
-	case 26:
+
+	case 26: /* 45 nm nehalem, "Bloomfield" */
+	case 30: /* 45 nm nehalem, "Lynnfield" */
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -2444,6 +2545,15 @@ static __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_gen_event_constraints;
 		pr_cont("Atom events, ");
 		break;
+
+	case 37: /* 32 nm nehalem, "Clarkdale" */
+	case 44: /* 32 nm nehalem, "Gulftown" */
+		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+
+		x86_pmu.event_constraints = intel_westmere_event_constraints;
+		pr_cont("Westmere events, ");
+		break;
 	default:
 		/*
 		 * default constraints for v2 and up

-- 


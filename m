Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958Ab0BZOzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 09:55:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:46275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964913Ab0BZOzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 09:55:46 -0500
Date: Fri, 26 Feb 2010 14:54:50 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events, x86: Split PMU definitions into separate files
Message-ID: <tip-f22f54f4491acd987a6c5a92de52b60ca8b58b61@git.kernel.org>
Git-Commit-ID: f22f54f4491acd987a6c5a92de52b60ca8b58b61
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 14:54:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f22f54f4491acd987a6c5a92de52b60ca8b58b61
Gitweb:     http://git.kernel.org/tip/f22f54f4491acd987a6c5a92de52b60ca8b58b61
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 26 Feb 2010 12:05:05 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Feb 2010 15:44:04 +0100

perf_events, x86: Split PMU definitions into separate files

Split amd,p6,intel into separate files so that we can easily deal with
CONFIG_CPU_SUP_* things, needed to make things build now that perf_event.c
relies on symbols from amd.c

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       | 1524 +-------------------------------
 arch/x86/kernel/cpu/perf_event_amd.c   |  416 +++++++++
 arch/x86/kernel/cpu/perf_event_intel.c |  971 ++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_p6.c    |  157 ++++
 4 files changed, 1554 insertions(+), 1514 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index dd09ccc..641ccb9 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -161,8 +161,6 @@ struct x86_pmu {
 
 static struct x86_pmu x86_pmu __read_mostly;
 
-static raw_spinlock_t amd_nb_lock;
-
 static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
@@ -171,140 +169,6 @@ static int x86_perf_event_set_period(struct perf_event *event,
 			     struct hw_perf_event *hwc, int idx);
 
 /*
- * Not sure about some of these
- */
-static const u64 p6_perfmon_event_map[] =
-{
-  [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,
-  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0f2e,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x012e,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
-  [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,
-};
-
-static u64 p6_pmu_event_map(int hw_event)
-{
-	return p6_perfmon_event_map[hw_event];
-}
-
-/*
- * Event setting that is specified not to count anything.
- * We use this to effectively disable a counter.
- *
- * L2_RQSTS with 0 MESI unit mask.
- */
-#define P6_NOP_EVENT			0x0000002EULL
-
-static u64 p6_pmu_raw_event(u64 hw_event)
-{
-#define P6_EVNTSEL_EVENT_MASK		0x000000FFULL
-#define P6_EVNTSEL_UNIT_MASK		0x0000FF00ULL
-#define P6_EVNTSEL_EDGE_MASK		0x00040000ULL
-#define P6_EVNTSEL_INV_MASK		0x00800000ULL
-#define P6_EVNTSEL_REG_MASK		0xFF000000ULL
-
-#define P6_EVNTSEL_MASK			\
-	(P6_EVNTSEL_EVENT_MASK |	\
-	 P6_EVNTSEL_UNIT_MASK  |	\
-	 P6_EVNTSEL_EDGE_MASK  |	\
-	 P6_EVNTSEL_INV_MASK   |	\
-	 P6_EVNTSEL_REG_MASK)
-
-	return hw_event & P6_EVNTSEL_MASK;
-}
-
-static struct event_constraint intel_p6_event_constraints[] =
-{
-	INTEL_EVENT_CONSTRAINT(0xc1, 0x1),	/* FLOPS */
-	INTEL_EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
-	INTEL_EVENT_CONSTRAINT(0x11, 0x1),	/* FP_ASSIST */
-	INTEL_EVENT_CONSTRAINT(0x12, 0x2),	/* MUL */
-	INTEL_EVENT_CONSTRAINT(0x13, 0x2),	/* DIV */
-	INTEL_EVENT_CONSTRAINT(0x14, 0x1),	/* CYCLES_DIV_BUSY */
-	EVENT_CONSTRAINT_END
-};
-
-/*
- * Intel PerfMon v3. Used on Core2 and later.
- */
-static const u64 intel_perfmon_event_map[] =
-{
-  [PERF_COUNT_HW_CPU_CYCLES]		= 0x003c,
-  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x4f2e,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x412e,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
-  [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
-};
-
-static struct event_constraint intel_core_event_constraints[] =
-{
-	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
-	INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
-	INTEL_EVENT_CONSTRAINT(0x13, 0x2), /* DIV */
-	INTEL_EVENT_CONSTRAINT(0x14, 0x1), /* CYCLES_DIV_BUSY */
-	INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
-	INTEL_EVENT_CONSTRAINT(0xc1, 0x1), /* FP_COMP_INSTR_RET */
-	EVENT_CONSTRAINT_END
-};
-
-static struct event_constraint intel_core2_event_constraints[] =
-{
-	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
-	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
-	INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
-	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
-	INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
-	INTEL_EVENT_CONSTRAINT(0x13, 0x2), /* DIV */
-	INTEL_EVENT_CONSTRAINT(0x14, 0x1), /* CYCLES_DIV_BUSY */
-	INTEL_EVENT_CONSTRAINT(0x18, 0x1), /* IDLE_DURING_DIV */
-	INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
-	INTEL_EVENT_CONSTRAINT(0xa1, 0x1), /* RS_UOPS_DISPATCH_CYCLES */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0x1), /* MEM_LOAD_RETIRED */
-	EVENT_CONSTRAINT_END
-};
-
-static struct event_constraint intel_nehalem_event_constraints[] =
-{
-	FIXED_EVENT_CONSTRAINT(0xc0, (0xf|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
-	FIXED_EVENT_CONSTRAINT(0x3c, (0xf|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
-	INTEL_EVENT_CONSTRAINT(0x40, 0x3), /* L1D_CACHE_LD */
-	INTEL_EVENT_CONSTRAINT(0x41, 0x3), /* L1D_CACHE_ST */
-	INTEL_EVENT_CONSTRAINT(0x42, 0x3), /* L1D_CACHE_LOCK */
-	INTEL_EVENT_CONSTRAINT(0x43, 0x3), /* L1D_ALL_REF */
-	INTEL_EVENT_CONSTRAINT(0x48, 0x3), /* L1D_PEND_MISS */
-	INTEL_EVENT_CONSTRAINT(0x4e, 0x3), /* L1D_PREFETCH */
-	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
-	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
-	EVENT_CONSTRAINT_END
-};
-
-static struct event_constraint intel_westmere_event_constraints[] =
-{
-	FIXED_EVENT_CONSTRAINT(0xc0, (0xf|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
-	FIXED_EVENT_CONSTRAINT(0x3c, (0xf|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
-	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
-	INTEL_EVENT_CONSTRAINT(0x60, 0x1), /* OFFCORE_REQUESTS_OUTSTANDING */
-	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
-	EVENT_CONSTRAINT_END
-};
-
-static struct event_constraint intel_gen_event_constraints[] =
-{
-	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
-	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
-	EVENT_CONSTRAINT_END
-};
-
-static u64 intel_pmu_event_map(int hw_event)
-{
-	return intel_perfmon_event_map[hw_event];
-}
-
-/*
  * Generalized hw caching related hw_event table, filled
  * in on a per model basis. A value of 0 means
  * 'not supported', -1 means 'hw_event makes no sense on
@@ -319,515 +183,6 @@ static u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
-static __initconst u64 westmere_hw_cache_event_ids
-				[PERF_COUNT_HW_CACHE_MAX]
-				[PERF_COUNT_HW_CACHE_OP_MAX]
-				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
-{
- [ C(L1D) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x010b, /* MEM_INST_RETIRED.LOADS       */
-		[ C(RESULT_MISS)   ] = 0x0151, /* L1D.REPL                     */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x020b, /* MEM_INST_RETURED.STORES      */
-		[ C(RESULT_MISS)   ] = 0x0251, /* L1D.M_REPL                   */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x014e, /* L1D_PREFETCH.REQUESTS        */
-		[ C(RESULT_MISS)   ] = 0x024e, /* L1D_PREFETCH.MISS            */
-	},
- },
- [ C(L1I ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0380, /* L1I.READS                    */
-		[ C(RESULT_MISS)   ] = 0x0280, /* L1I.MISSES                   */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
- },
- [ C(LL  ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0324, /* L2_RQSTS.LOADS               */
-		[ C(RESULT_MISS)   ] = 0x0224, /* L2_RQSTS.LD_MISS             */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0c24, /* L2_RQSTS.RFOS                */
-		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS            */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f2e, /* LLC Reference                */
-		[ C(RESULT_MISS)   ] = 0x412e, /* LLC Misses                   */
-	},
- },
- [ C(DTLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x010b, /* MEM_INST_RETIRED.LOADS       */
-		[ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.ANY         */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x020b, /* MEM_INST_RETURED.STORES      */
-		[ C(RESULT_MISS)   ] = 0x010c, /* MEM_STORE_RETIRED.DTLB_MISS  */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
- },
- [ C(ITLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x01c0, /* INST_RETIRED.ANY_P           */
-		[ C(RESULT_MISS)   ] = 0x0185, /* ITLB_MISSES.ANY              */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
- [ C(BPU ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ALL_BRANCHES */
-		[ C(RESULT_MISS)   ] = 0x03e8, /* BPU_CLEARS.ANY               */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
-};
-
-static __initconst u64 nehalem_hw_cache_event_ids
-				[PERF_COUNT_HW_CACHE_MAX]
-				[PERF_COUNT_HW_CACHE_OP_MAX]
-				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
-{
- [ C(L1D) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI            */
-		[ C(RESULT_MISS)   ] = 0x0140, /* L1D_CACHE_LD.I_STATE         */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI            */
-		[ C(RESULT_MISS)   ] = 0x0141, /* L1D_CACHE_ST.I_STATE         */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x014e, /* L1D_PREFETCH.REQUESTS        */
-		[ C(RESULT_MISS)   ] = 0x024e, /* L1D_PREFETCH.MISS            */
-	},
- },
- [ C(L1I ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0380, /* L1I.READS                    */
-		[ C(RESULT_MISS)   ] = 0x0280, /* L1I.MISSES                   */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
- },
- [ C(LL  ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0324, /* L2_RQSTS.LOADS               */
-		[ C(RESULT_MISS)   ] = 0x0224, /* L2_RQSTS.LD_MISS             */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0c24, /* L2_RQSTS.RFOS                */
-		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS            */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f2e, /* LLC Reference                */
-		[ C(RESULT_MISS)   ] = 0x412e, /* LLC Misses                   */
-	},
- },
- [ C(DTLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI   (alias)  */
-		[ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.ANY         */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI   (alias)  */
-		[ C(RESULT_MISS)   ] = 0x010c, /* MEM_STORE_RETIRED.DTLB_MISS  */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
- },
- [ C(ITLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x01c0, /* INST_RETIRED.ANY_P           */
-		[ C(RESULT_MISS)   ] = 0x20c8, /* ITLB_MISS_RETIRED            */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
- [ C(BPU ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ALL_BRANCHES */
-		[ C(RESULT_MISS)   ] = 0x03e8, /* BPU_CLEARS.ANY               */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
-};
-
-static __initconst u64 core2_hw_cache_event_ids
-				[PERF_COUNT_HW_CACHE_MAX]
-				[PERF_COUNT_HW_CACHE_OP_MAX]
-				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
-{
- [ C(L1D) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI          */
-		[ C(RESULT_MISS)   ] = 0x0140, /* L1D_CACHE_LD.I_STATE       */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI          */
-		[ C(RESULT_MISS)   ] = 0x0141, /* L1D_CACHE_ST.I_STATE       */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x104e, /* L1D_PREFETCH.REQUESTS      */
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(L1I ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0080, /* L1I.READS                  */
-		[ C(RESULT_MISS)   ] = 0x0081, /* L1I.MISSES                 */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(LL  ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f29, /* L2_LD.MESI                 */
-		[ C(RESULT_MISS)   ] = 0x4129, /* L2_LD.ISTATE               */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f2A, /* L2_ST.MESI                 */
-		[ C(RESULT_MISS)   ] = 0x412A, /* L2_ST.ISTATE               */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(DTLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI  (alias) */
-		[ C(RESULT_MISS)   ] = 0x0208, /* DTLB_MISSES.MISS_LD        */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI  (alias) */
-		[ C(RESULT_MISS)   ] = 0x0808, /* DTLB_MISSES.MISS_ST        */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(ITLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c0, /* INST_RETIRED.ANY_P         */
-		[ C(RESULT_MISS)   ] = 0x1282, /* ITLBMISSES                 */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
- [ C(BPU ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ANY        */
-		[ C(RESULT_MISS)   ] = 0x00c5, /* BP_INST_RETIRED.MISPRED    */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
-};
-
-static __initconst u64 atom_hw_cache_event_ids
-				[PERF_COUNT_HW_CACHE_MAX]
-				[PERF_COUNT_HW_CACHE_OP_MAX]
-				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
-{
- [ C(L1D) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x2140, /* L1D_CACHE.LD               */
-		[ C(RESULT_MISS)   ] = 0,
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x2240, /* L1D_CACHE.ST               */
-		[ C(RESULT_MISS)   ] = 0,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(L1I ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0380, /* L1I.READS                  */
-		[ C(RESULT_MISS)   ] = 0x0280, /* L1I.MISSES                 */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(LL  ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f29, /* L2_LD.MESI                 */
-		[ C(RESULT_MISS)   ] = 0x4129, /* L2_LD.ISTATE               */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f2A, /* L2_ST.MESI                 */
-		[ C(RESULT_MISS)   ] = 0x412A, /* L2_ST.ISTATE               */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(DTLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x2140, /* L1D_CACHE_LD.MESI  (alias) */
-		[ C(RESULT_MISS)   ] = 0x0508, /* DTLB_MISSES.MISS_LD        */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x2240, /* L1D_CACHE_ST.MESI  (alias) */
-		[ C(RESULT_MISS)   ] = 0x0608, /* DTLB_MISSES.MISS_ST        */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(ITLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c0, /* INST_RETIRED.ANY_P         */
-		[ C(RESULT_MISS)   ] = 0x0282, /* ITLB.MISSES                */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
- [ C(BPU ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ANY        */
-		[ C(RESULT_MISS)   ] = 0x00c5, /* BP_INST_RETIRED.MISPRED    */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
-};
-
-static u64 intel_pmu_raw_event(u64 hw_event)
-{
-#define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
-#define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
-#define CORE_EVNTSEL_EDGE_MASK		0x00040000ULL
-#define CORE_EVNTSEL_INV_MASK		0x00800000ULL
-#define CORE_EVNTSEL_REG_MASK		0xFF000000ULL
-
-#define CORE_EVNTSEL_MASK		\
-	(INTEL_ARCH_EVTSEL_MASK |	\
-	 INTEL_ARCH_UNIT_MASK   |	\
-	 INTEL_ARCH_EDGE_MASK   |	\
-	 INTEL_ARCH_INV_MASK    |	\
-	 INTEL_ARCH_CNT_MASK)
-
-	return hw_event & CORE_EVNTSEL_MASK;
-}
-
-static __initconst u64 amd_hw_cache_event_ids
-				[PERF_COUNT_HW_CACHE_MAX]
-				[PERF_COUNT_HW_CACHE_OP_MAX]
-				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
-{
- [ C(L1D) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
-		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0142, /* Data Cache Refills :system */
-		[ C(RESULT_MISS)   ] = 0,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0267, /* Data Prefetcher :attempts  */
-		[ C(RESULT_MISS)   ] = 0x0167, /* Data Prefetcher :cancelled */
-	},
- },
- [ C(L1I ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction cache fetches  */
-		[ C(RESULT_MISS)   ] = 0x0081, /* Instruction cache misses   */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x014B, /* Prefetch Instructions :Load */
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(LL  ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x037D, /* Requests to L2 Cache :IC+DC */
-		[ C(RESULT_MISS)   ] = 0x037E, /* L2 Cache Misses : IC+DC     */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x017F, /* L2 Fill/Writeback           */
-		[ C(RESULT_MISS)   ] = 0,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(DTLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
-		[ C(RESULT_MISS)   ] = 0x0046, /* L1 DTLB and L2 DLTB Miss   */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(ITLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction fecthes        */
-		[ C(RESULT_MISS)   ] = 0x0085, /* Instr. fetch ITLB misses   */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
- [ C(BPU ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c2, /* Retired Branch Instr.      */
-		[ C(RESULT_MISS)   ] = 0x00c3, /* Retired Mispredicted BI    */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
-};
-
-/*
- * AMD Performance Monitor K7 and later.
- */
-static const u64 amd_perfmon_event_map[] =
-{
-  [PERF_COUNT_HW_CPU_CYCLES]		= 0x0076,
-  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0080,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0081,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
-};
-
-static u64 amd_pmu_event_map(int hw_event)
-{
-	return amd_perfmon_event_map[hw_event];
-}
-
-static u64 amd_pmu_raw_event(u64 hw_event)
-{
-#define K7_EVNTSEL_EVENT_MASK	0xF000000FFULL
-#define K7_EVNTSEL_UNIT_MASK	0x00000FF00ULL
-#define K7_EVNTSEL_EDGE_MASK	0x000040000ULL
-#define K7_EVNTSEL_INV_MASK	0x000800000ULL
-#define K7_EVNTSEL_REG_MASK	0x0FF000000ULL
-
-#define K7_EVNTSEL_MASK			\
-	(K7_EVNTSEL_EVENT_MASK |	\
-	 K7_EVNTSEL_UNIT_MASK  |	\
-	 K7_EVNTSEL_EDGE_MASK  |	\
-	 K7_EVNTSEL_INV_MASK   |	\
-	 K7_EVNTSEL_REG_MASK)
-
-	return hw_event & K7_EVNTSEL_MASK;
-}
-
 /*
  * Propagate event elapsed time into the generic event.
  * Can only be executed on the CPU where the event is active.
@@ -1079,42 +434,6 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event_attr *attr)
 	return 0;
 }
 
-static void intel_pmu_enable_bts(u64 config)
-{
-	unsigned long debugctlmsr;
-
-	debugctlmsr = get_debugctlmsr();
-
-	debugctlmsr |= X86_DEBUGCTL_TR;
-	debugctlmsr |= X86_DEBUGCTL_BTS;
-	debugctlmsr |= X86_DEBUGCTL_BTINT;
-
-	if (!(config & ARCH_PERFMON_EVENTSEL_OS))
-		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_OS;
-
-	if (!(config & ARCH_PERFMON_EVENTSEL_USR))
-		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_USR;
-
-	update_debugctlmsr(debugctlmsr);
-}
-
-static void intel_pmu_disable_bts(void)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	unsigned long debugctlmsr;
-
-	if (!cpuc->ds)
-		return;
-
-	debugctlmsr = get_debugctlmsr();
-
-	debugctlmsr &=
-		~(X86_DEBUGCTL_TR | X86_DEBUGCTL_BTS | X86_DEBUGCTL_BTINT |
-		  X86_DEBUGCTL_BTS_OFF_OS | X86_DEBUGCTL_BTS_OFF_USR);
-
-	update_debugctlmsr(debugctlmsr);
-}
-
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -1223,26 +542,6 @@ static int __hw_perf_event_init(struct perf_event *event)
 	return 0;
 }
 
-static void p6_pmu_disable_all(void)
-{
-	u64 val;
-
-	/* p6 only has one enable register */
-	rdmsrl(MSR_P6_EVNTSEL0, val);
-	val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
-	wrmsrl(MSR_P6_EVNTSEL0, val);
-}
-
-static void intel_pmu_disable_all(void)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
-
-	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask))
-		intel_pmu_disable_bts();
-}
-
 static void x86_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1278,33 +577,6 @@ void hw_perf_disable(void)
 	x86_pmu.disable_all();
 }
 
-static void p6_pmu_enable_all(void)
-{
-	unsigned long val;
-
-	/* p6 only has one enable register */
-	rdmsrl(MSR_P6_EVNTSEL0, val);
-	val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-	wrmsrl(MSR_P6_EVNTSEL0, val);
-}
-
-static void intel_pmu_enable_all(void)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
-
-	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
-		struct perf_event *event =
-			cpuc->events[X86_PMC_IDX_FIXED_BTS];
-
-		if (WARN_ON_ONCE(!event))
-			return;
-
-		intel_pmu_enable_bts(event->hw.config);
-	}
-}
-
 static void x86_pmu_enable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1578,20 +850,6 @@ void hw_perf_enable(void)
 	x86_pmu.enable_all();
 }
 
-static inline u64 intel_pmu_get_status(void)
-{
-	u64 status;
-
-	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
-
-	return status;
-}
-
-static inline void intel_pmu_ack_status(u64 ack)
-{
-	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
-}
-
 static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 {
 	(void)checking_wrmsrl(hwc->config_base + idx,
@@ -1603,47 +861,6 @@ static inline void x86_pmu_disable_event(struct hw_perf_event *hwc, int idx)
 	(void)checking_wrmsrl(hwc->config_base + idx, hwc->config);
 }
 
-static inline void
-intel_pmu_disable_fixed(struct hw_perf_event *hwc, int __idx)
-{
-	int idx = __idx - X86_PMC_IDX_FIXED;
-	u64 ctrl_val, mask;
-
-	mask = 0xfULL << (idx * 4);
-
-	rdmsrl(hwc->config_base, ctrl_val);
-	ctrl_val &= ~mask;
-	(void)checking_wrmsrl(hwc->config_base, ctrl_val);
-}
-
-static inline void
-p6_pmu_disable_event(struct hw_perf_event *hwc, int idx)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	u64 val = P6_NOP_EVENT;
-
-	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-
-	(void)checking_wrmsrl(hwc->config_base + idx, val);
-}
-
-static inline void
-intel_pmu_disable_event(struct hw_perf_event *hwc, int idx)
-{
-	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
-		intel_pmu_disable_bts();
-		return;
-	}
-
-	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
-		intel_pmu_disable_fixed(hwc, idx);
-		return;
-	}
-
-	x86_pmu_disable_event(hwc, idx);
-}
-
 static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
 
 /*
@@ -1702,70 +919,6 @@ x86_perf_event_set_period(struct perf_event *event,
 	return ret;
 }
 
-static inline void
-intel_pmu_enable_fixed(struct hw_perf_event *hwc, int __idx)
-{
-	int idx = __idx - X86_PMC_IDX_FIXED;
-	u64 ctrl_val, bits, mask;
-	int err;
-
-	/*
-	 * Enable IRQ generation (0x8),
-	 * and enable ring-3 counting (0x2) and ring-0 counting (0x1)
-	 * if requested:
-	 */
-	bits = 0x8ULL;
-	if (hwc->config & ARCH_PERFMON_EVENTSEL_USR)
-		bits |= 0x2;
-	if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
-		bits |= 0x1;
-
-	/*
-	 * ANY bit is supported in v3 and up
-	 */
-	if (x86_pmu.version > 2 && hwc->config & ARCH_PERFMON_EVENTSEL_ANY)
-		bits |= 0x4;
-
-	bits <<= (idx * 4);
-	mask = 0xfULL << (idx * 4);
-
-	rdmsrl(hwc->config_base, ctrl_val);
-	ctrl_val &= ~mask;
-	ctrl_val |= bits;
-	err = checking_wrmsrl(hwc->config_base, ctrl_val);
-}
-
-static void p6_pmu_enable_event(struct hw_perf_event *hwc, int idx)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	u64 val;
-
-	val = hwc->config;
-	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-
-	(void)checking_wrmsrl(hwc->config_base + idx, val);
-}
-
-
-static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
-{
-	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
-		if (!__get_cpu_var(cpu_hw_events).enabled)
-			return;
-
-		intel_pmu_enable_bts(hwc->config);
-		return;
-	}
-
-	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
-		intel_pmu_enable_fixed(hwc, idx);
-		return;
-	}
-
-	__x86_pmu_enable_event(hwc, idx);
-}
-
 static void x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1887,66 +1040,6 @@ void perf_event_print_debug(void)
 	local_irq_restore(flags);
 }
 
-static void intel_pmu_drain_bts_buffer(struct cpu_hw_events *cpuc)
-{
-	struct debug_store *ds = cpuc->ds;
-	struct bts_record {
-		u64	from;
-		u64	to;
-		u64	flags;
-	};
-	struct perf_event *event = cpuc->events[X86_PMC_IDX_FIXED_BTS];
-	struct bts_record *at, *top;
-	struct perf_output_handle handle;
-	struct perf_event_header header;
-	struct perf_sample_data data;
-	struct pt_regs regs;
-
-	if (!event)
-		return;
-
-	if (!ds)
-		return;
-
-	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
-	top = (struct bts_record *)(unsigned long)ds->bts_index;
-
-	if (top <= at)
-		return;
-
-	ds->bts_index = ds->bts_buffer_base;
-
-
-	data.period	= event->hw.last_period;
-	data.addr	= 0;
-	data.raw	= NULL;
-	regs.ip		= 0;
-
-	/*
-	 * Prepare a generic sample, i.e. fill in the invariant fields.
-	 * We will overwrite the from and to address before we output
-	 * the sample.
-	 */
-	perf_prepare_sample(&header, &data, event, &regs);
-
-	if (perf_output_begin(&handle, event,
-			      header.size * (top - at), 1, 1))
-		return;
-
-	for (; at < top; at++) {
-		data.ip		= at->from;
-		data.addr	= at->to;
-
-		perf_output_sample(&handle, &header, &data, event);
-	}
-
-	perf_output_end(&handle);
-
-	/* There's new data available. */
-	event->hw.interrupts++;
-	event->pending_kill = POLL_IN;
-}
-
 static void x86_pmu_stop(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1966,10 +1059,6 @@ static void x86_pmu_stop(struct perf_event *event)
 	 */
 	x86_perf_event_update(event, hwc, idx);
 
-	/* Drain the remaining BTS records. */
-	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS))
-		intel_pmu_drain_bts_buffer(cpuc);
-
 	cpuc->events[idx] = NULL;
 }
 
@@ -1996,114 +1085,6 @@ static void x86_pmu_disable(struct perf_event *event)
 	perf_event_update_userpage(event);
 }
 
-/*
- * Save and restart an expired event. Called by NMI contexts,
- * so it has to be careful about preempting normal event ops:
- */
-static int intel_pmu_save_and_restart(struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-	int idx = hwc->idx;
-	int ret;
-
-	x86_perf_event_update(event, hwc, idx);
-	ret = x86_perf_event_set_period(event, hwc, idx);
-
-	return ret;
-}
-
-static void intel_pmu_reset(void)
-{
-	struct debug_store *ds = __get_cpu_var(cpu_hw_events).ds;
-	unsigned long flags;
-	int idx;
-
-	if (!x86_pmu.num_events)
-		return;
-
-	local_irq_save(flags);
-
-	printk("clearing PMU state on CPU#%d\n", smp_processor_id());
-
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
-		checking_wrmsrl(x86_pmu.eventsel + idx, 0ull);
-		checking_wrmsrl(x86_pmu.perfctr  + idx, 0ull);
-	}
-	for (idx = 0; idx < x86_pmu.num_events_fixed; idx++) {
-		checking_wrmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, 0ull);
-	}
-	if (ds)
-		ds->bts_index = ds->bts_buffer_base;
-
-	local_irq_restore(flags);
-}
-
-/*
- * This handler is triggered by the local APIC, so the APIC IRQ handling
- * rules apply:
- */
-static int intel_pmu_handle_irq(struct pt_regs *regs)
-{
-	struct perf_sample_data data;
-	struct cpu_hw_events *cpuc;
-	int bit, loops;
-	u64 ack, status;
-
-	data.addr = 0;
-	data.raw = NULL;
-
-	cpuc = &__get_cpu_var(cpu_hw_events);
-
-	perf_disable();
-	intel_pmu_drain_bts_buffer(cpuc);
-	status = intel_pmu_get_status();
-	if (!status) {
-		perf_enable();
-		return 0;
-	}
-
-	loops = 0;
-again:
-	if (++loops > 100) {
-		WARN_ONCE(1, "perfevents: irq loop stuck!\n");
-		perf_event_print_debug();
-		intel_pmu_reset();
-		perf_enable();
-		return 1;
-	}
-
-	inc_irq_stat(apic_perf_irqs);
-	ack = status;
-	for_each_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
-		struct perf_event *event = cpuc->events[bit];
-
-		clear_bit(bit, (unsigned long *) &status);
-		if (!test_bit(bit, cpuc->active_mask))
-			continue;
-
-		if (!intel_pmu_save_and_restart(event))
-			continue;
-
-		data.period = event->hw.last_period;
-
-		if (perf_event_overflow(event, 1, &data, regs))
-			intel_pmu_disable_event(&event->hw, bit);
-	}
-
-	intel_pmu_ack_status(ack);
-
-	/*
-	 * Repeat if there is more work to be done:
-	 */
-	status = intel_pmu_get_status();
-	if (status)
-		goto again;
-
-	perf_enable();
-
-	return 1;
-}
-
 static int x86_pmu_handle_irq(struct pt_regs *regs)
 {
 	struct perf_sample_data data;
@@ -2216,37 +1197,20 @@ perf_event_nmi_handler(struct notifier_block *self,
 	return NOTIFY_STOP;
 }
 
+static __read_mostly struct notifier_block perf_event_nmi_notifier = {
+	.notifier_call		= perf_event_nmi_handler,
+	.next			= NULL,
+	.priority		= 1
+};
+
 static struct event_constraint unconstrained;
 static struct event_constraint emptyconstraint;
 
-static struct event_constraint bts_constraint =
-	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
-
-static struct event_constraint *
-intel_special_constraints(struct perf_event *event)
-{
-	unsigned int hw_event;
-
-	hw_event = event->hw.config & INTEL_ARCH_EVENT_MASK;
-
-	if (unlikely((hw_event ==
-		      x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
-		     (event->hw.sample_period == 1))) {
-
-		return &bts_constraint;
-	}
-	return NULL;
-}
-
 static struct event_constraint *
-intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
 	struct event_constraint *c;
 
-	c = intel_special_constraints(event);
-	if (c)
-		return c;
-
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
 			if ((event->hw.config & c->cmask) == c->code)
@@ -2257,148 +1221,6 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
 	return &unconstrained;
 }
 
-/*
- * AMD64 events are detected based on their event codes.
- */
-static inline int amd_is_nb_event(struct hw_perf_event *hwc)
-{
-	return (hwc->config & 0xe0) == 0xe0;
-}
-
-static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
-				      struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-	struct amd_nb *nb = cpuc->amd_nb;
-	int i;
-
-	/*
-	 * only care about NB events
-	 */
-	if (!(nb && amd_is_nb_event(hwc)))
-		return;
-
-	/*
-	 * need to scan whole list because event may not have
-	 * been assigned during scheduling
-	 *
-	 * no race condition possible because event can only
-	 * be removed on one CPU at a time AND PMU is disabled
-	 * when we come here
-	 */
-	for (i = 0; i < x86_pmu.num_events; i++) {
-		if (nb->owners[i] == event) {
-			cmpxchg(nb->owners+i, event, NULL);
-			break;
-		}
-	}
-}
-
- /*
-  * AMD64 NorthBridge events need special treatment because
-  * counter access needs to be synchronized across all cores
-  * of a package. Refer to BKDG section 3.12
-  *
-  * NB events are events measuring L3 cache, Hypertransport
-  * traffic. They are identified by an event code >= 0xe00.
-  * They measure events on the NorthBride which is shared
-  * by all cores on a package. NB events are counted on a
-  * shared set of counters. When a NB event is programmed
-  * in a counter, the data actually comes from a shared
-  * counter. Thus, access to those counters needs to be
-  * synchronized.
-  *
-  * We implement the synchronization such that no two cores
-  * can be measuring NB events using the same counters. Thus,
-  * we maintain a per-NB allocation table. The available slot
-  * is propagated using the event_constraint structure.
-  *
-  * We provide only one choice for each NB event based on
-  * the fact that only NB events have restrictions. Consequently,
-  * if a counter is available, there is a guarantee the NB event
-  * will be assigned to it. If no slot is available, an empty
-  * constraint is returned and scheduling will eventually fail
-  * for this event.
-  *
-  * Note that all cores attached the same NB compete for the same
-  * counters to host NB events, this is why we use atomic ops. Some
-  * multi-chip CPUs may have more than one NB.
-  *
-  * Given that resources are allocated (cmpxchg), they must be
-  * eventually freed for others to use. This is accomplished by
-  * calling amd_put_event_constraints().
-  *
-  * Non NB events are not impacted by this restriction.
-  */
-static struct event_constraint *
-amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-	struct amd_nb *nb = cpuc->amd_nb;
-	struct perf_event *old = NULL;
-	int max = x86_pmu.num_events;
-	int i, j, k = -1;
-
-	/*
-	 * if not NB event or no NB, then no constraints
-	 */
-	if (!(nb && amd_is_nb_event(hwc)))
-		return &unconstrained;
-
-	/*
-	 * detect if already present, if so reuse
-	 *
-	 * cannot merge with actual allocation
-	 * because of possible holes
-	 *
-	 * event can already be present yet not assigned (in hwc->idx)
-	 * because of successive calls to x86_schedule_events() from
-	 * hw_perf_group_sched_in() without hw_perf_enable()
-	 */
-	for (i = 0; i < max; i++) {
-		/*
-		 * keep track of first free slot
-		 */
-		if (k == -1 && !nb->owners[i])
-			k = i;
-
-		/* already present, reuse */
-		if (nb->owners[i] == event)
-			goto done;
-	}
-	/*
-	 * not present, so grab a new slot
-	 * starting either at:
-	 */
-	if (hwc->idx != -1) {
-		/* previous assignment */
-		i = hwc->idx;
-	} else if (k != -1) {
-		/* start from free slot found */
-		i = k;
-	} else {
-		/*
-		 * event not found, no slot found in
-		 * first pass, try again from the
-		 * beginning
-		 */
-		i = 0;
-	}
-	j = i;
-	do {
-		old = cmpxchg(nb->owners+i, NULL, event);
-		if (!old)
-			break;
-		if (++i == max)
-			i = 0;
-	} while (i != j);
-done:
-	if (!old)
-		return &nb->event_constraints[i];
-
-	return &emptyconstraint;
-}
-
 static int x86_event_sched_in(struct perf_event *event,
 			  struct perf_cpu_context *cpuctx)
 {
@@ -2509,335 +1331,9 @@ undo:
 	return ret;
 }
 
-static __read_mostly struct notifier_block perf_event_nmi_notifier = {
-	.notifier_call		= perf_event_nmi_handler,
-	.next			= NULL,
-	.priority		= 1
-};
-
-static __initconst struct x86_pmu p6_pmu = {
-	.name			= "p6",
-	.handle_irq		= x86_pmu_handle_irq,
-	.disable_all		= p6_pmu_disable_all,
-	.enable_all		= p6_pmu_enable_all,
-	.enable			= p6_pmu_enable_event,
-	.disable		= p6_pmu_disable_event,
-	.eventsel		= MSR_P6_EVNTSEL0,
-	.perfctr		= MSR_P6_PERFCTR0,
-	.event_map		= p6_pmu_event_map,
-	.raw_event		= p6_pmu_raw_event,
-	.max_events		= ARRAY_SIZE(p6_perfmon_event_map),
-	.apic			= 1,
-	.max_period		= (1ULL << 31) - 1,
-	.version		= 0,
-	.num_events		= 2,
-	/*
-	 * Events have 40 bits implemented. However they are designed such
-	 * that bits [32-39] are sign extensions of bit 31. As such the
-	 * effective width of a event for P6-like PMU is 32 bits only.
-	 *
-	 * See IA-32 Intel Architecture Software developer manual Vol 3B
-	 */
-	.event_bits		= 32,
-	.event_mask		= (1ULL << 32) - 1,
-	.get_event_constraints	= intel_get_event_constraints,
-	.event_constraints	= intel_p6_event_constraints
-};
-
-static __initconst struct x86_pmu core_pmu = {
-	.name			= "core",
-	.handle_irq		= x86_pmu_handle_irq,
-	.disable_all		= x86_pmu_disable_all,
-	.enable_all		= x86_pmu_enable_all,
-	.enable			= x86_pmu_enable_event,
-	.disable		= x86_pmu_disable_event,
-	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
-	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
-	.event_map		= intel_pmu_event_map,
-	.raw_event		= intel_pmu_raw_event,
-	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
-	.apic			= 1,
-	/*
-	 * Intel PMCs cannot be accessed sanely above 32 bit width,
-	 * so we install an artificial 1<<31 period regardless of
-	 * the generic event period:
-	 */
-	.max_period		= (1ULL << 31) - 1,
-	.get_event_constraints	= intel_get_event_constraints,
-	.event_constraints	= intel_core_event_constraints,
-};
-
-static __initconst struct x86_pmu intel_pmu = {
-	.name			= "Intel",
-	.handle_irq		= intel_pmu_handle_irq,
-	.disable_all		= intel_pmu_disable_all,
-	.enable_all		= intel_pmu_enable_all,
-	.enable			= intel_pmu_enable_event,
-	.disable		= intel_pmu_disable_event,
-	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
-	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
-	.event_map		= intel_pmu_event_map,
-	.raw_event		= intel_pmu_raw_event,
-	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
-	.apic			= 1,
-	/*
-	 * Intel PMCs cannot be accessed sanely above 32 bit width,
-	 * so we install an artificial 1<<31 period regardless of
-	 * the generic event period:
-	 */
-	.max_period		= (1ULL << 31) - 1,
-	.enable_bts		= intel_pmu_enable_bts,
-	.disable_bts		= intel_pmu_disable_bts,
-	.get_event_constraints	= intel_get_event_constraints
-};
-
-static __initconst struct x86_pmu amd_pmu = {
-	.name			= "AMD",
-	.handle_irq		= x86_pmu_handle_irq,
-	.disable_all		= x86_pmu_disable_all,
-	.enable_all		= x86_pmu_enable_all,
-	.enable			= x86_pmu_enable_event,
-	.disable		= x86_pmu_disable_event,
-	.eventsel		= MSR_K7_EVNTSEL0,
-	.perfctr		= MSR_K7_PERFCTR0,
-	.event_map		= amd_pmu_event_map,
-	.raw_event		= amd_pmu_raw_event,
-	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_events		= 4,
-	.event_bits		= 48,
-	.event_mask		= (1ULL << 48) - 1,
-	.apic			= 1,
-	/* use highest bit to detect overflow */
-	.max_period		= (1ULL << 47) - 1,
-	.get_event_constraints	= amd_get_event_constraints,
-	.put_event_constraints	= amd_put_event_constraints
-};
-
-static __init int p6_pmu_init(void)
-{
-	switch (boot_cpu_data.x86_model) {
-	case 1:
-	case 3:  /* Pentium Pro */
-	case 5:
-	case 6:  /* Pentium II */
-	case 7:
-	case 8:
-	case 11: /* Pentium III */
-	case 9:
-	case 13:
-		/* Pentium M */
-		break;
-	default:
-		pr_cont("unsupported p6 CPU model %d ",
-			boot_cpu_data.x86_model);
-		return -ENODEV;
-	}
-
-	x86_pmu = p6_pmu;
-
-	return 0;
-}
-
-static __init int intel_pmu_init(void)
-{
-	union cpuid10_edx edx;
-	union cpuid10_eax eax;
-	unsigned int unused;
-	unsigned int ebx;
-	int version;
-
-	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
-		/* check for P6 processor family */
-	   if (boot_cpu_data.x86 == 6) {
-		return p6_pmu_init();
-	   } else {
-		return -ENODEV;
-	   }
-	}
-
-	/*
-	 * Check whether the Architectural PerfMon supports
-	 * Branch Misses Retired hw_event or not.
-	 */
-	cpuid(10, &eax.full, &ebx, &unused, &edx.full);
-	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
-		return -ENODEV;
-
-	version = eax.split.version_id;
-	if (version < 2)
-		x86_pmu = core_pmu;
-	else
-		x86_pmu = intel_pmu;
-
-	x86_pmu.version			= version;
-	x86_pmu.num_events		= eax.split.num_events;
-	x86_pmu.event_bits		= eax.split.bit_width;
-	x86_pmu.event_mask		= (1ULL << eax.split.bit_width) - 1;
-
-	/*
-	 * Quirk: v2 perfmon does not report fixed-purpose events, so
-	 * assume at least 3 events:
-	 */
-	if (version > 1)
-		x86_pmu.num_events_fixed = max((int)edx.split.num_events_fixed, 3);
-
-	/*
-	 * Install the hw-cache-events table:
-	 */
-	switch (boot_cpu_data.x86_model) {
-	case 14: /* 65 nm core solo/duo, "Yonah" */
-		pr_cont("Core events, ");
-		break;
-
-	case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
-	case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
-	case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
-	case 29: /* six-core 45 nm xeon "Dunnington" */
-		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
-		       sizeof(hw_cache_event_ids));
-
-		x86_pmu.event_constraints = intel_core2_event_constraints;
-		pr_cont("Core2 events, ");
-		break;
-
-	case 26: /* 45 nm nehalem, "Bloomfield" */
-	case 30: /* 45 nm nehalem, "Lynnfield" */
-		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
-		       sizeof(hw_cache_event_ids));
-
-		x86_pmu.event_constraints = intel_nehalem_event_constraints;
-		pr_cont("Nehalem/Corei7 events, ");
-		break;
-	case 28:
-		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
-		       sizeof(hw_cache_event_ids));
-
-		x86_pmu.event_constraints = intel_gen_event_constraints;
-		pr_cont("Atom events, ");
-		break;
-
-	case 37: /* 32 nm nehalem, "Clarkdale" */
-	case 44: /* 32 nm nehalem, "Gulftown" */
-		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
-		       sizeof(hw_cache_event_ids));
-
-		x86_pmu.event_constraints = intel_westmere_event_constraints;
-		pr_cont("Westmere events, ");
-		break;
-	default:
-		/*
-		 * default constraints for v2 and up
-		 */
-		x86_pmu.event_constraints = intel_gen_event_constraints;
-		pr_cont("generic architected perfmon, ");
-	}
-	return 0;
-}
-
-static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
-{
-	struct amd_nb *nb;
-	int i;
-
-	nb = kmalloc(sizeof(struct amd_nb), GFP_KERNEL);
-	if (!nb)
-		return NULL;
-
-	memset(nb, 0, sizeof(*nb));
-	nb->nb_id = nb_id;
-
-	/*
-	 * initialize all possible NB constraints
-	 */
-	for (i = 0; i < x86_pmu.num_events; i++) {
-		set_bit(i, nb->event_constraints[i].idxmsk);
-		nb->event_constraints[i].weight = 1;
-	}
-	return nb;
-}
-
-static void amd_pmu_cpu_online(int cpu)
-{
-	struct cpu_hw_events *cpu1, *cpu2;
-	struct amd_nb *nb = NULL;
-	int i, nb_id;
-
-	if (boot_cpu_data.x86_max_cores < 2)
-		return;
-
-	/*
-	 * function may be called too early in the
-	 * boot process, in which case nb_id is bogus
-	 */
-	nb_id = amd_get_nb_id(cpu);
-	if (nb_id == BAD_APICID)
-		return;
-
-	cpu1 = &per_cpu(cpu_hw_events, cpu);
-	cpu1->amd_nb = NULL;
-
-	raw_spin_lock(&amd_nb_lock);
-
-	for_each_online_cpu(i) {
-		cpu2 = &per_cpu(cpu_hw_events, i);
-		nb = cpu2->amd_nb;
-		if (!nb)
-			continue;
-		if (nb->nb_id == nb_id)
-			goto found;
-	}
-
-	nb = amd_alloc_nb(cpu, nb_id);
-	if (!nb) {
-		pr_err("perf_events: failed NB allocation for CPU%d\n", cpu);
-		raw_spin_unlock(&amd_nb_lock);
-		return;
-	}
-found:
-	nb->refcnt++;
-	cpu1->amd_nb = nb;
-
-	raw_spin_unlock(&amd_nb_lock);
-}
-
-static void amd_pmu_cpu_offline(int cpu)
-{
-	struct cpu_hw_events *cpuhw;
-
-	if (boot_cpu_data.x86_max_cores < 2)
-		return;
-
-	cpuhw = &per_cpu(cpu_hw_events, cpu);
-
-	raw_spin_lock(&amd_nb_lock);
-
-	if (--cpuhw->amd_nb->refcnt == 0)
-		kfree(cpuhw->amd_nb);
-
-	cpuhw->amd_nb = NULL;
-
-	raw_spin_unlock(&amd_nb_lock);
-}
-
-static __init int amd_pmu_init(void)
-{
-	/* Performance-monitoring supported from K7 and later: */
-	if (boot_cpu_data.x86 < 6)
-		return -ENODEV;
-
-	x86_pmu = amd_pmu;
-
-	/* Events are common for all AMDs */
-	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
-	       sizeof(hw_cache_event_ids));
-
-	/*
-	 * explicitly initialize the boot cpu, other cpus will get
-	 * the cpu hotplug callbacks from smp_init()
-	 */
-	amd_pmu_cpu_online(smp_processor_id());
-	return 0;
-}
+#include "perf_event_amd.c"
+#include "perf_event_p6.c"
+#include "perf_event_intel.c"
 
 static void __init pmu_check_apic(void)
 {
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
new file mode 100644
index 0000000..6d28e08
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -0,0 +1,416 @@
+#ifdef CONFIG_CPU_SUP_AMD
+
+static raw_spinlock_t amd_nb_lock;
+
+static __initconst u64 amd_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
+		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0142, /* Data Cache Refills :system */
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0267, /* Data Prefetcher :attempts  */
+		[ C(RESULT_MISS)   ] = 0x0167, /* Data Prefetcher :cancelled */
+	},
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction cache fetches  */
+		[ C(RESULT_MISS)   ] = 0x0081, /* Instruction cache misses   */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x014B, /* Prefetch Instructions :Load */
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x037D, /* Requests to L2 Cache :IC+DC */
+		[ C(RESULT_MISS)   ] = 0x037E, /* L2 Cache Misses : IC+DC     */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x017F, /* L2 Fill/Writeback           */
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
+		[ C(RESULT_MISS)   ] = 0x0046, /* L1 DTLB and L2 DLTB Miss   */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction fecthes        */
+		[ C(RESULT_MISS)   ] = 0x0085, /* Instr. fetch ITLB misses   */
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
+		[ C(RESULT_ACCESS) ] = 0x00c2, /* Retired Branch Instr.      */
+		[ C(RESULT_MISS)   ] = 0x00c3, /* Retired Mispredicted BI    */
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
+/*
+ * AMD Performance Monitor K7 and later.
+ */
+static const u64 amd_perfmon_event_map[] =
+{
+  [PERF_COUNT_HW_CPU_CYCLES]		= 0x0076,
+  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0080,
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0081,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
+};
+
+static u64 amd_pmu_event_map(int hw_event)
+{
+	return amd_perfmon_event_map[hw_event];
+}
+
+static u64 amd_pmu_raw_event(u64 hw_event)
+{
+#define K7_EVNTSEL_EVENT_MASK	0xF000000FFULL
+#define K7_EVNTSEL_UNIT_MASK	0x00000FF00ULL
+#define K7_EVNTSEL_EDGE_MASK	0x000040000ULL
+#define K7_EVNTSEL_INV_MASK	0x000800000ULL
+#define K7_EVNTSEL_REG_MASK	0x0FF000000ULL
+
+#define K7_EVNTSEL_MASK			\
+	(K7_EVNTSEL_EVENT_MASK |	\
+	 K7_EVNTSEL_UNIT_MASK  |	\
+	 K7_EVNTSEL_EDGE_MASK  |	\
+	 K7_EVNTSEL_INV_MASK   |	\
+	 K7_EVNTSEL_REG_MASK)
+
+	return hw_event & K7_EVNTSEL_MASK;
+}
+
+/*
+ * AMD64 events are detected based on their event codes.
+ */
+static inline int amd_is_nb_event(struct hw_perf_event *hwc)
+{
+	return (hwc->config & 0xe0) == 0xe0;
+}
+
+static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
+				      struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct amd_nb *nb = cpuc->amd_nb;
+	int i;
+
+	/*
+	 * only care about NB events
+	 */
+	if (!(nb && amd_is_nb_event(hwc)))
+		return;
+
+	/*
+	 * need to scan whole list because event may not have
+	 * been assigned during scheduling
+	 *
+	 * no race condition possible because event can only
+	 * be removed on one CPU at a time AND PMU is disabled
+	 * when we come here
+	 */
+	for (i = 0; i < x86_pmu.num_events; i++) {
+		if (nb->owners[i] == event) {
+			cmpxchg(nb->owners+i, event, NULL);
+			break;
+		}
+	}
+}
+
+ /*
+  * AMD64 NorthBridge events need special treatment because
+  * counter access needs to be synchronized across all cores
+  * of a package. Refer to BKDG section 3.12
+  *
+  * NB events are events measuring L3 cache, Hypertransport
+  * traffic. They are identified by an event code >= 0xe00.
+  * They measure events on the NorthBride which is shared
+  * by all cores on a package. NB events are counted on a
+  * shared set of counters. When a NB event is programmed
+  * in a counter, the data actually comes from a shared
+  * counter. Thus, access to those counters needs to be
+  * synchronized.
+  *
+  * We implement the synchronization such that no two cores
+  * can be measuring NB events using the same counters. Thus,
+  * we maintain a per-NB allocation table. The available slot
+  * is propagated using the event_constraint structure.
+  *
+  * We provide only one choice for each NB event based on
+  * the fact that only NB events have restrictions. Consequently,
+  * if a counter is available, there is a guarantee the NB event
+  * will be assigned to it. If no slot is available, an empty
+  * constraint is returned and scheduling will eventually fail
+  * for this event.
+  *
+  * Note that all cores attached the same NB compete for the same
+  * counters to host NB events, this is why we use atomic ops. Some
+  * multi-chip CPUs may have more than one NB.
+  *
+  * Given that resources are allocated (cmpxchg), they must be
+  * eventually freed for others to use. This is accomplished by
+  * calling amd_put_event_constraints().
+  *
+  * Non NB events are not impacted by this restriction.
+  */
+static struct event_constraint *
+amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct amd_nb *nb = cpuc->amd_nb;
+	struct perf_event *old = NULL;
+	int max = x86_pmu.num_events;
+	int i, j, k = -1;
+
+	/*
+	 * if not NB event or no NB, then no constraints
+	 */
+	if (!(nb && amd_is_nb_event(hwc)))
+		return &unconstrained;
+
+	/*
+	 * detect if already present, if so reuse
+	 *
+	 * cannot merge with actual allocation
+	 * because of possible holes
+	 *
+	 * event can already be present yet not assigned (in hwc->idx)
+	 * because of successive calls to x86_schedule_events() from
+	 * hw_perf_group_sched_in() without hw_perf_enable()
+	 */
+	for (i = 0; i < max; i++) {
+		/*
+		 * keep track of first free slot
+		 */
+		if (k == -1 && !nb->owners[i])
+			k = i;
+
+		/* already present, reuse */
+		if (nb->owners[i] == event)
+			goto done;
+	}
+	/*
+	 * not present, so grab a new slot
+	 * starting either at:
+	 */
+	if (hwc->idx != -1) {
+		/* previous assignment */
+		i = hwc->idx;
+	} else if (k != -1) {
+		/* start from free slot found */
+		i = k;
+	} else {
+		/*
+		 * event not found, no slot found in
+		 * first pass, try again from the
+		 * beginning
+		 */
+		i = 0;
+	}
+	j = i;
+	do {
+		old = cmpxchg(nb->owners+i, NULL, event);
+		if (!old)
+			break;
+		if (++i == max)
+			i = 0;
+	} while (i != j);
+done:
+	if (!old)
+		return &nb->event_constraints[i];
+
+	return &emptyconstraint;
+}
+
+static __initconst struct x86_pmu amd_pmu = {
+	.name			= "AMD",
+	.handle_irq		= x86_pmu_handle_irq,
+	.disable_all		= x86_pmu_disable_all,
+	.enable_all		= x86_pmu_enable_all,
+	.enable			= x86_pmu_enable_event,
+	.disable		= x86_pmu_disable_event,
+	.eventsel		= MSR_K7_EVNTSEL0,
+	.perfctr		= MSR_K7_PERFCTR0,
+	.event_map		= amd_pmu_event_map,
+	.raw_event		= amd_pmu_raw_event,
+	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
+	.num_events		= 4,
+	.event_bits		= 48,
+	.event_mask		= (1ULL << 48) - 1,
+	.apic			= 1,
+	/* use highest bit to detect overflow */
+	.max_period		= (1ULL << 47) - 1,
+	.get_event_constraints	= amd_get_event_constraints,
+	.put_event_constraints	= amd_put_event_constraints
+};
+
+static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
+{
+	struct amd_nb *nb;
+	int i;
+
+	nb = kmalloc(sizeof(struct amd_nb), GFP_KERNEL);
+	if (!nb)
+		return NULL;
+
+	memset(nb, 0, sizeof(*nb));
+	nb->nb_id = nb_id;
+
+	/*
+	 * initialize all possible NB constraints
+	 */
+	for (i = 0; i < x86_pmu.num_events; i++) {
+		set_bit(i, nb->event_constraints[i].idxmsk);
+		nb->event_constraints[i].weight = 1;
+	}
+	return nb;
+}
+
+static void amd_pmu_cpu_online(int cpu)
+{
+	struct cpu_hw_events *cpu1, *cpu2;
+	struct amd_nb *nb = NULL;
+	int i, nb_id;
+
+	if (boot_cpu_data.x86_max_cores < 2)
+		return;
+
+	/*
+	 * function may be called too early in the
+	 * boot process, in which case nb_id is bogus
+	 */
+	nb_id = amd_get_nb_id(cpu);
+	if (nb_id == BAD_APICID)
+		return;
+
+	cpu1 = &per_cpu(cpu_hw_events, cpu);
+	cpu1->amd_nb = NULL;
+
+	raw_spin_lock(&amd_nb_lock);
+
+	for_each_online_cpu(i) {
+		cpu2 = &per_cpu(cpu_hw_events, i);
+		nb = cpu2->amd_nb;
+		if (!nb)
+			continue;
+		if (nb->nb_id == nb_id)
+			goto found;
+	}
+
+	nb = amd_alloc_nb(cpu, nb_id);
+	if (!nb) {
+		pr_err("perf_events: failed NB allocation for CPU%d\n", cpu);
+		raw_spin_unlock(&amd_nb_lock);
+		return;
+	}
+found:
+	nb->refcnt++;
+	cpu1->amd_nb = nb;
+
+	raw_spin_unlock(&amd_nb_lock);
+}
+
+static void amd_pmu_cpu_offline(int cpu)
+{
+	struct cpu_hw_events *cpuhw;
+
+	if (boot_cpu_data.x86_max_cores < 2)
+		return;
+
+	cpuhw = &per_cpu(cpu_hw_events, cpu);
+
+	raw_spin_lock(&amd_nb_lock);
+
+	if (--cpuhw->amd_nb->refcnt == 0)
+		kfree(cpuhw->amd_nb);
+
+	cpuhw->amd_nb = NULL;
+
+	raw_spin_unlock(&amd_nb_lock);
+}
+
+static __init int amd_pmu_init(void)
+{
+	/* Performance-monitoring supported from K7 and later: */
+	if (boot_cpu_data.x86 < 6)
+		return -ENODEV;
+
+	x86_pmu = amd_pmu;
+
+	/* Events are common for all AMDs */
+	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
+	       sizeof(hw_cache_event_ids));
+
+	/*
+	 * explicitly initialize the boot cpu, other cpus will get
+	 * the cpu hotplug callbacks from smp_init()
+	 */
+	amd_pmu_cpu_online(smp_processor_id());
+	return 0;
+}
+
+#else /* CONFIG_CPU_SUP_AMD */
+
+static int amd_pmu_init(void)
+{
+	return 0;
+}
+
+static void amd_pmu_cpu_online(int cpu)
+{
+}
+
+static void amd_pmu_cpu_offline(int cpu)
+{
+}
+
+#endif
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
new file mode 100644
index 0000000..cf6590c
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -0,0 +1,971 @@
+#ifdef CONFIG_CPU_SUP_INTEL
+
+/*
+ * Intel PerfMon v3. Used on Core2 and later.
+ */
+static const u64 intel_perfmon_event_map[] =
+{
+  [PERF_COUNT_HW_CPU_CYCLES]		= 0x003c,
+  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x4f2e,
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x412e,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
+  [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
+};
+
+static struct event_constraint intel_core_event_constraints[] =
+{
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
+	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
+	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
+	INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
+	INTEL_EVENT_CONSTRAINT(0x13, 0x2), /* DIV */
+	INTEL_EVENT_CONSTRAINT(0x14, 0x1), /* CYCLES_DIV_BUSY */
+	INTEL_EVENT_CONSTRAINT(0x18, 0x1), /* IDLE_DURING_DIV */
+	INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
+	INTEL_EVENT_CONSTRAINT(0xa1, 0x1), /* RS_UOPS_DISPATCH_CYCLES */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0x1), /* MEM_LOAD_RETIRED */
+	EVENT_CONSTRAINT_END
+};
+
+static struct event_constraint intel_nehalem_event_constraints[] =
+{
+	FIXED_EVENT_CONSTRAINT(0xc0, (0xf|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0x3c, (0xf|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	INTEL_EVENT_CONSTRAINT(0x40, 0x3), /* L1D_CACHE_LD */
+	INTEL_EVENT_CONSTRAINT(0x41, 0x3), /* L1D_CACHE_ST */
+	INTEL_EVENT_CONSTRAINT(0x42, 0x3), /* L1D_CACHE_LOCK */
+	INTEL_EVENT_CONSTRAINT(0x43, 0x3), /* L1D_ALL_REF */
+	INTEL_EVENT_CONSTRAINT(0x48, 0x3), /* L1D_PEND_MISS */
+	INTEL_EVENT_CONSTRAINT(0x4e, 0x3), /* L1D_PREFETCH */
+	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
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
+	EVENT_CONSTRAINT_END
+};
+
+static struct event_constraint intel_gen_event_constraints[] =
+{
+	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	EVENT_CONSTRAINT_END
+};
+
+static u64 intel_pmu_event_map(int hw_event)
+{
+	return intel_perfmon_event_map[hw_event];
+}
+
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
+static __initconst u64 nehalem_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI            */
+		[ C(RESULT_MISS)   ] = 0x0140, /* L1D_CACHE_LD.I_STATE         */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI            */
+		[ C(RESULT_MISS)   ] = 0x0141, /* L1D_CACHE_ST.I_STATE         */
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
+		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI   (alias)  */
+		[ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.ANY         */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI   (alias)  */
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
+		[ C(RESULT_MISS)   ] = 0x20c8, /* ITLB_MISS_RETIRED            */
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
+static __initconst u64 core2_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI          */
+		[ C(RESULT_MISS)   ] = 0x0140, /* L1D_CACHE_LD.I_STATE       */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI          */
+		[ C(RESULT_MISS)   ] = 0x0141, /* L1D_CACHE_ST.I_STATE       */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x104e, /* L1D_PREFETCH.REQUESTS      */
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0080, /* L1I.READS                  */
+		[ C(RESULT_MISS)   ] = 0x0081, /* L1I.MISSES                 */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x4f29, /* L2_LD.MESI                 */
+		[ C(RESULT_MISS)   ] = 0x4129, /* L2_LD.ISTATE               */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x4f2A, /* L2_ST.MESI                 */
+		[ C(RESULT_MISS)   ] = 0x412A, /* L2_ST.ISTATE               */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI  (alias) */
+		[ C(RESULT_MISS)   ] = 0x0208, /* DTLB_MISSES.MISS_LD        */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI  (alias) */
+		[ C(RESULT_MISS)   ] = 0x0808, /* DTLB_MISSES.MISS_ST        */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x00c0, /* INST_RETIRED.ANY_P         */
+		[ C(RESULT_MISS)   ] = 0x1282, /* ITLBMISSES                 */
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
+		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ANY        */
+		[ C(RESULT_MISS)   ] = 0x00c5, /* BP_INST_RETIRED.MISPRED    */
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
+static __initconst u64 atom_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x2140, /* L1D_CACHE.LD               */
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x2240, /* L1D_CACHE.ST               */
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0380, /* L1I.READS                  */
+		[ C(RESULT_MISS)   ] = 0x0280, /* L1I.MISSES                 */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x4f29, /* L2_LD.MESI                 */
+		[ C(RESULT_MISS)   ] = 0x4129, /* L2_LD.ISTATE               */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x4f2A, /* L2_ST.MESI                 */
+		[ C(RESULT_MISS)   ] = 0x412A, /* L2_ST.ISTATE               */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x2140, /* L1D_CACHE_LD.MESI  (alias) */
+		[ C(RESULT_MISS)   ] = 0x0508, /* DTLB_MISSES.MISS_LD        */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x2240, /* L1D_CACHE_ST.MESI  (alias) */
+		[ C(RESULT_MISS)   ] = 0x0608, /* DTLB_MISSES.MISS_ST        */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x00c0, /* INST_RETIRED.ANY_P         */
+		[ C(RESULT_MISS)   ] = 0x0282, /* ITLB.MISSES                */
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
+		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ANY        */
+		[ C(RESULT_MISS)   ] = 0x00c5, /* BP_INST_RETIRED.MISPRED    */
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
+static u64 intel_pmu_raw_event(u64 hw_event)
+{
+#define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
+#define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
+#define CORE_EVNTSEL_EDGE_MASK		0x00040000ULL
+#define CORE_EVNTSEL_INV_MASK		0x00800000ULL
+#define CORE_EVNTSEL_REG_MASK		0xFF000000ULL
+
+#define CORE_EVNTSEL_MASK		\
+	(INTEL_ARCH_EVTSEL_MASK |	\
+	 INTEL_ARCH_UNIT_MASK   |	\
+	 INTEL_ARCH_EDGE_MASK   |	\
+	 INTEL_ARCH_INV_MASK    |	\
+	 INTEL_ARCH_CNT_MASK)
+
+	return hw_event & CORE_EVNTSEL_MASK;
+}
+
+static void intel_pmu_enable_bts(u64 config)
+{
+	unsigned long debugctlmsr;
+
+	debugctlmsr = get_debugctlmsr();
+
+	debugctlmsr |= X86_DEBUGCTL_TR;
+	debugctlmsr |= X86_DEBUGCTL_BTS;
+	debugctlmsr |= X86_DEBUGCTL_BTINT;
+
+	if (!(config & ARCH_PERFMON_EVENTSEL_OS))
+		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_OS;
+
+	if (!(config & ARCH_PERFMON_EVENTSEL_USR))
+		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_USR;
+
+	update_debugctlmsr(debugctlmsr);
+}
+
+static void intel_pmu_disable_bts(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	unsigned long debugctlmsr;
+
+	if (!cpuc->ds)
+		return;
+
+	debugctlmsr = get_debugctlmsr();
+
+	debugctlmsr &=
+		~(X86_DEBUGCTL_TR | X86_DEBUGCTL_BTS | X86_DEBUGCTL_BTINT |
+		  X86_DEBUGCTL_BTS_OFF_OS | X86_DEBUGCTL_BTS_OFF_USR);
+
+	update_debugctlmsr(debugctlmsr);
+}
+
+static void intel_pmu_disable_all(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask))
+		intel_pmu_disable_bts();
+}
+
+static void intel_pmu_enable_all(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
+
+	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
+		struct perf_event *event =
+			cpuc->events[X86_PMC_IDX_FIXED_BTS];
+
+		if (WARN_ON_ONCE(!event))
+			return;
+
+		intel_pmu_enable_bts(event->hw.config);
+	}
+}
+
+static inline u64 intel_pmu_get_status(void)
+{
+	u64 status;
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+
+	return status;
+}
+
+static inline void intel_pmu_ack_status(u64 ack)
+{
+	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
+}
+
+static inline void
+intel_pmu_disable_fixed(struct hw_perf_event *hwc, int __idx)
+{
+	int idx = __idx - X86_PMC_IDX_FIXED;
+	u64 ctrl_val, mask;
+
+	mask = 0xfULL << (idx * 4);
+
+	rdmsrl(hwc->config_base, ctrl_val);
+	ctrl_val &= ~mask;
+	(void)checking_wrmsrl(hwc->config_base, ctrl_val);
+}
+
+static void intel_pmu_drain_bts_buffer(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct bts_record {
+		u64	from;
+		u64	to;
+		u64	flags;
+	};
+	struct perf_event *event = cpuc->events[X86_PMC_IDX_FIXED_BTS];
+	struct bts_record *at, *top;
+	struct perf_output_handle handle;
+	struct perf_event_header header;
+	struct perf_sample_data data;
+	struct pt_regs regs;
+
+	if (!event)
+		return;
+
+	if (!ds)
+		return;
+
+	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
+	top = (struct bts_record *)(unsigned long)ds->bts_index;
+
+	if (top <= at)
+		return;
+
+	ds->bts_index = ds->bts_buffer_base;
+
+
+	data.period	= event->hw.last_period;
+	data.addr	= 0;
+	data.raw	= NULL;
+	regs.ip		= 0;
+
+	/*
+	 * Prepare a generic sample, i.e. fill in the invariant fields.
+	 * We will overwrite the from and to address before we output
+	 * the sample.
+	 */
+	perf_prepare_sample(&header, &data, event, &regs);
+
+	if (perf_output_begin(&handle, event,
+			      header.size * (top - at), 1, 1))
+		return;
+
+	for (; at < top; at++) {
+		data.ip		= at->from;
+		data.addr	= at->to;
+
+		perf_output_sample(&handle, &header, &data, event);
+	}
+
+	perf_output_end(&handle);
+
+	/* There's new data available. */
+	event->hw.interrupts++;
+	event->pending_kill = POLL_IN;
+}
+
+static inline void
+intel_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+{
+	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+		intel_pmu_disable_bts();
+		intel_pmu_drain_bts_buffer();
+		return;
+	}
+
+	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
+		intel_pmu_disable_fixed(hwc, idx);
+		return;
+	}
+
+	x86_pmu_disable_event(hwc, idx);
+}
+
+static inline void
+intel_pmu_enable_fixed(struct hw_perf_event *hwc, int __idx)
+{
+	int idx = __idx - X86_PMC_IDX_FIXED;
+	u64 ctrl_val, bits, mask;
+	int err;
+
+	/*
+	 * Enable IRQ generation (0x8),
+	 * and enable ring-3 counting (0x2) and ring-0 counting (0x1)
+	 * if requested:
+	 */
+	bits = 0x8ULL;
+	if (hwc->config & ARCH_PERFMON_EVENTSEL_USR)
+		bits |= 0x2;
+	if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
+		bits |= 0x1;
+
+	/*
+	 * ANY bit is supported in v3 and up
+	 */
+	if (x86_pmu.version > 2 && hwc->config & ARCH_PERFMON_EVENTSEL_ANY)
+		bits |= 0x4;
+
+	bits <<= (idx * 4);
+	mask = 0xfULL << (idx * 4);
+
+	rdmsrl(hwc->config_base, ctrl_val);
+	ctrl_val &= ~mask;
+	ctrl_val |= bits;
+	err = checking_wrmsrl(hwc->config_base, ctrl_val);
+}
+
+static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+{
+	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+		if (!__get_cpu_var(cpu_hw_events).enabled)
+			return;
+
+		intel_pmu_enable_bts(hwc->config);
+		return;
+	}
+
+	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
+		intel_pmu_enable_fixed(hwc, idx);
+		return;
+	}
+
+	__x86_pmu_enable_event(hwc, idx);
+}
+
+/*
+ * Save and restart an expired event. Called by NMI contexts,
+ * so it has to be careful about preempting normal event ops:
+ */
+static int intel_pmu_save_and_restart(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	int idx = hwc->idx;
+	int ret;
+
+	x86_perf_event_update(event, hwc, idx);
+	ret = x86_perf_event_set_period(event, hwc, idx);
+
+	return ret;
+}
+
+static void intel_pmu_reset(void)
+{
+	struct debug_store *ds = __get_cpu_var(cpu_hw_events).ds;
+	unsigned long flags;
+	int idx;
+
+	if (!x86_pmu.num_events)
+		return;
+
+	local_irq_save(flags);
+
+	printk("clearing PMU state on CPU#%d\n", smp_processor_id());
+
+	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+		checking_wrmsrl(x86_pmu.eventsel + idx, 0ull);
+		checking_wrmsrl(x86_pmu.perfctr  + idx, 0ull);
+	}
+	for (idx = 0; idx < x86_pmu.num_events_fixed; idx++) {
+		checking_wrmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, 0ull);
+	}
+	if (ds)
+		ds->bts_index = ds->bts_buffer_base;
+
+	local_irq_restore(flags);
+}
+
+/*
+ * This handler is triggered by the local APIC, so the APIC IRQ handling
+ * rules apply:
+ */
+static int intel_pmu_handle_irq(struct pt_regs *regs)
+{
+	struct perf_sample_data data;
+	struct cpu_hw_events *cpuc;
+	int bit, loops;
+	u64 ack, status;
+
+	data.addr = 0;
+	data.raw = NULL;
+
+	cpuc = &__get_cpu_var(cpu_hw_events);
+
+	perf_disable();
+	intel_pmu_drain_bts_buffer();
+	status = intel_pmu_get_status();
+	if (!status) {
+		perf_enable();
+		return 0;
+	}
+
+	loops = 0;
+again:
+	if (++loops > 100) {
+		WARN_ONCE(1, "perfevents: irq loop stuck!\n");
+		perf_event_print_debug();
+		intel_pmu_reset();
+		perf_enable();
+		return 1;
+	}
+
+	inc_irq_stat(apic_perf_irqs);
+	ack = status;
+	for_each_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
+		struct perf_event *event = cpuc->events[bit];
+
+		clear_bit(bit, (unsigned long *) &status);
+		if (!test_bit(bit, cpuc->active_mask))
+			continue;
+
+		if (!intel_pmu_save_and_restart(event))
+			continue;
+
+		data.period = event->hw.last_period;
+
+		if (perf_event_overflow(event, 1, &data, regs))
+			intel_pmu_disable_event(&event->hw, bit);
+	}
+
+	intel_pmu_ack_status(ack);
+
+	/*
+	 * Repeat if there is more work to be done:
+	 */
+	status = intel_pmu_get_status();
+	if (status)
+		goto again;
+
+	perf_enable();
+
+	return 1;
+}
+
+static struct event_constraint bts_constraint =
+	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
+
+static struct event_constraint *
+intel_special_constraints(struct perf_event *event)
+{
+	unsigned int hw_event;
+
+	hw_event = event->hw.config & INTEL_ARCH_EVENT_MASK;
+
+	if (unlikely((hw_event ==
+		      x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
+		     (event->hw.sample_period == 1))) {
+
+		return &bts_constraint;
+	}
+	return NULL;
+}
+
+static struct event_constraint *
+intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct event_constraint *c;
+
+	c = intel_special_constraints(event);
+	if (c)
+		return c;
+
+	return x86_get_event_constraints(cpuc, event);
+}
+
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
+static __initconst struct x86_pmu intel_pmu = {
+	.name			= "Intel",
+	.handle_irq		= intel_pmu_handle_irq,
+	.disable_all		= intel_pmu_disable_all,
+	.enable_all		= intel_pmu_enable_all,
+	.enable			= intel_pmu_enable_event,
+	.disable		= intel_pmu_disable_event,
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
+	.enable_bts		= intel_pmu_enable_bts,
+	.disable_bts		= intel_pmu_disable_bts,
+	.get_event_constraints	= intel_get_event_constraints
+};
+
+static __init int intel_pmu_init(void)
+{
+	union cpuid10_edx edx;
+	union cpuid10_eax eax;
+	unsigned int unused;
+	unsigned int ebx;
+	int version;
+
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
+		/* check for P6 processor family */
+	   if (boot_cpu_data.x86 == 6) {
+		return p6_pmu_init();
+	   } else {
+		return -ENODEV;
+	   }
+	}
+
+	/*
+	 * Check whether the Architectural PerfMon supports
+	 * Branch Misses Retired hw_event or not.
+	 */
+	cpuid(10, &eax.full, &ebx, &unused, &edx.full);
+	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
+		return -ENODEV;
+
+	version = eax.split.version_id;
+	if (version < 2)
+		x86_pmu = core_pmu;
+	else
+		x86_pmu = intel_pmu;
+
+	x86_pmu.version			= version;
+	x86_pmu.num_events		= eax.split.num_events;
+	x86_pmu.event_bits		= eax.split.bit_width;
+	x86_pmu.event_mask		= (1ULL << eax.split.bit_width) - 1;
+
+	/*
+	 * Quirk: v2 perfmon does not report fixed-purpose events, so
+	 * assume at least 3 events:
+	 */
+	if (version > 1)
+		x86_pmu.num_events_fixed = max((int)edx.split.num_events_fixed, 3);
+
+	/*
+	 * Install the hw-cache-events table:
+	 */
+	switch (boot_cpu_data.x86_model) {
+	case 14: /* 65 nm core solo/duo, "Yonah" */
+		pr_cont("Core events, ");
+		break;
+
+	case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
+	case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
+	case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
+	case 29: /* six-core 45 nm xeon "Dunnington" */
+		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+
+		x86_pmu.event_constraints = intel_core2_event_constraints;
+		pr_cont("Core2 events, ");
+		break;
+
+	case 26: /* 45 nm nehalem, "Bloomfield" */
+	case 30: /* 45 nm nehalem, "Lynnfield" */
+		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+
+		x86_pmu.event_constraints = intel_nehalem_event_constraints;
+		pr_cont("Nehalem/Corei7 events, ");
+		break;
+	case 28:
+		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+
+		x86_pmu.event_constraints = intel_gen_event_constraints;
+		pr_cont("Atom events, ");
+		break;
+
+	case 37: /* 32 nm nehalem, "Clarkdale" */
+	case 44: /* 32 nm nehalem, "Gulftown" */
+		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+
+		x86_pmu.event_constraints = intel_westmere_event_constraints;
+		pr_cont("Westmere events, ");
+		break;
+	default:
+		/*
+		 * default constraints for v2 and up
+		 */
+		x86_pmu.event_constraints = intel_gen_event_constraints;
+		pr_cont("generic architected perfmon, ");
+	}
+	return 0;
+}
+
+#else /* CONFIG_CPU_SUP_INTEL */
+
+static int intel_pmu_init(void)
+{
+	return 0;
+}
+
+#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
new file mode 100644
index 0000000..1ca5ba0
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -0,0 +1,157 @@
+#ifdef CONFIG_CPU_SUP_INTEL
+
+/*
+ * Not sure about some of these
+ */
+static const u64 p6_perfmon_event_map[] =
+{
+  [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,
+  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0f2e,
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x012e,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
+  [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,
+};
+
+static u64 p6_pmu_event_map(int hw_event)
+{
+	return p6_perfmon_event_map[hw_event];
+}
+
+/*
+ * Event setting that is specified not to count anything.
+ * We use this to effectively disable a counter.
+ *
+ * L2_RQSTS with 0 MESI unit mask.
+ */
+#define P6_NOP_EVENT			0x0000002EULL
+
+static u64 p6_pmu_raw_event(u64 hw_event)
+{
+#define P6_EVNTSEL_EVENT_MASK		0x000000FFULL
+#define P6_EVNTSEL_UNIT_MASK		0x0000FF00ULL
+#define P6_EVNTSEL_EDGE_MASK		0x00040000ULL
+#define P6_EVNTSEL_INV_MASK		0x00800000ULL
+#define P6_EVNTSEL_REG_MASK		0xFF000000ULL
+
+#define P6_EVNTSEL_MASK			\
+	(P6_EVNTSEL_EVENT_MASK |	\
+	 P6_EVNTSEL_UNIT_MASK  |	\
+	 P6_EVNTSEL_EDGE_MASK  |	\
+	 P6_EVNTSEL_INV_MASK   |	\
+	 P6_EVNTSEL_REG_MASK)
+
+	return hw_event & P6_EVNTSEL_MASK;
+}
+
+static struct event_constraint p6_event_constraints[] =
+{
+	INTEL_EVENT_CONSTRAINT(0xc1, 0x1),	/* FLOPS */
+	INTEL_EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
+	INTEL_EVENT_CONSTRAINT(0x11, 0x1),	/* FP_ASSIST */
+	INTEL_EVENT_CONSTRAINT(0x12, 0x2),	/* MUL */
+	INTEL_EVENT_CONSTRAINT(0x13, 0x2),	/* DIV */
+	INTEL_EVENT_CONSTRAINT(0x14, 0x1),	/* CYCLES_DIV_BUSY */
+	EVENT_CONSTRAINT_END
+};
+
+static void p6_pmu_disable_all(void)
+{
+	u64 val;
+
+	/* p6 only has one enable register */
+	rdmsrl(MSR_P6_EVNTSEL0, val);
+	val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+	wrmsrl(MSR_P6_EVNTSEL0, val);
+}
+
+static void p6_pmu_enable_all(void)
+{
+	unsigned long val;
+
+	/* p6 only has one enable register */
+	rdmsrl(MSR_P6_EVNTSEL0, val);
+	val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	wrmsrl(MSR_P6_EVNTSEL0, val);
+}
+
+static inline void
+p6_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 val = P6_NOP_EVENT;
+
+	if (cpuc->enabled)
+		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+
+	(void)checking_wrmsrl(hwc->config_base + idx, val);
+}
+
+static void p6_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 val;
+
+	val = hwc->config;
+	if (cpuc->enabled)
+		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+
+	(void)checking_wrmsrl(hwc->config_base + idx, val);
+}
+
+static __initconst struct x86_pmu p6_pmu = {
+	.name			= "p6",
+	.handle_irq		= x86_pmu_handle_irq,
+	.disable_all		= p6_pmu_disable_all,
+	.enable_all		= p6_pmu_enable_all,
+	.enable			= p6_pmu_enable_event,
+	.disable		= p6_pmu_disable_event,
+	.eventsel		= MSR_P6_EVNTSEL0,
+	.perfctr		= MSR_P6_PERFCTR0,
+	.event_map		= p6_pmu_event_map,
+	.raw_event		= p6_pmu_raw_event,
+	.max_events		= ARRAY_SIZE(p6_perfmon_event_map),
+	.apic			= 1,
+	.max_period		= (1ULL << 31) - 1,
+	.version		= 0,
+	.num_events		= 2,
+	/*
+	 * Events have 40 bits implemented. However they are designed such
+	 * that bits [32-39] are sign extensions of bit 31. As such the
+	 * effective width of a event for P6-like PMU is 32 bits only.
+	 *
+	 * See IA-32 Intel Architecture Software developer manual Vol 3B
+	 */
+	.event_bits		= 32,
+	.event_mask		= (1ULL << 32) - 1,
+	.get_event_constraints	= x86_get_event_constraints,
+	.event_constraints	= p6_event_constraints,
+};
+
+static __init int p6_pmu_init(void)
+{
+	switch (boot_cpu_data.x86_model) {
+	case 1:
+	case 3:  /* Pentium Pro */
+	case 5:
+	case 6:  /* Pentium II */
+	case 7:
+	case 8:
+	case 11: /* Pentium III */
+	case 9:
+	case 13:
+		/* Pentium M */
+		break;
+	default:
+		pr_cont("unsupported p6 CPU model %d ",
+			boot_cpu_data.x86_model);
+		return -ENODEV;
+	}
+
+	x86_pmu = p6_pmu;
+
+	return 0;
+}
+
+#endif /* CONFIG_CPU_SUP_INTEL */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187Ab0A1Jer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0A1Jer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138Ab0A1Jeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:34:37 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56106 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab0A1Jec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:34:32 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 28 Jan 2010 10:34:22 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: [PATCH/RFC v2 2/3] [ARM] perfevents: Event description for ARMv6,
 Cortex-A8 and Cortex-A9 exported
In-reply-to: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: acme@redhat.com, jamie.iles@picochip.com, will.deacon@arm.com,
       jpihet@mvista.com, mingo@elte.hu, peterz@infradead.org,
       p.osciak@samsung.com, m.szyprowski@samsung.com,
       kyungmin.park@samsung.com, m.nazarewicz@samsung.com,
       Tomasz Fujak <t.fujak@samsung.com>
Message-id: <1264671263-21412-3-git-send-email-t.fujak@samsung.com>
X-Mailer: git-send-email 1.6.5.3
References: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomasz Fujak <t.fujak@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>

---
 arch/arm/kernel/perf_event.c |  333 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 333 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 65edef6..eec086e 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -28,6 +28,17 @@
 
 static const struct pmu_irqs *pmu_irqs;
 
+#define PERF_EVENT_DESC_ENTRY(_val, _min, _max, _name, _desc) { \
+	.config = PERF_EVENT_RAW_TO_CONFIG(_val),\
+	.min_value = (_min),\
+	.max_value = (_max),\
+	.name = (_name),\
+	.description = (_desc)\
+}
+
+#define minv 0
+#define maxv 0
+
 /*
  * Hardware lock to serialize accesses to PMU registers. Needed for the
  * read/modify/write sequences.
@@ -86,6 +97,8 @@ struct arm_pmu {
 
 /* Set at runtime when we know what CPU type we are. */
 static const struct arm_pmu *armpmu;
+static LIST_HEAD(perf_events_arm);
+struct list_head *perf_events_platform = &perf_events_arm;
 
 #define HW_OP_UNSUPPORTED		0xFFFF
 
@@ -98,6 +111,17 @@ static unsigned armpmu_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 				     [PERF_COUNT_HW_CACHE_OP_MAX]
 				     [PERF_COUNT_HW_CACHE_RESULT_MAX];
 
+static void
+perf_event_add_events(struct list_head *head,
+			struct perf_event_description *array,
+			unsigned int count)
+{
+	unsigned int i = 0;
+
+	for (i = 0; i < count; ++i)
+		list_add_tail(&array[i].list, head);
+}
+
 static int
 armpmu_map_cache_event(u64 config)
 {
@@ -820,6 +844,56 @@ static const unsigned armv6mpcore_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 	},
 };
 
+static struct perf_event_description armv6_event_description[] = {
+	/* armv6 events */
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_ICACHE_MISS, minv, maxv,
+		"ICACHE_MISS", "Instruction cache miss"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_IBUF_STALL, minv, maxv,
+		"IBUF_STALL", "Instruction fetch stall cycle"
+		" (either uTLB or I-cache miss)"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_DDEP_STALL, minv, maxv,
+		"DDEP_STALL", "Data dependency stall cycle"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_ITLB_MISS, minv, maxv,
+		"ITLB_MISS", "Instruction uTLB miss"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_DTLB_MISS, minv, maxv,
+		"DTLB_MISS", "Data uTLB miss"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_BR_EXEC, minv, maxv,
+		"BR_EXEC", "Branch instruction executed "
+		"(even if the PC hasn't been affected)"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_BR_MISPREDICT, minv, maxv,
+	 "BR_MISPREDICT", "Branch mispredicted"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_INSTR_EXEC, minv, maxv,
+		"INSTR_EXEC", "Instruction executed (may be incremented"
+		" by 2 on some occasion)"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_DCACHE_HIT, minv, maxv,
+		"DCACHE_HIT", "Data cache hit for cacheable locations "
+		"(cache ops don't count)"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_DCACHE_ACCESS, minv, maxv,
+		"DCACHE_ACCESS", "Data cache access, all locations (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_DCACHE_MISS, minv, maxv,
+		"DCACHE_MISS", "Data cache miss (cache ops don't count)"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_DCACHE_WBACK, minv, maxv,
+		"DCACHE_WBACK", "Data cache writeback (once for "
+		"half a cache line)"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_SW_PC_CHANGE, minv, maxv,
+		"SW_PC_CHANGE", "Software PC change (does not count if the "
+		"mode is changed, i.e. at SVC)"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_MAIN_TLB_MISS, minv, maxv,
+		"MAIN_TLB_MISS", "Main TLB (not uTLB) miss"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_EXPL_D_ACCESS, minv, maxv,
+		"EXPL_D_ACCESS", "Explicit external data access, DCache "
+		"linefill, Uncached, write-through"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_LSU_FULL_STALL, minv, maxv,
+		"LSU_FULL_STALL", "Stall cycle due to full Load/Store"
+		" Unit queue"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_WBUF_DRAINED, minv, maxv,
+		"WBUF_DRAINED", "Write buffer drained because of DSB or "
+		"Strongly Ordered memory operation"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_CPU_CYCLES, minv, maxv,
+		"CPU_CYCLES", "CPU cycles"),
+	PERF_EVENT_DESC_ENTRY(ARMV6_PERFCTR_NOP, minv, maxv, "NOP", "???")
+};
+
 static inline unsigned long
 armv6_pmcr_read(void)
 {
@@ -1439,6 +1513,248 @@ static const unsigned armv7_a8_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 	},
 };
 
+static struct perf_event_description armv7_event_description[] = {
+	/* armv7 generic events */
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PMNC_SW_INCR, minv, maxv,
+		"PMNC_SW_INCR", "Software increment (write to a "
+		"dedicated register)"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_IFETCH_MISS, minv, maxv,
+		"IFETCH_MISS", "Instruction fetch miss that causes "
+		"refill. Speculative misses count unless they don't "
+		"make to the execution, maintenance operations don't"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_ITLB_MISS, minv, maxv,
+		"ITLB_MISS", "Instruction TLB miss that causes a refill."
+		" Both speculative and explicit accesses count"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DCACHE_REFILL, minv, maxv,
+		"DCACHE_REFILL", "Data cache refill. Same rules as ITLB_MISS"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DCACHE_ACCESS, minv, maxv,
+		"DCACHE_ACCESS", "Data cache access. Same rules as ITLB_MISS"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DTLB_REFILL, minv, maxv,
+		"DTLB_REFILL", "Data TLB refill. Same rules as ITLB_MISS"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DREAD, minv, maxv, "DREAD",
+		"Data read executed (including SWP)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DWRITE, minv, maxv, "DWRITE",
+		"Data write executed (including SWP)"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_EXC_TAKEN, minv, maxv,
+		"EXC_TAKEN", "Exception taken"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_EXC_EXECUTED, minv, maxv,
+		"EXC_EXECUTED", "Exception return executed"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_CID_WRITE, minv, maxv,
+		"CID_WRITE", "Context ID register written"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PC_WRITE, minv, maxv, "PC_WRITE",
+		"Software change of the PC (R15)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PC_IMM_BRANCH, minv, maxv,
+		"PC_IMM_BRANCH", "Immediate branch (B[L], BLX, CB[N]Z, HB[L],"
+		" HBLP), including conditional that fail"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_UNALIGNED_ACCESS, minv, maxv,
+		"UNALIGNED_ACCESS", "Data access unaligned to the transfer"
+		" size"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PC_BRANCH_MIS_PRED, minv, maxv,
+		"BRANCH_MISS_PRED", "Branch misprediction or not predicted"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_CLOCK_CYCLES, minv, maxv,
+		"CLOCK_CYCLES", "Cycle count"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PC_BRANCH_MIS_USED, minv, maxv,
+		"BRANCH_MIS_USED", "Branch or other program flow change that "
+		"could have been predicted"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_CPU_CYCLES, minv, maxv,
+		"CPU_CYCLES", "measures cpu cycles, the only allowed event"
+		" for the first counter")
+};
+
+static struct perf_event_description cortexa8_event_description[] = {
+	/* Cortex A8 specific events */
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_INSTR_EXECUTED, minv, maxv,
+		"INSTR_EXECUTED", "Instruction executed (including conditional"
+		" that don't pass)"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PC_PROC_RETURN, minv, maxv,
+		"PC_PROC_RETURN", "Procedure return (BX LR; MOV PC, LR; POP "
+		"{.., PC} and such)"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_WRITE_BUFFER_FULL, minv, maxv,
+		"WRITE_BUFFER_FULL", "Write buffer full cycle"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L2_STORE_MERGED, minv, maxv,
+		"L2_STORE_MERGED", "Store that is merged in the L2 memory"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L2_STORE_BUFF, minv, maxv,
+		"L2_STORE_BUFF", "A bufferable store from load/store to L2"
+		" cache, evictions and cast out data don't count (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L2_ACCESS, minv, maxv, "L2_ACCESS",
+		"L2 cache access"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L2_CACH_MISS, minv, maxv,
+		"L2_CACH_MISS", "L2 cache miss"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_AXI_READ_CYCLES, minv, maxv,
+		"AXI_READ_CYCLES", "AXI read data transfers"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_AXI_WRITE_CYCLES, minv, maxv,
+		"AXI_WRITE_CYCLES", "AXI write data transfers"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_MEMORY_REPLAY, minv, maxv,
+		"MEMORY_REPLAY", "Replay event in the memory subsystem (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_UNALIGNED_ACCESS_REPLAY, minv, maxv,
+		"UNALIGNED_ACCESS_REPLAY", "An unaligned memory access that"
+		" results in a replay (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L1_DATA_MISS, minv, maxv,
+		"L1_DATA_MISS", "L1 data cache miss"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L1_INST_MISS, minv, maxv,
+		"L1_INST_MISS", "L1 instruction cache miss"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L1_DATA_COLORING, minv, maxv,
+		"L1_DATA_COLORING", "L1 access that triggers eviction or cast"
+		" out (page coloring alias)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L1_NEON_DATA, minv, maxv,
+		"L1_NEON_DATA", "A NEON access that hits the L1 DCache"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L1_NEON_CACH_DATA, minv, maxv,
+		"L1_NEON_CACH_DATA", "A cacheable NEON access that hits the"
+		" L1 DCache"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L2_NEON, minv, maxv, "L2_NEON",
+		"A NEON access memory access that results in L2 being"
+		" accessed"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L2_NEON_HIT, minv, maxv,
+		"L2_NEON_HIT", "A NEON hit in the L2"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_L1_INST, minv, maxv, "L1_INST",
+		"A L1 instruction access (CP15 cache ops don't count)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PC_RETURN_MIS_PRED, minv, maxv,
+		"PC_RETURN_MIS_PRED", "A return stack misprediction because"
+		" of incorrect stack address"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PC_BRANCH_FAILED, minv, maxv,
+		"PC_BRANCH_FAILED", "Branch misprediction (both ways)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PC_BRANCH_TAKEN, minv, maxv,
+		"PC_BRANCH_TAKEN", "Predictable branch predicted taken"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PC_BRANCH_EXECUTED, minv, maxv,
+		"PC_BRANCH_EXECUTED", "Predictable branch executed taken"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_OP_EXECUTED, minv, maxv,
+		"OP_EXECUTED", "uOP executed (an instruction or a "
+		"multi-instruction step)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_CYCLES_INST_STALL, minv, maxv,
+		"CYCLES_INST_STALL", "Instruction issue unit idle cycle"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_CYCLES_INST, minv, maxv,
+		"CYCLES_INST", "Instruction issued (multicycle instruction "
+		"counts for one)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_CYCLES_NEON_DATA_STALL, minv, maxv,
+		"CYCLES_NEON_DATA_STALL", "Cycles the CPU waits on MRC "
+		"from NEON"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_CYCLES_NEON_INST_STALL, minv, maxv,
+		"CYCLES_NEON_INST_STALL", "Stall cycles caused by full NEON"
+		" queue (either ins. queue or load queue)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_NEON_CYCLES, minv, maxv,
+		"NEON_CYCLES", "Cycles that both processors (ARM & NEON)"
+		" are not idle"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PMU0_EVENTS, minv, maxv,
+		"PMU0_EVENTS", "Event on external input source (PMUEXTIN[0])"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PMU1_EVENTS, minv, maxv,
+		"PMU1_EVENTS", "Event on external input source (PMUEXTIN[1])"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PMU_EVENTS, minv, maxv,
+		"PMU_EVENTS", "Event on either of the external input sources"
+		" (PMUEXTIN[0,1])")
+};
+
+static struct perf_event_description cortexa9_event_description[] = {
+	/* ARMv7 Cortex-A9 specific event types */
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_JAVA_HW_BYTECODE_EXEC, minv, maxv,
+		"JAVA_HW_BYTECODE_EXEC", "Java bytecode executed in HW"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_JAVA_SW_BYTECODE_EXEC, minv, maxv,
+		"JAVA_SW_BYTECODE_EXEC", "Java bytecode executed in SW"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_JAZELLE_BRANCH_EXEC, minv, maxv,
+		"JAZELLE_BRANCH_EXEC", "Jazelle backward branch"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_COHERENT_LINE_MISS, minv, maxv,
+		"COHERENT_LINE_MISS", "???"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_COHERENT_LINE_HIT, minv, maxv,
+		"COHERENT_LINE_HIT", "???"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_ICACHE_DEP_STALL_CYCLES, minv,
+		maxv, "ICACHE_DEP_STALL_CYCLES", "Instruction cache "
+		"dependent stall"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DCACHE_DEP_STALL_CYCLES, minv,
+		maxv, "DCACHE_DEP_STALL_CYCLES", "Data cache dependent stall"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_TLB_MISS_DEP_STALL_CYCLES, minv,
+		maxv, "TLB_MISS_DEP_STALL_CYCLES", "Main TLB miss stall"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_STREX_EXECUTED_PASSED, minv, maxv,
+		"STREX_EXECUTED_PASSED", "STREX passed"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_STREX_EXECUTED_FAILED, minv, maxv,
+		"STREX_EXECUTED_FAILED", "STREX failed"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DATA_EVICTION, minv, maxv,
+		"DATA_EVICTION", "Cache data eviction (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_ISSUE_STAGE_NO_INST, minv, maxv,
+		"ISSUE_STAGE_NO_INST", "No instruction issued cycle"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_ISSUE_STAGE_EMPTY, minv, maxv,
+		"ISSUE_STAGE_EMPTY", "Empty issue unit cycles"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_INST_OUT_OF_RENAME_STAGE, minv,
+		maxv, "INST_OUT_OF_RENAME_STAGE", "???"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PREDICTABLE_FUNCT_RETURNS, minv,
+		maxv, "PREDICTABLE_FUNCT_RETURNS", "Predictable return "
+		"occured (?)"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_MAIN_UNIT_EXECUTED_INST, minv,
+		maxv, "MAIN_UNIT_EXECUTED_INST", "Pipe 0 instruction "
+		"executed (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_SECOND_UNIT_EXECUTED_INST, minv,
+		maxv, "SECOND_UNIT_EXECUTED_INST", "Pipe 1 instruction "
+		"executed (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_LD_ST_UNIT_EXECUTED_INST, minv,
+		maxv, "LD_ST_UNIT_EXECUTED_INST", "Load/Store Unit instruction"
+		" executed (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_FP_EXECUTED_INST, minv, maxv,
+		"FP_EXECUTED_INST", "VFP instruction executed (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_NEON_EXECUTED_INST, minv, maxv,
+		"NEON_EXECUTED_INST", "NEON instruction executed (?)"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PLD_FULL_DEP_STALL_CYCLES,
+		minv, maxv, "PLD_FULL_DEP_STALL_CYCLES", "PLD stall cycle"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DATA_WR_DEP_STALL_CYCLES, minv,
+		maxv, "DATA_WR_DEP_STALL_CYCLES", "Write stall cycle"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_ITLB_MISS_DEP_STALL_CYCLES, minv,
+		maxv, "ITLB_MISS_DEP_STALL_CYCLES", "Instruction stall due to"
+		" main TLB miss (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DTLB_MISS_DEP_STALL_CYCLES, minv,
+		maxv, "DTLB_MISS_DEP_STALL_CYCLES", "Data stall due to main TLB"
+		" miss (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_MICRO_ITLB_MISS_DEP_STALL_CYCLES,
+		minv, maxv, "MICRO_ITLB_MISS_DEP_STALL_CYCLES", "Instruction "
+		"stall due to uTLB miss (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_MICRO_DTLB_MISS_DEP_STALL_CYCLES,
+		minv, maxv, "MICRO_DTLB_MISS_DEP_STALL_CYCLES", "Data stall "
+		"due to micro uTLB miss (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DMB_DEP_STALL_CYCLES, minv, maxv,
+		"DMB_DEP_STALL_CYCLES", "DMB stall (?)"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_INTGR_CLK_ENABLED_CYCLES, minv,
+		maxv, "INTGR_CLK_ENABLED_CYCLES", "Integer core clock "
+		"disabled (?)"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DATA_ENGINE_CLK_EN_CYCLES, minv,
+		maxv, "DATA_ENGINE_CLK_EN_CYCLES", "Data engine clock disabled"
+		" (?)"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_ISB_INST, minv, maxv, "ISB_INST",
+		"ISB executed"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DSB_INST, minv, maxv, "DSB_INST",
+		"DSB executed"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_DMB_INST, minv, maxv, "DMB_INST",
+		"DMB executed"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_EXT_INTERRUPTS, minv, maxv,
+		"EXT_INTERRUPTS", "External interrupt"),
+
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PLE_CACHE_LINE_RQST_COMPLETED,
+		minv, maxv, "PLE_CACHE_LINE_RQST_COMPLETED", "PLE (Preload "
+		"engine) cache line request completed"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PLE_CACHE_LINE_RQST_SKIPPED, minv,
+		maxv, "PLE_CACHE_LINE_RQST_SKIPPED", "PLE cache line "
+		"request skipped"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PLE_FIFO_FLUSH, minv, maxv,
+		"PLE_FIFO_FLUSH", "PLE FIFO flush"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PLE_RQST_COMPLETED, minv, maxv,
+		"PLE_RQST_COMPLETED", "PLE request completed"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PLE_FIFO_OVERFLOW, minv, maxv,
+		"PLE_FIFO_OVERFLOW", "PLE FIFO overflow"),
+	PERF_EVENT_DESC_ENTRY(ARMV7_PERFCTR_PLE_RQST_PROG, minv, maxv,
+		"PLE_RQST_PROG", "PLE request programmed")
+};
+
+
+/* ********************************************************** */
+
 /*
  * Cortex-A9 HW events mapping
  */
@@ -2094,6 +2410,10 @@ init_hw_perf_events(void)
 			memcpy(armpmu_perf_cache_map, armv6_perf_cache_map,
 					sizeof(armv6_perf_cache_map));
 			perf_max_events	= armv6pmu.num_events;
+
+			perf_event_add_events(&perf_events_arm,
+				armv6_event_description,
+				ARRAY_SIZE(armv6_event_description));
 			break;
 		case 0xB020:	/* ARM11mpcore */
 			armpmu = &armv6mpcore_pmu;
@@ -2113,6 +2433,13 @@ init_hw_perf_events(void)
 			    supported */
 			armv7pmu.num_events = armv7_reset_read_pmnc();
 			perf_max_events = armv7pmu.num_events;
+
+			perf_event_add_events(&perf_events_arm,
+				armv7_event_description,
+				ARRAY_SIZE(armv7_event_description));
+			perf_event_add_events(&perf_events_arm,
+				cortexa8_event_description,
+				ARRAY_SIZE(cortexa8_event_description));
 			break;
 		case 0xC090:	/* Cortex-A9 */
 			armv7pmu.name = ARMV7_PMU_CORTEX_A9_NAME;
@@ -2121,6 +2448,12 @@ init_hw_perf_events(void)
 			armv7pmu.event_map = armv7_a9_pmu_event_map;
 			armpmu = &armv7pmu;
 
+			perf_event_add_events(&perf_events_arm,
+				armv7_event_description,
+				ARRAY_SIZE(armv7_event_description));
+			perf_event_add_events(&perf_events_arm,
+				cortexa9_event_description,
+				ARRAY_SIZE(cortexa9_event_description));
 			/* Reset PMNC and read the nb of CNTx counters
 			    supported */
 			armv7pmu.num_events = armv7_reset_read_pmnc();
-- 
1.5.4.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S932980AbZFQL5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbZFQL5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763497AbZFQL41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:56:27 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55624 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbZFQL4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:56:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19000.55473.26174.331511@cargo.ozlabs.ibm.com>
Date: Wed, 17 Jun 2009 21:51:13 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 2/6] perf_counter: powerpc: Use unsigned long for register and constraint values
In-Reply-To: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the powerpc perf_counter back-end to use unsigned long
types for hardware register values and for the value/mask pairs used
in checking whether a given set of events fit within the hardware
constraints.  This is in preparation for adding support for the PMU
on some 32-bit powerpc processors.  On 32-bit processors the hardware
registers are only 32 bits wide, and the PMU structure is generally
simpler, so 32 bits should be ample for expressing the hardware
constraints.  On 64-bit processors, unsigned long is 64 bits wide,
so using unsigned long vs. u64 (unsigned long long) makes no actual
difference.

This makes some other very minor changes: adjusting whitespace to line
things up in initialized structures, and simplifying some code in
hw_perf_disable().

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/include/asm/perf_counter.h |   35 +++++++------
 arch/powerpc/kernel/perf_counter.c      |   20 +++----
 arch/powerpc/kernel/power4-pmu.c        |   74 ++++++++++++++-------------
 arch/powerpc/kernel/power5+-pmu.c       |   79 +++++++++++++++--------------
 arch/powerpc/kernel/power5-pmu.c        |   83 ++++++++++++++++---------------
 arch/powerpc/kernel/power6-pmu.c        |   57 +++++++++++----------
 arch/powerpc/kernel/power7-pmu.c        |   46 +++++++++--------
 arch/powerpc/kernel/ppc970-pmu.c        |   47 +++++++++--------
 8 files changed, 229 insertions(+), 212 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index 2c2d9f6..2ceb0fe 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -21,21 +21,22 @@
  * describe the PMU on a particular POWER-family CPU.
  */
 struct power_pmu {
-	int	n_counter;
-	int	max_alternatives;
-	u64	add_fields;
-	u64	test_adder;
-	int	(*compute_mmcr)(u64 events[], int n_ev,
-				unsigned int hwc[], u64 mmcr[]);
-	int	(*get_constraint)(u64 event, u64 *mskp, u64 *valp);
-	int	(*get_alternatives)(u64 event, unsigned int flags,
-				    u64 alt[]);
-	void	(*disable_pmc)(unsigned int pmc, u64 mmcr[]);
-	int	(*limited_pmc_event)(u64 event);
-	u32	flags;
-	int	n_generic;
-	int	*generic_events;
-	int	(*cache_events)[PERF_COUNT_HW_CACHE_MAX]
+	int		n_counter;
+	int		max_alternatives;
+	unsigned long	add_fields;
+	unsigned long	test_adder;
+	int		(*compute_mmcr)(u64 events[], int n_ev,
+				unsigned int hwc[], unsigned long mmcr[]);
+	int		(*get_constraint)(u64 event, unsigned long *mskp,
+				unsigned long *valp);
+	int		(*get_alternatives)(u64 event, unsigned int flags,
+				u64 alt[]);
+	void		(*disable_pmc)(unsigned int pmc, unsigned long mmcr[]);
+	int		(*limited_pmc_event)(u64 event);
+	u32		flags;
+	int		n_generic;
+	int		*generic_events;
+	int		(*cache_events)[PERF_COUNT_HW_CACHE_MAX]
 			       [PERF_COUNT_HW_CACHE_OP_MAX]
 			       [PERF_COUNT_HW_CACHE_RESULT_MAX];
 };
@@ -68,8 +69,8 @@ extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 #endif
 
 /*
- * The power_pmu.get_constraint function returns a 64-bit value and
- * a 64-bit mask that express the constraints between this event and
+ * The power_pmu.get_constraint function returns a 32/64-bit value and
+ * a 32/64-bit mask that express the constraints between this event and
  * other events.
  *
  * The value and mask are divided up into (non-overlapping) bitfields
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index e6dc185..0249252 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -29,7 +29,7 @@ struct cpu_hw_counters {
 	struct perf_counter *counter[MAX_HWCOUNTERS];
 	u64 events[MAX_HWCOUNTERS];
 	unsigned int flags[MAX_HWCOUNTERS];
-	u64 mmcr[3];
+	unsigned long mmcr[3];
 	struct perf_counter *limited_counter[MAX_LIMITED_HWCOUNTERS];
 	u8  limited_hwidx[MAX_LIMITED_HWCOUNTERS];
 };
@@ -135,15 +135,15 @@ static void write_pmc(int idx, unsigned long val)
 static int power_check_constraints(u64 event[], unsigned int cflags[],
 				   int n_ev)
 {
-	u64 mask, value, nv;
+	unsigned long mask, value, nv;
 	u64 alternatives[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
-	u64 amasks[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
-	u64 avalues[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
-	u64 smasks[MAX_HWCOUNTERS], svalues[MAX_HWCOUNTERS];
+	unsigned long amasks[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	unsigned long avalues[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	unsigned long smasks[MAX_HWCOUNTERS], svalues[MAX_HWCOUNTERS];
 	int n_alt[MAX_HWCOUNTERS], choice[MAX_HWCOUNTERS];
 	int i, j;
-	u64 addf = ppmu->add_fields;
-	u64 tadd = ppmu->test_adder;
+	unsigned long addf = ppmu->add_fields;
+	unsigned long tadd = ppmu->test_adder;
 
 	if (n_ev > ppmu->n_counter)
 		return -1;
@@ -403,14 +403,12 @@ static void write_mmcr0(struct cpu_hw_counters *cpuhw, unsigned long mmcr0)
 void hw_perf_disable(void)
 {
 	struct cpu_hw_counters *cpuhw;
-	unsigned long ret;
 	unsigned long flags;
 
 	local_irq_save(flags);
 	cpuhw = &__get_cpu_var(cpu_hw_counters);
 
-	ret = cpuhw->disabled;
-	if (!ret) {
+	if (!cpuhw->disabled) {
 		cpuhw->disabled = 1;
 		cpuhw->n_added = 0;
 
@@ -1015,7 +1013,7 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	u64 period = counter->hw.sample_period;
 	s64 prev, delta, left;
 	int record = 0;
-	u64 mmcra, sdsync;
+	unsigned long mmcra, sdsync;
 
 	/* we don't have to worry about interrupts here */
 	prev = atomic64_read(&counter->hw.prev_count);
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
index 07bd308..81a1708 100644
--- a/arch/powerpc/kernel/power4-pmu.c
+++ b/arch/powerpc/kernel/power4-pmu.c
@@ -179,22 +179,22 @@ static short mmcr1_adder_bits[8] = {
  */
 
 static struct unitinfo {
-	u64	value, mask;
-	int	unit;
-	int	lowerbit;
+	unsigned long	value, mask;
+	int		unit;
+	int		lowerbit;
 } p4_unitinfo[16] = {
-	[PM_FPU]  = { 0x44000000000000ull, 0x88000000000000ull, PM_FPU, 0 },
-	[PM_ISU1] = { 0x20080000000000ull, 0x88000000000000ull, PM_ISU1, 0 },
+	[PM_FPU]  = { 0x44000000000000ul, 0x88000000000000ul, PM_FPU, 0 },
+	[PM_ISU1] = { 0x20080000000000ul, 0x88000000000000ul, PM_ISU1, 0 },
 	[PM_ISU1_ALT] =
-		    { 0x20080000000000ull, 0x88000000000000ull, PM_ISU1, 0 },
-	[PM_IFU]  = { 0x02200000000000ull, 0x08820000000000ull, PM_IFU, 41 },
+		    { 0x20080000000000ul, 0x88000000000000ul, PM_ISU1, 0 },
+	[PM_IFU]  = { 0x02200000000000ul, 0x08820000000000ul, PM_IFU, 41 },
 	[PM_IFU_ALT] =
-		    { 0x02200000000000ull, 0x08820000000000ull, PM_IFU, 41 },
-	[PM_IDU0] = { 0x10100000000000ull, 0x80840000000000ull, PM_IDU0, 1 },
-	[PM_ISU2] = { 0x10140000000000ull, 0x80840000000000ull, PM_ISU2, 0 },
-	[PM_LSU0] = { 0x01400000000000ull, 0x08800000000000ull, PM_LSU0, 0 },
-	[PM_LSU1] = { 0x00000000000000ull, 0x00010000000000ull, PM_LSU1, 40 },
-	[PM_GPS]  = { 0x00000000000000ull, 0x00000000000000ull, PM_GPS, 0 }
+		    { 0x02200000000000ul, 0x08820000000000ul, PM_IFU, 41 },
+	[PM_IDU0] = { 0x10100000000000ul, 0x80840000000000ul, PM_IDU0, 1 },
+	[PM_ISU2] = { 0x10140000000000ul, 0x80840000000000ul, PM_ISU2, 0 },
+	[PM_LSU0] = { 0x01400000000000ul, 0x08800000000000ul, PM_LSU0, 0 },
+	[PM_LSU1] = { 0x00000000000000ul, 0x00010000000000ul, PM_LSU1, 40 },
+	[PM_GPS]  = { 0x00000000000000ul, 0x00000000000000ul, PM_GPS, 0 }
 };
 
 static unsigned char direct_marked_event[8] = {
@@ -249,10 +249,11 @@ static int p4_marked_instr_event(u64 event)
 	return (mask >> (byte * 8 + bit)) & 1;
 }
 
-static int p4_get_constraint(u64 event, u64 *maskp, u64 *valp)
+static int p4_get_constraint(u64 event, unsigned long *maskp,
+			     unsigned long *valp)
 {
 	int pmc, byte, unit, lower, sh;
-	u64 mask = 0, value = 0;
+	unsigned long mask = 0, value = 0;
 	int grp = -1;
 
 	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
@@ -282,14 +283,14 @@ static int p4_get_constraint(u64 event, u64 *maskp, u64 *valp)
 		value |= p4_unitinfo[unit].value;
 		sh = p4_unitinfo[unit].lowerbit;
 		if (sh > 1)
-			value |= (u64)lower << sh;
+			value |= (unsigned long)lower << sh;
 		else if (lower != sh)
 			return -1;
 		unit = p4_unitinfo[unit].unit;
 
 		/* Set byte lane select field */
 		mask  |= 0xfULL << (28 - 4 * byte);
-		value |= (u64)unit << (28 - 4 * byte);
+		value |= (unsigned long)unit << (28 - 4 * byte);
 	}
 	if (grp == 0) {
 		/* increment PMC1/2/5/6 field */
@@ -353,9 +354,9 @@ static int p4_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 }
 
 static int p4_compute_mmcr(u64 event[], int n_ev,
-			   unsigned int hwc[], u64 mmcr[])
+			   unsigned int hwc[], unsigned long mmcr[])
 {
-	u64 mmcr0 = 0, mmcr1 = 0, mmcra = 0;
+	unsigned long mmcr0 = 0, mmcr1 = 0, mmcra = 0;
 	unsigned int pmc, unit, byte, psel, lower;
 	unsigned int ttm, grp;
 	unsigned int pmc_inuse = 0;
@@ -429,9 +430,11 @@ static int p4_compute_mmcr(u64 event[], int n_ev,
 		return -1;
 
 	/* Set TTMxSEL fields.  Note, units 1-3 => TTM0SEL codes 0-2 */
-	mmcr1 |= (u64)(unituse[3] * 2 + unituse[2]) << MMCR1_TTM0SEL_SH;
-	mmcr1 |= (u64)(unituse[7] * 3 + unituse[6] * 2) << MMCR1_TTM1SEL_SH;
-	mmcr1 |= (u64)unituse[9] << MMCR1_TTM2SEL_SH;
+	mmcr1 |= (unsigned long)(unituse[3] * 2 + unituse[2])
+		<< MMCR1_TTM0SEL_SH;
+	mmcr1 |= (unsigned long)(unituse[7] * 3 + unituse[6] * 2)
+		<< MMCR1_TTM1SEL_SH;
+	mmcr1 |= (unsigned long)unituse[9] << MMCR1_TTM2SEL_SH;
 
 	/* Set TTCxSEL fields. */
 	if (unitlower & 0xe)
@@ -456,7 +459,8 @@ static int p4_compute_mmcr(u64 event[], int n_ev,
 				ttm = unit - 1;		/* 2->1, 3->2 */
 			else
 				ttm = unit >> 2;
-			mmcr1 |= (u64)ttm << (MMCR1_TD_CP_DBG0SEL_SH - 2*byte);
+			mmcr1 |= (unsigned long)ttm
+				<< (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
 		}
 	}
 
@@ -519,7 +523,7 @@ static int p4_compute_mmcr(u64 event[], int n_ev,
 	return 0;
 }
 
-static void p4_disable_pmc(unsigned int pmc, u64 mmcr[])
+static void p4_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 {
 	/*
 	 * Setting the PMCxSEL field to 0 disables PMC x.
@@ -584,15 +588,15 @@ static int power4_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 };
 
 struct power_pmu power4_pmu = {
-	.n_counter = 8,
-	.max_alternatives = 5,
-	.add_fields = 0x0000001100005555ull,
-	.test_adder = 0x0011083300000000ull,
-	.compute_mmcr = p4_compute_mmcr,
-	.get_constraint = p4_get_constraint,
-	.get_alternatives = p4_get_alternatives,
-	.disable_pmc = p4_disable_pmc,
-	.n_generic = ARRAY_SIZE(p4_generic_events),
-	.generic_events = p4_generic_events,
-	.cache_events = &power4_cache_events,
+	.n_counter		= 8,
+	.max_alternatives	= 5,
+	.add_fields		= 0x0000001100005555ul,
+	.test_adder		= 0x0011083300000000ul,
+	.compute_mmcr		= p4_compute_mmcr,
+	.get_constraint		= p4_get_constraint,
+	.get_alternatives	= p4_get_alternatives,
+	.disable_pmc		= p4_disable_pmc,
+	.n_generic		= ARRAY_SIZE(p4_generic_events),
+	.generic_events		= p4_generic_events,
+	.cache_events		= &power4_cache_events,
 };
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index 41e5d2d..aef144d 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -126,20 +126,21 @@ static const int grsel_shift[8] = {
 };
 
 /* Masks and values for using events from the various units */
-static u64 unit_cons[PM_LASTUNIT+1][2] = {
-	[PM_FPU] =   { 0x3200000000ull, 0x0100000000ull },
-	[PM_ISU0] =  { 0x0200000000ull, 0x0080000000ull },
-	[PM_ISU1] =  { 0x3200000000ull, 0x3100000000ull },
-	[PM_IFU] =   { 0x3200000000ull, 0x2100000000ull },
-	[PM_IDU] =   { 0x0e00000000ull, 0x0040000000ull },
-	[PM_GRS] =   { 0x0e00000000ull, 0x0c40000000ull },
+static unsigned long unit_cons[PM_LASTUNIT+1][2] = {
+	[PM_FPU] =   { 0x3200000000ul, 0x0100000000ul },
+	[PM_ISU0] =  { 0x0200000000ul, 0x0080000000ul },
+	[PM_ISU1] =  { 0x3200000000ul, 0x3100000000ul },
+	[PM_IFU] =   { 0x3200000000ul, 0x2100000000ul },
+	[PM_IDU] =   { 0x0e00000000ul, 0x0040000000ul },
+	[PM_GRS] =   { 0x0e00000000ul, 0x0c40000000ul },
 };
 
-static int power5p_get_constraint(u64 event, u64 *maskp, u64 *valp)
+static int power5p_get_constraint(u64 event, unsigned long *maskp,
+				  unsigned long *valp)
 {
 	int pmc, byte, unit, sh;
 	int bit, fmask;
-	u64 mask = 0, value = 0;
+	unsigned long mask = 0, value = 0;
 
 	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
 	if (pmc) {
@@ -171,17 +172,18 @@ static int power5p_get_constraint(u64 event, u64 *maskp, u64 *valp)
 			bit = event & 7;
 			fmask = (bit == 6)? 7: 3;
 			sh = grsel_shift[bit];
-			mask |= (u64)fmask << sh;
-			value |= (u64)((event >> PM_GRS_SH) & fmask) << sh;
+			mask |= (unsigned long)fmask << sh;
+			value |= (unsigned long)((event >> PM_GRS_SH) & fmask)
+				<< sh;
 		}
 		/* Set byte lane select field */
-		mask  |= 0xfULL << (24 - 4 * byte);
-		value |= (u64)unit << (24 - 4 * byte);
+		mask  |= 0xfUL << (24 - 4 * byte);
+		value |= (unsigned long)unit << (24 - 4 * byte);
 	}
 	if (pmc < 5) {
 		/* need a counter from PMC1-4 set */
-		mask  |= 0x8000000000000ull;
-		value |= 0x1000000000000ull;
+		mask  |= 0x8000000000000ul;
+		value |= 0x1000000000000ul;
 	}
 	*maskp = mask;
 	*valp = value;
@@ -452,10 +454,10 @@ static int power5p_marked_instr_event(u64 event)
 }
 
 static int power5p_compute_mmcr(u64 event[], int n_ev,
-				unsigned int hwc[], u64 mmcr[])
+				unsigned int hwc[], unsigned long mmcr[])
 {
-	u64 mmcr1 = 0;
-	u64 mmcra = 0;
+	unsigned long mmcr1 = 0;
+	unsigned long mmcra = 0;
 	unsigned int pmc, unit, byte, psel;
 	unsigned int ttm;
 	int i, isbus, bit, grsel;
@@ -517,7 +519,7 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 			continue;
 		if (ttmuse++)
 			return -1;
-		mmcr1 |= (u64)i << MMCR1_TTM0SEL_SH;
+		mmcr1 |= (unsigned long)i << MMCR1_TTM0SEL_SH;
 	}
 	ttmuse = 0;
 	for (; i <= PM_GRS; ++i) {
@@ -525,7 +527,7 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 			continue;
 		if (ttmuse++)
 			return -1;
-		mmcr1 |= (u64)(i & 3) << MMCR1_TTM1SEL_SH;
+		mmcr1 |= (unsigned long)(i & 3) << MMCR1_TTM1SEL_SH;
 	}
 	if (ttmuse > 1)
 		return -1;
@@ -540,10 +542,11 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 			unit = PM_ISU0_ALT;
 		} else if (unit == PM_LSU1 + 1) {
 			/* select lower word of LSU1 for this byte */
-			mmcr1 |= 1ull << (MMCR1_TTM3SEL_SH + 3 - byte);
+			mmcr1 |= 1ul << (MMCR1_TTM3SEL_SH + 3 - byte);
 		}
 		ttm = unit >> 2;
-		mmcr1 |= (u64)ttm << (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
+		mmcr1 |= (unsigned long)ttm
+			<< (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
 	}
 
 	/* Second pass: assign PMCs, set PMCxSEL and PMCx_ADDER_SEL fields */
@@ -568,7 +571,7 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 			if (isbus && (byte & 2) &&
 			    (psel == 8 || psel == 0x10 || psel == 0x28))
 				/* add events on higher-numbered bus */
-				mmcr1 |= 1ull << (MMCR1_PMC1_ADDER_SEL_SH - pmc);
+				mmcr1 |= 1ul << (MMCR1_PMC1_ADDER_SEL_SH - pmc);
 		} else {
 			/* Instructions or run cycles on PMC5/6 */
 			--pmc;
@@ -576,7 +579,7 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 		if (isbus && unit == PM_GRS) {
 			bit = psel & 7;
 			grsel = (event[i] >> PM_GRS_SH) & PM_GRS_MSK;
-			mmcr1 |= (u64)grsel << grsel_shift[bit];
+			mmcr1 |= (unsigned long)grsel << grsel_shift[bit];
 		}
 		if (power5p_marked_instr_event(event[i]))
 			mmcra |= MMCRA_SAMPLE_ENABLE;
@@ -599,7 +602,7 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 	return 0;
 }
 
-static void power5p_disable_pmc(unsigned int pmc, u64 mmcr[])
+static void power5p_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 {
 	if (pmc <= 3)
 		mmcr[1] &= ~(0x7fUL << MMCR1_PMCSEL_SH(pmc));
@@ -655,17 +658,17 @@ static int power5p_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 };
 
 struct power_pmu power5p_pmu = {
-	.n_counter = 6,
-	.max_alternatives = MAX_ALT,
-	.add_fields = 0x7000000000055ull,
-	.test_adder = 0x3000040000000ull,
-	.compute_mmcr = power5p_compute_mmcr,
-	.get_constraint = power5p_get_constraint,
-	.get_alternatives = power5p_get_alternatives,
-	.disable_pmc = power5p_disable_pmc,
-	.limited_pmc_event = power5p_limited_pmc_event,
-	.flags = PPMU_LIMITED_PMC5_6,
-	.n_generic = ARRAY_SIZE(power5p_generic_events),
-	.generic_events = power5p_generic_events,
-	.cache_events = &power5p_cache_events,
+	.n_counter		= 6,
+	.max_alternatives	= MAX_ALT,
+	.add_fields		= 0x7000000000055ul,
+	.test_adder		= 0x3000040000000ul,
+	.compute_mmcr		= power5p_compute_mmcr,
+	.get_constraint		= power5p_get_constraint,
+	.get_alternatives	= power5p_get_alternatives,
+	.disable_pmc		= power5p_disable_pmc,
+	.limited_pmc_event	= power5p_limited_pmc_event,
+	.flags			= PPMU_LIMITED_PMC5_6,
+	.n_generic		= ARRAY_SIZE(power5p_generic_events),
+	.generic_events		= power5p_generic_events,
+	.cache_events		= &power5p_cache_events,
 };
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index 05600b6..8694c73 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -130,20 +130,21 @@ static const int grsel_shift[8] = {
 };
 
 /* Masks and values for using events from the various units */
-static u64 unit_cons[PM_LASTUNIT+1][2] = {
-	[PM_FPU] =   { 0xc0002000000000ull, 0x00001000000000ull },
-	[PM_ISU0] =  { 0x00002000000000ull, 0x00000800000000ull },
-	[PM_ISU1] =  { 0xc0002000000000ull, 0xc0001000000000ull },
-	[PM_IFU] =   { 0xc0002000000000ull, 0x80001000000000ull },
-	[PM_IDU] =   { 0x30002000000000ull, 0x00000400000000ull },
-	[PM_GRS] =   { 0x30002000000000ull, 0x30000400000000ull },
+static unsigned long unit_cons[PM_LASTUNIT+1][2] = {
+	[PM_FPU] =   { 0xc0002000000000ul, 0x00001000000000ul },
+	[PM_ISU0] =  { 0x00002000000000ul, 0x00000800000000ul },
+	[PM_ISU1] =  { 0xc0002000000000ul, 0xc0001000000000ul },
+	[PM_IFU] =   { 0xc0002000000000ul, 0x80001000000000ul },
+	[PM_IDU] =   { 0x30002000000000ul, 0x00000400000000ul },
+	[PM_GRS] =   { 0x30002000000000ul, 0x30000400000000ul },
 };
 
-static int power5_get_constraint(u64 event, u64 *maskp, u64 *valp)
+static int power5_get_constraint(u64 event, unsigned long *maskp,
+				 unsigned long *valp)
 {
 	int pmc, byte, unit, sh;
 	int bit, fmask;
-	u64 mask = 0, value = 0;
+	unsigned long mask = 0, value = 0;
 	int grp = -1;
 
 	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
@@ -178,8 +179,9 @@ static int power5_get_constraint(u64 event, u64 *maskp, u64 *valp)
 			bit = event & 7;
 			fmask = (bit == 6)? 7: 3;
 			sh = grsel_shift[bit];
-			mask |= (u64)fmask << sh;
-			value |= (u64)((event >> PM_GRS_SH) & fmask) << sh;
+			mask |= (unsigned long)fmask << sh;
+			value |= (unsigned long)((event >> PM_GRS_SH) & fmask)
+				<< sh;
 		}
 		/*
 		 * Bus events on bytes 0 and 2 can be counted
@@ -188,22 +190,22 @@ static int power5_get_constraint(u64 event, u64 *maskp, u64 *valp)
 		if (!pmc)
 			grp = byte & 1;
 		/* Set byte lane select field */
-		mask  |= 0xfULL << (24 - 4 * byte);
-		value |= (u64)unit << (24 - 4 * byte);
+		mask  |= 0xfUL << (24 - 4 * byte);
+		value |= (unsigned long)unit << (24 - 4 * byte);
 	}
 	if (grp == 0) {
 		/* increment PMC1/2 field */
-		mask  |= 0x200000000ull;
-		value |= 0x080000000ull;
+		mask  |= 0x200000000ul;
+		value |= 0x080000000ul;
 	} else if (grp == 1) {
 		/* increment PMC3/4 field */
-		mask  |= 0x40000000ull;
-		value |= 0x10000000ull;
+		mask  |= 0x40000000ul;
+		value |= 0x10000000ul;
 	}
 	if (pmc < 5) {
 		/* need a counter from PMC1-4 set */
-		mask  |= 0x8000000000000ull;
-		value |= 0x1000000000000ull;
+		mask  |= 0x8000000000000ul;
+		value |= 0x1000000000000ul;
 	}
 	*maskp = mask;
 	*valp = value;
@@ -383,10 +385,10 @@ static int power5_marked_instr_event(u64 event)
 }
 
 static int power5_compute_mmcr(u64 event[], int n_ev,
-			       unsigned int hwc[], u64 mmcr[])
+			       unsigned int hwc[], unsigned long mmcr[])
 {
-	u64 mmcr1 = 0;
-	u64 mmcra = 0;
+	unsigned long mmcr1 = 0;
+	unsigned long mmcra = 0;
 	unsigned int pmc, unit, byte, psel;
 	unsigned int ttm, grp;
 	int i, isbus, bit, grsel;
@@ -457,7 +459,7 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 			continue;
 		if (ttmuse++)
 			return -1;
-		mmcr1 |= (u64)i << MMCR1_TTM0SEL_SH;
+		mmcr1 |= (unsigned long)i << MMCR1_TTM0SEL_SH;
 	}
 	ttmuse = 0;
 	for (; i <= PM_GRS; ++i) {
@@ -465,7 +467,7 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 			continue;
 		if (ttmuse++)
 			return -1;
-		mmcr1 |= (u64)(i & 3) << MMCR1_TTM1SEL_SH;
+		mmcr1 |= (unsigned long)(i & 3) << MMCR1_TTM1SEL_SH;
 	}
 	if (ttmuse > 1)
 		return -1;
@@ -480,10 +482,11 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 			unit = PM_ISU0_ALT;
 		} else if (unit == PM_LSU1 + 1) {
 			/* select lower word of LSU1 for this byte */
-			mmcr1 |= 1ull << (MMCR1_TTM3SEL_SH + 3 - byte);
+			mmcr1 |= 1ul << (MMCR1_TTM3SEL_SH + 3 - byte);
 		}
 		ttm = unit >> 2;
-		mmcr1 |= (u64)ttm << (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
+		mmcr1 |= (unsigned long)ttm
+			<< (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
 	}
 
 	/* Second pass: assign PMCs, set PMCxSEL and PMCx_ADDER_SEL fields */
@@ -513,7 +516,7 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 			--pmc;
 			if ((psel == 8 || psel == 0x10) && isbus && (byte & 2))
 				/* add events on higher-numbered bus */
-				mmcr1 |= 1ull << (MMCR1_PMC1_ADDER_SEL_SH - pmc);
+				mmcr1 |= 1ul << (MMCR1_PMC1_ADDER_SEL_SH - pmc);
 		} else {
 			/* Instructions or run cycles on PMC5/6 */
 			--pmc;
@@ -521,7 +524,7 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 		if (isbus && unit == PM_GRS) {
 			bit = psel & 7;
 			grsel = (event[i] >> PM_GRS_SH) & PM_GRS_MSK;
-			mmcr1 |= (u64)grsel << grsel_shift[bit];
+			mmcr1 |= (unsigned long)grsel << grsel_shift[bit];
 		}
 		if (power5_marked_instr_event(event[i]))
 			mmcra |= MMCRA_SAMPLE_ENABLE;
@@ -541,7 +544,7 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 	return 0;
 }
 
-static void power5_disable_pmc(unsigned int pmc, u64 mmcr[])
+static void power5_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 {
 	if (pmc <= 3)
 		mmcr[1] &= ~(0x7fUL << MMCR1_PMCSEL_SH(pmc));
@@ -597,15 +600,15 @@ static int power5_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 };
 
 struct power_pmu power5_pmu = {
-	.n_counter = 6,
-	.max_alternatives = MAX_ALT,
-	.add_fields = 0x7000090000555ull,
-	.test_adder = 0x3000490000000ull,
-	.compute_mmcr = power5_compute_mmcr,
-	.get_constraint = power5_get_constraint,
-	.get_alternatives = power5_get_alternatives,
-	.disable_pmc = power5_disable_pmc,
-	.n_generic = ARRAY_SIZE(power5_generic_events),
-	.generic_events = power5_generic_events,
-	.cache_events = &power5_cache_events,
+	.n_counter		= 6,
+	.max_alternatives	= MAX_ALT,
+	.add_fields		= 0x7000090000555ul,
+	.test_adder		= 0x3000490000000ul,
+	.compute_mmcr		= power5_compute_mmcr,
+	.get_constraint		= power5_get_constraint,
+	.get_alternatives	= power5_get_alternatives,
+	.disable_pmc		= power5_disable_pmc,
+	.n_generic		= ARRAY_SIZE(power5_generic_events),
+	.generic_events		= power5_generic_events,
+	.cache_events		= &power5_cache_events,
 };
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index 46f74be..8898622 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -41,9 +41,9 @@
 #define MMCR1_NESTSEL_SH	45
 #define MMCR1_NESTSEL_MSK	0x7
 #define MMCR1_NESTSEL(m)	(((m) >> MMCR1_NESTSEL_SH) & MMCR1_NESTSEL_MSK)
-#define MMCR1_PMC1_LLA		((u64)1 << 44)
-#define MMCR1_PMC1_LLA_VALUE	((u64)1 << 39)
-#define MMCR1_PMC1_ADDR_SEL	((u64)1 << 35)
+#define MMCR1_PMC1_LLA		(1ul << 44)
+#define MMCR1_PMC1_LLA_VALUE	(1ul << 39)
+#define MMCR1_PMC1_ADDR_SEL	(1ul << 35)
 #define MMCR1_PMC1SEL_SH	24
 #define MMCR1_PMCSEL_SH(n)	(MMCR1_PMC1SEL_SH - (n) * 8)
 #define MMCR1_PMCSEL_MSK	0xff
@@ -173,10 +173,10 @@ static int power6_marked_instr_event(u64 event)
  * Assign PMC numbers and compute MMCR1 value for a set of events
  */
 static int p6_compute_mmcr(u64 event[], int n_ev,
-			   unsigned int hwc[], u64 mmcr[])
+			   unsigned int hwc[], unsigned long mmcr[])
 {
-	u64 mmcr1 = 0;
-	u64 mmcra = 0;
+	unsigned long mmcr1 = 0;
+	unsigned long mmcra = 0;
 	int i;
 	unsigned int pmc, ev, b, u, s, psel;
 	unsigned int ttmset = 0;
@@ -215,7 +215,7 @@ static int p6_compute_mmcr(u64 event[], int n_ev,
 			/* check for conflict on this byte of event bus */
 			if ((ttmset & (1 << b)) && MMCR1_TTMSEL(mmcr1, b) != u)
 				return -1;
-			mmcr1 |= (u64)u << MMCR1_TTMSEL_SH(b);
+			mmcr1 |= (unsigned long)u << MMCR1_TTMSEL_SH(b);
 			ttmset |= 1 << b;
 			if (u == 5) {
 				/* Nest events have a further mux */
@@ -224,7 +224,7 @@ static int p6_compute_mmcr(u64 event[], int n_ev,
 				    MMCR1_NESTSEL(mmcr1) != s)
 					return -1;
 				ttmset |= 0x10;
-				mmcr1 |= (u64)s << MMCR1_NESTSEL_SH;
+				mmcr1 |= (unsigned long)s << MMCR1_NESTSEL_SH;
 			}
 			if (0x30 <= psel && psel <= 0x3d) {
 				/* these need the PMCx_ADDR_SEL bits */
@@ -243,7 +243,7 @@ static int p6_compute_mmcr(u64 event[], int n_ev,
 		if (power6_marked_instr_event(event[i]))
 			mmcra |= MMCRA_SAMPLE_ENABLE;
 		if (pmc < 4)
-			mmcr1 |= (u64)psel << MMCR1_PMCSEL_SH(pmc);
+			mmcr1 |= (unsigned long)psel << MMCR1_PMCSEL_SH(pmc);
 	}
 	mmcr[0] = 0;
 	if (pmc_inuse & 1)
@@ -265,10 +265,11 @@ static int p6_compute_mmcr(u64 event[], int n_ev,
  *	20-23, 24-27, 28-31 ditto for bytes 1, 2, 3
  *	32-34	select field: nest (subunit) event selector
  */
-static int p6_get_constraint(u64 event, u64 *maskp, u64 *valp)
+static int p6_get_constraint(u64 event, unsigned long *maskp,
+			     unsigned long *valp)
 {
 	int pmc, byte, sh, subunit;
-	u64 mask = 0, value = 0;
+	unsigned long mask = 0, value = 0;
 
 	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
 	if (pmc) {
@@ -282,11 +283,11 @@ static int p6_get_constraint(u64 event, u64 *maskp, u64 *valp)
 		byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
 		sh = byte * 4 + (16 - PM_UNIT_SH);
 		mask |= PM_UNIT_MSKS << sh;
-		value |= (u64)(event & PM_UNIT_MSKS) << sh;
+		value |= (unsigned long)(event & PM_UNIT_MSKS) << sh;
 		if ((event & PM_UNIT_MSKS) == (5 << PM_UNIT_SH)) {
 			subunit = (event >> PM_SUBUNIT_SH) & PM_SUBUNIT_MSK;
-			mask  |= (u64)PM_SUBUNIT_MSK << 32;
-			value |= (u64)subunit << 32;
+			mask  |= (unsigned long)PM_SUBUNIT_MSK << 32;
+			value |= (unsigned long)subunit << 32;
 		}
 	}
 	if (pmc <= 4) {
@@ -458,7 +459,7 @@ static int p6_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 	return nalt;
 }
 
-static void p6_disable_pmc(unsigned int pmc, u64 mmcr[])
+static void p6_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 {
 	/* Set PMCxSEL to 0 to disable PMCx */
 	if (pmc <= 3)
@@ -516,17 +517,17 @@ static int power6_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 };
 
 struct power_pmu power6_pmu = {
-	.n_counter = 6,
-	.max_alternatives = MAX_ALT,
-	.add_fields = 0x1555,
-	.test_adder = 0x3000,
-	.compute_mmcr = p6_compute_mmcr,
-	.get_constraint = p6_get_constraint,
-	.get_alternatives = p6_get_alternatives,
-	.disable_pmc = p6_disable_pmc,
-	.limited_pmc_event = p6_limited_pmc_event,
-	.flags = PPMU_LIMITED_PMC5_6 | PPMU_ALT_SIPR,
-	.n_generic = ARRAY_SIZE(power6_generic_events),
-	.generic_events = power6_generic_events,
-	.cache_events = &power6_cache_events,
+	.n_counter		= 6,
+	.max_alternatives	= MAX_ALT,
+	.add_fields		= 0x1555,
+	.test_adder		= 0x3000,
+	.compute_mmcr		= p6_compute_mmcr,
+	.get_constraint		= p6_get_constraint,
+	.get_alternatives	= p6_get_alternatives,
+	.disable_pmc		= p6_disable_pmc,
+	.limited_pmc_event	= p6_limited_pmc_event,
+	.flags			= PPMU_LIMITED_PMC5_6 | PPMU_ALT_SIPR,
+	.n_generic		= ARRAY_SIZE(power6_generic_events),
+	.generic_events		= power6_generic_events,
+	.cache_events		= &power6_cache_events,
 };
diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index b72e7a1..658d1ae 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -71,10 +71,11 @@
  *     0-9: Count of events needing PMC1..PMC5
  */
 
-static int power7_get_constraint(u64 event, u64 *maskp, u64 *valp)
+static int power7_get_constraint(u64 event, unsigned long *maskp,
+				 unsigned long *valp)
 {
 	int pmc, sh;
-	u64 mask = 0, value = 0;
+	unsigned long mask = 0, value = 0;
 
 	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
 	if (pmc) {
@@ -224,10 +225,10 @@ static int power7_marked_instr_event(u64 event)
 }
 
 static int power7_compute_mmcr(u64 event[], int n_ev,
-			       unsigned int hwc[], u64 mmcr[])
+			       unsigned int hwc[], unsigned long mmcr[])
 {
-	u64 mmcr1 = 0;
-	u64 mmcra = 0;
+	unsigned long mmcr1 = 0;
+	unsigned long mmcra = 0;
 	unsigned int pmc, unit, combine, l2sel, psel;
 	unsigned int pmc_inuse = 0;
 	int i;
@@ -265,11 +266,14 @@ static int power7_compute_mmcr(u64 event[], int n_ev,
 			--pmc;
 		}
 		if (pmc <= 3) {
-			mmcr1 |= (u64) unit << (MMCR1_TTM0SEL_SH - 4 * pmc);
-			mmcr1 |= (u64) combine << (MMCR1_PMC1_COMBINE_SH - pmc);
+			mmcr1 |= (unsigned long) unit
+				<< (MMCR1_TTM0SEL_SH - 4 * pmc);
+			mmcr1 |= (unsigned long) combine
+				<< (MMCR1_PMC1_COMBINE_SH - pmc);
 			mmcr1 |= psel << MMCR1_PMCSEL_SH(pmc);
 			if (unit == 6)	/* L2 events */
-				mmcr1 |= (u64) l2sel << MMCR1_L2SEL_SH;
+				mmcr1 |= (unsigned long) l2sel
+					<< MMCR1_L2SEL_SH;
 		}
 		if (power7_marked_instr_event(event[i]))
 			mmcra |= MMCRA_SAMPLE_ENABLE;
@@ -287,10 +291,10 @@ static int power7_compute_mmcr(u64 event[], int n_ev,
 	return 0;
 }
 
-static void power7_disable_pmc(unsigned int pmc, u64 mmcr[])
+static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 {
 	if (pmc <= 3)
-		mmcr[1] &= ~(0xffULL << MMCR1_PMCSEL_SH(pmc));
+		mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SH(pmc));
 }
 
 static int power7_generic_events[] = {
@@ -343,15 +347,15 @@ static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 };
 
 struct power_pmu power7_pmu = {
-	.n_counter = 6,
-	.max_alternatives = MAX_ALT + 1,
-	.add_fields = 0x1555ull,
-	.test_adder = 0x3000ull,
-	.compute_mmcr = power7_compute_mmcr,
-	.get_constraint = power7_get_constraint,
-	.get_alternatives = power7_get_alternatives,
-	.disable_pmc = power7_disable_pmc,
-	.n_generic = ARRAY_SIZE(power7_generic_events),
-	.generic_events = power7_generic_events,
-	.cache_events = &power7_cache_events,
+	.n_counter		= 6,
+	.max_alternatives	= MAX_ALT + 1,
+	.add_fields		= 0x1555ul,
+	.test_adder		= 0x3000ul,
+	.compute_mmcr		= power7_compute_mmcr,
+	.get_constraint		= power7_get_constraint,
+	.get_alternatives	= power7_get_alternatives,
+	.disable_pmc		= power7_disable_pmc,
+	.n_generic		= ARRAY_SIZE(power7_generic_events),
+	.generic_events		= power7_generic_events,
+	.cache_events		= &power7_cache_events,
 };
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index ba0a357..3ed8833 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -183,7 +183,7 @@ static int p970_marked_instr_event(u64 event)
 }
 
 /* Masks and values for using events from the various units */
-static u64 unit_cons[PM_LASTUNIT+1][2] = {
+static unsigned long unit_cons[PM_LASTUNIT+1][2] = {
 	[PM_FPU] =   { 0xc80000000000ull, 0x040000000000ull },
 	[PM_VPU] =   { 0xc80000000000ull, 0xc40000000000ull },
 	[PM_ISU] =   { 0x080000000000ull, 0x020000000000ull },
@@ -192,10 +192,11 @@ static u64 unit_cons[PM_LASTUNIT+1][2] = {
 	[PM_STS] =   { 0x380000000000ull, 0x310000000000ull },
 };
 
-static int p970_get_constraint(u64 event, u64 *maskp, u64 *valp)
+static int p970_get_constraint(u64 event, unsigned long *maskp,
+			       unsigned long *valp)
 {
 	int pmc, byte, unit, sh, spcsel;
-	u64 mask = 0, value = 0;
+	unsigned long mask = 0, value = 0;
 	int grp = -1;
 
 	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
@@ -222,7 +223,7 @@ static int p970_get_constraint(u64 event, u64 *maskp, u64 *valp)
 			grp = byte & 1;
 		/* Set byte lane select field */
 		mask  |= 0xfULL << (28 - 4 * byte);
-		value |= (u64)unit << (28 - 4 * byte);
+		value |= (unsigned long)unit << (28 - 4 * byte);
 	}
 	if (grp == 0) {
 		/* increment PMC1/2/5/6 field */
@@ -236,7 +237,7 @@ static int p970_get_constraint(u64 event, u64 *maskp, u64 *valp)
 	spcsel = (event >> PM_SPCSEL_SH) & PM_SPCSEL_MSK;
 	if (spcsel) {
 		mask  |= 3ull << 48;
-		value |= (u64)spcsel << 48;
+		value |= (unsigned long)spcsel << 48;
 	}
 	*maskp = mask;
 	*valp = value;
@@ -257,9 +258,9 @@ static int p970_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 }
 
 static int p970_compute_mmcr(u64 event[], int n_ev,
-			     unsigned int hwc[], u64 mmcr[])
+			     unsigned int hwc[], unsigned long mmcr[])
 {
-	u64 mmcr0 = 0, mmcr1 = 0, mmcra = 0;
+	unsigned long mmcr0 = 0, mmcr1 = 0, mmcra = 0;
 	unsigned int pmc, unit, byte, psel;
 	unsigned int ttm, grp;
 	unsigned int pmc_inuse = 0;
@@ -320,7 +321,7 @@ static int p970_compute_mmcr(u64 event[], int n_ev,
 			continue;
 		ttm = unitmap[i];
 		++ttmuse[(ttm >> 2) & 1];
-		mmcr1 |= (u64)(ttm & ~4) << MMCR1_TTM1SEL_SH;
+		mmcr1 |= (unsigned long)(ttm & ~4) << MMCR1_TTM1SEL_SH;
 	}
 	/* Check only one unit per TTMx */
 	if (ttmuse[0] > 1 || ttmuse[1] > 1)
@@ -340,7 +341,8 @@ static int p970_compute_mmcr(u64 event[], int n_ev,
 			if (unit == PM_LSU1L && byte >= 2)
 				mmcr1 |= 1ull << (MMCR1_TTM3SEL_SH + 3 - byte);
 		}
-		mmcr1 |= (u64)ttm << (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
+		mmcr1 |= (unsigned long)ttm
+			<< (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
 	}
 
 	/* Second pass: assign PMCs, set PMCxSEL and PMCx_ADDER_SEL fields */
@@ -386,7 +388,8 @@ static int p970_compute_mmcr(u64 event[], int n_ev,
 	for (pmc = 0; pmc < 2; ++pmc)
 		mmcr0 |= pmcsel[pmc] << (MMCR0_PMC1SEL_SH - 7 * pmc);
 	for (; pmc < 8; ++pmc)
-		mmcr1 |= (u64)pmcsel[pmc] << (MMCR1_PMC3SEL_SH - 5 * (pmc - 2));
+		mmcr1 |= (unsigned long)pmcsel[pmc]
+			<< (MMCR1_PMC3SEL_SH - 5 * (pmc - 2));
 	if (pmc_inuse & 1)
 		mmcr0 |= MMCR0_PMC1CE;
 	if (pmc_inuse & 0xfe)
@@ -401,7 +404,7 @@ static int p970_compute_mmcr(u64 event[], int n_ev,
 	return 0;
 }
 
-static void p970_disable_pmc(unsigned int pmc, u64 mmcr[])
+static void p970_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 {
 	int shift, i;
 
@@ -468,15 +471,15 @@ static int ppc970_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 };
 
 struct power_pmu ppc970_pmu = {
-	.n_counter = 8,
-	.max_alternatives = 2,
-	.add_fields = 0x001100005555ull,
-	.test_adder = 0x013300000000ull,
-	.compute_mmcr = p970_compute_mmcr,
-	.get_constraint = p970_get_constraint,
-	.get_alternatives = p970_get_alternatives,
-	.disable_pmc = p970_disable_pmc,
-	.n_generic = ARRAY_SIZE(ppc970_generic_events),
-	.generic_events = ppc970_generic_events,
-	.cache_events = &ppc970_cache_events,
+	.n_counter		= 8,
+	.max_alternatives	= 2,
+	.add_fields		= 0x001100005555ull,
+	.test_adder		= 0x013300000000ull,
+	.compute_mmcr		= p970_compute_mmcr,
+	.get_constraint		= p970_get_constraint,
+	.get_alternatives	= p970_get_alternatives,
+	.disable_pmc		= p970_disable_pmc,
+	.n_generic		= ARRAY_SIZE(ppc970_generic_events),
+	.generic_events		= ppc970_generic_events,
+	.cache_events		= &ppc970_cache_events,
 };
-- 
1.6.0.4


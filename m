Return-Path: <linux-kernel-owner+w=401wt.eu-S1765923AbZFQL5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765923AbZFQL5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764509AbZFQL4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:56:25 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55609 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769AbZFQL4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:56:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19000.55631.802122.696927@cargo.ozlabs.ibm.com>
Date: Wed, 17 Jun 2009 21:53:51 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 5/6] perf_counter: powerpc: Add processor back-end for
   MPC7450 family
In-Reply-To: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the performance monitor hardware on the
MPC7450 family of processors (7450, 7451, 7455, 7447/7457, 7447A,
7448), used in the later Apple G4 powermacs/powerbooks and other
machines.  These machines have 6 hardware counters with a unique
set of events which can be counted on each counter, with some
events being available on multiple counters.

Raw event codes for these processors are (PMC << 8) + PMCSEL.
If PMC is non-zero then the event is that selected by the given
PMCSEL value for that PMC (hardware counter).  If PMC is zero
then the event selected is one of the low-numbered ones that are
common to several PMCs.  In this case PMCSEL must be <= 22 and
the event is what that PMCSEL value would select on PMC1 (but
it may be placed any other PMC that has the same event for that
PMCSEL value).

For events that count cycles or occurrences that exceed a threshold,
the threshold requested can be specified in the 0x3f000 bits of the
raw event codes.  If the event uses the threshold multiplier bit
and that bit should be set, that is indicated with the 0x40000 bit
of the raw event code.

This fills in some of the generic cache events.  Unfortunately there
are quite a few blank spaces in the table, partly because these
processors tend to count cache hits rather than cache accesses.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/Makefile           |    2 +
 arch/powerpc/kernel/mpc7450-pmu.c      |  417 ++++++++++++++++++++++++++++++++
 arch/powerpc/platforms/Kconfig.cputype |    1 +
 3 files changed, 420 insertions(+), 0 deletions(-)
 create mode 100644 arch/powerpc/kernel/mpc7450-pmu.c

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index c5f93f0..a9f8829 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -98,6 +98,7 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
 obj-$(CONFIG_PPC_PERF_CTRS)	+= perf_counter.o
 obj64-$(CONFIG_PPC_PERF_CTRS)	+= power4-pmu.o ppc970-pmu.o power5-pmu.o \
 				   power5+-pmu.o power6-pmu.o power7-pmu.o
+obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
 
 obj-$(CONFIG_8XX_MINIMAL_FPEMU) += softemu8xx.o
 
@@ -106,6 +107,7 @@ obj-y				+= iomap.o
 endif
 
 obj-$(CONFIG_PPC64)		+= $(obj64-y)
+obj-$(CONFIG_PPC32)		+= $(obj32-y)
 
 ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC),)
 obj-y				+= ppc_save_regs.o
diff --git a/arch/powerpc/kernel/mpc7450-pmu.c b/arch/powerpc/kernel/mpc7450-pmu.c
new file mode 100644
index 0000000..75ff47f
--- /dev/null
+++ b/arch/powerpc/kernel/mpc7450-pmu.c
@@ -0,0 +1,417 @@
+/*
+ * Performance counter support for MPC7450-family processors.
+ *
+ * Copyright 2008-2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/string.h>
+#include <linux/perf_counter.h>
+#include <linux/string.h>
+#include <asm/reg.h>
+#include <asm/cputable.h>
+
+#define N_COUNTER	6	/* Number of hardware counters */
+#define MAX_ALT		3	/* Maximum number of event alternative codes */
+
+/*
+ * Bits in event code for MPC7450 family
+ */
+#define PM_THRMULT_MSKS	0x40000
+#define PM_THRESH_SH	12
+#define PM_THRESH_MSK	0x3f
+#define PM_PMC_SH	8
+#define PM_PMC_MSK	7
+#define PM_PMCSEL_MSK	0x7f
+
+/*
+ * Classify events according to how specific their PMC requirements are.
+ * Result is:
+ *	0: can go on any PMC
+ *	1: can go on PMCs 1-4
+ *	2: can go on PMCs 1,2,4
+ *	3: can go on PMCs 1 or 2
+ *	4: can only go on one PMC
+ *	-1: event code is invalid
+ */
+#define N_CLASSES	5
+
+static int mpc7450_classify_event(u32 event)
+{
+	int pmc;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	if (pmc) {
+		if (pmc > N_COUNTER)
+			return -1;
+		return 4;
+	}
+	event &= PM_PMCSEL_MSK;
+	if (event <= 1)
+		return 0;
+	if (event <= 7)
+		return 1;
+	if (event <= 13)
+		return 2;
+	if (event <= 22)
+		return 3;
+	return -1;
+}
+
+/*
+ * Events using threshold and possible threshold scale:
+ *	code	scale?	name
+ *	11e	N	PM_INSTQ_EXCEED_CYC
+ *	11f	N	PM_ALTV_IQ_EXCEED_CYC
+ *	128	Y	PM_DTLB_SEARCH_EXCEED_CYC
+ *	12b	Y	PM_LD_MISS_EXCEED_L1_CYC
+ *	220	N	PM_CQ_EXCEED_CYC
+ *	30c	N	PM_GPR_RB_EXCEED_CYC
+ *	30d	?	PM_FPR_IQ_EXCEED_CYC ?
+ *	311	Y	PM_ITLB_SEARCH_EXCEED
+ *	410	N	PM_GPR_IQ_EXCEED_CYC
+ */
+
+/*
+ * Return use of threshold and threshold scale bits:
+ * 0 = uses neither, 1 = uses threshold, 2 = uses both
+ */
+static int mpc7450_threshold_use(u32 event)
+{
+	int pmc, sel;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	sel = event & PM_PMCSEL_MSK;
+	switch (pmc) {
+	case 1:
+		if (sel == 0x1e || sel == 0x1f)
+			return 1;
+		if (sel == 0x28 || sel == 0x2b)
+			return 2;
+		break;
+	case 2:
+		if (sel == 0x20)
+			return 1;
+		break;
+	case 3:
+		if (sel == 0xc || sel == 0xd)
+			return 1;
+		if (sel == 0x11)
+			return 2;
+		break;
+	case 4:
+		if (sel == 0x10)
+			return 1;
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Layout of constraint bits:
+ * 33222222222211111111110000000000
+ * 10987654321098765432109876543210
+ *  |<    ><  > < > < ><><><><><><>
+ *  TS TV   G4   G3  G2P6P5P4P3P2P1
+ *
+ * P1 - P6
+ *	0 - 11: Count of events needing PMC1 .. PMC6
+ *
+ * G2
+ *	12 - 14: Count of events needing PMC1 or PMC2
+ *
+ * G3
+ *	16 - 18: Count of events needing PMC1, PMC2 or PMC4
+ *
+ * G4
+ *	20 - 23: Count of events needing PMC1, PMC2, PMC3 or PMC4
+ *
+ * TV
+ *	24 - 29: Threshold value requested
+ *
+ * TS
+ *	30: Threshold scale value requested
+ */
+
+static u32 pmcbits[N_COUNTER][2] = {
+	{ 0x00844002, 0x00111001 },	/* PMC1 mask, value: P1,G2,G3,G4 */
+	{ 0x00844008, 0x00111004 },	/* PMC2: P2,G2,G3,G4 */
+	{ 0x00800020, 0x00100010 },	/* PMC3: P3,G4 */
+	{ 0x00840080, 0x00110040 },	/* PMC4: P4,G3,G4 */
+	{ 0x00000200, 0x00000100 },	/* PMC5: P5 */
+	{ 0x00000800, 0x00000400 }	/* PMC6: P6 */
+};
+
+static u32 classbits[N_CLASSES - 1][2] = {
+	{ 0x00000000, 0x00000000 },	/* class 0: no constraint */
+	{ 0x00800000, 0x00100000 },	/* class 1: G4 */
+	{ 0x00040000, 0x00010000 },	/* class 2: G3 */
+	{ 0x00004000, 0x00001000 },	/* class 3: G2 */
+};
+
+static int mpc7450_get_constraint(u64 event, unsigned long *maskp,
+				  unsigned long *valp)
+{
+	int pmc, class;
+	u32 mask, value;
+	int thresh, tuse;
+
+	class = mpc7450_classify_event(event);
+	if (class < 0)
+		return -1;
+	if (class == 4) {
+		pmc = ((unsigned int)event >> PM_PMC_SH) & PM_PMC_MSK;
+		mask  = pmcbits[pmc - 1][0];
+		value = pmcbits[pmc - 1][1];
+	} else {
+		mask  = classbits[class][0];
+		value = classbits[class][1];
+	}
+
+	tuse = mpc7450_threshold_use(event);
+	if (tuse) {
+		thresh = ((unsigned int)event >> PM_THRESH_SH) & PM_THRESH_MSK;
+		mask  |= 0x3f << 24;
+		value |= thresh << 24;
+		if (tuse == 2) {
+			mask |= 0x40000000;
+			if ((unsigned int)event & PM_THRMULT_MSKS)
+				value |= 0x40000000;
+		}
+	}
+
+	*maskp = mask;
+	*valp = value;
+	return 0;
+}
+
+static const unsigned int event_alternatives[][MAX_ALT] = {
+	{ 0x217, 0x317 },		/* PM_L1_DCACHE_MISS */
+	{ 0x418, 0x50f, 0x60f },	/* PM_SNOOP_RETRY */
+	{ 0x502, 0x602 },		/* PM_L2_HIT */
+	{ 0x503, 0x603 },		/* PM_L3_HIT */
+	{ 0x504, 0x604 },		/* PM_L2_ICACHE_MISS */
+	{ 0x505, 0x605 },		/* PM_L3_ICACHE_MISS */
+	{ 0x506, 0x606 },		/* PM_L2_DCACHE_MISS */
+	{ 0x507, 0x607 },		/* PM_L3_DCACHE_MISS */
+	{ 0x50a, 0x623 },		/* PM_LD_HIT_L3 */
+	{ 0x50b, 0x624 },		/* PM_ST_HIT_L3 */
+	{ 0x50d, 0x60d },		/* PM_L2_TOUCH_HIT */
+	{ 0x50e, 0x60e },		/* PM_L3_TOUCH_HIT */
+	{ 0x512, 0x612 },		/* PM_INT_LOCAL */
+	{ 0x513, 0x61d },		/* PM_L2_MISS */
+	{ 0x514, 0x61e },		/* PM_L3_MISS */
+};
+
+/*
+ * Scan the alternatives table for a match and return the
+ * index into the alternatives table if found, else -1.
+ */
+static int find_alternative(u32 event)
+{
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(event_alternatives); ++i) {
+		if (event < event_alternatives[i][0])
+			break;
+		for (j = 0; j < MAX_ALT && event_alternatives[i][j]; ++j)
+			if (event == event_alternatives[i][j])
+				return i;
+	}
+	return -1;
+}
+
+static int mpc7450_get_alternatives(u64 event, unsigned int flags, u64 alt[])
+{
+	int i, j, nalt = 1;
+	u32 ae;
+
+	alt[0] = event;
+	nalt = 1;
+	i = find_alternative((u32)event);
+	if (i >= 0) {
+		for (j = 0; j < MAX_ALT; ++j) {
+			ae = event_alternatives[i][j];
+			if (ae && ae != (u32)event)
+				alt[nalt++] = ae;
+		}
+	}
+	return nalt;
+}
+
+/*
+ * Bitmaps of which PMCs each class can use for classes 0 - 3.
+ * Bit i is set if PMC i+1 is usable.
+ */
+static const u8 classmap[N_CLASSES] = {
+	0x3f, 0x0f, 0x0b, 0x03, 0
+};
+
+/* Bit position and width of each PMCSEL field */
+static const int pmcsel_shift[N_COUNTER] = {
+	6,	0,	27,	22,	17,	11
+};
+static const u32 pmcsel_mask[N_COUNTER] = {
+	0x7f,	0x3f,	0x1f,	0x1f,	0x1f,	0x3f
+};
+
+/*
+ * Compute MMCR0/1/2 values for a set of events.
+ */
+static int mpc7450_compute_mmcr(u64 event[], int n_ev,
+				unsigned int hwc[], unsigned long mmcr[])
+{
+	u8 event_index[N_CLASSES][N_COUNTER];
+	int n_classevent[N_CLASSES];
+	int i, j, class, tuse;
+	u32 pmc_inuse = 0, pmc_avail;
+	u32 mmcr0 = 0, mmcr1 = 0, mmcr2 = 0;
+	u32 ev, pmc, thresh;
+
+	if (n_ev > N_COUNTER)
+		return -1;
+
+	/* First pass: count usage in each class */
+	for (i = 0; i < N_CLASSES; ++i)
+		n_classevent[i] = 0;
+	for (i = 0; i < n_ev; ++i) {
+		class = mpc7450_classify_event(event[i]);
+		if (class < 0)
+			return -1;
+		j = n_classevent[class]++;
+		event_index[class][j] = i;
+	}
+
+	/* Second pass: allocate PMCs from most specific event to least */
+	for (class = N_CLASSES - 1; class >= 0; --class) {
+		for (i = 0; i < n_classevent[class]; ++i) {
+			ev = event[event_index[class][i]];
+			if (class == 4) {
+				pmc = (ev >> PM_PMC_SH) & PM_PMC_MSK;
+				if (pmc_inuse & (1 << (pmc - 1)))
+					return -1;
+			} else {
+				/* Find a suitable PMC */
+				pmc_avail = classmap[class] & ~pmc_inuse;
+				if (!pmc_avail)
+					return -1;
+				pmc = ffs(pmc_avail);
+			}
+			pmc_inuse |= 1 << (pmc - 1);
+
+			tuse = mpc7450_threshold_use(ev);
+			if (tuse) {
+				thresh = (ev >> PM_THRESH_SH) & PM_THRESH_MSK;
+				mmcr0 |= thresh << 16;
+				if (tuse == 2 && (ev & PM_THRMULT_MSKS))
+					mmcr2 = 0x80000000;
+			}
+			ev &= pmcsel_mask[pmc - 1];
+			ev <<= pmcsel_shift[pmc - 1];
+			if (pmc <= 2)
+				mmcr0 |= ev;
+			else
+				mmcr1 |= ev;
+			hwc[event_index[class][i]] = pmc - 1;
+		}
+	}
+
+	if (pmc_inuse & 1)
+		mmcr0 |= MMCR0_PMC1CE;
+	if (pmc_inuse & 0x3e)
+		mmcr0 |= MMCR0_PMCnCE;
+
+	/* Return MMCRx values */
+	mmcr[0] = mmcr0;
+	mmcr[1] = mmcr1;
+	mmcr[2] = mmcr2;
+	return 0;
+}
+
+/*
+ * Disable counting by a PMC.
+ * Note that the pmc argument is 0-based here, not 1-based.
+ */
+static void mpc7450_disable_pmc(unsigned int pmc, unsigned long mmcr[])
+{
+	if (pmc <= 1)
+		mmcr[0] &= ~(pmcsel_mask[pmc] << pmcsel_shift[pmc]);
+	else
+		mmcr[1] &= ~(pmcsel_mask[pmc] << pmcsel_shift[pmc]);
+}
+
+static int mpc7450_generic_events[] = {
+	[PERF_COUNT_HW_CPU_CYCLES]		= 1,
+	[PERF_COUNT_HW_INSTRUCTIONS]		= 2,
+	[PERF_COUNT_HW_CACHE_MISSES]		= 0x217, /* PM_L1_DCACHE_MISS */
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x122, /* PM_BR_CMPL */
+	[PERF_COUNT_HW_BRANCH_MISSES] 		= 0x41c, /* PM_BR_MPRED */
+};
+
+#define C(x)	PERF_COUNT_HW_CACHE_##x
+
+/*
+ * Table of generalized cache-related events.
+ * 0 means not supported, -1 means nonsensical, other values
+ * are event codes.
+ */
+static int mpc7450_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
+	[C(L1D)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x225	},
+		[C(OP_WRITE)] = {	0,		0x227	},
+		[C(OP_PREFETCH)] = {	0,		0	},
+	},
+	[C(L1I)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x129,		0x115	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	0x634,		0	},
+	},
+	[C(LL)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0	},
+		[C(OP_WRITE)] = {	0,		0	},
+		[C(OP_PREFETCH)] = {	0,		0	},
+	},
+	[C(DTLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x312	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+	[C(ITLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x223	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+	[C(BPU)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x122,		0x41c	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+};
+
+struct power_pmu mpc7450_pmu = {
+	.name			= "MPC7450 family",
+	.n_counter		= N_COUNTER,
+	.max_alternatives	= MAX_ALT,
+	.add_fields		= 0x00111555ul,
+	.test_adder		= 0x00301000ul,
+	.compute_mmcr		= mpc7450_compute_mmcr,
+	.get_constraint		= mpc7450_get_constraint,
+	.get_alternatives	= mpc7450_get_alternatives,
+	.disable_pmc		= mpc7450_disable_pmc,
+	.n_generic		= ARRAY_SIZE(mpc7450_generic_events),
+	.generic_events		= mpc7450_generic_events,
+	.cache_events		= &mpc7450_cache_events,
+};
+
+static int init_mpc7450_pmu(void)
+{
+	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc/7450"))
+		return -ENODEV;
+
+	return register_power_pmu(&mpc7450_pmu);
+}
+
+arch_initcall(init_mpc7450_pmu);
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index dd9f3ec..8485c8c 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -75,6 +75,7 @@ config POWER4_ONLY
 config 6xx
 	def_bool y
 	depends on PPC32 && PPC_BOOK3S
+	select PPC_HAVE_PMU_SUPPORT
 
 config POWER3
 	bool
-- 
1.6.0.4


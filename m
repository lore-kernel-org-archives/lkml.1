Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZFTR0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZFTR0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 13:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZFTR0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 13:26:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47414 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZFTRZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 13:25:55 -0400
Date: Sat, 20 Jun 2009 19:25:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perfcounters updates
Message-ID: <20090620172520.GA8158@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perfcounters git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

This is a bit large and fresh - but i hope this is still acceptable 
in the merge window.

The main focus of the changes is the fixing of call-chain profiling 
and its push through the 'perf' tool and finalization of the 
call-chain ABI, and the fixing of a couple of bugs this exposed. (On 
x86 we went for the safer solution of using fast-gup for the 
call-chains - this is slower but only affects perfcounters. The 
faster and nicer solution of removing nested IRETs and 
save/restore-ing cr2 is being worked on.)

The other bigger change is PowerPC-32 support from Paulus. BenH has 
acked these changes, and has acked this (one-off) route towards 
mainline as well.

Note: there's a new default a_ops helper added to fs/anon_inodes.c, 
Al Viro was Cc:-ed to that patch (no reply yet). Apparently 
perfcounters is the first anon-fd user to allow writable mmaps.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (4):
      perf annotate: Print the filename:line for annotated colored lines
      perf annotate: Print a sorted summary of annotated overhead lines
      perf annotate: Fixes for filename:line displays
      perfcounter: Handle some IO return values

Ingo Molnar (14):
      perf stat: Reorganize output
      perf stat: Add feature to run and measure a command multiple times
      perf stat: Enable raw data to be printed
      perf report: Print out raw events in hexa
      perf record/report: Add call graph / call chain profiling
      perf_counter, x86: Fix call-chain walking
      perf_counter, x86: Fix kernel-space call-chains
      perf record: Fix fast task-exit race
      perf report: Add per system call overhead histogram
      perf report: Fix 32-bit printf format
      perf report: Tidy up the "--parent <regex>" and "--sort parent" call-chain features
      perf report: Add validation of call-chain entries
      perf report: Filter to parent set by default
      perf_counter, x86: Improve interactions with fast-gup

Jaswinder Singh Rajput (2):
      perf_counter, x86: Check old-AMD performance monitoring support
      perf_counter, x86: Update AMD hw caching related event table

Marti Raudsepp (1):
      perf_counter: Fix stack corruption in perf_read_hw

Paul Mackerras (10):
      perf_counter: Fix atomic_set vs. atomic64_t type mismatch
      perf_counter: powerpc: Fix two compile warnings
      perf_counter: Make set_perf_counter_pending() declaration common
      perf_counter: powerpc: Enable use of software counters on 32-bit powerpc
      perf_counter: powerpc: Use unsigned long for register and constraint values
      perf_counter: powerpc: Change how processor-specific back-ends get selected
      perf_counter: powerpc: Make powerpc perf_counter code safe for 32-bit kernels
      perf_counter: powerpc: Add processor back-end for MPC7450 family
      perf_counter: tools: Makefile tweaks for 64-bit powerpc
      perf_counter tools: Define and use our own u64, s64 etc. definitions

Peter Zijlstra (18):
      perf_counter: Fix ctx->mutex vs counter->mutex inversion
      x86, mm: Add __get_user_pages_fast()
      x86: Add NMI types for kmap_atomic
      perf_counter: x86: Fix call-chain support to use NMI-safe methods
      x86: Add NMI types for kmap_atomic, fix
      perf report: Add --sort <call> --call <$regex>
      perf_counter: x86: Set the period in the intel overflow handler
      perf_counter tools: Replace isprint() with issane()
      perf_counter tools: Add and use isprint()
      fs: Provide empty .set_page_dirty() aop for anon inodes
      perf_counter: Add event overlow handling
      perf_counter tools: Handle lost events
      perf_counter: Make callchain samples extensible
      perf_counter: Update userspace callchain sampling uses
      perf_counter tools: Add a data file header
      perf_counter: Simplify and fix task migration counting
      perf_counter: Close race in perf_lock_task_context()
      perf_counter: Push perf_sample_data through the swcounter code


 arch/powerpc/Kconfig                    |    1 +
 arch/powerpc/include/asm/hw_irq.h       |    6 +-
 arch/powerpc/include/asm/perf_counter.h |   52 +++--
 arch/powerpc/kernel/Makefile            |    8 +-
 arch/powerpc/kernel/mpc7450-pmu.c       |  417 +++++++++++++++++++++++++++++
 arch/powerpc/kernel/perf_counter.c      |  257 +++++++++++--------
 arch/powerpc/kernel/power4-pmu.c        |   89 ++++---
 arch/powerpc/kernel/power5+-pmu.c       |   95 ++++---
 arch/powerpc/kernel/power5-pmu.c        |   98 ++++---
 arch/powerpc/kernel/power6-pmu.c        |   72 +++--
 arch/powerpc/kernel/power7-pmu.c        |   61 +++--
 arch/powerpc/kernel/ppc970-pmu.c        |   63 +++--
 arch/powerpc/kernel/time.c              |   25 ++
 arch/powerpc/platforms/Kconfig.cputype  |   12 +-
 arch/x86/include/asm/perf_counter.h     |    5 -
 arch/x86/include/asm/pgtable_32.h       |    8 +-
 arch/x86/include/asm/uaccess.h          |    7 +-
 arch/x86/kernel/cpu/perf_counter.c      |  138 ++++++-----
 arch/x86/mm/gup.c                       |   58 ++++-
 fs/anon_inodes.c                        |   15 +
 include/asm-generic/kmap_types.h        |    5 +-
 include/linux/mm.h                      |    6 +
 include/linux/perf_counter.h            |   79 ++++--
 kernel/perf_counter.c                   |  312 +++++++++++++----------
 kernel/sched.c                          |    3 +-
 tools/perf/Makefile                     |   10 +-
 tools/perf/builtin-annotate.c           |  262 +++++++++++++++----
 tools/perf/builtin-record.c             |  163 +++++++-----
 tools/perf/builtin-report.c             |  439 +++++++++++++++++++++++++------
 tools/perf/builtin-stat.c               |  308 ++++++++++++++++------
 tools/perf/builtin-top.c                |   24 +-
 tools/perf/perf.h                       |    7 +
 tools/perf/types.h                      |   17 ++
 tools/perf/util/ctype.c                 |   17 +-
 tools/perf/util/parse-events.c          |   14 +-
 tools/perf/util/string.c                |    2 +-
 tools/perf/util/string.h                |    4 +-
 tools/perf/util/symbol.c                |   20 +-
 tools/perf/util/symbol.h                |   16 +-
 tools/perf/util/util.h                  |   18 +-
 40 files changed, 2321 insertions(+), 892 deletions(-)
 create mode 100644 arch/powerpc/kernel/mpc7450-pmu.c
 create mode 100644 tools/perf/types.h

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9fb344d..bf6cedf 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -126,6 +126,7 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
+	select HAVE_PERF_COUNTERS
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index b7f8f4a..867ab8e 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -131,6 +131,8 @@ static inline int irqs_disabled_flags(unsigned long flags)
 struct irq_chip;
 
 #ifdef CONFIG_PERF_COUNTERS
+
+#ifdef CONFIG_PPC64
 static inline unsigned long test_perf_counter_pending(void)
 {
 	unsigned long x;
@@ -154,15 +156,15 @@ static inline void clear_perf_counter_pending(void)
 		"r" (0),
 		"i" (offsetof(struct paca_struct, perf_counter_pending)));
 }
+#endif /* CONFIG_PPC64 */
 
-#else
+#else  /* CONFIG_PERF_COUNTERS */
 
 static inline unsigned long test_perf_counter_pending(void)
 {
 	return 0;
 }
 
-static inline void set_perf_counter_pending(void) {}
 static inline void clear_perf_counter_pending(void) {}
 #endif /* CONFIG_PERF_COUNTERS */
 
diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index cc7c887..8ccd4e1 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -10,6 +10,8 @@
  */
 #include <linux/types.h>
 
+#include <asm/hw_irq.h>
+
 #define MAX_HWCOUNTERS		8
 #define MAX_EVENT_ALTERNATIVES	8
 #define MAX_LIMITED_HWCOUNTERS	2
@@ -19,27 +21,27 @@
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
+	const char	*name;
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
 
-extern struct power_pmu *ppmu;
-
 /*
  * Values for power_pmu.flags
  */
@@ -53,15 +55,23 @@ extern struct power_pmu *ppmu;
 #define PPMU_LIMITED_PMC_REQD	2	/* have to put this on a limited PMC */
 #define PPMU_ONLY_COUNT_RUN	4	/* only counting in run state */
 
+extern int register_power_pmu(struct power_pmu *);
+
 struct pt_regs;
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
-#define perf_misc_flags(regs)	perf_misc_flags(regs)
-
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 
 /*
- * The power_pmu.get_constraint function returns a 64-bit value and
- * a 64-bit mask that express the constraints between this event and
+ * Only override the default definitions in include/linux/perf_counter.h
+ * if we have hardware PMU support.
+ */
+#ifdef CONFIG_PPC_PERF_CTRS
+#define perf_misc_flags(regs)	perf_misc_flags(regs)
+#endif
+
+/*
+ * The power_pmu.get_constraint function returns a 32/64-bit value and
+ * a 32/64-bit mask that express the constraints between this event and
  * other events.
  *
  * The value and mask are divided up into (non-overlapping) bitfields
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 612b0c4..a9f8829 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -95,9 +95,10 @@ obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
-obj-$(CONFIG_PERF_COUNTERS)	+= perf_counter.o power4-pmu.o ppc970-pmu.o \
-				   power5-pmu.o power5+-pmu.o power6-pmu.o \
-				   power7-pmu.o
+obj-$(CONFIG_PPC_PERF_CTRS)	+= perf_counter.o
+obj64-$(CONFIG_PPC_PERF_CTRS)	+= power4-pmu.o ppc970-pmu.o power5-pmu.o \
+				   power5+-pmu.o power6-pmu.o power7-pmu.o
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
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index bb20238..809fdf9 100644
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
@@ -46,6 +46,115 @@ struct power_pmu *ppmu;
  */
 static unsigned int freeze_counters_kernel = MMCR0_FCS;
 
+/*
+ * 32-bit doesn't have MMCRA but does have an MMCR2,
+ * and a few other names are different.
+ */
+#ifdef CONFIG_PPC32
+
+#define MMCR0_FCHV		0
+#define MMCR0_PMCjCE		MMCR0_PMCnCE
+
+#define SPRN_MMCRA		SPRN_MMCR2
+#define MMCRA_SAMPLE_ENABLE	0
+
+static inline unsigned long perf_ip_adjust(struct pt_regs *regs)
+{
+	return 0;
+}
+static inline void perf_set_pmu_inuse(int inuse) { }
+static inline void perf_get_data_addr(struct pt_regs *regs, u64 *addrp) { }
+static inline u32 perf_get_misc_flags(struct pt_regs *regs)
+{
+	return 0;
+}
+static inline void perf_read_regs(struct pt_regs *regs) { }
+static inline int perf_intr_is_nmi(struct pt_regs *regs)
+{
+	return 0;
+}
+
+#endif /* CONFIG_PPC32 */
+
+/*
+ * Things that are specific to 64-bit implementations.
+ */
+#ifdef CONFIG_PPC64
+
+static inline unsigned long perf_ip_adjust(struct pt_regs *regs)
+{
+	unsigned long mmcra = regs->dsisr;
+
+	if ((mmcra & MMCRA_SAMPLE_ENABLE) && !(ppmu->flags & PPMU_ALT_SIPR)) {
+		unsigned long slot = (mmcra & MMCRA_SLOT) >> MMCRA_SLOT_SHIFT;
+		if (slot > 1)
+			return 4 * (slot - 1);
+	}
+	return 0;
+}
+
+static inline void perf_set_pmu_inuse(int inuse)
+{
+	get_lppaca()->pmcregs_in_use = inuse;
+}
+
+/*
+ * The user wants a data address recorded.
+ * If we're not doing instruction sampling, give them the SDAR
+ * (sampled data address).  If we are doing instruction sampling, then
+ * only give them the SDAR if it corresponds to the instruction
+ * pointed to by SIAR; this is indicated by the [POWER6_]MMCRA_SDSYNC
+ * bit in MMCRA.
+ */
+static inline void perf_get_data_addr(struct pt_regs *regs, u64 *addrp)
+{
+	unsigned long mmcra = regs->dsisr;
+	unsigned long sdsync = (ppmu->flags & PPMU_ALT_SIPR) ?
+		POWER6_MMCRA_SDSYNC : MMCRA_SDSYNC;
+
+	if (!(mmcra & MMCRA_SAMPLE_ENABLE) || (mmcra & sdsync))
+		*addrp = mfspr(SPRN_SDAR);
+}
+
+static inline u32 perf_get_misc_flags(struct pt_regs *regs)
+{
+	unsigned long mmcra = regs->dsisr;
+
+	if (TRAP(regs) != 0xf00)
+		return 0;	/* not a PMU interrupt */
+
+	if (ppmu->flags & PPMU_ALT_SIPR) {
+		if (mmcra & POWER6_MMCRA_SIHV)
+			return PERF_EVENT_MISC_HYPERVISOR;
+		return (mmcra & POWER6_MMCRA_SIPR) ?
+			PERF_EVENT_MISC_USER : PERF_EVENT_MISC_KERNEL;
+	}
+	if (mmcra & MMCRA_SIHV)
+		return PERF_EVENT_MISC_HYPERVISOR;
+	return (mmcra & MMCRA_SIPR) ? PERF_EVENT_MISC_USER :
+		PERF_EVENT_MISC_KERNEL;
+}
+
+/*
+ * Overload regs->dsisr to store MMCRA so we only need to read it once
+ * on each interrupt.
+ */
+static inline void perf_read_regs(struct pt_regs *regs)
+{
+	regs->dsisr = mfspr(SPRN_MMCRA);
+}
+
+/*
+ * If interrupts were soft-disabled when a PMU interrupt occurs, treat
+ * it as an NMI.
+ */
+static inline int perf_intr_is_nmi(struct pt_regs *regs)
+{
+	return !regs->softe;
+}
+
+#endif /* CONFIG_PPC64 */
+
 static void perf_counter_interrupt(struct pt_regs *regs);
 
 void perf_counter_print_debug(void)
@@ -78,12 +187,14 @@ static unsigned long read_pmc(int idx)
 	case 6:
 		val = mfspr(SPRN_PMC6);
 		break;
+#ifdef CONFIG_PPC64
 	case 7:
 		val = mfspr(SPRN_PMC7);
 		break;
 	case 8:
 		val = mfspr(SPRN_PMC8);
 		break;
+#endif /* CONFIG_PPC64 */
 	default:
 		printk(KERN_ERR "oops trying to read PMC%d\n", idx);
 		val = 0;
@@ -115,12 +226,14 @@ static void write_pmc(int idx, unsigned long val)
 	case 6:
 		mtspr(SPRN_PMC6, val);
 		break;
+#ifdef CONFIG_PPC64
 	case 7:
 		mtspr(SPRN_PMC7, val);
 		break;
 	case 8:
 		mtspr(SPRN_PMC8, val);
 		break;
+#endif /* CONFIG_PPC64 */
 	default:
 		printk(KERN_ERR "oops trying to write PMC%d\n", idx);
 	}
@@ -135,15 +248,15 @@ static void write_pmc(int idx, unsigned long val)
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
@@ -283,7 +396,7 @@ static int check_excludes(struct perf_counter **ctrs, unsigned int cflags[],
 
 static void power_pmu_read(struct perf_counter *counter)
 {
-	long val, delta, prev;
+	s64 val, delta, prev;
 
 	if (!counter->hw.idx)
 		return;
@@ -403,14 +516,12 @@ static void write_mmcr0(struct cpu_hw_counters *cpuhw, unsigned long mmcr0)
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
 
@@ -479,7 +590,7 @@ void hw_perf_enable(void)
 		mtspr(SPRN_MMCRA, cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
 		mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
 		if (cpuhw->n_counters == 0)
-			get_lppaca()->pmcregs_in_use = 0;
+			perf_set_pmu_inuse(0);
 		goto out_enable;
 	}
 
@@ -512,7 +623,7 @@ void hw_perf_enable(void)
 	 * bit set and set the hardware counters to their initial values.
 	 * Then unfreeze the counters.
 	 */
-	get_lppaca()->pmcregs_in_use = 1;
+	perf_set_pmu_inuse(1);
 	mtspr(SPRN_MMCRA, cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
 	mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
 	mtspr(SPRN_MMCR0, (cpuhw->mmcr[0] & ~(MMCR0_PMC1CE | MMCR0_PMCjCE))
@@ -913,6 +1024,8 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 	case PERF_TYPE_RAW:
 		ev = counter->attr.config;
 		break;
+	default:
+		return ERR_PTR(-EINVAL);
 	}
 	counter->hw.config_base = ev;
 	counter->hw.idx = 0;
@@ -1007,13 +1120,12 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
  * things if requested.  Note that interrupts are hard-disabled
  * here so there is no possibility of being interrupted.
  */
-static void record_and_restart(struct perf_counter *counter, long val,
+static void record_and_restart(struct perf_counter *counter, unsigned long val,
 			       struct pt_regs *regs, int nmi)
 {
 	u64 period = counter->hw.sample_period;
 	s64 prev, delta, left;
 	int record = 0;
-	u64 addr, mmcra, sdsync;
 
 	/* we don't have to worry about interrupts here */
 	prev = atomic64_read(&counter->hw.prev_count);
@@ -1033,8 +1145,8 @@ static void record_and_restart(struct perf_counter *counter, long val,
 				left = period;
 			record = 1;
 		}
-		if (left < 0x80000000L)
-			val = 0x80000000L - left;
+		if (left < 0x80000000LL)
+			val = 0x80000000LL - left;
 	}
 
 	/*
@@ -1047,22 +1159,9 @@ static void record_and_restart(struct perf_counter *counter, long val,
 			.period	= counter->hw.last_period,
 		};
 
-		if (counter->attr.sample_type & PERF_SAMPLE_ADDR) {
-			/*
-			 * The user wants a data address recorded.
-			 * If we're not doing instruction sampling,
-			 * give them the SDAR (sampled data address).
-			 * If we are doing instruction sampling, then only
-			 * give them the SDAR if it corresponds to the
-			 * instruction pointed to by SIAR; this is indicated
-			 * by the [POWER6_]MMCRA_SDSYNC bit in MMCRA.
-			 */
-			mmcra = regs->dsisr;
-			sdsync = (ppmu->flags & PPMU_ALT_SIPR) ?
-				POWER6_MMCRA_SDSYNC : MMCRA_SDSYNC;
-			if (!(mmcra & MMCRA_SAMPLE_ENABLE) || (mmcra & sdsync))
-				data.addr = mfspr(SPRN_SDAR);
-		}
+		if (counter->attr.sample_type & PERF_SAMPLE_ADDR)
+			perf_get_data_addr(regs, &data.addr);
+
 		if (perf_counter_overflow(counter, nmi, &data)) {
 			/*
 			 * Interrupts are coming too fast - throttle them
@@ -1088,25 +1187,12 @@ static void record_and_restart(struct perf_counter *counter, long val,
  */
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
-	unsigned long mmcra;
-
-	if (TRAP(regs) != 0xf00) {
-		/* not a PMU interrupt */
-		return user_mode(regs) ? PERF_EVENT_MISC_USER :
-			PERF_EVENT_MISC_KERNEL;
-	}
+	u32 flags = perf_get_misc_flags(regs);
 
-	mmcra = regs->dsisr;
-	if (ppmu->flags & PPMU_ALT_SIPR) {
-		if (mmcra & POWER6_MMCRA_SIHV)
-			return PERF_EVENT_MISC_HYPERVISOR;
-		return (mmcra & POWER6_MMCRA_SIPR) ? PERF_EVENT_MISC_USER :
-			PERF_EVENT_MISC_KERNEL;
-	}
-	if (mmcra & MMCRA_SIHV)
-		return PERF_EVENT_MISC_HYPERVISOR;
-	return (mmcra & MMCRA_SIPR) ? PERF_EVENT_MISC_USER :
-			PERF_EVENT_MISC_KERNEL;
+	if (flags)
+		return flags;
+	return user_mode(regs) ? PERF_EVENT_MISC_USER :
+		PERF_EVENT_MISC_KERNEL;
 }
 
 /*
@@ -1115,20 +1201,12 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
  */
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	unsigned long mmcra;
 	unsigned long ip;
-	unsigned long slot;
 
 	if (TRAP(regs) != 0xf00)
 		return regs->nip;	/* not a PMU interrupt */
 
-	ip = mfspr(SPRN_SIAR);
-	mmcra = regs->dsisr;
-	if ((mmcra & MMCRA_SAMPLE_ENABLE) && !(ppmu->flags & PPMU_ALT_SIPR)) {
-		slot = (mmcra & MMCRA_SLOT) >> MMCRA_SLOT_SHIFT;
-		if (slot > 1)
-			ip += 4 * (slot - 1);
-	}
+	ip = mfspr(SPRN_SIAR) + perf_ip_adjust(regs);
 	return ip;
 }
 
@@ -1140,7 +1218,7 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 	int i;
 	struct cpu_hw_counters *cpuhw = &__get_cpu_var(cpu_hw_counters);
 	struct perf_counter *counter;
-	long val;
+	unsigned long val;
 	int found = 0;
 	int nmi;
 
@@ -1148,16 +1226,9 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 		freeze_limited_counters(cpuhw, mfspr(SPRN_PMC5),
 					mfspr(SPRN_PMC6));
 
-	/*
-	 * Overload regs->dsisr to store MMCRA so we only need to read it once.
-	 */
-	regs->dsisr = mfspr(SPRN_MMCRA);
+	perf_read_regs(regs);
 
-	/*
-	 * If interrupts were soft-disabled when this PMU interrupt
-	 * occurred, treat it as an NMI.
-	 */
-	nmi = !regs->softe;
+	nmi = perf_intr_is_nmi(regs);
 	if (nmi)
 		nmi_enter();
 	else
@@ -1214,50 +1285,22 @@ void hw_perf_counter_setup(int cpu)
 	cpuhw->mmcr[0] = MMCR0_FC;
 }
 
-extern struct power_pmu power4_pmu;
-extern struct power_pmu ppc970_pmu;
-extern struct power_pmu power5_pmu;
-extern struct power_pmu power5p_pmu;
-extern struct power_pmu power6_pmu;
-extern struct power_pmu power7_pmu;
-
-static int init_perf_counters(void)
+int register_power_pmu(struct power_pmu *pmu)
 {
-	unsigned long pvr;
-
-	/* XXX should get this from cputable */
-	pvr = mfspr(SPRN_PVR);
-	switch (PVR_VER(pvr)) {
-	case PV_POWER4:
-	case PV_POWER4p:
-		ppmu = &power4_pmu;
-		break;
-	case PV_970:
-	case PV_970FX:
-	case PV_970MP:
-		ppmu = &ppc970_pmu;
-		break;
-	case PV_POWER5:
-		ppmu = &power5_pmu;
-		break;
-	case PV_POWER5p:
-		ppmu = &power5p_pmu;
-		break;
-	case 0x3e:
-		ppmu = &power6_pmu;
-		break;
-	case 0x3f:
-		ppmu = &power7_pmu;
-		break;
-	}
+	if (ppmu)
+		return -EBUSY;		/* something's already registered */
+
+	ppmu = pmu;
+	pr_info("%s performance monitor hardware support registered\n",
+		pmu->name);
 
+#ifdef MSR_HV
 	/*
 	 * Use FCHV to ignore kernel events if MSR.HV is set.
 	 */
 	if (mfmsr() & MSR_HV)
 		freeze_counters_kernel = MMCR0_FCHV;
+#endif /* CONFIG_PPC64 */
 
 	return 0;
 }
-
-arch_initcall(init_perf_counters);
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
index 07bd308..db90b0c 100644
--- a/arch/powerpc/kernel/power4-pmu.c
+++ b/arch/powerpc/kernel/power4-pmu.c
@@ -10,7 +10,9 @@
  */
 #include <linux/kernel.h>
 #include <linux/perf_counter.h>
+#include <linux/string.h>
 #include <asm/reg.h>
+#include <asm/cputable.h>
 
 /*
  * Bits in event code for POWER4
@@ -179,22 +181,22 @@ static short mmcr1_adder_bits[8] = {
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
@@ -249,10 +251,11 @@ static int p4_marked_instr_event(u64 event)
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
@@ -282,14 +285,14 @@ static int p4_get_constraint(u64 event, u64 *maskp, u64 *valp)
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
@@ -353,9 +356,9 @@ static int p4_get_alternatives(u64 event, unsigned int flags, u64 alt[])
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
@@ -429,9 +432,11 @@ static int p4_compute_mmcr(u64 event[], int n_ev,
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
@@ -456,7 +461,8 @@ static int p4_compute_mmcr(u64 event[], int n_ev,
 				ttm = unit - 1;		/* 2->1, 3->2 */
 			else
 				ttm = unit >> 2;
-			mmcr1 |= (u64)ttm << (MMCR1_TD_CP_DBG0SEL_SH - 2*byte);
+			mmcr1 |= (unsigned long)ttm
+				<< (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
 		}
 	}
 
@@ -519,7 +525,7 @@ static int p4_compute_mmcr(u64 event[], int n_ev,
 	return 0;
 }
 
-static void p4_disable_pmc(unsigned int pmc, u64 mmcr[])
+static void p4_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 {
 	/*
 	 * Setting the PMCxSEL field to 0 disables PMC x.
@@ -583,16 +589,27 @@ static int power4_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu power4_pmu = {
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
+static struct power_pmu power4_pmu = {
+	.name			= "POWER4/4+",
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
+
+static int init_power4_pmu(void)
+{
+	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power4"))
+		return -ENODEV;
+
+	return register_power_pmu(&power4_pmu);
+}
+
+arch_initcall(init_power4_pmu);
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index 41e5d2d..f4adca8 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -10,7 +10,9 @@
  */
 #include <linux/kernel.h>
 #include <linux/perf_counter.h>
+#include <linux/string.h>
 #include <asm/reg.h>
+#include <asm/cputable.h>
 
 /*
  * Bits in event code for POWER5+ (POWER5 GS) and POWER5++ (POWER5 GS DD3)
@@ -126,20 +128,21 @@ static const int grsel_shift[8] = {
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
@@ -171,17 +174,18 @@ static int power5p_get_constraint(u64 event, u64 *maskp, u64 *valp)
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
@@ -452,10 +456,10 @@ static int power5p_marked_instr_event(u64 event)
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
@@ -517,7 +521,7 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 			continue;
 		if (ttmuse++)
 			return -1;
-		mmcr1 |= (u64)i << MMCR1_TTM0SEL_SH;
+		mmcr1 |= (unsigned long)i << MMCR1_TTM0SEL_SH;
 	}
 	ttmuse = 0;
 	for (; i <= PM_GRS; ++i) {
@@ -525,7 +529,7 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 			continue;
 		if (ttmuse++)
 			return -1;
-		mmcr1 |= (u64)(i & 3) << MMCR1_TTM1SEL_SH;
+		mmcr1 |= (unsigned long)(i & 3) << MMCR1_TTM1SEL_SH;
 	}
 	if (ttmuse > 1)
 		return -1;
@@ -540,10 +544,11 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
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
@@ -568,7 +573,7 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 			if (isbus && (byte & 2) &&
 			    (psel == 8 || psel == 0x10 || psel == 0x28))
 				/* add events on higher-numbered bus */
-				mmcr1 |= 1ull << (MMCR1_PMC1_ADDER_SEL_SH - pmc);
+				mmcr1 |= 1ul << (MMCR1_PMC1_ADDER_SEL_SH - pmc);
 		} else {
 			/* Instructions or run cycles on PMC5/6 */
 			--pmc;
@@ -576,7 +581,7 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 		if (isbus && unit == PM_GRS) {
 			bit = psel & 7;
 			grsel = (event[i] >> PM_GRS_SH) & PM_GRS_MSK;
-			mmcr1 |= (u64)grsel << grsel_shift[bit];
+			mmcr1 |= (unsigned long)grsel << grsel_shift[bit];
 		}
 		if (power5p_marked_instr_event(event[i]))
 			mmcra |= MMCRA_SAMPLE_ENABLE;
@@ -599,7 +604,7 @@ static int power5p_compute_mmcr(u64 event[], int n_ev,
 	return 0;
 }
 
-static void power5p_disable_pmc(unsigned int pmc, u64 mmcr[])
+static void power5p_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 {
 	if (pmc <= 3)
 		mmcr[1] &= ~(0x7fUL << MMCR1_PMCSEL_SH(pmc));
@@ -654,18 +659,30 @@ static int power5p_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu power5p_pmu = {
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
+static struct power_pmu power5p_pmu = {
+	.name			= "POWER5+/++",
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
+
+static int init_power5p_pmu(void)
+{
+	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5+")
+	    && strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5++"))
+		return -ENODEV;
+
+	return register_power_pmu(&power5p_pmu);
+}
+
+arch_initcall(init_power5p_pmu);
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index 05600b6..29b2c6c 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -10,7 +10,9 @@
  */
 #include <linux/kernel.h>
 #include <linux/perf_counter.h>
+#include <linux/string.h>
 #include <asm/reg.h>
+#include <asm/cputable.h>
 
 /*
  * Bits in event code for POWER5 (not POWER5++)
@@ -130,20 +132,21 @@ static const int grsel_shift[8] = {
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
@@ -178,8 +181,9 @@ static int power5_get_constraint(u64 event, u64 *maskp, u64 *valp)
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
@@ -188,22 +192,22 @@ static int power5_get_constraint(u64 event, u64 *maskp, u64 *valp)
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
@@ -383,10 +387,10 @@ static int power5_marked_instr_event(u64 event)
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
@@ -457,7 +461,7 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 			continue;
 		if (ttmuse++)
 			return -1;
-		mmcr1 |= (u64)i << MMCR1_TTM0SEL_SH;
+		mmcr1 |= (unsigned long)i << MMCR1_TTM0SEL_SH;
 	}
 	ttmuse = 0;
 	for (; i <= PM_GRS; ++i) {
@@ -465,7 +469,7 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 			continue;
 		if (ttmuse++)
 			return -1;
-		mmcr1 |= (u64)(i & 3) << MMCR1_TTM1SEL_SH;
+		mmcr1 |= (unsigned long)(i & 3) << MMCR1_TTM1SEL_SH;
 	}
 	if (ttmuse > 1)
 		return -1;
@@ -480,10 +484,11 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
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
@@ -513,7 +518,7 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 			--pmc;
 			if ((psel == 8 || psel == 0x10) && isbus && (byte & 2))
 				/* add events on higher-numbered bus */
-				mmcr1 |= 1ull << (MMCR1_PMC1_ADDER_SEL_SH - pmc);
+				mmcr1 |= 1ul << (MMCR1_PMC1_ADDER_SEL_SH - pmc);
 		} else {
 			/* Instructions or run cycles on PMC5/6 */
 			--pmc;
@@ -521,7 +526,7 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 		if (isbus && unit == PM_GRS) {
 			bit = psel & 7;
 			grsel = (event[i] >> PM_GRS_SH) & PM_GRS_MSK;
-			mmcr1 |= (u64)grsel << grsel_shift[bit];
+			mmcr1 |= (unsigned long)grsel << grsel_shift[bit];
 		}
 		if (power5_marked_instr_event(event[i]))
 			mmcra |= MMCRA_SAMPLE_ENABLE;
@@ -541,7 +546,7 @@ static int power5_compute_mmcr(u64 event[], int n_ev,
 	return 0;
 }
 
-static void power5_disable_pmc(unsigned int pmc, u64 mmcr[])
+static void power5_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 {
 	if (pmc <= 3)
 		mmcr[1] &= ~(0x7fUL << MMCR1_PMCSEL_SH(pmc));
@@ -596,16 +601,27 @@ static int power5_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu power5_pmu = {
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
+static struct power_pmu power5_pmu = {
+	.name			= "POWER5",
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
+
+static int init_power5_pmu(void)
+{
+	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5"))
+		return -ENODEV;
+
+	return register_power_pmu(&power5_pmu);
+}
+
+arch_initcall(init_power5_pmu);
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index 46f74be..09ae5bf 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -10,7 +10,9 @@
  */
 #include <linux/kernel.h>
 #include <linux/perf_counter.h>
+#include <linux/string.h>
 #include <asm/reg.h>
+#include <asm/cputable.h>
 
 /*
  * Bits in event code for POWER6
@@ -41,9 +43,9 @@
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
@@ -173,10 +175,10 @@ static int power6_marked_instr_event(u64 event)
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
@@ -215,7 +217,7 @@ static int p6_compute_mmcr(u64 event[], int n_ev,
 			/* check for conflict on this byte of event bus */
 			if ((ttmset & (1 << b)) && MMCR1_TTMSEL(mmcr1, b) != u)
 				return -1;
-			mmcr1 |= (u64)u << MMCR1_TTMSEL_SH(b);
+			mmcr1 |= (unsigned long)u << MMCR1_TTMSEL_SH(b);
 			ttmset |= 1 << b;
 			if (u == 5) {
 				/* Nest events have a further mux */
@@ -224,7 +226,7 @@ static int p6_compute_mmcr(u64 event[], int n_ev,
 				    MMCR1_NESTSEL(mmcr1) != s)
 					return -1;
 				ttmset |= 0x10;
-				mmcr1 |= (u64)s << MMCR1_NESTSEL_SH;
+				mmcr1 |= (unsigned long)s << MMCR1_NESTSEL_SH;
 			}
 			if (0x30 <= psel && psel <= 0x3d) {
 				/* these need the PMCx_ADDR_SEL bits */
@@ -243,7 +245,7 @@ static int p6_compute_mmcr(u64 event[], int n_ev,
 		if (power6_marked_instr_event(event[i]))
 			mmcra |= MMCRA_SAMPLE_ENABLE;
 		if (pmc < 4)
-			mmcr1 |= (u64)psel << MMCR1_PMCSEL_SH(pmc);
+			mmcr1 |= (unsigned long)psel << MMCR1_PMCSEL_SH(pmc);
 	}
 	mmcr[0] = 0;
 	if (pmc_inuse & 1)
@@ -265,10 +267,11 @@ static int p6_compute_mmcr(u64 event[], int n_ev,
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
@@ -282,11 +285,11 @@ static int p6_get_constraint(u64 event, u64 *maskp, u64 *valp)
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
@@ -458,7 +461,7 @@ static int p6_get_alternatives(u64 event, unsigned int flags, u64 alt[])
 	return nalt;
 }
 
-static void p6_disable_pmc(unsigned int pmc, u64 mmcr[])
+static void p6_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 {
 	/* Set PMCxSEL to 0 to disable PMCx */
 	if (pmc <= 3)
@@ -515,18 +518,29 @@ static int power6_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu power6_pmu = {
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
+static struct power_pmu power6_pmu = {
+	.name			= "POWER6",
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
+
+static int init_power6_pmu(void)
+{
+	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power6"))
+		return -ENODEV;
+
+	return register_power_pmu(&power6_pmu);
+}
+
+arch_initcall(init_power6_pmu);
diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index b72e7a1..5d755ef 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -10,7 +10,9 @@
  */
 #include <linux/kernel.h>
 #include <linux/perf_counter.h>
+#include <linux/string.h>
 #include <asm/reg.h>
+#include <asm/cputable.h>
 
 /*
  * Bits in event code for POWER7
@@ -71,10 +73,11 @@
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
@@ -224,10 +227,10 @@ static int power7_marked_instr_event(u64 event)
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
@@ -265,11 +268,14 @@ static int power7_compute_mmcr(u64 event[], int n_ev,
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
@@ -287,10 +293,10 @@ static int power7_compute_mmcr(u64 event[], int n_ev,
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
@@ -342,16 +348,27 @@ static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu power7_pmu = {
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
+static struct power_pmu power7_pmu = {
+	.name			= "POWER7",
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
+
+static int init_power7_pmu(void)
+{
+	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power7"))
+		return -ENODEV;
+
+	return register_power_pmu(&power7_pmu);
+}
+
+arch_initcall(init_power7_pmu);
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index ba0a357..6637c87 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -10,7 +10,9 @@
  */
 #include <linux/string.h>
 #include <linux/perf_counter.h>
+#include <linux/string.h>
 #include <asm/reg.h>
+#include <asm/cputable.h>
 
 /*
  * Bits in event code for PPC970
@@ -183,7 +185,7 @@ static int p970_marked_instr_event(u64 event)
 }
 
 /* Masks and values for using events from the various units */
-static u64 unit_cons[PM_LASTUNIT+1][2] = {
+static unsigned long unit_cons[PM_LASTUNIT+1][2] = {
 	[PM_FPU] =   { 0xc80000000000ull, 0x040000000000ull },
 	[PM_VPU] =   { 0xc80000000000ull, 0xc40000000000ull },
 	[PM_ISU] =   { 0x080000000000ull, 0x020000000000ull },
@@ -192,10 +194,11 @@ static u64 unit_cons[PM_LASTUNIT+1][2] = {
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
@@ -222,7 +225,7 @@ static int p970_get_constraint(u64 event, u64 *maskp, u64 *valp)
 			grp = byte & 1;
 		/* Set byte lane select field */
 		mask  |= 0xfULL << (28 - 4 * byte);
-		value |= (u64)unit << (28 - 4 * byte);
+		value |= (unsigned long)unit << (28 - 4 * byte);
 	}
 	if (grp == 0) {
 		/* increment PMC1/2/5/6 field */
@@ -236,7 +239,7 @@ static int p970_get_constraint(u64 event, u64 *maskp, u64 *valp)
 	spcsel = (event >> PM_SPCSEL_SH) & PM_SPCSEL_MSK;
 	if (spcsel) {
 		mask  |= 3ull << 48;
-		value |= (u64)spcsel << 48;
+		value |= (unsigned long)spcsel << 48;
 	}
 	*maskp = mask;
 	*valp = value;
@@ -257,9 +260,9 @@ static int p970_get_alternatives(u64 event, unsigned int flags, u64 alt[])
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
@@ -320,7 +323,7 @@ static int p970_compute_mmcr(u64 event[], int n_ev,
 			continue;
 		ttm = unitmap[i];
 		++ttmuse[(ttm >> 2) & 1];
-		mmcr1 |= (u64)(ttm & ~4) << MMCR1_TTM1SEL_SH;
+		mmcr1 |= (unsigned long)(ttm & ~4) << MMCR1_TTM1SEL_SH;
 	}
 	/* Check only one unit per TTMx */
 	if (ttmuse[0] > 1 || ttmuse[1] > 1)
@@ -340,7 +343,8 @@ static int p970_compute_mmcr(u64 event[], int n_ev,
 			if (unit == PM_LSU1L && byte >= 2)
 				mmcr1 |= 1ull << (MMCR1_TTM3SEL_SH + 3 - byte);
 		}
-		mmcr1 |= (u64)ttm << (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
+		mmcr1 |= (unsigned long)ttm
+			<< (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
 	}
 
 	/* Second pass: assign PMCs, set PMCxSEL and PMCx_ADDER_SEL fields */
@@ -386,7 +390,8 @@ static int p970_compute_mmcr(u64 event[], int n_ev,
 	for (pmc = 0; pmc < 2; ++pmc)
 		mmcr0 |= pmcsel[pmc] << (MMCR0_PMC1SEL_SH - 7 * pmc);
 	for (; pmc < 8; ++pmc)
-		mmcr1 |= (u64)pmcsel[pmc] << (MMCR1_PMC3SEL_SH - 5 * (pmc - 2));
+		mmcr1 |= (unsigned long)pmcsel[pmc]
+			<< (MMCR1_PMC3SEL_SH - 5 * (pmc - 2));
 	if (pmc_inuse & 1)
 		mmcr0 |= MMCR0_PMC1CE;
 	if (pmc_inuse & 0xfe)
@@ -401,7 +406,7 @@ static int p970_compute_mmcr(u64 event[], int n_ev,
 	return 0;
 }
 
-static void p970_disable_pmc(unsigned int pmc, u64 mmcr[])
+static void p970_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 {
 	int shift, i;
 
@@ -467,16 +472,28 @@ static int ppc970_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu ppc970_pmu = {
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
+static struct power_pmu ppc970_pmu = {
+	.name			= "PPC970/FX/MP",
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
+
+static int init_ppc970_pmu(void)
+{
+	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/970")
+	    && strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/970MP"))
+		return -ENODEV;
+
+	return register_power_pmu(&ppc970_pmu);
+}
+
+arch_initcall(init_ppc970_pmu);
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 15391c2..eae4511 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -53,6 +53,7 @@
 #include <linux/posix-timers.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
+#include <linux/perf_counter.h>
 
 #include <asm/io.h>
 #include <asm/processor.h>
@@ -525,6 +526,26 @@ void __init iSeries_time_init_early(void)
 }
 #endif /* CONFIG_PPC_ISERIES */
 
+#if defined(CONFIG_PERF_COUNTERS) && defined(CONFIG_PPC32)
+DEFINE_PER_CPU(u8, perf_counter_pending);
+
+void set_perf_counter_pending(void)
+{
+	get_cpu_var(perf_counter_pending) = 1;
+	set_dec(1);
+	put_cpu_var(perf_counter_pending);
+}
+
+#define test_perf_counter_pending()	__get_cpu_var(perf_counter_pending)
+#define clear_perf_counter_pending()	__get_cpu_var(perf_counter_pending) = 0
+
+#else  /* CONFIG_PERF_COUNTERS && CONFIG_PPC32 */
+
+#define test_perf_counter_pending()	0
+#define clear_perf_counter_pending()
+
+#endif /* CONFIG_PERF_COUNTERS && CONFIG_PPC32 */
+
 /*
  * For iSeries shared processors, we have to let the hypervisor
  * set the hardware decrementer.  We set a virtual decrementer
@@ -551,6 +572,10 @@ void timer_interrupt(struct pt_regs * regs)
 	set_dec(DECREMENTER_MAX);
 
 #ifdef CONFIG_PPC32
+	if (test_perf_counter_pending()) {
+		clear_perf_counter_pending();
+		perf_counter_do_pending();
+	}
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
 		do_IRQ(regs);
 #endif
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index cca6b4f..8485c8c 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -1,7 +1,7 @@
 config PPC64
 	bool "64-bit kernel"
 	default n
-	select HAVE_PERF_COUNTERS
+	select PPC_HAVE_PMU_SUPPORT
 	help
 	  This option selects whether a 32-bit or a 64-bit kernel
 	  will be built.
@@ -75,6 +75,7 @@ config POWER4_ONLY
 config 6xx
 	def_bool y
 	depends on PPC32 && PPC_BOOK3S
+	select PPC_HAVE_PMU_SUPPORT
 
 config POWER3
 	bool
@@ -243,6 +244,15 @@ config VIRT_CPU_ACCOUNTING
 
 	  If in doubt, say Y here.
 
+config PPC_HAVE_PMU_SUPPORT
+       bool
+
+config PPC_PERF_CTRS
+       def_bool y
+       depends on PERF_COUNTERS && PPC_HAVE_PMU_SUPPORT
+       help
+         This enables the powerpc-specific perf_counter back-end.
+
 config SMP
 	depends on PPC_STD_MMU || FSL_BOOKE
 	bool "Symmetric multi-processing support"
diff --git a/arch/x86/include/asm/perf_counter.h b/arch/x86/include/asm/perf_counter.h
index 876ed97..5fb33e1 100644
--- a/arch/x86/include/asm/perf_counter.h
+++ b/arch/x86/include/asm/perf_counter.h
@@ -84,11 +84,6 @@ union cpuid10_edx {
 #define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
 #define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
 
-extern void set_perf_counter_pending(void);
-
-#define clear_perf_counter_pending()	do { } while (0)
-#define test_perf_counter_pending()	(0)
-
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
 extern void perf_counters_lapic_init(void);
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 31bd120..01fd946 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -49,13 +49,17 @@ extern void set_pmd_pfn(unsigned long, unsigned long, pgprot_t);
 #endif
 
 #if defined(CONFIG_HIGHPTE)
+#define __KM_PTE			\
+	(in_nmi() ? KM_NMI_PTE : 	\
+	 in_irq() ? KM_IRQ_PTE :	\
+	 KM_PTE0)
 #define pte_offset_map(dir, address)					\
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE0) +		\
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), __KM_PTE) +		\
 	 pte_index((address)))
 #define pte_offset_map_nested(dir, address)				\
 	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE1) +		\
 	 pte_index((address)))
-#define pte_unmap(pte) kunmap_atomic((pte), KM_PTE0)
+#define pte_unmap(pte) kunmap_atomic((pte), __KM_PTE)
 #define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
 #else
 #define pte_offset_map(dir, address)					\
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index b685ece..512ee87 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -25,7 +25,12 @@
 #define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
 
 #define KERNEL_DS	MAKE_MM_SEG(-1UL)
-#define USER_DS		MAKE_MM_SEG(PAGE_OFFSET)
+
+#ifdef CONFIG_X86_32
+# define USER_DS	MAKE_MM_SEG(PAGE_OFFSET)
+#else
+# define USER_DS	MAKE_MM_SEG(__VIRTUAL_MASK)
+#endif
 
 #define get_ds()	(KERNEL_DS)
 #define get_fs()	(current_thread_info()->addr_limit)
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 275bc14..76dfef2 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -19,6 +19,7 @@
 #include <linux/kdebug.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
+#include <linux/highmem.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -389,23 +390,23 @@ static u64 intel_pmu_raw_event(u64 event)
 	return event & CORE_EVNTSEL_MASK;
 }
 
-static const u64 amd_0f_hw_cache_event_ids
+static const u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
 {
  [ C(L1D) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
+		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0042, /* Data Cache Refills from L2 */
 		[ C(RESULT_MISS)   ] = 0,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0267, /* Data Prefetcher :attempts  */
+		[ C(RESULT_MISS)   ] = 0x0167, /* Data Prefetcher :cancelled */
 	},
  },
  [ C(L1I ) ] = {
@@ -418,17 +419,17 @@ static const u64 amd_0f_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x014B, /* Prefetch Instructions :Load */
 		[ C(RESULT_MISS)   ] = 0,
 	},
  },
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x037D, /* Requests to L2 Cache :IC+DC */
+		[ C(RESULT_MISS)   ] = 0x037E, /* L2 Cache Misses : IC+DC     */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x017F, /* L2 Fill/Writeback           */
 		[ C(RESULT_MISS)   ] = 0,
 	},
 	[ C(OP_PREFETCH) ] = {
@@ -438,8 +439,8 @@ static const u64 amd_0f_hw_cache_event_ids
  },
  [ C(DTLB) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
+		[ C(RESULT_MISS)   ] = 0x0046, /* L1 DTLB and L2 DLTB Miss   */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = 0,
@@ -1223,6 +1224,8 @@ again:
 		if (!intel_pmu_save_and_restart(counter))
 			continue;
 
+		data.period = counter->hw.last_period;
+
 		if (perf_counter_overflow(counter, 1, &data))
 			intel_pmu_disable_counter(&counter->hw, bit);
 	}
@@ -1459,18 +1462,16 @@ static int intel_pmu_init(void)
 
 static int amd_pmu_init(void)
 {
+	/* Performance-monitoring supported from K7 and later: */
+	if (boot_cpu_data.x86 < 6)
+		return -ENODEV;
+
 	x86_pmu = amd_pmu;
 
-	switch (boot_cpu_data.x86) {
-	case 0x0f:
-	case 0x10:
-	case 0x11:
-		memcpy(hw_cache_event_ids, amd_0f_hw_cache_event_ids,
-		       sizeof(hw_cache_event_ids));
+	/* Events are common for all AMDs */
+	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
+	       sizeof(hw_cache_event_ids));
 
-		pr_cont("AMD Family 0f/10/11 events, ");
-		break;
-	}
 	return 0;
 }
 
@@ -1554,9 +1555,9 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
  */
 
 static inline
-void callchain_store(struct perf_callchain_entry *entry, unsigned long ip)
+void callchain_store(struct perf_callchain_entry *entry, u64 ip)
 {
-	if (entry->nr < MAX_STACK_DEPTH)
+	if (entry->nr < PERF_MAX_STACK_DEPTH)
 		entry->ip[entry->nr++] = ip;
 }
 
@@ -1577,8 +1578,8 @@ static void backtrace_warning(void *data, char *msg)
 
 static int backtrace_stack(void *data, char *name)
 {
-	/* Don't bother with IRQ stacks for now */
-	return -1;
+	/* Process all stacks: */
+	return 0;
 }
 
 static void backtrace_address(void *data, unsigned long addr, int reliable)
@@ -1596,47 +1597,59 @@ static const struct stacktrace_ops backtrace_ops = {
 	.address		= backtrace_address,
 };
 
+#include "../dumpstack.h"
+
 static void
 perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
-	unsigned long bp;
-	char *stack;
-	int nr = entry->nr;
+	callchain_store(entry, PERF_CONTEXT_KERNEL);
+	callchain_store(entry, regs->ip);
 
-	callchain_store(entry, instruction_pointer(regs));
+	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
+}
 
-	stack = ((char *)regs + sizeof(struct pt_regs));
-#ifdef CONFIG_FRAME_POINTER
-	bp = frame_pointer(regs);
-#else
-	bp = 0;
-#endif
+/*
+ * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
+ */
+static unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+{
+	unsigned long offset, addr = (unsigned long)from;
+	int type = in_nmi() ? KM_NMI : KM_IRQ0;
+	unsigned long size, len = 0;
+	struct page *page;
+	void *map;
+	int ret;
 
-	dump_trace(NULL, regs, (void *)stack, bp, &backtrace_ops, entry);
+	do {
+		ret = __get_user_pages_fast(addr, 1, 0, &page);
+		if (!ret)
+			break;
 
-	entry->kernel = entry->nr - nr;
-}
+		offset = addr & (PAGE_SIZE - 1);
+		size = min(PAGE_SIZE - offset, n - len);
 
+		map = kmap_atomic(page, type);
+		memcpy(to, map+offset, size);
+		kunmap_atomic(map, type);
+		put_page(page);
 
-struct stack_frame {
-	const void __user	*next_fp;
-	unsigned long		return_address;
-};
+		len  += size;
+		to   += size;
+		addr += size;
+
+	} while (len < n);
+
+	return len;
+}
 
 static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
 {
-	int ret;
+	unsigned long bytes;
 
-	if (!access_ok(VERIFY_READ, fp, sizeof(*frame)))
-		return 0;
+	bytes = copy_from_user_nmi(frame, fp, sizeof(*frame));
 
-	ret = 1;
-	pagefault_disable();
-	if (__copy_from_user_inatomic(frame, fp, sizeof(*frame)))
-		ret = 0;
-	pagefault_enable();
-
-	return ret;
+	return bytes == sizeof(*frame);
 }
 
 static void
@@ -1644,28 +1657,28 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
 	struct stack_frame frame;
 	const void __user *fp;
-	int nr = entry->nr;
 
-	regs = (struct pt_regs *)current->thread.sp0 - 1;
-	fp   = (void __user *)regs->bp;
+	if (!user_mode(regs))
+		regs = task_pt_regs(current);
 
+	fp = (void __user *)regs->bp;
+
+	callchain_store(entry, PERF_CONTEXT_USER);
 	callchain_store(entry, regs->ip);
 
-	while (entry->nr < MAX_STACK_DEPTH) {
-		frame.next_fp	     = NULL;
+	while (entry->nr < PERF_MAX_STACK_DEPTH) {
+		frame.next_frame	     = NULL;
 		frame.return_address = 0;
 
 		if (!copy_stack_frame(fp, &frame))
 			break;
 
-		if ((unsigned long)fp < user_stack_pointer(regs))
+		if ((unsigned long)fp < regs->sp)
 			break;
 
 		callchain_store(entry, frame.return_address);
-		fp = frame.next_fp;
+		fp = frame.next_frame;
 	}
-
-	entry->user = entry->nr - nr;
 }
 
 static void
@@ -1701,9 +1714,6 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 		entry = &__get_cpu_var(irq_entry);
 
 	entry->nr = 0;
-	entry->hv = 0;
-	entry->kernel = 0;
-	entry->user = 0;
 
 	perf_do_callchain(regs, entry);
 
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 6340cef..2d1d784 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -14,7 +14,7 @@
 static inline pte_t gup_get_pte(pte_t *ptep)
 {
 #ifndef CONFIG_X86_PAE
-	return *ptep;
+	return ACCESS_ONCE(*ptep);
 #else
 	/*
 	 * With get_user_pages_fast, we walk down the pagetables without taking
@@ -219,6 +219,62 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 	return 1;
 }
 
+/*
+ * Like get_user_pages_fast() except its IRQ-safe in that it won't fall
+ * back to the regular GUP.
+ */
+int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
+			  struct page **pages)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long addr, len, end;
+	unsigned long next;
+	unsigned long flags;
+	pgd_t *pgdp;
+	int nr = 0;
+
+	start &= PAGE_MASK;
+	addr = start;
+	len = (unsigned long) nr_pages << PAGE_SHIFT;
+	end = start + len;
+	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
+					(void __user *)start, len)))
+		return 0;
+
+	/*
+	 * XXX: batch / limit 'nr', to avoid large irq off latency
+	 * needs some instrumenting to determine the common sizes used by
+	 * important workloads (eg. DB2), and whether limiting the batch size
+	 * will decrease performance.
+	 *
+	 * It seems like we're in the clear for the moment. Direct-IO is
+	 * the main guy that batches up lots of get_user_pages, and even
+	 * they are limited to 64-at-a-time which is not so many.
+	 */
+	/*
+	 * This doesn't prevent pagetable teardown, but does prevent
+	 * the pagetables and pages from being freed on x86.
+	 *
+	 * So long as we atomically load page table pointers versus teardown
+	 * (which we do on x86, with the above PAE exception), we can follow the
+	 * address down to the the page and take a ref on it.
+	 */
+	local_irq_save(flags);
+	pgdp = pgd_offset(mm, addr);
+	do {
+		pgd_t pgd = *pgdp;
+
+		next = pgd_addr_end(addr, end);
+		if (pgd_none(pgd))
+			break;
+		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+			break;
+	} while (pgdp++, addr = next, addr != end);
+	local_irq_restore(flags);
+
+	return nr;
+}
+
 /**
  * get_user_pages_fast() - pin user pages in memory
  * @start:	starting user address
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 1dd96d4..47d4a01 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -52,6 +52,19 @@ static const struct dentry_operations anon_inodefs_dentry_operations = {
 	.d_delete	= anon_inodefs_delete_dentry,
 };
 
+/*
+ * nop .set_page_dirty method so that people can use .page_mkwrite on
+ * anon inodes.
+ */
+static int anon_set_page_dirty(struct page *page)
+{
+	return 0;
+};
+
+static const struct address_space_operations anon_aops = {
+	.set_page_dirty = anon_set_page_dirty,
+};
+
 /**
  * anon_inode_getfd - creates a new file instance by hooking it up to an
  *                    anonymous inode, and a dentry that describe the "class"
@@ -151,6 +164,8 @@ static struct inode *anon_inode_mkinode(void)
 
 	inode->i_fop = &anon_inode_fops;
 
+	inode->i_mapping->a_ops = &anon_aops;
+
 	/*
 	 * Mark the inode dirty from the very beginning,
 	 * that way it will never be moved to the dirty
diff --git a/include/asm-generic/kmap_types.h b/include/asm-generic/kmap_types.h
index 54e8b3d..eddbce0 100644
--- a/include/asm-generic/kmap_types.h
+++ b/include/asm-generic/kmap_types.h
@@ -24,7 +24,10 @@ D(12)	KM_SOFTIRQ1,
 D(13)	KM_SYNC_ICACHE,
 D(14)	KM_SYNC_DCACHE,
 D(15)	KM_UML_USERCOPY, /* UML specific, for copy_*_user - used in do_op_one_page */
-D(16)	KM_TYPE_NR
+D(16)	KM_IRQ_PTE,
+D(17)	KM_NMI,
+D(18)	KM_NMI_PTE,
+D(19)	KM_TYPE_NR
 };
 
 #undef D
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d88d6fc..cf260d8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -854,6 +854,12 @@ extern int mprotect_fixup(struct vm_area_struct *vma,
 			  unsigned long end, unsigned long newflags);
 
 /*
+ * doesn't attempt to fault and will return short.
+ */
+int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
+			  struct page **pages);
+
+/*
  * A callback you can register to apply pressure to ageable caches.
  *
  * 'shrink' is passed a count 'nr_to_scan' and a 'gfpmask'.  It should
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 1b3118a..89698d8 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -236,10 +236,16 @@ struct perf_counter_mmap_page {
 	/*
 	 * Control data for the mmap() data buffer.
 	 *
-	 * User-space reading this value should issue an rmb(), on SMP capable
-	 * platforms, after reading this value -- see perf_counter_wakeup().
+	 * User-space reading the @data_head value should issue an rmb(), on
+	 * SMP capable platforms, after reading this value -- see
+	 * perf_counter_wakeup().
+	 *
+	 * When the mapping is PROT_WRITE the @data_tail value should be
+	 * written by userspace to reflect the last read data. In this case
+	 * the kernel will not over-write unread data.
 	 */
 	__u64   data_head;		/* head in the data section */
+	__u64	data_tail;		/* user-space written tail */
 };
 
 #define PERF_EVENT_MISC_CPUMODE_MASK		(3 << 0)
@@ -275,6 +281,15 @@ enum perf_event_type {
 
 	/*
 	 * struct {
+	 * 	struct perf_event_header	header;
+	 * 	u64				id;
+	 * 	u64				lost;
+	 * };
+	 */
+	PERF_EVENT_LOST			= 2,
+
+	/*
+	 * struct {
 	 *	struct perf_event_header	header;
 	 *
 	 *	u32				pid, tid;
@@ -313,30 +328,39 @@ enum perf_event_type {
 
 	/*
 	 * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
-	 * will be PERF_RECORD_*
+	 * will be PERF_SAMPLE_*
 	 *
 	 * struct {
 	 *	struct perf_event_header	header;
 	 *
-	 *	{ u64			ip;	  } && PERF_RECORD_IP
-	 *	{ u32			pid, tid; } && PERF_RECORD_TID
-	 *	{ u64			time;     } && PERF_RECORD_TIME
-	 *	{ u64			addr;     } && PERF_RECORD_ADDR
-	 *	{ u64			config;   } && PERF_RECORD_CONFIG
-	 *	{ u32			cpu, res; } && PERF_RECORD_CPU
+	 *	{ u64			ip;	  } && PERF_SAMPLE_IP
+	 *	{ u32			pid, tid; } && PERF_SAMPLE_TID
+	 *	{ u64			time;     } && PERF_SAMPLE_TIME
+	 *	{ u64			addr;     } && PERF_SAMPLE_ADDR
+	 *	{ u64			config;   } && PERF_SAMPLE_CONFIG
+	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
 	 *
 	 *	{ u64			nr;
-	 *	  { u64 id, val; }	cnt[nr];  } && PERF_RECORD_GROUP
+	 *	  { u64 id, val; }	cnt[nr];  } && PERF_SAMPLE_GROUP
 	 *
-	 *	{ u16			nr,
-	 *				hv,
-	 *				kernel,
-	 *				user;
-	 *	  u64			ips[nr];  } && PERF_RECORD_CALLCHAIN
+	 *	{ u64			nr,
+	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
 	 * };
 	 */
 };
 
+enum perf_callchain_context {
+	PERF_CONTEXT_HV			= (__u64)-32,
+	PERF_CONTEXT_KERNEL		= (__u64)-128,
+	PERF_CONTEXT_USER		= (__u64)-512,
+
+	PERF_CONTEXT_GUEST		= (__u64)-2048,
+	PERF_CONTEXT_GUEST_KERNEL	= (__u64)-2176,
+	PERF_CONTEXT_GUEST_USER		= (__u64)-2560,
+
+	PERF_CONTEXT_MAX		= (__u64)-4095,
+};
+
 #ifdef __KERNEL__
 /*
  * Kernel-internal data types and definitions:
@@ -356,6 +380,13 @@ enum perf_event_type {
 #include <linux/pid_namespace.h>
 #include <asm/atomic.h>
 
+#define PERF_MAX_STACK_DEPTH		255
+
+struct perf_callchain_entry {
+	__u64				nr;
+	__u64				ip[PERF_MAX_STACK_DEPTH];
+};
+
 struct task_struct;
 
 /**
@@ -414,6 +445,7 @@ struct file;
 struct perf_mmap_data {
 	struct rcu_head			rcu_head;
 	int				nr_pages;	/* nr of data pages  */
+	int				writable;	/* are we writable   */
 	int				nr_locked;	/* nr pages mlocked  */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
@@ -423,8 +455,8 @@ struct perf_mmap_data {
 	atomic_long_t			done_head;	/* completed head    */
 
 	atomic_t			lock;		/* concurrent writes */
-
 	atomic_t			wakeup;		/* needs a wakeup    */
+	atomic_t			lost;		/* nr records lost   */
 
 	struct perf_counter_mmap_page   *user_page;
 	void				*data_pages[0];
@@ -604,6 +636,7 @@ extern void perf_counter_task_tick(struct task_struct *task, int cpu);
 extern int perf_counter_init_task(struct task_struct *child);
 extern void perf_counter_exit_task(struct task_struct *child);
 extern void perf_counter_free_task(struct task_struct *task);
+extern void set_perf_counter_pending(void);
 extern void perf_counter_do_pending(void);
 extern void perf_counter_print_debug(void);
 extern void __perf_disable(void);
@@ -649,18 +682,6 @@ static inline void perf_counter_mmap(struct vm_area_struct *vma)
 extern void perf_counter_comm(struct task_struct *tsk);
 extern void perf_counter_fork(struct task_struct *tsk);
 
-extern void perf_counter_task_migration(struct task_struct *task, int cpu);
-
-#define MAX_STACK_DEPTH			255
-
-struct perf_callchain_entry {
-	u16				nr;
-	u16				hv;
-	u16				kernel;
-	u16				user;
-	u64				ip[MAX_STACK_DEPTH];
-};
-
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
 extern int sysctl_perf_counter_paranoid;
@@ -701,8 +722,6 @@ static inline void perf_counter_mmap(struct vm_area_struct *vma)	{ }
 static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_fork(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
-static inline void perf_counter_task_migration(struct task_struct *task,
-					       int cpu)			{ }
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 29b685f..1a933a2 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -124,7 +124,7 @@ void perf_enable(void)
 
 static void get_ctx(struct perf_counter_context *ctx)
 {
-	atomic_inc(&ctx->refcount);
+	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
 }
 
 static void free_ctx(struct rcu_head *head)
@@ -175,6 +175,11 @@ perf_lock_task_context(struct task_struct *task, unsigned long *flags)
 			spin_unlock_irqrestore(&ctx->lock, *flags);
 			goto retry;
 		}
+
+		if (!atomic_inc_not_zero(&ctx->refcount)) {
+			spin_unlock_irqrestore(&ctx->lock, *flags);
+			ctx = NULL;
+		}
 	}
 	rcu_read_unlock();
 	return ctx;
@@ -193,7 +198,6 @@ static struct perf_counter_context *perf_pin_task_context(struct task_struct *ta
 	ctx = perf_lock_task_context(task, &flags);
 	if (ctx) {
 		++ctx->pin_count;
-		get_ctx(ctx);
 		spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 	return ctx;
@@ -1283,7 +1287,7 @@ static void perf_ctx_adjust_freq(struct perf_counter_context *ctx)
 		if (!interrupts) {
 			perf_disable();
 			counter->pmu->disable(counter);
-			atomic_set(&hwc->period_left, 0);
+			atomic64_set(&hwc->period_left, 0);
 			counter->pmu->enable(counter);
 			perf_enable();
 		}
@@ -1459,11 +1463,6 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 			put_ctx(parent_ctx);
 			ctx->parent_ctx = NULL;		/* no longer a clone */
 		}
-		/*
-		 * Get an extra reference before dropping the lock so that
-		 * this context won't get freed if the task exits.
-		 */
-		get_ctx(ctx);
 		spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
@@ -1553,7 +1552,7 @@ static int perf_release(struct inode *inode, struct file *file)
 static ssize_t
 perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 {
-	u64 values[3];
+	u64 values[4];
 	int n;
 
 	/*
@@ -1620,22 +1619,6 @@ static void perf_counter_reset(struct perf_counter *counter)
 	perf_counter_update_userpage(counter);
 }
 
-static void perf_counter_for_each_sibling(struct perf_counter *counter,
-					  void (*func)(struct perf_counter *))
-{
-	struct perf_counter_context *ctx = counter->ctx;
-	struct perf_counter *sibling;
-
-	WARN_ON_ONCE(ctx->parent_ctx);
-	mutex_lock(&ctx->mutex);
-	counter = counter->group_leader;
-
-	func(counter);
-	list_for_each_entry(sibling, &counter->sibling_list, list_entry)
-		func(sibling);
-	mutex_unlock(&ctx->mutex);
-}
-
 /*
  * Holding the top-level counter's child_mutex means that any
  * descendant process that has inherited this counter will block
@@ -1658,14 +1641,18 @@ static void perf_counter_for_each_child(struct perf_counter *counter,
 static void perf_counter_for_each(struct perf_counter *counter,
 				  void (*func)(struct perf_counter *))
 {
-	struct perf_counter *child;
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_counter *sibling;
 
-	WARN_ON_ONCE(counter->ctx->parent_ctx);
-	mutex_lock(&counter->child_mutex);
-	perf_counter_for_each_sibling(counter, func);
-	list_for_each_entry(child, &counter->child_list, child_list)
-		perf_counter_for_each_sibling(child, func);
-	mutex_unlock(&counter->child_mutex);
+	WARN_ON_ONCE(ctx->parent_ctx);
+	mutex_lock(&ctx->mutex);
+	counter = counter->group_leader;
+
+	perf_counter_for_each_child(counter, func);
+	func(counter);
+	list_for_each_entry(sibling, &counter->sibling_list, list_entry)
+		perf_counter_for_each_child(counter, func);
+	mutex_unlock(&ctx->mutex);
 }
 
 static int perf_counter_period(struct perf_counter *counter, u64 __user *arg)
@@ -1806,6 +1793,12 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct perf_mmap_data *data;
 	int ret = VM_FAULT_SIGBUS;
 
+	if (vmf->flags & FAULT_FLAG_MKWRITE) {
+		if (vmf->pgoff == 0)
+			ret = 0;
+		return ret;
+	}
+
 	rcu_read_lock();
 	data = rcu_dereference(counter->data);
 	if (!data)
@@ -1819,9 +1812,16 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		if ((unsigned)nr > data->nr_pages)
 			goto unlock;
 
+		if (vmf->flags & FAULT_FLAG_WRITE)
+			goto unlock;
+
 		vmf->page = virt_to_page(data->data_pages[nr]);
 	}
+
 	get_page(vmf->page);
+	vmf->page->mapping = vma->vm_file->f_mapping;
+	vmf->page->index   = vmf->pgoff;
+
 	ret = 0;
 unlock:
 	rcu_read_unlock();
@@ -1874,6 +1874,14 @@ fail:
 	return -ENOMEM;
 }
 
+static void perf_mmap_free_page(unsigned long addr)
+{
+	struct page *page = virt_to_page(addr);
+
+	page->mapping = NULL;
+	__free_page(page);
+}
+
 static void __perf_mmap_data_free(struct rcu_head *rcu_head)
 {
 	struct perf_mmap_data *data;
@@ -1881,9 +1889,10 @@ static void __perf_mmap_data_free(struct rcu_head *rcu_head)
 
 	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
 
-	free_page((unsigned long)data->user_page);
+	perf_mmap_free_page((unsigned long)data->user_page);
 	for (i = 0; i < data->nr_pages; i++)
-		free_page((unsigned long)data->data_pages[i]);
+		perf_mmap_free_page((unsigned long)data->data_pages[i]);
+
 	kfree(data);
 }
 
@@ -1920,9 +1929,10 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 }
 
 static struct vm_operations_struct perf_mmap_vmops = {
-	.open  = perf_mmap_open,
-	.close = perf_mmap_close,
-	.fault = perf_mmap_fault,
+	.open		= perf_mmap_open,
+	.close		= perf_mmap_close,
+	.fault		= perf_mmap_fault,
+	.page_mkwrite	= perf_mmap_fault,
 };
 
 static int perf_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1936,7 +1946,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	long user_extra, extra;
 	int ret = 0;
 
-	if (!(vma->vm_flags & VM_SHARED) || (vma->vm_flags & VM_WRITE))
+	if (!(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
@@ -1995,10 +2005,12 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	atomic_long_add(user_extra, &user->locked_vm);
 	vma->vm_mm->locked_vm += extra;
 	counter->data->nr_locked = extra;
+	if (vma->vm_flags & VM_WRITE)
+		counter->data->writable = 1;
+
 unlock:
 	mutex_unlock(&counter->mmap_mutex);
 
-	vma->vm_flags &= ~VM_MAYWRITE;
 	vma->vm_flags |= VM_RESERVED;
 	vma->vm_ops = &perf_mmap_vmops;
 
@@ -2175,11 +2187,38 @@ struct perf_output_handle {
 	unsigned long		head;
 	unsigned long		offset;
 	int			nmi;
-	int			overflow;
+	int			sample;
 	int			locked;
 	unsigned long		flags;
 };
 
+static bool perf_output_space(struct perf_mmap_data *data,
+			      unsigned int offset, unsigned int head)
+{
+	unsigned long tail;
+	unsigned long mask;
+
+	if (!data->writable)
+		return true;
+
+	mask = (data->nr_pages << PAGE_SHIFT) - 1;
+	/*
+	 * Userspace could choose to issue a mb() before updating the tail
+	 * pointer. So that all reads will be completed before the write is
+	 * issued.
+	 */
+	tail = ACCESS_ONCE(data->user_page->data_tail);
+	smp_rmb();
+
+	offset = (offset - tail) & mask;
+	head   = (head   - tail) & mask;
+
+	if ((int)(head - offset) < 0)
+		return false;
+
+	return true;
+}
+
 static void perf_output_wakeup(struct perf_output_handle *handle)
 {
 	atomic_set(&handle->data->poll, POLL_IN);
@@ -2270,12 +2309,57 @@ out:
 	local_irq_restore(handle->flags);
 }
 
+static void perf_output_copy(struct perf_output_handle *handle,
+			     const void *buf, unsigned int len)
+{
+	unsigned int pages_mask;
+	unsigned int offset;
+	unsigned int size;
+	void **pages;
+
+	offset		= handle->offset;
+	pages_mask	= handle->data->nr_pages - 1;
+	pages		= handle->data->data_pages;
+
+	do {
+		unsigned int page_offset;
+		int nr;
+
+		nr	    = (offset >> PAGE_SHIFT) & pages_mask;
+		page_offset = offset & (PAGE_SIZE - 1);
+		size	    = min_t(unsigned int, PAGE_SIZE - page_offset, len);
+
+		memcpy(pages[nr] + page_offset, buf, size);
+
+		len	    -= size;
+		buf	    += size;
+		offset	    += size;
+	} while (len);
+
+	handle->offset = offset;
+
+	/*
+	 * Check we didn't copy past our reservation window, taking the
+	 * possible unsigned int wrap into account.
+	 */
+	WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0);
+}
+
+#define perf_output_put(handle, x) \
+	perf_output_copy((handle), &(x), sizeof(x))
+
 static int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_counter *counter, unsigned int size,
-			     int nmi, int overflow)
+			     int nmi, int sample)
 {
 	struct perf_mmap_data *data;
 	unsigned int offset, head;
+	int have_lost;
+	struct {
+		struct perf_event_header header;
+		u64			 id;
+		u64			 lost;
+	} lost_event;
 
 	/*
 	 * For inherited counters we send all the output towards the parent.
@@ -2288,19 +2372,25 @@ static int perf_output_begin(struct perf_output_handle *handle,
 	if (!data)
 		goto out;
 
-	handle->data	 = data;
-	handle->counter	 = counter;
-	handle->nmi	 = nmi;
-	handle->overflow = overflow;
+	handle->data	= data;
+	handle->counter	= counter;
+	handle->nmi	= nmi;
+	handle->sample	= sample;
 
 	if (!data->nr_pages)
 		goto fail;
 
+	have_lost = atomic_read(&data->lost);
+	if (have_lost)
+		size += sizeof(lost_event);
+
 	perf_output_lock(handle);
 
 	do {
 		offset = head = atomic_long_read(&data->head);
 		head += size;
+		if (unlikely(!perf_output_space(data, offset, head)))
+			goto fail;
 	} while (atomic_long_cmpxchg(&data->head, offset, head) != offset);
 
 	handle->offset	= offset;
@@ -2309,55 +2399,27 @@ static int perf_output_begin(struct perf_output_handle *handle,
 	if ((offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT))
 		atomic_set(&data->wakeup, 1);
 
+	if (have_lost) {
+		lost_event.header.type = PERF_EVENT_LOST;
+		lost_event.header.misc = 0;
+		lost_event.header.size = sizeof(lost_event);
+		lost_event.id          = counter->id;
+		lost_event.lost        = atomic_xchg(&data->lost, 0);
+
+		perf_output_put(handle, lost_event);
+	}
+
 	return 0;
 
 fail:
-	perf_output_wakeup(handle);
+	atomic_inc(&data->lost);
+	perf_output_unlock(handle);
 out:
 	rcu_read_unlock();
 
 	return -ENOSPC;
 }
 
-static void perf_output_copy(struct perf_output_handle *handle,
-			     const void *buf, unsigned int len)
-{
-	unsigned int pages_mask;
-	unsigned int offset;
-	unsigned int size;
-	void **pages;
-
-	offset		= handle->offset;
-	pages_mask	= handle->data->nr_pages - 1;
-	pages		= handle->data->data_pages;
-
-	do {
-		unsigned int page_offset;
-		int nr;
-
-		nr	    = (offset >> PAGE_SHIFT) & pages_mask;
-		page_offset = offset & (PAGE_SIZE - 1);
-		size	    = min_t(unsigned int, PAGE_SIZE - page_offset, len);
-
-		memcpy(pages[nr] + page_offset, buf, size);
-
-		len	    -= size;
-		buf	    += size;
-		offset	    += size;
-	} while (len);
-
-	handle->offset = offset;
-
-	/*
-	 * Check we didn't copy past our reservation window, taking the
-	 * possible unsigned int wrap into account.
-	 */
-	WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0);
-}
-
-#define perf_output_put(handle, x) \
-	perf_output_copy((handle), &(x), sizeof(x))
-
 static void perf_output_end(struct perf_output_handle *handle)
 {
 	struct perf_counter *counter = handle->counter;
@@ -2365,7 +2427,7 @@ static void perf_output_end(struct perf_output_handle *handle)
 
 	int wakeup_events = counter->attr.wakeup_events;
 
-	if (handle->overflow && wakeup_events) {
+	if (handle->sample && wakeup_events) {
 		int events = atomic_inc_return(&data->events);
 		if (events >= wakeup_events) {
 			atomic_sub(wakeup_events, &data->events);
@@ -2970,7 +3032,7 @@ static void perf_log_throttle(struct perf_counter *counter, int enable)
 }
 
 /*
- * Generic counter overflow handling.
+ * Generic counter overflow handling, sampling.
  */
 
 int perf_counter_overflow(struct perf_counter *counter, int nmi,
@@ -3109,20 +3171,15 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 }
 
 static void perf_swcounter_overflow(struct perf_counter *counter,
-				    int nmi, struct pt_regs *regs, u64 addr)
+				    int nmi, struct perf_sample_data *data)
 {
-	struct perf_sample_data data = {
-		.regs	= regs,
-		.addr	= addr,
-		.period	= counter->hw.last_period,
-	};
+	data->period = counter->hw.last_period;
 
 	perf_swcounter_update(counter);
 	perf_swcounter_set_period(counter);
-	if (perf_counter_overflow(counter, nmi, &data))
+	if (perf_counter_overflow(counter, nmi, data))
 		/* soft-disable the counter */
 		;
-
 }
 
 static int perf_swcounter_is_counting(struct perf_counter *counter)
@@ -3187,18 +3244,18 @@ static int perf_swcounter_match(struct perf_counter *counter,
 }
 
 static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
-			       int nmi, struct pt_regs *regs, u64 addr)
+			       int nmi, struct perf_sample_data *data)
 {
 	int neg = atomic64_add_negative(nr, &counter->hw.count);
 
-	if (counter->hw.sample_period && !neg && regs)
-		perf_swcounter_overflow(counter, nmi, regs, addr);
+	if (counter->hw.sample_period && !neg && data->regs)
+		perf_swcounter_overflow(counter, nmi, data);
 }
 
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
-				     enum perf_type_id type, u32 event,
-				     u64 nr, int nmi, struct pt_regs *regs,
-				     u64 addr)
+				     enum perf_type_id type,
+				     u32 event, u64 nr, int nmi,
+				     struct perf_sample_data *data)
 {
 	struct perf_counter *counter;
 
@@ -3207,8 +3264,8 @@ static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
-		if (perf_swcounter_match(counter, type, event, regs))
-			perf_swcounter_add(counter, nr, nmi, regs, addr);
+		if (perf_swcounter_match(counter, type, event, data->regs))
+			perf_swcounter_add(counter, nr, nmi, data);
 	}
 	rcu_read_unlock();
 }
@@ -3227,9 +3284,9 @@ static int *perf_swcounter_recursion_context(struct perf_cpu_context *cpuctx)
 	return &cpuctx->recursion[0];
 }
 
-static void __perf_swcounter_event(enum perf_type_id type, u32 event,
-				   u64 nr, int nmi, struct pt_regs *regs,
-				   u64 addr)
+static void do_perf_swcounter_event(enum perf_type_id type, u32 event,
+				    u64 nr, int nmi,
+				    struct perf_sample_data *data)
 {
 	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
 	int *recursion = perf_swcounter_recursion_context(cpuctx);
@@ -3242,7 +3299,7 @@ static void __perf_swcounter_event(enum perf_type_id type, u32 event,
 	barrier();
 
 	perf_swcounter_ctx_event(&cpuctx->ctx, type, event,
-				 nr, nmi, regs, addr);
+				 nr, nmi, data);
 	rcu_read_lock();
 	/*
 	 * doesn't really matter which of the child contexts the
@@ -3250,7 +3307,7 @@ static void __perf_swcounter_event(enum perf_type_id type, u32 event,
 	 */
 	ctx = rcu_dereference(current->perf_counter_ctxp);
 	if (ctx)
-		perf_swcounter_ctx_event(ctx, type, event, nr, nmi, regs, addr);
+		perf_swcounter_ctx_event(ctx, type, event, nr, nmi, data);
 	rcu_read_unlock();
 
 	barrier();
@@ -3263,7 +3320,12 @@ out:
 void
 perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 {
-	__perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi, regs, addr);
+	struct perf_sample_data data = {
+		.regs = regs,
+		.addr = addr,
+	};
+
+	do_perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi, &data);
 }
 
 static void perf_swcounter_read(struct perf_counter *counter)
@@ -3404,36 +3466,18 @@ static const struct pmu perf_ops_task_clock = {
 	.read		= task_clock_perf_counter_read,
 };
 
-/*
- * Software counter: cpu migrations
- */
-void perf_counter_task_migration(struct task_struct *task, int cpu)
-{
-	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
-	struct perf_counter_context *ctx;
-
-	perf_swcounter_ctx_event(&cpuctx->ctx, PERF_TYPE_SOFTWARE,
-				 PERF_COUNT_SW_CPU_MIGRATIONS,
-				 1, 1, NULL, 0);
-
-	ctx = perf_pin_task_context(task);
-	if (ctx) {
-		perf_swcounter_ctx_event(ctx, PERF_TYPE_SOFTWARE,
-					 PERF_COUNT_SW_CPU_MIGRATIONS,
-					 1, 1, NULL, 0);
-		perf_unpin_context(ctx);
-	}
-}
-
 #ifdef CONFIG_EVENT_PROFILE
 void perf_tpcounter_event(int event_id)
 {
-	struct pt_regs *regs = get_irq_regs();
+	struct perf_sample_data data = {
+		.regs = get_irq_regs();
+		.addr = 0,
+	};
 
-	if (!regs)
-		regs = task_pt_regs(current);
+	if (!data.regs)
+		data.regs = task_pt_regs(current);
 
-	__perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, regs, 0);
+	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, &data);
 }
 EXPORT_SYMBOL_GPL(perf_tpcounter_event);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 8fb88a9..f46540b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1978,7 +1978,8 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 		if (task_hot(p, old_rq->clock, NULL))
 			schedstat_inc(p, se.nr_forced2_migrations);
 #endif
-		perf_counter_task_migration(p, new_cpu);
+		perf_swcounter_event(PERF_COUNT_SW_CPU_MIGRATIONS,
+				     1, 1, NULL, 0);
 	}
 	p->se.vruntime -= old_cfsrq->min_vruntime -
 					 new_cfsrq->min_vruntime;
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0cbd5d6..36d7eef 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -157,10 +157,15 @@ uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
 uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
+# If we're on a 64-bit kernel, use -m64
+ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
+  M64 := -m64
+endif
+
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-CFLAGS = -ggdb3 -Wall -Werror -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -O6
-LDFLAGS = -lpthread -lrt -lelf
+CFLAGS = $(M64) -ggdb3 -Wall -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -Werror -O6
+LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
@@ -285,6 +290,7 @@ LIB_FILE=libperf.a
 
 LIB_H += ../../include/linux/perf_counter.h
 LIB_H += perf.h
+LIB_H += types.h
 LIB_H += util/list.h
 LIB_H += util/rbtree.h
 LIB_H += util/levenshtein.h
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index b1ed5f7..7e58e3a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -25,6 +25,10 @@
 #define SHOW_USER	2
 #define SHOW_HV		4
 
+#define MIN_GREEN		0.5
+#define MIN_RED		5.0
+
+
 static char		const *input_name = "perf.data";
 static char		*vmlinux = "vmlinux";
 
@@ -39,40 +43,42 @@ static int		dump_trace = 0;
 
 static int		verbose;
 
+static int		print_line;
+
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
 struct ip_event {
 	struct perf_event_header header;
-	__u64 ip;
-	__u32 pid, tid;
+	u64 ip;
+	u32 pid, tid;
 };
 
 struct mmap_event {
 	struct perf_event_header header;
-	__u32 pid, tid;
-	__u64 start;
-	__u64 len;
-	__u64 pgoff;
+	u32 pid, tid;
+	u64 start;
+	u64 len;
+	u64 pgoff;
 	char filename[PATH_MAX];
 };
 
 struct comm_event {
 	struct perf_event_header header;
-	__u32 pid, tid;
+	u32 pid, tid;
 	char comm[16];
 };
 
 struct fork_event {
 	struct perf_event_header header;
-	__u32 pid, ppid;
+	u32 pid, ppid;
 };
 
 struct period_event {
 	struct perf_event_header header;
-	__u64 time;
-	__u64 id;
-	__u64 sample_period;
+	u64 time;
+	u64 id;
+	u64 sample_period;
 };
 
 typedef union event_union {
@@ -84,6 +90,13 @@ typedef union event_union {
 	struct period_event		period;
 } event_t;
 
+
+struct sym_ext {
+	struct rb_node	node;
+	double		percent;
+	char		*path;
+};
+
 static LIST_HEAD(dsos);
 static struct dso *kernel_dso;
 static struct dso *vdso;
@@ -145,7 +158,7 @@ static void dsos__fprintf(FILE *fp)
 		dso__fprintf(pos, fp);
 }
 
-static struct symbol *vdso__find_symbol(struct dso *dso, __u64 ip)
+static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
 {
 	return dso__find_symbol(kernel_dso, ip);
 }
@@ -178,19 +191,19 @@ static int load_kernel(void)
 
 struct map {
 	struct list_head node;
-	__u64	 start;
-	__u64	 end;
-	__u64	 pgoff;
-	__u64	 (*map_ip)(struct map *, __u64);
+	u64	 start;
+	u64	 end;
+	u64	 pgoff;
+	u64	 (*map_ip)(struct map *, u64);
 	struct dso	 *dso;
 };
 
-static __u64 map__map_ip(struct map *map, __u64 ip)
+static u64 map__map_ip(struct map *map, u64 ip)
 {
 	return ip - map->start + map->pgoff;
 }
 
-static __u64 vdso__map_ip(struct map *map, __u64 ip)
+static u64 vdso__map_ip(struct map *map, u64 ip)
 {
 	return ip;
 }
@@ -373,7 +386,7 @@ static int thread__fork(struct thread *self, struct thread *parent)
 	return 0;
 }
 
-static struct map *thread__find_map(struct thread *self, __u64 ip)
+static struct map *thread__find_map(struct thread *self, u64 ip)
 {
 	struct map *pos;
 
@@ -414,7 +427,7 @@ struct hist_entry {
 	struct map	 *map;
 	struct dso	 *dso;
 	struct symbol	 *sym;
-	__u64	 ip;
+	u64	 ip;
 	char		 level;
 
 	uint32_t	 count;
@@ -519,7 +532,7 @@ sort__dso_print(FILE *fp, struct hist_entry *self)
 	if (self->dso)
 		return fprintf(fp, "%-25s", self->dso->name);
 
-	return fprintf(fp, "%016llx         ", (__u64)self->ip);
+	return fprintf(fp, "%016llx         ", (u64)self->ip);
 }
 
 static struct sort_entry sort_dso = {
@@ -533,7 +546,7 @@ static struct sort_entry sort_dso = {
 static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	__u64 ip_l, ip_r;
+	u64 ip_l, ip_r;
 
 	if (left->sym == right->sym)
 		return 0;
@@ -550,13 +563,13 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 	size_t ret = 0;
 
 	if (verbose)
-		ret += fprintf(fp, "%#018llx  ", (__u64)self->ip);
+		ret += fprintf(fp, "%#018llx  ", (u64)self->ip);
 
 	if (self->sym) {
 		ret += fprintf(fp, "[%c] %s",
 			self->dso == kernel_dso ? 'k' : '.', self->sym->name);
 	} else {
-		ret += fprintf(fp, "%#016llx", (__u64)self->ip);
+		ret += fprintf(fp, "%#016llx", (u64)self->ip);
 	}
 
 	return ret;
@@ -647,7 +660,7 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 /*
  * collect histogram counts
  */
-static void hist_hit(struct hist_entry *he, __u64 ip)
+static void hist_hit(struct hist_entry *he, u64 ip)
 {
 	unsigned int sym_size, offset;
 	struct symbol *sym = he->sym;
@@ -676,7 +689,7 @@ static void hist_hit(struct hist_entry *he, __u64 ip)
 
 static int
 hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
-		struct symbol *sym, __u64 ip, char level)
+		struct symbol *sym, u64 ip, char level)
 {
 	struct rb_node **p = &hist.rb_node;
 	struct rb_node *parent = NULL;
@@ -848,7 +861,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	int show = 0;
 	struct dso *dso = NULL;
 	struct thread *thread = threads__findnew(event->ip.pid);
-	__u64 ip = event->ip.ip;
+	u64 ip = event->ip.ip;
 	struct map *map = NULL;
 
 	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
@@ -1030,13 +1043,33 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
+static char *get_color(double percent)
+{
+	char *color = PERF_COLOR_NORMAL;
+
+	/*
+	 * We color high-overhead entries in red, mid-overhead
+	 * entries in green - and keep the low overhead places
+	 * normal:
+	 */
+	if (percent >= MIN_RED)
+		color = PERF_COLOR_RED;
+	else {
+		if (percent > MIN_GREEN)
+			color = PERF_COLOR_GREEN;
+	}
+	return color;
+}
+
 static int
-parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
+parse_line(FILE *file, struct symbol *sym, u64 start, u64 len)
 {
 	char *line = NULL, *tmp, *tmp2;
+	static const char *prev_line;
+	static const char *prev_color;
 	unsigned int offset;
 	size_t line_len;
-	__u64 line_ip;
+	u64 line_ip;
 	int ret;
 	char *c;
 
@@ -1073,27 +1106,36 @@ parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
 	}
 
 	if (line_ip != -1) {
+		const char *path = NULL;
 		unsigned int hits = 0;
 		double percent = 0.0;
-		char *color = PERF_COLOR_NORMAL;
+		char *color;
+		struct sym_ext *sym_ext = sym->priv;
 
 		offset = line_ip - start;
 		if (offset < len)
 			hits = sym->hist[offset];
 
-		if (sym->hist_sum)
+		if (offset < len && sym_ext) {
+			path = sym_ext[offset].path;
+			percent = sym_ext[offset].percent;
+		} else if (sym->hist_sum)
 			percent = 100.0 * hits / sym->hist_sum;
 
+		color = get_color(percent);
+
 		/*
-		 * We color high-overhead entries in red, mid-overhead
-		 * entries in green - and keep the low overhead places
-		 * normal:
+		 * Also color the filename and line if needed, with
+		 * the same color than the percentage. Don't print it
+		 * twice for close colored ip with the same filename:line
 		 */
-		if (percent >= 5.0)
-			color = PERF_COLOR_RED;
-		else {
-			if (percent > 0.5)
-				color = PERF_COLOR_GREEN;
+		if (path) {
+			if (!prev_line || strcmp(prev_line, path)
+				       || color != prev_color) {
+				color_fprintf(stdout, color, " %s", path);
+				prev_line = path;
+				prev_color = color;
+			}
 		}
 
 		color_fprintf(stdout, color, " %7.2f", percent);
@@ -1109,10 +1151,125 @@ parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
 	return 0;
 }
 
+static struct rb_root root_sym_ext;
+
+static void insert_source_line(struct sym_ext *sym_ext)
+{
+	struct sym_ext *iter;
+	struct rb_node **p = &root_sym_ext.rb_node;
+	struct rb_node *parent = NULL;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct sym_ext, node);
+
+		if (sym_ext->percent > iter->percent)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&sym_ext->node, parent, p);
+	rb_insert_color(&sym_ext->node, &root_sym_ext);
+}
+
+static void free_source_line(struct symbol *sym, int len)
+{
+	struct sym_ext *sym_ext = sym->priv;
+	int i;
+
+	if (!sym_ext)
+		return;
+
+	for (i = 0; i < len; i++)
+		free(sym_ext[i].path);
+	free(sym_ext);
+
+	sym->priv = NULL;
+	root_sym_ext = RB_ROOT;
+}
+
+/* Get the filename:line for the colored entries */
+static void
+get_source_line(struct symbol *sym, u64 start, int len, char *filename)
+{
+	int i;
+	char cmd[PATH_MAX * 2];
+	struct sym_ext *sym_ext;
+
+	if (!sym->hist_sum)
+		return;
+
+	sym->priv = calloc(len, sizeof(struct sym_ext));
+	if (!sym->priv)
+		return;
+
+	sym_ext = sym->priv;
+
+	for (i = 0; i < len; i++) {
+		char *path = NULL;
+		size_t line_len;
+		u64 offset;
+		FILE *fp;
+
+		sym_ext[i].percent = 100.0 * sym->hist[i] / sym->hist_sum;
+		if (sym_ext[i].percent <= 0.5)
+			continue;
+
+		offset = start + i;
+		sprintf(cmd, "addr2line -e %s %016llx", filename, offset);
+		fp = popen(cmd, "r");
+		if (!fp)
+			continue;
+
+		if (getline(&path, &line_len, fp) < 0 || !line_len)
+			goto next;
+
+		sym_ext[i].path = malloc(sizeof(char) * line_len + 1);
+		if (!sym_ext[i].path)
+			goto next;
+
+		strcpy(sym_ext[i].path, path);
+		insert_source_line(&sym_ext[i]);
+
+	next:
+		pclose(fp);
+	}
+}
+
+static void print_summary(char *filename)
+{
+	struct sym_ext *sym_ext;
+	struct rb_node *node;
+
+	printf("\nSorted summary for file %s\n", filename);
+	printf("----------------------------------------------\n\n");
+
+	if (RB_EMPTY_ROOT(&root_sym_ext)) {
+		printf(" Nothing higher than %1.1f%%\n", MIN_GREEN);
+		return;
+	}
+
+	node = rb_first(&root_sym_ext);
+	while (node) {
+		double percent;
+		char *color;
+		char *path;
+
+		sym_ext = rb_entry(node, struct sym_ext, node);
+		percent = sym_ext->percent;
+		color = get_color(percent);
+		path = sym_ext->path;
+
+		color_fprintf(stdout, color, " %7.2f %s", percent, path);
+		node = rb_next(node);
+	}
+}
+
 static void annotate_sym(struct dso *dso, struct symbol *sym)
 {
 	char *filename = dso->name;
-	__u64 start, end, len;
+	u64 start, end, len;
 	char command[PATH_MAX*2];
 	FILE *file;
 
@@ -1121,13 +1278,6 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	if (dso == kernel_dso)
 		filename = vmlinux;
 
-	printf("\n------------------------------------------------\n");
-	printf(" Percent |	Source code & Disassembly of %s\n", filename);
-	printf("------------------------------------------------\n");
-
-	if (verbose >= 2)
-		printf("annotating [%p] %30s : [%p] %30s\n", dso, dso->name, sym, sym->name);
-
 	start = sym->obj_start;
 	if (!start)
 		start = sym->start;
@@ -1135,7 +1285,19 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	end = start + sym->end - sym->start + 1;
 	len = sym->end - sym->start;
 
-	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s", (__u64)start, (__u64)end, filename);
+	if (print_line) {
+		get_source_line(sym, start, len, filename);
+		print_summary(filename);
+	}
+
+	printf("\n\n------------------------------------------------\n");
+	printf(" Percent |	Source code & Disassembly of %s\n", filename);
+	printf("------------------------------------------------\n");
+
+	if (verbose >= 2)
+		printf("annotating [%p] %30s : [%p] %30s\n", dso, dso->name, sym, sym->name);
+
+	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s", (u64)start, (u64)end, filename);
 
 	if (verbose >= 3)
 		printf("doing: %s\n", command);
@@ -1150,6 +1312,8 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	}
 
 	pclose(file);
+	if (print_line)
+		free_source_line(sym, len);
 }
 
 static void find_annotations(void)
@@ -1308,6 +1472,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
+	OPT_BOOLEAN('l', "print-line", &print_line,
+		    "print matching source lines (may be slow)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0f5771f..d7ebbd7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -37,33 +37,37 @@ static pid_t			target_pid			= -1;
 static int			inherit				= 1;
 static int			force				= 0;
 static int			append_file			= 0;
+static int			call_graph			= 0;
 static int			verbose				= 0;
 
 static long			samples;
 static struct timeval		last_read;
 static struct timeval		this_read;
 
-static __u64			bytes_written;
+static u64			bytes_written;
 
 static struct pollfd		event_array[MAX_NR_CPUS * MAX_COUNTERS];
 
 static int			nr_poll;
 static int			nr_cpu;
 
+static int			file_new = 1;
+static struct perf_file_header	file_header;
+
 struct mmap_event {
 	struct perf_event_header	header;
-	__u32				pid;
-	__u32				tid;
-	__u64				start;
-	__u64				len;
-	__u64				pgoff;
+	u32				pid;
+	u32				tid;
+	u64				start;
+	u64				len;
+	u64				pgoff;
 	char				filename[PATH_MAX];
 };
 
 struct comm_event {
 	struct perf_event_header	header;
-	__u32				pid;
-	__u32				tid;
+	u32				pid;
+	u32				tid;
 	char				comm[16];
 };
 
@@ -77,10 +81,10 @@ struct mmap_data {
 
 static struct mmap_data		mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
-static unsigned int mmap_read_head(struct mmap_data *md)
+static unsigned long mmap_read_head(struct mmap_data *md)
 {
 	struct perf_counter_mmap_page *pc = md->base;
-	int head;
+	long head;
 
 	head = pc->data_head;
 	rmb();
@@ -88,6 +92,32 @@ static unsigned int mmap_read_head(struct mmap_data *md)
 	return head;
 }
 
+static void mmap_write_tail(struct mmap_data *md, unsigned long tail)
+{
+	struct perf_counter_mmap_page *pc = md->base;
+
+	/*
+	 * ensure all reads are done before we write the tail out.
+	 */
+	/* mb(); */
+	pc->data_tail = tail;
+}
+
+static void write_output(void *buf, size_t size)
+{
+	while (size) {
+		int ret = write(output, buf, size);
+
+		if (ret < 0)
+			die("failed to write");
+
+		size -= ret;
+		buf += ret;
+
+		bytes_written += ret;
+	}
+}
+
 static void mmap_read(struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
@@ -108,7 +138,7 @@ static void mmap_read(struct mmap_data *md)
 	 * In either case, truncate and restart at head.
 	 */
 	diff = head - old;
-	if (diff > md->mask / 2 || diff < 0) {
+	if (diff < 0) {
 		struct timeval iv;
 		unsigned long msecs;
 
@@ -136,36 +166,17 @@ static void mmap_read(struct mmap_data *md)
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		while (size) {
-			int ret = write(output, buf, size);
-
-			if (ret < 0)
-				die("failed to write");
-
-			size -= ret;
-			buf += ret;
-
-			bytes_written += ret;
-		}
+		write_output(buf, size);
 	}
 
 	buf = &data[old & md->mask];
 	size = head - old;
 	old += size;
 
-	while (size) {
-		int ret = write(output, buf, size);
-
-		if (ret < 0)
-			die("failed to write");
-
-		size -= ret;
-		buf += ret;
-
-		bytes_written += ret;
-	}
+	write_output(buf, size);
 
 	md->prev = old;
+	mmap_write_tail(md, old);
 }
 
 static volatile int done = 0;
@@ -191,7 +202,7 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 	struct comm_event comm_ev;
 	char filename[PATH_MAX];
 	char bf[BUFSIZ];
-	int fd, ret;
+	int fd;
 	size_t size;
 	char *field, *sep;
 	DIR *tasks;
@@ -201,8 +212,12 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0) {
-		fprintf(stderr, "couldn't open %s\n", filename);
-		exit(EXIT_FAILURE);
+		/*
+		 * We raced with a task exiting - just return:
+		 */
+		if (verbose)
+			fprintf(stderr, "couldn't open %s\n", filename);
+		return;
 	}
 	if (read(fd, bf, sizeof(bf)) < 0) {
 		fprintf(stderr, "couldn't read %s\n", filename);
@@ -223,17 +238,13 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 
 	comm_ev.pid = pid;
 	comm_ev.header.type = PERF_EVENT_COMM;
-	size = ALIGN(size, sizeof(__u64));
+	size = ALIGN(size, sizeof(u64));
 	comm_ev.header.size = sizeof(comm_ev) - (sizeof(comm_ev.comm) - size);
 
 	if (!full) {
 		comm_ev.tid = pid;
 
-		ret = write(output, &comm_ev, comm_ev.header.size);
-		if (ret < 0) {
-			perror("failed to write");
-			exit(-1);
-		}
+		write_output(&comm_ev, comm_ev.header.size);
 		return;
 	}
 
@@ -248,11 +259,7 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 
 		comm_ev.tid = pid;
 
-		ret = write(output, &comm_ev, comm_ev.header.size);
-		if (ret < 0) {
-			perror("failed to write");
-			exit(-1);
-		}
+		write_output(&comm_ev, comm_ev.header.size);
 	}
 	closedir(tasks);
 	return;
@@ -272,8 +279,12 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 
 	fp = fopen(filename, "r");
 	if (fp == NULL) {
-		fprintf(stderr, "couldn't open %s\n", filename);
-		exit(EXIT_FAILURE);
+		/*
+		 * We raced with a task exiting - just return:
+		 */
+		if (verbose)
+			fprintf(stderr, "couldn't open %s\n", filename);
+		return;
 	}
 	while (1) {
 		char bf[BUFSIZ], *pbf = bf;
@@ -304,17 +315,14 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 			size = strlen(execname);
 			execname[size - 1] = '\0'; /* Remove \n */
 			memcpy(mmap_ev.filename, execname, size);
-			size = ALIGN(size, sizeof(__u64));
+			size = ALIGN(size, sizeof(u64));
 			mmap_ev.len -= mmap_ev.start;
 			mmap_ev.header.size = (sizeof(mmap_ev) -
 					       (sizeof(mmap_ev.filename) - size));
 			mmap_ev.pid = pid;
 			mmap_ev.tid = pid;
 
-			if (write(output, &mmap_ev, mmap_ev.header.size) < 0) {
-				perror("failed to write");
-				exit(-1);
-			}
+			write_output(&mmap_ev, mmap_ev.header.size);
 		}
 	}
 
@@ -351,11 +359,25 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	int track = 1;
 
 	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+
 	if (freq) {
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 		attr->freq		= 1;
 		attr->sample_freq	= freq;
 	}
+
+	if (call_graph)
+		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
+
+	if (file_new) {
+		file_header.sample_type = attr->sample_type;
+	} else {
+		if (file_header.sample_type != attr->sample_type) {
+			fprintf(stderr, "incompatible append\n");
+			exit(-1);
+		}
+	}
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= (cpu < 0) && inherit;
@@ -410,7 +432,7 @@ try_again:
 	mmap_array[nr_cpu][counter].prev = 0;
 	mmap_array[nr_cpu][counter].mask = mmap_pages*page_size - 1;
 	mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
-			PROT_READ, MAP_SHARED, fd[nr_cpu][counter], 0);
+			PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter], 0);
 	if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
 		error("failed to mmap with %d (%s)\n", errno, strerror(errno));
 		exit(-1);
@@ -435,6 +457,14 @@ static void open_counters(int cpu, pid_t pid)
 	nr_cpu++;
 }
 
+static void atexit_header(void)
+{
+	file_header.data_size += bytes_written;
+
+	if (pwrite(output, &file_header, sizeof(file_header), 0) == -1)
+		perror("failed to write on file headers");
+}
+
 static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
@@ -448,6 +478,10 @@ static int __cmd_record(int argc, const char **argv)
 	assert(nr_cpus <= MAX_NR_CPUS);
 	assert(nr_cpus >= 0);
 
+	atexit(sig_atexit);
+	signal(SIGCHLD, sig_handler);
+	signal(SIGINT, sig_handler);
+
 	if (!stat(output_name, &st) && !force && !append_file) {
 		fprintf(stderr, "Error, output file %s exists, use -A to append or -f to overwrite.\n",
 				output_name);
@@ -456,7 +490,7 @@ static int __cmd_record(int argc, const char **argv)
 
 	flags = O_CREAT|O_RDWR;
 	if (append_file)
-		flags |= O_APPEND;
+		file_new = 0;
 	else
 		flags |= O_TRUNC;
 
@@ -466,15 +500,22 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
+	if (!file_new) {
+		if (read(output, &file_header, sizeof(file_header)) == -1) {
+			perror("failed to read file headers");
+			exit(-1);
+		}
+
+		lseek(output, file_header.data_size, SEEK_CUR);
+	}
+
+	atexit(atexit_header);
+
 	if (!system_wide) {
 		open_counters(-1, target_pid != -1 ? target_pid : getpid());
 	} else for (i = 0; i < nr_cpus; i++)
 		open_counters(i, target_pid);
 
-	atexit(sig_atexit);
-	signal(SIGCHLD, sig_handler);
-	signal(SIGINT, sig_handler);
-
 	if (target_pid == -1 && argc) {
 		pid = fork();
 		if (pid < 0)
@@ -555,6 +596,8 @@ static const struct option options[] = {
 		    "profile at this frequency"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
 		    "number of mmap data pages"),
+	OPT_BOOLEAN('g', "call-graph", &call_graph,
+		    "do call-graph (stack chain/backtrace) recording"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_END()
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 82fa93b..5eb5566 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -36,45 +36,65 @@ static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
 static int		dump_trace = 0;
 #define dprintf(x...)	do { if (dump_trace) printf(x); } while (0)
+#define cdprintf(x...)	do { if (dump_trace) color_fprintf(stdout, color, x); } while (0)
 
 static int		verbose;
+#define eprintf(x...)	do { if (verbose) fprintf(stderr, x); } while (0)
+
 static int		full_paths;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
+static char		default_parent_pattern[] = "^sys_|^do_page_fault";
+static char		*parent_pattern = default_parent_pattern;
+static regex_t		parent_regex;
+
+static int		exclude_other = 1;
+
 struct ip_event {
 	struct perf_event_header header;
-	__u64 ip;
-	__u32 pid, tid;
-	__u64 period;
+	u64 ip;
+	u32 pid, tid;
+	unsigned char __more_data[];
+};
+
+struct ip_callchain {
+	u64 nr;
+	u64 ips[0];
 };
 
 struct mmap_event {
 	struct perf_event_header header;
-	__u32 pid, tid;
-	__u64 start;
-	__u64 len;
-	__u64 pgoff;
+	u32 pid, tid;
+	u64 start;
+	u64 len;
+	u64 pgoff;
 	char filename[PATH_MAX];
 };
 
 struct comm_event {
 	struct perf_event_header header;
-	__u32 pid, tid;
+	u32 pid, tid;
 	char comm[16];
 };
 
 struct fork_event {
 	struct perf_event_header header;
-	__u32 pid, ppid;
+	u32 pid, ppid;
 };
 
 struct period_event {
 	struct perf_event_header header;
-	__u64 time;
-	__u64 id;
-	__u64 sample_period;
+	u64 time;
+	u64 id;
+	u64 sample_period;
+};
+
+struct lost_event {
+	struct perf_event_header header;
+	u64 id;
+	u64 lost;
 };
 
 typedef union event_union {
@@ -84,6 +104,7 @@ typedef union event_union {
 	struct comm_event		comm;
 	struct fork_event		fork;
 	struct period_event		period;
+	struct lost_event		lost;
 } event_t;
 
 static LIST_HEAD(dsos);
@@ -119,15 +140,11 @@ static struct dso *dsos__findnew(const char *name)
 
 	nr = dso__load(dso, NULL, verbose);
 	if (nr < 0) {
-		if (verbose)
-			fprintf(stderr, "Failed to open: %s\n", name);
+		eprintf("Failed to open: %s\n", name);
 		goto out_delete_dso;
 	}
-	if (!nr && verbose) {
-		fprintf(stderr,
-		"No symbols found in: %s, maybe install a debug package?\n",
-				name);
-	}
+	if (!nr)
+		eprintf("No symbols found in: %s, maybe install a debug package?\n", name);
 
 	dsos__add(dso);
 
@@ -146,7 +163,7 @@ static void dsos__fprintf(FILE *fp)
 		dso__fprintf(pos, fp);
 }
 
-static struct symbol *vdso__find_symbol(struct dso *dso, __u64 ip)
+static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
 {
 	return dso__find_symbol(kernel_dso, ip);
 }
@@ -193,19 +210,19 @@ static int strcommon(const char *pathname)
 
 struct map {
 	struct list_head node;
-	__u64	 start;
-	__u64	 end;
-	__u64	 pgoff;
-	__u64	 (*map_ip)(struct map *, __u64);
+	u64	 start;
+	u64	 end;
+	u64	 pgoff;
+	u64	 (*map_ip)(struct map *, u64);
 	struct dso	 *dso;
 };
 
-static __u64 map__map_ip(struct map *map, __u64 ip)
+static u64 map__map_ip(struct map *map, u64 ip)
 {
 	return ip - map->start + map->pgoff;
 }
 
-static __u64 vdso__map_ip(struct map *map, __u64 ip)
+static u64 vdso__map_ip(struct map *map, u64 ip)
 {
 	return ip;
 }
@@ -412,7 +429,7 @@ static int thread__fork(struct thread *self, struct thread *parent)
 	return 0;
 }
 
-static struct map *thread__find_map(struct thread *self, __u64 ip)
+static struct map *thread__find_map(struct thread *self, u64 ip)
 {
 	struct map *pos;
 
@@ -453,10 +470,11 @@ struct hist_entry {
 	struct map	 *map;
 	struct dso	 *dso;
 	struct symbol	 *sym;
-	__u64		 ip;
+	struct symbol	 *parent;
+	u64		 ip;
 	char		 level;
 
-	__u64		 count;
+	u64		 count;
 };
 
 /*
@@ -473,6 +491,16 @@ struct sort_entry {
 	size_t	(*print)(FILE *fp, struct hist_entry *);
 };
 
+static int64_t cmp_null(void *l, void *r)
+{
+	if (!l && !r)
+		return 0;
+	else if (!l)
+		return -1;
+	else
+		return 1;
+}
+
 /* --sort pid */
 
 static int64_t
@@ -507,14 +535,8 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 	char *comm_l = left->thread->comm;
 	char *comm_r = right->thread->comm;
 
-	if (!comm_l || !comm_r) {
-		if (!comm_l && !comm_r)
-			return 0;
-		else if (!comm_l)
-			return -1;
-		else
-			return 1;
-	}
+	if (!comm_l || !comm_r)
+		return cmp_null(comm_l, comm_r);
 
 	return strcmp(comm_l, comm_r);
 }
@@ -540,14 +562,8 @@ sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 	struct dso *dso_l = left->dso;
 	struct dso *dso_r = right->dso;
 
-	if (!dso_l || !dso_r) {
-		if (!dso_l && !dso_r)
-			return 0;
-		else if (!dso_l)
-			return -1;
-		else
-			return 1;
-	}
+	if (!dso_l || !dso_r)
+		return cmp_null(dso_l, dso_r);
 
 	return strcmp(dso_l->name, dso_r->name);
 }
@@ -558,7 +574,7 @@ sort__dso_print(FILE *fp, struct hist_entry *self)
 	if (self->dso)
 		return fprintf(fp, "%-25s", self->dso->name);
 
-	return fprintf(fp, "%016llx         ", (__u64)self->ip);
+	return fprintf(fp, "%016llx         ", (u64)self->ip);
 }
 
 static struct sort_entry sort_dso = {
@@ -572,7 +588,7 @@ static struct sort_entry sort_dso = {
 static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	__u64 ip_l, ip_r;
+	u64 ip_l, ip_r;
 
 	if (left->sym == right->sym)
 		return 0;
@@ -589,13 +605,13 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 	size_t ret = 0;
 
 	if (verbose)
-		ret += fprintf(fp, "%#018llx  ", (__u64)self->ip);
+		ret += fprintf(fp, "%#018llx  ", (u64)self->ip);
 
 	if (self->sym) {
 		ret += fprintf(fp, "[%c] %s",
 			self->dso == kernel_dso ? 'k' : '.', self->sym->name);
 	} else {
-		ret += fprintf(fp, "%#016llx", (__u64)self->ip);
+		ret += fprintf(fp, "%#016llx", (u64)self->ip);
 	}
 
 	return ret;
@@ -607,7 +623,38 @@ static struct sort_entry sort_sym = {
 	.print	= sort__sym_print,
 };
 
+/* --sort parent */
+
+static int64_t
+sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct symbol *sym_l = left->parent;
+	struct symbol *sym_r = right->parent;
+
+	if (!sym_l || !sym_r)
+		return cmp_null(sym_l, sym_r);
+
+	return strcmp(sym_l->name, sym_r->name);
+}
+
+static size_t
+sort__parent_print(FILE *fp, struct hist_entry *self)
+{
+	size_t ret = 0;
+
+	ret += fprintf(fp, "%-20s", self->parent ? self->parent->name : "[other]");
+
+	return ret;
+}
+
+static struct sort_entry sort_parent = {
+	.header = "Parent symbol       ",
+	.cmp	= sort__parent_cmp,
+	.print	= sort__parent_print,
+};
+
 static int sort__need_collapse = 0;
+static int sort__has_parent = 0;
 
 struct sort_dimension {
 	char			*name;
@@ -620,6 +667,7 @@ static struct sort_dimension sort_dimensions[] = {
 	{ .name = "comm",	.entry = &sort_comm,	},
 	{ .name = "dso",	.entry = &sort_dso,	},
 	{ .name = "symbol",	.entry = &sort_sym,	},
+	{ .name = "parent",	.entry = &sort_parent,	},
 };
 
 static LIST_HEAD(hist_entry__sort_list);
@@ -640,6 +688,19 @@ static int sort_dimension__add(char *tok)
 		if (sd->entry->collapse)
 			sort__need_collapse = 1;
 
+		if (sd->entry == &sort_parent) {
+			int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
+			if (ret) {
+				char err[BUFSIZ];
+
+				regerror(ret, &parent_regex, err, sizeof(err));
+				fprintf(stderr, "Invalid regex: %s\n%s",
+					parent_pattern, err);
+				exit(-1);
+			}
+			sort__has_parent = 1;
+		}
+
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
 		sd->taken = 1;
 
@@ -684,11 +745,14 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-hist_entry__fprintf(FILE *fp, struct hist_entry *self, __u64 total_samples)
+hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 {
 	struct sort_entry *se;
 	size_t ret;
 
+	if (exclude_other && !self->parent)
+		return 0;
+
 	if (total_samples) {
 		double percent = self->count * 100.0 / total_samples;
 		char *color = PERF_COLOR_NORMAL;
@@ -711,6 +775,9 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, __u64 total_samples)
 		ret = fprintf(fp, "%12Ld ", self->count);
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (exclude_other && (se == &sort_parent))
+			continue;
+
 		fprintf(fp, "  ");
 		ret += se->print(fp, self);
 	}
@@ -721,12 +788,72 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, __u64 total_samples)
 }
 
 /*
+ *
+ */
+
+static struct symbol *
+resolve_symbol(struct thread *thread, struct map **mapp,
+	       struct dso **dsop, u64 *ipp)
+{
+	struct dso *dso = dsop ? *dsop : NULL;
+	struct map *map = mapp ? *mapp : NULL;
+	uint64_t ip = *ipp;
+
+	if (!thread)
+		return NULL;
+
+	if (dso)
+		goto got_dso;
+
+	if (map)
+		goto got_map;
+
+	map = thread__find_map(thread, ip);
+	if (map != NULL) {
+		if (mapp)
+			*mapp = map;
+got_map:
+		ip = map->map_ip(map, ip);
+		*ipp  = ip;
+
+		dso = map->dso;
+	} else {
+		/*
+		 * If this is outside of all known maps,
+		 * and is a negative address, try to look it
+		 * up in the kernel dso, as it might be a
+		 * vsyscall (which executes in user-mode):
+		 */
+		if ((long long)ip < 0)
+		dso = kernel_dso;
+	}
+	dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
+
+	if (dsop)
+		*dsop = dso;
+
+	if (!dso)
+		return NULL;
+got_dso:
+	return dso->find_symbol(dso, ip);
+}
+
+static int call__match(struct symbol *sym)
+{
+	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
+		return 1;
+
+	return 0;
+}
+
+/*
  * collect histogram counts
  */
 
 static int
 hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
-		struct symbol *sym, __u64 ip, char level, __u64 count)
+		struct symbol *sym, u64 ip, struct ip_callchain *chain,
+		char level, u64 count)
 {
 	struct rb_node **p = &hist.rb_node;
 	struct rb_node *parent = NULL;
@@ -739,9 +866,41 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 		.ip	= ip,
 		.level	= level,
 		.count	= count,
+		.parent = NULL,
 	};
 	int cmp;
 
+	if (sort__has_parent && chain) {
+		u64 context = PERF_CONTEXT_MAX;
+		int i;
+
+		for (i = 0; i < chain->nr; i++) {
+			u64 ip = chain->ips[i];
+			struct dso *dso = NULL;
+			struct symbol *sym;
+
+			if (ip >= PERF_CONTEXT_MAX) {
+				context = ip;
+				continue;
+			}
+
+			switch (context) {
+			case PERF_CONTEXT_KERNEL:
+				dso = kernel_dso;
+				break;
+			default:
+				break;
+			}
+
+			sym = resolve_symbol(thread, NULL, &dso, &ip);
+
+			if (sym && call__match(sym)) {
+				entry.parent = sym;
+				break;
+			}
+		}
+	}
+
 	while (*p != NULL) {
 		parent = *p;
 		he = rb_entry(parent, struct hist_entry, rb_node);
@@ -873,7 +1032,7 @@ static void output__resort(void)
 	}
 }
 
-static size_t output__fprintf(FILE *fp, __u64 total_samples)
+static size_t output__fprintf(FILE *fp, u64 total_samples)
 {
 	struct hist_entry *pos;
 	struct sort_entry *se;
@@ -882,18 +1041,24 @@ static size_t output__fprintf(FILE *fp, __u64 total_samples)
 
 	fprintf(fp, "\n");
 	fprintf(fp, "#\n");
-	fprintf(fp, "# (%Ld samples)\n", (__u64)total_samples);
+	fprintf(fp, "# (%Ld samples)\n", (u64)total_samples);
 	fprintf(fp, "#\n");
 
 	fprintf(fp, "# Overhead");
-	list_for_each_entry(se, &hist_entry__sort_list, list)
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (exclude_other && (se == &sort_parent))
+			continue;
 		fprintf(fp, "  %s", se->header);
+	}
 	fprintf(fp, "\n");
 
 	fprintf(fp, "# ........");
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		int i;
 
+		if (exclude_other && (se == &sort_parent))
+			continue;
+
 		fprintf(fp, "  ");
 		for (i = 0; i < strlen(se->header); i++)
 			fprintf(fp, ".");
@@ -907,7 +1072,8 @@ static size_t output__fprintf(FILE *fp, __u64 total_samples)
 		ret += hist_entry__fprintf(fp, pos, total_samples);
 	}
 
-	if (!strcmp(sort_order, default_sort_order)) {
+	if (sort_order == default_sort_order &&
+			parent_pattern == default_parent_pattern) {
 		fprintf(fp, "#\n");
 		fprintf(fp, "# (For more details, try: perf report --sort comm,dso,symbol)\n");
 		fprintf(fp, "#\n");
@@ -932,7 +1098,21 @@ static unsigned long total = 0,
 		     total_mmap = 0,
 		     total_comm = 0,
 		     total_fork = 0,
-		     total_unknown = 0;
+		     total_unknown = 0,
+		     total_lost = 0;
+
+static int validate_chain(struct ip_callchain *chain, event_t *event)
+{
+	unsigned int chain_size;
+
+	chain_size = event->header.size;
+	chain_size -= (unsigned long)&event->ip.__more_data - (unsigned long)event;
+
+	if (chain->nr*sizeof(u64) > chain_size)
+		return -1;
+
+	return 0;
+}
 
 static int
 process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
@@ -941,12 +1121,16 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	int show = 0;
 	struct dso *dso = NULL;
 	struct thread *thread = threads__findnew(event->ip.pid);
-	__u64 ip = event->ip.ip;
-	__u64 period = 1;
+	u64 ip = event->ip.ip;
+	u64 period = 1;
 	struct map *map = NULL;
+	void *more_data = event->ip.__more_data;
+	struct ip_callchain *chain = NULL;
 
-	if (event->header.type & PERF_SAMPLE_PERIOD)
-		period = event->ip.period;
+	if (event->header.type & PERF_SAMPLE_PERIOD) {
+		period = *(u64 *)more_data;
+		more_data += sizeof(u64);
+	}
 
 	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p period: %Ld\n",
 		(void *)(offset + head),
@@ -956,10 +1140,28 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 		(void *)(long)ip,
 		(long long)period);
 
+	if (event->header.type & PERF_SAMPLE_CALLCHAIN) {
+		int i;
+
+		chain = (void *)more_data;
+
+		dprintf("... chain: nr:%Lu\n", chain->nr);
+
+		if (validate_chain(chain, event) < 0) {
+			eprintf("call-chain problem with event, skipping it.\n");
+			return 0;
+		}
+
+		if (dump_trace) {
+			for (i = 0; i < chain->nr; i++)
+				dprintf("..... %2d: %016Lx\n", i, chain->ips[i]);
+		}
+	}
+
 	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
 	if (thread == NULL) {
-		fprintf(stderr, "problem processing %d event, skipping it.\n",
+		eprintf("problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
@@ -977,22 +1179,6 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 		show = SHOW_USER;
 		level = '.';
 
-		map = thread__find_map(thread, ip);
-		if (map != NULL) {
-			ip = map->map_ip(map, ip);
-			dso = map->dso;
-		} else {
-			/*
-			 * If this is outside of all known maps,
-			 * and is a negative address, try to look it
-			 * up in the kernel dso, as it might be a
-			 * vsyscall (which executes in user-mode):
-			 */
-			if ((long long)ip < 0)
-				dso = kernel_dso;
-		}
-		dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
-
 	} else {
 		show = SHOW_HV;
 		level = 'H';
@@ -1000,14 +1186,10 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	}
 
 	if (show & show_mask) {
-		struct symbol *sym = NULL;
-
-		if (dso)
-			sym = dso->find_symbol(dso, ip);
+		struct symbol *sym = resolve_symbol(thread, &map, &dso, &ip);
 
-		if (hist_entry__add(thread, map, dso, sym, ip, level, period)) {
-			fprintf(stderr,
-		"problem incrementing symbol count, skipping event\n");
+		if (hist_entry__add(thread, map, dso, sym, ip, chain, level, period)) {
+			eprintf("problem incrementing symbol count, skipping event\n");
 			return -1;
 		}
 	}
@@ -1096,8 +1278,60 @@ process_period_event(event_t *event, unsigned long offset, unsigned long head)
 }
 
 static int
+process_lost_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	dprintf("%p [%p]: PERF_EVENT_LOST: id:%Ld: lost:%Ld\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->lost.id,
+		event->lost.lost);
+
+	total_lost += event->lost.lost;
+
+	return 0;
+}
+
+static void trace_event(event_t *event)
+{
+	unsigned char *raw_event = (void *)event;
+	char *color = PERF_COLOR_BLUE;
+	int i, j;
+
+	if (!dump_trace)
+		return;
+
+	dprintf(".");
+	cdprintf("\n. ... raw event: size %d bytes\n", event->header.size);
+
+	for (i = 0; i < event->header.size; i++) {
+		if ((i & 15) == 0) {
+			dprintf(".");
+			cdprintf("  %04x: ", i);
+		}
+
+		cdprintf(" %02x", raw_event[i]);
+
+		if (((i & 15) == 15) || i == event->header.size-1) {
+			cdprintf("  ");
+			for (j = 0; j < 15-(i & 15); j++)
+				cdprintf("   ");
+			for (j = 0; j < (i & 15); j++) {
+				if (isprint(raw_event[i-15+j]))
+					cdprintf("%c", raw_event[i-15+j]);
+				else
+					cdprintf(".");
+			}
+			cdprintf("\n");
+		}
+	}
+	dprintf(".\n");
+}
+
+static int
 process_event(event_t *event, unsigned long offset, unsigned long head)
 {
+	trace_event(event);
+
 	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW)
 		return process_overflow_event(event, offset, head);
 
@@ -1113,6 +1347,10 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 
 	case PERF_EVENT_PERIOD:
 		return process_period_event(event, offset, head);
+
+	case PERF_EVENT_LOST:
+		return process_lost_event(event, offset, head);
+
 	/*
 	 * We dont process them right now but they are fine:
 	 */
@@ -1128,11 +1366,13 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
+static struct perf_file_header		file_header;
+
 static int __cmd_report(void)
 {
 	int ret, rc = EXIT_FAILURE;
 	unsigned long offset = 0;
-	unsigned long head = 0;
+	unsigned long head = sizeof(file_header);
 	struct stat stat;
 	event_t *event;
 	uint32_t size;
@@ -1160,6 +1400,17 @@ static int __cmd_report(void)
 		exit(0);
 	}
 
+	if (read(input, &file_header, sizeof(file_header)) == -1) {
+		perror("failed to read file headers");
+		exit(-1);
+	}
+
+	if (sort__has_parent &&
+	    !(file_header.sample_type & PERF_SAMPLE_CALLCHAIN)) {
+		fprintf(stderr, "selected --sort parent, but no callchain data\n");
+		exit(-1);
+	}
+
 	if (load_kernel() < 0) {
 		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
@@ -1204,7 +1455,7 @@ more:
 
 	size = event->header.size;
 
-	dprintf("%p [%p]: event: %d\n",
+	dprintf("\n%p [%p]: event: %d\n",
 			(void *)(offset + head),
 			(void *)(long)event->header.size,
 			event->header.type);
@@ -1231,9 +1482,13 @@ more:
 
 	head += size;
 
+	if (offset + head >= sizeof(file_header) + file_header.data_size)
+		goto done;
+
 	if (offset + head < stat.st_size)
 		goto more;
 
+done:
 	rc = EXIT_SUCCESS;
 	close(input);
 
@@ -1241,6 +1496,7 @@ more:
 	dprintf("    mmap events: %10ld\n", total_mmap);
 	dprintf("    comm events: %10ld\n", total_comm);
 	dprintf("    fork events: %10ld\n", total_fork);
+	dprintf("    lost events: %10ld\n", total_lost);
 	dprintf(" unknown events: %10ld\n", total_unknown);
 
 	if (dump_trace)
@@ -1273,9 +1529,13 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol. Default: pid,symbol"),
+		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
+	OPT_STRING('p', "parent", &parent_pattern, "regex",
+		   "regex filter to identify parent, see: '--sort parent'"),
+	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
+		    "Only display entries with parent-match"),
 	OPT_END()
 };
 
@@ -1304,6 +1564,11 @@ int cmd_report(int argc, const char **argv, const char *prefix)
 
 	setup_sorting();
 
+	if (parent_pattern != default_parent_pattern)
+		sort_dimension__add("parent");
+	else
+		exclude_other = 0;
+
 	/*
 	 * Any (unrecognized) arguments left?
 	 */
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c43e4a9..6d3eeac 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -43,6 +43,7 @@
 #include "util/parse-events.h"
 
 #include <sys/prctl.h>
+#include <math.h>
 
 static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
 
@@ -79,12 +80,34 @@ static const unsigned int default_count[] = {
 	  10000,
 };
 
-static __u64			event_res[MAX_COUNTERS][3];
-static __u64			event_scaled[MAX_COUNTERS];
+#define MAX_RUN 100
 
-static __u64			runtime_nsecs;
-static __u64			walltime_nsecs;
-static __u64			runtime_cycles;
+static int			run_count		=  1;
+static int			run_idx			=  0;
+
+static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
+static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
+
+//static u64			event_hist[MAX_RUN][MAX_COUNTERS][3];
+
+
+static u64			runtime_nsecs[MAX_RUN];
+static u64			walltime_nsecs[MAX_RUN];
+static u64			runtime_cycles[MAX_RUN];
+
+static u64			event_res_avg[MAX_COUNTERS][3];
+static u64			event_res_noise[MAX_COUNTERS][3];
+
+static u64			event_scaled_avg[MAX_COUNTERS];
+
+static u64			runtime_nsecs_avg;
+static u64			runtime_nsecs_noise;
+
+static u64			walltime_nsecs_avg;
+static u64			walltime_nsecs_noise;
+
+static u64			runtime_cycles_avg;
+static u64			runtime_cycles_noise;
 
 static void create_perf_stat_counter(int counter)
 {
@@ -135,12 +158,12 @@ static inline int nsec_counter(int counter)
  */
 static void read_counter(int counter)
 {
-	__u64 *count, single_count[3];
+	u64 *count, single_count[3];
 	ssize_t res;
 	int cpu, nv;
 	int scaled;
 
-	count = event_res[counter];
+	count = event_res[run_idx][counter];
 
 	count[0] = count[1] = count[2] = 0;
 
@@ -149,8 +172,10 @@ static void read_counter(int counter)
 		if (fd[cpu][counter] < 0)
 			continue;
 
-		res = read(fd[cpu][counter], single_count, nv * sizeof(__u64));
-		assert(res == nv * sizeof(__u64));
+		res = read(fd[cpu][counter], single_count, nv * sizeof(u64));
+		assert(res == nv * sizeof(u64));
+		close(fd[cpu][counter]);
+		fd[cpu][counter] = -1;
 
 		count[0] += single_count[0];
 		if (scale) {
@@ -162,13 +187,13 @@ static void read_counter(int counter)
 	scaled = 0;
 	if (scale) {
 		if (count[2] == 0) {
-			event_scaled[counter] = -1;
+			event_scaled[run_idx][counter] = -1;
 			count[0] = 0;
 			return;
 		}
 
 		if (count[2] < count[1]) {
-			event_scaled[counter] = 1;
+			event_scaled[run_idx][counter] = 1;
 			count[0] = (unsigned long long)
 				((double)count[0] * count[1] / count[2] + 0.5);
 		}
@@ -178,10 +203,94 @@ static void read_counter(int counter)
 	 */
 	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
 		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK)
-		runtime_nsecs = count[0];
+		runtime_nsecs[run_idx] = count[0];
 	if (attrs[counter].type == PERF_TYPE_HARDWARE &&
 		attrs[counter].config == PERF_COUNT_HW_CPU_CYCLES)
-		runtime_cycles = count[0];
+		runtime_cycles[run_idx] = count[0];
+}
+
+static int run_perf_stat(int argc, const char **argv)
+{
+	unsigned long long t0, t1;
+	int status = 0;
+	int counter;
+	int pid;
+
+	if (!system_wide)
+		nr_cpus = 1;
+
+	for (counter = 0; counter < nr_counters; counter++)
+		create_perf_stat_counter(counter);
+
+	/*
+	 * Enable counters and exec the command:
+	 */
+	t0 = rdclock();
+	prctl(PR_TASK_PERF_COUNTERS_ENABLE);
+
+	if ((pid = fork()) < 0)
+		perror("failed to fork");
+
+	if (!pid) {
+		if (execvp(argv[0], (char **)argv)) {
+			perror(argv[0]);
+			exit(-1);
+		}
+	}
+
+	wait(&status);
+
+	prctl(PR_TASK_PERF_COUNTERS_DISABLE);
+	t1 = rdclock();
+
+	walltime_nsecs[run_idx] = t1 - t0;
+
+	for (counter = 0; counter < nr_counters; counter++)
+		read_counter(counter);
+
+	return WEXITSTATUS(status);
+}
+
+static void print_noise(u64 *count, u64 *noise)
+{
+	if (run_count > 1)
+		fprintf(stderr, "   ( +- %7.3f%% )",
+			(double)noise[0]/(count[0]+1)*100.0);
+}
+
+static void nsec_printout(int counter, u64 *count, u64 *noise)
+{
+	double msecs = (double)count[0] / 1000000;
+
+	fprintf(stderr, " %14.6f  %-20s", msecs, event_name(counter));
+
+	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
+		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
+
+		if (walltime_nsecs_avg)
+			fprintf(stderr, " # %10.3f CPUs ",
+				(double)count[0] / (double)walltime_nsecs_avg);
+	}
+	print_noise(count, noise);
+}
+
+static void abs_printout(int counter, u64 *count, u64 *noise)
+{
+	fprintf(stderr, " %14Ld  %-20s", count[0], event_name(counter));
+
+	if (runtime_cycles_avg &&
+		attrs[counter].type == PERF_TYPE_HARDWARE &&
+			attrs[counter].config == PERF_COUNT_HW_INSTRUCTIONS) {
+
+		fprintf(stderr, " # %10.3f IPC  ",
+			(double)count[0] / (double)runtime_cycles_avg);
+	} else {
+		if (runtime_nsecs_avg) {
+			fprintf(stderr, " # %10.3f M/sec",
+				(double)count[0]/runtime_nsecs_avg*1000.0);
+		}
+	}
+	print_noise(count, noise);
 }
 
 /*
@@ -189,11 +298,12 @@ static void read_counter(int counter)
  */
 static void print_counter(int counter)
 {
-	__u64 *count;
+	u64 *count, *noise;
 	int scaled;
 
-	count = event_res[counter];
-	scaled = event_scaled[counter];
+	count = event_res_avg[counter];
+	noise = event_res_noise[counter];
+	scaled = event_scaled_avg[counter];
 
 	if (scaled == -1) {
 		fprintf(stderr, " %14s  %-20s\n",
@@ -201,75 +311,107 @@ static void print_counter(int counter)
 		return;
 	}
 
-	if (nsec_counter(counter)) {
-		double msecs = (double)count[0] / 1000000;
-
-		fprintf(stderr, " %14.6f  %-20s",
-			msecs, event_name(counter));
-		if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
-			attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
+	if (nsec_counter(counter))
+		nsec_printout(counter, count, noise);
+	else
+		abs_printout(counter, count, noise);
 
-			if (walltime_nsecs)
-				fprintf(stderr, " # %11.3f CPU utilization factor",
-					(double)count[0] / (double)walltime_nsecs);
-		}
-	} else {
-		fprintf(stderr, " %14Ld  %-20s",
-			count[0], event_name(counter));
-		if (runtime_nsecs)
-			fprintf(stderr, " # %11.3f M/sec",
-				(double)count[0]/runtime_nsecs*1000.0);
-		if (runtime_cycles &&
-			attrs[counter].type == PERF_TYPE_HARDWARE &&
-				attrs[counter].config == PERF_COUNT_HW_INSTRUCTIONS) {
-
-			fprintf(stderr, " # %1.3f per cycle",
-				(double)count[0] / (double)runtime_cycles);
-		}
-	}
 	if (scaled)
 		fprintf(stderr, "  (scaled from %.2f%%)",
 			(double) count[2] / count[1] * 100);
+
 	fprintf(stderr, "\n");
 }
 
-static int do_perf_stat(int argc, const char **argv)
+/*
+ * normalize_noise noise values down to stddev:
+ */
+static void normalize_noise(u64 *val)
 {
-	unsigned long long t0, t1;
-	int counter;
-	int status;
-	int pid;
-	int i;
+	double res;
 
-	if (!system_wide)
-		nr_cpus = 1;
+	res = (double)*val / (run_count * sqrt((double)run_count));
 
-	for (counter = 0; counter < nr_counters; counter++)
-		create_perf_stat_counter(counter);
+	*val = (u64)res;
+}
 
-	/*
-	 * Enable counters and exec the command:
-	 */
-	t0 = rdclock();
-	prctl(PR_TASK_PERF_COUNTERS_ENABLE);
+static void update_avg(const char *name, int idx, u64 *avg, u64 *val)
+{
+	*avg += *val;
 
-	if ((pid = fork()) < 0)
-		perror("failed to fork");
+	if (verbose > 1)
+		fprintf(stderr, "debug: %20s[%d]: %Ld\n", name, idx, *val);
+}
+/*
+ * Calculate the averages and noises:
+ */
+static void calc_avg(void)
+{
+	int i, j;
+
+	if (verbose > 1)
+		fprintf(stderr, "\n");
+
+	for (i = 0; i < run_count; i++) {
+		update_avg("runtime", 0, &runtime_nsecs_avg, runtime_nsecs + i);
+		update_avg("walltime", 0, &walltime_nsecs_avg, walltime_nsecs + i);
+		update_avg("runtime_cycles", 0, &runtime_cycles_avg, runtime_cycles + i);
+
+		for (j = 0; j < nr_counters; j++) {
+			update_avg("counter/0", j,
+				event_res_avg[j]+0, event_res[i][j]+0);
+			update_avg("counter/1", j,
+				event_res_avg[j]+1, event_res[i][j]+1);
+			update_avg("counter/2", j,
+				event_res_avg[j]+2, event_res[i][j]+2);
+			update_avg("scaled", j,
+				event_scaled_avg + j, event_scaled[i]+j);
+		}
+	}
+	runtime_nsecs_avg /= run_count;
+	walltime_nsecs_avg /= run_count;
+	runtime_cycles_avg /= run_count;
+
+	for (j = 0; j < nr_counters; j++) {
+		event_res_avg[j][0] /= run_count;
+		event_res_avg[j][1] /= run_count;
+		event_res_avg[j][2] /= run_count;
+	}
 
-	if (!pid) {
-		if (execvp(argv[0], (char **)argv)) {
-			perror(argv[0]);
-			exit(-1);
+	for (i = 0; i < run_count; i++) {
+		runtime_nsecs_noise +=
+			abs((s64)(runtime_nsecs[i] - runtime_nsecs_avg));
+		walltime_nsecs_noise +=
+			abs((s64)(walltime_nsecs[i] - walltime_nsecs_avg));
+		runtime_cycles_noise +=
+			abs((s64)(runtime_cycles[i] - runtime_cycles_avg));
+
+		for (j = 0; j < nr_counters; j++) {
+			event_res_noise[j][0] +=
+				abs((s64)(event_res[i][j][0] - event_res_avg[j][0]));
+			event_res_noise[j][1] +=
+				abs((s64)(event_res[i][j][1] - event_res_avg[j][1]));
+			event_res_noise[j][2] +=
+				abs((s64)(event_res[i][j][2] - event_res_avg[j][2]));
 		}
 	}
 
-	while (wait(&status) >= 0)
-		;
+	normalize_noise(&runtime_nsecs_noise);
+	normalize_noise(&walltime_nsecs_noise);
+	normalize_noise(&runtime_cycles_noise);
 
-	prctl(PR_TASK_PERF_COUNTERS_DISABLE);
-	t1 = rdclock();
+	for (j = 0; j < nr_counters; j++) {
+		normalize_noise(&event_res_noise[j][0]);
+		normalize_noise(&event_res_noise[j][1]);
+		normalize_noise(&event_res_noise[j][2]);
+	}
+}
 
-	walltime_nsecs = t1 - t0;
+static void print_stat(int argc, const char **argv)
+{
+	int i, counter;
+
+	calc_avg();
 
 	fflush(stdout);
 
@@ -279,22 +421,19 @@ static int do_perf_stat(int argc, const char **argv)
 	for (i = 1; i < argc; i++)
 		fprintf(stderr, " %s", argv[i]);
 
-	fprintf(stderr, "\':\n");
-	fprintf(stderr, "\n");
-
-	for (counter = 0; counter < nr_counters; counter++)
-		read_counter(counter);
+	fprintf(stderr, "\'");
+	if (run_count > 1)
+		fprintf(stderr, " (%d runs)", run_count);
+	fprintf(stderr, ":\n\n");
 
 	for (counter = 0; counter < nr_counters; counter++)
 		print_counter(counter);
 
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, " Wall-clock time elapsed: %12.6f msecs\n",
-			(double)(t1-t0)/1e6);
+	fprintf(stderr, " %14.9f  seconds time elapsed.\n",
+			(double)walltime_nsecs_avg/1e9);
 	fprintf(stderr, "\n");
-
-	return 0;
 }
 
 static volatile int signr = -1;
@@ -332,11 +471,15 @@ static const struct option options[] = {
 			    "scale/normalize counters"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
+	OPT_INTEGER('r', "repeat", &run_count,
+		    "repeat command and print average + stddev (max: 100)"),
 	OPT_END()
 };
 
 int cmd_stat(int argc, const char **argv, const char *prefix)
 {
+	int status;
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	memcpy(attrs, default_attrs, sizeof(attrs));
@@ -344,6 +487,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 	argc = parse_options(argc, argv, options, stat_usage, 0);
 	if (!argc)
 		usage_with_options(stat_usage, options);
+	if (run_count <= 0 || run_count > MAX_RUN)
+		usage_with_options(stat_usage, options);
 
 	if (!nr_counters)
 		nr_counters = 8;
@@ -363,5 +508,14 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
 
-	return do_perf_stat(argc, argv);
+	status = 0;
+	for (run_idx = 0; run_idx < run_count; run_idx++) {
+		if (run_count != 1 && verbose)
+			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx+1);
+		status = run_perf_stat(argc, argv);
+	}
+
+	print_stat(argc, argv);
+
+	return status;
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fe338d3..5352b5e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -54,7 +54,7 @@ static int			system_wide			=  0;
 
 static int			default_interval		= 100000;
 
-static __u64			count_filter			=  5;
+static u64			count_filter			=  5;
 static int			print_entries			= 15;
 
 static int			target_pid			= -1;
@@ -79,8 +79,8 @@ static int			dump_symtab;
  * Symbols
  */
 
-static __u64			min_ip;
-static __u64			max_ip = -1ll;
+static u64			min_ip;
+static u64			max_ip = -1ll;
 
 struct sym_entry {
 	struct rb_node		rb_node;
@@ -194,7 +194,7 @@ static void print_sym_table(void)
 		100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)));
 
 	if (nr_counters == 1) {
-		printf("%Ld", attrs[0].sample_period);
+		printf("%Ld", (u64)attrs[0].sample_period);
 		if (freq)
 			printf("Hz ");
 		else
@@ -372,7 +372,7 @@ out_delete_dso:
 /*
  * Binary search in the histogram table and record the hit:
  */
-static void record_ip(__u64 ip, int counter)
+static void record_ip(u64 ip, int counter)
 {
 	struct symbol *sym = dso__find_symbol(kernel_dso, ip);
 
@@ -392,7 +392,7 @@ static void record_ip(__u64 ip, int counter)
 	samples--;
 }
 
-static void process_event(__u64 ip, int counter)
+static void process_event(u64 ip, int counter)
 {
 	samples++;
 
@@ -463,15 +463,15 @@ static void mmap_read_counter(struct mmap_data *md)
 	for (; old != head;) {
 		struct ip_event {
 			struct perf_event_header header;
-			__u64 ip;
-			__u32 pid, target_pid;
+			u64 ip;
+			u32 pid, target_pid;
 		};
 		struct mmap_event {
 			struct perf_event_header header;
-			__u32 pid, target_pid;
-			__u64 start;
-			__u64 len;
-			__u64 pgoff;
+			u32 pid, target_pid;
+			u64 start;
+			u64 len;
+			u64 pgoff;
 			char filename[PATH_MAX];
 		};
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 87a1aca..bccb529 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -19,6 +19,7 @@
 #include <sys/syscall.h>
 
 #include "../../include/linux/perf_counter.h"
+#include "types.h"
 
 /*
  * prctl(PR_TASK_PERF_COUNTERS_DISABLE) will (cheaply) disable all
@@ -65,4 +66,10 @@ sys_perf_counter_open(struct perf_counter_attr *attr,
 #define MAX_COUNTERS			256
 #define MAX_NR_CPUS			256
 
+struct perf_file_header {
+	u64	version;
+	u64	sample_type;
+	u64	data_size;
+};
+
 #endif
diff --git a/tools/perf/types.h b/tools/perf/types.h
new file mode 100644
index 0000000..5e75f90
--- /dev/null
+++ b/tools/perf/types.h
@@ -0,0 +1,17 @@
+#ifndef _PERF_TYPES_H
+#define _PERF_TYPES_H
+
+/*
+ * We define u64 as unsigned long long for every architecture
+ * so that we can print it with %Lx without getting warnings.
+ */
+typedef unsigned long long u64;
+typedef signed long long   s64;
+typedef unsigned int	   u32;
+typedef signed int	   s32;
+typedef unsigned short	   u16;
+typedef signed short	   s16;
+typedef unsigned char	   u8;
+typedef signed char	   s8;
+
+#endif /* _PERF_TYPES_H */
diff --git a/tools/perf/util/ctype.c b/tools/perf/util/ctype.c
index b90ec00..0b791bd 100644
--- a/tools/perf/util/ctype.c
+++ b/tools/perf/util/ctype.c
@@ -11,16 +11,21 @@ enum {
 	D = GIT_DIGIT,
 	G = GIT_GLOB_SPECIAL,	/* *, ?, [, \\ */
 	R = GIT_REGEX_SPECIAL,	/* $, (, ), +, ., ^, {, | * */
+	P = GIT_PRINT_EXTRA,	/* printable - alpha - digit - glob - regex */
+
+	PS = GIT_SPACE | GIT_PRINT_EXTRA,
 };
 
 unsigned char sane_ctype[256] = {
+/*	0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F			    */
+
 	0, 0, 0, 0, 0, 0, 0, 0, 0, S, S, 0, 0, S, 0, 0,		/*   0.. 15 */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,		/*  16.. 31 */
-	S, 0, 0, 0, R, 0, 0, 0, R, R, G, R, 0, 0, R, 0,		/*  32.. 47 */
-	D, D, D, D, D, D, D, D, D, D, 0, 0, 0, 0, 0, G,		/*  48.. 63 */
-	0, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  64.. 79 */
-	A, A, A, A, A, A, A, A, A, A, A, G, G, 0, R, 0,		/*  80.. 95 */
-	0, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  96..111 */
-	A, A, A, A, A, A, A, A, A, A, A, R, R, 0, 0, 0,		/* 112..127 */
+	PS,P, P, P, R, P, P, P, R, R, G, R, P, P, R, P,		/*  32.. 47 */
+	D, D, D, D, D, D, D, D, D, D, P, P, P, P, P, G,		/*  48.. 63 */
+	P, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  64.. 79 */
+	A, A, A, A, A, A, A, A, A, A, A, G, G, P, R, P,		/*  80.. 95 */
+	P, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  96..111 */
+	A, A, A, A, A, A, A, A, A, A, A, R, R, P, P, 0,		/* 112..127 */
 	/* Nothing in the 128.. range */
 };
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5a72586..35d04da 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -13,8 +13,8 @@ int					nr_counters;
 struct perf_counter_attr		attrs[MAX_COUNTERS];
 
 struct event_symbol {
-	__u8	type;
-	__u64	config;
+	u8	type;
+	u64	config;
 	char	*symbol;
 };
 
@@ -63,8 +63,8 @@ static char *hw_event_names[] = {
 };
 
 static char *sw_event_names[] = {
-	"cpu-clock-ticks",
-	"task-clock-ticks",
+	"cpu-clock-msecs",
+	"task-clock-msecs",
 	"page-faults",
 	"context-switches",
 	"CPU-migrations",
@@ -96,7 +96,7 @@ static char *hw_cache_result [][MAX_ALIASES] = {
 
 char *event_name(int counter)
 {
-	__u64 config = attrs[counter].config;
+	u64 config = attrs[counter].config;
 	int type = attrs[counter].type;
 	static char buf[32];
 
@@ -112,7 +112,7 @@ char *event_name(int counter)
 		return "unknown-hardware";
 
 	case PERF_TYPE_HW_CACHE: {
-		__u8 cache_type, cache_op, cache_result;
+		u8 cache_type, cache_op, cache_result;
 		static char name[100];
 
 		cache_type   = (config >>  0) & 0xff;
@@ -202,7 +202,7 @@ static int parse_generic_hw_symbols(const char *str, struct perf_counter_attr *a
  */
 static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
 {
-	__u64 config, id;
+	u64 config, id;
 	int type;
 	unsigned int i;
 	const char *sep, *pstr;
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index ec33c0c..c93eca9 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -15,7 +15,7 @@ static int hex(char ch)
  * While we find nice hex chars, build a long_val.
  * Return number of chars processed.
  */
-int hex2u64(const char *ptr, __u64 *long_val)
+int hex2u64(const char *ptr, u64 *long_val)
 {
 	const char *p = ptr;
 	*long_val = 0;
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index 72812c1..37b0325 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -1,8 +1,8 @@
 #ifndef _PERF_STRING_H_
 #define _PERF_STRING_H_
 
-#include <linux/types.h>
+#include "../types.h"
 
-int hex2u64(const char *ptr, __u64 *val);
+int hex2u64(const char *ptr, u64 *val);
 
 #endif
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 49a55f8..86e1437 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -9,9 +9,9 @@
 
 const char *sym_hist_filter;
 
-static struct symbol *symbol__new(__u64 start, __u64 len,
+static struct symbol *symbol__new(u64 start, u64 len,
 				  const char *name, unsigned int priv_size,
-				  __u64 obj_start, int verbose)
+				  u64 obj_start, int verbose)
 {
 	size_t namelen = strlen(name) + 1;
 	struct symbol *self = calloc(1, priv_size + sizeof(*self) + namelen);
@@ -21,14 +21,14 @@ static struct symbol *symbol__new(__u64 start, __u64 len,
 
 	if (verbose >= 2)
 		printf("new symbol: %016Lx [%08lx]: %s, hist: %p, obj_start: %p\n",
-			(__u64)start, (unsigned long)len, name, self->hist, (void *)(unsigned long)obj_start);
+			(u64)start, (unsigned long)len, name, self->hist, (void *)(unsigned long)obj_start);
 
 	self->obj_start= obj_start;
 	self->hist = NULL;
 	self->hist_sum = 0;
 
 	if (sym_hist_filter && !strcmp(name, sym_hist_filter))
-		self->hist = calloc(sizeof(__u64), len);
+		self->hist = calloc(sizeof(u64), len);
 
 	if (priv_size) {
 		memset(self, 0, priv_size);
@@ -89,7 +89,7 @@ static void dso__insert_symbol(struct dso *self, struct symbol *sym)
 {
 	struct rb_node **p = &self->syms.rb_node;
 	struct rb_node *parent = NULL;
-	const __u64 ip = sym->start;
+	const u64 ip = sym->start;
 	struct symbol *s;
 
 	while (*p != NULL) {
@@ -104,7 +104,7 @@ static void dso__insert_symbol(struct dso *self, struct symbol *sym)
 	rb_insert_color(&sym->rb_node, &self->syms);
 }
 
-struct symbol *dso__find_symbol(struct dso *self, __u64 ip)
+struct symbol *dso__find_symbol(struct dso *self, u64 ip)
 {
 	struct rb_node *n;
 
@@ -151,7 +151,7 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verb
 		goto out_failure;
 
 	while (!feof(file)) {
-		__u64 start;
+		u64 start;
 		struct symbol *sym;
 		int line_len, len;
 		char symbol_type;
@@ -232,7 +232,7 @@ static int dso__load_perf_map(struct dso *self, symbol_filter_t filter, int verb
 		goto out_failure;
 
 	while (!feof(file)) {
-		__u64 start, size;
+		u64 start, size;
 		struct symbol *sym;
 		int line_len, len;
 
@@ -353,7 +353,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
 {
 	uint32_t nr_rel_entries, idx;
 	GElf_Sym sym;
-	__u64 plt_offset;
+	u64 plt_offset;
 	GElf_Shdr shdr_plt;
 	struct symbol *f;
 	GElf_Shdr shdr_rel_plt;
@@ -523,7 +523,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
-		__u64 obj_start;
+		u64 obj_start;
 
 		if (!elf_sym__is_function(&sym))
 			continue;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 0d1292b..ea332e5 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -2,16 +2,18 @@
 #define _PERF_SYMBOL_ 1
 
 #include <linux/types.h>
+#include "../types.h"
 #include "list.h"
 #include "rbtree.h"
 
 struct symbol {
 	struct rb_node	rb_node;
-	__u64		start;
-	__u64		end;
-	__u64		obj_start;
-	__u64		hist_sum;
-	__u64		*hist;
+	u64		start;
+	u64		end;
+	u64		obj_start;
+	u64		hist_sum;
+	u64		*hist;
+	void		*priv;
 	char		name[0];
 };
 
@@ -19,7 +21,7 @@ struct dso {
 	struct list_head node;
 	struct rb_root	 syms;
 	unsigned int	 sym_priv_size;
-	struct symbol    *(*find_symbol)(struct dso *, __u64 ip);
+	struct symbol    *(*find_symbol)(struct dso *, u64 ip);
 	char		 name[0];
 };
 
@@ -35,7 +37,7 @@ static inline void *dso__sym_priv(struct dso *self, struct symbol *sym)
 	return ((void *)sym) - self->sym_priv_size;
 }
 
-struct symbol *dso__find_symbol(struct dso *self, __u64 ip);
+struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
 int dso__load_kernel(struct dso *self, const char *vmlinux,
 		     symbol_filter_t filter, int verbose);
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 76590a1..b8cfed7 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -100,11 +100,6 @@
 #include <iconv.h>
 #endif
 
-#ifndef NO_OPENSSL
-#include <openssl/ssl.h>
-#include <openssl/err.h>
-#endif
-
 /* On most systems <limits.h> would have given us this, but
  * not on some systems (e.g. GNU/Hurd).
  */
@@ -332,17 +327,20 @@ static inline int has_extension(const char *filename, const char *ext)
 #undef tolower
 #undef toupper
 extern unsigned char sane_ctype[256];
-#define GIT_SPACE 0x01
-#define GIT_DIGIT 0x02
-#define GIT_ALPHA 0x04
-#define GIT_GLOB_SPECIAL 0x08
-#define GIT_REGEX_SPECIAL 0x10
+#define GIT_SPACE		0x01
+#define GIT_DIGIT		0x02
+#define GIT_ALPHA		0x04
+#define GIT_GLOB_SPECIAL	0x08
+#define GIT_REGEX_SPECIAL	0x10
+#define GIT_PRINT_EXTRA		0x20
+#define GIT_PRINT		0x3E
 #define sane_istest(x,mask) ((sane_ctype[(unsigned char)(x)] & (mask)) != 0)
 #define isascii(x) (((x) & ~0x7f) == 0)
 #define isspace(x) sane_istest(x,GIT_SPACE)
 #define isdigit(x) sane_istest(x,GIT_DIGIT)
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
+#define isprint(x) sane_istest(x,GIT_PRINT)
 #define is_glob_special(x) sane_istest(x,GIT_GLOB_SPECIAL)
 #define is_regex_special(x) sane_istest(x,GIT_GLOB_SPECIAL | GIT_REGEX_SPECIAL)
 #define tolower(x) sane_case((unsigned char)(x), 0x20)

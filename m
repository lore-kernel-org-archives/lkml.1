Return-Path: <linux-kernel-owner+w=401wt.eu-S1761868AbZFKKKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761868AbZFKKKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762125AbZFKKKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:10:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:38161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762103AbZFKKKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:10:20 -0400
Date: Thu, 11 Jun 2009 10:09:46 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18992.36430.933526.742969@drongo.ozlabs.ibm.com>
References: <18992.36430.933526.742969@drongo.ozlabs.ibm.com>
Subject: [tip:branch?] perf_counter: powerpc: Implement generalized cache events for POWER processors
Message-ID: <tip-905de321d7499be1b5d1ae135ea390604a52d32d@git.kernel.org>
Git-Commit-ID: 905de321d7499be1b5d1ae135ea390604a52d32d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 11 Jun 2009 10:09:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  905de321d7499be1b5d1ae135ea390604a52d32d
Gitweb:     http://git.kernel.org/tip/905de321d7499be1b5d1ae135ea390604a52d32d
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Thu, 11 Jun 2009 14:55:42 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Jun 2009 12:07:37 +0200

perf_counter: powerpc: Implement generalized cache events for POWER processors

This adds tables of event codes for the generalized cache events for
all the currently supported powerpc processors: POWER{4,5,5+,6,7} and
PPC970*, plus powerpc-specific code to use these tables when a
generalized cache event is requested.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <18992.36430.933526.742969@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/include/asm/perf_counter.h |    3 ++
 arch/powerpc/kernel/perf_counter.c      |   42 +++++++++++++++++++++++++++-
 arch/powerpc/kernel/power4-pmu.c        |   41 +++++++++++++++++++++++++++
 arch/powerpc/kernel/power5+-pmu.c       |   45 +++++++++++++++++++++++++++++-
 arch/powerpc/kernel/power5-pmu.c        |   41 +++++++++++++++++++++++++++
 arch/powerpc/kernel/power6-pmu.c        |   46 +++++++++++++++++++++++++++++-
 arch/powerpc/kernel/power7-pmu.c        |   41 +++++++++++++++++++++++++++
 arch/powerpc/kernel/ppc970-pmu.c        |   41 +++++++++++++++++++++++++++
 8 files changed, 294 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index 1c60f0c..cc7c887 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -33,6 +33,9 @@ struct power_pmu {
 	u32	flags;
 	int	n_generic;
 	int	*generic_events;
+	int	(*cache_events)[PERF_COUNT_HW_CACHE_MAX]
+			       [PERF_COUNT_HW_CACHE_OP_MAX]
+			       [PERF_COUNT_HW_CACHE_RESULT_MAX];
 };
 
 extern struct power_pmu *ppmu;
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 5d12e68..bb20238 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -856,6 +856,36 @@ static void hw_perf_counter_destroy(struct perf_counter *counter)
 	}
 }
 
+/*
+ * Translate a generic cache event config to a raw event code.
+ */
+static int hw_perf_cache_event(u64 config, u64 *eventp)
+{
+	unsigned long type, op, result;
+	int ev;
+
+	if (!ppmu->cache_events)
+		return -EINVAL;
+
+	/* unpack config */
+	type = config & 0xff;
+	op = (config >> 8) & 0xff;
+	result = (config >> 16) & 0xff;
+
+	if (type >= PERF_COUNT_HW_CACHE_MAX ||
+	    op >= PERF_COUNT_HW_CACHE_OP_MAX ||
+	    result >= PERF_COUNT_HW_CACHE_RESULT_MAX)
+		return -EINVAL;
+
+	ev = (*ppmu->cache_events)[type][op][result];
+	if (ev == 0)
+		return -EOPNOTSUPP;
+	if (ev == -1)
+		return -EINVAL;
+	*eventp = ev;
+	return 0;
+}
+
 const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 {
 	u64 ev;
@@ -868,13 +898,21 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 
 	if (!ppmu)
 		return ERR_PTR(-ENXIO);
-	if (counter->attr.type != PERF_TYPE_RAW) {
+	switch (counter->attr.type) {
+	case PERF_TYPE_HARDWARE:
 		ev = counter->attr.config;
 		if (ev >= ppmu->n_generic || ppmu->generic_events[ev] == 0)
 			return ERR_PTR(-EOPNOTSUPP);
 		ev = ppmu->generic_events[ev];
-	} else {
+		break;
+	case PERF_TYPE_HW_CACHE:
+		err = hw_perf_cache_event(counter->attr.config, &ev);
+		if (err)
+			return ERR_PTR(err);
+		break;
+	case PERF_TYPE_RAW:
 		ev = counter->attr.config;
+		break;
 	}
 	counter->hw.config_base = ev;
 	counter->hw.idx = 0;
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
index 836fa11..0e94b68 100644
--- a/arch/powerpc/kernel/power4-pmu.c
+++ b/arch/powerpc/kernel/power4-pmu.c
@@ -543,6 +543,46 @@ static int p4_generic_events[] = {
 	[PERF_COUNT_BRANCH_MISSES] = 0x331,		/* PM_BR_MPRED_CR */
 };
 
+#define C(x)	PERF_COUNT_HW_CACHE_##x
+
+/*
+ * Table of generalized cache-related events.
+ * 0 means not supported, -1 means nonsensical, other values
+ * are event codes.
+ */
+static int power4_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
+	[C(L1D)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x8c10,		0x3c10	},
+		[C(OP_WRITE)] = {	0x7c10,		0xc13	},
+		[C(OP_PREFETCH)] = {	0xc35,		0	},
+	},
+	[C(L1I)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	0,		0	},
+	},
+	[C(L2)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0	},
+		[C(OP_WRITE)] = {	0,		0	},
+		[C(OP_PREFETCH)] = {	0xc34,		0	},
+	},
+	[C(DTLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x904	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+	[C(ITLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x900	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+	[C(BPU)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x330,		0x331	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+};
+
 struct power_pmu power4_pmu = {
 	.n_counter = 8,
 	.max_alternatives = 5,
@@ -554,4 +594,5 @@ struct power_pmu power4_pmu = {
 	.disable_pmc = p4_disable_pmc,
 	.n_generic = ARRAY_SIZE(p4_generic_events),
 	.generic_events = p4_generic_events,
+	.cache_events = &power4_cache_events,
 };
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index 8471e3c..bbf2cbb 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -614,6 +614,46 @@ static int power5p_generic_events[] = {
 	[PERF_COUNT_BRANCH_MISSES] = 0x230e5,		/* BR_MPRED_CR */
 };
 
+#define C(x)	PERF_COUNT_HW_CACHE_##x
+
+/*
+ * Table of generalized cache-related events.
+ * 0 means not supported, -1 means nonsensical, other values
+ * are event codes.
+ */
+static int power5p_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
+	[C(L1D)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x1c10a8,	0x3c1088	},
+		[C(OP_WRITE)] = {	0x2c10a8,	0xc10c3		},
+		[C(OP_PREFETCH)] = {	0xc70e7,	-1		},
+	},
+	[C(L1I)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	0,		0		},
+	},
+	[C(L2)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0		},
+		[C(OP_WRITE)] = {	0,		0		},
+		[C(OP_PREFETCH)] = {	0xc50c3,	0		},
+	},
+	[C(DTLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0xc20e4,	0x800c4		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
+	[C(ITLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x800c0		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
+	[C(BPU)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x230e4,	0x230e5		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
+};
+
 struct power_pmu power5p_pmu = {
 	.n_counter = 6,
 	.max_alternatives = MAX_ALT,
@@ -623,8 +663,9 @@ struct power_pmu power5p_pmu = {
 	.get_constraint = power5p_get_constraint,
 	.get_alternatives = power5p_get_alternatives,
 	.disable_pmc = power5p_disable_pmc,
+	.limited_pmc_event = power5p_limited_pmc_event,
+	.flags = PPMU_LIMITED_PMC5_6,
 	.n_generic = ARRAY_SIZE(power5p_generic_events),
 	.generic_events = power5p_generic_events,
-	.flags = PPMU_LIMITED_PMC5_6,
-	.limited_pmc_event = power5p_limited_pmc_event,
+	.cache_events = &power5p_cache_events,
 };
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index 1b44c5f..670cf10 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -556,6 +556,46 @@ static int power5_generic_events[] = {
 	[PERF_COUNT_BRANCH_MISSES] = 0x230e5,		/* BR_MPRED_CR */
 };
 
+#define C(x)	PERF_COUNT_HW_CACHE_##x
+
+/*
+ * Table of generalized cache-related events.
+ * 0 means not supported, -1 means nonsensical, other values
+ * are event codes.
+ */
+static int power5_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
+	[C(L1D)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x4c1090,	0x3c1088	},
+		[C(OP_WRITE)] = {	0x3c1090,	0xc10c3		},
+		[C(OP_PREFETCH)] = {	0xc70e7,	0		},
+	},
+	[C(L1I)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	0,		0		},
+	},
+	[C(L2)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x3c309b	},
+		[C(OP_WRITE)] = {	0,		0		},
+		[C(OP_PREFETCH)] = {	0xc50c3,	0		},
+	},
+	[C(DTLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x2c4090,	0x800c4		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
+	[C(ITLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x800c0		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
+	[C(BPU)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x230e4,	0x230e5		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
+};
+
 struct power_pmu power5_pmu = {
 	.n_counter = 6,
 	.max_alternatives = MAX_ALT,
@@ -567,4 +607,5 @@ struct power_pmu power5_pmu = {
 	.disable_pmc = power5_disable_pmc,
 	.n_generic = ARRAY_SIZE(power5_generic_events),
 	.generic_events = power5_generic_events,
+	.cache_events = &power5_cache_events,
 };
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index cd4fbe0..4da7078 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -474,6 +474,47 @@ static int power6_generic_events[] = {
 	[PERF_COUNT_BRANCH_MISSES] = 0x400052,		/* BR_MPRED */
 };
 
+#define C(x)	PERF_COUNT_HW_CACHE_##x
+
+/*
+ * Table of generalized cache-related events.
+ * 0 means not supported, -1 means nonsensical, other values
+ * are event codes.
+ * The "DTLB" and "ITLB" events relate to the DERAT and IERAT.
+ */
+static int power6_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
+	[C(L1D)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x80082,	0x80080		},
+		[C(OP_WRITE)] = {	0x80086,	0x80088		},
+		[C(OP_PREFETCH)] = {	0x810a4,	0		},
+	},
+	[C(L1I)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x100056 	},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	0x4008c,	0		},
+	},
+	[C(L2)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x150730,	0x250532	},
+		[C(OP_WRITE)] = {	0x250432,	0x150432	},
+		[C(OP_PREFETCH)] = {	0x810a6,	0		},
+	},
+	[C(DTLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x20000e	},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
+	[C(ITLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x420ce		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
+	[C(BPU)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x430e6,	0x400052	},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
+};
+
 struct power_pmu power6_pmu = {
 	.n_counter = 6,
 	.max_alternatives = MAX_ALT,
@@ -483,8 +524,9 @@ struct power_pmu power6_pmu = {
 	.get_constraint = p6_get_constraint,
 	.get_alternatives = p6_get_alternatives,
 	.disable_pmc = p6_disable_pmc,
+	.limited_pmc_event = p6_limited_pmc_event,
+	.flags = PPMU_LIMITED_PMC5_6 | PPMU_ALT_SIPR,
 	.n_generic = ARRAY_SIZE(power6_generic_events),
 	.generic_events = power6_generic_events,
-	.flags = PPMU_LIMITED_PMC5_6 | PPMU_ALT_SIPR,
-	.limited_pmc_event = p6_limited_pmc_event,
+	.cache_events = &power6_cache_events,
 };
diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index dfac48d..060e0de 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -302,6 +302,46 @@ static int power7_generic_events[] = {
 	[PERF_COUNT_BRANCH_MISSES] = 0x400f6,		/* BR_MPRED */
 };
 
+#define C(x)	PERF_COUNT_HW_CACHE_##x
+
+/*
+ * Table of generalized cache-related events.
+ * 0 means not supported, -1 means nonsensical, other values
+ * are event codes.
+ */
+static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
+	[C(L1D)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x400f0,	0xc880	},
+		[C(OP_WRITE)] = {	0,		0x300f0	},
+		[C(OP_PREFETCH)] = {	0xd8b8,		0	},
+	},
+	[C(L1I)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x200fc	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	0x408a,		0	},
+	},
+	[C(L2)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x6080,		0x6084	},
+		[C(OP_WRITE)] = {	0x6082,		0x6086	},
+		[C(OP_PREFETCH)] = {	0,		0	},
+	},
+	[C(DTLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x300fc	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+	[C(ITLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x400fc	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+	[C(BPU)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x10068,	0x400f6	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+};
+
 struct power_pmu power7_pmu = {
 	.n_counter = 6,
 	.max_alternatives = MAX_ALT + 1,
@@ -313,4 +353,5 @@ struct power_pmu power7_pmu = {
 	.disable_pmc = power7_disable_pmc,
 	.n_generic = ARRAY_SIZE(power7_generic_events),
 	.generic_events = power7_generic_events,
+	.cache_events = &power7_cache_events,
 };
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index eed47c4..336adf1 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -427,6 +427,46 @@ static int ppc970_generic_events[] = {
 	[PERF_COUNT_BRANCH_MISSES] = 0x327,		/* PM_GRP_BR_MPRED */
 };
 
+#define C(x)	PERF_COUNT_HW_CACHE_##x
+
+/*
+ * Table of generalized cache-related events.
+ * 0 means not supported, -1 means nonsensical, other values
+ * are event codes.
+ */
+static int ppc970_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
+	[C(L1D)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x8810,		0x3810	},
+		[C(OP_WRITE)] = {	0x7810,		0x813	},
+		[C(OP_PREFETCH)] = {	0x731,		0	},
+	},
+	[C(L1I)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	0,		0	},
+	},
+	[C(L2)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0	},
+		[C(OP_WRITE)] = {	0,		0	},
+		[C(OP_PREFETCH)] = {	0x733,		0	},
+	},
+	[C(DTLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x704	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+	[C(ITLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0,		0x700	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+	[C(BPU)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	0x431,		0x327	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
+};
+
 struct power_pmu ppc970_pmu = {
 	.n_counter = 8,
 	.max_alternatives = 2,
@@ -438,4 +478,5 @@ struct power_pmu ppc970_pmu = {
 	.disable_pmc = p970_disable_pmc,
 	.n_generic = ARRAY_SIZE(ppc970_generic_events),
 	.generic_events = ppc970_generic_events,
+	.cache_events = &ppc970_cache_events,
 };

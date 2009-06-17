Return-Path: <linux-kernel-owner+w=401wt.eu-S933707AbZFQOUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbZFQOUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933278AbZFQOTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:19:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:35703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933434AbZFQOTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:19:36 -0400
Date: Wed, 17 Jun 2009 14:19:08 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19000.55529.762227.518531@cargo.ozlabs.ibm.com>
References: <19000.55529.762227.518531@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/powerpc] perf_counter: powerpc: Change how processor-specific back-ends get selected
Message-ID: <tip-b7f3fd499de5a830a711ebd28606214d0fc007d6@git.kernel.org>
Git-Commit-ID: b7f3fd499de5a830a711ebd28606214d0fc007d6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 14:19:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7f3fd499de5a830a711ebd28606214d0fc007d6
Gitweb:     http://git.kernel.org/tip/b7f3fd499de5a830a711ebd28606214d0fc007d6
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Wed, 17 Jun 2009 21:52:09 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 16:16:33 +0200

perf_counter: powerpc: Change how processor-specific back-ends get selected

At present, the powerpc generic (processor-independent) perf_counter
code has list of processor back-end modules, and at initialization,
it looks at the PVR (processor version register) and has a switch
statement to select a suitable processor-specific back-end.

This is going to become inconvenient as we add more processor-specific
back-ends, so this inverts the order: now each back-end checks whether
it applies to the current processor, and registers itself if so.
Furthermore, instead of looking at the PVR, back-ends now check the
cur_cpu_spec->oprofile_cpu_type string and match on that.

Lastly, each back-end now specifies a name for itself so the core can
print a nice message when a back-end registers itself.

This doesn't provide any support for unregistering back-ends, but that
wouldn't be hard to do and would allow back-ends to be modules.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linuxppc-dev@ozlabs.org
Cc: benh@kernel.crashing.org
LKML-Reference: <19000.55529.762227.518531@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/include/asm/perf_counter.h |    5 ++-
 arch/powerpc/kernel/perf_counter.c      |   44 +++++--------------------------
 arch/powerpc/kernel/power4-pmu.c        |   15 ++++++++++-
 arch/powerpc/kernel/power5+-pmu.c       |   16 ++++++++++-
 arch/powerpc/kernel/power5-pmu.c        |   15 ++++++++++-
 arch/powerpc/kernel/power6-pmu.c        |   15 ++++++++++-
 arch/powerpc/kernel/power7-pmu.c        |   15 ++++++++++-
 arch/powerpc/kernel/ppc970-pmu.c        |   16 ++++++++++-
 8 files changed, 96 insertions(+), 45 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index 31eb012..816cdd3 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -21,6 +21,7 @@
  * describe the PMU on a particular POWER-family CPU.
  */
 struct power_pmu {
+	const char	*name;
 	int		n_counter;
 	int		max_alternatives;
 	unsigned long	add_fields;
@@ -41,8 +42,6 @@ struct power_pmu {
 			       [PERF_COUNT_HW_CACHE_RESULT_MAX];
 };
 
-extern struct power_pmu *ppmu;
-
 /*
  * Values for power_pmu.flags
  */
@@ -56,6 +55,8 @@ extern struct power_pmu *ppmu;
 #define PPMU_LIMITED_PMC_REQD	2	/* have to put this on a limited PMC */
 #define PPMU_ONLY_COUNT_RUN	4	/* only counting in run state */
 
+extern int register_power_pmu(struct power_pmu *);
+
 struct pt_regs;
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 #define perf_misc_flags(regs)	perf_misc_flags(regs)
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 0249252..54e0489 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -1214,42 +1214,14 @@ void hw_perf_counter_setup(int cpu)
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
 
 	/*
 	 * Use FCHV to ignore kernel events if MSR.HV is set.
@@ -1259,5 +1231,3 @@ static int init_perf_counters(void)
 
 	return 0;
 }
-
-arch_initcall(init_perf_counters);
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
index 81a1708..db90b0c 100644
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
@@ -587,7 +589,8 @@ static int power4_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu power4_pmu = {
+static struct power_pmu power4_pmu = {
+	.name			= "POWER4/4+",
 	.n_counter		= 8,
 	.max_alternatives	= 5,
 	.add_fields		= 0x0000001100005555ul,
@@ -600,3 +603,13 @@ struct power_pmu power4_pmu = {
 	.generic_events		= p4_generic_events,
 	.cache_events		= &power4_cache_events,
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
index aef144d..f4adca8 100644
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
@@ -657,7 +659,8 @@ static int power5p_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu power5p_pmu = {
+static struct power_pmu power5p_pmu = {
+	.name			= "POWER5+/++",
 	.n_counter		= 6,
 	.max_alternatives	= MAX_ALT,
 	.add_fields		= 0x7000000000055ul,
@@ -672,3 +675,14 @@ struct power_pmu power5p_pmu = {
 	.generic_events		= power5p_generic_events,
 	.cache_events		= &power5p_cache_events,
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
index 8694c73..29b2c6c 100644
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
@@ -599,7 +601,8 @@ static int power5_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu power5_pmu = {
+static struct power_pmu power5_pmu = {
+	.name			= "POWER5",
 	.n_counter		= 6,
 	.max_alternatives	= MAX_ALT,
 	.add_fields		= 0x7000090000555ul,
@@ -612,3 +615,13 @@ struct power_pmu power5_pmu = {
 	.generic_events		= power5_generic_events,
 	.cache_events		= &power5_cache_events,
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
index 8898622..09ae5bf 100644
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
@@ -516,7 +518,8 @@ static int power6_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu power6_pmu = {
+static struct power_pmu power6_pmu = {
+	.name			= "POWER6",
 	.n_counter		= 6,
 	.max_alternatives	= MAX_ALT,
 	.add_fields		= 0x1555,
@@ -531,3 +534,13 @@ struct power_pmu power6_pmu = {
 	.generic_events		= power6_generic_events,
 	.cache_events		= &power6_cache_events,
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
index 658d1ae..5d755ef 100644
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
@@ -346,7 +348,8 @@ static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu power7_pmu = {
+static struct power_pmu power7_pmu = {
+	.name			= "POWER7",
 	.n_counter		= 6,
 	.max_alternatives	= MAX_ALT + 1,
 	.add_fields		= 0x1555ul,
@@ -359,3 +362,13 @@ struct power_pmu power7_pmu = {
 	.generic_events		= power7_generic_events,
 	.cache_events		= &power7_cache_events,
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
index 3ed8833..6637c87 100644
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
@@ -470,7 +472,8 @@ static int ppc970_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
-struct power_pmu ppc970_pmu = {
+static struct power_pmu ppc970_pmu = {
+	.name			= "PPC970/FX/MP",
 	.n_counter		= 8,
 	.max_alternatives	= 2,
 	.add_fields		= 0x001100005555ull,
@@ -483,3 +486,14 @@ struct power_pmu ppc970_pmu = {
 	.generic_events		= ppc970_generic_events,
 	.cache_events		= &ppc970_cache_events,
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760328AbZIPWkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbZIPWkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760407AbZIPWkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:40:09 -0400
Received: from kroah.org ([198.145.64.141]:48956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760348AbZIPWjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:16 2009
Message-Id: <20090916223715.891840230@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 18/45] powerpc: Fix bug where perf_counters breaks oprofile
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-fix-bug-where-perf_counters-breaks-oprofile.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Paul Mackerras <paulus@samba.org>

commit a6dbf93a2ad853585409e715eb96dca9177e3c39 upstream.

Currently there is a bug where if you use oprofile on a pSeries
machine, then use perf_counters, then use oprofile again, oprofile
will not work correctly; it will lose the PMU configuration the next
time the hypervisor does a partition context switch, and thereafter
won't count anything.

Maynard Johnson identified the sequence causing the problem:
- oprofile setup calls ppc_enable_pmcs(), which calls
  pseries_lpar_enable_pmcs, which tells the hypervisor that we want
  to use the PMU, and sets the "PMU in use" flag in the lppaca.
  This flag tells the hypervisor whether it needs to save and restore
  the PMU config.
- The perf_counter code sets and clears the "PMU in use" flag directly
  as it context-switches the PMU between tasks, and leaves it clear
  when it finishes.
- oprofile setup, called for a new oprofile run, calls ppc_enable_pmcs,
  which does nothing because it has already been called.  In particular
  it doesn't set the "PMU in use" flag.

This fixes the problem by arranging for ppc_enable_pmcs to always set
the "PMU in use" flag.  It makes the perf_counter code call
ppc_enable_pmcs also rather than calling the lower-level function
directly, and removes the setting of the "PMU in use" flag from
pseries_lpar_enable_pmcs, since that is now done in its caller.

This also removes the declaration of pasemi_enable_pmcs because it
isn't defined anywhere.

Reported-by: Maynard Johnson <mpjohn@us.ibm.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/pmc.h         |   16 ++++++++++++++--
 arch/powerpc/kernel/perf_counter.c     |   13 +++----------
 arch/powerpc/kernel/sysfs.c            |    3 +++
 arch/powerpc/platforms/pseries/setup.c |    4 ----
 4 files changed, 20 insertions(+), 16 deletions(-)

--- a/arch/powerpc/include/asm/pmc.h
+++ b/arch/powerpc/include/asm/pmc.h
@@ -27,10 +27,22 @@ extern perf_irq_t perf_irq;
 
 int reserve_pmc_hardware(perf_irq_t new_perf_irq);
 void release_pmc_hardware(void);
+void ppc_enable_pmcs(void);
 
 #ifdef CONFIG_PPC64
-void power4_enable_pmcs(void);
-void pasemi_enable_pmcs(void);
+#include <asm/lppaca.h>
+
+static inline void ppc_set_pmu_inuse(int inuse)
+{
+	get_lppaca()->pmcregs_in_use = inuse;
+}
+
+extern void power4_enable_pmcs(void);
+
+#else /* CONFIG_PPC64 */
+
+static inline void ppc_set_pmu_inuse(int inuse) { }
+
 #endif
 
 #endif /* __KERNEL__ */
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -65,7 +65,6 @@ static inline unsigned long perf_ip_adju
 {
 	return 0;
 }
-static inline void perf_set_pmu_inuse(int inuse) { }
 static inline void perf_get_data_addr(struct pt_regs *regs, u64 *addrp) { }
 static inline u32 perf_get_misc_flags(struct pt_regs *regs)
 {
@@ -96,11 +95,6 @@ static inline unsigned long perf_ip_adju
 	return 0;
 }
 
-static inline void perf_set_pmu_inuse(int inuse)
-{
-	get_lppaca()->pmcregs_in_use = inuse;
-}
-
 /*
  * The user wants a data address recorded.
  * If we're not doing instruction sampling, give them the SDAR
@@ -535,8 +529,7 @@ void hw_perf_disable(void)
 		 * Check if we ever enabled the PMU on this cpu.
 		 */
 		if (!cpuhw->pmcs_enabled) {
-			if (ppc_md.enable_pmcs)
-				ppc_md.enable_pmcs();
+			ppc_enable_pmcs();
 			cpuhw->pmcs_enabled = 1;
 		}
 
@@ -598,7 +591,7 @@ void hw_perf_enable(void)
 		mtspr(SPRN_MMCRA, cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
 		mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
 		if (cpuhw->n_counters == 0)
-			perf_set_pmu_inuse(0);
+			ppc_set_pmu_inuse(0);
 		goto out_enable;
 	}
 
@@ -631,7 +624,7 @@ void hw_perf_enable(void)
 	 * bit set and set the hardware counters to their initial values.
 	 * Then unfreeze the counters.
 	 */
-	perf_set_pmu_inuse(1);
+	ppc_set_pmu_inuse(1);
 	mtspr(SPRN_MMCRA, cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
 	mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
 	mtspr(SPRN_MMCR0, (cpuhw->mmcr[0] & ~(MMCR0_PMC1CE | MMCR0_PMCjCE))
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -17,6 +17,7 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/smp.h>
+#include <asm/pmc.h>
 
 #include "cacheinfo.h"
 
@@ -123,6 +124,8 @@ static DEFINE_PER_CPU(char, pmcs_enabled
 
 void ppc_enable_pmcs(void)
 {
+	ppc_set_pmu_inuse(1);
+
 	/* Only need to enable them once */
 	if (__get_cpu_var(pmcs_enabled))
 		return;
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -223,10 +223,6 @@ static void pseries_lpar_enable_pmcs(voi
 	set = 1UL << 63;
 	reset = 0;
 	plpar_hcall_norets(H_PERFMON, set, reset);
-
-	/* instruct hypervisor to maintain PMCs */
-	if (firmware_has_feature(FW_FEATURE_SPLPAR))
-		get_lppaca()->pmcregs_in_use = 1;
 }
 
 static void __init pseries_discover_pic(void)



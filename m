Return-Path: <linux-kernel-owner+w=401wt.eu-S1763497AbZFRMvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763497AbZFRMvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762638AbZFRMuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:50:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:38197 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762787AbZFRMuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:50:06 -0400
Date: Thu, 18 Jun 2009 12:49:31 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19000.55590.634126.876084@cargo.ozlabs.ibm.com>
References: <19000.55590.634126.876084@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: powerpc: Make powerpc perf_counter code safe for 32-bit kernels
Message-ID: <tip-98fb1807b97e3e631b940f67544e265c64b984dc@git.kernel.org>
Git-Commit-ID: 98fb1807b97e3e631b940f67544e265c64b984dc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 12:49:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98fb1807b97e3e631b940f67544e265c64b984dc
Gitweb:     http://git.kernel.org/tip/98fb1807b97e3e631b940f67544e265c64b984dc
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Wed, 17 Jun 2009 21:53:10 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Jun 2009 11:11:46 +0200

perf_counter: powerpc: Make powerpc perf_counter code safe for 32-bit kernels

This abstracts a few things in arch/powerpc/kernel/perf_counter.c
that are specific to 64-bit kernels, and provides definitions for
32-bit kernels.  In particular,

* Only 64-bit has MMCRA and the bits in it that give information
  about a PMU interrupt (sampled PR, HV, slot number etc.)
* Only 64-bit has the lppaca and the lppaca->pmcregs_in_use field
* Use of SDAR is confined to 64-bit for now
* Only 64-bit has soft/lazy interrupt disable and therefore
  pseudo-NMIs (interrupts that occur while interrupts are soft-disabled)
* Only 64-bit has PMC7 and PMC8
* Only 64-bit has the MSR_HV bit.

This also fixes the types used in a couple of places, where we were
using long types for things that need to be 64-bit.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linuxppc-dev@ozlabs.org
Cc: benh@kernel.crashing.org
LKML-Reference: <19000.55590.634126.876084@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |  193 +++++++++++++++++++++++++-----------
 1 files changed, 133 insertions(+), 60 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 25e656c..809fdf9 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
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
@@ -283,7 +396,7 @@ static int check_excludes(struct perf_counter **ctrs, unsigned int cflags[],
 
 static void power_pmu_read(struct perf_counter *counter)
 {
-	long val, delta, prev;
+	s64 val, delta, prev;
 
 	if (!counter->hw.idx)
 		return;
@@ -477,7 +590,7 @@ void hw_perf_enable(void)
 		mtspr(SPRN_MMCRA, cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
 		mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
 		if (cpuhw->n_counters == 0)
-			get_lppaca()->pmcregs_in_use = 0;
+			perf_set_pmu_inuse(0);
 		goto out_enable;
 	}
 
@@ -510,7 +623,7 @@ void hw_perf_enable(void)
 	 * bit set and set the hardware counters to their initial values.
 	 * Then unfreeze the counters.
 	 */
-	get_lppaca()->pmcregs_in_use = 1;
+	perf_set_pmu_inuse(1);
 	mtspr(SPRN_MMCRA, cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
 	mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
 	mtspr(SPRN_MMCR0, (cpuhw->mmcr[0] & ~(MMCR0_PMC1CE | MMCR0_PMCjCE))
@@ -1007,11 +1120,10 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
  * things if requested.  Note that interrupts are hard-disabled
  * here so there is no possibility of being interrupted.
  */
-static void record_and_restart(struct perf_counter *counter, long val,
+static void record_and_restart(struct perf_counter *counter, unsigned long val,
 			       struct pt_regs *regs, int nmi)
 {
 	u64 period = counter->hw.sample_period;
-	unsigned long mmcra, sdsync;
 	s64 prev, delta, left;
 	int record = 0;
 
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
+	u32 flags = perf_get_misc_flags(regs);
 
-	if (TRAP(regs) != 0xf00) {
-		/* not a PMU interrupt */
-		return user_mode(regs) ? PERF_EVENT_MISC_USER :
-			PERF_EVENT_MISC_KERNEL;
-	}
-
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
@@ -1223,11 +1294,13 @@ int register_power_pmu(struct power_pmu *pmu)
 	pr_info("%s performance monitor hardware support registered\n",
 		pmu->name);
 
+#ifdef MSR_HV
 	/*
 	 * Use FCHV to ignore kernel events if MSR.HV is set.
 	 */
 	if (mfmsr() & MSR_HV)
 		freeze_counters_kernel = MMCR0_FCHV;
+#endif /* CONFIG_PPC64 */
 
 	return 0;
 }

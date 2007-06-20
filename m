Return-Path: <linux-kernel-owner+w=401wt.eu-S1763983AbXFTSsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763983AbXFTSsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763049AbXFTSmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:42:42 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:23908 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763017AbXFTSmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:42:39 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 20:41:49 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>,
       "David Rientjes" <rientjes@google.com>
cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 6/8] 2.6.22-rc3 perfmon2 : IBS implementation for AMD64
Message-ID: <20070620184148.GG5874@erda.amd.com>
References: <20070620182126.248753000@amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jun 2007 18:41:49.0113 (UTC)
 FILETIME=[A9451290:01C7B36A]
X-WSS-ID: 6A67AA811S4957788-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=perfmon2-fam10h-006.diff
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I have modified the error handling, pls. see below.

-Robert

This patch implements Instruction Based Sampling (IBS).

2nd try:
- include/asm-i386/msr-index.h: hex values made lowercase
- arch/i386/perfmon/perfmon.c: Handling of invalid indexes in
  pfm_pmd_s*() functions changed. This may only occur if the PMU
  description has been configured incorrectly. Also the function
  interface does not allow the return of error codes. So this can be
  handled using BUG_ON().

Signed-off-by: Robert Richter <robert.richter@amd.com>

Index: linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/i386/perfmon/perfmon.c
+++ linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
@@ -5,6 +5,9 @@
  * Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
  * Contributed by Stephane Eranian <eranian@hpl.hp.com>
  *
+ * Copyright (c) 2007 Advanced Micro Devices, Inc.
+ * Contributed by Robert Richter <robert.richter@amd.com>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
@@ -26,6 +29,12 @@
 
 #include <asm/nmi.h>
 
+#define IBS_CHECK_FETCHCTL	0x01
+#define IBS_CHECK_FETCHCTR	0x02
+#define IBS_CHECK_OPCTL		0x04
+#define IBS_CHECK_OPCTR		0x08
+#define IBS_CHECK_ALL		0x0f
+
 DEFINE_PER_CPU(unsigned long, real_iip);
 
 struct pfm_ds_area {
@@ -66,6 +75,49 @@ static inline int get_smt_id(void)
 #endif
 }
 
+static inline u64 __pfm_pmd_sread(unsigned int vpmd)
+{
+	struct pfm_arch_pmu_info *arch_info = pfm_pmu_conf->arch_info;
+	return arch_info->vpmds[get_smt_id()][vpmd];
+}
+
+static inline void __pfm_pmd_swrite(unsigned int vpmd, u64 val)
+{
+	struct pfm_arch_pmu_info *arch_info = pfm_pmu_conf->arch_info;
+	arch_info->vpmds[get_smt_id()][vpmd] = val;
+}
+
+/* Context must be locked for atomic read and write operations */
+
+/* hw_addr is used as index for the virtual PMDs. If index is out of
+   range, there is a bug in the PMU description. */
+
+u64 pfm_pmd_sread(struct pfm_context *ctx, unsigned int cnum)
+{
+	unsigned int vpmd = pfm_pmu_conf->pmd_desc[cnum].hw_addr;
+	BUG_ON(! spin_is_locked(&ctx->lock));
+	BUG_ON(vpmd >= PFM_NUM_VPMDS);
+	return __pfm_pmd_sread(vpmd);
+}
+
+void pfm_pmd_swrite(struct pfm_context *ctx, unsigned int cnum, u64 val)
+{
+	unsigned int vpmd = pfm_pmu_conf->pmd_desc[cnum].hw_addr;
+	BUG_ON(! spin_is_locked(&ctx->lock));
+	BUG_ON(vpmd >= PFM_NUM_VPMDS);
+	__pfm_pmd_swrite(vpmd, val);
+}
+
+static void pfm_pmd_sinc(struct pfm_context *ctx, unsigned int cnum)
+{
+	unsigned int vpmd = pfm_pmu_conf->pmd_desc[cnum].hw_addr;
+	u64 val = 0;
+	BUG_ON(! spin_is_locked(&ctx->lock));
+	BUG_ON(vpmd >= PFM_NUM_VPMDS);
+	val = __pfm_pmd_sread(vpmd);
+	__pfm_pmd_swrite(vpmd, val + 1);
+}
+
 void __pfm_write_reg_p4(const struct pfm_arch_ext_reg *xreg, u64 val)
 {
 	u64 pmi;
@@ -309,7 +361,13 @@ static int pfm_stop_save_p6(struct pfm_c
 	count = set->nused_pmds;
 	for (i = 0; count; i++) {
 		if (test_bit(i, ulp(set->used_pmds))) {
-			val = pfm_arch_read_pmd(ctx, i);
+			count--;
+			/* Skip for IBS event counter */
+			if (unlikely(i == arch_info->ibsfetchctr_idx))
+				continue;
+			if (unlikely(i == arch_info->ibsopctr_idx))
+				continue;
+			val = pfm_read_pmd(ctx, i);
 			if (likely(test_bit(i, ulp(cnt_mask)))) {
 				if (!(val & wmask)) {
 					__set_bit(i, ulp(set->povfl_pmds));
@@ -318,16 +376,60 @@ static int pfm_stop_save_p6(struct pfm_c
 				val = (pmds[i] & ~ovfl_mask) | (val & ovfl_mask);
 			}
 			pmds[i] = val;
-			count--;
 		}
 	}
 	/* 0 means: no need to save PMDs at upper level */
 	return 0;
 }
 
+/* Check for IBS events */
+/* ctx->lock must be locked for pfm_check_ibs_event() */
+
+static inline void pfm_check_ibs_event(struct pfm_context *ctx,
+				       struct pfm_event_set *set,
+				       u16 ctl, u64 ctl_mask, u16 ctr)
+{
+	struct pfm_reg_desc *pmc_desc = pfm_pmu_conf->pmc_desc;
+	u64 val = 0;
+
+	if (unlikely(test_bit(ctr, ulp(set->povfl_pmds)))) {
+		PFM_DBG("Warning: IBS event already pending for counter %d", ctr);
+		return;
+	}
+
+	/* Check event bits in control register */
+	rdmsrl(pmc_desc[ctl].hw_addr, val);
+	if (!(val & ctl_mask))
+		return;
+
+	PFM_DBG_ovfl("IBS event occurred for counter %d", ctr);
+	__set_bit(ctr, ulp(set->povfl_pmds));
+	set->npend_ovfls++;
+	/* Increment event counter, update PMD */
+	pfm_pmd_sinc(ctx, ctr);
+	set->view->set_pmds[ctr] = pfm_pmd_sread(ctx, ctr);
+}
+
 static int pfm_stop_save_amd64(struct pfm_context *ctx,
 			       struct pfm_event_set *set)
 {
+	struct pfm_arch_pmu_info *arch_info = pfm_pmu_conf->arch_info;
+
+	if (arch_info->flags & PFM_X86_FL_IBS) {
+		BUG_ON(!spin_is_locked(&ctx->lock));
+		/* Check for IBS fetch data */
+		pfm_check_ibs_event(ctx, set,
+				    arch_info->ibsfetchctl_idx,
+				    PFM_AMD64_IBSFETCHVAL,
+				    arch_info->ibsfetchctr_idx);
+		/* Check for IBS execution data */
+		pfm_check_ibs_event(ctx, set,
+				    arch_info->ibsopctl_idx,
+				    PFM_AMD64_IBSOPVAL,
+				    arch_info->ibsopctr_idx);
+	}
+
+	/* IbsFetchCtl/IbsOpCtl is cleard in pfm_stop_save_p6() */
 	return pfm_stop_save_p6(ctx, set);
 }
 
@@ -637,6 +739,7 @@ void pfm_arch_start(struct task_struct *
 		    struct pfm_event_set *set)
 {
 	struct pfm_arch_context *ctx_arch;
+	struct pfm_reg_desc *pmc_desc;
 	u64 *mask;
 	u16 i, num;
 
@@ -673,11 +776,18 @@ void pfm_arch_start(struct task_struct *
 	 */
 	num = pfm_pmu_conf->num_pmcs;
 	mask = pfm_pmu_conf->impl_pmcs;
+	pmc_desc = pfm_pmu_conf->pmc_desc;
 	for (i = 0; num; i++) {
-		if (test_bit(i, ulp(mask))) {
+		if (!test_bit(i, ulp(mask)))
+			continue;
+		num--;
+		if (!test_bit(i, ulp(set->used_pmcs)))
+			/* If the PMC is not used, we initialize with
+			 * interrupts disabled. */
+			pfm_arch_write_pmc(ctx, i, set->pmcs[i]
+					   & ~pmc_desc[i].no_emul64_msk);
+		else
 			pfm_arch_write_pmc(ctx, i, set->pmcs[i]);
-			num--;
-		}
 	}
 
 	/*
@@ -839,18 +949,37 @@ static int __kprobes pfm_has_ovfl_p6(voi
 	xrd = arch_info->pmd_addrs;
 
 	for (i = 0; num; i++) {
-		if (test_bit(i, ulp(cnt_mask))) {
-			rdmsrl(xrd[i].addrs[0], val);
-			if (!(val & wmask))
-				return 1;
-			num--;
-		}
+		if (!test_bit(i, ulp(cnt_mask)))
+			continue;
+		num--;
+		/* Skip for IBS event counter */
+		if (unlikely(i == arch_info->ibsfetchctr_idx))
+			continue;
+		if (unlikely(i == arch_info->ibsopctr_idx))
+			continue;
+		rdmsrl(xrd[i].addrs[0], val);
+		if (!(val & wmask))
+			return 1;
 	}
 	return 0;
 }
 
 static int __kprobes pfm_has_ovfl_amd64(void)
 {
+	struct pfm_arch_pmu_info *arch_info = pfm_pmu_conf->arch_info;
+	u64 val = 0;
+
+	if (!(arch_info->flags & PFM_X86_FL_IBS))
+		return pfm_has_ovfl_p6();
+
+	/* Check for IBS events */
+	rdmsrl(pfm_pmu_conf->pmc_desc[arch_info->ibsfetchctl_idx].hw_addr, val);
+	if (val & PFM_AMD64_IBSFETCHVAL)
+		return 1;
+	rdmsrl(pfm_pmu_conf->pmc_desc[arch_info->ibsopctl_idx].hw_addr, val);
+	if (val & PFM_AMD64_IBSOPVAL)
+		return 1;
+
 	return pfm_has_ovfl_p6();
 }
 
@@ -973,11 +1102,13 @@ static struct notifier_block pfm_nmi_nb=
 int pfm_arch_pmu_config_init(struct _pfm_pmu_config *cfg)
 {
 	struct pfm_arch_pmu_info *arch_info = cfg->arch_info;
-	struct pfm_arch_ext_reg *pc;
+	struct pfm_arch_ext_reg *pc, *pd;
 	u64 *mask;
 	unsigned int i, num, ena;
+	unsigned int ibs_check;
 
 	pc = arch_info->pmc_addrs;
+	pd = arch_info->pmd_addrs;
 
 	/*
 	 * ensure that PMU description is able to deal with NMI watchdog using
@@ -1023,18 +1154,86 @@ int pfm_arch_pmu_config_init(struct _pfm
 	num = cfg->num_pmcs;
 	mask = cfg->impl_pmcs;
 	ena = 0;
+	ibs_check = 0;
 	for (i = 0; num; i++) {
-		if (test_bit(i, ulp(mask))) {
-			if (pc[i].reg_type & PFM_REGT_EN) {
-		    		__set_bit(i, ulp(arch_info->enable_mask));
-		    		ena++;
-				arch_info->max_ena = i + 1;
+		if (!test_bit(i, ulp(mask)))
+			continue;
+		num--;
+		if (!(pc[i].reg_type & PFM_REGT_EN))
+			continue;
+		if (pc[i].reg_type & PFM_REGT_IBS) {
+			if (!(arch_info->flags & PFM_X86_FL_IBS)) {
+				PFM_DBG("Skipping PMD%d, IBS not supported by the PMU", i);
+				continue;
+			}
+			if (arch_info->pmc_addrs[i].addrs[0] == MSR_AMD64_IBSFETCHCTL) {
+				PFM_DBG("IBS fetch control register detected (PMC%d)", i);
+				if (ibs_check & IBS_CHECK_FETCHCTL) {
+					PFM_INFO("Invalid PMU configuration (PMC%d), "
+						 "IBS fetch control already configured", i);
+					return -EINVAL;
+				}
+				ibs_check |= IBS_CHECK_FETCHCTL;
+				arch_info->ibsfetchctl_idx = i;
+			}
+			else if (arch_info->pmc_addrs[i].addrs[0] == MSR_AMD64_IBSOPCTL) {
+				PFM_DBG("IBS execution control register detected (PMC%d)", i);
+				if (ibs_check & IBS_CHECK_OPCTL) {
+					PFM_INFO("Invalid PMU configuration (PMC%d), "
+						 "IBS execution control already configured", i);
+					return -EINVAL;
+				}
+				ibs_check |= IBS_CHECK_OPCTL;
+				arch_info->ibsopctl_idx = i;
 			}
-			num--;
 		}
+		__set_bit(i, ulp(arch_info->enable_mask));
+		ena++;
+		arch_info->max_ena = i + 1;
 	}
 	PFM_INFO("%u PMCs with enable capability", ena);
 
+	/* Configure IBS registers */
+	if (arch_info->flags & PFM_X86_FL_IBS) {
+		num = cfg->num_pmds;
+		mask = cfg->impl_pmds;
+		for (i = 0; num; i++) {
+			if (!test_bit(i, ulp(mask)))
+				continue;
+			num--;
+			if (!(pd[i].reg_type & PFM_REGT_IBS))
+				continue;
+			if (cfg->pmd_desc[i].type != PFM_REG_ICV)
+				/* No virtual IBS counter */
+				continue;
+			if (cfg->pmd_desc[i].hw_addr == PFM_VPMD_AMD64_IBSFETCHCTR) {
+				PFM_DBG("IBS fetch counter detected (PMD%d)", i);
+				if (ibs_check & IBS_CHECK_FETCHCTR) {
+					PFM_INFO("Invalid PMU configuration (PMD%d), "
+						 "IBS fetch counter already configured", i);
+					return -EINVAL;
+				}
+				ibs_check |= IBS_CHECK_FETCHCTR;
+				arch_info->ibsfetchctr_idx = i;
+			} else if (cfg->pmd_desc[i].hw_addr == PFM_VPMD_AMD64_IBSOPCTR) {
+				PFM_DBG("IBS execution counter detected (PMD%d)", i);
+				if (ibs_check & IBS_CHECK_OPCTR) {
+					PFM_INFO("Invalid PMU configuration (PMD%d), "
+						 "IBS execution counter already configured", i);
+					return -EINVAL;
+				}
+				ibs_check |= IBS_CHECK_OPCTR;
+				arch_info->ibsopctr_idx = i;
+			}
+		}
+		if ((ibs_check & IBS_CHECK_ALL) != IBS_CHECK_ALL) {
+			PFM_INFO("Invalid PMU configuration, "
+				 "Missing settings: 0x%02x", ibs_check);
+			return -EINVAL;
+		}
+		PFM_DBG("IBS configuration successfully finished");
+	}
+
 	/*
 	 * determine interrupt type to use
 	 */
Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
+++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
@@ -5,6 +5,9 @@
  * Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
  * Contributed by Stephane Eranian <eranian@hpl.hp.com>
  *
+ * Copyright (c) 2007 Advanced Micro Devices, Inc.
+ * Contributed by Robert Richter <robert.richter@amd.com>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
@@ -25,6 +28,7 @@
 #include <asm/nmi.h>
 
 MODULE_AUTHOR("Stephane Eranian <eranian@hpl.hp.com>");
+MODULE_AUTHOR("Robert Richter <robert.richter@amd.com>");
 MODULE_DESCRIPTION("AMD64 PMU description table");
 MODULE_LICENSE("GPL");
 
@@ -38,12 +42,26 @@ static struct pfm_arch_pmu_info pfm_k8_p
 /* pmc1  */	{{MSR_K7_EVNTSEL1, 0}, 1, PFM_REGT_EN},
 /* pmc2  */	{{MSR_K7_EVNTSEL2, 0}, 2, PFM_REGT_EN},
 /* pmc3  */	{{MSR_K7_EVNTSEL3, 0}, 3, PFM_REGT_EN},
+/* pmc4  */	{{MSR_AMD64_IBSFETCHCTL, 0}, 0, PFM_REGT_EN|PFM_REGT_IBS},
+/* pmc5  */	{{MSR_AMD64_IBSOPCTL, 0}, 0, PFM_REGT_EN|PFM_REGT_IBS},
 	},
 	.pmd_addrs = {
 /* pmd0  */	{{MSR_K7_PERFCTR0, 0}, 0, PFM_REGT_CTR},
 /* pmd1  */	{{MSR_K7_PERFCTR1, 0}, 0, PFM_REGT_CTR},
 /* pmd2  */	{{MSR_K7_PERFCTR2, 0}, 0, PFM_REGT_CTR},
 /* pmd3  */	{{MSR_K7_PERFCTR3, 0}, 0, PFM_REGT_CTR},
+/* pmd4  */	{{0, 0}, 0, PFM_REGT_CTR|PFM_REGT_IBS},
+/* pmd5  */	{{MSR_AMD64_IBSFETCHCTL, 0}, 0, PFM_REGT_IBS},
+/* pmd6  */	{{MSR_AMD64_IBSFETCHLINAD, 0}, 0, PFM_REGT_IBS},
+/* pmd7  */	{{MSR_AMD64_IBSFETCHPHYSAD, 0}, 0, PFM_REGT_IBS},
+/* pmd8  */	{{0, 0}, 0, PFM_REGT_CTR|PFM_REGT_IBS},
+/* pmd9  */	{{MSR_AMD64_IBSOPCTL, 0}, 0, PFM_REGT_IBS},
+/* pmd10 */	{{MSR_AMD64_IBSOPRIP, 0}, 0, PFM_REGT_IBS},
+/* pmd11 */	{{MSR_AMD64_IBSOPDATA, 0}, 0, PFM_REGT_IBS},
+/* pmd12 */	{{MSR_AMD64_IBSOPDATA2, 0}, 0, PFM_REGT_IBS},
+/* pmd13 */	{{MSR_AMD64_IBSOPDATA3, 0}, 0, PFM_REGT_IBS|PFM_REGT_IBS_EXT},
+/* pmd14 */	{{MSR_AMD64_IBSDCLINAD, 0}, 0, PFM_REGT_IBS|PFM_REGT_IBS_EXT},
+/* pmd15 */	{{MSR_AMD64_IBSDCPHYSAD, 0}, 0, PFM_REGT_IBS|PFM_REGT_IBS_EXT},
 	},
 	.pmu_style = PFM_X86_PMU_AMD64
 };
@@ -65,11 +83,26 @@ static struct pfm_arch_pmu_info pfm_k8_p
 			| (1ULL<<20)	\
 			| (1ULL<<21))
 
+/*
+ * We mark readonly bits as reserved and use the PMC for control
+ * operations only.  Interrupt enable and clear bits are reserved too.
+ * IBSFETCHCTL is also implemented as PMD, where data can be read
+ * from. Same applies to IBSOPCTR.
+ */
+#define PFM_AMD64_IBSFETCHCTL_VAL	PFM_AMD64_IBSFETCHEN
+#define PFM_AMD64_IBSFETCHCTL_NO64	PFM_AMD64_IBSFETCHEN
+#define PFM_AMD64_IBSFETCHCTL_RSVD	(~((1ULL<<16)-1))
+#define PFM_AMD64_IBSOPCTL_VAL		PFM_AMD64_IBSOPEN
+#define PFM_AMD64_IBSOPCTL_NO64		PFM_AMD64_IBSOPEN
+#define PFM_AMD64_IBSOPCTL_RSVD		(~((1ULL<<16)-1))
+
 static struct pfm_reg_desc pfm_k8_pmc_desc[]={
 /* pmc0  */ PMC_D(PFM_REG_I64, "PERFSEL0", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL0),
 /* pmc1  */ PMC_D(PFM_REG_I64, "PERFSEL1", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL1),
 /* pmc2  */ PMC_D(PFM_REG_I64, "PERFSEL2", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL2),
 /* pmc3  */ PMC_D(PFM_REG_I64, "PERFSEL3", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL3),
+/* pmc4  */ PMC_D(PFM_REG_I, "IBSFETCHCTL", PFM_AMD64_IBSFETCHCTL_VAL, PFM_AMD64_IBSFETCHCTL_RSVD, PFM_AMD64_IBSFETCHCTL_NO64, MSR_AMD64_IBSFETCHCTL),
+/* pmc5  */ PMC_D(PFM_REG_I, "IBSOPCTL", PFM_AMD64_IBSOPCTL_VAL, PFM_AMD64_IBSOPCTL_RSVD, PFM_AMD64_IBSOPCTL_NO64, MSR_AMD64_IBSOPCTL),
 };
 #define PFM_AMD_NUM_PMCS ARRAY_SIZE(pfm_k8_pmc_desc)
 
@@ -78,6 +111,18 @@ static struct pfm_reg_desc pfm_k8_pmd_de
 /* pmd1  */ PMD_D(PFM_REG_C,   "PERFCTR1",	MSR_K7_PERFCTR1),
 /* pmd2  */ PMD_D(PFM_REG_C,   "PERFCTR2",	MSR_K7_PERFCTR2),
 /* pmd3  */ PMD_D(PFM_REG_C,   "PERFCTR3",	MSR_K7_PERFCTR3),
+/* pmd4  */ PMD_D(PFM_REG_ICV, "IBSFETCHCTR",	PFM_VPMD_AMD64_IBSFETCHCTR),
+/* pmd5  */ PMD_D(PFM_REG_IRO, "IBSFETCHCTL",	MSR_AMD64_IBSFETCHCTL),
+/* pmd6  */ PMD_D(PFM_REG_IRO, "IBSFETCHLINAD",	MSR_AMD64_IBSFETCHLINAD),
+/* pmd7  */ PMD_D(PFM_REG_IRO, "IBSFETCHPHYSAD", MSR_AMD64_IBSFETCHPHYSAD),
+/* pmd8  */ PMD_D(PFM_REG_ICV, "IBSOPCTR",	PFM_VPMD_AMD64_IBSOPCTR),
+/* pmd9  */ PMD_D(PFM_REG_IRO, "IBSOPCTL",	MSR_AMD64_IBSOPCTL),
+/* pmd10 */ PMD_D(PFM_REG_IRO, "IBSOPRIP",	MSR_AMD64_IBSOPRIP),
+/* pmd11 */ PMD_D(PFM_REG_IRO, "IBSOPDATA",	MSR_AMD64_IBSOPDATA),
+/* pmd12 */ PMD_D(PFM_REG_IRO, "IBSOPDATA2",	MSR_AMD64_IBSOPDATA2),
+/* pmd13 */ PMD_D(PFM_REG_IRO, "IBSOPDATA3",	MSR_AMD64_IBSOPDATA3),
+/* pmd14 */ PMD_D(PFM_REG_IRO, "IBSDCLINAD",	MSR_AMD64_IBSDCLINAD),
+/* pmd15 */ PMD_D(PFM_REG_IRO, "IBSDCPHYSAD",	MSR_AMD64_IBSDCPHYSAD),
 };
 #define PFM_AMD_NUM_PMDS ARRAY_SIZE(pfm_k8_pmd_desc)
 
@@ -284,6 +329,9 @@ static int pfm_k8_detect_nmi(void)
 	 * auto-detect which perfctr/eventsel is used by NMI watchdog
 	 */
 	for (i=0; i < PFM_AMD_NUM_PMDS; i++) {
+		/* skip IBS registers */
+		if (pfm_k8_pmu_info.pmc_addrs[i].reg_type & PFM_REGT_IBS)
+			continue;
 		if (avail_to_resrv_perfctr_nmi(pfm_k8_pmd_desc[i].hw_addr))
 			continue;
 
@@ -332,10 +380,75 @@ static int pfm_k8_probe_pmu(void)
 		pfm_k8_setup_nb_event_control();
 
 	PFM_INFO("Using AMD64 PMU");
+	if (pfm_k8_pmu_info.flags & PFM_X86_FL_IBS)
+		PFM_INFO("IBS is supported by processor");
+	if (pfm_k8_pmu_info.flags & PFM_X86_FL_IBS_EXT)
+		PFM_INFO("IBS extended registers are supported by processor");
 
 	return 0;
 }
 
+static inline void
+pfm_amd64_check_register(struct pfm_pmu_config *cfg,
+			 struct pfm_reg_desc *reg,
+			 struct pfm_arch_ext_reg *ext_reg)
+{
+	struct pfm_arch_pmu_info *arch_info = cfg->arch_info;
+
+	if (!(ext_reg->reg_type & PFM_REGT_AMD64))
+		/* No special AMD64 PMU register */
+		return;
+
+	/* Disable register */
+	reg->type &= ~PFM_REG_I;
+
+	switch (ext_reg->reg_type & PFM_REGT_AMD64) {
+	case (PFM_REGT_IBS):
+		/* IBS register */
+		if (!(arch_info->flags & PFM_X86_FL_IBS))
+			return;
+		break;
+	case (PFM_REGT_IBS|PFM_REGT_IBS_EXT):
+		/* IBS extended register */
+		if (!(arch_info->flags & PFM_X86_FL_IBS_EXT))
+			return;
+		break;
+	default:
+		return;
+	}
+
+	/* Enable register */
+	reg->type |= PFM_REG_I;
+}
+
+static void pfm_amd64_setup_pmu(struct pfm_pmu_config *cfg)
+{
+	u16 i;
+	struct pfm_arch_pmu_info *arch_info = cfg->arch_info;
+
+	/* set PMU features depending on CPUID */
+	arch_info->flags &= ~(PFM_X86_FL_IBS|PFM_X86_FL_IBS_EXT);
+	switch (current_cpu_data.x86) {
+	case 15:
+		break;
+	case 16:
+		arch_info->flags |= PFM_X86_FL_IBS;
+		break;
+	default:
+		break;
+	}
+
+	/* Disable unsupported PMC/PMD registers */
+	for (i = 0; i < cfg->num_pmc_entries;  i++) {
+		pfm_amd64_check_register(cfg, &cfg->pmc_desc[i],
+					 &arch_info->pmc_addrs[i]);
+	}
+	for (i = 0; i < cfg->num_pmd_entries;  i++) {
+		pfm_amd64_check_register(cfg, &cfg->pmd_desc[i],
+					 &arch_info->pmd_addrs[i]);
+	}
+}
+
 static struct pfm_pmu_config pfm_k8_pmu_conf = {
 	.pmu_name = "AMD64",
 	.counter_width = 47,
@@ -344,14 +457,17 @@ static struct pfm_pmu_config pfm_k8_pmu_
 	.num_pmc_entries = PFM_AMD_NUM_PMCS,
 	.num_pmd_entries = PFM_AMD_NUM_PMDS,
 	.probe_pmu = pfm_k8_probe_pmu,
-	.version = "1.1",
+	.version = "1.2",
 	.arch_info = &pfm_k8_pmu_info,
 	.flags = PFM_PMU_BUILTIN_FLAG,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.pmd_sread = pfm_pmd_sread,
+	.pmd_swrite = pfm_pmd_swrite,
 };
 	
 static int __init pfm_k8_pmu_init_module(void)
 {
+	pfm_amd64_setup_pmu(&pfm_k8_pmu_conf);
 	return pfm_pmu_register(&pfm_k8_pmu_conf);
 }
 
Index: linux-2.6.22-rc3/include/asm-i386/msr-index.h
===================================================================
--- linux-2.6.22-rc3.orig/include/asm-i386/msr-index.h
+++ linux-2.6.22-rc3/include/asm-i386/msr-index.h
@@ -76,6 +76,18 @@
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
+#define MSR_AMD64_IBSFETCHCTL		0xc0011030
+#define MSR_AMD64_IBSFETCHLINAD		0xc0011031
+#define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
+#define MSR_AMD64_IBSOPCTL		0xc0011033
+#define MSR_AMD64_IBSOPRIP		0xc0011034
+#define MSR_AMD64_IBSOPDATA		0xc0011035
+#define MSR_AMD64_IBSOPDATA2		0xc0011036
+#define MSR_AMD64_IBSOPDATA3		0xc0011037
+#define MSR_AMD64_IBSDCLINAD		0xc0011038
+#define MSR_AMD64_IBSDCPHYSAD		0xc0011039
+#define MSR_AMD64_IBSCTL		0xc001103a
+
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
 #define MSR_K8_TOP_MEM2			0xc001001d
Index: linux-2.6.22-rc3/include/asm-i386/perfmon.h
===================================================================
--- linux-2.6.22-rc3.orig/include/asm-i386/perfmon.h
+++ linux-2.6.22-rc3/include/asm-i386/perfmon.h
@@ -2,6 +2,9 @@
  * Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
  * Contributed by Stephane Eranian <eranian@hpl.hp.com>
  *
+ * Copyright (c) 2007 Advanced Micro Devices, Inc.
+ * Contributed by Robert Richter <robert.richter@amd.com>
+ *
  * This file contains X86 Processor Family specific definitions
  * for the perfmon interface. This covers P6, Pentium M, P4/Xeon
  * (32-bit and 64-bit, i.e., EM64T) and AMD X86-64.
@@ -29,6 +32,7 @@
 
 #include <asm/desc.h>
 #include <asm/apic.h>
+#include <linux/threads.h> /* NR_CPUS */
 
 #ifdef CONFIG_4KSTACKS
 #define PFM_ARCH_PMD_STK_ARG	2
@@ -48,6 +52,15 @@
 #define PFM_ESCR_RSVD  ~0x000000007ffffffcULL
 
 /*
+ * For AMD64
+ */
+/* Familiy 10h */
+#define PFM_AMD64_IBSFETCHEN	(1ULL<<48)
+#define PFM_AMD64_IBSFETCHVAL	(1ULL<<49)
+#define PFM_AMD64_IBSOPEN	(1ULL<<17)
+#define PFM_AMD64_IBSOPVAL	(1ULL<<18)
+
+/*
  * bitmask for reg_type
  */
 #define PFM_REGT_NA		0x0000	/* not available */
@@ -58,6 +71,17 @@
 #define PFM_REGT_NOHT		0x0020	/* unavailable with HT */
 #define PFM_REGT_CTR		0x0040	/* counter */
 #define PFM_REGT_OTH		0x0080	/* other type of register */
+#define PFM_REGT_IBS		0x0100	/* IBS register set */
+#define PFM_REGT_IBS_EXT	0x0200	/* IBS extended register set */
+
+/* AMD64 PMU features */
+#define PFM_REGT_AMD64		(PFM_REGT_IBS|PFM_REGT_IBS_EXT)
+
+/* We count IBS events in virtual PMDs to use implemented sampling
+ * features */
+#define PFM_VPMD_AMD64_IBSFETCHCTR	0
+#define PFM_VPMD_AMD64_IBSOPCTR		1
+#define PFM_NUM_VPMDS			2
 
 /*
  * This design and the partitioning of resources for SMT (hyper threads)
@@ -93,6 +117,11 @@ struct pfm_arch_pmu_info {
 	u16 pebs_ctr_idx;  /* index of PEBS IQ_CTR4 counter  (for overflow) */
 	u16 reserved;	   /* for future use */
 	u8  pmu_style;	   /* type of PMU interface (P4, P6) */
+	u64 vpmds[NR_CPUS][PFM_NUM_VPMDS];	/* virt. sw PMDs per cpu */
+	u16 ibsfetchctl_idx;    /* IBS: index of IBS fetch control register */
+	u16 ibsfetchctr_idx;    /* IBS: index of IBS fetch counter (virtual) */
+	u16 ibsopctl_idx;       /* IBS: index of IBS execution control register */
+	u16 ibsopctr_idx;       /* IBS: index of IBS execution counter (virtual) */
 };
 
 /*
@@ -109,6 +138,12 @@ struct pfm_arch_pmu_info {
 #define PFM_X86_FL_PMU_DS	0x01	/* Intel: support for Data Save Area (DS) */
 #define PFM_X86_FL_PMU_PEBS	0x02	/* Intel: support PEBS (implies DS) */
 #define PFM_X86_FL_USE_NMI	0x04	/* must use NMI interrupt */
+#define PFM_X86_FL_IBS		0x08	/* AMD64: support for IBS */
+#define PFM_X86_FL_IBS_EXT	0x10	/* AMD64: support for IBS extended registers */
+
+/* Virtual PMDs access functions */
+u64 pfm_pmd_sread(struct pfm_context *ctx, unsigned int cnum);
+void pfm_pmd_swrite(struct pfm_context *ctx, unsigned int cnum, u64 val);
 
 void __pfm_read_reg_p4(const struct pfm_arch_ext_reg *xreg, u64 *val);
 void __pfm_write_reg_p4(const struct pfm_arch_ext_reg *xreg, u64 val);
@@ -340,6 +375,9 @@ static inline int pfm_arch_context_initi
 static inline void pfm_arch_ovfl_reset_pmd(struct pfm_context *ctx, unsigned int cnum)
 {
 	u64 val;
+	if (unlikely(pfm_pmu_conf->pmd_desc[cnum].type & PFM_REG_V))
+		/* skip virtual counters */
+		return;
 	val = pfm_arch_read_pmd(ctx, cnum);
 	pfm_arch_write_pmd(ctx, cnum, val);
 }
Index: linux-2.6.22-rc3/include/linux/perfmon_pmu.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/perfmon_pmu.h
+++ linux-2.6.22-rc3/include/linux/perfmon_pmu.h
@@ -2,6 +2,9 @@
  * Copyright (c) 2006 Hewlett-Packard Development Company, L.P.
  * Contributed by Stephane Eranian <eranian@hpl.hp.com>
  *
+ * Copyright (c) 2007 Advanced Micro Devices, Inc.
+ * Contributed by Robert Richter <robert.richter@amd.com>
+ *
  * Interface for PMU description modules
  *
  * This program is free software; you can redistribute it and/or
@@ -78,6 +81,8 @@ struct pfm_reg_desc {
 #define PFM_REG_W64	(PFM_REG_WC|PFM_REG_NO64|PFM_REG_I)
 #define PFM_REG_C	(PFM_REG_C64|PFM_REG_I)
 #define PFM_REG_I64	(PFM_REG_NO64|PFM_REG_I)
+#define PFM_REG_IRO	(PFM_REG_RO|PFM_REG_I)
+#define PFM_REG_ICV	(PFM_REG_C64|PFM_REG_I|PFM_REG_V) /* virtual (sw) counter */
 
 typedef int (*pfm_pmc_check_t)(struct pfm_context *ctx,
 			       struct pfm_event_set *set,
Index: linux-2.6.22-rc3/perfmon/perfmon_intr.c
===================================================================
--- linux-2.6.22-rc3.orig/perfmon/perfmon_intr.c
+++ linux-2.6.22-rc3/perfmon/perfmon_intr.c
@@ -18,6 +18,9 @@
  * Contributed by Stephane Eranian <eranian@hpl.hp.com>
  *                David Mosberger-Tang <davidm@hpl.hp.com>
  *
+ * Copyright (c) 2007 Advanced Micro Devices, Inc.
+ * Contributed by Robert Richter <robert.richter@amd.com>
+ *
  * More information about perfmon available at:
  * 	http://perfmon2.sf.net
  *
@@ -163,7 +166,19 @@ static void pfm_overflow_handler(struct 
 		 */
 		old_val = new_val = pmds[i];
 		ovfl_thres = set->pmds[i].ovflsw_thres;
-		new_val += 1 + ovfl_mask;
+		if (likely(!(pfm_pmu_conf->pmd_desc[i].type & PFM_REG_V)))
+			new_val += 1 + ovfl_mask;
+		else {
+			/* No hardware counter */
+			/*
+			 * Since the previous value is unknown, 64 bit
+			 * overflows can only detected for zero
+			 * values. Thus, increments of more than 1
+			 * will not be detected.
+			 */
+			if (! new_val)
+				old_val = ~0;
+		}
 		pmds[i] = new_val;
 
 		/*

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com




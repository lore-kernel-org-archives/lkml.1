Return-Path: <linux-kernel-owner+w=401wt.eu-S1764325AbXFTSvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764325AbXFTSvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763625AbXFTSqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:46:24 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:41585 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763632AbXFTSqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:46:21 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 20 Jun 2007 20:39:33 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>
cc: "Andi Kleen" <andi@firstfloor.org>, "David Rientjes" <rientjes@google.com>,
       "James Troup" <james@nocrew.org>, linux-kernel@vger.kernel.org
Subject: [patch 0/8] 2.6.22-rc3 perfmon2 : IBS implementation for AMD64,
 version 2
Message-ID: <20070620183923.GA5874@erda.amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jun 2007 18:39:33.0266 (UTC)
 FILETIME=[584C7720:01C7B36A]
X-WSS-ID: 6A67ABE223K947969-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this is version 2 of the patch series. Thanks to David and James for
reviewing this. Below you can find a diff that shows changes to the
previous version. The patches are relative to Stephane's 2.6.22-rc3
Perfmon2 release.

Regards,
Robert

Index: linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/i386/perfmon/perfmon.c
+++ linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
@@ -29,6 +29,12 @@
 
 #include <asm/nmi.h>
 
+#define IBS_CHECK_FETCHCTL	0x01
+#define IBS_CHECK_FETCHCTR	0x02
+#define IBS_CHECK_OPCTL		0x04
+#define IBS_CHECK_OPCTR		0x08
+#define IBS_CHECK_ALL		0x0f
+
 DEFINE_PER_CPU(unsigned long, real_iip);
 
 struct pfm_ds_area {
@@ -83,12 +89,14 @@ static inline void __pfm_pmd_swrite(unsi
 
 /* Context must be locked for atomic read and write operations */
 
+/* hw_addr is used as index for the virtual PMDs. If index is out of
+   range, there is a bug in the PMU description. */
+
 u64 pfm_pmd_sread(struct pfm_context *ctx, unsigned int cnum)
 {
 	unsigned int vpmd = pfm_pmu_conf->pmd_desc[cnum].hw_addr;
 	BUG_ON(! spin_is_locked(&ctx->lock));
-	if (vpmd >= PFM_NUM_VPMDS)
-		return 0;
+	BUG_ON(vpmd >= PFM_NUM_VPMDS);
 	return __pfm_pmd_sread(vpmd);
 }
 
@@ -96,8 +104,7 @@ void pfm_pmd_swrite(struct pfm_context *
 {
 	unsigned int vpmd = pfm_pmu_conf->pmd_desc[cnum].hw_addr;
 	BUG_ON(! spin_is_locked(&ctx->lock));
-	if (vpmd >= PFM_NUM_VPMDS)
-		return;
+	BUG_ON(vpmd >= PFM_NUM_VPMDS);
 	__pfm_pmd_swrite(vpmd, val);
 }
 
@@ -106,8 +113,7 @@ static void pfm_pmd_sinc(struct pfm_cont
 	unsigned int vpmd = pfm_pmu_conf->pmd_desc[cnum].hw_addr;
 	u64 val = 0;
 	BUG_ON(! spin_is_locked(&ctx->lock));
-	if (vpmd >= PFM_NUM_VPMDS)
-		return;
+	BUG_ON(vpmd >= PFM_NUM_VPMDS);
 	val = __pfm_pmd_sread(vpmd);
 	__pfm_pmd_swrite(vpmd, val + 1);
 }
@@ -376,55 +382,51 @@ static int pfm_stop_save_p6(struct pfm_c
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
 	struct pfm_arch_pmu_info *arch_info = pfm_pmu_conf->arch_info;
-	struct pfm_reg_desc *pmc_desc = pfm_pmu_conf->pmc_desc;
-	u64 val = 0;
 
 	if (arch_info->flags & PFM_X86_FL_IBS) {
-		/* Check for IBS events */
 		BUG_ON(!spin_is_locked(&ctx->lock));
-		do {
-			if (unlikely(test_bit(arch_info->ibsfetchctr_idx,
-					      ulp(set->povfl_pmds)))) {
-				PFM_DBG("Warning: IBS fetch data already pending");
-				continue;
-			}
-			rdmsrl(pmc_desc[arch_info->ibsfetchctl_idx].hw_addr,
-			       val);
-			if (!(val & PFM_AMD64_IBSFETCHVAL))
-				continue;
-			PFM_DBG_ovfl("New IBS fetch data available");
-			__set_bit(arch_info->ibsfetchctr_idx,
-				  ulp(set->povfl_pmds));
-			set->npend_ovfls++;
-			/* Increment event counter */
-			pfm_pmd_sinc(ctx, arch_info->ibsfetchctr_idx);
-			/* Update PMD */
-			set->view->set_pmds[arch_info->ibsfetchctr_idx] =
-				pfm_read_pmd(ctx, arch_info->ibsfetchctr_idx);
-		} while (0);
-		do {
-			if (unlikely(test_bit(arch_info->ibsopctr_idx,
-					      ulp(set->povfl_pmds)))) {
-				PFM_DBG("Warning: IBS execution data already pending");
-				continue;
-			}
-			rdmsrl(pmc_desc[arch_info->ibsopctl_idx].hw_addr, val);
-			if (!(val & PFM_AMD64_IBSOPVAL))
-				continue;
-			PFM_DBG_ovfl("New IBS execution data available");
-			__set_bit(arch_info->ibsopctr_idx,
-				  ulp(set->povfl_pmds));
-			set->npend_ovfls++;
-			/* Increment event counter */
-			pfm_pmd_sinc(ctx, arch_info->ibsopctr_idx);
-			/* Update PMD */
-			set->view->set_pmds[arch_info->ibsopctr_idx] =
-				pfm_read_pmd(ctx, arch_info->ibsopctr_idx);
-		} while (0);
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
 	}
 
 	/* IbsFetchCtl/IbsOpCtl is cleard in pfm_stop_save_p6() */
@@ -737,7 +739,7 @@ void pfm_arch_start(struct task_struct *
 		    struct pfm_event_set *set)
 {
 	struct pfm_arch_context *ctx_arch;
-	struct pfm_reg_desc* pmc_desc;
+	struct pfm_reg_desc *pmc_desc;
 	u64 *mask;
 	u16 i, num;
 
@@ -1103,12 +1105,7 @@ int pfm_arch_pmu_config_init(struct _pfm
 	struct pfm_arch_ext_reg *pc, *pd;
 	u64 *mask;
 	unsigned int i, num, ena;
-	unsigned int ibs_check = 0;
-#define IBS_CHECK_FETCHCTL	0x01
-#define IBS_CHECK_FETCHCTR	0x02
-#define IBS_CHECK_OPCTL		0x04
-#define IBS_CHECK_OPCTR		0x08
-#define IBS_CHECK_ALL		0x0f
+	unsigned int ibs_check;
 
 	pc = arch_info->pmc_addrs;
 	pd = arch_info->pmd_addrs;
Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_amd64.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_amd64.c
+++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_amd64.c
@@ -1,5 +1,5 @@
 /*
- * This file contains the PMU description for the Ahtlon64 and Opteron64
+ * This file contains the PMU description for the Athlon64 and Opteron64
  * processors. It supports 32 and 64-bit modes.
  *
  * Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
Index: linux-2.6.22-rc3/include/asm-i386/msr-index.h
===================================================================
--- linux-2.6.22-rc3.orig/include/asm-i386/msr-index.h
+++ linux-2.6.22-rc3/include/asm-i386/msr-index.h
@@ -76,24 +76,24 @@
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
-#define MSR_AMD64_IBSFETCHCTL		0xC0011030
-#define MSR_AMD64_IBSFETCHLINAD		0xC0011031
-#define MSR_AMD64_IBSFETCHPHYSAD	0xC0011032
-#define MSR_AMD64_IBSOPCTL		0xC0011033
-#define MSR_AMD64_IBSOPRIP		0xC0011034
-#define MSR_AMD64_IBSOPDATA		0xC0011035
-#define MSR_AMD64_IBSOPDATA2		0xC0011036
-#define MSR_AMD64_IBSOPDATA3		0xC0011037
-#define MSR_AMD64_IBSDCLINAD		0xC0011038
-#define MSR_AMD64_IBSDCPHYSAD		0xC0011039
-#define MSR_AMD64_IBSCTL		0xC001103A
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
 
 /* K8 MSRs */
-#define MSR_K8_TOP_MEM1			0xC001001A
-#define MSR_K8_TOP_MEM2			0xC001001D
-#define MSR_K8_SYSCFG			0xC0010010
-#define MSR_K8_HWCR			0xC0010015
+#define MSR_K8_TOP_MEM1			0xc001001a
+#define MSR_K8_TOP_MEM2			0xc001001d
+#define MSR_K8_SYSCFG			0xc0010010
+#define MSR_K8_HWCR			0xc0010015
 #define MSR_K8_ENABLE_C1E		0xc0010055
 #define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
 #define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
 

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com




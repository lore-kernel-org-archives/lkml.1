Return-Path: <linux-kernel-owner+w=401wt.eu-S1764130AbXFTStl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764130AbXFTStl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763001AbXFTSnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:43:16 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:38488 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763127AbXFTSnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:43:14 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 20:41:43 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>
cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 5/8] 2.6.22-rc3 perfmon2 : Initial AMD64 PMU
 configuration
Message-ID: <20070620184143.GF5874@erda.amd.com>
References: <20070620182126.248753000@amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jun 2007 18:41:43.0253 (UTC)
 FILETIME=[A5C6E850:01C7B36A]
X-WSS-ID: 6A67AB7A1S4957745-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=perfmon2-fam10h-005.diff
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements an initial AMD64 PMU configuration.

Signed-off-by: Robert Richter <robert.richter@amd.com>

Index: linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/i386/perfmon/perfmon.c
+++ linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
@@ -325,6 +325,12 @@ static int pfm_stop_save_p6(struct pfm_c
 	return 0;
 }
 
+static int pfm_stop_save_amd64(struct pfm_context *ctx,
+			       struct pfm_event_set *set)
+{
+	return pfm_stop_save_p6(ctx, set);
+}
+
 static int pfm_stop_save_core(struct pfm_context *ctx,
 			      struct pfm_event_set *set)
 {
@@ -843,6 +849,11 @@ static int __kprobes pfm_has_ovfl_p6(voi
 	return 0;
 }
 
+static int __kprobes pfm_has_ovfl_amd64(void)
+{
+	return pfm_has_ovfl_p6();
+}
+
 /*
  * detect is counters have overflowed.
  * return:
@@ -998,6 +1009,10 @@ int pfm_arch_pmu_config_init(struct _pfm
 		pfm_stop_save = pfm_stop_save_core;
 		pfm_has_ovfl  = pfm_has_ovfl_core;
 		break;
+	case PFM_X86_PMU_AMD64:
+		pfm_stop_save = pfm_stop_save_amd64;
+		pfm_has_ovfl  = pfm_has_ovfl_amd64;
+		break;
 	default:
 		PFM_INFO("unknown pmu_style=%d", arch_info->pmu_style);
 		return -EINVAL;
Index: linux-2.6.22-rc3/include/asm-i386/msr-index.h
===================================================================
--- linux-2.6.22-rc3.orig/include/asm-i386/msr-index.h
+++ linux-2.6.22-rc3/include/asm-i386/msr-index.h
@@ -73,7 +73,7 @@
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
 
-/* K7/K8 MSRs. Not complete. See the architecture manual for a more
+/* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
 /* K8 MSRs */
Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
+++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
@@ -25,7 +25,7 @@
 #include <asm/nmi.h>
 
 MODULE_AUTHOR("Stephane Eranian <eranian@hpl.hp.com>");
-MODULE_DESCRIPTION("Athlon/Opteron 64 (K8) PMU description table");
+MODULE_DESCRIPTION("AMD64 PMU description table");
 MODULE_LICENSE("GPL");
 
 static int force_nmi;
@@ -45,7 +45,7 @@ static struct pfm_arch_pmu_info pfm_k8_p
 /* pmd2  */	{{MSR_K7_PERFCTR2, 0}, 0, PFM_REGT_CTR},
 /* pmd3  */	{{MSR_K7_PERFCTR3, 0}, 0, PFM_REGT_CTR},
 	},
-	.pmu_style = PFM_X86_PMU_P6
+	.pmu_style = PFM_X86_PMU_AMD64
 };
 
 /*
@@ -331,11 +331,13 @@ static int pfm_k8_probe_pmu(void)
 	if (current_cpu_data.x86_max_cores > 1)
 		pfm_k8_setup_nb_event_control();
 
+	PFM_INFO("Using AMD64 PMU");
+
 	return 0;
 }
 
-static struct pfm_pmu_config pfm_k8_pmu_conf={
-	.pmu_name = "AMD K8",
+static struct pfm_pmu_config pfm_k8_pmu_conf = {
+	.pmu_name = "AMD64",
 	.counter_width = 47,
 	.pmd_desc = pfm_k8_pmd_desc,
 	.pmc_desc = pfm_k8_pmc_desc,
Index: linux-2.6.22-rc3/include/asm-i386/perfmon.h
===================================================================
--- linux-2.6.22-rc3.orig/include/asm-i386/perfmon.h
+++ linux-2.6.22-rc3/include/asm-i386/perfmon.h
@@ -98,16 +98,17 @@ struct pfm_arch_pmu_info {
 /*
  * X86 PMU style
  */
-#define PFM_X86_PMU_P4	 1 /* Intel P4/Xeon/EM64T processor PMU */
-#define PFM_X86_PMU_P6	 2 /* Intel P6/Pentium M, AMD X86-64 processor PMU */
-#define PFM_X86_PMU_CORE 3 /* Intel Core PMU */
+#define PFM_X86_PMU_P4		1 /* Intel P4/Xeon/EM64T processor PMU */
+#define PFM_X86_PMU_P6		2 /* Intel P6/Pentium M */
+#define PFM_X86_PMU_CORE	3 /* Intel Core PMU */
+#define PFM_X86_PMU_AMD64	4 /* AMD64 PMU (K8, family 10h) */
 
 /*
  * PMU feature flags
  */
-#define PFM_X86_FL_PMU_DS	0x1	/* Intel: support for Data Save Area (DS) */
-#define PFM_X86_FL_PMU_PEBS	0x2	/* Intel: support PEBS (implies DS) */
-#define PFM_X86_FL_USE_NMI	0x4	/* must use NMI interrupt */
+#define PFM_X86_FL_PMU_DS	0x01	/* Intel: support for Data Save Area (DS) */
+#define PFM_X86_FL_PMU_PEBS	0x02	/* Intel: support PEBS (implies DS) */
+#define PFM_X86_FL_USE_NMI	0x04	/* must use NMI interrupt */
 
 void __pfm_read_reg_p4(const struct pfm_arch_ext_reg *xreg, u64 *val);
 void __pfm_write_reg_p4(const struct pfm_arch_ext_reg *xreg, u64 val);

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com




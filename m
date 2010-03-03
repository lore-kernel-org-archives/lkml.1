Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0CCQrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:47:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:46187 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0CCQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:45:23 -0500
Message-Id: <20100303164306.678437077@chello.nl>
References: <20100303163936.906011640@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 03 Mar 2010 17:39:47 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 11/11] perf, x86: Clean up IA32_PERF_CAPABILITIES usage
Content-Disposition: inline; filename=perf-capabilities.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saner PERF_CAPABILITIES support

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c           |   15 +++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel.c     |   10 ++++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   26 +++++++++++++-------------
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   18 ++++--------------
 4 files changed, 40 insertions(+), 29 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -154,6 +154,17 @@ struct cpu_hw_events {
 #define for_each_event_constraint(e, c)	\
 	for ((e) = (c); (e)->cmask; (e)++)
 
+union perf_capabilities {
+	struct {
+		u64	lbr_format    : 6;
+		u64	pebs_trap     : 1;
+		u64	pebs_arch_reg : 1;
+		u64	pebs_format   : 4;
+		u64	smm_freeze    : 1;
+	};
+	u64	capabilities;
+};
+
 /*
  * struct x86_pmu - generic x86 pmu
  */
@@ -190,7 +201,8 @@ struct x86_pmu {
 	/*
 	 * Intel Arch Perfmon v2+
 	 */
-	u64		intel_ctrl;
+	u64			intel_ctrl;
+	union perf_capabilities intel_perf_capabilities;
 
 	/*
 	 * Intel DebugStore bits
@@ -205,7 +217,6 @@ struct x86_pmu {
 	 */
 	unsigned long	lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
 	int		lbr_nr;			   /* hardware stack size */
-	int		lbr_format;		   /* hardware format     */
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -840,6 +840,16 @@ static __init int intel_pmu_init(void)
 	if (version > 1)
 		x86_pmu.num_events_fixed = max((int)edx.split.num_events_fixed, 3);
 
+	/*
+	 * v2 and above have a perf capabilities MSR
+	 */
+	if (version > 1) {
+		u64 capabilities;
+
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);
+		x86_pmu.intel_perf_capabilities.capabilities = capabilities;
+	}
+
 	intel_ds_init();
 
 	/*
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -444,6 +444,12 @@ static void intel_pmu_pebs_fixup_ip(stru
 	u8 *kaddr;
 	int i;
 
+	/*
+	 * We don't need to fixup if the PEBS assist is fault like
+	 */
+	if (!x86_pmu.intel_perf_capabilities.pebs_trap)
+		return;
+
 	if (from && to) {
 		/*
 		 * We sampled a branch insn, rewind using the LBR stack
@@ -619,34 +625,28 @@ static void intel_ds_init(void)
 	x86_pmu.bts  = boot_cpu_has(X86_FEATURE_BTS);
 	x86_pmu.pebs = boot_cpu_has(X86_FEATURE_PEBS);
 	if (x86_pmu.pebs) {
-		int format = 0;
-
-		if (x86_pmu.version > 1) {
-			u64 capabilities;
-			/*
-			 * v2+ has a PEBS format field
-			 */
-			rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);
-			format = (capabilities >> 8) & 0xf;
-		}
+		int format = x86_pmu.intel_perf_capabilities.pebs_format;
+		char pebs_type =
+			x86_pmu.intel_perf_capabilities.pebs_trap ?  '+' : '-';
 
 		switch (format) {
 		case 0:
-			printk(KERN_CONT "PEBS v0, ");
+			printk(KERN_CONT "PEBS fmt0%c, ", pebs_type);
 			x86_pmu.pebs_record_size = sizeof(struct pebs_record_core);
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_core;
 			x86_pmu.pebs_constraints = intel_core_pebs_events;
 			break;
 
 		case 1:
-			printk(KERN_CONT "PEBS v1, ");
+			printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
 			x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
 			x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
 			break;
 
 		default:
-			printk(KERN_CONT "PEBS unknown format: %d, ", format);
+			printk(KERN_CONT "no PEBS fmt%d%c, ",
+					format, pebs_type);
 			x86_pmu.pebs = 0;
 			break;
 		}
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -53,7 +53,7 @@ static void intel_pmu_lbr_reset_64(void)
 
 static void intel_pmu_lbr_reset(void)
 {
-	if (x86_pmu.lbr_format == LBR_FORMAT_32)
+	if (x86_pmu.intel_perf_capabilities.lbr_format == LBR_FORMAT_32)
 		intel_pmu_lbr_reset_32();
 	else
 		intel_pmu_lbr_reset_64();
@@ -155,6 +155,7 @@ static void intel_pmu_lbr_read_32(struct
 static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 {
 	unsigned long mask = x86_pmu.lbr_nr - 1;
+	int lbr_format = x86_pmu.intel_perf_capabilities.lbr_format;
 	u64 tos = intel_pmu_lbr_tos();
 	int i;
 
@@ -165,7 +166,7 @@ static void intel_pmu_lbr_read_64(struct
 		rdmsrl(x86_pmu.lbr_from + lbr_idx, from);
 		rdmsrl(x86_pmu.lbr_to   + lbr_idx, to);
 
-		if (x86_pmu.lbr_format == LBR_FORMAT_EIP_FLAGS) {
+		if (lbr_format == LBR_FORMAT_EIP_FLAGS) {
 			flags = !!(from & LBR_FROM_FLAG_MISPRED);
 			from = (u64)((((s64)from) << 1) >> 1);
 		}
@@ -184,7 +185,7 @@ static void intel_pmu_lbr_read(struct pe
 	if (!cpuc->lbr_users)
 		return;
 
-	if (x86_pmu.lbr_format == LBR_FORMAT_32)
+	if (x86_pmu.intel_perf_capabilities.lbr_format == LBR_FORMAT_32)
 		intel_pmu_lbr_read_32(cpuc);
 	else
 		intel_pmu_lbr_read_64(cpuc);
@@ -192,17 +193,8 @@ static void intel_pmu_lbr_read(struct pe
 	data->branches = &cpuc->lbr_stack;
 }
 
-static int intel_pmu_lbr_format(void)
-{
-	u64 capabilities;
-
-	rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);
-	return capabilities & 0x1f;
-}
-
 static void intel_pmu_lbr_init_core(void)
 {
-	x86_pmu.lbr_format = intel_pmu_lbr_format();
 	x86_pmu.lbr_nr     = 4;
 	x86_pmu.lbr_tos    = 0x01c9;
 	x86_pmu.lbr_from   = 0x40;
@@ -211,7 +203,6 @@ static void intel_pmu_lbr_init_core(void
 
 static void intel_pmu_lbr_init_nhm(void)
 {
-	x86_pmu.lbr_format = intel_pmu_lbr_format();
 	x86_pmu.lbr_nr     = 16;
 	x86_pmu.lbr_tos    = 0x01c9;
 	x86_pmu.lbr_from   = 0x680;
@@ -220,7 +211,6 @@ static void intel_pmu_lbr_init_nhm(void)
 
 static void intel_pmu_lbr_init_atom(void)
 {
-	x86_pmu.lbr_format = intel_pmu_lbr_format();
 	x86_pmu.lbr_nr	   = 8;
 	x86_pmu.lbr_tos    = 0x01c9;
 	x86_pmu.lbr_from   = 0x40;

-- 


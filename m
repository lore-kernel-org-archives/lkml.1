Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0CDOB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:01:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:39699 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0CDOBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:01:55 -0500
Message-Id: <20100304140100.770650663@chello.nl>
References: <20100304140046.596569763@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 04 Mar 2010 15:00:57 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/14] perf, x86: Clean up IA32_PERF_CAPABILITIES usage
Content-Disposition: inline; filename=perf-capabilities.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saner PERF_CAPABILITIES support, which also exposes pebs_trap. Use that
latter to make PEBS's use of LBR conditional since a fault-like pebs
should already report the correct IP.

(As of this writing there is no known hardware that implements !pebs_trap)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c           |   15 ++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel.c     |   10 +++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   30 ++++++++++++++---------------
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   18 +++--------------
 4 files changed, 42 insertions(+), 31 deletions(-)

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
+	union perf_capabilities intel_cap;
 
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
@@ -834,6 +834,16 @@ static __init int intel_pmu_init(void)
 	if (version > 1)
 		x86_pmu.num_events_fixed = max((int)edx.split.num_events_fixed, 3);
 
+	/*
+	 * v2 and above have a perf capabilities MSR
+	 */
+	if (version > 1) {
+		u64 capabilities;
+
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);
+		x86_pmu.intel_cap.capabilities = capabilities;
+	}
+
 	intel_ds_init();
 
 	/*
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -342,7 +342,8 @@ static void intel_pmu_pebs_enable(struct
 	val |= 1ULL << hwc->idx;
 	wrmsrl(MSR_IA32_PEBS_ENABLE, val);
 
-	intel_pmu_lbr_enable(event);
+	if (x86_pmu.intel_cap.pebs_trap)
+		intel_pmu_lbr_enable(event);
 }
 
 static void intel_pmu_pebs_disable(struct perf_event *event)
@@ -356,7 +357,8 @@ static void intel_pmu_pebs_disable(struc
 
 	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
 
-	intel_pmu_lbr_disable(event);
+	if (x86_pmu.intel_cap.pebs_trap)
+		intel_pmu_lbr_disable(event);
 }
 
 static void intel_pmu_pebs_enable_all(void)
@@ -395,6 +397,12 @@ static int intel_pmu_pebs_fixup_ip(struc
 	unsigned long old_to, to = cpuc->lbr_entries[0].to;
 	unsigned long ip = regs->ip;
 
+	/*
+	 * We don't need to fixup if the PEBS assist is fault like
+	 */
+	if (!x86_pmu.intel_cap.pebs_trap)
+		return 1;
+
 	if (!cpuc->lbr_stack.nr || !from || !to)
 		return 0;
 
@@ -599,34 +607,26 @@ static void intel_ds_init(void)
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
+		char pebs_type = x86_pmu.intel_cap.pebs_trap ?  '+' : '-';
+		int format = x86_pmu.intel_cap.pebs_format;
 
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
+			printk(KERN_CONT "no PEBS fmt%d%c, ", format, pebs_type);
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
+	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
 		intel_pmu_lbr_reset_32();
 	else
 		intel_pmu_lbr_reset_64();
@@ -155,6 +155,7 @@ static void intel_pmu_lbr_read_32(struct
 static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 {
 	unsigned long mask = x86_pmu.lbr_nr - 1;
+	int lbr_format = x86_pmu.intel_cap.lbr_format;
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
@@ -184,23 +185,14 @@ static void intel_pmu_lbr_read(void)
 	if (!cpuc->lbr_users)
 		return;
 
-	if (x86_pmu.lbr_format == LBR_FORMAT_32)
+	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
 		intel_pmu_lbr_read_32(cpuc);
 	else
 		intel_pmu_lbr_read_64(cpuc);
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
@@ -209,7 +201,6 @@ static void intel_pmu_lbr_init_core(void
 
 static void intel_pmu_lbr_init_nhm(void)
 {
-	x86_pmu.lbr_format = intel_pmu_lbr_format();
 	x86_pmu.lbr_nr     = 16;
 	x86_pmu.lbr_tos    = 0x01c9;
 	x86_pmu.lbr_from   = 0x680;
@@ -218,7 +209,6 @@ static void intel_pmu_lbr_init_nhm(void)
 
 static void intel_pmu_lbr_init_atom(void)
 {
-	x86_pmu.lbr_format = intel_pmu_lbr_format();
 	x86_pmu.lbr_nr	   = 8;
 	x86_pmu.lbr_tos    = 0x01c9;
 	x86_pmu.lbr_from   = 0x40;

-- 


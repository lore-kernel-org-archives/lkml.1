Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0CEPnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:43:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0CEPnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:43:11 -0500
Message-Id: <20100305154128.966563424@chello.nl>
References: <20100305153926.639506880@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 05 Mar 2010 16:39:30 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/5] perf, x86: Clear the LBRs on init
Content-Disposition: inline; filename=lbr-errata-aak136.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some CPUs have errata where the LBR is not cleared on Power-On. So
always clear the LBRs before use.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event_intel.c     |   18 ++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    3 +++
 2 files changed, 19 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -775,6 +775,20 @@ static __initconst struct x86_pmu core_p
 	.event_constraints	= intel_core_event_constraints,
 };
 
+static void intel_pmu_cpu_starting(int cpu)
+{
+	init_debug_store_on_cpu(cpu);
+	/*
+	 * Deal with CPUs that don't clear their LBRs on power-up.
+	 */
+	intel_pmu_lbr_reset();
+}
+
+static void intel_pmu_cpu_dying(int cpu)
+{
+	fini_debug_store_on_cpu(cpu);
+}
+
 static __initconst struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -796,8 +810,8 @@ static __initconst struct x86_pmu intel_
 	.max_period		= (1ULL << 31) - 1,
 	.get_event_constraints	= intel_get_event_constraints,
 
-	.cpu_starting		= init_debug_store_on_cpu,
-	.cpu_dying		= fini_debug_store_on_cpu,
+	.cpu_starting		= intel_pmu_cpu_starting,
+	.cpu_dying		= intel_pmu_cpu_dying,
 };
 
 static void intel_clowertown_quirks(void)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -53,6 +53,9 @@ static void intel_pmu_lbr_reset_64(void)
 
 static void intel_pmu_lbr_reset(void)
 {
+	if (!x86_pmu.lbr_nr)
+		return;
+
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
 		intel_pmu_lbr_reset_32();
 	else

-- 


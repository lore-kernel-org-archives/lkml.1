Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0CEPnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:43:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:36820 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0CEPnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:43:20 -0500
Message-Id: <20100305154128.890278662@chello.nl>
References: <20100305153926.639506880@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 05 Mar 2010 16:39:29 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/5] perf, x86: Disable PEBS on clowertown chips
Content-Disposition: inline; filename=pebs-errata.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This CPU has just too many handycaps to be really useful.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c       |    4 ++++
 arch/x86/kernel/cpu/perf_event_intel.c |   27 +++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -197,6 +197,7 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
+	void		(*quirks)(void);
 
 	void		(*cpu_prepare)(int cpu);
 	void		(*cpu_starting)(int cpu);
@@ -1380,6 +1381,9 @@ void __init init_hw_perf_events(void)
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
+	if (x86_pmu.quirks)
+		x86_pmu.quirks();
+
 	if (x86_pmu.num_events > X86_PMC_MAX_GENERIC) {
 		WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
 		     x86_pmu.num_events, X86_PMC_MAX_GENERIC);
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -800,6 +800,32 @@ static __initconst struct x86_pmu intel_
 	.cpu_dying		= fini_debug_store_on_cpu,
 };
 
+static void intel_clowertown_quirks(void)
+{
+	/*
+	 * PEBS is unreliable due to:
+	 *
+	 *   AJ67  - PEBS may experience CPL leaks
+	 *   AJ68  - PEBS PMI may be delayed by one event
+	 *   AJ69  - GLOBAL_STATUS[62] will only be set when DEBUGCTL[12]
+	 *   AJ106 - FREEZE_LBRS_ON_PMI doesn't work in combination with PEBS
+	 *
+	 * AJ67 could be worked around by restricting the OS/USR flags.
+	 * AJ69 could be worked around by setting PMU_FREEZE_ON_PMI.
+	 *
+	 * AJ106 could possibly be worked around by not allowing LBR
+	 *       usage from PEBS, including the fixup.
+	 * AJ68  could possibly be worked around by always programming
+	 * 	 a pebs_event_reset[0] value and coping with the lost events.
+	 *
+	 * But taken together it might just make sense to not enable PEBS on
+	 * these chips.
+	 */
+	printk(KERN_WARNING "PEBS disabled due to CPU errata.\n");
+	x86_pmu.pebs = 0;
+	x86_pmu.pebs_constraints = NULL;
+}
+
 static __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -864,6 +890,7 @@ static __init int intel_pmu_init(void)
 		break;
 
 	case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
+		x86_pmu.quirks = intel_clowertown_quirks;
 	case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
 	case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
 	case 29: /* six-core 45 nm xeon "Dunnington" */

-- 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0CJNV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:21:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:57550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab0CJNVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:21:55 -0500
Date: Wed, 10 Mar 2010 13:21:12 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100305154128.890278662@chello.nl>
References: <20100305154128.890278662@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Disable PEBS on clovertown chips
Message-ID: <tip-3c44780b220e876b01e39d4028cd6f4205fbf5d6@git.kernel.org>
Git-Commit-ID: 3c44780b220e876b01e39d4028cd6f4205fbf5d6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:21:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c44780b220e876b01e39d4028cd6f4205fbf5d6
Gitweb:     http://git.kernel.org/tip/3c44780b220e876b01e39d4028cd6f4205fbf5d6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 4 Mar 2010 21:49:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:35 +0100

perf, x86: Disable PEBS on clovertown chips

This CPU has just too many handycaps to be really useful.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <20100305154128.890278662@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |    4 ++++
 arch/x86/kernel/cpu/perf_event_intel.c |   27 +++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 7b5430b..335ee1d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -197,6 +197,7 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
+	void		(*quirks)(void);
 
 	void		(*cpu_prepare)(int cpu);
 	void		(*cpu_starting)(int cpu);
@@ -1373,6 +1374,9 @@ void __init init_hw_perf_events(void)
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
+	if (x86_pmu.quirks)
+		x86_pmu.quirks();
+
 	if (x86_pmu.num_events > X86_PMC_MAX_GENERIC) {
 		WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
 		     x86_pmu.num_events, X86_PMC_MAX_GENERIC);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 246c072..224c952 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -792,6 +792,32 @@ static __initconst struct x86_pmu intel_pmu = {
 	.cpu_dying		= fini_debug_store_on_cpu,
 };
 
+static void intel_clovertown_quirks(void)
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
@@ -856,6 +882,7 @@ static __init int intel_pmu_init(void)
 		break;
 
 	case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
+		x86_pmu.quirks = intel_clovertown_quirks;
 	case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
 	case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
 	case 29: /* six-core 45 nm xeon "Dunnington" */

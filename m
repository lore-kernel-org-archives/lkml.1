Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZBGAwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZBGAwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZBGAw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:52:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:8733 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbZBGAw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:52:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,394,1231142400"; 
   d="scan'208";a="384795855"
Date: Fri, 6 Feb 2009 16:52:05 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Add clflush before monitor for Intel 7400 series - v2
Message-ID: <20090207005205.GB17586@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Sorry for the duplicate. resending to proper recipients)

For Intel 7400 series CPUs, the recommendation is to use a clflush on the
monitored address just before monitor and mwait pair [1]. This clflush makes
sure that there are no false wakeups from mwait when the monitored address
was recently written to.

[1] "MONITOR/MWAIT Recommendations for Intel Xeon Processor 7400 series"
section in specification update document of 7400 series
http://download.intel.com/design/xeon/specupdt/32033601.pdf

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---

Earlier patch:
http://marc.info/?l=linux-kernel&m=122341330606025&w=2

Current changes:
Minor modification based on Peter's comment

 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/intel.c       |    3 +++
 arch/x86/kernel/process.c         |    6 ++++++
 3 files changed, 10 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c	2009-02-06 15:58:25.000000000 -0800
+++ linux-2.6/arch/x86/kernel/cpu/intel.c	2009-02-06 16:11:41.000000000 -0800
@@ -291,6 +291,9 @@ static void __cpuinit init_intel(struct 
 		ds_init_intel(c);
 	}
 
+	if (c->x86 == 6 && c->x86_model == 29 && cpu_has_clflush)
+		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
+
 #ifdef CONFIG_X86_64
 	if (c->x86 == 15)
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c	2009-02-03 12:58:38.000000000 -0800
+++ linux-2.6/arch/x86/kernel/process.c	2009-02-06 16:11:41.000000000 -0800
@@ -180,6 +180,9 @@ void mwait_idle_with_hints(unsigned long
 
 	trace_power_start(&it, POWER_CSTATE, (ax>>4)+1);
 	if (!need_resched()) {
+		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
@@ -194,6 +197,9 @@ static void mwait_idle(void)
 	struct power_trace it;
 	if (!need_resched()) {
 		trace_power_start(&it, POWER_CSTATE, 1);
+		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
Index: linux-2.6/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cpufeature.h	2009-02-06 16:11:12.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/cpufeature.h	2009-02-06 16:40:44.000000000 -0800
@@ -93,6 +93,7 @@
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
+#define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYJGVBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYJGVBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYJGVA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:00:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:9434 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbYJGVA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:00:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="345113348"
Date: Tue, 7 Oct 2008 14:00:57 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Add clflush before monitor for Intel 7400 series
Message-ID: <20081007210056.GA5802@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For Intel 7400 series CPUs, the recommendation is to use a clflush on the
monitored address just before monitor and mwait pair [1]. This clflush makes
sure that there are no false wakeups from mwait when the monitored address
was recently written to.

[1] "MONITOR/MWAIT Recommendations for Intel Xeon Processor 7400 series"
section in specification update document of 7400 series
http://download.intel.com/design/xeon/specupdt/32033601.pdf

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/kernel/cpu/intel.c  |    3 +++
 arch/x86/kernel/process.c    |    6 ++++++
 include/asm-x86/cpufeature.h |    1 +
 3 files changed, 10 insertions(+)

Index: tip/arch/x86/kernel/cpu/intel.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/intel.c	2008-10-07 13:04:01.000000000 -0700
+++ tip/arch/x86/kernel/cpu/intel.c	2008-10-07 13:55:08.000000000 -0700
@@ -262,6 +262,9 @@ static void __cpuinit init_intel(struct 
 		ds_init_intel(c);
 	}
 
+	if (c->x86 == 6 && c->x86_model == 29 && cpu_has_clflush)
+		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
+
 #ifdef CONFIG_X86_64
 	if (c->x86 == 15)
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
Index: tip/arch/x86/kernel/process.c
===================================================================
--- tip.orig/arch/x86/kernel/process.c	2008-10-07 13:04:01.000000000 -0700
+++ tip/arch/x86/kernel/process.c	2008-10-07 13:47:07.000000000 -0700
@@ -155,6 +155,9 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
 	if (!need_resched()) {
+		if (boot_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
@@ -166,6 +169,9 @@ void mwait_idle_with_hints(unsigned long
 static void mwait_idle(void)
 {
 	if (!need_resched()) {
+		if (boot_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
Index: tip/include/asm-x86/cpufeature.h
===================================================================
--- tip.orig/include/asm-x86/cpufeature.h	2008-10-07 13:07:59.000000000 -0700
+++ tip/include/asm-x86/cpufeature.h	2008-10-07 13:39:41.000000000 -0700
@@ -91,6 +91,7 @@
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
+#define X86_FEATURE_CLFLUSH_MONITOR (3*32+23) /* clflush needed with monitor */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */

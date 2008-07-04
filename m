Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYGDPTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYGDPTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 11:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYGDPSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 11:18:54 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:18739 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYGDPSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 11:18:53 -0400
X-BigFish: VPS2(z297cpz3117K655Ozz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3HMIW-02-8J5-01
Date: Fri, 4 Jul 2008 17:18:36 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Len Brown <lenb@kernel.org>
Subject: [PATCH] x86: emphasize that c1e aware idle stuff is AMD specific
Message-ID: <20080704151836.GB21102@alberich.amd.com>
References: <20080610171639.551369443@linutronix.de> <alpine.LFD.1.10.0806181834110.3074@localhost.localdomain> <20080704143536.GA21102@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080704143536.GA21102@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 Jul 2008 15:18:38.0571 (UTC) FILETIME=[3C1CFBB0:01C8DDE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to clarify that AMD C1E has nothing to do with Intel's C1E or
C2E.

Furthermore I changed some comment to clarify that currently just AMD
family 0x10 CPUs support MWAIT. AMD family 0x11 has quite similar
power management features like family 0x10 but it has no MONITOR/MWAIT
instructions.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
Patch is against current tip/master.
(git describe says: tip-history-2008-06-30_08.08_Mon-441-g7782052
whatever that means ;-)

Regards,
Andreas


 arch/x86/kernel/process.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index beef5e1..f6da61a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -189,12 +189,12 @@ static void poll_idle(void)
 /*
  * mwait selection logic:
  *
- * It depends on the CPU. For AMD CPUs that support MWAIT this is
- * wrong. Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings
- * then depend on a clock divisor and current Pstate of the core. If
- * all cores of a processor are in halt state (C1) the processor can
- * enter the C1E (C1 enhanced) state. If mwait is used this will never
- * happen.
+ * It depends on the CPU. For AMD CPUs that support MWAIT - currently
+ * AMD family 0x10 - this is wrong. Those CPUs will enter C1 on
+ * HLT. Powersavings then depend on a clock divisor and current Pstate
+ * of the core. If all cores of a processor are in halt state (C1) the
+ * processor can enter the AMD C1E (C1 enhanced) state. If mwait is
+ * used this will never happen.
  *
  * idle=mwait overrides this decision and forces the usage of mwait.
  */
@@ -219,16 +219,16 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 		return 1;
 
 	/*
-	 * edx enumeratios MONITOR/MWAIT extensions. Check, whether
-	 * C1  supports MWAIT
+	 * EDX enumerates MONITOR/MWAIT extensions. Check, whether an
+	 * C1 sub-state is supported using MONITOR/MWAIT.
 	 */
 	return (edx & MWAIT_EDX_C1);
 }
 
 /*
- * Check for AMD CPUs, which have potentially C1E support
+ * Check for AMD CPUs, which have potentially AMD's C1E support
  */
-static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
+static int __cpuinit check_amd_c1e_idle(const struct cpuinfo_x86 *c)
 {
 	if (c->x86_vendor != X86_VENDOR_AMD)
 		return 0;
@@ -236,7 +236,7 @@ static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
 	if (c->x86 < 0x0F)
 		return 0;
 
-	/* Family 0x0f models < rev F do not have C1E */
+	/* Family 0x0f models < rev F do not have AMD C1E */
 	if (c->x86 == 0x0f && c->x86_model < 0x40)
 		return 0;
 
@@ -244,11 +244,11 @@ static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
 }
 
 /*
- * C1E aware idle routine. We check for C1E active in the interrupt
+ * AMD C1E aware idle routine. We check for C1E active in the interrupt
  * pending message MSR. If we detect C1E, then we handle it the same
  * way as C3 power states (local apic timer and TSC stop)
  */
-static void c1e_idle(void)
+static void amd_c1e_idle(void)
 {
 	static cpumask_t c1e_mask = CPU_MASK_NONE;
 	static int c1e_detected;
@@ -262,8 +262,8 @@ static void c1e_idle(void)
 		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
 		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
 			c1e_detected = 1;
-			mark_tsc_unstable("TSC halt in C1E");
-			printk(KERN_INFO "System has C1E enabled\n");
+			mark_tsc_unstable("TSC halts in AMD C1E");
+			printk(KERN_INFO "System has AMD C1E enabled\n");
 		}
 	}
 
@@ -316,9 +316,9 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		 */
 		printk(KERN_INFO "using mwait in idle threads.\n");
 		pm_idle = mwait_idle;
-	} else if (check_c1e_idle(c)) {
-		printk(KERN_INFO "using C1E aware idle routine\n");
-		pm_idle = c1e_idle;
+	} else if (check_amd_c1e_idle(c)) {
+		printk(KERN_INFO "using AMD C1E aware idle routine\n");
+		pm_idle = amd_c1e_idle;
 	} else
 		pm_idle = default_idle;
 }
-- 
1.5.6.1




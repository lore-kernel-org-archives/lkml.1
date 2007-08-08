Return-Path: <linux-kernel-owner+w=401wt.eu-S935342AbXHHOgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935342AbXHHOgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbXHHOgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:36:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759941AbXHHOgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:36:36 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Cal Peake <cp@absolutedigital.net>
Subject: Re: [PATCH] drop unneeded variable in amd_apic_timer_broken
Date: Wed, 8 Aug 2007 16:36:20 +0200
User-Agent: KMail/1.9.6
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net> <20070808000631.GB7353@one.firstfloor.org> <Pine.LNX.4.64.0708072030440.28681@lancer.cnet.absolutedigital.net>
In-Reply-To: <Pine.LNX.4.64.0708072030440.28681@lancer.cnet.absolutedigital.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081636.20223.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007 02:53:21 Cal Peake wrote:
> On Wed, 8 Aug 2007, Andi Kleen wrote:
> 
> > Not sure why the MSR varies between cores though.
> 
> Yeah that boggled me too.
> 
> > It's better to just make it a global instead.
> 
> Haven't gotten to figuring out how to do *that* yet... but here's a 
> cleanup for the detection function:

Can you please test if this patch works?

BTW I checked with AMD and they seem to think it's just a buggy BIOS.

-Andi

Use global flag to disable broken local apic timer on AMD CPUs.

The Averatec 2370 laptop BIOS seems to program the ENABLE_C1E
MSR inconsistently between cores. This confuses the lapic
use heuristics wants to know if C1E is enabled anywhere.

Use a global flag instead of a per cpu flag to handle this.
If any CPU has C1E enabled disabled lapic use.

Thanks to Cal Peake for debugging.
Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/apic.c
===================================================================
--- linux.orig/arch/i386/kernel/apic.c
+++ linux/arch/i386/kernel/apic.c
@@ -61,8 +61,9 @@ static int enable_local_apic __initdata 
 
 /* Local APIC timer verification ok */
 static int local_apic_timer_verify_ok;
-/* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int local_apic_timer_disabled;
+/* Disable local APIC timer from the kernel commandline or via dmi quirk
+   or using CPU MSR check */
+int local_apic_timer_disabled;
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
@@ -370,9 +371,6 @@ void __init setup_boot_APIC_clock(void)
 	long delta, deltapm;
 	int pm_referenced = 0;
 
-	if (boot_cpu_has(X86_FEATURE_LAPIC_TIMER_BROKEN))
-		local_apic_timer_disabled = 1;
-
 	/*
 	 * The local apic timer can be disabled via the kernel
 	 * commandline or from the test above. Register the lapic
Index: linux/arch/i386/kernel/cpu/amd.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/amd.c
+++ linux/arch/i386/kernel/cpu/amd.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <asm/io.h>
 #include <asm/processor.h>
+#include <asm/apic.h>
 
 #include "cpu.h"
 
@@ -22,6 +23,7 @@
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
+#ifdef CONFIG_X86_LOCAL_APIC
 #define ENABLE_C1E_MASK         0x18000000
 #define CPUID_PROCESSOR_SIGNATURE       1
 #define CPUID_XFAM              0x0ff00000
@@ -52,6 +54,7 @@ static __cpuinit int amd_apic_timer_brok
         }
 	return 0;
 }
+#endif
 
 int force_mwait __cpuinitdata;
 
@@ -282,8 +285,10 @@ static void __cpuinit init_amd(struct cp
 			num_cache_leaves = 3;
 	}
 
+#ifdef CONFIG_X86_LOCAL_APIC
 	if (amd_apic_timer_broken())
-		set_bit(X86_FEATURE_LAPIC_TIMER_BROKEN, c->x86_capability);
+		local_apic_timer_disabled = 1;
+#endif
 
 	if (c->x86 == 0x10 && !force_mwait)
 		clear_bit(X86_FEATURE_MWAIT, c->x86_capability);
Index: linux/include/asm-i386/apic.h
===================================================================
--- linux.orig/include/asm-i386/apic.h
+++ linux/include/asm-i386/apic.h
@@ -116,6 +116,8 @@ extern void enable_NMI_through_LVT0 (voi
 extern int timer_over_8254;
 extern int local_apic_timer_c2_ok;
 
+extern int local_apic_timer_disabled;
+
 #else /* !CONFIG_X86_LOCAL_APIC */
 static inline void lapic_shutdown(void) { }
 
Index: linux/include/asm-i386/cpufeature.h
===================================================================
--- linux.orig/include/asm-i386/cpufeature.h
+++ linux/include/asm-i386/cpufeature.h
@@ -79,7 +79,7 @@
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
 #define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
-#define X86_FEATURE_LAPIC_TIMER_BROKEN (3*32+ 14) /* lapic timer broken in C1 */
+/* 14 free */
 #define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
 #define X86_FEATURE_REP_GOOD   (3*32+16) /* rep microcode works well on this CPU */
 

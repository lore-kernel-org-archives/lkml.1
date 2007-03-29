Return-Path: <linux-kernel-owner+w=401wt.eu-S1422658AbXC2WGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422658AbXC2WGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422672AbXC2WGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:06:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:55893 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422673AbXC2WGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:06:50 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
Date: Fri, 30 Mar 2007 00:05:39 +0200
User-Agent: KMail/1.9.5
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, Len Brown <lenb@kernel.org>,
       "Morrow, William" <William.Morrow@amd.com>,
       "Crouse, Jordan" <jordan.crouse@ldcmail.amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703292249.37979.ak@suse.de> <Pine.LNX.4.64.0703291410480.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703291410480.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703300005.41800.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 23:16, Linus Torvalds wrote:
> 
> On Thu, 29 Mar 2007, Andi Kleen wrote:
> > 
> > Here's a patch. I don't have a system with C1E, so i only tested that
> > the apic timer still works on a older AMD box.
> 
> I think this looks better than what we have now, but it would look even 
> better if the core CPUID stuff was in arch/i386/kernel/cpu/amd.c, and we 
> simply had X86_FEATURE_BROKEN_C1_LAPIC etc..
> 
> And then the apic.c code would just check
> 
> 	if (boot_cpu_has(X86_FEATURE_BROKEN_C1_LAPIC))
> 		return -1;
> 
> or similar.

Ok fair point. Here's an updated patch.

> 
> Doing the same for C2 and C3 gives us a clean way to have all these 
> per-vendor things in their relevant places, rather than having various 
> vendor-specific checks sprinkled in random places..
> 
> That's *especially* true for something like this that can hit both on 
> x86-64 and i386, where the cpuid logic is shared,

It's not shared.

> but the APIC logic is  
> *not* shared. If I read your patch correctly, this only fixes it on 32-bit 
> platforms, and I don't think the problem is in any way 32-bit specific, is 
> it?

It is because 64bit doesn't have dyntick yet and doesn't try to use the lapic
timer only by default. It has a "apicmaintimer" option, but that is never set
automatically. When dyntick is ported over it will be needed there too.

-Andi

Disable local APIC timer use on AMD systems with C1E

AMD dual core laptops with C1E do not run the APIC timer correctly
when they go idle. Previously the code assumed this only happened
on C2 or deeper.  But not all of these systems report support C2.

Use a AMD supplied snippet to detect C1E being enabled and then disable
local apic timer use.

This supercedes an earlier workaround using DMI detection of specific systems.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/apic.c
===================================================================
--- linux.orig/arch/i386/kernel/apic.c
+++ linux/arch/i386/kernel/apic.c
@@ -272,32 +272,6 @@ static void __devinit setup_APIC_timer(v
 }
 
 /*
- * Detect systems with known broken BIOS implementations
- */
-static int __init lapic_check_broken_bios(struct dmi_system_id *d)
-{
-	printk(KERN_NOTICE "%s detected: disabling lapic timer.\n",
-		       d->ident);
-	local_apic_timer_disabled = 1;
-	return 0;
-}
-
-static struct dmi_system_id __initdata broken_bios_dmi_table[] = {
-	{
-		/*
-		 * BIOS exports only C1 state, but uses deeper power
-		 * modes behind the kernels back.
-		 */
-		  .callback = lapic_check_broken_bios,
-		  .ident = "HP nx6325",
-		  .matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
-		  },
-	 },
-	 {}
-};
-
-/*
  * In this functions we calibrate APIC bus clocks to the external timer.
  *
  * We want to do the calibration only once since we want to have local timer
@@ -372,12 +346,12 @@ void __init setup_boot_APIC_clock(void)
 	long delta, deltapm;
 	int pm_referenced = 0;
 
-	/* Detect know broken systems */
-	dmi_check_system(broken_bios_dmi_table);
+	if (boot_cpu_has(X86_FEATURE_LAPIC_TIMER_BROKEN))
+		local_apic_timer_disabled = 1;
 
 	/*
 	 * The local apic timer can be disabled via the kernel
-	 * commandline or from the dmi quirk above. Register the lapic
+	 * commandline or from the test above. Register the lapic
 	 * timer as a dummy clock event source on SMP systems, so the
 	 * broadcast mechanism is used. On UP systems simply ignore it.
 	 */
Index: linux/include/asm-i386/msr.h
===================================================================
--- linux.orig/include/asm-i386/msr.h
+++ linux/include/asm-i386/msr.h
@@ -275,6 +275,8 @@ static inline void wrmsr_on_cpu(unsigned
 #define MSR_K7_FID_VID_CTL		0xC0010041
 #define MSR_K7_FID_VID_STATUS		0xC0010042
 
+#define MSR_K8_ENABLE_C1E		0xC0010055
+
 /* extended feature register */
 #define MSR_EFER 			0xc0000080
 
Index: linux/arch/i386/kernel/cpu/amd.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/amd.c
+++ linux/arch/i386/kernel/cpu/amd.c
@@ -22,6 +22,37 @@
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
+#define ENABLE_C1E_MASK         0x18000000
+#define CPUID_PROCESSOR_SIGNATURE       1
+#define CPUID_XFAM              0x0ff00000
+#define CPUID_XFAM_K8           0x00000000
+#define CPUID_XFAM_10H          0x00100000
+#define CPUID_XFAM_11H          0x00200000
+#define CPUID_XMOD              0x000f0000
+#define CPUID_XMOD_REV_F        0x00040000
+
+/* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
+static __cpuinit int amd_apic_timer_broken(void)
+{
+	u32 lo, hi;
+	u32 eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
+	switch (eax & CPUID_XFAM) {
+	case CPUID_XFAM_K8:
+		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
+			break;
+	case CPUID_XFAM_10H:
+	case CPUID_XFAM_11H:
+		rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
+		if (lo & ENABLE_C1E_MASK)
+			return 1;
+                break;
+        default:
+                /* err on the side of caution */
+		return 1;
+        }
+	return 0;
+}
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
@@ -241,6 +272,9 @@ static void __cpuinit init_amd(struct cp
 
 	if (cpuid_eax(0x80000000) >= 0x80000006)
 		num_cache_leaves = 3;
+
+	if (amd_apic_timer_broken())
+		set_bit(X86_FEATURE_LAPIC_TIMER_BROKEN, c->x86_capability);
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 * c, unsigned int size)
Index: linux/include/asm-i386/cpufeature.h
===================================================================
--- linux.orig/include/asm-i386/cpufeature.h
+++ linux/include/asm-i386/cpufeature.h
@@ -75,6 +75,7 @@
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
 #define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
+#define X86_FEATURE_LAPIC_TIMER_BROKEN (3*32+ 14) /* lapic timer broken in C1 */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */


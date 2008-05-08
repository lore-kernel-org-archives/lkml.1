Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYEHMuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYEHMuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 08:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYEHMu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 08:50:27 -0400
Received: from www.tglx.de ([62.245.132.106]:57828 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbYEHMuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 08:50:25 -0400
Date: Thu, 8 May 2008 14:49:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT
 support
In-Reply-To: <48226569.7010906@zytor.com>
Message-ID: <alpine.LFD.1.10.0805081307520.3318@apollo.tec.linutronix.de>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl>
 <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl>
 <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org> <4822614B.6080706@zytor.com> <alpine.LFD.1.10.0805071923030.3024@woody.linux-foundation.org> <48226569.7010906@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, H. Peter Anvin wrote:
> Linus Torvalds wrote:
> > 
> > > *Certainly* I don't want anything like this crap:
> > > 
> > > > -    if (cpu_has_pat)
> > > > +    if (cpu_has_pat && cpu_has_pat_good)
> > 
> > This in fact is likely the best part of it.
> > 
> > Because that at least guarantees that we never say we have a good PAT when
> > the hardware doesn't even report it.
> > 
> > As it is, we seem to just blindly override hardware. It may be correct for
> > all the models we override, but still..
> > 
> 
> Yah, this is not good.  We should mask out the bit, but never, ever, set it if
> it was clear to begin with (unless we have it on really, *really*, good
> authority.)
> 
> I'm embarrassed to have let that slink by.

/me too.

Fix below.

Thanks,
	tglx

---------->
Subject: x86: cleanup PAT cpu validation
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 08 May 2008 09:18:43 +0200

Move the scattered checks for PAT support to a single function. Its
moved to addon_cpuid_features.c as this file is shared between 32 and
64 bit.

Remove the manipulation of the PAT feature bit and just disable PAT in
the PAT layer, based on the PAT bit provided by the CPU and the
current CPU version/model white list.

Change the boot CPU check so it works on Voyager somewhere in the
future as well :) Also panic, when a secondary has PAT disabled but
the primary one has alrady switched to PAT. We have no way to undo
that.

The white list is kept for now to ensure that we can rely on known to
work CPU types and concentrate on the software induced problems
instead of fighthing CPU erratas and subtle wreckage caused by not yet
verified CPUs. Once the PAT code has stabilized enough, we can remove
the white list and open the can of worms.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |   21 ++++++++++++
 arch/x86/kernel/cpu/common.c               |   27 +--------------
 arch/x86/kernel/setup_64.c                 |    9 +----
 arch/x86/mm/pat.c                          |   50 ++++++++++++-----------------
 include/asm-x86/pat.h                      |    8 ++++
 5 files changed, 55 insertions(+), 60 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/addon_cpuid_features.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ linux-2.6/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -6,6 +6,7 @@
 
 #include <linux/cpu.h>
 
+#include <asm/pat.h>
 #include <asm/processor.h>
 
 struct cpuid_bit {
@@ -48,3 +49,23 @@ void __cpuinit init_scattered_cpuid_feat
 			set_cpu_cap(c, cb->feature);
 	}
 }
+
+#ifdef CONFIG_X86_PAT
+void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
+{
+	switch (c->x86_vendor) {
+	case X86_VENDOR_AMD:
+		if (c->x86 >= 0xf && c->x86 <= 0x11)
+			return;
+		break;
+	case X86_VENDOR_INTEL:
+		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
+			return;
+		break;
+	}
+
+	pat_disable(cpu_has_pat ?
+		    "PAT disabled. Not yet verified on this CPU type." :
+		    "PAT not supported by CPU.");
+}
+#endif
Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -12,6 +12,7 @@
 #include <asm/mmu_context.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/pat.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
@@ -308,19 +309,6 @@ static void __cpuinit early_get_cap(stru
 
 	}
 
-	clear_cpu_cap(c, X86_FEATURE_PAT);
-
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		if (c->x86 >= 0xf && c->x86 <= 0x11)
-			set_cpu_cap(c, X86_FEATURE_PAT);
-		break;
-	case X86_VENDOR_INTEL:
-		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
-			set_cpu_cap(c, X86_FEATURE_PAT);
-		break;
-	}
-
 }
 
 /*
@@ -409,18 +397,6 @@ static void __cpuinit generic_identify(s
 		init_scattered_cpuid_features(c);
 	}
 
-	clear_cpu_cap(c, X86_FEATURE_PAT);
-
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		if (c->x86 >= 0xf && c->x86 <= 0x11)
-			set_cpu_cap(c, X86_FEATURE_PAT);
-		break;
-	case X86_VENDOR_INTEL:
-		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
-			set_cpu_cap(c, X86_FEATURE_PAT);
-		break;
-	}
 }
 
 static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
@@ -651,6 +627,7 @@ void __init early_cpu_init(void)
 		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
 
 	early_cpu_detect();
+	validate_pat_support(&boot_cpu_data);
 }
 
 /* Make sure %fs is initialized properly in idle threads */
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -70,6 +70,7 @@
 #include <asm/ds.h>
 #include <asm/topology.h>
 #include <asm/trampoline.h>
+#include <asm/pat.h>
 
 #include <mach_apic.h>
 #ifdef CONFIG_PARAVIRT
@@ -1063,25 +1064,19 @@ static void __cpuinit early_identify_cpu
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
-
-	clear_cpu_cap(c, X86_FEATURE_PAT);
-
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		early_init_amd(c);
-		if (c->x86 >= 0xf && c->x86 <= 0x11)
-			set_cpu_cap(c, X86_FEATURE_PAT);
 		break;
 	case X86_VENDOR_INTEL:
 		early_init_intel(c);
-		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
-			set_cpu_cap(c, X86_FEATURE_PAT);
 		break;
 	case X86_VENDOR_CENTAUR:
 		early_init_centaur(c);
 		break;
 	}
 
+	validate_pat_support(c);
 }
 
 /*
Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c
+++ linux-2.6/arch/x86/mm/pat.c
@@ -25,31 +25,24 @@
 #include <asm/mtrr.h>
 #include <asm/io.h>
 
-int pat_wc_enabled = 1;
+#ifdef CONFIG_X86_PAT
+int __read_mostly pat_wc_enabled = 1;
 
-static u64 __read_mostly boot_pat_state;
-
-static int nopat(char *str)
+void __init pat_disable(char *reason)
 {
 	pat_wc_enabled = 0;
-	printk(KERN_INFO "x86: PAT support disabled.\n");
-
-	return 0;
+	printk(KERN_INFO "%s\n", reason);
 }
-early_param("nopat", nopat);
 
-static int pat_known_cpu(void)
+static int nopat(char *str)
 {
-	if (!pat_wc_enabled)
-		return 0;
-
-	if (cpu_has_pat)
-		return 1;
-
-	pat_wc_enabled = 0;
-	printk(KERN_INFO "CPU and/or kernel does not support PAT.\n");
+	pat_disable("PAT support disabled.");
 	return 0;
 }
+early_param("nopat", nopat);
+#endif
+
+static u64 __read_mostly boot_pat_state;
 
 enum {
 	PAT_UC = 0,		/* uncached */
@@ -66,17 +59,19 @@ void pat_init(void)
 {
 	u64 pat;
 
-#ifndef CONFIG_X86_PAT
-	nopat(NULL);
-#endif
-
-	/* Boot CPU enables PAT based on CPU feature */
-	if (!smp_processor_id() && !pat_known_cpu())
+	if (!pat_wc_enabled)
 		return;
 
-	/* APs enable PAT iff boot CPU has enabled it before */
-	if (smp_processor_id() && !pat_wc_enabled)
-		return;
+	/* Paranoia check. */
+	if (!cpu_has_pat) {
+		printk(KERN_ERR "PAT enabled, but CPU feature cleared\n");
+		/*
+		 * Panic if this happens on the secondary CPU, and we
+		 * switched to PAT on the boot CPU. We have no way to
+		 * undo PAT.
+		*/
+		BUG_ON(boot_pat_state);
+	}
 
 	/* Set PWT to Write-Combining. All other bits stay the same */
 	/*
@@ -95,9 +90,8 @@ void pat_init(void)
 	      PAT(4,WB) | PAT(5,WC) | PAT(6,UC_MINUS) | PAT(7,UC);
 
 	/* Boot CPU check */
-	if (!smp_processor_id()) {
+	if (!boot_pat_state)
 		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
-	}
 
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 	printk(KERN_INFO "x86 PAT enabled: cpu %d, old 0x%Lx, new 0x%Lx\n",
Index: linux-2.6/include/asm-x86/pat.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pat.h
+++ linux-2.6/include/asm-x86/pat.h
@@ -4,7 +4,13 @@
 
 #include <linux/types.h>
 
+#ifdef CONFIG_X86_PAT
 extern int pat_wc_enabled;
+extern void validate_pat_support(struct cpuinfo_x86 *c);
+#else
+# define pat_wc_enabled		(0)
+static inline void validate_pat_support(struct cpuinfo_x86 *c) { }
+#endif
 
 extern void pat_init(void);
 
@@ -12,5 +18,7 @@ extern int reserve_memtype(u64 start, u6
 		unsigned long req_type, unsigned long *ret_type);
 extern int free_memtype(u64 start, u64 end);
 
+extern void pat_disable(char *reason);
+
 #endif
 

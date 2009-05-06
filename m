Return-Path: <linux-kernel-owner+w=401wt.eu-S1759740AbZEFMvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740AbZEFMvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759554AbZEFMup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:50:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:55191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759506AbZEFMun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:50:43 -0400
Subject: Re: [RFC][git-pull -tip] x86: cpu_debug and cpufeature patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090506122530.GV25203@elte.hu>
References: <1240191359.3106.93.camel@ht.satnam>
	 <1240217428.3083.2.camel@ht.satnam> <20090420111619.GE6670@elte.hu>
	 <1240933437.3074.4.camel@ht.satnam> <20090428172828.GA15392@elte.hu>
	 <1240977176.3028.0.camel@ht.satnam> <20090429105021.GG2373@elte.hu>
	 <1241007294.3061.12.camel@ht.satnam> <20090503090908.GA23183@elte.hu>
	 <1241603841.3322.3.camel@localhost.localdomain>
	 <20090506122530.GV25203@elte.hu>
Content-Type: text/plain
Date: Wed, 06 May 2009 18:19:40 +0530
Message-Id: <1241614180.3609.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-06 at 14:25 +0200, Ingo Molnar wrote:
> >  
> > +/* Advanced Power Management (Function 8000_0007h), edx */
> > +#define X86_FEATURE_TS		(9*32+ 0) /* Temperatue sensor		*/
> > +#define X86_FEATURE_FID		(9*32+ 1) /* Frequency ID control	*/
> > +#define X86_FEATURE_VID		(9*32+ 2) /* Voltage ID control		*/
> > +#define X86_FEATURE_TTP		(9*32+ 3) /* Thermal trip		*/
> > +#define X86_FEATURE_HTC		(9*32+ 4) /* Hardware thermal control	*/
> > +#define X86_FEATURE_STC		(9*32+ 5) /* Software thermal control	*/
> > +#define X86_FEATURE_100MHZSTEPS	(9*32+ 6) /* 100 MHz multiplier control	*/
> > +#define X86_FEATURE_HWPSTATE	(9*32+ 7) /* Hardware P-State control	*/
> > +#define X86_FEATURE_CONSTANT_TSC (9*32+ 8) /* Constant rate TSC ticks	*/
> > +
> 
> Yes, this general approach looks pretty good! Note how it reduces 
> the line count in fact.
> 

Yes, thanks :-)

> I havent looked deeply yet, but noticed that above you changed 
> X86_FEATURE_CONSTANT_TSC - why was that done?
> 

X86_FEATURE_CONSTANT_TSC is used as TSC Invariant of Power Management
EDX[8]. Now I made complete Advanced Power Management group so I moved
it down here.

Here is the complete Advanced Power Management patch, it is a big patch,
if you want I can further divide it:

Subject: [PATCH] x86: Add cpufeatures for Advanced Power Management

1. Add Advanced Power Management (Function 8000_0007h), edx
2. unification of X86_FEATURE_CONSTANT_TSC (from intel.c, amd.c to common.c)
3. Remove cpu/powerflags.c
4. Remove x86_power
5. Move 'power management' to flags of /proc/cpuinfo

/proc/cpuinfo (before)
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni cx16
lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
..
power management: ts ttp tm stc 100mhzsteps hwpstate

/proc/cpuinfo (after)
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow rep_good tsc_reliable nonstop_tsc pni cx16
lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
ts ttp htc stc 100mhzsteps hwpstate constant_tsc

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |   15 ++++++++++++---
 arch/x86/include/asm/processor.h  |    1 -
 arch/x86/kernel/cpu/Makefile      |    2 +-
 arch/x86/kernel/cpu/amd.c         |    9 ---------
 arch/x86/kernel/cpu/common.c      |   15 ++++++++++++++-
 arch/x86/kernel/cpu/intel.c       |   14 --------------
 arch/x86/kernel/cpu/powerflags.c  |   20 --------------------
 arch/x86/kernel/cpu/proc.c        |   14 --------------
 8 files changed, 27 insertions(+), 63 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/powerflags.c

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 6fabb6c..db04825 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -6,7 +6,7 @@
 
 #include <asm/required-features.h>
 
-#define NCAPINTS	9	/* N 32-bit words worth of info */
+#define NCAPINTS	10	/* N 32-bit words worth of info */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -76,7 +76,6 @@
 #define X86_FEATURE_K7		(3*32+ 5) /* "" Athlon */
 #define X86_FEATURE_P3		(3*32+ 6) /* "" P3 */
 #define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
-#define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
 #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
 #define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
@@ -164,12 +163,22 @@
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
 
+/* Advanced Power Management (Function 8000_0007h), edx */
+#define X86_FEATURE_TS		(9*32+ 0) /* Temperatue sensor		*/
+#define X86_FEATURE_FID		(9*32+ 1) /* Frequency ID control	*/
+#define X86_FEATURE_VID		(9*32+ 2) /* Voltage ID control		*/
+#define X86_FEATURE_TTP		(9*32+ 3) /* Thermal trip		*/
+#define X86_FEATURE_HTC		(9*32+ 4) /* Hardware thermal control	*/
+#define X86_FEATURE_STC		(9*32+ 5) /* Software thermal control	*/
+#define X86_FEATURE_100MHZSTEPS	(9*32+ 6) /* 100 MHz multiplier control	*/
+#define X86_FEATURE_HWPSTATE	(9*32+ 7) /* Hardware P-State control	*/
+#define X86_FEATURE_CONSTANT_TSC (9*32+ 8) /* Constant rate TSC ticks	*/
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <linux/bitops.h>
 
 extern const char * const x86_cap_flags[NCAPINTS*32];
-extern const char * const x86_power_flags[32];
 
 #define test_cpu_cap(c, bit)						\
 	 test_bit(bit, (unsigned long *)((c)->x86_capability))
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0b2fab0..deabe4a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -90,7 +90,6 @@ struct cpuinfo_x86 {
 	/* in KB - valid for CPUS which support this call: */
 	int			x86_cache_size;
 	int			x86_cache_alignment;	/* In bytes */
-	int			x86_power;
 	unsigned long		loops_per_jiffy;
 #ifdef CONFIG_SMP
 	/* cpus sharing the last level cache: */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3efcb2b..b43fcbb 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -8,7 +8,7 @@ CFLAGS_REMOVE_common.o = -pg
 endif
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
-obj-y			+= proc.o capflags.o powerflags.o common.o
+obj-y			+= proc.o capflags.o common.o
 obj-y			+= vmware.o hypervisor.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7e4a459..2c1931f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -333,15 +333,6 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
 
-	/*
-	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states
-	 */
-	if (c->x86_power & (1 << 8)) {
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-	}
-
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
 #else
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 827e93d..9d71629 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -576,8 +576,21 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 #endif
 
 	if (c->extended_cpuid_level >= 0x80000007)
-		c->x86_power = cpuid_edx(0x80000007);
+		c->x86_capability[9] = cpuid_edx(0x80000007);
 
+	/*
+	 * Advanced power management is 8000_0007 edx.
+	 * Bit 8 is TSC runs at constant rate with P/T states
+	 * and does not stop in deep C-states.
+	 *
+	 * It is also reliable across cores and sockets. (but not across
+	 * cabinets - we turn it off in that case explicitly.)
+	 */
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
+		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
+		sched_clock_stable = 1;
+	}
 }
 
 static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5dac7bd..361e7e5 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -61,20 +61,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		c->x86_phys_bits = 36;
 
 	/*
-	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states.
-	 *
-	 * It is also reliable across cores and sockets. (but not across
-	 * cabinets - we turn it off in that case explicitly.)
-	 */
-	if (c->x86_power & (1 << 8)) {
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
-		sched_clock_stable = 1;
-	}
-
-	/*
 	 * There is a known erratum on Pentium III and Core Solo
 	 * and Core Duo CPUs.
 	 * " Page with PAT set to WC while associated MTRR is UC
diff --git a/arch/x86/kernel/cpu/powerflags.c b/arch/x86/kernel/cpu/powerflags.c
deleted file mode 100644
index 5abbea2..0000000
--- a/arch/x86/kernel/cpu/powerflags.c
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Strings for the various x86 power flags
- *
- * This file must not contain any executable code.
- */
-
-#include <asm/cpufeature.h>
-
-const char *const x86_power_flags[32] = {
-	"ts",	/* temperature sensor */
-	"fid",  /* frequency id control */
-	"vid",  /* voltage id control */
-	"ttp",  /* thermal trip */
-	"tm",
-	"stc",
-	"100mhzsteps",
-	"hwpstate",
-	"",	/* tsc invariant mapped to constant_tsc */
-		/* nothing */
-};
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index f93047f..523bf39 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -121,20 +121,6 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
 		   c->x86_phys_bits, c->x86_virt_bits);
 #endif
-
-	seq_printf(m, "power management:");
-	for (i = 0; i < 32; i++) {
-		if (c->x86_power & (1 << i)) {
-			if (i < ARRAY_SIZE(x86_power_flags) &&
-			    x86_power_flags[i])
-				seq_printf(m, "%s%s",
-					   x86_power_flags[i][0]?" ":"",
-					   x86_power_flags[i]);
-			else
-				seq_printf(m, " [%d]", i);
-		}
-	}
-
 	seq_printf(m, "\n\n");
 
 	return 0;
-- 
1.6.0.6




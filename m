Return-Path: <linux-kernel-owner+w=401wt.eu-S1760640AbYBKWnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640AbYBKWnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbYBKWm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:42:58 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:2502 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760006AbYBKWm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:42:56 -0500
From: Michael Opdenacker <michael-lists@free-electrons.com>
Organization: Free Electrons
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some processors
Date: Mon, 11 Feb 2008 23:42:23 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com
References: <200802082347.25364.michael-lists@free-electrons.com> <20080208231130.GA10511@elte.hu>
In-Reply-To: <20080208231130.GA10511@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802112342.23493.michael-lists@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008, Ingo Molnar wrote:
> ditto - hide this into cpu.h.

I did hide all the ifdefs into cpu.h as you suggested. See the new patch below.
> 
> >  static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
> >  {
> > +#ifdef CONFIG_CPU_SUP_AMD
> >  	if (force_mwait)
> >  		return 1;
> > +#endif
> 
> same - use cpu.h to define force_mwait to 0 if !CPU_SUP_AMD.

I didn't manage to, as force_mwait is also assigned in the same code.
I worked around the problem by declaring force_mwait elsewhere
(see my explanations in the patch comment)

---

[PATCH] x86 (Linux Tiny): configure out support for some processors

This patch against x86/mm tries to revive an original patch
from Matt Mackall which didn't get merged at that time. It makes
it possible to disable support code for some processors. This can
be useful to support only the exact processor type used
in a given system.

This patch allows to save up to 12K of text and data.

This time, I tried to use as few ifdefs as possible,
and move them away to include files.

Note that I had to modify include/asm-x86/bugs.h to declare
ppro_with_ram_bug() as an inline function. I hope there's
no harm.

Also note that for the sake of convenience and consistency
between 32 and 64 bit, I move the declaration of force_mwait
from kernel/cpu/amd.c to kernel/setup_32.c 
(force_mwait is already defined in kernel/setup_64.c).

Thanks for your reviews! Michael.

Signed-off-by: Michael Opdenacker <michael@free-electrons.com>
---
 arch/x86/Kconfig.cpu            |   56 +++++++++++++++++
 arch/x86/kernel/cpu/Makefile    |   28 +++++-----
 arch/x86/kernel/cpu/amd.c       |    6 +-
 arch/x86/kernel/cpu/centaur.c   |    2 +-
 arch/x86/kernel/cpu/cpu.h       |  124 +++++++++++++++++++++++++++++++++++----
 arch/x86/kernel/cpu/cyrix.c     |    4 +-
 arch/x86/kernel/cpu/intel.c     |    6 +-
 arch/x86/kernel/cpu/nexgen.c    |    2 +-
 arch/x86/kernel/cpu/transmeta.c |    2 +-
 arch/x86/kernel/cpu/umc.c       |    2 +-
 arch/x86/kernel/setup_32.c      |    2 +
 arch/x86/mm/init_32.c           |    2 +
 include/asm-x86/bugs.h          |    2 +-
 13 files changed, 199 insertions(+), 39 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index e09a6b7..4fcd0fb 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -396,3 +396,59 @@ config X86_MINIMUM_CPU_FAMILY
 config X86_DEBUGCTLMSR
 	def_bool y
 	depends on !(M586MMX || M586TSC || M586 || M486 || M386)
+
+menuconfig PROCESSOR_SELECT
+	depends on EMBEDDED && X86_32
+	bool "Supported processor vendors"
+	default n
+	help
+	  This lets you choose what x86 vendor support code your kernel
+	  will include.
+
+config CPU_SUP_INTEL
+	bool "Support Intel processors" if PROCESSOR_SELECT
+	default y
+	help
+	  This enables extended support for Intel processors
+
+config CPU_SUP_CYRIX
+	bool "Support Cyrix processors" if PROCESSOR_SELECT
+	default y
+	help
+	  This enables extended support for Cyrix processors
+
+config CPU_SUP_NSC
+	bool "Support NSC processors" if PROCESSOR_SELECT
+	default y
+	help
+	  This enables extended support for NSC processors
+
+config CPU_SUP_AMD
+	bool "Support AMD processors" if PROCESSOR_SELECT
+	default y
+	help
+	  This enables extended support for AMD processors
+
+config CPU_SUP_CENTAUR
+	bool "Support Centaur processors" if PROCESSOR_SELECT
+	default y
+	help
+	  This enables extended support for Centaur processors
+
+config CPU_SUP_TRANSMETA
+	bool "Support Transmeta processors" if PROCESSOR_SELECT
+	default y
+	help
+	  This enables extended support for Transmeta processors
+
+config CPU_SUP_NEXGEN
+	bool "Support NexGen processors" if PROCESSOR_SELECT
+	default y
+	help
+	  This enables extended support for NexGen processors
+
+config CPU_SUP_UMC
+	bool "Support UMC processors" if PROCESSOR_SELECT
+	default y
+	help
+	  This enables extended support for UMC processors
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0c4d7c..a01cb67 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -2,20 +2,20 @@
 # Makefile for x86-compatible CPU details and quirks
 #
 
-obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
-obj-y			+= feature_names.o
+obj-y				:= intel_cacheinfo.o addon_cpuid_features.o
+obj-y				+= feature_names.o
 
-obj-$(CONFIG_X86_32)	+= common.o proc.o bugs.o
-obj-$(CONFIG_X86_32)	+= amd.o
-obj-$(CONFIG_X86_32)	+= cyrix.o
-obj-$(CONFIG_X86_32)	+= centaur.o
-obj-$(CONFIG_X86_32)	+= transmeta.o
-obj-$(CONFIG_X86_32)	+= intel.o
-obj-$(CONFIG_X86_32)	+= nexgen.o
-obj-$(CONFIG_X86_32)	+= umc.o
+obj-$(CONFIG_X86_32)		+= common.o proc.o bugs.o
+obj-$(CONFIG_CPU_SUP_AMD)	+= amd.o
+obj-$(CONFIG_CPU_SUP_CYRIX)	+= cyrix.o
+obj-$(CONFIG_CPU_SUP_CENTAUR)	+= centaur.o
+obj-$(CONFIG_CPU_SUP_TRANSMETA)	+= transmeta.o
+obj-$(CONFIG_CPU_SUP_INTEL)	+= intel.o
+obj-$(CONFIG_CPU_SUP_NEXGEN)	+= nexgen.o
+obj-$(CONFIG_CPU_SUP_UMC)	+= umc.o
 
-obj-$(CONFIG_X86_MCE)	+= mcheck/
-obj-$(CONFIG_MTRR)	+= mtrr/
-obj-$(CONFIG_CPU_FREQ)	+= cpufreq/
+obj-$(CONFIG_X86_MCE)		+= mcheck/
+obj-$(CONFIG_MTRR)		+= mtrr/
+obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 
-obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= perfctr-watchdog.o
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 693e353..8baeae9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -61,9 +61,7 @@ static __cpuinit int amd_apic_timer_broken(void)
 }
 #endif
 
-int force_mwait __cpuinitdata;
-
-void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+void __cpuinit __early_init_amd(struct cpuinfo_x86 *c)
 {
 	if (cpuid_eax(0x80000000) >= 0x80000007) {
 		c->x86_power = cpuid_edx(0x80000007);
@@ -340,7 +338,7 @@ static struct cpu_dev amd_cpu_dev __cpuinitdata = {
 	.c_size_cache	= amd_size_cache,
 };
 
-int __init amd_init_cpu(void)
+int __init __amd_init_cpu(void)
 {
 	cpu_devs[X86_VENDOR_AMD] = &amd_cpu_dev;
 	return 0;
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 9681fa1..c20f44b 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -464,7 +464,7 @@ static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
 	.c_size_cache	= centaur_size_cache,
 };
 
-int __init centaur_init_cpu(void)
+int __init __centaur_init_cpu(void)
 {
 	cpu_devs[X86_VENDOR_CENTAUR] = &centaur_cpu_dev;
 	return 0;
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index e0b38c3..3e54edc 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -24,15 +24,117 @@ extern struct cpu_dev * cpu_devs [X86_VENDOR_NUM];
 extern int get_model_name(struct cpuinfo_x86 *c);
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
 
-extern void early_init_intel(struct cpuinfo_x86 *c);
-extern void early_init_amd(struct cpuinfo_x86 *c);
-
 /* Specific CPU type init functions */
-int intel_cpu_init(void);
-int amd_init_cpu(void);
-int cyrix_init_cpu(void);
-int nsc_init_cpu(void);
-int centaur_init_cpu(void);
-int transmeta_init_cpu(void);
-int nexgen_init_cpu(void);
-int umc_init_cpu(void);
+
+#ifdef CONFIG_CPU_SUP_INTEL
+int __cpuinit __ppro_with_ram_bug(void);
+static inline int __cpuinit ppro_with_ram_bug(void)
+{
+	return __ppro_with_ram_bug();
+}
+
+void __cpuinit __early_init_intel(struct cpuinfo_x86 *c);
+static inline void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
+{
+	__early_init_intel(c);
+}
+
+int __intel_cpu_init(void);
+static inline int intel_cpu_init(void)
+{
+	return __intel_cpu_init();
+}
+#else
+static inline int __cpuinit ppro_with_ram_bug(void)
+{
+	return 0;
+}
+
+static inline void __cpuinit early_init_intel(struct cpuinfo_x86 *c) {}
+
+static inline int intel_cpu_init(void)
+{
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_CPU_SUP_AMD
+int __amd_init_cpu(void);
+static inline int amd_init_cpu(void)
+{
+	return __amd_init_cpu();
+}
+
+void __cpuinit __early_init_amd(struct cpuinfo_x86 *c);
+static inline void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+{
+	__early_init_amd(c);
+}
+#else
+static inline int amd_init_cpu(void)
+{
+	return 0;
+}
+
+static inline void __cpuinit early_init_amd(struct cpuinfo_x86 *c) {}
+#endif
+
+int __cyrix_init_cpu(void);
+static inline int cyrix_init_cpu(void)
+{
+#ifdef CONFIG_CPU_SUP_CYRIX
+	return __cyrix_init_cpu();
+#else
+	return 0;
+#endif
+}
+
+int __nsc_init_cpu(void);
+static inline int nsc_init_cpu(void)
+{
+#ifdef CONFIG_CPU_SUP_NSC
+	return __nsc_init_cpu();
+#else
+	return 0;
+#endif
+}
+
+int __centaur_init_cpu(void);
+static inline int centaur_init_cpu(void)
+{
+#ifdef CONFIG_CPU_SUP_CENTAUR
+	return __centaur_init_cpu();
+#else
+	return 0;
+#endif
+}
+
+int __transmeta_init_cpu(void);
+static inline int transmeta_init_cpu(void)
+{
+#ifdef CONFIG_CPU_SUP_TRANSMETA
+	return __transmeta_init_cpu();
+#else
+	return 0;
+#endif
+}
+
+int __nexgen_init_cpu(void);
+static inline int nexgen_init_cpu(void)
+{
+#ifdef CONFIG_CPU_SUP_NEXGEN
+	return __nexgen_init_cpu();
+#else
+	return 0;
+#endif
+}
+
+int __umc_init_cpu(void);
+static inline int umc_init_cpu(void)
+{
+#ifdef CONFIG_CPU_SUP_UMC
+	return __umc_init_cpu();
+#else
+	return 0;
+#endif
+}
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 7139b02..038aa60 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -439,7 +439,7 @@ static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
 	.c_identify	= cyrix_identify,
 };
 
-int __init cyrix_init_cpu(void)
+int __init __cyrix_init_cpu(void)
 {
 	cpu_devs[X86_VENDOR_CYRIX] = &cyrix_cpu_dev;
 	return 0;
@@ -451,7 +451,7 @@ static struct cpu_dev nsc_cpu_dev __cpuinitdata = {
 	.c_init		= init_nsc,
 };
 
-int __init nsc_init_cpu(void)
+int __init __nsc_init_cpu(void)
 {
 	cpu_devs[X86_VENDOR_NSC] = &nsc_cpu_dev;
 	return 0;
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index fae31ce..7eaac8e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -30,7 +30,7 @@
 struct movsl_mask movsl_mask __read_mostly;
 #endif
 
-void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
+void __cpuinit __early_init_intel(struct cpuinfo_x86 *c)
 {
 	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
 	if (c->x86 == 15 && c->x86_cache_alignment == 64)
@@ -46,7 +46,7 @@ void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
  *	This is called before we do cpu ident work
  */
  
-int __cpuinit ppro_with_ram_bug(void)
+int __cpuinit __ppro_with_ram_bug(void)
 {
 	/* Uses data from early_cpu_detect now */
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
@@ -294,7 +294,7 @@ static struct cpu_dev intel_cpu_dev __cpuinitdata = {
 	.c_size_cache	= intel_size_cache,
 };
 
-__init int intel_cpu_init(void)
+__init int __intel_cpu_init(void)
 {
 	cpu_devs[X86_VENDOR_INTEL] = &intel_cpu_dev;
 	return 0;
diff --git a/arch/x86/kernel/cpu/nexgen.c b/arch/x86/kernel/cpu/nexgen.c
index 961fbe1..c607e80 100644
--- a/arch/x86/kernel/cpu/nexgen.c
+++ b/arch/x86/kernel/cpu/nexgen.c
@@ -53,7 +53,7 @@ static struct cpu_dev nexgen_cpu_dev __cpuinitdata = {
 	.c_identify	= nexgen_identify,
 };
 
-int __init nexgen_init_cpu(void)
+int __init __nexgen_init_cpu(void)
 {
 	cpu_devs[X86_VENDOR_NEXGEN] = &nexgen_cpu_dev;
 	return 0;
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 200fb3f..5538853 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -109,7 +109,7 @@ static struct cpu_dev transmeta_cpu_dev __cpuinitdata = {
 	.c_identify	= transmeta_identify,
 };
 
-int __init transmeta_init_cpu(void)
+int __init __transmeta_init_cpu(void)
 {
 	cpu_devs[X86_VENDOR_TRANSMETA] = &transmeta_cpu_dev;
 	return 0;
diff --git a/arch/x86/kernel/cpu/umc.c b/arch/x86/kernel/cpu/umc.c
index a7a4e75..c8ef9f6 100644
--- a/arch/x86/kernel/cpu/umc.c
+++ b/arch/x86/kernel/cpu/umc.c
@@ -19,7 +19,7 @@ static struct cpu_dev umc_cpu_dev __cpuinitdata = {
 	},
 };
 
-int __init umc_init_cpu(void)
+int __init __umc_init_cpu(void)
 {
 	cpu_devs[X86_VENDOR_UMC] = &umc_cpu_dev;
 	return 0;
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 691ab4c..395bfb4 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -65,6 +65,8 @@
 #include <bios_ebda.h>
 #include <asm/cacheflush.h>
 
+int force_mwait __cpuinitdata;
+
 /* This value is set up by the early boot code to point to the value
    immediately after the boot time page tables.  It contains a *physical*
    address, and must not be in the .bss segment! */
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 347a8cd..1179648 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -48,6 +48,8 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 
+#include "../kernel/cpu/cpu.h"
+
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
diff --git a/include/asm-x86/bugs.h b/include/asm-x86/bugs.h
index 021cbdd..a876041 100644
--- a/include/asm-x86/bugs.h
+++ b/include/asm-x86/bugs.h
@@ -2,6 +2,6 @@
 #define _ASM_X86_BUGS_H
 
 extern void check_bugs(void);
-int ppro_with_ram_bug(void);
+inline int ppro_with_ram_bug(void);
 
 #endif /* _ASM_X86_BUGS_H */
-- 
1.5.2.5

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

Return-Path: <linux-kernel-owner+w=401wt.eu-S932924AbZHUVbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbZHUVbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917AbZHUVbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:31:44 -0400
Received: from www.tglx.de ([62.245.132.106]:51502 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932857AbZHUVb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:26 -0400
Message-Id: <20090821205602.044178379@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:29:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 05/32] x86: Move memory_setup to platform
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-memory-setup-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memory_setup is overridden by x86_quirks and by paravirts with weak
functions and quirks. Unify the whole mess and make it an
unconditional platform setup function which defaults to the standard
function and can be overridden by the early platform code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/e820.h      |    2 --
 arch/x86/include/asm/paravirt.h  |    1 -
 arch/x86/include/asm/platform.h  |    2 ++
 arch/x86/include/asm/setup.h     |    1 -
 arch/x86/kernel/apic/numaq_32.c  |    1 -
 arch/x86/kernel/e820.c           |   19 +------------------
 arch/x86/kernel/paravirt.c       |    6 ------
 arch/x86/kernel/platform_setup.c |    2 ++
 arch/x86/kernel/visws_quirks.c   |    3 ++-
 arch/x86/lguest/boot.c           |    3 ++-
 arch/x86/xen/enlighten.c         |    3 ++-
 11 files changed, 11 insertions(+), 32 deletions(-)

Index: linux-2.6/arch/x86/include/asm/e820.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/e820.h
+++ linux-2.6/arch/x86/include/asm/e820.h
@@ -126,8 +126,6 @@ extern void e820_reserve_resources(void)
 extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
-extern char *machine_specific_memory_setup(void);
-extern char *memory_setup(void);
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 
Index: linux-2.6/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6/arch/x86/include/asm/paravirt.h
@@ -88,7 +88,6 @@ struct pv_init_ops {
 
 	/* Basic arch-specific setup */
 	void (*arch_setup)(void);
-	char *(*memory_setup)(void);
 	void (*post_allocator_init)(void);
 
 	/* Print a banner to identify the environment */
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -14,12 +14,14 @@ struct platform_setup_quirks {
  * @reserve_resources:		reserve the standard resources for the
  *				platform
  * @reserve_ebda_region:	reserve the extended bios data area
+ * @memory_setup:		platform specific memory setup
  *
  */
 struct platform_setup_resources {
 	void (*probe_roms)(void);
 	void (*reserve_resources)(void);
 	void (*reserve_ebda_region)(void);
+	char *(*memory_setup)(void);
 };
 
 /**
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -22,7 +22,6 @@ struct x86_quirks {
 	int (*arch_pre_intr_init)(void);
 	int (*arch_intr_init)(void);
 	int (*arch_trap_init)(void);
-	char * (*arch_memory_setup)(void);
 	int (*mach_get_smp_config)(unsigned int early);
 	int (*mach_find_smp_config)(unsigned int reserve);
 
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -260,7 +260,6 @@ static struct x86_quirks numaq_x86_quirk
 	.arch_pre_time_init		= numaq_pre_time_init,
 	.arch_time_init			= NULL,
 	.arch_pre_intr_init		= NULL,
-	.arch_memory_setup		= NULL,
 	.arch_intr_init			= NULL,
 	.arch_trap_init			= NULL,
 	.mach_get_smp_config		= NULL,
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1455,28 +1455,11 @@ char *__init default_machine_specific_me
 	return who;
 }
 
-char *__init __attribute__((weak)) machine_specific_memory_setup(void)
-{
-	if (x86_quirks->arch_memory_setup) {
-		char *who = x86_quirks->arch_memory_setup();
-
-		if (who)
-			return who;
-	}
-	return default_machine_specific_memory_setup();
-}
-
-/* Overridden in paravirt.c if CONFIG_PARAVIRT */
-char * __init __attribute__((weak)) memory_setup(void)
-{
-	return machine_specific_memory_setup();
-}
-
 void __init setup_memory_map(void)
 {
 	char *who;
 
-	who = memory_setup();
+	who = platform_setup.resources.memory_setup();
 	memcpy(&e820_saved, &e820, sizeof(struct e820map));
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
 	e820_print_map(who);
Index: linux-2.6/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt.c
+++ linux-2.6/arch/x86/kernel/paravirt.c
@@ -60,11 +60,6 @@ static void __init default_banner(void)
 	       pv_info.name);
 }
 
-char *memory_setup(void)
-{
-	return pv_init_ops.memory_setup();
-}
-
 /* Simple instruction patching code. */
 #define DEF_NATIVE(ops, name, code)					\
 	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
@@ -322,7 +317,6 @@ struct pv_init_ops pv_init_ops = {
 	.patch = native_patch,
 	.banner = default_banner,
 	.arch_setup = paravirt_nop,
-	.memory_setup = machine_specific_memory_setup,
 };
 
 struct pv_time_ops pv_time_ops = {
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -7,6 +7,7 @@
 
 #include <asm/bios_ebda.h>
 #include <asm/setup.h>
+#include <asm/e820.h>
 
 void __cpuinit platform_setup_noop(void) { }
 
@@ -20,5 +21,6 @@ struct __initdata platform_setup_ops pla
 		.probe_roms = platform_setup_noop,
 		.reserve_resources = reserve_standard_io_resources,
 		.reserve_ebda_region = reserve_ebda_region,
+		.memory_setup = default_machine_specific_memory_setup,
 	},
 };
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -239,7 +239,6 @@ static int visws_trap_init(void);
 static struct x86_quirks visws_x86_quirks __initdata = {
 	.arch_time_init		= visws_time_init,
 	.arch_pre_intr_init	= visws_pre_intr_init,
-	.arch_memory_setup	= visws_memory_setup,
 	.arch_intr_init		= NULL,
 	.arch_trap_init		= visws_trap_init,
 	.mach_get_smp_config	= visws_get_smp_config,
@@ -263,6 +262,8 @@ void __init visws_early_detect(void)
 	 */
 	x86_quirks = &visws_x86_quirks;
 
+	platform_setup.resources.memory_setup = visws_memory_setup;
+
 	/*
 	 * Install reboot quirks:
 	 */
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -1270,7 +1270,6 @@ __init void lguest_init(void)
 	pv_irq_ops.safe_halt = lguest_safe_halt;
 
 	/* Setup operations */
-	pv_init_ops.memory_setup = lguest_memory_setup;
 	pv_init_ops.patch = lguest_patch;
 
 	/* Intercepts of various CPU instructions */
@@ -1325,6 +1324,8 @@ __init void lguest_init(void)
 	pv_time_ops.time_init = lguest_time_init;
 	pv_time_ops.get_tsc_khz = lguest_tsc_khz;
 
+	platform_setup.resources.memory_setup = lguest_memory_setup;
+
 	/*
 	 * Now is a good time to look at the implementations of these functions
 	 * before returning to the rest of lguest_init().
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c
+++ linux-2.6/arch/x86/xen/enlighten.c
@@ -841,7 +841,6 @@ static const struct pv_init_ops xen_init
 	.patch = xen_patch,
 
 	.banner = xen_banner,
-	.memory_setup = xen_memory_setup,
 	.arch_setup = xen_arch_setup,
 	.post_allocator_init = xen_post_allocator_init,
 };
@@ -986,6 +985,8 @@ asmlinkage void __init xen_start_kernel(
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
 
+	platform_setup.resources.memory_setup = xen_memory_setup;
+
 	xen_init_irq_ops();
 
 	xen_init_cpuid_mask();



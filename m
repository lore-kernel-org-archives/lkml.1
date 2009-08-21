Return-Path: <linux-kernel-owner+w=401wt.eu-S932977AbZHUVcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977AbZHUVcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbZHUVca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:32:30 -0400
Received: from www.tglx.de ([62.245.132.106]:51762 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934AbZHUVc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:32:27 -0400
Message-Id: <20090821205602.627177085@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 17/32] x86: Move paravirt banner printout to platform
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-banner-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace another obscure paravirt magic and move it to platform
setup. Such a hook is also useful for embedded and special hardware.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/paravirt.h  |    6 +++++-
 arch/x86/include/asm/platform.h  |    2 ++
 arch/x86/kernel/paravirt.c       |   10 +---------
 arch/x86/kernel/platform_setup.c |    1 +
 arch/x86/kernel/setup.c          |    1 +
 arch/x86/xen/enlighten.c         |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6/arch/x86/include/asm/paravirt.h
@@ -1623,6 +1623,8 @@ static inline unsigned long __raw_local_
 #undef PVOP_VCALL4
 #undef PVOP_CALL4
 
+extern void default_banner(void);
+
 #else  /* __ASSEMBLY__ */
 
 #define _PVSITE(ptype, clobbers, ops, word, algn)	\
@@ -1763,5 +1765,7 @@ static inline unsigned long __raw_local_
 #endif	/* CONFIG_X86_32 */
 
 #endif /* __ASSEMBLY__ */
-#endif /* CONFIG_PARAVIRT */
+#else  /* CONFIG_PARAVIRT */
+# define default_banner platform_setup_noop
+#endif /* !CONFIG_PARAVIRT */
 #endif /* _ASM_X86_PARAVIRT_H */
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -65,9 +65,11 @@ struct platform_setup_irqs {
 /**
  * struct platform_setup_oem - oem platform specific customizing functions
  * @arch_setup:			platform specific architecure setup
+ * @banner:			print a platform specific banner
  */
 struct platform_setup_oem {
 	void (*arch_setup)(void);
+	void (*banner)(void);
 };
 
 /**
Index: linux-2.6/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt.c
+++ linux-2.6/arch/x86/kernel/paravirt.c
@@ -54,7 +54,7 @@ u64 _paravirt_ident_64(u64 x)
 	return x;
 }
 
-static void __init default_banner(void)
+void __init default_banner(void)
 {
 	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
 	       pv_info.name);
@@ -208,13 +208,6 @@ extern void native_irq_enable_sysexit(vo
 extern void native_usergs_sysret32(void);
 extern void native_usergs_sysret64(void);
 
-static int __init print_banner(void)
-{
-	pv_init_ops.banner();
-	return 0;
-}
-core_initcall(print_banner);
-
 static struct resource reserve_ioports = {
 	.start = 0,
 	.end = IO_SPACE_LIMIT,
@@ -310,7 +303,6 @@ struct pv_info pv_info = {
 
 struct pv_init_ops pv_init_ops = {
 	.patch = native_patch,
-	.banner = default_banner,
 };
 
 struct pv_time_ops pv_time_ops = {
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -44,6 +44,7 @@ struct __initdata platform_setup_ops pla
 
 	.oem = {
 		.arch_setup = platform_setup_noop,
+		.banner = default_banner,
 	},
 
 	.quirks = {
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -1012,6 +1012,7 @@ void __init setup_arch(char **cmdline_p)
 	conswitchp = &dummy_con;
 #endif
 #endif
+	platform_setup.oem.banner();
 }
 
 #ifdef CONFIG_X86_32
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c
+++ linux-2.6/arch/x86/xen/enlighten.c
@@ -840,7 +840,6 @@ static const struct pv_info xen_info __i
 static const struct pv_init_ops xen_init_ops __initdata = {
 	.patch = xen_patch,
 
-	.banner = xen_banner,
 	.post_allocator_init = xen_post_allocator_init,
 };
 
@@ -986,6 +985,7 @@ asmlinkage void __init xen_start_kernel(
 
 	platform_setup.resources.memory_setup = xen_memory_setup;
 	platform_setup.oem.arch_setup = xen_arch_setup;
+	platform_setup.oem.banner = xen_banner;
 
 	xen_init_irq_ops();
 



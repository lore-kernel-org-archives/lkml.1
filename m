Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbZHUVgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbZHUVgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932906AbZHUVgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:36:47 -0400
Received: from www.tglx.de ([62.245.132.106]:51710 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932892AbZHUVcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:32:15 -0400
Message-Id: <20090821205602.546167777@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 15/32] x86: Move traps_init to platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-traps-init-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the quirks by a simple platform_setup function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/platform.h  |    2 ++
 arch/x86/include/asm/setup.h     |    3 ---
 arch/x86/kernel/apic/numaq_32.c  |    1 -
 arch/x86/kernel/platform_setup.c |    1 +
 arch/x86/kernel/setup.c          |   15 ---------------
 arch/x86/kernel/traps.c          |    5 ++---
 arch/x86/kernel/visws_quirks.c   |    8 +++-----
 7 files changed, 8 insertions(+), 27 deletions(-)

Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -54,10 +54,12 @@ struct platform_setup_resources {
  * @pre_vector_init:		init code to run before interrupt vectors
  *				are set up.
  * @intr_init:			interrupt init code
+ * @trap_init:			platform specific trap setup
  */
 struct platform_setup_irqs {
 	void (*pre_vector_init)(void);
 	void (*intr_init)(void);
+	void (*trap_init)(void);
 };
 
 /**
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -16,11 +16,8 @@
 struct x86_quirks {
 	int (*arch_pre_time_init)(void);
 	int (*arch_time_init)(void);
-	int (*arch_trap_init)(void);
 };
 
-extern void x86_quirk_trap_init(void);
-
 extern void x86_quirk_pre_time_init(void);
 extern void x86_quirk_time_init(void);
 
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -265,7 +265,6 @@ static void __init smp_read_mpc_oem(stru
 static struct x86_quirks numaq_x86_quirks __initdata = {
 	.arch_pre_time_init		= numaq_pre_time_init,
 	.arch_time_init			= NULL,
-	.arch_trap_init			= NULL,
 };
 
 static __init void early_check_numaq(void)
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -39,6 +39,7 @@ struct __initdata platform_setup_ops pla
 	.irqs = {
 		.pre_vector_init = init_ISA_irqs,
 		.intr_init = native_init_IRQ,
+		.trap_init = platform_setup_noop,
 	},
 
 	.quirks = {
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -1020,21 +1020,6 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_X86_32
 
-/**
- * x86_quirk_trap_init - initialise system specific traps
- *
- * Description:
- *	Called as the final act of trap_init().  Used in VISWS to initialise
- *	the various board specific APIC traps.
- **/
-void __init x86_quirk_trap_init(void)
-{
-	if (x86_quirks->arch_trap_init) {
-		if (x86_quirks->arch_trap_init())
-			return;
-	}
-}
-
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
Index: linux-2.6/arch/x86/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps.c
+++ linux-2.6/arch/x86/kernel/traps.c
@@ -59,6 +59,7 @@
 #include <asm/mach_traps.h>
 
 #ifdef CONFIG_X86_64
+#include <asm/platform.h>
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #else
@@ -980,7 +981,5 @@ void __init trap_init(void)
 	 */
 	cpu_init();
 
-#ifdef CONFIG_X86_32
-	x86_quirk_trap_init();
-#endif
+	platform_setup.irqs.trap_init();
 }
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -224,11 +224,10 @@ static void __init visws_find_smp_config
 	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
 }
 
-static int visws_trap_init(void);
+static void visws_trap_init(void);
 
 static struct x86_quirks visws_x86_quirks __initdata = {
 	.arch_time_init		= visws_time_init,
-	.arch_trap_init		= visws_trap_init,
 };
 
 void __init visws_early_detect(void)
@@ -252,6 +251,7 @@ void __init visws_early_detect(void)
 	platform_setup.mpparse.get_smp_config = visws_get_smp_config;
 	platform_setup.mpparse.find_smp_config = visws_find_smp_config;
 	platform_setup.irqs.pre_vector_init = visws_pre_intr_init;
+	platform_setup.irqs.trap_init = visws_trap_init;
 
 	/*
 	 * Install reboot quirks:
@@ -390,12 +390,10 @@ static __init void cobalt_init(void)
 		co_apic_read(CO_APIC_ID));
 }
 
-static int __init visws_trap_init(void)
+static void __init visws_trap_init(void)
 {
 	lithium_init();
 	cobalt_init();
-
-	return 1;
 }
 
 /*



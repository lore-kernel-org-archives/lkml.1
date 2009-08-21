Return-Path: <linux-kernel-owner+w=401wt.eu-S932963AbZHUVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbZHUVcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932824AbZHUVcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:32:17 -0400
Received: from www.tglx.de ([62.245.132.106]:51638 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947AbZHUVb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:58 -0400
Message-Id: <20090821205602.460995680@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 13/32] x86: Move pre_intr_init to platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-pre-intr-init-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the quirk machinery by a platform setup function which
defaults to the standard implementation. This is also a preparatory
patch for Moorestown support which needs to replace the default
init_ISA_irqs as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/irq.h       |    2 ++
 arch/x86/include/asm/platform.h  |   10 ++++++++++
 arch/x86/include/asm/setup.h     |    1 -
 arch/x86/kernel/apic/numaq_32.c  |    1 -
 arch/x86/kernel/irqinit.c        |   24 ++----------------------
 arch/x86/kernel/platform_setup.c |    5 +++++
 arch/x86/kernel/visws_quirks.c   |   10 +++-------
 7 files changed, 22 insertions(+), 31 deletions(-)

Index: linux-2.6/arch/x86/include/asm/irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq.h
+++ linux-2.6/arch/x86/include/asm/irq.h
@@ -47,4 +47,6 @@ extern unsigned int do_IRQ(struct pt_reg
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
 extern int vector_used_by_percpu_irq(unsigned int vector);
 
+extern void init_ISA_irqs(void);
+
 #endif /* _ASM_X86_IRQ_H */
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -50,12 +50,22 @@ struct platform_setup_resources {
 };
 
 /**
+ * struct platform_setup_irqs - platform specific interrupt setup
+ * @pre_vector_init:		init code to run before interrupt vectors
+ *				are set up.
+ */
+struct platform_setup_irqs {
+	void (*pre_vector_init)(void);
+};
+
+/**
  * struct platform_setup_ops - functions for platform specific setup
  *
  */
 struct platform_setup_ops {
 	struct platform_setup_resources resources;
 	struct platform_setup_mpparse mpparse;
+	struct platform_setup_irqs irqs;
 	struct platform_setup_quirks quirks;
 };
 
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -16,7 +16,6 @@
 struct x86_quirks {
 	int (*arch_pre_time_init)(void);
 	int (*arch_time_init)(void);
-	int (*arch_pre_intr_init)(void);
 	int (*arch_intr_init)(void);
 	int (*arch_trap_init)(void);
 };
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -265,7 +265,6 @@ static void __init smp_read_mpc_oem(stru
 static struct x86_quirks numaq_x86_quirks __initdata = {
 	.arch_pre_time_init		= numaq_pre_time_init,
 	.arch_time_init			= NULL,
-	.arch_pre_intr_init		= NULL,
 	.arch_intr_init			= NULL,
 	.arch_trap_init			= NULL,
 };
Index: linux-2.6/arch/x86/kernel/irqinit.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit.c
+++ linux-2.6/arch/x86/kernel/irqinit.c
@@ -116,7 +116,7 @@ int vector_used_by_percpu_irq(unsigned i
 	return 0;
 }
 
-static void __init init_ISA_irqs(void)
+void __init init_ISA_irqs(void)
 {
 	int i;
 
@@ -213,32 +213,12 @@ static void __init apic_intr_init(void)
 #endif
 }
 
-/**
- * x86_quirk_pre_intr_init - initialisation prior to setting up interrupt vectors
- *
- * Description:
- *	Perform any necessary interrupt initialisation prior to setting up
- *	the "ordinary" interrupt call gates.  For legacy reasons, the ISA
- *	interrupts should be initialised here if the machine emulates a PC
- *	in any way.
- **/
-static void __init x86_quirk_pre_intr_init(void)
-{
-#ifdef CONFIG_X86_32
-	if (x86_quirks->arch_pre_intr_init) {
-		if (x86_quirks->arch_pre_intr_init())
-			return;
-	}
-#endif
-	init_ISA_irqs();
-}
-
 void __init native_init_IRQ(void)
 {
 	int i;
 
 	/* Execute any quirks before the call gates are initialised: */
-	x86_quirk_pre_intr_init();
+	platform_setup.irqs.pre_vector_init();
 
 	apic_intr_init();
 
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -9,6 +9,7 @@
 #include <asm/mpspec.h>
 #include <asm/setup.h>
 #include <asm/e820.h>
+#include <asm/irq.h>
 
 void __cpuinit platform_setup_noop(void) { }
 void __init platform_setup_uint_noop(unsigned int unused) { }
@@ -35,6 +36,10 @@ struct __initdata platform_setup_ops pla
 		.get_smp_config = default_get_smp_config,
 	},
 
+	.irqs = {
+		.pre_vector_init = init_ISA_irqs,
+	},
+
 	.quirks = {
 		.mpc_record = platform_setup_uint_noop,
 	},
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -73,14 +73,10 @@ static int __init visws_time_init(void)
 	return 0;
 }
 
-static int __init visws_pre_intr_init(void)
+/* Replaces the default init_ISA_irqs in the generic setup */
+static void __init visws_pre_intr_init(void)
 {
 	init_VISWS_APIC_irqs();
-
-	/*
-	 * We dont want ISA irqs to be set up by the generic code:
-	 */
-	return 1;
 }
 
 /* Quirk for machine specific memory setup. */
@@ -232,7 +228,6 @@ static int visws_trap_init(void);
 
 static struct x86_quirks visws_x86_quirks __initdata = {
 	.arch_time_init		= visws_time_init,
-	.arch_pre_intr_init	= visws_pre_intr_init,
 	.arch_intr_init		= NULL,
 	.arch_trap_init		= visws_trap_init,
 };
@@ -257,6 +252,7 @@ void __init visws_early_detect(void)
 	platform_setup.resources.memory_setup = visws_memory_setup;
 	platform_setup.mpparse.get_smp_config = visws_get_smp_config;
 	platform_setup.mpparse.find_smp_config = visws_find_smp_config;
+	platform_setup.irqs.pre_vector_init = visws_pre_intr_init;
 
 	/*
 	 * Install reboot quirks:



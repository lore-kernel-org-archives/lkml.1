Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbZHUVgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbZHUVgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932906AbZHUVcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:32:15 -0400
Received: from www.tglx.de ([62.245.132.106]:51703 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932878AbZHUVcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:32:13 -0400
Message-Id: <20090821205602.506969013@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 14/32] x86: Move irq_init to platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-irq-init-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_init is overridden by x86_quirks and by paravirts. Unify the whole
mess and make it an unconditional platform setup function which
defaults to the standard function and can be overridden by the early
platform code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/irq.h       |    1 -
 arch/x86/include/asm/paravirt.h  |    2 --
 arch/x86/include/asm/platform.h  |    2 ++
 arch/x86/include/asm/setup.h     |    3 ---
 arch/x86/kernel/apic/numaq_32.c  |    1 -
 arch/x86/kernel/irqinit.c        |   12 ++++--------
 arch/x86/kernel/paravirt.c       |    6 ------
 arch/x86/kernel/platform_setup.c |    1 +
 arch/x86/kernel/setup.c          |   17 -----------------
 arch/x86/kernel/visws_quirks.c   |    1 -
 arch/x86/lguest/boot.c           |    2 +-
 arch/x86/xen/irq.c               |    5 +++--
 12 files changed, 11 insertions(+), 42 deletions(-)

Index: linux-2.6/arch/x86/include/asm/irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq.h
+++ linux-2.6/arch/x86/include/asm/irq.h
@@ -37,7 +37,6 @@ extern void fixup_irqs(void);
 #endif
 
 extern void (*generic_interrupt_extension)(void);
-extern void init_IRQ(void);
 extern void native_init_IRQ(void);
 extern bool handle_irq(unsigned irq, struct pt_regs *regs);
 
Index: linux-2.6/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6/arch/x86/include/asm/paravirt.h
@@ -208,8 +208,6 @@ struct pv_cpu_ops {
 };
 
 struct pv_irq_ops {
-	void (*init_IRQ)(void);
-
 	/*
 	 * Get/set interrupt state.  save_fl and restore_fl are only
 	 * expected to use X86_EFLAGS_IF; all other bits
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -53,9 +53,11 @@ struct platform_setup_resources {
  * struct platform_setup_irqs - platform specific interrupt setup
  * @pre_vector_init:		init code to run before interrupt vectors
  *				are set up.
+ * @intr_init:			interrupt init code
  */
 struct platform_setup_irqs {
 	void (*pre_vector_init)(void);
+	void (*intr_init)(void);
 };
 
 /**
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -16,12 +16,9 @@
 struct x86_quirks {
 	int (*arch_pre_time_init)(void);
 	int (*arch_time_init)(void);
-	int (*arch_intr_init)(void);
 	int (*arch_trap_init)(void);
 };
 
-extern void x86_quirk_intr_init(void);
-
 extern void x86_quirk_trap_init(void);
 
 extern void x86_quirk_pre_time_init(void);
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -265,7 +265,6 @@ static void __init smp_read_mpc_oem(stru
 static struct x86_quirks numaq_x86_quirks __initdata = {
 	.arch_pre_time_init		= numaq_pre_time_init,
 	.arch_time_init			= NULL,
-	.arch_intr_init			= NULL,
 	.arch_trap_init			= NULL,
 };
 
Index: linux-2.6/arch/x86/kernel/irqinit.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit.c
+++ linux-2.6/arch/x86/kernel/irqinit.c
@@ -140,8 +140,10 @@ void __init init_ISA_irqs(void)
 	}
 }
 
-/* Overridden in paravirt.c */
-void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
+void init_IRQ(void)
+{
+	platform_setup.irqs.intr_init();
+}
 
 static void __init smp_intr_init(void)
 {
@@ -238,12 +240,6 @@ void __init native_init_IRQ(void)
 
 #ifdef CONFIG_X86_32
 	/*
-	 * Call quirks after call gates are initialised (usually add in
-	 * the architecture specific gates):
-	 */
-	x86_quirk_intr_init();
-
-	/*
 	 * External FPU? Set up irq13 if so, for
 	 * original braindamaged IBM FERR coupling.
 	 */
Index: linux-2.6/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt.c
+++ linux-2.6/arch/x86/kernel/paravirt.c
@@ -183,11 +183,6 @@ unsigned paravirt_patch_insns(void *insn
 	return insn_len;
 }
 
-void init_IRQ(void)
-{
-	pv_irq_ops.init_IRQ();
-}
-
 static void native_flush_tlb(void)
 {
 	__native_flush_tlb();
@@ -328,7 +323,6 @@ struct pv_time_ops pv_time_ops = {
 };
 
 struct pv_irq_ops pv_irq_ops = {
-	.init_IRQ = native_init_IRQ,
 	.save_fl = __PV_IS_CALLEE_SAVE(native_save_fl),
 	.restore_fl = __PV_IS_CALLEE_SAVE(native_restore_fl),
 	.irq_disable = __PV_IS_CALLEE_SAVE(native_irq_disable),
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -38,6 +38,7 @@ struct __initdata platform_setup_ops pla
 
 	.irqs = {
 		.pre_vector_init = init_ISA_irqs,
+		.intr_init = native_init_IRQ,
 	},
 
 	.quirks = {
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -1021,23 +1021,6 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_32
 
 /**
- * x86_quirk_intr_init - post gate setup interrupt initialisation
- *
- * Description:
- *	Fill in any interrupts that may have been left out by the general
- *	init_IRQ() routine.  interrupts having to do with the machine rather
- *	than the devices on the I/O bus (like APIC interrupts in intel MP
- *	systems) are started here.
- **/
-void __init x86_quirk_intr_init(void)
-{
-	if (x86_quirks->arch_intr_init) {
-		if (x86_quirks->arch_intr_init())
-			return;
-	}
-}
-
-/**
  * x86_quirk_trap_init - initialise system specific traps
  *
  * Description:
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -228,7 +228,6 @@ static int visws_trap_init(void);
 
 static struct x86_quirks visws_x86_quirks __initdata = {
 	.arch_time_init		= visws_time_init,
-	.arch_intr_init		= NULL,
 	.arch_trap_init		= visws_trap_init,
 };
 
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -1262,7 +1262,6 @@ __init void lguest_init(void)
 	 */
 
 	/* Interrupt-related operations */
-	pv_irq_ops.init_IRQ = lguest_init_IRQ;
 	pv_irq_ops.save_fl = PV_CALLEE_SAVE(save_fl);
 	pv_irq_ops.restore_fl = __PV_IS_CALLEE_SAVE(lg_restore_fl);
 	pv_irq_ops.irq_disable = PV_CALLEE_SAVE(irq_disable);
@@ -1325,6 +1324,7 @@ __init void lguest_init(void)
 	pv_time_ops.get_tsc_khz = lguest_tsc_khz;
 
 	platform_setup.resources.memory_setup = lguest_memory_setup;
+	platform_setup.irqs.intr_init = lguest_init_IRQ;
 
 	/*
 	 * Now is a good time to look at the implementations of these functions
Index: linux-2.6/arch/x86/xen/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/irq.c
+++ linux-2.6/arch/x86/xen/irq.c
@@ -1,5 +1,7 @@
 #include <linux/hardirq.h>
 
+#include <asm/platform.h>
+
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/vcpu.h>
@@ -112,8 +114,6 @@ static void xen_halt(void)
 }
 
 static const struct pv_irq_ops xen_irq_ops __initdata = {
-	.init_IRQ = xen_init_IRQ,
-
 	.save_fl = PV_CALLEE_SAVE(xen_save_fl),
 	.restore_fl = PV_CALLEE_SAVE(xen_restore_fl),
 	.irq_disable = PV_CALLEE_SAVE(xen_irq_disable),
@@ -129,4 +129,5 @@ static const struct pv_irq_ops xen_irq_o
 void __init xen_init_irq_ops()
 {
 	pv_irq_ops = xen_irq_ops;
+	platform_setup.irqs.intr_init = xen_init_IRQ;
 }



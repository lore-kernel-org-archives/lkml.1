Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbYHKOeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbYHKOeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYHKOeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:34:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:64105 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYHKOeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=SA+rEP0d5mkAx2Rc6s6Qfrnwn7h7Tmoi93QiNLfTKZM4WL3gt/Dyol4GMmujnY+SHp
         pqF1dw5hejUU1UG/G44Lf0h9QvQil0eaxdL8eMPZEk1N+nCPU57oprc/ZQmvIZcw3HD2
         KB2vhTAyVSStNIR3Y0oSTpkthCyErGRfF0e08=
Date: Mon, 11 Aug 2008 18:34:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: apic interrupts - move assignments to
	irqinit_32.c
Message-ID: <20080811143408.GB7196@lenovo>
References: <20080808195006.GA7014@lenovo> <20080811125729.GB2842@elte.hu> <20080811130647.GA23289@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080811130647.GA23289@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Aug 11, 2008 at 03:06:47PM +0200]
| 
| * Ingo Molnar <mingo@elte.hu> wrote:
| 
| > * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > 
| > > 64bit mode APIC interrupt handlers are set within irqinit_64.c.
| > > Lets do tha same for 32bit mode which would help in furter code merging.
| > > 
| > > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > > ---
| > > 
| > > I found it useful for APIC code merging process (in which
| > > i'm now). So please review and test if possible.
| > > Any comments are quite welcome!
| > > 
| > > Ugh... almost forget - the patch is over -tip tree
| > > commit 62c67a7cc7dbd9c8d92d49cfd7d5ca1d8f354616
| > 
| > applied to tip/x86/core for more testing, thanks Cyrill.
| 
| doesnt build:
| 
|  arch/x86/mach-default/setup.c:44: warning: ‘irq2’ defined but not used
|  arch/x86/kernel/irqinit_32.c: In function ‘native_init_IRQ’:
|  arch/x86/kernel/irqinit_32.c:139: error: ‘irq2’ undeclared (first use in this function)
|  arch/x86/kernel/irqinit_32.c:139: error: (Each undeclared identifier is reported only once
|  arch/x86/kernel/irqinit_32.c:139: error: for each function it appears in.)
| 
| with:
| 
|  http://redhat.com/~mingo/misc/config-Mon_Aug_11_14_48_29_CEST_2008.bad
| 
| 	Ingo
| 

Sorry, Ingo, for that. Here is an updated version. Could you please
update it?

		- Cyrill -
---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH -tip] x86: apic interrupts - move assignments to irqinit_32.c v2

64bit mode APIC interrupt handlers are set within irqinit_64.c.
Lets do tha same for 32bit mode which would help in furter code merging.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

The patch is on top of 62c67a7cc7dbd9c8d92d49cfd7d5ca1d8f354616 -tip tree.

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-08-11 18:16:22.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-08-11 18:18:13.000000000 +0400
@@ -1366,54 +1366,6 @@ void smp_error_interrupt(struct pt_regs 
 	irq_exit();
 }
 
-#ifdef CONFIG_SMP
-void __init smp_intr_init(void)
-{
-	/*
-	 * IRQ0 must be given a fixed assignment and initialized,
-	 * because it's used before the IO-APIC is set up.
-	 */
-	set_intr_gate(FIRST_DEVICE_VECTOR, interrupt[0]);
-
-	/*
-	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
-	 * IPI, driven by wakeup.
-	 */
-	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
-
-	/* IPI for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR, invalidate_interrupt);
-
-	/* IPI for generic function call */
-	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
-
-	/* IPI for single call function */
-	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
-				call_function_single_interrupt);
-}
-#endif
-
-/*
- * Initialize APIC interrupts
- */
-void __init apic_intr_init(void)
-{
-#ifdef CONFIG_SMP
-	smp_intr_init();
-#endif
-	/* self generated IPI for local APIC timer */
-	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
-
-	/* IPI vectors for APIC spurious and error interrupts */
-	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
-	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
-
-	/* thermal monitor LVT interrupt */
-#ifdef CONFIG_X86_MCE_P4THERMAL
-	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
-#endif
-}
-
 /**
  * connect_bsp_APIC - attach the APIC to the interrupt system
  */
Index: linux-2.6.git/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_32.c	2008-08-11 18:16:22.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/irqinit_32.c	2008-08-11 18:23:51.000000000 +0400
@@ -74,6 +74,15 @@ void __init init_ISA_irqs (void)
 	}
 }
 
+/*
+ * IRQ2 is cascade interrupt to second interrupt controller
+ */
+static struct irqaction irq2 = {
+	.handler = no_action,
+	.mask = CPU_MASK_NONE,
+	.name = "cascade",
+};
+
 /* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
@@ -98,6 +107,46 @@ void __init native_init_IRQ(void)
 			set_intr_gate(vector, interrupt[i]);
 	}
 
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
+	/*
+	 * IRQ0 must be given a fixed assignment and initialized,
+	 * because it's used before the IO-APIC is set up.
+	 */
+	set_intr_gate(FIRST_DEVICE_VECTOR, interrupt[0]);
+
+	/*
+	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
+	 * IPI, driven by wakeup.
+	 */
+	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
+
+	/* IPI for invalidation */
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR, invalidate_interrupt);
+
+	/* IPI for generic function call */
+	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+
+	/* IPI for single call function */
+	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR, call_function_single_interrupt);
+#endif
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	/* self generated IPI for local APIC timer */
+	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
+
+	/* IPI vectors for APIC spurious and error interrupts */
+	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
+	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+#endif
+
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
+	/* thermal monitor LVT interrupt */
+	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
+#endif
+
+	if (!acpi_ioapic)
+		setup_irq(2, &irq2);
+
 	/* setup after call gates are initialised (usually add in
 	 * the architecture specific gates)
 	 */
Index: linux-2.6.git/arch/x86/mach-default/setup.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mach-default/setup.c	2008-08-11 18:16:22.000000000 +0400
+++ linux-2.6.git/arch/x86/mach-default/setup.c	2008-08-11 18:22:51.000000000 +0400
@@ -38,15 +38,6 @@ void __init pre_intr_init_hook(void)
 	init_ISA_irqs();
 }
 
-/*
- * IRQ2 is cascade interrupt to second interrupt controller
- */
-static struct irqaction irq2 = {
-	.handler = no_action,
-	.mask = CPU_MASK_NONE,
-	.name = "cascade",
-};
-
 /**
  * intr_init_hook - post gate setup interrupt initialisation
  *
@@ -62,12 +53,6 @@ void __init intr_init_hook(void)
 		if (x86_quirks->arch_intr_init())
 			return;
 	}
-#ifdef CONFIG_X86_LOCAL_APIC
-	apic_intr_init();
-#endif
-
-	if (!acpi_ioapic)
-		setup_irq(2, &irq2);
 }
 
 /**
Index: linux-2.6.git/include/asm-x86/arch_hooks.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/arch_hooks.h	2008-08-11 18:16:22.000000000 +0400
+++ linux-2.6.git/include/asm-x86/arch_hooks.h	2008-08-11 18:18:13.000000000 +0400
@@ -12,8 +12,6 @@
 /* these aren't arch hooks, they are generic routines
  * that can be used by the hooks */
 extern void init_ISA_irqs(void);
-extern void apic_intr_init(void);
-extern void smp_intr_init(void);
 extern irqreturn_t timer_interrupt(int irq, void *dev_id);
 
 /* these are the defined hooks */

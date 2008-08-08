Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbYHHTul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbYHHTul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbYHHTuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:50:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:20650 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYHHTuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:50:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dGE/vBms+DcyrKgsJZbHX4c190+1NhdXMXr5kNMcrDg6A1i8aRDg1gac82P9ay5R+3
         Bz/hhb5tpRzpsl0eK1hfmm4lCaQQdn9wRf9rAVS0PEy0CNIDq49aBNh+gekXCte9VNGX
         axHI23i1ZcM4Y8vFlvjNZ3+1LiFoqZdKXSZFc=
Date: Fri, 8 Aug 2008 23:50:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86: apic interrupts - move assignments to
	irqinit_32.c
Message-ID: <20080808195006.GA7014@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64bit mode APIC interrupt handlers are set within irqinit_64.c.
Lets do tha same for 32bit mode which would help in furter code merging.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

I found it useful for APIC code merging process (in which
i'm now). So please review and test if possible.
Any comments are quite welcome!

Ugh... almost forget - the patch is over -tip tree
commit 62c67a7cc7dbd9c8d92d49cfd7d5ca1d8f354616

 arch/x86/kernel/apic_32.c     |   48 -----------------------------------------
 arch/x86/kernel/irqinit_32.c  |   49 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/mach-default/setup.c |   15 ------------
 include/asm-x86/arch_hooks.h  |    2 -
 4 files changed, 48 insertions(+), 66 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-08-08 23:12:23.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-08-08 23:14:21.000000000 +0400
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
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_32.c	2008-08-08 23:12:23.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/irqinit_32.c	2008-08-08 23:18:33.000000000 +0400
@@ -98,6 +98,46 @@ void __init native_init_IRQ(void)
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
Index: linux-2.6.git/include/asm-x86/arch_hooks.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/arch_hooks.h	2008-08-08 23:12:23.000000000 +0400
+++ linux-2.6.git/include/asm-x86/arch_hooks.h	2008-08-08 23:14:21.000000000 +0400
@@ -12,8 +12,6 @@
 /* these aren't arch hooks, they are generic routines
  * that can be used by the hooks */
 extern void init_ISA_irqs(void);
-extern void apic_intr_init(void);
-extern void smp_intr_init(void);
 extern irqreturn_t timer_interrupt(int irq, void *dev_id);
 
 /* these are the defined hooks */
Index: linux-2.6.git/arch/x86/mach-default/setup.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mach-default/setup.c	2008-08-08 23:12:23.000000000 +0400
+++ linux-2.6.git/arch/x86/mach-default/setup.c	2008-08-08 23:18:57.000000000 +0400
@@ -62,12 +62,6 @@ void __init intr_init_hook(void)
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

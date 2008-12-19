Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbYLSQJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbYLSQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYLSQJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:09:21 -0500
Received: from relay2.sgi.com ([192.48.179.30]:52881 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751019AbYLSQJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:09:20 -0500
Date: Fri, 19 Dec 2008 10:09:19 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 v5] SGI RTC: add generic timer system interrupt
Message-ID: <20081219160919.GA18226@sgi.com>
References: <20081219160751.GA18071@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219160751.GA18071@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allocates a system interrupt vector for platform specific use
in implementing timer interrupts.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

Refreshed for latest -tip.

 arch/x86/include/asm/hw_irq.h      |    1 
 arch/x86/include/asm/irq.h         |    2 +
 arch/x86/include/asm/irq_vectors.h |    5 +++
 arch/x86/kernel/entry_64.S         |    2 +
 arch/x86/kernel/irqinit_64.c       |   45 +++++++++++++++++++++++++++++++++
 5 files changed, 55 insertions(+)

Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S	2008-12-19 10:02:26.000000000 -0600
+++ linux/arch/x86/kernel/entry_64.S	2008-12-19 10:02:28.000000000 -0600
@@ -985,6 +985,8 @@ apicinterrupt UV_BAU_MESSAGE \
 	uv_bau_message_intr1 uv_bau_message_interrupt
 apicinterrupt LOCAL_TIMER_VECTOR \
 	apic_timer_interrupt smp_apic_timer_interrupt
+apicinterrupt GENERIC_TIMER_VECTOR \
+	generic_timer_interrupt smp_generic_timer_interrupt
 
 #ifdef CONFIG_SMP
 apicinterrupt INVALIDATE_TLB_VECTOR_START+0 \
Index: linux/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_64.c	2008-12-19 10:02:26.000000000 -0600
+++ linux/arch/x86/kernel/irqinit_64.c	2008-12-19 10:02:28.000000000 -0600
@@ -22,6 +22,7 @@
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
+#include <asm/idle.h>
 
 /*
  * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
@@ -93,6 +94,47 @@ void __init init_ISA_irqs(void)
 
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
+
+/* Function pointer for generic timer interrupt handling */
+static void (*generic_timer_interrupt_extension)(void);
+
+int
+register_generic_timer_extension(void (*fn)(void))
+{
+	if (generic_timer_interrupt_extension)
+		return 1;
+
+	generic_timer_interrupt_extension = fn;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_generic_timer_extension);
+
+void
+unregister_generic_timer_extension(void)
+{
+	if (generic_timer_interrupt_extension)
+		generic_timer_interrupt_extension = NULL;
+}
+EXPORT_SYMBOL_GPL(unregister_generic_timer_extension);
+
+void smp_generic_timer_interrupt(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	ack_APIC_irq();
+
+	exit_idle();
+
+	irq_enter();
+
+	if (generic_timer_interrupt_extension)
+		generic_timer_interrupt_extension();
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
 static void __init smp_intr_init(void)
 {
 #ifdef CONFIG_SMP
@@ -134,6 +176,9 @@ static void __init apic_intr_init(void)
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
+	/* IPI for platform specific timers */
+	alloc_intr_gate(GENERIC_TIMER_VECTOR, generic_timer_interrupt);
+
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
Index: linux/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq_vectors.h	2008-12-19 10:02:26.000000000 -0600
+++ linux/arch/x86/include/asm/irq_vectors.h	2008-12-19 10:02:28.000000000 -0600
@@ -92,6 +92,11 @@
 #define LOCAL_PERF_VECTOR	0xee
 
 /*
+ * Generic timer vector for platform specific use
+ */
+#define GENERIC_TIMER_VECTOR	0xed
+
+/*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
Index: linux/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hw_irq.h	2008-12-19 10:02:26.000000000 -0600
+++ linux/arch/x86/include/asm/hw_irq.h	2008-12-19 10:02:28.000000000 -0600
@@ -29,6 +29,7 @@
 
 /* Interrupt handlers registered during init_IRQ */
 extern void apic_timer_interrupt(void);
+extern void generic_timer_interrupt(void);
 extern void error_interrupt(void);
 extern void perf_counter_interrupt(void);
 
Index: linux/arch/x86/include/asm/irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq.h	2008-12-19 10:02:26.000000000 -0600
+++ linux/arch/x86/include/asm/irq.h	2008-12-19 10:02:28.000000000 -0600
@@ -38,6 +38,8 @@ extern void fixup_irqs(void);
 
 extern unsigned int do_IRQ(struct pt_regs *regs);
 extern void init_IRQ(void);
+extern int register_generic_timer_extension(void (*fn)(void));
+extern void unregister_generic_timer_extension(void);
 extern void native_init_IRQ(void);
 
 /* Interrupt vector management */

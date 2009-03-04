Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbZCDS4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbZCDS4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZCDS4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:56:10 -0500
Received: from relay1.sgi.com ([192.48.179.29]:51923 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755411AbZCDS4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:56:08 -0500
Date: Wed, 4 Mar 2009 12:56:05 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3 v7] SGI RTC: add generic system vector
Message-ID: <20090304185605.GA24419@sgi.com>
References: <20090304185413.GA24385@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304185413.GA24385@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allocates a system interrupt vector for various platform
specific uses.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

Made suggested simplifications and made symmetric across 32/64 bit.

 arch/x86/include/asm/entry_arch.h  |    2 +
 arch/x86/include/asm/hardirq.h     |    1 
 arch/x86/include/asm/hw_irq.h      |    1 
 arch/x86/include/asm/irq.h         |    1 
 arch/x86/include/asm/irq_vectors.h |    5 ++++
 arch/x86/kernel/entry_64.S         |    2 +
 arch/x86/kernel/irq.c              |   34 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/irqinit_32.c       |    3 ++
 arch/x86/kernel/irqinit_64.c       |    3 ++
 9 files changed, 52 insertions(+)

Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S	2009-03-04 11:07:48.000000000 -0600
+++ linux/arch/x86/kernel/entry_64.S	2009-03-04 11:07:51.000000000 -0600
@@ -984,6 +984,8 @@ apicinterrupt UV_BAU_MESSAGE \
 #endif
 apicinterrupt LOCAL_TIMER_VECTOR \
 	apic_timer_interrupt smp_apic_timer_interrupt
+apicinterrupt GENERIC_INTERRUPT_VECTOR \
+	generic_interrupt smp_generic_interrupt
 
 #ifdef CONFIG_SMP
 apicinterrupt INVALIDATE_TLB_VECTOR_START+0 \
Index: linux/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_64.c	2009-03-04 11:07:48.000000000 -0600
+++ linux/arch/x86/kernel/irqinit_64.c	2009-03-04 11:07:51.000000000 -0600
@@ -147,6 +147,9 @@ static void __init apic_intr_init(void)
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
+	/* generic IPI for platform specific use */
+	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
+
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
Index: linux/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq_vectors.h	2009-03-04 11:07:48.000000000 -0600
+++ linux/arch/x86/include/asm/irq_vectors.h	2009-03-04 11:07:51.000000000 -0600
@@ -112,6 +112,11 @@
 #define LOCAL_PERF_VECTOR		0xee
 
 /*
+ * Generic system vector for platform specific use
+ */
+#define GENERIC_INTERRUPT_VECTOR	0xed
+
+/*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
Index: linux/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hw_irq.h	2009-03-04 11:07:48.000000000 -0600
+++ linux/arch/x86/include/asm/hw_irq.h	2009-03-04 11:07:51.000000000 -0600
@@ -27,6 +27,7 @@
 
 /* Interrupt handlers registered during init_IRQ */
 extern void apic_timer_interrupt(void);
+extern void generic_interrupt(void);
 extern void error_interrupt(void);
 extern void perf_counter_interrupt(void);
 
Index: linux/arch/x86/include/asm/irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq.h	2009-03-04 11:07:48.000000000 -0600
+++ linux/arch/x86/include/asm/irq.h	2009-03-04 11:07:51.000000000 -0600
@@ -36,6 +36,7 @@ static inline int irq_canonicalize(int i
 extern void fixup_irqs(void);
 #endif
 
+extern void (*generic_interrupt_extension)(void);
 extern void init_IRQ(void);
 extern void native_init_IRQ(void);
 extern bool handle_irq(unsigned irq, struct pt_regs *regs);
Index: linux/arch/x86/kernel/irq.c
===================================================================
--- linux.orig/arch/x86/kernel/irq.c	2009-03-04 11:07:48.000000000 -0600
+++ linux/arch/x86/kernel/irq.c	2009-03-04 11:07:51.000000000 -0600
@@ -15,6 +15,9 @@
 
 atomic_t irq_err_count;
 
+/* Function pointer for generic interrupt vector handling */
+void (*generic_interrupt_extension)(void) = NULL;
+
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
@@ -60,6 +63,12 @@ static int show_other_interrupts(struct 
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
 	seq_printf(p, "  Performance counter interrupts\n");
 #endif
+	if (generic_interrupt_extension) {
+		seq_printf(p, "PLT: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", irq_stats(j)->generic_irqs);
+		seq_printf(p, "  Platform interrupts\n");
+	}
 #ifdef CONFIG_SMP
 	seq_printf(p, "RES: ");
 	for_each_online_cpu(j)
@@ -168,6 +177,8 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->apic_timer_irqs;
 	sum += irq_stats(cpu)->apic_perf_irqs;
 #endif
+	if (generic_interrupt_extension)
+		sum += irq_stats(cpu)->generic_irqs;
 #ifdef CONFIG_SMP
 	sum += irq_stats(cpu)->irq_resched_count;
 	sum += irq_stats(cpu)->irq_call_count;
@@ -231,4 +242,27 @@ unsigned int __irq_entry do_IRQ(struct p
 	return 1;
 }
 
+/*
+ * Handler for GENERIC_INTERRUPT_VECTOR.
+ */
+void smp_generic_interrupt(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	ack_APIC_irq();
+
+	exit_idle();
+
+	irq_enter();
+
+	inc_irq_stat(generic_irqs);
+
+	if (generic_interrupt_extension)
+		generic_interrupt_extension();
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
Index: linux/arch/x86/include/asm/hardirq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hardirq.h	2009-03-04 11:07:48.000000000 -0600
+++ linux/arch/x86/include/asm/hardirq.h	2009-03-04 11:07:51.000000000 -0600
@@ -13,6 +13,7 @@ typedef struct {
 	unsigned int irq_spurious_count;
 #endif
 	unsigned int apic_perf_irqs;
+	unsigned int generic_irqs;	/* arch dependent */
 #ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
Index: linux/arch/x86/include/asm/entry_arch.h
===================================================================
--- linux.orig/arch/x86/include/asm/entry_arch.h	2009-03-04 11:07:48.000000000 -0600
+++ linux/arch/x86/include/asm/entry_arch.h	2009-03-04 11:07:51.000000000 -0600
@@ -33,6 +33,8 @@ BUILD_INTERRUPT3(invalidate_interrupt7,I
 		 smp_invalidate_interrupt)
 #endif
 
+BUILD_INTERRUPT(generic_interrupt, GENERIC_INTERRUPT_VECTOR)
+
 /*
  * every pentium local APIC has two 'local interrupts', with a
  * soft-definable vector attached to both interrupts, one of
Index: linux/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_32.c	2009-03-04 11:07:48.000000000 -0600
+++ linux/arch/x86/kernel/irqinit_32.c	2009-03-04 11:07:51.000000000 -0600
@@ -160,6 +160,9 @@ static void __init apic_intr_init(void)
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
+	/* generic IPI for platform specific use */
+	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
+
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);

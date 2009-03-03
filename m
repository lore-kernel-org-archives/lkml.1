Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZCCPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZCCPOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZCCPOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:14:03 -0500
Received: from relay3.sgi.com ([192.48.171.31]:47412 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985AbZCCPOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:14:01 -0500
Date: Tue, 3 Mar 2009 09:13:57 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6 v6] SGI RTC: add generic system interrupt
Message-ID: <20090303151357.GA20120@sgi.com>
References: <20090303151044.GA20016@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303151044.GA20016@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allocates a system interrupt vector for various platform
specific uses.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

Made changes suggested by tglx and refreshed for latest -tip.

 arch/x86/include/asm/hardirq.h     |    1 
 arch/x86/include/asm/hw_irq.h      |    3 +
 arch/x86/include/asm/irq.h         |    9 ++++
 arch/x86/include/asm/irq_vectors.h |    5 ++
 arch/x86/kernel/entry_64.S         |    2 
 arch/x86/kernel/irq.c              |   12 +++++
 arch/x86/kernel/irqinit_64.c       |   74 +++++++++++++++++++++++++++++++++
 7 files changed, 106 insertions(+)

Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S	2009-03-02 08:20:20.000000000 -0600
+++ linux/arch/x86/kernel/entry_64.S	2009-03-02 08:20:52.000000000 -0600
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
--- linux.orig/arch/x86/kernel/irqinit_64.c	2009-03-02 08:20:20.000000000 -0600
+++ linux/arch/x86/kernel/irqinit_64.c	2009-03-02 08:20:52.000000000 -0600
@@ -22,6 +22,7 @@
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
+#include <asm/idle.h>
 
 /*
  * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
@@ -105,6 +106,76 @@ static void __init init_ISA_irqs(void)
 
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
+
+/* Function pointer for generic interrupt vector handling */
+static void (*generic_interrupt_extension)(void);
+static char generic_show_string[28];
+static char generic_show_prefix[6];
+
+int is_generic_interrupt_registered()
+{
+	if (generic_interrupt_extension)
+		return 1;
+	else
+		return 0;
+}
+
+char *generic_interrupt_string(void)
+{
+	return generic_show_string;
+}
+
+char *generic_interrupt_prefix(void)
+{
+	return generic_show_prefix;
+}
+
+int register_generic_interrupt_extension(void (*fn)(void),
+					 const char *show_prefix,
+					 const char *show_string)
+{
+	if (generic_interrupt_extension)
+		return -EBUSY;
+
+	snprintf(generic_show_prefix, sizeof(generic_show_prefix),
+		"%3.3s: ", show_prefix ? show_prefix : "GEN");
+
+	snprintf(generic_show_string, sizeof(generic_show_string),
+		"  %s", show_string ?  show_string : "Generic interrupts");
+
+	generic_interrupt_extension = fn;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_generic_interrupt_extension);
+
+void unregister_generic_interrupt_extension(void)
+{
+	if (generic_interrupt_extension)
+		generic_interrupt_extension = NULL;
+}
+EXPORT_SYMBOL_GPL(unregister_generic_interrupt_extension);
+
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
 static void __init smp_intr_init(void)
 {
 #ifdef CONFIG_SMP
@@ -147,6 +218,9 @@ static void __init apic_intr_init(void)
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
--- linux.orig/arch/x86/include/asm/irq_vectors.h	2009-03-02 08:20:20.000000000 -0600
+++ linux/arch/x86/include/asm/irq_vectors.h	2009-03-02 08:20:52.000000000 -0600
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
--- linux.orig/arch/x86/include/asm/hw_irq.h	2009-03-02 08:20:20.000000000 -0600
+++ linux/arch/x86/include/asm/hw_irq.h	2009-03-02 08:20:52.000000000 -0600
@@ -27,6 +27,9 @@
 
 /* Interrupt handlers registered during init_IRQ */
 extern void apic_timer_interrupt(void);
+#ifdef CONFIG_X86_64
+extern void generic_interrupt(void);
+#endif
 extern void error_interrupt(void);
 extern void perf_counter_interrupt(void);
 
Index: linux/arch/x86/include/asm/irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq.h	2009-03-02 08:20:20.000000000 -0600
+++ linux/arch/x86/include/asm/irq.h	2009-03-02 08:20:52.000000000 -0600
@@ -42,6 +42,15 @@ extern bool handle_irq(unsigned irq, str
 
 extern unsigned int do_IRQ(struct pt_regs *regs);
 
+#ifdef CONFIG_X86_64
+extern int is_generic_interrupt_registered(void);
+extern char *generic_interrupt_string(void);
+extern char *generic_interrupt_prefix(void);
+extern int register_generic_interrupt_extension(void (*fn)(void), const char *,
+							const char *);
+extern void unregister_generic_interrupt_extension(void);
+#endif
+
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
 extern int vector_used_by_percpu_irq(unsigned int vector);
Index: linux/arch/x86/kernel/irq.c
===================================================================
--- linux.orig/arch/x86/kernel/irq.c	2009-03-02 08:20:20.000000000 -0600
+++ linux/arch/x86/kernel/irq.c	2009-03-02 08:20:52.000000000 -0600
@@ -60,6 +60,14 @@ static int show_other_interrupts(struct 
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
 	seq_printf(p, "  Performance counter interrupts\n");
 #endif
+#ifdef CONFIG_X86_64
+	if (is_generic_interrupt_registered()) {
+		seq_printf(p, "%s", generic_interrupt_prefix());
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", irq_stats(j)->generic_irqs);
+		seq_printf(p, "%s\n", generic_interrupt_string());
+	}
+#endif
 #ifdef CONFIG_SMP
 	seq_printf(p, "RES: ");
 	for_each_online_cpu(j)
@@ -168,6 +176,10 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->apic_timer_irqs;
 	sum += irq_stats(cpu)->apic_perf_irqs;
 #endif
+#ifdef CONFIG_X86_64
+	if (is_generic_interrupt_registered())
+		sum += irq_stats(cpu)->generic_irqs;
+#endif
 #ifdef CONFIG_SMP
 	sum += irq_stats(cpu)->irq_resched_count;
 	sum += irq_stats(cpu)->irq_call_count;
Index: linux/arch/x86/include/asm/hardirq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hardirq.h	2009-03-02 08:20:20.000000000 -0600
+++ linux/arch/x86/include/asm/hardirq.h	2009-03-02 08:20:52.000000000 -0600
@@ -22,6 +22,7 @@ typedef struct {
 	unsigned int irq_thermal_count;
 # ifdef CONFIG_X86_64
 	unsigned int irq_threshold_count;
+	unsigned int generic_irqs;
 # endif
 #endif
 } ____cacheline_aligned irq_cpustat_t;

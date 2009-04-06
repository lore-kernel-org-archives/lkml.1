Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZDFJtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZDFJtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbZDFJor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:42361 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbZDFJoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:39 -0400
Message-Id: <20090406094517.724626696@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/15] perf_counter: x86: self-IPI for pending work
Content-Disposition: inline; filename=perf_counter-x86-pending.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement set_perf_counter_pending() with a self-IPI so that it will
run ASAP in a usable context.

For now use a second IRQ vector, because the primary vector pokes
the apic in funny ways that seem to confuse things.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/entry_arch.h   |    1 +
 arch/x86/include/asm/hardirq.h      |    1 +
 arch/x86/include/asm/hw_irq.h       |    1 +
 arch/x86/include/asm/irq_vectors.h  |    5 +++++
 arch/x86/include/asm/perf_counter.h |    3 ++-
 arch/x86/kernel/cpu/perf_counter.c  |   14 ++++++++++++++
 arch/x86/kernel/entry_64.S          |    2 ++
 arch/x86/kernel/irq.c               |    5 +++++
 arch/x86/kernel/irqinit_32.c        |    1 +
 arch/x86/kernel/irqinit_64.c        |    1 +
 10 files changed, 33 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/include/asm/entry_arch.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/entry_arch.h
+++ linux-2.6/arch/x86/include/asm/entry_arch.h
@@ -50,6 +50,7 @@ BUILD_INTERRUPT(spurious_interrupt,SPURI
 
 #ifdef CONFIG_PERF_COUNTERS
 BUILD_INTERRUPT(perf_counter_interrupt, LOCAL_PERF_VECTOR)
+BUILD_INTERRUPT(perf_pending_interrupt, LOCAL_PENDING_VECTOR)
 #endif
 
 #ifdef CONFIG_X86_MCE_P4THERMAL
Index: linux-2.6/arch/x86/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hardirq.h
+++ linux-2.6/arch/x86/include/asm/hardirq.h
@@ -14,6 +14,7 @@ typedef struct {
 #endif
 	unsigned int generic_irqs;	/* arch dependent */
 	unsigned int apic_perf_irqs;
+	unsigned int apic_pending_irqs;
 #ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
Index: linux-2.6/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6/arch/x86/include/asm/hw_irq.h
@@ -30,6 +30,7 @@ extern void apic_timer_interrupt(void);
 extern void generic_interrupt(void);
 extern void error_interrupt(void);
 extern void perf_counter_interrupt(void);
+extern void perf_pending_interrupt(void);
 
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
+++ linux-2.6/arch/x86/include/asm/irq_vectors.h
@@ -117,6 +117,11 @@
 #define GENERIC_INTERRUPT_VECTOR	0xed
 
 /*
+ * Performance monitoring pending work vector:
+ */
+#define LOCAL_PENDING_VECTOR		0xec
+
+/*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
Index: linux-2.6/arch/x86/include/asm/perf_counter.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/perf_counter.h
+++ linux-2.6/arch/x86/include/asm/perf_counter.h
@@ -84,7 +84,8 @@ union cpuid10_edx {
 #define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
 #define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
 
-#define set_perf_counter_pending()	do { } while (0)
+extern void set_perf_counter_pending(void);
+
 #define clear_perf_counter_pending()	do { } while (0)
 #define test_perf_counter_pending()	(0)
 
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -849,6 +849,20 @@ void smp_perf_counter_interrupt(struct p
 	irq_exit();
 }
 
+void smp_perf_pending_interrupt(struct pt_regs *regs)
+{
+	irq_enter();
+	ack_APIC_irq();
+	inc_irq_stat(apic_pending_irqs);
+	perf_counter_do_pending();
+	irq_exit();
+}
+
+void set_perf_counter_pending(void)
+{
+	apic->send_IPI_self(LOCAL_PENDING_VECTOR);
+}
+
 void perf_counters_lapic_init(int nmi)
 {
 	u32 apic_val;
Index: linux-2.6/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6/arch/x86/kernel/entry_64.S
@@ -1028,6 +1028,8 @@ apicinterrupt SPURIOUS_APIC_VECTOR \
 #ifdef CONFIG_PERF_COUNTERS
 apicinterrupt LOCAL_PERF_VECTOR \
 	perf_counter_interrupt smp_perf_counter_interrupt
+apicinterrupt LOCAL_PENDING_VECTOR \
+	perf_pending_interrupt smp_perf_pending_interrupt
 #endif
 
 /*
Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -67,6 +67,10 @@ static int show_other_interrupts(struct 
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
 	seq_printf(p, "  Performance counter interrupts\n");
+	seq_printf(p, "PND: ");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->apic_pending_irqs);
+	seq_printf(p, "  Performance pending work\n");
 #endif
 	if (generic_interrupt_extension) {
 		seq_printf(p, "PLT: ");
@@ -171,6 +175,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->apic_timer_irqs;
 	sum += irq_stats(cpu)->irq_spurious_count;
 	sum += irq_stats(cpu)->apic_perf_irqs;
+	sum += irq_stats(cpu)->apic_pending_irqs;
 #endif
 	if (generic_interrupt_extension)
 		sum += irq_stats(cpu)->generic_irqs;
Index: linux-2.6/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6/arch/x86/kernel/irqinit_32.c
@@ -166,6 +166,7 @@ static void __init apic_intr_init(void)
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 # ifdef CONFIG_PERF_COUNTERS
 	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+	alloc_intr_gate(LOCAL_PENDING_VECTOR, perf_pending_interrupt);
 # endif
 
 # ifdef CONFIG_X86_MCE_P4THERMAL
Index: linux-2.6/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6/arch/x86/kernel/irqinit_64.c
@@ -156,6 +156,7 @@ static void __init apic_intr_init(void)
 	/* Performance monitoring interrupt: */
 #ifdef CONFIG_PERF_COUNTERS
 	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+	alloc_intr_gate(LOCAL_PENDING_VECTOR, perf_pending_interrupt);
 #endif
 }
 

-- 


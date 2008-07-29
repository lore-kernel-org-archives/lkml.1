Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYG2Xdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYG2Xdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYG2XdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:33:05 -0400
Received: from gw.goop.org ([64.81.55.164]:54677 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbYG2XdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:33:03 -0400
Message-ID: <488FA8A9.6000005@goop.org>
Date: Tue, 29 Jul 2008 16:32:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86: implement multiple queues for smp function call
 IPIs
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds 8 queues for smp_call_function(), in order to avoid a
bottleneck on a single global lock and list for function calls.  When
initiating a function call, the sender chooses a queue based on its
own processor id (if there are more than 8 processors, they hash down
to 8 queues).  It then sends an IPI to the corresponding vector for
that queue to each target CPU.  The target CPUs use the vector number
to determine which queue they should scan for work.

This should give smp_call_function the same performance
characteristics as the original x86-64 cross-cpu tlb flush code, which
used the same scheme.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/Kconfig                          |    4 ++++
 arch/x86/kernel/apic_32.c                 |   11 ++++++++++-
 arch/x86/kernel/entry_32.S                |   25 ++++++++++++++-----------
 arch/x86/kernel/entry_64.S                |   19 ++++++++++++++++---
 arch/x86/kernel/irqinit_64.c              |   11 ++++++++++-
 arch/x86/kernel/smp.c                     |   10 +++++++---
 arch/x86/xen/smp.c                        |   27 ++++++++++++++++++++++++++-
 include/asm-x86/hw_irq.h                  |   20 +++++++++-----------
 include/asm-x86/irq_vectors.h             |    6 ++++--
 include/asm-x86/mach-default/entry_arch.h |   16 +++++++++++++++-
 10 files changed, 115 insertions(+), 34 deletions(-)

===================================================================
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -178,6 +178,10 @@
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
 	select USE_GENERIC_SMP_HELPERS
 	default y
+
+config GENERIC_SMP_QUEUES
+       int
+       default "8"
 
 config X86_32_SMP
 	def_bool y
===================================================================
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1382,7 +1382,16 @@
 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
 	/* IPI for generic function call */
-	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+	BUILD_BUG_ON(CONFIG_GENERIC_SMP_QUEUES !=
+		     (CALL_FUNCTION_VECTOR_END - CALL_FUNCTION_VECTOR_START + 1));
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+0, call_function_interrupt0);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+1, call_function_interrupt1);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+2, call_function_interrupt2);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+3, call_function_interrupt3);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+4, call_function_interrupt4);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+5, call_function_interrupt5);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+6, call_function_interrupt6);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+7, call_function_interrupt7);
 
 	/* IPI for single call function */
 	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
===================================================================
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -688,19 +688,22 @@
 ENDPROC(common_interrupt)
 	CFI_ENDPROC
 
-#define BUILD_INTERRUPT(name, nr)	\
-ENTRY(name)				\
-	RING0_INT_FRAME;		\
-	pushl $~(nr);			\
-	CFI_ADJUST_CFA_OFFSET 4;	\
-	SAVE_ALL;			\
-	TRACE_IRQS_OFF			\
-	movl %esp,%eax;			\
-	call smp_##name;		\
-	jmp ret_from_intr;		\
-	CFI_ENDPROC;			\
+#define __BUILD_INTERRUPT(name, func, nr)	\
+ENTRY(name)					\
+	RING0_INT_FRAME;			\
+	pushl $~(nr);				\
+	CFI_ADJUST_CFA_OFFSET 4;		\
+	SAVE_ALL;				\
+	TRACE_IRQS_OFF				\
+	movl %esp,%eax;				\
+	call func;				\
+	jmp ret_from_intr;			\
+	CFI_ENDPROC;				\
 ENDPROC(name)
 
+#define BUILD_INTERRUPT(name, nr)	\
+	__BUILD_INTERRUPT(name, smp_##name, nr)
+
 /* The include is where all of the SMP etc. interrupts come from */
 #include "entry_arch.h"
 
===================================================================
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -869,9 +869,22 @@
 	apicinterrupt RESCHEDULE_VECTOR,smp_reschedule_interrupt
 END(reschedule_interrupt)
 
-ENTRY(call_function_interrupt)
-	apicinterrupt CALL_FUNCTION_VECTOR,smp_call_function_interrupt
-END(call_function_interrupt)
+
+	.macro CALLFUNCTION_ENTRY num
+ENTRY(call_function_interrupt\num)
+	apicinterrupt CALL_FUNCTION_VECTOR_START+\num,smp_call_function_interrupt
+END(call_function_interrupt\num)
+	.endm
+
+	CALLFUNCTION_ENTRY 0
+	CALLFUNCTION_ENTRY 1
+	CALLFUNCTION_ENTRY 2
+	CALLFUNCTION_ENTRY 3
+	CALLFUNCTION_ENTRY 4
+	CALLFUNCTION_ENTRY 5
+	CALLFUNCTION_ENTRY 6
+	CALLFUNCTION_ENTRY 7
+
 ENTRY(call_function_single_interrupt)
 	apicinterrupt CALL_FUNCTION_SINGLE_VECTOR,smp_call_function_single_interrupt
 END(call_function_single_interrupt)
===================================================================
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -188,7 +188,16 @@
 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
 	/* IPI for generic function call */
-	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+	BUILD_BUG_ON(CONFIG_GENERIC_SMP_QUEUES !=
+		     (CALL_FUNCTION_VECTOR_END - CALL_FUNCTION_VECTOR_START + 1));
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+0, call_function_interrupt0);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+1, call_function_interrupt1);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+2, call_function_interrupt2);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+3, call_function_interrupt3);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+4, call_function_interrupt4);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+5, call_function_interrupt5);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+6, call_function_interrupt6);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR_START+7, call_function_interrupt7);
 
 	/* IPI for generic single function call */
 	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
===================================================================
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -129,15 +129,16 @@
 void native_send_call_func_ipi(cpumask_t mask)
 {
 	cpumask_t allbutself;
+	unsigned queue = smp_processor_id() % CONFIG_GENERIC_SMP_QUEUES;
 
 	allbutself = cpu_online_map;
 	cpu_clear(smp_processor_id(), allbutself);
 
 	if (cpus_equal(mask, allbutself) &&
 	    cpus_equal(cpu_online_map, cpu_callout_map))
-		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+		send_IPI_allbutself(CALL_FUNCTION_VECTOR_START + queue);
 	else
-		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+		send_IPI_mask(mask, CALL_FUNCTION_VECTOR_START + queue);
 }
 
 static void stop_this_cpu(void *dummy)
@@ -187,9 +188,12 @@
 
 void smp_call_function_interrupt(struct pt_regs *regs)
 {
+	unsigned queue;
+
 	ack_APIC_irq();
 	irq_enter();
-	generic_smp_call_function_interrupt(0);
+	queue = ~regs->orig_ax - CALL_FUNCTION_VECTOR_START;
+	generic_smp_call_function_interrupt(queue);
 #ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_call_count++;
 #else
===================================================================
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -41,6 +41,8 @@
 static DEFINE_PER_CPU(int, callfunc_irq);
 static DEFINE_PER_CPU(int, callfuncsingle_irq);
 static DEFINE_PER_CPU(int, debug_irq) = -1;
+
+static DEFINE_PER_CPU(unsigned, callfunc_queue);
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
 static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
@@ -381,6 +383,21 @@
 static void xen_smp_send_call_function_ipi(cpumask_t mask)
 {
 	int cpu;
+	unsigned queue = smp_processor_id() % CONFIG_GENERIC_SMP_QUEUES;
+
+	/*
+	 * We can't afford to allocate N callfunc vectors * M cpu
+	 * interrupts, so we just need to fake it for now.  We can fix
+	 * this when we integrate event channels at the vector level.
+	 * For now, we just leave a hint for the target cpus for which
+	 * queue to start on, but they still need to search them all.
+	 * (Which is not really much worse than having a single
+	 * queue.)
+	 */
+	for_each_cpu_mask_nr(cpu, mask)
+		per_cpu(callfunc_queue, cpu) = queue;
+
+	wmb();			/* set queues before sending interrupt */
 
 	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
 
@@ -400,8 +417,16 @@
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 {
+	unsigned start_queue = __get_cpu_var(callfunc_queue);
+	unsigned queue;
+
 	irq_enter();
-	generic_smp_call_function_interrupt(0);
+	queue = start_queue;
+	do {
+		generic_smp_call_function_interrupt(queue);
+		queue = (queue + 1) % CONFIG_GENERIC_SMP_QUEUES;
+	} while(queue != start_queue);
+
 #ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_call_count++;
 #else
===================================================================
--- a/include/asm-x86/hw_irq.h
+++ b/include/asm-x86/hw_irq.h
@@ -34,20 +34,18 @@
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
 
-extern void invalidate_interrupt(void);
-extern void invalidate_interrupt0(void);
-extern void invalidate_interrupt1(void);
-extern void invalidate_interrupt2(void);
-extern void invalidate_interrupt3(void);
-extern void invalidate_interrupt4(void);
-extern void invalidate_interrupt5(void);
-extern void invalidate_interrupt6(void);
-extern void invalidate_interrupt7(void);
-
 extern void irq_move_cleanup_interrupt(void);
 extern void threshold_interrupt(void);
 
-extern void call_function_interrupt(void);
+extern void call_function_interrupt0(void);
+extern void call_function_interrupt1(void);
+extern void call_function_interrupt2(void);
+extern void call_function_interrupt3(void);
+extern void call_function_interrupt4(void);
+extern void call_function_interrupt5(void);
+extern void call_function_interrupt6(void);
+extern void call_function_interrupt7(void);
+
 extern void call_function_single_interrupt(void);
 
 /* PIC specific functions */
===================================================================
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -62,8 +62,9 @@
 # define SPURIOUS_APIC_VECTOR		0xff
 # define ERROR_APIC_VECTOR		0xfe
 # define RESCHEDULE_VECTOR		0xfc
-# define CALL_FUNCTION_VECTOR		0xfb
 # define CALL_FUNCTION_SINGLE_VECTOR	0xfa
+# define CALL_FUNCTION_VECTOR_END	0xf8
+# define CALL_FUNCTION_VECTOR_START	0xf1 /* f1-f8 multiple callfunction queues */
 # define THERMAL_APIC_VECTOR		0xf0
 
 #else
@@ -71,10 +72,11 @@
 #define SPURIOUS_APIC_VECTOR		0xff
 #define ERROR_APIC_VECTOR		0xfe
 #define RESCHEDULE_VECTOR		0xfd
-#define CALL_FUNCTION_VECTOR		0xfc
 #define CALL_FUNCTION_SINGLE_VECTOR	0xfb
 #define THERMAL_APIC_VECTOR		0xfa
 #define THRESHOLD_APIC_VECTOR		0xf9
+#define CALL_FUNCTION_VECTOR_END	0xf7
+#define CALL_FUNCTION_VECTOR_START	0xf0 /* f0-f7 multiple callfunction queues */
 
 #endif
 
===================================================================
--- a/include/asm-x86/mach-default/entry_arch.h
+++ b/include/asm-x86/mach-default/entry_arch.h
@@ -11,8 +11,22 @@
  */
 #ifdef CONFIG_X86_SMP
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
-BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
 BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
+
+#define BUILD_CALLFUNCTION(n)					\
+	__BUILD_INTERRUPT(call_function_interrupt##n,		\
+			  smp_call_function_interrupt,		\
+			  CALL_FUNCTION_VECTOR_START + n)
+BUILD_CALLFUNCTION(0)
+BUILD_CALLFUNCTION(1)
+BUILD_CALLFUNCTION(2)
+BUILD_CALLFUNCTION(3)
+BUILD_CALLFUNCTION(4)
+BUILD_CALLFUNCTION(5)
+BUILD_CALLFUNCTION(6)
+BUILD_CALLFUNCTION(7)
+
+#undef BUILD_CALLFUNCTION
 #endif
 
 /*



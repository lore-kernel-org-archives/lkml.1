Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbYLSXYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbYLSXYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYLSXYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:24:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:41704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYLSXYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:24:44 -0500
Message-ID: <494C2D00.1060403@kernel.org>
Date: Fri, 19 Dec 2008 15:23:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix lguest used_vectors breakage -v2
References: <494B8790.4060801@kernel.org> <20081219222349.GA10954@elte.hu>
In-Reply-To: <20081219222349.GA10954@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix lguest, clean up

32-bit lguest used used_vectors to record vectors, but that model of
allocating vectors changed and got broken, after we changed vector
allocation to a per_cpu array.

Try enable that for 64bit, and the array is used for all vectors that
are not managed by vector_irq per_cpu array.

Also kill system_vectors[], that is now a duplication of the
used_vectors bitmap.

[ merged in cpus4096 due to io_apic.c cpumask changes. ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/include/asm/desc.h           |   10 ++++------
 arch/x86/include/asm/irq.h            |    1 +
 arch/x86/kernel/apic.c                |    2 --
 arch/x86/kernel/io_apic.c             |    9 +++------
 arch/x86/kernel/irqinit_32.c          |   16 +++++++++++++++-
 arch/x86/kernel/irqinit_64.c          |   13 +++++++++++++
 arch/x86/kernel/traps.c               |   12 +++++++-----
 drivers/lguest/interrupts_and_traps.c |   13 +++++++++----
 8 files changed, 52 insertions(+), 24 deletions(-)

Index: linux-2.6/arch/x86/include/asm/desc.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/desc.h
+++ linux-2.6/arch/x86/include/asm/desc.h
@@ -320,16 +320,14 @@ static inline void set_intr_gate(unsigne
 	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);
 }
 
-#define SYS_VECTOR_FREE		0
-#define SYS_VECTOR_ALLOCED	1
-
 extern int first_system_vector;
-extern char system_vectors[];
+/* used_vectors is BITMAP for irq is not managed by percpu vector_irq */
+extern unsigned long used_vectors[];
 
 static inline void alloc_system_vector(int vector)
 {
-	if (system_vectors[vector] == SYS_VECTOR_FREE) {
-		system_vectors[vector] = SYS_VECTOR_ALLOCED;
+	if (!test_bit(vector, used_vectors)) {
+		set_bit(vector, used_vectors);
 		if (first_system_vector > vector)
 			first_system_vector = vector;
 	} else
Index: linux-2.6/arch/x86/include/asm/irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq.h
+++ linux-2.6/arch/x86/include/asm/irq.h
@@ -42,5 +42,6 @@ extern void native_init_IRQ(void);
 
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
+extern int vector_used_by_percpu_irq(unsigned int vector);
 
 #endif /* _ASM_X86_IRQ_H */
Index: linux-2.6/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic.c
+++ linux-2.6/arch/x86/kernel/apic.c
@@ -120,8 +120,6 @@ EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok
 
 int first_system_vector = 0xfe;
 
-char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
-
 /*
  * Debug level, exported for io_apic.c
  */
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -1326,13 +1326,10 @@ next:
 		}
 		if (unlikely(current_vector == vector))
 			continue;
-#ifdef CONFIG_X86_64
-		if (vector == IA32_SYSCALL_VECTOR)
+
+		if (test_bit(vector, used_vectors))
 			goto next;
-#else
-		if (vector == SYSCALL_VECTOR)
-			goto next;
-#endif
+
 		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
Index: linux-2.6/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6/arch/x86/kernel/irqinit_32.c
@@ -110,6 +110,18 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq)
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
+int vector_used_by_percpu_irq(unsigned int vector)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (per_cpu(vector_irq, cpu)[vector] != -1)
+			return 1;
+	}
+
+	return 0;
+}
+
 /* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
@@ -146,10 +158,12 @@ void __init native_init_IRQ(void)
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
 	/* IPI for single call function */
-	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR, call_function_single_interrupt);
+	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
+				 call_function_single_interrupt);
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
+	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
Index: linux-2.6/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6/arch/x86/kernel/irqinit_64.c
@@ -69,6 +69,18 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq)
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
+int vector_used_by_percpu_irq(unsigned int vector)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (per_cpu(vector_irq, cpu)[vector] != -1)
+			return 1;
+	}
+
+	return 0;
+}
+
 void __init init_ISA_irqs(void)
 {
 	int i;
@@ -121,6 +133,7 @@ static void __init smp_intr_init(void)
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
+	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
 }
 
Index: linux-2.6/arch/x86/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps.c
+++ linux-2.6/arch/x86/kernel/traps.c
@@ -73,9 +73,6 @@
 
 #include "cpu/mcheck/mce.h"
 
-DECLARE_BITMAP(used_vectors, NR_VECTORS);
-EXPORT_SYMBOL_GPL(used_vectors);
-
 asmlinkage int system_call(void);
 
 /* Do we ignore FPU interrupts ? */
@@ -90,6 +87,9 @@ gate_desc idt_table[256]
 	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
 #endif
 
+DECLARE_BITMAP(used_vectors, NR_VECTORS);
+EXPORT_SYMBOL_GPL(used_vectors);
+
 static int ignore_nmis;
 
 static inline void conditional_sti(struct pt_regs *regs)
@@ -950,9 +950,7 @@ dotraplinkage void do_iret_error(struct
 
 void __init trap_init(void)
 {
-#ifdef CONFIG_X86_32
 	int i;
-#endif
 
 #ifdef CONFIG_EISA
 	void __iomem *p = early_ioremap(0x0FFFD9, 4);
@@ -1009,11 +1007,15 @@ void __init trap_init(void)
 	}
 
 	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
+#endif
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
 		set_bit(i, used_vectors);
 
+#ifdef CONFIG_X86_64
+	set_bit(IA32_SYSCALL_VECTOR, used_vectors);
+#else
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
 	/*
Index: linux-2.6/drivers/lguest/interrupts_and_traps.c
===================================================================
--- linux-2.6.orig/drivers/lguest/interrupts_and_traps.c
+++ linux-2.6/drivers/lguest/interrupts_and_traps.c
@@ -222,11 +222,16 @@ bool check_syscall_vector(struct lguest
 int init_interrupts(void)
 {
 	/* If they want some strange system call vector, reserve it now */
-	if (syscall_vector != SYSCALL_VECTOR
-	    && test_and_set_bit(syscall_vector, used_vectors)) {
-		printk("lg: couldn't reserve syscall %u\n", syscall_vector);
-		return -EBUSY;
+	if (syscall_vector != SYSCALL_VECTOR) {
+		if (test_bit(syscall_vector, used_vectors) ||
+		    vector_used_by_percpu_irq(syscall_vector)) {
+			printk(KERN_ERR "lg: couldn't reserve syscall %u\n",
+				 syscall_vector);
+			return -EBUSY;
+		}
+		set_bit(syscall_vector, used_vectors);
 	}
+
 	return 0;
 }
 


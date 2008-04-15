Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbYDOUhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbYDOUhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbYDOUg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:36:58 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60858 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756279AbYDOUg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:36:57 -0400
Date: Tue, 15 Apr 2008 15:36:56 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
Message-ID: <Pine.SGI.3.96.1080415153530.8706317k-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.

From: Alan Mayer <ajm@sgi.com>

The SGI UV system needs several more system vectors than a vanilla
x86_64 system.  Rather than burden the other archs with extra system
vectors that they don't use, change FIRST_SYSTEM_VECTOR to a variable,
so that it can be dynamic.

Signed-off-by: Alan Mayer <ajm@sgi.com>

---
Index: ingo/arch/x86/kernel/i8259_64.c
===================================================================
--- ingo.orig/arch/x86/kernel/i8259_64.c	2008-04-10 13:24:30.000000000 -0500
+++ ingo/arch/x86/kernel/i8259_64.c	2008-04-10 13:57:33.000000000 -0500
@@ -479,33 +479,33 @@
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.
 	 */
-	set_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
+	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
 	/* IPIs for invalidation */
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
 
 	/* IPI for generic function call */
-	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 #endif
-	set_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
-	set_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
+	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
+	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 
 	/* self generated IPI for local APIC timer */
-	set_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
+	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
 	/* IPI vectors for APIC spurious and error interrupts */
-	set_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
-	set_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
+	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
Index: ingo/arch/x86/kernel/io_apic_64.c
===================================================================
--- ingo.orig/arch/x86/kernel/io_apic_64.c	2008-04-10 13:24:30.000000000 -0500
+++ ingo/arch/x86/kernel/io_apic_64.c	2008-04-10 13:57:33.000000000 -0500
@@ -82,6 +82,10 @@
 
 static int assign_irq_vector(int irq, cpumask_t mask);
 
+int first_system_vector = 0xfe;
+
+char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
+
 #define __apicdebuginit  __init
 
 int sis_apic_bug; /* not actually supported, dummy for compile */
@@ -717,7 +721,7 @@
 		offset = current_offset;
 next:
 		vector += 8;
-		if (vector >= FIRST_SYSTEM_VECTOR) {
+		if (vector >= first_system_vector) {
 			/* If we run out of vectors on large boxen, must share them. */
 			offset = (offset + 1) % 8;
 			vector = FIRST_DEVICE_VECTOR + offset;
Index: ingo/include/asm-x86/hw_irq_64.h
===================================================================
--- ingo.orig/include/asm-x86/hw_irq_64.h	2008-04-10 13:24:30.000000000 -0500
+++ ingo/include/asm-x86/hw_irq_64.h	2008-04-10 13:57:33.000000000 -0500
@@ -91,7 +91,6 @@
  * levels. (0x80 is the syscall vector)
  */
 #define FIRST_DEVICE_VECTOR	(IRQ15_VECTOR + 2)
-#define FIRST_SYSTEM_VECTOR	0xef   /* duplicated in irq.h */
 
 
 #ifndef __ASSEMBLY__
@@ -115,6 +114,8 @@
 void threshold_interrupt(void);
 void i8254_timer_resume(void);
 
+extern int first_system_vector;
+
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
 extern void __setup_vector_irq(int cpu);
Index: ingo/include/asm-x86/irq_64.h
===================================================================
--- ingo.orig/include/asm-x86/irq_64.h	2008-04-10 13:24:30.000000000 -0500
+++ ingo/include/asm-x86/irq_64.h	2008-04-10 13:57:33.000000000 -0500
@@ -31,7 +31,7 @@
  */
 #define NR_VECTORS 256
 
-#define FIRST_SYSTEM_VECTOR	0xef   /* duplicated in hw_irq.h */
+extern int first_system_vector;
 
 #if NR_CPUS < MAX_IO_APICS
 #define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
Index: ingo/arch/x86/kernel/io_apic_32.c
===================================================================
--- ingo.orig/arch/x86/kernel/io_apic_32.c	2008-04-10 13:24:30.000000000 -0500
+++ ingo/arch/x86/kernel/io_apic_32.c	2008-04-10 13:57:33.000000000 -0500
@@ -73,6 +73,10 @@
 
 static int disable_timer_pin_1 __initdata;
 
+int first_system_vector = 0xfe;
+
+char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
+
 /*
  * Rough estimation of how many shared IRQs there are, can
  * be changed anytime.
@@ -1166,7 +1170,7 @@
 	offset = current_offset;
 next:
 	vector += 8;
-	if (vector >= FIRST_SYSTEM_VECTOR) {
+	if (vector >= first_system_vector) {
 		offset = (offset + 1) % 8;
 		vector = FIRST_DEVICE_VECTOR + offset;
 	}
@@ -2263,7 +2267,7 @@
 	int i;
 
 	/* Reserve all the system vectors. */
-	for (i = FIRST_SYSTEM_VECTOR; i < NR_VECTORS; i++)
+	for (i = first_system_vector; i < NR_VECTORS; i++)
 		set_bit(i, used_vectors);
 
 	enable_IO_APIC();
Index: ingo/include/asm-x86/mach-default/irq_vectors.h
===================================================================
--- ingo.orig/include/asm-x86/mach-default/irq_vectors.h	2008-04-10 13:24:30.000000000 -0500
+++ ingo/include/asm-x86/mach-default/irq_vectors.h	2008-04-10 13:57:33.000000000 -0500
@@ -63,7 +63,6 @@
  * levels. (0x80 is the syscall vector)
  */
 #define FIRST_DEVICE_VECTOR	0x31
-#define FIRST_SYSTEM_VECTOR	0xef
 
 #define TIMER_IRQ 0
 
Index: ingo/include/asm-x86/mach-visws/irq_vectors.h
===================================================================
--- ingo.orig/include/asm-x86/mach-visws/irq_vectors.h	2008-04-10 13:24:30.000000000 -0500
+++ ingo/include/asm-x86/mach-visws/irq_vectors.h	2008-04-10 13:57:33.000000000 -0500
@@ -42,7 +42,6 @@
  * levels. (0x80 is the syscall vector)
  */
 #define FIRST_DEVICE_VECTOR	0x31
-#define FIRST_SYSTEM_VECTOR	0xef
 
 #define TIMER_IRQ 0
 
Index: ingo/arch/x86/kernel/apic_32.c
===================================================================
--- ingo.orig/arch/x86/kernel/apic_32.c	2008-04-10 13:24:30.000000000 -0500
+++ ingo/arch/x86/kernel/apic_32.c	2008-04-10 13:57:33.000000000 -0500
@@ -1353,13 +1353,13 @@
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.
 	 */
-	set_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
+	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
 	/* IPI for invalidation */
-	set_intr_gate(INVALIDATE_TLB_VECTOR, invalidate_interrupt);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR, invalidate_interrupt);
 
 	/* IPI for generic function call */
-	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 }
 #endif
 
@@ -1372,15 +1372,15 @@
 	smp_intr_init();
 #endif
 	/* self generated IPI for local APIC timer */
-	set_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
+	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
 	/* IPI vectors for APIC spurious and error interrupts */
-	set_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
-	set_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
+	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
 	/* thermal monitor LVT interrupt */
 #ifdef CONFIG_X86_MCE_P4THERMAL
-	set_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
+	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
 }
 
Index: ingo/include/asm-x86/desc.h
===================================================================
--- ingo.orig/include/asm-x86/desc.h	2008-04-10 13:48:58.000000000 -0500
+++ ingo/include/asm-x86/desc.h	2008-04-10 14:01:48.000000000 -0500
@@ -311,6 +311,28 @@
 	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);
 }
 
+#define SYS_VECTOR_FREE		0
+#define SYS_VECTOR_ALLOCED	1
+
+extern int first_system_vector;
+extern char system_vectors[];
+
+static inline void alloc_system_vector(int vector)
+{
+	if (system_vectors[vector] == SYS_VECTOR_FREE) {
+		system_vectors[vector] = SYS_VECTOR_ALLOCED;
+		if (first_system_vector > vector)
+			first_system_vector = vector;
+	} else
+		BUG();
+}
+
+static inline void alloc_intr_gate(unsigned int n, void *addr)
+{
+	alloc_system_vector(n);
+	set_intr_gate(n, addr);
+}
+
 /*
  * This routine sets up an interrupt gate at directory privilege level 3.
  */


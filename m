Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYDHVKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYDHVKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbYDHVKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:10:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37597 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752257AbYDHVKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:10:03 -0400
Date: Tue, 8 Apr 2008 16:10:02 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
Message-ID: <Pine.SGI.3.96.1080408160826.8706317D-100000@fergus.americas.sgi.com>
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
--- ingo.orig/arch/x86/kernel/i8259_64.c	2008-04-04 14:57:05.000000000 -0500
+++ ingo/arch/x86/kernel/i8259_64.c	2008-04-04 15:57:05.000000000 -0500
@@ -22,6 +22,7 @@
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
+#include <asm/genapic.h>
 
 /*
  * Common place to define all x86 IRQ vectors
@@ -456,6 +457,22 @@
 	}
 }
 
+#define SYS_VECTOR_FREE		0
+#define SYS_VECTOR_ALLOCED	1
+
+static char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
+
+static int alloc_system_vector(int vector)
+{
+	if (system_vectors[vector] == SYS_VECTOR_FREE) {
+		system_vectors[vector] = SYS_VECTOR_ALLOCED;
+		if (vector < first_system_vector)
+			first_system_vector = vector;
+		return vector;
+	} else
+		BUG();
+}
+
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
 void __init native_init_IRQ(void)
@@ -479,33 +496,37 @@
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.
 	 */
-	set_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
+	set_intr_gate(alloc_system_vector(RESCHEDULE_VECTOR), reschedule_interrupt);
 
 	/* IPIs for invalidation */
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
-	set_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
+	set_intr_gate(alloc_system_vector(INVALIDATE_TLB_VECTOR_START+0), invalidate_interrupt0);
+	set_intr_gate(alloc_system_vector(INVALIDATE_TLB_VECTOR_START+1), invalidate_interrupt1);
+	set_intr_gate(alloc_system_vector(INVALIDATE_TLB_VECTOR_START+2), invalidate_interrupt2);
+	set_intr_gate(alloc_system_vector(INVALIDATE_TLB_VECTOR_START+3), invalidate_interrupt3);
+	set_intr_gate(alloc_system_vector(INVALIDATE_TLB_VECTOR_START+4), invalidate_interrupt4);
+	set_intr_gate(alloc_system_vector(INVALIDATE_TLB_VECTOR_START+5), invalidate_interrupt5);
+	set_intr_gate(alloc_system_vector(INVALIDATE_TLB_VECTOR_START+6), invalidate_interrupt6);
+	set_intr_gate(alloc_system_vector(INVALIDATE_TLB_VECTOR_START+7), invalidate_interrupt7);
 
 	/* IPI for generic function call */
-	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+	set_intr_gate(alloc_system_vector(CALL_FUNCTION_VECTOR), call_function_interrupt);
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 #endif
-	set_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
-	set_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
+	set_intr_gate(alloc_system_vector(THERMAL_APIC_VECTOR), thermal_interrupt);
+	set_intr_gate(alloc_system_vector(THRESHOLD_APIC_VECTOR), threshold_interrupt);
 
 	/* self generated IPI for local APIC timer */
-	set_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
+	set_intr_gate(alloc_system_vector(LOCAL_TIMER_VECTOR), apic_timer_interrupt);
 
 	/* IPI vectors for APIC spurious and error interrupts */
-	set_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
-	set_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+	set_intr_gate(alloc_system_vector(SPURIOUS_APIC_VECTOR), spurious_interrupt);
+	set_intr_gate(alloc_system_vector(ERROR_APIC_VECTOR), error_interrupt);
+	if (is_uv_system() ) {
+		alloc_system_vector(XPC_ACTIVATE);
+		alloc_system_vector(XPC_NOTIFY);
+	}
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
Index: ingo/arch/x86/kernel/io_apic_64.c
===================================================================
--- ingo.orig/arch/x86/kernel/io_apic_64.c	2008-04-04 14:57:05.000000000 -0500
+++ ingo/arch/x86/kernel/io_apic_64.c	2008-04-04 15:57:37.000000000 -0500
@@ -82,6 +82,8 @@
 
 static int assign_irq_vector(int irq, cpumask_t mask);
 
+int first_system_vector = 0xfe;
+
 #define __apicdebuginit  __init
 
 int sis_apic_bug; /* not actually supported, dummy for compile */
@@ -717,7 +719,7 @@
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
--- ingo.orig/include/asm-x86/hw_irq_64.h	2008-04-04 14:59:42.000000000 -0500
+++ ingo/include/asm-x86/hw_irq_64.h	2008-04-04 15:58:05.000000000 -0500
@@ -85,13 +85,16 @@
  */
 #define LOCAL_TIMER_VECTOR	0xef
 
+#define XPC_ACTIVATE		0xee
+#define XPC_NOTIFY		0xed
+
+
 /*
  * First APIC vector available to drivers: (vectors 0x30-0xee)
  * we start at 0x41 to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
  */
 #define FIRST_DEVICE_VECTOR	(IRQ15_VECTOR + 2)
-#define FIRST_SYSTEM_VECTOR	0xef   /* duplicated in irq.h */
 
 
 #ifndef __ASSEMBLY__
@@ -115,6 +118,8 @@
 void threshold_interrupt(void);
 void i8254_timer_resume(void);
 
+extern int first_system_vector;
+
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
 extern void __setup_vector_irq(int cpu);
Index: ingo/include/asm-x86/irq_64.h
===================================================================
--- ingo.orig/include/asm-x86/irq_64.h	2008-04-04 14:59:42.000000000 -0500
+++ ingo/include/asm-x86/irq_64.h	2008-04-04 15:58:52.000000000 -0500
@@ -31,7 +31,7 @@
  */
 #define NR_VECTORS 256
 
-#define FIRST_SYSTEM_VECTOR	0xef   /* duplicated in hw_irq.h */
+extern int first_system_vector;
 
 #if NR_CPUS < MAX_IO_APICS
 #define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))


Return-Path: <linux-kernel-owner+w=401wt.eu-S933315AbXIUWtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbXIUWtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764020AbXIUWcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:40513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764099AbXIUWcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:46 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: rusty@rustcorp.com.au, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [44/50] i386: Introduce "used_vectors" bitmap which can be used to  reserve vectors.
Message-Id: <20070921223244.AC4B613DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

This simplifies the io_apic.c __assign_irq_vector() logic and removes
the explicit SYSCALL_VECTOR check, and also allows for vectors to be
reserved by other mechanisms (ie. lguest).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/i8259.c   |    3 ++-
 arch/i386/kernel/io_apic.c |   13 ++++++++-----
 arch/i386/kernel/traps.c   |   10 ++++++++++
 include/asm-i386/irq.h     |    3 +++
 4 files changed, 23 insertions(+), 6 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/i8259.c
===================================================================
--- linux.orig/arch/i386/kernel/i8259.c
+++ linux/arch/i386/kernel/i8259.c
@@ -400,7 +400,8 @@ void __init native_init_IRQ(void)
 		int vector = FIRST_EXTERNAL_VECTOR + i;
 		if (i >= NR_IRQS)
 			break;
-		if (vector != SYSCALL_VECTOR) 
+		/* SYSCALL_VECTOR was reserved in trap_init. */
+		if (!test_bit(vector, used_vectors))
 			set_intr_gate(vector, interrupt[i]);
 	}
 
Index: linux/arch/i386/kernel/io_apic.c
===================================================================
--- linux.orig/arch/i386/kernel/io_apic.c
+++ linux/arch/i386/kernel/io_apic.c
@@ -1198,7 +1198,7 @@ static u8 irq_vector[NR_IRQ_VECTORS] __r
 static int __assign_irq_vector(int irq)
 {
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
-	int vector, offset, i;
+	int vector, offset;
 
 	BUG_ON((unsigned)irq >= NR_IRQ_VECTORS);
 
@@ -1215,11 +1215,8 @@ next:
 	}
 	if (vector == current_vector)
 		return -ENOSPC;
-	if (vector == SYSCALL_VECTOR)
+	if (test_and_set_bit(vector, used_vectors))
 		goto next;
-	for (i = 0; i < NR_IRQ_VECTORS; i++)
-		if (irq_vector[i] == vector)
-			goto next;
 
 	current_vector = vector;
 	current_offset = offset;
@@ -2290,6 +2287,12 @@ static inline void __init check_timer(vo
 
 void __init setup_IO_APIC(void)
 {
+	int i;
+
+	/* Reserve all the system vectors. */
+	for (i = FIRST_SYSTEM_VECTOR; i < NR_VECTORS; i++)
+		set_bit(i, used_vectors);
+
 	enable_IO_APIC();
 
 	if (acpi_ioapic)
Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -65,6 +65,9 @@
 
 int panic_on_unrecovered_nmi;
 
+DECLARE_BITMAP(used_vectors, NR_VECTORS);
+EXPORT_SYMBOL_GPL(used_vectors);
+
 asmlinkage int system_call(void);
 
 /* Do we ignore FPU interrupts ? */
@@ -1217,6 +1220,8 @@ static void __init set_task_gate(unsigne
 
 void __init trap_init(void)
 {
+	int i;
+
 #ifdef CONFIG_EISA
 	void __iomem *p = ioremap(0x0FFFD9, 4);
 	if (readl(p) == 'E'+('I'<<8)+('S'<<16)+('A'<<24)) {
@@ -1276,6 +1281,11 @@ void __init trap_init(void)
 
 	set_system_gate(SYSCALL_VECTOR,&system_call);
 
+	/* Reserve all the builtin and the syscall vector. */
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
+		set_bit(i, used_vectors);
+	set_bit(SYSCALL_VECTOR, used_vectors);
+
 	/*
 	 * Should be a barrier for any external CPU state.
 	 */
Index: linux/include/asm-i386/irq.h
===================================================================
--- linux.orig/include/asm-i386/irq.h
+++ linux/include/asm-i386/irq.h
@@ -45,4 +45,7 @@ unsigned int do_IRQ(struct pt_regs *regs
 void init_IRQ(void);
 void __init native_init_IRQ(void);
 
+/* Interrupt vector management */
+extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
+
 #endif /* _ASM_IRQ_H */

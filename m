Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbXINFPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbXINFPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 01:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXINFOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 01:14:53 -0400
Received: from ozlabs.org ([203.10.76.45]:34009 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbXINFOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 01:14:53 -0400
Subject: [PATCH] Introduce "used_vectors" bitmap which can be used to
	reserve vectors.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 15:14:09 +1000
Message-Id: <1189746849.7262.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi and everyone,

	Wanted to get your thoughts on this patch.  lguest now supports plan9
guests which use 0x40 for system calls.  We want to let the guests use
that vector if available, but have no way to stop io_apic from
clobbering it.  This does that, and also simplifies the current code a
little.

Thanks,
Rusty.

This simplifies the io_apic.c __assign_irq_vector() logic and removes
the explicit SYSCALL_VECTOR check, and also allows for vectors to be
reserved by other mechanisms (ie. lguest).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 arch/i386/kernel/i8259.c   |    3 ++-
 arch/i386/kernel/io_apic.c |   13 ++++++++-----
 arch/i386/kernel/traps.c   |   10 ++++++++++
 include/asm-i386/irq.h     |    3 +++
 4 files changed, 23 insertions(+), 6 deletions(-)

===================================================================
--- a/arch/i386/kernel/i8259.c
+++ b/arch/i386/kernel/i8259.c
@@ -400,7 +400,8 @@ void __init native_init_IRQ(void)
 		int vector = FIRST_EXTERNAL_VECTOR + i;
 		if (i >= NR_IRQS)
 			break;
-		if (vector != SYSCALL_VECTOR) 
+		/* SYSCALL_VECTOR was reserved in trap_init. */
+		if (!test_bit(vector, used_vectors))
 			set_intr_gate(vector, interrupt[i]);
 	}
 
===================================================================
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -1198,7 +1198,7 @@ static int __assign_irq_vector(int irq)
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
===================================================================
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -64,6 +64,9 @@
 #include "mach_traps.h"
 
 int panic_on_unrecovered_nmi;
+
+DECLARE_BITMAP(used_vectors, NR_VECTORS);
+EXPORT_SYMBOL_GPL(used_vectors);
 
 asmlinkage int system_call(void);
 
@@ -1156,6 +1159,8 @@ static void __init set_task_gate(unsigne
 
 void __init trap_init(void)
 {
+	int i;
+
 #ifdef CONFIG_EISA
 	void __iomem *p = ioremap(0x0FFFD9, 4);
 	if (readl(p) == 'E'+('I'<<8)+('S'<<16)+('A'<<24)) {
@@ -1215,6 +1220,11 @@ void __init trap_init(void)
 
 	set_system_gate(SYSCALL_VECTOR,&system_call);
 
+	/* Reserve all the builtin and the syscall vector. */
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
+		set_bit(i, used_vectors);
+	set_bit(SYSCALL_VECTOR, used_vectors);
+
 	/*
 	 * Should be a barrier for any external CPU state.
 	 */
===================================================================
--- a/include/asm-i386/irq.h
+++ b/include/asm-i386/irq.h
@@ -45,4 +45,7 @@ void init_IRQ(void);
 void init_IRQ(void);
 void __init native_init_IRQ(void);
 
+/* Interrupt vector management */
+extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
+
 #endif /* _ASM_IRQ_H */



Return-Path: <linux-kernel-owner+w=401wt.eu-S932788AbXJQK51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbXJQK51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 06:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbXJQK5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 06:57:20 -0400
Received: from ozlabs.org ([203.10.76.45]:37453 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759090AbXJQK5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 06:57:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/5] Introduce "used_vectors" bitmap which can be used to reserve vectors.
Date: Wed, 17 Oct 2007 20:56:04 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200710172046.55454.rusty@rustcorp.com.au> <200710172052.47230.rusty@rustcorp.com.au> <200710172054.45652.rusty@rustcorp.com.au>
In-Reply-To: <200710172054.45652.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710172056.05123.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies the io_apic.c __assign_irq_vector() logic and removes
the explicit SYSCALL_VECTOR check, and also allows for vectors to be
reserved by other mechanisms (ie. lguest).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>
---
 arch/x86/kernel/i8259_32.c   |    3 ++-
 arch/x86/kernel/io_apic_32.c |   13 ++++++++-----
 arch/x86/kernel/traps_32.c   |   10 ++++++++++
 include/asm-x86/irq_32.h     |    3 +++
 4 files changed, 23 insertions(+), 6 deletions(-)

===================================================================
--- a/arch/x86/kernel/i8259_32.c
+++ b/arch/x86/kernel/i8259_32.c
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
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
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
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
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
--- a/include/asm-x86/irq_32.h
+++ b/include/asm-x86/irq_32.h
@@ -45,4 +45,7 @@ void init_IRQ(void);
 void init_IRQ(void);
 void __init native_init_IRQ(void);
 
+/* Interrupt vector management */
+extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
+
 #endif /* _ASM_IRQ_H */

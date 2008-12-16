Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbYLPUfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbYLPUfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYLPUe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:34:59 -0500
Received: from gw.goop.org ([64.81.55.164]:58029 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbYLPUe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:34:58 -0500
Message-ID: <494810F0.1010101@goop.org>
Date: Tue, 16 Dec 2008 12:34:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: add handle_irq() to allow interrupt injection
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen uses a different interrupt path, so introduce handle_irq() to
allow interrupts to be inserted into the normal interrupt path.  This
is handled slightly differently on 32 and 64-bit.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/irq.h |    1 +
 arch/x86/kernel/irq_32.c   |   34 +++++++++++++++++++++-------------
 arch/x86/kernel/irq_64.c   |   23 ++++++++++++++++-------
 3 files changed, 38 insertions(+), 20 deletions(-)

===================================================================
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -39,6 +39,7 @@
 extern unsigned int do_IRQ(struct pt_regs *regs);
 extern void init_IRQ(void);
 extern void native_init_IRQ(void);
+extern bool handle_irq(unsigned irq, struct pt_regs *regs);
 
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
===================================================================
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -191,6 +191,26 @@
 execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq) { return 0; }
 #endif
 
+bool handle_irq(unsigned irq, struct pt_regs *regs)
+{
+	struct irq_desc *desc;
+	int overflow;
+
+	overflow = check_stack_overflow();
+
+	desc = irq_to_desc(irq);
+	if (unlikely(!desc))
+		return false;
+
+	if (!execute_on_irq_stack(overflow, desc, irq)) {
+		if (unlikely(overflow))
+			print_stack_overflow();
+		desc->handle_irq(irq, desc);
+	}
+
+	return true;
+}
+
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
@@ -200,31 +220,19 @@
 {
 	struct pt_regs *old_regs;
 	/* high bit used in ret_from_ code */
-	int overflow;
 	unsigned vector = ~regs->orig_ax;
-	struct irq_desc *desc;
 	unsigned irq;
 
-
 	old_regs = set_irq_regs(regs);
 	irq_enter();
 	irq = __get_cpu_var(vector_irq)[vector];
 
-	overflow = check_stack_overflow();
-
-	desc = irq_to_desc(irq);
-	if (unlikely(!desc)) {
+	if (!handle_irq(irq, regs)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d vector %#x cpu %d\n",
 					__func__, irq, vector, smp_processor_id());
 		BUG();
 	}
 
-	if (!execute_on_irq_stack(overflow, desc, irq)) {
-		if (unlikely(overflow))
-			print_stack_overflow();
-		desc->handle_irq(irq, desc);
-	}
-
 	irq_exit();
 	set_irq_regs(old_regs);
 	return 1;
===================================================================
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -40,6 +40,20 @@
 #endif
 }
 
+bool handle_irq(unsigned irq, struct pt_regs *regs)
+{
+	struct irq_desc *desc;
+
+	stack_overflow_check(regs);
+
+	desc = irq_to_desc(irq);
+	if (unlikely(!desc))
+		return false;
+
+	generic_handle_irq_desc(irq, desc);
+	return true;
+}
+
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
@@ -48,7 +62,6 @@
 asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct irq_desc *desc;
 
 	/* high bit used in ret_from_ code  */
 	unsigned vector = ~regs->orig_ax;
@@ -56,14 +69,10 @@
 
 	exit_idle();
 	irq_enter();
+
 	irq = __get_cpu_var(vector_irq)[vector];
 
-	stack_overflow_check(regs);
-
-	desc = irq_to_desc(irq);
-	if (likely(desc))
-		generic_handle_irq_desc(irq, desc);
-	else {
+	if (!handle_irq(irq, regs)) {
 		if (!disable_apic)
 			ack_APIC_irq();
 



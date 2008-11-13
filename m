Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbYKMTi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbYKMTi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYKMTeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:15 -0500
Received: from gw.goop.org ([64.81.55.164]:34398 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbYKMTeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:05 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 10 of 38] x86: add handle_irq() to allow interrupt injection
X-Mercurial-Node: e23d74964d85e788d4c677d87fd1b67c88325f47
Message-Id: <e23d74964d85e788d4c6.1226603408@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
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
 arch/x86/kernel/irq_64.c   |   27 ++++++++++++++++++---------
 3 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -39,6 +39,7 @@
 extern unsigned int do_IRQ(struct pt_regs *regs);
 extern void init_IRQ(void);
 extern void native_init_IRQ(void);
+extern bool handle_irq(unsigned irq, struct pt_regs *regs);
 
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
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
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -42,6 +42,22 @@
 }
 #endif
 
+bool handle_irq(unsigned irq, struct pt_regs *regs)
+{
+	struct irq_desc *desc;
+
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	stack_overflow_check(regs);
+#endif
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
@@ -50,7 +66,6 @@
 asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct irq_desc *desc;
 
 	/* high bit used in ret_from_ code  */
 	unsigned vector = ~regs->orig_ax;
@@ -58,16 +73,10 @@
 
 	exit_idle();
 	irq_enter();
+
 	irq = __get_cpu_var(vector_irq)[vector];
 
-#ifdef CONFIG_DEBUG_STACKOVERFLOW
-	stack_overflow_check(regs);
-#endif
-
-	desc = irq_to_desc(irq);
-	if (likely(desc))
-		generic_handle_irq_desc(irq, desc);
-	else {
+	if (!handle_irq(irq, regs)) {
 		if (!disable_apic)
 			ack_APIC_irq();
 



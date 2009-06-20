Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbZFTSqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbZFTSqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbZFTSpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:45:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48024 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310AbZFTSpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:45:38 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 05/25] Blackfin: redo handling of bad irqs
Date: Sat, 20 Jun 2009 14:44:28 -0400
Message-Id: <1245523488-26536-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the common IRQ code initializing much more of the irq_desc state, we
can't blindly initialize it ourselves to the local bad_irq state.  If we
do, we end up wrongly clobbering many fields.  So punt most of the bad irq
code as the common layers will handle the default state, and simply call
handle_bad_irq() directly when the IRQ we are processing is invalid.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/irqchip.c |   53 ++++++++-------------------------------
 1 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 6e31e93..36bba30 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -38,38 +38,15 @@
 #include <asm/pda.h>
 
 static atomic_t irq_err_count;
-static spinlock_t irq_controller_lock;
-
-/*
- * Dummy mask/unmask handler
- */
-void dummy_mask_unmask_irq(unsigned int irq)
-{
-}
-
 void ack_bad_irq(unsigned int irq)
 {
 	atomic_inc(&irq_err_count);
 	printk(KERN_ERR "IRQ: spurious interrupt %d\n", irq);
 }
 
-static struct irq_chip bad_chip = {
-	.ack = dummy_mask_unmask_irq,
-	.mask = dummy_mask_unmask_irq,
-	.unmask = dummy_mask_unmask_irq,
-};
-
-static int bad_stats;
 static struct irq_desc bad_irq_desc = {
-	.status = IRQ_DISABLED,
-	.chip = &bad_chip,
 	.handle_irq = handle_bad_irq,
-	.depth = 1,
 	.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
-	.kstat_irqs = &bad_stats,
-#ifdef CONFIG_SMP
-	.affinity = CPU_MASK_ALL
-#endif
 };
 
 #ifdef CONFIG_CPUMASK_OFFSTACK
@@ -119,21 +96,13 @@ __attribute__((l1_text))
 #endif
 asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 {
-	struct pt_regs *old_regs;
-	struct irq_desc *desc = irq_desc + irq;
 #ifndef CONFIG_IPIPE
 	unsigned short pending, other_ints;
 #endif
-	old_regs = set_irq_regs(regs);
-
-	/*
-	 * Some hardware gives randomly wrong interrupts.  Rather
-	 * than crashing, do something sensible.
-	 */
-	if (irq >= NR_IRQS)
-		desc = &bad_irq_desc;
+	struct pt_regs *old_regs = set_irq_regs(regs);
 
 	irq_enter();
+
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	/* Debugging check for stack overflow: is there less than STACK_WARN free? */
 	{
@@ -149,7 +118,15 @@ asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 		}
 	}
 #endif
-	generic_handle_irq(irq);
+
+	/*
+	 * Some hardware gives randomly wrong interrupts.  Rather
+	 * than crashing, do something sensible.
+	 */
+	if (irq >= NR_IRQS)
+		handle_bad_irq(irq, &bad_irq_desc);
+	else
+		generic_handle_irq(irq);
 
 #ifndef CONFIG_IPIPE
 	/*
@@ -173,14 +150,6 @@ asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 
 void __init init_IRQ(void)
 {
-	struct irq_desc *desc;
-	int irq;
-
-	spin_lock_init(&irq_controller_lock);
-	for (irq = 0, desc = irq_desc; irq < NR_IRQS; irq++, desc++) {
-		*desc = bad_irq_desc;
-	}
-
 	init_arch_irq();
 
 #ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
-- 
1.6.3.1


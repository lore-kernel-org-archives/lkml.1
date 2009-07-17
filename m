Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZGQUXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZGQUXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZGQUTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:42 -0400
Received: from kroah.org ([198.145.64.141]:43083 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbZGQUTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:30 2009
Message-Id: <20090717201229.825396140@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:08:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Frysinger <vapier@gentoo.org>
Subject: [patch 06/24] Blackfin: redo handling of bad irqs
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=blackfin-redo-handling-of-bad-irqs.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 26579216f3cdf1ae05f0af8412b444870a167510 upstream.

With the common IRQ code initializing much more of the irq_desc state, we
can't blindly initialize it ourselves to the local bad_irq state.  If we
do, we end up wrongly clobbering many fields.  So punt most of the bad irq
code as the common layers will handle the default state, and simply call
handle_bad_irq() directly when the IRQ we are processing is invalid.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/blackfin/kernel/irqchip.c |   50 +++++++++--------------------------------
 1 file changed, 11 insertions(+), 39 deletions(-)

--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -38,14 +38,6 @@
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
 
 void ack_bad_irq(unsigned int irq)
 {
@@ -53,21 +45,9 @@ void ack_bad_irq(unsigned int irq)
 	printk(KERN_ERR "IRQ: spurious interrupt %d\n", irq);
 }
 
-static struct irq_chip bad_chip = {
-	.ack = dummy_mask_unmask_irq,
-	.mask = dummy_mask_unmask_irq,
-	.unmask = dummy_mask_unmask_irq,
-};
-
 static struct irq_desc bad_irq_desc = {
-	.status = IRQ_DISABLED,
-	.chip = &bad_chip,
 	.handle_irq = handle_bad_irq,
-	.depth = 1,
 	.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
-#ifdef CONFIG_SMP
-	.affinity = CPU_MASK_ALL
-#endif
 };
 
 #ifdef CONFIG_CPUMASK_OFFSTACK
@@ -117,21 +97,13 @@ __attribute__((l1_text))
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
@@ -147,7 +119,15 @@ asmlinkage void asm_do_IRQ(unsigned int 
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
@@ -171,14 +151,6 @@ asmlinkage void asm_do_IRQ(unsigned int 
 
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



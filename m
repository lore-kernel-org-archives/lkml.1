Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbYGKPL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbYGKPL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYGKPLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:11:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44571 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYGKPLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:11:15 -0400
Date: Fri, 11 Jul 2008 09:10:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com
Subject: Re: Multiple MSI, take 3
Message-ID: <20080711151058.GU14894@parisc-linux.org>
References: <20080711005719.GO14894@parisc-linux.org> <m1iqvc91li.fsf@frodo.ebiederm.org> <20080711102326.GR14894@parisc-linux.org> <m1iqvc7iys.fsf@frodo.ebiederm.org> <20080711121744.GT14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711121744.GT14894@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 06:17:44AM -0600, Matthew Wilcox wrote:
> On Fri, Jul 11, 2008 at 04:34:19AM -0700, Eric W. Biederman wrote:
> > There is one idea that seems to model this cleanly
> > without breaking all kinds of expectations.
> > 
> > That is an irq with a very small data payload.
> > 
> > In that case we wire all of the vectors up to a single
> > irq handler that computes the payload as:
> > payload = vector - base-vector.
> > 
> > And then we figure out how to pass that to the handler in irqaction.
> > 
> > To most of the system it is a single irq so it avoids breaking
> > expectations about what an irq is.
> > 
> > To everything else it is a little odd, and has it's own unique
> > set of rules (which is good as well).

Having implemented this, I wish to retract my earlier statement:

> I think rather than passing the 'vector - base_vector' integer, the
> request_irq_block() should pass in an array of pointers as large as nvec
> and irqaction passes the appropriate pointer to the handler.

That idea requires a lot of mucking with generic_IRQ_handle, which I'm
not willing to do.  Anyone have any problems with the below patch?

I've not implemented the corresponding bit in io_apic_64.c yet, so
completely untested.

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 3aac154..a5d79e9 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -173,7 +173,7 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 	stack_overflow_check(regs);
 #endif
 
-	if (likely(irq < NR_IRQS))
+	if (likely((irq & ARCH_IRQ_DATA_MASK) < NR_IRQS))
 		generic_handle_irq(irq);
 	else {
 		if (!disable_apic)
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 552e0ec..19c679c 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -282,6 +282,19 @@ extern unsigned int __do_IRQ(unsigned int irq);
 #endif
 
 /*
+ * For multiple MSI, we allow a small amount of data to be passed to
+ * the interrupt handler to determine which vector was called.  MSI
+ * only allows 32 interrupts, so we default to requiring 5 bits of
+ * information to be passed.  If your arch has NR_IRQS set higher than
+ * 2^27, you have some extremely large arrays and probably want to consider
+ * defining ARCH_IRQ_DATA_SHIFT and ARCH_IRQ_DATA_MASK.
+ */
+#ifndef ARCH_IRQ_DATA_SHIFT
+#define ARCH_IRQ_DATA_SHIFT 27
+#define ARCH_IRQ_DATA_MASK ((1 << ARCH_IRQ_DATA_SHIFT) - 1)
+#endif
+
+/*
  * Architectures call this to let the generic IRQ layer
  * handle an interrupt. If the descriptor is attached to an
  * irqchip-style controller then we call the ->handle_irq() handler,
@@ -289,7 +302,7 @@ extern unsigned int __do_IRQ(unsigned int irq);
  */
 static inline void generic_handle_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc + (irq & ARCH_IRQ_DATA_MASK);
 
 #ifdef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
 	desc->handle_irq(irq, desc);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 5fa6198..86ff1ab 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -126,7 +126,7 @@ irqreturn_t no_action(int cpl, void *dev_id)
  *
  * Handles the action chain of an irq event
  */
-irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
+irqreturn_t handle_IRQ_event(unsigned int irq_plus_data, struct irqaction *action)
 {
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
@@ -137,7 +137,7 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 		local_irq_enable_in_hardirq();
 
 	do {
-		ret = action->handler(irq, action->dev_id);
+		ret = action->handler(irq_plus_data, action->dev_id);
 		if (ret == IRQ_HANDLED)
 			status |= action->flags;
 		retval |= ret;
@@ -163,15 +163,16 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
  * This is the original x86 implementation which is used for every
  * interrupt type.
  */
-unsigned int __do_IRQ(unsigned int irq)
+unsigned int __do_IRQ(unsigned int irq_plus_data)
 {
+	unsigned int irq = irq_plus_data & ARCH_IRQ_DATA_MASK;
 	struct irq_desc *desc = irq_desc + irq;
 	struct irqaction *action;
 	unsigned int status;
 
 	kstat_this_cpu.irqs[irq]++;
 	if (CHECK_IRQ_PER_CPU(desc->status)) {
-		irqreturn_t action_ret;
+		irqreturn_t ret;
 
 		/*
 		 * No locking required for CPU-local interrupts:
@@ -179,9 +180,9 @@ unsigned int __do_IRQ(unsigned int irq)
 		if (desc->chip->ack)
 			desc->chip->ack(irq);
 		if (likely(!(desc->status & IRQ_DISABLED))) {
-			action_ret = handle_IRQ_event(irq, desc->action);
+			ret = handle_IRQ_event(irq_plus_data, desc->action);
 			if (!noirqdebug)
-				note_interrupt(irq, desc, action_ret);
+				note_interrupt(irq, desc, ret);
 		}
 		desc->chip->end(irq);
 		return 1;
@@ -233,7 +234,7 @@ unsigned int __do_IRQ(unsigned int irq)
 
 		spin_unlock(&desc->lock);
 
-		action_ret = handle_IRQ_event(irq, action);
+		action_ret = handle_IRQ_event(irq_plus_data, action);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
 

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

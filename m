Return-Path: <linux-kernel-owner+w=401wt.eu-S932686AbYARW3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbYARW3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763035AbYARW3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:29:06 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:46066 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762421AbYARW3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:29:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DENB2QXUm2kAmT669Hq9s5a8oHUpwBN3bW2Wkup5vZTC0mK8JNOX0f3bbBepbhIndjXln3xnI7ggN8eig2pY6JO2rHJE7XZp6EgjjG3Vja1w9pRvzRnnx1tdqTKuNA/V+eDFEQ4I19t1OVBdDunnXgIORlUFMN7GTdTISxuMEPw=  ;
X-YMail-OSG: YU3YrIIVM1lq41NEi6k0QWcpLQxeWy7.cP7T8JgmblC2u82KSvhxVf0J4Gp3WjY_MIudfP.XKg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch/rfc 2.6.24-rc8-git] genirq: partial lockdep fixes
Date: Fri, 18 Jan 2008 14:29:00 -0800
User-Agent: KMail/1.9.6
Cc: peterz@infradead.org, mingo@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181429.00485.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPERIMENTAL and incomplete patch to make LOCKDEP behave better in
the face of irq chaining, by annotating irqs with a lock_class which
can reflect that hierarchy.

This version of the patch is incomplete in at least two respects:

 - There's no spin_lock_irq_nested() primitive, so that locking calls
   on irq probing (yeech!) paths must ignore the annotations.

	==> LOCKDEP feature is evidently missing:
		spin_lock_irq_nested(lock_ptr, lock_class)

 - We'd really need new API to declare the parent/child relationships
   between IRQs to handle this properly.  Lacking such calls, this just
   piggybacks set_irq_chained_handler() to modify the parent's class.
   That's a problem, since only the lowest level of any lock tree gets
   accurate nesting annotations.  On the plus side: no platform changes
   are needed this way, so testing is easy.

	==> GENIRQ programming interface evidently missing
		set_irq_parent(parent_irqnum, child_irqnum) (?)

Example:  when a GPIO controller's set_wake() handler needs to call its
parent's set_irq_wake() method to ensure all appropriate signal paths are
set up, that currently generates a bogus lockdep warning.  This patch
removes those bogus warnings ... when there's only one level of parent.

---
 include/linux/irq.h    |    3 +++
 kernel/irq/autoprobe.c |    5 +++++
 kernel/irq/chip.c      |   44 ++++++++++++++++++++++++++++----------------
 kernel/irq/handle.c    |    4 ++--
 kernel/irq/manage.c    |   12 ++++++------
 kernel/irq/migration.c |    2 +-
 kernel/irq/proc.c      |    2 +-
 kernel/irq/spurious.c  |    6 +++---
 8 files changed, 49 insertions(+), 29 deletions(-)

--- a/include/linux/irq.h	2008-01-17 22:25:53.000000000 -0800
+++ b/include/linux/irq.h	2008-01-18 00:08:57.000000000 -0800
@@ -164,6 +164,9 @@ struct irq_desc {
 	unsigned int		irqs_unhandled;
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	spinlock_t		lock;
+#ifdef CONFIG_LOCKDEP
+	unsigned int		lock_class;	/* for chained irqs */
+#endif
 #ifdef CONFIG_SMP
 	cpumask_t		affinity;
 	unsigned int		cpu;
--- a/kernel/irq/autoprobe.c	2008-01-17 22:25:53.000000000 -0800
+++ b/kernel/irq/autoprobe.c	2008-01-18 00:08:57.000000000 -0800
@@ -41,6 +41,7 @@ unsigned long probe_irq_on(void)
 	for (i = NR_IRQS-1; i > 0; i--) {
 		desc = irq_desc + i;
 
+/* FIXME nested */
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			/*
@@ -71,6 +72,7 @@ unsigned long probe_irq_on(void)
 	for (i = NR_IRQS-1; i > 0; i--) {
 		desc = irq_desc + i;
 
+/* FIXME nested */
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
@@ -93,6 +95,7 @@ unsigned long probe_irq_on(void)
 		unsigned int status;
 
 		desc = irq_desc + i;
+/* FIXME nested */
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -134,6 +137,7 @@ unsigned int probe_irq_mask(unsigned lon
 		struct irq_desc *desc = irq_desc + i;
 		unsigned int status;
 
+/* FIXME nested */
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -177,6 +181,7 @@ int probe_irq_off(unsigned long val)
 		struct irq_desc *desc = irq_desc + i;
 		unsigned int status;
 
+/* FIXME nested */
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
--- a/kernel/irq/chip.c	2008-01-17 22:25:52.000000000 -0800
+++ b/kernel/irq/chip.c	2008-01-18 14:20:21.000000000 -0800
@@ -35,7 +35,7 @@ void dynamic_irq_init(unsigned int irq)
 
 	/* Ensure we don't have left over values from a previous use of this irq */
 	desc = irq_desc + irq;
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	desc->status = IRQ_DISABLED;
 	desc->chip = &no_irq_chip;
 	desc->handle_irq = handle_bad_irq;
@@ -68,7 +68,7 @@ void dynamic_irq_cleanup(unsigned int ir
 	}
 
 	desc = irq_desc + irq;
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	if (desc->action) {
 		spin_unlock_irqrestore(&desc->lock, flags);
 		printk(KERN_ERR "Destroying IRQ%d without calling free_irq\n",
@@ -105,7 +105,7 @@ int set_irq_chip(unsigned int irq, struc
 		chip = &no_irq_chip;
 
 	desc = irq_desc + irq;
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	irq_chip_set_defaults(chip);
 	desc->chip = chip;
 	spin_unlock_irqrestore(&desc->lock, flags);
@@ -132,7 +132,7 @@ int set_irq_type(unsigned int irq, unsig
 
 	desc = irq_desc + irq;
 	if (desc->chip->set_type) {
-		spin_lock_irqsave(&desc->lock, flags);
+		spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 		ret = desc->chip->set_type(irq, type);
 		spin_unlock_irqrestore(&desc->lock, flags);
 	}
@@ -159,7 +159,7 @@ int set_irq_data(unsigned int irq, void 
 	}
 
 	desc = irq_desc + irq;
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	desc->handler_data = data;
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
@@ -184,7 +184,7 @@ int set_irq_msi(unsigned int irq, struct
 		return -EINVAL;
 	}
 	desc = irq_desc + irq;
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	desc->msi_desc = entry;
 	if (entry)
 		entry->irq = irq;
@@ -209,7 +209,7 @@ int set_irq_chip_data(unsigned int irq, 
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	desc->chip_data = data;
 	spin_unlock_irqrestore(&desc->lock, flags);
 
@@ -293,7 +293,7 @@ handle_simple_irq(unsigned int irq, stru
 	irqreturn_t action_ret;
 	const unsigned int cpu = smp_processor_id();
 
-	spin_lock(&desc->lock);
+	spin_lock_nested(&desc->lock, desc->lock_class);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -311,7 +311,7 @@ handle_simple_irq(unsigned int irq, stru
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	spin_lock(&desc->lock);
+	spin_lock_nested(&desc->lock, desc->lock_class);
 	desc->status &= ~IRQ_INPROGRESS;
 out_unlock:
 	spin_unlock(&desc->lock);
@@ -334,7 +334,7 @@ handle_level_irq(unsigned int irq, struc
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
-	spin_lock(&desc->lock);
+	spin_lock_nested(&desc->lock, desc->lock_class);
 	mask_ack_irq(desc, irq);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
@@ -357,7 +357,7 @@ handle_level_irq(unsigned int irq, struc
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	spin_lock(&desc->lock);
+	spin_lock_nested(&desc->lock, desc->lock_class);
 	desc->status &= ~IRQ_INPROGRESS;
 	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
 		desc->chip->unmask(irq);
@@ -382,7 +382,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
-	spin_lock(&desc->lock);
+	spin_lock_nested(&desc->lock, desc->lock_class);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out;
@@ -410,7 +410,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	spin_lock(&desc->lock);
+	spin_lock_nested(&desc->lock, desc->lock_class);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
 	desc->chip->eoi(irq);
@@ -439,7 +439,7 @@ handle_edge_irq(unsigned int irq, struct
 {
 	const unsigned int cpu = smp_processor_id();
 
-	spin_lock(&desc->lock);
+	spin_lock_nested(&desc->lock, desc->lock_class);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 
@@ -489,7 +489,7 @@ handle_edge_irq(unsigned int irq, struct
 		action_ret = handle_IRQ_event(irq, action);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
-		spin_lock(&desc->lock);
+		spin_lock_nested(&desc->lock, desc->lock_class);
 
 	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
 
@@ -553,7 +553,7 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->chip = &dummy_irq_chip;
 	}
 
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
@@ -570,6 +570,18 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 		desc->depth = 0;
 		desc->chip->unmask(irq);
+
+#ifdef CONFIG_LOCKDEP
+		/* REVISIT this only handles a single level of chaining.
+		 * A better solution would use a new interface setting
+		 * the child's lock_class to one more than the parent's;
+		 * but genirq doesn't currently link parents to children.
+		 *
+		 * REVISIT should this even work?  We already grabbed the
+		 * lock with the wrong class annotation, above...
+		 */
+		desc->lock_class++;
+#endif
 	}
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
--- a/kernel/irq/handle.c	2008-01-17 22:25:52.000000000 -0800
+++ b/kernel/irq/handle.c	2008-01-18 00:08:57.000000000 -0800
@@ -187,7 +187,7 @@ fastcall unsigned int __do_IRQ(unsigned 
 		return 1;
 	}
 
-	spin_lock(&desc->lock);
+	spin_lock_nested(&desc->lock, desc->lock_class);
 	if (desc->chip->ack)
 		desc->chip->ack(irq);
 	/*
@@ -237,7 +237,7 @@ fastcall unsigned int __do_IRQ(unsigned 
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
 
-		spin_lock(&desc->lock);
+		spin_lock_nested(&desc->lock, desc->lock_class);
 		if (likely(!(desc->status & IRQ_PENDING)))
 			break;
 		desc->status &= ~IRQ_PENDING;
--- a/kernel/irq/manage.c	2008-01-17 22:25:52.000000000 -0800
+++ b/kernel/irq/manage.c	2008-01-18 00:08:57.000000000 -0800
@@ -45,7 +45,7 @@ void synchronize_irq(unsigned int irq)
 			cpu_relax();
 
 		/* Ok, that indicated we're done: double-check carefully. */
-		spin_lock_irqsave(&desc->lock, flags);
+		spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 		status = desc->status;
 		spin_unlock_irqrestore(&desc->lock, flags);
 
@@ -115,7 +115,7 @@ void disable_irq_nosync(unsigned int irq
 	if (irq >= NR_IRQS)
 		return;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
 		desc->chip->disable(irq);
@@ -167,7 +167,7 @@ void enable_irq(unsigned int irq)
 	if (irq >= NR_IRQS)
 		return;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	switch (desc->depth) {
 	case 0:
 		printk(KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
@@ -210,7 +210,7 @@ int set_irq_wake(unsigned int irq, unsig
 	/* wakeup-capable irqs can be shared between drivers that
 	 * don't need to have the same sleep mode behaviors.
 	 */
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	if (on) {
 		if (desc->wake_depth++ == 0)
 			desc->status |= IRQ_WAKEUP;
@@ -301,7 +301,7 @@ int setup_irq(unsigned int irq, struct i
 	/*
 	 * The following block of code has to be executed atomically
 	 */
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	p = &desc->action;
 	old = *p;
 	if (old) {
@@ -427,7 +427,7 @@ void free_irq(unsigned int irq, void *de
 		return;
 
 	desc = irq_desc + irq;
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	p = &desc->action;
 	for (;;) {
 		struct irqaction *action = *p;
--- a/kernel/irq/migration.c	2008-01-17 22:25:53.000000000 -0800
+++ b/kernel/irq/migration.c	2008-01-18 00:08:57.000000000 -0800
@@ -6,7 +6,7 @@ void set_pending_irq(unsigned int irq, c
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned long flags;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	desc->status |= IRQ_MOVE_PENDING;
 	irq_desc[irq].pending_mask = mask;
 	spin_unlock_irqrestore(&desc->lock, flags);
--- a/kernel/irq/proc.c	2008-01-17 22:25:53.000000000 -0800
+++ b/kernel/irq/proc.c	2008-01-18 00:08:57.000000000 -0800
@@ -84,7 +84,7 @@ static int name_unique(unsigned int irq,
 	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock_irqsave_nested(&desc->lock, flags, desc->lock_class);
 	for (action = desc->action ; action; action = action->next) {
 		if ((action != new_action) && action->name &&
 				!strcmp(new_action->name, action->name)) {
--- a/kernel/irq/spurious.c	2008-01-17 22:25:52.000000000 -0800
+++ b/kernel/irq/spurious.c	2008-01-18 00:08:57.000000000 -0800
@@ -29,7 +29,7 @@ static int misrouted_irq(int irq)
 		if (i == irq)	/* Already tried */
 			continue;
 
-		spin_lock(&desc->lock);
+		spin_lock_nested(&desc->lock, desc->lock_class);
 		/* Already running on another processor */
 		if (desc->status & IRQ_INPROGRESS) {
 			/*
@@ -57,7 +57,7 @@ static int misrouted_irq(int irq)
 		}
 		local_irq_disable();
 		/* Now clean up the flags */
-		spin_lock(&desc->lock);
+		spin_lock_nested(&desc->lock, desc->lock_class);
 		action = desc->action;
 
 		/*
@@ -71,7 +71,7 @@ static int misrouted_irq(int irq)
 			work = 1;
 			spin_unlock(&desc->lock);
 			handle_IRQ_event(i, action);
-			spin_lock(&desc->lock);
+			spin_lock_nested(&desc->lock, desc->lock_class);
 			desc->status &= ~IRQ_PENDING;
 		}
 		desc->status &= ~IRQ_INPROGRESS;

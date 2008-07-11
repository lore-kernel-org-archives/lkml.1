Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbYGKVTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbYGKVTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbYGKVSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:18:38 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:49502 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYGKVSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:18:30 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com, ebiederm@xmission.com,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/6] Allow a small amount of data to be stored with the interrupt number
Date: Fri, 11 Jul 2008 17:16:53 -0400
Message-Id: <1215811018-15270-1-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <20080711211559.GV14894@parisc-linux.org>
References: <20080711211559.GV14894@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI MSI capability allows up to 5 bits of information to be sent
from the device to the interrupt controller.  Rather than allocate
multiple Linux interrupts to handle this, we can store the information in
the top 5 bits of the interrupt number.  Architectures which have not
been converted to handle multiple MSI will not store data there and so
do not need to be taught about this.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/irq.h |   22 +++++++++++++++++++++-
 kernel/irq/chip.c   |    5 +++--
 kernel/irq/handle.c |   17 +++++++++--------
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 552e0ec..9bc7d61 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -282,6 +282,26 @@ extern unsigned int __do_IRQ(unsigned int irq);
 #endif
 
 /*
+ * We allow interrupts to have a few subchannels.  It's up to the
+ * architecture to arrange how many there are per interrupt and what they
+ * are used for.  To support subchannels, architectures should define
+ * IRQ_SUBCHANNEL_BITS in asm/irq.h.  In order to support multiple PCI MSI,
+ * an architecture should set it to at least 5 in order to support 32
+ * subchannels (one for each vector).  This leaves 27 bits for NR_IRQS.  If
+ * the architecture wants to store something other than MSI data here, it
+ * may wish to make it larger, but should take care not to run into NR_IRQS.
+ */
+
+#ifndef IRQ_SUBCHANNEL_BITS
+#define get_irq_value(irq)	(irq)
+#define get_irq_subchannel(irq)	0
+#else
+#define IRQ_SUBCHANNEL_SHIFT	(32 - IRQ_SUBCHANNEL_BITS)
+#define get_irq_value(irq)	(irq & ((1 << IRQ_SUBCHANNEL_SHIFT) - 1))
+#define get_irq_subchannel(irq)	(irq >> IRQ_SUBCHANNEL_SHIFT)
+#endif
+
+/*
  * Architectures call this to let the generic IRQ layer
  * handle an interrupt. If the descriptor is attached to an
  * irqchip-style controller then we call the ->handle_irq() handler,
@@ -289,7 +309,7 @@ extern unsigned int __do_IRQ(unsigned int irq);
  */
 static inline void generic_handle_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc + get_irq_value(irq);
 
 #ifdef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
 	desc->handle_irq(irq, desc);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 964964b..fd4f7f0 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -453,8 +453,9 @@ out:
  *	loop is left.
  */
 void
-handle_edge_irq(unsigned int irq, struct irq_desc *desc)
+handle_edge_irq(unsigned int irq_plus_data, struct irq_desc *desc)
 {
+	const unsigned int irq = get_irq_value(irq_plus_data);
 	const unsigned int cpu = smp_processor_id();
 
 	spin_lock(&desc->lock);
@@ -504,7 +505,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 
 		desc->status &= ~IRQ_PENDING;
 		spin_unlock(&desc->lock);
-		action_ret = handle_IRQ_event(irq, action);
+		action_ret = handle_IRQ_event(irq_plus_data, action);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
 		spin_lock(&desc->lock);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 5fa6198..4e463e6 100644
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
@@ -145,7 +145,7 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 	} while (action);
 
 	if (status & IRQF_SAMPLE_RANDOM)
-		add_interrupt_randomness(irq);
+		add_interrupt_randomness(get_irq_value(irq_plus_data));
 	local_irq_disable();
 
 	return retval;
@@ -163,15 +163,16 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
  * This is the original x86 implementation which is used for every
  * interrupt type.
  */
-unsigned int __do_IRQ(unsigned int irq)
+unsigned int __do_IRQ(unsigned int irq_plus_data)
 {
+	const unsigned int irq = get_irq_value(irq_plus_data);
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
1.5.5.4


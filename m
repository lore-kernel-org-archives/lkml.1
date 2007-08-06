Return-Path: <linux-kernel-owner+w=401wt.eu-S1763367AbXHFKb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763367AbXHFKb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762658AbXHFKbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:31:21 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:36846 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbXHFKbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:31:20 -0400
Date: Mon, 6 Aug 2007 19:30:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] genirq: support multiple interrupt priorities
Message-ID: <20070806103027.GA4624@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple patch for adding trivial interrupt priority support.

I've added a ->set_prio() to the irq_chip which is implemented
effectively the same way as ->set_type(), it's an optional component for
those that really care about it.

This follows the rationale that PICs that do support multiple priorities
are going to support a fairly wide range, which is not something that can
easily be represented generically. Given that, the only IRQF_PRIO_* flags
that are introduced are for generic priorities that we assume all
priority-capable PICs can support -- namely, high, low, and default (or
none). In addition to this there is also a set_irq_prio() modelled after
set_irq_type() which platform-specific code can set to more specific
values that aren't suitable for generic abstraction.

My primary use case for this is for making sure we have high priorities
where we want them in the platform code, especially chained handlers,
timers, things of that nature. Going the genirq route is certainly much
cleaner than trying to hack up my own arch-specific API for this. I
imagine other people will have similar use cases for this.

Comments? Flames?

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 include/linux/interrupt.h |    5 +++++
 include/linux/irq.h       |    3 +++
 kernel/irq/chip.c         |   26 ++++++++++++++++++++++++++
 kernel/irq/manage.c       |   16 ++++++++++++++++
 4 files changed, 50 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5523f19..503754e 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -45,6 +45,8 @@
  * IRQF_IRQPOLL - Interrupt is used for polling (only the interrupt that is
  *                registered first in an shared interrupt is considered for
  *                performance reasons)
+ * IRQF_PRIO_HIGH - Give IRQ a high priority
+ * IRQF_PRIO_LOW - Give IRQ a low priority
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -54,6 +56,9 @@
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
+#define IRQF_PRIO_HIGH		0x00002000
+#define IRQF_PRIO_LOW		0x00004000
+#define IRQF_PRIO_MASK		(IRQF_PRIO_HIGH | IRQF_PRIO_LOW)
 
 /*
  * Migration helpers. Scheduled for removal in 9/2007
diff --git a/include/linux/irq.h b/include/linux/irq.h
index efc8853..88cfd33 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -91,6 +96,7 @@ struct msi_desc;
  * @retrigger:		resend an IRQ to the CPU
  * @set_type:		set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
  * @set_wake:		enable/disable power-management wake-on of an IRQ
+ * @set_prio:		set the priority of an IRQ
  *
  * @release:		release function solely used by UML
  * @typename:		obsoleted by name, kept as migration helper
@@ -113,6 +119,7 @@ struct irq_chip {
 	int		(*retrigger)(unsigned int irq);
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
 	int		(*set_wake)(unsigned int irq, unsigned int on);
+	int		(*set_prio)(unsigned int irq, unsigned int prio);
 
 	/* Currently used only by UML, might disappear one day.*/
 #ifdef CONFIG_IRQ_RELEASE_METHOD
@@ -381,6 +388,7 @@ extern int set_irq_data(unsigned int irq, void *data);
 extern int set_irq_chip_data(unsigned int irq, void *data);
 extern int set_irq_type(unsigned int irq, unsigned int type);
 extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
+extern int set_irq_prio(unsigned int irq, unsigned int prio);
 
 #define get_irq_chip(irq)	(irq_desc[irq].chip)
 #define get_irq_chip_data(irq)	(irq_desc[irq].chip_data)
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 615ce97..fa7df4d 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -141,6 +141,32 @@ int set_irq_type(unsigned int irq, unsigned int type)
 EXPORT_SYMBOL(set_irq_type);
 
 /**
+ *	set_irq_prio - set the irq priority for an irq
+ *	@irq:	irq number
+ *	@prio:	interrupt priority - see include/linux/interrupt.h
+ */
+int set_irq_prio(unsigned int irq, unsigned int prio)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+	int ret = -ENXIO;
+
+	if (irq >= NR_IRQS) {
+		printk(KERN_ERR "Trying to set irq priority for IRQ%d\n", irq);
+		return -ENODEV;
+	}
+
+	desc = irq_desc + irq;
+	if (desc->chip->set_prio) {
+		spin_lock_irqsave(&desc->lock, flags);
+		ret = desc->chip->set_prio(irq, prio);
+		spin_unlock_irqrestore(&desc->lock, flags);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(set_irq_prio);
+
+/**
  *	set_irq_data - set irq type data for an irq
  *	@irq:	Interrupt number
  *	@data:	Pointer to interrupt specific data
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 203a518..f51f8d2 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -347,6 +353,22 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 		} else
 			compat_irq_chip_set_default_handler(desc);
 
+		/* Setup the priority if configured: */
+		if (new->flags & IRQF_PRIO_MASK) {
+			if (desc->chip && desc->chip->set_prio)
+				desc->chip->set_prio(irq,
+						new->flags & IRQF_PRIO_MASK);
+			else
+				/*
+				 * IRQF_PRIO_* but the PIC does not support
+				 * multiple priorities?
+				 */
+				printk(KERN_WARNING "No IRQF_PRIO set_prio "
+				       "function for IRQ %d (%s)\n", irq,
+				       desc->chip ? desc->chip->name :
+				       "unknown");
+		}
+
 		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
 				  IRQ_INPROGRESS);
 
 

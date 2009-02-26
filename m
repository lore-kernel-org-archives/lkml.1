Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZBZN3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZBZN3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbZBZN2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:28:49 -0500
Received: from www.tglx.de ([62.245.132.106]:46807 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbZBZN2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:28:47 -0500
Message-Id: <20090226131719.640887792@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 26 Feb 2009 13:28:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: [patch 3/4] genirq: add a quick check handler
References: <20090226131336.423054348@linutronix.de>
Content-Disposition: inline; filename=genirq-add-quickcheckhandler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch for threaded interrupt handlers.

Adds a quick check handler which is called before the real handler.
The quick check handler can decide whether the interrupt was originated
from the device or not. It can also declare the interrupt as handled
and subsequently avoid that the real handler is called.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>

---
 include/linux/interrupt.h |   16 ++++++++++++++--
 include/linux/irqreturn.h |    2 ++
 kernel/irq/handle.c       |   18 +++++++++++++++---
 kernel/irq/manage.c       |   17 ++++++++++++-----
 4 files changed, 43 insertions(+), 10 deletions(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -62,6 +62,7 @@
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
 struct irqaction {
+	irq_handler_t quick_check_handler;
 	irq_handler_t handler;
 	unsigned long flags;
 	cpumask_t mask;
@@ -73,8 +74,19 @@ struct irqaction {
 };
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
-extern int __must_check request_irq(unsigned int, irq_handler_t handler,
-		       unsigned long, const char *, void *);
+
+extern int __must_check
+request_irq_quickcheck(unsigned int irq, irq_handler_t handler,
+		       irq_handler_t quick_check_handler,
+		       unsigned long flags, const char *name, void *dev);
+
+static inline int __must_check
+request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
+	    const char *name, void *dev)
+{
+	return request_irq_quickcheck(irq, handler, NULL, flags, name, dev);
+}
+
 extern void free_irq(unsigned int, void *);
 
 struct device;
Index: linux-2.6-tip/include/linux/irqreturn.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irqreturn.h
+++ linux-2.6-tip/include/linux/irqreturn.h
@@ -5,10 +5,12 @@
  * enum irqreturn
  * @IRQ_NONE		interrupt was not from this device
  * @IRQ_HANDLED		interrupt was handled by this device
+ * @IRQ_NEEDS_HANDLING	quick check handler requests to run real handler
  */
 enum irqreturn {
 	IRQ_NONE,
 	IRQ_HANDLED,
+	IRQ_NEEDS_HANDLING,
 };
 
 typedef enum irqreturn irqreturn_t;
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -354,9 +354,21 @@ irqreturn_t handle_IRQ_event(unsigned in
 		local_irq_enable_in_hardirq();
 
 	do {
-		ret = action->handler(irq, action->dev_id);
-		if (ret == IRQ_HANDLED)
-			status |= action->flags;
+		if (action->quick_check_handler)
+			ret = action->quick_check_handler(irq, action->dev_id);
+		else
+			ret = IRQ_NEEDS_HANDLING;
+
+		switch (ret) {
+		default:
+			break;
+
+		case IRQ_NEEDS_HANDLING:
+			ret = action->handler(irq, action->dev_id);
+			if (ret == IRQ_HANDLED)
+				status |= action->flags;
+			break;
+		}
 		retval |= ret;
 		action = action->next;
 	} while (action);
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -641,9 +641,13 @@ void free_irq(unsigned int irq, void *de
 EXPORT_SYMBOL(free_irq);
 
 /**
- *	request_irq - allocate an interrupt line
+ *	request_irq_quickcheck - allocate an interrupt line
  *	@irq: Interrupt line to allocate
- *	@handler: Function to be called when the IRQ occurs
+ *	@handler: Function to be called when the IRQ occurs.
+ *		  Primary handler for threaded interrupts
+ *      @quick_check_handler: Function called before the real interrupt
+ *			handler. It checks if the interrupt originated
+ *			from the device. This can be NULL.
  *	@irqflags: Interrupt type flags
  *	@devname: An ascii name for the claiming device
  *	@dev_id: A cookie passed back to the handler function
@@ -670,8 +674,10 @@ EXPORT_SYMBOL(free_irq);
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
  */
-int request_irq(unsigned int irq, irq_handler_t handler,
-		unsigned long irqflags, const char *devname, void *dev_id)
+int request_irq_quickcheck(unsigned int irq, irq_handler_t handler,
+			   irq_handler_t quick_check_handler,
+			   unsigned long irqflags, const char *devname,
+			   void *dev_id)
 {
 	struct irqaction *action;
 	struct irq_desc *desc;
@@ -718,6 +724,7 @@ int request_irq(unsigned int irq, irq_ha
 	if (!action)
 		return -ENOMEM;
 
+	action->quick_check_handler = quick_check_handler;
 	action->handler = handler;
 	action->flags = irqflags;
 	action->name = devname;
@@ -748,4 +755,4 @@ int request_irq(unsigned int irq, irq_ha
 #endif
 	return retval;
 }
-EXPORT_SYMBOL(request_irq);
+EXPORT_SYMBOL(request_irq_quickcheck);



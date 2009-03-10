Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZCJK1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZCJK1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 06:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZCJK13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 06:27:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:51145 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbZCJK12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 06:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=BTN5/609Ay9iV8ovENG8KH9af0sYW0/9aX4n8rQG/IP3A/cxVU39/a+SZz6npmY73/
         tNwCqcqhhIGyG/4okxxFLb3ekZVXHuUgJCniIZjp1KB0gjNCVvLzN8KazJsnOdOi0pR3
         3ZfJe0EpFrV5a44Jjlxb5SJ25Vxul7chrqJug=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
       tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org
Date: Tue, 10 Mar 2009 19:24:59 +0900
Message-Id: <20090310102459.23422.80761.sendpatchset@rx1.opensource.se>
Subject: [PATCH] Free setup_irq() interrupt V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds a __free_irq() function for releasing 
interrupts requested with setup_irq().

Without this patch we have no way of releasing such
interrupts since free_irq() today tries to kfree()
the irqaction passed with setup_irq().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Changes since V1:
 - break out a __free_irq() function, thanks Ingo! 

 Why again are we not using struct list_head for the irqaction list?

 include/linux/irq.h |    1 +
 kernel/irq/manage.c |   40 ++++++++++++++++++++++++++--------------
 2 files changed, 27 insertions(+), 14 deletions(-)

--- 0001/include/linux/irq.h
+++ work/include/linux/irq.h	2009-03-10 19:00:34.000000000 +0900
@@ -236,6 +236,7 @@ typedef struct irq_desc		irq_desc_t;
 #include <asm/hw_irq.h>
 
 extern int setup_irq(unsigned int irq, struct irqaction *new);
+extern struct irqaction *__free_irq(unsigned int irq, void *dev_id);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 
--- 0001/kernel/irq/manage.c
+++ work/kernel/irq/manage.c	2009-03-10 19:03:56.000000000 +0900
@@ -551,20 +551,14 @@ int setup_irq(unsigned int irq, struct i
 }
 
 /**
- *	free_irq - free an interrupt
+ *	__free_irq - free an interrupt
  *	@irq: Interrupt line to free
  *	@dev_id: Device identity to free
  *
- *	Remove an interrupt handler. The handler is removed and if the
- *	interrupt line is no longer in use by any driver it is disabled.
- *	On a shared IRQ the caller must ensure the interrupt is disabled
- *	on the card it drives before calling this function. The function
- *	does not return until any executing interrupts for this IRQ
- *	have completed.
- *
- *	This function must not be called from interrupt context.
+ * Used to remove interrupts statically setup by the early boot process.
  */
-void free_irq(unsigned int irq, void *dev_id)
+
+struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction **p;
@@ -573,7 +567,7 @@ void free_irq(unsigned int irq, void *de
 	WARN_ON(in_interrupt());
 
 	if (!desc)
-		return;
+		return NULL;
 
 	spin_lock_irqsave(&desc->lock, flags);
 	p = &desc->action;
@@ -623,17 +617,35 @@ void free_irq(unsigned int irq, void *de
 				local_irq_restore(flags);
 			}
 #endif
-			kfree(action);
-			return;
+			return action;
 		}
 		printk(KERN_ERR "Trying to free already-free IRQ %d\n", irq);
 #ifdef CONFIG_DEBUG_SHIRQ
 		dump_stack();
 #endif
 		spin_unlock_irqrestore(&desc->lock, flags);
-		return;
+		return NULL;
 	}
 }
+
+/**
+ *	free_irq - free an interrupt allocated with request_irq
+ *	@irq: Interrupt line to free
+ *	@dev_id: Device identity to free
+ *
+ *	Remove an interrupt handler. The handler is removed and if the
+ *	interrupt line is no longer in use by any driver it is disabled.
+ *	On a shared IRQ the caller must ensure the interrupt is disabled
+ *	on the card it drives before calling this function. The function
+ *	does not return until any executing interrupts for this IRQ
+ *	have completed.
+ *
+ *	This function must not be called from interrupt context.
+ */
+void free_irq(unsigned int irq, void *dev_id)
+{
+	kfree(__free_irq(irq, dev_id));
+}
 EXPORT_SYMBOL(free_irq);
 
 /**

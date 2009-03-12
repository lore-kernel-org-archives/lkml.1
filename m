Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZCLMJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZCLMJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbZCLMIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:08:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:45097 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbZCLMIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=cnJpbqG/KCtJIodLEnL0FsVIygDuakx+QFAEONm/G+/M2A7UOXO3VoM5jGxJwfWEY/
         cO8JFM+QuGWVPMwMKXZhferA7BnU4ceUXbL9C87YznFKbEP/2N5OLaN2/3czy25DdCZf
         YQ6rhxeYvrjByIMKUHbxErLY1lzCz7+4FgdJA=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Magnus Damm <magnus.damm@gmail.com>,
       lethal@linux-sh.org, tglx@linutronix.de, mingo@elte.hu
Date: Thu, 12 Mar 2009 21:05:42 +0900
Message-Id: <20090312120542.2926.56609.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090312120534.2926.78511.sendpatchset@rx1.opensource.se>
References: <20090312120534.2926.78511.sendpatchset@rx1.opensource.se>
Subject: [PATCH 01/03] Add remove_irq() for freeing of setup_irq() irqs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds a remove_irq() function for releasing 
interrupts requested with setup_irq().

Without this patch we have no way of releasing such
interrupts since free_irq() today tries to kfree()
the irqaction passed with setup_irq().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Changes since V2:
 - name the function remove_irq() instead of __free_irq(), thanks Thomas!

 Changes since V1:
 - break out a __free_irq() function, thanks Ingo! 

 include/linux/irq.h |    1 +
 kernel/irq/manage.c |   39 ++++++++++++++++++++++++++-------------
 2 files changed, 27 insertions(+), 13 deletions(-)

--- 0001/include/linux/irq.h
+++ work/include/linux/irq.h	2009-03-12 18:36:20.000000000 +0900
@@ -228,6 +228,7 @@ typedef struct irq_desc		irq_desc_t;
 #include <asm/hw_irq.h>
 
 extern int setup_irq(unsigned int irq, struct irqaction *new);
+extern struct irqaction *remove_irq(unsigned int irq, void *dev_id);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 
--- 0001/kernel/irq/manage.c
+++ work/kernel/irq/manage.c	2009-03-12 20:29:17.000000000 +0900
@@ -551,20 +551,14 @@ int setup_irq(unsigned int irq, struct i
 }
 
 /**
- *	free_irq - free an interrupt
+ *	remove_irq - free an interrupt
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
+struct irqaction *remove_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action, **action_ptr;
@@ -573,7 +567,7 @@ void free_irq(unsigned int irq, void *de
 	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
 
 	if (!desc)
-		return;
+		return NULL;
 
 	spin_lock_irqsave(&desc->lock, flags);
 
@@ -589,7 +583,7 @@ void free_irq(unsigned int irq, void *de
 			WARN(1, "Trying to free already-free IRQ %d\n", irq);
 			spin_unlock_irqrestore(&desc->lock, flags);
 
-			return;
+			return NULL;
 		}
 
 		if (action->dev_id == dev_id)
@@ -636,7 +630,26 @@ void free_irq(unsigned int irq, void *de
 		local_irq_restore(flags);
 	}
 #endif
-	kfree(action);
+	return action;
+}
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
+	kfree(remove_irq(irq, dev_id));
 }
 EXPORT_SYMBOL(free_irq);
 

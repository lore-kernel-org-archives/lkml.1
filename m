Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbZCLXHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbZCLXHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbZCLXHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:07:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:49491 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZCLXHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:07:07 -0400
Date: Thu, 12 Mar 2009 23:06:25 GMT
From: Magnus Damm <damm@igel.co.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       damm@igel.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       damm@igel.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090312120542.2926.56609.sendpatchset@rx1.opensource.se>
References: <20090312120542.2926.56609.sendpatchset@rx1.opensource.se>
Subject: [tip:irq/genirq] irq: add remove_irq() for freeing of setup_irq() irqs
Message-ID: <tip-f21cfb258df6dd3ea0b3e56d75c7e994edb81b35@git.kernel.org>
Git-Commit-ID: f21cfb258df6dd3ea0b3e56d75c7e994edb81b35
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 23:06:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f21cfb258df6dd3ea0b3e56d75c7e994edb81b35
Gitweb:     http://git.kernel.org/tip/f21cfb258df6dd3ea0b3e56d75c7e994edb81b35
Author:     Magnus Damm <damm@igel.co.jp>
AuthorDate: Thu, 12 Mar 2009 21:05:42 +0900
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 13:16:32 +0100

irq: add remove_irq() for freeing of setup_irq() irqs

Impact: add new API

This patch adds a remove_irq() function for releasing
interrupts requested with setup_irq().

Without this patch we have no way of releasing such
interrupts since free_irq() today tries to kfree()
the irqaction passed with setup_irq().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
LKML-Reference: <20090312120542.2926.56609.sendpatchset@rx1.opensource.se>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/irq.h |    1 +
 kernel/irq/manage.c |   39 ++++++++++++++++++++++++++-------------
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index f899b50..56f9988 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -236,6 +236,7 @@ typedef struct irq_desc		irq_desc_t;
 #include <asm/hw_irq.h>
 
 extern int setup_irq(unsigned int irq, struct irqaction *new);
+extern struct irqaction *remove_irq(unsigned int irq, void *dev_id);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 52ee171..8b069a7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -551,20 +551,14 @@ int setup_irq(unsigned int irq, struct irqaction *act)
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
@@ -573,7 +567,7 @@ void free_irq(unsigned int irq, void *dev_id)
 	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
 
 	if (!desc)
-		return;
+		return NULL;
 
 	spin_lock_irqsave(&desc->lock, flags);
 
@@ -589,7 +583,7 @@ void free_irq(unsigned int irq, void *dev_id)
 			WARN(1, "Trying to free already-free IRQ %d\n", irq);
 			spin_unlock_irqrestore(&desc->lock, flags);
 
-			return;
+			return NULL;
 		}
 
 		if (action->dev_id == dev_id)
@@ -636,7 +630,26 @@ void free_irq(unsigned int irq, void *dev_id)
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
 

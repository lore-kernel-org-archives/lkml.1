Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbZCLMJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbZCLMJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbZCLMIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:08:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:57616 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbZCLMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:08:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NPMB2Cdki2TX5h1ZhTmtVYLonLCJFEa4nIUpUNSPptD3mIfi5dHj4n1gJAtwBYT/T0
         Y/V4TqbvFD5CKeJk9lzefRIJGWkUF4EJD+P79ivw+s0oQPeetXzukxQnbFUOvtsswLzA
         vvxE/n9hL4cQsBF2jQKMW85J+EF3rPnFc6PYw=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, lethal@linux-sh.org, tglx@linutronix.de,
       Magnus Damm <magnus.damm@gmail.com>, mingo@elte.hu
Date: Thu, 12 Mar 2009 21:05:51 +0900
Message-Id: <20090312120551.2926.43942.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090312120534.2926.78511.sendpatchset@rx1.opensource.se>
References: <20090312120534.2926.78511.sendpatchset@rx1.opensource.se>
Subject: [PATCH 02/03] Match remove_irq() args with setup_irq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Modify remove_irq() to match setup_irq().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 include/linux/irq.h |    2 +-
 kernel/irq/manage.c |   26 +++++++++++++++++---------
 2 files changed, 18 insertions(+), 10 deletions(-)

--- 0002/include/linux/irq.h
+++ work/include/linux/irq.h	2009-03-12 20:30:10.000000000 +0900
@@ -228,7 +228,7 @@ typedef struct irq_desc		irq_desc_t;
 #include <asm/hw_irq.h>
 
 extern int setup_irq(unsigned int irq, struct irqaction *new);
-extern struct irqaction *remove_irq(unsigned int irq, void *dev_id);
+extern void remove_irq(unsigned int irq, struct irqaction *act);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 
--- 0002/kernel/irq/manage.c
+++ work/kernel/irq/manage.c	2009-03-12 20:31:05.000000000 +0900
@@ -550,15 +550,11 @@ int setup_irq(unsigned int irq, struct i
 	return __setup_irq(irq, desc, act);
 }
 
-/**
- *	remove_irq - free an interrupt
- *	@irq: Interrupt line to free
- *	@dev_id: Device identity to free
- *
- * Used to remove interrupts statically setup by the early boot process.
+ /*
+ * Internal function to unregister an irqaction - used to free
+ * regular and special interrupts that are part of the architecture.
  */
-
-struct irqaction *remove_irq(unsigned int irq, void *dev_id)
+static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action, **action_ptr;
@@ -634,6 +630,18 @@ struct irqaction *remove_irq(unsigned in
 }
 
 /**
+ *	remove_irq - free an interrupt
+ *	@irq: Interrupt line to free
+ *	@act: irqaction for the interrupt
+ *
+ * Used to remove interrupts statically setup by the early boot process.
+ */
+void remove_irq(unsigned int irq, struct irqaction *act)
+{
+	__free_irq(irq, act->dev_id);
+}
+
+/**
  *	free_irq - free an interrupt allocated with request_irq
  *	@irq: Interrupt line to free
  *	@dev_id: Device identity to free
@@ -649,7 +657,7 @@ struct irqaction *remove_irq(unsigned in
  */
 void free_irq(unsigned int irq, void *dev_id)
 {
-	kfree(remove_irq(irq, dev_id));
+	kfree(__free_irq(irq, dev_id));
 }
 EXPORT_SYMBOL(free_irq);
 

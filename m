Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbXJRXl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbXJRXl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758560AbXJRXlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:41:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbXJRXlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:41:50 -0400
Date: Thu, 18 Oct 2007 16:39:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] synchronize_irq needs a barrier
In-Reply-To: <1192749449.7367.51.camel@pasglop>
Message-ID: <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>  <1192745137.7367.40.camel@pasglop>
  <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
 <1192749449.7367.51.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Oct 2007, Benjamin Herrenschmidt wrote:
> 
> I agree and you can see that in fact, we don't have enough barrier on
> the other side since spin_unlock doesn't prevent subsequent loads from
> crossing a previous store...
> 
> I wonder if that's worth trying to address, adding a barrier in
> handle_IRQ_event for example, or we can continue ignoring the barrier
> and let some drivers do their own fixes in fancy ways.

So how about something like this (untested! not necessarily very well 
thought through either!)

Basic notion: the only thing that serializes the IRQ_INPROGRESS flag is 
the descriptor lock. And we don't have to (or even want to!) hold it while 
waiting for the thing, but we want to *have*held*it* in between whatever 
we're synchronizing with.

The internal irq handler functions already held the lock when they did 
whatever they need to serialize - and they are possibly performance 
critical too - so they use the "internal" function that doesn't get the 
lock unnecessarily again.

Hmm? 

		Linus

---
 kernel/irq/manage.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 80eab7a..f3e9575 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -14,6 +14,18 @@
 
 #include "internals.h"
 
+/*
+ * Internally wait for IRQ_INPROGRESS to go away on other CPU's,
+ * after having serialized with the descriptor lock.
+ */
+static inline void do_synchronize_irq(struct irq_desc *desc)
+{
+#ifdef CONFIG_SMP
+	while (desc->status & IRQ_INPROGRESS)
+		cpu_relax();
+#endif
+}
+
 #ifdef CONFIG_SMP
 
 /**
@@ -28,13 +40,15 @@
  */
 void synchronize_irq(unsigned int irq)
 {
+	unsigned long flags;
 	struct irq_desc *desc = irq_desc + irq;
 
 	if (irq >= NR_IRQS)
 		return;
 
-	while (desc->status & IRQ_INPROGRESS)
-		cpu_relax();
+	spin_lock_irqsave(&desc->lock, flags);
+	spin_unlock_irqrestore(&desc->lock, flags);
+	do_synchronize_irq(desc);
 }
 EXPORT_SYMBOL(synchronize_irq);
 
@@ -129,7 +143,7 @@ void disable_irq(unsigned int irq)
 
 	disable_irq_nosync(irq);
 	if (desc->action)
-		synchronize_irq(irq);
+		do_synchronize_irq(desc);
 }
 EXPORT_SYMBOL(disable_irq);
 
@@ -443,7 +457,7 @@ void free_irq(unsigned int irq, void *dev_id)
 			unregister_handler_proc(irq, action);
 
 			/* Make sure it's not being used on another CPU */
-			synchronize_irq(irq);
+			do_synchronize_irq(desc);
 #ifdef CONFIG_DEBUG_SHIRQ
 			/*
 			 * It's a shared IRQ -- the driver ought to be

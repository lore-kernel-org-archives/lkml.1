Return-Path: <linux-kernel-owner+w=401wt.eu-S1946076AbXBIDsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946076AbXBIDsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 22:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946079AbXBIDsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 22:48:47 -0500
Received: from ozlabs.org ([203.10.76.45]:51479 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946076AbXBIDsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 22:48:46 -0500
Date: Fri, 9 Feb 2007 14:48:42 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@elte.hu, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: genirq: Add a set_irq_handler_locked() function
Message-ID: <20070209034842.GF3489@localhost.localdomain>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20070207023353.GC23870@localhost.localdomain> <1170940949.3646.1.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170940949.3646.1.camel@chaos>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, as discussed previously over IRC and private email.  Please
apply.

At present set_irq_handler() and all the existing variants take the
desc->lock for the irq in question before adjusting the irq's flow
handler.  This can cause problems for irq chips for which a given
interrupt can be either level or edge depending on what's attached.
The chip->set_type() callback, which is used to switch the interrupt
type in this case may need to alter the flow handler - but it is
called with the desc->lock already held, so it cannot safely call
set_irq_handler().

This patch pulls the core logic out of set_irq_handler() into a new
set_irq_handler_locked() which assumes the desc->lock is already held.
It can safely be used from the chip->set_type() callback.

Signed-off-by: David Gibson <dwg@au1.ibm.com>

Index: working-2.6/kernel/irq/chip.c
===================================================================
--- working-2.6.orig/kernel/irq/chip.c	2007-01-24 12:01:21.000000000 +1100
+++ working-2.6/kernel/irq/chip.c	2007-02-09 14:28:55.000000000 +1100
@@ -500,6 +500,43 @@ handle_percpu_irq(unsigned int irq, stru
 
 #endif /* CONFIG_SMP */
 
+/**
+ *	set_irq_handler_locked - Set irq flow handler. *
+ *	@irq:		the interrupt number
+ *	@handle:	the flow handler function
+ *	@is_chained:	is this a chained handler (used for cascade interrupts)
+ *	@name:		name for this handler, usually "level" or "edge"
+ *
+ *	This version of set_irq_handler() assumes that desc->lock for
+ *	the interrupt in question is already taken.  In particular,
+ *	this means it is safe to call from a chip->set_type() callback
+ *	function.
+ */
+void set_irq_handler_locked(unsigned int irq, irq_flow_handler_t handle,
+			    int is_chained, const char *name)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	/* Uninstall? */
+	if (handle == handle_bad_irq) {
+		if (desc->chip != &no_irq_chip) {
+			desc->chip->mask(irq);
+			desc->chip->ack(irq);
+		}
+		desc->status |= IRQ_DISABLED;
+		desc->depth = 1;
+	}
+	desc->handle_irq = handle;
+	desc->name = name;
+
+	if (handle != handle_bad_irq && is_chained) {
+		desc->status &= ~IRQ_DISABLED;
+		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
+		desc->depth = 0;
+		desc->chip->unmask(irq);
+	}
+}
+
 void
 __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name)
@@ -531,25 +568,7 @@ __set_irq_handler(unsigned int irq, irq_
 	}
 
 	spin_lock_irqsave(&desc->lock, flags);
-
-	/* Uninstall? */
-	if (handle == handle_bad_irq) {
-		if (desc->chip != &no_irq_chip) {
-			desc->chip->mask(irq);
-			desc->chip->ack(irq);
-		}
-		desc->status |= IRQ_DISABLED;
-		desc->depth = 1;
-	}
-	desc->handle_irq = handle;
-	desc->name = name;
-
-	if (handle != handle_bad_irq && is_chained) {
-		desc->status &= ~IRQ_DISABLED;
-		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
-		desc->depth = 0;
-		desc->chip->unmask(irq);
-	}
+	set_irq_handler_locked(irq, handle, is_chained, name);
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
Index: working-2.6/include/linux/irq.h
===================================================================
--- working-2.6.orig/include/linux/irq.h	2007-01-24 12:01:21.000000000 +1100
+++ working-2.6/include/linux/irq.h	2007-02-09 14:04:12.000000000 +1100
@@ -329,6 +329,9 @@ set_irq_chip_and_handler_name(unsigned i
 			      irq_flow_handler_t handle, const char *name);
 
 extern void
+set_irq_handler_locked(unsigned int irq, irq_flow_handler_t handle,
+		       int is_chained, const char *name);
+extern void
 __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name);
 

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

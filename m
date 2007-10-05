Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbXJEFhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbXJEFhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXJEFhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:37:12 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:40972 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbXJEFhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=sr5bnYtNZcA0Uzx/O97JUuyA05r11ufnaRUrcM+bDbE07Mlb9cbucU3/GZ42475Hit5xIzjuWI7vp4ylq0aHMGGZtBaJC+eyIdVhBemduFOSc7zq/mNSEUpyhlWefvzpP1AiR7DETlqmh0m+YJv11lW7reqf4MZiKG22MPS1C6c=
Date: Fri, 5 Oct 2007 07:36:58 +0200
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH RFC 2/2] IRQ: Modularize the setup_irq code (2)
Message-ID: <20071005053658.GB3435@Ahmed>
References: <20071005053057.GA3435@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005053057.GA3435@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce irq_desc_match_fist_irqaction() to support setup_irq() 
code modularity.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

Any ideas for a better method name ?

 manage.c |   89 ++++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 51 insertions(+), 38 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 6a0d778..4e96d56 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -293,6 +293,55 @@ int can_add_irqaction_on_allocated_irq(unsigned int irq, struct irqaction *new)
 }
 
 /*
+ * Configure the passed irq descriptor to satisfy our first newly
+ * added irqaction needs
+ * must be called with the irq_desc[irq]->lock held
+ */
+void irq_desc_match_fist_irqaction(unsigned int irq, struct irqaction *new)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	/* We must be the first and the only irqaction */
+	BUG_ON(desc->action != new || new->next);
+
+	irq_chip_set_defaults(desc->chip);
+
+#if defined(CONFIG_IRQ_PER_CPU)
+	if (new->flags & IRQF_PERCPU)
+		desc->status |= IRQ_PER_CPU;
+#endif
+
+	/* Setup the type (level, edge polarity) if configured: */
+	if (new->flags & IRQF_TRIGGER_MASK) {
+		if (desc->chip && desc->chip->set_type)
+			desc->chip->set_type(irq,
+					     new->flags & IRQF_TRIGGER_MASK);
+		else
+			/*
+			 * IRQF_TRIGGER_* but the PIC does not support
+			 * multiple flow-types?
+			 */
+			printk(KERN_WARNING "No IRQF_TRIGGER set_type "
+			       "function for IRQ %d (%s)\n", irq,
+			       desc->chip ? desc->chip->name : "unknown");
+	} else
+		compat_irq_chip_set_default_handler(desc);
+
+	desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING | IRQ_INPROGRESS);
+
+	if (!(desc->status & IRQ_NOAUTOEN)) {
+		desc->depth = 0;
+		desc->status &= ~IRQ_DISABLED;
+		if (desc->chip->startup)
+			desc->chip->startup(irq);
+		else
+			desc->chip->enable(irq);
+	} else
+		/* Undo nested disables: */
+		desc->depth = 1;
+}
+
+/*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
  */
@@ -352,45 +401,9 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	if (new->flags & IRQF_NOBALANCING)
 		desc->status |= IRQ_NO_BALANCING;
 
-	if (!shared) {
-		irq_chip_set_defaults(desc->chip);
+	if (!shared)
+		irq_desc_match_fist_irqaction(irq, new);
 
-#if defined(CONFIG_IRQ_PER_CPU)
-		if (new->flags & IRQF_PERCPU)
-			desc->status |= IRQ_PER_CPU;
-#endif
-
-		/* Setup the type (level, edge polarity) if configured: */
-		if (new->flags & IRQF_TRIGGER_MASK) {
-			if (desc->chip && desc->chip->set_type)
-				desc->chip->set_type(irq,
-						new->flags & IRQF_TRIGGER_MASK);
-			else
-				/*
-				 * IRQF_TRIGGER_* but the PIC does not support
-				 * multiple flow-types?
-				 */
-				printk(KERN_WARNING "No IRQF_TRIGGER set_type "
-				       "function for IRQ %d (%s)\n", irq,
-				       desc->chip ? desc->chip->name :
-				       "unknown");
-		} else
-			compat_irq_chip_set_default_handler(desc);
-
-		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
-				  IRQ_INPROGRESS);
-
-		if (!(desc->status & IRQ_NOAUTOEN)) {
-			desc->depth = 0;
-			desc->status &= ~IRQ_DISABLED;
-			if (desc->chip->startup)
-				desc->chip->startup(irq);
-			else
-				desc->chip->enable(irq);
-		} else
-			/* Undo nested disables: */
-			desc->depth = 1;
-	}
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

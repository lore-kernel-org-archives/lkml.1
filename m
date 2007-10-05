Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbXJEFbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbXJEFbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbXJEFbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:31:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:6443 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXJEFbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=Ve4UV4eL+ZFUO0AJJwdKd/cEFgHDJn7svRdZttX8S7gYwdxJ+jkDlROtLNuBWtxYAQVpPIBMIib3plITNw3/8+GeCnGpj2cRrHLaBY/lmlEqQjSbg1k9ub4rI2O1AEr/CIFnqzZftE03+JsK0LGxx+NREoKGIUjPU2qiZ0dV6LQ=
Date: Fri, 5 Oct 2007 07:30:58 +0200
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH RFC 1/2] IRQ: Modularize the setup_irq code (1)
Message-ID: <20071005053057.GA3435@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas/lkml,

setup_irq() code contains a big chunk of 130 code lines that 
can be divided to several smaller methods. These 2 patches introduce 
those small functions to aid toward setup_irq() code modularity. 
No major code logic changes exist.

Patches can be applied cleanly over v2.6.23-rc9.

Thanks,

==> (Description for Logs)

Introduce can_add_irqaction_on_allocated_irq and warn_about_irqaction_mismatch
methods to support setup_irq() code modularity.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 manage.c |   92 +++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 55 insertions(+), 37 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 7230d91..6a0d778 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -248,6 +248,50 @@ void compat_irq_chip_set_default_handler(struct irq_desc *desc)
 		desc->handle_irq = NULL;
 }
 
+static inline void warn_about_irqaction_mismatch(unsigned int irq,
+						 struct irqaction *new)
+{
+#ifdef CONFIG_DEBUG_SHIRQ
+	const char *name = irq_desc[irq].action->name;
+	/* If device doesn't expect the mismatch */
+	if (!(new->flags & IRQF_PROBE_SHARED)) {
+		printk(KERN_ERR "IRQ handler type mismatch for IRQ %d\n", irq);
+		if (name)
+			printk(KERN_ERR "current handler: %s\n", name);
+		dump_stack();
+	}
+#endif
+}
+
+/*
+ * Test if an irqaction can be added to the passed allocated IRQ line
+ * Must be called with the irq_desc[irq]->lock held.
+ */
+int can_add_irqaction_on_allocated_irq(unsigned int irq, struct irqaction *new)
+{
+	struct irqaction *old = irq_desc[irq].action;
+
+	BUG_ON(!old);
+	/*
+	 * Can't share interrupts unless both agree to and are
+	 * the same type (level, edge, polarity). So both flag
+	 * fields must have IRQF_SHARED set and the bits which
+	 * set the trigger type must match.
+	 */
+	if (!((old->flags & new->flags) & IRQF_SHARED) ||
+	    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK))
+		return 0;
+
+#if defined(CONFIG_IRQ_PER_CPU)
+	/* All handlers must agree on per-cpuness */
+	if ((old->flags & IRQF_PERCPU) !=
+	    (new->flags & IRQF_PERCPU))
+		return 0;
+#endif
+
+	return 1;
+}
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
@@ -256,7 +300,6 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	struct irqaction *old, **p;
-	const char *old_name = NULL;
 	unsigned long flags;
 	int shared = 0;
 
@@ -289,31 +332,18 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	p = &desc->action;
 	old = *p;
 	if (old) {
-		/*
-		 * Can't share interrupts unless both agree to and are
-		 * the same type (level, edge, polarity). So both flag
-		 * fields must have IRQF_SHARED set and the bits which
-		 * set the trigger type must match.
-		 */
-		if (!((old->flags & new->flags) & IRQF_SHARED) ||
-		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK)) {
-			old_name = old->name;
-			goto mismatch;
-		}
-
-#if defined(CONFIG_IRQ_PER_CPU)
-		/* All handlers must agree on per-cpuness */
-		if ((old->flags & IRQF_PERCPU) !=
-		    (new->flags & IRQF_PERCPU))
-			goto mismatch;
-#endif
-
-		/* add new interrupt at end of irq queue */
-		do {
-			p = &old->next;
-			old = *p;
-		} while (old);
 		shared = 1;
+		if (can_add_irqaction_on_allocated_irq(irq, new)) {
+			/* add new interrupt at end of irq queue */
+			do {
+				p = &old->next;
+				old = *p;
+			} while (old);
+		} else {
+			warn_about_irqaction_mismatch(irq, new);
+			spin_unlock_irqrestore(&desc->lock, flags);
+			return -EBUSY;
+		}
 	}
 
 	*p = new;
@@ -372,18 +402,6 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	register_handler_proc(irq, new);
 
 	return 0;
-
-mismatch:
-#ifdef CONFIG_DEBUG_SHIRQ
-	if (!(new->flags & IRQF_PROBE_SHARED)) {
-		printk(KERN_ERR "IRQ handler type mismatch for IRQ %d\n", irq);
-		if (old_name)
-			printk(KERN_ERR "current handler: %s\n", old_name);
-		dump_stack();
-	}
-#endif
-	spin_unlock_irqrestore(&desc->lock, flags);
-	return -EBUSY;
 }
 
 /**


-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

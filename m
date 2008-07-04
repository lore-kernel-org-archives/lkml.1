Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYGDKqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYGDKqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 06:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYGDKqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 06:46:44 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:38354 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYGDKqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 06:46:43 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-12.tower-164.messagelabs.com!1215168401!22426905!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Fri, 4 Jul 2008 12:46:34 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] handle failure of irqchip->set_type in setup_irq
Message-ID: <20080704104634.GA31634@digi.com>
References: <20080625131101.GA6205@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080625131101.GA6205@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 04 Jul 2008 10:46:37.0538 (UTC) FILETIME=[3C04FC20:01C8DDC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_type returns an int indicating success or failure, but up to now
setup_irq ignores that.

In my case this resulted in a machine hang:
gpio-keys requested IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, but
arm/ns9xxx can only trigger on one direction so set_type didn't touch
the configuration which happens do default to a level sensitiveness and
returned -EINVAL.  setup_irq ignored that and unmasked the irq.  This
resulted in an endless triggering of the gpio-key interrupt service
routine which effectively killed the machine.

With this patch applied setup_irq propagates the error to the caller.

Note that before in the case 

	chip && !chip->set_type && !chip->name

a NULL pointer was feed to printk.  This is fixed, too.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
Hello,

Changes since initial post:

 - improve commit log (hopefully)
 - move code to a dedicated function to improve readability and code
   line length.
 - include the symbolic name of the failing callback in the error
   message.

Best regards
Uwe

 kernel/irq/manage.c |   72 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 46d6611..178b966 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -270,6 +270,35 @@ void compat_irq_chip_set_default_handler(struct irq_desc *desc)
 		desc->handle_irq = NULL;
 }
 
+static int __irq_set_trigger(struct irq_chip *chip, unsigned int irq,
+		unsigned long flags)
+{
+	int ret;
+
+	if (!chip || !chip->set_type) {
+		/*
+		 * IRQF_TRIGGER_* but the PIC does not support multiple
+		 * flow-types?
+		 */
+		pr_warning("No set_type function for IRQ %d (%s)\n", irq,
+				chip ? (chip->name ? : "unknown") : "unknown");
+		return 0;
+	}
+
+	ret = chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
+
+	if (ret) {
+		char buf[100];
+
+		snprintf(buf, sizeof(buf), KERN_ERR
+				"setting flow type for irq %u failed (%%s)\n",
+				irq);
+		print_fn_descriptor_symbol(buf, chip->set_type);
+	}
+
+	return ret;
+}
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
@@ -281,6 +310,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	const char *old_name = NULL;
 	unsigned long flags;
 	int shared = 0;
+	int ret;
 
 	if (irq >= NR_IRQS)
 		return -EINVAL;
@@ -338,37 +368,26 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 		shared = 1;
 	}
 
-	*p = new;
-
-	/* Exclude IRQ from balancing */
-	if (new->flags & IRQF_NOBALANCING)
-		desc->status |= IRQ_NO_BALANCING;
-
 	if (!shared) {
 		irq_chip_set_defaults(desc->chip);
 
-#if defined(CONFIG_IRQ_PER_CPU)
-		if (new->flags & IRQF_PERCPU)
-			desc->status |= IRQ_PER_CPU;
-#endif
-
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
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
+			ret = __irq_set_trigger(desc->chip, irq, new->flags);
+
+			if (ret) {
+				spin_unlock_irqrestore(&desc->lock, flags);
+				return ret;
+			}
+
 		} else
 			compat_irq_chip_set_default_handler(desc);
 
+#if defined(CONFIG_IRQ_PER_CPU)
+		if (new->flags & IRQF_PERCPU)
+			desc->status |= IRQ_PER_CPU;
+#endif
+
 		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
 				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
 
@@ -383,6 +402,13 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 			/* Undo nested disables: */
 			desc->depth = 1;
 	}
+
+	*p = new;
+
+	/* Exclude IRQ from balancing */
+	if (new->flags & IRQF_NOBALANCING)
+		desc->status |= IRQ_NO_BALANCING;
+
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
-- 
1.5.6


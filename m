Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbYFYNLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbYFYNLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 09:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYFYNLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 09:11:08 -0400
Received: from mail161.messagelabs.com ([216.82.253.115]:52764 "EHLO
	mail161.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbYFYNLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 09:11:07 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-2.tower-161.messagelabs.com!1214399464!12996202!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Wed, 25 Jun 2008 15:11:01 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] handle failure of irqchip->set_type in setup_irq
Message-ID: <20080625131101.GA6205@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 25 Jun 2008 13:11:02.0155 (UTC) FILETIME=[EAD0DDB0:01C8D6C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_type returns an int but currently setup_irq ignores that.

To save me from undoing some changes setting the IRQ_NO_BALANCING bit in
desc->flags, setting IRQ_PER_CPU in desc->status and adding the new
action to desc is only done after set_type succeeded.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
Hello,

in my case set_type returns an error because gpio-key tries to use
IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING and my irq-chip can only do
one of these.

Best regards
Uwe

 kernel/irq/manage.c |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 46d6611..bc990a1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -281,6 +281,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	const char *old_name = NULL;
 	unsigned long flags;
 	int shared = 0;
+	int ret;
 
 	if (irq >= NR_IRQS)
 		return -EINVAL;
@@ -338,26 +339,23 @@ int setup_irq(unsigned int irq, struct irqaction *new)
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
+			if (desc->chip && desc->chip->set_type) {
+				ret = desc->chip->set_type(irq,
 						new->flags & IRQF_TRIGGER_MASK);
-			else
+				if (ret) {
+					pr_err("setting flow type for irq %u "
+							"failed\n", irq);
+					spin_unlock_irqrestore(&desc->lock,
+							flags);
+					return ret;
+				}
+
+			} else
 				/*
 				 * IRQF_TRIGGER_* but the PIC does not support
 				 * multiple flow-types?
@@ -369,6 +367,11 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 		} else
 			compat_irq_chip_set_default_handler(desc);
 
+#if defined(CONFIG_IRQ_PER_CPU)
+		if (new->flags & IRQF_PERCPU)
+			desc->status |= IRQ_PER_CPU;
+#endif
+
 		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
 				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
 
@@ -383,6 +386,13 @@ int setup_irq(unsigned int irq, struct irqaction *new)
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


-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbXCZTPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbXCZTPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXCZTPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:15:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:42871 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbXCZTPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=GP3hom5//Rt9Tvkk4eQN0TLhumCH5lPEBcN22lo6pYJluwujlgjiqlULVwSYOxAReSr322w5R2OqbTangryGCwAI32Bk00iTjGJ7j7WI00tX5vfYIgk6/sOBb8tnGd61tWljKBzcxQP31v3OcSe0X9u0yLfnKGn0/2+HZR25Rew=
Date: Mon, 26 Mar 2007 21:14:55 +0200
To: linux-kernel@vger.kernel.org
Subject: [PATCH] IRQ: Check for PERCPU flag only when adding first irqaction.
Message-ID: <20070326191455.GA21991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

An irqaction structure won't be added to the IRQ line irqaction list if they
don't agree wrt the IRQF_PERCPU flag. Only check and set this flag in IRQ
descriptor `status' field when the first irqaction is added to the line list.


Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

Patch over 2.6.21-rc5.

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 5597c15..ea82a54 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -317,10 +317,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	}
 
 	*p = new;
-#if defined(CONFIG_IRQ_PER_CPU)
-	if (new->flags & IRQF_PERCPU)
-		desc->status |= IRQ_PER_CPU;
-#endif
+
 	/* Exclude IRQ from balancing */
 	if (new->flags & IRQF_NOBALANCING)
 		desc->status |= IRQ_NO_BALANCING;
@@ -328,6 +325,11 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	if (!shared) {
 		irq_chip_set_defaults(desc->chip);
 
+#if defined(CONFIG_IRQ_PER_CPU)
+		if (new->flags & IRQF_PERCPU)
+			desc->status |= IRQ_PER_CPU;
+#endif
+		
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
 			if (desc->chip && desc->chip->set_type)

-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

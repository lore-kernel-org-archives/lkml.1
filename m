Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbXC0Iye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbXC0Iye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 04:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXC0Iye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 04:54:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:53405 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbXC0Iyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 04:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=N4dIELiltvIFn6oDdAP4PCgsksLgeYSRQU1fThOs8nu9dttcxoYekliqkrJJROTA2E0jogSzPNWzWrYca6Mq5cIaXv9we7Q7aqOk1FNumn+ndkC462c5I9jtMaXh5EKGi9Tlgj75FRMlGdQkoSjznT1CLdt1cpxuhk0caTLKG3c=
Date: Tue, 27 Mar 2007 10:54:25 +0200
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IRQ: Check for PERCPU flag only when adding first irqaction.
Message-ID: <20070327085425.GD21991@Ahmed>
References: <20070326191455.GA21991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326191455.GA21991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 09:14:55PM +0200, ahmed wrote:
> Hi,
> 
> An irqaction structure won't be added to the IRQ line irqaction list if they
> don't agree wrt the IRQF_PERCPU flag. Only check and set this flag in IRQ
> descriptor `status' field when the first irqaction is added to the line list.
> 
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> Patch over 2.6.21-rc5.

Maybe just a better description (with the same patch below):

An irqaction structure won't be added to an IRQ descriptor irqaction list
if it don't agree with other irqactions on the IRQF_PERCPU flag. Don't 
check for this flag to change IRQ descriptor `status' for every irqaction
added to the list, Doing the check only for the first irqaction added is
enough.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
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


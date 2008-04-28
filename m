Return-Path: <linux-kernel-owner+w=401wt.eu-S967290AbYD1Woy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967290AbYD1Woy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966576AbYD1Wgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:36:47 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30490 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966529AbYD1Wgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:39 -0400
Message-Id: <20080428223619.502755454@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:02 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 15/55] PNPACPI: extend irq_flags() to set IORESOURCE_IRQ_SHAREABLE when appropriate
Content-Disposition: inline; filename=pnpacpi-add-shareability-to-irq-flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies IRQ resource parsing slightly by computing all the
IORESOURCE_IRQ_* flags at the same time.

This also keeps track of shareability information when parsing options
from _PRS.  Previously we ignored shareability in _PRS.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:17.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:17.000000000 -0600
@@ -32,19 +32,26 @@
 /*
  * Allocated Resources
  */
-static int irq_flags(int triggering, int polarity)
+static int irq_flags(int triggering, int polarity, int shareable)
 {
+	int flags;
+
 	if (triggering == ACPI_LEVEL_SENSITIVE) {
 		if (polarity == ACPI_ACTIVE_LOW)
-			return IORESOURCE_IRQ_LOWLEVEL;
+			flags = IORESOURCE_IRQ_LOWLEVEL;
 		else
-			return IORESOURCE_IRQ_HIGHLEVEL;
+			flags = IORESOURCE_IRQ_HIGHLEVEL;
 	} else {
 		if (polarity == ACPI_ACTIVE_LOW)
-			return IORESOURCE_IRQ_LOWEDGE;
+			flags = IORESOURCE_IRQ_LOWEDGE;
 		else
-			return IORESOURCE_IRQ_HIGHEDGE;
+			flags = IORESOURCE_IRQ_HIGHEDGE;
 	}
+
+	if (shareable)
+		flags |= IORESOURCE_IRQ_SHAREABLE;
+
+	return flags;
 }
 
 static void decode_irq_flags(int flag, int *triggering, int *polarity)
@@ -110,16 +117,13 @@
 	}
 
 	res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
-	res->irq_resource[i].flags |= irq_flags(triggering, polarity);
+	res->irq_resource[i].flags |= irq_flags(triggering, polarity, shareable);
 	irq = acpi_register_gsi(gsi, triggering, polarity);
 	if (irq < 0) {
 		res->irq_resource[i].flags |= IORESOURCE_DISABLED;
 		return;
 	}
 
-	if (shareable)
-		res->irq_resource[i].flags |= IORESOURCE_IRQ_SHAREABLE;
-
 	res->irq_resource[i].start = irq;
 	res->irq_resource[i].end = irq;
 	pcibios_penalize_isa_irq(irq, 1);
@@ -441,7 +445,7 @@
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
 			__set_bit(p->interrupts[i], irq->map);
-	irq->flags = irq_flags(p->triggering, p->polarity);
+	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
 
 	pnp_register_irq_resource(option, irq);
 }
@@ -461,7 +465,7 @@
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
 			__set_bit(p->interrupts[i], irq->map);
-	irq->flags = irq_flags(p->triggering, p->polarity);
+	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
 
 	pnp_register_irq_resource(option, irq);
 }

-- 

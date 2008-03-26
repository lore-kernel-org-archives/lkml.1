Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbYCZROR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbYCZROR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760444AbYCZRI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:08:56 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:8926 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760723AbYCZRIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:48 -0400
Message-Id: <20080326171226.135507672@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:12 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 14/37] PNPACPI: extend irq_flags() to set IORESOURCE_IRQ_SHAREABLE when appropriate
Content-Disposition: inline; filename=pnpacpi-add-shareability-to-irq-flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies IRQ resource parsing slightly by computing all the
IORESOURCE_IRQ_* flags at the same time.

This also keeps track of shareability information when parsing options
from _PRS.  Previously we ignored shareability in _PRS.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-21 15:10:22.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-21 15:10:23.000000000 -0600
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
@@ -108,16 +115,13 @@
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
@@ -439,7 +443,7 @@
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
 			__set_bit(p->interrupts[i], irq->map);
-	irq->flags = irq_flags(p->triggering, p->polarity);
+	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
 
 	pnp_register_irq_resource(option, irq);
 }
@@ -459,7 +463,7 @@
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
 			__set_bit(p->interrupts[i], irq->map);
-	irq->flags = irq_flags(p->triggering, p->polarity);
+	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
 
 	pnp_register_irq_resource(option, irq);
 }

-- 

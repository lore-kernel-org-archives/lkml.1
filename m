Return-Path: <linux-kernel-owner+w=401wt.eu-S1765453AbYF0XC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765453AbYF0XC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764323AbYF0W64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:58:56 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:19468 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761937AbYF0W6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:58:48 -0400
Message-Id: <20080627225759.691183081@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:56:58 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 07/28] PNPACPI: keep disabled resources when parsing current config
Content-Disposition: inline; filename=pnp-keep-disabled-resources-when-parsing-current-config
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we parse a device's _CRS data (the current resource settings),
we should keep track of everything we find, even if it's currently
disabled or invalid.

This is what we already do for ISAPNP and PNPBIOS, and it helps
keep things matched up when we subsequently re-encode resources.
For example, consider a device with (mem, irq0, irq1, io), where
irq0 is disabled.  If we drop irq0 when parsing the _CRS, we will
mistakenly put irq1 in the irq0 slot when we encode resources
for an _SRS call.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work14/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work14.orig/drivers/pnp/pnpacpi/rsparser.c	2008-06-17 14:47:29.000000000 -0600
+++ work14/drivers/pnp/pnpacpi/rsparser.c	2008-06-17 15:46:52.000000000 -0600
@@ -98,8 +98,10 @@ static void pnpacpi_parse_allocated_irqr
 	int irq, flags;
 	int p, t;
 
-	if (!valid_IRQ(gsi))
+	if (!valid_IRQ(gsi)) {
+		pnp_add_irq_resource(dev, gsi, IORESOURCE_DISABLED);
 		return;
+	}
 
 	/*
 	 * in IO-APIC mode, use overrided attribute. Two reasons:
@@ -248,24 +250,39 @@ static acpi_status pnpacpi_allocated_res
 		 * _CRS, but some firmware violates this, so parse them all.
 		 */
 		irq = &res->data.irq;
-		for (i = 0; i < irq->interrupt_count; i++) {
-			pnpacpi_parse_allocated_irqresource(dev,
-				irq->interrupts[i],
-				irq->triggering,
-				irq->polarity,
-				irq->sharable);
+		if (irq->interrupt_count == 0)
+			pnp_add_irq_resource(dev, 0, IORESOURCE_DISABLED);
+		else {
+			for (i = 0; i < irq->interrupt_count; i++) {
+				pnpacpi_parse_allocated_irqresource(dev,
+					irq->interrupts[i],
+					irq->triggering,
+					irq->polarity,
+				    irq->sharable);
+			}
+
+			/*
+			 * The IRQ encoder puts a single interrupt in each
+			 * descriptor, so if a _CRS descriptor has more than
+			 * one interrupt, we won't be able to re-encode it.
+			 */
+			if (pnp_can_write(dev) && irq->interrupt_count > 1) {
+				dev_warn(&dev->dev, "multiple interrupts in "
+					 "_CRS descriptor; configuration can't "
+					 "be changed\n");
+				dev->capabilities &= ~PNP_WRITE;
+			}
 		}
 		break;
 
 	case ACPI_RESOURCE_TYPE_DMA:
 		dma = &res->data.dma;
-		if (dma->channel_count > 0) {
+		if (dma->channel_count > 0 && dma->channels[0] != (u8) -1)
 			flags = dma_flags(dma->type, dma->bus_master,
 					  dma->transfer);
-			if (dma->channels[0] == (u8) -1)
-				flags |= IORESOURCE_DISABLED;
-			pnp_add_dma_resource(dev, dma->channels[0], flags);
-		}
+		else
+			flags = IORESOURCE_DISABLED;
+		pnp_add_dma_resource(dev, dma->channels[0], flags);
 		break;
 
 	case ACPI_RESOURCE_TYPE_IO:
@@ -331,12 +348,29 @@ static acpi_status pnpacpi_allocated_res
 		if (extended_irq->producer_consumer == ACPI_PRODUCER)
 			return AE_OK;
 
-		for (i = 0; i < extended_irq->interrupt_count; i++) {
-			pnpacpi_parse_allocated_irqresource(dev,
-				extended_irq->interrupts[i],
-				extended_irq->triggering,
-				extended_irq->polarity,
-				extended_irq->sharable);
+		if (extended_irq->interrupt_count == 0)
+			pnp_add_irq_resource(dev, 0, IORESOURCE_DISABLED);
+		else {
+			for (i = 0; i < extended_irq->interrupt_count; i++) {
+				pnpacpi_parse_allocated_irqresource(dev,
+					extended_irq->interrupts[i],
+					extended_irq->triggering,
+					extended_irq->polarity,
+					extended_irq->sharable);
+			}
+
+			/*
+			 * The IRQ encoder puts a single interrupt in each
+			 * descriptor, so if a _CRS descriptor has more than
+			 * one interrupt, we won't be able to re-encode it.
+			 */
+			if (pnp_can_write(dev) &&
+			    extended_irq->interrupt_count > 1) {
+				dev_warn(&dev->dev, "multiple interrupts in "
+					 "_CRS descriptor; configuration can't "
+					 "be changed\n");
+				dev->capabilities &= ~PNP_WRITE;
+			}
 		}
 		break;
 

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763191AbYFDWNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763191AbYFDWNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760307AbYFDWLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:11:34 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:33405 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468AbYFDWL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:11:29 -0400
Message-Id: <20080604221127.983575336@ldl.fc.hp.com>
References: <20080604220933.168145536@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 16:09:39 -0600
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
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [patch 06/18] PNP: introduce pnp_irq_mask_t typedef
Content-Disposition: inline; filename=pnp-irq-bitmap-decl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a typedef for the IRQ bitmap, which should cause
no functional change, but will make it easier to pass a
pointer to a bitmap to pnp_register_irq_resource().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-06-04 15:38:19.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-06-04 15:38:25.000000000 -0600
@@ -30,8 +30,10 @@ struct pnp_port {
 };
 
 #define PNP_IRQ_NR 256
+typedef struct { DECLARE_BITMAP(bits, PNP_IRQ_NR); } pnp_irq_mask_t;
+
 struct pnp_irq {
-	DECLARE_BITMAP(map, PNP_IRQ_NR);	/* bitmask for IRQ lines */
+	pnp_irq_mask_t map;	/* bitmap for IRQ lines */
 	unsigned char flags;	/* IRQ flags */
 	unsigned char pad;	/* pad */
 	struct pnp_irq *next;	/* next IRQ */
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-06-04 15:30:51.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-06-04 15:39:10.000000000 -0600
@@ -98,13 +98,13 @@ int pnp_register_irq_resource(struct pnp
 		int i;
 
 		for (i = 0; i < 16; i++)
-			if (test_bit(i, data->map))
+			if (test_bit(i, data->map.bits))
 				pcibios_penalize_isa_irq(i, 0);
 	}
 #endif
 
 #ifdef DEBUG
-	bitmap_scnprintf(buf, sizeof(buf), data->map, PNP_IRQ_NR);
+	bitmap_scnprintf(buf, sizeof(buf), data->map.bits, PNP_IRQ_NR);
 	dev_dbg(&dev->dev, "  irq bitmask %s flags %#x\n", buf,
 		data->flags);
 #endif
@@ -653,7 +653,7 @@ static int pnp_possible_option(struct pn
 		case IORESOURCE_IRQ:
 			for (irq = tmp->irq; irq; irq = irq->next) {
 				if (start < PNP_IRQ_NR &&
-				    test_bit(start, irq->map))
+				    test_bit(start, irq->map.bits))
 					return 1;
 			}
 			break;
Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-06-04 15:28:38.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-06-04 15:38:25.000000000 -0600
@@ -128,20 +128,20 @@ static int pnp_assign_irq(struct pnp_dev
 	res->start = -1;
 	res->end = -1;
 
-	if (bitmap_empty(rule->map, PNP_IRQ_NR)) {
+	if (bitmap_empty(rule->map.bits, PNP_IRQ_NR)) {
 		res->flags |= IORESOURCE_DISABLED;
 		dev_dbg(&dev->dev, "  irq %d disabled\n", idx);
 		goto __add;
 	}
 
 	/* TBD: need check for >16 IRQ */
-	res->start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
+	res->start = find_next_bit(rule->map.bits, PNP_IRQ_NR, 16);
 	if (res->start < PNP_IRQ_NR) {
 		res->end = res->start;
 		goto __add;
 	}
 	for (i = 0; i < 16; i++) {
-		if (test_bit(xtab[i], rule->map)) {
+		if (test_bit(xtab[i], rule->map.bits)) {
 			res->start = res->end = xtab[i];
 			if (pnp_check_irq(dev, res))
 				goto __add;
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-06-04 15:38:18.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-06-04 15:38:25.000000000 -0600
@@ -67,7 +67,7 @@ static void pnp_print_irq(pnp_info_buffe
 
 	pnp_printf(buffer, "%sirq ", space);
 	for (i = 0; i < PNP_IRQ_NR; i++)
-		if (test_bit(i, irq->map)) {
+		if (test_bit(i, irq->map.bits)) {
 			if (!first) {
 				pnp_printf(buffer, ",");
 			} else {
@@ -78,7 +78,7 @@ static void pnp_print_irq(pnp_info_buffe
 			else
 				pnp_printf(buffer, "%i", i);
 		}
-	if (bitmap_empty(irq->map, PNP_IRQ_NR))
+	if (bitmap_empty(irq->map.bits, PNP_IRQ_NR))
 		pnp_printf(buffer, "<none>");
 	if (irq->flags & IORESOURCE_IRQ_HIGHEDGE)
 		pnp_printf(buffer, " High-Edge");
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-06-04 15:38:18.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-06-04 15:38:25.000000000 -0600
@@ -441,7 +441,7 @@ static void __init isapnp_parse_irq_reso
 	if (!irq)
 		return;
 	bits = (tmp[1] << 8) | tmp[0];
-	bitmap_copy(irq->map, &bits, 16);
+	bitmap_copy(irq->map.bits, &bits, 16);
 	if (size > 2)
 		irq->flags = tmp[2];
 	else
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-06-04 15:38:18.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-06-04 15:38:25.000000000 -0600
@@ -408,7 +408,7 @@ static __init void pnpacpi_parse_irq_opt
 
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
-			__set_bit(p->interrupts[i], irq->map);
+			__set_bit(p->interrupts[i], irq->map.bits);
 	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
 
 	pnp_register_irq_resource(dev, option, irq);
@@ -429,7 +429,7 @@ static __init void pnpacpi_parse_ext_irq
 
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
-			__set_bit(p->interrupts[i], irq->map);
+			__set_bit(p->interrupts[i], irq->map.bits);
 	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
 
 	pnp_register_irq_resource(dev, option, irq);
Index: work10/drivers/pnp/quirks.c
===================================================================
--- work10.orig/drivers/pnp/quirks.c	2008-06-04 15:28:38.000000000 -0600
+++ work10/drivers/pnp/quirks.c	2008-06-04 15:38:25.000000000 -0600
@@ -68,7 +68,7 @@ static void quirk_cmi8330_resources(stru
 
 		for (irq = res->irq; irq; irq = irq->next) {	// Valid irqs are 5, 7, 10
 			tmp = 0x04A0;
-			bitmap_copy(irq->map, &tmp, 16);	// 0000 0100 1010 0000
+			bitmap_copy(irq->map.bits, &tmp, 16);	// 0000 0100 1010 0000
 		}
 
 		for (dma = res->dma; dma; dma = dma->next)	// Valid 8bit dma channels are 1,3
@@ -187,7 +187,7 @@ static void quirk_ad1815_mpu_resources(s
 		if (!copy)
 			break;
 
-		memcpy(copy->map, irq->map, sizeof copy->map);
+		bitmap_copy(copy->map.bits, irq->map.bits, PNP_IRQ_NR);
 		copy->flags = irq->flags;
 
 		copy->next = res->irq; /* Yes, this is NULL */
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-06-04 15:38:18.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-06-04 15:38:25.000000000 -0600
@@ -275,7 +275,7 @@ static __init void pnpbios_parse_irq_opt
 	if (!irq)
 		return;
 	bits = (p[2] << 8) | p[1];
-	bitmap_copy(irq->map, &bits, 16);
+	bitmap_copy(irq->map.bits, &bits, 16);
 	if (size > 2)
 		irq->flags = p[3];
 	else

-- 

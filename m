Return-Path: <linux-kernel-owner+w=401wt.eu-S932668AbYDYS7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbYDYS7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765135AbYDYSlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:41:10 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:32345 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998AbYDYSkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:32 -0400
Message-Id: <20080425183933.297829562@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:52 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
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
Subject: [patch 45/54] PNP: make generic pnp_add_irq_resource()
Content-Disposition: inline; filename=pnp-common-add-irq-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pnp_add_irq_resource() that can be used by all the PNP
backends.  This consolidates a little more pnp_resource_table
knowledge into one place.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |    3 +++
 drivers/pnp/interface.c        |   14 +++++---------
 drivers/pnp/isapnp/core.c      |    8 +++-----
 drivers/pnp/pnpacpi/rsparser.c |   31 +++++++------------------------
 drivers/pnp/pnpbios/rsparser.c |   31 +++++++------------------------
 drivers/pnp/resource.c         |   26 ++++++++++++++++++++++++++
 6 files changed, 51 insertions(+), 62 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-25 11:15:10.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-25 11:15:11.000000000 -0600
@@ -37,3 +37,6 @@
 	struct pnp_resource dma[PNP_MAX_DMA];
 	struct pnp_resource irq[PNP_MAX_IRQ];
 };
+
+struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
+					  int flags);
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-25 11:15:11.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-25 11:15:11.000000000 -0600
@@ -569,6 +569,32 @@
 	return NULL;
 }
 
+struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
+					  int flags)
+{
+	struct pnp_resource *pnp_res;
+	struct resource *res;
+	static unsigned char warned;
+
+	pnp_res = pnp_new_resource(dev, IORESOURCE_IRQ);
+	if (!pnp_res) {
+		if (!warned) {
+			dev_err(&dev->dev, "can't add resource for IRQ %d\n",
+				irq);
+			warned = 1;
+		}
+		return NULL;
+	}
+
+	res = &pnp_res->res;
+	res->flags = IORESOURCE_IRQ | flags;
+	res->start = irq;
+	res->end = irq;
+
+	dev_dbg(&dev->dev, "  add irq %d flags 0x%x\n", irq, flags);
+	return pnp_res;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-04-25 11:15:10.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-04-25 11:15:11.000000000 -0600
@@ -326,6 +326,7 @@
 	struct resource *res;
 	char *buf = (void *)ubuf;
 	int retval = 0;
+	resource_size_t start;
 
 	if (dev->status & PNP_ATTACHED) {
 		retval = -EBUSY;
@@ -429,15 +430,10 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				pnp_res = &dev->res->irq[nirq];
-				pnp_res->index = nirq;
-				res = &pnp_res->res;
-				res->start = res->end =
-				    simple_strtoul(buf, &buf, 0);
-				res->flags = IORESOURCE_IRQ;
-				nirq++;
-				if (nirq >= PNP_MAX_IRQ)
-					break;
+				start = simple_strtoul(buf, &buf, 0);
+				pnp_res = pnp_add_irq_resource(dev, start, 0);
+				if (pnp_res)
+					pnp_res->index = nirq++;
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-25 11:15:10.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-25 11:15:11.000000000 -0600
@@ -964,11 +964,9 @@
 			     8);
 			if (!ret)
 				continue;
-			pnp_res = &dev->res->irq[tmp];
-			pnp_res->index = tmp;
-			res = &pnp_res->res;
-			res->start = res->end = ret;
-			res->flags = IORESOURCE_IRQ;
+			pnp_res = pnp_add_irq_resource(dev, ret, 0);
+			if (pnp_res)
+				pnp_res->index = tmp;
 		}
 		for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:09.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:11.000000000 -0600
@@ -82,28 +82,12 @@
 						u32 gsi, int triggering,
 						int polarity, int shareable)
 {
-	struct resource *res;
-	int i;
-	int irq;
+	int irq, flags;
 	int p, t;
-	static unsigned char warned;
 
 	if (!valid_IRQ(gsi))
 		return;
 
-	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		res = &dev->res->irq[i].res;
-		if (res->flags & IORESOURCE_UNSET)
-			break;
-	}
-	if (i >= PNP_MAX_IRQ) {
-		if (!warned) {
-			printk(KERN_WARNING "pnpacpi: exceeded the max number"
-				" of IRQ resources: %d\n", PNP_MAX_IRQ);
-			warned = 1;
-		}
-		return;
-	}
 	/*
 	 * in IO-APIC mode, use overrided attribute. Two reasons:
 	 * 1. BIOS bug in DSDT
@@ -121,17 +105,14 @@
 		}
 	}
 
-	res->flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
-	res->flags |= irq_flags(triggering, polarity, shareable);
+	flags = irq_flags(triggering, polarity, shareable);
 	irq = acpi_register_gsi(gsi, triggering, polarity);
-	if (irq < 0) {
-		res->flags |= IORESOURCE_DISABLED;
-		return;
-	}
+	if (irq >= 0)
+		pcibios_penalize_isa_irq(irq, 1);
+	else
+		flags |= IORESOURCE_DISABLED;
 
-	res->start = irq;
-	res->end = irq;
-	pcibios_penalize_isa_irq(irq, 1);
+	pnp_add_irq_resource(dev, irq, flags);
 }
 
 static int dma_flags(int type, int bus_master, int transfer)
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:15:09.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:15:11.000000000 -0600
@@ -54,28 +54,6 @@
  * Allocated Resources
  */
 
-static void pnpbios_parse_allocated_irqresource(struct pnp_dev *dev, int irq)
-{
-	struct resource *res;
-	int i;
-
-	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		res = &dev->res->irq[i].res;
-		if (res->flags & IORESOURCE_UNSET)
-			break;
-	}
-
-	if (i < PNP_MAX_IRQ) {
-		res->flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
-		if (irq == -1) {
-			res->flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->start = res->end = (unsigned long)irq;
-		pcibios_penalize_isa_irq(irq, 1);
-	}
-}
-
 static void pnpbios_parse_allocated_dmaresource(struct pnp_dev *dev, int dma)
 {
 	struct resource *res;
@@ -148,7 +126,7 @@
 							    unsigned char *end)
 {
 	unsigned int len, tag;
-	int io, size, mask, i;
+	int io, size, mask, i, flags;
 
 	if (!p)
 		return NULL;
@@ -205,12 +183,17 @@
 		case SMALL_TAG_IRQ:
 			if (len < 2 || len > 3)
 				goto len_err;
+			flags = 0;
 			io = -1;
 			mask = p[1] + p[2] * 256;
 			for (i = 0; i < 16; i++, mask = mask >> 1)
 				if (mask & 0x01)
 					io = i;
-			pnpbios_parse_allocated_irqresource(dev, io);
+			if (io != -1)
+				pcibios_penalize_isa_irq(io, 1);
+			else
+				flags = IORESOURCE_DISABLED;
+			pnp_add_irq_resource(dev, io, flags);
 			break;
 
 		case SMALL_TAG_DMA:

-- 

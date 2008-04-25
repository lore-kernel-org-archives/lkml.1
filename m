Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbYDYTAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbYDYTAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764064AbYDYSlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:41:19 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:19252 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbYDYSkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:35 -0400
Message-Id: <20080425183933.523675648@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:53 -0600
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
Subject: [patch 46/54] PNP: make generic pnp_add_dma_resource()
Content-Disposition: inline; filename=pnp-common-add-dma-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pnp_add_dma_resource() that can be used by all the PNP
backends.  This consolidates a little more pnp_resource_table
knowledge into one place.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |    2 +
 drivers/pnp/interface.c        |   13 +++---------
 drivers/pnp/isapnp/core.c      |    8 ++-----
 drivers/pnp/pnpacpi/rsparser.c |   42 +++++++----------------------------------
 drivers/pnp/pnpbios/rsparser.c |   26 +++----------------------
 drivers/pnp/resource.c         |   26 +++++++++++++++++++++++++
 6 files changed, 47 insertions(+), 70 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-25 11:15:11.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-25 11:15:12.000000000 -0600
@@ -40,3 +40,5 @@
 
 struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
 					  int flags);
+struct pnp_resource *pnp_add_dma_resource(struct pnp_dev *dev, int dma,
+					  int flags);
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-25 11:15:11.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-25 11:15:12.000000000 -0600
@@ -595,6 +595,32 @@
 	return pnp_res;
 }
 
+struct pnp_resource *pnp_add_dma_resource(struct pnp_dev *dev, int dma,
+					  int flags)
+{
+	struct pnp_resource *pnp_res;
+	struct resource *res;
+	static unsigned char warned;
+
+	pnp_res = pnp_new_resource(dev, IORESOURCE_DMA);
+	if (!pnp_res) {
+		if (!warned) {
+			dev_err(&dev->dev, "can't add resource for DMA %d\n",
+				dma);
+			warned = 1;
+		}
+		return NULL;
+	}
+
+	res = &pnp_res->res;
+	res->flags = IORESOURCE_DMA | flags;
+	res->start = dma;
+	res->end = dma;
+
+	dev_dbg(&dev->dev, "  add dma %d flags 0x%x\n", dma, flags);
+	return pnp_res;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-04-25 11:15:11.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-04-25 11:15:12.000000000 -0600
@@ -440,15 +440,10 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				pnp_res = &dev->res->dma[ndma];
-				pnp_res->index = ndma;
-				res = &pnp_res->res;
-				res->start = res->end =
-				    simple_strtoul(buf, &buf, 0);
-				res->flags = IORESOURCE_DMA;
-				ndma++;
-				if (ndma >= PNP_MAX_DMA)
-					break;
+				start = simple_strtoul(buf, &buf, 0);
+				pnp_res = pnp_add_dma_resource(dev, start, 0);
+				if (pnp_res)
+					pnp_res->index = ndma++;
 				continue;
 			}
 			break;
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-25 11:15:11.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-25 11:15:12.000000000 -0600
@@ -972,11 +972,9 @@
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
-			pnp_res = &dev->res->dma[tmp];
-			pnp_res->index = tmp;
-			res = &pnp_res->res;
-			res->start = res->end = ret;
-			res->flags = IORESOURCE_DMA;
+			pnp_res = pnp_add_dma_resource(dev, ret, 0);
+			if  (pnp_res)
+				pnp_res->index = tmp;
 		}
 	}
 	return 0;
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:11.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:12.000000000 -0600
@@ -158,34 +158,6 @@
 	return flags;
 }
 
-static void pnpacpi_parse_allocated_dmaresource(struct pnp_dev *dev,
-						u32 dma, int flags)
-{
-	struct resource *res;
-	int i;
-	static unsigned char warned;
-
-	for (i = 0; i < PNP_MAX_DMA; i++) {
-		res = &dev->res->dma[i].res;
-		if (res->flags & IORESOURCE_UNSET)
-			break;
-	}
-	if (i < PNP_MAX_DMA) {
-		res->flags = IORESOURCE_DMA;	// Also clears _UNSET flag
-		res->flags |= flags;
-		if (dma == -1) {
-			res->flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->start = dma;
-		res->end = dma;
-	} else if (!warned) {
-		printk(KERN_WARNING "pnpacpi: exceeded the max number of DMA "
-				"resources: %d \n", PNP_MAX_DMA);
-		warned = 1;
-	}
-}
-
 static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev,
 					       u64 io, u64 len, int io_decode)
 {
@@ -285,7 +257,7 @@
 	struct acpi_resource_memory32 *memory32;
 	struct acpi_resource_fixed_memory32 *fixed_memory32;
 	struct acpi_resource_extended_irq *extended_irq;
-	int i;
+	int i, flags;
 
 	switch (res->type) {
 	case ACPI_RESOURCE_TYPE_IRQ:
@@ -305,11 +277,13 @@
 
 	case ACPI_RESOURCE_TYPE_DMA:
 		dma = &res->data.dma;
-		if (dma->channel_count > 0)
-			pnpacpi_parse_allocated_dmaresource(dev,
-				dma->channels[0],
-				dma_flags(dma->type, dma->bus_master,
-					  dma->transfer));
+		if (dma->channel_count > 0) {
+			flags = dma_flags(dma->type, dma->bus_master,
+					  dma->transfer);
+			if (dma->channels[0] == (u8) -1)
+				flags |= IORESOURCE_DISABLED;
+			pnp_add_dma_resource(dev, dma->channels[0], flags);
+		}
 		break;
 
 	case ACPI_RESOURCE_TYPE_IO:
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:15:11.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:15:12.000000000 -0600
@@ -54,27 +54,6 @@
  * Allocated Resources
  */
 
-static void pnpbios_parse_allocated_dmaresource(struct pnp_dev *dev, int dma)
-{
-	struct resource *res;
-	int i;
-
-	for (i = 0; i < PNP_MAX_DMA; i++) {
-		res = &dev->res->dma[i].res;
-		if (res->flags & IORESOURCE_UNSET)
-			break;
-	}
-
-	if (i < PNP_MAX_DMA) {
-		res->flags = IORESOURCE_DMA;	// Also clears _UNSET flag
-		if (dma == -1) {
-			res->flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->start = res->end = (unsigned long)dma;
-	}
-}
-
 static void pnpbios_parse_allocated_ioresource(struct pnp_dev *dev,
 					       int io, int len)
 {
@@ -199,12 +178,15 @@
 		case SMALL_TAG_DMA:
 			if (len != 2)
 				goto len_err;
+			flags = 0;
 			io = -1;
 			mask = p[1];
 			for (i = 0; i < 8; i++, mask = mask >> 1)
 				if (mask & 0x01)
 					io = i;
-			pnpbios_parse_allocated_dmaresource(dev, io);
+			if (io == -1)
+				flags = IORESOURCE_DISABLED;
+			pnp_add_dma_resource(dev, io, flags);
 			break;
 
 		case SMALL_TAG_PORT:

-- 

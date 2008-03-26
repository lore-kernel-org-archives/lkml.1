Return-Path: <linux-kernel-owner+w=401wt.eu-S1763487AbYCZRQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763487AbYCZRQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761244AbYCZRJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:09:15 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:22121 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760828AbYCZRI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:58 -0400
Message-Id: <20080326171227.539502349@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:19 -0600
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
Subject: [patch 21/37] PNP: make generic pnp_add_dma_resource()
Content-Disposition: inline; filename=pnp-common-add-dma-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pnp_add_dma_resource() that can be used by all the PNP
backends.  This consolidates a little more pnp_resource_table
knowledge into one place.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |    1 +
 drivers/pnp/isapnp/core.c      |    4 +---
 drivers/pnp/pnpacpi/rsparser.c |   34 ++++------------------------------
 drivers/pnp/pnpbios/rsparser.c |   21 +--------------------
 drivers/pnp/resource.c         |   24 ++++++++++++++++++++++++
 5 files changed, 31 insertions(+), 53 deletions(-)

Index: work7/drivers/pnp/base.h
===================================================================
--- work7.orig/drivers/pnp/base.h	2008-03-25 14:48:51.000000000 -0600
+++ work7/drivers/pnp/base.h	2008-03-25 14:48:54.000000000 -0600
@@ -16,3 +16,4 @@
 int pnp_check_dma(struct pnp_dev * dev, int idx);
 
 int pnp_add_irq_resource(struct pnp_dev *dev, int irq, int flags);
+int pnp_add_dma_resource(struct pnp_dev *dev, int dma, int flags);
Index: work7/drivers/pnp/resource.c
===================================================================
--- work7.orig/drivers/pnp/resource.c	2008-03-25 14:48:51.000000000 -0600
+++ work7/drivers/pnp/resource.c	2008-03-25 14:48:54.000000000 -0600
@@ -487,6 +487,30 @@
 	return 0;
 }
 
+int pnp_add_dma_resource(struct pnp_dev *dev, int dma, int flags)
+{
+	struct pnp_resource_table *res = &dev->res;
+	int i = 0;
+	static unsigned char warned;
+
+	while (set(res->dma_resource[i].flags) && i < PNP_MAX_DMA)
+		i++;
+	if (i >= PNP_MAX_DMA && !warned) {
+		dev_err(&dev->dev, "too many DMAs (max %d)\n", PNP_MAX_DMA);
+		warned = 1;
+		return -ENOSPC;
+	}
+
+	res->dma_resource[i].flags = IORESOURCE_DMA | flags;
+	if (dma < 0) {
+		res->dma_resource[i].flags |= IORESOURCE_DISABLED;
+		return -EINVAL;
+	}
+	res->dma_resource[i].start = dma;
+	res->dma_resource[i].end = dma;
+	return 0;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-25 14:48:51.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-25 14:48:54.000000000 -0600
@@ -968,9 +968,7 @@
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
-			res->dma_resource[tmp].start =
-			    res->dma_resource[tmp].end = ret;
-			res->dma_resource[tmp].flags = IORESOURCE_DMA;
+			pnp_add_dma_resource(dev, ret, 0);
 		}
 	}
 	return 0;
Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-25 14:48:51.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-25 14:48:54.000000000 -0600
@@ -153,32 +153,6 @@
 	return flags;
 }
 
-static void pnpacpi_parse_allocated_dmaresource(struct pnp_dev *dev,
-						u32 dma, int flags)
-{
-	struct pnp_resource_table *res = &dev->res;
-	int i = 0;
-	static unsigned char warned;
-
-	while (i < PNP_MAX_DMA &&
-	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
-		i++;
-	if (i < PNP_MAX_DMA) {
-		res->dma_resource[i].flags = IORESOURCE_DMA;	// Also clears _UNSET flag
-		res->dma_resource[i].flags |= flags;
-		if (dma == -1) {
-			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->dma_resource[i].start = dma;
-		res->dma_resource[i].end = dma;
-	} else if (!warned) {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of DMA "
-				"resources: %d \n", PNP_MAX_DMA);
-		warned = 1;
-	}
-}
-
 static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev,
 					       u64 io, u64 len, int io_decode)
 {
@@ -295,10 +269,10 @@
 	case ACPI_RESOURCE_TYPE_DMA:
 		dma = &res->data.dma;
 		if (dma->channel_count > 0)
-			pnpacpi_parse_allocated_dmaresource(dev,
-				dma->channels[0],
-				dma_flags(dma->type, dma->bus_master,
-					  dma->transfer));
+			pnp_add_dma_resource(dev, dma->channels[0],
+					     dma_flags(dma->type,
+						       dma->bus_master,
+						       dma->transfer));
 		break;
 
 	case ACPI_RESOURCE_TYPE_IO:
Index: work7/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/rsparser.c	2008-03-25 14:48:51.000000000 -0600
+++ work7/drivers/pnp/pnpbios/rsparser.c	2008-03-25 14:48:54.000000000 -0600
@@ -54,25 +54,6 @@
  * Allocated Resources
  */
 
-static void pnpbios_parse_allocated_dmaresource(struct pnp_dev *dev, int dma)
-{
-	struct pnp_resource_table *res = &dev->res;
-	int i = 0;
-
-	while (i < PNP_MAX_DMA &&
-	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
-		i++;
-	if (i < PNP_MAX_DMA) {
-		res->dma_resource[i].flags = IORESOURCE_DMA;	// Also clears _UNSET flag
-		if (dma == -1) {
-			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->dma_resource[i].start =
-		    res->dma_resource[i].end = (unsigned long)dma;
-	}
-}
-
 static void pnpbios_parse_allocated_ioresource(struct pnp_dev *dev,
 					       int io, int len)
 {
@@ -190,7 +171,7 @@
 			for (i = 0; i < 8; i++, mask = mask >> 1)
 				if (mask & 0x01)
 					io = i;
-			pnpbios_parse_allocated_dmaresource(dev, io);
+			pnp_add_dma_resource(dev, io, 0);
 			break;
 
 		case SMALL_TAG_PORT:
Index: work7/drivers/pnp/interface.c
===================================================================
--- work7.orig/drivers/pnp/interface.c	2008-03-25 14:48:51.000000000 -0600
+++ work7/drivers/pnp/interface.c	2008-03-25 14:48:54.000000000 -0600
@@ -370,7 +370,7 @@
 		goto done;
 	}
 	if (!strnicmp(buf, "set", 3)) {
-		int nport = 0, nmem = 0, ndma = 0;
+		int nport = 0, nmem = 0;
 		if (dev->active)
 			goto done;
 		buf += 3;
@@ -439,14 +439,8 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.dma_resource[ndma].start =
-				    dev->res.dma_resource[ndma].end =
-				    simple_strtoul(buf, &buf, 0);
-				dev->res.dma_resource[ndma].flags =
-				    IORESOURCE_DMA;
-				ndma++;
-				if (ndma >= PNP_MAX_DMA)
-					break;
+				start = simple_strtoul(buf, &buf, 0);
+				pnp_add_dma_resource(dev, start, 0);
 				continue;
 			}
 			break;

-- 

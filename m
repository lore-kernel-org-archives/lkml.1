Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbYDRVFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbYDRVFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbYDRUwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:52:54 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26286 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760156AbYDRUwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:19 -0400
Message-Id: <20080418205054.510966149@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:31 -0600
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
Subject: [patch 36/53] PNP: add struct pnp_resource
Content-Disposition: inline; filename=pnp-add-struct-pnp_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This struct currently contains only a struct resource, but we will
soon need additional PNP-specific information.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |   12 ++++++++----
 drivers/pnp/isapnp/core.c      |   26 ++++++++++++++++++--------
 drivers/pnp/pnpacpi/rsparser.c |    8 ++++----
 drivers/pnp/pnpbios/rsparser.c |    8 ++++----
 drivers/pnp/resource.c         |    8 ++++----
 5 files changed, 38 insertions(+), 24 deletions(-)

Index: work8/drivers/pnp/base.h
===================================================================
--- work8.orig/drivers/pnp/base.h	2008-04-17 14:57:25.000000000 -0600
+++ work8/drivers/pnp/base.h	2008-04-17 15:04:41.000000000 -0600
@@ -24,9 +24,13 @@
 #define PNP_MAX_IRQ		 2
 #define PNP_MAX_DMA		 2
 
+struct pnp_resource {
+	struct resource res;
+};
+
 struct pnp_resource_table {
-	struct resource port_resource[PNP_MAX_PORT];
-	struct resource mem_resource[PNP_MAX_MEM];
-	struct resource dma_resource[PNP_MAX_DMA];
-	struct resource irq_resource[PNP_MAX_IRQ];
+	struct pnp_resource port[PNP_MAX_PORT];
+	struct pnp_resource mem[PNP_MAX_MEM];
+	struct pnp_resource dma[PNP_MAX_DMA];
+	struct pnp_resource irq[PNP_MAX_IRQ];
 };
Index: work8/drivers/pnp/isapnp/core.c
===================================================================
--- work8.orig/drivers/pnp/isapnp/core.c	2008-04-17 15:02:30.000000000 -0600
+++ work8/drivers/pnp/isapnp/core.c	2008-04-17 15:04:41.000000000 -0600
@@ -923,6 +923,7 @@
 
 static int isapnp_read_resources(struct pnp_dev *dev)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 	int tmp, ret;
 
@@ -932,7 +933,8 @@
 			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
 			if (!ret)
 				continue;
-			res = &dev->res->port_resource[tmp];
+			pnp_res = &dev->res->port[tmp];
+			res = &pnp_res->res;
 			res->start = ret;
 			res->flags = IORESOURCE_IO;
 		}
@@ -941,7 +943,8 @@
 			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
 				continue;
-			res = &dev->res->mem_resource[tmp];
+			pnp_res = &dev->res->mem[tmp];
+			res = &pnp_res->res;
 			res->start = ret;
 			res->flags = IORESOURCE_MEM;
 		}
@@ -951,7 +954,8 @@
 			     8);
 			if (!ret)
 				continue;
-			res = &dev->res->irq_resource[tmp];
+			pnp_res = &dev->res->irq[tmp];
+			res = &pnp_res->res;
 			res->start = res->end = ret;
 			res->flags = IORESOURCE_IRQ;
 		}
@@ -959,7 +963,8 @@
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
-			res = &dev->res->dma_resource[tmp];
+			pnp_res = &dev->res->dma[tmp];
+			res = &pnp_res->res;
 			res->start = res->end = ret;
 			res->flags = IORESOURCE_DMA;
 		}
@@ -980,20 +985,23 @@
 
 static int isapnp_set_resources(struct pnp_dev *dev)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 	int tmp;
 
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
 	for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
-		res = &dev->res->port_resource[tmp];
+		pnp_res = &dev->res->port[tmp];
+		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_IO | IORESOURCE_UNSET)) ==
 				IORESOURCE_IO)
 			isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
 					  res->start);
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
-		res = &dev->res->irq_resource[tmp];
+		pnp_res = &dev->res->irq[tmp];
+		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) ==
 				IORESOURCE_IRQ) {
 			int irq = res->start;
@@ -1003,13 +1011,15 @@
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
-		res = &dev->res->dma_resource[tmp];
+		pnp_res = &dev->res->dma[tmp];
+		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) ==
 				IORESOURCE_DMA)
 			isapnp_write_byte(ISAPNP_CFG_DMA + tmp, res->start);
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
-		res = &dev->res->mem_resource[tmp];
+		pnp_res = &dev->res->mem[tmp];
+		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) ==
 				IORESOURCE_MEM)
 			isapnp_write_word(ISAPNP_CFG_MEM + (tmp << 3),
Index: work8/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work8.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-17 15:02:30.000000000 -0600
+++ work8/drivers/pnp/pnpacpi/rsparser.c	2008-04-17 15:04:41.000000000 -0600
@@ -92,7 +92,7 @@
 		return;
 
 	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		res = &dev->res->irq_resource[i];
+		res = &dev->res->irq[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
@@ -183,7 +183,7 @@
 	static unsigned char warned;
 
 	for (i = 0; i < PNP_MAX_DMA; i++) {
-		res = &dev->res->dma_resource[i];
+		res = &dev->res->dma[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
@@ -211,7 +211,7 @@
 	static unsigned char warned;
 
 	for (i = 0; i < PNP_MAX_PORT; i++) {
-		res = &dev->res->port_resource[i];
+		res = &dev->res->port[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
@@ -241,7 +241,7 @@
 	static unsigned char warned;
 
 	for (i = 0; i < PNP_MAX_MEM; i++) {
-		res = &dev->res->mem_resource[i];
+		res = &dev->res->mem[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
Index: work8/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work8.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-17 15:02:30.000000000 -0600
+++ work8/drivers/pnp/pnpbios/rsparser.c	2008-04-17 15:04:41.000000000 -0600
@@ -60,7 +60,7 @@
 	int i;
 
 	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		res = &dev->res->irq_resource[i];
+		res = &dev->res->irq[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
@@ -82,7 +82,7 @@
 	int i;
 
 	for (i = 0; i < PNP_MAX_DMA; i++) {
-		res = &dev->res->dma_resource[i];
+		res = &dev->res->dma[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
@@ -104,7 +104,7 @@
 	int i;
 
 	for (i = 0; i < PNP_MAX_PORT; i++) {
-		res = &dev->res->port_resource[i];
+		res = &dev->res->port[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
@@ -127,7 +127,7 @@
 	int i;
 
 	for (i = 0; i < PNP_MAX_MEM; i++) {
-		res = &dev->res->mem_resource[i];
+		res = &dev->res->mem[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
Index: work8/drivers/pnp/resource.c
===================================================================
--- work8.orig/drivers/pnp/resource.c	2008-04-17 14:57:25.000000000 -0600
+++ work8/drivers/pnp/resource.c	2008-04-17 15:04:41.000000000 -0600
@@ -498,19 +498,19 @@
 	case IORESOURCE_IO:
 		if (num >= PNP_MAX_PORT)
 			return NULL;
-		return &res->port_resource[num];
+		return &res->port[num].res;
 	case IORESOURCE_MEM:
 		if (num >= PNP_MAX_MEM)
 			return NULL;
-		return &res->mem_resource[num];
+		return &res->mem[num].res;
 	case IORESOURCE_IRQ:
 		if (num >= PNP_MAX_IRQ)
 			return NULL;
-		return &res->irq_resource[num];
+		return &res->irq[num].res;
 	case IORESOURCE_DMA:
 		if (num >= PNP_MAX_DMA)
 			return NULL;
-		return &res->dma_resource[num];
+		return &res->dma[num].res;
 	}
 	return NULL;
 }

-- 

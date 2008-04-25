Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbYDYTAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbYDYTAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764767AbYDYSlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:41:15 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:19217 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764864AbYDYSk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:29 -0400
Message-Id: <20080425183932.665145836@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:49 -0600
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
Subject: [patch 42/54] PNP: add struct pnp_resource
Content-Disposition: inline; filename=pnp-add-struct-pnp_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a "struct pnp_resource".  This currently
contains only a struct resource, but we will soon need
additional PNP-specific information.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |   12 ++++++++----
 drivers/pnp/interface.c        |   13 +++++++++----
 drivers/pnp/isapnp/core.c      |   26 ++++++++++++++++++--------
 drivers/pnp/manager.c          |   32 ++++++++++++++++++++------------
 drivers/pnp/pnpacpi/rsparser.c |    8 ++++----
 drivers/pnp/pnpbios/rsparser.c |    8 ++++----
 drivers/pnp/resource.c         |    8 ++++----
 drivers/pnp/support.c          |    8 ++++----
 8 files changed, 71 insertions(+), 44 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-25 11:15:08.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-25 11:15:09.000000000 -0600
@@ -26,9 +26,13 @@
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
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-25 11:15:09.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-25 11:15:09.000000000 -0600
@@ -931,6 +931,7 @@
 
 static int isapnp_read_resources(struct pnp_dev *dev)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 	int tmp, ret;
 
@@ -940,7 +941,8 @@
 			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
 			if (!ret)
 				continue;
-			res = &dev->res->port_resource[tmp];
+			pnp_res = &dev->res->port[tmp];
+			res = &pnp_res->res;
 			res->start = ret;
 			res->flags = IORESOURCE_IO;
 		}
@@ -949,7 +951,8 @@
 			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
 				continue;
-			res = &dev->res->mem_resource[tmp];
+			pnp_res = &dev->res->mem[tmp];
+			res = &pnp_res->res;
 			res->start = ret;
 			res->flags = IORESOURCE_MEM;
 		}
@@ -959,7 +962,8 @@
 			     8);
 			if (!ret)
 				continue;
-			res = &dev->res->irq_resource[tmp];
+			pnp_res = &dev->res->irq[tmp];
+			res = &pnp_res->res;
 			res->start = res->end = ret;
 			res->flags = IORESOURCE_IRQ;
 		}
@@ -967,7 +971,8 @@
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
-			res = &dev->res->dma_resource[tmp];
+			pnp_res = &dev->res->dma[tmp];
+			res = &pnp_res->res;
 			res->start = res->end = ret;
 			res->flags = IORESOURCE_DMA;
 		}
@@ -989,6 +994,7 @@
 
 static int isapnp_set_resources(struct pnp_dev *dev)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 	int tmp;
 
@@ -996,7 +1002,8 @@
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
 	for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
-		res = &dev->res->port_resource[tmp];
+		pnp_res = &dev->res->port[tmp];
+		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_IO | IORESOURCE_UNSET)) ==
 				IORESOURCE_IO) {
 			dev_dbg(&dev->dev, "  set io  %d to 0x%llx\n",
@@ -1006,7 +1013,8 @@
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
-		res = &dev->res->irq_resource[tmp];
+		pnp_res = &dev->res->irq[tmp];
+		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) ==
 				IORESOURCE_IRQ) {
 			int irq = res->start;
@@ -1017,7 +1025,8 @@
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
-		res = &dev->res->dma_resource[tmp];
+		pnp_res = &dev->res->dma[tmp];
+		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) ==
 				IORESOURCE_DMA) {
 			dev_dbg(&dev->dev, "  set dma %d to %lld\n",
@@ -1026,7 +1035,8 @@
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
-		res = &dev->res->mem_resource[tmp];
+		pnp_res = &dev->res->mem[tmp];
+		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) ==
 				IORESOURCE_MEM) {
 			dev_dbg(&dev->dev, "  set mem %d to 0x%llx\n",
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:09.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:09.000000000 -0600
@@ -92,7 +92,7 @@
 		return;
 
 	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		res = &dev->res->irq_resource[i];
+		res = &dev->res->irq[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
@@ -185,7 +185,7 @@
 	static unsigned char warned;
 
 	for (i = 0; i < PNP_MAX_DMA; i++) {
-		res = &dev->res->dma_resource[i];
+		res = &dev->res->dma[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
@@ -213,7 +213,7 @@
 	static unsigned char warned;
 
 	for (i = 0; i < PNP_MAX_PORT; i++) {
-		res = &dev->res->port_resource[i];
+		res = &dev->res->port[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
@@ -243,7 +243,7 @@
 	static unsigned char warned;
 
 	for (i = 0; i < PNP_MAX_MEM; i++) {
-		res = &dev->res->mem_resource[i];
+		res = &dev->res->mem[i].res;
 		if (res->flags & IORESOURCE_UNSET)
 			break;
 	}
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:15:09.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:15:09.000000000 -0600
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
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-25 11:15:08.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-25 11:15:09.000000000 -0600
@@ -508,19 +508,19 @@
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
Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-04-25 11:15:08.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-25 11:15:09.000000000 -0600
@@ -19,6 +19,7 @@
 
 static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 
 	if (idx >= PNP_MAX_PORT) {
@@ -27,7 +28,8 @@
 		return 1;
 	}
 
-	res = &dev->res->port_resource[idx];
+	pnp_res = &dev->res->port[idx];
+	res = &pnp_res->res;
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
@@ -66,6 +68,7 @@
 
 static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 
 	if (idx >= PNP_MAX_MEM) {
@@ -74,7 +77,8 @@
 		return 1;
 	}
 
-	res = &dev->res->mem_resource[idx];
+	pnp_res = &dev->res->mem[idx];
+	res = &pnp_res->res;
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
@@ -123,6 +127,7 @@
 
 static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 	int i;
 
@@ -137,7 +142,8 @@
 		return 1;
 	}
 
-	res = &dev->res->irq_resource[idx];
+	pnp_res = &dev->res->irq[idx];
+	res = &pnp_res->res;
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
@@ -180,6 +186,7 @@
 
 static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 	int i;
 
@@ -193,7 +200,8 @@
 		return;
 	}
 
-	res = &dev->res->dma_resource[idx];
+	pnp_res = &dev->res->dma[idx];
+	res = &pnp_res->res;
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
@@ -251,22 +259,22 @@
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		res = &dev->res->irq_resource[idx];
+		res = &dev->res->irq[idx].res;
 		res->flags = IORESOURCE_IRQ;
 		pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		res = &dev->res->dma_resource[idx];
+		res = &dev->res->dma[idx].res;
 		res->flags = IORESOURCE_DMA;
 		pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		res = &dev->res->port_resource[idx];
+		res = &dev->res->port[idx].res;
 		res->flags = IORESOURCE_IO;
 		pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		res = &dev->res->mem_resource[idx];
+		res = &dev->res->mem[idx].res;
 		res->flags = IORESOURCE_MEM;
 		pnp_init_resource(res);
 	}
@@ -282,22 +290,22 @@
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		res = &dev->res->irq_resource[idx];
+		res = &dev->res->irq[idx].res;
 		if (res->flags & IORESOURCE_AUTO)
 			pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		res = &dev->res->dma_resource[idx];
+		res = &dev->res->dma[idx].res;
 		if (res->flags & IORESOURCE_AUTO)
 			pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		res = &dev->res->port_resource[idx];
+		res = &dev->res->port[idx].res;
 		if (res->flags & IORESOURCE_AUTO)
 			pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		res = &dev->res->mem_resource[idx];
+		res = &dev->res->mem[idx].res;
 		if (res->flags & IORESOURCE_AUTO)
 			pnp_init_resource(res);
 	}
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-04-25 11:15:08.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-04-25 11:15:09.000000000 -0600
@@ -322,6 +322,7 @@
 			  const char *ubuf, size_t count)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 	char *buf = (void *)ubuf;
 	int retval = 0;
@@ -382,7 +383,8 @@
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res->port_resource[nport];
+				pnp_res = &dev->res->port[nport];
+				res = &pnp_res->res;
 				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
@@ -403,7 +405,8 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res->mem_resource[nmem];
+				pnp_res = &dev->res->mem[nmem];
+				res = &pnp_res->res;
 				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
@@ -424,7 +427,8 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res->irq_resource[nirq];
+				pnp_res = &dev->res->irq[nirq];
+				res = &pnp_res->res;
 				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
 				res->flags = IORESOURCE_IRQ;
@@ -437,7 +441,8 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res->dma_resource[ndma];
+				pnp_res = &dev->res->dma[ndma];
+				res = &pnp_res->res;
 				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
 				res->flags = IORESOURCE_DMA;
Index: work10/drivers/pnp/support.c
===================================================================
--- work10.orig/drivers/pnp/support.c	2008-04-25 11:15:08.000000000 -0600
+++ work10/drivers/pnp/support.c	2008-04-25 11:15:09.000000000 -0600
@@ -61,26 +61,26 @@
 	dev_dbg(&dev->dev, "current resources: %s\n", desc);
 
 	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		res = &dev->res->irq_resource[i];
+		res = &dev->res->irq[i].res;
 		if (!(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  irq %lld flags 0x%lx\n",
 				(unsigned long long) res->start, res->flags);
 	}
 	for (i = 0; i < PNP_MAX_DMA; i++) {
-		res = &dev->res->dma_resource[i];
+		res = &dev->res->dma[i].res;
 		if (!(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  dma %lld flags 0x%lx\n",
 				(unsigned long long) res->start, res->flags);
 	}
 	for (i = 0; i < PNP_MAX_PORT; i++) {
-		res = &dev->res->port_resource[i];
+		res = &dev->res->port[i].res;
 		if (!(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  io  0x%llx-0x%llx flags 0x%lx\n",
 				(unsigned long long) res->start,
 				(unsigned long long) res->end, res->flags);
 	}
 	for (i = 0; i < PNP_MAX_MEM; i++) {
-		res = &dev->res->mem_resource[i];
+		res = &dev->res->mem[i].res;
 		if (!(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  mem 0x%llx-0x%llx flags 0x%lx\n",
 				(unsigned long long) res->start,

-- 

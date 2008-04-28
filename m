Return-Path: <linux-kernel-owner+w=401wt.eu-S936931AbYD1W57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936931AbYD1W57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966861AbYD1WiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:38:03 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:12982 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966810AbYD1WhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:25 -0400
Message-Id: <20080428223625.726229075@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:32 -0600
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
Subject: [patch 45/55] PNP: add pnp_resource index for ISAPNP
Content-Disposition: inline; filename=pnp-add-pnp_resource-index
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the ISAPNP config register index in the struct pnp_resource.

We need this because it is important to write ISAPNP configuration
back to the same registers we read it from.  For example, if we
read valid regions from memory descriptors 0, 1, and 3, we'd
better write them back to the same registers, without compressing
them to descriptors 0, 1, and 2.

This was previously guaranteed by using the index into the
pnp_resource_table array as the ISAPNP config register index.
However, I am removing those fixed-size arrays, so we need to
save the ISAPNP register index elsewhere.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h        |    1 
 drivers/pnp/interface.c   |   33 +++++++++++++++---------
 drivers/pnp/isapnp/core.c |   63 +++++++++++++++++++++++++++++++++-------------
 drivers/pnp/manager.c     |   32 +++++++++++++++++------
 4 files changed, 92 insertions(+), 37 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-28 16:09:43.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-28 16:09:44.000000000 -0600
@@ -31,6 +31,7 @@
 
 struct pnp_resource {
 	struct resource res;
+	unsigned int index;		/* ISAPNP config register index */
 };
 
 struct pnp_resource_table {
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-28 16:09:42.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-28 16:09:44.000000000 -0600
@@ -931,6 +931,7 @@
 
 static int isapnp_read_resources(struct pnp_dev *dev)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 	int tmp, ret;
 
@@ -940,7 +941,9 @@
 			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
 			if (!ret)
 				continue;
-			res = pnp_get_resource(dev, IORESOURCE_IO, tmp);
+			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IO, tmp);
+			pnp_res->index = tmp;
+			res = &pnp_res->res;
 			res->start = ret;
 			res->flags = IORESOURCE_IO;
 		}
@@ -949,7 +952,10 @@
 			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
 				continue;
-			res = pnp_get_resource(dev, IORESOURCE_MEM, tmp);
+			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_MEM,
+						       tmp);
+			pnp_res->index = tmp;
+			res = &pnp_res->res;
 			res->start = ret;
 			res->flags = IORESOURCE_MEM;
 		}
@@ -959,7 +965,10 @@
 			     8);
 			if (!ret)
 				continue;
-			res = pnp_get_resource(dev, IORESOURCE_IRQ, tmp);
+			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IRQ,
+						       tmp);
+			pnp_res->index = tmp;
+			res = &pnp_res->res;
 			res->start = res->end = ret;
 			res->flags = IORESOURCE_IRQ;
 		}
@@ -967,7 +976,10 @@
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
-			res = pnp_get_resource(dev, IORESOURCE_DMA, tmp);
+			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_DMA,
+						       tmp);
+			pnp_res->index = tmp;
+			res = &pnp_res->res;
 			res->start = res->end = ret;
 			res->flags = IORESOURCE_DMA;
 		}
@@ -989,45 +1001,62 @@
 
 static int isapnp_set_resources(struct pnp_dev *dev)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
-	int tmp;
+	int tmp, index;
 
 	dev_dbg(&dev->dev, "set resources\n");
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
 	for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
-		res = pnp_get_resource(dev, IORESOURCE_IO, tmp);
+		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IO, tmp);
+		if (!pnp_res)
+			continue;
+		res = &pnp_res->res;
 		if (pnp_resource_valid(res)) {
+			index = pnp_res->index;
 			dev_dbg(&dev->dev, "  set io  %d to %#llx\n",
-				tmp, (unsigned long long) res->start);
-			isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
+				index, (unsigned long long) res->start);
+			isapnp_write_word(ISAPNP_CFG_PORT + (index << 1),
 					  res->start);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
-		res = pnp_get_resource(dev, IORESOURCE_IRQ, tmp);
+		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IRQ, tmp);
+		if (!pnp_res)
+			continue;
+		res = &pnp_res->res;
 		if (pnp_resource_valid(res)) {
 			int irq = res->start;
 			if (irq == 2)
 				irq = 9;
-			dev_dbg(&dev->dev, "  set irq %d to %d\n", tmp, irq);
-			isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
+			index = pnp_res->index;
+			dev_dbg(&dev->dev, "  set irq %d to %d\n", index, irq);
+			isapnp_write_byte(ISAPNP_CFG_IRQ + (index << 1), irq);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
-		res = pnp_get_resource(dev, IORESOURCE_DMA, tmp);
+		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_DMA, tmp);
+		if (!pnp_res)
+			continue;
+		res = &pnp_res->res;
 		if (pnp_resource_valid(res)) {
+			index = pnp_res->index;
 			dev_dbg(&dev->dev, "  set dma %d to %lld\n",
-				tmp, (unsigned long long) res->start);
-			isapnp_write_byte(ISAPNP_CFG_DMA + tmp, res->start);
+				index, (unsigned long long) res->start);
+			isapnp_write_byte(ISAPNP_CFG_DMA + index, res->start);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
-		res = pnp_get_resource(dev, IORESOURCE_MEM, tmp);
+		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_MEM, tmp);
+		if (!pnp_res)
+			continue;
+		res = &pnp_res->res;
 		if (pnp_resource_valid(res)) {
+			index = pnp_res->index;
 			dev_dbg(&dev->dev, "  set mem %d to %#llx\n",
-				tmp, (unsigned long long) res->start);
-			isapnp_write_word(ISAPNP_CFG_MEM + (tmp << 3),
+				index, (unsigned long long) res->start);
+			isapnp_write_word(ISAPNP_CFG_MEM + (index << 3),
 					  (res->start >> 8) & 0xffff);
 		}
 	}
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-04-28 16:09:37.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-04-28 16:09:44.000000000 -0600
@@ -320,6 +320,7 @@
 			  const char *ubuf, size_t count)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 	char *buf = (void *)ubuf;
 	int retval = 0;
@@ -380,10 +381,12 @@
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				res = pnp_get_resource(dev, IORESOURCE_IO,
-						       nport);
-				if (!res)
+				pnp_res = pnp_get_pnp_resource(dev,
+						IORESOURCE_IO, nport);
+				if (!pnp_res)
 					break;
+				pnp_res->index = nport;
+				res = &pnp_res->res;
 				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
@@ -402,10 +405,12 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = pnp_get_resource(dev, IORESOURCE_MEM,
-						       nmem);
-				if (!res)
+				pnp_res = pnp_get_pnp_resource(dev,
+						IORESOURCE_MEM, nmem);
+				if (!pnp_res)
 					break;
+				pnp_res->index = nmem;
+				res = &pnp_res->res;
 				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
@@ -424,10 +429,12 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = pnp_get_resource(dev, IORESOURCE_IRQ,
-						       nirq);
-				if (!res)
+				pnp_res = pnp_get_pnp_resource(dev,
+						IORESOURCE_IRQ, nirq);
+				if (!pnp_res)
 					break;
+				pnp_res->index = nirq;
+				res = &pnp_res->res;
 				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
 				res->flags = IORESOURCE_IRQ;
@@ -438,10 +445,12 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = pnp_get_resource(dev, IORESOURCE_DMA,
-						       ndma);
-				if (!res)
+				pnp_res = pnp_get_pnp_resource(dev,
+						IORESOURCE_DMA, ndma);
+				if (!pnp_res)
 					break;
+				pnp_res->index = ndma;
+				res = &pnp_res->res;
 				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
 				res->flags = IORESOURCE_DMA;
Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-04-28 16:09:43.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-28 16:09:44.000000000 -0600
@@ -19,15 +19,18 @@
 
 static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 
-	res = pnp_get_resource(dev, IORESOURCE_IO, idx);
-	if (!res) {
+	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IO, idx);
+	if (!pnp_res) {
 		dev_err(&dev->dev, "too many I/O port resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
 
+	res = &pnp_res->res;
+
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  io %d already set to %#llx-%#llx "
@@ -37,6 +40,7 @@
 	}
 
 	/* set the initial values */
+	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_IO;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -65,15 +69,18 @@
 
 static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 
-	res = pnp_get_resource(dev, IORESOURCE_MEM, idx);
-	if (!res) {
+	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_MEM, idx);
+	if (!pnp_res) {
 		dev_err(&dev->dev, "too many memory resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
 
+	res = &pnp_res->res;
+
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  mem %d already set to %#llx-%#llx "
@@ -83,6 +90,7 @@
 	}
 
 	/* set the initial values */
+	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_MEM;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -121,6 +129,7 @@
 
 static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 	int i;
 
@@ -129,13 +138,15 @@
 		5, 10, 11, 12, 9, 14, 15, 7, 3, 4, 13, 0, 1, 6, 8, 2
 	};
 
-	res = pnp_get_resource(dev, IORESOURCE_IRQ, idx);
-	if (!res) {
+	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IRQ, idx);
+	if (!pnp_res) {
 		dev_err(&dev->dev, "too many IRQ resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
 
+	res = &pnp_res->res;
+
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  irq %d already set to %d flags %#lx\n",
@@ -144,6 +155,7 @@
 	}
 
 	/* set the initial values */
+	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_IRQ;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -177,6 +189,7 @@
 
 static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
 	int i;
 
@@ -185,12 +198,14 @@
 		1, 3, 5, 6, 7, 0, 2, 4
 	};
 
-	res = pnp_get_resource(dev, IORESOURCE_DMA, idx);
-	if (!res) {
+	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_DMA, idx);
+	if (!pnp_res) {
 		dev_err(&dev->dev, "too many DMA resources\n");
 		return;
 	}
 
+	res = &pnp_res->res;
+
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  dma %d already set to %d flags %#lx\n",
@@ -199,6 +214,7 @@
 	}
 
 	/* set the initial values */
+	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_DMA;
 	res->flags &= ~IORESOURCE_UNSET;
 

-- 

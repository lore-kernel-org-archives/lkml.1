Return-Path: <linux-kernel-owner+w=401wt.eu-S932981AbYDYS5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981AbYDYS5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764773AbYDYSk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:40:58 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:48777 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764849AbYDYSk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:27 -0400
Message-Id: <20080425183932.866077549@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:50 -0600
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
Subject: [patch 43/54] PNP: add pnp_resource index for ISAPNP
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
 drivers/pnp/base.h        |    1 +
 drivers/pnp/interface.c   |    4 ++++
 drivers/pnp/isapnp/core.c |   26 +++++++++++++++++---------
 drivers/pnp/manager.c     |    4 ++++
 4 files changed, 26 insertions(+), 9 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-25 11:15:09.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-25 11:15:10.000000000 -0600
@@ -28,6 +28,7 @@
 
 struct pnp_resource {
 	struct resource res;
+	unsigned int index;		/* ISAPNP config register index */
 };
 
 struct pnp_resource_table {
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-25 11:15:09.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-25 11:15:10.000000000 -0600
@@ -942,6 +942,7 @@
 			if (!ret)
 				continue;
 			pnp_res = &dev->res->port[tmp];
+			pnp_res->index = tmp;
 			res = &pnp_res->res;
 			res->start = ret;
 			res->flags = IORESOURCE_IO;
@@ -952,6 +953,7 @@
 			if (!ret)
 				continue;
 			pnp_res = &dev->res->mem[tmp];
+			pnp_res->index = tmp;
 			res = &pnp_res->res;
 			res->start = ret;
 			res->flags = IORESOURCE_MEM;
@@ -963,6 +965,7 @@
 			if (!ret)
 				continue;
 			pnp_res = &dev->res->irq[tmp];
+			pnp_res->index = tmp;
 			res = &pnp_res->res;
 			res->start = res->end = ret;
 			res->flags = IORESOURCE_IRQ;
@@ -972,6 +975,7 @@
 			if (ret == 4)
 				continue;
 			pnp_res = &dev->res->dma[tmp];
+			pnp_res->index = tmp;
 			res = &pnp_res->res;
 			res->start = res->end = ret;
 			res->flags = IORESOURCE_DMA;
@@ -996,52 +1000,56 @@
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	int tmp;
+	int tmp, index;
 
 	dev_dbg(&dev->dev, "set resources\n");
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
 	for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
 		pnp_res = &dev->res->port[tmp];
+		index = pnp_res->index;
 		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_IO | IORESOURCE_UNSET)) ==
 				IORESOURCE_IO) {
 			dev_dbg(&dev->dev, "  set io  %d to 0x%llx\n",
-				tmp, (unsigned long long) res->start);
-			isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
+				index, (unsigned long long) res->start);
+			isapnp_write_word(ISAPNP_CFG_PORT + (index << 1),
 					  res->start);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
 		pnp_res = &dev->res->irq[tmp];
+		index = pnp_res->index;
 		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) ==
 				IORESOURCE_IRQ) {
 			int irq = res->start;
 			if (irq == 2)
 				irq = 9;
-			dev_dbg(&dev->dev, "  set irq %d to %d\n", tmp, irq);
-			isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
+			dev_dbg(&dev->dev, "  set irq %d to %d\n", index, irq);
+			isapnp_write_byte(ISAPNP_CFG_IRQ + (index << 1), irq);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
 		pnp_res = &dev->res->dma[tmp];
+		index = pnp_res->index;
 		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) ==
 				IORESOURCE_DMA) {
 			dev_dbg(&dev->dev, "  set dma %d to %lld\n",
-				tmp, (unsigned long long) res->start);
-			isapnp_write_byte(ISAPNP_CFG_DMA + tmp, res->start);
+				index, (unsigned long long) res->start);
+			isapnp_write_byte(ISAPNP_CFG_DMA + index, res->start);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
 		pnp_res = &dev->res->mem[tmp];
+		index = pnp_res->index;
 		res = &pnp_res->res;
 		if ((res->flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) ==
 				IORESOURCE_MEM) {
 			dev_dbg(&dev->dev, "  set mem %d to 0x%llx\n",
-				tmp, (unsigned long long) res->start);
-			isapnp_write_word(ISAPNP_CFG_MEM + (tmp << 3),
+				index, (unsigned long long) res->start);
+			isapnp_write_word(ISAPNP_CFG_MEM + (index << 3),
 					  (res->start >> 8) & 0xffff);
 		}
 	}
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-04-25 11:15:09.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-04-25 11:15:10.000000000 -0600
@@ -384,6 +384,7 @@
 				while (isspace(*buf))
 					++buf;
 				pnp_res = &dev->res->port[nport];
+				pnp_res->index = nport;
 				res = &pnp_res->res;
 				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
@@ -406,6 +407,7 @@
 				while (isspace(*buf))
 					++buf;
 				pnp_res = &dev->res->mem[nmem];
+				pnp_res->index = nmem;
 				res = &pnp_res->res;
 				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
@@ -428,6 +430,7 @@
 				while (isspace(*buf))
 					++buf;
 				pnp_res = &dev->res->irq[nirq];
+				pnp_res->index = nirq;
 				res = &pnp_res->res;
 				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
@@ -442,6 +445,7 @@
 				while (isspace(*buf))
 					++buf;
 				pnp_res = &dev->res->dma[ndma];
+				pnp_res->index = ndma;
 				res = &pnp_res->res;
 				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-04-25 11:15:09.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-25 11:15:10.000000000 -0600
@@ -40,6 +40,7 @@
 	}
 
 	/* set the initial values */
+	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_IO;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -89,6 +90,7 @@
 	}
 
 	/* set the initial values */
+	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_MEM;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -153,6 +155,7 @@
 	}
 
 	/* set the initial values */
+	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_IRQ;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -211,6 +214,7 @@
 	}
 
 	/* set the initial values */
+	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_DMA;
 	res->flags &= ~IORESOURCE_UNSET;
 

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S967452AbYD1Wrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967452AbYD1Wrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966129AbYD1WhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:09 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30599 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966446AbYD1Wgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:53 -0400
Message-Id: <20080428223621.795967092@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:13 -0600
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
Subject: [patch 26/55] PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
Content-Disposition: inline; filename=pnp-factor-init-resources
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the common part of pnp_init_resource_table() and
pnp_clean_resource_table() into a new pnp_init_resource().
This reduces a little code duplication and will be
useful later to initialize an individual resource.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h    |    2 +
 drivers/pnp/manager.c |   90 ++++++++++++++++++++++++--------------------------
 2 files changed, 46 insertions(+), 46 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-28 16:09:22.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-28 16:09:25.000000000 -0600
@@ -18,3 +18,5 @@
 int pnp_check_dma(struct pnp_dev * dev, int idx);
 
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
+
+void pnp_init_resource(struct resource *res);
Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-04-28 16:09:24.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-28 16:09:25.000000000 -0600
@@ -234,42 +234,52 @@
 	dev_dbg(&dev->dev, "  disable dma %d\n", idx);
 }
 
+void pnp_init_resource(struct resource *res)
+{
+	unsigned long type;
+
+	type = res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
+			     IORESOURCE_IRQ | IORESOURCE_DMA);
+
+	res->name = NULL;
+	res->flags = type | IORESOURCE_AUTO | IORESOURCE_UNSET;
+	if (type == IORESOURCE_IRQ || type == IORESOURCE_DMA) {
+		res->start = -1;
+		res->end = -1;
+	} else {
+		res->start = 0;
+		res->end = 0;
+	}
+}
+
 /**
  * pnp_init_resources - Resets a resource table to default values.
  * @table: pointer to the desired resource table
  */
 void pnp_init_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *table = &dev->res;
+	struct resource *res;
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		table->irq_resource[idx].name = NULL;
-		table->irq_resource[idx].start = -1;
-		table->irq_resource[idx].end = -1;
-		table->irq_resource[idx].flags =
-		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res = &dev->res.irq_resource[idx];
+		res->flags = IORESOURCE_IRQ;
+		pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		table->dma_resource[idx].name = NULL;
-		table->dma_resource[idx].start = -1;
-		table->dma_resource[idx].end = -1;
-		table->dma_resource[idx].flags =
-		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res = &dev->res.dma_resource[idx];
+		res->flags = IORESOURCE_DMA;
+		pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		table->port_resource[idx].name = NULL;
-		table->port_resource[idx].start = 0;
-		table->port_resource[idx].end = 0;
-		table->port_resource[idx].flags =
-		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res = &dev->res.port_resource[idx];
+		res->flags = IORESOURCE_IO;
+		pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		table->mem_resource[idx].name = NULL;
-		table->mem_resource[idx].start = 0;
-		table->mem_resource[idx].end = 0;
-		table->mem_resource[idx].flags =
-		    IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res = &dev->res.mem_resource[idx];
+		res->flags = IORESOURCE_MEM;
+		pnp_init_resource(res);
 	}
 }
 
@@ -279,40 +289,36 @@
  */
 static void pnp_clean_resource_table(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct resource *res;
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		if (!(res->irq_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->irq_resource[idx].start = -1;
-		res->irq_resource[idx].end = -1;
-		res->irq_resource[idx].flags =
-		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res = &dev->res.irq_resource[idx];
+		if (res->flags & IORESOURCE_AUTO) {
+			res->flags = IORESOURCE_IRQ;
+			pnp_init_resource(res);
+		}
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		if (!(res->dma_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->dma_resource[idx].start = -1;
-		res->dma_resource[idx].end = -1;
-		res->dma_resource[idx].flags =
-		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res = &dev->res.dma_resource[idx];
+		if (res->flags & IORESOURCE_AUTO) {
+			res->flags = IORESOURCE_DMA;
+			pnp_init_resource(res);
+		}
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		if (!(res->port_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->port_resource[idx].start = 0;
-		res->port_resource[idx].end = 0;
-		res->port_resource[idx].flags =
-		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res = &dev->res.port_resource[idx];
+		if (res->flags & IORESOURCE_AUTO) {
+			res->flags = IORESOURCE_IO;
+			pnp_init_resource(res);
+		}
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		if (!(res->mem_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->mem_resource[idx].start = 0;
-		res->mem_resource[idx].end = 0;
-		res->mem_resource[idx].flags =
-		    IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res = &dev->res.mem_resource[idx];
+		if (res->flags & IORESOURCE_AUTO) {
+			res->flags = IORESOURCE_MEM;
+			pnp_init_resource(res);
+		}
 	}
 }
 

-- 

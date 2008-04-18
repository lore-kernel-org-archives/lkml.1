Return-Path: <linux-kernel-owner+w=401wt.eu-S1762410AbYDRVCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762410AbYDRVCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761385AbYDRUwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:52:42 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:35210 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761014AbYDRUwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:05 -0400
Message-Id: <20080418205051.704761191@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:17 -0600
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
Subject: [patch 22/53] PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
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
 drivers/pnp/manager.c |   86 +++++++++++++++++++-------------------------------
 2 files changed, 36 insertions(+), 52 deletions(-)

Index: work8/drivers/pnp/base.h
===================================================================
--- work8.orig/drivers/pnp/base.h	2008-04-10 16:47:29.000000000 -0600
+++ work8/drivers/pnp/base.h	2008-04-10 16:48:43.000000000 -0600
@@ -16,3 +16,5 @@
 int pnp_check_mem(struct pnp_dev * dev, int idx);
 int pnp_check_irq(struct pnp_dev * dev, int idx);
 int pnp_check_dma(struct pnp_dev * dev, int idx);
+
+void pnp_init_resource(struct resource *res);
Index: work8/drivers/pnp/manager.c
===================================================================
--- work8.orig/drivers/pnp/manager.c	2008-04-10 16:48:34.000000000 -0600
+++ work8/drivers/pnp/manager.c	2008-04-10 16:48:43.000000000 -0600
@@ -200,6 +200,24 @@
 	*flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
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
@@ -209,34 +227,14 @@
 	struct pnp_resource_table *table = &dev->res;
 	int idx;
 
-	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		table->irq_resource[idx].name = NULL;
-		table->irq_resource[idx].start = -1;
-		table->irq_resource[idx].end = -1;
-		table->irq_resource[idx].flags =
-		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
-	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		table->dma_resource[idx].name = NULL;
-		table->dma_resource[idx].start = -1;
-		table->dma_resource[idx].end = -1;
-		table->dma_resource[idx].flags =
-		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
-	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		table->port_resource[idx].name = NULL;
-		table->port_resource[idx].start = 0;
-		table->port_resource[idx].end = 0;
-		table->port_resource[idx].flags =
-		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
-	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		table->mem_resource[idx].name = NULL;
-		table->mem_resource[idx].start = 0;
-		table->mem_resource[idx].end = 0;
-		table->mem_resource[idx].flags =
-		    IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
+	for (idx = 0; idx < PNP_MAX_IRQ; idx++)
+		pnp_init_resource(&table->irq_resource[idx]);
+	for (idx = 0; idx < PNP_MAX_DMA; idx++)
+		pnp_init_resource(&table->dma_resource[idx]);
+	for (idx = 0; idx < PNP_MAX_PORT; idx++)
+		pnp_init_resource(&table->port_resource[idx]);
+	for (idx = 0; idx < PNP_MAX_MEM; idx++)
+		pnp_init_resource(&table->mem_resource[idx]);
 }
 
 /**
@@ -245,40 +243,24 @@
  */
 static void pnp_clean_resource_table(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *table = &dev->res;
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		if (!(res->irq_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->irq_resource[idx].start = -1;
-		res->irq_resource[idx].end = -1;
-		res->irq_resource[idx].flags =
-		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		if (table->irq_resource[idx].flags & IORESOURCE_AUTO)
+			pnp_init_resource(&table->irq_resource[idx]);
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		if (!(res->dma_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->dma_resource[idx].start = -1;
-		res->dma_resource[idx].end = -1;
-		res->dma_resource[idx].flags =
-		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		if (table->dma_resource[idx].flags & IORESOURCE_AUTO)
+			pnp_init_resource(&table->dma_resource[idx]);
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		if (!(res->port_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->port_resource[idx].start = 0;
-		res->port_resource[idx].end = 0;
-		res->port_resource[idx].flags =
-		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		if (table->port_resource[idx].flags & IORESOURCE_AUTO)
+			pnp_init_resource(&table->port_resource[idx]);
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		if (!(res->mem_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->mem_resource[idx].start = 0;
-		res->mem_resource[idx].end = 0;
-		res->mem_resource[idx].flags =
-		    IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		if (table->mem_resource[idx].flags & IORESOURCE_AUTO)
+			pnp_init_resource(&table->mem_resource[idx]);
 	}
 }
 

-- 

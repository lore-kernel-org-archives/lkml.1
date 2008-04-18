Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbYDRVL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbYDRVL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761542AbYDRUx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:53:29 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26425 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311AbYDRUwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:33 -0400
Message-Id: <20080418205056.370787258@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:40 -0600
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
Subject: [patch 45/53] PNP: replace pnp_resource_table with dynamically allocated resources
Content-Disposition: inline; filename=pnp-make-resources-dynamic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PNP used to have a fixed-size pnp_resource_table for tracking the
resources used by a device.  This table often overflowed, so we've
had to increase the table size, which wastes memory because most
devices have very few resources.

This patch replaces the table with a linked list of resources where
the entries are allocated on demand.

This removes messages like these:

    pnpacpi: exceeded the max number of IO resources
    00:01: too many PORTs (max 40)

References:

    http://bugzilla.kernel.org/show_bug.cgi?id=9535
    http://bugzilla.kernel.org/show_bug.cgi?id=9740
    http://lkml.org/lkml/2007/11/30/110

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h        |   13 --------
 drivers/pnp/core.c        |   20 +++++++-----
 drivers/pnp/isapnp/core.c |   56 ++++++++++++++--------------------
 drivers/pnp/manager.c     |   33 +++++---------------
 drivers/pnp/resource.c    |   74 +++++++++++++---------------------------------
 include/linux/pnp.h       |    3 -
 6 files changed, 68 insertions(+), 131 deletions(-)

Index: work8/drivers/pnp/base.h
===================================================================
--- work8.orig/drivers/pnp/base.h	2008-04-18 12:33:55.000000000 -0600
+++ work8/drivers/pnp/base.h	2008-04-18 12:33:56.000000000 -0600
@@ -20,23 +20,12 @@
 void pnp_init_resource(struct resource *res);
 int pnp_resource_type(struct resource *res);
 
-#define PNP_MAX_PORT		40
-#define PNP_MAX_MEM		24
-#define PNP_MAX_IRQ		 2
-#define PNP_MAX_DMA		 2
-
 struct pnp_resource {
+	struct list_head list;
 	struct resource res;
 	unsigned int index;		/* ISAPNP config register index */
 };
 
-struct pnp_resource_table {
-	struct pnp_resource port[PNP_MAX_PORT];
-	struct pnp_resource mem[PNP_MAX_MEM];
-	struct pnp_resource dma[PNP_MAX_DMA];
-	struct pnp_resource irq[PNP_MAX_IRQ];
-};
-
 struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
 					  int flags);
 struct pnp_resource *pnp_add_dma_resource(struct pnp_dev *dev, int dma,
Index: work8/drivers/pnp/core.c
===================================================================
--- work8.orig/drivers/pnp/core.c	2008-04-18 12:27:14.000000000 -0600
+++ work8/drivers/pnp/core.c	2008-04-18 12:33:56.000000000 -0600
@@ -99,6 +99,16 @@
 	}
 }
 
+static void pnp_free_resources(struct pnp_dev *dev)
+{
+	struct pnp_resource *pnp_res;
+
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		list_del(&pnp_res->list);
+		kfree(pnp_res);
+	}
+}
+
 static void pnp_release_device(struct device *dmdev)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
@@ -106,7 +116,7 @@
 	pnp_free_option(dev->independent);
 	pnp_free_option(dev->dependent);
 	pnp_free_ids(dev);
-	kfree(dev->res);
+	pnp_free_resources(dev);
 	kfree(dev);
 }
 
@@ -119,12 +129,7 @@
 	if (!dev)
 		return NULL;
 
-	dev->res = kzalloc(sizeof(struct pnp_resource_table), GFP_KERNEL);
-	if (!dev->res) {
-		kfree(dev);
-		return NULL;
-	}
-
+	INIT_LIST_HEAD(&dev->resources);
 	dev->protocol = protocol;
 	dev->number = id;
 
@@ -134,7 +139,6 @@
 
 	dev_id = pnp_add_id(dev, pnpid);
 	if (!dev_id) {
-		kfree(dev->res);
 		kfree(dev);
 		return NULL;
 	}
Index: work8/drivers/pnp/isapnp/core.c
===================================================================
--- work8.orig/drivers/pnp/isapnp/core.c	2008-04-18 12:32:37.000000000 -0600
+++ work8/drivers/pnp/isapnp/core.c	2008-04-18 12:33:56.000000000 -0600
@@ -970,53 +970,45 @@
 	return 0;
 }
 
+#define set(flags)	((flags & IORESOURCE_UNSET) == 0)
+
 static int isapnp_set_resources(struct pnp_dev *dev)
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	int tmp, index;
+	int index, irq;
 
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
-	for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
-		pnp_res = &dev->res->port[tmp];
-		index = pnp_res->index;
+
+	list_for_each_entry(pnp_res, &dev->resources, list) {
 		res = &pnp_res->res;
-		if ((res->flags & (IORESOURCE_IO | IORESOURCE_UNSET)) ==
-				IORESOURCE_IO)
+		if (res->flags & IORESOURCE_UNSET)
+			continue;
+
+		index = pnp_res->index;
+		switch (pnp_resource_type(res)) {
+		case IORESOURCE_IO:
 			isapnp_write_word(ISAPNP_CFG_PORT + (index << 1),
 					  res->start);
-	}
-	for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
-		pnp_res = &dev->res->irq[tmp];
-		index = pnp_res->index;
-		res = &pnp_res->res;
-		if ((res->flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) ==
-				IORESOURCE_IRQ) {
-			int irq = res->start;
+			break;
+		case IORESOURCE_MEM:
+			/* FIXME: We aren't handling 32bit mems properly here */
+			isapnp_write_word(ISAPNP_CFG_MEM + (index << 3),
+					  (res->start >> 8) & 0xffff);
+			break;
+		case IORESOURCE_IRQ:
+			irq = res->start;
 			if (irq == 2)
 				irq = 9;
 			isapnp_write_byte(ISAPNP_CFG_IRQ + (index << 1), irq);
-		}
-	}
-	for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
-		pnp_res = &dev->res->dma[tmp];
-		index = pnp_res->index;
-		res = &pnp_res->res;
-		if ((res->flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) ==
-				IORESOURCE_DMA)
+			break;
+		case IORESOURCE_DMA:
 			isapnp_write_byte(ISAPNP_CFG_DMA + index, res->start);
+			break;
+		}
 	}
-	for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
-		pnp_res = &dev->res->mem[tmp];
-		index = pnp_res->index;
-		res = &pnp_res->res;
-		if ((res->flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) ==
-				IORESOURCE_MEM)
-			isapnp_write_word(ISAPNP_CFG_MEM + (index << 3),
-				  (res->start >> 8) & 0xffff);
-	}
-	/* FIXME: We aren't handling 32bit mems properly here */
+
 	isapnp_activate(dev->number);
 	isapnp_cfg_end();
 	return 0;
Index: work8/drivers/pnp/manager.c
===================================================================
--- work8.orig/drivers/pnp/manager.c	2008-04-18 12:27:14.000000000 -0600
+++ work8/drivers/pnp/manager.c	2008-04-18 12:33:56.000000000 -0600
@@ -228,45 +228,30 @@
 
 /**
  * pnp_init_resources - Resets a resource table to default values.
- * @table: pointer to the desired resource table
+ * @dev: pointer to the desired device
  */
 void pnp_init_resources(struct pnp_dev *dev)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
-	int i;
 
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IRQ, i)); i++)
-		pnp_init_resource(res);
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_DMA, i)); i++)
-		pnp_init_resource(res);
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++)
-		pnp_init_resource(res);
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++)
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
 		pnp_init_resource(res);
+	}
 }
 
 /**
  * pnp_clean_resources - clears resources that were not manually set
- * @res: the resources to clean
+ * @dev: pointer to the desired device
  */
 static void pnp_clean_resource_table(struct pnp_dev *dev)
 {
+	struct pnp_resource *pnp_res;
 	struct resource *res;
-	int i;
 
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IRQ, i)); i++) {
-		if (res->flags & IORESOURCE_AUTO)
-			pnp_init_resource(res);
-	}
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_DMA, i)); i++) {
-		if (res->flags & IORESOURCE_AUTO)
-			pnp_init_resource(res);
-	}
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
-		if (res->flags & IORESOURCE_AUTO)
-			pnp_init_resource(res);
-	}
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
 		if (res->flags & IORESOURCE_AUTO)
 			pnp_init_resource(res);
 	}
Index: work8/drivers/pnp/resource.c
===================================================================
--- work8.orig/drivers/pnp/resource.c	2008-04-18 12:33:55.000000000 -0600
+++ work8/drivers/pnp/resource.c	2008-04-18 12:33:56.000000000 -0600
@@ -498,25 +498,13 @@
 struct resource *pnp_get_resource(struct pnp_dev *dev,
 				  unsigned int type, unsigned int num)
 {
-	struct pnp_resource_table *res = dev->res;
+	struct pnp_resource *pnp_res;
+	struct resource *res;
 
-	switch (type) {
-	case IORESOURCE_IO:
-		if (num >= PNP_MAX_PORT)
-			return NULL;
-		return &res->port[num].res;
-	case IORESOURCE_MEM:
-		if (num >= PNP_MAX_MEM)
-			return NULL;
-		return &res->mem[num].res;
-	case IORESOURCE_IRQ:
-		if (num >= PNP_MAX_IRQ)
-			return NULL;
-		return &res->irq[num].res;
-	case IORESOURCE_DMA:
-		if (num >= PNP_MAX_DMA)
-			return NULL;
-		return &res->dma[num].res;
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
+		if (pnp_resource_type(res) == type && num-- == 0)
+			return res;
 	}
 	return NULL;
 }
@@ -526,43 +514,23 @@
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	int i;
 
-	switch (type) {
-	case IORESOURCE_IO:
-		for (i = 0; i < PNP_MAX_PORT; i++) {
-			pnp_res = &dev->res->port[i];
-			res = &pnp_res->res;
-			if (res->flags & IORESOURCE_UNSET)
-				return pnp_res;
-		}
-		break;
-	case IORESOURCE_MEM:
-		for (i = 0; i < PNP_MAX_MEM; i++) {
-			pnp_res = &dev->res->mem[i];
-			res = &pnp_res->res;
-			if (res->flags & IORESOURCE_UNSET)
-				return pnp_res;
-		}
-		break;
-	case IORESOURCE_IRQ:
-		for (i = 0; i < PNP_MAX_IRQ; i++) {
-			pnp_res = &dev->res->irq[i];
-			res = &pnp_res->res;
-			if (res->flags & IORESOURCE_UNSET)
-				return pnp_res;
-		}
-		break;
-	case IORESOURCE_DMA:
-		for (i = 0; i < PNP_MAX_DMA; i++) {
-			pnp_res = &dev->res->dma[i];
-			res = &pnp_res->res;
-			if (res->flags & IORESOURCE_UNSET)
-				return pnp_res;
-		}
-		break;
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
+		if (pnp_resource_type(res) == type &&
+		    res->flags & IORESOURCE_UNSET)
+			return pnp_res;
 	}
-	return NULL;
+
+	pnp_res = kzalloc(sizeof(struct pnp_resource), GFP_KERNEL);
+	if (!pnp_res)
+		return NULL;
+
+	res = &pnp_res->res;
+	res->flags = type;
+	pnp_init_resource(res);
+	list_add_tail(&pnp_res->list, &dev->resources);
+	return pnp_res;
 }
 
 struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
Index: work8/include/linux/pnp.h
===================================================================
--- work8.orig/include/linux/pnp.h	2008-04-18 12:27:14.000000000 -0600
+++ work8/include/linux/pnp.h	2008-04-18 12:33:56.000000000 -0600
@@ -17,7 +17,6 @@
 
 struct pnp_protocol;
 struct pnp_dev;
-struct pnp_resource_table;
 
 /*
  * Resource Management
@@ -253,7 +252,7 @@
 	int capabilities;
 	struct pnp_option *independent;
 	struct pnp_option *dependent;
-	struct pnp_resource_table *res;
+	struct list_head resources;
 
 	char name[PNP_NAME_LEN];	/* contains a human-readable name */
 	unsigned short regs;		/* ISAPnP: supported registers */

-- 

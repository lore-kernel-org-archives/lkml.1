Return-Path: <linux-kernel-owner+w=401wt.eu-S933432AbYDYTEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbYDYTEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764933AbYDYSlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:41:36 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:7438 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761290AbYDYSki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:38 -0400
Message-Id: <20080425183934.149874598@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:56 -0600
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
Subject: [patch 49/54] PNP: use pnp_get_pnp_resource() in resource assignment functions
Content-Disposition: inline; filename=pnp-add-get-pnp-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes PNP_MAX_PORT, etc., uses and removes direct references
to the pnp_resource_table.

I don't like pnp_get_pnp_resource() and hope that it is temporary,
but the assignment functions need the pnp_resource (not just the
struct resource) because they need to fill in the ISAPNP index.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h     |    3 +++
 drivers/pnp/manager.c  |   16 ++++++++--------
 drivers/pnp/resource.c |   24 ++++++++++++++++++------
 3 files changed, 29 insertions(+), 14 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-25 11:15:13.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-25 11:15:14.000000000 -0600
@@ -21,6 +21,9 @@
 
 void pnp_init_resource(struct resource *res);
 
+struct pnp_resource *pnp_get_pnp_resource(struct pnp_dev *dev,
+					  unsigned int type, unsigned int num);
+
 #define PNP_MAX_PORT		40
 #define PNP_MAX_MEM		24
 #define PNP_MAX_IRQ		 2
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-25 11:15:13.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-25 11:15:14.000000000 -0600
@@ -499,8 +499,8 @@
 #endif
 }
 
-struct resource *pnp_get_resource(struct pnp_dev *dev,
-				  unsigned int type, unsigned int num)
+struct pnp_resource *pnp_get_pnp_resource(struct pnp_dev *dev,
+					  unsigned int type, unsigned int num)
 {
 	struct pnp_resource_table *res = dev->res;
 
@@ -508,22 +508,34 @@
 	case IORESOURCE_IO:
 		if (num >= PNP_MAX_PORT)
 			return NULL;
-		return &res->port[num].res;
+		return &res->port[num];
 	case IORESOURCE_MEM:
 		if (num >= PNP_MAX_MEM)
 			return NULL;
-		return &res->mem[num].res;
+		return &res->mem[num];
 	case IORESOURCE_IRQ:
 		if (num >= PNP_MAX_IRQ)
 			return NULL;
-		return &res->irq[num].res;
+		return &res->irq[num];
 	case IORESOURCE_DMA:
 		if (num >= PNP_MAX_DMA)
 			return NULL;
-		return &res->dma[num].res;
+		return &res->dma[num];
 	}
 	return NULL;
 }
+
+struct resource *pnp_get_resource(struct pnp_dev *dev,
+				  unsigned int type, unsigned int num)
+{
+	struct pnp_resource *pnp_res;
+
+	pnp_res = pnp_get_pnp_resource(dev, type, num);
+	if (pnp_res)
+		return &pnp_res->res;
+
+	return NULL;
+}
 EXPORT_SYMBOL(pnp_get_resource);
 
 static struct pnp_resource *pnp_new_resource(struct pnp_dev *dev, int type)
Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-04-25 11:15:10.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-25 11:15:14.000000000 -0600
@@ -22,13 +22,13 @@
 	struct pnp_resource *pnp_res;
 	struct resource *res;
 
-	if (idx >= PNP_MAX_PORT) {
+	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IO, idx);
+	if (!pnp_res) {
 		dev_err(&dev->dev, "too many I/O port resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
 
-	pnp_res = &dev->res->port[idx];
 	res = &pnp_res->res;
 
 	/* check if this resource has been manually set, if so skip */
@@ -72,13 +72,13 @@
 	struct pnp_resource *pnp_res;
 	struct resource *res;
 
-	if (idx >= PNP_MAX_MEM) {
+	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_MEM, idx);
+	if (!pnp_res) {
 		dev_err(&dev->dev, "too many memory resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
 
-	pnp_res = &dev->res->mem[idx];
 	res = &pnp_res->res;
 
 	/* check if this resource has been manually set, if so skip */
@@ -138,13 +138,13 @@
 		5, 10, 11, 12, 9, 14, 15, 7, 3, 4, 13, 0, 1, 6, 8, 2
 	};
 
-	if (idx >= PNP_MAX_IRQ) {
+	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IRQ, idx);
+	if (!pnp_res) {
 		dev_err(&dev->dev, "too many IRQ resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
 
-	pnp_res = &dev->res->irq[idx];
 	res = &pnp_res->res;
 
 	/* check if this resource has been manually set, if so skip */
@@ -198,12 +198,12 @@
 		1, 3, 5, 6, 7, 0, 2, 4
 	};
 
-	if (idx >= PNP_MAX_DMA) {
+	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_DMA, idx);
+	if (!pnp_res) {
 		dev_err(&dev->dev, "too many DMA resources\n");
 		return;
 	}
 
-	pnp_res = &dev->res->dma[idx];
 	res = &pnp_res->res;
 
 	/* check if this resource has been manually set, if so skip */

-- 

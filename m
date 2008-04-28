Return-Path: <linux-kernel-owner+w=401wt.eu-S936643AbYD1W4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936643AbYD1W4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966848AbYD1Whx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:53 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:31978 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966785AbYD1WhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:18 -0400
Message-Id: <20080428223625.328863535@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:30 -0600
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
Subject: [patch 43/55] PNP: add struct pnp_resource
Content-Disposition: inline; filename=pnp-add-struct-pnp_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a "struct pnp_resource".  This currently
contains only a struct resource, but we will soon need
additional PNP-specific information.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h      |   12 ++++++++----
 drivers/pnp/interface.c |    1 +
 drivers/pnp/manager.c   |   20 ++++++++++++--------
 drivers/pnp/resource.c  |    8 ++++----
 4 files changed, 25 insertions(+), 16 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-28 16:09:41.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-28 16:09:43.000000000 -0600
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
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-28 16:09:41.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:43.000000000 -0600
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
--- work10.orig/drivers/pnp/manager.c	2008-04-28 16:09:41.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-28 16:09:43.000000000 -0600
@@ -247,22 +247,22 @@
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
@@ -278,28 +278,28 @@
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		res = &dev->res->irq_resource[idx];
+		res = &dev->res->irq[idx].res;
 		if (res->flags & IORESOURCE_AUTO) {
 			res->flags = IORESOURCE_IRQ;
 			pnp_init_resource(res);
 		}
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		res = &dev->res->dma_resource[idx];
+		res = &dev->res->dma[idx].res;
 		if (res->flags & IORESOURCE_AUTO) {
 			res->flags = IORESOURCE_DMA;
 			pnp_init_resource(res);
 		}
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		res = &dev->res->port_resource[idx];
+		res = &dev->res->port[idx].res;
 		if (res->flags & IORESOURCE_AUTO) {
 			res->flags = IORESOURCE_IO;
 			pnp_init_resource(res);
 		}
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		res = &dev->res->mem_resource[idx];
+		res = &dev->res->mem[idx].res;
 		if (res->flags & IORESOURCE_AUTO) {
 			res->flags = IORESOURCE_MEM;
 			pnp_init_resource(res);

-- 

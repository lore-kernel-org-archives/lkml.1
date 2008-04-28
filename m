Return-Path: <linux-kernel-owner+w=401wt.eu-S936210AbYD1Wzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936210AbYD1Wzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966026AbYD1Whv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:51 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:31962 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966395AbYD1WhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:16 -0400
Message-Id: <20080428223625.529988852@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:31 -0600
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
Subject: [patch 44/55] PNP: add pnp_get_pnp_resource()
Content-Disposition: inline; filename=pnp-add-get-pnp-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some places, we need to get the struct pnp_resource, not just
the struct resource, because ISAPNP needs to store the register
index in the pnp_resource.

I don't like pnp_get_pnp_resource() and hope that it is temporary,
but we need it for a little while.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h     |    3 +++
 drivers/pnp/resource.c |   24 ++++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-28 16:09:43.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-28 16:09:43.000000000 -0600
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
--- work10.orig/drivers/pnp/resource.c	2008-04-28 16:09:43.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:43.000000000 -0600
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
 
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */

-- 

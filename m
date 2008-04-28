Return-Path: <linux-kernel-owner+w=401wt.eu-S967428AbYD1Wsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967428AbYD1Wsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966763AbYD1WhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:15 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30619 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966666AbYD1Wg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:56 -0400
Message-Id: <20080428223622.006658098@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:14 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 27/55] PNP: add pnp_get_resource() interface
Content-Disposition: inline; filename=pnp-add-get-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a pnp_get_resource() that works the same way as
platform_get_resource().  This will enable us to consolidate
many pnp_resource_table references in one place, which will
make it easier to make the table dynamic.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/resource.c |   27 +++++++++++++++++++++++++++
 include/linux/pnp.h    |    1 +
 2 files changed, 28 insertions(+)

Index: work10/include/linux/pnp.h
===================================================================
--- work10.orig/include/linux/pnp.h	2008-04-28 16:09:24.000000000 -0600
+++ work10/include/linux/pnp.h	2008-04-28 16:09:26.000000000 -0600
@@ -25,6 +25,7 @@
 /*
  * Resource Management
  */
+struct resource *pnp_get_resource(struct pnp_dev *, unsigned int, unsigned int);
 
 /* Use these instead of directly reading pnp_dev to get resource information */
 #define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-28 16:09:19.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:26.000000000 -0600
@@ -487,6 +487,33 @@
 #endif
 }
 
+struct resource *pnp_get_resource(struct pnp_dev *dev,
+				  unsigned int type, unsigned int num)
+{
+	struct pnp_resource_table *res = &dev->res;
+
+	switch (type) {
+	case IORESOURCE_IO:
+		if (num >= PNP_MAX_PORT)
+			return NULL;
+		return &res->port_resource[num];
+	case IORESOURCE_MEM:
+		if (num >= PNP_MAX_MEM)
+			return NULL;
+		return &res->mem_resource[num];
+	case IORESOURCE_IRQ:
+		if (num >= PNP_MAX_IRQ)
+			return NULL;
+		return &res->irq_resource[num];
+	case IORESOURCE_DMA:
+		if (num >= PNP_MAX_DMA)
+			return NULL;
+		return &res->dma_resource[num];
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(pnp_get_resource);
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {

-- 

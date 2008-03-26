Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbYCZRS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbYCZRS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbYCZRJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:09:29 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:22200 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761104AbYCZRJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:09:10 -0400
Message-Id: <20080326171228.962706020@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:26 -0600
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
Subject: [patch 28/37] PNP: add pnp_get_resource() interface
Content-Disposition: inline; filename=pnp-add-get-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a pnp_get_resource() that works the same way as
platform_get_resource().  This will enable us to consolidate
many pnp_resource_table references in one place, which will
make it easier to make the table dynamic.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 include/linux/pnp.h    |    1 +
 drivers/pnp/resource.c |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

Index: work7/include/linux/pnp.h
===================================================================
--- work7.orig/include/linux/pnp.h	2008-03-24 15:26:03.000000000 -0600
+++ work7/include/linux/pnp.h	2008-03-24 15:39:26.000000000 -0600
@@ -25,6 +25,7 @@
 /*
  * Resource Management
  */
+struct resource *pnp_get_resource(struct pnp_dev *, unsigned int, unsigned int);
 
 /* Use these instead of directly reading pnp_dev to get resource information */
 #define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
Index: work7/drivers/pnp/resource.c
===================================================================
--- work7.orig/drivers/pnp/resource.c	2008-03-24 15:26:03.000000000 -0600
+++ work7/drivers/pnp/resource.c	2008-03-24 15:40:25.000000000 -0600
@@ -560,6 +560,32 @@
 	return 0;
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
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {

-- 

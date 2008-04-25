Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbYDYTFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbYDYTFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765344AbYDYSlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:41:42 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:28759 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764072AbYDYSj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:39:56 -0400
Message-Id: <20080425183928.375529075@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:28 -0600
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
Subject: [patch 21/54] PNP: add debug when assigning PNP resources
Content-Disposition: inline; filename=pnp-add-resource-list-debug-output
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to dump PNP resources before and after
assigning resources and before writing them to the device.

This is enabled by CONFIG_PNP_DEBUG=y.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-25 11:14:51.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-25 11:14:57.000000000 -0600
@@ -16,3 +16,5 @@
 int pnp_check_mem(struct pnp_dev * dev, int idx);
 int pnp_check_irq(struct pnp_dev * dev, int idx);
 int pnp_check_dma(struct pnp_dev * dev, int idx);
+
+void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
Index: work10/drivers/pnp/support.c
===================================================================
--- work10.orig/drivers/pnp/support.c	2008-04-25 11:14:48.000000000 -0600
+++ work10/drivers/pnp/support.c	2008-04-25 11:14:57.000000000 -0600
@@ -51,3 +51,44 @@
 	str[6] = hex_asc((id >>  0) & 0xf);
 	str[7] = '\0';
 }
+
+#ifdef DEBUG
+void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
+{
+	struct resource *res;
+	int i;
+
+	dev_dbg(&dev->dev, "current resources: %s\n", desc);
+
+	for (i = 0; i < PNP_MAX_IRQ; i++) {
+		res = &dev->res.irq_resource[i];
+		if (!(res->flags & IORESOURCE_UNSET))
+			dev_dbg(&dev->dev, "  irq %lld flags 0x%lx\n",
+				(unsigned long long) res->start, res->flags);
+	}
+	for (i = 0; i < PNP_MAX_DMA; i++) {
+		res = &dev->res.dma_resource[i];
+		if (!(res->flags & IORESOURCE_UNSET))
+			dev_dbg(&dev->dev, "  dma %lld flags 0x%lx\n",
+				(unsigned long long) res->start, res->flags);
+	}
+	for (i = 0; i < PNP_MAX_PORT; i++) {
+		res = &dev->res.port_resource[i];
+		if (!(res->flags & IORESOURCE_UNSET))
+			dev_dbg(&dev->dev, "  io  0x%llx-0x%llx flags 0x%lx\n",
+				(unsigned long long) res->start,
+				(unsigned long long) res->end, res->flags);
+	}
+	for (i = 0; i < PNP_MAX_MEM; i++) {
+		res = &dev->res.mem_resource[i];
+		if (!(res->flags & IORESOURCE_UNSET))
+			dev_dbg(&dev->dev, "  mem 0x%llx-0x%llx flags 0x%lx\n",
+				(unsigned long long) res->start,
+				(unsigned long long) res->end, res->flags);
+	}
+}
+#else
+void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
+{
+}
+#endif
Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-04-25 11:14:55.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-25 11:14:57.000000000 -0600
@@ -28,20 +28,25 @@
 		return 1;
 	}
 
-	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
-		return 1;
-
 	start = &dev->res.port_resource[idx].start;
 	end = &dev->res.port_resource[idx].end;
 	flags = &dev->res.port_resource[idx].flags;
 
+	/* check if this resource has been manually set, if so skip */
+	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO)) {
+		dev_dbg(&dev->dev, "  io %d already set to 0x%llx-0x%llx "
+			"flags 0x%x\n", idx, (unsigned long long) *start,
+			(unsigned long long) *end, (int) *flags);
+		return 1;
+	}
+
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_IO;
 	*flags &= ~IORESOURCE_UNSET;
 
 	if (!rule->size) {
 		*flags |= IORESOURCE_DISABLED;
+		dev_dbg(&dev->dev, "  io %d disabled\n", idx);
 		return 1;	/* skip disabled resource requests */
 	}
 
@@ -52,9 +57,13 @@
 	while (!pnp_check_port(dev, idx)) {
 		*start += rule->align;
 		*end = *start + rule->size - 1;
-		if (*start > rule->max || !rule->align)
+		if (*start > rule->max || !rule->align) {
+			dev_dbg(&dev->dev, "  couldn't assign io %d\n", idx);
 			return 0;
+		}
 	}
+	dev_dbg(&dev->dev, "  assign io  %d 0x%llx-0x%llx\n", idx,
+		(unsigned long long) *start, (unsigned long long) *end);
 	return 1;
 }
 
@@ -69,14 +78,18 @@
 		return 1;
 	}
 
-	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO))
-		return 1;
-
 	start = &dev->res.mem_resource[idx].start;
 	end = &dev->res.mem_resource[idx].end;
 	flags = &dev->res.mem_resource[idx].flags;
 
+	/* check if this resource has been manually set, if so skip */
+	if (!(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO)) {
+		dev_dbg(&dev->dev, "  mem %d already set to 0x%llx-0x%llx "
+			"flags 0x%x\n", idx, (unsigned long long) *start,
+			(unsigned long long) *end, (int) *flags);
+		return 1;
+	}
+
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_MEM;
 	*flags &= ~IORESOURCE_UNSET;
@@ -93,6 +106,7 @@
 
 	if (!rule->size) {
 		*flags |= IORESOURCE_DISABLED;
+		dev_dbg(&dev->dev, "  mem %d disabled\n", idx);
 		return 1;	/* skip disabled resource requests */
 	}
 
@@ -103,9 +117,13 @@
 	while (!pnp_check_mem(dev, idx)) {
 		*start += rule->align;
 		*end = *start + rule->size - 1;
-		if (*start > rule->max || !rule->align)
+		if (*start > rule->max || !rule->align) {
+			dev_dbg(&dev->dev, "  couldn't assign mem %d\n", idx);
 			return 0;
+		}
 	}
+	dev_dbg(&dev->dev, "  assign mem %d 0x%llx-0x%llx\n", idx,
+		(unsigned long long) *start, (unsigned long long) *end);
 	return 1;
 }
 
@@ -126,20 +144,24 @@
 		return 1;
 	}
 
-	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO))
-		return 1;
-
 	start = &dev->res.irq_resource[idx].start;
 	end = &dev->res.irq_resource[idx].end;
 	flags = &dev->res.irq_resource[idx].flags;
 
+	/* check if this resource has been manually set, if so skip */
+	if (!(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO)) {
+		dev_dbg(&dev->dev, "  irq %d already set to %d flags 0x%x\n",
+			idx, (int) *start, (int) *flags);
+		return 1;
+	}
+
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_IRQ;
 	*flags &= ~IORESOURCE_UNSET;
 
 	if (bitmap_empty(rule->map, PNP_IRQ_NR)) {
 		*flags |= IORESOURCE_DISABLED;
+		dev_dbg(&dev->dev, "  irq %d disabled\n", idx);
 		return 1;	/* skip disabled resource requests */
 	}
 
@@ -147,15 +169,20 @@
 	*start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
 	if (*start < PNP_IRQ_NR) {
 		*end = *start;
+		dev_dbg(&dev->dev, "  assign irq %d %d\n", idx, (int) *start);
 		return 1;
 	}
 	for (i = 0; i < 16; i++) {
 		if (test_bit(xtab[i], rule->map)) {
 			*start = *end = xtab[i];
-			if (pnp_check_irq(dev, idx))
+			if (pnp_check_irq(dev, idx)) {
+				dev_dbg(&dev->dev, "  assign irq %d %d\n", idx,
+					(int) *start);
 				return 1;
+			}
 		}
 	}
+	dev_dbg(&dev->dev, "  couldn't assign irq %d\n", idx);
 	return 0;
 }
 
@@ -175,14 +202,17 @@
 		return;
 	}
 
-	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
-		return;
-
 	start = &dev->res.dma_resource[idx].start;
 	end = &dev->res.dma_resource[idx].end;
 	flags = &dev->res.dma_resource[idx].flags;
 
+	/* check if this resource has been manually set, if so skip */
+	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO)) {
+		dev_dbg(&dev->dev, "  dma %d already set to %d flags 0x%x\n",
+			idx, (int) *start, (int) *flags);
+		return;
+	}
+
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_DMA;
 	*flags &= ~IORESOURCE_UNSET;
@@ -190,14 +220,18 @@
 	for (i = 0; i < 8; i++) {
 		if (rule->map & (1 << xtab[i])) {
 			*start = *end = xtab[i];
-			if (pnp_check_dma(dev, idx))
+			if (pnp_check_dma(dev, idx)) {
+				dev_dbg(&dev->dev, "  assign dma %d %d\n", idx,
+					(int) *start);
 				return;
+			}
 		}
 	}
 #ifdef MAX_DMA_CHANNELS
 	*start = *end = MAX_DMA_CHANNELS;
 #endif
 	*flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
+	dev_dbg(&dev->dev, "  disable dma %d\n", idx);
 }
 
 /**
@@ -298,9 +332,11 @@
 	if (!pnp_can_configure(dev))
 		return -ENODEV;
 
+	dbg_pnp_show_resources(dev, "before pnp_assign_resources");
 	mutex_lock(&pnp_res_mutex);
 	pnp_clean_resource_table(&dev->res);	/* start with a fresh slate */
 	if (dev->independent) {
+		dev_dbg(&dev->dev, "assigning independent options\n");
 		port = dev->independent->port;
 		mem = dev->independent->mem;
 		irq = dev->independent->irq;
@@ -333,6 +369,8 @@
 	if (depnum) {
 		struct pnp_option *dep;
 		int i;
+
+		dev_dbg(&dev->dev, "assigning dependent option %d\n", depnum);
 		for (i = 1, dep = dev->dependent; i < depnum;
 		     i++, dep = dep->next)
 			if (!dep)
@@ -368,11 +406,13 @@
 		goto fail;
 
 	mutex_unlock(&pnp_res_mutex);
+	dbg_pnp_show_resources(dev, "after pnp_assign_resources");
 	return 1;
 
 fail:
 	pnp_clean_resource_table(&dev->res);
 	mutex_unlock(&pnp_res_mutex);
+	dbg_pnp_show_resources(dev, "after pnp_assign_resources (failed)");
 	return 0;
 }
 
@@ -473,6 +513,7 @@
 		return -EINVAL;
 	}
 
+	dbg_pnp_show_resources(dev, "pnp_start_dev");
 	if (dev->protocol->set(dev) < 0) {
 		dev_err(&dev->dev, "activation failed\n");
 		return -EIO;

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbYDYSwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbYDYSwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761398AbYDYSkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:40:31 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:40180 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764645AbYDYSkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:09 -0400
Message-Id: <20080425183930.426637983@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:38 -0600
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
Subject: [patch 31/54] PNP: reduce redundancy in pnp_assign_port() and others
Content-Disposition: inline; filename=pnp-simplify-assign-functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a temporary "res" pointer to replace repeated lookups in
the pnp resource tables.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/manager.c |  108 ++++++++++++++++++++++----------------------------
 1 file changed, 48 insertions(+), 60 deletions(-)

Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-04-25 11:15:00.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-25 11:15:03.000000000 -0600
@@ -19,8 +19,7 @@
 
 static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 {
-	resource_size_t *start, *end;
-	unsigned long *flags;
+	struct resource *res;
 
 	if (idx >= PNP_MAX_PORT) {
 		dev_err(&dev->dev, "too many I/O port resources\n");
@@ -28,49 +27,46 @@
 		return 1;
 	}
 
-	start = &dev->res.port_resource[idx].start;
-	end = &dev->res.port_resource[idx].end;
-	flags = &dev->res.port_resource[idx].flags;
+	res = &dev->res.port_resource[idx];
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO)) {
+	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  io %d already set to 0x%llx-0x%llx "
-			"flags 0x%x\n", idx, (unsigned long long) *start,
-			(unsigned long long) *end, (int) *flags);
+			"flags 0x%x\n", idx, (unsigned long long) res->start,
+			(unsigned long long) res->end, (int) res->flags);
 		return 1;
 	}
 
 	/* set the initial values */
-	*flags |= rule->flags | IORESOURCE_IO;
-	*flags &= ~IORESOURCE_UNSET;
+	res->flags |= rule->flags | IORESOURCE_IO;
+	res->flags &= ~IORESOURCE_UNSET;
 
 	if (!rule->size) {
-		*flags |= IORESOURCE_DISABLED;
+		res->flags |= IORESOURCE_DISABLED;
 		dev_dbg(&dev->dev, "  io %d disabled\n", idx);
 		return 1;	/* skip disabled resource requests */
 	}
 
-	*start = rule->min;
-	*end = *start + rule->size - 1;
+	res->start = rule->min;
+	res->end = res->start + rule->size - 1;
 
 	/* run through until pnp_check_port is happy */
 	while (!pnp_check_port(dev, idx)) {
-		*start += rule->align;
-		*end = *start + rule->size - 1;
-		if (*start > rule->max || !rule->align) {
+		res->start += rule->align;
+		res->end = res->start + rule->size - 1;
+		if (res->start > rule->max || !rule->align) {
 			dev_dbg(&dev->dev, "  couldn't assign io %d\n", idx);
 			return 0;
 		}
 	}
 	dev_dbg(&dev->dev, "  assign io  %d 0x%llx-0x%llx\n", idx,
-		(unsigned long long) *start, (unsigned long long) *end);
+		(unsigned long long) res->start, (unsigned long long) res->end);
 	return 1;
 }
 
 static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
 {
-	resource_size_t *start, *end;
-	unsigned long *flags;
+	struct resource *res;
 
 	if (idx >= PNP_MAX_MEM) {
 		dev_err(&dev->dev, "too many memory resources\n");
@@ -78,59 +74,56 @@
 		return 1;
 	}
 
-	start = &dev->res.mem_resource[idx].start;
-	end = &dev->res.mem_resource[idx].end;
-	flags = &dev->res.mem_resource[idx].flags;
+	res = &dev->res.mem_resource[idx];
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO)) {
+	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  mem %d already set to 0x%llx-0x%llx "
-			"flags 0x%x\n", idx, (unsigned long long) *start,
-			(unsigned long long) *end, (int) *flags);
+			"flags 0x%x\n", idx, (unsigned long long) res->start,
+			(unsigned long long) res->end, (int) res->flags);
 		return 1;
 	}
 
 	/* set the initial values */
-	*flags |= rule->flags | IORESOURCE_MEM;
-	*flags &= ~IORESOURCE_UNSET;
+	res->flags |= rule->flags | IORESOURCE_MEM;
+	res->flags &= ~IORESOURCE_UNSET;
 
 	/* convert pnp flags to standard Linux flags */
 	if (!(rule->flags & IORESOURCE_MEM_WRITEABLE))
-		*flags |= IORESOURCE_READONLY;
+		res->flags |= IORESOURCE_READONLY;
 	if (rule->flags & IORESOURCE_MEM_CACHEABLE)
-		*flags |= IORESOURCE_CACHEABLE;
+		res->flags |= IORESOURCE_CACHEABLE;
 	if (rule->flags & IORESOURCE_MEM_RANGELENGTH)
-		*flags |= IORESOURCE_RANGELENGTH;
+		res->flags |= IORESOURCE_RANGELENGTH;
 	if (rule->flags & IORESOURCE_MEM_SHADOWABLE)
-		*flags |= IORESOURCE_SHADOWABLE;
+		res->flags |= IORESOURCE_SHADOWABLE;
 
 	if (!rule->size) {
-		*flags |= IORESOURCE_DISABLED;
+		res->flags |= IORESOURCE_DISABLED;
 		dev_dbg(&dev->dev, "  mem %d disabled\n", idx);
 		return 1;	/* skip disabled resource requests */
 	}
 
-	*start = rule->min;
-	*end = *start + rule->size - 1;
+	res->start = rule->min;
+	res->end = res->start + rule->size - 1;
 
 	/* run through until pnp_check_mem is happy */
 	while (!pnp_check_mem(dev, idx)) {
-		*start += rule->align;
-		*end = *start + rule->size - 1;
-		if (*start > rule->max || !rule->align) {
+		res->start += rule->align;
+		res->end = res->start + rule->size - 1;
+		if (res->start > rule->max || !rule->align) {
 			dev_dbg(&dev->dev, "  couldn't assign mem %d\n", idx);
 			return 0;
 		}
 	}
 	dev_dbg(&dev->dev, "  assign mem %d 0x%llx-0x%llx\n", idx,
-		(unsigned long long) *start, (unsigned long long) *end);
+		(unsigned long long) res->start, (unsigned long long) res->end);
 	return 1;
 }
 
 static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
 {
-	resource_size_t *start, *end;
-	unsigned long *flags;
+	struct resource *res;
 	int i;
 
 	/* IRQ priority: this table is good for i386 */
@@ -144,40 +137,39 @@
 		return 1;
 	}
 
-	start = &dev->res.irq_resource[idx].start;
-	end = &dev->res.irq_resource[idx].end;
-	flags = &dev->res.irq_resource[idx].flags;
+	res = &dev->res.irq_resource[idx];
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO)) {
+	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  irq %d already set to %d flags 0x%x\n",
-			idx, (int) *start, (int) *flags);
+			idx, (int) res->start, (int) res->flags);
 		return 1;
 	}
 
 	/* set the initial values */
-	*flags |= rule->flags | IORESOURCE_IRQ;
-	*flags &= ~IORESOURCE_UNSET;
+	res->flags |= rule->flags | IORESOURCE_IRQ;
+	res->flags &= ~IORESOURCE_UNSET;
 
 	if (bitmap_empty(rule->map, PNP_IRQ_NR)) {
-		*flags |= IORESOURCE_DISABLED;
+		res->flags |= IORESOURCE_DISABLED;
 		dev_dbg(&dev->dev, "  irq %d disabled\n", idx);
 		return 1;	/* skip disabled resource requests */
 	}
 
 	/* TBD: need check for >16 IRQ */
-	*start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
-	if (*start < PNP_IRQ_NR) {
-		*end = *start;
-		dev_dbg(&dev->dev, "  assign irq %d %d\n", idx, (int) *start);
+	res->start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
+	if (res->start < PNP_IRQ_NR) {
+		res->end = res->start;
+		dev_dbg(&dev->dev, "  assign irq %d %d\n", idx,
+			(int) res->start);
 		return 1;
 	}
 	for (i = 0; i < 16; i++) {
 		if (test_bit(xtab[i], rule->map)) {
-			*start = *end = xtab[i];
+			res->start = res->end = xtab[i];
 			if (pnp_check_irq(dev, idx)) {
 				dev_dbg(&dev->dev, "  assign irq %d %d\n", idx,
-					(int) *start);
+					(int) res->start);
 				return 1;
 			}
 		}
@@ -188,8 +180,7 @@
 
 static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
-	resource_size_t *start, *end;
-	unsigned long *flags;
+	struct resource *res;
 	int i;
 
 	/* DMA priority: this table is good for i386 */
@@ -202,35 +193,33 @@
 		return;
 	}
 
-	start = &dev->res.dma_resource[idx].start;
-	end = &dev->res.dma_resource[idx].end;
-	flags = &dev->res.dma_resource[idx].flags;
+	res = &dev->res.dma_resource[idx];
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO)) {
+	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  dma %d already set to %d flags 0x%x\n",
-			idx, (int) *start, (int) *flags);
+			idx, (int) res->start, (int) res->flags);
 		return;
 	}
 
 	/* set the initial values */
-	*flags |= rule->flags | IORESOURCE_DMA;
-	*flags &= ~IORESOURCE_UNSET;
+	res->flags |= rule->flags | IORESOURCE_DMA;
+	res->flags &= ~IORESOURCE_UNSET;
 
 	for (i = 0; i < 8; i++) {
 		if (rule->map & (1 << xtab[i])) {
-			*start = *end = xtab[i];
+			res->start = res->end = xtab[i];
 			if (pnp_check_dma(dev, idx)) {
 				dev_dbg(&dev->dev, "  assign dma %d %d\n", idx,
-					(int) *start);
+					(int) res->start);
 				return;
 			}
 		}
 	}
 #ifdef MAX_DMA_CHANNELS
-	*start = *end = MAX_DMA_CHANNELS;
+	res->start = res->end = MAX_DMA_CHANNELS;
 #endif
-	*flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
+	res->flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
 	dev_dbg(&dev->dev, "  disable dma %d\n", idx);
 }
 

-- 

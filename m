Return-Path: <linux-kernel-owner+w=401wt.eu-S1763931AbYCZRTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763931AbYCZRTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761420AbYCZRJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:09:37 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:32669 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761201AbYCZRJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:09:16 -0400
Message-Id: <20080326171229.568065385@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:29 -0600
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
Subject: [patch 31/37] PNP: convert resource checks to use pnp_get_resource(), not pnp_resource_table
Content-Disposition: inline; filename=pnp-convert-checks-to-pnp_get_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes more direct references to pnp_resource_table.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/resource.c
===================================================================
--- work7.orig/drivers/pnp/resource.c	2008-03-24 16:35:33.000000000 -0600
+++ work7/drivers/pnp/resource.c	2008-03-24 16:50:00.000000000 -0600
@@ -216,14 +216,17 @@
 int pnp_check_port(struct pnp_dev *dev, int idx)
 {
 	int i;
+	struct resource *res, *tres;
 	struct pnp_dev *tdev;
 	resource_size_t *port, *end, *tport, *tend;
 
-	port = &dev->res.port_resource[idx].start;
-	end = &dev->res.port_resource[idx].end;
+	res = pnp_get_resource(dev, IORESOURCE_IO, idx);
+
+	port = &res->start;
+	end = &res->end;
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.port_resource[idx].flags))
+	if (cannot_compare(res->flags))
 		return 1;
 
 	/* check if the resource is already in use, skip if the
@@ -243,9 +246,10 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_PORT && i != idx; i++) {
-		if (dev->res.port_resource[i].flags & IORESOURCE_IO) {
-			tport = &dev->res.port_resource[i].start;
-			tend = &dev->res.port_resource[i].end;
+		tres = pnp_get_resource(dev, IORESOURCE_IO, i);
+		if (tres->flags & IORESOURCE_IO) {
+			tport = &tres->start;
+			tend = &tres->end;
 			if (ranged_conflict(port, end, tport, tend))
 				return 0;
 		}
@@ -256,12 +260,12 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_PORT; i++) {
-			if (tdev->res.port_resource[i].flags & IORESOURCE_IO) {
-				if (cannot_compare
-				    (tdev->res.port_resource[i].flags))
+			tres = pnp_get_resource(dev, IORESOURCE_IO, i);
+			if (tres->flags & IORESOURCE_IO) {
+				if (cannot_compare(tres->flags))
 					continue;
-				tport = &tdev->res.port_resource[i].start;
-				tend = &tdev->res.port_resource[i].end;
+				tport = &tres->start;
+				tend = &tres->end;
 				if (ranged_conflict(port, end, tport, tend))
 					return 0;
 			}
@@ -274,14 +278,17 @@
 int pnp_check_mem(struct pnp_dev *dev, int idx)
 {
 	int i;
+	struct resource *res, *tres;
 	struct pnp_dev *tdev;
 	resource_size_t *addr, *end, *taddr, *tend;
 
-	addr = &dev->res.mem_resource[idx].start;
-	end = &dev->res.mem_resource[idx].end;
+	res = pnp_get_resource(dev, IORESOURCE_MEM, idx);
+
+	addr = &res->start;
+	end = &res->end;
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.mem_resource[idx].flags))
+	if (cannot_compare(res->flags))
 		return 1;
 
 	/* check if the resource is already in use, skip if the
@@ -301,9 +308,10 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_MEM && i != idx; i++) {
-		if (dev->res.mem_resource[i].flags & IORESOURCE_MEM) {
-			taddr = &dev->res.mem_resource[i].start;
-			tend = &dev->res.mem_resource[i].end;
+		tres = pnp_get_resource(dev, IORESOURCE_MEM, i);
+		if (tres->flags & IORESOURCE_MEM) {
+			taddr = &tres->start;
+			tend = &tres->end;
 			if (ranged_conflict(addr, end, taddr, tend))
 				return 0;
 		}
@@ -314,12 +322,12 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_MEM; i++) {
-			if (tdev->res.mem_resource[i].flags & IORESOURCE_MEM) {
-				if (cannot_compare
-				    (tdev->res.mem_resource[i].flags))
+			tres = pnp_get_resource(dev, IORESOURCE_MEM, i);
+			if (tres->flags & IORESOURCE_MEM) {
+				if (cannot_compare(tres->flags))
 					continue;
-				taddr = &tdev->res.mem_resource[i].start;
-				tend = &tdev->res.mem_resource[i].end;
+				taddr = &tres->start;
+				tend = &tres->end;
 				if (ranged_conflict(addr, end, taddr, tend))
 					return 0;
 			}
@@ -337,11 +345,16 @@
 int pnp_check_irq(struct pnp_dev *dev, int idx)
 {
 	int i;
+	struct resource *res, *tres;
 	struct pnp_dev *tdev;
-	resource_size_t *irq = &dev->res.irq_resource[idx].start;
+	resource_size_t *irq;
+
+	res = pnp_get_resource(dev, IORESOURCE_IRQ, idx);
+
+	irq = &res->start;
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.irq_resource[idx].flags))
+	if (cannot_compare(res->flags))
 		return 1;
 
 	/* check if the resource is valid */
@@ -356,8 +369,9 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_IRQ && i != idx; i++) {
-		if (dev->res.irq_resource[i].flags & IORESOURCE_IRQ) {
-			if (dev->res.irq_resource[i].start == *irq)
+		tres = pnp_get_resource(dev, IORESOURCE_IRQ, i);
+		if (tres->flags & IORESOURCE_IRQ) {
+			if (tres->start == *irq)
 				return 0;
 		}
 	}
@@ -389,11 +403,11 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_IRQ; i++) {
-			if (tdev->res.irq_resource[i].flags & IORESOURCE_IRQ) {
-				if (cannot_compare
-				    (tdev->res.irq_resource[i].flags))
+			tres = pnp_get_resource(dev, IORESOURCE_IRQ, i);
+			if (tres->flags & IORESOURCE_IRQ) {
+				if (cannot_compare(tres->flags))
 					continue;
-				if ((tdev->res.irq_resource[i].start == *irq))
+				if (tres->start == *irq)
 					return 0;
 			}
 		}
@@ -406,11 +420,16 @@
 {
 #ifndef CONFIG_IA64
 	int i;
+	struct resource *res, *tres;
 	struct pnp_dev *tdev;
-	resource_size_t *dma = &dev->res.dma_resource[idx].start;
+	resource_size_t *dma;
+
+	res = pnp_get_resource(dev, IORESOURCE_DMA, idx);
+
+	dma = &res->start;
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.dma_resource[idx].flags))
+	if (cannot_compare(res->flags))
 		return 1;
 
 	/* check if the resource is valid */
@@ -425,8 +444,9 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_DMA && i != idx; i++) {
-		if (dev->res.dma_resource[i].flags & IORESOURCE_DMA) {
-			if (dev->res.dma_resource[i].start == *dma)
+		tres = pnp_get_resource(dev, IORESOURCE_DMA, i);
+		if (tres->flags & IORESOURCE_DMA) {
+			if (tres->start == *dma)
 				return 0;
 		}
 	}
@@ -444,11 +464,11 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_DMA; i++) {
-			if (tdev->res.dma_resource[i].flags & IORESOURCE_DMA) {
-				if (cannot_compare
-				    (tdev->res.dma_resource[i].flags))
+			tres = pnp_get_resource(dev, IORESOURCE_DMA, i);
+			if (tres->flags & IORESOURCE_DMA) {
+				if (cannot_compare(tres->flags))
 					continue;
-				if ((tdev->res.dma_resource[i].start == *dma))
+				if (tres->start == *dma)
 					return 0;
 			}
 		}

-- 

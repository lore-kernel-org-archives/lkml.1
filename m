Return-Path: <linux-kernel-owner+w=401wt.eu-S967732AbYD1Wva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967732AbYD1Wva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966819AbYD1Wh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:28 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:12687 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966704AbYD1WhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:00 -0400
Message-Id: <20080428223623.047125976@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:19 -0600
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
Subject: [patch 32/55] PNP: reduce redundancy in pnp_check_port() and others
Content-Disposition: inline; filename=pnp-simplify-check-functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a temporary "res" pointer to replace repeated lookups in
the pnp resource tables.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-28 16:09:31.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:32.000000000 -0600
@@ -243,13 +243,15 @@
 {
 	int i;
 	struct pnp_dev *tdev;
+	struct resource *res, *tres;
 	resource_size_t *port, *end, *tport, *tend;
 
-	port = &dev->res.port_resource[idx].start;
-	end = &dev->res.port_resource[idx].end;
+	res = &dev->res.port_resource[idx];
+	port = &res->start;
+	end = &res->end;
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.port_resource[idx].flags))
+	if (cannot_compare(res->flags))
 		return 1;
 
 	/* check if the resource is already in use, skip if the
@@ -269,9 +271,10 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_PORT && i != idx; i++) {
-		if (dev->res.port_resource[i].flags & IORESOURCE_IO) {
-			tport = &dev->res.port_resource[i].start;
-			tend = &dev->res.port_resource[i].end;
+		tres = &dev->res.port_resource[i];
+		if (tres->flags & IORESOURCE_IO) {
+			tport = &tres->start;
+			tend = &tres->end;
 			if (ranged_conflict(port, end, tport, tend))
 				return 0;
 		}
@@ -282,12 +285,12 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_PORT; i++) {
-			if (tdev->res.port_resource[i].flags & IORESOURCE_IO) {
-				if (cannot_compare
-				    (tdev->res.port_resource[i].flags))
+			tres = &tdev->res.port_resource[i];
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
@@ -301,13 +304,15 @@
 {
 	int i;
 	struct pnp_dev *tdev;
+	struct resource *res, *tres;
 	resource_size_t *addr, *end, *taddr, *tend;
 
-	addr = &dev->res.mem_resource[idx].start;
-	end = &dev->res.mem_resource[idx].end;
+	res = &dev->res.mem_resource[idx];
+	addr = &res->start;
+	end = &res->end;
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.mem_resource[idx].flags))
+	if (cannot_compare(res->flags))
 		return 1;
 
 	/* check if the resource is already in use, skip if the
@@ -327,9 +332,10 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_MEM && i != idx; i++) {
-		if (dev->res.mem_resource[i].flags & IORESOURCE_MEM) {
-			taddr = &dev->res.mem_resource[i].start;
-			tend = &dev->res.mem_resource[i].end;
+		tres = &dev->res.mem_resource[i];
+		if (tres->flags & IORESOURCE_MEM) {
+			taddr = &tres->start;
+			tend = &tres->end;
 			if (ranged_conflict(addr, end, taddr, tend))
 				return 0;
 		}
@@ -340,12 +346,12 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_MEM; i++) {
-			if (tdev->res.mem_resource[i].flags & IORESOURCE_MEM) {
-				if (cannot_compare
-				    (tdev->res.mem_resource[i].flags))
+			tres = &tdev->res.mem_resource[i];
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
@@ -364,10 +370,14 @@
 {
 	int i;
 	struct pnp_dev *tdev;
-	resource_size_t *irq = &dev->res.irq_resource[idx].start;
+	struct resource *res, *tres;
+	resource_size_t *irq;
+
+	res = &dev->res.irq_resource[idx];
+	irq = &res->start;
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.irq_resource[idx].flags))
+	if (cannot_compare(res->flags))
 		return 1;
 
 	/* check if the resource is valid */
@@ -382,8 +392,9 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_IRQ && i != idx; i++) {
-		if (dev->res.irq_resource[i].flags & IORESOURCE_IRQ) {
-			if (dev->res.irq_resource[i].start == *irq)
+		tres = &dev->res.irq_resource[i];
+		if (tres->flags & IORESOURCE_IRQ) {
+			if (tres->start == *irq)
 				return 0;
 		}
 	}
@@ -415,11 +426,11 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_IRQ; i++) {
-			if (tdev->res.irq_resource[i].flags & IORESOURCE_IRQ) {
-				if (cannot_compare
-				    (tdev->res.irq_resource[i].flags))
+			tres = &tdev->res.irq_resource[i];
+			if (tres->flags & IORESOURCE_IRQ) {
+				if (cannot_compare(tres->flags))
 					continue;
-				if ((tdev->res.irq_resource[i].start == *irq))
+				if (tres->start == *irq)
 					return 0;
 			}
 		}
@@ -433,10 +444,14 @@
 #ifndef CONFIG_IA64
 	int i;
 	struct pnp_dev *tdev;
-	resource_size_t *dma = &dev->res.dma_resource[idx].start;
+	struct resource *res, *tres;
+	resource_size_t *dma;
+
+	res = &dev->res.dma_resource[idx];
+	dma = &res->start;
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.dma_resource[idx].flags))
+	if (cannot_compare(res->flags))
 		return 1;
 
 	/* check if the resource is valid */
@@ -451,8 +466,9 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_DMA && i != idx; i++) {
-		if (dev->res.dma_resource[i].flags & IORESOURCE_DMA) {
-			if (dev->res.dma_resource[i].start == *dma)
+		tres = &dev->res.dma_resource[i];
+		if (tres->flags & IORESOURCE_DMA) {
+			if (tres->start == *dma)
 				return 0;
 		}
 	}
@@ -470,11 +486,11 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_DMA; i++) {
-			if (tdev->res.dma_resource[i].flags & IORESOURCE_DMA) {
-				if (cannot_compare
-				    (tdev->res.dma_resource[i].flags))
+			tres = &tdev->res.dma_resource[i];
+			if (tres->flags & IORESOURCE_DMA) {
+				if (cannot_compare(tres->flags))
 					continue;
-				if ((tdev->res.dma_resource[i].start == *dma))
+				if (tres->start == *dma)
 					return 0;
 			}
 		}

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S967849AbYD1Wwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967849AbYD1Wwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966827AbYD1Whh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:37 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:31925 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966739AbYD1WhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:09 -0400
Message-Id: <20080428223624.295390288@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:25 -0600
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
Subject: [patch 38/55] PNP: convert assign, interface to use pnp_get_resource(), not pnp_resource_table
Content-Disposition: inline; filename=pnp-convert-assigns-to-pnp_get_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes more direct references to pnp_resource_table from the
pnp_assign_resources() path and the /sys user interface path.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-04-28 16:09:34.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-28 16:09:36.000000000 -0600
@@ -21,14 +21,13 @@
 {
 	struct resource *res;
 
-	if (idx >= PNP_MAX_PORT) {
+	res = pnp_get_resource(dev, IORESOURCE_IO, idx);
+	if (!res) {
 		dev_err(&dev->dev, "too many I/O port resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
 
-	res = &dev->res.port_resource[idx];
-
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  io %d already set to %#llx-%#llx "
@@ -68,14 +67,13 @@
 {
 	struct resource *res;
 
-	if (idx >= PNP_MAX_MEM) {
+	res = pnp_get_resource(dev, IORESOURCE_MEM, idx);
+	if (!res) {
 		dev_err(&dev->dev, "too many memory resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
 
-	res = &dev->res.mem_resource[idx];
-
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  mem %d already set to %#llx-%#llx "
@@ -131,14 +129,13 @@
 		5, 10, 11, 12, 9, 14, 15, 7, 3, 4, 13, 0, 1, 6, 8, 2
 	};
 
-	if (idx >= PNP_MAX_IRQ) {
+	res = pnp_get_resource(dev, IORESOURCE_IRQ, idx);
+	if (!res) {
 		dev_err(&dev->dev, "too many IRQ resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
 
-	res = &dev->res.irq_resource[idx];
-
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  irq %d already set to %d flags %#lx\n",
@@ -188,13 +185,12 @@
 		1, 3, 5, 6, 7, 0, 2, 4
 	};
 
-	if (idx >= PNP_MAX_DMA) {
+	res = pnp_get_resource(dev, IORESOURCE_DMA, idx);
+	if (!res) {
 		dev_err(&dev->dev, "too many DMA resources\n");
 		return;
 	}
 
-	res = &dev->res.dma_resource[idx];
-
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
 		dev_dbg(&dev->dev, "  dma %d already set to %d flags %#lx\n",
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-04-28 16:09:33.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-04-28 16:09:36.000000000 -0600
@@ -383,7 +383,10 @@
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res.port_resource[nport];
+				res = pnp_get_resource(dev, IORESOURCE_IO,
+						       nport);
+				if (!res)
+					break;
 				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
@@ -396,15 +399,16 @@
 					res->end = res->start;
 				res->flags = IORESOURCE_IO;
 				nport++;
-				if (nport >= PNP_MAX_PORT)
-					break;
 				continue;
 			}
 			if (!strnicmp(buf, "mem", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res.mem_resource[nmem];
+				res = pnp_get_resource(dev, IORESOURCE_MEM,
+						       nmem);
+				if (!res)
+					break;
 				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
@@ -417,34 +421,34 @@
 					res->end = res->start;
 				res->flags = IORESOURCE_MEM;
 				nmem++;
-				if (nmem >= PNP_MAX_MEM)
-					break;
 				continue;
 			}
 			if (!strnicmp(buf, "irq", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res.irq_resource[nirq];
+				res = pnp_get_resource(dev, IORESOURCE_IRQ,
+						       nirq);
+				if (!res)
+					break;
 				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
 				res->flags = IORESOURCE_IRQ;
 				nirq++;
-				if (nirq >= PNP_MAX_IRQ)
-					break;
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res.dma_resource[ndma];
+				res = pnp_get_resource(dev, IORESOURCE_DMA,
+						       ndma);
+				if (!res)
+					break;
 				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
 				res->flags = IORESOURCE_DMA;
 				ndma++;
-				if (ndma >= PNP_MAX_DMA)
-					break;
 				continue;
 			}
 			break;
Index: work10/drivers/pnp/support.c
===================================================================
--- work10.orig/drivers/pnp/support.c	2008-04-28 16:09:22.000000000 -0600
+++ work10/drivers/pnp/support.c	2008-04-28 16:09:36.000000000 -0600
@@ -61,27 +61,27 @@
 	dev_dbg(&dev->dev, "current resources: %s\n", desc);
 
 	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		res = &dev->res.irq_resource[i];
-		if (!(res->flags & IORESOURCE_UNSET))
+		res = pnp_get_resource(dev, IORESOURCE_IRQ, i);
+		if (res && !(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  irq %lld flags %#lx\n",
 				(unsigned long long) res->start, res->flags);
 	}
 	for (i = 0; i < PNP_MAX_DMA; i++) {
-		res = &dev->res.dma_resource[i];
-		if (!(res->flags & IORESOURCE_UNSET))
+		res = pnp_get_resource(dev, IORESOURCE_DMA, i);
+		if (res && !(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  dma %lld flags %#lx\n",
 				(unsigned long long) res->start, res->flags);
 	}
 	for (i = 0; i < PNP_MAX_PORT; i++) {
-		res = &dev->res.port_resource[i];
-		if (!(res->flags & IORESOURCE_UNSET))
+		res = pnp_get_resource(dev, IORESOURCE_IO, i);
+		if (res && !(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  io  %#llx-%#llx flags %#lx\n",
 				(unsigned long long) res->start,
 				(unsigned long long) res->end, res->flags);
 	}
 	for (i = 0; i < PNP_MAX_MEM; i++) {
-		res = &dev->res.mem_resource[i];
-		if (!(res->flags & IORESOURCE_UNSET))
+		res = pnp_get_resource(dev, IORESOURCE_MEM, i);
+		if (res && !(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  mem %#llx-%#llx flags %#lx\n",
 				(unsigned long long) res->start,
 				(unsigned long long) res->end, res->flags);

-- 

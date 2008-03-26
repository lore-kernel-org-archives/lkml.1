Return-Path: <linux-kernel-owner+w=401wt.eu-S1764129AbYCZRVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764129AbYCZRVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759055AbYCZRJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:09:47 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:27551 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761262AbYCZRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:09:17 -0400
Message-Id: <20080326171229.969984416@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:31 -0600
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
Subject: [patch 33/37] PNP: remove PNP_MAX_* uses
Content-Disposition: inline; filename=pnp-remove-max-uses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some PNP_MAX_* uses.  The pnp_resource_table isn't
dynamic yet, but with pnp_get_resource(), we can start moving
away from the table size constants.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/interface.c |   43 +++++++++++++++++++++----------------------
 drivers/pnp/quirks.c    |   15 +++++++++------
 drivers/pnp/resource.c  |   40 ++++++++++++++++++++++++----------------
 drivers/pnp/system.c    |   21 ++++++++++-----------
 4 files changed, 64 insertions(+), 55 deletions(-)

Index: work7/drivers/pnp/interface.c
===================================================================
--- work7.orig/drivers/pnp/interface.c	2008-03-24 16:35:22.000000000 -0600
+++ work7/drivers/pnp/interface.c	2008-03-24 16:51:17.000000000 -0600
@@ -243,11 +243,14 @@
 
 static DEVICE_ATTR(options, S_IRUGO, pnp_show_options, NULL);
 
+#define set(flags)      ((flags & IORESOURCE_UNSET) == 0)
+
 static ssize_t pnp_show_current_resources(struct device *dmdev,
 					  struct device_attribute *attr,
 					  char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+	struct resource *res;
 	int i, ret;
 	pnp_info_buffer_t *buffer;
 
@@ -267,50 +270,46 @@
 	else
 		pnp_printf(buffer, "disabled\n");
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
-		if (pnp_port_valid(dev, i)) {
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
+		if (set(res->flags)) {
 			pnp_printf(buffer, "io");
-			if (pnp_port_flags(dev, i) & IORESOURCE_DISABLED)
+			if (res->flags & IORESOURCE_DISABLED)
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " 0x%llx-0x%llx\n",
-					   (unsigned long long)
-					   pnp_port_start(dev, i),
-					   (unsigned long long)pnp_port_end(dev,
-									    i));
+					   (unsigned long long) res->start,
+					   (unsigned long long) res->end);
 		}
 	}
-	for (i = 0; i < PNP_MAX_MEM; i++) {
-		if (pnp_mem_valid(dev, i)) {
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
+		if (set(res->flags)) {
 			pnp_printf(buffer, "mem");
-			if (pnp_mem_flags(dev, i) & IORESOURCE_DISABLED)
+			if (res->flags & IORESOURCE_DISABLED)
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " 0x%llx-0x%llx\n",
-					   (unsigned long long)
-					   pnp_mem_start(dev, i),
-					   (unsigned long long)pnp_mem_end(dev,
-									   i));
+					   (unsigned long long) res->start,
+					   (unsigned long long) res->end);
 		}
 	}
-	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		if (pnp_irq_valid(dev, i)) {
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IRQ, i)); i++) {
+		if (set(res->flags)) {
 			pnp_printf(buffer, "irq");
-			if (pnp_irq_flags(dev, i) & IORESOURCE_DISABLED)
+			if (res->flags & IORESOURCE_DISABLED)
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " %lld\n",
-					   (unsigned long long)pnp_irq(dev, i));
+					   (unsigned long long) res->start);
 		}
 	}
-	for (i = 0; i < PNP_MAX_DMA; i++) {
-		if (pnp_dma_valid(dev, i)) {
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_DMA, i)); i++) {
+		if (set(res->flags)) {
 			pnp_printf(buffer, "dma");
-			if (pnp_dma_flags(dev, i) & IORESOURCE_DISABLED)
+			if (res->flags & IORESOURCE_DISABLED)
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " %lld\n",
-					   (unsigned long long)pnp_dma(dev, i));
+					   (unsigned long long) res->start);
 		}
 	}
 	ret = (buffer->curr - buf);
Index: work7/drivers/pnp/quirks.c
===================================================================
--- work7.orig/drivers/pnp/quirks.c	2008-03-24 16:35:22.000000000 -0600
+++ work7/drivers/pnp/quirks.c	2008-03-24 16:51:17.000000000 -0600
@@ -114,6 +114,7 @@
 static void quirk_system_pci_resources(struct pnp_dev *dev)
 {
 	struct pci_dev *pdev = NULL;
+	struct resource *res;
 	resource_size_t pnp_start, pnp_end, pci_start, pci_end;
 	int i, j;
 
@@ -134,13 +135,15 @@
 
 			pci_start = pci_resource_start(pdev, i);
 			pci_end = pci_resource_end(pdev, i);
-			for (j = 0; j < PNP_MAX_MEM; j++) {
-				if (!pnp_mem_valid(dev, j) ||
-				    pnp_mem_len(dev, j) == 0)
+			for (j = 0;
+			     (res = pnp_get_resource(dev, IORESOURCE_MEM, j));
+			     j++) {
+				if (res->flags & IORESOURCE_UNSET ||
+				    (res->start == 0 && res->end == 0))
 					continue;
 
-				pnp_start = pnp_mem_start(dev, j);
-				pnp_end = pnp_mem_end(dev, j);
+				pnp_start = res->start;
+				pnp_end = res->end;
 
 				/*
 				 * If the PNP region doesn't overlap the PCI
@@ -173,7 +176,7 @@
 					pci_name(pdev), i,
 					(unsigned long long) pci_start,
 					(unsigned long long) pci_end);
-				pnp_mem_flags(dev, j) = 0;
+				res->flags = 0;
 			}
 		}
 	}
Index: work7/drivers/pnp/resource.c
===================================================================
--- work7.orig/drivers/pnp/resource.c	2008-03-24 16:51:28.000000000 -0600
+++ work7/drivers/pnp/resource.c	2008-03-24 16:58:00.000000000 -0600
@@ -245,8 +245,9 @@
 	}
 
 	/* check for internal conflicts */
-	for (i = 0; i < PNP_MAX_PORT && i != idx; i++) {
-		tres = pnp_get_resource(dev, IORESOURCE_IO, i);
+	for (i = 0;
+	     i != idx && (tres = pnp_get_resource(dev, IORESOURCE_IO, i));
+	     i++) {
 		if (tres->flags & IORESOURCE_IO) {
 			tport = &tres->start;
 			tend = &tres->end;
@@ -259,8 +260,9 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (i = 0; i < PNP_MAX_PORT; i++) {
-			tres = pnp_get_resource(dev, IORESOURCE_IO, i);
+		for (i = 0;
+		     (tres = pnp_get_resource(dev, IORESOURCE_IO, i));
+		     i++) {
 			if (tres->flags & IORESOURCE_IO) {
 				if (cannot_compare(tres->flags))
 					continue;
@@ -307,8 +309,9 @@
 	}
 
 	/* check for internal conflicts */
-	for (i = 0; i < PNP_MAX_MEM && i != idx; i++) {
-		tres = pnp_get_resource(dev, IORESOURCE_MEM, i);
+	for (i = 0;
+	     i != idx && (tres = pnp_get_resource(dev, IORESOURCE_MEM, i));
+	     i++) {
 		if (tres->flags & IORESOURCE_MEM) {
 			taddr = &tres->start;
 			tend = &tres->end;
@@ -321,8 +324,9 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (i = 0; i < PNP_MAX_MEM; i++) {
-			tres = pnp_get_resource(dev, IORESOURCE_MEM, i);
+		for (i = 0;
+		     (tres = pnp_get_resource(dev, IORESOURCE_MEM, i));
+		     i++) {
 			if (tres->flags & IORESOURCE_MEM) {
 				if (cannot_compare(tres->flags))
 					continue;
@@ -368,8 +372,9 @@
 	}
 
 	/* check for internal conflicts */
-	for (i = 0; i < PNP_MAX_IRQ && i != idx; i++) {
-		tres = pnp_get_resource(dev, IORESOURCE_IRQ, i);
+	for (i = 0;
+	     i != idx && (tres = pnp_get_resource(dev, IORESOURCE_IRQ, i));
+	     i++) {
 		if (tres->flags & IORESOURCE_IRQ) {
 			if (tres->start == *irq)
 				return 0;
@@ -402,8 +407,9 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (i = 0; i < PNP_MAX_IRQ; i++) {
-			tres = pnp_get_resource(dev, IORESOURCE_IRQ, i);
+		for (i = 0;
+		     (tres = pnp_get_resource(dev, IORESOURCE_IRQ, i));
+		     i++) {
 			if (tres->flags & IORESOURCE_IRQ) {
 				if (cannot_compare(tres->flags))
 					continue;
@@ -443,8 +449,9 @@
 	}
 
 	/* check for internal conflicts */
-	for (i = 0; i < PNP_MAX_DMA && i != idx; i++) {
-		tres = pnp_get_resource(dev, IORESOURCE_DMA, i);
+	for (i = 0;
+	     i != idx && (tres = pnp_get_resource(dev, IORESOURCE_DMA, i));
+	     i++) {
 		if (tres->flags & IORESOURCE_DMA) {
 			if (tres->start == *dma)
 				return 0;
@@ -463,8 +470,9 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (i = 0; i < PNP_MAX_DMA; i++) {
-			tres = pnp_get_resource(dev, IORESOURCE_DMA, i);
+		for (i = 0;
+		     (tres = pnp_get_resource(dev, IORESOURCE_DMA, i));
+		     i++) {
 			if (tres->flags & IORESOURCE_DMA) {
 				if (cannot_compare(tres->flags))
 					continue;
Index: work7/drivers/pnp/system.c
===================================================================
--- work7.orig/drivers/pnp/system.c	2008-03-24 16:35:22.000000000 -0600
+++ work7/drivers/pnp/system.c	2008-03-24 16:51:17.000000000 -0600
@@ -56,14 +56,15 @@
 
 static void reserve_resources_of_dev(struct pnp_dev *dev)
 {
+	struct resource *res;
 	int i;
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
-		if (!pnp_port_valid(dev, i))
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
+		if (res->flags & IORESOURCE_UNSET)
 			continue;
-		if (pnp_port_start(dev, i) == 0)
+		if (res->start == 0)
 			continue;	/* disabled */
-		if (pnp_port_start(dev, i) < 0x100)
+		if (res->start < 0x100)
 			/*
 			 * Below 0x100 is only standard PC hardware
 			 * (pics, kbd, timer, dma, ...)
@@ -73,19 +74,17 @@
 			 * So, do nothing
 			 */
 			continue;
-		if (pnp_port_end(dev, i) < pnp_port_start(dev, i))
+		if (res->end < res->start)
 			continue;	/* invalid */
 
-		reserve_range(dev, pnp_port_start(dev, i),
-			      pnp_port_end(dev, i), 1);
+		reserve_range(dev, res->start, res->end, 1);
 	}
 
-	for (i = 0; i < PNP_MAX_MEM; i++) {
-		if (!pnp_mem_valid(dev, i))
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
+		if (res->flags & IORESOURCE_UNSET)
 			continue;
 
-		reserve_range(dev, pnp_mem_start(dev, i),
-			      pnp_mem_end(dev, i), 0);
+		reserve_range(dev, res->start, res->end, 0);
 	}
 }
 

-- 

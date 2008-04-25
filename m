Return-Path: <linux-kernel-owner+w=401wt.eu-S1761977AbYDYS6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977AbYDYS6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765098AbYDYSlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:41:01 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:32292 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764821AbYDYSk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:26 -0400
Message-Id: <20080425183932.457629051@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:48 -0600
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
Subject: [patch 41/54] PNP: remove pnp_resource_table references from resource decoders
Content-Disposition: inline; filename=pnp-remove-pnp_resource_table-from-decoders
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a few more references to the pnp_resource_table.
No functional change.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/isapnp/core.c      |   87 ++++++++++++++++++++--------------------
 drivers/pnp/pnpacpi/rsparser.c |   88 ++++++++++++++++++++++-------------------
 drivers/pnp/pnpbios/rsparser.c |   82 +++++++++++++++++++++-----------------
 3 files changed, 138 insertions(+), 119 deletions(-)

Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-25 11:15:08.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-25 11:15:09.000000000 -0600
@@ -931,7 +931,7 @@
 
 static int isapnp_read_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *res = dev->res;
+	struct resource *res;
 	int tmp, ret;
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
@@ -940,16 +940,18 @@
 			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
 			if (!ret)
 				continue;
-			res->port_resource[tmp].start = ret;
-			res->port_resource[tmp].flags = IORESOURCE_IO;
+			res = &dev->res->port_resource[tmp];
+			res->start = ret;
+			res->flags = IORESOURCE_IO;
 		}
 		for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
 			ret =
 			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
 				continue;
-			res->mem_resource[tmp].start = ret;
-			res->mem_resource[tmp].flags = IORESOURCE_MEM;
+			res = &dev->res->mem_resource[tmp];
+			res->start = ret;
+			res->flags = IORESOURCE_MEM;
 		}
 		for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
 			ret =
@@ -957,17 +959,17 @@
 			     8);
 			if (!ret)
 				continue;
-			res->irq_resource[tmp].start =
-			    res->irq_resource[tmp].end = ret;
-			res->irq_resource[tmp].flags = IORESOURCE_IRQ;
+			res = &dev->res->irq_resource[tmp];
+			res->start = res->end = ret;
+			res->flags = IORESOURCE_IRQ;
 		}
 		for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
-			res->dma_resource[tmp].start =
-			    res->dma_resource[tmp].end = ret;
-			res->dma_resource[tmp].flags = IORESOURCE_DMA;
+			res = &dev->res->dma_resource[tmp];
+			res->start = res->end = ret;
+			res->flags = IORESOURCE_DMA;
 		}
 	}
 	return 0;
@@ -987,52 +989,51 @@
 
 static int isapnp_set_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *res = dev->res;
+	struct resource *res;
 	int tmp;
 
 	dev_dbg(&dev->dev, "set resources\n");
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
-	for (tmp = 0;
-	     tmp < ISAPNP_MAX_PORT
-	     && (res->port_resource[tmp].
-		 flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO;
-	     tmp++) {
-		dev_dbg(&dev->dev, "  set io  %d to 0x%llx\n",
-			tmp, (unsigned long long) res->port_resource[tmp].start);
-		isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
-				  res->port_resource[tmp].start);
-	}
-	for (tmp = 0;
-	     tmp < ISAPNP_MAX_IRQ
-	     && (res->irq_resource[tmp].
-		 flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) == IORESOURCE_IRQ;
-	     tmp++) {
-		int irq = res->irq_resource[tmp].start;
-		if (irq == 2)
-			irq = 9;
-		dev_dbg(&dev->dev, "  set irq %d to %d\n", tmp, irq);
-		isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
-	}
-	for (tmp = 0;
-	     tmp < ISAPNP_MAX_DMA
-	     && (res->dma_resource[tmp].
-		 flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) == IORESOURCE_DMA;
-	     tmp++) {
-		dev_dbg(&dev->dev, "  set dma %d to %lld\n",
-			tmp, (unsigned long long) res->dma_resource[tmp].start);
-		isapnp_write_byte(ISAPNP_CFG_DMA + tmp,
-				  res->dma_resource[tmp].start);
-	}
-	for (tmp = 0;
-	     tmp < ISAPNP_MAX_MEM
-	     && (res->mem_resource[tmp].
-		 flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) == IORESOURCE_MEM;
-	     tmp++) {
-		dev_dbg(&dev->dev, "  set mem %d to 0x%llx\n",
-			tmp, (unsigned long long) res->mem_resource[tmp].start);
-		isapnp_write_word(ISAPNP_CFG_MEM + (tmp << 3),
-				  (res->mem_resource[tmp].start >> 8) & 0xffff);
+	for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
+		res = &dev->res->port_resource[tmp];
+		if ((res->flags & (IORESOURCE_IO | IORESOURCE_UNSET)) ==
+				IORESOURCE_IO) {
+			dev_dbg(&dev->dev, "  set io  %d to 0x%llx\n",
+				tmp, (unsigned long long) res->start);
+			isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
+					  res->start);
+		}
+	}
+	for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
+		res = &dev->res->irq_resource[tmp];
+		if ((res->flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) ==
+				IORESOURCE_IRQ) {
+			int irq = res->start;
+			if (irq == 2)
+				irq = 9;
+			dev_dbg(&dev->dev, "  set irq %d to %d\n", tmp, irq);
+			isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
+		}
+	}
+	for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
+		res = &dev->res->dma_resource[tmp];
+		if ((res->flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) ==
+				IORESOURCE_DMA) {
+			dev_dbg(&dev->dev, "  set dma %d to %lld\n",
+				tmp, (unsigned long long) res->start);
+			isapnp_write_byte(ISAPNP_CFG_DMA + tmp, res->start);
+		}
+	}
+	for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
+		res = &dev->res->mem_resource[tmp];
+		if ((res->flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) ==
+				IORESOURCE_MEM) {
+			dev_dbg(&dev->dev, "  set mem %d to 0x%llx\n",
+				tmp, (unsigned long long) res->start);
+			isapnp_write_word(ISAPNP_CFG_MEM + (tmp << 3),
+					  (res->start >> 8) & 0xffff);
+		}
 	}
 	/* FIXME: We aren't handling 32bit mems properly here */
 	isapnp_activate(dev->number);
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:08.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:09.000000000 -0600
@@ -82,8 +82,8 @@
 						u32 gsi, int triggering,
 						int polarity, int shareable)
 {
-	struct pnp_resource_table *res = dev->res;
-	int i = 0;
+	struct resource *res;
+	int i;
 	int irq;
 	int p, t;
 	static unsigned char warned;
@@ -91,9 +91,11 @@
 	if (!valid_IRQ(gsi))
 		return;
 
-	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
-	       i < PNP_MAX_IRQ)
-		i++;
+	for (i = 0; i < PNP_MAX_IRQ; i++) {
+		res = &dev->res->irq_resource[i];
+		if (res->flags & IORESOURCE_UNSET)
+			break;
+	}
 	if (i >= PNP_MAX_IRQ) {
 		if (!warned) {
 			printk(KERN_WARNING "pnpacpi: exceeded the max number"
@@ -119,16 +121,16 @@
 		}
 	}
 
-	res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
-	res->irq_resource[i].flags |= irq_flags(triggering, polarity, shareable);
+	res->flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
+	res->flags |= irq_flags(triggering, polarity, shareable);
 	irq = acpi_register_gsi(gsi, triggering, polarity);
 	if (irq < 0) {
-		res->irq_resource[i].flags |= IORESOURCE_DISABLED;
+		res->flags |= IORESOURCE_DISABLED;
 		return;
 	}
 
-	res->irq_resource[i].start = irq;
-	res->irq_resource[i].end = irq;
+	res->start = irq;
+	res->end = irq;
 	pcibios_penalize_isa_irq(irq, 1);
 }
 
@@ -178,22 +180,24 @@
 static void pnpacpi_parse_allocated_dmaresource(struct pnp_dev *dev,
 						u32 dma, int flags)
 {
-	struct pnp_resource_table *res = dev->res;
-	int i = 0;
+	struct resource *res;
+	int i;
 	static unsigned char warned;
 
-	while (i < PNP_MAX_DMA &&
-	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
-		i++;
+	for (i = 0; i < PNP_MAX_DMA; i++) {
+		res = &dev->res->dma_resource[i];
+		if (res->flags & IORESOURCE_UNSET)
+			break;
+	}
 	if (i < PNP_MAX_DMA) {
-		res->dma_resource[i].flags = IORESOURCE_DMA;	// Also clears _UNSET flag
-		res->dma_resource[i].flags |= flags;
+		res->flags = IORESOURCE_DMA;	// Also clears _UNSET flag
+		res->flags |= flags;
 		if (dma == -1) {
-			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
+			res->flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->dma_resource[i].start = dma;
-		res->dma_resource[i].end = dma;
+		res->start = dma;
+		res->end = dma;
 	} else if (!warned) {
 		printk(KERN_WARNING "pnpacpi: exceeded the max number of DMA "
 				"resources: %d \n", PNP_MAX_DMA);
@@ -204,23 +208,25 @@
 static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev,
 					       u64 io, u64 len, int io_decode)
 {
-	struct pnp_resource_table *res = dev->res;
-	int i = 0;
+	struct resource *res;
+	int i;
 	static unsigned char warned;
 
-	while (!(res->port_resource[i].flags & IORESOURCE_UNSET) &&
-	       i < PNP_MAX_PORT)
-		i++;
+	for (i = 0; i < PNP_MAX_PORT; i++) {
+		res = &dev->res->port_resource[i];
+		if (res->flags & IORESOURCE_UNSET)
+			break;
+	}
 	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
+		res->flags = IORESOURCE_IO;	// Also clears _UNSET flag
 		if (io_decode == ACPI_DECODE_16)
-			res->port_resource[i].flags |= PNP_PORT_FLAG_16BITADDR;
+			res->flags |= PNP_PORT_FLAG_16BITADDR;
 		if (len <= 0 || (io + len - 1) >= 0x10003) {
-			res->port_resource[i].flags |= IORESOURCE_DISABLED;
+			res->flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->port_resource[i].start = io;
-		res->port_resource[i].end = io + len - 1;
+		res->start = io;
+		res->end = io + len - 1;
 	} else if (!warned) {
 		printk(KERN_WARNING "pnpacpi: exceeded the max number of IO "
 				"resources: %d \n", PNP_MAX_PORT);
@@ -232,24 +238,26 @@
 						u64 mem, u64 len,
 						int write_protect)
 {
-	struct pnp_resource_table *res = dev->res;
-	int i = 0;
+	struct resource *res;
+	int i;
 	static unsigned char warned;
 
-	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET) &&
-	       (i < PNP_MAX_MEM))
-		i++;
+	for (i = 0; i < PNP_MAX_MEM; i++) {
+		res = &dev->res->mem_resource[i];
+		if (res->flags & IORESOURCE_UNSET)
+			break;
+	}
 	if (i < PNP_MAX_MEM) {
-		res->mem_resource[i].flags = IORESOURCE_MEM;	// Also clears _UNSET flag
+		res->flags = IORESOURCE_MEM;	// Also clears _UNSET flag
 		if (len <= 0) {
-			res->mem_resource[i].flags |= IORESOURCE_DISABLED;
+			res->flags |= IORESOURCE_DISABLED;
 			return;
 		}
 		if (write_protect == ACPI_READ_WRITE_MEMORY)
-			res->mem_resource[i].flags |= IORESOURCE_MEM_WRITEABLE;
+			res->flags |= IORESOURCE_MEM_WRITEABLE;
 
-		res->mem_resource[i].start = mem;
-		res->mem_resource[i].end = mem + len - 1;
+		res->start = mem;
+		res->end = mem + len - 1;
 	} else if (!warned) {
 		printk(KERN_WARNING "pnpacpi: exceeded the max number of mem "
 				"resources: %d\n", PNP_MAX_MEM);
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:15:08.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:15:09.000000000 -0600
@@ -56,80 +56,90 @@
 
 static void pnpbios_parse_allocated_irqresource(struct pnp_dev *dev, int irq)
 {
-	struct pnp_resource_table *res = dev->res;
-	int i = 0;
+	struct resource *res;
+	int i;
+
+	for (i = 0; i < PNP_MAX_IRQ; i++) {
+		res = &dev->res->irq_resource[i];
+		if (res->flags & IORESOURCE_UNSET)
+			break;
+	}
 
-	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET)
-	       && i < PNP_MAX_IRQ)
-		i++;
 	if (i < PNP_MAX_IRQ) {
-		res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
+		res->flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
 		if (irq == -1) {
-			res->irq_resource[i].flags |= IORESOURCE_DISABLED;
+			res->flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->irq_resource[i].start =
-		    res->irq_resource[i].end = (unsigned long)irq;
+		res->start = res->end = (unsigned long)irq;
 		pcibios_penalize_isa_irq(irq, 1);
 	}
 }
 
 static void pnpbios_parse_allocated_dmaresource(struct pnp_dev *dev, int dma)
 {
-	struct pnp_resource_table *res = dev->res;
-	int i = 0;
+	struct resource *res;
+	int i;
+
+	for (i = 0; i < PNP_MAX_DMA; i++) {
+		res = &dev->res->dma_resource[i];
+		if (res->flags & IORESOURCE_UNSET)
+			break;
+	}
 
-	while (i < PNP_MAX_DMA &&
-	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
-		i++;
 	if (i < PNP_MAX_DMA) {
-		res->dma_resource[i].flags = IORESOURCE_DMA;	// Also clears _UNSET flag
+		res->flags = IORESOURCE_DMA;	// Also clears _UNSET flag
 		if (dma == -1) {
-			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
+			res->flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->dma_resource[i].start =
-		    res->dma_resource[i].end = (unsigned long)dma;
+		res->start = res->end = (unsigned long)dma;
 	}
 }
 
 static void pnpbios_parse_allocated_ioresource(struct pnp_dev *dev,
 					       int io, int len)
 {
-	struct pnp_resource_table *res = dev->res;
-	int i = 0;
+	struct resource *res;
+	int i;
+
+	for (i = 0; i < PNP_MAX_PORT; i++) {
+		res = &dev->res->port_resource[i];
+		if (res->flags & IORESOURCE_UNSET)
+			break;
+	}
 
-	while (!(res->port_resource[i].flags & IORESOURCE_UNSET)
-	       && i < PNP_MAX_PORT)
-		i++;
 	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
+		res->flags = IORESOURCE_IO;	// Also clears _UNSET flag
 		if (len <= 0 || (io + len - 1) >= 0x10003) {
-			res->port_resource[i].flags |= IORESOURCE_DISABLED;
+			res->flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->port_resource[i].start = (unsigned long)io;
-		res->port_resource[i].end = (unsigned long)(io + len - 1);
+		res->start = (unsigned long)io;
+		res->end = (unsigned long)(io + len - 1);
 	}
 }
 
 static void pnpbios_parse_allocated_memresource(struct pnp_dev *dev,
 						int mem, int len)
 {
-	struct pnp_resource_table *res = dev->res;
-	int i = 0;
+	struct resource *res;
+	int i;
+
+	for (i = 0; i < PNP_MAX_MEM; i++) {
+		res = &dev->res->mem_resource[i];
+		if (res->flags & IORESOURCE_UNSET)
+			break;
+	}
 
-	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET)
-	       && i < PNP_MAX_MEM)
-		i++;
 	if (i < PNP_MAX_MEM) {
-		res->mem_resource[i].flags = IORESOURCE_MEM;	// Also clears _UNSET flag
+		res->flags = IORESOURCE_MEM;	// Also clears _UNSET flag
 		if (len <= 0) {
-			res->mem_resource[i].flags |= IORESOURCE_DISABLED;
+			res->flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->mem_resource[i].start = (unsigned long)mem;
-		res->mem_resource[i].end = (unsigned long)(mem + len - 1);
+		res->start = (unsigned long)mem;
+		res->end = (unsigned long)(mem + len - 1);
 	}
 }
 

-- 

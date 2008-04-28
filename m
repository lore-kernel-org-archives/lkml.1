Return-Path: <linux-kernel-owner+w=401wt.eu-S968152AbYD1XEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968152AbYD1XEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966929AbYD1Wil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:38:41 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30547 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934638AbYD1Wgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:48 -0400
Message-Id: <20080428223620.523037604@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:07 -0600
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
Subject: [patch 20/55] PNP: add debug output to encoders
Content-Disposition: inline; filename=pnp-add-encoder-debug-output
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debug output to encoders (enabled by CONFIG_PNP_DEBUG).  This
uses dev_printk, so I had to add pnp_dev arguments at the same time.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/isapnp/core.c      |    2 
 drivers/pnp/pnpacpi/core.c     |    2 
 drivers/pnp/pnpacpi/rsparser.c |   90 +++++++++++++++++++++++++++++------------
 drivers/pnp/pnpbios/core.c     |    2 
 drivers/pnp/pnpbios/rsparser.c |   58 ++++++++++++++++++++------
 5 files changed, 114 insertions(+), 40 deletions(-)

Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-28 16:09:20.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-28 16:09:21.000000000 -0600
@@ -980,6 +980,7 @@
 {
 	int ret;
 
+	dev_dbg(&dev->dev, "get resources\n");
 	pnp_init_resource_table(&dev->res);
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	ret = isapnp_read_resources(dev);
@@ -992,15 +993,19 @@
 	struct pnp_resource_table *res = &dev->res;
 	int tmp;
 
+	dev_dbg(&dev->dev, "set resources\n");
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
 	for (tmp = 0;
 	     tmp < ISAPNP_MAX_PORT
 	     && (res->port_resource[tmp].
 		 flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO;
-	     tmp++)
+	     tmp++) {
+		dev_dbg(&dev->dev, "  set io  %d to %#llx\n",
+			tmp, (unsigned long long) res->port_resource[tmp].start);
 		isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
 				  res->port_resource[tmp].start);
+	}
 	for (tmp = 0;
 	     tmp < ISAPNP_MAX_IRQ
 	     && (res->irq_resource[tmp].
@@ -1009,22 +1014,29 @@
 		int irq = res->irq_resource[tmp].start;
 		if (irq == 2)
 			irq = 9;
+		dev_dbg(&dev->dev, "  set irq %d to %d\n", tmp, irq);
 		isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
 	}
 	for (tmp = 0;
 	     tmp < ISAPNP_MAX_DMA
 	     && (res->dma_resource[tmp].
 		 flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) == IORESOURCE_DMA;
-	     tmp++)
+	     tmp++) {
+		dev_dbg(&dev->dev, "  set dma %d to %lld\n",
+			tmp, (unsigned long long) res->dma_resource[tmp].start);
 		isapnp_write_byte(ISAPNP_CFG_DMA + tmp,
 				  res->dma_resource[tmp].start);
+	}
 	for (tmp = 0;
 	     tmp < ISAPNP_MAX_MEM
 	     && (res->mem_resource[tmp].
 		 flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) == IORESOURCE_MEM;
-	     tmp++)
+	     tmp++) {
+		dev_dbg(&dev->dev, "  set mem %d to %#llx\n",
+			tmp, (unsigned long long) res->mem_resource[tmp].start);
 		isapnp_write_word(ISAPNP_CFG_MEM + (tmp << 3),
 				  (res->mem_resource[tmp].start >> 8) & 0xffff);
+	}
 	/* FIXME: We aren't handling 32bit mems properly here */
 	isapnp_activate(dev->number);
 	isapnp_cfg_end();
Index: work10/drivers/pnp/pnpacpi/core.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/core.c	2008-04-28 16:09:20.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/core.c	2008-04-28 16:09:21.000000000 -0600
@@ -77,6 +77,7 @@
 {
 	acpi_status status;
 
+	dev_dbg(&dev->dev, "get resources\n");
 	status = pnpacpi_parse_allocated_resource(dev);
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
@@ -88,6 +89,7 @@
 	int ret;
 	acpi_status status;
 
+	dev_dbg(&dev->dev, "set resources\n");
 	ret = pnpacpi_build_resource_template(dev, &buffer);
 	if (ret)
 		return ret;
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:20.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:21.000000000 -0600
@@ -408,6 +408,8 @@
 {
 	acpi_handle handle = dev->data;
 
+	dev_dbg(&dev->dev, "parse allocated resources\n");
+
 	/* Blank the resource table values */
 	pnp_init_resource_table(&dev->res);
 
@@ -738,6 +740,8 @@
 	acpi_status status;
 	struct acpipnp_parse_option_s parse_data;
 
+	dev_dbg(&dev->dev, "parse resource options\n");
+
 	parse_data.option = pnp_register_independent_option(dev);
 	if (!parse_data.option)
 		return AE_ERROR;
@@ -814,7 +818,7 @@
 	buffer->pointer = kzalloc(buffer->length - 1, GFP_KERNEL);
 	if (!buffer->pointer)
 		return -ENOMEM;
-	pnp_dbg("Res cnt %d", res_cnt);
+
 	resource = (struct acpi_resource *)buffer->pointer;
 	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
 				     pnpacpi_type_resources, &resource);
@@ -829,7 +833,8 @@
 	return 0;
 }
 
-static void pnpacpi_encode_irq(struct acpi_resource *resource,
+static void pnpacpi_encode_irq(struct pnp_dev *dev,
+			       struct acpi_resource *resource,
 			       struct resource *p)
 {
 	struct acpi_resource_irq *irq = &resource->data.irq;
@@ -844,9 +849,15 @@
 		irq->sharable = ACPI_SHARED;
 	irq->interrupt_count = 1;
 	irq->interrupts[0] = p->start;
+
+	dev_dbg(&dev->dev, "  encode irq %d %s %s %s\n", (int) p->start,
+		triggering == ACPI_LEVEL_SENSITIVE ? "level" : "edge",
+		polarity == ACPI_ACTIVE_LOW ? "low" : "high",
+		irq->sharable == ACPI_SHARED ? "shared" : "exclusive");
 }
 
-static void pnpacpi_encode_ext_irq(struct acpi_resource *resource,
+static void pnpacpi_encode_ext_irq(struct pnp_dev *dev,
+				   struct acpi_resource *resource,
 				   struct resource *p)
 {
 	struct acpi_resource_extended_irq *extended_irq = &resource->data.extended_irq;
@@ -862,9 +873,15 @@
 		extended_irq->sharable = ACPI_SHARED;
 	extended_irq->interrupt_count = 1;
 	extended_irq->interrupts[0] = p->start;
+
+	dev_dbg(&dev->dev, "  encode irq %d %s %s %s\n", (int) p->start,
+		triggering == ACPI_LEVEL_SENSITIVE ? "level" : "edge",
+		polarity == ACPI_ACTIVE_LOW ? "low" : "high",
+		extended_irq->sharable == ACPI_SHARED ? "shared" : "exclusive");
 }
 
-static void pnpacpi_encode_dma(struct acpi_resource *resource,
+static void pnpacpi_encode_dma(struct pnp_dev *dev,
+			       struct acpi_resource *resource,
 			       struct resource *p)
 {
 	struct acpi_resource_dma *dma = &resource->data.dma;
@@ -898,9 +915,14 @@
 	dma->bus_master = !!(p->flags & IORESOURCE_DMA_MASTER);
 	dma->channel_count = 1;
 	dma->channels[0] = p->start;
+
+	dev_dbg(&dev->dev, "  encode dma %d "
+		"type %#x transfer %#x master %d\n",
+		(int) p->start, dma->type, dma->transfer, dma->bus_master);
 }
 
-static void pnpacpi_encode_io(struct acpi_resource *resource,
+static void pnpacpi_encode_io(struct pnp_dev *dev,
+			      struct acpi_resource *resource,
 			      struct resource *p)
 {
 	struct acpi_resource_io *io = &resource->data.io;
@@ -912,18 +934,27 @@
 	io->maximum = p->end;
 	io->alignment = 0;	/* Correct? */
 	io->address_length = p->end - p->start + 1;
+
+	dev_dbg(&dev->dev, "  encode io %#llx-%#llx decode %#x\n",
+		(unsigned long long) p->start, (unsigned long long) p->end,
+		io->io_decode);
 }
 
-static void pnpacpi_encode_fixed_io(struct acpi_resource *resource,
+static void pnpacpi_encode_fixed_io(struct pnp_dev *dev,
+				    struct acpi_resource *resource,
 				    struct resource *p)
 {
 	struct acpi_resource_fixed_io *fixed_io = &resource->data.fixed_io;
 
 	fixed_io->address = p->start;
 	fixed_io->address_length = p->end - p->start + 1;
+
+	dev_dbg(&dev->dev, "  encode fixed_io %#llx-%#llx\n",
+		(unsigned long long) p->start, (unsigned long long) p->end);
 }
 
-static void pnpacpi_encode_mem24(struct acpi_resource *resource,
+static void pnpacpi_encode_mem24(struct pnp_dev *dev,
+				 struct acpi_resource *resource,
 				 struct resource *p)
 {
 	struct acpi_resource_memory24 *memory24 = &resource->data.memory24;
@@ -936,9 +967,14 @@
 	memory24->maximum = p->end;
 	memory24->alignment = 0;
 	memory24->address_length = p->end - p->start + 1;
+
+	dev_dbg(&dev->dev, "  encode mem24 %#llx-%#llx write_protect %#x\n",
+		(unsigned long long) p->start, (unsigned long long) p->end,
+		memory24->write_protect);
 }
 
-static void pnpacpi_encode_mem32(struct acpi_resource *resource,
+static void pnpacpi_encode_mem32(struct pnp_dev *dev,
+				 struct acpi_resource *resource,
 				 struct resource *p)
 {
 	struct acpi_resource_memory32 *memory32 = &resource->data.memory32;
@@ -950,9 +986,14 @@
 	memory32->maximum = p->end;
 	memory32->alignment = 0;
 	memory32->address_length = p->end - p->start + 1;
+
+	dev_dbg(&dev->dev, "  encode mem32 %#llx-%#llx write_protect %#x\n",
+		(unsigned long long) p->start, (unsigned long long) p->end,
+		memory32->write_protect);
 }
 
-static void pnpacpi_encode_fixed_mem32(struct acpi_resource *resource,
+static void pnpacpi_encode_fixed_mem32(struct pnp_dev *dev,
+				       struct acpi_resource *resource,
 				       struct resource *p)
 {
 	struct acpi_resource_fixed_memory32 *fixed_memory32 = &resource->data.fixed_memory32;
@@ -962,6 +1003,11 @@
 	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
 	fixed_memory32->address = p->start;
 	fixed_memory32->address_length = p->end - p->start + 1;
+
+	dev_dbg(&dev->dev, "  encode fixed_mem32 %#llx-%#llx "
+		"write_protect %#x\n",
+		(unsigned long long) p->start, (unsigned long long) p->end,
+		fixed_memory32->write_protect);
 }
 
 int pnpacpi_encode_resources(struct pnp_dev *dev, struct acpi_buffer *buffer)
@@ -973,57 +1019,49 @@
 	struct acpi_resource *resource = buffer->pointer;
 	int port = 0, irq = 0, dma = 0, mem = 0;
 
-	pnp_dbg("res cnt %d", res_cnt);
+	dev_dbg(&dev->dev, "encode %d resources\n", res_cnt);
 	while (i < res_cnt) {
 		switch (resource->type) {
 		case ACPI_RESOURCE_TYPE_IRQ:
-			pnp_dbg("Encode irq");
-			pnpacpi_encode_irq(resource,
+			pnpacpi_encode_irq(dev, resource,
 					   &res_table->irq_resource[irq]);
 			irq++;
 			break;
 
 		case ACPI_RESOURCE_TYPE_DMA:
-			pnp_dbg("Encode dma");
-			pnpacpi_encode_dma(resource,
+			pnpacpi_encode_dma(dev, resource,
 					   &res_table->dma_resource[dma]);
 			dma++;
 			break;
 		case ACPI_RESOURCE_TYPE_IO:
-			pnp_dbg("Encode io");
-			pnpacpi_encode_io(resource,
+			pnpacpi_encode_io(dev, resource,
 					  &res_table->port_resource[port]);
 			port++;
 			break;
 		case ACPI_RESOURCE_TYPE_FIXED_IO:
-			pnp_dbg("Encode fixed io");
-			pnpacpi_encode_fixed_io(resource,
+			pnpacpi_encode_fixed_io(dev, resource,
 						&res_table->
 						port_resource[port]);
 			port++;
 			break;
 		case ACPI_RESOURCE_TYPE_MEMORY24:
-			pnp_dbg("Encode mem24");
-			pnpacpi_encode_mem24(resource,
+			pnpacpi_encode_mem24(dev, resource,
 					     &res_table->mem_resource[mem]);
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_MEMORY32:
-			pnp_dbg("Encode mem32");
-			pnpacpi_encode_mem32(resource,
+			pnpacpi_encode_mem32(dev, resource,
 					     &res_table->mem_resource[mem]);
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
-			pnp_dbg("Encode fixed mem32");
-			pnpacpi_encode_fixed_mem32(resource,
+			pnpacpi_encode_fixed_mem32(dev, resource,
 						   &res_table->
 						   mem_resource[mem]);
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
-			pnp_dbg("Encode ext irq");
-			pnpacpi_encode_ext_irq(resource,
+			pnpacpi_encode_ext_irq(dev, resource,
 					       &res_table->irq_resource[irq]);
 			irq++;
 			break;
Index: work10/drivers/pnp/pnpbios/core.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/core.c	2008-04-28 16:09:20.000000000 -0600
+++ work10/drivers/pnp/pnpbios/core.c	2008-04-28 16:09:21.000000000 -0600
@@ -212,6 +212,7 @@
 	if (!pnpbios_is_dynamic(dev))
 		return -EPERM;
 
+	dev_dbg(&dev->dev, "get resources\n");
 	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -1;
@@ -234,6 +235,7 @@
 	if (!pnpbios_is_dynamic(dev))
 		return -EPERM;
 
+	dev_dbg(&dev->dev, "set resources\n");
 	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -1;
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:20.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:21.000000000 -0600
@@ -143,6 +143,8 @@
 	if (!p)
 		return NULL;
 
+	dev_dbg(&dev->dev, "parse allocated resources\n");
+
 	/* Blank the resource table values */
 	pnp_init_resource_table(&dev->res);
 
@@ -390,6 +392,8 @@
 	if (!p)
 		return NULL;
 
+	dev_dbg(&dev->dev, "parse resource options\n");
+
 	option_independent = option = pnp_register_independent_option(dev);
 	if (!option)
 		return NULL;
@@ -574,7 +578,8 @@
  * Allocated Resource Encoding
  */
 
-static void pnpbios_encode_mem(unsigned char *p, struct resource *res)
+static void pnpbios_encode_mem(struct pnp_dev *dev, unsigned char *p,
+			       struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
@@ -585,9 +590,13 @@
 	p[7] = ((base >> 8) >> 8) & 0xff;
 	p[10] = (len >> 8) & 0xff;
 	p[11] = ((len >> 8) >> 8) & 0xff;
+
+	dev_dbg(&dev->dev, "  encode mem %#llx-%#llx\n",
+		(unsigned long long) res->start, (unsigned long long) res->end);
 }
 
-static void pnpbios_encode_mem32(unsigned char *p, struct resource *res)
+static void pnpbios_encode_mem32(struct pnp_dev *dev, unsigned char *p,
+				 struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
@@ -604,9 +613,13 @@
 	p[17] = (len >> 8) & 0xff;
 	p[18] = (len >> 16) & 0xff;
 	p[19] = (len >> 24) & 0xff;
+
+	dev_dbg(&dev->dev, "  encode mem32 %#llx-%#llx\n",
+		(unsigned long long) res->start, (unsigned long long) res->end);
 }
 
-static void pnpbios_encode_fixed_mem32(unsigned char *p, struct resource *res)
+static void pnpbios_encode_fixed_mem32(struct pnp_dev *dev, unsigned char *p,
+				       struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
@@ -619,26 +632,36 @@
 	p[9] = (len >> 8) & 0xff;
 	p[10] = (len >> 16) & 0xff;
 	p[11] = (len >> 24) & 0xff;
+
+	dev_dbg(&dev->dev, "  encode fixed_mem32 %#llx-%#llx\n",
+		(unsigned long long) res->start, (unsigned long long) res->end);
 }
 
-static void pnpbios_encode_irq(unsigned char *p, struct resource *res)
+static void pnpbios_encode_irq(struct pnp_dev *dev, unsigned char *p,
+			       struct resource *res)
 {
 	unsigned long map = 0;
 
 	map = 1 << res->start;
 	p[1] = map & 0xff;
 	p[2] = (map >> 8) & 0xff;
+
+	dev_dbg(&dev->dev, "  encode irq %d\n", res->start);
 }
 
-static void pnpbios_encode_dma(unsigned char *p, struct resource *res)
+static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
+			       struct resource *res)
 {
 	unsigned long map = 0;
 
 	map = 1 << res->start;
 	p[1] = map & 0xff;
+
+	dev_dbg(&dev->dev, "  encode dma %d\n", res->start);
 }
 
-static void pnpbios_encode_port(unsigned char *p, struct resource *res)
+static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
+				struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
@@ -648,9 +671,13 @@
 	p[4] = base & 0xff;
 	p[5] = (base >> 8) & 0xff;
 	p[7] = len & 0xff;
+
+	dev_dbg(&dev->dev, "  encode io %#llx-%#llx\n",
+		(unsigned long long) res->start, (unsigned long long) res->end);
 }
 
-static void pnpbios_encode_fixed_port(unsigned char *p, struct resource *res)
+static void pnpbios_encode_fixed_port(struct pnp_dev *dev, unsigned char *p,
+				      struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
@@ -658,6 +685,9 @@
 	p[1] = base & 0xff;
 	p[2] = (base >> 8) & 0xff;
 	p[3] = len & 0xff;
+
+	dev_dbg(&dev->dev, "  encode fixed_io %#llx-%#llx\n",
+		(unsigned long long) res->start, (unsigned long long) res->end);
 }
 
 static unsigned char *pnpbios_encode_allocated_resource_data(struct pnp_dev
@@ -688,42 +718,42 @@
 		case LARGE_TAG_MEM:
 			if (len != 9)
 				goto len_err;
-			pnpbios_encode_mem(p, &res->mem_resource[mem]);
+			pnpbios_encode_mem(dev, p, &res->mem_resource[mem]);
 			mem++;
 			break;
 
 		case LARGE_TAG_MEM32:
 			if (len != 17)
 				goto len_err;
-			pnpbios_encode_mem32(p, &res->mem_resource[mem]);
+			pnpbios_encode_mem32(dev, p, &res->mem_resource[mem]);
 			mem++;
 			break;
 
 		case LARGE_TAG_FIXEDMEM32:
 			if (len != 9)
 				goto len_err;
-			pnpbios_encode_fixed_mem32(p, &res->mem_resource[mem]);
+			pnpbios_encode_fixed_mem32(dev, p, &res->mem_resource[mem]);
 			mem++;
 			break;
 
 		case SMALL_TAG_IRQ:
 			if (len < 2 || len > 3)
 				goto len_err;
-			pnpbios_encode_irq(p, &res->irq_resource[irq]);
+			pnpbios_encode_irq(dev, p, &res->irq_resource[irq]);
 			irq++;
 			break;
 
 		case SMALL_TAG_DMA:
 			if (len != 2)
 				goto len_err;
-			pnpbios_encode_dma(p, &res->dma_resource[dma]);
+			pnpbios_encode_dma(dev, p, &res->dma_resource[dma]);
 			dma++;
 			break;
 
 		case SMALL_TAG_PORT:
 			if (len != 7)
 				goto len_err;
-			pnpbios_encode_port(p, &res->port_resource[port]);
+			pnpbios_encode_port(dev, p, &res->port_resource[port]);
 			port++;
 			break;
 
@@ -734,7 +764,7 @@
 		case SMALL_TAG_FIXEDPORT:
 			if (len != 3)
 				goto len_err;
-			pnpbios_encode_fixed_port(p, &res->port_resource[port]);
+			pnpbios_encode_fixed_port(dev, p, &res->port_resource[port]);
 			port++;
 			break;
 

-- 

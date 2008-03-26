Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbYCZRPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbYCZRPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761101AbYCZRJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:09:10 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:22050 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760808AbYCZRIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:53 -0400
Message-Id: <20080326171226.738281309@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:15 -0600
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
Subject: [patch 17/37] PNP: remove more pnp_resource_table arguments
Content-Disposition: inline; filename=pnp-remove-more-pnp_resource_table-args
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop passing around struct pnp_resource_table pointers.  In most cases,
the caller doesn't need to know how the resources are stored inside
the struct pnp_dev.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/isapnp/core.c      |    6 ++--
 drivers/pnp/pnpacpi/core.c     |   11 ++-----
 drivers/pnp/pnpacpi/pnpacpi.h  |    6 ++--
 drivers/pnp/pnpacpi/rsparser.c |   55 +++++++++++++++++++++-----------------
 drivers/pnp/pnpbios/core.c     |    4 +-
 drivers/pnp/pnpbios/pnpbios.h  |    4 +-
 drivers/pnp/pnpbios/rsparser.c |   58 ++++++++++++++++++++---------------------
 7 files changed, 73 insertions(+), 71 deletions(-)

Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-25 14:48:39.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-25 14:48:44.000000000 -0600
@@ -934,9 +934,9 @@
 EXPORT_SYMBOL(isapnp_cfg_end);
 EXPORT_SYMBOL(isapnp_write_byte);
 
-static int isapnp_read_resources(struct pnp_dev *dev,
-				 struct pnp_resource_table *res)
+static int isapnp_read_resources(struct pnp_dev *dev)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int tmp, ret;
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
@@ -984,7 +984,7 @@
 
 	pnp_init_resource_table(&dev->res);
 	isapnp_cfg_begin(dev->card->number, dev->number);
-	ret = isapnp_read_resources(dev, &dev->res);
+	ret = isapnp_read_resources(dev);
 	isapnp_cfg_end();
 	return ret;
 }
Index: work7/drivers/pnp/pnpacpi/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/core.c	2008-03-25 14:48:39.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/core.c	2008-03-25 14:48:44.000000000 -0600
@@ -77,8 +77,7 @@
 {
 	acpi_status status;
 
-	status = pnpacpi_parse_allocated_resource((acpi_handle) dev->data,
-						  &dev->res);
+	status = pnpacpi_parse_allocated_resource(dev);
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
 
@@ -92,7 +91,7 @@
 	ret = pnpacpi_build_resource_template(dev, &buffer);
 	if (ret)
 		return ret;
-	ret = pnpacpi_encode_resources(&dev->res, &buffer);
+	ret = pnpacpi_encode_resources(dev, &buffer);
 	if (ret) {
 		kfree(buffer.pointer);
 		return ret;
@@ -183,8 +182,7 @@
 
 	if (dev->active) {
 		/* parse allocated resource */
-		status = pnpacpi_parse_allocated_resource(device->handle,
-							  &dev->res);
+		status = pnpacpi_parse_allocated_resource(dev);
 		if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
 			pnp_err("PnPACPI: METHOD_NAME__CRS failure for %s",
 				acpi_device_hid(device));
@@ -192,8 +190,7 @@
 	}
 
 	if (dev->capabilities & PNP_CONFIGURABLE) {
-		status = pnpacpi_parse_resource_option_data(device->handle,
-							    dev);
+		status = pnpacpi_parse_resource_option_data(dev);
 		if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
 			pnp_err("PnPACPI: METHOD_NAME__PRS failure for %s",
 				acpi_device_hid(device));
Index: work7/drivers/pnp/pnpacpi/pnpacpi.h
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/pnpacpi.h	2008-03-25 14:48:38.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/pnpacpi.h	2008-03-25 14:48:44.000000000 -0600
@@ -5,8 +5,8 @@
 #include <linux/acpi.h>
 #include <linux/pnp.h>
 
-acpi_status pnpacpi_parse_allocated_resource(acpi_handle, struct pnp_resource_table*);
-acpi_status pnpacpi_parse_resource_option_data(acpi_handle, struct pnp_dev*);
-int pnpacpi_encode_resources(struct pnp_resource_table *, struct acpi_buffer *);
+acpi_status pnpacpi_parse_allocated_resource(struct pnp_dev *);
+acpi_status pnpacpi_parse_resource_option_data(struct pnp_dev *);
+int pnpacpi_encode_resources(struct pnp_dev *, struct acpi_buffer *);
 int pnpacpi_build_resource_template(struct pnp_dev *, struct acpi_buffer *);
 #endif
Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-25 14:48:38.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-25 14:48:44.000000000 -0600
@@ -76,10 +76,11 @@
 	}
 }
 
-static void pnpacpi_parse_allocated_irqresource(struct pnp_resource_table *res,
+static void pnpacpi_parse_allocated_irqresource(struct pnp_dev *dev,
 						u32 gsi, int triggering,
 						int polarity, int shareable)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int i = 0;
 	int irq;
 	int p, t;
@@ -170,9 +171,10 @@
 	return flags;
 }
 
-static void pnpacpi_parse_allocated_dmaresource(struct pnp_resource_table *res,
+static void pnpacpi_parse_allocated_dmaresource(struct pnp_dev *dev,
 						u32 dma, int flags)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int i = 0;
 	static unsigned char warned;
 
@@ -195,9 +197,10 @@
 	}
 }
 
-static void pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
+static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev,
 					       u64 io, u64 len, int io_decode)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int i = 0;
 	static unsigned char warned;
 
@@ -221,10 +224,11 @@
 	}
 }
 
-static void pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
+static void pnpacpi_parse_allocated_memresource(struct pnp_dev *dev,
 						u64 mem, u64 len,
 						int write_protect)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int i = 0;
 	static unsigned char warned;
 
@@ -249,7 +253,7 @@
 	}
 }
 
-static void pnpacpi_parse_allocated_address_space(struct pnp_resource_table *res_table,
+static void pnpacpi_parse_allocated_address_space(struct pnp_dev *dev,
 						  struct acpi_resource *res)
 {
 	struct acpi_resource_address64 addr, *p = &addr;
@@ -266,11 +270,11 @@
 		return;
 
 	if (p->resource_type == ACPI_MEMORY_RANGE)
-		pnpacpi_parse_allocated_memresource(res_table,
+		pnpacpi_parse_allocated_memresource(dev,
 			p->minimum, p->address_length,
 			p->info.mem.write_protect);
 	else if (p->resource_type == ACPI_IO_RANGE)
-		pnpacpi_parse_allocated_ioresource(res_table,
+		pnpacpi_parse_allocated_ioresource(dev,
 			p->minimum, p->address_length,
 			p->granularity == 0xfff ? ACPI_DECODE_10 :
 				ACPI_DECODE_16);
@@ -279,7 +283,7 @@
 static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 					      void *data)
 {
-	struct pnp_resource_table *res_table = data;
+	struct pnp_dev *dev = data;
 	struct acpi_resource_irq *irq;
 	struct acpi_resource_dma *dma;
 	struct acpi_resource_io *io;
@@ -298,7 +302,7 @@
 		 */
 		irq = &res->data.irq;
 		for (i = 0; i < irq->interrupt_count; i++) {
-			pnpacpi_parse_allocated_irqresource(res_table,
+			pnpacpi_parse_allocated_irqresource(dev,
 				irq->interrupts[i],
 				irq->triggering,
 				irq->polarity,
@@ -309,7 +313,7 @@
 	case ACPI_RESOURCE_TYPE_DMA:
 		dma = &res->data.dma;
 		if (dma->channel_count > 0)
-			pnpacpi_parse_allocated_dmaresource(res_table,
+			pnpacpi_parse_allocated_dmaresource(dev,
 				dma->channels[0],
 				dma_flags(dma->type, dma->bus_master,
 					  dma->transfer));
@@ -317,7 +321,7 @@
 
 	case ACPI_RESOURCE_TYPE_IO:
 		io = &res->data.io;
-		pnpacpi_parse_allocated_ioresource(res_table,
+		pnpacpi_parse_allocated_ioresource(dev,
 			io->minimum,
 			io->address_length,
 			io->io_decode);
@@ -329,7 +333,7 @@
 
 	case ACPI_RESOURCE_TYPE_FIXED_IO:
 		fixed_io = &res->data.fixed_io;
-		pnpacpi_parse_allocated_ioresource(res_table,
+		pnpacpi_parse_allocated_ioresource(dev,
 			fixed_io->address,
 			fixed_io->address_length,
 			ACPI_DECODE_10);
@@ -343,21 +347,21 @@
 
 	case ACPI_RESOURCE_TYPE_MEMORY24:
 		memory24 = &res->data.memory24;
-		pnpacpi_parse_allocated_memresource(res_table,
+		pnpacpi_parse_allocated_memresource(dev,
 			memory24->minimum,
 			memory24->address_length,
 			memory24->write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_MEMORY32:
 		memory32 = &res->data.memory32;
-		pnpacpi_parse_allocated_memresource(res_table,
+		pnpacpi_parse_allocated_memresource(dev,
 			memory32->minimum,
 			memory32->address_length,
 			memory32->write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 		fixed_memory32 = &res->data.fixed_memory32;
-		pnpacpi_parse_allocated_memresource(res_table,
+		pnpacpi_parse_allocated_memresource(dev,
 			fixed_memory32->address,
 			fixed_memory32->address_length,
 			fixed_memory32->write_protect);
@@ -365,7 +369,7 @@
 	case ACPI_RESOURCE_TYPE_ADDRESS16:
 	case ACPI_RESOURCE_TYPE_ADDRESS32:
 	case ACPI_RESOURCE_TYPE_ADDRESS64:
-		pnpacpi_parse_allocated_address_space(res_table, res);
+		pnpacpi_parse_allocated_address_space(dev, res);
 		break;
 
 	case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
@@ -379,7 +383,7 @@
 			return AE_OK;
 
 		for (i = 0; i < extended_irq->interrupt_count; i++) {
-			pnpacpi_parse_allocated_irqresource(res_table,
+			pnpacpi_parse_allocated_irqresource(dev,
 				extended_irq->interrupts[i],
 				extended_irq->triggering,
 				extended_irq->polarity,
@@ -398,14 +402,15 @@
 	return AE_OK;
 }
 
-acpi_status pnpacpi_parse_allocated_resource(acpi_handle handle,
-					     struct pnp_resource_table * res)
+acpi_status pnpacpi_parse_allocated_resource(struct pnp_dev *dev)
 {
+	acpi_handle handle = dev->data;
+
 	/* Blank the resource table values */
-	pnp_init_resource_table(res);
+	pnp_init_resource_table(&dev->res);
 
 	return acpi_walk_resources(handle, METHOD_NAME__CRS,
-				   pnpacpi_allocated_resource, res);
+				   pnpacpi_allocated_resource, dev);
 }
 
 static __init void pnpacpi_parse_dma_option(struct pnp_option *option,
@@ -713,9 +718,9 @@
 	return AE_OK;
 }
 
-acpi_status __init pnpacpi_parse_resource_option_data(acpi_handle handle,
-						      struct pnp_dev *dev)
+acpi_status __init pnpacpi_parse_resource_option_data(struct pnp_dev *dev)
 {
+	acpi_handle handle = dev->data;
 	acpi_status status;
 	struct acpipnp_parse_option_s parse_data;
 
@@ -945,9 +950,9 @@
 	fixed_memory32->address_length = p->end - p->start + 1;
 }
 
-int pnpacpi_encode_resources(struct pnp_resource_table *res_table,
-			     struct acpi_buffer *buffer)
+int pnpacpi_encode_resources(struct pnp_dev *dev, struct acpi_buffer *buffer)
 {
+	struct pnp_resource_table *res_table = &dev->res;
 	int i = 0;
 	/* pnpacpi_build_resource_template allocates extra mem */
 	int res_cnt = (buffer->length - 1) / sizeof(struct acpi_resource) - 1;
Index: work7/drivers/pnp/pnpbios/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/core.c	2008-03-25 14:48:39.000000000 -0600
+++ work7/drivers/pnp/pnpbios/core.c	2008-03-25 14:48:44.000000000 -0600
@@ -219,7 +219,7 @@
 		kfree(node);
 		return -ENODEV;
 	}
-	pnpbios_read_resources_from_node(&dev->res, node);
+	pnpbios_read_resources_from_node(dev, node);
 	dev->active = pnp_is_active(dev);
 	kfree(node);
 	return 0;
@@ -241,7 +241,7 @@
 		kfree(node);
 		return -ENODEV;
 	}
-	if (pnpbios_write_resources_to_node(&dev->res, node) < 0) {
+	if (pnpbios_write_resources_to_node(dev, node) < 0) {
 		kfree(node);
 		return -1;
 	}
Index: work7/drivers/pnp/pnpbios/pnpbios.h
===================================================================
--- work7.orig/drivers/pnp/pnpbios/pnpbios.h	2008-03-25 14:48:21.000000000 -0600
+++ work7/drivers/pnp/pnpbios/pnpbios.h	2008-03-25 14:48:44.000000000 -0600
@@ -28,8 +28,8 @@
 extern int  pnpbios_dont_use_current_config;
 
 extern int pnpbios_parse_data_stream(struct pnp_dev *dev, struct pnp_bios_node * node);
-extern int pnpbios_read_resources_from_node(struct pnp_resource_table *res, struct pnp_bios_node * node);
-extern int pnpbios_write_resources_to_node(struct pnp_resource_table *res, struct pnp_bios_node * node);
+extern int pnpbios_read_resources_from_node(struct pnp_dev *dev, struct pnp_bios_node *node);
+extern int pnpbios_write_resources_to_node(struct pnp_dev *dev, struct pnp_bios_node *node);
 extern void pnpid32_to_pnpid(u32 id, char *str);
 
 extern void pnpbios_print_status(const char * module, u16 status);
Index: work7/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/rsparser.c	2008-03-25 14:48:29.000000000 -0600
+++ work7/drivers/pnp/pnpbios/rsparser.c	2008-03-25 14:48:44.000000000 -0600
@@ -54,9 +54,9 @@
  * Allocated Resources
  */
 
-static void pnpbios_parse_allocated_irqresource(struct pnp_resource_table *res,
-						int irq)
+static void pnpbios_parse_allocated_irqresource(struct pnp_dev *dev, int irq)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int i = 0;
 
 	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET)
@@ -74,9 +74,9 @@
 	}
 }
 
-static void pnpbios_parse_allocated_dmaresource(struct pnp_resource_table *res,
-						int dma)
+static void pnpbios_parse_allocated_dmaresource(struct pnp_dev *dev, int dma)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int i = 0;
 
 	while (i < PNP_MAX_DMA &&
@@ -93,9 +93,10 @@
 	}
 }
 
-static void pnpbios_parse_allocated_ioresource(struct pnp_resource_table *res,
+static void pnpbios_parse_allocated_ioresource(struct pnp_dev *dev,
 					       int io, int len)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int i = 0;
 
 	while (!(res->port_resource[i].flags & IORESOURCE_UNSET)
@@ -112,9 +113,10 @@
 	}
 }
 
-static void pnpbios_parse_allocated_memresource(struct pnp_resource_table *res,
+static void pnpbios_parse_allocated_memresource(struct pnp_dev *dev,
 						int mem, int len)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int i = 0;
 
 	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET)
@@ -131,11 +133,9 @@
 	}
 }
 
-static unsigned char *pnpbios_parse_allocated_resource_data(unsigned char *p,
-							    unsigned char *end,
-							    struct
-							    pnp_resource_table
-							    *res)
+static unsigned char *pnpbios_parse_allocated_resource_data(struct pnp_dev *dev,
+							    unsigned char *p,
+							    unsigned char *end)
 {
 	unsigned int len, tag;
 	int io, size, mask, i;
@@ -144,7 +144,7 @@
 		return NULL;
 
 	/* Blank the resource table values */
-	pnp_init_resource_table(res);
+	pnp_init_resource_table(&dev->res);
 
 	while ((char *)p < (char *)end) {
 
@@ -164,7 +164,7 @@
 				goto len_err;
 			io = *(short *)&p[4];
 			size = *(short *)&p[10];
-			pnpbios_parse_allocated_memresource(res, io, size);
+			pnpbios_parse_allocated_memresource(dev, io, size);
 			break;
 
 		case LARGE_TAG_ANSISTR:
@@ -180,7 +180,7 @@
 				goto len_err;
 			io = *(int *)&p[4];
 			size = *(int *)&p[16];
-			pnpbios_parse_allocated_memresource(res, io, size);
+			pnpbios_parse_allocated_memresource(dev, io, size);
 			break;
 
 		case LARGE_TAG_FIXEDMEM32:
@@ -188,7 +188,7 @@
 				goto len_err;
 			io = *(int *)&p[4];
 			size = *(int *)&p[8];
-			pnpbios_parse_allocated_memresource(res, io, size);
+			pnpbios_parse_allocated_memresource(dev, io, size);
 			break;
 
 		case SMALL_TAG_IRQ:
@@ -199,7 +199,7 @@
 			for (i = 0; i < 16; i++, mask = mask >> 1)
 				if (mask & 0x01)
 					io = i;
-			pnpbios_parse_allocated_irqresource(res, io);
+			pnpbios_parse_allocated_irqresource(dev, io);
 			break;
 
 		case SMALL_TAG_DMA:
@@ -210,7 +210,7 @@
 			for (i = 0; i < 8; i++, mask = mask >> 1)
 				if (mask & 0x01)
 					io = i;
-			pnpbios_parse_allocated_dmaresource(res, io);
+			pnpbios_parse_allocated_dmaresource(dev, io);
 			break;
 
 		case SMALL_TAG_PORT:
@@ -218,7 +218,7 @@
 				goto len_err;
 			io = p[2] + p[3] * 256;
 			size = p[7];
-			pnpbios_parse_allocated_ioresource(res, io, size);
+			pnpbios_parse_allocated_ioresource(dev, io, size);
 			break;
 
 		case SMALL_TAG_VENDOR:
@@ -230,7 +230,7 @@
 				goto len_err;
 			io = p[1] + p[2] * 256;
 			size = p[3];
-			pnpbios_parse_allocated_ioresource(res, io, size);
+			pnpbios_parse_allocated_ioresource(dev, io, size);
 			break;
 
 		case SMALL_TAG_END:
@@ -672,12 +672,12 @@
 	p[3] = len & 0xff;
 }
 
-static unsigned char *pnpbios_encode_allocated_resource_data(unsigned char *p,
-							     unsigned char *end,
-							     struct
-							     pnp_resource_table
-							     *res)
+static unsigned char *pnpbios_encode_allocated_resource_data(struct pnp_dev
+								*dev,
+							     unsigned char *p,
+							     unsigned char *end)
 {
+	struct pnp_resource_table *res = &dev->res;
 	unsigned int len, tag;
 	int port = 0, irq = 0, dma = 0, mem = 0;
 
@@ -786,7 +786,7 @@
 	unsigned char *p = (char *)node->data;
 	unsigned char *end = (char *)(node->data + node->size);
 
-	p = pnpbios_parse_allocated_resource_data(p, end, &dev->res);
+	p = pnpbios_parse_allocated_resource_data(dev, p, end);
 	if (!p)
 		return -EIO;
 	p = pnpbios_parse_resource_option_data(p, end, dev);
@@ -798,25 +798,25 @@
 	return 0;
 }
 
-int pnpbios_read_resources_from_node(struct pnp_resource_table *res,
+int pnpbios_read_resources_from_node(struct pnp_dev *dev,
 				     struct pnp_bios_node *node)
 {
 	unsigned char *p = (char *)node->data;
 	unsigned char *end = (char *)(node->data + node->size);
 
-	p = pnpbios_parse_allocated_resource_data(p, end, res);
+	p = pnpbios_parse_allocated_resource_data(dev, p, end);
 	if (!p)
 		return -EIO;
 	return 0;
 }
 
-int pnpbios_write_resources_to_node(struct pnp_resource_table *res,
+int pnpbios_write_resources_to_node(struct pnp_dev *dev,
 				    struct pnp_bios_node *node)
 {
 	unsigned char *p = (char *)node->data;
 	unsigned char *end = (char *)(node->data + node->size);
 
-	p = pnpbios_encode_allocated_resource_data(p, end, res);
+	p = pnpbios_encode_allocated_resource_data(dev, p, end);
 	if (!p)
 		return -EIO;
 	return 0;

-- 

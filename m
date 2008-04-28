Return-Path: <linux-kernel-owner+w=401wt.eu-S937280AbYD1W6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937280AbYD1W6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966641AbYD1Wgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:36:51 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:3001 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966446AbYD1Wgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:43 -0400
Message-Id: <20080428223619.915929525@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:04 -0600
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
Subject: [patch 17/55] PNP: add debug output to option registration
Content-Disposition: inline; filename=pnp-add-option-registration-debug-output
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debug output to resource option registration functions (enabled
by CONFIG_PNP_DEBUG).  This uses dev_printk, so I had to add pnp_dev
arguments at the same time.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/isapnp/core.c      |   49 +++++++++++++++++------------
 drivers/pnp/pnpacpi/rsparser.c |   67 +++++++++++++++++++++++------------------
 drivers/pnp/pnpbios/rsparser.c |   53 ++++++++++++++++++--------------
 drivers/pnp/resource.c         |   34 ++++++++++++++++++--
 include/linux/pnp.h            |   11 ++++--
 5 files changed, 134 insertions(+), 80 deletions(-)

Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-28 15:57:04.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:19.000000000 -0600
@@ -53,6 +53,8 @@
 	if (dev->independent)
 		dev_err(&dev->dev, "independent resource already registered\n");
 	dev->independent = option;
+
+	dev_dbg(&dev->dev, "new independent option\n");
 	return option;
 }
 
@@ -70,12 +72,18 @@
 		parent->next = option;
 	} else
 		dev->dependent = option;
+
+	dev_dbg(&dev->dev, "new dependent option (priority %#x)\n", priority);
 	return option;
 }
 
-int pnp_register_irq_resource(struct pnp_option *option, struct pnp_irq *data)
+int pnp_register_irq_resource(struct pnp_dev *dev, struct pnp_option *option,
+			      struct pnp_irq *data)
 {
 	struct pnp_irq *ptr;
+#ifdef DEBUG
+	char buf[PNP_IRQ_NR];   /* hex-encoded, so this is overkill but safe */
+#endif
 
 	ptr = option->irq;
 	while (ptr && ptr->next)
@@ -94,10 +102,17 @@
 				pcibios_penalize_isa_irq(i, 0);
 	}
 #endif
+
+#ifdef DEBUG
+	bitmap_scnprintf(buf, sizeof(buf), data->map, PNP_IRQ_NR);
+	dev_dbg(&dev->dev, "  irq bitmask %s flags %#x\n", buf,
+		data->flags);
+#endif
 	return 0;
 }
 
-int pnp_register_dma_resource(struct pnp_option *option, struct pnp_dma *data)
+int pnp_register_dma_resource(struct pnp_dev *dev, struct pnp_option *option,
+			      struct pnp_dma *data)
 {
 	struct pnp_dma *ptr;
 
@@ -109,10 +124,13 @@
 	else
 		option->dma = data;
 
+	dev_dbg(&dev->dev, "  dma bitmask %#x flags %#x\n", data->map,
+		data->flags);
 	return 0;
 }
 
-int pnp_register_port_resource(struct pnp_option *option, struct pnp_port *data)
+int pnp_register_port_resource(struct pnp_dev *dev, struct pnp_option *option,
+			       struct pnp_port *data)
 {
 	struct pnp_port *ptr;
 
@@ -124,10 +142,14 @@
 	else
 		option->port = data;
 
+	dev_dbg(&dev->dev, "  io  "
+		"min %#x max %#x align %d size %d flags %#x\n",
+		data->min, data->max, data->align, data->size, data->flags);
 	return 0;
 }
 
-int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data)
+int pnp_register_mem_resource(struct pnp_dev *dev, struct pnp_option *option,
+			      struct pnp_mem *data)
 {
 	struct pnp_mem *ptr;
 
@@ -138,6 +160,10 @@
 		ptr->next = data;
 	else
 		option->mem = data;
+
+	dev_dbg(&dev->dev, "  mem "
+		"min %#x max %#x align %d size %d flags %#x\n",
+		data->min, data->max, data->align, data->size, data->flags);
 	return 0;
 }
 
Index: work10/include/linux/pnp.h
===================================================================
--- work10.orig/include/linux/pnp.h	2008-04-28 16:09:12.000000000 -0600
+++ work10/include/linux/pnp.h	2008-04-28 16:09:19.000000000 -0600
@@ -382,11 +382,14 @@
 struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev);
 struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev,
 						 int priority);
-int pnp_register_irq_resource(struct pnp_option *option, struct pnp_irq *data);
-int pnp_register_dma_resource(struct pnp_option *option, struct pnp_dma *data);
-int pnp_register_port_resource(struct pnp_option *option,
+int pnp_register_irq_resource(struct pnp_dev *dev, struct pnp_option *option,
+			      struct pnp_irq *data);
+int pnp_register_dma_resource(struct pnp_dev *dev, struct pnp_option *option,
+			      struct pnp_dma *data);
+int pnp_register_port_resource(struct pnp_dev *dev, struct pnp_option *option,
 			       struct pnp_port *data);
-int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data);
+int pnp_register_mem_resource(struct pnp_dev *dev, struct pnp_option *option,
+			      struct pnp_mem *data);
 void pnp_init_resource_table(struct pnp_resource_table *table);
 int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
 			  int mode);
@@ -430,10 +433,10 @@
 /* resource management */
 static inline struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev) { return NULL; }
 static inline struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev, int priority) { return NULL; }
-static inline int pnp_register_irq_resource(struct pnp_option *option, struct pnp_irq *data) { return -ENODEV; }
-static inline int pnp_register_dma_resource(struct pnp_option *option, struct pnp_dma *data) { return -ENODEV; }
-static inline int pnp_register_port_resource(struct pnp_option *option, struct pnp_port *data) { return -ENODEV; }
-static inline int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data) { return -ENODEV; }
+static inline int pnp_register_irq_resource(struct pnp_dev *dev, struct pnp_option *option, struct pnp_irq *data) { return -ENODEV; }
+static inline int pnp_register_dma_resource(struct pnp_dev *dev, struct pnp_option *option, struct pnp_dma *data) { return -ENODEV; }
+static inline int pnp_register_port_resource(struct pnp_dev *dev, struct pnp_option *option, struct pnp_port *data) { return -ENODEV; }
+static inline int pnp_register_mem_resource(struct pnp_dev *dev, struct pnp_option *option, struct pnp_mem *data) { return -ENODEV; }
 static inline void pnp_init_resource_table(struct pnp_resource_table *table) { }
 static inline int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res, int mode) { return -ENODEV; }
 static inline int pnp_auto_config_dev(struct pnp_dev *dev) { return -ENODEV; }
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-28 16:09:14.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-28 16:09:19.000000000 -0600
@@ -431,7 +431,8 @@
 /*
  *  Add IRQ resource to resources list.
  */
-static void __init isapnp_parse_irq_resource(struct pnp_option *option,
+static void __init isapnp_parse_irq_resource(struct pnp_dev *dev,
+					     struct pnp_option *option,
 					     int size)
 {
 	unsigned char tmp[3];
@@ -448,13 +449,14 @@
 		irq->flags = tmp[2];
 	else
 		irq->flags = IORESOURCE_IRQ_HIGHEDGE;
-	pnp_register_irq_resource(option, irq);
+	pnp_register_irq_resource(dev, option, irq);
 }
 
 /*
  *  Add DMA resource to resources list.
  */
-static void __init isapnp_parse_dma_resource(struct pnp_option *option,
+static void __init isapnp_parse_dma_resource(struct pnp_dev *dev,
+					     struct pnp_option *option,
 					     int size)
 {
 	unsigned char tmp[2];
@@ -466,13 +468,14 @@
 		return;
 	dma->map = tmp[0];
 	dma->flags = tmp[1];
-	pnp_register_dma_resource(option, dma);
+	pnp_register_dma_resource(dev, option, dma);
 }
 
 /*
  *  Add port resource to resources list.
  */
-static void __init isapnp_parse_port_resource(struct pnp_option *option,
+static void __init isapnp_parse_port_resource(struct pnp_dev *dev,
+					      struct pnp_option *option,
 					      int size)
 {
 	unsigned char tmp[7];
@@ -487,13 +490,14 @@
 	port->align = tmp[5];
 	port->size = tmp[6];
 	port->flags = tmp[0] ? PNP_PORT_FLAG_16BITADDR : 0;
-	pnp_register_port_resource(option, port);
+	pnp_register_port_resource(dev, option, port);
 }
 
 /*
  *  Add fixed port resource to resources list.
  */
-static void __init isapnp_parse_fixed_port_resource(struct pnp_option *option,
+static void __init isapnp_parse_fixed_port_resource(struct pnp_dev *dev,
+						    struct pnp_option *option,
 						    int size)
 {
 	unsigned char tmp[3];
@@ -507,13 +511,14 @@
 	port->size = tmp[2];
 	port->align = 0;
 	port->flags = PNP_PORT_FLAG_FIXED;
-	pnp_register_port_resource(option, port);
+	pnp_register_port_resource(dev, option, port);
 }
 
 /*
  *  Add memory resource to resources list.
  */
-static void __init isapnp_parse_mem_resource(struct pnp_option *option,
+static void __init isapnp_parse_mem_resource(struct pnp_dev *dev,
+					     struct pnp_option *option,
 					     int size)
 {
 	unsigned char tmp[9];
@@ -528,13 +533,14 @@
 	mem->align = (tmp[6] << 8) | tmp[5];
 	mem->size = ((tmp[8] << 8) | tmp[7]) << 8;
 	mem->flags = tmp[0];
-	pnp_register_mem_resource(option, mem);
+	pnp_register_mem_resource(dev, option, mem);
 }
 
 /*
  *  Add 32-bit memory resource to resources list.
  */
-static void __init isapnp_parse_mem32_resource(struct pnp_option *option,
+static void __init isapnp_parse_mem32_resource(struct pnp_dev *dev,
+					       struct pnp_option *option,
 					       int size)
 {
 	unsigned char tmp[17];
@@ -551,13 +557,14 @@
 	mem->size =
 	    (tmp[16] << 24) | (tmp[15] << 16) | (tmp[14] << 8) | tmp[13];
 	mem->flags = tmp[0];
-	pnp_register_mem_resource(option, mem);
+	pnp_register_mem_resource(dev, option, mem);
 }
 
 /*
  *  Add 32-bit fixed memory resource to resources list.
  */
-static void __init isapnp_parse_fixed_mem32_resource(struct pnp_option *option,
+static void __init isapnp_parse_fixed_mem32_resource(struct pnp_dev *dev,
+						     struct pnp_option *option,
 						     int size)
 {
 	unsigned char tmp[9];
@@ -572,7 +579,7 @@
 	mem->size = (tmp[8] << 24) | (tmp[7] << 16) | (tmp[6] << 8) | tmp[5];
 	mem->align = 0;
 	mem->flags = tmp[0];
-	pnp_register_mem_resource(option, mem);
+	pnp_register_mem_resource(dev, option, mem);
 }
 
 /*
@@ -656,13 +663,13 @@
 		case _STAG_IRQ:
 			if (size < 2 || size > 3)
 				goto __skip;
-			isapnp_parse_irq_resource(option, size);
+			isapnp_parse_irq_resource(dev, option, size);
 			size = 0;
 			break;
 		case _STAG_DMA:
 			if (size != 2)
 				goto __skip;
-			isapnp_parse_dma_resource(option, size);
+			isapnp_parse_dma_resource(dev, option, size);
 			size = 0;
 			break;
 		case _STAG_STARTDEP:
@@ -682,17 +689,18 @@
 			if (size != 0)
 				goto __skip;
 			priority = 0;
+			dev_dbg(&dev->dev, "end dependent options\n");
 			break;
 		case _STAG_IOPORT:
 			if (size != 7)
 				goto __skip;
-			isapnp_parse_port_resource(option, size);
+			isapnp_parse_port_resource(dev, option, size);
 			size = 0;
 			break;
 		case _STAG_FIXEDIO:
 			if (size != 3)
 				goto __skip;
-			isapnp_parse_fixed_port_resource(option, size);
+			isapnp_parse_fixed_port_resource(dev, option, size);
 			size = 0;
 			break;
 		case _STAG_VENDOR:
@@ -700,7 +708,7 @@
 		case _LTAG_MEMRANGE:
 			if (size != 9)
 				goto __skip;
-			isapnp_parse_mem_resource(option, size);
+			isapnp_parse_mem_resource(dev, option, size);
 			size = 0;
 			break;
 		case _LTAG_ANSISTR:
@@ -715,13 +723,13 @@
 		case _LTAG_MEM32RANGE:
 			if (size != 17)
 				goto __skip;
-			isapnp_parse_mem32_resource(option, size);
+			isapnp_parse_mem32_resource(dev, option, size);
 			size = 0;
 			break;
 		case _LTAG_FIXEDMEM32RANGE:
 			if (size != 9)
 				goto __skip;
-			isapnp_parse_fixed_mem32_resource(option, size);
+			isapnp_parse_fixed_mem32_resource(dev, option, size);
 			size = 0;
 			break;
 		case _STAG_END:
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:11.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:19.000000000 -0600
@@ -263,7 +263,8 @@
  * Resource Configuration Options
  */
 
-static __init void pnpbios_parse_mem_option(unsigned char *p, int size,
+static __init void pnpbios_parse_mem_option(struct pnp_dev *dev,
+					    unsigned char *p, int size,
 					    struct pnp_option *option)
 {
 	struct pnp_mem *mem;
@@ -276,10 +277,11 @@
 	mem->align = (p[9] << 8) | p[8];
 	mem->size = ((p[11] << 8) | p[10]) << 8;
 	mem->flags = p[3];
-	pnp_register_mem_resource(option, mem);
+	pnp_register_mem_resource(dev, option, mem);
 }
 
-static __init void pnpbios_parse_mem32_option(unsigned char *p, int size,
+static __init void pnpbios_parse_mem32_option(struct pnp_dev *dev,
+					      unsigned char *p, int size,
 					      struct pnp_option *option)
 {
 	struct pnp_mem *mem;
@@ -292,10 +294,11 @@
 	mem->align = (p[15] << 24) | (p[14] << 16) | (p[13] << 8) | p[12];
 	mem->size = (p[19] << 24) | (p[18] << 16) | (p[17] << 8) | p[16];
 	mem->flags = p[3];
-	pnp_register_mem_resource(option, mem);
+	pnp_register_mem_resource(dev, option, mem);
 }
 
-static __init void pnpbios_parse_fixed_mem32_option(unsigned char *p, int size,
+static __init void pnpbios_parse_fixed_mem32_option(struct pnp_dev *dev,
+						    unsigned char *p, int size,
 						    struct pnp_option *option)
 {
 	struct pnp_mem *mem;
@@ -307,11 +310,12 @@
 	mem->size = (p[11] << 24) | (p[10] << 16) | (p[9] << 8) | p[8];
 	mem->align = 0;
 	mem->flags = p[3];
-	pnp_register_mem_resource(option, mem);
+	pnp_register_mem_resource(dev, option, mem);
 }
 
-static __init void pnpbios_parse_irq_option(unsigned char *p, int size,
-				     struct pnp_option *option)
+static __init void pnpbios_parse_irq_option(struct pnp_dev *dev,
+					    unsigned char *p, int size,
+					    struct pnp_option *option)
 {
 	struct pnp_irq *irq;
 	unsigned long bits;
@@ -325,11 +329,12 @@
 		irq->flags = p[3];
 	else
 		irq->flags = IORESOURCE_IRQ_HIGHEDGE;
-	pnp_register_irq_resource(option, irq);
+	pnp_register_irq_resource(dev, option, irq);
 }
 
-static __init void pnpbios_parse_dma_option(unsigned char *p, int size,
-				     struct pnp_option *option)
+static __init void pnpbios_parse_dma_option(struct pnp_dev *dev,
+					    unsigned char *p, int size,
+					    struct pnp_option *option)
 {
 	struct pnp_dma *dma;
 
@@ -338,10 +343,11 @@
 		return;
 	dma->map = p[1];
 	dma->flags = p[2];
-	pnp_register_dma_resource(option, dma);
+	pnp_register_dma_resource(dev, option, dma);
 }
 
-static __init void pnpbios_parse_port_option(unsigned char *p, int size,
+static __init void pnpbios_parse_port_option(struct pnp_dev *dev,
+					     unsigned char *p, int size,
 					     struct pnp_option *option)
 {
 	struct pnp_port *port;
@@ -354,10 +360,11 @@
 	port->align = p[6];
 	port->size = p[7];
 	port->flags = p[1] ? PNP_PORT_FLAG_16BITADDR : 0;
-	pnp_register_port_resource(option, port);
+	pnp_register_port_resource(dev, option, port);
 }
 
-static __init void pnpbios_parse_fixed_port_option(unsigned char *p, int size,
+static __init void pnpbios_parse_fixed_port_option(struct pnp_dev *dev,
+						   unsigned char *p, int size,
 						   struct pnp_option *option)
 {
 	struct pnp_port *port;
@@ -369,7 +376,7 @@
 	port->size = p[3];
 	port->align = 0;
 	port->flags = PNP_PORT_FLAG_FIXED;
-	pnp_register_port_resource(option, port);
+	pnp_register_port_resource(dev, option, port);
 }
 
 static __init unsigned char *
@@ -403,37 +410,37 @@
 		case LARGE_TAG_MEM:
 			if (len != 9)
 				goto len_err;
-			pnpbios_parse_mem_option(p, len, option);
+			pnpbios_parse_mem_option(dev, p, len, option);
 			break;
 
 		case LARGE_TAG_MEM32:
 			if (len != 17)
 				goto len_err;
-			pnpbios_parse_mem32_option(p, len, option);
+			pnpbios_parse_mem32_option(dev, p, len, option);
 			break;
 
 		case LARGE_TAG_FIXEDMEM32:
 			if (len != 9)
 				goto len_err;
-			pnpbios_parse_fixed_mem32_option(p, len, option);
+			pnpbios_parse_fixed_mem32_option(dev, p, len, option);
 			break;
 
 		case SMALL_TAG_IRQ:
 			if (len < 2 || len > 3)
 				goto len_err;
-			pnpbios_parse_irq_option(p, len, option);
+			pnpbios_parse_irq_option(dev, p, len, option);
 			break;
 
 		case SMALL_TAG_DMA:
 			if (len != 2)
 				goto len_err;
-			pnpbios_parse_dma_option(p, len, option);
+			pnpbios_parse_dma_option(dev, p, len, option);
 			break;
 
 		case SMALL_TAG_PORT:
 			if (len != 7)
 				goto len_err;
-			pnpbios_parse_port_option(p, len, option);
+			pnpbios_parse_port_option(dev, p, len, option);
 			break;
 
 		case SMALL_TAG_VENDOR:
@@ -443,7 +450,7 @@
 		case SMALL_TAG_FIXEDPORT:
 			if (len != 3)
 				goto len_err;
-			pnpbios_parse_fixed_port_option(p, len, option);
+			pnpbios_parse_fixed_port_option(dev, p, len, option);
 			break;
 
 		case SMALL_TAG_STARTDEP:
@@ -464,6 +471,7 @@
 				printk(KERN_WARNING
 				       "PnPBIOS: Missing SMALL_TAG_STARTDEP tag\n");
 			option = option_independent;
+			dev_dbg(&dev->dev, "end dependent options\n");
 			break;
 
 		case SMALL_TAG_END:
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:18.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:19.000000000 -0600
@@ -410,7 +410,8 @@
 				   pnpacpi_allocated_resource, res);
 }
 
-static __init void pnpacpi_parse_dma_option(struct pnp_option *option,
+static __init void pnpacpi_parse_dma_option(struct pnp_dev *dev,
+					    struct pnp_option *option,
 					    struct acpi_resource_dma *p)
 {
 	int i;
@@ -427,10 +428,11 @@
 
 	dma->flags = dma_flags(p->type, p->bus_master, p->transfer);
 
-	pnp_register_dma_resource(option, dma);
+	pnp_register_dma_resource(dev, option, dma);
 }
 
-static __init void pnpacpi_parse_irq_option(struct pnp_option *option,
+static __init void pnpacpi_parse_irq_option(struct pnp_dev *dev,
+					    struct pnp_option *option,
 					    struct acpi_resource_irq *p)
 {
 	int i;
@@ -447,10 +449,11 @@
 			__set_bit(p->interrupts[i], irq->map);
 	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
 
-	pnp_register_irq_resource(option, irq);
+	pnp_register_irq_resource(dev, option, irq);
 }
 
-static __init void pnpacpi_parse_ext_irq_option(struct pnp_option *option,
+static __init void pnpacpi_parse_ext_irq_option(struct pnp_dev *dev,
+						struct pnp_option *option,
 					struct acpi_resource_extended_irq *p)
 {
 	int i;
@@ -467,10 +470,11 @@
 			__set_bit(p->interrupts[i], irq->map);
 	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
 
-	pnp_register_irq_resource(option, irq);
+	pnp_register_irq_resource(dev, option, irq);
 }
 
-static __init void pnpacpi_parse_port_option(struct pnp_option *option,
+static __init void pnpacpi_parse_port_option(struct pnp_dev *dev,
+					     struct pnp_option *option,
 					     struct acpi_resource_io *io)
 {
 	struct pnp_port *port;
@@ -486,10 +490,11 @@
 	port->size = io->address_length;
 	port->flags = ACPI_DECODE_16 == io->io_decode ?
 	    PNP_PORT_FLAG_16BITADDR : 0;
-	pnp_register_port_resource(option, port);
+	pnp_register_port_resource(dev, option, port);
 }
 
-static __init void pnpacpi_parse_fixed_port_option(struct pnp_option *option,
+static __init void pnpacpi_parse_fixed_port_option(struct pnp_dev *dev,
+						   struct pnp_option *option,
 					struct acpi_resource_fixed_io *io)
 {
 	struct pnp_port *port;
@@ -503,10 +508,11 @@
 	port->size = io->address_length;
 	port->align = 0;
 	port->flags = PNP_PORT_FLAG_FIXED;
-	pnp_register_port_resource(option, port);
+	pnp_register_port_resource(dev, option, port);
 }
 
-static __init void pnpacpi_parse_mem24_option(struct pnp_option *option,
+static __init void pnpacpi_parse_mem24_option(struct pnp_dev *dev,
+					      struct pnp_option *option,
 					      struct acpi_resource_memory24 *p)
 {
 	struct pnp_mem *mem;
@@ -524,10 +530,11 @@
 	mem->flags = (ACPI_READ_WRITE_MEMORY == p->write_protect) ?
 	    IORESOURCE_MEM_WRITEABLE : 0;
 
-	pnp_register_mem_resource(option, mem);
+	pnp_register_mem_resource(dev, option, mem);
 }
 
-static __init void pnpacpi_parse_mem32_option(struct pnp_option *option,
+static __init void pnpacpi_parse_mem32_option(struct pnp_dev *dev,
+					      struct pnp_option *option,
 					      struct acpi_resource_memory32 *p)
 {
 	struct pnp_mem *mem;
@@ -545,10 +552,11 @@
 	mem->flags = (ACPI_READ_WRITE_MEMORY == p->write_protect) ?
 	    IORESOURCE_MEM_WRITEABLE : 0;
 
-	pnp_register_mem_resource(option, mem);
+	pnp_register_mem_resource(dev, option, mem);
 }
 
-static __init void pnpacpi_parse_fixed_mem32_option(struct pnp_option *option,
+static __init void pnpacpi_parse_fixed_mem32_option(struct pnp_dev *dev,
+						    struct pnp_option *option,
 					struct acpi_resource_fixed_memory32 *p)
 {
 	struct pnp_mem *mem;
@@ -565,10 +573,11 @@
 	mem->flags = (ACPI_READ_WRITE_MEMORY == p->write_protect) ?
 	    IORESOURCE_MEM_WRITEABLE : 0;
 
-	pnp_register_mem_resource(option, mem);
+	pnp_register_mem_resource(dev, option, mem);
 }
 
-static __init void pnpacpi_parse_address_option(struct pnp_option *option,
+static __init void pnpacpi_parse_address_option(struct pnp_dev *dev,
+						struct pnp_option *option,
 						struct acpi_resource *r)
 {
 	struct acpi_resource_address64 addr, *p = &addr;
@@ -596,7 +605,7 @@
 		mem->flags = (p->info.mem.write_protect ==
 			      ACPI_READ_WRITE_MEMORY) ? IORESOURCE_MEM_WRITEABLE
 		    : 0;
-		pnp_register_mem_resource(option, mem);
+		pnp_register_mem_resource(dev, option, mem);
 	} else if (p->resource_type == ACPI_IO_RANGE) {
 		port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 		if (!port)
@@ -605,7 +614,7 @@
 		port->size = p->address_length;
 		port->align = 0;
 		port->flags = PNP_PORT_FLAG_FIXED;
-		pnp_register_port_resource(option, port);
+		pnp_register_port_resource(dev, option, port);
 	}
 }
 
@@ -625,11 +634,11 @@
 
 	switch (res->type) {
 	case ACPI_RESOURCE_TYPE_IRQ:
-		pnpacpi_parse_irq_option(option, &res->data.irq);
+		pnpacpi_parse_irq_option(dev, option, &res->data.irq);
 		break;
 
 	case ACPI_RESOURCE_TYPE_DMA:
-		pnpacpi_parse_dma_option(option, &res->data.dma);
+		pnpacpi_parse_dma_option(dev, option, &res->data.dma);
 		break;
 
 	case ACPI_RESOURCE_TYPE_START_DEPENDENT:
@@ -664,14 +673,16 @@
 		}
 		parse_data->option = parse_data->option_independent;
 		parse_data->option_independent = NULL;
+		dev_dbg(&dev->dev, "end dependent options\n");
 		break;
 
 	case ACPI_RESOURCE_TYPE_IO:
-		pnpacpi_parse_port_option(option, &res->data.io);
+		pnpacpi_parse_port_option(dev, option, &res->data.io);
 		break;
 
 	case ACPI_RESOURCE_TYPE_FIXED_IO:
-		pnpacpi_parse_fixed_port_option(option, &res->data.fixed_io);
+		pnpacpi_parse_fixed_port_option(dev, option,
+					        &res->data.fixed_io);
 		break;
 
 	case ACPI_RESOURCE_TYPE_VENDOR:
@@ -679,29 +690,30 @@
 		break;
 
 	case ACPI_RESOURCE_TYPE_MEMORY24:
-		pnpacpi_parse_mem24_option(option, &res->data.memory24);
+		pnpacpi_parse_mem24_option(dev, option, &res->data.memory24);
 		break;
 
 	case ACPI_RESOURCE_TYPE_MEMORY32:
-		pnpacpi_parse_mem32_option(option, &res->data.memory32);
+		pnpacpi_parse_mem32_option(dev, option, &res->data.memory32);
 		break;
 
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
-		pnpacpi_parse_fixed_mem32_option(option,
+		pnpacpi_parse_fixed_mem32_option(dev, option,
 						 &res->data.fixed_memory32);
 		break;
 
 	case ACPI_RESOURCE_TYPE_ADDRESS16:
 	case ACPI_RESOURCE_TYPE_ADDRESS32:
 	case ACPI_RESOURCE_TYPE_ADDRESS64:
-		pnpacpi_parse_address_option(option, res);
+		pnpacpi_parse_address_option(dev, option, res);
 		break;
 
 	case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
 		break;
 
 	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
-		pnpacpi_parse_ext_irq_option(option, &res->data.extended_irq);
+		pnpacpi_parse_ext_irq_option(dev, option,
+					     &res->data.extended_irq);
 		break;
 
 	case ACPI_RESOURCE_TYPE_GENERIC_REGISTER:

-- 

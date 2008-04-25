Return-Path: <linux-kernel-owner+w=401wt.eu-S1763356AbYDYS5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763356AbYDYS5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764995AbYDYSkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:40:55 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:48756 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764791AbYDYSkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:23 -0400
Message-Id: <20080425183932.246692198@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:47 -0600
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
Subject: [patch 40/54] PNP: make pnp_resource_table private to PNP core
Content-Disposition: inline; filename=pnp-private-resource-table
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no remaining references to the PNP_MAX_* constants or
the pnp_resource_table structure outside of the PNP core.  Make
them private to the PNP core.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |   12 ++++++++++++
 drivers/pnp/core.c             |    8 ++++++++
 drivers/pnp/interface.c        |    8 ++++----
 drivers/pnp/isapnp/core.c      |    4 ++--
 drivers/pnp/manager.c          |   24 ++++++++++++------------
 drivers/pnp/pnpacpi/rsparser.c |   10 ++++++----
 drivers/pnp/pnpbios/rsparser.c |    8 ++++----
 drivers/pnp/resource.c         |    2 +-
 drivers/pnp/support.c          |    8 ++++----
 include/linux/pnp.h            |   14 ++------------
 10 files changed, 55 insertions(+), 43 deletions(-)

Index: work10/include/linux/pnp.h
===================================================================
--- work10.orig/include/linux/pnp.h	2008-04-25 11:15:02.000000000 -0600
+++ work10/include/linux/pnp.h	2008-04-25 11:15:08.000000000 -0600
@@ -13,14 +13,11 @@
 #include <linux/errno.h>
 #include <linux/mod_devicetable.h>
 
-#define PNP_MAX_PORT		40
-#define PNP_MAX_MEM		24
-#define PNP_MAX_IRQ		2
-#define PNP_MAX_DMA		2
 #define PNP_NAME_LEN		50
 
 struct pnp_protocol;
 struct pnp_dev;
+struct pnp_resource_table;
 
 /*
  * Resource Management
@@ -187,13 +184,6 @@
 	struct pnp_option *next;	/* used to chain dependent resources */
 };
 
-struct pnp_resource_table {
-	struct resource port_resource[PNP_MAX_PORT];
-	struct resource mem_resource[PNP_MAX_MEM];
-	struct resource dma_resource[PNP_MAX_DMA];
-	struct resource irq_resource[PNP_MAX_IRQ];
-};
-
 /*
  * Device Management
  */
@@ -263,7 +253,7 @@
 	int capabilities;
 	struct pnp_option *independent;
 	struct pnp_option *dependent;
-	struct pnp_resource_table res;
+	struct pnp_resource_table *res;
 
 	char name[PNP_NAME_LEN];	/* contains a human-readable name */
 	unsigned short regs;		/* ISAPnP: supported registers */
Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-25 11:15:05.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-25 11:15:08.000000000 -0600
@@ -20,3 +20,15 @@
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
 void pnp_init_resource(struct resource *res);
+
+#define PNP_MAX_PORT		40
+#define PNP_MAX_MEM		24
+#define PNP_MAX_IRQ		 2
+#define PNP_MAX_DMA		 2
+
+struct pnp_resource_table {
+	struct resource port_resource[PNP_MAX_PORT];
+	struct resource mem_resource[PNP_MAX_MEM];
+	struct resource dma_resource[PNP_MAX_DMA];
+	struct resource irq_resource[PNP_MAX_IRQ];
+};
Index: work10/drivers/pnp/core.c
===================================================================
--- work10.orig/drivers/pnp/core.c	2008-04-25 11:14:49.000000000 -0600
+++ work10/drivers/pnp/core.c	2008-04-25 11:15:08.000000000 -0600
@@ -106,6 +106,7 @@
 	pnp_free_option(dev->independent);
 	pnp_free_option(dev->dependent);
 	pnp_free_ids(dev);
+	kfree(dev->res);
 	kfree(dev);
 }
 
@@ -118,6 +119,12 @@
 	if (!dev)
 		return NULL;
 
+	dev->res = kzalloc(sizeof(struct pnp_resource_table), GFP_KERNEL);
+	if (!dev->res) {
+		kfree(dev);
+		return NULL;
+	}
+
 	dev->protocol = protocol;
 	dev->number = id;
 	dev->dma_mask = DMA_24BIT_MASK;
@@ -133,6 +140,7 @@
 
 	dev_id = pnp_add_id(dev, pnpid);
 	if (!dev_id) {
+		kfree(dev->res);
 		kfree(dev);
 		return NULL;
 	}
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-25 11:14:59.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-25 11:15:08.000000000 -0600
@@ -931,7 +931,7 @@
 
 static int isapnp_read_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int tmp, ret;
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
@@ -987,7 +987,7 @@
 
 static int isapnp_set_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int tmp;
 
 	dev_dbg(&dev->dev, "set resources\n");
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:06.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:08.000000000 -0600
@@ -21,6 +21,8 @@
 #include <linux/kernel.h>
 #include <linux/acpi.h>
 #include <linux/pci.h>
+#include <linux/pnp.h>
+#include "../base.h"
 #include "pnpacpi.h"
 
 #ifdef CONFIG_IA64
@@ -80,7 +82,7 @@
 						u32 gsi, int triggering,
 						int polarity, int shareable)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 	int irq;
 	int p, t;
@@ -176,7 +178,7 @@
 static void pnpacpi_parse_allocated_dmaresource(struct pnp_dev *dev,
 						u32 dma, int flags)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 	static unsigned char warned;
 
@@ -202,7 +204,7 @@
 static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev,
 					       u64 io, u64 len, int io_decode)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 	static unsigned char warned;
 
@@ -230,7 +232,7 @@
 						u64 mem, u64 len,
 						int write_protect)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 	static unsigned char warned;
 
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:15:06.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:15:08.000000000 -0600
@@ -56,7 +56,7 @@
 
 static void pnpbios_parse_allocated_irqresource(struct pnp_dev *dev, int irq)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 
 	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET)
@@ -76,7 +76,7 @@
 
 static void pnpbios_parse_allocated_dmaresource(struct pnp_dev *dev, int dma)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 
 	while (i < PNP_MAX_DMA &&
@@ -96,7 +96,7 @@
 static void pnpbios_parse_allocated_ioresource(struct pnp_dev *dev,
 					       int io, int len)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 
 	while (!(res->port_resource[i].flags & IORESOURCE_UNSET)
@@ -116,7 +116,7 @@
 static void pnpbios_parse_allocated_memresource(struct pnp_dev *dev,
 						int mem, int len)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 
 	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET)
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-25 11:15:07.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-25 11:15:08.000000000 -0600
@@ -502,7 +502,7 @@
 struct resource *pnp_get_resource(struct pnp_dev *dev,
 				  unsigned int type, unsigned int num)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 
 	switch (type) {
 	case IORESOURCE_IO:
Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-04-25 11:15:05.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-25 11:15:08.000000000 -0600
@@ -27,7 +27,7 @@
 		return 1;
 	}
 
-	res = &dev->res.port_resource[idx];
+	res = &dev->res->port_resource[idx];
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
@@ -74,7 +74,7 @@
 		return 1;
 	}
 
-	res = &dev->res.mem_resource[idx];
+	res = &dev->res->mem_resource[idx];
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
@@ -137,7 +137,7 @@
 		return 1;
 	}
 
-	res = &dev->res.irq_resource[idx];
+	res = &dev->res->irq_resource[idx];
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
@@ -193,7 +193,7 @@
 		return;
 	}
 
-	res = &dev->res.dma_resource[idx];
+	res = &dev->res->dma_resource[idx];
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(res->flags & IORESOURCE_AUTO)) {
@@ -251,22 +251,22 @@
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		res = &dev->res.irq_resource[idx];
+		res = &dev->res->irq_resource[idx];
 		res->flags = IORESOURCE_IRQ;
 		pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		res = &dev->res.dma_resource[idx];
+		res = &dev->res->dma_resource[idx];
 		res->flags = IORESOURCE_DMA;
 		pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		res = &dev->res.port_resource[idx];
+		res = &dev->res->port_resource[idx];
 		res->flags = IORESOURCE_IO;
 		pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		res = &dev->res.mem_resource[idx];
+		res = &dev->res->mem_resource[idx];
 		res->flags = IORESOURCE_MEM;
 		pnp_init_resource(res);
 	}
@@ -282,22 +282,22 @@
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		res = &dev->res.irq_resource[idx];
+		res = &dev->res->irq_resource[idx];
 		if (res->flags & IORESOURCE_AUTO)
 			pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		res = &dev->res.dma_resource[idx];
+		res = &dev->res->dma_resource[idx];
 		if (res->flags & IORESOURCE_AUTO)
 			pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		res = &dev->res.port_resource[idx];
+		res = &dev->res->port_resource[idx];
 		if (res->flags & IORESOURCE_AUTO)
 			pnp_init_resource(res);
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		res = &dev->res.mem_resource[idx];
+		res = &dev->res->mem_resource[idx];
 		if (res->flags & IORESOURCE_AUTO)
 			pnp_init_resource(res);
 	}
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-04-25 11:15:07.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-04-25 11:15:08.000000000 -0600
@@ -382,7 +382,7 @@
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res.port_resource[nport];
+				res = &dev->res->port_resource[nport];
 				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
@@ -403,7 +403,7 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res.mem_resource[nmem];
+				res = &dev->res->mem_resource[nmem];
 				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
@@ -424,7 +424,7 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res.irq_resource[nirq];
+				res = &dev->res->irq_resource[nirq];
 				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
 				res->flags = IORESOURCE_IRQ;
@@ -437,7 +437,7 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = &dev->res.dma_resource[ndma];
+				res = &dev->res->dma_resource[ndma];
 				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
 				res->flags = IORESOURCE_DMA;
Index: work10/drivers/pnp/support.c
===================================================================
--- work10.orig/drivers/pnp/support.c	2008-04-25 11:14:57.000000000 -0600
+++ work10/drivers/pnp/support.c	2008-04-25 11:15:08.000000000 -0600
@@ -61,26 +61,26 @@
 	dev_dbg(&dev->dev, "current resources: %s\n", desc);
 
 	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		res = &dev->res.irq_resource[i];
+		res = &dev->res->irq_resource[i];
 		if (!(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  irq %lld flags 0x%lx\n",
 				(unsigned long long) res->start, res->flags);
 	}
 	for (i = 0; i < PNP_MAX_DMA; i++) {
-		res = &dev->res.dma_resource[i];
+		res = &dev->res->dma_resource[i];
 		if (!(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  dma %lld flags 0x%lx\n",
 				(unsigned long long) res->start, res->flags);
 	}
 	for (i = 0; i < PNP_MAX_PORT; i++) {
-		res = &dev->res.port_resource[i];
+		res = &dev->res->port_resource[i];
 		if (!(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  io  0x%llx-0x%llx flags 0x%lx\n",
 				(unsigned long long) res->start,
 				(unsigned long long) res->end, res->flags);
 	}
 	for (i = 0; i < PNP_MAX_MEM; i++) {
-		res = &dev->res.mem_resource[i];
+		res = &dev->res->mem_resource[i];
 		if (!(res->flags & IORESOURCE_UNSET))
 			dev_dbg(&dev->dev, "  mem 0x%llx-0x%llx flags 0x%lx\n",
 				(unsigned long long) res->start,

-- 

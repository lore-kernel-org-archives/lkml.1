Return-Path: <linux-kernel-owner+w=401wt.eu-S967878AbYD1WyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967878AbYD1WyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966574AbYD1Whp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:45 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:3890 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966749AbYD1WhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:13 -0400
Message-Id: <20080428223624.923080244@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:28 -0600
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
Subject: [patch 41/55] PNP: make pnp_resource_table private to PNP core
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
 drivers/pnp/isapnp/core.c      |    4 ++--
 drivers/pnp/manager.c          |   16 ++++++++--------
 drivers/pnp/pnpacpi/rsparser.c |   10 ++++++----
 drivers/pnp/pnpbios/rsparser.c |    8 ++++----
 drivers/pnp/resource.c         |    2 +-
 include/linux/pnp.h            |   14 ++------------
 8 files changed, 43 insertions(+), 31 deletions(-)

Index: work10/include/linux/pnp.h
===================================================================
--- work10.orig/include/linux/pnp.h	2008-04-28 16:09:30.000000000 -0600
+++ work10/include/linux/pnp.h	2008-04-28 16:09:41.000000000 -0600
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
@@ -184,13 +181,6 @@
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
@@ -260,7 +250,7 @@
 	int capabilities;
 	struct pnp_option *independent;
 	struct pnp_option *dependent;
-	struct pnp_resource_table res;
+	struct pnp_resource_table *res;
 
 	char name[PNP_NAME_LEN];	/* contains a human-readable name */
 	unsigned short regs;		/* ISAPnP: supported registers */
Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-28 16:09:34.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-28 16:09:41.000000000 -0600
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
--- work10.orig/drivers/pnp/core.c	2008-04-28 16:09:12.000000000 -0600
+++ work10/drivers/pnp/core.c	2008-04-28 16:09:41.000000000 -0600
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
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-28 16:09:24.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-28 16:09:41.000000000 -0600
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
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:35.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:41.000000000 -0600
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
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:35.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:41.000000000 -0600
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
--- work10.orig/drivers/pnp/resource.c	2008-04-28 16:09:37.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:41.000000000 -0600
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
--- work10.orig/drivers/pnp/manager.c	2008-04-28 16:09:36.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-28 16:09:41.000000000 -0600
@@ -247,22 +247,22 @@
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
@@ -278,28 +278,28 @@
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		res = &dev->res.irq_resource[idx];
+		res = &dev->res->irq_resource[idx];
 		if (res->flags & IORESOURCE_AUTO) {
 			res->flags = IORESOURCE_IRQ;
 			pnp_init_resource(res);
 		}
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		res = &dev->res.dma_resource[idx];
+		res = &dev->res->dma_resource[idx];
 		if (res->flags & IORESOURCE_AUTO) {
 			res->flags = IORESOURCE_DMA;
 			pnp_init_resource(res);
 		}
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		res = &dev->res.port_resource[idx];
+		res = &dev->res->port_resource[idx];
 		if (res->flags & IORESOURCE_AUTO) {
 			res->flags = IORESOURCE_IO;
 			pnp_init_resource(res);
 		}
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		res = &dev->res.mem_resource[idx];
+		res = &dev->res->mem_resource[idx];
 		if (res->flags & IORESOURCE_AUTO) {
 			res->flags = IORESOURCE_MEM;
 			pnp_init_resource(res);

-- 

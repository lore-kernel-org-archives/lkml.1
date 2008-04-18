Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbYDRVEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbYDRVEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761437AbYDRUww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:52:52 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:21765 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbYDRUwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:16 -0400
Message-Id: <20080418205054.120493549@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:29 -0600
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
Subject: [patch 34/53] PNP: make pnp_resource_table private to PNP core
Content-Disposition: inline; filename=pnp-private-resource-table
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no remaining references to the PNP_MAX_* constants or
the pnp_resource_table structure outside of the PNP core.  Make
them private to the PNP core.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 include/linux/pnp.h            |   14 ++------------
 drivers/pnp/base.h             |   12 ++++++++++++
 drivers/pnp/core.c             |    8 ++++++++
 drivers/pnp/isapnp/core.c      |    4 ++--
 drivers/pnp/pnpacpi/rsparser.c |   10 ++++++----
 drivers/pnp/pnpbios/rsparser.c |    8 ++++----
 drivers/pnp/resource.c         |    2 +-
 7 files changed, 35 insertions(+), 23 deletions(-)

Index: work8/include/linux/pnp.h
===================================================================
--- work8.orig/include/linux/pnp.h	2008-04-17 14:51:52.000000000 -0600
+++ work8/include/linux/pnp.h	2008-04-17 14:57:25.000000000 -0600
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
Index: work8/drivers/pnp/base.h
===================================================================
--- work8.orig/drivers/pnp/base.h	2008-04-17 14:51:52.000000000 -0600
+++ work8/drivers/pnp/base.h	2008-04-17 14:57:25.000000000 -0600
@@ -18,3 +18,15 @@
 int pnp_check_dma(struct pnp_dev * dev, int idx);
 
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
Index: work8/drivers/pnp/core.c
===================================================================
--- work8.orig/drivers/pnp/core.c	2008-04-17 14:51:52.000000000 -0600
+++ work8/drivers/pnp/core.c	2008-04-17 14:57:25.000000000 -0600
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
 
@@ -127,6 +134,7 @@
 
 	dev_id = pnp_add_id(dev, pnpid);
 	if (!dev_id) {
+		kfree(dev->res);
 		kfree(dev);
 		return NULL;
 	}
Index: work8/drivers/pnp/isapnp/core.c
===================================================================
--- work8.orig/drivers/pnp/isapnp/core.c	2008-04-17 14:51:52.000000000 -0600
+++ work8/drivers/pnp/isapnp/core.c	2008-04-17 14:57:25.000000000 -0600
@@ -923,7 +923,7 @@
 
 static int isapnp_read_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int tmp, ret;
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
@@ -978,7 +978,7 @@
 
 static int isapnp_set_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int tmp;
 
 	isapnp_cfg_begin(dev->card->number, dev->number);
Index: work8/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work8.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-17 14:54:45.000000000 -0600
+++ work8/drivers/pnp/pnpacpi/rsparser.c	2008-04-17 14:57:25.000000000 -0600
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
@@ -174,7 +176,7 @@
 static void pnpacpi_parse_allocated_dmaresource(struct pnp_dev *dev,
 						u32 dma, int flags)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 	static unsigned char warned;
 
@@ -200,7 +202,7 @@
 static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev,
 					       u64 io, u64 len, int io_decode)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 	static unsigned char warned;
 
@@ -228,7 +230,7 @@
 						u64 mem, u64 len,
 						int write_protect)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 	static unsigned char warned;
 
Index: work8/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work8.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-17 14:53:00.000000000 -0600
+++ work8/drivers/pnp/pnpbios/rsparser.c	2008-04-17 14:57:25.000000000 -0600
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
Index: work8/drivers/pnp/resource.c
===================================================================
--- work8.orig/drivers/pnp/resource.c	2008-04-17 14:56:51.000000000 -0600
+++ work8/drivers/pnp/resource.c	2008-04-17 14:57:25.000000000 -0600
@@ -492,7 +492,7 @@
 struct resource *pnp_get_resource(struct pnp_dev *dev,
 				  unsigned int type, unsigned int num)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 
 	switch (type) {
 	case IORESOURCE_IO:

-- 

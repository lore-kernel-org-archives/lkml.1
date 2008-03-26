Return-Path: <linux-kernel-owner+w=401wt.eu-S1764076AbYCZRUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764076AbYCZRUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761443AbYCZRJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:09:44 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:32700 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759992AbYCZRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:09:20 -0400
Message-Id: <20080326171230.574480195@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:34 -0600
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
Subject: [patch 36/37] PNP: make pnp_resource_table private to PNP core
Content-Disposition: inline; filename=pnp-private-resource-table
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no remaining references to the PNP_MAX_* constants or
the pnp_resource_table structure outside of the PNP core.  Make
them private to the PNP core.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h     |   12 ++++++++++++
 drivers/pnp/core.c     |    8 ++++++++
 drivers/pnp/manager.c  |    4 ++--
 drivers/pnp/resource.c |   10 +++++-----
 include/linux/pnp.h    |   14 ++------------
 5 files changed, 29 insertions(+), 19 deletions(-)

Index: work7/include/linux/pnp.h
===================================================================
--- work7.orig/include/linux/pnp.h	2008-03-26 11:10:33.000000000 -0600
+++ work7/include/linux/pnp.h	2008-03-26 11:10:34.000000000 -0600
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
@@ -160,13 +157,6 @@
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
@@ -236,7 +226,7 @@
 	int capabilities;
 	struct pnp_option *independent;
 	struct pnp_option *dependent;
-	struct pnp_resource_table res;
+	struct pnp_resource_table *res;
 
 	char name[PNP_NAME_LEN];	/* contains a human-readable name */
 	unsigned short regs;		/* ISAPnP: supported registers */
Index: work7/drivers/pnp/base.h
===================================================================
--- work7.orig/drivers/pnp/base.h	2008-03-26 11:10:26.000000000 -0600
+++ work7/drivers/pnp/base.h	2008-03-26 11:10:34.000000000 -0600
@@ -19,3 +19,15 @@
 int pnp_add_dma_resource(struct pnp_dev *dev, int dma, int flags);
 int pnp_add_io_resource(struct pnp_dev *dev, resource_size_t start, resource_size_t len, int flags);
 int pnp_add_mem_resource(struct pnp_dev *dev, resource_size_t start, resource_size_t len, int flags);
+
+#define PNP_MAX_PORT		40
+#define PNP_MAX_MEM		24
+#define PNP_MAX_IRQ		2
+#define PNP_MAX_DMA		2
+
+struct pnp_resource_table {
+	struct resource port_resource[PNP_MAX_PORT];
+	struct resource mem_resource[PNP_MAX_MEM];
+	struct resource dma_resource[PNP_MAX_DMA];
+	struct resource irq_resource[PNP_MAX_IRQ];
+};
Index: work7/drivers/pnp/manager.c
===================================================================
--- work7.orig/drivers/pnp/manager.c	2008-03-26 11:10:33.000000000 -0600
+++ work7/drivers/pnp/manager.c	2008-03-26 11:10:34.000000000 -0600
@@ -218,7 +218,7 @@
  */
 void pnp_init_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *table = &dev->res;
+	struct pnp_resource_table *table = dev->res;
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
@@ -257,7 +257,7 @@
  */
 static void pnp_clean_resource_table(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
Index: work7/drivers/pnp/resource.c
===================================================================
--- work7.orig/drivers/pnp/resource.c	2008-03-26 11:10:32.000000000 -0600
+++ work7/drivers/pnp/resource.c	2008-03-26 11:10:34.000000000 -0600
@@ -493,7 +493,7 @@
 
 int pnp_add_irq_resource(struct pnp_dev *dev, int irq, int flags)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 	static unsigned char warned;
 
@@ -517,7 +517,7 @@
 
 int pnp_add_dma_resource(struct pnp_dev *dev, int dma, int flags)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 	static unsigned char warned;
 
@@ -541,7 +541,7 @@
 
 int pnp_add_io_resource(struct pnp_dev *dev, resource_size_t start, resource_size_t len, int flags)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	resource_size_t end = start + len - 1;
 	int i = 0;
 	static unsigned char warned;
@@ -566,7 +566,7 @@
 
 int pnp_add_mem_resource(struct pnp_dev *dev, resource_size_t start, resource_size_t len, int flags)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 	int i = 0;
 	static unsigned char warned;
 
@@ -591,7 +591,7 @@
 struct resource *pnp_get_resource(struct pnp_dev *dev,
 				  unsigned int type, unsigned int num)
 {
-	struct pnp_resource_table *res = &dev->res;
+	struct pnp_resource_table *res = dev->res;
 
 	switch (type) {
 	case IORESOURCE_IO:
Index: work7/drivers/pnp/core.c
===================================================================
--- work7.orig/drivers/pnp/core.c	2008-03-26 10:54:04.000000000 -0600
+++ work7/drivers/pnp/core.c	2008-03-26 11:10:34.000000000 -0600
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

-- 

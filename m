Return-Path: <linux-kernel-owner+w=401wt.eu-S1763154AbYCZROf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763154AbYCZROf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760930AbYCZRJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:09:03 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:8973 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760798AbYCZRIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:55 -0400
Message-Id: <20080326171226.939532085@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:16 -0600
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
Subject: [patch 18/37] PNP: add pnp_init_resources(struct pnp_dev *) interface
Content-Disposition: inline; filename=pnp-remove-pnp_resource_table-from-init
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pnp_init_resources(struct pnp_dev *), which will replace
pnp_init_resource_table(), which takes a pointer to the
pnp_resource_table itself.  Passing only the pnp_dev * reduces
the possibility for error in the caller and removes the
pnp_resource_table implementation detail from the interface.

Even though pnp_init_resource_table() is exported, I did not
export pnp_init_resources() because it is used only by the PNP
core.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/interface.c        |    6 +++---
 drivers/pnp/isapnp/core.c      |    4 ++--
 drivers/pnp/manager.c          |    5 +++++
 drivers/pnp/pnpacpi/core.c     |    2 +-
 drivers/pnp/pnpacpi/rsparser.c |    3 +--
 drivers/pnp/pnpbios/core.c     |    2 +-
 drivers/pnp/pnpbios/rsparser.c |    3 +--
 include/linux/pnp.h            |    2 ++
 8 files changed, 16 insertions(+), 11 deletions(-)

Index: work7/include/linux/pnp.h
===================================================================
--- work7.orig/include/linux/pnp.h	2008-03-25 14:48:39.000000000 -0600
+++ work7/include/linux/pnp.h	2008-03-25 14:48:47.000000000 -0600
@@ -388,6 +388,7 @@
 			       struct pnp_port *data);
 int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data);
 void pnp_init_resource_table(struct pnp_resource_table *table);
+void pnp_init_resources(struct pnp_dev *dev);
 int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
 			  int mode);
 int pnp_auto_config_dev(struct pnp_dev *dev);
@@ -435,6 +436,7 @@
 static inline int pnp_register_port_resource(struct pnp_option *option, struct pnp_port *data) { return -ENODEV; }
 static inline int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data) { return -ENODEV; }
 static inline void pnp_init_resource_table(struct pnp_resource_table *table) { }
+static inline void pnp_init_resources(struct pnp_dev *dev) { }
 static inline int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res, int mode) { return -ENODEV; }
 static inline int pnp_auto_config_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_validate_config(struct pnp_dev *dev) { return -ENODEV; }
Index: work7/drivers/pnp/manager.c
===================================================================
--- work7.orig/drivers/pnp/manager.c	2008-03-25 14:48:39.000000000 -0600
+++ work7/drivers/pnp/manager.c	2008-03-25 14:48:47.000000000 -0600
@@ -238,6 +238,11 @@
 	}
 }
 
+void pnp_init_resources(struct pnp_dev *dev)
+{
+	pnp_init_resource_table(&dev->res);
+}
+
 /**
  * pnp_clean_resources - clears resources that were not manually set
  * @res: the resources to clean
Index: work7/drivers/pnp/interface.c
===================================================================
--- work7.orig/drivers/pnp/interface.c	2008-03-25 14:48:39.000000000 -0600
+++ work7/drivers/pnp/interface.c	2008-03-25 14:48:47.000000000 -0600
@@ -351,14 +351,14 @@
 	if (!strnicmp(buf, "auto", 4)) {
 		if (dev->active)
 			goto done;
-		pnp_init_resource_table(&dev->res);
+		pnp_init_resources(dev);
 		retval = pnp_auto_config_dev(dev);
 		goto done;
 	}
 	if (!strnicmp(buf, "clear", 5)) {
 		if (dev->active)
 			goto done;
-		pnp_init_resource_table(&dev->res);
+		pnp_init_resources(dev);
 		goto done;
 	}
 	if (!strnicmp(buf, "get", 3)) {
@@ -373,7 +373,7 @@
 		if (dev->active)
 			goto done;
 		buf += 3;
-		pnp_init_resource_table(&dev->res);
+		pnp_init_resources(dev);
 		mutex_lock(&pnp_res_mutex);
 		while (1) {
 			while (isspace(*buf))
Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-25 14:48:44.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-25 14:48:47.000000000 -0600
@@ -438,7 +438,7 @@
 	dev->capabilities |= PNP_READ;
 	dev->capabilities |= PNP_WRITE;
 	dev->capabilities |= PNP_DISABLE;
-	pnp_init_resource_table(&dev->res);
+	pnp_init_resources(dev);
 	return dev;
 }
 
@@ -982,7 +982,7 @@
 {
 	int ret;
 
-	pnp_init_resource_table(&dev->res);
+	pnp_init_resources(dev);
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	ret = isapnp_read_resources(dev);
 	isapnp_cfg_end();
Index: work7/drivers/pnp/pnpacpi/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/core.c	2008-03-25 14:48:44.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/core.c	2008-03-25 14:48:47.000000000 -0600
@@ -210,7 +210,7 @@
 
 	/* clear out the damaged flags */
 	if (!dev->active)
-		pnp_init_resource_table(&dev->res);
+		pnp_init_resources(dev);
 	pnp_add_device(dev);
 	num++;
 
Index: work7/drivers/pnp/pnpbios/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/core.c	2008-03-25 14:48:44.000000000 -0600
+++ work7/drivers/pnp/pnpbios/core.c	2008-03-25 14:48:47.000000000 -0600
@@ -346,7 +346,7 @@
 
 	/* clear out the damaged flags */
 	if (!dev->active)
-		pnp_init_resource_table(&dev->res);
+		pnp_init_resources(dev);
 
 	pnp_add_device(dev);
 	pnpbios_interface_attach_device(node);
Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-25 14:48:44.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-25 14:48:47.000000000 -0600
@@ -406,8 +406,7 @@
 {
 	acpi_handle handle = dev->data;
 
-	/* Blank the resource table values */
-	pnp_init_resource_table(&dev->res);
+	pnp_init_resources(dev);
 
 	return acpi_walk_resources(handle, METHOD_NAME__CRS,
 				   pnpacpi_allocated_resource, dev);
Index: work7/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/rsparser.c	2008-03-25 14:48:44.000000000 -0600
+++ work7/drivers/pnp/pnpbios/rsparser.c	2008-03-25 14:48:47.000000000 -0600
@@ -143,8 +143,7 @@
 	if (!p)
 		return NULL;
 
-	/* Blank the resource table values */
-	pnp_init_resource_table(&dev->res);
+	pnp_init_resources(dev);
 
 	while ((char *)p < (char *)end) {
 

-- 

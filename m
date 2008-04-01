Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbYDAPXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbYDAPXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759430AbYDAPSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:18:23 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:34915 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759330AbYDAPSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:18:06 -0400
Message-Id: <20080401151738.838525355@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:50 -0600
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
Subject: [patch 16/37] PNP: remove pnp_resource_table from internal get/set interfaces
Content-Disposition: inline; filename=pnp-remove-pnp_resource_table-args-from-get-set
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we call protocol->get() and protocol->set() methods, we currently
supply pointers to both the pnp_dev and the pnp_resource_table even
though the pnp_resource_table should always be the one associated with
the pnp_dev.

This removes the pnp_resource_table arguments to make it clear that
these methods only operate on the specified pnp_dev.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 include/linux/pnp.h        |    4 ++--
 drivers/pnp/interface.c    |    2 +-
 drivers/pnp/manager.c      |    2 +-
 drivers/pnp/isapnp/core.c  |   11 +++++------
 drivers/pnp/pnpacpi/core.c |    8 +++-----
 drivers/pnp/pnpbios/core.c |   10 ++++------
 6 files changed, 16 insertions(+), 21 deletions(-)

Index: work7/include/linux/pnp.h
===================================================================
--- work7.orig/include/linux/pnp.h	2008-03-31 17:07:19.000000000 -0600
+++ work7/include/linux/pnp.h	2008-03-31 17:10:39.000000000 -0600
@@ -328,8 +328,8 @@
 	char *name;
 
 	/* resource control functions */
-	int (*get) (struct pnp_dev *dev, struct pnp_resource_table *res);
-	int (*set) (struct pnp_dev *dev, struct pnp_resource_table *res);
+	int (*get) (struct pnp_dev *dev);
+	int (*set) (struct pnp_dev *dev);
 	int (*disable) (struct pnp_dev *dev);
 
 	/* protocol specific suspend/resume */
Index: work7/drivers/pnp/interface.c
===================================================================
--- work7.orig/drivers/pnp/interface.c	2008-03-31 16:59:07.000000000 -0600
+++ work7/drivers/pnp/interface.c	2008-03-31 17:10:39.000000000 -0600
@@ -364,7 +364,7 @@
 	if (!strnicmp(buf, "get", 3)) {
 		mutex_lock(&pnp_res_mutex);
 		if (pnp_can_read(dev))
-			dev->protocol->get(dev, &dev->res);
+			dev->protocol->get(dev);
 		mutex_unlock(&pnp_res_mutex);
 		goto done;
 	}
Index: work7/drivers/pnp/manager.c
===================================================================
--- work7.orig/drivers/pnp/manager.c	2008-03-31 16:59:07.000000000 -0600
+++ work7/drivers/pnp/manager.c	2008-03-31 17:10:39.000000000 -0600
@@ -473,7 +473,7 @@
 		return -EINVAL;
 	}
 
-	if (dev->protocol->set(dev, &dev->res) < 0) {
+	if (dev->protocol->set(dev) < 0) {
 		dev_err(&dev->dev, "activation failed\n");
 		return -EIO;
 	}
Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-31 17:10:26.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-31 17:10:39.000000000 -0600
@@ -968,21 +968,20 @@
 	return 0;
 }
 
-static int isapnp_get_resources(struct pnp_dev *dev,
-				struct pnp_resource_table *res)
+static int isapnp_get_resources(struct pnp_dev *dev)
 {
 	int ret;
 
-	pnp_init_resource_table(res);
+	pnp_init_resource_table(&dev->res);
 	isapnp_cfg_begin(dev->card->number, dev->number);
-	ret = isapnp_read_resources(dev, res);
+	ret = isapnp_read_resources(dev, &dev->res);
 	isapnp_cfg_end();
 	return ret;
 }
 
-static int isapnp_set_resources(struct pnp_dev *dev,
-				struct pnp_resource_table *res)
+static int isapnp_set_resources(struct pnp_dev *dev)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int tmp;
 
 	isapnp_cfg_begin(dev->card->number, dev->number);
Index: work7/drivers/pnp/pnpacpi/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/core.c	2008-03-31 17:10:38.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/core.c	2008-03-31 17:10:39.000000000 -0600
@@ -73,8 +73,7 @@
 	return 1;
 }
 
-static int pnpacpi_get_resources(struct pnp_dev *dev,
-				 struct pnp_resource_table *res)
+static int pnpacpi_get_resources(struct pnp_dev *dev)
 {
 	acpi_status status;
 
@@ -83,8 +82,7 @@
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
 
-static int pnpacpi_set_resources(struct pnp_dev *dev,
-				 struct pnp_resource_table *res)
+static int pnpacpi_set_resources(struct pnp_dev *dev)
 {
 	acpi_handle handle = dev->data;
 	struct acpi_buffer buffer;
@@ -94,7 +92,7 @@
 	ret = pnpacpi_build_resource_template(dev, &buffer);
 	if (ret)
 		return ret;
-	ret = pnpacpi_encode_resources(res, &buffer);
+	ret = pnpacpi_encode_resources(&dev->res, &buffer);
 	if (ret) {
 		kfree(buffer.pointer);
 		return ret;
Index: work7/drivers/pnp/pnpbios/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/core.c	2008-03-31 17:05:32.000000000 -0600
+++ work7/drivers/pnp/pnpbios/core.c	2008-03-31 17:10:39.000000000 -0600
@@ -204,8 +204,7 @@
 
 #endif				/* CONFIG_HOTPLUG */
 
-static int pnpbios_get_resources(struct pnp_dev *dev,
-				 struct pnp_resource_table *res)
+static int pnpbios_get_resources(struct pnp_dev *dev)
 {
 	u8 nodenum = dev->number;
 	struct pnp_bios_node *node;
@@ -220,14 +219,13 @@
 		kfree(node);
 		return -ENODEV;
 	}
-	pnpbios_read_resources_from_node(res, node);
+	pnpbios_read_resources_from_node(&dev->res, node);
 	dev->active = pnp_is_active(dev);
 	kfree(node);
 	return 0;
 }
 
-static int pnpbios_set_resources(struct pnp_dev *dev,
-				 struct pnp_resource_table *res)
+static int pnpbios_set_resources(struct pnp_dev *dev)
 {
 	u8 nodenum = dev->number;
 	struct pnp_bios_node *node;
@@ -243,7 +241,7 @@
 		kfree(node);
 		return -ENODEV;
 	}
-	if (pnpbios_write_resources_to_node(res, node) < 0) {
+	if (pnpbios_write_resources_to_node(&dev->res, node) < 0) {
 		kfree(node);
 		return -1;
 	}

-- 

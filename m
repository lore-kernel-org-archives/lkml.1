Return-Path: <linux-kernel-owner+w=401wt.eu-S932725AbYDYTDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbYDYTDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761747AbYDYSlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:41:31 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:19330 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764945AbYDYSkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:42 -0400
Message-Id: <20080425183934.932494912@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:58 -0600
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
Subject: [patch 51/54] PNPACPI: move _CRS/_PRS warnings closer to the action
Content-Disposition: inline; filename=pnpacpi-cleanup-CRS-PRS-warnings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move warnings about _CRS and _PRS problems to the place where we
actually make the ACPI calls.  Then we don't have to pass around
acpi_status values any more than necessary.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/pnpacpi/pnpacpi.h
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/pnpacpi.h	2008-04-25 11:14:56.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/pnpacpi.h	2008-04-25 11:15:15.000000000 -0600
@@ -5,8 +5,8 @@
 #include <linux/acpi.h>
 #include <linux/pnp.h>
 
-acpi_status pnpacpi_parse_allocated_resource(struct pnp_dev *);
-acpi_status pnpacpi_parse_resource_option_data(struct pnp_dev *);
+int pnpacpi_parse_allocated_resource(struct pnp_dev *);
+int pnpacpi_parse_resource_option_data(struct pnp_dev *);
 int pnpacpi_encode_resources(struct pnp_dev *, struct acpi_buffer *);
 int pnpacpi_build_resource_template(struct pnp_dev *, struct acpi_buffer *);
 #endif
Index: work10/drivers/pnp/pnpacpi/core.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/core.c	2008-04-25 11:14:58.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/core.c	2008-04-25 11:15:15.000000000 -0600
@@ -75,11 +75,8 @@
 
 static int pnpacpi_get_resources(struct pnp_dev *dev)
 {
-	acpi_status status;
-
 	dev_dbg(&dev->dev, "get resources\n");
-	status = pnpacpi_parse_allocated_resource(dev);
-	return ACPI_FAILURE(status) ? -ENODEV : 0;
+	return pnpacpi_parse_allocated_resource(dev);
 }
 
 static int pnpacpi_set_resources(struct pnp_dev *dev)
@@ -182,22 +179,11 @@
 	else
 		strncpy(dev->name, acpi_device_bid(device), sizeof(dev->name));
 
-	if (dev->active) {
-		/* parse allocated resource */
-		status = pnpacpi_parse_allocated_resource(dev);
-		if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
-			pnp_err("PnPACPI: METHOD_NAME__CRS failure for %s",
-				acpi_device_hid(device));
-		}
-	}
+	if (dev->active)
+		pnpacpi_parse_allocated_resource(dev);
 
-	if (dev->capabilities & PNP_CONFIGURABLE) {
-		status = pnpacpi_parse_resource_option_data(dev);
-		if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
-			pnp_err("PnPACPI: METHOD_NAME__PRS failure for %s",
-				acpi_device_hid(device));
-		}
-	}
+	if (dev->capabilities & PNP_CONFIGURABLE)
+		pnpacpi_parse_resource_option_data(dev);
 
 	if (device->flags.compatible_ids) {
 		struct acpi_compatible_id_list *cid_list = device->pnp.cid_list;
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:13.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:15.000000000 -0600
@@ -339,16 +339,24 @@
 	return AE_OK;
 }
 
-acpi_status pnpacpi_parse_allocated_resource(struct pnp_dev *dev)
+int pnpacpi_parse_allocated_resource(struct pnp_dev *dev)
 {
 	acpi_handle handle = dev->data;
+	acpi_status status;
 
 	dev_dbg(&dev->dev, "parse allocated resources\n");
 
 	pnp_init_resources(dev);
 
-	return acpi_walk_resources(handle, METHOD_NAME__CRS,
-				   pnpacpi_allocated_resource, dev);
+	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
+				     pnpacpi_allocated_resource, dev);
+
+	if (ACPI_FAILURE(status)) {
+		if (status != AE_NOT_FOUND)
+			dev_err(&dev->dev, "can't evaluate _CRS: %d", status);
+		return -EPERM;
+	}
+	return 0;
 }
 
 static __init void pnpacpi_parse_dma_option(struct pnp_dev *dev,
@@ -670,7 +678,7 @@
 	return AE_OK;
 }
 
-acpi_status __init pnpacpi_parse_resource_option_data(struct pnp_dev *dev)
+int __init pnpacpi_parse_resource_option_data(struct pnp_dev *dev)
 {
 	acpi_handle handle = dev->data;
 	acpi_status status;
@@ -680,13 +688,19 @@
 
 	parse_data.option = pnp_register_independent_option(dev);
 	if (!parse_data.option)
-		return AE_ERROR;
+		return -ENOMEM;
+
 	parse_data.option_independent = parse_data.option;
 	parse_data.dev = dev;
 	status = acpi_walk_resources(handle, METHOD_NAME__PRS,
 				     pnpacpi_option_resource, &parse_data);
 
-	return status;
+	if (ACPI_FAILURE(status)) {
+		if (status != AE_NOT_FOUND)
+			dev_err(&dev->dev, "can't evaluate _PRS: %d", status);
+		return -EPERM;
+	}
+	return 0;
 }
 
 static int pnpacpi_supported_resource(struct acpi_resource *res)
@@ -745,7 +759,7 @@
 	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
 				     pnpacpi_count_resources, &res_cnt);
 	if (ACPI_FAILURE(status)) {
-		dev_err(&dev->dev, "can't evaluate _CRS\n");
+		dev_err(&dev->dev, "can't evaluate _CRS: %d\n", status);
 		return -EINVAL;
 	}
 	if (!res_cnt)
@@ -760,7 +774,7 @@
 				     pnpacpi_type_resources, &resource);
 	if (ACPI_FAILURE(status)) {
 		kfree(buffer->pointer);
-		dev_err(&dev->dev, "can't evaluate _CRS\n");
+		dev_err(&dev->dev, "can't evaluate _CRS: %d\n", status);
 		return -EINVAL;
 	}
 	/* resource will pointer the end resource now */

-- 

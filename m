Return-Path: <linux-kernel-owner+w=401wt.eu-S1765700AbYDYSml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765700AbYDYSml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761280AbYDYSjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:39:36 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:9688 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbYDYSjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:39:31 -0400
Message-Id: <20080425183925.114514156@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:12 -0600
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
Subject: [patch 05/54] PNP: change pnp_add_id() to allocate its own pnp_id structures
Content-Disposition: inline; filename=pnp-move-allocation-into-pnp_add_id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves some of the pnp_id knowledge out of the backends and into
the PNP core.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/base.h             |    2 +-
 drivers/pnp/driver.c           |   28 +++++++++++++++++++++-------
 drivers/pnp/isapnp/core.c      |   24 +++++++++++-------------
 drivers/pnp/pnpacpi/core.c     |   27 +++------------------------
 drivers/pnp/pnpbios/core.c     |   10 +---------
 drivers/pnp/pnpbios/rsparser.c |    7 +------
 6 files changed, 38 insertions(+), 60 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-25 11:14:45.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-25 11:14:46.000000000 -0600
@@ -1,6 +1,6 @@
 extern spinlock_t pnp_lock;
 void *pnp_alloc(long size);
-int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev);
+struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
 int pnp_interface_attach_device(struct pnp_dev *dev);
 void pnp_fixup_device(struct pnp_dev *dev);
 void pnp_free_option(struct pnp_option *option);
Index: work10/drivers/pnp/driver.c
===================================================================
--- work10.orig/drivers/pnp/driver.c	2008-04-25 11:12:17.000000000 -0600
+++ work10/drivers/pnp/driver.c	2008-04-25 11:14:46.000000000 -0600
@@ -226,22 +226,36 @@
 
 /**
  * pnp_add_id - adds an EISA id to the specified device
- * @id: pointer to a pnp_id structure
  * @dev: pointer to the desired device
+ * @id: pointer to an EISA id string
  */
-int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev)
+struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id)
 {
-	struct pnp_id *ptr;
+	struct pnp_id *dev_id, *ptr;
 
-	id->next = NULL;
+	dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
+	if (!dev_id)
+		return NULL;
+
+	dev_id->id[0] = id[0];
+	dev_id->id[1] = id[1];
+	dev_id->id[2] = id[2];
+	dev_id->id[3] = tolower(id[3]);
+	dev_id->id[4] = tolower(id[4]);
+	dev_id->id[5] = tolower(id[5]);
+	dev_id->id[6] = tolower(id[6]);
+	dev_id->id[7] = '\0';
+
+	dev_id->next = NULL;
 	ptr = dev->id;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
 	if (ptr)
-		ptr->next = id;
+		ptr->next = dev_id;
 	else
-		dev->id = id;
-	return 0;
+		dev->id = dev_id;
+
+	return dev_id;
 }
 
 EXPORT_SYMBOL(pnp_register_driver);
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-25 11:14:44.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-25 11:14:46.000000000 -0600
@@ -44,6 +44,8 @@
 #include <linux/mutex.h>
 #include <asm/io.h>
 
+#include "../base.h"
+
 #if 0
 #define ISAPNP_REGION_OK
 #endif
@@ -401,20 +403,16 @@
 static void isapnp_parse_id(struct pnp_dev *dev, unsigned short vendor,
 			    unsigned short device)
 {
-	struct pnp_id *id;
+	char id[8];
 
-	if (!dev)
-		return;
-	id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
-	if (!id)
-		return;
-	sprintf(id->id, "%c%c%c%x%x%x%x",
+	sprintf(id, "%c%c%c%x%x%x%x",
 		'A' + ((vendor >> 2) & 0x3f) - 1,
 		'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1,
 		'A' + ((vendor >> 8) & 0x1f) - 1,
 		(device >> 4) & 0x0f,
 		device & 0x0f, (device >> 12) & 0x0f, (device >> 8) & 0x0f);
-	pnp_add_id(id, dev);
+
+	pnp_add_id(dev, id);
 }
 
 /*
Index: work10/drivers/pnp/pnpacpi/core.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/core.c	2008-04-25 11:14:45.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/core.c	2008-04-25 11:14:46.000000000 -0600
@@ -73,18 +73,6 @@
 	return 1;
 }
 
-static void __init pnpidacpi_to_pnpid(char *id, char *str)
-{
-	str[0] = id[0];
-	str[1] = id[1];
-	str[2] = id[2];
-	str[3] = tolower(id[3]);
-	str[4] = tolower(id[4]);
-	str[5] = tolower(id[5]);
-	str[6] = tolower(id[6]);
-	str[7] = '\0';
-}
-
 static int pnpacpi_get_resources(struct pnp_dev *dev,
 				 struct pnp_resource_table *res)
 {
@@ -201,12 +189,9 @@
 
 	dev->number = num;
 
-	/* set the initial values for the PnP device */
-	dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
+	dev_id = pnp_add_id(dev, acpi_device_hid(device));
 	if (!dev_id)
 		goto err;
-	pnpidacpi_to_pnpid(acpi_device_hid(device), dev_id->id);
-	pnp_add_id(dev_id, dev);
 
 	if (dev->active) {
 		/* parse allocated resource */
@@ -227,7 +212,6 @@
 		}
 	}
 
-	/* parse compatible ids */
 	if (device->flags.compatible_ids) {
 		struct acpi_compatible_id_list *cid_list = device->pnp.cid_list;
 		int i;
@@ -235,12 +219,7 @@
 		for (i = 0; i < cid_list->count; i++) {
 			if (!ispnpidacpi(cid_list->id[i].value))
 				continue;
-			dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
-			if (!dev_id)
-				continue;
-
-			pnpidacpi_to_pnpid(cid_list->id[i].value, dev_id->id);
-			pnp_add_id(dev_id, dev);
+			pnp_add_id(dev, cid_list->id[i].value);
 		}
 	}
 
Index: work10/drivers/pnp/pnpbios/core.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/core.c	2008-04-25 11:14:45.000000000 -0600
+++ work10/drivers/pnp/pnpbios/core.c	2008-04-25 11:14:46.000000000 -0600
@@ -332,16 +332,14 @@
 	if (!dev)
 		return -1;
 
-	dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
+	pnpid32_to_pnpid(node->eisa_id, id);
+	dev_id = pnp_add_id(dev, id);
 	if (!dev_id) {
 		kfree(dev);
 		return -1;
 	}
 
 	dev->number = node->handle;
-	pnpid32_to_pnpid(node->eisa_id, id);
-	memcpy(dev_id->id, id, 7);
-	pnp_add_id(dev_id, dev);
 	pnpbios_parse_data_stream(dev, node);
 	dev->active = pnp_is_active(dev);
 	dev->flags = node->flags;
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:12:17.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:14:46.000000000 -0600
@@ -16,6 +16,7 @@
 }
 #endif				/* CONFIG_PCI */
 
+#include "../base.h"
 #include "pnpbios.h"
 
 /* standard resource tags */
@@ -548,13 +549,11 @@
 		case SMALL_TAG_COMPATDEVID:	/* compatible ID */
 			if (len != 4)
 				goto len_err;
-			dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
-			if (!dev_id)
-				return NULL;
 			pnpid32_to_pnpid(p[1] | p[2] << 8 | p[3] << 16 | p[4] <<
 					 24, id);
-			memcpy(&dev_id->id, id, 7);
-			pnp_add_id(dev_id, dev);
+			dev_id = pnp_add_id(dev, id);
+			if (!dev_id)
+				return NULL;
 			break;
 
 		case SMALL_TAG_END:

-- 

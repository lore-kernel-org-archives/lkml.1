Return-Path: <linux-kernel-owner+w=401wt.eu-S967160AbYD1WlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967160AbYD1WlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966127AbYD1Wgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:36:32 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30376 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965834AbYD1Wg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:28 -0400
Message-Id: <20080428223617.870551928@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:33:54 -0600
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
Subject: [patch 07/55] PNP: add pnp_alloc_dev()
Content-Disposition: inline; filename=pnp-alloc-dev
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pnp_alloc_dev() to allocate a struct pnp_dev and fill in the
protocol, instance number, and initial PNP ID.  Now it is always
valid to use dev_printk() on any pnp_dev pointer.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/base.h         |    1 +
 drivers/pnp/core.c         |   38 +++++++++++++++++++++++++++++++-------
 drivers/pnp/isapnp/core.c  |   11 +++++------
 drivers/pnp/pnpacpi/core.c |   19 +++----------------
 drivers/pnp/pnpbios/core.c |   13 ++-----------
 5 files changed, 42 insertions(+), 40 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-28 16:09:11.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-28 16:09:12.000000000 -0600
@@ -2,6 +2,7 @@
 void *pnp_alloc(long size);
 #define PNP_EISA_ID_MASK 0x7fffffff
 void pnp_eisa_id_to_string(u32 id, char *str);
+struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *, int id, char *pnpid);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
 int pnp_interface_attach_device(struct pnp_dev *dev);
 void pnp_fixup_device(struct pnp_dev *dev);
Index: work10/drivers/pnp/core.c
===================================================================
--- work10.orig/drivers/pnp/core.c	2008-04-28 15:57:04.000000000 -0600
+++ work10/drivers/pnp/core.c	2008-04-28 16:09:12.000000000 -0600
@@ -109,15 +109,42 @@
 	kfree(dev);
 }
 
-int __pnp_add_device(struct pnp_dev *dev)
+struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *protocol, int id, char *pnpid)
 {
-	int ret;
+	struct pnp_dev *dev;
+	struct pnp_id *dev_id;
 
-	pnp_fixup_device(dev);
+	dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	dev->protocol = protocol;
+	dev->number = id;
+	dev->dma_mask = DMA_24BIT_MASK;
+
+	dev->dev.parent = &dev->protocol->dev;
 	dev->dev.bus = &pnp_bus_type;
 	dev->dev.dma_mask = &dev->dma_mask;
-	dev->dma_mask = dev->dev.coherent_dma_mask = DMA_24BIT_MASK;
+	dev->dev.coherent_dma_mask = dev->dma_mask;
 	dev->dev.release = &pnp_release_device;
+
+	sprintf(dev->dev.bus_id, "%02x:%02x", dev->protocol->number,
+		dev->number);
+
+	dev_id = pnp_add_id(dev, pnpid);
+	if (!dev_id) {
+		kfree(dev);
+		return NULL;
+	}
+
+	return dev;
+}
+
+int __pnp_add_device(struct pnp_dev *dev)
+{
+	int ret;
+
+	pnp_fixup_device(dev);
 	dev->status = PNP_READY;
 	spin_lock(&pnp_lock);
 	list_add_tail(&dev->global_list, &pnp_global);
@@ -145,9 +172,6 @@
 	if (dev->card)
 		return -EINVAL;
 
-	dev->dev.parent = &dev->protocol->dev;
-	sprintf(dev->dev.bus_id, "%02x:%02x", dev->protocol->number,
-		dev->number);
 	ret = __pnp_add_device(dev);
 	if (ret)
 		return ret;
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-28 16:09:11.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-28 16:09:12.000000000 -0600
@@ -409,18 +409,17 @@
 	char id[8];
 
 	isapnp_peek(tmp, size);
-	dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
-	if (!dev)
-		return NULL;
-	dev->number = number;
 	eisa_id = tmp[0] | tmp[1] << 8 | tmp[2] << 16 | tmp[3] << 24;
 	pnp_eisa_id_to_string(eisa_id, id);
-	pnp_add_id(dev, id);
+
+	dev = pnp_alloc_dev(&isapnp_protocol, number, id);
+	if (!dev)
+		return NULL;
+
 	dev->regs = tmp[4];
 	dev->card = card;
 	if (size > 5)
 		dev->regs |= tmp[5] << 8;
-	dev->protocol = &isapnp_protocol;
 	dev->capabilities |= PNP_CONFIGURABLE;
 	dev->capabilities |= PNP_READ;
 	dev->capabilities |= PNP_WRITE;
Index: work10/drivers/pnp/pnpacpi/core.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/core.c	2008-04-28 16:09:10.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/core.c	2008-04-28 16:09:12.000000000 -0600
@@ -152,7 +152,6 @@
 {
 	acpi_handle temp = NULL;
 	acpi_status status;
-	struct pnp_id *dev_id;
 	struct pnp_dev *dev;
 
 	status = acpi_get_handle(device->handle, "_CRS", &temp);
@@ -160,11 +159,10 @@
 	    is_exclusive_device(device))
 		return 0;
 
-	dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
-	if (!dev) {
-		pnp_err("Out of memory");
+	dev = pnp_alloc_dev(&pnpacpi_protocol, num, acpi_device_hid(device));
+	if (!dev)
 		return -ENOMEM;
-	}
+
 	dev->data = device->handle;
 	/* .enabled means the device can decode the resources */
 	dev->active = device->status.enabled;
@@ -180,19 +178,11 @@
 	if (ACPI_SUCCESS(status))
 		dev->capabilities |= PNP_DISABLE;
 
-	dev->protocol = &pnpacpi_protocol;
-
 	if (strlen(acpi_device_name(device)))
 		strncpy(dev->name, acpi_device_name(device), sizeof(dev->name));
 	else
 		strncpy(dev->name, acpi_device_bid(device), sizeof(dev->name));
 
-	dev->number = num;
-
-	dev_id = pnp_add_id(dev, acpi_device_hid(device));
-	if (!dev_id)
-		goto err;
-
 	if (dev->active) {
 		/* parse allocated resource */
 		status = pnpacpi_parse_allocated_resource(device->handle,
@@ -230,9 +220,6 @@
 	num++;
 
 	return AE_OK;
-err:
-	kfree(dev);
-	return -EINVAL;
 }
 
 static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
Index: work10/drivers/pnp/pnpbios/core.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/core.c	2008-04-28 16:09:11.000000000 -0600
+++ work10/drivers/pnp/pnpbios/core.c	2008-04-28 16:09:12.000000000 -0600
@@ -318,7 +318,6 @@
 {
 	struct list_head *pos;
 	struct pnp_dev *dev;
-	struct pnp_id *dev_id;
 	char id[8];
 
 	/* check if the device is already added */
@@ -328,18 +327,11 @@
 			return -1;
 	}
 
-	dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
-	if (!dev)
-		return -1;
-
 	pnp_eisa_id_to_string(node->eisa_id & PNP_EISA_ID_MASK, id);
-	dev_id = pnp_add_id(dev, id);
-	if (!dev_id) {
-		kfree(dev);
+	dev = pnp_alloc_dev(&pnpbios_protocol, node->handle, id);
+	if (!dev)
 		return -1;
-	}
 
-	dev->number = node->handle;
 	pnpbios_parse_data_stream(dev, node);
 	dev->active = pnp_is_active(dev);
 	dev->flags = node->flags;
@@ -352,7 +344,6 @@
 		dev->capabilities |= PNP_WRITE;
 	if (dev->flags & PNPBIOS_REMOVABLE)
 		dev->capabilities |= PNP_REMOVABLE;
-	dev->protocol = &pnpbios_protocol;
 
 	/* clear out the damaged flags */
 	if (!dev->active)

-- 

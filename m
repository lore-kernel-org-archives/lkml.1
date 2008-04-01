Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbYDAPUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbYDAPUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759299AbYDAPSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:18:01 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10561 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758911AbYDAPRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:17:50 -0400
Message-Id: <20080401151736.807325335@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:40 -0600
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
Subject: [patch 06/37] PNP: add pnp_alloc_dev()
Content-Disposition: inline; filename=pnp-alloc-dev
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pnp_alloc_dev() to allocate a struct pnp_dev and fill in the
protocol, instance number, and initial PNP ID.  Now it is always
valid to use dev_printk() on any pnp_dev pointer.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h         |    1 +
 drivers/pnp/core.c         |   28 +++++++++++++++++++++++++---
 drivers/pnp/isapnp/core.c  |   11 +++++------
 drivers/pnp/pnpacpi/core.c |   19 +++----------------
 drivers/pnp/pnpbios/core.c |   15 +++------------
 5 files changed, 37 insertions(+), 37 deletions(-)

Index: work7/drivers/pnp/base.h
===================================================================
--- work7.orig/drivers/pnp/base.h	2008-03-31 17:02:52.000000000 -0600
+++ work7/drivers/pnp/base.h	2008-03-31 17:05:32.000000000 -0600
@@ -1,6 +1,7 @@
 extern spinlock_t pnp_lock;
 void *pnp_alloc(long size);
 void pnp_eisa_id_to_string(u32 id, char *str);
+struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *, int id, char *pnpid);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
 int pnp_interface_attach_device(struct pnp_dev *dev);
 void pnp_fixup_device(struct pnp_dev *dev);
Index: work7/drivers/pnp/core.c
===================================================================
--- work7.orig/drivers/pnp/core.c	2008-03-31 17:02:52.000000000 -0600
+++ work7/drivers/pnp/core.c	2008-03-31 17:05:32.000000000 -0600
@@ -109,6 +109,31 @@
 	kfree(dev);
 }
 
+struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *protocol, int id, char *pnpid)
+{
+	struct pnp_dev *dev;
+	struct pnp_id *dev_id;
+
+	dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	dev->protocol = protocol;
+	dev->number = id;
+
+	dev->dev.parent = &dev->protocol->dev;
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
 int __pnp_add_device(struct pnp_dev *dev)
 {
 	int ret;
@@ -145,9 +170,6 @@
 	if (dev->card)
 		return -EINVAL;
 
-	dev->dev.parent = &dev->protocol->dev;
-	sprintf(dev->dev.bus_id, "%02x:%02x", dev->protocol->number,
-		dev->number);
 	ret = __pnp_add_device(dev);
 	if (ret)
 		return ret;
Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-31 17:04:02.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-31 17:07:12.000000000 -0600
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
Index: work7/drivers/pnp/pnpacpi/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/core.c	2008-03-31 17:02:52.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/core.c	2008-03-31 17:05:32.000000000 -0600
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
Index: work7/drivers/pnp/pnpbios/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/core.c	2008-03-31 17:02:52.000000000 -0600
+++ work7/drivers/pnp/pnpbios/core.c	2008-03-31 17:05:32.000000000 -0600
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
 	pnp_eisa_id_to_string(node->eisa_id, id);
-	dev_id = pnp_add_id(dev, id);
-	if (!dev_id) {
-		kfree(dev);
-		return -1;
-	}
+	dev = pnp_alloc_dev(&pnpbios_protocol, node->handle, id);
+	if (!dev)
+		return -ENOMEM;
 
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S936901AbXHHBXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936901AbXHHBXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934460AbXHHBVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:21:04 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59258 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570AbXHHBVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:21:01 -0400
Date: Tue, 07 Aug 2007 18:23:25 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 3/5] try parent numa_node at first before using default v2
In-reply-to: <200708072246.l77Mk2Qw008754@imap1.linux-foundation.org>
To: akpm@linux-foundation.org, ak@suse.de
Cc: apw@shadowen.org, clameter@sgi.com, greg@kroah.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200708071823.26120.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200708072246.l77Mk2Qw008754@imap1.linux-foundation.org>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 3/5] try parent numa_node at first before using default v2

in the device_add, we try to use use parent numa_node.
need to make sure pci root bus's bridge device numa_node is set.
then we could use device->numa_node direclty for all device.
and don't need to call pcibus_to_node().

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e48fcf0..c029ffc 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -935,7 +938,6 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	dev->dev.release = pci_release_dev;
 	pci_dev_get(dev);
 
-	set_dev_node(&dev->dev, pcibus_to_node(bus));
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.coherent_dma_mask = 0xffffffffull;
 
@@ -1096,6 +1098,9 @@ struct pci_bus * pci_create_bus(struct device *parent,
 		goto dev_reg_err;
 	b->bridge = get_device(dev);
 
+	if (!parent)
+		set_dev_node(b->bridge, pcibus_to_node(b));
+
 	b->class_dev.class = &pcibus_class;
 	sprintf(b->class_dev.class_id, "%04x:%02x", pci_domain_nr(b), bus);
 	error = class_device_register(&b->class_dev);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 0455aa7..d8b063b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -672,6 +672,11 @@ int device_add(struct device *dev)
 	if (error)
 		goto Error;
 
+	/* use parent numa_node */
+	if (parent) {
+		set_dev_node(dev, dev_to_node(parent));
+	}
+
 	/* first, register with generic layer. */
 	kobject_set_name(&dev->kobj, "%s", dev->bus_id);
 	error = kobject_add(&dev->kobj);
@@ -1269,8 +1274,11 @@ int device_move(struct device *dev, struct device *new_parent)
 	dev->parent = new_parent;
 	if (old_parent)
 		klist_remove(&dev->knode_parent);
-	if (new_parent)
+	if (new_parent) {
 		klist_add_tail(&dev->knode_parent, &new_parent->klist_children);
+		set_dev_node(dev, dev_to_node(new_parent));
+	}
+
 	if (!dev->class)
 		goto out_put;
 	error = device_move_class_links(dev, old_parent, new_parent);
@@ -1280,9 +1288,12 @@ int device_move(struct device *dev, struct device *new_parent)
 		if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
 			if (new_parent)
 				klist_remove(&dev->knode_parent);
-			if (old_parent)
+			dev->parent = old_parent;
+			if (old_parent) {
 				klist_add_tail(&dev->knode_parent,
 					       &old_parent->klist_children);
+				set_dev_node(dev, dev_to_node(old_parent));
+			}
 		}
 		put_device(new_parent);
 		goto out;
-

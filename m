Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbYBSLP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbYBSLP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbYBSLNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:13:38 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37002 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232AbYBSLNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:13:32 -0500
Date: Tue, 19 Feb 2008 03:20:41 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 5/8] try parent numa_node at first before using default v2
In-reply-to: <200802190311.44404.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802190320.41210.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802190311.44404.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in the device_add, we try to use use parent numa_node.
need to make sure pci root bus's bridge device numa_node is set.
then we could use device->numa_node direclty for all device.
and don't need to call pcibus_to_node().

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -964,7 +964,6 @@ void pci_device_add(struct pci_dev *dev,
 	dev->dev.release = pci_release_dev;
 	pci_dev_get(dev);
 
-	set_dev_node(&dev->dev, pcibus_to_node(bus));
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.dma_parms = &dev->dma_parms;
 	dev->dev.coherent_dma_mask = 0xffffffffull;
@@ -1116,6 +1115,9 @@ struct pci_bus * pci_create_bus(struct d
 		goto dev_reg_err;
 	b->bridge = get_device(dev);
 
+	if (!parent)
+		set_dev_node(b->bridge, pcibus_to_node(b));
+
 	b->dev.class = &pcibus_class;
 	b->dev.parent = b->bridge;
 	sprintf(b->dev.bus_id, "%04x:%02x", pci_domain_nr(b), bus);
Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -788,6 +788,10 @@ int device_add(struct device *dev)
 	parent = get_device(dev->parent);
 	setup_parent(dev, parent);
 
+	/* use parent numa_node */
+	if (parent)
+		set_dev_node(dev, dev_to_node(parent));
+
 	/* first, register with generic layer. */
 	error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev->bus_id);
 	if (error)
@@ -1339,8 +1343,11 @@ int device_move(struct device *dev, stru
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
@@ -1350,9 +1357,12 @@ int device_move(struct device *dev, stru
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
 		cleanup_glue_dir(dev, new_parent_kobj);
 		put_device(new_parent);

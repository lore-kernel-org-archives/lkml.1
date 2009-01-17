Return-Path: <linux-kernel-owner+w=401wt.eu-S1765769AbZAQVrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765769AbZAQVrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZAQVrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:47:33 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44660 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZAQVrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:47:31 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 17 Jan 2009 22:47:28 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/4] firewire: core: move some functions
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ca8b7763ca31e24d@s5r6.in-berlin.de>
Message-ID: <tkrat.6745ce2e35d4198e@s5r6.in-berlin.de>
References: <tkrat.ca8b7763ca31e24d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |   90 +++++++++++++++++------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -155,27 +155,6 @@ struct bus_type fw_bus_type = {
 };
 EXPORT_SYMBOL(fw_bus_type);
 
-static void fw_device_release(struct device *dev)
-{
-	struct fw_device *device = fw_device(dev);
-	struct fw_card *card = device->card;
-	unsigned long flags;
-
-	/*
-	 * Take the card lock so we don't set this to NULL while a
-	 * FW_NODE_UPDATED callback is being handled or while the
-	 * bus manager work looks at this node.
-	 */
-	spin_lock_irqsave(&card->lock, flags);
-	device->node->data = NULL;
-	spin_unlock_irqrestore(&card->lock, flags);
-
-	fw_node_put(device->node);
-	kfree(device->config_rom);
-	kfree(device);
-	fw_card_put(card);
-}
-
 int fw_device_enable_phys_dma(struct fw_device *device)
 {
 	int generation = device->generation;
@@ -678,11 +657,53 @@ static void fw_device_shutdown(struct wo
 	fw_device_put(device);
 }
 
+static void fw_device_release(struct device *dev)
+{
+	struct fw_device *device = fw_device(dev);
+	struct fw_card *card = device->card;
+	unsigned long flags;
+
+	/*
+	 * Take the card lock so we don't set this to NULL while a
+	 * FW_NODE_UPDATED callback is being handled or while the
+	 * bus manager work looks at this node.
+	 */
+	spin_lock_irqsave(&card->lock, flags);
+	device->node->data = NULL;
+	spin_unlock_irqrestore(&card->lock, flags);
+
+	fw_node_put(device->node);
+	kfree(device->config_rom);
+	kfree(device);
+	fw_card_put(card);
+}
+
 static struct device_type fw_device_type = {
-	.release	= fw_device_release,
+	.release = fw_device_release,
 };
 
-static void fw_device_update(struct work_struct *work);
+static int update_unit(struct device *dev, void *data)
+{
+	struct fw_unit *unit = fw_unit(dev);
+	struct fw_driver *driver = (struct fw_driver *)dev->driver;
+
+	if (is_fw_unit(dev) && driver != NULL && driver->update != NULL) {
+		down(&dev->sem);
+		driver->update(unit);
+		up(&dev->sem);
+	}
+
+	return 0;
+}
+
+static void fw_device_update(struct work_struct *work)
+{
+	struct fw_device *device =
+		container_of(work, struct fw_device, work.work);
+
+	fw_device_cdev_update(device);
+	device_for_each_child(&device->device, NULL, update_unit);
+}
 
 /*
  * If a device was pending for deletion because its node went away but its
@@ -850,29 +871,6 @@ static void fw_device_init(struct work_s
 	put_device(&device->device);	/* our reference */
 }
 
-static int update_unit(struct device *dev, void *data)
-{
-	struct fw_unit *unit = fw_unit(dev);
-	struct fw_driver *driver = (struct fw_driver *)dev->driver;
-
-	if (is_fw_unit(dev) && driver != NULL && driver->update != NULL) {
-		down(&dev->sem);
-		driver->update(unit);
-		up(&dev->sem);
-	}
-
-	return 0;
-}
-
-static void fw_device_update(struct work_struct *work)
-{
-	struct fw_device *device =
-		container_of(work, struct fw_device, work.work);
-
-	fw_device_cdev_update(device);
-	device_for_each_child(&device->device, NULL, update_unit);
-}
-
 enum {
 	REREAD_BIB_ERROR,
 	REREAD_BIB_GONE,

-- 
Stefan Richter
-=====-==--= ---= =---=
http://arcgraph.de/sr/


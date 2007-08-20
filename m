Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbXHTW4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbXHTW4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761358AbXHTWxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:53:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:53975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbXHTWxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:53:12 -0400
Message-Id: <20070820225136.212150000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:18 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: oakad@yahoo.com, kay.sievers@vrfy.org
Subject: [patch 12/14] Convert from class_device to device for TI flash media
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=misc.patch

Convert from class_device to device for drivers/misc/tifm.  This is
part of the work to eliminate struct class_device.

---
 drivers/misc/tifm_7xx1.c |    4 ++--
 drivers/misc/tifm_core.c |   24 ++++++++++++------------
 include/linux/tifm.h     |    2 +-
 3 files changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/misc/tifm_core.c
+++ b/drivers/misc/tifm_core.c
@@ -165,16 +165,16 @@ static struct bus_type tifm_bus_type = {
 	.resume    = tifm_device_resume
 };
 
-static void tifm_free(struct class_device *cdev)
+static void tifm_free(struct device *dev)
 {
-	struct tifm_adapter *fm = container_of(cdev, struct tifm_adapter, cdev);
+	struct tifm_adapter *fm = container_of(dev, struct tifm_adapter, dev);
 
 	kfree(fm);
 }
 
 static struct class tifm_adapter_class = {
 	.name    = "tifm_adapter",
-	.release = tifm_free
+	.dev_release = tifm_free
 };
 
 struct tifm_adapter *tifm_alloc_adapter(unsigned int num_sockets,
@@ -185,9 +185,9 @@ struct tifm_adapter *tifm_alloc_adapter(
 	fm = kzalloc(sizeof(struct tifm_adapter)
 		     + sizeof(struct tifm_dev*) * num_sockets, GFP_KERNEL);
 	if (fm) {
-		fm->cdev.class = &tifm_adapter_class;
-		fm->cdev.dev = dev;
-		class_device_initialize(&fm->cdev);
+		fm->dev.class = &tifm_adapter_class;
+		fm->dev.parent = dev;
+		device_initialize(&fm->dev);
 		spin_lock_init(&fm->lock);
 		fm->num_sockets = num_sockets;
 	}
@@ -208,8 +208,8 @@ int tifm_add_adapter(struct tifm_adapter
 	if (rc)
 		return rc;
 
-	snprintf(fm->cdev.class_id, BUS_ID_SIZE, "tifm%u", fm->id);
-	rc = class_device_add(&fm->cdev);
+	snprintf(fm->dev.bus_id, BUS_ID_SIZE, "tifm%u", fm->id);
+	rc = device_add(&fm->dev);
 	if (rc) {
 		spin_lock(&tifm_adapter_lock);
 		idr_remove(&tifm_adapter_idr, fm->id);
@@ -233,13 +233,13 @@ void tifm_remove_adapter(struct tifm_ada
 	spin_lock(&tifm_adapter_lock);
 	idr_remove(&tifm_adapter_idr, fm->id);
 	spin_unlock(&tifm_adapter_lock);
-	class_device_del(&fm->cdev);
+	device_del(&fm->dev);
 }
 EXPORT_SYMBOL(tifm_remove_adapter);
 
 void tifm_free_adapter(struct tifm_adapter *fm)
 {
-	class_device_put(&fm->cdev);
+	put_device(&fm->dev);
 }
 EXPORT_SYMBOL(tifm_free_adapter);
 
@@ -266,9 +266,9 @@ struct tifm_dev *tifm_alloc_device(struc
 		sock->card_event = tifm_dummy_event;
 		sock->data_event = tifm_dummy_event;
 
-		sock->dev.parent = fm->cdev.dev;
+		sock->dev.parent = fm->dev.parent;
 		sock->dev.bus = &tifm_bus_type;
-		sock->dev.dma_mask = fm->cdev.dev->dma_mask;
+		sock->dev.dma_mask = fm->dev.parent->dma_mask;
 		sock->dev.release = tifm_free_device;
 
 		snprintf(sock->dev.bus_id, BUS_ID_SIZE,
--- a/include/linux/tifm.h
+++ b/include/linux/tifm.h
@@ -120,7 +120,7 @@ struct tifm_adapter {
 	struct completion   *finish_me;
 
 	struct work_struct  media_switcher;
-	struct class_device cdev;
+	struct device	    dev;
 
 	void                (*eject)(struct tifm_adapter *fm,
 				     struct tifm_dev *sock);
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -149,7 +149,7 @@ static void tifm_7xx1_switch_media(struc
 	socket_change_set = fm->socket_change_set;
 	fm->socket_change_set = 0;
 
-	dev_dbg(fm->cdev.dev, "checking media set %x\n",
+	dev_dbg(fm->dev.parent, "checking media set %x\n",
 		socket_change_set);
 
 	if (!socket_change_set) {
@@ -164,7 +164,7 @@ static void tifm_7xx1_switch_media(struc
 		if (sock) {
 			printk(KERN_INFO
 			       "%s : demand removing card from socket %u:%u\n",
-			       fm->cdev.class_id, fm->id, cnt);
+			       fm->dev.bus_id, fm->id, cnt);
 			fm->sockets[cnt] = NULL;
 			sock_addr = sock->addr;
 			spin_unlock_irqrestore(&fm->lock, flags);

-- 

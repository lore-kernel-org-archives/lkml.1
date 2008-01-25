Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbYAYHXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbYAYHXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbYAYHPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:38 -0500
Received: from mail.suse.de ([195.135.220.2]:52538 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbYAYHPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:36 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tony Jones <tonyj@suse.de>, Alex Dubov <oakad@yahoo.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 027/196] tifm: Convert from class_device to device for TI flash media
Date: Thu, 24 Jan 2008 23:09:25 -0800
Message-Id: <1201245134-4876-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/tifm_7xx1.c |    4 ++--
 drivers/misc/tifm_core.c |   24 ++++++++++++------------
 include/linux/tifm.h     |    2 +-
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index 2d1b3df..54380da 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -149,7 +149,7 @@ static void tifm_7xx1_switch_media(struct work_struct *work)
 	socket_change_set = fm->socket_change_set;
 	fm->socket_change_set = 0;
 
-	dev_dbg(fm->cdev.dev, "checking media set %x\n",
+	dev_dbg(fm->dev.parent, "checking media set %x\n",
 		socket_change_set);
 
 	if (!socket_change_set) {
@@ -164,7 +164,7 @@ static void tifm_7xx1_switch_media(struct work_struct *work)
 		if (sock) {
 			printk(KERN_INFO
 			       "%s : demand removing card from socket %u:%u\n",
-			       fm->cdev.class_id, fm->id, cnt);
+			       fm->dev.bus_id, fm->id, cnt);
 			fm->sockets[cnt] = NULL;
 			sock_addr = sock->addr;
 			spin_unlock_irqrestore(&fm->lock, flags);
diff --git a/drivers/misc/tifm_core.c b/drivers/misc/tifm_core.c
index 8f77949..9754405 100644
--- a/drivers/misc/tifm_core.c
+++ b/drivers/misc/tifm_core.c
@@ -160,16 +160,16 @@ static struct bus_type tifm_bus_type = {
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
@@ -180,9 +180,9 @@ struct tifm_adapter *tifm_alloc_adapter(unsigned int num_sockets,
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
@@ -203,8 +203,8 @@ int tifm_add_adapter(struct tifm_adapter *fm)
 	if (rc)
 		return rc;
 
-	snprintf(fm->cdev.class_id, BUS_ID_SIZE, "tifm%u", fm->id);
-	rc = class_device_add(&fm->cdev);
+	snprintf(fm->dev.bus_id, BUS_ID_SIZE, "tifm%u", fm->id);
+	rc = device_add(&fm->dev);
 	if (rc) {
 		spin_lock(&tifm_adapter_lock);
 		idr_remove(&tifm_adapter_idr, fm->id);
@@ -228,13 +228,13 @@ void tifm_remove_adapter(struct tifm_adapter *fm)
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
 
@@ -261,9 +261,9 @@ struct tifm_dev *tifm_alloc_device(struct tifm_adapter *fm, unsigned int id,
 		sock->card_event = tifm_dummy_event;
 		sock->data_event = tifm_dummy_event;
 
-		sock->dev.parent = fm->cdev.dev;
+		sock->dev.parent = fm->dev.parent;
 		sock->dev.bus = &tifm_bus_type;
-		sock->dev.dma_mask = fm->cdev.dev->dma_mask;
+		sock->dev.dma_mask = fm->dev.parent->dma_mask;
 		sock->dev.release = tifm_free_device;
 
 		snprintf(sock->dev.bus_id, BUS_ID_SIZE,
diff --git a/include/linux/tifm.h b/include/linux/tifm.h
index 6b3a318..2096b76 100644
--- a/include/linux/tifm.h
+++ b/include/linux/tifm.h
@@ -120,7 +120,7 @@ struct tifm_adapter {
 	struct completion   *finish_me;
 
 	struct work_struct  media_switcher;
-	struct class_device cdev;
+	struct device	    dev;
 
 	void                (*eject)(struct tifm_adapter *fm,
 				     struct tifm_dev *sock);
-- 
1.5.3.8


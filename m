Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbYDTKv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbYDTKv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758347AbYDTKlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:41:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56373 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760092AbYDTKlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:41:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tony Jones <tonyj@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 32/36] memstick: convert struct class_device to struct device
Date: Sun, 20 Apr 2008 03:46:02 -0700
Message-Id: <1208688366-9252-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct class_device is going away, struct device should be used instead.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/memstick/core/memstick.c    |   33 ++++++++++++++++-----------------
 drivers/memstick/core/mspro_block.c |    4 ++--
 drivers/memstick/host/jmb38x_ms.c   |   16 ++++++++--------
 include/linux/memstick.h            |    2 +-
 4 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 946e3d3..61b98c3 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -177,16 +177,16 @@ static struct bus_type memstick_bus_type = {
 	.resume         = memstick_device_resume
 };
 
-static void memstick_free(struct class_device *cdev)
+static void memstick_free(struct device *dev)
 {
-	struct memstick_host *host = container_of(cdev, struct memstick_host,
-						  cdev);
+	struct memstick_host *host = container_of(dev, struct memstick_host,
+						  dev);
 	kfree(host);
 }
 
 static struct class memstick_host_class = {
 	.name       = "memstick_host",
-	.release    = memstick_free
+	.dev_release = memstick_free
 };
 
 static void memstick_free_card(struct device *dev)
@@ -383,8 +383,8 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 	if (card) {
 		card->host = host;
 		snprintf(card->dev.bus_id, sizeof(card->dev.bus_id),
-			 "%s", host->cdev.class_id);
-		card->dev.parent = host->cdev.dev;
+			 "%s", host->dev.bus_id);
+		card->dev.parent = &host->dev;
 		card->dev.bus = &memstick_bus_type;
 		card->dev.release = memstick_free_card;
 		card->check = memstick_dummy_check;
@@ -427,7 +427,7 @@ static void memstick_check(struct work_struct *work)
 						  media_checker);
 	struct memstick_dev *card;
 
-	dev_dbg(host->cdev.dev, "memstick_check started\n");
+	dev_dbg(&host->dev, "memstick_check started\n");
 	mutex_lock(&host->lock);
 	if (!host->card)
 		memstick_power_on(host);
@@ -440,7 +440,7 @@ static void memstick_check(struct work_struct *work)
 			host->card = NULL;
 		}
 	} else {
-		dev_dbg(host->cdev.dev, "new card %02x, %02x, %02x\n",
+		dev_dbg(&host->dev, "new card %02x, %02x, %02x\n",
 			card->id.type, card->id.category, card->id.class);
 		if (host->card) {
 			if (memstick_set_rw_addr(host->card)
@@ -465,7 +465,7 @@ static void memstick_check(struct work_struct *work)
 		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
 
 	mutex_unlock(&host->lock);
-	dev_dbg(host->cdev.dev, "memstick_check finished\n");
+	dev_dbg(&host->dev, "memstick_check finished\n");
 }
 
 /**
@@ -482,9 +482,9 @@ struct memstick_host *memstick_alloc_host(unsigned int extra,
 	if (host) {
 		mutex_init(&host->lock);
 		INIT_WORK(&host->media_checker, memstick_check);
-		host->cdev.class = &memstick_host_class;
-		host->cdev.dev = dev;
-		class_device_initialize(&host->cdev);
+		host->dev.class = &memstick_host_class;
+		host->dev.parent = dev;
+		device_initialize(&host->dev);
 	}
 	return host;
 }
@@ -507,10 +507,9 @@ int memstick_add_host(struct memstick_host *host)
 	if (rc)
 		return rc;
 
-	snprintf(host->cdev.class_id, BUS_ID_SIZE,
-		 "memstick%u", host->id);
+	snprintf(host->dev.bus_id, BUS_ID_SIZE, "memstick%u", host->id);
 
-	rc = class_device_add(&host->cdev);
+	rc = device_add(&host->dev);
 	if (rc) {
 		spin_lock(&memstick_host_lock);
 		idr_remove(&memstick_host_idr, host->id);
@@ -541,7 +540,7 @@ void memstick_remove_host(struct memstick_host *host)
 	spin_lock(&memstick_host_lock);
 	idr_remove(&memstick_host_idr, host->id);
 	spin_unlock(&memstick_host_lock);
-	class_device_del(&host->cdev);
+	device_del(&host->dev);
 }
 EXPORT_SYMBOL(memstick_remove_host);
 
@@ -552,7 +551,7 @@ EXPORT_SYMBOL(memstick_remove_host);
 void memstick_free_host(struct memstick_host *host)
 {
 	mutex_destroy(&host->lock);
-	class_device_put(&host->cdev);
+	put_device(&host->dev);
 }
 EXPORT_SYMBOL(memstick_free_host);
 
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 557dbbb..477d0fb 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1127,8 +1127,8 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	u64 limit = BLK_BOUNCE_HIGH;
 	unsigned long capacity;
 
-	if (host->cdev.dev->dma_mask && *(host->cdev.dev->dma_mask))
-		limit = *(host->cdev.dev->dma_mask);
+	if (host->dev.dma_mask && *(host->dev.dma_mask))
+		limit = *(host->dev.dma_mask);
 
 	for (rc = 0; msb->attr_group.attrs[rc]; ++rc) {
 		s_attr = mspro_from_sysfs_attr(msb->attr_group.attrs[rc]);
diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 8770a5f..a054668 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -361,15 +361,15 @@ static int jmb38x_ms_issue_cmd(struct memstick_host *msh)
 	unsigned int data_len, cmd, t_val;
 
 	if (!(STATUS_HAS_MEDIA & readl(host->addr + STATUS))) {
-		dev_dbg(msh->cdev.dev, "no media status\n");
+		dev_dbg(&msh->dev, "no media status\n");
 		host->req->error = -ETIME;
 		return host->req->error;
 	}
 
-	dev_dbg(msh->cdev.dev, "control %08x\n",
+	dev_dbg(&msh->dev, "control %08x\n",
 		readl(host->addr + HOST_CONTROL));
-	dev_dbg(msh->cdev.dev, "status %08x\n", readl(host->addr + INT_STATUS));
-	dev_dbg(msh->cdev.dev, "hstatus %08x\n", readl(host->addr + STATUS));
+	dev_dbg(&msh->dev, "status %08x\n", readl(host->addr + INT_STATUS));
+	dev_dbg(&msh->dev, "hstatus %08x\n", readl(host->addr + STATUS));
 
 	host->cmd_flags = 0;
 	host->block_pos = 0;
@@ -448,7 +448,7 @@ static int jmb38x_ms_issue_cmd(struct memstick_host *msh)
 	host->req->error = 0;
 
 	writel(cmd, host->addr + TPC);
-	dev_dbg(msh->cdev.dev, "executing TPC %08x, len %x\n", cmd, data_len);
+	dev_dbg(&msh->dev, "executing TPC %08x, len %x\n", cmd, data_len);
 
 	return 0;
 }
@@ -461,11 +461,11 @@ static void jmb38x_ms_complete_cmd(struct memstick_host *msh, int last)
 
 	del_timer(&host->timer);
 
-	dev_dbg(msh->cdev.dev, "c control %08x\n",
+	dev_dbg(&msh->dev, "c control %08x\n",
 		readl(host->addr + HOST_CONTROL));
-	dev_dbg(msh->cdev.dev, "c status %08x\n",
+	dev_dbg(&msh->dev, "c status %08x\n",
 		readl(host->addr + INT_STATUS));
-	dev_dbg(msh->cdev.dev, "c hstatus %08x\n", readl(host->addr + STATUS));
+	dev_dbg(&msh->dev, "c hstatus %08x\n", readl(host->addr + STATUS));
 
 	host->req->int_reg = readl(host->addr + STATUS) & 0xff;
 
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 3e686ec..37a5cdb 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -276,7 +276,7 @@ struct memstick_host {
 #define MEMSTICK_CAP_PAR8          4
 
 	struct work_struct  media_checker;
-	struct class_device cdev;
+	struct device       dev;
 
 	struct memstick_dev *card;
 	unsigned int        retries;
-- 
1.5.4.5


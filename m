Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbYLDAu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbYLDAu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbYLDAqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:46:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:65357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757943AbYLDAqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:46:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,710,1220252400"; 
   d="scan'208";a="86212499"
Subject: [PATCH 2/4] dmaengine: use idr for registering dma device numbers
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Date: Wed, 03 Dec 2008 17:46:51 -0700
Message-ID: <20081204004651.27790.38167.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
References: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings some predictability to dma device numbers, i.e. an rmmod/insmod
cycle may now result in /sys/class/dma/dma0chan0 being restored rather than
/sys/class/dma/dma1chan0 appearing.

Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/dmaengine.c   |   26 ++++++++++++++++++++++++--
 include/linux/dmaengine.h |    4 ++++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index fead043..4b7ffb7 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -57,10 +57,12 @@
 #include <linux/mutex.h>
 #include <linux/jiffies.h>
 #include <linux/rculist.h>
+#include <linux/idr.h>
 
 static DEFINE_MUTEX(dma_list_mutex);
 static LIST_HEAD(dma_device_list);
 static long dmaengine_ref_count;
+static struct idr dma_idr;
 
 /* --- sysfs implementation --- */
 
@@ -147,6 +149,11 @@ static void chan_dev_release(struct device *dev)
 	struct dma_chan_dev *chan_dev;
 
 	chan_dev = container_of(dev, typeof(*chan_dev), device);
+	if (atomic_dec_and_test(chan_dev->idr_ref)) {
+		mutex_lock(&dma_list_mutex);
+		idr_remove(&dma_idr, chan_dev->dev_id);
+		mutex_unlock(&dma_list_mutex);
+	}
 	kfree(chan_dev);
 }
 
@@ -604,9 +611,9 @@ EXPORT_SYMBOL(dmaengine_put);
  */
 int dma_async_device_register(struct dma_device *device)
 {
-	static int id;
 	int chancnt = 0, rc;
 	struct dma_chan* chan;
+	atomic_t *idr_ref;
 
 	if (!device)
 		return -ENODEV;
@@ -633,9 +640,20 @@ int dma_async_device_register(struct dma_device *device)
 	BUG_ON(!device->device_issue_pending);
 	BUG_ON(!device->dev);
 
+	idr_ref = kmalloc(sizeof(*idr_ref), GFP_KERNEL);
+	if (!idr_ref)
+		return -ENOMEM;
+	atomic_set(idr_ref, 0);
+ idr_retry:
+	if (!idr_pre_get(&dma_idr, GFP_KERNEL))
+		return -ENOMEM;
 	mutex_lock(&dma_list_mutex);
-	device->dev_id = id++;
+	rc = idr_get_new(&dma_idr, NULL, &device->dev_id);
 	mutex_unlock(&dma_list_mutex);
+	if (rc == -EAGAIN)
+		goto idr_retry;
+	else if (rc != 0)
+		return rc;
 
 	/* represent channels in sysfs. Probably want devs too */
 	list_for_each_entry(chan, &device->channels, device_node) {
@@ -652,6 +670,9 @@ int dma_async_device_register(struct dma_device *device)
 		chan->dev->device.class = &dma_devclass;
 		chan->dev->device.parent = device->dev;
 		chan->dev->chan = chan;
+		chan->dev->idr_ref = idr_ref;
+		chan->dev->dev_id = device->dev_id;
+		atomic_inc(idr_ref);
 		dev_set_name(&chan->dev->device, "dma%dchan%d",
 			     device->dev_id, chan->chan_id);
 
@@ -964,6 +985,7 @@ EXPORT_SYMBOL_GPL(dma_run_dependencies);
 
 static int __init dma_bus_init(void)
 {
+	idr_init(&dma_idr);
 	mutex_init(&dma_list_mutex);
 	return class_register(&dma_devclass);
 }
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d6b6bff..64dea2a 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -140,10 +140,14 @@ struct dma_chan {
  * struct dma_chan_dev - relate sysfs device node to backing channel device
  * @chan - driver channel device
  * @device - sysfs device
+ * @dev_id - parent dma_device dev_id
+ * @idr_ref - reference count to gate release of dma_device dev_id
  */
 struct dma_chan_dev {
 	struct dma_chan *chan;
 	struct device device;
+	int dev_id;
+	atomic_t *idr_ref;
 };
 
 static inline const char *dma_chan_name(struct dma_chan *chan)


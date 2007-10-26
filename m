Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbXJ0GdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbXJ0GdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 02:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbXJ0Gcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 02:32:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:57192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbXJ0Gcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 02:32:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,336,1188802800"; 
   d="scan'208";a="306437330"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH] DMAENGINE: Convert from class_device to device
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: shannon.nelson@intel.com, greg@kroah.com, kay.sievers@vrfy.org,
       tonyj@suse.de, dan.j.williams@intel.com
Date: Fri, 26 Oct 2007 16:53:43 -0700
Message-ID: <20071026235343.5672.88225.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

Convert from class_device to device for drivers/dma/dmaengine.  This is
part of the work to eliminate struct class_device.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---

 drivers/dma/dmaengine.c   |   46 ++++++++++++++++++++++++---------------------
 include/linux/dmaengine.h |    3 ++-
 2 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 8248992..84257f7 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -41,12 +41,12 @@
  * the definition of dma_event_callback in dmaengine.h.
  *
  * Each device has a kref, which is initialized to 1 when the device is
- * registered. A kref_get is done for each class_device registered.  When the
- * class_device is released, the coresponding kref_put is done in the release
+ * registered. A kref_get is done for each device registered.  When the
+ * device is released, the coresponding kref_put is done in the release
  * method. Every time one of the device's channels is allocated to a client,
  * a kref_get occurs.  When the channel is freed, the coresponding kref_put
  * happens. The device's release function does a completion, so
- * unregister_device does a remove event, class_device_unregister, a kref_put
+ * unregister_device does a remove event, device_unregister, a kref_put
  * for the first reference, then waits on the completion for all other
  * references to finish.
  *
@@ -77,9 +77,10 @@ static LIST_HEAD(dma_client_list);
 
 /* --- sysfs implementation --- */
 
-static ssize_t show_memcpy_count(struct class_device *cd, char *buf)
+static ssize_t
+show_memcpy_count(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct dma_chan *chan = container_of(cd, struct dma_chan, class_dev);
+	struct dma_chan *chan = to_dma_chan(dev);
 	unsigned long count = 0;
 	int i;
 
@@ -89,9 +90,11 @@ static ssize_t show_memcpy_count(struct class_device *cd, char *buf)
 	return sprintf(buf, "%lu\n", count);
 }
 
-static ssize_t show_bytes_transferred(struct class_device *cd, char *buf)
+static ssize_t
+show_bytes_transferred(struct device *dev, struct device_attribute *attr,
+		       char *buf)
 {
-	struct dma_chan *chan = container_of(cd, struct dma_chan, class_dev);
+	struct dma_chan *chan = to_dma_chan(dev);
 	unsigned long count = 0;
 	int i;
 
@@ -101,9 +104,10 @@ static ssize_t show_bytes_transferred(struct class_device *cd, char *buf)
 	return sprintf(buf, "%lu\n", count);
 }
 
-static ssize_t show_in_use(struct class_device *cd, char *buf)
+static ssize_t
+show_in_use(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct dma_chan *chan = container_of(cd, struct dma_chan, class_dev);
+	struct dma_chan *chan = to_dma_chan(dev);
 	int in_use = 0;
 
 	if (unlikely(chan->slow_ref) &&
@@ -119,7 +123,7 @@ static ssize_t show_in_use(struct class_device *cd, char *buf)
 	return sprintf(buf, "%d\n", in_use);
 }
 
-static struct class_device_attribute dma_class_attrs[] = {
+static struct device_attribute dma_attrs[] = {
 	__ATTR(memcpy_count, S_IRUGO, show_memcpy_count, NULL),
 	__ATTR(bytes_transferred, S_IRUGO, show_bytes_transferred, NULL),
 	__ATTR(in_use, S_IRUGO, show_in_use, NULL),
@@ -128,16 +132,16 @@ static struct class_device_attribute dma_class_attrs[] = {
 
 static void dma_async_device_cleanup(struct kref *kref);
 
-static void dma_class_dev_release(struct class_device *cd)
+static void dma_dev_release(struct device *dev)
 {
-	struct dma_chan *chan = container_of(cd, struct dma_chan, class_dev);
+	struct dma_chan *chan = to_dma_chan(dev);
 	kref_put(&chan->device->refcount, dma_async_device_cleanup);
 }
 
 static struct class dma_devclass = {
-	.name            = "dma",
-	.class_dev_attrs = dma_class_attrs,
-	.release = dma_class_dev_release,
+	.name		= "dma",
+	.dev_attrs	= dma_attrs,
+	.dev_release	= dma_dev_release,
 };
 
 /* --- client and device registration --- */
@@ -384,12 +388,12 @@ int dma_async_device_register(struct dma_device *device)
 			continue;
 
 		chan->chan_id = chancnt++;
-		chan->class_dev.class = &dma_devclass;
-		chan->class_dev.dev = NULL;
-		snprintf(chan->class_dev.class_id, BUS_ID_SIZE, "dma%dchan%d",
+		chan->dev.class = &dma_devclass;
+		chan->dev.parent = NULL;
+		snprintf(chan->dev.bus_id, BUS_ID_SIZE, "dma%dchan%d",
 		         device->dev_id, chan->chan_id);
 
-		rc = class_device_register(&chan->class_dev);
+		rc = device_register(&chan->dev);
 		if (rc) {
 			chancnt--;
 			free_percpu(chan->local);
@@ -416,7 +420,7 @@ err_out:
 		if (chan->local == NULL)
 			continue;
 		kref_put(&device->refcount, dma_async_device_cleanup);
-		class_device_unregister(&chan->class_dev);
+		device_unregister(&chan->dev);
 		chancnt--;
 		free_percpu(chan->local);
 	}
@@ -450,7 +454,7 @@ void dma_async_device_unregister(struct dma_device *device)
 
 	list_for_each_entry(chan, &device->channels, device_node) {
 		dma_clients_notify_removed(chan);
-		class_device_unregister(&chan->class_dev);
+		device_unregister(&chan->dev);
 		dma_chan_release(chan);
 	}
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index a3b6035..55c9a69 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -132,7 +132,7 @@ struct dma_chan {
 
 	/* sysfs */
 	int chan_id;
-	struct class_device class_dev;
+	struct device dev;
 
 	struct kref refcount;
 	int slow_ref;
@@ -142,6 +142,7 @@ struct dma_chan {
 	struct dma_chan_percpu *local;
 };
 
+#define to_dma_chan(p) container_of(p, struct dma_chan, dev)
 
 void dma_chan_cleanup(struct kref *kref);
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbYLDAwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbYLDAwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758091AbYLDArU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:47:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:17093 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087AbYLDArP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:47:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,710,1220252400"; 
   d="scan'208";a="470925222"
Subject: [PATCH 1/4] dmaengine: add a release for dma class devices and
	dependent infrastructure
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Alexander Beregalov <a.beregalov@gmail.com>
Date: Wed, 03 Dec 2008 17:46:46 -0700
Message-ID: <20081204004646.27790.70015.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
References: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resolves:
WARNING: at drivers/base/core.c:122 device_release+0x4d/0x52()
Device 'dma0chan0' does not have a release() function, it is broken and must be fixed.

The dma_chan_dev object is introduced to gear-match sysfs kobject and
dmaengine channel lifetimes.  When a channel is removed access to the
sysfs entries return -ENODEV until the kobject can be released.

The bulk of the change is updates to existing code to handle the extra
layer of indirection between a dma_chan and its struct device.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/dmaengine.c   |  108 +++++++++++++++++++++++++++++++++++----------
 drivers/dma/dmatest.c     |   14 +++---
 drivers/dma/dw_dmac.c     |   91 +++++++++++++++++++++-----------------
 drivers/dma/fsldma.c      |    2 -
 include/linux/dmaengine.h |   19 +++++++-
 5 files changed, 158 insertions(+), 76 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index dcf1a83..fead043 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -64,36 +64,75 @@ static long dmaengine_ref_count;
 
 /* --- sysfs implementation --- */
 
+/**
+ * dev_to_dma_chan - convert a device pointer to the its sysfs container object
+ * @dev - device node
+ *
+ * Must be called under dma_list_mutex
+ */
+static struct dma_chan *dev_to_dma_chan(struct device *dev)
+{
+	struct dma_chan_dev *chan_dev;
+
+	chan_dev = container_of(dev, typeof(*chan_dev), device);
+	return chan_dev->chan;
+}
+
 static ssize_t show_memcpy_count(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct dma_chan *chan = to_dma_chan(dev);
+	struct dma_chan *chan;
 	unsigned long count = 0;
 	int i;
+	int err;
 
-	for_each_possible_cpu(i)
-		count += per_cpu_ptr(chan->local, i)->memcpy_count;
+	mutex_lock(&dma_list_mutex);
+	chan = dev_to_dma_chan(dev);
+	if (chan) {
+		for_each_possible_cpu(i)
+			count += per_cpu_ptr(chan->local, i)->memcpy_count;
+		err = sprintf(buf, "%lu\n", count);
+	} else
+		err = -ENODEV;
+	mutex_unlock(&dma_list_mutex);
 
-	return sprintf(buf, "%lu\n", count);
+	return err;
 }
 
 static ssize_t show_bytes_transferred(struct device *dev, struct device_attribute *attr,
 				      char *buf)
 {
-	struct dma_chan *chan = to_dma_chan(dev);
+	struct dma_chan *chan;
 	unsigned long count = 0;
 	int i;
+	int err;
 
-	for_each_possible_cpu(i)
-		count += per_cpu_ptr(chan->local, i)->bytes_transferred;
+	mutex_lock(&dma_list_mutex);
+	chan = dev_to_dma_chan(dev);
+	if (chan) {
+		for_each_possible_cpu(i)
+			count += per_cpu_ptr(chan->local, i)->bytes_transferred;
+		err = sprintf(buf, "%lu\n", count);
+	} else
+		err = -ENODEV;
+	mutex_unlock(&dma_list_mutex);
 
-	return sprintf(buf, "%lu\n", count);
+	return err;
 }
 
 static ssize_t show_in_use(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct dma_chan *chan = to_dma_chan(dev);
+	struct dma_chan *chan;
+	int err;
 
-	return sprintf(buf, "%d\n", chan->client_count);
+	mutex_lock(&dma_list_mutex);
+	chan = dev_to_dma_chan(dev);
+	if (chan)
+		err = sprintf(buf, "%d\n", chan->client_count);
+	else
+		err = -ENODEV;
+	mutex_unlock(&dma_list_mutex);
+
+	return err;
 }
 
 static struct device_attribute dma_attrs[] = {
@@ -103,9 +142,18 @@ static struct device_attribute dma_attrs[] = {
 	__ATTR_NULL
 };
 
+static void chan_dev_release(struct device *dev)
+{
+	struct dma_chan_dev *chan_dev;
+
+	chan_dev = container_of(dev, typeof(*chan_dev), device);
+	kfree(chan_dev);
+}
+
 static struct class dma_devclass = {
 	.name		= "dma",
 	.dev_attrs	= dma_attrs,
+	.dev_release	= chan_dev_release,
 };
 
 /* --- client and device registration --- */
@@ -415,12 +463,12 @@ static struct dma_chan *private_candidate(dma_cap_mask_t *mask, struct dma_devic
 	list_for_each_entry(chan, &dev->channels, device_node) {
 		if (!__dma_chan_satisfies_mask(chan, mask)) {
 			pr_debug("%s: %s wrong capabilities\n",
-				 __func__, dev_name(&chan->dev));
+				 __func__, dma_chan_name(chan));
 			continue;
 		}
 		if (chan->client_count) {
 			pr_debug("%s: %s busy\n",
-				 __func__, dev_name(&chan->dev));
+				 __func__, dma_chan_name(chan));
 			continue;
 		}
 		ret = chan;
@@ -466,22 +514,22 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 
 			if (err == -ENODEV) {
 				pr_debug("%s: %s module removed\n", __func__,
-					 dev_name(&chan->dev));
+					 dma_chan_name(chan));
 				list_del_rcu(&device->global_node);
 			} else if (err)
 				pr_err("dmaengine: failed to get %s: (%d)",
-				       dev_name(&chan->dev), err);
+				       dma_chan_name(chan), err);
 			else
 				break;
 		} else
 			pr_debug("%s: %s filter said false\n",
-				 __func__, dev_name(&chan->dev));
+				 __func__, dma_chan_name(chan));
 		chan = NULL;
 	}
 	mutex_unlock(&dma_list_mutex);
 
 	pr_debug("%s: %s (%s)\n", __func__, chan ? "success" : "fail",
-		 chan ? dev_name(&chan->dev) : NULL);
+		 chan ? dma_chan_name(chan) : NULL);
 
 	return chan;
 }
@@ -521,7 +569,7 @@ void dmaengine_get(void)
 				break;
 			} else if (err)
 				pr_err("dmaengine: failed to get %s: (%d)",
-				       dev_name(&chan->dev), err);
+				       dma_chan_name(chan), err);
 		}
 	}
 	mutex_unlock(&dma_list_mutex);
@@ -594,14 +642,20 @@ int dma_async_device_register(struct dma_device *device)
 		chan->local = alloc_percpu(typeof(*chan->local));
 		if (chan->local == NULL)
 			continue;
+		chan->dev = kzalloc(sizeof(*chan->dev), GFP_KERNEL);
+		if (chan->dev == NULL) {
+			free_percpu(chan->local);
+			continue;
+		}
 
 		chan->chan_id = chancnt++;
-		chan->dev.class = &dma_devclass;
-		chan->dev.parent = device->dev;
-		dev_set_name(&chan->dev, "dma%dchan%d",
+		chan->dev->device.class = &dma_devclass;
+		chan->dev->device.parent = device->dev;
+		chan->dev->chan = chan;
+		dev_set_name(&chan->dev->device, "dma%dchan%d",
 			     device->dev_id, chan->chan_id);
 
-		rc = device_register(&chan->dev);
+		rc = device_register(&chan->dev->device);
 		if (rc) {
 			free_percpu(chan->local);
 			chan->local = NULL;
@@ -638,7 +692,10 @@ err_out:
 	list_for_each_entry(chan, &device->channels, device_node) {
 		if (chan->local == NULL)
 			continue;
-		device_unregister(&chan->dev);
+		mutex_lock(&dma_list_mutex);
+		chan->dev->chan = NULL;
+		mutex_unlock(&dma_list_mutex);
+		device_unregister(&chan->dev->device);
 		free_percpu(chan->local);
 	}
 	return rc;
@@ -665,7 +722,10 @@ void dma_async_device_unregister(struct dma_device *device)
 		WARN_ONCE(chan->client_count,
 			  "%s called while %d clients hold a reference\n",
 			  __func__, chan->client_count);
-		device_unregister(&chan->dev);
+		mutex_lock(&dma_list_mutex);
+		chan->dev->chan = NULL;
+		mutex_unlock(&dma_list_mutex);
+		device_unregister(&chan->dev->device);
 	}
 }
 EXPORT_SYMBOL(dma_async_device_unregister);
@@ -838,7 +898,7 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 		return DMA_SUCCESS;
 
 	WARN_ONCE(tx->parent, "%s: speculatively walking dependency chain for"
-		  " %s\n", __func__, dev_name(&tx->chan->dev));
+		  " %s\n", __func__, dma_chan_name(tx->chan));
 
 	/* poll through the dependency chain, return when tx is complete */
 	do {
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index c77d47c..3603f1e 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -80,7 +80,7 @@ static bool dmatest_match_channel(struct dma_chan *chan)
 {
 	if (test_channel[0] == '\0')
 		return true;
-	return strcmp(dev_name(&chan->dev), test_channel) == 0;
+	return strcmp(dma_chan_name(chan), test_channel) == 0;
 }
 
 static bool dmatest_match_device(struct dma_device *device)
@@ -325,7 +325,7 @@ static int dmatest_add_channel(struct dma_chan *chan)
 
 	dtc = kmalloc(sizeof(struct dmatest_chan), GFP_KERNEL);
 	if (!dtc) {
-		pr_warning("dmatest: No memory for %s\n", dev_name(&chan->dev));
+		pr_warning("dmatest: No memory for %s\n", dma_chan_name(chan));
 		return -ENOMEM;
 	}
 
@@ -336,16 +336,16 @@ static int dmatest_add_channel(struct dma_chan *chan)
 		thread = kzalloc(sizeof(struct dmatest_thread), GFP_KERNEL);
 		if (!thread) {
 			pr_warning("dmatest: No memory for %s-test%u\n",
-				   dev_name(&chan->dev), i);
+				   dma_chan_name(chan), i);
 			break;
 		}
 		thread->chan = dtc->chan;
 		smp_wmb();
 		thread->task = kthread_run(dmatest_func, thread, "%s-test%u",
-				dev_name(&chan->dev), i);
+				dma_chan_name(chan), i);
 		if (IS_ERR(thread->task)) {
 			pr_warning("dmatest: Failed to run thread %s-test%u\n",
-					dev_name(&chan->dev), i);
+					dma_chan_name(chan), i);
 			kfree(thread);
 			break;
 		}
@@ -355,7 +355,7 @@ static int dmatest_add_channel(struct dma_chan *chan)
 		list_add_tail(&thread->node, &dtc->threads);
 	}
 
-	pr_info("dmatest: Started %u threads using %s\n", i, dev_name(&chan->dev));
+	pr_info("dmatest: Started %u threads using %s\n", i, dma_chan_name(chan));
 
 	list_add_tail(&dtc->node, &dmatest_channels);
 	nr_channels++;
@@ -408,7 +408,7 @@ static void __exit dmatest_exit(void)
 		list_del(&dtc->node);
 		dmatest_cleanup_channel(dtc);
 		pr_debug("dmatest: dropped channel %s\n",
-			 dev_name(&dtc->chan->dev));
+			 dma_chan_name(dtc->chan));
 		dma_release_channel(dtc->chan);
 	}
 }
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index a29dda8..6b702cc 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -70,6 +70,15 @@
  * the controller, though.
  */
 
+static struct device *chan2dev(struct dma_chan *chan)
+{
+	return &chan->dev->device;
+}
+static struct device *chan2parent(struct dma_chan *chan)
+{
+	return chan->dev->device.parent;
+}
+
 static struct dw_desc *dwc_first_active(struct dw_dma_chan *dwc)
 {
 	return list_entry(dwc->active_list.next, struct dw_desc, desc_node);
@@ -93,12 +102,12 @@ static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
 			ret = desc;
 			break;
 		}
-		dev_dbg(&dwc->chan.dev, "desc %p not ACKed\n", desc);
+		dev_dbg(chan2dev(&dwc->chan), "desc %p not ACKed\n", desc);
 		i++;
 	}
 	spin_unlock_bh(&dwc->lock);
 
-	dev_vdbg(&dwc->chan.dev, "scanned %u descriptors on freelist\n", i);
+	dev_vdbg(chan2dev(&dwc->chan), "scanned %u descriptors on freelist\n", i);
 
 	return ret;
 }
@@ -108,10 +117,10 @@ static void dwc_sync_desc_for_cpu(struct dw_dma_chan *dwc, struct dw_desc *desc)
 	struct dw_desc	*child;
 
 	list_for_each_entry(child, &desc->txd.tx_list, desc_node)
-		dma_sync_single_for_cpu(dwc->chan.dev.parent,
+		dma_sync_single_for_cpu(chan2parent(&dwc->chan),
 				child->txd.phys, sizeof(child->lli),
 				DMA_TO_DEVICE);
-	dma_sync_single_for_cpu(dwc->chan.dev.parent,
+	dma_sync_single_for_cpu(chan2parent(&dwc->chan),
 			desc->txd.phys, sizeof(desc->lli),
 			DMA_TO_DEVICE);
 }
@@ -129,11 +138,11 @@ static void dwc_desc_put(struct dw_dma_chan *dwc, struct dw_desc *desc)
 
 		spin_lock_bh(&dwc->lock);
 		list_for_each_entry(child, &desc->txd.tx_list, desc_node)
-			dev_vdbg(&dwc->chan.dev,
+			dev_vdbg(chan2dev(&dwc->chan),
 					"moving child desc %p to freelist\n",
 					child);
 		list_splice_init(&desc->txd.tx_list, &dwc->free_list);
-		dev_vdbg(&dwc->chan.dev, "moving desc %p to freelist\n", desc);
+		dev_vdbg(chan2dev(&dwc->chan), "moving desc %p to freelist\n", desc);
 		list_add(&desc->desc_node, &dwc->free_list);
 		spin_unlock_bh(&dwc->lock);
 	}
@@ -163,9 +172,9 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 
 	/* ASSERT:  channel is idle */
 	if (dma_readl(dw, CH_EN) & dwc->mask) {
-		dev_err(&dwc->chan.dev,
+		dev_err(chan2dev(&dwc->chan),
 			"BUG: Attempted to start non-idle channel\n");
-		dev_err(&dwc->chan.dev,
+		dev_err(chan2dev(&dwc->chan),
 			"  SAR: 0x%x DAR: 0x%x LLP: 0x%x CTL: 0x%x:%08x\n",
 			channel_readl(dwc, SAR),
 			channel_readl(dwc, DAR),
@@ -193,7 +202,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 	void				*param;
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
 
-	dev_vdbg(&dwc->chan.dev, "descriptor %u complete\n", txd->cookie);
+	dev_vdbg(chan2dev(&dwc->chan), "descriptor %u complete\n", txd->cookie);
 
 	dwc->completed = txd->cookie;
 	callback = txd->callback;
@@ -208,11 +217,11 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 	 * mapped before they were submitted...
 	 */
 	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP))
-		dma_unmap_page(dwc->chan.dev.parent, desc->lli.dar, desc->len,
-				DMA_FROM_DEVICE);
+		dma_unmap_page(chan2parent(&dwc->chan), desc->lli.dar,
+			       desc->len, DMA_FROM_DEVICE);
 	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP))
-		dma_unmap_page(dwc->chan.dev.parent, desc->lli.sar, desc->len,
-				DMA_TO_DEVICE);
+		dma_unmap_page(chan2parent(&dwc->chan), desc->lli.sar,
+			       desc->len, DMA_TO_DEVICE);
 
 	/*
 	 * The API requires that no submissions are done from a
@@ -228,7 +237,7 @@ static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	LIST_HEAD(list);
 
 	if (dma_readl(dw, CH_EN) & dwc->mask) {
-		dev_err(&dwc->chan.dev,
+		dev_err(chan2dev(&dwc->chan),
 			"BUG: XFER bit set, but channel not idle!\n");
 
 		/* Try to continue after resetting the channel... */
@@ -273,7 +282,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		return;
 	}
 
-	dev_vdbg(&dwc->chan.dev, "scan_descriptors: llp=0x%x\n", llp);
+	dev_vdbg(chan2dev(&dwc->chan), "scan_descriptors: llp=0x%x\n", llp);
 
 	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
 		if (desc->lli.llp == llp)
@@ -292,7 +301,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		dwc_descriptor_complete(dwc, desc);
 	}
 
-	dev_err(&dwc->chan.dev,
+	dev_err(chan2dev(&dwc->chan),
 		"BUG: All descriptors done, but channel not idle!\n");
 
 	/* Try to continue after resetting the channel... */
@@ -308,7 +317,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 
 static void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
 {
-	dev_printk(KERN_CRIT, &dwc->chan.dev,
+	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
 			"  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
 			lli->sar, lli->dar, lli->llp,
 			lli->ctlhi, lli->ctllo);
@@ -342,9 +351,9 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	 * controller flagged an error instead of scribbling over
 	 * random memory locations.
 	 */
-	dev_printk(KERN_CRIT, &dwc->chan.dev,
+	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
 			"Bad descriptor submitted for DMA!\n");
-	dev_printk(KERN_CRIT, &dwc->chan.dev,
+	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
 			"  cookie: %d\n", bad_desc->txd.cookie);
 	dwc_dump_lli(dwc, &bad_desc->lli);
 	list_for_each_entry(child, &bad_desc->txd.tx_list, desc_node)
@@ -442,12 +451,12 @@ static dma_cookie_t dwc_tx_submit(struct dma_async_tx_descriptor *tx)
 	 * for DMA. But this is hard to do in a race-free manner.
 	 */
 	if (list_empty(&dwc->active_list)) {
-		dev_vdbg(&tx->chan->dev, "tx_submit: started %u\n",
+		dev_vdbg(chan2dev(tx->chan), "tx_submit: started %u\n",
 				desc->txd.cookie);
 		dwc_dostart(dwc, desc);
 		list_add_tail(&desc->desc_node, &dwc->active_list);
 	} else {
-		dev_vdbg(&tx->chan->dev, "tx_submit: queued %u\n",
+		dev_vdbg(chan2dev(tx->chan), "tx_submit: queued %u\n",
 				desc->txd.cookie);
 
 		list_add_tail(&desc->desc_node, &dwc->queue);
@@ -472,11 +481,11 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	unsigned int		dst_width;
 	u32			ctllo;
 
-	dev_vdbg(&chan->dev, "prep_dma_memcpy d0x%x s0x%x l0x%zx f0x%lx\n",
+	dev_vdbg(chan2dev(chan), "prep_dma_memcpy d0x%x s0x%x l0x%zx f0x%lx\n",
 			dest, src, len, flags);
 
 	if (unlikely(!len)) {
-		dev_dbg(&chan->dev, "prep_dma_memcpy: length is zero!\n");
+		dev_dbg(chan2dev(chan), "prep_dma_memcpy: length is zero!\n");
 		return NULL;
 	}
 
@@ -516,7 +525,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 			first = desc;
 		} else {
 			prev->lli.llp = desc->txd.phys;
-			dma_sync_single_for_device(chan->dev.parent,
+			dma_sync_single_for_device(chan2parent(chan),
 					prev->txd.phys, sizeof(prev->lli),
 					DMA_TO_DEVICE);
 			list_add_tail(&desc->desc_node,
@@ -531,7 +540,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		prev->lli.ctllo |= DWC_CTLL_INT_EN;
 
 	prev->lli.llp = 0;
-	dma_sync_single_for_device(chan->dev.parent,
+	dma_sync_single_for_device(chan2parent(chan),
 			prev->txd.phys, sizeof(prev->lli),
 			DMA_TO_DEVICE);
 
@@ -562,7 +571,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	struct scatterlist	*sg;
 	size_t			total_len = 0;
 
-	dev_vdbg(&chan->dev, "prep_dma_slave\n");
+	dev_vdbg(chan2dev(chan), "prep_dma_slave\n");
 
 	if (unlikely(!dws || !sg_len))
 		return NULL;
@@ -570,7 +579,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	reg_width = dws->reg_width;
 	prev = first = NULL;
 
-	sg_len = dma_map_sg(chan->dev.parent, sgl, sg_len, direction);
+	sg_len = dma_map_sg(chan2parent(chan), sgl, sg_len, direction);
 
 	switch (direction) {
 	case DMA_TO_DEVICE:
@@ -587,7 +596,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 			desc = dwc_desc_get(dwc);
 			if (!desc) {
-				dev_err(&chan->dev,
+				dev_err(chan2dev(chan),
 					"not enough descriptors available\n");
 				goto err_desc_get;
 			}
@@ -607,7 +616,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 				first = desc;
 			} else {
 				prev->lli.llp = desc->txd.phys;
-				dma_sync_single_for_device(chan->dev.parent,
+				dma_sync_single_for_device(chan2parent(chan),
 						prev->txd.phys,
 						sizeof(prev->lli),
 						DMA_TO_DEVICE);
@@ -633,7 +642,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 			desc = dwc_desc_get(dwc);
 			if (!desc) {
-				dev_err(&chan->dev,
+				dev_err(chan2dev(chan),
 					"not enough descriptors available\n");
 				goto err_desc_get;
 			}
@@ -653,7 +662,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 				first = desc;
 			} else {
 				prev->lli.llp = desc->txd.phys;
-				dma_sync_single_for_device(chan->dev.parent,
+				dma_sync_single_for_device(chan2parent(chan),
 						prev->txd.phys,
 						sizeof(prev->lli),
 						DMA_TO_DEVICE);
@@ -673,7 +682,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		prev->lli.ctllo |= DWC_CTLL_INT_EN;
 
 	prev->lli.llp = 0;
-	dma_sync_single_for_device(chan->dev.parent,
+	dma_sync_single_for_device(chan2parent(chan),
 			prev->txd.phys, sizeof(prev->lli),
 			DMA_TO_DEVICE);
 
@@ -768,11 +777,11 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	u32			cfghi;
 	u32			cfglo;
 
-	dev_vdbg(&chan->dev, "alloc_chan_resources\n");
+	dev_vdbg(chan2dev(chan), "alloc_chan_resources\n");
 
 	/* ASSERT:  channel is idle */
 	if (dma_readl(dw, CH_EN) & dwc->mask) {
-		dev_dbg(&chan->dev, "DMA channel not idle?\n");
+		dev_dbg(chan2dev(chan), "DMA channel not idle?\n");
 		return -EIO;
 	}
 
@@ -808,7 +817,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 
 		desc = kzalloc(sizeof(struct dw_desc), GFP_KERNEL);
 		if (!desc) {
-			dev_info(&chan->dev,
+			dev_info(chan2dev(chan),
 				"only allocated %d descriptors\n", i);
 			spin_lock_bh(&dwc->lock);
 			break;
@@ -818,7 +827,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 		desc->txd.tx_submit = dwc_tx_submit;
 		desc->txd.flags = DMA_CTRL_ACK;
 		INIT_LIST_HEAD(&desc->txd.tx_list);
-		desc->txd.phys = dma_map_single(chan->dev.parent, &desc->lli,
+		desc->txd.phys = dma_map_single(chan2parent(chan), &desc->lli,
 				sizeof(desc->lli), DMA_TO_DEVICE);
 		dwc_desc_put(dwc, desc);
 
@@ -833,7 +842,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 
 	spin_unlock_bh(&dwc->lock);
 
-	dev_dbg(&chan->dev,
+	dev_dbg(chan2dev(chan),
 		"alloc_chan_resources allocated %d descriptors\n", i);
 
 	return i;
@@ -846,7 +855,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	struct dw_desc		*desc, *_desc;
 	LIST_HEAD(list);
 
-	dev_dbg(&chan->dev, "free_chan_resources (descs allocated=%u)\n",
+	dev_dbg(chan2dev(chan), "free_chan_resources (descs allocated=%u)\n",
 			dwc->descs_allocated);
 
 	/* ASSERT:  channel is idle */
@@ -867,13 +876,13 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	spin_unlock_bh(&dwc->lock);
 
 	list_for_each_entry_safe(desc, _desc, &list, desc_node) {
-		dev_vdbg(&chan->dev, "  freeing descriptor %p\n", desc);
-		dma_unmap_single(chan->dev.parent, desc->txd.phys,
+		dev_vdbg(chan2dev(chan), "  freeing descriptor %p\n", desc);
+		dma_unmap_single(chan2parent(chan), desc->txd.phys,
 				sizeof(desc->lli), DMA_TO_DEVICE);
 		kfree(desc);
 	}
 
-	dev_vdbg(&chan->dev, "free_chan_resources done\n");
+	dev_vdbg(chan2dev(chan), "free_chan_resources done\n");
 }
 
 /*----------------------------------------------------------------------*/
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 46e0128..ca70a21 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -822,7 +822,7 @@ static int __devinit fsl_dma_chan_probe(struct fsl_dma_device *fdev,
 	 */
 	WARN_ON(fdev->feature != new_fsl_chan->feature);
 
-	new_fsl_chan->dev = &new_fsl_chan->common.dev;
+	new_fsl_chan->dev = &new_fsl_chan->common.dev->device;
 	new_fsl_chan->reg_base = ioremap(new_fsl_chan->reg.start,
 			new_fsl_chan->reg.end - new_fsl_chan->reg.start + 1);
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 1419a50..d6b6bff 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -113,7 +113,7 @@ struct dma_chan_percpu {
  * @device: ptr to the dma device who supplies this channel, always !%NULL
  * @cookie: last cookie value returned to client
  * @chan_id: channel ID for sysfs
- * @class_dev: class device for sysfs
+ * @dev: class device for sysfs
  * @refcount: kref, used in "bigref" slow-mode
  * @slow_ref: indicates that the DMA channel is free
  * @rcu: the DMA channel's RCU head
@@ -128,7 +128,7 @@ struct dma_chan {
 
 	/* sysfs */
 	int chan_id;
-	struct device dev;
+	struct dma_chan_dev *dev;
 
 	struct list_head device_node;
 	struct dma_chan_percpu *local;
@@ -136,7 +136,20 @@ struct dma_chan {
 	int table_count;
 };
 
-#define to_dma_chan(p) container_of(p, struct dma_chan, dev)
+/**
+ * struct dma_chan_dev - relate sysfs device node to backing channel device
+ * @chan - driver channel device
+ * @device - sysfs device
+ */
+struct dma_chan_dev {
+	struct dma_chan *chan;
+	struct device device;
+};
+
+static inline const char *dma_chan_name(struct dma_chan *chan)
+{
+	return dev_name(&chan->dev->device);
+}
 
 void dma_chan_cleanup(struct kref *kref);
 


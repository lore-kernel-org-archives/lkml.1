Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZCFLH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZCFLH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZCFLHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:07:18 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:63999 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZCFLHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:07:17 -0500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dmaengine: Add privatecnt to revert DMA_PRIVATE propery
Date: Fri,  6 Mar 2009 20:07:14 +0900
Message-Id: <1236337634-5110-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently dma_request_channel() set DMA_PRIVATE capability but never
clear it.  So if a public channel was once grabbed by
dma_request_channel(), the device stay PRIVATE forever.  Add
privatecnt member to dma_device to correctly revert it.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/dma/dmaengine.c   |    8 ++++++++
 include/linux/dmaengine.h |    9 +++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 280a9d2..14be8fa 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -507,6 +507,7 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 			 * published in the general-purpose allocator
 			 */
 			dma_cap_set(DMA_PRIVATE, device->cap_mask);
+			device->privatecnt++;
 			err = dma_chan_get(chan);
 
 			if (err == -ENODEV) {
@@ -518,6 +519,8 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 				       dma_chan_name(chan), err);
 			else
 				break;
+			if (--device->privatecnt == 0)
+				dma_cap_clear(DMA_PRIVATE, device->cap_mask);
 			chan->private = NULL;
 			chan = NULL;
 		}
@@ -537,6 +540,9 @@ void dma_release_channel(struct dma_chan *chan)
 	WARN_ONCE(chan->client_count != 1,
 		  "chan reference count %d != 1\n", chan->client_count);
 	dma_chan_put(chan);
+	/* drop PRIVATE cap enabled by __dma_request_channel() */
+	if (--chan->device->privatecnt == 0)
+		dma_cap_clear(DMA_PRIVATE, chan->device->cap_mask);
 	chan->private = NULL;
 	mutex_unlock(&dma_list_mutex);
 }
@@ -701,6 +707,8 @@ int dma_async_device_register(struct dma_device *device)
 			}
 		}
 	list_add_tail_rcu(&device->global_node, &dma_device_list);
+	if (dma_has_cap(DMA_PRIVATE, device->cap_mask))
+		chan->device->privatecnt++;	/* Always private */
 	dma_channel_rebalance();
 	mutex_unlock(&dma_list_mutex);
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index f041384..f834fa1 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -209,6 +209,7 @@ struct dma_async_tx_descriptor {
 /**
  * struct dma_device - info on the entity supplying DMA services
  * @chancnt: how many DMA channels are supported
+ * @privatecnt: how many DMA channels are requested by dma_request_channel
  * @channels: the list of struct dma_chan
  * @global_node: list_head for global dma_device_list
  * @cap_mask: one or more dma_capability flags
@@ -232,6 +233,7 @@ struct dma_async_tx_descriptor {
 struct dma_device {
 
 	unsigned int chancnt;
+	unsigned int privatecnt;
 	struct list_head channels;
 	struct list_head global_node;
 	dma_cap_mask_t  cap_mask;
@@ -342,6 +344,13 @@ __dma_cap_set(enum dma_transaction_type tx_type, dma_cap_mask_t *dstp)
 	set_bit(tx_type, dstp->bits);
 }
 
+#define dma_cap_clear(tx, mask) __dma_cap_clear((tx), &(mask))
+static inline void
+__dma_cap_clear(enum dma_transaction_type tx_type, dma_cap_mask_t *dstp)
+{
+	clear_bit(tx_type, dstp->bits);
+}
+
 #define dma_cap_zero(mask) __dma_cap_zero(&(mask))
 static inline void __dma_cap_zero(dma_cap_mask_t *dstp)
 {
-- 
1.5.6.3


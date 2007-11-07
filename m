Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbXKGSqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbXKGSqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXKGSqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:46:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:55707 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbXKGSqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:46:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,385,1188802800"; 
   d="scan'208";a="313803281"
Subject: [PATCH] dmaengine: Fix broken device refcounting
From: Dan Williams <dan.j.williams@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Shannon Nelson <shannon.nelson@intel.com>, hskinnemoen@atmel.com,
       stable@kernel.org
Content-Type: text/plain
Date: Wed, 07 Nov 2007 11:46:07 -0700
Message-Id: <1194461167.8489.6.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

When a DMA device is unregistered, its reference count is decremented
twice for each channel: Once dma_class_dev_release() and once in
dma_chan_cleanup(). This may result in the DMA device driver's
remove() function completing before all channels have been cleaned
up, causing lots of use-after-free fun.

Fix it by incrementing the device's reference count twice for each
channel during registration.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
[dan.j.williams@intel.com: kill unnecessary client refcounting]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: stable@kernel.org
---

This fixes dmaengine refcounting in 2.6.23.y and 2.6.24-rc.

 drivers/dma/dmaengine.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 84257f7..ec7e871 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -186,10 +186,9 @@ static void dma_client_chan_alloc(struct dma_client *client)
 				/* we are done once this client rejects
 				 * an available resource
 				 */
-				if (ack == DMA_ACK) {
+				if (ack == DMA_ACK)
 					dma_chan_get(chan);
-					kref_get(&device->refcount);
-				} else if (ack == DMA_NAK)
+				else if (ack == DMA_NAK)
 					return;
 			}
 		}
@@ -276,11 +275,8 @@ static void dma_clients_notify_removed(struct dma_chan *chan)
 		/* client was holding resources for this channel so
 		 * free it
 		 */
-		if (ack == DMA_ACK) {
+		if (ack == DMA_ACK)
 			dma_chan_put(chan);
-			kref_put(&chan->device->refcount,
-				dma_async_device_cleanup);
-		}
 	}
 
 	mutex_unlock(&dma_list_mutex);
@@ -320,11 +316,8 @@ void dma_async_client_unregister(struct dma_client *client)
 			ack = client->event_callback(client, chan,
 				DMA_RESOURCE_REMOVED);
 
-			if (ack == DMA_ACK) {
+			if (ack == DMA_ACK)
 				dma_chan_put(chan);
-				kref_put(&chan->device->refcount,
-					dma_async_device_cleanup);
-			}
 		}
 
 	list_del(&client->global_node);
@@ -401,6 +394,8 @@ int dma_async_device_register(struct dma_device *device)
 			goto err_out;
 		}
 
+		/* One for the channel, one of the class device */
+		kref_get(&device->refcount);
 		kref_get(&device->refcount);
 		kref_init(&chan->refcount);
 		chan->slow_ref = 0;

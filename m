Return-Path: <linux-kernel-owner+w=401wt.eu-S1765433AbXJZQmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765433AbXJZQmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764538AbXJZQjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:39:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:62896 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764887AbXJZQjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:39:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,334,1188802800"; 
   d="scan'208";a="306120700"
Subject: Re: [PATCH] DMA: Fix broken device refcounting
From: Dan Williams <dan.j.williams@intel.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Shannon Nelson <shannon.nelson@intel.com>
In-Reply-To: <1193415162504-git-send-email-hskinnemoen@atmel.com>
References: <1193415162504-git-send-email-hskinnemoen@atmel.com>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 09:36:17 -0700
Message-Id: <1193416577.9353.5.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-26 at 09:12 -0700, Haavard Skinnemoen wrote:
> I'm not sure if this is the correct way to solve it, but it seems to
> work. The remove() function does not hang, which indicates that the
> device's reference count does drop all the way to zero on
> unregistration, which in turn indicates that it did actually drop
> _below_ zero before.

Yeah, Shannon ran into this too...  I'd like to be able clean this up by
reducing the number of time we take the device reference, but the
following patch is still showing problems in Shannon's environment, so I
missed one...

---

dmaengine: fix up dma_device refcounting

From: Dan Williams <dan.j.williams@intel.com>

Currently the code drops too many references on the parent device.  Change
the scheme to:

+ take a reference at registration:
  dma_async_device_register()
+ take a reference for each channel device registered:
  device_register(&chan->dev)
- drop a reference for each channel device unregistered:
  device_unregister(&chan->dev)
- drop a reference at unregistration:
  dma_async_device_unregister()

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/dma/dmaengine.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 84257f7..d2b600b 100644
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
@@ -221,7 +220,6 @@ void dma_chan_cleanup(struct kref *kref)
 {
 	struct dma_chan *chan = container_of(kref, struct dma_chan, refcount);
 	chan->device->device_free_chan_resources(chan);
-	kref_put(&chan->device->refcount, dma_async_device_cleanup);
 }
 EXPORT_SYMBOL(dma_chan_cleanup);
 
@@ -276,11 +274,8 @@ static void dma_clients_notify_removed(struct dma_chan *chan)
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
@@ -320,11 +315,8 @@ void dma_async_client_unregister(struct dma_client *client)
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

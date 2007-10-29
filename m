Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbXJ2QCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbXJ2QCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbXJ2QCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:02:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:39401 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297AbXJ2QCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:02:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,343,1188802800"; 
   d="scan'208";a="190790172"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] DMA: Fix broken device refcounting
Date: Mon, 29 Oct 2007 09:02:34 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C034FF787@orsmsx418.amr.corp.intel.com>
In-Reply-To: <1193512357.18911.6.camel@dwillia2-linux.ch.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] DMA: Fix broken device refcounting
Thread-Index: AcgYzaSlA5TUPPdGSHKMnvGtZ87ZzgBduyqA
References: <1193415162504-git-send-email-hskinnemoen@atmel.com> <1193416577.9353.5.camel@dwillia2-linux.ch.intel.com> <20071027154947.6836a3d9@siona> <1193512357.18911.6.camel@dwillia2-linux.ch.intel.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Oct 2007 16:02:36.0137 (UTC) FILETIME=[1F5DDD90:01C81A45]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Williams, Dan J 
>On Sat, 2007-10-27 at 06:49 -0700, Haavard Skinnemoen wrote:
>> On Fri, 26 Oct 2007 09:36:17 -0700
>> Dan Williams <dan.j.williams@intel.com> wrote:
>> 
>> > @@ -221,7 +220,6 @@ void dma_chan_cleanup(struct kref *kref)
>> >  {
>> >       struct dma_chan *chan = container_of(kref, struct 
>dma_chan, refcount);
>> >       chan->device->device_free_chan_resources(chan);
>> > -     kref_put(&chan->device->refcount, dma_async_device_cleanup);
>> >  }
>> >  EXPORT_SYMBOL(dma_chan_cleanup);
>> 
>> While I can't see any problems with the rest of the patch, I 
>think this
>> part is wrong for the same reasons removing the kref_put() from the
>> class device cleanup function is. I don't see any constraint that
>> guarantees that dma_chan_cleanup() will always be called before
>> dma_dev_release(), which means that "chan" may have been freed before
>> this function gets a chance to run. Please correct me if I'm wrong.
>
>Absolutely right, the driver, not dmaengine, frees the memory so there
>must be a per channel reference on the device to hold off the driver's
>remove routine.
>> 
>> Håvard
>
>So how about this...
>
>---snip---
>dmaengine: Fix broken device refcounting
>
>From: Haavard Skinnemoen <hskinnemoen@atmel.com>
>
>When a DMA device is unregistered, its reference count is decremented
>twice for each channel: Once dma_class_dev_release() and once in
>dma_chan_cleanup(). This may result in the DMA device driver's
>remove() function completing before all channels have been cleaned
>up, causing lots of use-after-free fun.
>
>Fix it by incrementing the device's reference count twice for each
>channel during registration.
>
>Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
>[dan.j.williams@intel.com: kill unnecessary client refcounting]
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>---
>
> drivers/dma/dmaengine.c |   17 ++++++-----------
> 1 files changed, 6 insertions(+), 11 deletions(-)
>
>diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
>index 84257f7..ec7e871 100644
>--- a/drivers/dma/dmaengine.c
>+++ b/drivers/dma/dmaengine.c
>@@ -186,10 +186,9 @@ static void dma_client_chan_alloc(struct 
>dma_client *client)
> 				/* we are done once this client rejects
> 				 * an available resource
> 				 */
>-				if (ack == DMA_ACK) {
>+				if (ack == DMA_ACK)
> 					dma_chan_get(chan);
>-					kref_get(&device->refcount);
>-				} else if (ack == DMA_NAK)
>+				else if (ack == DMA_NAK)
> 					return;
> 			}
> 		}
>@@ -276,11 +275,8 @@ static void 
>dma_clients_notify_removed(struct dma_chan *chan)
> 		/* client was holding resources for this channel so
> 		 * free it
> 		 */
>-		if (ack == DMA_ACK) {
>+		if (ack == DMA_ACK)
> 			dma_chan_put(chan);
>-			kref_put(&chan->device->refcount,
>-				dma_async_device_cleanup);
>-		}
> 	}
> 
> 	mutex_unlock(&dma_list_mutex);
>@@ -320,11 +316,8 @@ void dma_async_client_unregister(struct 
>dma_client *client)
> 			ack = client->event_callback(client, chan,
> 				DMA_RESOURCE_REMOVED);
> 
>-			if (ack == DMA_ACK) {
>+			if (ack == DMA_ACK)
> 				dma_chan_put(chan);
>-				kref_put(&chan->device->refcount,
>-					dma_async_device_cleanup);
>-			}
> 		}
> 
> 	list_del(&client->global_node);
>@@ -401,6 +394,8 @@ int dma_async_device_register(struct 
>dma_device *device)
> 			goto err_out;
> 		}
> 
>+		/* One for the channel, one of the class device */
>+		kref_get(&device->refcount);
> 		kref_get(&device->refcount);
> 		kref_init(&chan->refcount);
> 		chan->slow_ref = 0;
>
>

I tested this in my ioatdma setup and no longer get the panic.  I'm good with this if you two are happy with it.  

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>

sln

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbYGBCBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbYGBCBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757484AbYGBCA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:00:58 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:35987 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYGBCA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gl4fRG+7G3prjeuN7ySW20f3FdFE+W5EtAaCyDk//WdkabFHG4wZ0ZrDSuEvaFGZfw
         Pc0zaboFGq19JQBbekDzRcbygso85BSSUsFEVTU2XwitvTeWfmjQNVupTbupA7GHxOVe
         IiZ1VZC/eNocJUtttc+bNEBZ4fFeF7hrOxrQc=
Message-ID: <e9c3a7c20807011900x7b2ac3dx7536e0450202e3c0@mail.gmail.com>
Date: Tue, 1 Jul 2008 19:00:55 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH v4 2/6] dmaengine: Add dma_chan_is_in_use() function
Cc: "Pierre Ossman" <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, "David Brownell" <david-b@pacbell.net>
In-Reply-To: <e9c3a7c20807011831n74eb69b8r3095b62515fe5c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	 <e9c3a7c20807011831n74eb69b8r3095b62515fe5c9@mail.gmail.com>
X-Google-Sender-Auth: f94c538807242f92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 6:31 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Jun 26, 2008 at 6:23 AM, Haavard Skinnemoen
> <haavard.skinnemoen@atmel.com> wrote:
>> This moves the code checking if a DMA channel is in use from
>> show_in_use() into an inline helper function, dma_is_in_use(). DMA
>> controllers can use this in order to give clients exclusive access to
>> channels (usually necessary when setting up slave DMA.)
>>
>> I have to admit that I don't really understand the channel refcounting
>> logic at all... dma_chan_get() simply increments a per-cpu value. How
>> can we be sure that whatever CPU calls dma_chan_is_in_use() sees the
>> same value?
>
> As Chris noted in the comments at the top of dmaengine.c this is an
> implementation Rusty's 'bigref'.  It seeks to avoid the
> cache-line-bouncing overhead of maintaining a single global refcount
> in hot paths like tcp_v{4,6}_rcv().  When the channel is being
> removed, a rare event, we transition to the accurate, yet slow, global
> method.
>
> Your observation is correct, dma_chan_is_in_use() may lie in the case
> when the current cpu is not using the channel.  For this particular
> test I think you can look to see if this channel's resources are
> already allocated.  If they are then some other client got a hold of
> this channel before the current attempt.  Hmm... that would also
> require that we free the channel's resources in the case where the
> client replies with DMA_NAK, probably something we should do anyways.
>
> Thoughts?
>

Actually we will probably need something like the following.
->client_count is protected by the dma_list_mutex.

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 99c22b4..10de69e 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -183,9 +183,10 @@ static void dma_client_chan_alloc(struct
dma_client *client)
 				/* we are done once this client rejects
 				 * an available resource
 				 */
-				if (ack == DMA_ACK)
+				if (ack == DMA_ACK) {
 					dma_chan_get(chan);
-				else if (ack == DMA_NAK)
+					chan->client_count++;
+				} else if (ack == DMA_NAK)
 					return;
 			}
 		}
@@ -272,8 +273,10 @@ static void dma_clients_notify_removed(struct
dma_chan *chan)
 		/* client was holding resources for this channel so
 		 * free it
 		 */
-		if (ack == DMA_ACK)
+		if (ack == DMA_ACK) {
 			dma_chan_put(chan);
+			chan->client_count--;
+		}
 	}

 	mutex_unlock(&dma_list_mutex);
@@ -313,8 +316,10 @@ void dma_async_client_unregister(struct dma_client *client)
 			ack = client->event_callback(client, chan,
 				DMA_RESOURCE_REMOVED);

-			if (ack == DMA_ACK)
+			if (ack == DMA_ACK) {
 				dma_chan_put(chan);
+				chan->client_count--;
+			}
 		}

 	list_del(&client->global_node);
@@ -394,6 +399,7 @@ int dma_async_device_register(struct dma_device *device)
 		kref_get(&device->refcount);
 		kref_get(&device->refcount);
 		kref_init(&chan->refcount);
+		chan->client_count = 0;
 		chan->slow_ref = 0;
 		INIT_RCU_HEAD(&chan->rcu);
 	}
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d08a5c5..6432b83 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -139,6 +139,7 @@ struct dma_chan_percpu {
  * @rcu: the DMA channel's RCU head
  * @device_node: used to add this to the device chan list
  * @local: per-cpu pointer to a struct dma_chan_percpu
+ * @client-count: how many clients are using this channel
  */
 struct dma_chan {
 	struct dma_device *device;
@@ -154,6 +155,7 @@ struct dma_chan {

 	struct list_head device_node;
 	struct dma_chan_percpu *local;
+	int client_count;
 };

 #define to_dma_chan(p) container_of(p, struct dma_chan, dev)

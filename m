Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYLBPwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYLBPwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYLBPv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:51:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:33963 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751342AbYLBPvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:51:55 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+7YwhCwZm7VyrvYC2QqozQZoppHUDrSoo5b1KD0O
	/EvjEU19kzu1+g
Date: Tue, 2 Dec 2008 16:52:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       maciej.sosnowski@intel.com, hskinnemoen@atmel.com,
       nicolas.ferre@atmel.com
Subject: Re: [PATCH 07/13] dmaengine: introduce dma_request_channel and
 private channels
In-Reply-To: <20081114213453.32354.53002.stgit@dwillia2-linux.ch.intel.com>
Message-ID: <Pine.LNX.4.64.0812021642120.5663@axis700.grange>
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com>
 <20081114213453.32354.53002.stgit@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

I think, there is a problem with your dma_request_channel() / 
private_candidate() implementation: your current version only tries one 
channel from a dma device list, which matched capabilities. If this 
channel is not accepted by the client, you do not try other channels from 
this device and just go to the next one...

Another problem I encountered with my framebuffer is the initialisation 
order. You initialise dmaengine per subsys_initcall(), whereas the only 
way to guarantee the order:

dmaengine
dma-device driver
framebuffer

when they are all linked into the kernel was to switch dmaengine to 
arch_initcall, put the dma driver under subsys_initcall, and the 
framebuffer under a normal module_init / device_initcall.

Below is a naive patch, adding two more arguments to private_candidate() 
is not very elegant, so, this is not an official submission. Feel free to 
propose a better fix. But if you like, I can make two patches out of this 
- separating the initialisation priority.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

dmaengine: scan all channels if one is rejected, initialise earlier.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 94dcc64..677b0c8 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -404,10 +404,12 @@ static void dma_channel_rebalance(void)
 		}
 }
 
-static struct dma_chan *private_candidate(dma_cap_mask_t *mask, struct dma_device *dev)
+static struct dma_chan *private_candidate(dma_cap_mask_t *mask,
+		struct dma_device *dev, dma_filter_fn fn, void *fn_param)
 {
 	struct dma_chan *chan;
 	struct dma_chan *ret = NULL;
+	bool ack;
 
 	/* devices with multiple channels need special handling as we need to
 	 * ensure that all channels are either private or public.
@@ -430,8 +432,18 @@ static struct dma_chan *private_candidate(dma_cap_mask_t *mask, struct dma_devic
 				 __func__, dev_name(&chan->dev));
 			continue;
 		}
-		ret = chan;
-		break;
+
+		if (fn)
+			ack = fn(chan, fn_param);
+		else
+			ack = true;
+
+		if (ack) {
+			ret = chan;
+			break;
+		} else
+			pr_debug("%s: %s filter said false\n",
+				 __func__, dev_name(&chan->dev));
 	}
 
 	return ret;
@@ -447,42 +459,33 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 {
 	struct dma_device *device, *_d;
 	struct dma_chan *chan = NULL;
-	bool ack;
 	int err;
 
 	/* Find a channel */
 	mutex_lock(&dma_list_mutex);
 	list_for_each_entry_safe(device, _d, &dma_device_list, global_node) {
-		chan = private_candidate(mask, device);
+		chan = private_candidate(mask, device, fn, fn_param);
 		if (!chan)
 			continue;
 
-		if (fn)
-			ack = fn(chan, fn_param);
+		/* Found a suitable channel, try to grab, prep, and
+		 * return it.  We first set DMA_PRIVATE to disable
+		 * balance_ref_count as this channel will not be
+		 * published in the general-purpose allocator
+		 */
+		dma_cap_set(DMA_PRIVATE, device->cap_mask);
+		err = dma_chan_get(chan);
+
+		if (err == -ENODEV) {
+			pr_debug("%s: %s module removed\n", __func__,
+				 dev_name(&chan->dev));
+			list_del_rcu(&device->global_node);
+		} else if (err)
+			pr_err("dmaengine: failed to get %s: (%d)",
+			       dev_name(&chan->dev), err);
 		else
-			ack = true;
-
-		if (ack) {
-			/* Found a suitable channel, try to grab, prep, and
-			 * return it.  We first set DMA_PRIVATE to disable
-			 * balance_ref_count as this channel will not be
-			 * published in the general-purpose allocator
-			 */
-			dma_cap_set(DMA_PRIVATE, device->cap_mask);
-			err = dma_chan_get(chan);
+			break;
 
-			if (err == -ENODEV) {
-				pr_debug("%s: %s module removed\n", __func__,
-					 dev_name(&chan->dev));
-				list_del_rcu(&device->global_node);
-			} else if (err)
-				pr_err("dmaengine: failed to get %s: (%d)",
-				       dev_name(&chan->dev), err);
-			else
-				break;
-		} else
-			pr_debug("%s: %s filter said false\n",
-				 __func__, dev_name(&chan->dev));
 		chan = NULL;
 	}
 	mutex_unlock(&dma_list_mutex);
@@ -912,6 +915,4 @@ static int __init dma_bus_init(void)
 	mutex_init(&dma_list_mutex);
 	return class_register(&dma_devclass);
 }
-subsys_initcall(dma_bus_init);
-
-
+arch_initcall(dma_bus_init);

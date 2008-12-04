Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbYLDAvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbYLDAvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbYLDArN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:47:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:15265 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057AbYLDArL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:47:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,710,1220252400"; 
   d="scan'208";a="86212516"
Subject: [PATCH 3/4] dmaengine: advertise all channels on a device to
	dma_filter_fn
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Wed, 03 Dec 2008 17:46:56 -0700
Message-ID: <20081204004656.27790.18182.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
References: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow dma_filter_fn routines to disambiguate multiple channels on a device
rather than assuming that all channels on a device are equal.

Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/dmaengine.c |   33 +++++++++++++--------------------
 1 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 4b7ffb7..f4a640d 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -452,10 +452,10 @@ static void dma_channel_rebalance(void)
 		}
 }
 
-static struct dma_chan *private_candidate(dma_cap_mask_t *mask, struct dma_device *dev)
+static struct dma_chan *private_candidate(dma_cap_mask_t *mask, struct dma_device *dev,
+					  dma_filter_fn fn, void *fn_param)
 {
 	struct dma_chan *chan;
-	struct dma_chan *ret = NULL;
 
 	/* devices with multiple channels need special handling as we need to
 	 * ensure that all channels are either private or public.
@@ -478,11 +478,15 @@ static struct dma_chan *private_candidate(dma_cap_mask_t *mask, struct dma_devic
 				 __func__, dma_chan_name(chan));
 			continue;
 		}
-		ret = chan;
-		break;
+		if (fn && !fn(chan, fn_param)) {
+			pr_debug("%s: %s filter said false\n",
+				 __func__, dma_chan_name(chan));
+			continue;
+		}
+		return chan;
 	}
 
-	return ret;
+	return NULL;
 }
 
 /**
@@ -495,22 +499,13 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 {
 	struct dma_device *device, *_d;
 	struct dma_chan *chan = NULL;
-	bool ack;
 	int err;
 
 	/* Find a channel */
 	mutex_lock(&dma_list_mutex);
 	list_for_each_entry_safe(device, _d, &dma_device_list, global_node) {
-		chan = private_candidate(mask, device);
-		if (!chan)
-			continue;
-
-		if (fn)
-			ack = fn(chan, fn_param);
-		else
-			ack = true;
-
-		if (ack) {
+		chan = private_candidate(mask, device, fn, fn_param);
+		if (chan) {
 			/* Found a suitable channel, try to grab, prep, and
 			 * return it.  We first set DMA_PRIVATE to disable
 			 * balance_ref_count as this channel will not be
@@ -528,10 +523,8 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 				       dma_chan_name(chan), err);
 			else
 				break;
-		} else
-			pr_debug("%s: %s filter said false\n",
-				 __func__, dma_chan_name(chan));
-		chan = NULL;
+			chan = NULL;
+		}
 	}
 	mutex_unlock(&dma_list_mutex);
 


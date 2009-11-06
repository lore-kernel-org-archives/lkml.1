Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbZKFW0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbZKFW0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760244AbZKFWZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:25:54 -0500
Received: from kroah.org ([198.145.64.141]:57197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759931AbZKFWXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:41 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:51 2009
Message-Id: <20091106221551.539852739@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>, Mel Gorman <mel@csn.ul.ie>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [91/99] iwlwifi: reduce noise when skb allocation fails
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=iwlwifi-reduce-noise-when-skb-allocation-fails.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Reinette Chatre <reinette.chatre@intel.com>

commit f82a924cc88a5541df1d4b9d38a0968cd077a051 upstream.

Replenishment of receive buffers is done in the tasklet handling
received frames as well as in a workqueue. When we are in the tasklet
we cannot sleep and thus attempt atomic skb allocations. It is generally
not a big problem if this fails since iwl_rx_allocate is always followed
by a call to iwl_rx_queue_restock which will queue the work to replenish
the buffers at a time when sleeping is allowed.

We thus add the __GFP_NOWARN to the skb allocation in iwl_rx_allocate to
reduce the noise if such an allocation fails while we still have enough
buffers. We do maintain the warning and the error message when we are low
on buffers to communicate to the user that there is a potential problem with
memory availability on system

This addresses issue reported upstream in thread "iwlagn: order 2 page
allocation failures" in
http://thread.gmane.org/gmane.linux.kernel.wireless.general/39187

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   10 +++++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 ++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1208,11 +1208,18 @@ static void iwl3945_rx_allocate(struct i
 		}
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
+		if (rxq->free_count > RX_LOW_WATERMARK)
+			priority |= __GFP_NOWARN;
 		/* Alloc a new receive buffer */
 		skb = alloc_skb(priv->hw_params.rx_buf_size, priority);
 		if (!skb) {
 			if (net_ratelimit())
-				IWL_CRIT(priv, ": Can not allocate SKB buffers\n");
+				IWL_DEBUG_INFO(priv, "Failed to allocate SKB buffer.\n");
+			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
+			    net_ratelimit())
+				IWL_CRIT(priv, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
+					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
+					 rxq->free_count);
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -250,12 +250,20 @@ void iwl_rx_allocate(struct iwl_priv *pr
 		}
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
+		if (rxq->free_count > RX_LOW_WATERMARK)
+			priority |= __GFP_NOWARN;
 		/* Alloc a new receive buffer */
 		skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
 						priority);
 
 		if (!skb) {
-			IWL_CRIT(priv, "Can not allocate SKB buffers\n");
+			if (net_ratelimit())
+				IWL_DEBUG_INFO(priv, "Failed to allocate SKB buffer.\n");
+			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
+			    net_ratelimit())
+				IWL_CRIT(priv, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
+					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
+					 rxq->free_count);
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */



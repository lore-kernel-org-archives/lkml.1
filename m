Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZIIUFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZIIUFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZIIUFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:05:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:25958 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbZIIUFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:05:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185854547"
Subject: Re: iwlagn: order 2 page allocation failures
From: reinette chatre <reinette.chatre@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "Krauss, Assaf" <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>
In-Reply-To: <20090909165545.GK24614@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl>
	 <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie>
	 <200909091759.33655.elendil@planet.nl>  <20090909165545.GK24614@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 13:05:38 -0700
Message-Id: <1252526738.30150.91.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel and Frans, 

Thank you very much for digging into this.

On Wed, 2009-09-09 at 09:55 -0700, Mel Gorman wrote:
> Conceivably a better candidate for this problem is commit
> 4752c93c30441f98f7ed723001b1a5e3e5619829 introduced in May 2009. If there
> are less than RX_QUEUE_SIZE/2 left, it starts replenishing buffers. Mohamed,
> is it absolutly necessary it use GFP_ATOMIC there? If an allocation fails,
> does it always mean frames are dropped or could it just replenish what it
> can and try again later printing a warning only if allocation failures are
> resulting in packet loss?

I agree that this patch may be the reason we are seeing this issue. We
would like to keep using GFP_ATOMIC here, but it is not necessary for an
allocation failure to be so noisy since the function doing the
allocation (iwl_rx_allocate) is always followed by a call to
iwl_rx_queue_restock which will schedule a refill if the buffers are
running low. We can thus use ___GFP_NOWARN for the allocations in
iwl_rx_allocate and leave it to the restocking to find the needed memory
when it tried its allocations using GFP_KERNEL.

I do think it is useful to let user know about these allocation
failures, even if it does not result in packet loss. Wrapping it in
net_ratelimit() will help though.

How about the patch below?

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b90adcb..f0ee72e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -252,10 +252,11 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 
 		/* Alloc a new receive buffer */
 		skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
-						priority);
+				priority | __GFP_NOWARN);
 
 		if (!skb) {
-			IWL_CRIT(priv, "Can not allocate SKB buffers\n");
+			if (net_ratelimit())
+				IWL_CRIT(priv, "Can not allocate SKB buffer.\n");
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0909668..5d9fb78 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1147,10 +1147,10 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
 		/* Alloc a new receive buffer */
-		skb = alloc_skb(priv->hw_params.rx_buf_size, priority);
+		skb = alloc_skb(priv->hw_params.rx_buf_size, priority | __GFP_NOWARN);
 		if (!skb) {
 			if (net_ratelimit())
-				IWL_CRIT(priv, ": Can not allocate SKB buffers\n");
+				IWL_CRIT(priv, "Can not allocate SKB buffer.\n");
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */



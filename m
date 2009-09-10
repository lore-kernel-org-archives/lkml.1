Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZIJJCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZIJJCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 05:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZIJJCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 05:02:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46370 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZIJJCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 05:02:04 -0400
Date: Thu, 10 Sep 2009 10:02:06 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: reinette chatre <reinette.chatre@intel.com>
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
Subject: Re: iwlagn: order 2 page allocation failures
Message-ID: <20090910090206.GA22276@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl> <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie> <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie> <1252526738.30150.91.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1252526738.30150.91.camel@rc-desk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 01:05:38PM -0700, reinette chatre wrote:
> Mel and Frans, 
> 
> Thank you very much for digging into this.
> 
> On Wed, 2009-09-09 at 09:55 -0700, Mel Gorman wrote:
> > Conceivably a better candidate for this problem is commit
> > 4752c93c30441f98f7ed723001b1a5e3e5619829 introduced in May 2009. If there
> > are less than RX_QUEUE_SIZE/2 left, it starts replenishing buffers. Mohamed,
> > is it absolutly necessary it use GFP_ATOMIC there? If an allocation fails,
> > does it always mean frames are dropped or could it just replenish what it
> > can and try again later printing a warning only if allocation failures are
> > resulting in packet loss?
> 
> I agree that this patch may be the reason we are seeing this issue. We
> would like to keep using GFP_ATOMIC here, but it is not necessary for an
> allocation failure to be so noisy since the function doing the
> allocation (iwl_rx_allocate) is always followed by a call to
> iwl_rx_queue_restock which will schedule a refill if the buffers are
> running low.

Right, so it's a "refill now if you can and defer further refilling
until later".

> We can thus use ___GFP_NOWARN for the allocations in
> iwl_rx_allocate and leave it to the restocking to find the needed memory
> when it tried its allocations using GFP_KERNEL.
> 

Would it be possible to use __GFP_NOWARN *unless* this allocation is
necessary to receive the packet?

> I do think it is useful to let user know about these allocation
> failures, even if it does not result in packet loss. Wrapping it in
> net_ratelimit() will help though.
> 

If it does not distinguish between failures causing packet loss and just a
temporary issue, I'd be worried the messages would generate bug reports and
we genuinely won't know if it's a real problem or not.

As a total aside, there is still the problem that the driver is depending on
order-2 allocations. On systems without swap, the allocation problem could be
more severe as there are fewer pages the system can use to regain contiguity.

> How about the patch below?
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
> index b90adcb..f0ee72e 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
> @@ -252,10 +252,11 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
>  
>  		/* Alloc a new receive buffer */
>  		skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
> -						priority);
> +				priority | __GFP_NOWARN);
>  

So, would it be possible here to only remove __GFP_NOWARN if this is GFP_ATOMIC
(implying we have to refill now) and the rxq->free_count is really small
e.g. <= 2?

>  		if (!skb) {
> -			IWL_CRIT(priv, "Can not allocate SKB buffers\n");
> +			if (net_ratelimit())
> +				IWL_CRIT(priv, "Can not allocate SKB buffer.\n");

Similarly, could the message either be supressed when there is enough
buffers in the RX queue or differenciate between enough buffers and
things getting tight possibly causing packet loss?

The IWL_CRIT() part even is a hint - there is no guarantee that the allocation
failure is really a critical problem.

>  			/* We don't reschedule replenish work here -- we will
>  			 * call the restock method and if it still needs
>  			 * more buffers it will schedule replenish */
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 0909668..5d9fb78 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -1147,10 +1147,10 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv, gfp_t priority)
>  		spin_unlock_irqrestore(&rxq->lock, flags);
>  
>  		/* Alloc a new receive buffer */
> -		skb = alloc_skb(priv->hw_params.rx_buf_size, priority);
> +		skb = alloc_skb(priv->hw_params.rx_buf_size, priority | __GFP_NOWARN);
>  		if (!skb) {
>  			if (net_ratelimit())
> -				IWL_CRIT(priv, ": Can not allocate SKB buffers\n");
> +				IWL_CRIT(priv, "Can not allocate SKB buffer.\n");
>  			/* We don't reschedule replenish work here -- we will
>  			 * call the restock method and if it still needs
>  			 * more buffers it will schedule replenish */
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

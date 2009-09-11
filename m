Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZIKIpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZIKIpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 04:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZIKIpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 04:45:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57746 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbZIKIpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 04:45:38 -0400
Date: Fri, 11 Sep 2009 09:45:42 +0100
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
Message-ID: <20090911084542.GA32497@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl> <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie> <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie> <1252526738.30150.91.camel@rc-desk> <20090910090206.GA22276@csn.ul.ie> <1252606547.30150.304.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1252606547.30150.304.camel@rc-desk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 11:15:47AM -0700, reinette chatre wrote:
> > > We can thus use ___GFP_NOWARN for the allocations in
> > > iwl_rx_allocate and leave it to the restocking to find the needed memory
> > > when it tried its allocations using GFP_KERNEL.
> > > 
> > 
> > Would it be possible to use __GFP_NOWARN *unless* this allocation is
> > necessary to receive the packet?
> 
> I think so.
> 
> > > I do think it is useful to let user know about these allocation
> > > failures, even if it does not result in packet loss. Wrapping it in
> > > net_ratelimit() will help though.
> > > 
> > 
> > If it does not distinguish between failures causing packet loss and just a
> > temporary issue, I'd be worried the messages would generate bug reports and
> > we genuinely won't know if it's a real problem or not.
> 
> Good point.
> 
> > 
> > As a total aside, there is still the problem that the driver is depending on
> > order-2 allocations. On systems without swap, the allocation problem could be
> > more severe as there are fewer pages the system can use to regain contiguity.
> 
> It seems that somebody did think about this in the initialization of
> max_pkt_size (which is priv->hw_params.rx_buf_size - 256). If we use
> max_pkt_size in the code that allocates the skb then the 256 added for
> alignment will not cause it to go to an order-2 allocation. I do not
> know why max_pkt_size is not used at the moment and will have to do some
> digging to find out.
> 

Thanks

> > > How about the patch below?
> > > 
> > > diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
> > > index b90adcb..f0ee72e 100644
> > > --- a/drivers/net/wireless/iwlwifi/iwl-rx.c
> > > +++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
> > > @@ -252,10 +252,11 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
> > >  
> > >  		/* Alloc a new receive buffer */
> > >  		skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
> > > -						priority);
> > > +				priority | __GFP_NOWARN);
> > >  
> > 
> > So, would it be possible here to only remove __GFP_NOWARN if this is GFP_ATOMIC
> > (implying we have to refill now) and the rxq->free_count is really small
> > e.g. <= 2?
> 
> I like your suggestion. Considering the issue I would like to remove
> __GFP_NOWARN even if it is GFP_KERNEL ... I think it is actually even
> more of a problem if we are in GFP_KERNEL and not able to allocate
> memory when running low on buffers. Also, with the queue size of 256 I
> think we can use RX_LOW_WATERMARK here, which is 8.
> 

RX_LOW_WATERMARK sounds reasonable as if that watermark is reached, the
buffer count is pretty low. With order-2 allocations, I bet the system is
beginning to grind a bit to find contiguous pages at that point as well.

I agree that it's a greater problem if the system is unable to allocate
the pages as GFP_KERNEL - prehaps to the extent where it's worth
distinguishing between GFP_KERNEL and GFP_ATOMIC failures. If GFP_KERNEL
allocations are failure, packet loss is likely and the system may not
recover, particularly if there is no swap configured.

> > 
> 
> > 
> > >  		if (!skb) {
> > > -			IWL_CRIT(priv, "Can not allocate SKB buffers\n");
> > > +			if (net_ratelimit())
> > > +				IWL_CRIT(priv, "Can not allocate SKB buffer.\n");
> > 
> > Similarly, could the message either be supressed when there is enough
> > buffers in the RX queue or differenciate between enough buffers and
> > things getting tight possibly causing packet loss?
> 
> Frans also had comments in this regard. Will do. 
> 
> > 
> > The IWL_CRIT() part even is a hint - there is no guarantee that the allocation
> > failure is really a critical problem.
> 
> Right.
> 
> How about this: 
> 
> >From bd2153dd9e4a0ad588adec38c580d67023d5587e Mon Sep 17 00:00:00 2001
> From: Reinette Chatre <reinette.chatre@intel.com>
> Date: Wed, 9 Sep 2009 15:41:00 -0700
> Subject: [PATCH] iwlwifi: reduce noise when skb allocation fails
> 
> Replenishment of receive buffers is done in the tasklet handling
> received frames as well as in a workqueue. When we are in the tasklet
> we cannot sleep and thus attempt atomic skb allocations. It is generally
> not a big problem if this fails since iwl_rx_allocate is always followed
> by a call to iwl_rx_queue_restock which will queue the work to replenish
> the buffers at a time when sleeping is allowed.
> 
> We thus add the __GFP_NOWARN to the skb allocation in iwl_rx_allocate to
> reduce the noise if such an allocation fails while we still have enough
> buffers. We do maintain the warning and the error message when we are low
> on buffers to communicate to the user that there is a potential problem with
> memory availability on system
> 
> This addresses issue reported upstream in thread "iwlagn: order 2 page
> allocation failures" in
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/39187
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-rx.c       |   12 +++++++++---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 +++++++-
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
> index b90adcb..cb50cc7 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
> @@ -250,12 +250,18 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
>  		}
>  		spin_unlock_irqrestore(&rxq->lock, flags);
>  
> +		if (rxq->free_count > RX_LOW_WATERMARK)
> +			priority |= __GFP_NOWARN;

Seems very reasonable.

>  		/* Alloc a new receive buffer */
> -		skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
> -						priority);
> +		skb = alloc_skb(priv->hw_params.rx_buf_size + 256, priority);
>  

This change appears superflous. It don't change any functionality. Looks
like the style is just being made consistent with a similar code block
elsewhere.

>  		if (!skb) {
> -			IWL_CRIT(priv, "Can not allocate SKB buffers\n");
> +			if (net_ratelimit())
> +				IWL_DEBUG_INFO("Failed to allocate SKB buffer.\n");
> +			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
> +			    net_ratelimit())
> +				IWL_CRIT(priv, "Failed to allocate SKB buffer. Only %u free buffers remaining\n",
> +					 rxq->free_count);


To get a good idea of how screwed we really are, how about?

				IWL_CRIT(priv, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining\n",
					priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
					 rxq->free_count);

>  			/* We don't reschedule replenish work here -- we will
>  			 * call the restock method and if it still needs
>  			 * more buffers it will schedule replenish */
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 0909668..0d96b17 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -1146,11 +1146,17 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv, gfp_t priority)
>  		}
>  		spin_unlock_irqrestore(&rxq->lock, flags);
>  
> +		if (rxq->free_count > RX_LOW_WATERMARK)
> +			priority |= __GFP_NOWARN;
>  		/* Alloc a new receive buffer */
>  		skb = alloc_skb(priv->hw_params.rx_buf_size, priority);
>  		if (!skb) {
>  			if (net_ratelimit())
> -				IWL_CRIT(priv, ": Can not allocate SKB buffers\n");
> +				IWL_DEBUG_INFO("Failed to allocate SKB buffer.\n");
> +			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
> +			    net_ratelimit())
> +				IWL_CRIT(priv, "Failed to allocate SKB buffer. Only %u free buffers remaining\n",
> +					 rxq->free_count);
>  			/* We don't reschedule replenish work here -- we will
>  			 * call the restock method and if it still needs
>  			 * more buffers it will schedule replenish */

Otherwise, it looks just the finest and I think it will address the
problem to some extent - in that it won't print alarming messages when
they are not needed.

The additional changes with respect to GFP_ATOMIC are optional. Whether
you do it or not.

Acked-by: Mel Gorman <mel@csn.ul.ie>

Thanks very much.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

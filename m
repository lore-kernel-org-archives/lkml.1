Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZJNQ2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZJNQ2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZJNQ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:28:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:16783 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbZJNQ2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:28:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,559,1249282800"; 
   d="scan'208";a="457425120"
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
From: reinette chatre <reinette.chatre@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20091014103002.GA5027@csn.ul.ie>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	 <20091012134328.GB8200@csn.ul.ie> <200910121932.14607.elendil@planet.nl>
	 <200910132238.40867.elendil@planet.nl>  <20091014103002.GA5027@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 09:28:00 -0700
Message-Id: <1255537680.21134.14.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Wed, 2009-10-14 at 03:30 -0700, Mel Gorman wrote:
> From 5fb9f897117bf2701f9fdebe4d008dbe34358ab9 Mon Sep 17 00:00:00 2001
> From: Mel Gorman <mel@csn.ul.ie>
> Date: Wed, 14 Oct 2009 11:19:57 +0100
> Subject: [PATCH] iwlwifi: Suppress warnings related to GFP_ATOMIC allocations that do not matter
> 
> iwlwifi refills RX buffers in two ways - a direct method using GFP_ATOMIC
> and a tasklet method using GFP_KERNEL. There are a number of RX buffers and
> there are only serious issues when there are no RX buffers left. The driver
> explicitly warns when refills are failing and the buffers are low but it
> always warns when a GFP_ATOMIC allocation fails even when there is no
> packet loss as a result.


No, it does not always warn when a GFP_ATOMIC allocation fails. Please
check earlier in iwl_rx_allocate() we have:

if (rxq->free_count > RX_LOW_WATERMARK)
	priority |= __GFP_NOWARN;

So it will suppress warnings as long as we have buffers available.

We do want to see warnings if memory is below watermark and allocation
fails - your patch prevents these warnings from appearing.

> This patch specifies __GFP_NOWARN for the direct refill method that uses
> GFP_ATOMIC. To help identify where allocation failures might be coming
> from, the stack is dumped when the RX queue is dangerously low.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> --- 
>  drivers/net/wireless/iwlwifi/iwl-rx.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl b/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
> old mode 100644
> new mode 100755
> diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
> index 8e1bb53..f91a108 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
> @@ -260,10 +260,12 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
>  			if (net_ratelimit())
>  				IWL_DEBUG_INFO(priv, "Failed to allocate SKB buffer.\n");
>  			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
> -			    net_ratelimit())
> +			    net_ratelimit()) {
>  				IWL_CRIT(priv, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
>  					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
>  					 rxq->free_count);
> +				dump_stack();
> +			}
>  			/* We don't reschedule replenish work here -- we will
>  			 * call the restock method and if it still needs
>  			 * more buffers it will schedule replenish */
> @@ -320,7 +322,7 @@ EXPORT_SYMBOL(iwl_rx_replenish);
>  
>  void iwl_rx_replenish_now(struct iwl_priv *priv)
>  {
> -	iwl_rx_allocate(priv, GFP_ATOMIC);
> +	iwl_rx_allocate(priv, GFP_ATOMIC|__GFP_NOWARN);
>  
>  	iwl_rx_queue_restock(priv);
>  }


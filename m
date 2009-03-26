Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbZCZHj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbZCZHj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZCZHjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:39:18 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34751 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZCZHjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cuDViQWa1yf8m7r3eBJRh1teFVj7Rz7x4YfUW5Yz52NNXAi+Fo5+dplisk8DdqE8xw
         lxhWn15b+qSJzVejeowQ0k7vnS+rbibZfffnkN6wH+EJFj4gJBTbJbcuBDFReS9qnMw2
         B4FE2v2paxPJshkqdx8Gg2lPZYAvPbxu3NEDs=
Date: Thu, 26 Mar 2009 07:39:09 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       r.schwebel@pengutronix.de, torvalds@linux-foundation.org,
       blaschka@linux.vnet.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090326073909.GB4204@ff.dom.local>
References: <20090325122635.GA6489@gondor.apana.org.au> <20090325225456.GA3271@ami.dom.local> <20090326024129.GA13982@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326024129.GA13982@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 10:41:29AM +0800, Herbert Xu wrote:
...
> Yes this is why my original patch that started all this is broken.
> However, this doesn't apply to my patch that open-codes __napi_complete.
...
> This should work too.  However, the fact that the following patch
> is broken means that we have bigger problems.

I agree. This should be effectively equal to the revert, so I guess
Ingo probably hit some other bug btw.

Jarek P.

> 
> net: Fix netpoll lockup in legacy receive path
> 
> When I fixed the GRO crash in the legacy receive path I used
> napi_complete to replace __napi_complete.  Unfortunately they're
> not the same when NETPOLL is enabled, which may result in us
> not calling __napi_complete at all.
> 
> What's more, we really do need to keep the __napi_complete call
> within the IRQ-off section since in theory an IRQ can occur in
> between and fill up the backlog to the maximum, causing us to
> lock up.
> 
> This patch fixes this by essentially open-coding __napi_complete.
> 
> Note we no longer need the memory barrier because this function
> is per-cpu.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index e3fe5c7..2a7f6b3 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2588,9 +2588,10 @@ static int process_backlog(struct napi_struct *napi, int quota)
>  		local_irq_disable();
>  		skb = __skb_dequeue(&queue->input_pkt_queue);
>  		if (!skb) {
> +			list_del(&napi->poll_list);
> +			clear_bit(NAPI_STATE_SCHED, &napi->state);
>  			local_irq_enable();
> -			napi_complete(napi);
> -			goto out;
> +			break;
>  		}
>  		local_irq_enable();
>  
> @@ -2599,7 +2600,6 @@ static int process_backlog(struct napi_struct *napi, int quota)
>  
>  	napi_gro_flush(napi);
>  
> -out:
>  	return work;
>  }
> 
> Thanks,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

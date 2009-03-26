Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbZCZAKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbZCZAKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZCZAKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:10:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33998
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbZCZAKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:10:31 -0400
Date: Wed, 25 Mar 2009 17:10:19 -0700 (PDT)
Message-Id: <20090325.171019.56283101.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: herbert@gondor.apana.org.au, mingo@elte.hu, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090325225456.GA3271@ami.dom.local>
References: <20090325122635.GA6489@gondor.apana.org.au>
	<20090325225456.GA3271@ami.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Wed, 25 Mar 2009 23:54:56 +0100

Ingo, in case it isn't completely obvious, it would be
wonderful if you could try Jarek's patch below with your
test case.

Thanks!

> Herbert Xu wrote, On 03/25/2009 01:26 PM:
> 
> > On Wed, Mar 25, 2009 at 01:20:46PM +0100, Ingo Molnar wrote:
> >> ok - i have started testing the delta below, on top of the plain 
> >> revert.
> > 
> > Thanks! BTW Ingo, any chance you could help us identify the problem
> > with the previous patch? I don't have a forcedeth machine here
> > and the hang you had with my patch that open-coded __napi_complete
> > appears intimately connected to forcedeth (with NAPI enabled).
> 
> Of course it's too late for verifying this now, but (for the future)
> I think, this scenario could be considered:
> 
> process_backlog()			netif_rx()
> 
> if (!skb)
> local_irq_enable()
> 					if (queue.qlen) //NO
> 					napi_schedule() //NOTHING
> 					__skb_queue_tail() //qlen > 0
> napi_complete()
> ...					...
> 					Every next netif_rx() sees
> 					qlen > 0, so napi is never
> 					scheduled again.
> 
> Then, something like this might work...
> 
> Jarek P.
> --- (2.6.29)
>  net/core/dev.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index e3fe5c7..cf53c24 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2589,7 +2589,11 @@ static int process_backlog(struct napi_struct *napi, int quota)
>  		skb = __skb_dequeue(&queue->input_pkt_queue);
>  		if (!skb) {
>  			local_irq_enable();
> -			napi_complete(napi);
> +			napi_gro_flush(napi);
> +			local_irq_disable();
> +			if (skb_queue_empty(&queue->input_pkt_queue))
> +				__napi_complete(napi);
> +			local_irq_enable();
>  			goto out;
>  		}
>  		local_irq_enable();

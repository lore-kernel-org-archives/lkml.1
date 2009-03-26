Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbZCZCmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbZCZCmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZCZCm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:42:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:54488 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751039AbZCZCm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:42:28 -0400
Date: Thu, 26 Mar 2009 10:41:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       r.schwebel@pengutronix.de, torvalds@linux-foundation.org,
       blaschka@linux.vnet.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090326024129.GA13982@gondor.apana.org.au>
References: <20090325122635.GA6489@gondor.apana.org.au> <20090325225456.GA3271@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325225456.GA3271@ami.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 11:54:56PM +0100, Jarek Poplawski wrote:
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

Yes this is why my original patch that started all this is broken.
However, this doesn't apply to my patch that open-codes __napi_complete.

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

This should work too.  However, the fact that the following patch
is broken means that we have bigger problems.

net: Fix netpoll lockup in legacy receive path

When I fixed the GRO crash in the legacy receive path I used
napi_complete to replace __napi_complete.  Unfortunately they're
not the same when NETPOLL is enabled, which may result in us
not calling __napi_complete at all.

What's more, we really do need to keep the __napi_complete call
within the IRQ-off section since in theory an IRQ can occur in
between and fill up the backlog to the maximum, causing us to
lock up.

This patch fixes this by essentially open-coding __napi_complete.

Note we no longer need the memory barrier because this function
is per-cpu.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/core/dev.c b/net/core/dev.c
index e3fe5c7..2a7f6b3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2588,9 +2588,10 @@ static int process_backlog(struct napi_struct *napi, int quota)
 		local_irq_disable();
 		skb = __skb_dequeue(&queue->input_pkt_queue);
 		if (!skb) {
+			list_del(&napi->poll_list);
+			clear_bit(NAPI_STATE_SCHED, &napi->state);
 			local_irq_enable();
-			napi_complete(napi);
-			goto out;
+			break;
 		}
 		local_irq_enable();
 
@@ -2599,7 +2600,6 @@ static int process_backlog(struct napi_struct *napi, int quota)
 
 	napi_gro_flush(napi);
 
-out:
 	return work;
 }

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

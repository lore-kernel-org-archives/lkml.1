Return-Path: <linux-kernel-owner+w=401wt.eu-S1759523AbZCYMKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523AbZCYMKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761271AbZCYMJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:09:31 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:36612 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761270AbZCYMJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:09:30 -0400
Date: Wed, 25 Mar 2009 20:08:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090325120840.GA6351@gondor.apana.org.au>
References: <20090324150928.GB30224@gondor.apana.org.au> <20090324.143622.186562202.davem@davemloft.net> <20090325002303.GA2219@gondor.apana.org.au> <20090324.191134.05205089.davem@davemloft.net> <20090325073349.GF25833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325073349.GF25833@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 08:33:49AM +0100, Ingo Molnar wrote:
> 
> So if there's no definitive resolution for the real cause of the 
> bug, the plain revert looks like an acceptable interim choice for 
> .29.1 - at least as far as my systems go.

OK, let's just do the revert and disable GRO for the legacy path.
This should be the safest option for 2.6.29.

GRO: Disable GRO on legacy netif_rx path

When I fixed the GRO crash in the legacy receive path I used
napi_complete to replace __napi_complete.  Unfortunately they're
not the same when NETPOLL is enabled, which may result in us
not calling __napi_complete at all.

What's more, we really do need to keep the __napi_complete call
within the IRQ-off section since in theory an IRQ can occur in
between and fill up the backlog to the maximum, causing us to
lock up.

Since we can't seem to find a fix that works properly right now,
this patch reverts all the GRO support from the netif_rx path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/core/dev.c b/net/core/dev.c
index e3fe5c7..e438f54 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2588,18 +2588,15 @@ static int process_backlog(struct napi_struct *napi, int quota)
 		local_irq_disable();
 		skb = __skb_dequeue(&queue->input_pkt_queue);
 		if (!skb) {
+			__napi_complete(napi);
 			local_irq_enable();
-			napi_complete(napi);
-			goto out;
+			break;
 		}
 		local_irq_enable();
 
-		napi_gro_receive(napi, skb);
+		netif_receive_skb(skb);
 	} while (++work < quota && jiffies == start_time);
 
-	napi_gro_flush(napi);
-
-out:
 	return work;
 }
 
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

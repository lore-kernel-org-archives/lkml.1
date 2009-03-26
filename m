Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbZCZJSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbZCZJSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZCZJSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:18:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:14812 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZCZJSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vXWnRE7IuVBvCi5q2MQToPAe83P+JqSDy8BfAg9C0Gk8P0gkgmD29vu14/gTwsueEG
         pECroeGXaPbZVfvCElNBHIJGVFtVBDyWKvOWlY3oCDYLfoEsxtiyKQJf+ZwUfWGepaq6
         LYS8VAY6Juxp/6Q5C+p99BVp51u91JXPd3oKc=
Date: Thu, 26 Mar 2009 09:18:08 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, mingo@elte.hu, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de,
       Adam Richter <adam_richter2004@yahoo.com>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090326091808.GD4204@ff.dom.local>
References: <20090325122635.GA6489@gondor.apana.org.au> <20090325225456.GA3271@ami.dom.local> <20090326024129.GA13982@gondor.apana.org.au> <20090325.202050.08183381.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325.202050.08183381.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 08:20:50PM -0700, David Miller wrote:
...
> Adam Richter has successfully tested Jarek's variant, and if Ingo's
> tests show that it makes his problem go away too then I'm definitely
> going with Jarek's patch.

I hope this patch version on top of Herbert's revert could be useful
then.

Thanks,
Jarek P.
-------------------->
GRO: Re-enable GRO on legacy netif_rx path.

Replacing __napi_complete() with napi_complete() in process_backlog()
caused various breaks for non-napi NICs. It looks like the following
scenario can happen:

process_backlog()			netif_rx()

if (!skb)
local_irq_enable()
					if (queue.qlen) //NO
					napi_schedule() //NOTHING
					__skb_queue_tail() //qlen > 0
napi_complete()
...					...
					Every next netif_rx() sees
					qlen > 0, so napi is never
					scheduled again.

This patch fixes it by open-coding napi_complete() with additional
check for empty queue before __napi_complete().

With help of debugging by Ingo Molnar, Sascha Hauer and Herbert Xu.

Reported-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Adam Richter <adam_richter2004@yahoo.com>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---
(vs. 2.6.29 with Herbert's "GRO: Disable GRO on legacy netif_rx path")

diff -Nurp a/net/core/dev.c b/net/core/dev.c
--- a/net/core/dev.c	2009-03-26 08:32:51.000000000 +0000
+++ b/net/core/dev.c	2009-03-26 08:37:58.000000000 +0000
@@ -2588,15 +2588,22 @@ static int process_backlog(struct napi_s
 		local_irq_disable();
 		skb = __skb_dequeue(&queue->input_pkt_queue);
 		if (!skb) {
-			__napi_complete(napi);
 			local_irq_enable();
-			break;
+			napi_gro_flush(napi);
+			local_irq_disable();
+			if (skb_queue_empty(&queue->input_pkt_queue))
+				__napi_complete(napi);
+			local_irq_enable();
+			goto out;
 		}
 		local_irq_enable();
 
-		netif_receive_skb(skb);
+		napi_gro_receive(napi, skb);
 	} while (++work < quota && jiffies == start_time);
 
+	napi_gro_flush(napi);
+
+out:
 	return work;
 }
 

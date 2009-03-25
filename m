Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbZCYMVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbZCYMVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbZCYMVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:21:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53768 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbZCYMVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:21:08 -0400
Date: Wed, 25 Mar 2009 13:20:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090325122046.GD11571@elte.hu>
References: <20090324150928.GB30224@gondor.apana.org.au> <20090324.143622.186562202.davem@davemloft.net> <20090325002303.GA2219@gondor.apana.org.au> <20090324.191134.05205089.davem@davemloft.net> <20090325073349.GF25833@elte.hu> <20090325120840.GA6351@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325120840.GA6351@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Mar 25, 2009 at 08:33:49AM +0100, Ingo Molnar wrote:
> > 
> > So if there's no definitive resolution for the real cause of the 
> > bug, the plain revert looks like an acceptable interim choice for 
> > .29.1 - at least as far as my systems go.
> 
> OK, let's just do the revert and disable GRO for the legacy path.
> This should be the safest option for 2.6.29.

ok - i have started testing the delta below, on top of the plain 
revert.

	Ingo

diff --git a/net/core/dev.c b/net/core/dev.c
index c1e9dc0..e438f54 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2594,11 +2594,9 @@ static int process_backlog(struct napi_struct *napi, int quota)
 		}
 		local_irq_enable();
 
-		napi_gro_receive(napi, skb);
+		netif_receive_skb(skb);
 	} while (++work < quota && jiffies == start_time);
 
-	napi_gro_flush(napi);
-
 	return work;
 }
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZCZJJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZCZJJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbZCZJIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:08:36 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:38448 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755986AbZCZJI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:08:26 -0400
Date: Thu, 26 Mar 2009 17:07:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090326090744.GA16665@gondor.apana.org.au>
References: <20090324150928.GB30224@gondor.apana.org.au> <20090324.143622.186562202.davem@davemloft.net> <20090325002303.GA2219@gondor.apana.org.au> <20090324.191134.05205089.davem@davemloft.net> <20090325073349.GF25833@elte.hu> <20090325120840.GA6351@gondor.apana.org.au> <20090325122046.GD11571@elte.hu> <20090325122635.GA6489@gondor.apana.org.au> <20090325220149.GB21111@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325220149.GB21111@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 11:01:49PM +0100, Ingo Molnar wrote:
> 
> Sure, can try that. Probably the best would be if you sent me a 
> combo patch with the precise patch you meant me to try (there were 
> several patches, i'm not sure which one is the 'previous' one) plus 
> the forcedeth debug enable change as well.

Sure, here's the patch to do both.

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

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index b8251e8..101e552 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -64,7 +64,7 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#if 0
+#if 1
 #define dprintk			printk
 #else
 #define dprintk(x...)		do { } while (0)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

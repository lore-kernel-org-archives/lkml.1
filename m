Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbZCXPK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbZCXPK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZCXPKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:10:21 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:46307 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751525AbZCXPKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:10:20 -0400
Date: Tue, 24 Mar 2009 23:09:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090324150928.GB30224@gondor.apana.org.au>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu> <20090324143303.GP5367@pengutronix.de> <20090324143942.GA20462@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324143942.GA20462@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 03:39:42PM +0100, Ingo Molnar wrote:
>
> Subject: [PATCH] net: Fix netpoll lockup in legacy receive path

Actually, this patch is still racy.  If some interrupt comes in
and we suddenly get the maximum amount of backlog we can still
hang when we call __napi_complete incorrectly.  It's unlikely
but we certainly shouldn't allow that.  Here's a better version.

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

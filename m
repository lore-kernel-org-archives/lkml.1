Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZCYW4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZCYW4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbZCYW4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:56:04 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:34500 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbZCYW4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=jRxHj2Vu4GHTwApKPKtZU5s9NUxD5H2/AaGGsOhmiqNvhYkYcubWOBHFhhGpuxgeeU
         d17tz6FeoCi68DK6RWfPK2XwgrhmlewMJJ3Am0BO+zzZ+V6C1uJ7Jpngop6C42WnEMa8
         GzEBcxU6NkA9SG0I+dnvI7QMrQeUnX2ilqPwQ=
Date: Wed, 25 Mar 2009 23:54:56 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       r.schwebel@pengutronix.de, torvalds@linux-foundation.org,
       blaschka@linux.vnet.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090325225456.GA3271@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325122635.GA6489@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote, On 03/25/2009 01:26 PM:

> On Wed, Mar 25, 2009 at 01:20:46PM +0100, Ingo Molnar wrote:
>> ok - i have started testing the delta below, on top of the plain 
>> revert.
> 
> Thanks! BTW Ingo, any chance you could help us identify the problem
> with the previous patch? I don't have a forcedeth machine here
> and the hang you had with my patch that open-coded __napi_complete
> appears intimately connected to forcedeth (with NAPI enabled).

Of course it's too late for verifying this now, but (for the future)
I think, this scenario could be considered:

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

Then, something like this might work...

Jarek P.
--- (2.6.29)
 net/core/dev.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e3fe5c7..cf53c24 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2589,7 +2589,11 @@ static int process_backlog(struct napi_struct *napi, int quota)
 		skb = __skb_dequeue(&queue->input_pkt_queue);
 		if (!skb) {
 			local_irq_enable();
-			napi_complete(napi);
+			napi_gro_flush(napi);
+			local_irq_disable();
+			if (skb_queue_empty(&queue->input_pkt_queue))
+				__napi_complete(napi);
+			local_irq_enable();
 			goto out;
 		}
 		local_irq_enable();

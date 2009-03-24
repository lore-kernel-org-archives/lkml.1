Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbZCXNge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbZCXNge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbZCXNgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:36:25 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:36283 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753666AbZCXNgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:36:25 -0400
Date: Tue, 24 Mar 2009 21:35:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090324133542.GA29046@gondor.apana.org.au>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324130202.GA32469@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 02:02:02PM +0100, Ingo Molnar wrote:
> 
> Yesterday about half of my testboxes (3 out of 7) started getting 
> weird networking failures: their network interface just got stuck 
> completely - no rx and no tx at all. Restarting the interface did 
> not help.

Darn, does this patch help?

net: Fix netpoll lockup in legacy receive path

When I fixed the GRO crash in the legacy receive path I used
napi_complete to replace __napi_complete.  Unfortunately they're
not the same when NETPOLL is enabled, which may result in us
not calling __napi_complete at all.

While this is fishy in itself, let's make the obvious fix right
now of reverting to the previous state where we always called
__napi_complete.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/core/dev.c b/net/core/dev.c
index e3fe5c7..523f53e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2580,24 +2580,26 @@ static int process_backlog(struct napi_struct *napi, int quota)
 	int work = 0;
 	struct softnet_data *queue = &__get_cpu_var(softnet_data);
 	unsigned long start_time = jiffies;
+	struct sk_buff *skb;
 
 	napi->weight = weight_p;
 	do {
-		struct sk_buff *skb;
-
 		local_irq_disable();
 		skb = __skb_dequeue(&queue->input_pkt_queue);
-		if (!skb) {
-			local_irq_enable();
-			napi_complete(napi);
-			goto out;
-		}
 		local_irq_enable();
+		if (!skb)
+			break;
 
 		napi_gro_receive(napi, skb);
 	} while (++work < quota && jiffies == start_time);
 
 	napi_gro_flush(napi);
+	if (skb)
+		goto out;
+
+	local_irq_disable();
+	__napi_complete(napi);
+	local_irq_enable();
 
 out:
 	return work;

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0CAPSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:18:25 -0500
Received: from a.mx.secunet.com ([213.68.205.161]:52254 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab0CAPSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:18:23 -0500
X-Greylist: delayed 1404 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2010 10:18:23 EST
Date: Mon, 1 Mar 2010 15:55:19 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: tip: origin tree boot crash
Message-ID: <20100301145519.GB20729@secunet.com>
References: <20081225001724.GA2813@gondor.apana.org.au>
 <20081225002020.GA2912@gondor.apana.org.au>
 <20090324044932.GA18245@gondor.apana.org.au>
 <20091204135530.GA29371@gondor.apana.org.au>
 <20100226004914.GA20812@gondor.apana.org.au>
 <20100301075024.GA4753@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301075024.GA4753@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Mar 2010 14:54:55.0923 (UTC) FILETIME=[2810E030:01CAB94F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Mar 01, 2010 at 08:50:24AM +0100, Ingo Molnar wrote:
> 
> Hi,
> 
> * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> >       crypto: pcrypt - Add pcrypt crypto parallelization wrapper
> 
> -tip testing started triggering the following frequent boot crash yesterday, 
> on 64-bit x86:
> 
>  |  calling  pcrypt_init+0x0/0xee @ 1
>  |  BUG: unable to handle kernel NULL pointer dereference at (null)
>  |  IP: [<ffffffff8126550b>] memcpy+0xb/0xb0
>  |  Call Trace:
>  |   [<ffffffff810c2f38>] ? padata_alloc+0x98/0x150
>  |   [<ffffffff82158c51>] ? pcrypt_init+0x0/0xee
>  |   [<ffffffff82158ccc>] pcrypt_init+0x7b/0xee
> 

Ugh, it seems that I forgot to allocate one of the cpumasks. Looking at the
configs of my test systems I noticed, that CONFIG_CPUMASK_OFFSTACK was
not set on all the configs, so I did not notice it.

The patch below fixes the boot crash if CONFIG_CPUMASK_OFFSTACK is
enabled on my test systems. Does the patch fix it for you too?

Thanks,

Steffen

Subject: [PATCH] padata: allocate the cpumask for the padata instance

The cpumask of the padata instance was used without allocated.
This caused boot crashes if CONFIG_CPUMASK_OFFSTACK is enabled.
This patch fixes this by doing proper allocation for this cpumask.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 6f9bcb8..93caf65 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -642,6 +642,9 @@ struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 	if (!pd)
 		goto err_free_inst;
 
+	if (!alloc_cpumask_var(&pinst->cpumask, GFP_KERNEL))
+		goto err_free_pd;
+
 	rcu_assign_pointer(pinst->pd, pd);
 
 	pinst->wq = wq;
@@ -654,12 +657,14 @@ struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 	pinst->cpu_notifier.priority = 0;
 	err = register_hotcpu_notifier(&pinst->cpu_notifier);
 	if (err)
-		goto err_free_pd;
+		goto err_free_cpumask;
 
 	mutex_init(&pinst->lock);
 
 	return pinst;
 
+err_free_cpumask:
+	free_cpumask_var(pinst->cpumask);
 err_free_pd:
 	padata_free_pd(pd);
 err_free_inst:
@@ -685,6 +690,7 @@ void padata_free(struct padata_instance *pinst)
 
 	unregister_hotcpu_notifier(&pinst->cpu_notifier);
 	padata_free_pd(pinst->pd);
+	free_cpumask_var(pinst->cpumask);
 	kfree(pinst);
 }
 EXPORT_SYMBOL(padata_free);
-- 
1.5.6.5


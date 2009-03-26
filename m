Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZCZGne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZCZGne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 02:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZCZGn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 02:43:26 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54227 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZCZGnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 02:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nzkX+l5zWUH1squbTUTixsFXYtzxA/cZG6zz9bWq62ekQfNLGKoZCIU326zODQ98U5
         76n6WyB6uvs19HyYhpOVrvlmhNOEeP/cib26vAUetgk3wsqYDuz/TN5uOs/nvmwbAMEx
         FYoiAtFBzH0j9CcIrKwrn7u6qOzVPnkKr7JEI=
Date: Thu, 26 Mar 2009 06:43:17 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, mingo@elte.hu, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090326064317.GA4204@ff.dom.local>
References: <20090325122635.GA6489@gondor.apana.org.au> <20090325225456.GA3271@ami.dom.local> <20090325.171019.56283101.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325.171019.56283101.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 05:10:19PM -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Wed, 25 Mar 2009 23:54:56 +0100
> 
> Ingo, in case it isn't completely obvious, it would be
> wonderful if you could try Jarek's patch below with your
> test case.
> 
> Thanks!

David, of course testing my patch would be very nice, but I think we
should definitely & immediately have this tested already Herbert's
revert patch in -stable now. 

Thanks,
Jarek P.

> 
> > Herbert Xu wrote, On 03/25/2009 01:26 PM:
> > 
> > > On Wed, Mar 25, 2009 at 01:20:46PM +0100, Ingo Molnar wrote:
> > >> ok - i have started testing the delta below, on top of the plain 
> > >> revert.
> > > 
> > > Thanks! BTW Ingo, any chance you could help us identify the problem
> > > with the previous patch? I don't have a forcedeth machine here
> > > and the hang you had with my patch that open-coded __napi_complete
> > > appears intimately connected to forcedeth (with NAPI enabled).
> > 
> > Of course it's too late for verifying this now, but (for the future)
> > I think, this scenario could be considered:
> > 
> > process_backlog()			netif_rx()
> > 
> > if (!skb)
> > local_irq_enable()
> > 					if (queue.qlen) //NO
> > 					napi_schedule() //NOTHING
> > 					__skb_queue_tail() //qlen > 0
> > napi_complete()
> > ...					...
> > 					Every next netif_rx() sees
> > 					qlen > 0, so napi is never
> > 					scheduled again.
> > 
> > Then, something like this might work...
> > 
> > Jarek P.
> > --- (2.6.29)
> >  net/core/dev.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index e3fe5c7..cf53c24 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -2589,7 +2589,11 @@ static int process_backlog(struct napi_struct *napi, int quota)
> >  		skb = __skb_dequeue(&queue->input_pkt_queue);
> >  		if (!skb) {
> >  			local_irq_enable();
> > -			napi_complete(napi);
> > +			napi_gro_flush(napi);
> > +			local_irq_disable();
> > +			if (skb_queue_empty(&queue->input_pkt_queue))
> > +				__napi_complete(napi);
> > +			local_irq_enable();
> >  			goto out;
> >  		}
> >  		local_irq_enable();

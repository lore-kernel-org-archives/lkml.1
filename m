Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXHMW2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXHMW2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760860AbXHMW2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:28:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48181 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760663AbXHMW2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:28:03 -0400
Date: Mon, 13 Aug 2007 15:28:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Martin Bligh <mbligh@mbligh.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality,
 performance and maintenance
In-Reply-To: <20070813221847.GA20314@Krystal>
Message-ID: <Pine.LNX.4.64.0708131523020.28626@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <p73y7hrywel.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0707090845520.13792@schroedinger.engr.sgi.com>
 <46925B5D.8000507@google.com> <Pine.LNX.4.64.0707091055090.16207@schroedinger.engr.sgi.com>
 <4692A1D0.50308@mbligh.org> <20070709214426.GC1026@Krystal>
 <Pine.LNX.4.64.0707091451200.18780@schroedinger.engr.sgi.com>
 <20070709225817.GA5111@Krystal> <Pine.LNX.4.64.0707091715450.2062@schroedinger.engr.sgi.com>
 <20070813221847.GA20314@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Mathieu Desnoyers wrote:

> > @@ -1554,23 +1564,20 @@ static void __always_inline *slab_alloc(
> >  		gfp_t gfpflags, int node, void *addr)
> >  {
> >  	void **object;
> > -	unsigned long flags;
> >  	struct kmem_cache_cpu *c;
> >  
> 
> What if we prefetch c->freelist here ? I see in this diff that the other
> code just reads it sooner as a condition for the if().

Not sure as to what this may bring. If you read it earlier then you may 
get the wrong value and then may have to refetch the cacheline.

We cannot fetch c->freelist without determining c. I can remove the 
check for c->page == page so that the fetch of c->freelist comes 
immeidately after detemination of c. But that does not change performance.

> > -		c->freelist = object;
> > -	} else
> > -		__slab_free(s, page, x, addr, c->offset);
> > +redo:
> > +	freelist = c->freelist;
> 
> I suspect this smp_rmb() may be the cause of a major slowdown.
> Therefore, I think we should try taking a copy of c->page and simply
> check if it has changed right after the cmpxchg_local:

Thought so too and I removed that smp_rmb and tested this modification 
on UP again without any performance gains. I think the cacheline fetches 
dominates the execution thread here and cmpxchg does not bring us 
anything.

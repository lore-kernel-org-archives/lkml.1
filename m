Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbZFBH1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbZFBH1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758316AbZFBH05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:26:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37230 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbZFBH05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:26:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=eMg9aVjTp38DkYKuECKHkiS1tNuuamZEdEcEIc5JSJhE4RZVt/SyTdbbqX2dUdFGj
	Bfppm2oW7UXS0VDLN2j8w==
Date: Tue, 2 Jun 2009 00:26:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <20090601225602.3482cd0d.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0906020016060.24915@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com> <alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com> <20090601225602.3482cd0d.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009, Andrew Morton wrote:

> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1547,7 +1547,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
> >  		goto out;
> >  
> >  	/* The OOM killer will not help higher order allocs */
> > -	if (order > PAGE_ALLOC_COSTLY_ORDER)
> > +	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_NOFAIL))
> >  		goto out;
> >  
> >  	/* Exhausted what can be done so it's blamo time */
> > @@ -1765,11 +1765,13 @@ rebalance:
> >  				goto got_pg;
> >  
> >  			/*
> > -			 * The OOM killer does not trigger for high-order allocations
> > -			 * but if no progress is being made, there are no other
> > -			 * options and retrying is unlikely to help
> > +			 * The OOM killer does not trigger for high-order
> > +			 * ~__GFP_NOFAIL allocations so if no progress is being
> > +			 * made, there are no other options and retrying is
> > +			 * unlikely to help.
> >  			 */
> > -			if (order > PAGE_ALLOC_COSTLY_ORDER)
> > +			if (order > PAGE_ALLOC_COSTLY_ORDER &&
> > +						!(gfp_mask & __GFP_NOFAIL))
> >  				goto nopage;
> >  
> >  			goto restart;
> 
> I really think/hope/expect that this is unneeded.
> 
> Do we know of any callsites which do greater-than-order-0 allocations
> with GFP_NOFAIL?  If so, we should fix them.
> 
> Then just ban order>0 && GFP_NOFAIL allocations.
> 

That seems like a different topic: banning higher-order __GFP_NOFAIL 
allocations or just deprecating __GFP_NOFAIL altogether and slowly 
switching users over is a worthwhile effort, but is unrelated.

This patch is necessary because we explicitly deny the oom killer from 
being used when the order is greater than PAGE_ALLOC_COSTLY_ORDER because 
of an assumption that it won't help.  That assumption isn't always true, 
especially for large memory-hogging tasks that have mlocked large chunks 
of contiguous memory, for example.  The only thing we do know is that 
direct reclaim has not made any progress so we're unlikely to get a 
substantial amount of memory freeing in the immediate future.  Such an 
instance will simply loop forever without killing that rogue task for a 
__GFP_NOFAIL allocation.

So while it's better in the long-term to deprecate the flag as much as 
possible and perhaps someday remove it from the page allocator entirely, 
we're faced with the current behavior of either looping endlessly or 
freeing memory so the kernel allocation may succeed when direct reclaim 
has failed, which also makes this a rare instance where the oom killer 
will never needlessly kill a task.

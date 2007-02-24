Return-Path: <linux-kernel-owner+w=401wt.eu-S933302AbXBXBIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbXBXBIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 20:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933307AbXBXBIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 20:08:31 -0500
Received: from ns2.suse.de ([195.135.220.15]:40259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933302AbXBXBIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 20:08:30 -0500
Date: Sat, 24 Feb 2007 02:08:11 +0100
From: Nick Piggin <npiggin@suse.de>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-ID: <20070224010811.GA2201@wotan.suse.de>
References: <20070223153743.GA26141@wotan.suse.de> <200702231731.17262.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702231731.17262.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 05:31:17PM +0100, Eric Dumazet wrote:
> On Friday 23 February 2007 16:37, Nick Piggin wrote:
> > The dentry hash uses up 8MB for 1 million entries on my 4GB system is one
> > of the biggest wasters of memory for me. Because I rarely have more than
> > one or two hundred thousand dentries. And that's with several kernel trees
> > worth of entries. Most desktop and probably even many types of servers will
> > only use a fraction of that.
> >
> > So I introduce a new method for resizing hash tables with RCU, and apply
> > that to the dentry hash.
> >
> > The primitive heuristic is that the hash size is doubled when the number of
> > entries reaches 150% the hash size, and halved when the number is 50%.
> > It should also be able to shrink under memory pressure, and scale up as
> > large as we go.
> >
> > A pity it uses vmalloc memory for the moment.
> >
> > The implementation is not highly stress tested, but it is running now. It
> > could do a bit more RCU stuff asynchronously rather than with
> > synchronize_rcu, but who cares, for now.
> >
> > The hash is costing me about 256K now, which is a 32x reduction in memory.
> >
> > I don't know if it's worthwhile to do this, rather than move things to
> > other data structures, but something just tempted me to have a go!  I'd be
> > interested to hear comments, and how many holes people can spot in my
> > design ;)
> >
> > Thanks,
> > Nick
> 
> Hi Nick
> 
> Thats a really good idea !
> 
> The vmalloc() thing could be a problem, so :
> 
> Could you bring back the support of 'dhash_entries=262144' boot param, so that 
> an admin could set the initial size of dhash table, (and not shrink it under 
> this size even if the number of dentries is low)

Hi Eric,

Yeah, that's a good idea. I'll look at doing that.

> In case dhash_entries is set in boot params, we could try to use 
> alloc_large_system_hash() for the initial table, (eventually using Hugepages 
> (not vmalloc)), if we add a free_large_system_hash() function to be able to 
> free the initial table.
> 
> Or else, time is to add the possibility for vmalloc() to use hugepages 
> itself...

That sounds like a nice idea to have a hugepage vmalloc for very large
allocations. The big NUMA guys already use vmalloc to allocate large hashes,
so hugepages would probably be a big win for them.

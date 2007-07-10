Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbXGJNEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbXGJNEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbXGJNEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:04:10 -0400
Received: from mail.suse.de ([195.135.220.2]:50429 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbXGJNEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:04:06 -0400
Date: Tue, 10 Jul 2007 15:03:56 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@skynet.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, kenchen@google.com,
       jschopp@austin.ibm.com, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       y-goto@jp.fujitsu.com, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans -- anti-fragmentation
Message-ID: <20070710130356.GG8779@wotan.suse.de>
References: <20070710102043.GA20303@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710102043.GA20303@skynet.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 11:20:43AM +0100, Mel Gorman wrote:
> > 
> >  Mel's page allocator work.  Might merge this, but I'm still not hearing
> >  sufficiently convincing noises from a sufficient number of people over this.
> > 
> 
> This is a long on-going story. It bounces between people who say it's not a
> complete solution and everything should have the 100% ability to defragment
> and the people on the other side that say it goes a long way to solving their
> problem. I've cc'd some of the parties that have expressed any interest in
> the last year.

And I guess some other people who want to see what prolbems there are
and what can't be solved between order-0 allocations and reserve zones.

 
> On a slightly more left of centre tact, these patches *may* help fsblock with
> large blocks although I would like to hear Nick's confirming/denying this.
> Currently if fsblock wants to work with large blocks, it uses a vmap to map
> discontiguous pages so they are virtually contiguous for the filesystem. The
> use of VMAP is never cheap, though how much of an overhead in this case is
> unknown.  If these patches were in place, fsblock could optimisically allocate
> the higher-order page and use it without vmap if it succeeded. If it fails,
> it would use vmap as a lower-performance-but-still-works fallback. This
> may tie in better with what Christoph is doing with large blocks as well
> as it may be a compromise solution between their proposals - I'm not 100%
> sure so he's cc'd as well for comment.

Yeah higher order allocations could definitely be helpful for this although
I couldn't guess at the sort of impovements at this stage. And I mean if
there was a simple choice between better (but still not perfect) support
for higher order allocations or not, then of course you would take them.
I am sure there are other places as well where they might makes life a bit
easier or performance a bit better.

But given the code involved, it is not just a simple choice, but a
tradeoff. Perhaps I haven't seen or don't realise it, but I'm still not
sure that this tradeoff is a good one. (just my opinion).


> The patches have been reviewed heavily recently by Christoph and Andy has
> looked through them as well. They've been tested for a long time in -mm so
> I would expect they not regress functionality. I've maintained that having
> the 100% ability to defragment will cost too much in terms of performance
> and would be blocked by the fact that the device driver model would have to
> be updated to never use physical addresses - a massive undertaking. I think
> this approach is more pragmatic and working on making more types of memory
> (like page tables) migratable is at least piecemeal as opposed to turning
> everything on it's head.

My comments about defragmentation of the kernel were not exactly what
I believe is the right direction to go (it may be, but I'm rally not
in a position to know without having seen or tried to implement it). But
I do think that's what would really be needed in order to really support
higher order allocations the same as order-0.

I realise in your pragmatic approach, you are encouraging users to
put fallbacks in place in case a higher order page cannot be allocated,
but I don't think either higher order pagecache or higher order slubs
have such fallbacks (fsblock or a combination of fsblock and higher
order pagecache could have, but...).
 
> >  These are slub changes which are dependent on Mel's stuff, and I have a note
> >  here that there were reports of page allocation failures with these.  What's
> >  up with that?
> > 
> 
> These is where the
> have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch and
> only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
> patches should be. There were page allocation failure reports without these
> patches but Nick felt they were not the correct solution and I tend to agree
> with him on this matter. I haven't put a massive amount of thought into it
> yet because without grouping pages by mobility, the question is pointless.

Yeah I think that was a hack.



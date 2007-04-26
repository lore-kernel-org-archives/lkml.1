Return-Path: <linux-kernel-owner+w=401wt.eu-S1031171AbXDZKsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031171AbXDZKsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031173AbXDZKsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:48:17 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:51845 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031171AbXDZKsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:48:16 -0400
Date: Thu, 26 Apr 2007 11:48:13 +0100
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426104813.GD27620@skynet.ie>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <463057D9.9030804@yahoo.com.au>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/04/07 17:42), Nick Piggin didst pronounce:
> Christoph Lameter wrote:
> >On Thu, 26 Apr 2007, Nick Piggin wrote:
> >
> >
> >>>mapping through the radix tree. You just need to change the way the
> >>>filesystem looks up pages.
> >>
> >>You didn't think any of the criticisms of higher order page cache size
> >>were valid?
> >
> >
> >They are all known points that have been discussed to death.
> 
> I missed the part where you showed that it was a better solution than
> the alternatives.
> 
> 
> >>>What are the exact requirement you are trying to address?
> >>
> >>Block size > page cache size.
> >
> >
> >But what do you mean with it? A block is no longer a contiguous section of 
> >memory. So you have redefined the term.
> 
> I don't understand what you mean at all. A block has always been a
> contiguous area of disk.
> 

Yes, but what you seem to be proposing is that lower layers be
able to treat non-contiguous pages as one IO artifact - like
non-contiguous-compound-pages. Ultimately both are probably needed. i.e.
Use contiguous pages for large blocks where possible but be able to deal
with the compound page consisting of multiple smaller pages with a
regression in performance when necessary.

I don't think what Christoph and Nick are proposing are mutually
exclusive. The arguement is really "which do we deal with first".

> 
> >>You guys have a couple of problems, firstly you need to have ia64
> >>filesystems accessable to x86_64. And secondly you have these controllers
> >>without enough sg entries for nice sized IOs.
> >
> >
> >This is not sgi specific sorry.
> >
> >
> >>I sympathise, and higher order pagecache might solve these in a way, but
> >>I don't think it is the right way to go, mainly because of the 
> >>fragmentation
> >>issues.
> >
> >
> >And you dont care about Mel's work on that level?
> 
> I actually don't like it too much because it can't provide a robust
> solution. What do you do on systems with small memories, or those that
> eventually do get fragmented?
> 

They won't be creating filesystems with large blocks for a start but
even if they did, they would need to your proposal.

Again, I don't think they are mutually exclusive as such.

> Actually, I don't know why people are so excited about being able to
> use higher order allocations (I would rather be more excited about
> never having to use them). But for those few places that really need
> it, I'd rather see them use a virtually mapped kernel with proper
> defragmentation rather than putting hacks all through the core code.
> 

That involves creating a vmalloc-like area or breaking the 1:1 physical:virtual
mapping in the kernel address space. Of those two, I think a vmalloc area
would be easier, have less performance impact and might even be a starting
point for non-contiguous-compound-pages.

hmm.

> >>Increasing PAGE_SIZE, support for block size > page cache size, and 
> >>getting
> >>io controllers matched to a 4K page size IMO would be some good ways to
> >>solve these problems. I know they are probably harder...
> >
> >
> >No this has been tried before and does not work. Why should we loose the 
> >capability to work with 4k pages just because there is some data that 
> >has to be thrown around in quantity? I'd like to have flexibility here.
> 
> Is that a big problem? Really? You use 16K pages on your IPF systems,
> don't you?
> 
> 
> >The fragmentation problem is solvable and we already have a solution in 
> >mm. So I do not really see a problem there?
> 
> I don't think that it is solved, and I think the heuristics that are
> there would be put under more stress if they become widely used. And
> it isn't only about whether we can get the page or not, but also about
> the cost. Look up Linus's arguments about page colouring, which are
> similar and  I also think are pretty valid.
> 

Page coloring has come up a lot in the past. Can you point me at an
example you have in mind and I'll see if the same arguments really
apply.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

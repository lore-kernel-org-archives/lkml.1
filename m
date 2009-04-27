Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbZD0Hs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbZD0Hs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 03:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZD0HsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 03:48:19 -0400
Received: from cmpxchg.org ([85.214.51.133]:36853 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbZD0HsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 03:48:18 -0400
Date: Mon, 27 Apr 2009 09:46:30 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
Subject: Re: [patch 3/3][rfc] vmscan: batched swap slot allocation
Message-ID: <20090427074630.GA2244@cmpxchg.org>
References: <1240259085-25872-1-git-send-email-hannes@cmpxchg.org> <1240259085-25872-3-git-send-email-hannes@cmpxchg.org> <Pine.LNX.4.64.0904222059200.18587@blonde.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904222059200.18587@blonde.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 09:37:09PM +0100, Hugh Dickins wrote:
> On Mon, 20 Apr 2009, Johannes Weiner wrote:
> 
> > Every swap slot allocation tries to be subsequent to the previous one
> > to help keeping the LRU order of anon pages intact when they are
> > swapped out.
> > 
> > With an increasing number of concurrent reclaimers, the average
> > distance between two subsequent slot allocations of one reclaimer
> > increases as well.  The contiguous LRU list chunks each reclaimer
> > swaps out get 'multiplexed' on the swap space as they allocate the
> > slots concurrently.
> > 
> > 	2 processes isolating 15 pages each and allocating swap slots
> > 	concurrently:
> > 
> > 	#0			#1
> > 
> > 	page 0 slot 0		page 15 slot 1
> > 	page 1 slot 2		page 16 slot 3
> > 	page 2 slot 4		page 17 slot 5
> > 	...
> > 
> > 	-> average slot distance of 2
> > 
> > All reclaimers being equally fast, this becomes a problem when the
> > total number of concurrent reclaimers gets so high that even equal
> > distribution makes the average distance between the slots of one
> > reclaimer too wide for optimistic swap-in to compensate.
> > 
> > But right now, one reclaimer can take much longer than another one
> > because its pages are mapped into more page tables and it has thus
> > more work to do and the faster reclaimer will allocate multiple swap
> > slots between two slot allocations of the slower one.
> > 
> > This patch makes shrink_page_list() allocate swap slots in batches,
> > collecting all the anonymous memory pages in a list without
> > rescheduling and actual reclaim in between.  And only after all anon
> > pages are swap cached, unmap and write-out starts for them.
> > 
> > While this does not fix the fundamental issue of slot distribution
> > increasing with reclaimers, it mitigates the problem by balancing the
> > resulting fragmentation equally between the allocators.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Hugh Dickins <hugh@veritas.com>
> 
> You're right to be thinking along these lines, and probing for
> improvements to be made here, but I don't think this patch is
> what we want.
> 
> Its spaghetti just about defeated me.  If it were what we wanted,
> I think it ought to be restructured.  Thanks to KAMEZAWA-san for
> pointing out the issue of multiple locked pages, I'm not keen on
> that either.  And I don't like the
> > +		if (list_empty(&swap_pages))
> > +			cond_resched();
> because that kind of thing only makes a difference on !CONFIG_PREEMPT
> (which may cover most distros, but still seems regrettable).
> 
> Your testing looked good, but wasn't it precisely the test that
> would be improved by these changes?  Linear touching, some memory
> pressure chaos, then repeated linear touching.

Agreed, it was.  I started to play around with qsbench per Andrew's
suggestion but stopped now and went back to the scratch pad.  I agree
that these patches are not the solution.

> I think you're placing too much emphasis on the expectation that
> the pages which come off the bottom of the LRU are linear and
> belonging to a single object.  Isn't it more realistic that
> they'll come from scattered locations within independent objects
> of different lifetimes?  Or, the single linear without the chaos.

Oh that is certainly great input, thank you!

> There may well be changes you can make here to reflect that better,
> yet still keep your advantage in the exceptional case that there's
> just the one linear.
> 
> An experiment I've never made, maybe you'd like to try, is to have
> a level of indirection between the swap entries inserted into ptes
> and the actual offsets on swap: assigning the actual offset on swap
> at the last moment in swap_writepage, so the writes are in sequence
> and merged at the block layer (whichever CPU they come from).  Whether
> swapins will be bunched together we cannot know, but we do know that
> bunching the writes together should pay off (both on HDD and SSD).

I thought about indirect ptes as well but wasn't sure about it and
hoped we could get away with less invasive changes.  It might not be
the case.  Thanks for poking in that direction, I will see what I can
come up with.

	Hannes

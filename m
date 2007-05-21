Return-Path: <linux-kernel-owner+w=401wt.eu-S1764910AbXEUWnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764910AbXEUWnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbXEUWno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:43:44 -0400
Received: from waste.org ([66.93.16.53]:56034 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756652AbXEUWnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:43:43 -0400
Date: Mon, 21 May 2007 17:43:16 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <npiggin@suse.de>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-ID: <20070521224316.GC11166@waste.org>
References: <20070518040854.GA15654@wotan.suse.de> <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com> <20070519012530.GB15569@wotan.suse.de> <20070519181501.GC19966@holomorphy.com> <20070520052229.GA9372@wotan.suse.de> <20070520084647.GF19966@holomorphy.com> <20070520092552.GA7318@wotan.suse.de> <20070521080813.GQ31925@holomorphy.com> <20070521092742.GA19642@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521092742.GA19642@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 11:27:42AM +0200, Nick Piggin wrote:
> On Mon, May 21, 2007 at 01:08:13AM -0700, William Lee Irwin III wrote:
> > On Sun, May 20, 2007 at 01:46:47AM -0700, William Lee Irwin III wrote:
> > >> The lack of consideration of the average case. I'll see what I can smoke
> > >> out there.
> > 
> > On Sun, May 20, 2007 at 11:25:52AM +0200, Nick Piggin wrote:
> > > I _am_ considering the average case, and I consider the aligned structure
> > > is likely to win on average :) I just don't have numbers for it yet.
> > 
> > Choosing k distinct integers (mem_map array indices) from the interval
> > [0,n-1] results in k(n-k+1)/n non-adjacent intervals of contiguous
> > array indices on average. The average interval length is
> > (n+1)/(n-k+1) - 1/C(n,k). Alignment considerations make going much
> > further somewhat hairy, but it should be clear that contiguity arising
> > from random choice is non-negligible.
> 
> That doesn't say anything about temporal locality, though.
> 
>  
> > In any event, I don't have all that much of an objection to what's
> > actually proposed, just this particular cache footprint argument.
> > One can motivate increases in sizeof(struct page), but not this way.
> 
> Realise that you have to have a run of I think at least 7 or 8 contiguous
> pages and temporally close references in order to save a single cacheline.
> 
> Then also that if the page being touched is not partially in cache from
> an earlier access, then it is statistically going to cost more lines to
> touch it (up to 75% if you touch the first and the last field, obviously 0%
> if you only touch a single field, but that's unlikely given that you
> usually take a reference then do at least something else like check flags).
> 
> I think the problem with the cache footprint argument is just whether
> it makes any significant difference to performance. But..
> 
> 
> > Now that I've been informed of the ->_count and ->_mapcount issues,
> > I'd say that they're grave and should be corrected even at the cost
> > of sizeof(struct page).
> 
> ... yeah, something like that would bypass 

As long as we're throwing out crazy unpopular ideas, try this one:

Divide struct page in two such that all the most commonly used
elements are in one piece that's nicely sized and the rest are in
another. Have two parallel arrays containing these pieces and accessor
functions around the unpopular bits.

Whether a sensible divide between popular and unpopular bits isn't
clear to me. But hey, I said it was crazy.

-- 
Mathematics is the supreme nostalgia of our time.

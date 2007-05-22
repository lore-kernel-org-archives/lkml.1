Return-Path: <linux-kernel-owner+w=401wt.eu-S1764678AbXEVB5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764678AbXEVB5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758278AbXEVB5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:57:08 -0400
Received: from mail.suse.de ([195.135.220.2]:35289 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969AbXEVB5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:57:05 -0400
Date: Tue, 22 May 2007 03:57:03 +0200
From: Nick Piggin <npiggin@suse.de>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Matt Mackall <mpm@selenic.com>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-ID: <20070522015703.GE27743@wotan.suse.de>
References: <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com> <20070519012530.GB15569@wotan.suse.de> <20070519181501.GC19966@holomorphy.com> <20070520052229.GA9372@wotan.suse.de> <20070520084647.GF19966@holomorphy.com> <20070520092552.GA7318@wotan.suse.de> <20070521080813.GQ31925@holomorphy.com> <20070521092742.GA19642@wotan.suse.de> <20070521224316.GC11166@waste.org> <20070522013951.GP19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522013951.GP19966@holomorphy.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 06:39:51PM -0700, William Lee Irwin III wrote:
> On Mon, May 21, 2007 at 11:27:42AM +0200, Nick Piggin wrote:
> >> ... yeah, something like that would bypass 
> 
> On Mon, May 21, 2007 at 05:43:16PM -0500, Matt Mackall wrote:
> > As long as we're throwing out crazy unpopular ideas, try this one:
> > Divide struct page in two such that all the most commonly used
> > elements are in one piece that's nicely sized and the rest are in
> > another. Have two parallel arrays containing these pieces and accessor
> > functions around the unpopular bits.
> > Whether a sensible divide between popular and unpopular bits isn't
> > clear to me. But hey, I said it was crazy.
> 
> I have a crazier and even less popular idea. Eliminate struct page
> entirely as an accounting structure (and, of course, mem_map with it).
> Filesystems can keep the per-page metadata they need in their own
> accounting structures, slab mutatis mutandis, etc. The brilliant bit
> here is that devolving the accounting structures this way allows the
> fs and/or subsystem to arrange for strong cache locality, file offset
> adjacency to imply memory adjacency of the page accounting fields,
> etc., where grabbing random structures out of some array is a real
> cache thrasher.
> 
> The page allocation and page replacement algorithms would have to be
> adjusted, and things would have to allocate their own refcounts,
> supposing they want/need refcounts, but it's not so far out. Refer to
> filesystem pages by <mapping, index> pairs, refer to slab pages by

BTW. I think the filesystem APIs (at least the VM-side ones) should be
doing this anyway (not even index, but offset). Passing things like
lists of pages around is just horrible. See my write_begin/write_end
and perform_write aops for (what I think is) a step in the right
direction.


> address (virtual and physical are trivially inter-convertible), mock
> up something akin to what filesystems do for anonymous pages, etc.
> 
> The real objection everyone's going to have is that driver writers
> will stain their shorts when faced with the rules for handling such
> things. The thing is, I'm not entirely sure who these driver writers
> that would have such trouble are, since the driver writers I know
> personally are sophisticates rather than walking disaster areas as such
> would imply. I suppose they may not be representative of the whole.

That's not the objection I would have. I would say that firstly, I
don't think the mem_map overhead is very significant (at any rate,
an allocated-on-demand metadata is not going to be any smaller if
you fill up on pagecache...). Secondly, I think there is merit to
having the same page metadata used by the major subsystems, because
it helps for locality of reference.

But I haven't explored the idea enough myself to know whether there
would be any really killer benefits to this. Delayed metadata freeing
via RCU without holding up the freeing of the actual page would have
been something, however I can do similar with speculative references
now (or whenever the code gets merged), which doesn't even require the
RCU overhead.


> -- wli
> 
> P.S. This idea is not plucked out of the air; it has precedents. A
> number of microkernels do this, and IIRC k42 does so also.

Psst, just say "kernels" when you mention this to Linus ;)

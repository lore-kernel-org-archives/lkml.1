Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYJ0KRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYJ0KRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYJ0KRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:17:10 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:62895 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbYJ0KRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:17:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LE2tgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,491,1220193000"; 
   d="scan'208";a="219040513"
Date: Mon, 27 Oct 2008 21:17:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Claudio Martins <ctpm@ist.utl.pt>, linux-kernel@vger.kernel.org
Subject: Re: Order 0 page allocation failure under heavy I/O load
Message-ID: <20081027101701.GD4985@disturbed>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Claudio Martins <ctpm@ist.utl.pt>, linux-kernel@vger.kernel.org
References: <20081026225723.GO18495@disturbed> <200810270547.31123.ctpm@ist.utl.pt> <20081027062216.GH11948@disturbed> <1225094696.16159.8.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225094696.16159.8.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 09:04:56AM +0100, Peter Zijlstra wrote:
> On Mon, 2008-10-27 at 17:22 +1100, Dave Chinner wrote:
> > On Mon, Oct 27, 2008 at 06:47:31AM +0100, Claudio Martins wrote:
> > > On Sunday 26 October 2008, Dave Chinner wrote:
> > > 
> > > > The host will hang for tens of seconds at a time with both CPU cores
> > > > pegged at 100%, and eventually I get this in dmesg:
> > > >
> > > > [1304740.261506] linux: page allocation failure. order:0, mode:0x10000
> > > > [1304740.261516] Pid: 10705, comm: linux Tainted: P          2.6.26-1-amd64
> 
> > No, because I've found the XFS bug the workload was triggering so
> > I don't need to run it anymore.
> > 
> > I reported the problem because it appears that we've reported an
> > allocation failure without very much reclaim scanning (64 pages in
> > DMA zone, 0 pages in DMA32 zone), and there is apparently pages
> > available for allocation in the DMA zone:
> > 
> > 1304740.262136] Node 0 DMA: 160*4kB 82*8kB 32*16kB 11*32kB 8*64kB 4*128kB 3*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8048kB
> > 
> > So it appears that memory reclaim has not found the free pages it
> > apparently has available....
> > 
> > Fundamentally, I/O from a single CPU to a single disk on a machine
> > with 2GB RAM should not be able to cause allocation failures at all,
> > especially when the I/O is pure data I/O to a single file. Something
> > in the default config is busted if I can do that, and that's why
> > I reported the bug.
> 
> The allocation is 'mode:0x10000', which is __GFP_NOMEMALLOC. That means
> the allocation doesn't have __GFP_WAIT, so it cannot do reclaim, it
> doesn't have __GFP_HIGH so it can't access some emergency reserves.

How did we get a gfp_mask with only __GFP_NOMEMALLOC?  A mempool
allocation sets that and many more flags (like __GFP_NORETRY) but
they aren't present in that mask....

> The DMA stuff is special, and part of it is guarded for anything but
> __GFP_DMA allocations.

So if it wasn't a __GFP_DMA allocation - then what ran out of
memory? There appeared to be memory availble in the DMA32 zone....

> You just ran the system very low on memory, and then tried an allocation
> that can't do anything about it.. I don't find it very surprising it
> fails.

I didn't run the system low on memory - the *kernel* did. The
page cache is holding most of memory, and most of that is clean:

Active:254755 inactive:180546 dirty:13547 writeback:20016 unstable:0
free:3059 slab:39487 mapped:141190 pagetables:16401 bounce:0

> The 'bug' if any, is having such a poor allocation within your IO path.
> Not something to blame on the VM.

The I/O path started with a page fault and a call to
balance_dirty_pages_ratelimited_nr(). i.e. all the I/O is being done
by the VM and the allocation failure appears to be caused by
the VM holding all the clean free memory in the page cache where
the I/O layers can't access it. That really does seem like a VM
balance problem to me, not an I/O layer problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

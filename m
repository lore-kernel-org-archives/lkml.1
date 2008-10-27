Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbYJ0IEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbYJ0IEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYJ0IEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:04:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:51637 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYJ0IEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:04:45 -0400
Subject: Re: Order 0 page allocation failure under heavy I/O load
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Claudio Martins <ctpm@ist.utl.pt>, linux-kernel@vger.kernel.org
In-Reply-To: <20081027062216.GH11948@disturbed>
References: <20081026225723.GO18495@disturbed>
	 <200810270547.31123.ctpm@ist.utl.pt>  <20081027062216.GH11948@disturbed>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Oct 2008 09:04:56 +0100
Message-Id: <1225094696.16159.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 17:22 +1100, Dave Chinner wrote:
> On Mon, Oct 27, 2008 at 06:47:31AM +0100, Claudio Martins wrote:
> > On Sunday 26 October 2008, Dave Chinner wrote:
> > 
> > > The host will hang for tens of seconds at a time with both CPU cores
> > > pegged at 100%, and eventually I get this in dmesg:
> > >
> > > [1304740.261506] linux: page allocation failure. order:0, mode:0x10000
> > > [1304740.261516] Pid: 10705, comm: linux Tainted: P          2.6.26-1-amd64

> No, because I've found the XFS bug the workload was triggering so
> I don't need to run it anymore.
> 
> I reported the problem because it appears that we've reported an
> allocation failure without very much reclaim scanning (64 pages in
> DMA zone, 0 pages in DMA32 zone), and there is apparently pages
> available for allocation in the DMA zone:
> 
> 1304740.262136] Node 0 DMA: 160*4kB 82*8kB 32*16kB 11*32kB 8*64kB 4*128kB 3*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8048kB
> 
> So it appears that memory reclaim has not found the free pages it
> apparently has available....
> 
> Fundamentally, I/O from a single CPU to a single disk on a machine
> with 2GB RAM should not be able to cause allocation failures at all,
> especially when the I/O is pure data I/O to a single file. Something
> in the default config is busted if I can do that, and that's why
> I reported the bug.

The allocation is 'mode:0x10000', which is __GFP_NOMEMALLOC. That means
the allocation doesn't have __GFP_WAIT, so it cannot do reclaim, it
doesn't have __GFP_HIGH so it can't access some emergency reserves.

The DMA stuff is special, and part of it is guarded for anything but
__GFP_DMA allocations.

You just ran the system very low on memory, and then tried an allocation
that can't do anything about it.. I don't find it very surprising it
fails.

The 'bug' if any, is having such a poor allocation within your IO path.
Not something to blame on the VM.

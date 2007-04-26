Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbXDZSQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbXDZSQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031418AbXDZSQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:16:45 -0400
Received: from brick.kernel.dk ([80.160.20.94]:5631 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbXDZSQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:16:35 -0400
Date: Thu, 26 Apr 2007 20:12:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426181249.GH2017@kernel.dk>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <46304B9E.5070604@yahoo.com.au> <20070426161152.GC16337@infradead.org> <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com> <20070426180358.GG2017@kernel.dk> <20070426180932.GA10642@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426180932.GA10642@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26 2007, Christoph Hellwig wrote:
> On Thu, Apr 26, 2007 at 08:03:58PM +0200, Jens Axboe wrote:
> > On Thu, Apr 26 2007, Christoph Lameter wrote:
> > > > Iff we really the larger physical page size to support the hardware
> > > > then it makes sense to go down a path of larger pages.  But it doesn't.
> > > 
> > > You are redefining the problem. We need larger physical sizes to support 
> > > the hardware. Yes. We can dodge the issue with shim layers and hacks. It 
> > > is obvious from the kernel sources that this is needed.
> > 
> > We definitely don't. Larger sizes are ONE way to solve the problem, they
> > are definitely not the only one. If the larger pages become unfeasible
> > for some reason (be it fragmentation, or just because the design isn't
> > good), then we can solve it differently.
> 
> Exactly.  But the only counter-proposal we have so far seems far worse :)

Lets look at some numbers. I'll just concentrate on the scatterlist,
since the bio_vec is smaller. On x86 32-bit, the scatterlist is 20 bytes
long. If we accept that 2^1 allocations are ok (they should be), then we
can support ~1.6mb ios just like that.

My approach would be to support scatterlist chaining. Essentially you'd
have the last element of the sglist pointing to the next array of
entries. We can then stick to 128 entry arrays which fit nicely in a
single page allocation and easily support >> 2mb ios. The only caveat is
that you'd need to update the drivers to get there, since a regular
iteration over the array isn't enough. My plan was to add an sglist
iterator helper that hides this from the drivers, if they need to loop
over the scatterlist. Things like {dma/pci}_map_sg() would of course be
updated.

The above can be implemented fairly cleanly, and on a need-to-have
basis. It's not something that'll break drivers.

What do you think?

-- 
Jens Axboe


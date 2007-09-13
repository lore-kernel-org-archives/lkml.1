Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbXIMJkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbXIMJkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXIMJkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:40:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37964 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbXIMJkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:40:33 -0400
Date: Thu, 13 Sep 2007 10:40:30 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070913094030.GA22778@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709111617.03586.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111644240.29413@schroedinger.engr.sgi.com> <200709121246.08833.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709121607140.4204@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709121607140.4204@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (12/09/07 16:17), Christoph Lameter didst pronounce:
> On Wed, 12 Sep 2007, Nick Piggin wrote:
> 
> > I will still argue that my approach is the better technical solution for large
> > block support than yours, I don't think we made progress on that. And I'm
> > quite sure we agreed at the VM summit not to rely on your patches for
> > VM or IO scalability.
> 
> The approach has already been tried (see the XFS layer) and found lacking. 
> 
> Having a fake linear block through vmalloc means that a special software 
> layer must be introduced and we may face special casing in the block / fs 
> layer to check if we have one of these strange vmalloc blocks.
> 

One of Nick's points is that to have a 100% reliable solution, that is
what is required. We already have a layering between the VM and the FS
but my understanding is that fsblock replaces rather than adds to it.

Surely, we'll be able to detect the situation where the memory is really
contiguous as a fast path and have a slower path where fragmentation was
a problem.

> > But you just showed in two emails that you don't understand what the
> > problem is. To reiterate: lumpy reclaim does *not* invalidate my formulae;
> > and antifrag does *not* isolate the issue.
> 
> I do understand what the problem is. I just do not get what your problem 
> with this is and why you have this drive to demand perfection. We are 
> working a variety of approaches on the (potential) issue but you 
> categorically state that it cannot be solved.
> 

This is going in circles.

His point is that we also cannot prove it is 100% correct in all
situations. Without taking additional (expensive) steps, there will be a
workload that fragments physical memory. He doesn't know what it is and neither
do we, but that does not mean that someone else will find it. He also has a
point about the slow degredation of fragmentation that is woefully difficult
to reproduce. We've had this provability of correctness problem before.

His initial problem was not with the patches as such but the fact that they
seemed to be presented as a 1st class feature that we fully support and
is a potential solution for some VM and IO Scalability problems.  This is
not the case, we have to treat it as a 2nd class feature until we *know* no
situation exists where it breaks down. These patches on their own would have
to run for months if not a year or so before we could be really sure about it.

The only implementation question about these patches that hasn't been addressed
is the mmap() support. What's wrong with it in it's current form. Can it be
fixed or if it's fundamentally screwed etc. That has fallen by the
wayside.

> > But what do you say about viable alternatives that do not have to
> > worry about these "unlikely scenarios", full stop? So, why should we
> > not use fs block for higher order page support?
> 
> Because it has already been rejected in another form and adds more 
> layering to the filesystem and more checking for special cases in which 
> we only have virtual linearity? It does not reduce the number of page 
> structs that have to be handled by the lower layers etc.
> 

Unless callers always use an iterator for blocks that is optimised in the
physically linear case to be a simple array offset and when not physically
linear it either walks chains (complex) or uses vmap (must deal with TLB
flushes amoung other things). If it optimistically uses physically contiguous
memory, we may find a way to use only one page struct as well.

> Maybe we coud get to something like a hybrid that avoids some of these 
> issues?

Or gee whiz, I don't know. Start with your patches as a strictly 2nd class
citizen and build fsblock in while trying to keep use of physically contiguous
memory where possible and it makes sense.

> Add support so something like a virtual compound page can be 
> handled transparently in the filesystem layer with special casing if 
> such a beast reaches the block layer?
> 
> > I didn't skip that. We have large page pools today. How does that give
> > first class of support to those allocations if you have to have memory
> > reserves?
> 
> See my other mail. That portion is not complete yet. Sorry.
> 

I am *very* wary of using reserve pools for anything other than
emergency situations. If nothing else pools == wasted memory + a sizing
problem. But hey, it is one option.

Are we going to agree on some sort of plan or are we just going to
handwave ourselves to death?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

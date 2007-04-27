Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbXD0NG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbXD0NG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbXD0NG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:06:57 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:56105 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbXD0NGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:06:55 -0400
Date: Fri, 27 Apr 2007 14:06:52 +0100
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427130652.GG3645@skynet.ie>
References: <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com> <4630593C.8070905@yahoo.com.au> <20070426160715.GB16337@infradead.org> <4631CAE7.2080109@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4631CAE7.2080109@yahoo.com.au>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (27/04/07 20:05), Nick Piggin didst pronounce:
> Christoph Hellwig wrote:
> >On Thu, Apr 26, 2007 at 05:48:12PM +1000, Nick Piggin wrote:
> >
> >>>Well maybe you could explain what you want. Preferably without 
> >>>redefining the established terms?
> >>
> >>Support for larger buffers than page cache pages.
> >
> >
> >I don't think you really want this :)  The whole non-pagecache I/O
> >path before 2.3 was a toal pain just because it used buffers to drive
> >I/O.  Add to that buffers bigger than a page and you add another
> >two mangnitudes of complexity.  If you want to see a mess like that
> >download on of the eary XFS/Linux releases that had an I/O path
> >like that.  I _really_ _really_ don't want to go there.
> 
> I'm not actually suggesting to add anything like that. But I think
> larger blocks can be doable while retaining the "buffer" layer as a
> relatively simple pagecache to block translation.
> 
> Anyway, I'm working on patches... they might crash and burn, but we
> might have something to talk about later.
> 
> 
> >Linux has a long tradition of trading a tiny bit of efficieny for
> >much cleaner code, and I'd for 100% go down Christoph's route here.
> >Then again I'd actually be rather surprised if > page buffers
> >were more efficient - you'd run into shitloads over overhead due to
> >them beeing non-contingous like calling vmap all over the place,
> >reprogramming iommus to at least make them look virtually contingous [1],
> >etc..
> 
> I still think hardware should work reasonably well with 4K pages. The
> SGI io controllers and/or the Linux block layer that doesn't allow more
> than 128 sg entries is clearly suboptimal if the hardware runs twice as
> fast with 2MB submissions.
> 
> 
> >I also don't quite get what your problem with higher order allocations
> >are.  order 1 allocations are generally just fine, and in fact
> >thread stacks are >= oder 1 on most architectures.  And if the pagecache
> >uses higher order allocations that means we'll finally fix our problems
> >with them, which we have to do anyway.  Workloads continue to grow and
> >with them the kernel overhead to manage them, while the pagesize for
> >many architectures is fixed.  So we'll have to deal with order 1
> >and order 2 allocations better just for backing kmalloc and co.
> 
> The pagecache is much bigger and often a lot more activity than these
> other things though. Also, the more things you add to higher order
> allocations, the more pressure you have.
> 
> I like PAGE_SIZE pagecache, because it is reliable and really fast, if
> you need to reclaim a page it should be almost O(1).
> 
> 
> >Or think jumboframes for that matter.
> 
> They can actually run into problems if the hardware wants contiguous
> memory.
> 
> I don't know why you think the fragmentation issues are just magically
> fixed. It is hard and inefficient to reclaim larger order blocks (even
> with lumpy reclaim), and Mel's patches aren't perfect. Actually, last
> time I looked, they needed to keep at least 16MB of pages free to be
> reasonably effective (or do we just say that people with less than XMB
> of memory shouldn't be accessing these filesystems anyway?)

It'll work without adjusting the min_free_kbytes at all. The 16MB free had
better results after fragmentation stress tests but this was a few percent
of memory when allocating as huge pages as opposed to it falling apart. The
success rates were still way way higher than the vanilla kernel.

>, and I'm
> not sure if they have been tested for long term stability in the
> presence of a reasonable amount of higher order allocations.
> 

I don't have a sample workload that has reasonable amount of higher order
allocations over longer period of time. When the next -mm comes out, SLUB will
be able to use high-order pages so I'll boot my machine with less memory to
pressure it more. Assuming the kernel boots on my desktop machine, I should
get some idea of what its long-term behaviour looks like.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

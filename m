Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbXIKVE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbXIKVE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764241AbXIKVEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:04:01 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60520 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763640AbXIKVD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:03:59 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 17:03:57 EDT
Date: Tue, 11 Sep 2007 22:03:48 +0100
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrea Arcangeli <andrea@suse.de>, Christoph Lameter <clameter@sgi.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070911210348.GB18127@skynet.ie>
References: <20070911060349.993975297@sgi.com> <20070911164702.GD10831@v2.random> <1189535461.32731.75.camel@localhost> <200709111226.06728.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200709111226.06728.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/09/07 12:26), Nick Piggin didst pronounce:
> On Wednesday 12 September 2007 04:31, Mel Gorman wrote:
> > On Tue, 2007-09-11 at 18:47 +0200, Andrea Arcangeli wrote:
> > > On Tue, Sep 11, 2007 at 04:36:07PM +0100, Mel Gorman wrote:
> > > > that increasing the pagesize like what Andrea suggested would lead to
> > > > internal fragmentation problems. Regrettably we didn't discuss Andrea's
> > >
> > > The config_page_shift guarantees the kernel stacks or whatever not
> > > defragmentable allocation other allocation goes into the same 64k "not
> > > defragmentable" page. Not like with SGI design that a 8k kernel stack
> > > could be allocated in the first 64k page, and then another 8k stack
> > > could be allocated in the next 64k page, effectively pinning all 64k
> > > pages until Nick worst case scenario triggers.
> >
> > In practice, it's pretty difficult to trigger. Buddy allocators always
> > try and use the smallest possible sized buddy to split. Once a 64K is
> > split for a 4K or 8K allocation, the remainder of that block will be
> > used for other 4K, 8K, 16K, 32K allocations. The situation where
> > multiple 64K blocks gets split does not occur.
> >
> > Now, the worst case scenario for your patch is that a hostile process
> > allocates large amount of memory and mlocks() one 4K page per 64K chunk
> > (this is unlikely in practice I know). The end result is you have many
> > 64KB regions that are now unusable because 4K is pinned in each of them.
> > Your approach is not immune from problems either. To me, only Nicks
> > approach is bullet-proof in the long run.
> 
> One important thing I think in Andrea's case, the memory will be accounted
> for (eg. we can limit mlock, or work within various memory accounting things).
> 

For mlock()ed sure. Not for pagetables though, kmalloc slabs etc. It
might be a non-issue as well. Like the large block patches, there are
aspects of Andrea's case that we simply do not know.

> With fragmentation, I suspect it will be much more difficult to do this. It
> would be another layer of heuristics that will also inevitably go wrong
> at times if you try to limit how much "fragmentation" a process can do.
> Quite likely it is hard to make something even work reasonably well in
> most cases.

Regreattably, this is also woefully difficult to prove. For
fragmentation, I can look into having a more expensive version of
/proc/pagetypeinfo to give a detailed account of the current
fragmentation state but it's a side-issue.

> > >  We can still try to save some memory by
> > > defragging the slab a bit, but it's by far *not* required with
> > > config_page_shift. No defrag at all is required infact.
> >
> > You will need to take some sort of defragmentation to deal with internal
> > fragmentation. It's a very similar problem to blasting away at slab
> > pages and still not being able to free them because objects are in use.
> > Replace "slab" with "large page" and "object" with "4k page" and the
> > issues are similar.
> 
> Well yes and slab has issues today too with internal fragmentation,
> targetted reclaim and some (small) higher order allocations too today.
> But at least with config_page_shift, you don't introduce _new_ sources
> of problems (eg. coming from pagecache or other allocs).
> 

Well, we do extend the internal fragmentation problem. Previous, it was
inode, dcache and friends. Now we have to deal with internal
fragmentation related to page tables, per-cpu pages etc. Maybe they can
be solved too, but they are of similar difficulty to what Christoph
faces.

> Sure, there are some other things -- like pagecache can actually use
> up more memory instead -- but there are a number of other positives
> that Andrea's has as well. It is using order-0 pages, which are first class
> throughout the VM; they have per-cpu queues, and do not require any
> special reclaim code.

Being able to use the per-cpu queues is a big plus.

> They also *actually do* reduce the page
> management overhead in the general case, unlike higher order pcache.
> 
> So combined with the accounting issues, I think it is unfair to say that
> Andrea's is just moving the fragmentation to internal. It has a number
> of upsides. I have no idea how it will actually behave and perform, mind
> you ;)
> 

Neither do I. Andrea's suggestion definitly has upsides. I'm just saying
it's not going to cure cancer any better than the large block patchset ;)

> 
> > > Plus there's a cost in defragging and freeing cache... the more you
> > > need defrag, the slower the kernel will be.
> > >
> > > > approach in depth.
> > >
> > > Well it wasn't my fault if we didn't discuss it in depth though.
> >
> > If it's my fault, sorry about that. It wasn't my intention.
> 
> I think it did get brushed aside a little quickly too (not blaming anyone).
> Maybe because Linus was hostile. But *if* the idea is that page
> management overhead has or will become a problem that needs fixing,
> then neither higher order pagecache, nor (obviously) fsblock, fixes this
> properly. Andrea's most definitely has the potential to.

Fair point.

What way to jump now is the question.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

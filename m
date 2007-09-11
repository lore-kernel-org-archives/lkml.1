Return-Path: <linux-kernel-owner+w=401wt.eu-S1764028AbXIKS1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764028AbXIKS1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760728AbXIKS1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:27:14 -0400
Received: from hu-out-0506.google.com ([72.14.214.228]:31368 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760466AbXIKS1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Io20+z1DihgtKBMSN3P1RBZxx0HcI02omB3hh5bZ8W7Sb+nDlYAUTzj7T23E6yHIO6mcgYJsILi6IDip0vze+IxpsIDVYAWyOOUT5guH8Hnx3Su4L7NyOhydLVdYf2dXUOXQCna/9eJHkg4jpJ056Xp/8V1swRgHtr3HwS+jG5w=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 21:25:43 +0300
User-Agent: KMail/1.9.6
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <andrea@suse.de>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <1189535461.32731.75.camel@localhost> <200709111226.06728.nickpiggin@yahoo.com.au>
In-Reply-To: <200709111226.06728.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709112125.44188.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2007 05:26:05 Nick Piggin wrote:
> On Wednesday 12 September 2007 04:31, Mel Gorman wrote:
> > On Tue, 2007-09-11 at 18:47 +0200, Andrea Arcangeli wrote:
> > > Hi Mel,
> >
> > Hi,
> >
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
> With fragmentation, I suspect it will be much more difficult to do this. It
> would be another layer of heuristics that will also inevitably go wrong
> at times if you try to limit how much "fragmentation" a process can do.
> Quite likely it is hard to make something even work reasonably well in
> most cases.
> 
> 
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
> Sure, there are some other things -- like pagecache can actually use
> up more memory instead -- but there are a number of other positives
> that Andrea's has as well. It is using order-0 pages, which are first class
> throughout the VM; they have per-cpu queues, and do not require any
> special reclaim code. They also *actually do* reduce the page
> management overhead in the general case, unlike higher order pcache.
> 
> So combined with the accounting issues, I think it is unfair to say that
> Andrea's is just moving the fragmentation to internal. It has a number
> of upsides. I have no idea how it will actually behave and perform, mind
> you ;)
> 
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
> 

Hi,

I think that fundamental problem is no fragmentation/large pages/...

The problem is the VM itself.
The vm doesn't use virtual memory, thats all, that the problem.
Although this will be probably linux 3.0, I think that the right way to solve all those problems 
is to make all kernel memory vmalloced (except few areas like kernel .text)
 
It will suddenly remove the buddy allocator, it will remove need for highmem, it will allow to allocate any amount of memory
(for example 4k stacks will be obsolete)
It will even allow kernel memory to be swapped to disk.

This is the solution, but it is very very hard.

Best regards,
	Maxim Levitsky

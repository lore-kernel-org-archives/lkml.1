Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbXIKSHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbXIKSHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758422AbXIKSHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:07:44 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:38439 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758318AbXIKSHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:07:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=p0nqzf+pi6w2y/0V7p+jkU57x0okiPHqwTBxfAcl2LmG1bGtG+BDBsm9WI5yJrkQ9Cq/8STQY4teiLgyGEMpPklk8TqkZDiSVw4n1cN6OQaSTZNIEZhW73DI2RhGG56PPaaaKFXfNJzi1aQROfFy7vfkSc6qJI85p0c1A1+zYa0=  ;
X-YMail-OSG: r3lLodsVM1mPG2E2TiSsdjZZwro_s8XxJuguHOPpB5JFcNUprQfY1BLKrzDU6YKHSgeh0CJrwD_RiRB7U.N008D1qGXY
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 12:26:05 +1000
User-Agent: KMail/1.9.5
Cc: Andrea Arcangeli <andrea@suse.de>, Christoph Lameter <clameter@sgi.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <20070911164702.GD10831@v2.random> <1189535461.32731.75.camel@localhost>
In-Reply-To: <1189535461.32731.75.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111226.06728.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 04:31, Mel Gorman wrote:
> On Tue, 2007-09-11 at 18:47 +0200, Andrea Arcangeli wrote:
> > Hi Mel,
>
> Hi,
>
> > On Tue, Sep 11, 2007 at 04:36:07PM +0100, Mel Gorman wrote:
> > > that increasing the pagesize like what Andrea suggested would lead to
> > > internal fragmentation problems. Regrettably we didn't discuss Andrea's
> >
> > The config_page_shift guarantees the kernel stacks or whatever not
> > defragmentable allocation other allocation goes into the same 64k "not
> > defragmentable" page. Not like with SGI design that a 8k kernel stack
> > could be allocated in the first 64k page, and then another 8k stack
> > could be allocated in the next 64k page, effectively pinning all 64k
> > pages until Nick worst case scenario triggers.
>
> In practice, it's pretty difficult to trigger. Buddy allocators always
> try and use the smallest possible sized buddy to split. Once a 64K is
> split for a 4K or 8K allocation, the remainder of that block will be
> used for other 4K, 8K, 16K, 32K allocations. The situation where
> multiple 64K blocks gets split does not occur.
>
> Now, the worst case scenario for your patch is that a hostile process
> allocates large amount of memory and mlocks() one 4K page per 64K chunk
> (this is unlikely in practice I know). The end result is you have many
> 64KB regions that are now unusable because 4K is pinned in each of them.
> Your approach is not immune from problems either. To me, only Nicks
> approach is bullet-proof in the long run.

One important thing I think in Andrea's case, the memory will be accounted
for (eg. we can limit mlock, or work within various memory accounting things).

With fragmentation, I suspect it will be much more difficult to do this. It
would be another layer of heuristics that will also inevitably go wrong
at times if you try to limit how much "fragmentation" a process can do.
Quite likely it is hard to make something even work reasonably well in
most cases.


> >  We can still try to save some memory by
> > defragging the slab a bit, but it's by far *not* required with
> > config_page_shift. No defrag at all is required infact.
>
> You will need to take some sort of defragmentation to deal with internal
> fragmentation. It's a very similar problem to blasting away at slab
> pages and still not being able to free them because objects are in use.
> Replace "slab" with "large page" and "object" with "4k page" and the
> issues are similar.

Well yes and slab has issues today too with internal fragmentation,
targetted reclaim and some (small) higher order allocations too today.
But at least with config_page_shift, you don't introduce _new_ sources
of problems (eg. coming from pagecache or other allocs).

Sure, there are some other things -- like pagecache can actually use
up more memory instead -- but there are a number of other positives
that Andrea's has as well. It is using order-0 pages, which are first class
throughout the VM; they have per-cpu queues, and do not require any
special reclaim code. They also *actually do* reduce the page
management overhead in the general case, unlike higher order pcache.

So combined with the accounting issues, I think it is unfair to say that
Andrea's is just moving the fragmentation to internal. It has a number
of upsides. I have no idea how it will actually behave and perform, mind
you ;)


> > Plus there's a cost in defragging and freeing cache... the more you
> > need defrag, the slower the kernel will be.
> >
> > > approach in depth.
> >
> > Well it wasn't my fault if we didn't discuss it in depth though.
>
> If it's my fault, sorry about that. It wasn't my intention.

I think it did get brushed aside a little quickly too (not blaming anyone).
Maybe because Linus was hostile. But *if* the idea is that page
management overhead has or will become a problem that needs fixing,
then neither higher order pagecache, nor (obviously) fsblock, fixes this
properly. Andrea's most definitely has the potential to.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbXI2Ivc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbXI2Ivc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 04:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbXI2IvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 04:51:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46449 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbXI2IvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 04:51:23 -0400
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20070929011311.8b51dedb.akpm@linux-foundation.org>
References: <20070919033605.785839297@sgi.com>
	 <20070919033643.763818012@sgi.com>
	 <200709280742.38262.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
	 <1191002119.18147.80.camel@lappy>
	 <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
	 <1191003950.18147.85.camel@lappy>
	 <20070929011311.8b51dedb.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 10:47:12 +0200
Message-Id: <1191055632.18147.101.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-09-29 at 01:13 -0700, Andrew Morton wrote:
> On Fri, 28 Sep 2007 20:25:50 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > 
> > On Fri, 2007-09-28 at 11:20 -0700, Christoph Lameter wrote:
> > 
> > > > start 2 processes that each mmap a separate 64M file, and which does
> > > > sequential writes on them. start a 3th process that does the same with
> > > > 64M anonymous.
> > > > 
> > > > wait for a while, and you'll see order=1 failures.
> > > 
> > > Really? That means we can no longer even allocate stacks for forking.
> > > 
> > > Its surprising that neither lumpy reclaim nor the mobility patches can 
> > > deal with it? Lumpy reclaim should be able to free neighboring pages to 
> > > avoid the order 1 failure unless there are lots of pinned pages.
> > > 
> > > I guess then that lots of pages are pinned through I/O?
> > 
> > memory got massively fragemented, as anti-frag gets easily defeated.
> > setting min_free_kbytes to 12M does seem to solve it - it forces 2 max
> > order blocks to stay available, so we don't mix types. however 12M on
> > 128M is rather a lot.
> > 
> > its still on my todo list to look at it further..
> > 
> 
> That would be really really bad (as in: patch-dropping time) if those
> order-1 allocations are not atomic.
> 
> What's the callsite? 

Ah, right, that was the detail... all this lumpy reclaim is useless for
atomic allocations. And with SLUB using higher order pages, atomic !0
order allocations will be very very common.

One I can remember was:

  add_to_page_cache()
    radix_tree_insert()
      radix_tree_node_alloc()
        kmem_cache_alloc()

which is an atomic callsite.

Which leaves us in a situation where we can load pages, because there is
free memory, but can't manage to allocate memory to track them.. 


Return-Path: <linux-kernel-owner+w=401wt.eu-S933456AbYETT7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbYETT7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbYETT7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:59:08 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19165 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758756AbYETT7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:59:05 -0400
Date: Tue, 20 May 2008 21:58:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: blk_queue_bounce_limits can actually sleep
Message-ID: <20080520195857.GC22369@kernel.dk>
References: <20080519202409.6d1055be@infradead.org> <20080520192958.GW22369@kernel.dk> <20080520124556.ad0c3fca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520124556.ad0c3fca.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20 2008, Andrew Morton wrote:
> On Tue, 20 May 2008 21:29:59 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Mon, May 19 2008, Arjan van de Ven wrote:
> > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > Subject: [PATCH] block: blk_queue_bounce_limits can actually sleep
> > > 
> > > blk_queue_bounce_limit can call init_emergency_isa_pool, which
> > > does sleeping allocations... document it as such by adding
> > > might_sleep() to the driver
> > 
> > Isn't that superflous, as mempool_create() -> kmalloc(..., __GFP_WAIT)
> > ends up spewing that warning anyway?
> 
> It's largely superfluous given the way in which Arjan implemented it.
> 
> One situation which we regularly hit is:
> 
> foo()
> {
> 	...
> 	if (some_unlikely_condition())
> 		do_something_which_sleeps();
> 	...
> }
> 
> and then we go and call that code under spinlock and ship it out, when
> of course a handful of testers hit the unlikely condition.
> 
> The solution to that is to add a might_sleep() _outside_ the test of
> some_unlikely_condition().  ie:
> 
> --- a/block/blk-settings.c~a
> +++ a/block/blk-settings.c
> @@ -140,6 +140,8 @@ void blk_queue_bounce_limit(struct reque
>  	unsigned long b_pfn = dma_addr >> PAGE_SHIFT;
>  	int dma = 0;
>  
> +	might_sleep();
> +
>  	q->bounce_gfp = GFP_NOIO;
>  #if BITS_PER_LONG == 64
>  	/* Assume anything <= 4GB can be handled by IOMMU.

Yeah, THAT I agree with in general, but it's probably too much here
since most callers will not block and probably do call it under the
queue lock already (just guessing here, didn't audit any callers).

> but it's all vague and waffly because Arjan forgot to tell us why he's
> bothering to patch this code at all???

Probably the math still isn't quite correct, so it ends up setting up
the isa pool for no good reason :-(

-- 
Jens Axboe


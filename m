Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbZDAX6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbZDAX6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZDAX6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:58:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:48574 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZDAX6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:58:04 -0400
Message-ID: <49D3FF7F.2070505@kernel.org>
Date: Thu, 02 Apr 2009 08:57:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 08/17] bio: reimplement bio_copy_user_iov()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-9-git-send-email-tj@kernel.org> <49D38D4B.7020701@panasas.com>
In-Reply-To: <49D38D4B.7020701@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 23:57:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
> I've looked hard and deep into your patchset, and I would like to
> suggest an improvement.
> 
> [Option 1]
> What your code is actually using from sgl-code base is:
>  for_each_sg
>  sg_mapping_iter and it's
> 	sg_miter_start, sg_miter_next
>  ... (what else)
> 
> I would like if you can define above for bvec(s) just the way you like
> them. Then code works directly on the destination bvect inside the final
> bio. One less copy no intermediate allocation, and no kmalloc of
> bigger-then-page buffers.
> 
> These are all small inlines, duplicating those will not affect
> Kernel size at all. You are not using the chaining ability of sgl(s)
> so it can be simplified. You will see that not having the intermediate
> copy simplifies the code even more.
> 
> Since no out-side user currently needs sgl(s) no functionality is lost.

Yeah, we can switch to dealing with bvecs instead of sgls.  For kernel
mappings, it wouldn't make any difference.  For user single mappings,
it'll remove an intermediate step.  For user sg mappings, if we make
gup use sgl, it won't make much difference.

Frankly, for copy paths, I don't think all this matters at all.  If
each request is small, other overheads will dominate.  For large
requests, copying to and from sgl isn't something worth worrying
about.

For mapping paths, if we change gup to use sgl (we really can't make
it swallow bvec), I don't think it will make whole lot of difference
one way or the other.  It might end up using slightly more cachelines,
but that will be about it.

I do agree using bvec as internal page carrier would be nicer (sans
having to implement stuff manually) but I'm not convinced whether
it'll be worth the added code.

> [Option 2]
> Keep pointer to sgl and not bvec at bio, again code works on final
> destination.  Later users of block layer that call blk_rq_fill_sgl
> (blk_rq_map_sg) will just get a copy of the pointer and another
> allocation and copy is gained.  This option will spill outside of
> the current patches scope. Into bvec hacking code.
> 
> I do like your long term vision of separating the DMA part from the
> virtual part of scatterlists. Note how they are actually two
> disjoint lists altogether. After the dma_map does its thing the dma
> physical list might be shorter then virtual and sizes might not
> correspond at all. The dma mapping code regards the dma part as an
> empty list that gets appended while processing, any segments match
> is accidental. (That is: inside the scatterlist the virtual address
> most probably does not match the dma address)
> 
> So [option 1] matches more closely to that vision.
> 
> Historically code was doing
>   Many-sources => scatterlist => biovec => scatterlist => dma-scatterlist
> 
> Only at 2.6.30 we can say that we shorten a step to do:
>   Many-sources => biovec => scatterlist => dma-scatterlist
> 
> Now you want to return the extra step, I hate it.

It's not my favorite part either but I'm just not convinced it matters
all that much.

> [Option 2] can make that even shorter.
>   Many-sources => scatterlist => dma-scatterlist

Yeah, this is the root cause.  We don't have a common API to carry
segments so we end up doing impedence matching when crossing
boundaries.  Drivers expect sgl at the interface.  Filesystems
obviously expect bio with bvecs.  gup expects array of pages (this one
isn't too bad tho).

> Please consider [option 1] it will only add some source code
> but it will not increase code size, maybe it will decrease,
> and it will be fast.
>
> Please consider that this code-path is used by me, in exofs and
> pNFS-objcets in a very very hot path, where memory pressure is a
> common scenario.

I'm not hugely against using bvec inside.  I just didn't see much
difference and went for something easier, so yeah, it definitely is an
option.

Jens, Tomo, what do you guys think?

> And I have one more question.  Are you sure kmalloc of
> bigger-then-page buffers are safe?

It has higher chance of failure but is definitely safe.

> As I understood it, that tries to allocate physically contiguous
> pages which degrades as time passes, and last time I tried this with
> a kmem_cache (do to a bug) it crashed the kernel randomly after 2
> minutes of use.

Then, that's a bug.  Yeah, high order allocations fail more easily as
time passes.  But low order (1 maybe 2) allocations aren't too bad.
If it matters we can make bio_kmalloc() use vmalloc() for bvecs if it
goes over PAGE_SIZE but again given that nobody reported the spurious
GFP_DMA in bounce_gfp which triggers frenzy OOM killing spree for
large SG_IOs, I don't think this matters all that much.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763301AbZDBJAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763301AbZDBJAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbZDBI7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 04:59:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:47203 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757246AbZDBI7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 04:59:54 -0400
Message-ID: <49D47E7B.3030209@kernel.org>
Date: Thu, 02 Apr 2009 17:59:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 08/17] bio: reimplement bio_copy_user_iov()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-9-git-send-email-tj@kernel.org> <49D38D4B.7020701@panasas.com> <49D3FF7F.2070505@kernel.org> <49D47653.90507@panasas.com>
In-Reply-To: <49D47653.90507@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 08:59:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
>> Yeah, we can switch to dealing with bvecs instead of sgls.  For kernel
>> mappings, it wouldn't make any difference.  For user single mappings,
>> it'll remove an intermediate step.  For user sg mappings, if we make
>> gup use sgl, it won't make much difference.
> 
> "gup use sgl" was just a stupid suggestion to try eliminate one more
> allocation. Realy Realy stupid.
> 
> for gup there is a much better, safer, way. Just allocate on the stack
> a constant size say 64 pointers and add an inner-loop on the 64 pages.
> The extra code loop is much cheaper then an allocation and is one less
> point of failure.

Great.

> So now that we got gup out of the way, will you go directly to bvecs?

As said before, I don't think exposing bio at the driver interface is
a good idea copy or not.  For internal implementation, if there's
enough benefit, yeah.

>> Frankly, for copy paths, I don't think all this matters at all.  If
>> each request is small, other overheads will dominate.  For large
>> requests, copying to and from sgl isn't something worth worrying
>> about.
> 
> It is. Again, I tested that. Each new allocation in the order of
> the number of pages in a request adds 3-5% on a RAM I/O

Sure, if you do things against ram, anything will show up.  Do you
have something more realistic?

> And it adds a point of failure. The less the better.

That is not the only measure.  Things are always traded off using
multiple evaluation metrics.  The same goes with the _NO_ allocation
thing.

>> For mapping paths, if we change gup to use sgl (we really can't make
>> it swallow bvec), I don't think it will make whole lot of difference
>> one way or the other.  It might end up using slightly more cachelines,
>> but that will be about it.
> 
> gup to use sgl, is out of the way, that was stupid idea to try eliminate
> one more dynamic allocation. 

Yeah, I do agree gup is much better off with pages array.

>> I do agree using bvec as internal page carrier would be nicer (sans
>> having to implement stuff manually) but I'm not convinced whether
>> it'll be worth the added code.
> 
> We can reach a point where there is no intermediate dynamic alloctions
> and no point of failures, but for the allocation of the final bio+biovec.

There is no need to obsess about no point of failure.  Obsessing about
single evaluation metric is a nice and fast way toward a mess.

> And that "implement stuff manually" will also enable internal bio
> code cleanups since now biovec is that much smarter.
>
> <snip> 
>>> And I have one more question.  Are you sure kmalloc of
>>> bigger-then-page buffers are safe?
>> It has higher chance of failure but is definitely safe.
> 
> Much much higher, not just 100% higher. And it will kill the
> use of block-layer in nommu systems.

Didn't know nommu would kill high order allocation or were you talking
about vmalloc?

>>> As I understood it, that tries to allocate physically contiguous
>>> pages which degrades as time passes, and last time I tried this with
>>> a kmem_cache (do to a bug) it crashed the kernel randomly after 2
>>> minutes of use.
>> Then, that's a bug.  
> 
> Fixing the bug will not help, the allocation will fail and the IO will
> not get through.

Under enough memory pressure, Non-fs IOs are gonna fail somewhere
along the line.  If you don't like that, use mempool backed allocation
or preallocated data structures.  Also, I believe it is generally
considered better to fail IO than oopsing.  :-P

>> Yeah, high order allocations fail more easily as time passes.  But
>> low order (1 maybe 2) allocations aren't too bad.
> 
> No, we are not talking about 1 or 2. Today since Jens put the scatterlist
> chaining we can have lots and lots of them chained together. At the time
> Jens said that bio had the chaining option for a long time, only scatterlists
> limit the size of the request.

Alright, let's than chain bios but let's please do it inside bio
proper.

>> If it matters we can make bio_kmalloc() use vmalloc() for bvecs if it
>> goes over PAGE_SIZE but again given that nobody reported the
> 
> No that is a regression, vmaloc is an order of a magnitude slower then
> just plain BIO chaining

It all depends on how frequent those multiple allocations will be.

> spurious
>> GFP_DMA in bounce_gfp which triggers frenzy OOM killing spree for
>> large SG_IOs, I don't think this matters all that much.
>>
> 
> This BUG was only for HW, ie ata. But for stuff like iscsi FB sas
> they did fine.

The bug was for all controllers which couldn't do 64bit DMA on 64bit
machines.

> The fact of the matter is that people, me included, run in systems
> with very large request for a while now, large like 4096 pages which
> is 16 chained bios. Do you want to allocate that with vmalloc?

The patchset was written the way it's written because I couldn't see
any pressing performance requirement for the current existing users.
Optimizing for SG_IO against memory is simply not a good idea.

If you have in-kernel users which often require large transfers, sure,
chaining bio would be better.  Still, let's do it _inside_ bio.  Would
your use case be happy with something like blk_rq_map_kern_bvec(rq,
bvec) which can append to rq?  If we convert internal implementation
over to bvec, blk_rq_map_kern_sg() can be sg->bvec converting wrapper
around blk_rq_map_kern_bvec().

> I love your cleanups, and your courage, which I don't have.

Thanks a lot but it's not like the code and Jens are scary monsters I
need to slay, so I don't think I'm being particularly courageous.  :-)

> I want to help in any way I can. If you need just tell me what, and
> I'll be glad to try or test anything. This is fun I like to work and
> think on these things

Great, your reviews are comments are very helpful, so please keep them
coming.  :-)

Jens, Tomo, what do you guys think?

Thanks.

-- 
tejun

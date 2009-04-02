Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbZDBI1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbZDBI1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 04:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbZDBI1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 04:27:01 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:17617 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754835AbZDBI06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 04:26:58 -0400
Message-ID: <49D47653.90507@panasas.com>
Date: Thu, 02 Apr 2009 11:24:51 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 08/17] bio: reimplement bio_copy_user_iov()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-9-git-send-email-tj@kernel.org> <49D38D4B.7020701@panasas.com> <49D3FF7F.2070505@kernel.org>
In-Reply-To: <49D3FF7F.2070505@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2009 08:26:54.0274 (UTC) FILETIME=[C7906A20:01C9B36C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2009 02:57 AM, Tejun Heo wrote:
> Hello, Boaz.
> 
> Boaz Harrosh wrote:
>> I've looked hard and deep into your patchset, and I would like to
>> suggest an improvement.
>>
>> [Option 1]
>> What your code is actually using from sgl-code base is:
>>  for_each_sg
>>  sg_mapping_iter and it's
>> 	sg_miter_start, sg_miter_next
>>  ... (what else)
>>
>> I would like if you can define above for bvec(s) just the way you like
>> them. Then code works directly on the destination bvect inside the final
>> bio. One less copy no intermediate allocation, and no kmalloc of
>> bigger-then-page buffers.
>>
>> These are all small inlines, duplicating those will not affect
>> Kernel size at all. You are not using the chaining ability of sgl(s)
>> so it can be simplified. You will see that not having the intermediate
>> copy simplifies the code even more.
>>
>> Since no out-side user currently needs sgl(s) no functionality is lost.
> 
> Yeah, we can switch to dealing with bvecs instead of sgls.  For kernel
> mappings, it wouldn't make any difference.  For user single mappings,
> it'll remove an intermediate step.  For user sg mappings, if we make
> gup use sgl, it won't make much difference.

"gup use sgl" was just a stupid suggestion to try eliminate one more
allocation. Realy Realy stupid.

for gup there is a much better, safer, way. Just allocate on the stack
a constant size say 64 pointers and add an inner-loop on the 64 pages.
The extra code loop is much cheaper then an allocation and is one less
point of failure.

So now that we got gup out of the way, will you go directly to bvecs?

The goal is to have NO allocations at all.

> 
> Frankly, for copy paths, I don't think all this matters at all.  If
> each request is small, other overheads will dominate.  For large
> requests, copying to and from sgl isn't something worth worrying
> about.

It is. Again, I tested that. Each new allocation in the order of
the number of pages in a request adds 3-5% on a RAM I/O

And it adds a point of failure. The less the better.

> For mapping paths, if we change gup to use sgl (we really can't make
> it swallow bvec), I don't think it will make whole lot of difference
> one way or the other.  It might end up using slightly more cachelines,
> but that will be about it.
> 

gup to use sgl, is out of the way, that was stupid idea to try eliminate
one more dynamic allocation. 

> I do agree using bvec as internal page carrier would be nicer (sans
> having to implement stuff manually) but I'm not convinced whether
> it'll be worth the added code.
> 

We can reach a point where there is no intermediate dynamic alloctions
and no point of failures, but for the allocation of the final bio+biovec.

And that "implement stuff manually" will also enable internal bio
code cleanups since now biovec is that much smarter.

<snip> 
>> And I have one more question.  Are you sure kmalloc of
>> bigger-then-page buffers are safe?
> 
> It has higher chance of failure but is definitely safe.
> 

Much much higher, not just 100% higher. And it will kill the
use of block-layer in nommu systems.

>> As I understood it, that tries to allocate physically contiguous
>> pages which degrades as time passes, and last time I tried this with
>> a kmem_cache (do to a bug) it crashed the kernel randomly after 2
>> minutes of use.
> 
> Then, that's a bug.  

Fixing the bug will not help, the allocation will fail and the IO will
not get through.

> Yeah, high order allocations fail more easily as
> time passes.  But low order (1 maybe 2) allocations aren't too bad.

No, we are not talking about 1 or 2. Today since Jens put the scatterlist
chaining we can have lots and lots of them chained together. At the time
Jens said that bio had the chaining option for a long time, only scatterlists
limit the size of the request.

> If it matters we can make bio_kmalloc() use vmalloc() for bvecs if it
> goes over PAGE_SIZE but again given that nobody reported the

No that is a regression, vmaloc is an order of a magnitude slower then
just plain BIO chaining

spurious
> GFP_DMA in bounce_gfp which triggers frenzy OOM killing spree for
> large SG_IOs, I don't think this matters all that much.
> 

This BUG was only for HW, ie ata. But for stuff like iscsi FB sas
they did fine.

The fact of the matter is that people, me included, run in systems with
very large request for a while now, large like 4096 pages which is
16 chained bios. Do you want to allocate that with vmalloc?

> Thanks.
> 

I love your cleanups, and your courage, which I don't have.
I want to help in any way I can. If you need just tell me  what,
and I'll be glad to try or test anything. This is fun I like to work
and think on these things

Thanks
Boaz


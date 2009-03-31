Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbZCaNHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbZCaNHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZCaNHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:07:32 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:26516 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752823AbZCaNHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:07:30 -0400
Message-ID: <49D214E7.2040908@panasas.com>
Date: Tue, 31 Mar 2009 16:04:39 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc	cleanups
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <200903281451.01361.bzolnier@gmail.com> <20090328140405.GA2741@liondog.tnic> <49D08CEC.3010705@kernel.org> <49D0A985.7090307@panasas.com> <49D0FF56.3080205@kernel.org> <49D1D7A3.40303@panasas.com> <49D1DCE2.1050201@kernel.org>
In-Reply-To: <49D1DCE2.1050201@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2009 13:06:36.0761 (UTC) FILETIME=[85E13490:01C9B201]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2009 12:05 PM, Tejun Heo wrote:
> Hello, Boaz.
> 
> Boaz Harrosh wrote:
>> I hope you have not been working on stabilizing this code yet, I've
>> just seen it this mornning (Israel time). It has obvious bugs, in
>> the use of scatterlists.
> 
> Actually, I'm now and it's mostly working now.
> 

hmm, I've seen for example use of:
sg_set_page(&sg,,)   on a stack scatterlist entry, and call to a function
that does for_each_sg(), but the for_each_sg() looks for a terminating bit.
You must do sg_init_one() or sg_init_table() first.

Are these code paths exercised?

>> But before you go running to fix them. Don't. I don't like the
>> scatter-list API at all. We where working hard to remove them from
>> scsi and I don't like them for block layer either.
>>
>> If it is for my personal needs then all I need is a simple: "I have
>> this bio please attach it to a request". The reason I have a bio is
>> because it comes from a filesystem and because I will be needing to
>> use the raid engines that are bio based.
>>
>> I must have confused you with my blk_rq_map_pages() patches, these
>> where made just as an example of the ugliness and fragility of not
>> using bios. It was suppose to be a bad example, not to be
>> accepted. (Hence the absence of my Singed-off-by:) Scatterlists are
>> bad because they are two times too fat for what they do here, they
>> need to be allocated, chained and slabbed, and finally they need to
>> be converted to a bio. Working directly with a bio is the shortest
>> route.
> 
> sgl or bvec doesn't make much of difference.  The only difference
> between sgl and bvec is the extra entries for DMA mapping.  

Exactly, and in 32bit largemem that part is 200% of the first
part, so bvec can be 33% of sgl at times, and 50% usually.

> The
> problem is that there needs to be common way to describe the pages.
> The reason why the blk/bio mapping looks that complex is because all
> four cases - user map/copy and kern map/copy - are similar but subtly
> different.  Without a common medium to carry the list of pages, each
> path ended up mixing what's common with what's different and thus the
> not quite manageable code.

Yes, the mess is more historical, and patch by patch wise, then actual
technical difficulty. And it is more accommodating to what user code has
at hand then what makes block-layer clean.

> 
> The reason why I want with sgl is because it's the sg mapping
> iterator.  

Actually no! "sg mapping iterator" success. it has that chaining
ugliness and bit markers. And all that missing information from it.
It was born out of necessity, and was a nightmare to stabilize around
the 2.6.21st kernel if I remember correctly.

At the time there was that long argument of it needing to be an sg_table
and chained at the table level. Because look how much information is missing
form a scatterlist. Like the length, the allocated size associated data, ... 
scatterlist is both too large and too little to be a nice carrier structure
for pages.

Other than that, using bvec or sgl wouldn't make any
> difference.  All that's necessary is common carrier of page/offset/len
> list.
> 

bvec has the same shortages as a scatterlist, a good carrier is a bio

> But given the use of sgl there, I don't think the performance
> arguments holds much ground.  How high performance or scalability is
> required in PC bio map paths?  The added cost is at the most one more
> sgl allocation and use of more sparse data structure which BTW
> wouldn't be that large anyway.  

One pageful of scatterlist can be as small as 128 nents. This is a stupid
512K. This is way too small for any real IO. Start chaining these and you get
a nightmare. The governing structure should be something much longer, and smarter.
(Don't even think of allocating something linearly bigger then one page
it does not work).

> Both aren't worth worrying about
> considering how relative coldness of the path and other overhead of
> doing IO.
> 

Not true, with ram-disk performance benchmarks we could see 3-6% difference
with an extra sccaterlist allocation. SSDs and RDMA devices come close to
ram disk performance these days.

> If you think sgl is too heavy for things like this, the right way to
> go is to introduce some generic mechanism to carry sg chunks and use
> it in bio, but I don't think the overhead of the current sgl justifies
> that.  If you have qualms about the sgl API, please clean it up.  

sgl is a compromise with historical code at the DMA and LLD level.
It should not have any new users above the block layer.

> I
> just don't think bvec should be used outside of block/fs interface.
> As I wrote before, non-FS users have no reason to worry about bio.
> All it should think about is the requst it needs to issue and the
> memory area it's gonna use as in/out buffers.  bio just doesn't have a
> place there.
> 

I don't understand what happens to all the people that start to work on the block
layer, they start getting defensive about bio being private to the request
level. But the Genie is out of the bag already (I know cats and bottles).
bio is already heavily used above the block layer from directly inside filesystems
to all kind of raid engines, DM MD managers, multi paths, integrity information ...

Because bio is exactly that Ideal page carrier you are talking about.
The usage pattern needed by everybody everywhere is:
Allocate an abstract container starting empty. add some pages to it,
grow / chain endlessly as needed, (or as constrained from other factors).
Submit it down the stack. Next stage can re-use it, split it, merge it, mux
it demux it, bounce it, hang event notifiers, the works.

The only such structure today is a bio. If an API should be cleaned up it
is the bio API. Add the nice iterator to it if you like sg_next() a lot.

Make it so clean that all users of block-request take a bio, easily add
pages / memory segments to it, and then submit it into a request with a single
API, blk_req_add_bio(). or better blk_make_request(bio).

Inventing half baked intermediate linear structures will not hold.

>> I do not understand what was your intention for the
>> blk_rq_map_kern_sgl() how's the user for it?
> 
> Well, the only in-kern user which was tinkering with rq/bio internals
> was scsi_req_map_sg().  Do you have another user?
> 

scsi_req_map_sg() is gone. All its users now go directly to blk_rq_map_*
and submit requests directly. So there are no external users of sgl.
(Should be submitted soon)

>> BTW: now you absolutely must do something with the name of
>> blk_rq_map_sg() which does not do any mapping and does not change
>> request at all.
> 
> Heh... yeap, definitely.  Can you think of a good one?
> 

I would say blk_rq_fill_sgl, maybe

> Thanks.
> 

Other then the sgl usage I like your clean ups a lot, I do however have
some comments. Should I hold these until you post them or start shooting
away?

Thanks
Boaz

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763147AbZDALxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763147AbZDALxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZDALw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:52:57 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:18515 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755542AbZDALwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:52:55 -0400
Message-ID: <49D35518.3040901@panasas.com>
Date: Wed, 01 Apr 2009 14:50:48 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc	cleanups
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <200903281451.01361.bzolnier@gmail.com> <20090328140405.GA2741@liondog.tnic> <49D08CEC.3010705@kernel.org> <49D0A985.7090307@panasas.com> <49D0FF56.3080205@kernel.org> <49D1D7A3.40303@panasas.com> <49D1DCE2.1050201@kernel.org> <49D214E7.2040908@panasas.com> <49D21DF8.1020302@kernel.org>
In-Reply-To: <49D21DF8.1020302@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 11:52:52.0723 (UTC) FILETIME=[635C5430:01C9B2C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2009 04:43 PM, Tejun Heo wrote:
> Hello, Boaz.
> 
Hi Tejun

> Boaz Harrosh wrote:
>> On 03/31/2009 12:05 PM, Tejun Heo wrote:
>>> Hello, Boaz.
>>>
> 
>>> sgl or bvec doesn't make much of difference.  The only difference
>>> between sgl and bvec is the extra entries for DMA mapping.  
>> Exactly, and in 32bit largemem that part is 200% of the first
>> part, so bvec can be 33% of sgl at times, and 50% usually.
> 
> And why would all that matter for temporary short-lived sgls on a
> relatively cold path?
> 

It's use is un-common yes, but it is not cold. It is very hot for it's
users. Any SG_IO users from sg, bsg and other go threw here sometimes
very hotly.

My benchmarks where done with the sg3_dd utility, going threw sg.c
for direct IO submission. (sg3 utils package)

I will use some such path for the exofs filesystem which is very
hot for me

> 
> What?  If you're unhappy with sgl interface, improve it.  Don't go
> around it.  Yeah, it took some work to work the sgl changes out but
> it's stable now, so why not use it?
> 

I hate it, but pragmatically I will be too lazy to do anything
about it.

Again it is heavily used low down in drivers land, and DMA times
which is what it is. It is not used in mm or VFS or user-mode-to-kernel.
I thought we where talking about the interface above block layer.
scatter lists have no place there.

>> At the time there was that long argument of it needing to be an
>> sg_table and chained at the table level. Because look how much
>> information is missing form a scatterlist. Like the length, the
>> allocated size associated data, ...  scatterlist is both too large
>> and too little to be a nice carrier structure for pages.
> 
> Again, then, please go ahead and improve it.  Whether you like it or
> not, it's the de-facto standard segment carrying structure which is
> widely used.  You can't go around that.
> 
>> Other than that, using bvec or sgl wouldn't make any
>>> difference.  All that's necessary is common carrier of page/offset/len
>>> list.
>>>
>> bvec has the same shortages as a scatterlist, a good carrier is a bio
> 
> bio is _NOT_ designed to be a generic page carrier.  Please do not
> abuse the interface just because the code is there.  If you think the
> currnent sg code is lacking, improve it and then apply it to bio if
> possible, don't twist and abuse bio.
> 

I'm only using bio the exact same way as other filesystems. The only
difference is that I need it with a block_pc command.

>>> But given the use of sgl there, I don't think the performance
>>> arguments holds much ground.  How high performance or scalability is
>>> required in PC bio map paths?  The added cost is at the most one more
>>> sgl allocation and use of more sparse data structure which BTW
>>> wouldn't be that large anyway.  
>> One pageful of scatterlist can be as small as 128 nents. This is a
>> stupid 512K. This is way too small for any real IO. Start chaining
>> these and you get a nightmare. The governing structure should be
>> something much longer, and smarter.  (Don't even think of allocating
>> something linearly bigger then one page it does not work).
> 
> I'm not trying to use sgl inside block layer.  I'm using it as page
> carrier for kernel API (what else would you use?) and page carrier for
> internal implementation because sgl has some useful helpers to deal
> with them.
> 
>>> Both aren't worth worrying about considering how relative coldness
>>> of the path and other overhead of doing IO.
>> Not true, with ram-disk performance benchmarks we could see 3-6% difference
>> with an extra sccaterlist allocation. SSDs and RDMA devices come close to
>> ram disk performance these days.
> 
> And you're doing that via PC requests using blk_rq_map_*() interface?
> Wouldn't those IOs go through regular bio channel?
> 

Sure, that's the point. I need a block_pc command interface that is just as
hot as current "regular bio channel".

And so do CD-burners, tapes, you name it. Any none FS heavy usage of
scsi devices, who's usage does not fit the narrow READ/WRITE flat array
of sectors. They can have very heavy I/O, osd for instance.

>>> If you think sgl is too heavy for things like this, the right way to
>>> go is to introduce some generic mechanism to carry sg chunks and use
>>> it in bio, but I don't think the overhead of the current sgl justifies
>>> that.  If you have qualms about the sgl API, please clean it up.  
>> sgl is a compromise with historical code at the DMA and LLD level.
>> It should not have any new users above the block layer.
> 
> bio is something which should be exported outside of block layer?
> 

It is today, it's used in the interface between filesystems and block-layer
and in-between stacked block devices.

>>> I just don't think bvec should be used outside of block/fs
>>> interface.  As I wrote before, non-FS users have no reason to worry
>>> about bio.  All it should think about is the requst it needs to
>>> issue and the memory area it's gonna use as in/out buffers.  bio
>>> just doesn't have a place there.
>> I don't understand what happens to all the people that start to work
>> on the block layer, they start getting defensive about bio being
>> private to the request level. But the Genie is out of the bag
>> already (I know cats and bottles).  bio is already heavily used
>> above the block layer from directly inside filesystems to all kind
>> of raid engines, DM MD managers, multi paths, integrity information
>> ...
>>
>> Because bio is exactly that Ideal page carrier you are talking about.
>> The usage pattern needed by everybody everywhere is:
>> Allocate an abstract container starting empty. add some pages to it,
>> grow / chain endlessly as needed, (or as constrained from other factors).
>> Submit it down the stack. Next stage can re-use it, split it, merge it, mux
>> it demux it, bounce it, hang event notifiers, the works.
>>
>> The only such structure today is a bio. If an API should be cleaned up it
>> is the bio API. Add the nice iterator to it if you like sg_next() a lot.
>>
>> Make it so clean that all users of block-request take a bio, easily add
>> pages / memory segments to it, and then submit it into a request with a single
>> API, blk_req_add_bio(). or better blk_make_request(bio).
>>
>> Inventing half baked intermediate linear structures will not hold.
> 
> Thanks for the credit but I didn't invent sgl.
> 
> bio is unit of block IO viewed from filesystems.  Let's leave it
> there.  If you're unhappy with sg_table or sgl, what needs to be done
> is extending sg_table such that it does all the great things you
> described above and then integrating it into bio.  If the extra fields
> for DMA mapping matters, create a new structure which will be used for
> that purpose and build API around it and then replace private bvec
> handling inside bio and apply the new API gradually replacing sgl
> usages where it makes sense.
> 
> In all seriousness, using bio as generic page list carrier is a
> horrible horrible idea.  That's a path which will lead to strange
> situations.  bio isa an interface tightly tied to block and fs
> interface.  No one else has any business playing with it.  md/dm got
> caught up inbetween and I know that people haven't been happy with the
> situation and there haven been attempts to move over to request based
> implementation although I don't know what happened thereafter, so
> please stop pushing bio as generic data carrier because it is not and
> should not ever be.
> 
> For now, the only thing that matter is whether to use sgl in
> blk_rq_map_kern_sgl() or not.  I suppose you're pushing for using bio
> instead, right?
> 

Currently I do not see any candidate users for blk_rq_map_kern_sgl().
sg.c was that last user and TOMO has converted that to blk_rq_map_user/_iov
with map_data at places. It should all be going into 2.6.30.

Me I will not use sgl. My main motivation is exofs, an osd based
filesystem, and pNFS-objects-layout driver. Both of which leave in
"fs" space. The only solution, which I currently have implemented,
is using bios. sgl is not an option.

Thanks
Boaz

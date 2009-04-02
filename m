Return-Path: <linux-kernel-owner+w=401wt.eu-S934634AbZDBJ5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634AbZDBJ5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761657AbZDBJ4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:56:47 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:18344 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757834AbZDBJ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:56:46 -0400
Message-ID: <49D48B5E.9060708@panasas.com>
Date: Thu, 02 Apr 2009 12:54:38 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 08/17] bio: reimplement bio_copy_user_iov()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-9-git-send-email-tj@kernel.org> <49D38D4B.7020701@panasas.com> <49D3FF7F.2070505@kernel.org> <49D47653.90507@panasas.com> <49D47E7B.3030209@kernel.org>
In-Reply-To: <49D47E7B.3030209@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2009 09:56:40.0534 (UTC) FILETIME=[52067760:01C9B379]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2009 11:59 AM, Tejun Heo wrote:
> Hello, Boaz.
> 

Hi Tejun

> Boaz Harrosh wrote:

>> So now that we got gup out of the way, will you go directly to bvecs?
> 
> As said before, I don't think exposing bio at the driver interface is
> a good idea copy or not.  For internal implementation, if there's
> enough benefit, yeah.
> 

I want to draw your attention, to something you might be forgetting
sorry not to make it clearer before.

There is no users for blk_rq_map_kern_sgl(), and no need for any such 
driver interface.

This is because there is a pending patchest done by TOMO, which is
in it's 4th incarnation by now, which removes the very last users
of scsi_execute_async() and it's use of sgl. together with all that
mess at scsi_lib.c. Removing scsi_execute_async() will remove the only
potential user of blk_rq_map_kern_sgl(). So it can be killed at birth.

The pachset was tested and debugged by all scsi ULD maintainers
and is in very stable state. I hope it can make it into 2.6.30
but for sure it will make it into 2.6.31, which is the time frame
we are talking about.

James any chance this patchset can make 2.6.30?

Please note that the important historical users of scsi_execute_async()
sg.c and sr.c don't use it already in 2.6.28-29, and the last bugs of that
change, where wrinkled out.

Are there currently in your patchset any other users of blk_rq_map_kern_sgl()?

>>> Frankly, for copy paths, I don't think all this matters at all.  If
>>> each request is small, other overheads will dominate.  For large
>>> requests, copying to and from sgl isn't something worth worrying
>>> about.
>> It is. Again, I tested that. Each new allocation in the order of
>> the number of pages in a request adds 3-5% on a RAM I/O
> 
> Sure, if you do things against ram, anything will show up.  Do you
> have something more realistic?
> 

Reads from some SSDs/FLASH is just as fast as RAM. Battery backup RAM
is very common. Pete Wyckoff reached speeds over RDMA which come close
to RAM.

>> And it adds a point of failure. The less the better.
> 
> That is not the only measure.  Things are always traded off using
> multiple evaluation metrics.  The same goes with the _NO_ allocation
> thing.
> 

>>> I do agree using bvec as internal page carrier would be nicer (sans
>>> having to implement stuff manually) but I'm not convinced whether
>>> it'll be worth the added code.
>> We can reach a point where there is no intermediate dynamic alloctions
>> and no point of failures, but for the allocation of the final bio+biovec.
> 
> There is no need to obsess about no point of failure.  Obsessing about
> single evaluation metric is a nice and fast way toward a mess.
> 

I agree completely. "no mess" - first priority, "no point of failure"
- far behind second. "Lots of work" - not considered

Is there no way we can reach both?

>> And that "implement stuff manually" will also enable internal bio
>> code cleanups since now biovec is that much smarter.
>>
>> <snip> 

> 
> Under enough memory pressure, Non-fs IOs are gonna fail somewhere
> along the line.  If you don't like that, use mempool backed allocation
> or preallocated data structures.  

bio's and bvects do that, no?

> Also, I believe it is generally
> considered better to fail IO than oopsing.  :-P
> 

I agree, exactly my point, eliminate any extra allocation is the
best way for that.

>>> Yeah, high order allocations fail more easily as time passes.  But
>>> low order (1 maybe 2) allocations aren't too bad.
>> No, we are not talking about 1 or 2. Today since Jens put the scatterlist
>> chaining we can have lots and lots of them chained together. At the time
>> Jens said that bio had the chaining option for a long time, only scatterlists
>> limit the size of the request.
> 
> Alright, let's than chain bios but let's please do it inside bio
> proper.
> 

Yes, I completely agree. This can/should be internal bio business.
Doing it this way will also add robustness to other users of bio
like filesystems raid-engines and staking drivers.

Thanks that would be ideal.

>> If it matters we can make bio_kmalloc() use vmalloc() for bvecs if it
>>> goes over PAGE_SIZE but again given that nobody reported the
>> No that is a regression, vmaloc is an order of a magnitude slower then
>> just plain BIO chaining
> 
> It all depends on how frequent those multiple allocations will be.
> 

When they come they come in groups. I'm talking about steady stream
of these that come for minutes. think any streaming application
like backup or plain cp of very large files, video prepossessing, ...
I know, at Panasas we have only these stuff.

>> spurious
>>> GFP_DMA in bounce_gfp which triggers frenzy OOM killing spree for
>>> large SG_IOs, I don't think this matters all that much.
>>>
>> This BUG was only for HW, ie ata. But for stuff like iscsi FB sas
>> they did fine.
> 
> The bug was for all controllers which couldn't do 64bit DMA on 64bit
> machines.
> 
>> The fact of the matter is that people, me included, run in systems
>> with very large request for a while now, large like 4096 pages which
>> is 16 chained bios. Do you want to allocate that with vmalloc?
> 
> The patchset was written the way it's written because I couldn't see
> any pressing performance requirement for the current existing users.
> Optimizing for SG_IO against memory is simply not a good idea.
> 
> If you have in-kernel users which often require large transfers, sure,
> chaining bio would be better.  Still, let's do it _inside_ bio.  Would
> your use case be happy with something like blk_rq_map_kern_bvec(rq,
> bvec) which can append to rq?  If we convert internal implementation
> over to bvec, blk_rq_map_kern_sg() can be sg->bvec converting wrapper
> around blk_rq_map_kern_bvec().
> 

See above I answered that. No need for blk_rq_map_kern_bvec() nor
blk_rq_map_kern_sg(), currently. OSD absolutely needs the direct
use of bios via the fs route, and the other users are going out
fast.

And yes bio chaining at the bio level is a dream come true
for me, and it drops 3 items off my todo list.
Thanks

>> I love your cleanups, and your courage, which I don't have.
> 
> Thanks a lot but it's not like the code and Jens are scary monsters I
> need to slay, so I don't think I'm being particularly courageous.  :-)
> 
>> I want to help in any way I can. If you need just tell me what, and
>> I'll be glad to try or test anything. This is fun I like to work and
>> think on these things
> 
> Great, your reviews are comments are very helpful, so please keep them
> coming.  :-)
> 
> Jens, Tomo, what do you guys think?
> 
> Thanks.
> 

Thank you
Boaz

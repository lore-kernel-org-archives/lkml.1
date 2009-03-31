Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbZCaKi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbZCaKi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZCaKiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:38:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52584 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbZCaKiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:38:18 -0400
Date: Tue, 31 Mar 2009 12:38:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 5/7] vfs: Add  wbcflush sysfs knob to disable storage
	device writeback cache flushes
Message-ID: <20090331103815.GI5178@kernel.dk>
References: <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B978.5030107@oss.ntt.co.jp> <20090330123618.GS5178@kernel.dk> <49D0D4D0.5000108@oss.ntt.co.jp> <20090330143539.GT5178@kernel.dk> <49D1BCE3.8060902@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49D1BCE3.8060902@oss.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31 2009, Fernando Luis Vázquez Cao wrote:
> Jens Axboe wrote:
>> On Mon, Mar 30 2009, Fernando Luis Vázquez Cao wrote:
>>> Jens Axboe wrote:
>>>> On Mon, Mar 30 2009, Fernando Luis Vázquez Cao wrote:
>>>>> Add a sysfs knob to disable storage device writeback cache flushes.
>>>>>
>>>>> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
>>>>> ---
>>>>>
>>>>> diff -urNp linux-2.6.29-orig/block/blk-barrier.c linux-2.6.29/block/blk-barrier.c
>>>>> --- linux-2.6.29-orig/block/blk-barrier.c	2009-03-24 08:12:14.000000000 +0900
>>>>> +++ linux-2.6.29/block/blk-barrier.c	2009-03-30 17:08:28.000000000 +0900
>>>>> @@ -318,6 +318,9 @@ int blkdev_issue_flush(struct block_devi
>>>>>  	if (!q)
>>>>>  		return -ENXIO;
>>>>>
>>>>> +	if (blk_queue_nowbcflush(q))
>>>>> +		return -EOPNOTSUPP;
>>>>> +
>>>>>  	bio = bio_alloc(GFP_KERNEL, 0);
>>>>>  	if (!bio)
>>>>>  		return -ENOMEM;
>>>>> diff -urNp linux-2.6.29-orig/block/blk-core.c linux-2.6.29/block/blk-core.c
>>>>> --- linux-2.6.29-orig/block/blk-core.c	2009-03-24 08:12:14.000000000 +0900
>>>>> +++ linux-2.6.29/block/blk-core.c	2009-03-30 17:08:28.000000000 +0900
>>>>> @@ -1452,7 +1452,8 @@ static inline void __generic_make_reques
>>>>>  			goto end_io;
>>>>>  		}
>>>>>  		if (bio_barrier(bio) && bio_has_data(bio) &&
>>>>> -		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
>>>>> +		    (blk_queue_nowbcflush(q) ||
>>>>> +		     q->next_ordered == QUEUE_ORDERED_NONE)) {
>>>>>  			err = -EOPNOTSUPP;
>>>>>  			goto end_io;
>>>>>  		}
>>>> This (and the above hunk) should be changed. -EOPNOTSUPP means the
>>>> target does not support barriers, that is a different thing to flushes
>>>> not being needed. A file system issuing a barrier and getting
>>>> -EOPNOTSUPP back will disable barriers, since it now thinks that
>>>> ordering cannot be guaranteed.
>>> The reason I decided to use -EOPNOTSUPP was that I wanted to keep
>>> barriers and device flushes from entering the block layer when
>>> they are not needed. I feared that if we pass them down the block
>>> stack (knowing in advance they will not be actually submitted to
>>> disk) we may end up slowing things down unnecessarily.
>>
>> But that's just wrong, you need to make sure that the block layer / io
>> scheduler doesn't reorder as well. It's a lot more complex than just the
>> device end. So just returning -EOPNOTSUPP and pretending that you need
>> not use barriers at the fs end is just wrong.
>
> I should have mentioned that in this patch set I was trying to tackle the
> blkdev_issue_flush() case only. As you pointed out, with the code above
> requests may get silently reordered across barriers inside the block layer.
>
> The follow-up patch I am working on implements blkdev_issue_empty_barrier(),
> which should be used by filesystems that want to emit an empty barrier (as
> opposed to just triggering a device flush). Doing this we can optimize
> fsync() flushes (block_flush_device()) and filesystem-originated barriers
> (blkdev_issue_empty_barrier()) independently in the block layer.

Not sure it makes sense to abstract that out into an api, it's basically
just a bio_alloc(gfp, 0); with setting the bio fields and then
submitting. Otherwise you'd have to either pass a ton of parameters, the
caller will want to set end_io, bdev, etc anyway. And after that it's
just submit_bio().

> I agree with you that the we should pass barriers down in
> __generic_make_request, but the optimization above for fsync()-originated
> blkdev_issue_flush()'s seems valid to me.

Of course, we need to do that. Anything else would be broken. The
blkdev_issue_flush() should be changed to return 0, with the -EOPNOTSUPP
being flag cached.

-- 
Jens Axboe


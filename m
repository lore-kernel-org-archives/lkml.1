Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZC3OTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZC3OTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZC3OS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:18:59 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57186 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZC3OS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:18:59 -0400
Message-ID: <49D0D4D0.5000108@oss.ntt.co.jp>
Date: Mon, 30 Mar 2009 23:18:56 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
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
References: <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B978.5030107@oss.ntt.co.jp> <20090330123618.GS5178@kernel.dk>
In-Reply-To: <20090330123618.GS5178@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Mar 30 2009, Fernando Luis Vázquez Cao wrote:
>> Add a sysfs knob to disable storage device writeback cache flushes.
>>
>> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
>> ---
>>
>> diff -urNp linux-2.6.29-orig/block/blk-barrier.c linux-2.6.29/block/blk-barrier.c
>> --- linux-2.6.29-orig/block/blk-barrier.c	2009-03-24 08:12:14.000000000 +0900
>> +++ linux-2.6.29/block/blk-barrier.c	2009-03-30 17:08:28.000000000 +0900
>> @@ -318,6 +318,9 @@ int blkdev_issue_flush(struct block_devi
>>  	if (!q)
>>  		return -ENXIO;
>>
>> +	if (blk_queue_nowbcflush(q))
>> +		return -EOPNOTSUPP;
>> +
>>  	bio = bio_alloc(GFP_KERNEL, 0);
>>  	if (!bio)
>>  		return -ENOMEM;
>> diff -urNp linux-2.6.29-orig/block/blk-core.c linux-2.6.29/block/blk-core.c
>> --- linux-2.6.29-orig/block/blk-core.c	2009-03-24 08:12:14.000000000 +0900
>> +++ linux-2.6.29/block/blk-core.c	2009-03-30 17:08:28.000000000 +0900
>> @@ -1452,7 +1452,8 @@ static inline void __generic_make_reques
>>  			goto end_io;
>>  		}
>>  		if (bio_barrier(bio) && bio_has_data(bio) &&
>> -		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
>> +		    (blk_queue_nowbcflush(q) ||
>> +		     q->next_ordered == QUEUE_ORDERED_NONE)) {
>>  			err = -EOPNOTSUPP;
>>  			goto end_io;
>>  		}
> 
> This (and the above hunk) should be changed. -EOPNOTSUPP means the
> target does not support barriers, that is a different thing to flushes
> not being needed. A file system issuing a barrier and getting
> -EOPNOTSUPP back will disable barriers, since it now thinks that
> ordering cannot be guaranteed.

The reason I decided to use -EOPNOTSUPP was that I wanted to keep
barriers and device flushes from entering the block layer when
they are not needed. I feared that if we pass them down the block
stack (knowing in advance they will not be actually submitted to
disk) we may end up slowing things down unnecessarily.

As you mentioned, filesystems such as ext3/4 will disable
barriers if they get -EOPNOTSUPP when issuing one. I was planning
to add a notifier mechanism so that we can notify filesystems has
been a change in the barrier settings. This might be
over-engineering, though. Especially considering that "-o
remount,barrier=1" will bring us the barriers back.

> A more appropriate change would be to successfully complete a flush
> without actually sending it down to the device if blk_queue_nowbcflush()
> is true. Then blkdev_issue_flush() would just work as well. It also
> needs to take stacking into account, or stacked drivers will have to
> propagate the settings up the stack. If you allow simply the barrier to
> be passed down, you get that for free.

Aren't we risking slowing things down? Does the small optimization above
make sense (especially taking the remount trick into account)?

Maybe I am worrying too much about the possible performance penalty.

>> +static struct queue_sysfs_entry queue_wbcflush_entry = {
>> +	.attr = {.name = "wbcflush", .mode = S_IRUGO | S_IWUSR },
>> +	.show = queue_wbcflush_show,
>> +	.store = queue_wbcflush_store,
>> +};
>> +
> 
> Naming is also pretty bad, perhaps something like "honor_cache_flush"
> would be better, or perhaps "cache_flush_needed". At least something
> that is more descriptive of this setting actually controls, wbcflush
> does not do that.

You are right, wbcflush is a pretty ugly name. I will use
"honor_cache_flush" in the next iteration of the patches.


Thanks,

Fernando

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbZIHCDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbZIHCDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 22:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZIHCDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 22:03:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62864 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbZIHCDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 22:03:54 -0400
Message-ID: <4AA5BB3E.4050808@cn.fujitsu.com>
Date: Tue, 08 Sep 2009 10:02:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] trace bio queueing trial only when it occurs
References: <20090908093416.5a2f98b6.minchan.kim@barrios-desktop> <20090908005520.GA7967@localhost>
In-Reply-To: <20090908005520.GA7967@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> Minchan,
> 
> I tend to agree with the change, but somehow confused by blkparse(1):
> 
>         Q -- queued   This notes *intent* to queue i/o at the given location.  No real requests exists yet.
> 
> Li Zefan has been working on blktrace and he can tell more.
> 

I work on ftrace-plugin blktrace and blk TRACE_EVENT, but don't know
much about the old blktrace history. ;)

I think the manpage says it's called before ->make_request_fn(), so
"No real requests exist yet".

Actually the trace was called just before make_request at first:
	2056a782f8e7e65fd4bfd027506b4ce1c5e9ccd4

And then 2 patches added some checks between them:
	5ddfe9691c91a244e8d1be597b6428fcefd58103
	51fd77bd9f512ab6cc9df0733ba1caaab89eb957

It seems to me it makes sense to have this patch.

> Thanks,
> Fengguang
> 
> On Tue, Sep 08, 2009 at 08:34:16AM +0800, Minchan Kim wrote:
>> It got lost in LKML mail storm.
>> I resend this.
>> Wu, Could you review this patch, please?
>>
>> == CUT_HERE ==
>>
>> If BIO is discarded or cross over end of device,
>> BIO queueing trial doesn't occur.
>>
>> Let's trace it only when it happens.
>>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  block/blk-core.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 5b59592..1a0cfd5 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1463,8 +1463,6 @@ static inline void __generic_make_request(struct bio *bio)
>>  		if (old_sector != -1)
>>  			trace_block_remap(q, bio, old_dev, old_sector);
>>
>> -		trace_block_bio_queue(q, bio);
>> -
>>  		old_sector = bio->bi_sector;
>>  		old_dev = bio->bi_bdev->bd_dev;
>>
>> @@ -1477,6 +1475,8 @@ static inline void __generic_make_request(struct bio *bio)
>>  			goto end_io;
>>  		}
>>
>> +		trace_block_bio_queue(q, bio);
>> +
>>  		ret = q->make_request_fn(q, bio);
>>  	} while (ret);
>>
>> --
>> 1.6.4
>>
>>
>>

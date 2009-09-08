Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbZIHEKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbZIHEKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 00:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZIHEKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 00:10:54 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:55936 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZIHEKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 00:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UTM8k39MQPQJEuEJxPt5giskW/ekJgPWWxEhCMD05iWY0iLSECl+AbhN6MSJfQdQsJ
         vyiy7cVV35NdQQyAIDFwOMuuGARkXdqGrQbNwt1Mqs51frV8ycpb3Jkz4ee0jSHJSBQk
         6ZbYkW8obyIRbrTOSJZ6d7eksxZFL35eUzHmc=
MIME-Version: 1.0
In-Reply-To: <4AA5BB3E.4050808@cn.fujitsu.com>
References: <20090908093416.5a2f98b6.minchan.kim@barrios-desktop>
	 <20090908005520.GA7967@localhost> <4AA5BB3E.4050808@cn.fujitsu.com>
Date: Tue, 8 Sep 2009 13:10:55 +0900
Message-ID: <28c262360909072110j8ef5962h7231be5c03d68da3@mail.gmail.com>
Subject: Re: [PATCH] trace bio queueing trial only when it occurs
From: Minchan Kim <minchan.kim@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 11:02 AM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> Wu Fengguang wrote:
>> Minchan,
>>
>> I tend to agree with the change, but somehow confused by blkparse(1):
>>
>>         Q -- queued   This notes *intent* to queue i/o at the given location.  No real requests exists yet.
>>
>> Li Zefan has been working on blktrace and he can tell more.
>>
>
> I work on ftrace-plugin blktrace and blk TRACE_EVENT, but don't know
> much about the old blktrace history. ;)
>
> I think the manpage says it's called before ->make_request_fn(), so
> "No real requests exist yet".
>
> Actually the trace was called just before make_request at first:
>        2056a782f8e7e65fd4bfd027506b4ce1c5e9ccd4
>
> And then 2 patches added some checks between them:
>        5ddfe9691c91a244e8d1be597b6428fcefd58103
>        51fd77bd9f512ab6cc9df0733ba1caaab89eb957
>
> It seems to me it makes sense to have this patch.

Thanks for good information.
Yes. It seems above 2 patches seem to break the rule.
Could I add your ACK?

>> Thanks,
>> Fengguang
>>
>> On Tue, Sep 08, 2009 at 08:34:16AM +0800, Minchan Kim wrote:
>>> It got lost in LKML mail storm.
>>> I resend this.
>>> Wu, Could you review this patch, please?
>>>
>>> == CUT_HERE ==
>>>
>>> If BIO is discarded or cross over end of device,
>>> BIO queueing trial doesn't occur.
>>>
>>> Let's trace it only when it happens.
>>>
>>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>>> ---
>>>  block/blk-core.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 5b59592..1a0cfd5 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -1463,8 +1463,6 @@ static inline void __generic_make_request(struct bio *bio)
>>>              if (old_sector != -1)
>>>                      trace_block_remap(q, bio, old_dev, old_sector);
>>>
>>> -            trace_block_bio_queue(q, bio);
>>> -
>>>              old_sector = bio->bi_sector;
>>>              old_dev = bio->bi_bdev->bd_dev;
>>>
>>> @@ -1477,6 +1475,8 @@ static inline void __generic_make_request(struct bio *bio)
>>>                      goto end_io;
>>>              }
>>>
>>> +            trace_block_bio_queue(q, bio);
>>> +
>>>              ret = q->make_request_fn(q, bio);
>>>      } while (ret);
>>>
>>> --
>>> 1.6.4
>>>
>>>
>>>
>



-- 
Kind regards,
Minchan Kim

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZLEKst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZLEKst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 05:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbZLEKss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 05:48:48 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:50235 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZLEKsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 05:48:47 -0500
X-Greylist: delayed 58462 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Dec 2009 05:48:47 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ucfLHnL4ndmMDvutt5/TyOBn3zLOZmkPxmp2SSh9rEFUrElTTAS0DwKFJPxP7eZbs1
         /xIic/6vapFHWRykceMX0GO48vyoMageSlZ1I4gCZIKPxFiZuVQgtp5X5bwGY+ejuVLR
         pjtU/pLFj6zQMNsZsvXChgOgcMl0l8uJkcM1U=
MIME-Version: 1.0
In-Reply-To: <20091205085051.GC8742@kernel.dk>
References: <20091203035330.GB13165@sli10-desk.sh.intel.com>
	 <20091203115740.GM8742@kernel.dk>
	 <4e5e476b0912041034h2a2c53fdh16ddb6523c4917cd@mail.gmail.com>
	 <20091205085051.GC8742@kernel.dk>
Date: Sat, 5 Dec 2009 11:48:54 +0100
Message-ID: <4e5e476b0912050248l2c6365e7qfa36ba467da7da8b@mail.gmail.com>
Subject: Re: [RFC]cfq-iosched: no dispatch limit for single queue
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 5, 2009 at 9:50 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Fri, Dec 04 2009, Corrado Zoccolo wrote:
>> Hi Shaohua, Jens,
>> On Thu, Dec 3, 2009 at 12:57 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> > On Thu, Dec 03 2009, Shaohua Li wrote:
>> >> Since commit 2f5cb7381b737e24c8046fd4aeab571fb71315f5, each queue can send
>> >> up to 4 * 4 requests if only one queue exists. I wonder why we have such limit.
>> >> Device supports tag can send more requests. For example, AHCI can send 31
>> >> requests. Test (direct aio randread) shows the limits reduce about 4% disk
>> >> thoughput.
>> >> On the other hand, since we send one request one time, if other queue
>> >> pop when current is sending more than cfq_quantum requests, current queue will
>> >> stop send requests soon after one request, so sounds there is no big latency.
>> >>
>> >> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>> >>
>> >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> >> index aa1e953..e05650f 100644
>> >> --- a/block/cfq-iosched.c
>> >> +++ b/block/cfq-iosched.c
>> >> @@ -1298,9 +1298,9 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>> >>                       return false;
>> >>
>> >>               /*
>> >> -              * Sole queue user, allow bigger slice
>> >> +              * Sole queue user, no limit
>> >>                */
>> >> -             max_dispatch *= 4;
>> >> +             max_dispatch = -1;
>> >>       }
>> >>
>> >>       /*
>> >
>> > As you mention, we do dispatches in bites of 1. In reality, there's
>> > going to be little difference when we get this far in the depth process,
>> > so I think the patch looks good. I have applied it, thanks.
>>
>> I think the limit should be removed only for sync queues.
>> For async queues, if cfq_latency is not set, removing the limit here can
>> cause very high latencies to sync queues (almost 100% increase),
>> without a noticeable throughput gain.
>
> It's always problematic to say 'without a noticable throughput gain', as
> on some workloads/storage, the difference between 16 and eg 32 in depth
> WILL be noticeable.
For async writes, I think that the hardware that could benefit of 32
parallel requests
(e.g. RAIDs with > 8 disks), already has a big write cache, so 16 or 32 doesn't
really matter for them. It matters, instead, on single SATA disk with NCQ, where
having 31 pending requests instead of 16 will increase the latency of subsequent
reads by 120ms in worst case.

> 16 is already high enough that if we hit that limit,
> it will cause a latency hit. The hope here is that larger wont make it
> much worse, but we'll see.
Ok. Maybe, when one sets low_latency = 0, having also the highest
write throughput
is desired, so the additional latency will not be a problem.

Thanks,
Corrado

>
> --
> Jens Axboe
>
>

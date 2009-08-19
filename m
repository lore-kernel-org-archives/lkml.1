Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbZHSNWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbZHSNWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZHSNWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:22:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58820 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZHSNWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:22:08 -0400
Message-ID: <4A8BFC79.1000004@garzik.org>
Date: Wed, 19 Aug 2009 09:22:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: use single threaded work queue
References: <20090819112554.GY12579@kernel.dk> <4A8BE932.5090300@garzik.org> <20090819120458.GZ12579@kernel.dk> <4A8BECC2.2060607@rtr.ca> <20090819122320.GA12579@kernel.dk>
In-Reply-To: <20090819122320.GA12579@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2009 08:23 AM, Jens Axboe wrote:
> On Wed, Aug 19 2009, Mark Lord wrote:
>> Jens Axboe wrote:
>>> On Wed, Aug 19 2009, Jeff Garzik wrote:
>>>> On 08/19/2009 07:25 AM, Jens Axboe wrote:
>>>>> Hi,
>>>>>
>>>>> On boxes with lots of CPUs, we have so many kernel threads it's not
>>>>> funny. The basic problem is that create_workqueue() creates a per-cpu
>>>>> thread, where we could easily get by with a single thread for a lot of
>>>>> cases.
>>>>>
>>>>> One such case appears to be ata_wq. You want at most one per pio drive,
>>>>> not one per CPU. I'd suggest just dropping it to a single threaded wq.
>>>>>
>>>>> Signed-off-by: Jens Axboe<jens.axboe@oracle.com>
>>>>>
>>>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>>>> index 072ba5e..0d78628 100644
>>>>> --- a/drivers/ata/libata-core.c
>>>>> +++ b/drivers/ata/libata-core.c
>>>>> @@ -6580,7 +6580,7 @@ static int __init ata_init(void)
>>>>>    {
>>>>>    	ata_parse_force_param();
>>>>>
>>>>> -	ata_wq = create_workqueue("ata");
>>>>> +	ata_wq = create_singlethread_workqueue("ata");
>>>>>    	if (!ata_wq)
>>>>>    		goto free_force_tbl;
>>>>
>>>> I agree with one-thread-per-cpu is too much, in these modern
>>>> multi-core  times, but one thread is too little.  You have
>>>> essentially re-created  simplex DMA -- blocking and waiting such that
>>>> one drive out of ~4 can be  used at any one time.
>>>>
>>>> ata_pio_task() is in a workqueue so that it can sleep and/or spend a
>>>> long time polling ATA registers.  That means an active task can
>>>> definitely starve all other tasks in the workqueue, if only one
>>>> thread  is available.  If starvation occurs, it will potentially
>>>> pause the  unrelated task for several seconds.
>>>>
>>>> The proposed patch actually expands an existing problem --
>>>> uniprocessor  case, where there is only one workqueue thread.  For
>>>> the reasons  outlined above, we actually want multiple threads even
>>>> in the UP case.  If you have more than one PIO device, latency is
>>>> bloody awful, with  occasional multi-second "hiccups" as one PIO
>>>> devices waits for another.  It's an ugly wart that users DO
>>>> occasionally complain about; luckily  most users have at most one PIO
>>>> polled device.
>>>>
>>>> It would be nice if we could replace this workqueue with a thread
>>>> pool,  where thread count inside the pool ranges from zero to $N
>>>> depending on  level of thread pool activity.  Our common case in
>>>> libata would be  _zero_ threads, if so...
>>>
>>> That would be ideal, N essentially be:
>>>
>>>          N = min(nr_cpus, nr_drives_that_need_pio);
>> ..
>>
>> No, that would leave just a single thread again for UP.
>
> So one thread per ap would be better, then.

Yes.


>> It would be nice to just create these threads on-demand,
>> and destroy them again after periods of dis-use.
>> Kind of like how Apache does worker threads.
>
> Well, that's the same thread pool suggestion that Jeff came up with. And
> I agree, that's a nicer long term solution (it's also how the per-bdi
> flushing replacement works). The problem with that appears to be that
> any suggested patchset for thread pools spiral into certain "but what
> color should it be?!" death.

Let people complain with code :)  libata has two basic needs in this area:
(1) specifying a thread count other than "1" or "nr-cpus"
(2) don't start unneeded threads / idle out unused threads


> I'll try and work up a simple create_threadpool() implementation, we can
> literally cut away hundreds of threads with that.

That would be fantastic.  It really _would_ remove hundreds of threads 
on this 2x4 (2 quad-core pkgs) system I have, for example.

I bet systems like those sparc64 Niagaras or 32-core MIPS are completely 
insane with unused kernel threads...

But if create_threadpool() proves too ambitious, having the ability for 
the subsystem to specify number of threads (#1, above) should suffice to 
fix your problem and the existing UP-thread-count problem.

	Jeff



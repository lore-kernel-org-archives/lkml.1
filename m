Return-Path: <linux-kernel-owner+w=401wt.eu-S1751381AbZHSMPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbZHSMPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbZHSMO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:14:59 -0400
Received: from rtr.ca ([76.10.145.34]:50331 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZHSMO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:14:58 -0400
Message-ID: <4A8BECC2.2060607@rtr.ca>
Date: Wed, 19 Aug 2009 08:14:58 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: use single threaded work queue
References: <20090819112554.GY12579@kernel.dk> <4A8BE932.5090300@garzik.org> <20090819120458.GZ12579@kernel.dk>
In-Reply-To: <20090819120458.GZ12579@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Aug 19 2009, Jeff Garzik wrote:
>> On 08/19/2009 07:25 AM, Jens Axboe wrote:
>>> Hi,
>>>
>>> On boxes with lots of CPUs, we have so many kernel threads it's not
>>> funny. The basic problem is that create_workqueue() creates a per-cpu
>>> thread, where we could easily get by with a single thread for a lot of
>>> cases.
>>>
>>> One such case appears to be ata_wq. You want at most one per pio drive,
>>> not one per CPU. I'd suggest just dropping it to a single threaded wq.
>>>
>>> Signed-off-by: Jens Axboe<jens.axboe@oracle.com>
>>>
>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>> index 072ba5e..0d78628 100644
>>> --- a/drivers/ata/libata-core.c
>>> +++ b/drivers/ata/libata-core.c
>>> @@ -6580,7 +6580,7 @@ static int __init ata_init(void)
>>>   {
>>>   	ata_parse_force_param();
>>>
>>> -	ata_wq = create_workqueue("ata");
>>> +	ata_wq = create_singlethread_workqueue("ata");
>>>   	if (!ata_wq)
>>>   		goto free_force_tbl;
>>
>> I agree with one-thread-per-cpu is too much, in these modern multi-core  
>> times, but one thread is too little.  You have essentially re-created  
>> simplex DMA -- blocking and waiting such that one drive out of ~4 can be  
>> used at any one time.
>>
>> ata_pio_task() is in a workqueue so that it can sleep and/or spend a  
>> long time polling ATA registers.  That means an active task can  
>> definitely starve all other tasks in the workqueue, if only one thread  
>> is available.  If starvation occurs, it will potentially pause the  
>> unrelated task for several seconds.
>>
>> The proposed patch actually expands an existing problem -- uniprocessor  
>> case, where there is only one workqueue thread.  For the reasons  
>> outlined above, we actually want multiple threads even in the UP case.  
>> If you have more than one PIO device, latency is bloody awful, with  
>> occasional multi-second "hiccups" as one PIO devices waits for another.  
>> It's an ugly wart that users DO occasionally complain about; luckily  
>> most users have at most one PIO polled device.
>>
>> It would be nice if we could replace this workqueue with a thread pool,  
>> where thread count inside the pool ranges from zero to $N depending on  
>> level of thread pool activity.  Our common case in libata would be  
>> _zero_ threads, if so...
> 
> That would be ideal, N essentially be:
> 
>         N = min(nr_cpus, nr_drives_that_need_pio);
..

No, that would leave just a single thread again for UP.

It would be nice to just create these threads on-demand,
and destroy them again after periods of dis-use.
Kind of like how Apache does worker threads.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969Ab0A2OwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab0A2OwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918Ab0A2OwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:52:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:49187 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab0A2OwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:52:05 -0500
Message-ID: <4B62F5F6.3040401@windriver.com>
Date: Fri, 29 Jan 2010 08:51:34 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>, peterz@infradead.org
Subject: Re: [PATCH 1/3] softlockup: add sched_clock_tick() to avoid kernel
 warning on kgdb resume
References: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com> <1264631124-4837-2-git-send-email-jason.wessel@windriver.com> <20100129080706.GJ14636@elte.hu>
In-Reply-To: <20100129080706.GJ14636@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2010 14:51:35.0456 (UTC) FILETIME=[8DC5CA00:01CAA0F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jason Wessel <jason.wessel@windriver.com> wrote:
>
>   
>> @@ -118,6 +125,14 @@ void softlockup_tick(void)
>>  	}
>>  
>>  	if (touch_ts == 0) {
>> +		if (unlikely(per_cpu(softlock_touch_sync, this_cpu))) {
>> +			/*
>> +			 * If the time stamp was touched atomically
>> +			 * make sure the scheduler tick is up to date.
>> +			 */
>> +			per_cpu(softlock_touch_sync, this_cpu) = false;
>> +			sched_clock_tick();
>> +		}
>>  		__touch_softlockup_watchdog();
>>  		return;
>>     
>
> Shouldnt just all of touch_softlockup_watchdog() gain this new 
> sched_clock_tick() call, instead of doing this ugly flaggery? Or would that 
> lock up or misbehave in other ways in some cases?
>
> That would also make the patch much simpler i guess, as we'd only have the 
> chunk above.
>   

We have already been down that road, and it breaks other cases. 

http://lkml.org/lkml/2009/7/28/204

Specifically the test case of:

echo 3 > /proc/sys/kernel/softlockup_thresh

And then some kernel code in a thread like:
        local_irq_disable();
        printk("Disable local irq for 11 seconds\n");
        mdelay(11000);
        local_irq_enable();


I could consider calling sched_cpu_clock() before returning the kernel
to normal execution, but that didn't look very safe to call from the
exception context, which is why it was delayed until the next time the
soft lockup code ran.

Resuming from a long sleep is a ugly problem, so I am open to short term
and long term suggestions, including a polling time API (obviously we
would prefer not to go down that rat hole :-)

Jason.

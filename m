Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0BAFxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 00:53:22 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:60971 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0BAFxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 00:53:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NVeyp1/LOQExToRw0AwPrVOoWFc16/JUGVrYwvY1wv/NL3RGU74FtsiYI+aiX5amCN
         9kLAb4j7iLytz7KMKLXPqDNaG0ft9R6ZozjW54g71LJsPzdmCiY2Z878maW2B1NF5ztk
         LwHCAejRa1/lYEad+VRP6c4tMEMJ6LQaXmsEg=
MIME-Version: 1.0
In-Reply-To: <4B62F5F6.3040401@windriver.com>
References: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com>
	 <1264631124-4837-2-git-send-email-jason.wessel@windriver.com>
	 <20100129080706.GJ14636@elte.hu> <4B62F5F6.3040401@windriver.com>
Date: Mon, 1 Feb 2010 13:53:19 +0800
Message-ID: <ce2c83091001312153u280c0035j9ef53fb3e8d9068d@mail.gmail.com>
Subject: Re: [PATCH 1/3] softlockup: add sched_clock_tick() to avoid kernel 
	warning on kgdb resume
From: Dongdong Deng <libfetion@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 10:51 PM, Jason Wessel
<jason.wessel@windriver.com> wrote:
> Ingo Molnar wrote:
>> * Jason Wessel <jason.wessel@windriver.com> wrote:
>>
>>
>>> @@ -118,6 +125,14 @@ void softlockup_tick(void)
>>>      }
>>>
>>>      if (touch_ts == 0) {
>>> +            if (unlikely(per_cpu(softlock_touch_sync, this_cpu))) {
>>> +                    /*
>>> +                     * If the time stamp was touched atomically
>>> +                     * make sure the scheduler tick is up to date.
>>> +                     */
>>> +                    per_cpu(softlock_touch_sync, this_cpu) = false;
>>> +                    sched_clock_tick();
>>> +            }
>>>              __touch_softlockup_watchdog();
>>>              return;
>>>
>>
>> Shouldnt just all of touch_softlockup_watchdog() gain this new
>> sched_clock_tick() call, instead of doing this ugly flaggery? Or would that
>> lock up or misbehave in other ways in some cases?
>>
>> That would also make the patch much simpler i guess, as we'd only have the
>> chunk above.
>>
>
> We have already been down that road, and it breaks other cases.
>
> http://lkml.org/lkml/2009/7/28/204
>
> Specifically the test case of:
>
> echo 3 > /proc/sys/kernel/softlockup_thresh
>
> And then some kernel code in a thread like:
>        local_irq_disable();
>        printk("Disable local irq for 11 seconds\n");
>        mdelay(11000);
>        local_irq_enable();

Hi Jason,

Maybe this problem was fixed by
commit baf48f6577e581a9adb8fe849dc80e24b21d171d - "softlock: fix false
panic which can occur if softlockup_thresh is reduced".

Thanks,
Dongdong

>
>
> I could consider calling sched_cpu_clock() before returning the kernel
> to normal execution, but that didn't look very safe to call from the
> exception context, which is why it was delayed until the next time the
> soft lockup code ran.
>
> Resuming from a long sleep is a ugly problem, so I am open to short term
> and long term suggestions, including a polling time API (obviously we
> would prefer not to go down that rat hole :-)
>
> Jason.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

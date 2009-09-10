Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbZIJJbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbZIJJbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 05:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZIJJbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 05:31:24 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:57326 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZIJJbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 05:31:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gC7f3hcwSLRTMHYrMCjJOy//DqdaTvohufqcwzqiDtGjXOjkEO+MMX2ComtfEDS3OK
         Un0V3JJiKkjSTt6Wag31Mf1JUC8OoYsckcZdesEFpPaB8GCtiHhoD3FLc9C2mlaLWvNv
         zxb77Wkm+wyT+feYLjpcjfXp4dBczzOxCj4m0=
MIME-Version: 1.0
In-Reply-To: <af3ea28a0909100107q328d1288x8d677d4d5f79f728@mail.gmail.com>
References: <af3ea28a0909090035t710f5895i135760a2c7bd8a02@mail.gmail.com>
	 <1252537622.9883.24.camel@localhost.localdomain>
	 <af3ea28a0909100107q328d1288x8d677d4d5f79f728@mail.gmail.com>
Date: Thu, 10 Sep 2009 17:31:25 +0800
Message-ID: <2674af740909100231x582851dbv9b71bc2914be7030@mail.gmail.com>
Subject: Re: [PATCH] update clocksource raw_time in timekeeping_suspend
From: Yong Zhang <yong.zhang0@gmail.com>
To: ye janboe <janboe.ye@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, zippel@linux-m68k.org,
       akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 4:07 PM, ye janboe <janboe.ye@gmail.com> wrote:
> hi, John
>
> Thanks for your comments.
>
> After sent this patch, I realize that this patch exposes the hardware
> detail ugly in common code.
>
> In embed system, user space apps need to have a method to get the
> right time which will not be impacted by NTP and suspend.
>
> Yes, you are right. I want to add sleep_length to the raw time and
> user space apps could get the right time after suspend.
>

What I get from the code is that CLOCK_MONOTONIC doesn't consider
sleep_length either. Do I miss something?

IMO, CLOCK_MONOTONIC_RAW should be coordinate with
CLOCK_MONOTONIC. The difference between them is
whether it's modified by NTP or not.

Correct me if I'm wrong.

-Yong

> Is this right semantics of CLOCK_MONOTONIC_RAW?
>
> Janboe
> 2009/9/10 john stultz <johnstul@us.ibm.com>:
>> On Wed, 2009-09-09 at 15:35 +0800, ye janboe wrote:
>>> after resume from suspend, raw_time is not updated in
>>> timekeeping_suspend. CLOCK_MONOTONIC_RAW could not get the real hw
>>> time.
>>> This patch fix this issue.
>>
>> Hmm.. I'll admit suspend probably was less considered with
>> CLOCK_MONOTONIC_RAW, so the semantics aren't well established.
>>
>> However, I do think we want CLOCK_MONOTONIC_RAW to at-least closely map
>> to CLOCK_MONOTONIC (but *not* be NTP adjusted). I think that is what
>> folks would most likely expect.
>>
>> However, that isn't what this patch seems to do.
>>
>> Over suspend, I believe all hardware counters reset, so this patch would
>> seem to try to subtract the value back.
>>
>> This sort of makes sense for something like the TSC, which never wraps,
>> so the raw_time would be set back to a tranlation of the actual TSC
>> counter,  but for other clocksources like the ACPI PM, it would only
>> subtract at most 5 seconds. So this leaks hardware specific detail in an
>> ugly way.
>>
>> Instead I suspect the most intuitive change would be to add in the
>> sleep_length to the raw time. This keeps CLOCK_MONOTONIC_RAW behaving
>> similarly to CLOCK_MONOTONIC, which I believe makes it more useful for
>> folks using CLOCK_MONOTONIC_RAW for things like tuning time
>> synchronization.
>>
>> But let me know more why you chose this implementation and maybe that
>> will show some better insight in to how you expect it to behave.
>>
>> thanks
>> -john
>>
>>
>>
>>> Signed-off-by: janboe <janboe.ye@gmail.com>
>>> ---
>>>  kernel/time/timekeeping.c |    6 ++++++
>>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>>> index e8c77d9..8420b85 100644
>>> --- a/kernel/time/timekeeping.c
>>> +++ b/kernel/time/timekeeping.c
>>> @@ -331,6 +331,8 @@ static unsigned long timekeeping_suspend_time;
>>>  static int timekeeping_resume(struct sys_device *dev)
>>>  {
>>>         unsigned long flags;
>>> +       s64 nsec;
>>> +       cycle_t last_cycle, cycle_delta;
>>>         unsigned long now = read_persistent_clock();
>>>
>>>         clocksource_resume();
>>> @@ -346,8 +348,12 @@ static int timekeeping_resume(struct sys_device *dev)
>>>         }
>>>         update_xtime_cache(0);
>>>         /* re-base the last cycle value */
>>> +       last_cycle = clock->cycle_last;
>>>         clock->cycle_last = 0;
>>>         clock->cycle_last = clocksource_read(clock);
>>> +       cycle_delta = clock->cycle_last - last_cycle;
>>> +       nsec = cyc2ns(clock, cycle_delta);
>>> +       timespec_add_ns(&clock->raw_time, nsec);
>>>         clock->error = 0;
>>>         timekeeping_suspended = 0;
>>>         write_sequnlock_irqrestore(&xtime_lock, flags);
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

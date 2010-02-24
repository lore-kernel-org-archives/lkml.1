Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0BXJAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:00:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53698 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755528Ab0BXJAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:00:17 -0500
Message-ID: <4B84EAAE.5020408@cn.fujitsu.com>
Date: Wed, 24 Feb 2010 17:00:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: =?UTF-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>
CC: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Patch for tracing c states (power_end) on x86
References: <1266999573.3415.8.camel@localhost>	 <4B84E51A.900@cn.fujitsu.com> <1267001084.3415.16.camel@localhost>
In-Reply-To: <1267001084.3415.16.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schöne wrote:
> Hi,
> 

Please don't top posting. :)

> I tried to pass 0 in "my" sleep routine "static void mwait_idle(void)"
> Which led to the following behaviour:
> The event was reported on /sys/kernel/debug/tracing, but still not
> for sys_perf_open.

The event was not reported by sys_perf_open()? Could you be more
elaborate on this? Because I don't get you here.

> As 1 had been the argument which led to a working tracing, I assumed,
> that the argument should be the same as the 2nd arg of the last
> power_start event.
> Since this argument had been 1 in my case, it worked for me. However, 0
> did not.
> 
> Bye Robert
> 
> 
> 
> Am Mittwoch, den 24.02.2010, 16:36 +0800 schrieb Li Zefan:
>> Robert Schöne wrote:
>>> Hello,
>>>
>>> Since noone replied to my last mail (Febr. 15th, 11:42), describing the
>>> way to fix the missing c-state tracing, here's a patch.
>>> Maybe its easier that way.
>>>
>>> (I used the perf-fixes-for-linus git tree to obtain a
>>> more-then-up-to-date version)
>>>
>>> Bye Robert
>>>
>>>
>>> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
>>> index 02d6780..b1cfb88 100644
>>> --- a/arch/x86/kernel/process.c
>>> +++ b/arch/x86/kernel/process.c
>>> @@ -384,6 +384,7 @@ void default_idle(void)
>>>                 else
>>>                         local_irq_enable();
>>>                 current_thread_info()->status |= TS_POLLING;
>>> +               trace_power_end(1);
>>>         } else {
>>>                 local_irq_enable();
>>>                 /* loop is done by the caller */
>>> @@ -451,6 +452,7 @@ void mwait_idle_with_hints(unsigned long ax,
>>> unsigned long cx)
>>>                 if (!need_resched())
>>>                         __mwait(ax, cx);
>>>         }
>>> +       trace_power_end((ax>>4)+1);
>> The only argument of trace_power_end() is a dummy, so you can just
>> pass 0 or 1 to the trace hook, actually better pass 0 to be
>> consistent with other parts.
>>
>> The dummy argument can't be eliminated, because the macros that
>> automatically generates racing code have some limitations, and
>> seems it's not so easy to get over.
>>
>>>  }
>>>  
>>>  /* Default MONITOR/MWAIT with no hints, used for default C1 state */
>>> @@ -467,6 +469,7 @@ static void mwait_idle(void)
>>>                         __sti_mwait(0, 0);
>>>                 else
>>>                         local_irq_enable();
>>> +               trace_power_end(1);
>>>         } else
>>>                 local_irq_enable();
>>>  }
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> ------------------------- Mail from Febr. 15th --------------------
> Hi,
> I have a question regarding the event "power/power_end".
> For the standard linux kernel (2.6.32.8), it's just not reported -
> neither for the /sys/kernel/debug/tracing nor for the sys_perf_open
> approach.
> 
> System:
>         Intel Core 2 Quad,
>         Kernel 2.6.32.8,
>         for sys_perf_open:always using sampling counters,
>         (Kernel 2.6.33-rcX should show the same behavior)
> 
> After finding "my" c-state procedure in arch/x86/kernel/process.c
> (which was "static void mwait_idle(void)" btw), I added a
> trace_power_end call on the correct line:
> ...
>                 else
>                         local_irq_enable();
>         } else
> ...
> ->
> ...
>                 else
>                         local_irq_enable();
>                 trace_power_end(0);
>         } else
> ...
> Now the event was reported on /sys/kernel/debug/tracing, but still not
> for sys_perf_open.
> 
> Then I had the idea, that trace_power_end's argument should be the same
> as the 2nd argument of the previous power_start.
> 
> That worked.
> 
> However, things to be done are: add trace_power_end's to some
> process.c's procedures.
> 
> 
> Bye Robert
> 
> -------------------------End of Mail of Febr. 15th --------------------
> 
> 
> 
> 

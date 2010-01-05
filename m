Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968Ab0AEKSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0AEKSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 05:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853Ab0AEKSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 05:18:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab0AEKSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 05:18:37 -0500
Message-ID: <4B4311E8.1000001@redhat.com>
Date: Tue, 05 Jan 2010 18:18:16 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Marc Dionne <marc.c.dionne@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG during shutdown - bisected to commit e2912009
References: <6041d2001001011627o5c494df4v37c0c466df3d444c@mail.gmail.com>	 <1262392920.32223.10.camel@laptop>	 <6041d2001001041043ka810288l64ae9d6d8105b284@mail.gmail.com>	 <4B42AA40.3060406@redhat.com> <6041d2001001041923u7bd512a6w4b5399af17424422@mail.gmail.com>
In-Reply-To: <6041d2001001041923u7bd512a6w4b5399af17424422@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 11:23 AM, Marc Dionne wrote:
> On Mon, Jan 4, 2010 at 9:56 PM, Xiaotian Feng<dfeng@redhat.com>  wrote:
>> On 01/05/2010 02:43 AM, Marc Dionne wrote:
>>>
>>> On Fri, Jan 1, 2010 at 7:42 PM, Peter Zijlstra<peterz@infradead.org>
>>>   wrote:
>>>>
>>>> On Fri, 2010-01-01 at 19:27 -0500, Marc Dionne wrote:
>>>>>
>>>>> I'm getting a BUG with current kernels from
>>>>> kernel/time/clockevents.c:263 when halting the system - a restart
>>>>> behaves normally.  I don't have a good camera handy at the moment to
>>>>> capture the call stack on screen, but the call sequence is:
>>>>>
>>>>> clockevents_notify
>>>>> hrtimer_cpu_notify
>>>>> notifier_call_chain
>>>>> raw_notifier_call_chain
>>>>> _cpu_down
>>>>> disable_nonboot_cpus
>>>>> kernel_power_off
>>>>> sys_reboot
>>>>>
>>>>> I bisected it down to commit e2912009: sched: Ensure set_task_cpu() is
>>>>> never called on blocked tasks.  There were a few commits tested along
>>>>> the way where I got a freeze (with the power still on) instead of a
>>>>> BUG. Reverting that commit from the current kernel doesn't look
>>>>> trivial, but the commit immediately preceding this one does halt fine.
>>>>
>>>> We somehow seem to trip up the below patch, which doesn't really make
>>>> sense, as I can't find how task placement would affect the below error.
>>>>
>>>> It seems to purely test against the hot-unplugged cpu, not a cpu the
>>>> task is running on.
>>>>
>>>> ---
>>>> commit bb6eddf7676e1c1f3e637aa93c5224488d99036f
>>>> Author: Thomas Gleixner<tglx@linutronix.de>
>>>> Date:   Thu Dec 10 15:35:10 2009 +0100
>>>
>>> Probably predictable but worth testing, reverting that patch does
>>> allow my system to shutdown cleanly.
>>
>> That BUG_ON was removed by reverting that patch, so you can shutdown
>> cleanly.
>>
>> Could you please attach you kernel config file? I'm a little confused about
>> how do you revert e2912009, manually? I can't see any connections between
>> e2912009 and bb6eddf7, could you please show me your timer list (cat
>> /proc/timer_list)
>
> config is attached, and the output of cat /proc/timers is also
> attached (it's rather large).
>
> To recap:
> - Reverting bb6eddf7 gives me a clean shutdown - predictable of course
> since it removes the BUG_ON
> - I wasn't able to trivially revert e2912009 from a current kernel.
> But it fails to shutdown while the preceding commit is OK.
>
> So it would seem that e2912009 is triggering something that the check
> in bb6eddf7 is catching.
>
> With more recent kernels (but not the ones around e2912009), I do get
> these timer-related warnings in dmesg (and briefly on screen) :
>
> PCSP: Timer resolution is not sufficient (999848nS)
> PCSP: Make sure you have HPET and ACPI enabled.
> PCSP: Turned into nopcm mode.
>
This is outputed by sound module, but it will not affect clockevents, 
could you please try following patch and let me know the output before 
BUG_ON happens? We can gather more information on the BUG_ON. Thank you.

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 6f740d9..7c945e8 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -260,6 +260,9 @@ void clockevents_notify(unsigned long reason, void *arg)
                 list_for_each_entry_safe(dev, tmp, &clockevent_devices, 
list) {
                         if (cpumask_test_cpu(cpu, dev->cpumask) &&
                             cpumask_weight(dev->cpumask) == 1) {
+                               if (dev->mode != CLOCK_EVT_MODE_UNUSED)
+                                       printk("invalid dev %s mode %d 
on cpu %d\n", dev->name,
+                                               dev->mode, cpu);
                                 BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
                                 list_del(&dev->list);

> Marc


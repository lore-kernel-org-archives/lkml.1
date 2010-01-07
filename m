Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645Ab0AGCwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab0AGCwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932307Ab0AGCwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:52:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab0AGCwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:52:13 -0500
Message-ID: <4B454C48.2000404@redhat.com>
Date: Thu, 07 Jan 2010 10:51:52 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Marc Dionne <marc.c.dionne@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG during shutdown - bisected to commit e2912009
References: <6041d2001001011627o5c494df4v37c0c466df3d444c@mail.gmail.com>	 <1262392920.32223.10.camel@laptop>	 <6041d2001001041043ka810288l64ae9d6d8105b284@mail.gmail.com>	 <4B42AA40.3060406@redhat.com>	 <6041d2001001041923u7bd512a6w4b5399af17424422@mail.gmail.com>	 <4B4311E8.1000001@redhat.com>	 <6041d2001001051458j46cdf7abqc4a0a249445ec348@mail.gmail.com>	 <4B445B0E.50208@redhat.com> <6041d2001001061644i59d9cbb6pfcd85177d8391419@mail.gmail.com>
In-Reply-To: <6041d2001001061644i59d9cbb6pfcd85177d8391419@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2010 08:44 AM, Marc Dionne wrote:
> On Wed, Jan 6, 2010 at 4:42 AM, Xiaotian Feng<dfeng@redhat.com>  wrote:
>> On 01/06/2010 06:58 AM, Marc Dionne wrote:
>>>
>>> On Tue, Jan 5, 2010 at 5:18 AM, Xiaotian Feng<dfeng@redhat.com>    wrote:
>>>>
>>>> This is outputed by sound module, but it will not affect clockevents,
>>>> could
>>>> you please try following patch and let me know the output before BUG_ON
>>>> happens? We can gather more information on the BUG_ON. Thank you.
>>>>
>>>> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
>>>> index 6f740d9..7c945e8 100644
>>>> --- a/kernel/time/clockevents.c
>>>> +++ b/kernel/time/clockevents.c
>>>> @@ -260,6 +260,9 @@ void clockevents_notify(unsigned long reason, void
>>>> *arg)
>>>>                 list_for_each_entry_safe(dev, tmp,&clockevent_devices,
>>>> list)
>>>> {
>>>>                         if (cpumask_test_cpu(cpu, dev->cpumask)&&
>>>>                             cpumask_weight(dev->cpumask) == 1) {
>>>> +                               if (dev->mode != CLOCK_EVT_MODE_UNUSED)
>>>> +                                       printk("invalid dev %s mode %d on
>>>> cpu %d\n", dev->name,
>>>> +                                               dev->mode, cpu);
>>>>                                 BUG_ON(dev->mode !=
>>>> CLOCK_EVT_MODE_UNUSED);
>>>>                                 list_del(&dev->list);
>>>
>>> I don't get anything on screen from the printk - is there a trick
>>> needed to getting printk output at that stage of shutting down?  I
>>> tried inserting an mdelay() before the BUG, which delayed the bug
>>> output but still didn't print the invalid dev message.
>>
>> Did you notice this BUG when you're doing suspend/resume?
>>
>> Does the BUG still appear if we changed BUG_ON line to BUG_ON(dev->mode !=
>> CLOCK_EVT_MODE_UNUSED&&  dev->mode != CLOCK_EVT_MODE_SHUTDOWN)?
>
> I only see the BUG on halt - reboot works normally and suspend
> actually freezes and doesn't suspend, but that's perhaps unrelated.
>
> I managed to get your suggested printk to work by adding KERN_CRIT
> (otherwise I got no output), and the offending dev is:
>   "hpet", mode 3 (CLOCK_EVT_MODE_ONESHOT?), cpu 4.

It looks like kernel is trying to remove broadcast device, could you 
please try following patch?

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 6f740d9..d7395fd 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -259,7 +259,8 @@ void clockevents_notify(unsigned long reason, void *arg)
                 cpu = *((int *)arg);
                 list_for_each_entry_safe(dev, tmp, &clockevent_devices, 
list) {
                         if (cpumask_test_cpu(cpu, dev->cpumask) &&
-                           cpumask_weight(dev->cpumask) == 1) {
+                           cpumask_weight(dev->cpumask) == 1 &&
+                           !tick_is_broadcast_device(dev)) {
                                 BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
                                 list_del(&dev->list);
                         }


>
> Marc
>


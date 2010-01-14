Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268Ab0ANLor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab0ANLor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166Ab0ANLoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:44:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab0ANLop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:44:45 -0500
Message-ID: <4B4F0376.3090906@redhat.com>
Date: Thu, 14 Jan 2010 19:43:50 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Magnus Damm <damm@igel.co.jp>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH] clockevent: don't remove broadcast device when cpu is
 dead
References: <1262834564-13033-1-git-send-email-dfeng@redhat.com> <alpine.LFD.2.00.1001121300190.6420@localhost.localdomain> <4B4D2678.5090601@redhat.com> <alpine.LFD.2.00.1001132305280.6420@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001132305280.6420@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 06:08 AM, Thomas Gleixner wrote:
> On Wed, 13 Jan 2010, Xiaotian Feng wrote:
>> On 01/12/2010 09:20 PM, Thomas Gleixner wrote:
>>> On Thu, 7 Jan 2010, Xiaotian Feng wrote:
>>>
>>>> Marc reported BUG during shutdown, after debugging, kernel is trying
>>>> to remove a broadcast device which mode is CLOCK_EVT_MODE_ONESHOT.
>>>>
>>>> The root cause for this bug is that in clockevents_notify,
>>>> "cpumask_weight(dev->cpumask) == 1" is always true even if dev is a
>>>
>>> Why is cpumask_weight(dev->cpumask) == 1 always true when we shutdown
>>> a non boot cpu ?
>>>
>>> The broadcast device is not a per cpu device and the cpumask should
>>> not only contain the CPU which is shut down !
>>
>> At least for hpet broadcast dev, it's dev->cpumask is only contain the CPU
>> which it is initialized from.
>
> Which is fundamentaly wrong and the root cause of the problem. I'll
> have a look tomorrow morning when my brain is more awake than now.

hpet_legacy_clockevent_register is trying to register new CE, but 
replace failed,
then in tick_check_new_device -> tick_check_broadcast_device, the legacy 
hpet CE
was registered as multicast device, but its dev->cpumask is cpumask of 
smp_processor_id().

on my system its dev->cpumask is cpumask of 0, but in Marc's, 
dev->cpumask is cpumask of 4.
So when kernel is trying to offline cpu 4, the broadcast hpet is removed.

>
>> And for broadcast device, kernel is using tick_broadcast_mask not
>> dev->cpumask, right?
>
> No, tick_broadcast_mask is the bitmask which tells us which cpus get
> the broadcast IPI.
>
> Thanks,
>
> 	tglx
>


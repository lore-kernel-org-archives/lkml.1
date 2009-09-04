Return-Path: <linux-kernel-owner+w=401wt.eu-S934411AbZIDWbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411AbZIDWbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 18:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934368AbZIDWa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 18:30:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:65085 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934350AbZIDWa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 18:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cDq15/+Ee7NuNpQbSUvYAEkC7Ix/F1DxNeP4Xskig7evvLuIXaGf8WJ2FwWM4mikE/
         46fyu/p/PccJ/6dJ8ZY5zMld5VOYoa84hqdfN7WV1++eLWrw7u5Z+1rChYGkBg3p4Xt6
         wiHEkYhmBjwsZMYsehnbj5wVJbHmnf/SMuEnA=
Message-ID: <4AA19520.3070708@gmail.com>
Date: Sat, 05 Sep 2009 00:30:56 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: suspend race -mm regression [Was: Power: fix suspend vt regression]
References: <1249980093-16319-1-git-send-email-jirislaby@gmail.com> <4A81E073.5080703@gmail.com> <4A9B9C1C.9020506@gmail.com> <200908312132.10904.rjw@sisk.pl> <4AA0FEBF.7040104@gmail.com>
In-Reply-To: <4AA0FEBF.7040104@gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCs reduced.

On 09/04/2009 01:49 PM, Jiri Slaby wrote:
> On 08/31/2009 09:32 PM, Rafael J. Wysocki wrote:
>> On Monday 31 August 2009, Jiri Slaby wrote:
>>> On 08/11/2009 11:19 PM, Jiri Slaby wrote:
>>>> However there is still a race or something. Sometimes the suspend goes
>>>> through, sometimes it doesn't. I will investigate this further.
>>>
>>> Hmm, this took a loong time to track down a bit. Code instrumentation by
>>> outb(XX, 0x80) usually caused the issue to disappear.
>>>
>>> However I found out that it's caused by might_sleep() calls in
>>> flush_workqueue() and flush_cpu_workqueue(). I.e. it looks like there is
>>> a task which deadlocks/spins forever. If we won't reschedule to it,
>>> suspend proceeds.
>>>
>>> I replaced the latter might_sleep() by show_state() and removed
>>> refrigerated tasks afterwards. The thing is that I don't know if the
>>> prank task is there. I need a scheduler to store "next" task pid or
>>> whatever to see what it picked as "next" and so what will run due to
>>> might_sched(). I can then show it on port 80 display and read it when
>>> the hangup occurs.
>>>
>>> Depending on which might_sleep(), either flush_workqueue() never (well,
>>> at least in next 5 minutes) proceeds to for_each_cpu() or
>>> wait_for_completion() in flush_cpu_workqueue() never returns.
>>>
>>> It's a regression against some -rc1 based -next tree. Bisection
>>> impossible, suspend needs to be run even 7 times before it occurs. Maybe
>>> a s/might_sleep/yield/ could make it happen earlier (going to try)?
>>
>> If /sys/class/rtc/rtc0/wakealarm works on this box, you can use it to trigger
>> resume in a loop.
>>
>> Basically, you can do
>>
>> # echo 0 > /sys/class/rtc/rtc0/wakealarm
>> # date +%s -d "+60 seconds" > /sys/class/rtc/rtc0/wakealarm
>>
>> then go to suspend and it will resume the box in ~1 minute.
> 
> Thanks, in the end I found it manually. Goddammit! It's an -mm thing:
> cpu_hotplug-dont-affect-current-tasks-affinity.patch

BTW. when I reverted it, during suspend I got a warning:
SMP alternatives: switching to UP code
------------[ cut here ]------------
WARNING: at kernel/smp.c:124
__generic_smp_call_function_interrupt+0xfd/0x110()
Hardware name: To Be Filled By O.E.M.
Modules linked in: nfs lockd auth_rpcgss sunrpc ath5k ath
Pid: 3423, comm: pm-suspend Not tainted 2.6.31-rc8-mm1_64 #762
Call Trace:
 [<ffffffff8103fc48>] warn_slowpath_common+0x78/0xb0
 [<ffffffff8103fc8f>] warn_slowpath_null+0xf/0x20
 [<ffffffff8106950d>] __generic_smp_call_function_interrupt+0xfd/0x110
 [<ffffffff8106956a>] hotplug_cfd+0x4a/0xa0
 [<ffffffff81434e47>] notifier_call_chain+0x47/0x90
 [<ffffffff8105b311>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8141ece0>] _cpu_down+0x150/0x2d0
 [<ffffffff8104169b>] disable_nonboot_cpus+0xab/0x130
 [<ffffffff8106ee3d>] suspend_devices_and_enter+0xad/0x1a0
 [<ffffffff8106f00b>] enter_state+0xdb/0xf0
 [<ffffffff8106e741>] state_store+0x91/0x100
 [<ffffffff8116c157>] kobj_attr_store+0x17/0x20
 [<ffffffff8111c6a0>] sysfs_write_file+0xe0/0x160
 [<ffffffff810c3ce8>] vfs_write+0xb8/0x1b0
 [<ffffffff81434c35>] ? do_page_fault+0x185/0x350
 [<ffffffff810c434c>] sys_write+0x4c/0x80
 [<ffffffff8100be2b>] system_call_fastpath+0x16/0x1b
---[ end trace 73264e95657dec65 ]---
CPU1 is down

> Well, I don't know why, but when the kthread overthere runs under
> suspend conditions and gets rescheduled (e.g. by the might_sleep()
> inside) it never returns. pick_next_task always returns the idle task
> from the idle queue. State of the thread is TASK_RUNNING.
> 
> Why is it not enqueued into some queue? I tried also
> sched_setscheduler(current, FIFO, 99) in the thread itself. Unless I did
> it wrong, it seems like a global scheduler problem?
> 
> Ingo, any ideas?

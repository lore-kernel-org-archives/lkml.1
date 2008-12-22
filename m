Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYLVPtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYLVPtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 10:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYLVPsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 10:48:55 -0500
Received: from rtr.ca ([76.10.145.34]:34309 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711AbYLVPsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 10:48:54 -0500
Message-ID: <494FB6E3.1040409@rtr.ca>
Date: Mon, 22 Dec 2008 10:48:51 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       akpm@linux-foundation.org, rjw@sisk.pl, tglx@linutronix.de,
       lenb@kernel.org, linux-pm@lists.linux-foundation.org, davej@redhat.com
Subject: Re: SMP poweroff hangs:  it's baaaack!  But on x86_64 this time.
References: <20071213053020.E28AB1454450@imap.suse.de> <4761601B.3030408@rtr.ca> <20071213164545.GA10593@suse.de> <47616C15.7030604@rtr.ca> <47616F8C.9030803@rtr.ca> <49491F32.1040400@rtr.ca> <20081219115917.GA1599@ucw.cz> <494C5619.7020209@rtr.ca>
In-Reply-To: <494C5619.7020209@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Pavel Machek wrote:
>> On Wed 2008-12-17 10:48:02, Mark Lord wrote:
>>>> Subject: Fix SMP poweroff hangs
>>>> From: Mark Lord <lkml@rtr.ca>
>>>>
>>>> We need to disable all CPUs other than the boot CPU (usually 0) before
>>>> attempting to power-off modern SMP machines.  This fixes the
>>>> hang-on-poweroff issue on my MythTV SMP box, and also on Thomas 
>>>> Gleixner's
>>>> new toybox.
>>>>
>>>> Signed-off-by: Mark Lord <mlord@pobox.com>
>>>> Acked-by: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>> ---
>>>>
>>>>  kernel/sys.c |    2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff -puN kernel/sys.c~fix-smp-poweroff-hangs kernel/sys.c
>>>> --- a/kernel/sys.c~fix-smp-poweroff-hangs
>>>> +++ a/kernel/sys.c
>>>> @@ -32,6 +32,7 @@
>>>>  #include <linux/getcpu.h>
>>>>  #include <linux/task_io_accounting_ops.h>
>>>>  #include <linux/seccomp.h>
>>>> +#include <linux/cpu.h>
>>>>   #include <linux/compat.h>
>>>>  #include <linux/syscalls.h>
>>>> @@ -878,6 +879,7 @@ void kernel_power_off(void)
>>>>      kernel_shutdown_prepare(SYSTEM_POWER_OFF);
>>>>      if (pm_power_off_prepare)
>>>>          pm_power_off_prepare();
>>>> +    disable_nonboot_cpus();
>>>>      sysdev_shutdown();
>>>>      printk(KERN_EMERG "Power down.\n");
>>>>      machine_power_off();
>>> ..
>>>
>>> This bug has returned here now, but on x86_86 this time around.
>>> Same machine as before, just upgraded toa 64-bit kernel/user (2.6.27.9)
>>> from the original 32-bit kernel/user that was originally fixed (above).
>>>
>>> One hang at poweroff over the past 10 days.  Not much, but enough
>>> to destroy confidence in "unattended" operation.
>>>
>>> I lack opportunity to dig further into the code for now,
>>> but just wanted to flag the problem, in case similar reports
>>> from others might already be out there.
>>>
>>> In the meanwhile, I'm experimenting with this simple patch,
>>> garnered from the 32-bit investigations last time around.
>>> We should know in a few weeks whether it has any effect or not.
>>>
>>> --- old/kernel/sys.c    2008-10-18 13:57:22.000000000 -0400
>>> +++ linux-2.6.27.9/kernel/sys.c    2008-12-17 09:42:17.000000000 -0500
>>> @@ -303,6 +303,8 @@
>>>
>>> static void kernel_shutdown_prepare(enum system_states state)
>>> {
>>> +    set_cpus_allowed(current, 
>>> cpumask_of_cpu(first_cpu(cpu_online_map)));
>>
>> Is this line neccessary?
> ..
> 
> One or the other is probably redundant, but it's not 100% clear 
> *which*.  :)
> The line above was suggested by others back when the original problem
> was being worked on for 32-bit.
> 
>>> +    disable_nonboot_cpus();
>>>     blocking_notifier_call_chain(&reboot_notifier_list,
>>>         (state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
>>>     system_state = state;
>>> @@ -333,7 +335,6 @@
>>>     kernel_shutdown_prepare(SYSTEM_POWER_OFF);
>>>     if (pm_power_off_prepare)
>>>         pm_power_off_prepare();
>>> -    disable_nonboot_cpus();
>>>     sysdev_shutdown();
>>>     printk(KERN_EMERG "Power down.\n");
>>>     machine_power_off();
>>
>> Do you have any idea why it helps? BIOS will see us shutting down on
>> cpu0 anyway, so if this helps there's a linux bug somewhere...
> ..
> 
> I don't know if it helps, yet.  Needs a lot more soak first.
> The theory here is, that all BIOS interactions from the kernel
> probably should happen only on the "boot CPU" or on "cpu 0",
> not just the "halt" sequence.
> 
> By setting the CPU restriction earlier in the shutdown sequence,
> we should be on the correct CPU for all of the various device-driver
> BIOS ineractions that might happen before actually halting.
> 
> Could be a bad theory, but I'm open to other possible suggestions.
..

Well, it has hung on poweroff again now, so that patch apparently doesn't
cure the problem.  Darn.  The machine is at remote site, and I won't have
access to it for another week or so to do any further diagnostics.
Perhaps we'll just leave it running for the whole week.

Cheers

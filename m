Return-Path: <linux-kernel-owner+w=401wt.eu-S1761517AbXJENjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517AbXJENjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 09:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXJENjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 09:39:37 -0400
Received: from rtr.ca ([76.10.145.34]:3285 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbXJENjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 09:39:36 -0400
Message-ID: <47063E93.9030105@rtr.ca>
Date: Fri, 05 Oct 2007 09:39:31 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Brown, Len" <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, simon.derr@bull.net,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [patch 4/6] Fix SMP poweroff hangs
References: <200710010820.l918KApW006834@imap1.linux-foundation.org> <CFF307C98FEABE47A452B27C06B85BB603DA9AB8@hdsmsx411.amr.corp.intel.com> <m1hclascwo.fsf@ebiederm.dsl.xmission.com> <200710020048.38856.rjw@sisk.pl> <m1myv2o13c.fsf@ebiederm.dsl.xmission.com> <470198B1.2030003@rtr.ca> <m1ve9pn8d1.fsf@ebiederm.dsl.xmission.com> <470271EA.4040509@rtr.ca> <m1ejgdif0f.fsf@ebiederm.dsl.xmission.com> <4702C902.7000504@rtr.ca>
In-Reply-To: <4702C902.7000504@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting this.. somehow left LKML off the TO/CC list.. (thanks Andrew!)

Eric W. Biederman wrote:
> Mark Lord <lkml@rtr.ca> writes:
>
>> Eric W. Biederman wrote:
>>> Mark Lord <lkml@rtr.ca> writes:
>>>>> - It could be that we changed the initialization order.
>>>>> - It could be that we changed the set of sysdev devices.
>>>>> - It could be we that cpu_down is doing something extra that we are not
>>>>>   doing.
>>>>>
>>>>> My guess is that Mark Lord, and Thomas Gleixner are sharp enough to
>>>>> have checked their command line parameters before submitting a kernel
>>>>> bugfix patch.  Although it would not hurt to have confirmation of
>>>>> that.
>>>> Right.  No fancy command line overrides here.
>>> Ok.
>>>
>>> Simple questions.
>>> - 32bit or 64bit x86?
>>> - Is this new failure mode or a regression?
>>> - By hang on power off I assume you mean that the power does
>>>   not go off?
>>> - Is there anything else you can tell me about this failure mode?
>> You could search kernel archives from last week,
>> when lots more info was posted in the original trouble reports.
>
> Sure.  I will. I was starting off a bit lazy.
>
>> My system is Core2Duo DualCore 1.86GHz, pure 32bit kernel/user.
>> System prints "Power Down." message, but power stays on.
>> Broken in 2.6.17, and in 2.6.23-rc*.  No other versions attempted.
>
> Ok.  So apparently not a regression.
>
>>> Mark, Thomas given the difficulty in reproducing the failure if
>>> someone has time I would love to see what happens if for testing:
>>> set_cpus_allowed(current, cpumask_of_cpu(1)); (instead of
>> disable_nonboot_cpus)
>>
>> System behaved fine on six consecutive poweroffs with that.
>> This could be due to subtle timing changes induced by the
>> context switches this produces, though.  I also tried it
>> as the very first line in the same function, and saw no change.
>
> Thanks.  This confirms something.  This is not an issue of which
> cpu you are running on (or else by forcing you onto the second
> core it would always fail).   At most it may be something
> happening on one cpu and the getting switched to another cpu.
>
> So this looks like something extra that cpu_down is doing.
>
>> I then removed that one line (and left out the disable_nonboot_cpus as well),
>> and it failed to power off on the very next attempt (got lucky).
>
> Ok.
>
>> Changed it to set_cpus_allowed(current, cpumask_of_cpu(0)),
>> and it survived six consecutive poweroffs.
>>
>> Changed it back to disable_nonboot_cpus(..),
>> and it also survived another four consecutive poweroffs.
>>
>> I also verified that both CPUs were enabled on entry to machine_poweroff().
>
> That both CPUS are enabled on entry to machine_poweroff is expected,
> and normal.
>
> The code path on i386 should be:
> machine_power_off
>   native_machine_power_off
>      machine_shutdown(); (which disables the other cpus)
>     smp_call_function
>        stop_this_cpu (on each cpu to be stopped.
>      pm_power_off(); (which turns off the power)
..
> This does sound like a race of some sort.

Mmm... thanks for the tour.

The cpu hotplug code appears to take great precautions against internal races
(dunno if it succeeds or not, though), but the correspond code in native_smp_send_stop()
looks a bit iffy by comparison.  I wonder if that's where it gets stuck?

static void native_smp_send_stop(void)
{
       /* Don't deadlock on the call lock in panic */
       int nolock = !spin_trylock(&call_lock);
       unsigned long flags;

       local_irq_save(flags);
       __smp_call_function(stop_this_cpu, NULL, 0, 0);
       if (!nolock)
               spin_unlock(&call_lock);
       disable_local_APIC();
       local_irq_restore(flags);
}

So basically, it tries to avoid races by grabbing the call_lock,
but then ignores that lock and proceeds anyway.  Recipe for a race?

-ml

Return-Path: <linux-kernel-owner+w=401wt.eu-S964785AbZJIWoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbZJIWoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 18:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbZJIWoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 18:44:15 -0400
Received: from claw.goop.org ([74.207.240.146]:34604 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761515AbZJIWoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 18:44:14 -0400
Message-ID: <4ACFBC98.4070701@goop.org>
Date: Fri, 09 Oct 2009 15:43:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] sched: add notifier for process migration
References: <4ACFA4C5.4020607@goop.org> <1255125738.7439.17.camel@laptop>
In-Reply-To: <1255125738.7439.17.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/09 15:02, Peter Zijlstra wrote:
>> I'm working on adding vsyscall (vread) support for
>> arch/x86/kernel/pvclock.c.  The algorithm needs to look up per-cpu tsc
>> parameters (aka pvclock_vcpu_time_info) so that it can compute global
>> system time from the tsc.  To do this, it needs to grab a consistent
>> snapshot of (tsc, time_info).
>>     
> time_info as in gettimeofday()?, that's supposed to be globally
> consistent, so get that first and then get the tsc and you're as race
> free as you're ever going to get from userspace.
>   

pvclock_vcpu_time_info is a structure which is part of the hypervisor
ABI (implemented by both Xen and KVM at the moment), which provides all
the info needed to compute a global system time (ns from host boot, for
example) from the tsc, even if the CPU's tscs are not synced, or running
at the same frequency, or can stop/change at any moment.  The hypervisor
provides it for each guest virtual CPU containing the parameters for the
underlying physical CPU the vCPU is currently running on.

This is all done in pvclock_clocksource_read, which is then used as the
input for all the rest of the kernel's gettimeofday/clock_gettime/etc
functions.  I'm extending this so I can also implement
pvclock_clocksource_vread and do the same thing from userspace.

>> Obviously this is all racy from usermode, because there are two levels
>> of scheduling going on the virtual case: kernel scheduling of tasks to
>> vcpus, and hypervisor scheduling of vcpus to pcpus.  The latter is dealt
>> with a version number in the tsc parameter structure to indicate changes
>> in the params (which could be due to scheduling, power events, etc).
>>
>> To deal with kernel scheduling I want a second version number to let
>> usermode know they've been migrated to a new (v)cpu and need to try
>> again with updated time parameters.  Specifically, update the version on
>> the "from" vcpu so that usermode (vsyscall) code holding an old pointer
>> can see the number change and reload the cpu number and get a pointer to
>> the new cpu's time_info.
>>     
> /me utterly confused.
>   

OK, concretely:

   1. allocate a page and fixmap it into userspace
   2. keep an array of structures containing tsc->cycle_t
      (pvclock_vcpu_time_info) params, indexed by cpu
   3. register those structures with the hypervisor so it can update
      them as either the pcpus change freq and/or the vcpus get moved to
      different pcpus
   4. associate a "migration_count" with each structure (ie, how many
      times this cpu has had tasks migrated off it)

The algorithm is basically:

    do {
        cpu = vgetcpu();    	/* get current cpu */
        ti = &timeinfo[cpu];	/* get scaling+offset for tsc */

        /* !!! migration race */

        migration_count = ti->migration_count;
        version = ti->version;

        barrier();

        local_time_info = *ti;

        tsc = rdtsc();
        cycles = compute_cycles_from_tsc(tsc, &local_time_info);

        barrier();

        cpu1 = vgetcpu();

    /* loop if anything changed under our feet:
        - we changed cpus (if we got migrated at "!!! migration race" above
           then the migration_count test won't pick it up)
        - the time info changed
        - we got migrated to a different cpu (we need to check this as well
           as cpu != cpu1 in case we got migrated from A->B->A)
     */

    } while(unlikely(cpu1 != cpu ||
    		 timeinfo->version != version ||
    		 timeinfo->migration_count != migration_count));

    return cycles;
      

This is executed in usermode as part of vsyscall gettimeofday via the
clocksource.vread function.

>> Initially I was doing this with a preempt notifier on sched_out, but Avi
>> pointed out that this was a pessimistic approximation of what I really
>> want, which is notification on cross-cpu migration.  And since migration
>> is an inherently expensive operation, the overhead of a notifier here
>> should be negligible.  (Aside from that, the preempt notifier mechanism
>> isn't intended to be enabled on every process on the system.)
>>     
> And here you're utterly failing to explain what you want such a notifier
> would do.
>   

Referring to the code above, it does:

	time_info[from_cpu]->migrate_count++;

so that usermode can see that it has been moved to a different cpu and
needs to try again.

>> So I'm proposing this patch.  My questions are:
>>
>>    1. Does this look generally reasonable?
>>     
> I'm generally confused and not at all clear as to how things would work.
> Afaik the vdso is a global entity and does not contain per-cpu or
> per-task state.
>   

Yep.  For this implementation I fixmap another page of per-cpu time info
into usermode for use by the pvclock vread implementation.  This is
mapped RO and global, of course.

> If you're proposing to increment a global seq count on every task
> migration, then I think its a terribly bad idea.
>   

A per-cpu counter on each migration.

>>    2. Will this notifier actually be called every time a task gets
>>       migrated between CPUs?  Are there cases where migration may happen
>>       via some other path? (Though for my particular case I only care
>>       about migration when the task is actually preempted; if it goes to
>>       sleep on one cpu and happens to wake on another then it wasn't in
>>       the middle of getting time so it doesn't matter.)
>>     
> No, you've missed quite a lot of cases.
>   

Could you expand on that?  Where else would we need to catch a migration?

> I've got no idea how vgetcpu() works, but since the vdso page is global
> and not per-task, I can't really see how it could work sanely.
>   

It works either by using "lsl" to fetch cpu+node number info encoded in
a segment limit, or via rdtscp which encodes cpu+node in the TSC_AUX
register.

Thanks,
    J


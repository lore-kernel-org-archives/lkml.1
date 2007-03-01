Return-Path: <linux-kernel-owner+w=401wt.eu-S965031AbXCAML4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031AbXCAML4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965035AbXCAML4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:11:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42290 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965031AbXCAMLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:11:55 -0500
Message-ID: <45E6C2F2.8090007@redhat.com>
Date: Thu, 01 Mar 2007 07:11:30 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, jbeulich@novell.com,
       anil.s.keshavamurthy@intel.com, amul.shah@unisys.com
Subject: Re: [PATCH]: Use stop_machine_run in the Intel RNG driver
References: <20070227120835.14880.38530.sendpatchset@prarit.boston.redhat.com>	<45E42268.30209@redhat.com> <20070228221619.dc135f3c.akpm@linux-foundation.org>
In-Reply-To: <20070228221619.dc135f3c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I think what you're describing here is just the standard old
> smp_call_function() deadlock, rather than anything which is specific to
> intel-rng, yes?
>
> It is "well known" that you can't call smp_call_function() with local
> interrupts disabled.  In fact i386 will spit a warning if you try it.
>
>
> intel-rng doesn't do that, but what it _does_ do is:
>
> 	smp_call_function(..., wait = 0);
> 	local_irq_disable();
>
> so some CPUs will still be entering the IPI while this CPU has gone and
> disabled interrupts, thus exposing us to the deadlock, yes?
>   

Not quite Andrew.  This was a different and little more complicated.

The deadlock occurs because two CPUs are in contention over a rw_lock 
and the "call_function" puts the CPUs in such a state that no forward 
progress will be made until the calling CPU has completed it's code.

Here's a more detailed example (sorry for the cut-and-paste):

1.  CPU A has done read_lock(&lock), and has acquired the lock.
2.  CPU B has done write_lock_irq(&lock) and is waiting for A to release 
the lock.  CPU B has disabled interrupts while waiting for the interrupt:

void __lockfunc _write_lock_irq(rwlock_t *lock)
{
        local_irq_disable();
        preempt_disable();
        rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
        _raw_write_lock(lock);
}

3.  CPU C issues smp_call_function, as in the case of the intel-rng driver:

    set_mb(waitflag, 1);
    smp_call_function(intel_init_wait, NULL, 1, 0);
    ...
    // do some stuff with interrupts disabled
    ...
    set_mb(waitflag, 0);

where

static char __initdata waitflag;

static void __init intel_init_wait(void *unused)
{
        while (waitflag)
                cpu_relax();
}

In this code the calling processor, C, has issued an IPI and disabled 
interrupts on every processor except itself.  When each processor takes 
the IPI it runs intel_init_wait and waits in a tight loop until  
waitflag is zero.  ie) no forward progress on any CPU.

CPU C will not execute the code below the smp_call_function until all 
processors have started (not completed!) the IPI function.  From 
call_smp_function:

        cpus = num_online_cpus() - 1;
        ...

        /* Send a message to all other CPUs and wait for them to respond */
        send_IPI_allbutself(CALL_FUNCTION_VECTOR);

        /* Wait for response */
        while (atomic_read(&data.started) != cpus)
                cpu_relax();

So CPU C is waiting here.

4.  CPU A, which holds the lock sees the IPI and is in the 
intel_init_wait code, happily waiting.  CPU A has incremented 
data.started.  CPU A will stay in this loop until CPU C sets waitflag = 0.

5.  CPU B, if you recall is _waiting with interrupts disabled_ for CPU A 
to release the  lock.  It does not see the IPI because it has interrupts 
disabled.  It will not see the IPI until CPU A has released the lock.

6.  CPU C is eventually only waiting for CPU B to do the final increment 
of data.started = cpus.  CPU B is waiting for CPU A to release the 
lock.  CPU A is executing a tight loop which it will not exit from until 
CPU C can set waitflag to zero.

That's a 3-way deadlock.

So, the issue is placing the other CPUs in a state that they do not make 
forward progress.  The deadlock occurs before the calling CPU has 
disabled interrupts in the code in step 3.

I also tested this code without the __init tags and explicitly coding 
waitflag=0 to avoid the gcc only setting .bss section variables to zero 
error that someone fixed last week.  I also removed the code that 
disabled interrupts on the calling processor which had no effect -- at 
first I thought it was a simple interrupt issue ...

Maybe smp_call_function needs a written warning that the called function 
should not "suspend" CPUs?

P.

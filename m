Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZHFWqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZHFWqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 18:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZHFWql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 18:46:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59535 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZHFWqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 18:46:40 -0400
Message-ID: <4A7B5D46.7080109@us.ibm.com>
Date: Thu, 06 Aug 2009 15:46:30 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "lkml," <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>, Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] fixup pi_state in futex_requeue on lock steal
References: <4A7A1D48.7040309@us.ibm.com> <1249576660.32113.585.camel@twins>
In-Reply-To: <1249576660.32113.585.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2009-08-05 at 17:01 -0700, Darren Hart wrote:
>> NOT FOR INCLUSION
>>
>> Fixup the uval and pi_state owner in futex_requeue(requeue_pi=1) in the event
>> of a lock steal or owner died.  I had hoped to leave it up to the new owner to
>> fix up the userspace value since we can't really handle a fault here
>> gracefully.  This should be safe as the lock is contended and should force all
>> userspace attempts to lock or unlock into the kernel where they'll block on the
>> hb lock.  However, when I don't update the uaddr, I hit the WARN_ON(pid !=
>> pi_state->owner->pid) as expected, and the userspace testcase deadlocks.
>>
>> I need to try and better understand what's happening to hang userspace.  In the
>> meantime I thought I'd share what I'm working with atm.  This is a complete HACK
>> and is ugly, non-modular, etc etc.  However, it currently works.  It would explode
>> in a most impressive fashion should we happen to fault.  So the remaining questions
>> are:
>>
>> o Why does userspace deadlock if we leave the uval updating to the new owner
>>   waking up in futex_wait_requeue_pi()?
>>
>> o If we have to handle a fault in futex_requeue(), how can we best cleanup the
>>   proxy lock acquisition and get things back into a sane state.  We faulted, so
>>   determinism is out the window anyway, we just need to recover gracefully.
> 
> 
> Do you have a trace of the thing going down?

I finally did get a trace... but learned something in the process. 
Elaborating below.

> 
> Tglx and me usually use sched_switch and a few trace_printk()s sprinkled
> around, the typical one would be in sys_futex, printing the futex cmd
> and arg.
> 
> OK, so run me through this one more time.
> 
> A condvar has two futexes, an inner and an outer. The inner futex is
> always locked and the waiting threads are stacked on that.

3 actually:

cond->data->futex (the waitqueue)
cond->data->lock (the lock protecting the internal data)
outer mutex (the pthread_mutex)

> 
> Then on signal/broadcast, we lock the outer lock and requeue all the
> blocked tasks from the inner to the outer, then we release the outer
> lock and let them rip.

Yes - and in requeue_pi with a PI mutex we only let 1 rip, and requeue 
the rest, rather than wake them all as the old implementation for PI 
mutexes did.

> 
> Since we're seeing lock steals, I'm thinking the outer lock isn't taken
> when we're doing the requeue?

Correct.  Unfortunately this is "valid" usage.

> 
> Anyway, during the requeue we lock-steal because the owner isn't running
> yet and we iterate a higher prio task in the requeue loop?

I believe so.

> 
> This leaves the outer lock's futex field messed up because it points to
> the wrong TID.

The futex uval isn't messed up, it just still hold the value of the 
previous owners tid (not the expected owner we're stealing from).  I 
believe now that this is proper behavior.

> 
> After we finish the requeue loop, we unlock the HBs.
> 
> 
> So far so good?

Yup.

> 
> 
> Now, normally the waking thread will find itself owner and will check
> the futex variable and fix her up -- while holding the HB lock.

Correcto.

> 
> However, in case the outer lock gets contended again, we can get
> interrupted between requeue and wakeup/fixup and observe this messed up
> futex value, which is causing this WARN to trigger.

This is where I was mistaken.  I had seen the WARN_ON(pid != 
pi_state->owner->pid) in lookup_pi_state() while working on the previous 
2 patches I sent to the list.  The one which updates the lock_ptr of the 
futex_q to match that of the pi_state should fix this.  What happened 
before was we would grab the wrong hb lock so while we were fixing up 
the pi_state and uval in the woken thread, a contending thread would 
read those value while holding the correct hb lock.  That race is fixed 
with the "[PATCH 1/2] Update woken requeued futex_q lock_ptr" patch.

> 
> So where do we deadlock, after this all goes down? Do we perhaps lookup
> the wrong pi_state using that wrong TID?
> 

We only deadlocked while I was (wrongly) trying to update pi_state owner 
from the requeue thread.  Deadlocks don't occur in my testing with only 
patches 1 and 2.

[PATCH 1/2] Update woken requeued futex_q lock_ptr" patch
[PATCH 2/2][RT] Avoid deadlock in rt_mutex_start_proxy_lock()


> Since its only the outer futex's value that matters, right? Can't we pin
> that using get_user_pages() before we take the HB lock and go into the
> requeue loop? That way we're sure to be able to change it without
> faulting.

I now don't believe we have to do this.  In fact, futex_lock_pi() 
exhibits a similar "race window" (simplified below):

         /*
          * Block on the PI mutex:
          */
         ret = rt_mutex_timed_lock(&q.pi_state->pi_mutex, to, 1);

         [RACE WINDOW ]   (not really, see below)

         spin_lock(q.lock_ptr);
         /*
          * Fixup the pi_state owner and possibly acquire the lock if we
          * haven't already.
          */
         res = fixup_owner(uaddr, fshared, &q, !ret);

Note that the rt_mutex is acquire while the q.lock_ptr (hb->lock) is not 
held (since we can sleep).  This is FINE and not a race.  Lets look at 
what happens if another task tries to get the lock during that time:

futex_lock_pi
	futex_lock_pi_atomic
		lookup_pi_state
			
At this point we have the pi_state.  It's owner field will point to the 
previous owner, not the task that is currently acquiring it.  But the 
rt_mutex itself knows who owns it, so proper boosting should still 
occur.  Once the new owner complete the pi_state update, the pi_state 
will be removed from the old owner pi_state_list and added to its 
pi_state_list.  Since the futex uval shows it's owned in both cases, the 
new contender is still forced into the kernel to block on the rt_mutex. 
  Since we update the uval, then the pi_state->owner, we are sure to be 
able to access the rt_mutex via the old uval so long as we hold the 
hb->lock.

So, I think we're fine with respect to the pi_state ownership!  In fact 
I finally managed to catch the lock steal in the requeue loop in my 
tracing, and everything worked fine.  Going to go rerun a bunch more 
tests and see if I hit any other issues, if I do, I suspect they are 
unrelated to this.

Thanks for the help in thinking this through.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

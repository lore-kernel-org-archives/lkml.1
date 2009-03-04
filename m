Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZCDHx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZCDHx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 02:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZCDHxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 02:53:48 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56035 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZCDHxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 02:53:47 -0500
Message-ID: <49AE3386.1070604@us.ibm.com>
Date: Tue, 03 Mar 2009 23:53:42 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [TIP][RFC 6/7] futex: add requeue_pi calls
References: <49AC73A9.4040804@us.ibm.com> <49AC77D1.6090106@us.ibm.com>
In-Reply-To: <49AC77D1.6090106@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> From: Darren Hart <dvhltc@us.ibm.com>
> 
> PI Futexes must have an owner at all times, so the standard requeue 
> commands
> aren't sufficient.  The new commands properly manage pi futex ownership by
> ensuring a futex with waiters has an owner at all times.  Once complete 
> these
> patches will allow glibc to properly handle pi mutexes with 
> pthread_condvars.
> 
> The approach taken here is to create two new futex op codes:
> 
> FUTEX_WAIT_REQUEUE_PI:
> Threads will use this op code to wait on a futex (such as a non-pi 
> waitqueue)
> and wake after they have been requeued to a pi futex.  Prior to 
> returning to
> userspace, they will take this pi futex (and the underlying rt_mutex).
> 
> futex_wait_requeue_pi() is currently the result of a high speed collision
> between futex_wait and futex_lock_pi (with the first part of futex_lock_pi
> being done by futex_requeue_pi_init() on behalf of the waiter).
> 
> FUTEX_REQUEUE_PI:
> This call must be used to wake threads waiting with FUTEX_WAIT_REQUEUE_PI,
> regardless of how many threads the caller intends to wake or requeue.
> pthread_cond_broadcast should call this with nr_wake=1 and nr_requeue=-1 
> (all).
> pthread_cond_signal should call this with nr_wake=1 and nr_requeue=0.  The
> reason being we need both callers to get the benefit of the
> futex_requeue_pi_init() routine which will prepare the top_waiter (the 
> thread
> to be woken) to take possesion of the pi futex by setting FUTEX_WAITERS and
> preparing the futex_q.pi_state.  futex_requeue() also enqueues the 
> top_waiter
> on the rt_mutex via rt_mutex_start_proxy_lock(). If pthread_cond_signal 
> used
> FUTEX_WAKE, we would have a similar race window where the caller can 
> return and
> release the mutex before the waiters can fully wake, potentially leaving 
> the
> rt_mutex with waiters but no owner.
> 
> We hit a failed paging request running the testcase (7/7) in a loop
> (only takes a few minutes at most to hit on my 8way x86_64 test
> machine).  It appears to be the result of splitting rt_mutex_slowlock()
> across two execution contexts by means of rt_mutex_start_proxy_lock()
> and rt_mutex_finish_proxy_lock().  The former calls
> task_blocks_on_rt_mutex() on behalf of the waiting task prior to
> requeuing and waking it by the requeueing thread.  The latter is
> executed upon wakeup by the waiting thread which somehow manages to call
> the new __rt_mutex_slowlock() with waiter->task != NULL and still
> succeed with try_to_take_lock(), this leads to corruption of the plists
> and an eventual failed paging request.  See 7/7 for the rather crude
> testcase that causes this.  Any tips on where this race might be
> occuring are welcome.

After some judicious use of printk (ftrace from tip wouldn't let me set 
the current_tracer, permission denied) I managed to catch a failing 
scenario where the signaling thread returns to userspace and unlocks the 
mutex before the waiting thread calls __rt_mutex_slowunlock() (which is 
fine) but the signaler calls rt_mutex_fastunlock() instead of 
rt_mutex_slowunlock() which is what the rt_mutex_start_proxy_lock() was 
supposed to prevent, so I am apparently not fully preparing the waiter 
and enqueueing it on the rt_mutex.  Annotated printk output:

Signaler thread in futex_requeue()
	lookup_pi_state: allocating a new pi state
	futex_requeue_pi_init: futex_lock_pi_atomic returned: 0
	futex_requeue: futex_requeue_pi_init returned: 0

Signaler thread returned to userspace and did pthread_mutex_unlock()
	rt_mutex_fastunlock: unlocked ffff88013d1749d0

Waiting thread woke up in futex_wait_requeue_pi() and tries to finish 
taking the lock:
	__rt_mutex_slowlock: waiter->task is ffff8802bdd350c0
	try_to_take_rt_mutex: assigned rt_mutex (ffff88013d1749d0) owner
		to current ffff8802bdd350c0

Waiting thread get's the lock while waiter->task is not NULL (b/c the 
signaler didn't go through the slow path)
	__rt_mutex_slowlock: got the lock

I'll continue looking into this tomorrow, but Steven if you have any 
ideas on what I may have missed in rt_mutex_start_proxy_lock() I'd 
appreciate any insight you might have to share.  Thomas, I know you gave 
this function some thought as well, did I take a radically different 
approach to what you had in mind?

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

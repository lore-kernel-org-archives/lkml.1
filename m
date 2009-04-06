Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZDFQaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZDFQaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZDFQaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:30:25 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:41836 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZDFQaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:30:24 -0400
Message-ID: <49DA2DFA.5080205@us.ibm.com>
Date: Mon, 06 Apr 2009 09:29:46 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
       niv@linux.vnet.ibm.com, Vernon Mauery <vernux@us.ibm.com>
Subject: Re: [tip PATCH v7 0/9] RFC: futex: requeue pi implementation
References: <20090403203832.9772.21410.stgit@Aeon> <alpine.LFD.2.00.0904041035411.2884@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904041035411.2884@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Darren,
> 
> On Fri, 3 Apr 2009, Darren Hart wrote:
>> The following series is v7 of the requeue_pi patches against
>> linux-2.6-tip/core/futexes.  The current futex implementation doesn't allow for
>> requeueing of PI futexes, which leads to a thundering herd during
>> pthread_cond_broadcasa()t (as opposed to a civilized priority ordered wakeup
>> sequence).  The core of the problem is that the underlying rt_mutex cannot be
>> left with waiters and no owner (which would break the PI logic).  This patch
>> series updates the futex code to allow for requeueing from non-PI to PI futexes
>> in support of PI aware pthread_cond_* calls along with some needful rt_mutex
>> helper routines.  The credit for the conceptual design goes to Thomas Gleixner,
>> while the bugs and other idiocies present in this implementation should be
>> attributed to me.
> 
> I went through the patches with a fine comb again and there is nothing
> left which triggered my futex wreckage sensors. Thanks for your
> patience to go through the lather, rinse, repeat drill.
> 
> I think we are at a point where that code simply needs exposure to the
> hostile environment of RT-Java VMs. I'm going to pull that into
> tip/next and into -rt. Even if we have no requeue_pi user right now we
> definitly want to test the heck out of the changes which also affect
> the existing futex ops.
> 
> Uli, Jakub can you please go over the design and the user space
> interface ?
> 
> Darren, could you please polish the initial design notes - especially
> point out the subtle differences between requeue and requeue_pi - and
> send them into the thread? That might help Uli and Jakub and we
> definitly want to have that info preserved in Documentation/ as well.

I'll be away most of the day so I've whipped something up quickly in
order to get discussion started.  It is probably a little heavy on the
glibc details and a little light on the kernel details for inclusion in
Documentation/.  Please review for high-level content and let me know
what you would like to see more or less of.  I'll pick this back up
tomorrow to incorporate any suggestions and flesh out the kernel details
a bit more.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team


Futex Requeue PI
----------------

Requeueing of tasks from a non-PI futex to a PI futex requires special
handling in order to ensure the underlying rt_mutex is never left without an
owner if it has waiters; doing so would break the PI boosting logic [see
rt-mutex-desgin.txt]  For the purposes of brevity, this action will be referred
to as "requeue_pi" throughout this document.  Priority inheritance is
abbreviated throughout as "PI".

Motivation
----------

Without requeue_pi, the current implementation of pthread_cond_broadcast()
must resort to waking all the tasks waiting on a pthread_condvar and letting
them try and sort out which task gets to run first in classic thundering-herd
formation.  An ideal implementation would wake the highest priority waiter,
and leave the rest to the natural wakeup inherent in unlocking the mutex
associated with the condvar.

Consider the simplified glibc calls:

/* caller must lock mutex */
pthread_cond_wait(cond, mutex)
{
	lock(cond->__data.__lock);
	unlock(mutex);
	do {
	   unlock(cond->__data.__lock);
	   futex_wait(cond->__data.__futex);
	   lock(cond->__data.__lock);
	} while(...)
	unlock(cond->__data.__lock);
	lock(mutex);
}

pthread_cond_broadcast(cond)
{
	lock(cond->__data.__lock);
	unlock(cond->__data.__lock);
	futex_requeue(cond->data.__futex, cond->mutex);
}

Once pthread_cond_broadcast() requeues the tasks, the cond->mutex has waiters.
Note that pthread_cond_wait() attempts to lock the mutex only after it has
returned to userspace.  This will leave the underlying rt_mutex with waiters,
and no owner, breaking the previously mentioned PI boosting algorithms.

In order to support PI-aware pthread_condvar's, the kernel needs to be able to
requeue tasks to PI futexes.  This support implies that upon a successful
futex_wait system call, the caller would return to userspace already holding
the PI futex.  As such the glibc implemenation would be modified as follows:


/* caller must lock mutex */
pthread_cond_wait_pi(cond, mutex)
{
	lock(cond->__data.__lock);
	unlock(mutex);
	do {
	   unlock(cond->__data.__lock);
	   futex_wait_requeue_pi(cond->__data.__futex);
	   lock(cond->__data.__lock);
	} while(...)
	unlock(cond->__data.__lock);
        /* the kernel acquired the the mutex for us */
}

pthread_cond_broadcast_pi(cond)
{
	lock(cond->__data.__lock);
	unlock(cond->__data.__lock);
	futex_requeue_pi(cond->data.__futex, cond->mutex);
}

The actual glibc implemenation will likely test for PI and make the
necessary changes inside the existing calls rather than creating new calls
for the PI cases.  Similar changes are needed for pthread_cond_timedwait()
and pthread_cond_signal().

Implementation
--------------

In order to ensure the rt_mutex has an owner if it has waiters, it is necessary
for the both the requeue code as well as the waiting code to be able to acquire
the rt_mutex before returning to userspace (the requeue code cannot simply wake
the waiter and leave it to acquire the rt_mutex as it would open a race window
between the requeue call returning to userspace and the waiter waking and
starting to run.  This is especially true in the uncontended case.

To accomplish this, rt_mutex lock acquistion has to be able to be accomlished
vicariously by the requeue code on behalf of the waiter.  This is accomplished
via two new rt_mutex helper routines: rt_mutex_start_proxy_lock() (called by 
the requeue code) and rt_mutex_finish_proxy_lock(), called by the waiter upon
wakeup.

Two new system calls provide the kernel<->userspace interface to requeue_pi:
FUTEX_WAIT_REQUEUE_PI and FUTEX_REQUEUE_PI (and FUTEX_CMP_REQUEUE_PI).

FUTEX_WAIT_REQUEUE_PI is called by the waiter (pthread_cond_wait() and
pthread_cond_timedwait()) to block on the initial futex and wait to be requeued
to a PI aware futex.  The implemenation is basically the result of a high speed
collision between futex_wait() and futex_lock_pi(), with some extra logic to
check for the additional wake-up scenarios.

FUTEX_REQUEUE_PI is called by the waker (pthread_cond_broadcast() and
pthread_cond_signal()) to requeue and possibly wake the waiting tasks.
Internally, this system call is still handled by futex_requeue (by passing
requeue_pi=1).  Before requeueing, futex_requeue() attempts to acquire the
requeue target PI futex on behalf of the top waiter, if it can, this waiter is
woken.  It then proceeds to requeue the remaining nr_wake+nr_requeue tasks to
the PI futex.  It calls rt_mutex_start_proxy_lock() prior to each requeue to
prepare the task as a waiter on the underlying rt_mutex.  It is possible that
the lock can be acquired at this stage as well, if so, the next waiter is woken
to finish the acquisition of the lock.  FUTEX_REQUEUE_PI accepts nr_wake and
nr_requeue as arguments, but their sum is all that really matters.  It will
wake or requeue up to nr_wake + nr_requeue tasks.  It will wake only as many
tasks as it can acquire the lock for, which in the majority of cases should be
0 as good programming practice dictates that the caller of either
pthread_cond_broadcast() or pthread_cond_signal() acquire the mutex prior to
making the call.  FUTEX_REQUEUE_PI requires that nr_wake=1.  nr_requeue should
be INT_MAX for broadcast and 0 for signal.


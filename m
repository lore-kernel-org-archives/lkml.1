Return-Path: <linux-kernel-owner+w=401wt.eu-S1761007AbZDGVdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007AbZDGVdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbZDGVdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:33:13 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54319 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbZDGVdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:33:12 -0400
Message-ID: <49DBC68F.3080508@us.ibm.com>
Date: Tue, 07 Apr 2009 14:33:03 -0700
From: Vernon Mauery <vernux@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Darren Hart <dvhltc@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
       niv@linux.vnet.ibm.com
Subject: Re: [tip PATCH v7 0/9] RFC: futex: requeue pi implementation
References: <20090403203832.9772.21410.stgit@Aeon> <alpine.LFD.2.00.0904041035411.2884@localhost.localdomain> <49DA2DFA.5080205@us.ibm.com>
In-Reply-To: <49DA2DFA.5080205@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> Thomas Gleixner wrote:
>> Darren,
>>
>> On Fri, 3 Apr 2009, Darren Hart wrote:
[snip]
>> Darren, could you please polish the initial design notes - especially
>> point out the subtle differences between requeue and requeue_pi - and
>> send them into the thread? That might help Uli and Jakub and we
>> definitly want to have that info preserved in Documentation/ as well.
> 
> I'll be away most of the day so I've whipped something up quickly in
> order to get discussion started.  It is probably a little heavy on the
> glibc details and a little light on the kernel details for inclusion in
> Documentation/.  Please review for high-level content and let me know
> what you would like to see more or less of.  I'll pick this back up
> tomorrow to incorporate any suggestions and flesh out the kernel details
> a bit more.
> 

Darren,

A gentle review of your documentation follows.

> Futex Requeue PI
> ----------------
> 
> Requeueing of tasks from a non-PI futex to a PI futex requires special
> handling in order to ensure the underlying rt_mutex is never left without an
> owner if it has waiters; doing so would break the PI boosting logic [see
> rt-mutex-desgin.txt]  For the purposes of brevity, this action will be referred
> to as "requeue_pi" throughout this document.  Priority inheritance is
> abbreviated throughout as "PI".
> 
> Motivation
> ----------
> 
> Without requeue_pi, the current implementation of pthread_cond_broadcast()
> must resort to waking all the tasks waiting on a pthread_condvar and letting
> them try and sort out which task gets to run first in classic thundering-herd
       ^try to sort out^
> formation.  An ideal implementation would wake the highest priority waiter,
                                                     ^highest-priority^
> and leave the rest to the natural wakeup inherent in unlocking the mutex
> associated with the condvar.
> 
> Consider the simplified glibc calls:
> 
> /* caller must lock mutex */
> pthread_cond_wait(cond, mutex)
> {
>     lock(cond->__data.__lock);
>     unlock(mutex);
>     do {
>        unlock(cond->__data.__lock);
>        futex_wait(cond->__data.__futex);
>        lock(cond->__data.__lock);
>     } while(...)
>     unlock(cond->__data.__lock);
>     lock(mutex);
> }
> 
> pthread_cond_broadcast(cond)
> {
>     lock(cond->__data.__lock);
>     unlock(cond->__data.__lock);
>     futex_requeue(cond->data.__futex, cond->mutex);
> }
> 
> Once pthread_cond_broadcast() requeues the tasks, the cond->mutex has waiters.
> Note that pthread_cond_wait() attempts to lock the mutex only after it has
> returned to userspace.  This will leave the underlying rt_mutex with waiters,
> and no owner, breaking the previously mentioned PI boosting algorithms.
                                                  ^PI-boosting^
> 
> In order to support PI-aware pthread_condvar's, the kernel needs to be able to
> requeue tasks to PI futexes.  This support implies that upon a successful
> futex_wait system call, the caller would return to userspace already holding
> the PI futex.  As such the glibc implemenation would be modified as follows:
                                   ^implementation^
> 
> 
> /* caller must lock mutex */
> pthread_cond_wait_pi(cond, mutex)
> {
>     lock(cond->__data.__lock);
>     unlock(mutex);
>     do {
>        unlock(cond->__data.__lock);
>        futex_wait_requeue_pi(cond->__data.__futex);
>        lock(cond->__data.__lock);
>     } while(...)
>     unlock(cond->__data.__lock);
>        /* the kernel acquired the the mutex for us */
> }
> 
> pthread_cond_broadcast_pi(cond)
> {
>     lock(cond->__data.__lock);
>     unlock(cond->__data.__lock);
>     futex_requeue_pi(cond->data.__futex, cond->mutex);
> }
> 
> The actual glibc implemenation will likely test for PI and make the
                   ^implementation^

> necessary changes inside the existing calls rather than creating new calls
> for the PI cases.  Similar changes are needed for pthread_cond_timedwait()
> and pthread_cond_signal().
> 
> Implementation
> --------------
> 
> In order to ensure the rt_mutex has an owner if it has waiters, it is necessary
> for the both the requeue code as well as the waiting code to be able to acquire
> the rt_mutex before returning to userspace (the requeue code cannot simply wake

I would suggest not using a parenthetical expression here because of the length
of the enclosed sentence.  Also, you have a missing right parenthesis.

> the waiter and leave it to acquire the rt_mutex as it would open a race window
> between the requeue call returning to userspace and the waiter waking and
> starting to run.  This is especially true in the uncontended case.
> 
> To accomplish this, rt_mutex lock acquistion has to be able to be accomlished
                                    ^acquisition^                   ^accomplished^
> vicariously by the requeue code on behalf of the waiter.  This is accomplished

Lots of accomplishing going on here^^^.  And one is missing a its p.  Maybe
rewritten as:

To accomplish this, the rt_mutex lock must be acquired vicariously by the
requeue code on behalf of the waiter.  This is done by two new rt_mutex
helper routines: rt_mutex_start_proxy_lock(), called by he requeue code;
and rt_mutex_finish_proxy_lock(), called by the waiter upon wakeup.

> via two new rt_mutex helper routines: rt_mutex_start_proxy_lock() (called by
 > the requeue code) and rt_mutex_finish_proxy_lock(), called by the waiter upon
> wakeup.

I also changed the punctuation there to remove the parenthetical expression
modifying the first function, where only a comma was used on the second.  Too
many commas and modifications made me think that maybe a semicolon would work
well.

> 
> Two new system calls provide the kernel<->userspace interface to requeue_pi:
> FUTEX_WAIT_REQUEUE_PI and FUTEX_REQUEUE_PI (and FUTEX_CMP_REQUEUE_PI).
> 
> FUTEX_WAIT_REQUEUE_PI is called by the waiter (pthread_cond_wait() and
> pthread_cond_timedwait()) to block on the initial futex and wait to be requeued
> to a PI aware futex.  The implemenation is basically the result of a high speed
       ^PI-aware^           ^implementation^                           ^high-speed^
> collision between futex_wait() and futex_lock_pi(), with some extra logic to
> check for the additional wake-up scenarios.
> 
> FUTEX_REQUEUE_PI is called by the waker (pthread_cond_broadcast() and
> pthread_cond_signal()) to requeue and possibly wake the waiting tasks.
> Internally, this system call is still handled by futex_requeue (by passing
> requeue_pi=1).  Before requeueing, futex_requeue() attempts to acquire the
> requeue target PI futex on behalf of the top waiter, if it can, this waiter is
                                                     ^.  If^
> woken.  It then proceeds to requeue the remaining nr_wake+nr_requeue tasks to
> the PI futex.  It calls rt_mutex_start_proxy_lock() prior to each requeue to
> prepare the task as a waiter on the underlying rt_mutex.  It is possible that
> the lock can be acquired at this stage as well, if so, the next waiter is woken
                                                ^.  If^
> to finish the acquisition of the lock.  FUTEX_REQUEUE_PI accepts nr_wake and
> nr_requeue as arguments, but their sum is all that really matters.  It will

Lots of 'It' by this point.  Maybe replacing 'it' with a proper noun a couple
of times would help make sure we are all on the same page.

> wake or requeue up to nr_wake + nr_requeue tasks.  It will wake only as many
> tasks as it can acquire the lock for, which in the majority of cases should be
> 0 as good programming practice dictates that the caller of either
  ^0, as^
> pthread_cond_broadcast() or pthread_cond_signal() acquire the mutex prior to
> making the call.  FUTEX_REQUEUE_PI requires that nr_wake=1.  nr_requeue should
> be INT_MAX for broadcast and 0 for signal.

One final point is that generally numbers less than ten are spelled out, but
since this is a technical document where we see things like nr_wake=1, I figured
it would look more consistent to let those 0s slide.

Keep in mind that I am not really an editor so take my changes with a grain of
salt. (I am only *married* to an editor and if she gets wind that I am
pretending to be one on the side I will be in big trouble :)

--Vernon

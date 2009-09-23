Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZIWWcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZIWWcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZIWWcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:32:04 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:57484 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751837AbZIWWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:32:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsFAM89ukpMROOX/2dsb2JhbACBUdVjgiWBdgU
Date: Wed, 23 Sep 2009 18:32:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Chris Friesen <cfriesen@nortel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace RCU: (ab)using futexes to save cpu cycles and
	energy
Message-ID: <20090923223204.GA2921@Krystal>
References: <20090923174820.GA12827@Krystal> <4ABA631A.8030306@nortel.com> <20090923190337.GA16983@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090923190337.GA16983@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:55:20 up 36 days,  8:44,  2 users,  load average: 0.26, 0.19,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Chris Friesen (cfriesen@nortel.com) wrote:
> > On 09/23/2009 11:48 AM, Mathieu Desnoyers wrote:
> > 
> > > Here are the primitives I've created. I'd like to have feedback on my
> > > futex use, just to make sure I did not do any incorrect assumptions.
> > 
> > > /*
> > >  * Wake-up any waiting defer thread. Called from many concurrent threads.
> > >  */
> > > static void wake_up_defer(void)
> > > {
> > >         if (unlikely(atomic_read(&defer_thread_futex) == -1))
> > >                 atomic_set(&defer_thread_futex, 0);
> > >                 futex(&defer_thread_futex, FUTEX_WAKE,
> > >                       0, NULL, NULL, 0);
> > > }
> > 
> > Is it a problem if multiple threads all hit the defer_thread_futex==-1
> > case simultaneously?
> 
> It should not be, since what we'll have is, e.g.:
> 
> thread 1 calls wakeup
> thread 2 calls wakeup
> thread 3 calls wait
> 
> (thread 3 is waiting on the futex, defer_thread_futex = -1)
> - thread 1 sees defer_thread_futex==-1
> - thread 2 sees defer_thread_futex==-1
> - thread 1 sets defer_thread_futex = 0
> - thread 2 sets defer_thread_futex = 0
> - thread 1 calls futex() to wake up the waiter, expect 0
> - thread 2 calls futex() to wake up the waiter, expect 0
> 
> Basically, what happens in this scenario is that the first futex()
> call will wake up any waiter, and the second will be a no-op.
> 
> Let's complicate this, if we have thread 3 running wait_defer()
> concurrently:
> 
> - thread 3 decrements defer_thread_futex
> - thread 1 sees defer_thread_futex==-1
> - thread 2 sees defer_thread_futex==-1
> - thread 1 sets defer_thread_futex = 0
> - thread 2 sets defer_thread_futex = 0
> - thread 1 calls futex() to wake up the waiter, expect 0
> - thread 2 calls futex() to wake up the waiter, expect 0
> - thread 3 calls futex() to wait, expect -1
>   Returns immediately because defer_thread_futex == 0
> 
> Other scenario, where thread decrements defer_thread_futex a bit later:
> 
> - thread 1 sees defer_thread_futex==0
> - thread 2 sees defer_thread_futex==0
> - thread 3 decrements defer_thread_futex
> - thread 3 tests defer_thread_futex==-1
> - thread 3 calls futex() to wait, expect -1
> 
> In this scenario, we have to notice that if threads 1/2 enqueued tasks
> to do before checking defer_thread_futex, these tasks would not be seen
> by the waiter thread.
> 
> So correct memory ordering of:
> 
> - wake_up_defer:
>   * queue callbacks to perform (1)
>   * wake up (2)
> 
> - wait_defer:
>   * for (;;)
>     * wait for futex (3)
>     * sleep 100ms (wait for more callbacks to be enqueued)
>     * dequeue callbacks, execute them (4)
> 
> 
> actually matters. I'll have to be really careful about that (unless we
> just accept that tasks to perform could be queued for a while, however,
> I'd like to give an upper bound to the delay between batch callback
> execution).
> 
> Ensuring that 1 is written before 2, and that 4 is done before 3 seems a
> bit racy. (I have to got out for lunch now, so I'll have to review the
> ordering afterward)
> 

I knew I needed to think about it a bit more. Here is the proposed
algorithm hopefully fixing the race identified in the 3rd scenario
above. The idea is to perform the "check for empty queue" between the
&defer_thread_futex decrement and the test in wait_defer. It skips the
futex call and proceed if the list is non-empty.

As I am drilling into the problem, it looks very much like an attempt to
implement efficient wait queues in userspace based on sys_futex().

/*
 * Wake-up any waiting defer thread. Called from many concurrent
 * threads.
 */
static void wake_up_defer(void)
{
        if (unlikely(atomic_read(&defer_thread_futex) == -1)) {
                atomic_set(&defer_thread_futex, 0);
                futex(&defer_thread_futex, FUTEX_WAKE, 0,
                      NULL, NULL, 0);
        }
}

/*
 * Defer thread waiting. Single thread.
 */
static void wait_defer(void)
{
        atomic_dec(&defer_thread_futex);
        smp_mb();       /* Write futex before read queue */
        if (rcu_defer_num_callbacks()) {
                smp_mb();       /* Read queue before write futex */
                /* Callbacks are queued, don't wait. */
                atomic_set(&defer_thread_futex, 0);
        } else {
                smp_rmb();      /* Read queue before read futex */
                if (atomic_read(&defer_thread_futex) == -1)
                        futex(&defer_thread_futex, FUTEX_WAIT, -1,
                              NULL, NULL, 0);
        }
}

- call_rcu():
  * queue callbacks to perform
  * smp_mb()
  * wake_up_defer()

- defer thread:
  * for (;;)
    * wait_defer()
    * sleep 100ms (wait for more callbacks to be enqueued)
    * dequeue callbacks, execute them

The goal here is that if call_rcu() enqueues a callback (even if it
races with defer thread going to sleep), there should not be a
potentially infinite delay before it gets executed. Therefore, being
blocked in sys_futex while there is a callback to execute, without any
hope to be woken up unless another callback is queued, would not meet
that design requirement. I think that checking the number of queued
callbacks within wait_defer() as I propose here should address this
situation.

Comments ?

Mathieu

> 
> >  If so, maybe this should use an atomic
> > test-and-set operation so that only one thread actually calls futex().
> 
> It's not a matter if many threads wake up the waiter, so I don't think
> the test-and-set is required. The benefit of using a simple test here is
> that we don't have to bring the cache-line in exclusive mode to the
> local CPU to perform the test. It can stay shared.
> 
> > 
> > > /*
> > >  * Defer thread waiting. Single thread.
> > >  */
> > > static void wait_defer(void)
> > > {
> > >         atomic_dec(&defer_thread_futex);
> > >         if (atomic_read(&defer_thread_futex) == -1)
> > >                 futex(&defer_thread_futex, FUTEX_WAIT, -1,
> > >                       NULL, NULL, 0);
> > > }
> > 
> > Is it a problem if the value of defer_thread_futex changes to zero after
> > the dec but before the test?
> 
> No. That's not a problem, because this means there is a concurrent "wake
> up". Seeing a value of "0" here will skip over the futex wait and go on.
> The concurrent futex wakeup call will simply be a no-op in that case.
> 
> Thanks for the comments,
> 
> Mathieu
> 
> > 
> > Chris
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

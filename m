Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbZJDUhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbZJDUhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 16:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbZJDUhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 16:37:17 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55386 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757752AbZJDUhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 16:37:15 -0400
Date: Sun, 4 Oct 2009 13:36:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace RCU: (ab)using futexes to save cpu cycles and
	energy
Message-ID: <20091004203639.GH6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090923174820.GA12827@Krystal> <20091001144037.GB6205@linux.vnet.ibm.com> <20091004143745.GA19785@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004143745.GA19785@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 10:37:45AM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Wed, Sep 23, 2009 at 01:48:20PM -0400, Mathieu Desnoyers wrote:
> > > Hi,
> > > 
> > > When implementing the call_rcu() "worker thread" in userspace, I ran
> > > into the problem that it had to be woken up periodically to check if
> > > there are any callbacks to execute. However, I easily imagine that this
> > > does not fit well with the "green computing" definition.
> > > 
> > > Therefore, I've looked at ways to have the call_rcu() callers waking up
> > > this worker thread when callbacks are enqueued. However, I don't want to
> > > take any lock and the fast path (when no wake up is required) should not
> > > cause any cache-line exchange.
> > > 
> > > Here are the primitives I've created. I'd like to have feedback on my
> > > futex use, just to make sure I did not do any incorrect assumptions.
> > > 
> > > This could also be eventually used in the QSBR Userspace RCU quiescent
> > > state and in mb/signal userspace RCU when exiting RCU read-side C.S. to
> > > ensure synchronize_rcu() does not busy-wait for too long.
> > > 
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
> > > 
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
> > The standard approach would be to use pthread_cond_wait() and
> > pthread_cond_broadcast().  Unfortunately, this would require holding a
> > pthread_mutex_lock across both operations, which would not necessarily
> > be so good for wake-up-side scalability.
> 
> The pthread_cond_broadcast() mutex is really a bugger when it comes to
> execute it at each rcu_read_unlock(). We could as well use a mutex to
> protect the whole read-side.. :-(
> 
> > That said, without this sort of heavy-locking approach, wakeup races
> > are quite difficult to avoid.
> 
> I did a formal model of my futex-based wait/wakeup. The main idea is
> that the waiter:
> 
> - Set itself to "waiting"
> - Checks the "real condition" for which it will wait (e.g. queues empty
>   when used for rcu callbacks, no more ongoing old reader thread C.S.
>   when used in synchronize_rcu())
> - Calls sys_futex if the variable have not changed.
> 
> And the waker:
> - sets the "real condition" waking up the waiter (enqueuing, or
>   rcu_read_unlock())
> - check if the waiter must be woken up, if so, wake it up by setting the
>   state to "running" and calling sys_futex.
> 
> But as you say, wakeup races are difficult (but not impossible!) to
> avoid. This is why I resorted to a formal model of the wait/wakeup
> scheme to ensure that we cannot end up in a situation where a waker
> races with the waiter and does not wake it up when it should. This is
> nothing fancy (does not model memory and instruction reordering
> automatically), but I figure that memory barriers are required between
> almost every steps of this algorithm, so by adding smp_mb() I end up
> ensure sequential behavior. I added test cases in the model to ensure
> that incorrect memory reordering _would_ cause errors by doing the
> reordering by hand in error-injection runs.

My question is whether pthread_cond_wait() and pthread_cond_broadcast()
can substitute for the raw call to futex.  Unless I am missing something
(which I quite possibly am), the kernel will serialize on the futex
anyway, so serialization in user-mode code does not add much additional
pain.

> The model is available at:
> http://www.lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git;a=tree;f=futex-wakeup;h=4ddeaeb2784165cb0465d4ca9f7d27acb562eae3;hb=refs/heads/formal-model
> 
> (this is in the formal-model branch of the urcu tree, futex-wakeup
> subdir)
> 
> This is modeling this snippet of code :
> 
> static int defer_thread_futex;
> 
> /*
>  * Wake-up any waiting defer thread. Called from many concurrent threads.
>  */
> static void wake_up_defer(void)
> {
>         if (unlikely(uatomic_read(&defer_thread_futex) == -1)) {
>                 uatomic_set(&defer_thread_futex, 0);
>                 futex(&defer_thread_futex, FUTEX_WAKE, 1,
>                       NULL, NULL, 0);
>         }
> }
> 
> static void enqueue(void *callback)	/* not the actual types */
> {
> 	add_to_queue(callback);
> 	smp_mb();
> 	wake_up_defer();
> }
> 
> /*
>  * rcu_defer_num_callbacks() returns the total number of callbacks
>  * enqueued.
>  */
> 
> /*
>  * Defer thread waiting. Single thread.
>  */
> static void wait_defer(void)
> {
>         uatomic_dec(&defer_thread_futex);
>         smp_mb();       /* Write futex before read queue */
>         if (rcu_defer_num_callbacks()) {
>                 smp_mb();       /* Read queue before write futex */
>                 /* Callbacks are queued, don't wait. */
>                 uatomic_set(&defer_thread_futex, 0);
>         } else {
>                 smp_rmb();      /* Read queue before read futex */
>                 if (uatomic_read(&defer_thread_futex) == -1)
>                         futex(&defer_thread_futex, FUTEX_WAIT, -1,
>                               NULL, NULL, 0);
>         }
> }
> 
> 
> Comments are welcome,

I will take a look after further recovery from jetlag.  Not yet competent
to review this kind of stuff.  Give me a few days.  ;-)

							Thanx, Paul

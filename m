Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZJDByC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZJDByC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 21:54:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZJDByA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 21:54:00 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37462 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756801AbZJDByA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 21:54:00 -0400
Date: Thu, 1 Oct 2009 07:40:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace RCU: (ab)using futexes to save cpu cycles and
	energy
Message-ID: <20091001144037.GB6205@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090923174820.GA12827@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923174820.GA12827@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 01:48:20PM -0400, Mathieu Desnoyers wrote:
> Hi,
> 
> When implementing the call_rcu() "worker thread" in userspace, I ran
> into the problem that it had to be woken up periodically to check if
> there are any callbacks to execute. However, I easily imagine that this
> does not fit well with the "green computing" definition.
> 
> Therefore, I've looked at ways to have the call_rcu() callers waking up
> this worker thread when callbacks are enqueued. However, I don't want to
> take any lock and the fast path (when no wake up is required) should not
> cause any cache-line exchange.
> 
> Here are the primitives I've created. I'd like to have feedback on my
> futex use, just to make sure I did not do any incorrect assumptions.
> 
> This could also be eventually used in the QSBR Userspace RCU quiescent
> state and in mb/signal userspace RCU when exiting RCU read-side C.S. to
> ensure synchronize_rcu() does not busy-wait for too long.
> 
> /*
>  * Wake-up any waiting defer thread. Called from many concurrent threads.
>  */
> static void wake_up_defer(void)
> {
>         if (unlikely(atomic_read(&defer_thread_futex) == -1))
>                 atomic_set(&defer_thread_futex, 0);
>                 futex(&defer_thread_futex, FUTEX_WAKE,
>                       0, NULL, NULL, 0);
> }
> 
> /*
>  * Defer thread waiting. Single thread.
>  */
> static void wait_defer(void)
> {
>         atomic_dec(&defer_thread_futex);
>         if (atomic_read(&defer_thread_futex) == -1)
>                 futex(&defer_thread_futex, FUTEX_WAIT, -1,
>                       NULL, NULL, 0);
> }

The standard approach would be to use pthread_cond_wait() and
pthread_cond_broadcast().  Unfortunately, this would require holding a
pthread_mutex_lock across both operations, which would not necessarily
be so good for wake-up-side scalability.

That said, without this sort of heavy-locking approach, wakeup races
are quite difficult to avoid.

							Thanx, Paul

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765285AbXFEQZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765285AbXFEQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbXFEQZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:25:16 -0400
Received: from www.osadl.org ([213.239.205.134]:45032 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754800AbXFEQZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:25:14 -0400
Subject: Re: [RFC][PATCH] muptiple bugs in PI futexes
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20070523115159.GA30251@ms2.inr.ac.ru>
References: <20070507144351.GA12302@ms2.inr.ac.ru>
	 <20070523072609.GC6859@elte.hu>  <20070523115159.GA30251@ms2.inr.ac.ru>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 18:25:11 +0200
Message-Id: <1181060711.4404.114.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2007-05-23 at 15:51 +0400, Alexey Kuznetsov wrote:
> The first chunk: results in self-inflicted deadlock inside glibc.
> Sometimes futex_lock_pi returns -ESRCH, when it is not expected
> and glibc enters to for(;;) sleep() to simulate deadlock. This problem
> is quite obvious and I think the patch is right. Though it looks like
> each "if" in futex_lock_pi() got some stupid special case "else if". :-)

Hmm, what means not expected ? -ESRCH is returned, when the owner task
is not found. 

> +		} else if (ret == -ESRCH) {
> +			/* Process could exit right now, so that robust list
> +			 * was processed after we got uval. Retry. */
> +			pagefault_disable();
> +			curval = futex_atomic_cmpxchg_inatomic(uaddr,
> +							       uval, uval);

When we retrieve uval, we hold the hash bucket lock and we keep it down
to this point, so the robust list processing is stuck on the hash bucket
lock. Also using uval is wrong. The user space variable holds "newval",
which was written there before:

 curval = cmpxchg_futex_value_locked(uaddr, uval, newval); 

So you just go back up to retry_locked or into the fault handling path
(which is unlikely).

This does not really explain, why you do prevent the -ESRCH return value
in the next cycle, except for the case, where we go through the fault
handling path.

> The second chunk: sometimes futex_lock_pi() returns -EDEADLK,
> when nobody has the lock. The reason is also obvious (see comment
> in the patch), but correct fix is far beyond my comprehension.
> I guess someone already saw this, the chunk:
> 
>                         if (rt_mutex_trylock(&q.pi_state->pi_mutex))
>                                 ret = 0;
> 
> is obviously from the same opera. But it does not work, because the
> rtmutex is really taken at this point: wake_futex_pi() of previous
> owner reassigned it to us.

No, -EDEADLK is returned from here:

	ret = rt_mutex_timed_lock(&q.pi_state->pi_mutex, to, 1);

The rtmutex code only returns -EDEADLK, when the lock is already held by
the task or when it runs into a circular rtmutex dependency (e.g. a ABBA
deadlock) during the PI-walk.

Also wake_futex_pi() does not assign the ownership of the rtmutex, it
assigns the ownership of the futex pi state and unlocks the rtmutex,
which sets the pending owner. The pending owner is the highest priority
waiter. The ownership assignment of the rtmutex happens inside the
rtmutex code, not in wake_futex_pi.

The trylock is covering the following situation:

rt_mutex_timed_lock(&q.pi_state->pi_mutex, to, 1) returns -ETIMEOUT;

Now it get's blocked on:
	spin_lock(q.lock_ptr);

because on the other CPU the futex is unlocked. The rt-mutex code does
not find a waiter and unlocks the rtmutex with no new owner. The hack
bucket lock is released and the task which is blocked on the hash bucket
lock has a chance to grab it.

>  My fix works. But it looks very stupid.
> I would think about removal of shift of ownership in wake_futex_pi()
> and making all the work in context of process taking lock.

I have no clue why it works. The only explanation is, that an existing
deadlock is resolved by the exiting task.

>  		if (ret && q.pi_state->owner == curr) {

This happens only, when the rtmutex was unlocked by another task between
the return from the rtmutex code and reacquiring the hash bucket lock.

>  			if (rt_mutex_trylock(&q.pi_state->pi_mutex))
>  				ret = 0;

If we can get the rtmutex here, we are the owner of the lock and need to
fix up ownership in the user space variable further down.

> +			/* Holy crap... Now futex lock returns -EDEADLK
> +			 * sometimes, because ownership was passed to us while
> +			 * unlock of previous owner. Who wrote this?

I admit, that I was one of the authors :)

> +			 * Please, fix this correctly. For now:
> +			 */

The fix is to remove it and to find the real cause of the problem.

I'm running the glibc tests since hours w/o tripping into it.

	tglx



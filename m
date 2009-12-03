Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbZLCGzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbZLCGzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 01:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZLCGza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 01:55:30 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:51686 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZLCGza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 01:55:30 -0500
Message-ID: <4B1760DD.6060606@us.ibm.com>
Date: Wed, 02 Dec 2009 22:55:25 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Michel Lespinasse <walken@google.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation (and ADAPTIVE)
References: <20091117074655.GA14023@google.com> <1258447807.7816.20.camel@laptop>
In-Reply-To: <1258447807.7816.20.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> --- 
> Subject: futex: implement adaptive spin
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Jan 20 14:40:36 CET 2009
> 
> Implement kernel side adaptive spining for futexes.

Hi Peter,

I'm working on reconciling the SET_WAIT patch from Michel and your
ADAPTIVE_WAIT patch. So far I've forward ported the adaptive patch and
cleaned up a few things. I'd like your take on the updated adaptive spin
in futex_wait() below.

Also, in the adaptive case, we have to decide how to handle the val !=
uval case after the adaptive spin has failed. Otherwise
futex_wait_setup() will return EWOULDBLOCK. Just checking for the flag
may not be enough if the lock is subsequently released as we should then
acquire it. We face many of the same problems here as we do with
FUTEX_LOCK_PI, except we don't have the rtmutex code to handle some of
them for us.

I'm starting to think this may be best implemented as a new function and
op code, maybe something like FUTEX_LOCK which could take ADAPTIVE as a
flag. FUTEX_LOCK would demux to futex_lock() in do_futex. This op would
define the futex value policy like PI and Robust futexes do. We would
basicaly be implementing a mutex, indicated by the LOCK term (as with
FUTEX_LOCK_PI), as opposed to the WAIT term which is really meant to be
a simple wait queue. This would keep some complexity out of the wait
paths.

> 
> This is implemented as a new futex op: FUTEX_WAIT_ADAPTIVE, because it
> requires the futex lock field to contain a TID and regular futexes do
> not have that restriction.
> 
> FUTEX_WAIT_ADAPTIVE will spin while the lock owner is running (on a 
> different cpu) or until the task gets preempted. After that it behaves
> like FUTEX_WAIT.
> 
> The spin loop tries to acquire the lock by cmpxchg(lock, 0, tid) == tid
> on the lower 30 bits (TID_MASK) of the lock field -- leaving the
> WAITERS and OWNER_DIED flags in tact.
> 
> NOTE: we could fold mutex_spin_on_owner() and futex_spin_on_owner() by
> adding a lock_owner function argument.
> 
>   void lock_spin_on_owner(struct thread_info *(*lock_owner)(void *lock),
>                           void *lock, struct thread_info *owner);
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/futex.h |    2 +
>  include/linux/sched.h |    1 
>  kernel/futex.c        |   96 ++++++++++++++++++++++++++++++++++++++++++--------
>  kernel/sched.c        |   59 ++++++++++++++++++++++++++++++
>  4 files changed, 143 insertions(+), 15 deletions(-)
> 

> ...

> +static int futex_wait(u32 __user *uaddr, int flags,
>  		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
>  {
>  	struct task_struct *curr = current;
> @@ -1176,11 +1206,43 @@ static int futex_wait(u32 __user *uaddr,
>  	if (!bitset)
>  		return -EINVAL;
> 
> +#ifdef CONFIG_SMP
> +	if (!futex_cmpxchg_enabled || !(flags & FLAGS_ADAPTIVE))
> +		goto skip_adaptive;
> +
> +	preempt_disable();
> +	for (;;) {
> +		struct thread_info *owner;
> +		u32 curval = 0, newval = task_pid_vnr(curr);
> +
> +		owner = futex_owner(uaddr);
> +		if (owner && futex_spin_on_owner(uaddr, owner))
> +			break;
> +
> +		if (get_futex_value_locked(&uval, uaddr))
> +			break;
> +
> +		curval |= uval & ~FUTEX_TID_MASK;
> +		newval |= uval & ~FUTEX_TID_MASK;
> +
> +		if (cmpxchg_futex_value_locked(uaddr, curval, newval)
> +				== newval)
> +			return 0;
> +
> +		if (!owner && (need_resched() || rt_task(curr)))
> +			break;
> +
> +		cpu_relax();
> +	}
> +	preempt_enable();
> +skip_adaptive:
> +#endif
> +

Maybe something more like:

#ifdef CONFIG_SMP
	if ((flags & FLAGS_ADAPTIVE) && futex_cmpxchg_enabled) {
		preempt_disable();
		tid = task_pid_vnr(current);
		for (;;) {
			struct thread_info *owner;
			u32 uval, curval, newval;

			owner = futex_owner(uaddr);
			if (owner && futex_spin_on_owner(uaddr, owner))
				break;

			if (get_futex_value_locked(&uval, uaddr))
				break;

			/*
			 * Preserve robust and waiters bits.
			 */
			curval = uval & ~FUTEX_TID_MASK;
			newval = tid | curval;

			if (cmpxchg_futex_value_locked(uaddr, curval, newval)
					== curval)
				return 0;

			/*
			 * Adaptive futexes manage the owner atomically. We
			 * are not in danger of deadlock by preempting a pending
			 * owner. Abort the loop if our time slice has expired.
			 * RT Threads can spin until they preempt the owner, at
			 * which point they will break out of the loop anyway.
			 */
			if (need_resched())
				break;

			/* Do we need this here? */
			cpu_relax();
		}
		preempt_enable();
	}
#endif

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbZK3WJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbZK3WJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZK3WJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:09:52 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33059 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbZK3WJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:09:51 -0500
Message-ID: <4B1442B0.6000402@us.ibm.com>
Date: Mon, 30 Nov 2009 14:09:52 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Michel Lespinasse <walken@google.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
References: <20091117074655.GA14023@google.com> <1258447807.7816.20.camel@laptop>
In-Reply-To: <1258447807.7816.20.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

Hey Peter,

Some thoughts on adaptive futexes ...

> Subject: futex: implement adaptive spin
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Jan 20 14:40:36 CET 2009
> 
> Implement kernel side adaptive spining for futexes.
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
> ...

> Index: linux-2.6/kernel/futex.c
> ===================================================================
> --- linux-2.6.orig/kernel/futex.c
> +++ linux-2.6/kernel/futex.c
> @@ -1158,10 +1158,40 @@ handle_fault:
>   */
>  #define FLAGS_SHARED		0x01
>  #define FLAGS_CLOCKRT		0x02
> +#define FLAGS_ADAPTIVE		0x03
> 
>  static long futex_wait_restart(struct restart_block *restart);
> 
> -static int futex_wait(u32 __user *uaddr, int fshared,
> +#ifdef CONFIG_SMP
> +struct thread_info *futex_owner(u32 __user *uaddr)
> +{
> +	struct thread_info *ti = NULL;
> +	struct task_struct *p;
> +	pid_t pid;
> +	u32 uval;
> +
> +	if (get_futex_value_locked(&uval, uaddr))
> +		return NULL;

Just give up if it would cause a fault?

> +
> +	pid = uval & FUTEX_TID_MASK;
> +	rcu_read_lock();
> +	p = find_taks_by_vpid(pid);

I'm impressed that you can create such a solid patch without compiling it!

> +	if (p) {
> +		const struct cred *cred, *pcred;
> +
> +		cread = current_cred();
> +		pcred = __task_cred(p);
> +		if (cred->euid == pcred->euid ||
> +		    cred->euid == pcred->uid)
> +			ti = task_thread_info(p);
> +	}
> +	rcu_read_unlock();
> +
> +	return ti;
> +}
> +#endif
> +
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

Do we need to lookup newval every iteration?

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

"== curval" isn't it? futex_atomic_cmpxchg_inatomic() returns the 
oldval, not the newval.

> +			return 0;
> +
> +		if (!owner && (need_resched() || rt_task(curr)))
> +			break;

Hrm... why go through the loop at all for an rt_task if we bail on the 
first iteration?

> +
> +		cpu_relax();
> +	}
> +	preempt_enable();
> +skip_adaptive:

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

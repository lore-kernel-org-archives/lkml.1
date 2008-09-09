Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYIIP4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYIIP4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYIIP4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:56:37 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40171 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbYIIP4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:56:36 -0400
Date: Tue, 9 Sep 2008 20:01:52 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frank Mayhar <fmayhar@google.com>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5] Fix itimer/many thread hang.
Message-ID: <20080909160152.GA714@tv-sign.ru>
References: <1220906643.31846.21.camel@bobble.smo.corp.google.com> <20080909070329.GD2086@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909070329.GD2086@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Ingo Molnar wrote:
>
> * Frank Mayhar <fmayhar@google.com> wrote:
>
> > Overview
> >
> > This patch reworks the handling of POSIX CPU timers, including the 
> > ITIMER_PROF, ITIMER_VIRT timers and rlimit handling.  It was put 
> > together with the help of Roland McGrath, the owner and original 
> > writer of this code.

I'll try to read this patch on weekend. A couple of naive questions
right now.

> +static inline void thread_group_cputime(
> +	struct task_struct *tsk,
> +	struct task_cputime *times)
> +{
> +	struct signal_struct *sig;
> +	int i;
> +	struct task_cputime *tot;
> +
> +	rcu_read_lock();
> +	sig = rcu_dereference(tsk->signal);
> +	if (unlikely(!sig) || !sig->cputime.totals) {
> +		times->utime = tsk->utime;
> +		times->stime = tsk->stime;
> +		times->sum_exec_runtime = tsk->se.sum_exec_runtime;
> +		rcu_read_unlock();
> +		return;
> +	}
> +	times->stime = times->utime = cputime_zero;
> +	times->sum_exec_runtime = 0;
> +	for_each_possible_cpu(i) {
> +		tot = per_cpu_ptr(tsk->signal->cputime.totals, i);
> +		times->utime = cputime_add(times->utime, tot->utime);
> +		times->stime = cputime_add(times->stime, tot->stime);
> +		times->sum_exec_runtime += tot->sum_exec_runtime;
> +	}
> +	rcu_read_unlock();
> +}

The patch has a lot of

	rcu_read_lock();
	sig = rcu_dereference(tsk->signal);

This is bogus, task_struct->signal is not protected by RCU.

However, at first glance the code (this and other funcs) looks correct...
Either tsk == current, or the code runs under ->siglock. Or we know that
->signal can't go away (wait_task_zombie).

As for this particular function, it seems to me that ->signal == NULL
is not possible, no?

Please remove the false RCU stuff.

Btw, this function has a lot of callers, perhaps it is better to
uninline it.

>  static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  {
>  	struct signal_struct *sig;
>  	int ret;
>
>  	if (clone_flags & CLONE_THREAD) {
> -		atomic_inc(&current->signal->count);
> -		atomic_inc(&current->signal->live);
> -		return 0;
> +		ret = thread_group_cputime_clone_thread(current, tsk);
> +		if (likely(!ret)) {
> +			atomic_inc(&current->signal->count);
> +			atomic_inc(&current->signal->live);
> +		}

So, the first CLONE_THREAD creates ->cputime.totals. After that
thread_group_cputime_account_xxx() start to use it even if the task
doesn't have the attached cpu timers.

Stupid question: can't we allocate .totals in posix_cpu_timer_create() /
set_process_cpu_timer() ?

> +int thread_group_cputime_alloc_smp(struct task_struct *tsk)
> +{
> +	struct signal_struct *sig = tsk->signal;
> +	struct task_cputime *cputime;
> +
> +	/*
> +	 * If we have multiple threads and we don't already have a
> +	 * per-CPU task_cputime struct, allocate one and fill it in with
> +	 * the times accumulated so far.
> +	 */
> +	if (sig->cputime.totals)
> +		return 0;
> +	cputime = alloc_percpu(struct task_cputime);
> +	if (cputime == NULL)
> +		return -ENOMEM;
> +	read_lock(&tasklist_lock);

tasklist_lock is not needed,

> +	spin_lock_irq(&tsk->sighand->siglock);

->siglock is enough.

> +static inline int task_cputime_expired(const struct task_cputime *sample,
> +					const struct task_cputime *expires)
> +{
> +	if (!cputime_eq(expires->utime, cputime_zero) &&
> +	    cputime_ge(sample->utime, expires->utime))
> +		return 1;
> +	if (!cputime_eq(expires->stime, cputime_zero) &&
> +	    cputime_ge(cputime_add(sample->utime, sample->stime),
> +		       expires->stime))
> +		return 1;
> +	if (expires->sum_exec_runtime != 0 &&
> +	    sample->sum_exec_runtime >= expires->sum_exec_runtime)
> +		return 1;
> +	return 0;
> +}
> +
> +static inline int fastpath_timer_check(struct task_struct *tsk,
> +					struct signal_struct *sig)
> +{
> +	struct task_cputime task_sample = {
> +		.utime = tsk->utime,
> +		.stime = tsk->stime,
> +		.sum_exec_runtime = tsk->se.sum_exec_runtime
> +	};
> +	struct task_cputime group_sample;
> +
> +	if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
> +		return 1;
> +	thread_group_cputime(tsk, &group_sample);
> +	return task_cputime_expired(&group_sample, &sig->cputime_expires);
> +}
> +
> @@ -1323,30 +1304,30 @@ void run_posix_cpu_timers(struct task_struct *tsk)
>  {
>  	LIST_HEAD(firing);
>  	struct k_itimer *timer, *next;
> +	struct signal_struct *sig;
> +	struct sighand_struct *sighand;
> +	unsigned long flags;
>
>  	BUG_ON(!irqs_disabled());
>
> -#define UNEXPIRED(clock) \
> -		(cputime_eq(tsk->it_##clock##_expires, cputime_zero) || \
> -		 cputime_lt(clock##_ticks(tsk), tsk->it_##clock##_expires))
> -
> -	if (UNEXPIRED(prof) && UNEXPIRED(virt) &&
> -	    (tsk->it_sched_expires == 0 ||
> -	     tsk->se.sum_exec_runtime < tsk->it_sched_expires))
> -		return;
> -
> -#undef	UNEXPIRED
> -
> +	/* Safely pick up tsk->signal and make sure it's valid. */
> +	rcu_read_lock();
> +	sig = rcu_dereference(tsk->signal);
>  	/*
> -	 * Double-check with locks held.
> +	 * The fast path checks that there are no expired thread or thread
> +	 * group timers.  If that's so, just return.
>  	 */
> -	read_lock(&tasklist_lock);
> -	if (likely(tsk->signal != NULL)) {
> -		spin_lock(&tsk->sighand->siglock);
> -
> +	if (unlikely(!sig) || !fastpath_timer_check(tsk, sig)) {
> +		rcu_read_unlock();
> +		return;

Ugh. Probably I misunderstand the patch, but...

Let's suppose the task doesn't have cpu timers. Currently, in this case
run_posix_cpu_timers() quickly checks UNEXPIRED() and returns. With this
patch we call fastpath_timer_check(). The first task_cputime_expired()
returns 0, so we are doing thread_group_cputime()->for_each_possible_cpu().

Not good, this code runs every timer tick. Perhaps it makes sense
to add a fastpath check.

(again, rcu stuff is bogus)

Oleg.


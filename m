Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbYINRpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbYINRpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 13:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYINRpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 13:45:12 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35366 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbYINRpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 13:45:10 -0400
Date: Sun, 14 Sep 2008 21:50:40 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fmayhar@google.com, adobriyan@gmail.com,
       mingo@elte.hu, roland@redhat.com, tglx@linutronix.de
Subject: Re: + itimers-fix-itimer-many-thread-hang.patch added to -mm tree
Message-ID: <20080914175040.GA819@tv-sign.ru>
References: <200809122353.m8CNrCmR011310@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809122353.m8CNrCmR011310@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/mm-commits/lkml/

(Frank, please don't forget to CC me ;)

On 09/12, Andrew Morton wrote:
>
> Subject: itimers: fix itimer/many thread hang
> From: Frank Mayhar <fmayhar@google.com>

Still can't read this patch thoroughly, but imho it looks good...
A couple of random nits.

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
> +	if (task_cputime_zero(&tsk->cputime_expires) &&
> +	    task_cputime_zero(&sig->cputime_expires))
> +		return 0;
> +	if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
> +		return 1;
> +	thread_group_cputime(tsk, &group_sample);
> +	return task_cputime_expired(&group_sample, &sig->cputime_expires);
> +}

Really minor nit. Suppose that task_cputime_zero(tsk) == T and
task_cputime_zero(sig) == F. In that case task_cputime_expired(&task_sample)
is not needed, perhaps it makes sense to reformat this function a bit

	static inline int fastpath_timer_check(struct task_struct *tsk,
						struct signal_struct *sig)
	{
		if (!task_cputime_zero(&tsk->cputime_expires)) {
			struct task_cputime task_sample = {
				.utime = tsk->utime,
				.stime = tsk->stime,
				.sum_exec_runtime = tsk->se.sum_exec_runtime
			};
			if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
				return 1;
		}

		if (!task_cputime_zero(&sig->cputime_expires)) {
			struct task_cputime group_sample;
			thread_group_cputime(tsk, &group_sample);
			if (task_cputime_expired(&group_sample, &sig->cputime_expires))
				return 1;
		}

		return 0;
	}

this way it also looks more symmetrical.

> @@ -1323,30 +1358,29 @@ void run_posix_cpu_timers(struct task_st
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
> +	/* Pick up tsk->signal and make sure it's valid. */
> +	sig = tsk->signal;
>  	/*
> -	 * Double-check with locks held.
> +	 * The fast path checks that there are no expired thread or thread
> +	 * group timers.  If that's so, just return.  Also check that
> +	 * tsk->signal is non-NULL; this probably can't happen but cover the
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^

No, no, the comment is wrong. This certainly can happen if the timer
tick happens after exit_notify(). I meant that thread_group_cputime()
can't hit ->signal == NULL.

> +	 * possibility anyway.
>  	 */
> -	read_lock(&tasklist_lock);
> -	if (likely(tsk->signal != NULL)) {
> -		spin_lock(&tsk->sighand->siglock);
> -
> +	if (unlikely(!sig) || !fastpath_timer_check(tsk, sig)) {
> +		return;
> +	}

I'd suggest to move the "if (!sig)" check into fastpath_timer_check(),
run_posix_cpu_timers() doesn't use sig, but this is matter a of taste.

OK, I did the patch on top of the change in fastpath_timer_check(),
just for illustration:

--- CPU-TIMERS-2.6.27-rc5/kernel/posix-cpu-timers.c~2_ftc_sig	2008-09-14 20:17:51.000000000 +0400
+++ CPU-TIMERS-2.6.27-rc5/kernel/posix-cpu-timers.c	2008-09-14 20:39:45.000000000 +0400
@@ -1323,15 +1323,18 @@ static inline int task_cputime_expired(c
  * fastpath_timer_check - POSIX CPU timers fast path.
  *
  * @tsk:	The task (thread) being checked.
- * @sig:	The signal pointer for that task.
  *
  * If there are no timers set return false.  Otherwise snapshot the task and
  * thread group timers, then compare them with the corresponding expiration
  # times.  Returns true if a timer has expired, else returns false.
  */
-static inline int fastpath_timer_check(struct task_struct *tsk,
-					struct signal_struct *sig)
+static inline int fastpath_timer_check(struct task_struct *tsk)
 {
+	struct signal_struct *sig = tsk->signal;
+
+	if (unlikely(!sig))
+		return 0;
+
 	if (!task_cputime_zero(&tsk->cputime_expires)) {
 		struct task_cputime task_sample = {
 			.utime = tsk->utime,
@@ -1361,22 +1364,17 @@ void run_posix_cpu_timers(struct task_st
 {
 	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
-	struct signal_struct *sig;
 	struct sighand_struct *sighand;
 	unsigned long flags;
 
 	BUG_ON(!irqs_disabled());
-
-	/* Pick up tsk->signal and make sure it's valid. */
-	sig = tsk->signal;
 	/*
 	 * The fast path checks that there are no expired thread or thread
-	 * group timers.  If that's so, just return.  Also check that
-	 * tsk->signal is non-NULL; this probably can't happen but cover the
-	 * possibility anyway.
+	 * group timers.  If that's so, just return.
 	 */
-	if (unlikely(!sig) || !fastpath_timer_check(tsk, sig))
+	if (!fastpath_timer_check(tsk))
 		return;
+
 	sighand = lock_task_sighand(tsk, &flags);
 	if (likely(sighand)) {
 		/*
------------------------------------------------------------------------------

> +	sighand = lock_task_sighand(tsk, &flags);
> +	if (likely(sighand)) {

This is a bit misleading, lock_task_sighand() can't fail or we have a bug.
We already checked ->signal != NULL, and the task is current, we can use
spin_lock(&tsk->sighand->siglock).

To clarify, if lock_task_sighand() could fail, fastpath_timer_check()
is not safe. So I'd suggest the next patch:

--- CPU-TIMERS-2.6.27-rc5/kernel/posix-cpu-timers.c~3_rpct_siglock	2008-09-14 20:39:45.000000000 +0400
+++ CPU-TIMERS-2.6.27-rc5/kernel/posix-cpu-timers.c	2008-09-14 20:46:22.000000000 +0400
@@ -1364,8 +1364,6 @@ void run_posix_cpu_timers(struct task_st
 {
 	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
-	struct sighand_struct *sighand;
-	unsigned long flags;
 
 	BUG_ON(!irqs_disabled());
 	/*
@@ -1375,26 +1373,24 @@ void run_posix_cpu_timers(struct task_st
 	if (!fastpath_timer_check(tsk))
 		return;
 
-	sighand = lock_task_sighand(tsk, &flags);
-	if (likely(sighand)) {
-		/*
-		 * Here we take off tsk->signal->cpu_timers[N] and
-		 * tsk->cpu_timers[N] all the timers that are firing, and
-		 * put them on the firing list.
-		 */
-		check_thread_timers(tsk, &firing);
-		check_process_timers(tsk, &firing);
+	spin_lock(&tsk->sighand->siglock);
+	/*
+	 * Here we take off tsk->signal->cpu_timers[N] and
+	 * tsk->cpu_timers[N] all the timers that are firing, and
+	 * put them on the firing list.
+	 */
+	check_thread_timers(tsk, &firing);
+	check_process_timers(tsk, &firing);
 
-		/*
-		 * We must release these locks before taking any timer's lock.
-		 * There is a potential race with timer deletion here, as the
-		 * siglock now protects our private firing list.  We have set
-		 * the firing flag in each timer, so that a deletion attempt
-		 * that gets the timer lock before we do will give it up and
-		 * spin until we've taken care of that timer below.
-		 */
-	}
-	unlock_task_sighand(tsk, &flags);
+	/*
+	 * We must release these locks before taking any timer's lock.
+	 * There is a potential race with timer deletion here, as the
+	 * siglock now protects our private firing list.  We have set
+	 * the firing flag in each timer, so that a deletion attempt
+	 * that gets the timer lock before we do will give it up and
+	 * spin until we've taken care of that timer below.
+	 */
+	spin_unlock(&tsk->sighand->siglock);
 
 	/*
 	 * Now that all the timers on our list have the firing flag,
-------------------------------------------------------------------------------

> +unsigned long long thread_group_sched_runtime(struct task_struct *p)
> +{
> +	unsigned long flags;
> +	u64 ns;
> +	struct rq *rq;
> +	struct task_cputime totals;
> +
> +	rq = task_rq_lock(p, &flags);
> +	thread_group_cputime(p, &totals);
> +	ns = totals.sum_exec_runtime + task_delta_exec(p, rq);
>  	task_rq_unlock(rq, &flags);

Hmm. This is used by cpu_clock_sample_group_locked() which has already
called thread_group_cputime(). Yes, without task_rq_lock(), but
thread_group_cputime() is not "atomic" anyway. And please note that
thread_group_sched_runtime() is not that "group", we don't account
task_delta_exec() for other threads. Perhaps we can kill this function?
Or, at least, perhaps we can simplify this:

--- CPU-TIMERS-2.6.27-rc5/kernel/posix-cpu-timers.c~4_cpu_clock_sample_group	2008-09-14 20:46:22.000000000 +0400
+++ CPU-TIMERS-2.6.27-rc5/kernel/posix-cpu-timers.c	2008-09-14 21:29:20.000000000 +0400
@@ -299,7 +299,7 @@ static int cpu_clock_sample(const clocki
 		cpu->cpu = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = task_sched_runtime(p);
+		cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
 		break;
 	}
 	return 0;
@@ -327,7 +327,7 @@ static int cpu_clock_sample_group_locked
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = thread_group_sched_runtime(p);
+		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
 		break;
 	}
 	return 0;
--- CPU-TIMERS-2.6.27-rc5/kernel/sched.c~4_cpu_clock_sample_group	2008-09-14 18:29:33.000000000 +0400
+++ CPU-TIMERS-2.6.27-rc5/kernel/sched.c	2008-09-14 21:29:30.000000000 +0400
@@ -4039,54 +4039,22 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 /*
  * Return any ns on the sched_clock that have not yet been banked in
  * @p in case that task is currently running.
- *
- * Called with task_rq_lock() held on @rq.
  */
-static unsigned long long task_delta_exec(struct task_struct *p, struct rq *rq)
+unsigned long long task_delta_exec(struct task_struct *p)
 {
+	struct rq *rq;
+	unsigned long flags;
+	u64 ns = 0;
+
+	rq = task_rq_lock(p, &flags);
 	if (task_current(rq, p)) {
 		u64 delta_exec;
 
 		update_rq_clock(rq);
 		delta_exec = rq->clock - p->se.exec_start;
 		if ((s64)delta_exec > 0)
-			return delta_exec;
+			ns = delta_exec;
 	}
-	return 0;
-}
-
-/*
- * Return p->sum_exec_runtime plus any more ns on the sched_clock
- * that have not yet been banked in case the task is currently running.
- */
-unsigned long long task_sched_runtime(struct task_struct *p)
-{
-	unsigned long flags;
-	u64 ns;
-	struct rq *rq;
-
-	rq = task_rq_lock(p, &flags);
-	ns = p->se.sum_exec_runtime + task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
-
-	return ns;
-}
-
-/*
- * Return sum_exec_runtime for the thread group plus any more ns on the
- * sched_clock that have not yet been banked in case the task is currently
- * running.
- */
-unsigned long long thread_group_sched_runtime(struct task_struct *p)
-{
-	unsigned long flags;
-	u64 ns;
-	struct rq *rq;
-	struct task_cputime totals;
-
-	rq = task_rq_lock(p, &flags);
-	thread_group_cputime(p, &totals);
-	ns = totals.sum_exec_runtime + task_delta_exec(p, rq);
 	task_rq_unlock(rq, &flags);
 
 	return ns;
-------------------------------------------------------------------------------

BTW, with or without this patch cpu_clock_sample_group() doesn't need
->siglock, afaics.

Oleg.


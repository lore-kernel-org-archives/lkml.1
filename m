Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbZDBQqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbZDBQqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763342AbZDBQpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:45:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33737 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763867AbZDBQpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:45:42 -0400
Date: Thu, 2 Apr 2009 18:45:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] itimers: merge ITIMER_VIRT and ITIMER_PROF common
	code
Message-ID: <20090402164524.GB7385@elte.hu>
References: <20090402141146.0ede3c2a@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402141146.0ede3c2a@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(added more Cc:s)

* Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Both cpu itimers have same data flow in the few places, this patch make
> unification of code related with VIRT and PROF itimers.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  include/linux/sched.h     |    6 +-
>  kernel/fork.c             |    8 +-
>  kernel/itimer.c           |  136 +++++++++++++++++++--------------------------
>  kernel/posix-cpu-timers.c |   81 ++++++++++++++-------------
>  4 files changed, 107 insertions(+), 124 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 29df637..b4c19c2 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -440,6 +440,8 @@ struct pacct_struct {
>  	unsigned long		ac_minflt, ac_majflt;
>  };
>  
> +enum itimer_number {IT_VIRT = 0, IT_PROF = 1};
> +
>  /**
>   * struct task_cputime - collected CPU time counts
>   * @utime:		time spent in user mode, in &cputime_t units
> @@ -526,8 +528,8 @@ struct signal_struct {
>  	ktime_t it_real_incr;
>  
>  	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
> -	cputime_t it_prof_expires, it_virt_expires;
> -	cputime_t it_prof_incr, it_virt_incr;
> +	cputime_t it_expires[2];
> +	cputime_t it_incr[2];
>  
>  	/*
>  	 * Thread group totals for process CPU timers.
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 47c1584..6c7044a 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -803,10 +803,10 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
>  	thread_group_cputime_init(sig);
>  
>  	/* Expiration times and increments. */
> -	sig->it_virt_expires = cputime_zero;
> -	sig->it_virt_incr = cputime_zero;
> -	sig->it_prof_expires = cputime_zero;
> -	sig->it_prof_incr = cputime_zero;
> +	sig->it_expires[IT_VIRT] = cputime_zero;
> +	sig->it_expires[IT_PROF] = cputime_zero;
> +	sig->it_incr[IT_VIRT] = cputime_zero;
> +	sig->it_incr[IT_PROF] = cputime_zero;
>  
>  	/* Cached expiration times. */
>  	sig->cputime_expires.prof_exp = cputime_zero;
> diff --git a/kernel/itimer.c b/kernel/itimer.c
> index 58762f7..ec64fea 100644
> --- a/kernel/itimer.c
> +++ b/kernel/itimer.c
> @@ -41,10 +41,34 @@ static struct timeval itimer_get_remtime(struct hrtimer *timer)
>  	return ktime_to_timeval(rem);
>  }
>  
> +static void get_cpu_itimer(struct task_struct *tsk, enum itimer_number i,
> +			   struct itimerval *value)
> +{
> +	cputime_t cval, cinterval;
> +
> +	spin_lock_irq(&tsk->sighand->siglock);
> +	cval = tsk->signal->it_expires[i];
> +	cinterval = tsk->signal->it_incr[i];
> +	if (!cputime_eq(cval, cputime_zero)) {
> +		struct task_cputime cputime;
> +		cputime_t utime;
> +
> +		thread_group_cputimer(tsk, &cputime);
> +		utime = cputime.utime;
> +		if (cputime_le(cval, utime)) { /* about to fire */
> +			cval = jiffies_to_cputime(1);
> +		} else {
> +			cval = cputime_sub(cval, utime);
> +		}
> +	}
> +	spin_unlock_irq(&tsk->sighand->siglock);
> +	cputime_to_timeval(cval, &value->it_value);
> +	cputime_to_timeval(cinterval, &value->it_interval);
> +}
> +
>  int do_getitimer(int which, struct itimerval *value)
>  {
>  	struct task_struct *tsk = current;
> -	cputime_t cinterval, cval;
>  
>  	switch (which) {
>  	case ITIMER_REAL:
> @@ -55,44 +79,10 @@ int do_getitimer(int which, struct itimerval *value)
>  		spin_unlock_irq(&tsk->sighand->siglock);
>  		break;
>  	case ITIMER_VIRTUAL:
> -		spin_lock_irq(&tsk->sighand->siglock);
> -		cval = tsk->signal->it_virt_expires;
> -		cinterval = tsk->signal->it_virt_incr;
> -		if (!cputime_eq(cval, cputime_zero)) {
> -			struct task_cputime cputime;
> -			cputime_t utime;
> -
> -			thread_group_cputimer(tsk, &cputime);
> -			utime = cputime.utime;
> -			if (cputime_le(cval, utime)) { /* about to fire */
> -				cval = jiffies_to_cputime(1);
> -			} else {
> -				cval = cputime_sub(cval, utime);
> -			}
> -		}
> -		spin_unlock_irq(&tsk->sighand->siglock);
> -		cputime_to_timeval(cval, &value->it_value);
> -		cputime_to_timeval(cinterval, &value->it_interval);
> +		get_cpu_itimer(tsk, IT_VIRT, value);
>  		break;
>  	case ITIMER_PROF:
> -		spin_lock_irq(&tsk->sighand->siglock);
> -		cval = tsk->signal->it_prof_expires;
> -		cinterval = tsk->signal->it_prof_incr;
> -		if (!cputime_eq(cval, cputime_zero)) {
> -			struct task_cputime times;
> -			cputime_t ptime;
> -
> -			thread_group_cputimer(tsk, &times);
> -			ptime = cputime_add(times.utime, times.stime);
> -			if (cputime_le(cval, ptime)) { /* about to fire */
> -				cval = jiffies_to_cputime(1);
> -			} else {
> -				cval = cputime_sub(cval, ptime);
> -			}
> -		}
> -		spin_unlock_irq(&tsk->sighand->siglock);
> -		cputime_to_timeval(cval, &value->it_value);
> -		cputime_to_timeval(cinterval, &value->it_interval);
> +		get_cpu_itimer(tsk, IT_PROF, value);
>  		break;
>  	default:
>  		return(-EINVAL);
> @@ -128,6 +118,35 @@ enum hrtimer_restart it_real_fn(struct hrtimer *timer)
>  	return HRTIMER_NORESTART;
>  }
>  
> +static void set_cpu_itimer(struct task_struct *tsk, enum itimer_number i,
> +			   struct itimerval *value, struct itimerval *ovalue)
> +{
> +	cputime_t cval, cinterval, nval, ninterval;
> +
> +	nval = timeval_to_cputime(&value->it_value);
> +	ninterval = timeval_to_cputime(&value->it_interval);
> +
> +	spin_lock_irq(&tsk->sighand->siglock);
> +
> +	cval = tsk->signal->it_expires[i];
> +	cinterval = tsk->signal->it_incr[i];
> +	if (!cputime_eq(cval, cputime_zero) ||
> +	    !cputime_eq(nval, cputime_zero)) {
> +		if (cputime_gt(nval, cputime_zero))
> +			nval = cputime_add(nval, jiffies_to_cputime(1));
> +		set_process_cpu_timer(tsk, i, &nval, &cval);
> +	}
> +	tsk->signal->it_expires[i] = nval;
> +	tsk->signal->it_incr[i] = ninterval;
> +
> +	spin_unlock_irq(&tsk->sighand->siglock);
> +
> +	if (ovalue) {
> +		cputime_to_timeval(cval, &ovalue->it_value);
> +		cputime_to_timeval(cinterval, &ovalue->it_interval);
> +	}
> +}
> +
>  /*
>   * Returns true if the timeval is in canonical form
>   */
> @@ -139,7 +158,6 @@ int do_setitimer(int which, struct itimerval *value, struct itimerval *ovalue)
>  	struct task_struct *tsk = current;
>  	struct hrtimer *timer;
>  	ktime_t expires;
> -	cputime_t cval, cinterval, nval, ninterval;
>  
>  	/*
>  	 * Validate the timevals in value.
> @@ -174,48 +192,10 @@ again:
>  		spin_unlock_irq(&tsk->sighand->siglock);
>  		break;
>  	case ITIMER_VIRTUAL:
> -		nval = timeval_to_cputime(&value->it_value);
> -		ninterval = timeval_to_cputime(&value->it_interval);
> -		spin_lock_irq(&tsk->sighand->siglock);
> -		cval = tsk->signal->it_virt_expires;
> -		cinterval = tsk->signal->it_virt_incr;
> -		if (!cputime_eq(cval, cputime_zero) ||
> -		    !cputime_eq(nval, cputime_zero)) {
> -			if (cputime_gt(nval, cputime_zero))
> -				nval = cputime_add(nval,
> -						   jiffies_to_cputime(1));
> -			set_process_cpu_timer(tsk, CPUCLOCK_VIRT,
> -					      &nval, &cval);
> -		}
> -		tsk->signal->it_virt_expires = nval;
> -		tsk->signal->it_virt_incr = ninterval;
> -		spin_unlock_irq(&tsk->sighand->siglock);
> -		if (ovalue) {
> -			cputime_to_timeval(cval, &ovalue->it_value);
> -			cputime_to_timeval(cinterval, &ovalue->it_interval);
> -		}
> +		set_cpu_itimer(tsk, IT_VIRT, value, ovalue);
>  		break;
>  	case ITIMER_PROF:
> -		nval = timeval_to_cputime(&value->it_value);
> -		ninterval = timeval_to_cputime(&value->it_interval);
> -		spin_lock_irq(&tsk->sighand->siglock);
> -		cval = tsk->signal->it_prof_expires;
> -		cinterval = tsk->signal->it_prof_incr;
> -		if (!cputime_eq(cval, cputime_zero) ||
> -		    !cputime_eq(nval, cputime_zero)) {
> -			if (cputime_gt(nval, cputime_zero))
> -				nval = cputime_add(nval,
> -						   jiffies_to_cputime(1));
> -			set_process_cpu_timer(tsk, CPUCLOCK_PROF,
> -					      &nval, &cval);
> -		}
> -		tsk->signal->it_prof_expires = nval;
> -		tsk->signal->it_prof_incr = ninterval;
> -		spin_unlock_irq(&tsk->sighand->siglock);
> -		if (ovalue) {
> -			cputime_to_timeval(cval, &ovalue->it_value);
> -			cputime_to_timeval(cinterval, &ovalue->it_interval);
> -		}
> +		set_cpu_itimer(tsk, IT_PROF, value, ovalue);
>  		break;
>  	default:
>  		return -EINVAL;
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 8e5d9a6..76e125c 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -17,8 +17,8 @@ void update_rlimit_cpu(unsigned long rlim_new)
>  	cputime_t cputime;
>  
>  	cputime = secs_to_cputime(rlim_new);
> -	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
> -	    cputime_lt(current->signal->it_prof_expires, cputime)) {
> +	if (cputime_eq(current->signal->it_expires[IT_PROF], cputime_zero) ||
> +	    cputime_lt(current->signal->it_expires[IT_PROF], cputime)) {
>  		spin_lock_irq(&current->sighand->siglock);
>  		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
>  		spin_unlock_irq(&current->sighand->siglock);
> @@ -619,18 +619,18 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
>  			default:
>  				BUG();
>  			case CPUCLOCK_VIRT:
> -				if (!cputime_eq(p->signal->it_virt_expires,
> +				if (!cputime_eq(p->signal->it_expires[IT_VIRT],
>  						cputime_zero) &&
> -				    cputime_lt(p->signal->it_virt_expires,
> +				    cputime_lt(p->signal->it_expires[IT_VIRT],
>  					       timer->it.cpu.expires.cpu))
>  					break;
>  				p->signal->cputime_expires.virt_exp =
>  					timer->it.cpu.expires.cpu;
>  				break;
>  			case CPUCLOCK_PROF:
> -				if (!cputime_eq(p->signal->it_prof_expires,
> +				if (!cputime_eq(p->signal->it_expires[IT_PROF],
>  						cputime_zero) &&
> -				    cputime_lt(p->signal->it_prof_expires,
> +				    cputime_lt(p->signal->it_expires[IT_PROF],
>  					       timer->it.cpu.expires.cpu))
>  					break;
>  				i = p->signal->rlim[RLIMIT_CPU].rlim_cur;
> @@ -1069,6 +1069,36 @@ static void stop_process_timers(struct task_struct *tsk)
>  	spin_unlock_irqrestore(&cputimer->lock, flags);
>  }
>  
> +static cputime_t check_cpu_itimer(struct task_struct *tsk, enum itimer_number i,
> +				  cputime_t expires, cputime_t cur_time)
> +{
> +	struct signal_struct *const sig = tsk->signal;
> +
> +	if (cputime_eq(sig->it_expires[i], cputime_zero))
> +		return expires;
> +
> +	if (cputime_ge(cur_time, sig->it_expires[i])) {
> +		int signo;
> +
> +		sig->it_expires[i] = sig->it_incr[i];
> +		if (!cputime_eq(sig->it_expires[i], cputime_zero)) {
> +			sig->it_expires[i] = cputime_add(sig->it_expires[i],
> +							 cur_time);
> +		}
> +
> +		signo = (i == IT_VIRT) ? SIGVTALRM : SIGPROF;
> +		__group_send_sig_info(signo, SEND_SIG_PRIV, tsk);
> +	}
> +
> +	if (!cputime_eq(sig->it_expires[i], cputime_zero) &&
> +	    (cputime_eq(expires, cputime_zero) ||
> +	     cputime_lt(sig->it_expires[i], expires))) {
> +		expires = sig->it_expires[i];
> +	}
> +
> +	return expires;
> +}
> +
>  /*
>   * Check for any per-thread CPU timers that have fired and move them
>   * off the tsk->*_timers list onto the firing list.  Per-thread timers
> @@ -1088,10 +1118,10 @@ static void check_process_timers(struct task_struct *tsk,
>  	 * Don't sample the current process CPU clocks if there are no timers.
>  	 */
>  	if (list_empty(&timers[CPUCLOCK_PROF]) &&
> -	    cputime_eq(sig->it_prof_expires, cputime_zero) &&
> +	    cputime_eq(sig->it_expires[IT_PROF], cputime_zero) &&
>  	    sig->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY &&
>  	    list_empty(&timers[CPUCLOCK_VIRT]) &&
> -	    cputime_eq(sig->it_virt_expires, cputime_zero) &&
> +	    cputime_eq(sig->it_expires[IT_VIRT], cputime_zero) &&
>  	    list_empty(&timers[CPUCLOCK_SCHED])) {
>  		stop_process_timers(tsk);
>  		return;
> @@ -1151,38 +1181,9 @@ static void check_process_timers(struct task_struct *tsk,
>  	/*
>  	 * Check for the special case process timers.
>  	 */
> -	if (!cputime_eq(sig->it_prof_expires, cputime_zero)) {
> -		if (cputime_ge(ptime, sig->it_prof_expires)) {
> -			/* ITIMER_PROF fires and reloads.  */
> -			sig->it_prof_expires = sig->it_prof_incr;
> -			if (!cputime_eq(sig->it_prof_expires, cputime_zero)) {
> -				sig->it_prof_expires = cputime_add(
> -					sig->it_prof_expires, ptime);
> -			}
> -			__group_send_sig_info(SIGPROF, SEND_SIG_PRIV, tsk);
> -		}
> -		if (!cputime_eq(sig->it_prof_expires, cputime_zero) &&
> -		    (cputime_eq(prof_expires, cputime_zero) ||
> -		     cputime_lt(sig->it_prof_expires, prof_expires))) {
> -			prof_expires = sig->it_prof_expires;
> -		}
> -	}
> -	if (!cputime_eq(sig->it_virt_expires, cputime_zero)) {
> -		if (cputime_ge(utime, sig->it_virt_expires)) {
> -			/* ITIMER_VIRTUAL fires and reloads.  */
> -			sig->it_virt_expires = sig->it_virt_incr;
> -			if (!cputime_eq(sig->it_virt_expires, cputime_zero)) {
> -				sig->it_virt_expires = cputime_add(
> -					sig->it_virt_expires, utime);
> -			}
> -			__group_send_sig_info(SIGVTALRM, SEND_SIG_PRIV, tsk);
> -		}
> -		if (!cputime_eq(sig->it_virt_expires, cputime_zero) &&
> -		    (cputime_eq(virt_expires, cputime_zero) ||
> -		     cputime_lt(sig->it_virt_expires, virt_expires))) {
> -			virt_expires = sig->it_virt_expires;
> -		}
> -	}
> +	prof_expires = check_cpu_itimer(tsk, IT_PROF, prof_expires, ptime);
> +	virt_expires = check_cpu_itimer(tsk, IT_VIRT, virt_expires, utime);
> +
>  	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
>  		unsigned long psecs = cputime_to_secs(ptime);
>  		cputime_t x;
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

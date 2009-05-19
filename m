Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZESNx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZESNx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZESNxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:53:12 -0400
Received: from www.tglx.de ([62.245.132.106]:45310 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbZESNxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:53:10 -0400
Date: Tue, 19 May 2009 15:52:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend3 1/2] itimers: merge ITIMER_VIRT and ITIMER_PROF
 common code
In-Reply-To: <20090518135011.5de06307@dhcp-lab-109.englab.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.0905191517080.5983@localhost.localdomain>
References: <20090518135011.5de06307@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw,

On Mon, 18 May 2009, Stanislaw Gruszka wrote:
> Both cpu itimers have same data flow in the few places, this patch make
> unification of code related with VIRT and PROF itimers.

Sorry for late response.
 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> Compared to previous patch bug (using utime instead of sum stime + utime when
> setup PROF itimer) is fixed. I also no longer introduce new IT_PROF and IT_VIRT
> definitions, only CPUCLOCK_PROF and CPUCLOCK_VIRT are used.
>
>  include/linux/sched.h     |    8 ++-
>  kernel/fork.c             |    8 +-
>  kernel/itimer.c           |  151 ++++++++++++++++++++++-----------------------
>  kernel/posix-cpu-timers.c |   86 +++++++++++++-------------
>  4 files changed, 125 insertions(+), 128 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b4c38bc..0d8367b 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -454,6 +454,11 @@ struct pacct_struct {
>  	unsigned long		ac_minflt, ac_majflt;
>  };
>  
> +struct cpu_itimer {
> +	cputime_t expires;
> +	cputime_t incr;
> +};
> +
>  /**
>   * struct task_cputime - collected CPU time counts
>   * @utime:		time spent in user mode, in &cputime_t units
> @@ -540,8 +545,7 @@ struct signal_struct {
>  	ktime_t it_real_incr;
>  
>  	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
> -	cputime_t it_prof_expires, it_virt_expires;
> -	cputime_t it_prof_incr, it_virt_incr;
> +	struct cpu_itimer it[2];

I like the general idea of the patch, but it's not obvious that
CPUCLOCK_PROF and CPUCLOCK_VIRT happen to be defined as 0 resp 1.

This needs at least a comment.

> +static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
> +			   struct itimerval *value)
> +{
> +	cputime_t cval, cinterval;
> +	struct cpu_itimer *it = &tsk->signal->it[clock_id];
> +
> +	spin_lock_irq(&tsk->sighand->siglock);
> +
> +	cval = it->expires;
> +	cinterval = it->incr;

  We dereference it-> w/o checking clock_id first ?

> +	if (!cputime_eq(cval, cputime_zero)) {
> +		struct task_cputime cputime;
> +		cputime_t t;
> +
> +		thread_group_cputimer(tsk, &cputime);
> +		switch (clock_id) {
> +		default:
> +			BUG();

  So the BUG here is correct, but a little late. OTOH we only have local
  callers, so that will only catch stupidity of people changing the
  calling code. Not sure if it's worth bothering with it at all.

> +		case CPUCLOCK_PROF:
> +			t = cputime_add(cputime.utime, cputime.stime);
> +			break;
> +		case CPUCLOCK_VIRT:
> +			t = cputime.utime;
> +			break;
> +		}
> +
> +		if (cputime_le(cval, t)) { /* about to fire */

  Please avoid end of line comments. The if/else here can do without
  braces.

> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index bece7c0..b6accca 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -14,11 +14,11 @@
>   */
>  void update_rlimit_cpu(unsigned long rlim_new)
>  {
> -	cputime_t cputime;
> +	cputime_t cputime = secs_to_cputime(rlim_new);
> +	struct signal_struct *const sig = current->signal;
>  
> -	cputime = secs_to_cputime(rlim_new);
> -	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
> -	    cputime_gt(current->signal->it_prof_expires, cputime)) {
> +	if (cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) ||
> +	    cputime_gt(sig->it[CPUCLOCK_PROF].expires, cputime)) {
>  		spin_lock_irq(&current->sighand->siglock);
>  		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
>  		spin_unlock_irq(&current->sighand->siglock);
> @@ -613,36 +613,39 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
>  				break;
>  			}
>  		} else {
> +			struct signal_struct *const sig = p->signal;
> +
>  			/*
>  			 * For a process timer, set the cached expiration time.
>  			 */
> +

  Stray newline

>  			switch (CPUCLOCK_WHICH(timer->it_clock)) {
>  			default:
>  				BUG();
>  			case CPUCLOCK_VIRT:
> -				if (!cputime_eq(p->signal->it_virt_expires,
> +				if (!cputime_eq(sig->it[CPUCLOCK_VIRT].expires,
>  						cputime_zero) &&
> -				    cputime_lt(p->signal->it_virt_expires,
> +				    cputime_lt(sig->it[CPUCLOCK_VIRT].expires,
>  					       timer->it.cpu.expires.cpu))
>  					break;
>  				p->signal->cputime_expires.virt_exp =
>  					timer->it.cpu.expires.cpu;

  Should change to sig->cputime... as well

>  				break;
>  			case CPUCLOCK_PROF:
> -				if (!cputime_eq(p->signal->it_prof_expires,
> +				if (!cputime_eq(sig->it[CPUCLOCK_PROF].expires,
>  						cputime_zero) &&
> -				    cputime_lt(p->signal->it_prof_expires,
> +				    cputime_lt(sig->it[CPUCLOCK_PROF].expires,
>  					       timer->it.cpu.expires.cpu))
>  					break;

  That code could be simplified further by splitting out the
  comparisons into a separate function and doing

  	      	      	     	if (fred(&sig->it[CPUCLOCK_PROF], timer))
					break;

>  				i = p->signal->rlim[RLIMIT_CPU].rlim_cur;
>  				if (i != RLIM_INFINITY &&
>  				    i <= cputime_to_secs(timer->it.cpu.expires.cpu))
>  					break;
> -				p->signal->cputime_expires.prof_exp =
> +				sig->cputime_expires.prof_exp =
>  					timer->it.cpu.expires.cpu;

  Also we reference timer->it.cpu.expires.cpu in all 3 cases several
  times, so having an extra pointer to it would make the code more
  readable as well.

>  				break;
>  			case CPUCLOCK_SCHED:
> -				p->signal->cputime_expires.sched_exp =
> +				sig->cputime_expires.sched_exp =
>  					timer->it.cpu.expires.sched;
>  				break;
>  			}
> @@ -1070,6 +1073,28 @@ static void stop_process_timers(struct task_struct *tsk)
>  	spin_unlock_irqrestore(&cputimer->lock, flags);
>  }
>  
> +static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
> +			     cputime_t *expires, cputime_t cur_time, int signo)
> +{
> +	if (cputime_eq(it->expires, cputime_zero))
> +		return;
> +
> +	if (cputime_ge(cur_time, it->expires)) {
> +		it->expires = it->incr;
> +		if (!cputime_eq(it->expires, cputime_zero)) {
> +			it->expires = cputime_add(it->expires, cur_time);
> +		}

  	No braces please
> +
> +		__group_send_sig_info(signo, SEND_SIG_PRIV, tsk);
> +	}
> +
> +	if (!cputime_eq(it->expires, cputime_zero) &&
> +	    (cputime_eq(*expires, cputime_zero) ||
> +	     cputime_lt(it->expires, *expires))) {
> +		*expires = it->expires;
> +	}
> +}
> +

Looks fine otherwise. Thanks,

      tglx

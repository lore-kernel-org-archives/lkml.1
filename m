Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZBEVdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZBEVdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZBEVdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:33:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52135 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbZBEVdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:33:41 -0500
Date: Thu, 5 Feb 2009 22:30:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       yanmin_zhang@linux.intel.com, seto.hidetoshi@jp.fujitsu.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] timers: split process wide cpu clocks/timers
Message-ID: <20090205213059.GA5050@redhat.com>
References: <20090205112414.104100700@chello.nl> <20090205113139.119115519@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205113139.119115519@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05, Peter Zijlstra wrote:
>
> Change the process wide cpu timers/clocks so that we:
>
>  1) don't mess up the kernel with too many threads,
>  2) don't have a per-cpu allocation for each process,
>  3) have no impact when not used.
>
> In order to accomplish this we're going to split it into two parts:
>
>  - clocks; which can take all the time they want since they run
>            from user context -- ie. sys_clock_gettime(CLOCK_PROCESS_CPUTIME_ID)
>
>  - timers; which need constant time sampling but since they're
>            explicity used, the user can pay the overhead.
>
> The clock readout will go back to a full sum of the thread group, while the
> timers will run of a global 'clock' that only runs when needed, so only
> programs that make use of the facility pay the price.

Ah, personally I think this is a very nice idea!

A couple of minor questions, before I try to read this patch more...

>  static inline
> -void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
> +void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)

I know, it is silly to complain about the naming, but can't resist.

Now we have both thread_group_cputime() and thread_group_cputimer().
But it is not possible to distinguish them while reading the code.
For example, looks like posix_cpu_timers_exit_group() needs
thread_group_cputimer, not thread_group_cputime, no? But then we can
hit the WARN_ON(!cputimer->running). Afaics.

Hmm... Can't fastpath_timer_check()->thread_group_cputimer() have the
false warning too? Suppose we had the timer, then posix_cpu_timer_del()
removes this timer, but task_cputime_zero(&sig->cputime_expires) still
not true.

> +void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
> +{
> +	struct sighand_struct *sighand;
> +	struct signal_struct *sig;
> +	struct task_struct *t;
> +
> +	*times = INIT_CPUTIME;
> +
> +	rcu_read_lock();
> +	sighand = rcu_dereference(tsk->sighand);
> +	if (!sighand)
> +		goto out;
> +
> +	sig = tsk->signal;

I am afraid to be wrong, but it looks like we always call this function
when we know we must have a valid ->sighand/siglock. Perhaps we do not
need any check?

IOW, unless I missed something we should not just return if there is no
->sighand or ->signal, this just hides the problem while we should fix
the caller.

> + * Enable the process wide cpu timer accounting.
> + *
> + * serialized using ->sighand->siglock
> + */
> +static void start_process_timers(struct task_struct *tsk)
> +{
> +	tsk->signal->cputimer.running = 1;
> +	barrier();
> +}
> +
> +/*
> + * Release the process wide timer accounting -- timer stops ticking when
> + * nobody cares about it.
> + *
> + * serialized using ->sighand->siglock
> + */
> +static void stop_process_timers(struct task_struct *tsk)
> +{
> +	tsk->signal->cputimer.running = 0;
> +	barrier();
> +}

Could you explain these barriers?


And, I am a bit lost... set_process_cpu_timer() does cpu_timer_sample_group(),
but posix_cpu_timer_set() does cpu_clock_sample_group() in !CPUCLOCK_PERTHREAD
case, could you confirm this is correct?

Oleg.


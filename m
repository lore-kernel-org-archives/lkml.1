Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYC1K3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYC1K3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYC1K3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:29:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51775 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbYC1K3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:29:01 -0400
Date: Fri, 28 Mar 2008 11:28:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2.6.25-rc6] Fix itimer/many thread hang.
Message-ID: <20080328102844.GE633@elte.hu>
References: <20080305040826.D0E6127010A@magilla.localdomain> <1204830243.20004.31.camel@bobble.smo.corp.google.com> <20080311075020.A93DB26F991@magilla.localdomain> <1205269507.23124.57.camel@bobble.smo.corp.google.com> <20080311213507.5BCDF26F991@magilla.localdomain> <1205455050.19551.16.camel@bobble.smo.corp.google.com> <20080321071846.1B22B26F9A7@magilla.localdomain> <1206122240.14638.31.camel@bobble.smo.corp.google.com> <20080322215829.D69D026F9A7@magilla.localdomain> <1206665568.426.24.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206665568.426.24.camel@bobble.smo.corp.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Mayhar <fmayhar@google.com> wrote:

> +static inline void thread_group_times_init(struct signal_struct *sig)
> +{
> +	sig->thread_group_times = NULL;
> +}
> +
> +static inline void thread_group_times_free(struct signal_struct *sig)
> +{
> +	if (sig->thread_group_times)
> +		free_percpu(sig->thread_group_times);
> +}
> +
> +/*
> + * Allocate the thread_group_cputime struct appropriately and fill in the current
> + * values of the fields.  Called from do_setitimer() when setting an interval
> + * timer (ITIMER_PROF or ITIMER_VIRTUAL).  Assumes interrupts are enabled when
> + * it's called.  Note that there is no corresponding deallocation done from
> + * do_setitimer(); the structure is freed at process exit.
> + */
> +static inline int thread_group_times_alloc(struct task_struct *tsk)
> +{
> +	struct signal_struct *sig = tsk->signal;
> +	struct thread_group_cputime *thread_group_times;
> +	struct task_struct *t;
> +	cputime_t utime, stime;
> +	unsigned long long sum_exec_runtime;
> +
> +	/*
> +	 * If we don't already have a thread_group_cputime struct, allocate
> +	 * one and fill it in with the accumulated times.
> +	 */
> +	if (sig->thread_group_times)
> +		return 0;
> +	thread_group_times = alloc_percpu(struct thread_group_cputime);
> +	if (thread_group_times == NULL)
> +		return -ENOMEM;
> +	read_lock(&tasklist_lock);
> +	spin_lock_irq(&tsk->sighand->siglock);
> +	if (sig->thread_group_times) {
> +		spin_unlock_irq(&tsk->sighand->siglock);
> +		read_unlock(&tasklist_lock);
> +		free_percpu(thread_group_times);
> +		return 0;
> +	}
> +	sig->thread_group_times = thread_group_times;
> +	utime = sig->utime;
> +	stime = sig->stime;
> +	sum_exec_runtime = tsk->se.sum_exec_runtime;
> +	t = tsk;
> +	do {
> +		utime = cputime_add(utime, t->utime);
> +		stime = cputime_add(stime, t->stime);
> +		sum_exec_runtime += t->se.sum_exec_runtime;
> +	} while_each_thread(tsk, t);
> +	thread_group_times = per_cpu_ptr(sig->thread_group_times, get_cpu());
> +	thread_group_times->utime = utime;
> +	thread_group_times->stime = stime;
> +	thread_group_times->sum_exec_runtime = sum_exec_runtime;
> +	put_cpu_no_resched();
> +	spin_unlock_irq(&tsk->sighand->siglock);
> +	read_unlock(&tasklist_lock);
> +	return 0;
> +}

please dont put such a huge inline into a header.

> +
> +#define thread_group_update(sig, field, val, op) ({ \
> +	if (sig && sig->thread_group_times) {				\
> +		int cpu;						\
> +		struct thread_group_cputime *thread_group_times;	\
> +									\
> +		cpu = get_cpu();					\
> +		thread_group_times =					\
> +			per_cpu_ptr(sig->thread_group_times, cpu);	\
> +		thread_group_times->field =				\
> +			op(thread_group_times->field, val);		\
> +		put_cpu_no_resched();					\
> +	}								\
> +})

nor use any macros that includes code.

> +static inline int thread_group_cputime(struct thread_group_cputime *thread_group_times,
> +	struct signal_struct *sig)

ditto, line length as well.

> +	if (!sig->thread_group_times)
> +		return(0);

return 0 is the proper form - please run your patch through 
scripts/checkpatch.pl.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752510AbYKMQAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbYKMQAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYKMQAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:00:31 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:39341 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYKMQA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:00:29 -0500
Subject: Re: [PATCH] revert: timers: fix itimer/many thread hang
From: Doug Chapman <doug.chapman@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frank Mayhar <fmayhar@google.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1225989102.7803.4749.camel@twins>
References: <1224694989.8431.23.camel@oberon>
	 <1225132746.14792.13.camel@bobble.smo.corp.google.com>
	 <1225219114.24204.37.camel@oberon>
	 <1225936715.27507.44.camel@bobble.smo.corp.google.com>
	 <1225969420.7803.4366.camel@twins>  <1225989102.7803.4749.camel@twins>
Content-Type: text/plain
Date: Thu, 13 Nov 2008 11:00:21 -0500
Message-Id: <1226592021.21297.25.camel@oberon>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter didn't mention here that the itimer/many thread patches cause a
race-condition panic which is easily reproduced (in fact unavoidable
with SLUB debugging on) on hyperthreaded ia64 systems (but certainly
possible on all systems).  Can we get this revert patch pulled in?  The
other attempts to fix this so far have been unsuccessful.  I have tested
with this revert patch and it does indeed fix that issue.

thanks,

- Doug

On Thu, 2008-11-06 at 17:31 +0100, Peter Zijlstra wrote:
> This patch reverts all the itimer/many thread patches:
> 
> 7086efe1c1536f6bc160e7d60a9bfd645b91f279
> bb34d92f643086d546b49cef680f6f305ed84414
> 5ce73a4a5a4893a1aa4cdeed1b1a5a6de42c43b6
> 0a8eaa4f9b58759595a1bfe13a1295fdc25ba026
> f06febc96ba8e0af80bcc3eaec0a109e88275fac
> 
> Because I think the per-cpu accounting approach is wrong and makes
> things worse for people with a machine that has more than a hand-full of
> CPUs.
> 
> Build and boot tested on my favourite x86_64 config.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 8fcfa39..e215906 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1341,15 +1341,20 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
>  	prstatus->pr_pgrp = task_pgrp_vnr(p);
>  	prstatus->pr_sid = task_session_vnr(p);
>  	if (thread_group_leader(p)) {
> -		struct task_cputime cputime;
> -
>  		/*
> -		 * This is the record for the group leader.  It shows the
> -		 * group-wide total, not its individual thread total.
> +		 * This is the record for the group leader.  Add in the
> +		 * cumulative times of previous dead threads.  This total
> +		 * won't include the time of each live thread whose state
> +		 * is included in the core dump.  The final total reported
> +		 * to our parent process when it calls wait4 will include
> +		 * those sums as well as the little bit more time it takes
> +		 * this and each other thread to finish dying after the
> +		 * core dump synchronization phase.
>  		 */
> -		thread_group_cputime(p, &cputime);
> -		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
> -		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
> +		cputime_to_timeval(cputime_add(p->utime, p->signal->utime),
> +				   &prstatus->pr_utime);
> +		cputime_to_timeval(cputime_add(p->stime, p->signal->stime),
> +				   &prstatus->pr_stime);
>  	} else {
>  		cputime_to_timeval(p->utime, &prstatus->pr_utime);
>  		cputime_to_timeval(p->stime, &prstatus->pr_stime);
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 6af7fba..efd68c5 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -388,20 +388,20 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>  
>  		/* add up live thread stats at the group level */
>  		if (whole) {
> -			struct task_cputime cputime;
>  			struct task_struct *t = task;
>  			do {
>  				min_flt += t->min_flt;
>  				maj_flt += t->maj_flt;
> +				utime = cputime_add(utime, task_utime(t));
> +				stime = cputime_add(stime, task_stime(t));
>  				gtime = cputime_add(gtime, task_gtime(t));
>  				t = next_thread(t);
>  			} while (t != task);
>  
>  			min_flt += sig->min_flt;
>  			maj_flt += sig->maj_flt;
> -			thread_group_cputime(task, &cputime);
> -			utime = cputime.utime;
> -			stime = cputime.stime;
> +			utime = cputime_add(utime, sig->utime);
> +			stime = cputime_add(stime, sig->stime);
>  			gtime = cputime_add(gtime, sig->gtime);
>  		}
>  
> diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
> index 4a145ca..89b6ecd 100644
> --- a/include/linux/kernel_stat.h
> +++ b/include/linux/kernel_stat.h
> @@ -66,7 +66,6 @@ static inline unsigned int kstat_irqs(unsigned int irq)
>  	return sum;
>  }
>  
> -extern unsigned long long task_delta_exec(struct task_struct *);
>  extern void account_user_time(struct task_struct *, cputime_t);
>  extern void account_user_time_scaled(struct task_struct *, cputime_t);
>  extern void account_system_time(struct task_struct *, int, cputime_t);
> diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
> index a7c7213..04c2e43 100644
> --- a/include/linux/posix-timers.h
> +++ b/include/linux/posix-timers.h
> @@ -113,6 +113,4 @@ void set_process_cpu_timer(struct task_struct *task, unsigned int clock_idx,
>  
>  long clock_nanosleep_restart(struct restart_block *restart_block);
>  
> -void update_rlimit_cpu(unsigned long rlim_new);
> -
>  #endif
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index dc07f9a..a739747 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -433,39 +433,6 @@ struct pacct_struct {
>  	unsigned long		ac_minflt, ac_majflt;
>  };
>  
> -/**
> - * struct task_cputime - collected CPU time counts
> - * @utime:		time spent in user mode, in &cputime_t units
> - * @stime:		time spent in kernel mode, in &cputime_t units
> - * @sum_exec_runtime:	total time spent on the CPU, in nanoseconds
> - *
> - * This structure groups together three kinds of CPU time that are
> - * tracked for threads and thread groups.  Most things considering
> - * CPU time want to group these counts together and treat all three
> - * of them in parallel.
> - */
> -struct task_cputime {
> -	cputime_t utime;
> -	cputime_t stime;
> -	unsigned long long sum_exec_runtime;
> -};
> -/* Alternate field names when used to cache expirations. */
> -#define prof_exp	stime
> -#define virt_exp	utime
> -#define sched_exp	sum_exec_runtime
> -
> -/**
> - * struct thread_group_cputime - thread group interval timer counts
> - * @totals:		thread group interval timers; substructure for
> - *			uniprocessor kernel, per-cpu for SMP kernel.
> - *
> - * This structure contains the version of task_cputime, above, that is
> - * used for thread group CPU clock calculations.
> - */
> -struct thread_group_cputime {
> -	struct task_cputime *totals;
> -};
> -
>  /*
>   * NOTE! "signal_struct" does not have it's own
>   * locking, because a shared signal_struct always
> @@ -511,17 +478,6 @@ struct signal_struct {
>  	cputime_t it_prof_expires, it_virt_expires;
>  	cputime_t it_prof_incr, it_virt_incr;
>  
> -	/*
> -	 * Thread group totals for process CPU clocks.
> -	 * See thread_group_cputime(), et al, for details.
> -	 */
> -	struct thread_group_cputime cputime;
> -
> -	/* Earliest-expiration cache. */
> -	struct task_cputime cputime_expires;
> -
> -	struct list_head cpu_timers[3];
> -
>  	/* job control IDs */
>  
>  	/*
> @@ -552,7 +508,7 @@ struct signal_struct {
>  	 * Live threads maintain their own counters and add to these
>  	 * in __exit_signal, except for the group leader.
>  	 */
> -	cputime_t cutime, cstime;
> +	cputime_t utime, stime, cutime, cstime;
>  	cputime_t gtime;
>  	cputime_t cgtime;
>  	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
> @@ -561,6 +517,14 @@ struct signal_struct {
>  	struct task_io_accounting ioac;
>  
>  	/*
> +	 * Cumulative ns of scheduled CPU time for dead threads in the
> +	 * group, not including a zombie group leader.  (This only differs
> +	 * from jiffies_to_ns(utime + stime) if sched_clock uses something
> +	 * other than jiffies.)
> +	 */
> +	unsigned long long sum_sched_runtime;
> +
> +	/*
>  	 * We don't bother to synchronize most readers of this at all,
>  	 * because there is no reader checking a limit that actually needs
>  	 * to get both rlim_cur and rlim_max atomically, and either one
> @@ -571,6 +535,8 @@ struct signal_struct {
>  	 */
>  	struct rlimit rlim[RLIM_NLIMITS];
>  
> +	struct list_head cpu_timers[3];
> +
>  	/* keep the process-shared keyrings here so that they do the right
>  	 * thing in threads created with CLONE_THREAD */
>  #ifdef CONFIG_KEYS
> @@ -1176,7 +1142,8 @@ struct task_struct {
>  /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
>  	unsigned long min_flt, maj_flt;
>  
> -	struct task_cputime cputime_expires;
> +  	cputime_t it_prof_expires, it_virt_expires;
> +	unsigned long long it_sched_expires;
>  	struct list_head cpu_timers[3];
>  
>  /* process credentials */
> @@ -1632,7 +1599,6 @@ extern unsigned long long cpu_clock(int cpu);
>  
>  extern unsigned long long
>  task_sched_runtime(struct task_struct *task);
> -extern unsigned long long thread_group_sched_runtime(struct task_struct *task);
>  
>  /* sched_exec is called by processes performing an exec */
>  #ifdef CONFIG_SMP
> @@ -2144,30 +2110,6 @@ static inline int spin_needbreak(spinlock_t *lock)
>  }
>  
>  /*
> - * Thread group CPU time accounting.
> - */
> -
> -extern int thread_group_cputime_alloc(struct task_struct *);
> -extern void thread_group_cputime(struct task_struct *, struct task_cputime *);
> -
> -static inline void thread_group_cputime_init(struct signal_struct *sig)
> -{
> -	sig->cputime.totals = NULL;
> -}
> -
> -static inline int thread_group_cputime_clone_thread(struct task_struct *curr)
> -{
> -	if (curr->signal->cputime.totals)
> -		return 0;
> -	return thread_group_cputime_alloc(curr);
> -}
> -
> -static inline void thread_group_cputime_free(struct signal_struct *sig)
> -{
> -	free_percpu(sig->cputime.totals);
> -}
> -
> -/*
>   * Reevaluate whether the task has signals pending delivery.
>   * Wake the task if so.
>   * This is required every time the blocked sigset_t changes.
> diff --git a/include/linux/time.h b/include/linux/time.h
> index ce321ac..d2c578d 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -132,9 +132,6 @@ extern int timekeeping_valid_for_hres(void);
>  extern void update_wall_time(void);
>  extern void update_xtime_cache(u64 nsec);
>  
> -struct tms;
> -extern void do_sys_times(struct tms *);
> -
>  /**
>   * timespec_to_ns - Convert timespec to nanoseconds
>   * @ts:		pointer to the timespec variable to be converted
> diff --git a/kernel/compat.c b/kernel/compat.c
> index 8eafe3e..143990e 100644
> --- a/kernel/compat.c
> +++ b/kernel/compat.c
> @@ -23,7 +23,6 @@
>  #include <linux/timex.h>
>  #include <linux/migrate.h>
>  #include <linux/posix-timers.h>
> -#include <linux/times.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -209,23 +208,49 @@ asmlinkage long compat_sys_setitimer(int which,
>  	return 0;
>  }
>  
> -static compat_clock_t clock_t_to_compat_clock_t(clock_t x)
> -{
> -	return compat_jiffies_to_clock_t(clock_t_to_jiffies(x));
> -}
> -
>  asmlinkage long compat_sys_times(struct compat_tms __user *tbuf)
>  {
> +	/*
> +	 *	In the SMP world we might just be unlucky and have one of
> +	 *	the times increment as we use it. Since the value is an
> +	 *	atomically safe type this is just fine. Conceptually its
> +	 *	as if the syscall took an instant longer to occur.
> +	 */
>  	if (tbuf) {
> -		struct tms tms;
>  		struct compat_tms tmp;
> -
> -		do_sys_times(&tms);
> -		/* Convert our struct tms to the compat version. */
> -		tmp.tms_utime = clock_t_to_compat_clock_t(tms.tms_utime);
> -		tmp.tms_stime = clock_t_to_compat_clock_t(tms.tms_stime);
> -		tmp.tms_cutime = clock_t_to_compat_clock_t(tms.tms_cutime);
> -		tmp.tms_cstime = clock_t_to_compat_clock_t(tms.tms_cstime);
> +		struct task_struct *tsk = current;
> +		struct task_struct *t;
> +		cputime_t utime, stime, cutime, cstime;
> +
> +		read_lock(&tasklist_lock);
> +		utime = tsk->signal->utime;
> +		stime = tsk->signal->stime;
> +		t = tsk;
> +		do {
> +			utime = cputime_add(utime, t->utime);
> +			stime = cputime_add(stime, t->stime);
> +			t = next_thread(t);
> +		} while (t != tsk);
> +
> +		/*
> +		 * While we have tasklist_lock read-locked, no dying thread
> +		 * can be updating current->signal->[us]time.  Instead,
> +		 * we got their counts included in the live thread loop.
> +		 * However, another thread can come in right now and
> +		 * do a wait call that updates current->signal->c[us]time.
> +		 * To make sure we always see that pair updated atomically,
> +		 * we take the siglock around fetching them.
> +		 */
> +		spin_lock_irq(&tsk->sighand->siglock);
> +		cutime = tsk->signal->cutime;
> +		cstime = tsk->signal->cstime;
> +		spin_unlock_irq(&tsk->sighand->siglock);
> +		read_unlock(&tasklist_lock);
> +
> +		tmp.tms_utime = compat_jiffies_to_clock_t(cputime_to_jiffies(utime));
> +		tmp.tms_stime = compat_jiffies_to_clock_t(cputime_to_jiffies(stime));
> +		tmp.tms_cutime = compat_jiffies_to_clock_t(cputime_to_jiffies(cutime));
> +		tmp.tms_cstime = compat_jiffies_to_clock_t(cputime_to_jiffies(cstime));
>  		if (copy_to_user(tbuf, &tmp, sizeof(tmp)))
>  			return -EFAULT;
>  	}
> diff --git a/kernel/exit.c b/kernel/exit.c
> index b361006..9d2f87b 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -113,6 +113,8 @@ static void __exit_signal(struct task_struct *tsk)
>  		 * We won't ever get here for the group leader, since it
>  		 * will have been the last reference on the signal_struct.
>  		 */
> +		sig->utime = cputime_add(sig->utime, task_utime(tsk));
> +		sig->stime = cputime_add(sig->stime, task_stime(tsk));
>  		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
>  		sig->min_flt += tsk->min_flt;
>  		sig->maj_flt += tsk->maj_flt;
> @@ -121,6 +123,7 @@ static void __exit_signal(struct task_struct *tsk)
>  		sig->inblock += task_io_get_inblock(tsk);
>  		sig->oublock += task_io_get_oublock(tsk);
>  		task_io_accounting_add(&sig->ioac, &tsk->ioac);
> +		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
>  		sig = NULL; /* Marker for below. */
>  	}
>  
> @@ -1301,7 +1304,6 @@ static int wait_task_zombie(struct task_struct *p, int options,
>  	if (likely(!traced)) {
>  		struct signal_struct *psig;
>  		struct signal_struct *sig;
> -		struct task_cputime cputime;
>  
>  		/*
>  		 * The resource counters for the group leader are in its
> @@ -1317,23 +1319,20 @@ static int wait_task_zombie(struct task_struct *p, int options,
>  		 * need to protect the access to p->parent->signal fields,
>  		 * as other threads in the parent group can be right
>  		 * here reaping other children at the same time.
> -		 *
> -		 * We use thread_group_cputime() to get times for the thread
> -		 * group, which consolidates times for all threads in the
> -		 * group including the group leader.
>  		 */
>  		spin_lock_irq(&p->parent->sighand->siglock);
>  		psig = p->parent->signal;
>  		sig = p->signal;
> -		thread_group_cputime(p, &cputime);
>  		psig->cutime =
>  			cputime_add(psig->cutime,
> -			cputime_add(cputime.utime,
> -				    sig->cutime));
> +			cputime_add(p->utime,
> +			cputime_add(sig->utime,
> +				    sig->cutime)));
>  		psig->cstime =
>  			cputime_add(psig->cstime,
> -			cputime_add(cputime.stime,
> -				    sig->cstime));
> +			cputime_add(p->stime,
> +			cputime_add(sig->stime,
> +				    sig->cstime)));
>  		psig->cgtime =
>  			cputime_add(psig->cgtime,
>  			cputime_add(p->gtime,
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 4b964d7..1e13d05 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -765,44 +765,15 @@ void __cleanup_sighand(struct sighand_struct *sighand)
>  		kmem_cache_free(sighand_cachep, sighand);
>  }
>  
> -
> -/*
> - * Initialize POSIX timer handling for a thread group.
> - */
> -static void posix_cpu_timers_init_group(struct signal_struct *sig)
> -{
> -	/* Thread group counters. */
> -	thread_group_cputime_init(sig);
> -
> -	/* Expiration times and increments. */
> -	sig->it_virt_expires = cputime_zero;
> -	sig->it_virt_incr = cputime_zero;
> -	sig->it_prof_expires = cputime_zero;
> -	sig->it_prof_incr = cputime_zero;
> -
> -	/* Cached expiration times. */
> -	sig->cputime_expires.prof_exp = cputime_zero;
> -	sig->cputime_expires.virt_exp = cputime_zero;
> -	sig->cputime_expires.sched_exp = 0;
> -
> -	/* The timer lists. */
> -	INIT_LIST_HEAD(&sig->cpu_timers[0]);
> -	INIT_LIST_HEAD(&sig->cpu_timers[1]);
> -	INIT_LIST_HEAD(&sig->cpu_timers[2]);
> -}
> -
>  static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  {
>  	struct signal_struct *sig;
>  	int ret;
>  
>  	if (clone_flags & CLONE_THREAD) {
> -		ret = thread_group_cputime_clone_thread(current);
> -		if (likely(!ret)) {
> -			atomic_inc(&current->signal->count);
> -			atomic_inc(&current->signal->live);
> -		}
> -		return ret;
> +		atomic_inc(&current->signal->count);
> +		atomic_inc(&current->signal->live);
> +		return 0;
>  	}
>  	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
>  	tsk->signal = sig;
> @@ -830,25 +801,39 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  	sig->it_real_incr.tv64 = 0;
>  	sig->real_timer.function = it_real_fn;
>  
> +	sig->it_virt_expires = cputime_zero;
> +	sig->it_virt_incr = cputime_zero;
> +	sig->it_prof_expires = cputime_zero;
> +	sig->it_prof_incr = cputime_zero;
> +
>  	sig->leader = 0;	/* session leadership doesn't inherit */
>  	sig->tty_old_pgrp = NULL;
>  	sig->tty = NULL;
>  
> -	sig->cutime = sig->cstime = cputime_zero;
> +	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
>  	sig->gtime = cputime_zero;
>  	sig->cgtime = cputime_zero;
>  	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
>  	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
>  	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
>  	task_io_accounting_init(&sig->ioac);
> +	INIT_LIST_HEAD(&sig->cpu_timers[0]);
> +	INIT_LIST_HEAD(&sig->cpu_timers[1]);
> +	INIT_LIST_HEAD(&sig->cpu_timers[2]);
>  	taskstats_tgid_init(sig);
>  
>  	task_lock(current->group_leader);
>  	memcpy(sig->rlim, current->signal->rlim, sizeof sig->rlim);
>  	task_unlock(current->group_leader);
>  
> -	posix_cpu_timers_init_group(sig);
> -
> +	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
> +		/*
> +		 * New sole thread in the process gets an expiry time
> +		 * of the whole CPU time limit.
> +		 */
> +		tsk->it_prof_expires =
> +			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
> +	}
>  	acct_init_pacct(&sig->pacct);
>  
>  	tty_audit_fork(sig);
> @@ -858,7 +843,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  
>  void __cleanup_signal(struct signal_struct *sig)
>  {
> -	thread_group_cputime_free(sig);
>  	exit_thread_group_keys(sig);
>  	tty_kref_put(sig->tty);
>  	kmem_cache_free(signal_cachep, sig);
> @@ -909,19 +893,6 @@ void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
>  #endif /* CONFIG_MM_OWNER */
>  
>  /*
> - * Initialize POSIX timer handling for a single task.
> - */
> -static void posix_cpu_timers_init(struct task_struct *tsk)
> -{
> -	tsk->cputime_expires.prof_exp = cputime_zero;
> -	tsk->cputime_expires.virt_exp = cputime_zero;
> -	tsk->cputime_expires.sched_exp = 0;
> -	INIT_LIST_HEAD(&tsk->cpu_timers[0]);
> -	INIT_LIST_HEAD(&tsk->cpu_timers[1]);
> -	INIT_LIST_HEAD(&tsk->cpu_timers[2]);
> -}
> -
> -/*
>   * This creates a new process as a copy of the old one,
>   * but does not actually start it yet.
>   *
> @@ -1033,7 +1004,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	task_io_accounting_init(&p->ioac);
>  	acct_clear_integrals(p);
>  
> -	posix_cpu_timers_init(p);
> +	p->it_virt_expires = cputime_zero;
> +	p->it_prof_expires = cputime_zero;
> +	p->it_sched_expires = 0;
> +	INIT_LIST_HEAD(&p->cpu_timers[0]);
> +	INIT_LIST_HEAD(&p->cpu_timers[1]);
> +	INIT_LIST_HEAD(&p->cpu_timers[2]);
>  
>  	p->lock_depth = -1;		/* -1 = no lock */
>  	do_posix_clock_monotonic_gettime(&p->start_time);
> @@ -1234,6 +1210,21 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	if (clone_flags & CLONE_THREAD) {
>  		p->group_leader = current->group_leader;
>  		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
> +
> +		if (!cputime_eq(current->signal->it_virt_expires,
> +				cputime_zero) ||
> +		    !cputime_eq(current->signal->it_prof_expires,
> +				cputime_zero) ||
> +		    current->signal->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY ||
> +		    !list_empty(&current->signal->cpu_timers[0]) ||
> +		    !list_empty(&current->signal->cpu_timers[1]) ||
> +		    !list_empty(&current->signal->cpu_timers[2])) {
> +			/*
> +			 * Have child wake up on its first tick to check
> +			 * for process CPU timers.
> +			 */
> +			p->it_prof_expires = jiffies_to_cputime(1);
> +		}
>  	}
>  
>  	if (likely(p->pid)) {
> diff --git a/kernel/itimer.c b/kernel/itimer.c
> index db7c358..ab98274 100644
> --- a/kernel/itimer.c
> +++ b/kernel/itimer.c
> @@ -55,15 +55,17 @@ int do_getitimer(int which, struct itimerval *value)
>  		spin_unlock_irq(&tsk->sighand->siglock);
>  		break;
>  	case ITIMER_VIRTUAL:
> +		read_lock(&tasklist_lock);
>  		spin_lock_irq(&tsk->sighand->siglock);
>  		cval = tsk->signal->it_virt_expires;
>  		cinterval = tsk->signal->it_virt_incr;
>  		if (!cputime_eq(cval, cputime_zero)) {
> -			struct task_cputime cputime;
> -			cputime_t utime;
> -
> -			thread_group_cputime(tsk, &cputime);
> -			utime = cputime.utime;
> +			struct task_struct *t = tsk;
> +			cputime_t utime = tsk->signal->utime;
> +			do {
> +				utime = cputime_add(utime, t->utime);
> +				t = next_thread(t);
> +			} while (t != tsk);
>  			if (cputime_le(cval, utime)) { /* about to fire */
>  				cval = jiffies_to_cputime(1);
>  			} else {
> @@ -71,19 +73,25 @@ int do_getitimer(int which, struct itimerval *value)
>  			}
>  		}
>  		spin_unlock_irq(&tsk->sighand->siglock);
> +		read_unlock(&tasklist_lock);
>  		cputime_to_timeval(cval, &value->it_value);
>  		cputime_to_timeval(cinterval, &value->it_interval);
>  		break;
>  	case ITIMER_PROF:
> +		read_lock(&tasklist_lock);
>  		spin_lock_irq(&tsk->sighand->siglock);
>  		cval = tsk->signal->it_prof_expires;
>  		cinterval = tsk->signal->it_prof_incr;
>  		if (!cputime_eq(cval, cputime_zero)) {
> -			struct task_cputime times;
> -			cputime_t ptime;
> -
> -			thread_group_cputime(tsk, &times);
> -			ptime = cputime_add(times.utime, times.stime);
> +			struct task_struct *t = tsk;
> +			cputime_t ptime = cputime_add(tsk->signal->utime,
> +						      tsk->signal->stime);
> +			do {
> +				ptime = cputime_add(ptime,
> +						    cputime_add(t->utime,
> +								t->stime));
> +				t = next_thread(t);
> +			} while (t != tsk);
>  			if (cputime_le(cval, ptime)) { /* about to fire */
>  				cval = jiffies_to_cputime(1);
>  			} else {
> @@ -91,6 +99,7 @@ int do_getitimer(int which, struct itimerval *value)
>  			}
>  		}
>  		spin_unlock_irq(&tsk->sighand->siglock);
> +		read_unlock(&tasklist_lock);
>  		cputime_to_timeval(cval, &value->it_value);
>  		cputime_to_timeval(cinterval, &value->it_interval);
>  		break;
> @@ -176,6 +185,7 @@ again:
>  	case ITIMER_VIRTUAL:
>  		nval = timeval_to_cputime(&value->it_value);
>  		ninterval = timeval_to_cputime(&value->it_interval);
> +		read_lock(&tasklist_lock);
>  		spin_lock_irq(&tsk->sighand->siglock);
>  		cval = tsk->signal->it_virt_expires;
>  		cinterval = tsk->signal->it_virt_incr;
> @@ -190,6 +200,7 @@ again:
>  		tsk->signal->it_virt_expires = nval;
>  		tsk->signal->it_virt_incr = ninterval;
>  		spin_unlock_irq(&tsk->sighand->siglock);
> +		read_unlock(&tasklist_lock);
>  		if (ovalue) {
>  			cputime_to_timeval(cval, &ovalue->it_value);
>  			cputime_to_timeval(cinterval, &ovalue->it_interval);
> @@ -198,6 +209,7 @@ again:
>  	case ITIMER_PROF:
>  		nval = timeval_to_cputime(&value->it_value);
>  		ninterval = timeval_to_cputime(&value->it_interval);
> +		read_lock(&tasklist_lock);
>  		spin_lock_irq(&tsk->sighand->siglock);
>  		cval = tsk->signal->it_prof_expires;
>  		cinterval = tsk->signal->it_prof_incr;
> @@ -212,6 +224,7 @@ again:
>  		tsk->signal->it_prof_expires = nval;
>  		tsk->signal->it_prof_incr = ninterval;
>  		spin_unlock_irq(&tsk->sighand->siglock);
> +		read_unlock(&tasklist_lock);
>  		if (ovalue) {
>  			cputime_to_timeval(cval, &ovalue->it_value);
>  			cputime_to_timeval(cinterval, &ovalue->it_interval);
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 153dcb2..c42a03a 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -7,93 +7,6 @@
>  #include <linux/errno.h>
>  #include <linux/math64.h>
>  #include <asm/uaccess.h>
> -#include <linux/kernel_stat.h>
> -
> -/*
> - * Allocate the thread_group_cputime structure appropriately and fill in the
> - * current values of the fields.  Called from copy_signal() via
> - * thread_group_cputime_clone_thread() when adding a second or subsequent
> - * thread to a thread group.  Assumes interrupts are enabled when called.
> - */
> -int thread_group_cputime_alloc(struct task_struct *tsk)
> -{
> -	struct signal_struct *sig = tsk->signal;
> -	struct task_cputime *cputime;
> -
> -	/*
> -	 * If we have multiple threads and we don't already have a
> -	 * per-CPU task_cputime struct (checked in the caller), allocate
> -	 * one and fill it in with the times accumulated so far.  We may
> -	 * race with another thread so recheck after we pick up the sighand
> -	 * lock.
> -	 */
> -	cputime = alloc_percpu(struct task_cputime);
> -	if (cputime == NULL)
> -		return -ENOMEM;
> -	spin_lock_irq(&tsk->sighand->siglock);
> -	if (sig->cputime.totals) {
> -		spin_unlock_irq(&tsk->sighand->siglock);
> -		free_percpu(cputime);
> -		return 0;
> -	}
> -	sig->cputime.totals = cputime;
> -	cputime = per_cpu_ptr(sig->cputime.totals, smp_processor_id());
> -	cputime->utime = tsk->utime;
> -	cputime->stime = tsk->stime;
> -	cputime->sum_exec_runtime = tsk->se.sum_exec_runtime;
> -	spin_unlock_irq(&tsk->sighand->siglock);
> -	return 0;
> -}
> -
> -/**
> - * thread_group_cputime - Sum the thread group time fields across all CPUs.
> - *
> - * @tsk:	The task we use to identify the thread group.
> - * @times:	task_cputime structure in which we return the summed fields.
> - *
> - * Walk the list of CPUs to sum the per-CPU time fields in the thread group
> - * time structure.
> - */
> -void thread_group_cputime(
> -	struct task_struct *tsk,
> -	struct task_cputime *times)
> -{
> -	struct signal_struct *sig;
> -	int i;
> -	struct task_cputime *tot;
> -
> -	sig = tsk->signal;
> -	if (unlikely(!sig) || !sig->cputime.totals) {
> -		times->utime = tsk->utime;
> -		times->stime = tsk->stime;
> -		times->sum_exec_runtime = tsk->se.sum_exec_runtime;
> -		return;
> -	}
> -	times->stime = times->utime = cputime_zero;
> -	times->sum_exec_runtime = 0;
> -	for_each_possible_cpu(i) {
> -		tot = per_cpu_ptr(tsk->signal->cputime.totals, i);
> -		times->utime = cputime_add(times->utime, tot->utime);
> -		times->stime = cputime_add(times->stime, tot->stime);
> -		times->sum_exec_runtime += tot->sum_exec_runtime;
> -	}
> -}
> -
> -/*
> - * Called after updating RLIMIT_CPU to set timer expiration if necessary.
> - */
> -void update_rlimit_cpu(unsigned long rlim_new)
> -{
> -	cputime_t cputime;
> -
> -	cputime = secs_to_cputime(rlim_new);
> -	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
> -	    cputime_lt(current->signal->it_prof_expires, cputime)) {
> -		spin_lock_irq(&current->sighand->siglock);
> -		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
> -		spin_unlock_irq(&current->sighand->siglock);
> -	}
> -}
>  
>  static int check_clock(const clockid_t which_clock)
>  {
> @@ -245,6 +158,10 @@ static inline cputime_t virt_ticks(struct task_struct *p)
>  {
>  	return p->utime;
>  }
> +static inline unsigned long long sched_ns(struct task_struct *p)
> +{
> +	return task_sched_runtime(p);
> +}
>  
>  int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
>  {
> @@ -294,7 +211,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
>  		cpu->cpu = virt_ticks(p);
>  		break;
>  	case CPUCLOCK_SCHED:
> -		cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
> +		cpu->sched = sched_ns(p);
>  		break;
>  	}
>  	return 0;
> @@ -303,30 +220,59 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
>  /*
>   * Sample a process (thread group) clock for the given group_leader task.
>   * Must be called with tasklist_lock held for reading.
> + * Must be called with tasklist_lock held for reading, and p->sighand->siglock.
>   */
> -static int cpu_clock_sample_group(const clockid_t which_clock,
> -				  struct task_struct *p,
> -				  union cpu_time_count *cpu)
> +static int cpu_clock_sample_group_locked(unsigned int clock_idx,
> +					 struct task_struct *p,
> +					 union cpu_time_count *cpu)
>  {
> -	struct task_cputime cputime;
> -
> -	thread_group_cputime(p, &cputime);
> -	switch (which_clock) {
> +	struct task_struct *t = p;
> + 	switch (clock_idx) {
>  	default:
>  		return -EINVAL;
>  	case CPUCLOCK_PROF:
> -		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
> +		cpu->cpu = cputime_add(p->signal->utime, p->signal->stime);
> +		do {
> +			cpu->cpu = cputime_add(cpu->cpu, prof_ticks(t));
> +			t = next_thread(t);
> +		} while (t != p);
>  		break;
>  	case CPUCLOCK_VIRT:
> -		cpu->cpu = cputime.utime;
> +		cpu->cpu = p->signal->utime;
> +		do {
> +			cpu->cpu = cputime_add(cpu->cpu, virt_ticks(t));
> +			t = next_thread(t);
> +		} while (t != p);
>  		break;
>  	case CPUCLOCK_SCHED:
> -		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
> +		cpu->sched = p->signal->sum_sched_runtime;
> +		/* Add in each other live thread.  */
> +		while ((t = next_thread(t)) != p) {
> +			cpu->sched += t->se.sum_exec_runtime;
> +		}
> +		cpu->sched += sched_ns(p);
>  		break;
>  	}
>  	return 0;
>  }
>  
> +/*
> + * Sample a process (thread group) clock for the given group_leader task.
> + * Must be called with tasklist_lock held for reading.
> + */
> +static int cpu_clock_sample_group(const clockid_t which_clock,
> +				  struct task_struct *p,
> +				  union cpu_time_count *cpu)
> +{
> +	int ret;
> +	unsigned long flags;
> +	spin_lock_irqsave(&p->sighand->siglock, flags);
> +	ret = cpu_clock_sample_group_locked(CPUCLOCK_WHICH(which_clock), p,
> +					    cpu);
> +	spin_unlock_irqrestore(&p->sighand->siglock, flags);
> +	return ret;
> +}
> +
>  
>  int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
>  {
> @@ -525,11 +471,80 @@ void posix_cpu_timers_exit(struct task_struct *tsk)
>  }
>  void posix_cpu_timers_exit_group(struct task_struct *tsk)
>  {
> -	struct task_cputime cputime;
> -
> -	thread_group_cputime(tsk, &cputime);
>  	cleanup_timers(tsk->signal->cpu_timers,
> -		       cputime.utime, cputime.stime, cputime.sum_exec_runtime);
> +		       cputime_add(tsk->utime, tsk->signal->utime),
> +		       cputime_add(tsk->stime, tsk->signal->stime),
> +		     tsk->se.sum_exec_runtime + tsk->signal->sum_sched_runtime);
> +}
> +
> +
> +/*
> + * Set the expiry times of all the threads in the process so one of them
> + * will go off before the process cumulative expiry total is reached.
> + */
> +static void process_timer_rebalance(struct task_struct *p,
> +				    unsigned int clock_idx,
> +				    union cpu_time_count expires,
> +				    union cpu_time_count val)
> +{
> +	cputime_t ticks, left;
> +	unsigned long long ns, nsleft;
> + 	struct task_struct *t = p;
> +	unsigned int nthreads = atomic_read(&p->signal->live);
> +
> +	if (!nthreads)
> +		return;
> +
> +	switch (clock_idx) {
> +	default:
> +		BUG();
> +		break;
> +	case CPUCLOCK_PROF:
> +		left = cputime_div_non_zero(cputime_sub(expires.cpu, val.cpu),
> +				       nthreads);
> +		do {
> +			if (likely(!(t->flags & PF_EXITING))) {
> +				ticks = cputime_add(prof_ticks(t), left);
> +				if (cputime_eq(t->it_prof_expires,
> +					       cputime_zero) ||
> +				    cputime_gt(t->it_prof_expires, ticks)) {
> +					t->it_prof_expires = ticks;
> +				}
> +			}
> +			t = next_thread(t);
> +		} while (t != p);
> +		break;
> +	case CPUCLOCK_VIRT:
> +		left = cputime_div_non_zero(cputime_sub(expires.cpu, val.cpu),
> +				       nthreads);
> +		do {
> +			if (likely(!(t->flags & PF_EXITING))) {
> +				ticks = cputime_add(virt_ticks(t), left);
> +				if (cputime_eq(t->it_virt_expires,
> +					       cputime_zero) ||
> +				    cputime_gt(t->it_virt_expires, ticks)) {
> +					t->it_virt_expires = ticks;
> +				}
> +			}
> +			t = next_thread(t);
> +		} while (t != p);
> +		break;
> +	case CPUCLOCK_SCHED:
> +		nsleft = expires.sched - val.sched;
> +		do_div(nsleft, nthreads);
> +		nsleft = max_t(unsigned long long, nsleft, 1);
> +		do {
> +			if (likely(!(t->flags & PF_EXITING))) {
> +				ns = t->se.sum_exec_runtime + nsleft;
> +				if (t->it_sched_expires == 0 ||
> +				    t->it_sched_expires > ns) {
> +					t->it_sched_expires = ns;
> +				}
> +			}
> +			t = next_thread(t);
> +		} while (t != p);
> +		break;
> +	}
>  }
>  
>  static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
> @@ -593,32 +608,29 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
>  			default:
>  				BUG();
>  			case CPUCLOCK_PROF:
> -				if (cputime_eq(p->cputime_expires.prof_exp,
> +				if (cputime_eq(p->it_prof_expires,
>  					       cputime_zero) ||
> -				    cputime_gt(p->cputime_expires.prof_exp,
> +				    cputime_gt(p->it_prof_expires,
>  					       nt->expires.cpu))
> -					p->cputime_expires.prof_exp =
> -						nt->expires.cpu;
> +					p->it_prof_expires = nt->expires.cpu;
>  				break;
>  			case CPUCLOCK_VIRT:
> -				if (cputime_eq(p->cputime_expires.virt_exp,
> +				if (cputime_eq(p->it_virt_expires,
>  					       cputime_zero) ||
> -				    cputime_gt(p->cputime_expires.virt_exp,
> +				    cputime_gt(p->it_virt_expires,
>  					       nt->expires.cpu))
> -					p->cputime_expires.virt_exp =
> -						nt->expires.cpu;
> +					p->it_virt_expires = nt->expires.cpu;
>  				break;
>  			case CPUCLOCK_SCHED:
> -				if (p->cputime_expires.sched_exp == 0 ||
> -				    p->cputime_expires.sched_exp >
> -							nt->expires.sched)
> -					p->cputime_expires.sched_exp =
> -						nt->expires.sched;
> +				if (p->it_sched_expires == 0 ||
> +				    p->it_sched_expires > nt->expires.sched)
> +					p->it_sched_expires = nt->expires.sched;
>  				break;
>  			}
>  		} else {
>  			/*
> -			 * For a process timer, set the cached expiration time.
> +			 * For a process timer, we must balance
> +			 * all the live threads' expirations.
>  			 */
>  			switch (CPUCLOCK_WHICH(timer->it_clock)) {
>  			default:
> @@ -629,9 +641,7 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
>  				    cputime_lt(p->signal->it_virt_expires,
>  					       timer->it.cpu.expires.cpu))
>  					break;
> -				p->signal->cputime_expires.virt_exp =
> -					timer->it.cpu.expires.cpu;
> -				break;
> +				goto rebalance;
>  			case CPUCLOCK_PROF:
>  				if (!cputime_eq(p->signal->it_prof_expires,
>  						cputime_zero) &&
> @@ -642,12 +652,13 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
>  				if (i != RLIM_INFINITY &&
>  				    i <= cputime_to_secs(timer->it.cpu.expires.cpu))
>  					break;
> -				p->signal->cputime_expires.prof_exp =
> -					timer->it.cpu.expires.cpu;
> -				break;
> +				goto rebalance;
>  			case CPUCLOCK_SCHED:
> -				p->signal->cputime_expires.sched_exp =
> -					timer->it.cpu.expires.sched;
> +			rebalance:
> +				process_timer_rebalance(
> +					timer->it.cpu.task,
> +					CPUCLOCK_WHICH(timer->it_clock),
> +					timer->it.cpu.expires, now);
>  				break;
>  			}
>  		}
> @@ -958,13 +969,13 @@ static void check_thread_timers(struct task_struct *tsk,
>  	struct signal_struct *const sig = tsk->signal;
>  
>  	maxfire = 20;
> -	tsk->cputime_expires.prof_exp = cputime_zero;
> +	tsk->it_prof_expires = cputime_zero;
>  	while (!list_empty(timers)) {
>  		struct cpu_timer_list *t = list_first_entry(timers,
>  						      struct cpu_timer_list,
>  						      entry);
>  		if (!--maxfire || cputime_lt(prof_ticks(tsk), t->expires.cpu)) {
> -			tsk->cputime_expires.prof_exp = t->expires.cpu;
> +			tsk->it_prof_expires = t->expires.cpu;
>  			break;
>  		}
>  		t->firing = 1;
> @@ -973,13 +984,13 @@ static void check_thread_timers(struct task_struct *tsk,
>  
>  	++timers;
>  	maxfire = 20;
> -	tsk->cputime_expires.virt_exp = cputime_zero;
> +	tsk->it_virt_expires = cputime_zero;
>  	while (!list_empty(timers)) {
>  		struct cpu_timer_list *t = list_first_entry(timers,
>  						      struct cpu_timer_list,
>  						      entry);
>  		if (!--maxfire || cputime_lt(virt_ticks(tsk), t->expires.cpu)) {
> -			tsk->cputime_expires.virt_exp = t->expires.cpu;
> +			tsk->it_virt_expires = t->expires.cpu;
>  			break;
>  		}
>  		t->firing = 1;
> @@ -988,13 +999,13 @@ static void check_thread_timers(struct task_struct *tsk,
>  
>  	++timers;
>  	maxfire = 20;
> -	tsk->cputime_expires.sched_exp = 0;
> +	tsk->it_sched_expires = 0;
>  	while (!list_empty(timers)) {
>  		struct cpu_timer_list *t = list_first_entry(timers,
>  						      struct cpu_timer_list,
>  						      entry);
>  		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires.sched) {
> -			tsk->cputime_expires.sched_exp = t->expires.sched;
> +			tsk->it_sched_expires = t->expires.sched;
>  			break;
>  		}
>  		t->firing = 1;
> @@ -1044,10 +1055,10 @@ static void check_process_timers(struct task_struct *tsk,
>  {
>  	int maxfire;
>  	struct signal_struct *const sig = tsk->signal;
> -	cputime_t utime, ptime, virt_expires, prof_expires;
> +	cputime_t utime, stime, ptime, virt_expires, prof_expires;
>  	unsigned long long sum_sched_runtime, sched_expires;
> +	struct task_struct *t;
>  	struct list_head *timers = sig->cpu_timers;
> -	struct task_cputime cputime;
>  
>  	/*
>  	 * Don't sample the current process CPU clocks if there are no timers.
> @@ -1063,10 +1074,18 @@ static void check_process_timers(struct task_struct *tsk,
>  	/*
>  	 * Collect the current process totals.
>  	 */
> -	thread_group_cputime(tsk, &cputime);
> -	utime = cputime.utime;
> -	ptime = cputime_add(utime, cputime.stime);
> -	sum_sched_runtime = cputime.sum_exec_runtime;
> +	utime = sig->utime;
> +	stime = sig->stime;
> +	sum_sched_runtime = sig->sum_sched_runtime;
> +	t = tsk;
> +	do {
> +		utime = cputime_add(utime, t->utime);
> +		stime = cputime_add(stime, t->stime);
> +		sum_sched_runtime += t->se.sum_exec_runtime;
> +		t = next_thread(t);
> +	} while (t != tsk);
> +	ptime = cputime_add(utime, stime);
> +
>  	maxfire = 20;
>  	prof_expires = cputime_zero;
>  	while (!list_empty(timers)) {
> @@ -1174,18 +1193,60 @@ static void check_process_timers(struct task_struct *tsk,
>  		}
>  	}
>  
> -	if (!cputime_eq(prof_expires, cputime_zero) &&
> -	    (cputime_eq(sig->cputime_expires.prof_exp, cputime_zero) ||
> -	     cputime_gt(sig->cputime_expires.prof_exp, prof_expires)))
> -		sig->cputime_expires.prof_exp = prof_expires;
> -	if (!cputime_eq(virt_expires, cputime_zero) &&
> -	    (cputime_eq(sig->cputime_expires.virt_exp, cputime_zero) ||
> -	     cputime_gt(sig->cputime_expires.virt_exp, virt_expires)))
> -		sig->cputime_expires.virt_exp = virt_expires;
> -	if (sched_expires != 0 &&
> -	    (sig->cputime_expires.sched_exp == 0 ||
> -	     sig->cputime_expires.sched_exp > sched_expires))
> -		sig->cputime_expires.sched_exp = sched_expires;
> +	if (!cputime_eq(prof_expires, cputime_zero) ||
> +	    !cputime_eq(virt_expires, cputime_zero) ||
> +	    sched_expires != 0) {
> +		/*
> +		 * Rebalance the threads' expiry times for the remaining
> +		 * process CPU timers.
> +		 */
> +
> +		cputime_t prof_left, virt_left, ticks;
> +		unsigned long long sched_left, sched;
> +		const unsigned int nthreads = atomic_read(&sig->live);
> +
> +		if (!nthreads)
> +			return;
> +
> +		prof_left = cputime_sub(prof_expires, utime);
> +		prof_left = cputime_sub(prof_left, stime);
> +		prof_left = cputime_div_non_zero(prof_left, nthreads);
> +		virt_left = cputime_sub(virt_expires, utime);
> +		virt_left = cputime_div_non_zero(virt_left, nthreads);
> +		if (sched_expires) {
> +			sched_left = sched_expires - sum_sched_runtime;
> +			do_div(sched_left, nthreads);
> +			sched_left = max_t(unsigned long long, sched_left, 1);
> +		} else {
> +			sched_left = 0;
> +		}
> +		t = tsk;
> +		do {
> +			if (unlikely(t->flags & PF_EXITING))
> +				continue;
> +
> +			ticks = cputime_add(cputime_add(t->utime, t->stime),
> +					    prof_left);
> +			if (!cputime_eq(prof_expires, cputime_zero) &&
> +			    (cputime_eq(t->it_prof_expires, cputime_zero) ||
> +			     cputime_gt(t->it_prof_expires, ticks))) {
> +				t->it_prof_expires = ticks;
> +			}
> +
> +			ticks = cputime_add(t->utime, virt_left);
> +			if (!cputime_eq(virt_expires, cputime_zero) &&
> +			    (cputime_eq(t->it_virt_expires, cputime_zero) ||
> +			     cputime_gt(t->it_virt_expires, ticks))) {
> +				t->it_virt_expires = ticks;
> +			}
> +
> +			sched = t->se.sum_exec_runtime + sched_left;
> +			if (sched_expires && (t->it_sched_expires == 0 ||
> +					      t->it_sched_expires > sched)) {
> +				t->it_sched_expires = sched;
> +			}
> +		} while ((t = next_thread(t)) != tsk);
> +	}
>  }
>  
>  /*
> @@ -1253,86 +1314,6 @@ out:
>  	++timer->it_requeue_pending;
>  }
>  
> -/**
> - * task_cputime_zero - Check a task_cputime struct for all zero fields.
> - *
> - * @cputime:	The struct to compare.
> - *
> - * Checks @cputime to see if all fields are zero.  Returns true if all fields
> - * are zero, false if any field is nonzero.
> - */
> -static inline int task_cputime_zero(const struct task_cputime *cputime)
> -{
> -	if (cputime_eq(cputime->utime, cputime_zero) &&
> -	    cputime_eq(cputime->stime, cputime_zero) &&
> -	    cputime->sum_exec_runtime == 0)
> -		return 1;
> -	return 0;
> -}
> -
> -/**
> - * task_cputime_expired - Compare two task_cputime entities.
> - *
> - * @sample:	The task_cputime structure to be checked for expiration.
> - * @expires:	Expiration times, against which @sample will be checked.
> - *
> - * Checks @sample against @expires to see if any field of @sample has expired.
> - * Returns true if any field of the former is greater than the corresponding
> - * field of the latter if the latter field is set.  Otherwise returns false.
> - */
> -static inline int task_cputime_expired(const struct task_cputime *sample,
> -					const struct task_cputime *expires)
> -{
> -	if (!cputime_eq(expires->utime, cputime_zero) &&
> -	    cputime_ge(sample->utime, expires->utime))
> -		return 1;
> -	if (!cputime_eq(expires->stime, cputime_zero) &&
> -	    cputime_ge(cputime_add(sample->utime, sample->stime),
> -		       expires->stime))
> -		return 1;
> -	if (expires->sum_exec_runtime != 0 &&
> -	    sample->sum_exec_runtime >= expires->sum_exec_runtime)
> -		return 1;
> -	return 0;
> -}
> -
> -/**
> - * fastpath_timer_check - POSIX CPU timers fast path.
> - *
> - * @tsk:	The task (thread) being checked.
> - *
> - * Check the task and thread group timers.  If both are zero (there are no
> - * timers set) return false.  Otherwise snapshot the task and thread group
> - * timers and compare them with the corresponding expiration times.  Return
> - * true if a timer has expired, else return false.
> - */
> -static inline int fastpath_timer_check(struct task_struct *tsk)
> -{
> -	struct signal_struct *sig = tsk->signal;
> -
> -	if (unlikely(!sig))
> -		return 0;
> -
> -	if (!task_cputime_zero(&tsk->cputime_expires)) {
> -		struct task_cputime task_sample = {
> -			.utime = tsk->utime,
> -			.stime = tsk->stime,
> -			.sum_exec_runtime = tsk->se.sum_exec_runtime
> -		};
> -
> -		if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
> -			return 1;
> -	}
> -	if (!task_cputime_zero(&sig->cputime_expires)) {
> -		struct task_cputime group_sample;
> -
> -		thread_group_cputime(tsk, &group_sample);
> -		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
> -			return 1;
> -	}
> -	return 0;
> -}
> -
>  /*
>   * This is called from the timer interrupt handler.  The irq handler has
>   * already updated our counts.  We need to check if any timers fire now.
> @@ -1345,31 +1326,42 @@ void run_posix_cpu_timers(struct task_struct *tsk)
>  
>  	BUG_ON(!irqs_disabled());
>  
> -	/*
> -	 * The fast path checks that there are no expired thread or thread
> -	 * group timers.  If that's so, just return.
> -	 */
> -	if (!fastpath_timer_check(tsk))
> +#define UNEXPIRED(clock) \
> +		(cputime_eq(tsk->it_##clock##_expires, cputime_zero) || \
> +		 cputime_lt(clock##_ticks(tsk), tsk->it_##clock##_expires))
> +
> +	if (UNEXPIRED(prof) && UNEXPIRED(virt) &&
> +	    (tsk->it_sched_expires == 0 ||
> +	     tsk->se.sum_exec_runtime < tsk->it_sched_expires))
>  		return;
>  
> -	spin_lock(&tsk->sighand->siglock);
> -	/*
> -	 * Here we take off tsk->signal->cpu_timers[N] and
> -	 * tsk->cpu_timers[N] all the timers that are firing, and
> -	 * put them on the firing list.
> -	 */
> -	check_thread_timers(tsk, &firing);
> -	check_process_timers(tsk, &firing);
> +#undef	UNEXPIRED
>  
>  	/*
> -	 * We must release these locks before taking any timer's lock.
> -	 * There is a potential race with timer deletion here, as the
> -	 * siglock now protects our private firing list.  We have set
> -	 * the firing flag in each timer, so that a deletion attempt
> -	 * that gets the timer lock before we do will give it up and
> -	 * spin until we've taken care of that timer below.
> +	 * Double-check with locks held.
>  	 */
> -	spin_unlock(&tsk->sighand->siglock);
> +	read_lock(&tasklist_lock);
> +	if (likely(tsk->signal != NULL)) {
> +		spin_lock(&tsk->sighand->siglock);
> +
> +		/*
> +		 * Here we take off tsk->cpu_timers[N] and tsk->signal->cpu_timers[N]
> +		 * all the timers that are firing, and put them on the firing list.
> +		 */
> +		check_thread_timers(tsk, &firing);
> +		check_process_timers(tsk, &firing);
> +
> +		/*
> +		 * We must release these locks before taking any timer's lock.
> +		 * There is a potential race with timer deletion here, as the
> +		 * siglock now protects our private firing list.  We have set
> +		 * the firing flag in each timer, so that a deletion attempt
> +		 * that gets the timer lock before we do will give it up and
> +		 * spin until we've taken care of that timer below.
> +		 */
> +		spin_unlock(&tsk->sighand->siglock);
> +	}
> +	read_unlock(&tasklist_lock);
>  
>  	/*
>  	 * Now that all the timers on our list have the firing flag,
> @@ -1397,9 +1389,10 @@ void run_posix_cpu_timers(struct task_struct *tsk)
>  
>  /*
>   * Set one of the process-wide special case CPU timers.
> - * The tsk->sighand->siglock must be held by the caller.
> - * The *newval argument is relative and we update it to be absolute, *oldval
> - * is absolute and we update it to be relative.
> + * The tasklist_lock and tsk->sighand->siglock must be held by the caller.
> + * The oldval argument is null for the RLIMIT_CPU timer, where *newval is
> + * absolute; non-null for ITIMER_*, where *newval is relative and we update
> + * it to be absolute, *oldval is absolute and we update it to be relative.
>   */
>  void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
>  			   cputime_t *newval, cputime_t *oldval)
> @@ -1408,7 +1401,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
>  	struct list_head *head;
>  
>  	BUG_ON(clock_idx == CPUCLOCK_SCHED);
> -	cpu_clock_sample_group(clock_idx, tsk, &now);
> +	cpu_clock_sample_group_locked(clock_idx, tsk, &now);
>  
>  	if (oldval) {
>  		if (!cputime_eq(*oldval, cputime_zero)) {
> @@ -1442,14 +1435,13 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
>  	    cputime_ge(list_first_entry(head,
>  				  struct cpu_timer_list, entry)->expires.cpu,
>  		       *newval)) {
> -		switch (clock_idx) {
> -		case CPUCLOCK_PROF:
> -			tsk->signal->cputime_expires.prof_exp = *newval;
> -			break;
> -		case CPUCLOCK_VIRT:
> -			tsk->signal->cputime_expires.virt_exp = *newval;
> -			break;
> -		}
> +		/*
> +		 * Rejigger each thread's expiry time so that one will
> +		 * notice before we hit the process-cumulative expiry time.
> +		 */
> +		union cpu_time_count expires = { .sched = 0 };
> +		expires.cpu = *newval;
> +		process_timer_rebalance(tsk, clock_idx, expires, now);
>  	}
>  }
>  
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9d50bd4..70f98c4 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4033,26 +4033,23 @@ DEFINE_PER_CPU(struct kernel_stat, kstat);
>  EXPORT_PER_CPU_SYMBOL(kstat);
>  
>  /*
> - * Return any ns on the sched_clock that have not yet been banked in
> - * @p in case that task is currently running.
> + * Return p->sum_exec_runtime plus any more ns on the sched_clock
> + * that have not yet been banked in case the task is currently running.
>   */
> -unsigned long long task_delta_exec(struct task_struct *p)
> +unsigned long long task_sched_runtime(struct task_struct *p)
>  {
>  	unsigned long flags;
> +	u64 ns, delta_exec;
>  	struct rq *rq;
> -	u64 ns = 0;
>  
>  	rq = task_rq_lock(p, &flags);
> -
> +	ns = p->se.sum_exec_runtime;
>  	if (task_current(rq, p)) {
> -		u64 delta_exec;
> -
>  		update_rq_clock(rq);
>  		delta_exec = rq->clock - p->se.exec_start;
>  		if ((s64)delta_exec > 0)
> -			ns = delta_exec;
> +			ns += delta_exec;
>  	}
> -
>  	task_rq_unlock(rq, &flags);
>  
>  	return ns;
> @@ -4069,7 +4066,6 @@ void account_user_time(struct task_struct *p, cputime_t cputime)
>  	cputime64_t tmp;
>  
>  	p->utime = cputime_add(p->utime, cputime);
> -	account_group_user_time(p, cputime);
>  
>  	/* Add user time to cpustat. */
>  	tmp = cputime_to_cputime64(cputime);
> @@ -4094,7 +4090,6 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime)
>  	tmp = cputime_to_cputime64(cputime);
>  
>  	p->utime = cputime_add(p->utime, cputime);
> -	account_group_user_time(p, cputime);
>  	p->gtime = cputime_add(p->gtime, cputime);
>  
>  	cpustat->user = cputime64_add(cpustat->user, tmp);
> @@ -4130,7 +4125,6 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
>  	}
>  
>  	p->stime = cputime_add(p->stime, cputime);
> -	account_group_system_time(p, cputime);
>  
>  	/* Add system time to cpustat. */
>  	tmp = cputime_to_cputime64(cputime);
> @@ -4172,7 +4166,6 @@ void account_steal_time(struct task_struct *p, cputime_t steal)
>  
>  	if (p == rq->idle) {
>  		p->stime = cputime_add(p->stime, steal);
> -		account_group_system_time(p, steal);
>  		if (atomic_read(&rq->nr_iowait) > 0)
>  			cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
>  		else
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 51aa3e1..5781abb 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -500,7 +500,6 @@ static void update_curr(struct cfs_rq *cfs_rq)
>  		struct task_struct *curtask = task_of(curr);
>  
>  		cpuacct_charge(curtask, delta_exec);
> -		account_group_exec_runtime(curtask, delta_exec);
>  	}
>  }
>  
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index c7963d5..98b1a19 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -526,8 +526,6 @@ static void update_curr_rt(struct rq *rq)
>  	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
>  
>  	curr->se.sum_exec_runtime += delta_exec;
> -	account_group_exec_runtime(curr, delta_exec);
> -
>  	curr->se.exec_start = rq->clock;
>  	cpuacct_charge(curr, delta_exec);
>  
> @@ -1460,7 +1458,7 @@ static void watchdog(struct rq *rq, struct task_struct *p)
>  		p->rt.timeout++;
>  		next = DIV_ROUND_UP(min(soft, hard), USEC_PER_SEC/HZ);
>  		if (p->rt.timeout > next)
> -			p->cputime_expires.sched_exp = p->se.sum_exec_runtime;
> +			p->it_sched_expires = p->se.sum_exec_runtime;
>  	}
>  }
>  
> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> index ee71bec..a93ef66 100644
> --- a/kernel/sched_stats.h
> +++ b/kernel/sched_stats.h
> @@ -277,89 +277,3 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
>  #define sched_info_switch(t, next)		do { } while (0)
>  #endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
>  
> -/*
> - * The following are functions that support scheduler-internal time accounting.
> - * These functions are generally called at the timer tick.  None of this depends
> - * on CONFIG_SCHEDSTATS.
> - */
> -
> -/**
> - * account_group_user_time - Maintain utime for a thread group.
> - *
> - * @tsk:	Pointer to task structure.
> - * @cputime:	Time value by which to increment the utime field of the
> - *		thread_group_cputime structure.
> - *
> - * If thread group time is being maintained, get the structure for the
> - * running CPU and update the utime field there.
> - */
> -static inline void account_group_user_time(struct task_struct *tsk,
> -					   cputime_t cputime)
> -{
> -	struct signal_struct *sig;
> -
> -	sig = tsk->signal;
> -	if (unlikely(!sig))
> -		return;
> -	if (sig->cputime.totals) {
> -		struct task_cputime *times;
> -
> -		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
> -		times->utime = cputime_add(times->utime, cputime);
> -		put_cpu_no_resched();
> -	}
> -}
> -
> -/**
> - * account_group_system_time - Maintain stime for a thread group.
> - *
> - * @tsk:	Pointer to task structure.
> - * @cputime:	Time value by which to increment the stime field of the
> - *		thread_group_cputime structure.
> - *
> - * If thread group time is being maintained, get the structure for the
> - * running CPU and update the stime field there.
> - */
> -static inline void account_group_system_time(struct task_struct *tsk,
> -					     cputime_t cputime)
> -{
> -	struct signal_struct *sig;
> -
> -	sig = tsk->signal;
> -	if (unlikely(!sig))
> -		return;
> -	if (sig->cputime.totals) {
> -		struct task_cputime *times;
> -
> -		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
> -		times->stime = cputime_add(times->stime, cputime);
> -		put_cpu_no_resched();
> -	}
> -}
> -
> -/**
> - * account_group_exec_runtime - Maintain exec runtime for a thread group.
> - *
> - * @tsk:	Pointer to task structure.
> - * @ns:		Time value by which to increment the sum_exec_runtime field
> - *		of the thread_group_cputime structure.
> - *
> - * If thread group time is being maintained, get the structure for the
> - * running CPU and update the sum_exec_runtime field there.
> - */
> -static inline void account_group_exec_runtime(struct task_struct *tsk,
> -					      unsigned long long ns)
> -{
> -	struct signal_struct *sig;
> -
> -	sig = tsk->signal;
> -	if (unlikely(!sig))
> -		return;
> -	if (sig->cputime.totals) {
> -		struct task_cputime *times;
> -
> -		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
> -		times->sum_exec_runtime += ns;
> -		put_cpu_no_resched();
> -	}
> -}
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 4530fc6..37ce260 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1342,7 +1342,6 @@ int do_notify_parent(struct task_struct *tsk, int sig)
>  	struct siginfo info;
>  	unsigned long flags;
>  	struct sighand_struct *psig;
> -	struct task_cputime cputime;
>  	int ret = sig;
>  
>  	BUG_ON(sig == -1);
> @@ -1373,9 +1372,10 @@ int do_notify_parent(struct task_struct *tsk, int sig)
>  
>  	info.si_uid = tsk->uid;
>  
> -	thread_group_cputime(tsk, &cputime);
> -	info.si_utime = cputime_to_jiffies(cputime.utime);
> -	info.si_stime = cputime_to_jiffies(cputime.stime);
> +	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
> +						       tsk->signal->utime));
> +	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
> +						       tsk->signal->stime));
>  
>  	info.si_status = tsk->exit_code & 0x7f;
>  	if (tsk->exit_code & 0x80)
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 31deba8..fc71f99 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -853,28 +853,38 @@ asmlinkage long sys_setfsgid(gid_t gid)
>  	return old_fsgid;
>  }
>  
> -void do_sys_times(struct tms *tms)
> -{
> -	struct task_cputime cputime;
> -	cputime_t cutime, cstime;
> -
> -	spin_lock_irq(&current->sighand->siglock);
> -	thread_group_cputime(current, &cputime);
> -	cutime = current->signal->cutime;
> -	cstime = current->signal->cstime;
> -	spin_unlock_irq(&current->sighand->siglock);
> -	tms->tms_utime = cputime_to_clock_t(cputime.utime);
> -	tms->tms_stime = cputime_to_clock_t(cputime.stime);
> -	tms->tms_cutime = cputime_to_clock_t(cutime);
> -	tms->tms_cstime = cputime_to_clock_t(cstime);
> -}
> -
>  asmlinkage long sys_times(struct tms __user * tbuf)
>  {
> +	/*
> +	 *	In the SMP world we might just be unlucky and have one of
> +	 *	the times increment as we use it. Since the value is an
> +	 *	atomically safe type this is just fine. Conceptually its
> +	 *	as if the syscall took an instant longer to occur.
> +	 */
>  	if (tbuf) {
>  		struct tms tmp;
> -
> -		do_sys_times(&tmp);
> +		struct task_struct *tsk = current;
> +		struct task_struct *t;
> +		cputime_t utime, stime, cutime, cstime;
> +
> +		spin_lock_irq(&tsk->sighand->siglock);
> +		utime = tsk->signal->utime;
> +		stime = tsk->signal->stime;
> +		t = tsk;
> +		do {
> +			utime = cputime_add(utime, t->utime);
> +			stime = cputime_add(stime, t->stime);
> +			t = next_thread(t);
> +		} while (t != tsk);
> +
> +		cutime = tsk->signal->cutime;
> +		cstime = tsk->signal->cstime;
> +		spin_unlock_irq(&tsk->sighand->siglock);
> +
> +		tmp.tms_utime = cputime_to_clock_t(utime);
> +		tmp.tms_stime = cputime_to_clock_t(stime);
> +		tmp.tms_cutime = cputime_to_clock_t(cutime);
> +		tmp.tms_cstime = cputime_to_clock_t(cstime);
>  		if (copy_to_user(tbuf, &tmp, sizeof(struct tms)))
>  			return -EFAULT;
>  	}
> @@ -1439,6 +1449,7 @@ asmlinkage long sys_old_getrlimit(unsigned int resource, struct rlimit __user *r
>  asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
>  {
>  	struct rlimit new_rlim, *old_rlim;
> +	unsigned long it_prof_secs;
>  	int retval;
>  
>  	if (resource >= RLIM_NLIMITS)
> @@ -1492,7 +1503,18 @@ asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
>  	if (new_rlim.rlim_cur == RLIM_INFINITY)
>  		goto out;
>  
> -	update_rlimit_cpu(new_rlim.rlim_cur);
> +	it_prof_secs = cputime_to_secs(current->signal->it_prof_expires);
> +	if (it_prof_secs == 0 || new_rlim.rlim_cur <= it_prof_secs) {
> +		unsigned long rlim_cur = new_rlim.rlim_cur;
> +		cputime_t cputime;
> +
> +		cputime = secs_to_cputime(rlim_cur);
> +		read_lock(&tasklist_lock);
> +		spin_lock_irq(&current->sighand->siglock);
> +		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
> +		spin_unlock_irq(&current->sighand->siglock);
> +		read_unlock(&tasklist_lock);
> +	}
>  out:
>  	return 0;
>  }
> @@ -1530,8 +1552,11 @@ out:
>   *
>   */
>  
> -static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r)
> +static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r,
> +				     cputime_t *utimep, cputime_t *stimep)
>  {
> +	*utimep = cputime_add(*utimep, t->utime);
> +	*stimep = cputime_add(*stimep, t->stime);
>  	r->ru_nvcsw += t->nvcsw;
>  	r->ru_nivcsw += t->nivcsw;
>  	r->ru_minflt += t->min_flt;
> @@ -1545,13 +1570,12 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
>  	struct task_struct *t;
>  	unsigned long flags;
>  	cputime_t utime, stime;
> -	struct task_cputime cputime;
>  
>  	memset((char *) r, 0, sizeof *r);
>  	utime = stime = cputime_zero;
>  
>  	if (who == RUSAGE_THREAD) {
> -		accumulate_thread_rusage(p, r);
> +		accumulate_thread_rusage(p, r, &utime, &stime);
>  		goto out;
>  	}
>  
> @@ -1574,9 +1598,8 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
>  				break;
>  
>  		case RUSAGE_SELF:
> -			thread_group_cputime(p, &cputime);
> -			utime = cputime_add(utime, cputime.utime);
> -			stime = cputime_add(stime, cputime.stime);
> +			utime = cputime_add(utime, p->signal->utime);
> +			stime = cputime_add(stime, p->signal->stime);
>  			r->ru_nvcsw += p->signal->nvcsw;
>  			r->ru_nivcsw += p->signal->nivcsw;
>  			r->ru_minflt += p->signal->min_flt;
> @@ -1585,7 +1608,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
>  			r->ru_oublock += p->signal->oublock;
>  			t = p;
>  			do {
> -				accumulate_thread_rusage(t, r);
> +				accumulate_thread_rusage(t, r, &utime, &stime);
>  				t = next_thread(t);
>  			} while (t != p);
>  			break;
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index f85597a..d5dd93f 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -75,7 +75,6 @@
>  #include <linux/string.h>
>  #include <linux/selinux.h>
>  #include <linux/mutex.h>
> -#include <linux/posix-timers.h>
>  
>  #include "avc.h"
>  #include "objsec.h"
> @@ -2325,7 +2324,13 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
>  			initrlim = init_task.signal->rlim+i;
>  			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
>  		}
> -		update_rlimit_cpu(rlim->rlim_cur);
> +		if (current->signal->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
> +			/*
> +			 * This will cause RLIMIT_CPU calculations
> +			 * to be refigured.
> +			 */
> +			current->it_prof_expires = jiffies_to_cputime(1);
> +		}
>  	}
>  
>  	/* Wake up the parent if it is waiting so that it can
> 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYH3Pck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYH3Pck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 11:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYH3Pcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 11:32:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYH3Pcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 11:32:31 -0400
Subject: Re: Still seeing decreasing stime/utime
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Spencer Candland <spencer@bluehost.com>, dmitry.adamushko@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080830135557.GA24039@balbir.in.ibm.com>
References: <48B5C4C7.8040509@bluehost.com>
	 <48B66BCC.8030207@linux.vnet.ibm.com> <48B702FA.8060308@bluehost.com>
	 <20080828224502.GA1540@balbir.in.ibm.com> <48B859C8.5000001@bluehost.com>
	 <48B8E102.5050503@linux.vnet.ibm.com> <1220095656.8426.23.camel@twins>
	 <20080830135557.GA24039@balbir.in.ibm.com>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 17:32:07 +0200
Message-Id: <1220110327.14894.40.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-30 at 19:25 +0530, Balbir Singh wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-08-30 13:27:36]:
> 
> > On Sat, 2008-08-30 at 11:26 +0530, Balbir Singh wrote:
> > > Spencer Candland wrote:
> > > >> Here is an experimental patch (I've just compiled and booted a machine
> > > >> with it, I am unable to reproduce your problem), could you please test
> > > >> it for me and see if it helps solve the problem
> > > > 
> > > > Looks like this fixed it.  I have been testing this for the last 16
> > > > hours and everything is looking good.
> > > > 
> > > 
> > > Excellent! Ingo, Peter, do you like the patch? If so, could you please pick it
> > > up Ingo. I think we should even push the fix to stable releases.
> > 
> > Looks good, except for the issue you yourself earlier raised, a few of
> > those functions looks too large to be inlined.
> >
> 
> Here's the updated revision with task_*time functions moved to sched.c
> and inlining removed, except for task_gtime(). I've compiled and
> booted a machine (x86_64) with this patch applied.
> 
> Reported-by: spencer@bluehost.com
> 
> Spencer reported a problem where utime and stime were going negative despite
> the fixes in commit b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa. The suspected
> reason for the problem is that signal_struct maintains it's own utime and
> stime (of exited tasks), these are not updated using the new task_utime()
> routine, hence sig->utime can go backwards and cause the same problem
> to occur (sig->utime, adds tsk->utime and not task_utime()). This patch
> fixes the problem
> 
> TODO: using max(task->prev_utime, derived utime) works for now, but a more
> generic solution is to implement cputime_max() and use the cputime_gt()
> function for comparison.
> 
> Comments?
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Thanks Balbir!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
> 
>  fs/proc/array.c       |   59 --------------------------------------------------
>  include/linux/sched.h |    4 +++
>  kernel/exit.c         |    6 ++---
>  kernel/sched.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 66 insertions(+), 62 deletions(-)
> 
> diff -puN kernel/exit.c~fix-utime-stime-moving-backwards kernel/exit.c
> --- linux-2.6.27-rc3/kernel/exit.c~fix-utime-stime-moving-backwards	2008-08-29 03:14:57.000000000 +0530
> +++ linux-2.6.27-rc3-balbir/kernel/exit.c	2008-08-29 03:21:18.000000000 +0530
> @@ -115,9 +115,9 @@ static void __exit_signal(struct task_st
>  		 * We won't ever get here for the group leader, since it
>  		 * will have been the last reference on the signal_struct.
>  		 */
> -		sig->utime = cputime_add(sig->utime, tsk->utime);
> -		sig->stime = cputime_add(sig->stime, tsk->stime);
> -		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
> +		sig->utime = cputime_add(sig->utime, task_utime(tsk));
> +		sig->stime = cputime_add(sig->stime, task_stime(tsk));
> +		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
>  		sig->min_flt += tsk->min_flt;
>  		sig->maj_flt += tsk->maj_flt;
>  		sig->nvcsw += tsk->nvcsw;
> diff -puN fs/proc/array.c~fix-utime-stime-moving-backwards fs/proc/array.c
> --- linux-2.6.27-rc3/fs/proc/array.c~fix-utime-stime-moving-backwards	2008-08-29 03:14:58.000000000 +0530
> +++ linux-2.6.27-rc3-balbir/fs/proc/array.c	2008-08-29 03:16:09.000000000 +0530
> @@ -349,65 +349,6 @@ int proc_pid_status(struct seq_file *m, 
>  	return 0;
>  }
>  
> -/*
> - * Use precise platform statistics if available:
> - */
> -#ifdef CONFIG_VIRT_CPU_ACCOUNTING
> -static cputime_t task_utime(struct task_struct *p)
> -{
> -	return p->utime;
> -}
> -
> -static cputime_t task_stime(struct task_struct *p)
> -{
> -	return p->stime;
> -}
> -#else
> -static cputime_t task_utime(struct task_struct *p)
> -{
> -	clock_t utime = cputime_to_clock_t(p->utime),
> -		total = utime + cputime_to_clock_t(p->stime);
> -	u64 temp;
> -
> -	/*
> -	 * Use CFS's precise accounting:
> -	 */
> -	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
> -
> -	if (total) {
> -		temp *= utime;
> -		do_div(temp, total);
> -	}
> -	utime = (clock_t)temp;
> -
> -	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
> -	return p->prev_utime;
> -}
> -
> -static cputime_t task_stime(struct task_struct *p)
> -{
> -	clock_t stime;
> -
> -	/*
> -	 * Use CFS's precise accounting. (we subtract utime from
> -	 * the total, to make sure the total observed by userspace
> -	 * grows monotonically - apps rely on that):
> -	 */
> -	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
> -			cputime_to_clock_t(task_utime(p));
> -
> -	if (stime >= 0)
> -		p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
> -
> -	return p->prev_stime;
> -}
> -#endif
> -
> -static cputime_t task_gtime(struct task_struct *p)
> -{
> -	return p->gtime;
> -}
> -
>  static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>  			struct pid *pid, struct task_struct *task, int whole)
>  {
> diff -puN include/linux/sched.h~fix-utime-stime-moving-backwards include/linux/sched.h
> --- linux-2.6.27-rc3/include/linux/sched.h~fix-utime-stime-moving-backwards	2008-08-29 03:14:58.000000000 +0530
> +++ linux-2.6.27-rc3-balbir/include/linux/sched.h	2008-08-30 18:43:56.000000000 +0530
> @@ -1430,6 +1430,10 @@ static inline void put_task_struct(struc
>  		__put_task_struct(t);
>  }
>  
> +extern cputime_t task_utime(struct task_struct *p);
> +extern cputime_t task_stime(struct task_struct *p);
> +extern cputime_t task_gtime(struct task_struct *p);
> +
>  /*
>   * Per process flags
>   */
> diff -puN kernel/sched.c~fix-utime-stime-moving-backwards kernel/sched.c
> --- linux-2.6.27-rc3/kernel/sched.c~fix-utime-stime-moving-backwards	2008-08-30 18:38:15.000000000 +0530
> +++ linux-2.6.27-rc3-balbir/kernel/sched.c	2008-08-30 18:41:40.000000000 +0530
> @@ -4176,6 +4176,65 @@ void account_steal_time(struct task_stru
>  }
>  
>  /*
> + * Use precise platform statistics if available:
> + */
> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING
> +cputime_t task_utime(struct task_struct *p)
> +{
> +	return p->utime;
> +}
> +
> +cputime_t task_stime(struct task_struct *p)
> +{
> +	return p->stime;
> +}
> +#else
> +cputime_t task_utime(struct task_struct *p)
> +{
> +	clock_t utime = cputime_to_clock_t(p->utime),
> +		total = utime + cputime_to_clock_t(p->stime);
> +	u64 temp;
> +
> +	/*
> +	 * Use CFS's precise accounting:
> +	 */
> +	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
> +
> +	if (total) {
> +		temp *= utime;
> +		do_div(temp, total);
> +	}
> +	utime = (clock_t)temp;
> +
> +	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
> +	return p->prev_utime;
> +}
> +
> +cputime_t task_stime(struct task_struct *p)
> +{
> +	clock_t stime;
> +
> +	/*
> +	 * Use CFS's precise accounting. (we subtract utime from
> +	 * the total, to make sure the total observed by userspace
> +	 * grows monotonically - apps rely on that):
> +	 */
> +	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
> +			cputime_to_clock_t(task_utime(p));
> +
> +	if (stime >= 0)
> +		p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
> +
> +	return p->prev_stime;
> +}
> +#endif
> +
> +inline cputime_t task_gtime(struct task_struct *p)
> +{
> +	return p->gtime;
> +}
> +
> +/*
>   * This function gets called by the timer code, with HZ frequency.
>   * We call it with interrupts disabled.
>   *
> _
> 


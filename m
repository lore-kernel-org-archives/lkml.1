Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbXH3JLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbXH3JLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 05:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbXH3JLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 05:11:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39976 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbXH3JK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 05:10:59 -0400
Subject: Re: [PATCH 2.6.21] Return available first timeslice to the
	creator, not parent
From: Peter Zijlstra <peterz@infradead.org>
To: Vitaly Mayatskikh <vmayatsk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelianov <xemul@openvz.org>
In-Reply-To: <m3fy21qx4p.fsf@dhcp-lab-143.englab.brq.redhat.com>
References: <m3fy21qx4p.fsf@dhcp-lab-143.englab.brq.redhat.com>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 11:10:56 +0200
Message-Id: <1188465056.6112.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 09:50 +0200, Vitaly Mayatskikh wrote:
> Short-living process returns its timeslice to the parent, this affects
> process that creates a lot of such short-living threads, because its
> not a parent for new threads. Patch fixes this issue and doesn't break
> kabi as does the patch from reporter: http://lkml.org/lkml/2007/4/7/21

> plain text document attachment (2.6.21-timeslice.patch), "proposed
> patch"
> diff -up -bB ./include/linux/sched.h.orig ./include/linux/sched.h
> --- ./include/linux/sched.h.orig	2007-08-21 09:20:22.000000000 +0200
> +++ ./include/linux/sched.h	2007-08-27 10:14:06.000000000 +0200
> @@ -827,7 +827,9 @@ struct task_struct {
>  
>  	unsigned long policy;
>  	cpumask_t cpus_allowed;
> -	unsigned int time_slice, first_time_slice;
> +	unsigned int time_slice;
> +	/* Pid of creator */
> +	unsigned int cpid;

might as well make that pid_t, or maybe even a struct pid* and keep a
reference on it - the struct pid police might have an opinion.

>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>  	struct sched_info sched_info;
> diff -up -bB ./kernel/sched.c.orig ./kernel/sched.c
> --- ./kernel/sched.c.orig	2007-08-21 09:20:22.000000000 +0200
> +++ ./kernel/sched.c	2007-08-27 10:18:44.000000000 +0200
> @@ -1626,9 +1626,9 @@ void fastcall sched_fork(struct task_str
>  	p->time_slice = (current->time_slice + 1) >> 1;
>  	/*
>  	 * The remainder of the first timeslice might be recovered by
> -	 * the parent if the child exits early enough.
> +	 * the creator (not parent!) if the child exits early enough.
>  	 */
> -	p->first_time_slice = 1;
> +	p->cpid = current->pid;
>  	current->time_slice >>= 1;
>  	p->timestamp = sched_clock();
>  	if (unlikely(!current->time_slice)) {
> @@ -1728,33 +1728,46 @@ void fastcall wake_up_new_task(struct ta
>  
>  /*
>   * Potentially available exiting-child timeslices are
> - * retrieved here - this way the parent does not get
> + * retrieved here - this way the creator does not get
>   * penalized for creating too many threads.
>   *
>   * (this cannot be used to 'generate' timeslices
>   * artificially, because any timeslice recovered here
> - * was given away by the parent in the first place.)
> + * was given away by the creator in the first place.)
>   */
>  void fastcall sched_exit(struct task_struct *p)
>  {
>  	unsigned long flags;
>  	struct rq *rq;
> -
> +	struct task_struct* creator = NULL;
>  	/*
>  	 * If the child was a (relative-) CPU hog then decrease
> -	 * the sleep_avg of the parent as well.
> +	 * the sleep_avg of the creator as well.
>  	 */
> -	rq = task_rq_lock(p->parent, &flags);
> -	if (p->first_time_slice && task_cpu(p) == task_cpu(p->parent)) {
> -		p->parent->time_slice += p->time_slice;
> -		if (unlikely(p->parent->time_slice > task_timeslice(p)))
> -			p->parent->time_slice = task_timeslice(p);
> +	if (p->cpid) {
> +		struct pid *pid = find_get_pid((pid_t)p->cpid);
> +		if (pid) {
> +			creator = get_pid_task(pid, PIDTYPE_PID);
> +			put_pid(pid);
>  	}
> -	if (p->sleep_avg < p->parent->sleep_avg)
> -		p->parent->sleep_avg = p->parent->sleep_avg /
> +
> +		if (creator) {
> +			if (task_cpu(p) == task_cpu(creator)) {
> +				rq = task_rq_lock(creator, &flags);
> +
> +				creator->time_slice += p->time_slice;
> +				if (unlikely(creator->time_slice > task_timeslice(p)))
> +					creator->time_slice = task_timeslice(p);
> +
> +				if (p->sleep_avg < creator->sleep_avg)
> +					creator->sleep_avg = creator->sleep_avg /
>  		(EXIT_WEIGHT + 1) * EXIT_WEIGHT + p->sleep_avg /
>  		(EXIT_WEIGHT + 1);
>  	task_rq_unlock(rq, &flags);
> +			}
> +			put_task_struct(creator);
> +		}
> +	}
>  }
>  
>  /**
> @@ -3153,7 +3166,7 @@ static void task_running_tick(struct rq 
>  		 */
>  		if ((p->policy == SCHED_RR) && !--p->time_slice) {
>  			p->time_slice = task_timeslice(p);
> -			p->first_time_slice = 0;
> +			p->cpid = 0;
>  			set_tsk_need_resched(p);
>  
>  			/* put it at the end of the queue: */
> @@ -3166,7 +3179,7 @@ static void task_running_tick(struct rq 
>  		set_tsk_need_resched(p);
>  		p->prio = effective_prio(p);
>  		p->time_slice = task_timeslice(p);
> -		p->first_time_slice = 0;
> +		p->cpid = 0;
>  
>  		if (!rq->expired_timestamp)
>  			rq->expired_timestamp = jiffies;

Other than that it looks good, pretty much what I suggested :-)


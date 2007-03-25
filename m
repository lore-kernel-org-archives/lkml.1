Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbXCYRw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbXCYRw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 13:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXCYRw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 13:52:27 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:43022 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbXCYRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 13:52:26 -0400
Message-ID: <4606B6CF.6040306@in.ibm.com>
Date: Sun, 25 Mar 2007 23:22:15 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: pj@sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
References: <20070325164746.GI11794@in.ibm.com>
In-Reply-To: <20070325164746.GI11794@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vatsa,

Srivatsa Vaddagiri wrote:
> 
> diff -puN kernel/cpuset.c~cpuset_race_fix kernel/cpuset.c
> --- linux-2.6.21-rc4/kernel/cpuset.c~cpuset_race_fix	2007-03-25 21:08:27.000000000 +0530
> +++ linux-2.6.21-rc4-vatsa/kernel/cpuset.c	2007-03-25 21:25:05.000000000 +0530
> @@ -1182,6 +1182,7 @@ static int attach_task(struct cpuset *cs
>  	pid_t pid;
>  	struct task_struct *tsk;
>  	struct cpuset *oldcs;
> +	struct cpuset *oldcs_tobe_released = NULL;

How about oldcs_to_be_released?

>  	cpumask_t cpus;
>  	nodemask_t from, to;
>  	struct mm_struct *mm;
> @@ -1237,6 +1238,8 @@ static int attach_task(struct cpuset *cs
>  	}
>  	atomic_inc(&cs->count);
>  	rcu_assign_pointer(tsk->cpuset, cs);
> +	if (atomic_dec_and_test(&oldcs->count))
> +		oldcs_tobe_released = oldcs;
>  	task_unlock(tsk);
> 
>  	guarantee_online_cpus(cs, &cpus);
> @@ -1257,8 +1260,8 @@ static int attach_task(struct cpuset *cs
> 
>  	put_task_struct(tsk);
>  	synchronize_rcu();
> -	if (atomic_dec_and_test(&oldcs->count))
> -		check_for_release(oldcs, ppathbuf);
> +	if (oldcs_tobe_released)
> +		check_for_release(oldcs_tobe_released, ppathbuf);
>  	return 0;
>  }
> 
> @@ -2200,10 +2203,6 @@ void cpuset_fork(struct task_struct *chi
>   * it is holding that mutex while calling check_for_release(),
>   * which calls kmalloc(), so can't be called holding callback_mutex().
>   *
> - * We don't need to task_lock() this reference to tsk->cpuset,
> - * because tsk is already marked PF_EXITING, so attach_task() won't
> - * mess with it, or task is a failed fork, never visible to attach_task.
> - *
>   * the_top_cpuset_hack:
>   *
>   *    Set the exiting tasks cpuset to the root cpuset (top_cpuset).
> @@ -2242,19 +2241,20 @@ void cpuset_exit(struct task_struct *tsk
>  {
>  	struct cpuset *cs;
> 
> +	task_lock(tsk);
>  	cs = tsk->cpuset;
>  	tsk->cpuset = &top_cpuset;	/* the_top_cpuset_hack - see above */
> +	atomic_dec(&cs->count);

How about using a local variable like ref_count and using

ref_count = atomic_dec_and_test(&cs->count); This will avoid the two
atomic operations, atomic_dec() and atomic_read() below.

> +	task_unlock(tsk);
> 
>  	if (notify_on_release(cs)) {
>  		char *pathbuf = NULL;
> 
>  		mutex_lock(&manage_mutex);
> -		if (atomic_dec_and_test(&cs->count))
> +		if (!atomic_read(&cs->count))

if (ref_count == 0)

>  			check_for_release(cs, &pathbuf);
>  		mutex_unlock(&manage_mutex);
>  		cpuset_release_agent(pathbuf);
> -	} else {
> -		atomic_dec(&cs->count);
>  	}
>  }
> 

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

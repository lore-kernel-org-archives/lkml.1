Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZBPLI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZBPLI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 06:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZBPLIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 06:08:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46001 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZBPLIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 06:08:46 -0500
Subject: Re: RT scheduling and a way to make a process hang, unkillable
From: Peter Zijlstra <peterz@infradead.org>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com
In-Reply-To: <20090216103636.GC17355@linux.vnet.ibm.com>
References: <4997672B.1000301@fatooh.org> <1234697096.4713.24.camel@laptop>
	 <20090216103636.GC17355@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 12:08:36 +0100
Message-Id: <1234782516.4703.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 16:06 +0530, Dhaval Giani wrote:

> sched: Don't allow setuid to succeed if the user does not have rt bandwidth
> 
> Corey Hickey reported that on using setuid to change the uid of a
> rt process, the process would be unkillable and not be running.
> This is because there was no rt runtime for that user group. Add
> in a check to see if a user can attach an rt task to its task group.
> 
> Disclaimer: Not sure about the return values, and if setuid allows
> return values other than EPERM and EAGAIN.
> 
> Not-Yet-Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h
> +++ linux-2.6/include/linux/sched.h
> @@ -2320,9 +2320,12 @@ extern long sched_group_rt_runtime(struc
>  extern int sched_group_set_rt_period(struct task_group *tg,
>  				      long rt_period_us);
>  extern long sched_group_rt_period(struct task_group *tg);
> +int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
>  #endif
>  #endif
>  
> +int rt_task_can_switch_user(uid_t uid, struct task_struct *tsk);
> +
>  #ifdef CONFIG_TASK_XACCT
>  static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
>  {
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -9466,6 +9466,16 @@ static int sched_rt_global_constraints(v
>  
>  	return ret;
>  }
> +
> +int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
> +{
> +	/* Don't accept realtime tasks when there is no way for them to run */
> +	if (rt_task(tsk) && tg->rt_bandwidth.rt_runtime == 0)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  #else /* !CONFIG_RT_GROUP_SCHED */
>  static int sched_rt_global_constraints(void)
>  {
> @@ -9559,8 +9569,7 @@ cpu_cgroup_can_attach(struct cgroup_subs
>  		      struct task_struct *tsk)
>  {
>  #ifdef CONFIG_RT_GROUP_SCHED
> -	/* Don't accept realtime tasks when there is no way for them to run */
> -	if (rt_task(tsk) && cgroup_tg(cgrp)->rt_bandwidth.rt_runtime == 0)
> +	if (sched_rt_can_attach(cgroup_tg(cgrp), tsk))
>  		return -EINVAL;
>  #else
>  	/* We don't support RT-tasks being in separate groups */
> Index: linux-2.6/kernel/user.c
> ===================================================================
> --- linux-2.6.orig/kernel/user.c
> +++ linux-2.6/kernel/user.c
> @@ -216,8 +216,28 @@ static ssize_t cpu_rt_period_store(struc
>  
>  static struct kobj_attribute cpu_rt_period_attr =
>  	__ATTR(cpu_rt_period, 0644, cpu_rt_period_show, cpu_rt_period_store);
> +
>  #endif
>  
> +#ifdef CONFIG_RT_GROUP_SCHED && CONFIG_USER_SCHED
> +/*
> + * We need to check if a setuid can take place. This function should be called
> + * before successfully completing the setuid.
> + */
> +
> +int rt_task_can_switch_user(uid_t uid, struct task_struct *tsk)
> +{
> +	struct user_struct *up = find_user(uid);
> +
> +	return sched_rt_can_attach(up->tg, tsk);
> +}

Should that not be !sched_rt_can_attach(), or preferably change
sched_rt_can_attach() to return a boolean, like the name implies.

> +#else
> +int rt_task_can_switch_user(uid_t uid, struct task_struct *tsk)
> +{
> +	return 0;
> +}

With the below this means !RT_GROUP_SCHED || CGROUP never gets to change
uid :-)

> +#endif
>  /* default attributes per uid directory */
>  static struct attribute *uids_attributes[] = {
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> Index: linux-2.6/kernel/sys.c
> ===================================================================
> --- linux-2.6.orig/kernel/sys.c
> +++ linux-2.6/kernel/sys.c
> @@ -579,6 +579,15 @@ static int set_user(struct cred *new)
>  		return -EAGAIN;
>  	}
>  
> +	/*
> +	 * Though rt_task_can_switch_user returns EINVAL on failure, we
> +	 * return EAGAIN so as not to break semantics and because
> +	 * EAGAIN implies resource not available which is the case in
> +	 * this case.
> +	 */
> +	if (rt_task_can_switch_user(new->uid, current))
> +		return -EAGAIN;
> +
>  	free_uid(new->user);
>  	new->user = new_user;
>  	return 0;
> 


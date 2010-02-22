Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0BVWGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:06:38 -0500
Received: from smtp-out.google.com ([216.239.33.17]:38604 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab0BVWGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:06:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fhmuzjAw3vbGSH2LHBQSHKgJIGU/f7aenbTZ4hsWiax3YLX4qJubwTHwzqLBOirYj
	SaHBBH4pGsXDtfO6jQwfg==
Date: Mon, 22 Feb 2010 14:06:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time
 (58568d2)
In-Reply-To: <4B827043.3060305@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002221339160.14426@chino.kir.corp.google.com>
References: <20100218134921.GF9738@laptop> <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com> <20100219033126.GI9738@laptop> <alpine.DEB.2.00.1002190143040.6293@chino.kir.corp.google.com> <4B827043.3060305@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Miao Xie wrote:

> >>> guarantee_online_cpus() truly does require callback_mutex, the 
> >>> cgroup_scan_tasks() iterator locking can protect changes in the cgroup 
> >>> hierarchy but it doesn't protect a store to cs->cpus_allowed or for 
> >>> hotplug.
> >>
> >> Right, but the callback_mutex was being removed by this patch.
> >>
> > 
> > I was making the case for it to be readded :)
> 
> But cgroup_mutex is held when someone changes cs->cpus_allowed or doing hotplug,
> so I think callback_mutex is not necessary in this case.
> 

Then why is it taken in update_cpumask()?

> I think this patch can't fix this bug, because mems_allowed of tasks in the
> top group is set to node_possible_map by default, not when the task is 
> attached.
> 

Ok, I thought that all tasks get their ->attach() function called whenever 
their cgroup is mounted.

> I made a new patch at the end of this email to fix it, but I have no machine
> to test it now. who can test it for me.
> 
> ---
> diff --git a/init/main.c b/init/main.c
> index 4cb47a1..512ba15 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -846,7 +846,7 @@ static int __init kernel_init(void * unused)
>  	/*
>  	 * init can allocate pages on any node
>  	 */
> -	set_mems_allowed(node_possible_map);
> +	set_mems_allowed(node_states[N_HIGH_MEMORY]);
>  	/*
>  	 * init can run on any cpu.
>  	 */
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index ba401fa..e29b440 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -935,10 +935,12 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
>  	struct task_struct *tsk = current;
>  
>  	tsk->mems_allowed = *to;
> +	wmb();
>  
>  	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
>  
>  	guarantee_online_mems(task_cs(tsk),&tsk->mems_allowed);
> +	wmb();
>  }
>  
>  /*
> @@ -1391,11 +1393,10 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>  
>  	if (cs == &top_cpuset) {
>  		cpumask_copy(cpus_attach, cpu_possible_mask);
> -		to = node_possible_map;
>  	} else {
>  		guarantee_online_cpus(cs, cpus_attach);
> -		guarantee_online_mems(cs, &to);
>  	}
> +	guarantee_online_mems(cs, &to);
>  
>  	/* do per-task migration stuff possibly for each in the threadgroup */
>  	cpuset_attach_task(tsk, &to, cs);

Do we need to set cpus_attach to cpu_possible_mask?  Why won't 
cpu_active_mask suffice?

> @@ -2090,15 +2091,19 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
>  static int cpuset_track_online_nodes(struct notifier_block *self,
>  				unsigned long action, void *arg)
>  {
> +	nodemask_t oldmems;

Is it possible to use NODEMASK_ALLOC() instead?

> +
>  	cgroup_lock();
>  	switch (action) {
>  	case MEM_ONLINE:
> -	case MEM_OFFLINE:
> +		oldmems = top_cpuset.mems_allowed;
>  		mutex_lock(&callback_mutex);
>  		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>  		mutex_unlock(&callback_mutex);
> -		if (action == MEM_OFFLINE)
> -			scan_for_empty_cpusets(&top_cpuset);
> +		update_tasks_nodemask(&top_cpuset, &oldmems, NULL);
> +		break;
> +	case MEM_OFFLINE:
> +		scan_for_empty_cpusets(&top_cpuset);
>  		break;
>  	default:
>  		break;

Looks good.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYELXt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYELXt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 19:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbYELXtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 19:49:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756908AbYELXti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 19:49:38 -0400
Date: Mon, 12 May 2008 16:48:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balaji Rao <balajirrao@gmail.com>
Cc: dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, menage@google.com, balbir@in.ibm.com,
       vatsa@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, dada1@cosmosbay.com
Subject: Re: [RFC][-mm] Simple stats for cpu resource controller v4
Message-Id: <20080512164833.8354abeb.akpm@linux-foundation.org>
In-Reply-To: <200805120148.37856.balajirrao@gmail.com>
References: <200804052339.46632.balajirrao@gmail.com>
	<200805030526.46750.balajirrao@gmail.com>
	<20080502171938.bcb27121.akpm@linux-foundation.org>
	<200805120148.37856.balajirrao@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 01:48:37 +0530
Balaji Rao <balajirrao@gmail.com> wrote:

> Hi Andrew,
> 
> Here's a version that uses percpu_counters and which actually works. The 
> only evil it contains is the check, 
> 
> 	if (percpu_counter_ready) {
> 		..
> 	}

There's no instance of "percpu_counter_ready" in the patch so I'm a bit
stumped.

> @@ -3837,6 +3858,16 @@ void account_user_time(struct task_struct *p, cputime_t cputime)
>  		cpustat->nice = cputime64_add(cpustat->nice, tmp);
>  	else
>  		cpustat->user = cputime64_add(cpustat->user, tmp);
> +
> +       /* Charge the task's group */
> +#ifdef CONFIG_CGROUP_SCHED
> +	{
> +		struct task_group *tg;
> +		tg = task_group(p);
> +		__cpu_cgroup_stat_add(tg->stat, CPU_CGROUP_STAT_UTIME,
> +				cputime_to_msecs(cputime));
> +	}
> +#endif
>  }
>  
>  /*
> @@ -3892,8 +3923,17 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
>  		cpustat->irq = cputime64_add(cpustat->irq, tmp);
>  	else if (softirq_count())
>  		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
> -	else if (p != rq->idle)
> +	else if (p != rq->idle) {
>  		cpustat->system = cputime64_add(cpustat->system, tmp);
> +#ifdef CONFIG_CGROUP_SCHED
> +		{
> +			struct task_group *tg;
> +			tg = task_group(p);
> +			__cpu_cgroup_stat_add(tg->stat, CPU_CGROUP_STAT_STIME,
> +					cputime_to_msecs(cputime));
> +		}
> +	}
> +#endif

I'd suggest that the above be turned into calls to a helper function
which is a no-op if !CONFIG_CGROUP_SCHED.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbYKSBUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbYKSBUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 20:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbYKSBTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 20:19:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52083 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYKSBTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 20:19:49 -0500
Message-ID: <492369A4.3060104@cn.fujitsu.com>
Date: Wed, 19 Nov 2008 09:19:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: print triggering task's cpuset and mems allowed
References: <alpine.DEB.1.10.0810241704380.15988@chino.kir.corp.google.com> <alpine.DEB.1.10.0810241714290.16902@chino.kir.corp.google.com> <20081027174136.c97687c7.akpm@linux-foundation.org> <alpine.DEB.1.10.0810280222090.31219@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.10.0810280222090.31219@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> oom: print triggering task's cpuset and mems allowed
> 
> When cpusets are enabled, it's necessary to print the triggering task's
> set of allowable nodes so the subsequently printed meminfo can be
> interpreted correctly.
> 
> We also print the task's cpuset name for informational purposes.
> 
> Cc: Paul Menage <menage@google.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/cpuset.h |    6 ++++++
>  kernel/cpuset.c        |   34 ++++++++++++++++++++++++++++++++++
>  mm/oom_kill.c          |    1 +
>  3 files changed, 41 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -80,6 +80,8 @@ extern int current_cpuset_is_being_rebound(void);
>  
>  extern void rebuild_sched_domains(void);
>  
> +extern void cpuset_print_task_mems_allowed(struct task_struct *p);
> +
>  #else /* !CONFIG_CPUSETS */
>  
>  static inline int cpuset_init_early(void) { return 0; }
> @@ -163,6 +165,10 @@ static inline void rebuild_sched_domains(void)
>  	partition_sched_domains(1, NULL, NULL);
>  }
>  
> +static inline void cpuset_print_task_mems_allowed(struct task_struct *p)
> +{
> +}
> +
>  #endif /* !CONFIG_CPUSETS */
>  
>  #endif /* _LINUX_CPUSET_H */
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -239,6 +239,17 @@ static struct cpuset top_cpuset = {
>  static DEFINE_MUTEX(callback_mutex);
>  
>  /*
> + * cpuset_buffer_lock protects both the cpuset_name and cpuset_nodelist
> + * buffers.  They are statically allocated to prevent using excess stack
> + * when calling cpuset_print_task_mems_allowed().
> + */
> +#define CPUSET_NAME_LEN		(128)
> +#define	CPUSET_NODELIST_LEN	(256)
> +static char cpuset_name[CPUSET_NAME_LEN];
> +static char cpuset_nodelist[CPUSET_NODELIST_LEN];
> +static DEFINE_SPINLOCK(cpuset_buffer_lock);
> +
> +/*
>   * This is ugly, but preserves the userspace API for existing cpuset
>   * users. If someone tries to mount the "cpuset" filesystem, we
>   * silently switch it to mount "cgroup" instead
> @@ -2339,6 +2350,29 @@ int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
>  	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
>  }
>  
> +/**
> + * cpuset_print_task_mems_allowed - prints task's cpuset and mems_allowed
> + * @task: pointer to task_struct of some task.
> + *
> + * Description: Prints @task's name, cpuset name, and cached copy of its
> + * mems_allowed to the kernel log.  Must hold task_lock(task) to allow
> + * dereferencing task_cs(task).
> + */

But none of the callers of this function holds task_lock nor rcu_read_lock,
they hold tasklist_lock. Have you confirmed this is ok? It seems racy that
the task may be moved to another cgroup and the original cgroup gets removed.

> +void cpuset_print_task_mems_allowed(struct task_struct *tsk)
> +{
> +	struct dentry *dentry;
> +
> +	dentry = task_cs(tsk)->css.cgroup->dentry;
> +	spin_lock(&cpuset_buffer_lock);
> +	snprintf(cpuset_name, CPUSET_NAME_LEN,
> +		 dentry ? (const char *)dentry->d_name.name : "/");
> +	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
> +			   tsk->mems_allowed);
> +	printk(KERN_INFO "%s cpuset=%s mems_allowed=%s\n",
> +	       tsk->comm, cpuset_name, cpuset_nodelist);
> +	spin_unlock(&cpuset_buffer_lock);
> +}
> +
>  /*
>   * Collection of memory_pressure is suppressed unless
>   * this flag is enabled by writing "1" to the special
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -391,6 +391,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  		printk(KERN_WARNING "%s invoked oom-killer: "
>  			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
>  			current->comm, gfp_mask, order, current->oomkilladj);
> +		cpuset_print_task_mems_allowed(current);
>  		dump_stack();
>  		show_mem();
>  		if (sysctl_oom_dump_tasks)
> --


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZAEJC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZAEJC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZAEJC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:02:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550AbZAEJC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:02:26 -0500
Date: Mon, 5 Jan 2009 01:01:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] cpuset: convert cpuset_attach() to use
 cpumask_var_t
Message-Id: <20090105010147.bc42b655.akpm@linux-foundation.org>
In-Reply-To: <4961C919.6040404@cn.fujitsu.com>
References: <495B2EA6.7010808@cn.fujitsu.com>
	<495B2EC2.9090305@cn.fujitsu.com>
	<495B2EE7.4040406@cn.fujitsu.com>
	<495B2EFB.302@cn.fujitsu.com>
	<20090104233856.8c72eb58.akpm@linux-foundation.org>
	<4961C919.6040404@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 16:47:21 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> Allocate a global cpumask_var_t at boot, and use it in cpuset_attach(), so
> we won't fail cpuset_attach().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Mike Travis <travis@sgi.com>
> ---
>  kernel/cpuset.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index afa29cf..1e32e6b 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1306,6 +1306,9 @@ static int fmeter_getrate(struct fmeter *fmp)
>  	return val;
>  }
>  
> +/* Protected by cgroup_lock */
> +static cpumask_var_t cpus_attach;
> +
>  /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
>  static int cpuset_can_attach(struct cgroup_subsys *ss,
>  			     struct cgroup *cont, struct task_struct *tsk)
> @@ -1330,7 +1333,6 @@ static void cpuset_attach(struct cgroup_subsys *ss,
>  			  struct cgroup *cont, struct cgroup *oldcont,
>  			  struct task_struct *tsk)
>  {
> -	cpumask_t cpus;
>  	nodemask_t from, to;
>  	struct mm_struct *mm;
>  	struct cpuset *cs = cgroup_cs(cont);
> @@ -1338,13 +1340,13 @@ static void cpuset_attach(struct cgroup_subsys *ss,
>  	int err;
>  
>  	if (cs == &top_cpuset) {
> -		cpus = cpu_possible_map;
> +		cpumask_copy(cpus_attach, cpu_possible_mask);
>  	} else {
>  		mutex_lock(&callback_mutex);
> -		guarantee_online_cpus(cs, &cpus);
> +		guarantee_online_cpus(cs, cpus_attach);
>  		mutex_unlock(&callback_mutex);
>  	}
> -	err = set_cpus_allowed_ptr(tsk, &cpus);
> +	err = set_cpus_allowed_ptr(tsk, cpus_attach);
>  	if (err)
>  		return;
>  
> @@ -1357,7 +1359,6 @@ static void cpuset_attach(struct cgroup_subsys *ss,
>  			cpuset_migrate_mm(mm, &from, &to);
>  		mmput(mm);
>  	}
> -
>  }
>  
>  /* The various types of files and directories in a cpuset file system */
> @@ -1838,6 +1839,9 @@ int __init cpuset_init(void)
>  	if (err < 0)
>  		return err;
>  
> +	if (!alloc_cpumask_var(&cpus_attach, GFP_KERNEL))
> +		BUG();
> +
>  	number_of_cpusets = 1;
>  	return 0;
>  }

OK, that works.

Do we need to dynamically allocate cpus_attach?  Can we just do

static cpumask_t cpus_attach;

?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbZBCIFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbZBCIFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZBCIFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:05:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40176 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZBCIFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:05:39 -0500
Date: Tue, 3 Feb 2009 17:04:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM (v2)
Message-Id: <20090203170427.c6070cda.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090203072701.GV918@balbir.in.ibm.com>
References: <20090203072013.GU918@balbir.in.ibm.com>
	<20090203072701.GV918@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 12:57:01 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Checkpatch caught an additional space, so here is the patch again
> 
> 
> Description: Add RSS and swap to OOM output from memcg
> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Changelog v2..v1:
> 
> 1. Add more information about task's memcg and the memcg
>    over it's limit
> 2. Print data in KB
> 3. Move the print routine outside task_lock()
> 4. Use rcu_read_lock() around cgroup_path, strictly speaking it
>    is not required, but relying on the current memcg implementation
>    is not a good idea.
> 
> 
> This patch displays memcg values like failcnt, usage and limit
> when an OOM occurs due to memcg.
> 
> Thanks go out to Johannes Weiner, Li Zefan, David Rientjes,
> Kamezawa Hiroyuki, Daisuke Nishimura and KOSAKI Motohiro for
> review.
> 

IIUC, this oom_kill is serialized by memcg_tasklist mutex.
Then, you don't have to allocate buffer on stack.


> +void mem_cgroup_print_mem_info(struct mem_cgroup *memcg, struct task_struct *p)
> +{
> +	struct cgroup *task_cgrp;
> +	struct cgroup *mem_cgrp;
> +	/*
> +	 * Need a buffer on stack, can't rely on allocations.
> +	 */
> +	char task_memcg_name[MEM_CGROUP_OOM_BUF_SIZE];
> +	char memcg_name[MEM_CGROUP_OOM_BUF_SIZE];
> +	int ret;
> +

making this as

static char task_memcg_name[PATH_MAX];
static char memcg_name[PATH_MAX];

is ok, I think. and the patch will be more simple.

Thanks,
-kame


> +	if (!memcg)
> +		return;
> +
> +	mem_cgrp = memcg->css.cgroup;
> +	task_cgrp = mem_cgroup_from_task(p)->css.cgroup;
> +
> +	rcu_read_lock();
> +	ret = cgroup_path(task_cgrp, task_memcg_name, MEM_CGROUP_OOM_BUF_SIZE);
> +	if (ret < 0) {
> +		/*
> +		 * Unfortunately, we are unable to convert to a useful name
> +		 * But we'll still print out the usage information
> +		 */
> +		rcu_read_unlock();
> +		goto done;
> +	}
> +	ret = cgroup_path(mem_cgrp, memcg_name, MEM_CGROUP_OOM_BUF_SIZE);
> +	 if (ret < 0) {
> +		rcu_read_unlock();
> +		goto done;
> +	}
> +
> +	rcu_read_unlock();
> +
> +	printk(KERN_INFO "Task in %s killed as a result of limit of %s\n",
> +			task_memcg_name, memcg_name);
> +done:
> +
> +	printk(KERN_INFO "memory: usage %llukB, limit %llukB, failcnt %llu\n",
> +		res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
> +		res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,
> +		res_counter_read_u64(&memcg->res, RES_FAILCNT));
> +	printk(KERN_INFO "memory+swap: usage %llukB, limit %llukB, "
> +		"failcnt %llu\n",
> +		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
> +		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
> +		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
> +}
> +
>  /*
>   * Unlike exported interface, "oom" parameter is added. if oom==true,
>   * oom-killer can be invoked.
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index d3b9bac..951356f 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -394,6 +394,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  		cpuset_print_task_mems_allowed(current);
>  		task_unlock(current);
>  		dump_stack();
> +		mem_cgroup_print_mem_info(mem, current);
>  		show_mem();
>  		if (sysctl_oom_dump_tasks)
>  			dump_tasks(mem);
> 
> -- 
> 	Balbir
> 


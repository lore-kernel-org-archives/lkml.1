Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZBCBaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZBCBaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZBCB3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:29:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60892 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZBCB3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:29:53 -0500
Message-ID: <49879DE5.8030505@cn.fujitsu.com>
Date: Tue, 03 Feb 2009 09:29:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM
References: <20090202125240.GA918@balbir.in.ibm.com> <20090202140849.GB918@balbir.in.ibm.com>
In-Reply-To: <20090202140849.GB918@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void mem_cgroup_print_mem_info(struct mem_cgroup *memcg)
> +{
> +	printk(KERN_WARNING "Memory cgroups's name %s\n",
> +		memcg->css.cgroup->dentry->d_name.name);
> +	printk(KERN_WARNING "Memory cgroup RSS : usage %llu, limit %llu"
> +		" failcnt %llu\n", res_counter_read_u64(&memcg->res, RES_USAGE),

", failcnt %llu\n" ?

> +		res_counter_read_u64(&memcg->res, RES_LIMIT),
> +		res_counter_read_u64(&memcg->res, RES_FAILCNT));
> +	printk(KERN_WARNING "Memory cgroup swap: usage %llu, limit %llu "
> +		"failcnt %llu\n",

", failcnt %llu\n" ?

> +		res_counter_read_u64(&memcg->memsw, RES_USAGE),
> +		res_counter_read_u64(&memcg->memsw, RES_LIMIT),
> +		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
> +}
> +
>  /*
>   * Unlike exported interface, "oom" parameter is added. if oom==true,
>   * oom-killer can be invoked.
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index d3b9bac..b8e53ae 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -392,6 +392,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  			current->comm, gfp_mask, order, current->oomkilladj);
>  		task_lock(current);
>  		cpuset_print_task_mems_allowed(current);
> +		mem_cgroup_print_mem_info(mem);

I think this can be put outside the task lock. The lock is used to call task_cs() safely in
cpuset_print_task_mems_allowed().

>  		task_unlock(current);
>  		dump_stack();
>  		show_mem();
> 

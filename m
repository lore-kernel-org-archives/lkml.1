Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbZBEE41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbZBEE41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 23:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbZBEE4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 23:56:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49150 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbZBEE4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 23:56:16 -0500
Date: Thu, 5 Feb 2009 13:55:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM (v3)
Message-Id: <20090205135503.f89049e9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <498A6445.4030206@cn.fujitsu.com>
References: <20090203172135.GF918@balbir.in.ibm.com>
	<498A6445.4030206@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Feb 2009 12:00:05 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

>
> > +void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
> > +{
> > +	struct cgroup *task_cgrp;
> > +	struct cgroup *mem_cgrp;
> > +	/*
> > +	 * Need a buffer on stack, can't rely on allocations. The code relies
> > +	 * on the assumption that OOM is serialized for memory controller.
> > +	 * If this assumption is broken, revisit this code.
> > +	 */
> > +	static char task_memcg_name[PATH_MAX];
> > +	static char memcg_name[PATH_MAX];
> 
> Is there any lock which protects this static data?
> 

As commented, seriealized by memory cgroup. see memcg_taslist mutex.


> > +	int ret;
> > +
> > +	if (!memcg)
> > +		return;
> > +
> > +	mem_cgrp = memcg->css.cgroup;
> > +	task_cgrp = mem_cgroup_from_task(p)->css.cgroup;
> > +
> > +	rcu_read_lock();
> > +	ret = cgroup_path(task_cgrp, task_memcg_name, PATH_MAX);
> > +	if (ret < 0) {
> > +		/*
> > +		 * Unfortunately, we are unable to convert to a useful name
> > +		 * But we'll still print out the usage information
> > +		 */
> > +		rcu_read_unlock();
> > +		goto done;
> > +	}
> > +	ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
> > +	 if (ret < 0) {
> > +		rcu_read_unlock();
> > +		goto done;
> > +	}
> > +
> > +	rcu_read_unlock();
> 
> IIRC, a preempt_enable() will add about 50 bytes to kernel size.
> 
I think compliler does good job here....


> I think these lines are also good for readability:
> 
> 	rcu_read_lock();
> 	ret = cgroup_path(task_cgrp, task_memcg_name, PATH_MAX);
> 	if (ret >= 0)
> 		ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
> 	rcu_read_unlock();
> 

In mmotm set, there is no 2 buffers. just one.
Sorry, if you have comments, patch against mmotm is welcome.

Thanks,
-Kame

> 	if (ret < 0) {
> 		/*
> 		 * Unfortunately, we are unable to convert to a useful name
> 		 * But we'll still print out the usage information
> 		 */
> 		goto done;
> 	}
> 
> Lai
> 
> > +
> > +	printk(KERN_INFO "Task in %s killed as a result of limit of %s\n",
> > +			task_memcg_name, memcg_name);
> > +done:
> > +
> > +	printk(KERN_INFO "memory: usage %llukB, limit %llukB, failcnt %llu\n",
> > +		res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
> > +		res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,
> > +		res_counter_read_u64(&memcg->res, RES_FAILCNT));
> > +	printk(KERN_INFO "memory+swap: usage %llukB, limit %llukB, "
> > +		"failcnt %llu\n",
> > +		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
> > +		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
> > +		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
> > +}
> > +
> >  /*
> >   * Unlike exported interface, "oom" parameter is added. if oom==true,
> >   * oom-killer can be invoked.
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index d3b9bac..2f3166e 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -394,6 +394,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >  		cpuset_print_task_mems_allowed(current);
> >  		task_unlock(current);
> >  		dump_stack();
> > +		mem_cgroup_print_oom_info(mem, current);
> >  		show_mem();
> >  		if (sysctl_oom_dump_tasks)
> >  			dump_tasks(mem);
> > 
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 


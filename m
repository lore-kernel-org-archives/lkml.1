Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZBCDtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZBCDtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZBCDtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:49:41 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50497 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZBCDtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:49:40 -0500
Date: Tue, 3 Feb 2009 12:44:36 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: nishimura@mxp.nes.nec.co.jp, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM
Message-Id: <20090203124436.bc0120ca.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090202134505.GA4848@cmpxchg.org>
References: <20090202125240.GA918@balbir.in.ibm.com>
	<20090202134505.GA4848@cmpxchg.org>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009 14:45:06 +0100, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Mon, Feb 02, 2009 at 06:22:40PM +0530, Balbir Singh wrote:
> > Hi, All,
> > 
> > I found the following patch useful while debugging the memory
> > controller. It adds additional information if memcg invoked the OOM.
> > 
> > Comments, Suggestions?
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > Description: Add RSS and swap to OOM output from memcg
> > 
> > This patch displays memcg values like failcnt, usage and limit
> > when an OOM occurs due to memcg.
> > 
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > ---
> > 
> >  include/linux/memcontrol.h |    5 +++++
> >  mm/memcontrol.c            |   15 +++++++++++++++
> >  mm/oom_kill.c              |    1 +
> >  3 files changed, 21 insertions(+), 0 deletions(-)
> > 
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 326f45c..2ce1737 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -104,6 +104,7 @@ struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
> >  						      struct zone *zone);
> >  struct zone_reclaim_stat*
> >  mem_cgroup_get_reclaim_stat_from_page(struct page *page);
> > +extern void mem_cgroup_print_mem_info(struct mem_cgroup *memcg);
> >  
> >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> >  extern int do_swap_account;
> > @@ -270,6 +271,10 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
> >  	return NULL;
> >  }
> >  
> > +void mem_cgroup_print_mem_info(struct mem_cgroup *memcg)
> > +{
> > +}
> > +
> >  #endif /* CONFIG_CGROUP_MEM_CONT */
> >  
> >  #endif /* _LINUX_MEMCONTROL_H */
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 8e4be9c..75eae85 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -813,6 +813,21 @@ bool mem_cgroup_oom_called(struct task_struct *task)
> >  	rcu_read_unlock();
> >  	return ret;
> >  }
> > +
> > +void mem_cgroup_print_mem_info(struct mem_cgroup *memcg)
> > +{
> > +	printk(KERN_WARNING "Memory cgroups's name %s\n",
> > +		memcg->css.cgroup->dentry->d_name.name);
> > +	printk(KERN_WARNING "Memory cgroup RSS : usage %llu, limit %llu"
> > +		" failcnt %llu\n", res_counter_read_u64(&memcg->res, RES_USAGE),
> > +		res_counter_read_u64(&memcg->res, RES_LIMIT),
> > +		res_counter_read_u64(&memcg->res, RES_FAILCNT));
> > +	printk(KERN_WARNING "Memory cgroup swap: usage %llu, limit %llu "
> > +		"failcnt %llu\n", res_counter_read_u64(&memcg->res, RES_USAGE),
> > +		res_counter_read_u64(&memcg->res, RES_LIMIT),
> > +		res_counter_read_u64(&memcg->res, RES_FAILCNT));
> > +}
> > +
> >  /*
> >   * Unlike exported interface, "oom" parameter is added. if oom==true,
> >   * oom-killer can be invoked.
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index d3b9bac..b8e53ae 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -392,6 +392,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >  			current->comm, gfp_mask, order, current->oomkilladj);
> >  		task_lock(current);
> >  		cpuset_print_task_mems_allowed(current);
> > +		mem_cgroup_print_mem_info(mem);
> 
> mem is only !NULL when we come from mem_cgroup_out_of_memory().  This
> crashes otherwise in mem_cgroup_print_mem_info(), no?
> 
I think you're right.

IMHO, "mem_cgroup_print_mem_info(current)" would be better here,
and call mem_cgroup_from_task at mem_cgroup_print_mem_info.


Thanks,
Daisuke Nishimura.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751565AbZIDEUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbZIDEUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 00:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbZIDEUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 00:20:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60801 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZIDEUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 00:20:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Sep 2009 13:18:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [mmotm][experimental][PATCH] coalescing charge
Message-Id: <20090904131835.ac2b8cc8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090903141727.ccde7e91.nishimura@mxp.nes.nec.co.jp>
References: <20090902093438.eed47a57.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902134114.b6f1a04d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902182923.c6d98fd6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090903141727.ccde7e91.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009 14:17:27 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > =
> > This is a code for batched charging using percpu cache.
> > At charge, memcg charges 64pages and remember it in percpu cache.
> > Because it's cache, drain/flushed if necessary.
> > 
> > This version uses public percpu area , not per-memcg percpu area.
> >  2 benefits of public percpu area.
> >  1. Sum of stocked charge in the system is limited to # of cpus
> >     not to the number of memcg. This shows better synchonization.
> >  2. drain code for flush/cpuhotplug is very easy (and quick)
> > 
> > The most important point of this patch is that we never touch res_counter
> > in fast path. The res_counter is system-wide shared counter which is modified
> > very frequently. We shouldn't touch it as far as we can for avoid false sharing.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> It looks basically good. I'll do some tests with all patches applied.
> 
thanks.


> I have some comments inlined.
> > ---
> >  mm/memcontrol.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 88 insertions(+), 5 deletions(-)
> > 
> > Index: mmotm-2.6.31-Aug27/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-2.6.31-Aug27.orig/mm/memcontrol.c
> > +++ mmotm-2.6.31-Aug27/mm/memcontrol.c
> > @@ -275,6 +275,7 @@ enum charge_type {
> >  static void mem_cgroup_get(struct mem_cgroup *mem);
> >  static void mem_cgroup_put(struct mem_cgroup *mem);
> >  static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
> > +static void drain_all_stock(void);
> >  
> >  static struct mem_cgroup_per_zone *
> >  mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
> > @@ -1136,6 +1137,8 @@ static int mem_cgroup_hierarchical_recla
> >  		victim = mem_cgroup_select_victim(root_mem);
> >  		if (victim == root_mem) {
> >  			loop++;
> > +			if (loop >= 1)
> > +				drain_all_stock();
> >  			if (loop >= 2) {
> >  				/*
> >  				 * If we have not been able to reclaim
> > @@ -1253,6 +1256,79 @@ done:
> >  	unlock_page_cgroup(pc);
> >  }
> >  
> > +#define CHARGE_SIZE	(64 * PAGE_SIZE)
> > +struct memcg_stock_pcp {
> > +	struct mem_cgroup *from;
> > +	int charge;
> > +};
> > +DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
> > +
> It might be better to add "static".
> 
ok.


> > +static bool consume_stock(struct mem_cgroup *mem)
> > +{
> > +	struct memcg_stock_pcp *stock;
> > +	bool ret = true;
> > +
> > +	stock = &get_cpu_var(memcg_stock);
> > +	if (mem == stock->from && stock->charge)
> > +		stock->charge -= PAGE_SIZE;
> > +	else
> > +		ret = false;
> > +	put_cpu_var(memcg_stock);
> > +	return ret;
> > +}
> > +
> > +static void drain_stock(struct memcg_stock_pcp *stock)
> > +{
> > +	struct mem_cgroup *old = stock->from;
> > +
> > +	if (stock->charge) {
> > +		res_counter_uncharge(&old->res, stock->charge);
> > +		if (do_swap_account)
> > +			res_counter_uncharge(&old->memsw, stock->charge);
> > +	}
> > +	stock->from = NULL;
> We must clear stock->charge too.
> 
ok.



> > +}
> > +
> > +static void drain_local_stock(struct work_struct *dummy)
> > +{
> > +	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
> > +	drain_stock(stock);
> > +	put_cpu_var(memcg_stock);
> > +}
> > +
> > +static void refill_stock(struct mem_cgroup *mem, int val)
> > +{
> > +	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
> > +
> > +	if (stock->from != mem) {
> > +		drain_stock(stock);
> > +		stock->from = mem;
> > +	}
> > +	stock->charge = val;
> > +	put_cpu_var(memcg_stock);
> > +}
> > +
> > +static void drain_all_stock(void)
> > +{
> > +	schedule_on_each_cpu(drain_local_stock);
> > +}
> > +
> > +static int __cpuinit memcg_stock_cpu_callback(struct notifier_block *nb,
> > +					unsigned long action,
> > +					void *hcpu)
> > +{
> > +#ifdef CONFIG_HOTPLUG_CPU
> > +	int cpu = (unsigned long)*hcpu;
> '*' isn't needed.
> 
Hmm, ouch.

> > +	struct memcg_stock_pcp *stock;
> > +
> > +	if (action != CPU_DEAD)
> > +		return NOTIFY_OK;
> > +	stock = per_cpu(memcg_stock, cpu);
> '&' is needed.
> 
yes..

> > +	drain_stock(stock);
> > +#endif
> > +	return NOTIFY_OK;
> > +}
> > +
> >  /*
> >   * Unlike exported interface, "oom" parameter is added. if oom==true,
> >   * oom-killer can be invoked.
> > @@ -1288,23 +1364,25 @@ static int __mem_cgroup_try_charge(struc
> >  		return 0;
> >  
> >  	VM_BUG_ON(css_is_removed(&mem->css));
> > +	if (mem_cgroup_is_root(mem))
> > +		goto done;
> > +	if (consume_stock(mem))
> > +		goto charged;
> >  
> >  	while (1) {
> >  		int ret = 0;
> >  		unsigned long flags = 0;
> >  
> > -		if (mem_cgroup_is_root(mem))
> > -			goto done;
> > -		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res);
> > +		ret = res_counter_charge(&mem->res, CHARGE_SIZE, &fail_res);
> >  		if (likely(!ret)) {
> >  			if (!do_swap_account)
> >  				break;
> > -			ret = res_counter_charge(&mem->memsw, PAGE_SIZE,
> > +			ret = res_counter_charge(&mem->memsw, CHARGE_SIZE,
> >  							&fail_res);
> >  			if (likely(!ret))
> >  				break;
> >  			/* mem+swap counter fails */
> > -			res_counter_uncharge(&mem->res, PAGE_SIZE);
> > +			res_counter_uncharge(&mem->res, CHARGE_SIZE);
> >  			flags |= MEM_CGROUP_RECLAIM_NOSWAP;
> >  			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
> >  									memsw);
> > @@ -1342,6 +1420,9 @@ static int __mem_cgroup_try_charge(struc
> >  			goto nomem;
> >  		}
> >  	}
> > +	refill_stock(mem, CHARGE_SIZE - PAGE_SIZE);
> > +
> > +charged:
> >  	/*
> >  	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
> >  	 * if they exceeds softlimit.
> > @@ -2448,6 +2529,7 @@ move_account:
> >  			goto out;
> >  		/* This is for making all *used* pages to be on LRU. */
> >  		lru_add_drain_all();
> > +		drain_all_stock();
> >  		ret = 0;
> >  		for_each_node_state(node, N_HIGH_MEMORY) {
> >  			for (zid = 0; !ret && zid < MAX_NR_ZONES; zid++) {
> > @@ -3166,6 +3248,7 @@ mem_cgroup_create(struct cgroup_subsys *
> >  		root_mem_cgroup = mem;
> >  		if (mem_cgroup_soft_limit_tree_init())
> >  			goto free_out;
> > +		hotcpu_notifier(memcg_stock_cpu_callback, 0);
> >  
> We should include cpu.h to use hotcpu_notifier().
> 
Ah, I'll check my .config again..

Thanks,
-Kame


> >  	} else {
> >  		parent = mem_cgroup_from_cont(cont->parent);
> > 
> 
> 
> Thanks,
> Daisuke Nishimura.
> 


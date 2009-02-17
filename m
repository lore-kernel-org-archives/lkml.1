Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZBQDZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZBQDZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 22:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZBQDYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 22:24:34 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:52760 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbZBQDYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 22:24:33 -0500
Date: Tue, 17 Feb 2009 08:54:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 3/4] Memory controller soft limit organize cgroups
	(v2)
Message-ID: <20090217032405.GC20958@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090216110844.29795.17804.sendpatchset@localhost.localdomain> <20090216110906.29795.74208.sendpatchset@localhost.localdomain> <20090217094337.8BC9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090217094337.8BC9.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-02-17 10:00:00]:

> >  /*
> > + * Cgroups above their limits are maintained in a RB-Tree, independent of
> > + * their hierarchy representation
> > + */
> > +
> > +static struct rb_root mem_cgroup_soft_limit_exceeded_groups;
> 
> 37 length variable name seems too long.
>

OK, I'll shorten it
 
> 
> > +static DEFINE_SPINLOCK(memcg_soft_limit_tree_lock);
> > +
> > +/*
> >   * The memory controller data structure. The memory controller controls both
> >   * page cache and RSS per cgroup. We would eventually like to provide
> >   * statistics based on the statistics developed by Rik Van Riel for clock-pro,
> > @@ -176,12 +185,18 @@ struct mem_cgroup {
> >  
> >  	unsigned int	swappiness;
> >  
> > +	struct rb_node mem_cgroup_node;
> > +	unsigned long long usage_in_excess;
> > +	unsigned long last_tree_update;
> > +
> 
> no comment fields.
> 

I'll add them, the names are descriptive, but comments always help

> Do usage_in_excess and last_tree_update have what unit? "unsigned long" 
> don't tell me anything.
> 
> 
> >  	/*
> >  	 * statistics. This must be placed at the end of memcg.
> >  	 */
> >  	struct mem_cgroup_stat stat;
> >  };
> >  
> > +#define	MEM_CGROUP_TREE_UPDATE_INTERVAL		(HZ)
> > +
> 
> In general, memory subsystem be considered to shouldn't have timer thing.
> it's because we expect we get 100x times faster machine after 10 year,
> at that time, we expect proper timeout value is changed.
> 

Right now, I don't want to overwhelm the system by updating the tree
every time a page is added/removed. So I use an interval to see if we
should update the tree. I am not using any timers per-se.

> Can we make proper stastics, instead?
> 

I am not sure I understand your proposal fully

> 
> >  enum charge_type {
> >  	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
> >  	MEM_CGROUP_CHARGE_TYPE_MAPPED,
> > @@ -214,6 +229,41 @@ static void mem_cgroup_get(struct mem_cgroup *mem);
> >  static void mem_cgroup_put(struct mem_cgroup *mem);
> >  static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
> >  
> > +static void mem_cgroup_insert_exceeded(struct mem_cgroup *mem)
> > +{
> > +	struct rb_node **p = &mem_cgroup_soft_limit_exceeded_groups.rb_node;
> > +	struct rb_node *parent = NULL;
> > +	struct mem_cgroup *mem_node;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
> > +	while (*p) {
> > +		parent = *p;
> > +		mem_node = rb_entry(parent, struct mem_cgroup, mem_cgroup_node);
> > +		if (mem->usage_in_excess < mem_node->usage_in_excess)
> > +			p = &(*p)->rb_left;
> > +		/*
> > +		 * We can't avoid mem cgroups that are over their soft
> > +		 * limit by the same amount
> > +		 */
> > +		else if (mem->usage_in_excess >= mem_node->usage_in_excess)
> > +			p = &(*p)->rb_right;
> > +	}
> > +	rb_link_node(&mem->mem_cgroup_node, parent, p);
> > +	rb_insert_color(&mem->mem_cgroup_node,
> > +			&mem_cgroup_soft_limit_exceeded_groups);
> > +	mem->last_tree_update = jiffies;
> > +	spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
> > +}
> 
> I think this function is called from page fault hotpath, right?
> if so, you insert global lock into hotpath!
>

page fault hotpath - the hooks are at the place where we would have
called try_to_free_pages(). We already have global locks per zone and
lock is held for a short time to find and pick the correct memcg for
reclaim.
 
> 
> > +
> > +static void mem_cgroup_remove_exceeded(struct mem_cgroup *mem)
> > +{
> > +	unsigned long flags;
> > +	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
> > +	rb_erase(&mem->mem_cgroup_node, &mem_cgroup_soft_limit_exceeded_groups);
> > +	spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
> > +}
> > +
> >  static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
> >  					 struct page_cgroup *pc,
> >  					 bool charge)
> > @@ -897,6 +947,39 @@ static void record_last_oom(struct mem_cgroup *mem)
> >  	mem_cgroup_walk_tree(mem, NULL, record_last_oom_cb);
> >  }
> >  
> > +static void mem_cgroup_check_and_update_tree(struct mem_cgroup *mem,
> > +						bool time_check)
> > +{
> > +	unsigned long long prev_usage_in_excess, new_usage_in_excess;
> > +	bool updated_tree = false;
> > +	unsigned long next_update = 0;
> > +	unsigned long flags;
> > +
> > +	mem_cgroup_get(mem);
> > +	prev_usage_in_excess = mem->usage_in_excess;
> > +	new_usage_in_excess = res_counter_soft_limit_excess(&mem->res);
> > +
> > +	if (time_check)
> > +		next_update = mem->last_tree_update +
> > +				MEM_CGROUP_TREE_UPDATE_INTERVAL;
> > +	if (new_usage_in_excess && time_after(jiffies, next_update)) {
> 
> incorrect time_after() usage. jiffies can round-tripping. then 
> time_after(jiffies, 0) don't gurantee to return true.

Not sure I completely understand your comment. Is even
mem_cgroup_oom_called time_before broken?

> 
> > +		if (prev_usage_in_excess)
> > +			mem_cgroup_remove_exceeded(mem);
> > +		mem_cgroup_insert_exceeded(mem);
> > +		updated_tree = true;
> > +	} else if (prev_usage_in_excess && !new_usage_in_excess) {
> > +		mem_cgroup_remove_exceeded(mem);
> > +		updated_tree = true;
> > +	}
> > +
> > +	if (updated_tree) {
> > +		spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
> > +		mem->last_tree_update = jiffies;
> > +		mem->usage_in_excess = new_usage_in_excess;
> > +		spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
> > +	}
> > +	mem_cgroup_put(mem);
> > +}
> >  
> >  /*
> >   * Unlike exported interface, "oom" parameter is added. if oom==true,
> > @@ -906,9 +989,9 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> >  			gfp_t gfp_mask, struct mem_cgroup **memcg,
> >  			bool oom)
> >  {
> > -	struct mem_cgroup *mem, *mem_over_limit;
> > +	struct mem_cgroup *mem, *mem_over_limit, *mem_over_soft_limit;
> >  	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
> > -	struct res_counter *fail_res;
> > +	struct res_counter *fail_res, *soft_fail_res = NULL;
> >  
> >  	if (unlikely(test_thread_flag(TIF_MEMDIE))) {
> >  		/* Don't account this! */
> > @@ -938,12 +1021,13 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> >  		int ret;
> >  		bool noswap = false;
> >  
> > -		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res);
> > +		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res,
> > +						&soft_fail_res);
> >  		if (likely(!ret)) {
> >  			if (!do_swap_account)
> >  				break;
> >  			ret = res_counter_charge(&mem->memsw, PAGE_SIZE,
> > -							&fail_res);
> > +							&fail_res, NULL);
> >  			if (likely(!ret))
> >  				break;
> >  			/* mem+swap counter fails */
> > @@ -985,6 +1069,13 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> >  			goto nomem;
> >  		}
> >  	}
> > +
> > +	if (soft_fail_res) {
> > +		mem_over_soft_limit =
> > +			mem_cgroup_from_res_counter(soft_fail_res, res);
> > +		mem_cgroup_check_and_update_tree(mem_over_soft_limit, true);
> > +	}
> > +	mem_cgroup_check_and_update_tree(mem, true);
> >  	return 0;
> >  nomem:
> >  	css_put(&mem->css);
> > @@ -1422,6 +1513,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
> >  	mz = page_cgroup_zoneinfo(pc);
> >  	unlock_page_cgroup(pc);
> >  
> > +	mem_cgroup_check_and_update_tree(mem, true);
> >  	/* at swapout, this memcg will be accessed to record to swap */
> >  	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
> >  		css_put(&mem->css);
> > @@ -2346,6 +2438,7 @@ static void __mem_cgroup_free(struct mem_cgroup *mem)
> >  {
> >  	int node;
> >  
> > +	mem_cgroup_check_and_update_tree(mem, false);
> >  	free_css_id(&mem_cgroup_subsys, &mem->css);
> >  
> >  	for_each_node_state(node, N_POSSIBLE)
> > @@ -2412,6 +2505,7 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
> >  	if (cont->parent == NULL) {
> >  		enable_swap_cgroup();
> >  		parent = NULL;
> > +		mem_cgroup_soft_limit_exceeded_groups = RB_ROOT;
> >  	} else {
> >  		parent = mem_cgroup_from_cont(cont->parent);
> >  		mem->use_hierarchy = parent->use_hierarchy;
> > @@ -2432,6 +2526,8 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
> >  		res_counter_init(&mem->memsw, NULL);
> >  	}
> >  	mem->last_scanned_child = 0;
> > +	mem->usage_in_excess = 0;
> > +	mem->last_tree_update = 0;	/* Yes, time begins at 0 here */
> >  	spin_lock_init(&mem->reclaim_param_lock);
> >  
> >  	if (parent)
> > 
>

Thanks for the review! 

-- 
	Balbir

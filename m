Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbYKBFnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbYKBFnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 01:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYKBFnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 01:43:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50730 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbYKBFnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 01:43:11 -0400
Date: Sun, 2 Nov 2008 14:42:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mm] [PATCH 2/4] Memory cgroup resource counters for hierarchy
Message-Id: <20081102144237.59ab5f03.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081101184837.2575.98059.sendpatchset@balbir-laptop>
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
	<20081101184837.2575.98059.sendpatchset@balbir-laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Nov 2008 00:18:37 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> Add support for building hierarchies in resource counters. Cgroups allows us
> to build a deep hierarchy, but we currently don't link the resource counters
> belonging to the memory controller control groups, which are linked in
> cgroup hiearchy. This patch provides the infrastructure for resource counters
> that have the same hiearchy as their cgroup counter parts.
> 
> These set of patches are based on the resource counter hiearchy patches posted
> by Pavel Emelianov.
> 
> NOTE: Building hiearchies is expensive, deeper hierarchies imply charging
> the all the way up to the root. It is known that hiearchies are expensive,
> so the user needs to be careful and aware of the trade-offs before creating
> very deep ones.
> 
...isn't it better to add "root_lock" to res_counter rather than taking
all levels of lock one by one ?

 spin_lock(&res_counter->hierarchy_root->lock);
 do all charge/uncharge to hierarchy
 spin_unlock(&res_counter->hierarchy_root->lock);

Hmm ?

Thaks,
-Kame


> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  include/linux/res_counter.h |    8 ++++++--
>  kernel/res_counter.c        |   42 ++++++++++++++++++++++++++++++++++--------
>  mm/memcontrol.c             |    9 ++++++---
>  3 files changed, 46 insertions(+), 13 deletions(-)
> 
> diff -puN include/linux/res_counter.h~resource-counters-hierarchy-support include/linux/res_counter.h
> --- linux-2.6.28-rc2/include/linux/res_counter.h~resource-counters-hierarchy-support	2008-11-02 00:14:58.000000000 +0530
> +++ linux-2.6.28-rc2-balbir/include/linux/res_counter.h	2008-11-02 00:14:58.000000000 +0530
> @@ -43,6 +43,10 @@ struct res_counter {
>  	 * the routines below consider this to be IRQ-safe
>  	 */
>  	spinlock_t lock;
> +	/*
> +	 * Parent counter, used for hierarchial resource accounting
> +	 */
> +	struct res_counter *parent;
>  };
>  
>  /**
> @@ -87,7 +91,7 @@ enum {
>   * helpers for accounting
>   */
>  
> -void res_counter_init(struct res_counter *counter);
> +void res_counter_init(struct res_counter *counter, struct res_counter *parent);
>  
>  /*
>   * charge - try to consume more resource.
> @@ -103,7 +107,7 @@ void res_counter_init(struct res_counter
>  int __must_check res_counter_charge_locked(struct res_counter *counter,
>  		unsigned long val);
>  int __must_check res_counter_charge(struct res_counter *counter,
> -		unsigned long val);
> +		unsigned long val, struct res_counter **limit_fail_at);
>  
>  /*
>   * uncharge - tell that some portion of the resource is released
> diff -puN kernel/res_counter.c~resource-counters-hierarchy-support kernel/res_counter.c
> --- linux-2.6.28-rc2/kernel/res_counter.c~resource-counters-hierarchy-support	2008-11-02 00:14:58.000000000 +0530
> +++ linux-2.6.28-rc2-balbir/kernel/res_counter.c	2008-11-02 00:14:58.000000000 +0530
> @@ -15,10 +15,11 @@
>  #include <linux/uaccess.h>
>  #include <linux/mm.h>
>  
> -void res_counter_init(struct res_counter *counter)
> +void res_counter_init(struct res_counter *counter, struct res_counter *parent)
>  {
>  	spin_lock_init(&counter->lock);
>  	counter->limit = (unsigned long long)LLONG_MAX;
> +	counter->parent = parent;
>  }
>  
>  int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
> @@ -34,14 +35,34 @@ int res_counter_charge_locked(struct res
>  	return 0;
>  }
>  
> -int res_counter_charge(struct res_counter *counter, unsigned long val)
> +int res_counter_charge(struct res_counter *counter, unsigned long val,
> +			struct res_counter **limit_fail_at)
>  {
>  	int ret;
>  	unsigned long flags;
> +	struct res_counter *c, *u;
>  
> -	spin_lock_irqsave(&counter->lock, flags);
> -	ret = res_counter_charge_locked(counter, val);
> -	spin_unlock_irqrestore(&counter->lock, flags);
> +	*limit_fail_at = NULL;
> +	local_irq_save(flags);
> +	for (c = counter; c != NULL; c = c->parent) {
> +		spin_lock(&c->lock);
> +		ret = res_counter_charge_locked(c, val);
> +		spin_unlock(&c->lock);
> +		if (ret < 0) {
> +			*limit_fail_at = c;
> +			goto undo;
> +		}
> +	}
> +	ret = 0;
> +	goto done;
> +undo:
> +	for (u = counter; u != c; u = u->parent) {
> +		spin_lock(&u->lock);
> +		res_counter_uncharge_locked(u, val);
> +		spin_unlock(&u->lock);
> +	}
> +done:
> +	local_irq_restore(flags);
>  	return ret;
>  }
>  
> @@ -56,10 +77,15 @@ void res_counter_uncharge_locked(struct 
>  void res_counter_uncharge(struct res_counter *counter, unsigned long val)
>  {
>  	unsigned long flags;
> +	struct res_counter *c;
>  
> -	spin_lock_irqsave(&counter->lock, flags);
> -	res_counter_uncharge_locked(counter, val);
> -	spin_unlock_irqrestore(&counter->lock, flags);
> +	local_irq_save(flags);
> +	for (c = counter; c != NULL; c = c->parent) {
> +		spin_lock(&c->lock);
> +		res_counter_uncharge_locked(c, val);
> +		spin_unlock(&c->lock);
> +	}
> +	local_irq_restore(flags);
>  }
>  
>  
> diff -puN mm/memcontrol.c~resource-counters-hierarchy-support mm/memcontrol.c
> --- linux-2.6.28-rc2/mm/memcontrol.c~resource-counters-hierarchy-support	2008-11-02 00:14:58.000000000 +0530
> +++ linux-2.6.28-rc2-balbir/mm/memcontrol.c	2008-11-02 00:14:58.000000000 +0530
> @@ -485,6 +485,7 @@ int mem_cgroup_try_charge(struct mm_stru
>  {
>  	struct mem_cgroup *mem;
>  	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
> +	struct res_counter *fail_res;
>  	/*
>  	 * We always charge the cgroup the mm_struct belongs to.
>  	 * The mm_struct's mem_cgroup changes on task migration if the
> @@ -510,7 +511,7 @@ int mem_cgroup_try_charge(struct mm_stru
>  	}
>  
>  
> -	while (unlikely(res_counter_charge(&mem->res, PAGE_SIZE))) {
> +	while (unlikely(res_counter_charge(&mem->res, PAGE_SIZE, &fail_res))) {
>  		if (!(gfp_mask & __GFP_WAIT))
>  			goto nomem;
>  
> @@ -1175,18 +1176,20 @@ static void mem_cgroup_free(struct mem_c
>  static struct cgroup_subsys_state *
>  mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>  {
> -	struct mem_cgroup *mem;
> +	struct mem_cgroup *mem, *parent;
>  	int node;
>  
>  	if (unlikely((cont->parent) == NULL)) {
>  		mem = &init_mem_cgroup;
> +		parent = NULL;
>  	} else {
>  		mem = mem_cgroup_alloc();
> +		parent = mem_cgroup_from_cont(cont->parent);
>  		if (!mem)
>  			return ERR_PTR(-ENOMEM);
>  	}
>  
> -	res_counter_init(&mem->res);
> +	res_counter_init(&mem->res, parent ? &parent->res : NULL);
>  
>  	for_each_node_state(node, N_POSSIBLE)
>  		if (alloc_mem_cgroup_per_zone_info(mem, node))
> _
> 
> -- 
> 	Balbir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0BVSIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:08:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab0BVSID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:08:03 -0500
Date: Mon, 22 Feb 2010 13:07:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <arighi@develer.com>
Cc: David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting
	infrastructure
Message-ID: <20100222180732.GC3096@redhat.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com> <1266765525-30890-2-git-send-email-arighi@develer.com> <alpine.DEB.2.00.1002211321010.22858@chino.kir.corp.google.com> <20100221221700.GA5233@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100221221700.GA5233@linux>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 11:17:01PM +0100, Andrea Righi wrote:
> On Sun, Feb 21, 2010 at 01:28:35PM -0800, David Rientjes wrote:
> 
> [snip]
> 
> > > +static struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
> > > +{
> > > +	struct page_cgroup *pc;
> > > +	struct mem_cgroup *mem = NULL;
> > > +
> > > +	pc = lookup_page_cgroup(page);
> > > +	if (unlikely(!pc))
> > > +		return NULL;
> > > +	lock_page_cgroup(pc);
> > > +	if (PageCgroupUsed(pc)) {
> > > +		mem = pc->mem_cgroup;
> > > +		if (mem)
> > > +			css_get(&mem->css);
> > > +	}
> > > +	unlock_page_cgroup(pc);
> > > +	return mem;
> > > +}
> > 
> > Is it possible to merge this with try_get_mem_cgroup_from_page()?
> 
> Agreed.
> 
> > 
> > > +
> > > +void mem_cgroup_charge_dirty(struct page *page,
> > > +			enum zone_stat_item idx, int charge)
> > > +{
> > > +	struct mem_cgroup *mem;
> > > +	struct mem_cgroup_stat_cpu *cpustat;
> > > +	unsigned long flags;
> > > +	int cpu;
> > > +
> > > +	if (mem_cgroup_disabled())
> > > +		return;
> > > +	/* Translate the zone_stat_item into a mem_cgroup_stat_index */
> > > +	switch (idx) {
> > > +	case NR_FILE_DIRTY:
> > > +		idx = MEM_CGROUP_STAT_FILE_DIRTY;
> > > +		break;
> > > +	case NR_WRITEBACK:
> > > +		idx = MEM_CGROUP_STAT_WRITEBACK;
> > > +		break;
> > > +	case NR_WRITEBACK_TEMP:
> > > +		idx = MEM_CGROUP_STAT_WRITEBACK_TEMP;
> > > +		break;
> > > +	case NR_UNSTABLE_NFS:
> > > +		idx = MEM_CGROUP_STAT_UNSTABLE_NFS;
> > > +		break;
> > > +	default:
> > > +		return;
> > 
> > WARN()?  We don't want to silently leak counters.
> 
> Agreed.
> 
> > 
> > > +	}
> > > +	/* Charge the memory cgroup statistics */
> > > +	mem = get_mem_cgroup_from_page(page);
> > > +	if (!mem) {
> > > +		mem = root_mem_cgroup;
> > > +		css_get(&mem->css);
> > > +	}
> > 
> > get_mem_cgroup_from_page() should probably handle the root_mem_cgroup case 
> > and return a reference from it.
> 
> Right. But I'd prefer to use try_get_mem_cgroup_from_page() without
> changing the behaviour of this function.
> 
> > 
> > > +
> > > +	local_irq_save(flags);
> > > +	cpu = get_cpu();
> > > +	cpustat = &mem->stat.cpustat[cpu];
> > > +	__mem_cgroup_stat_add_safe(cpustat, idx, charge);
> > 
> > get_cpu()?  Preemption is already disabled, just use smp_processor_id().
> 
> mmmh... actually, we can just copy the code from
> mem_cgroup_charge_statistics(), so local_irq_save/restore are not
> necessarily needed and we can just use get_cpu()/put_cpu().
> 
> > > +	put_cpu();
> > > +	local_irq_restore(flags);
> > > +	css_put(&mem->css);
> > > +}
> > > +
> > >  static unsigned long mem_cgroup_get_local_zonestat(struct mem_cgroup *mem,
> > >  					enum lru_list idx)
> > >  {
> > > @@ -992,6 +1061,97 @@ static unsigned int get_swappiness(struct mem_cgroup *memcg)
> > >  	return swappiness;
> > >  }
> > >  
> > > +static unsigned long get_dirty_bytes(struct mem_cgroup *memcg)
> > > +{
> > > +	struct cgroup *cgrp = memcg->css.cgroup;
> > > +	unsigned long dirty_bytes;
> > > +
> > > +	/* root ? */
> > > +	if (cgrp->parent == NULL)
> > > +		return vm_dirty_bytes;
> > > +
> > > +	spin_lock(&memcg->reclaim_param_lock);
> > > +	dirty_bytes = memcg->dirty_bytes;
> > > +	spin_unlock(&memcg->reclaim_param_lock);
> > > +
> > > +	return dirty_bytes;
> > > +}
> > > +
> > > +unsigned long mem_cgroup_dirty_bytes(void)
> > > +{
> > > +	struct mem_cgroup *memcg;
> > > +	unsigned long dirty_bytes;
> > > +
> > > +	if (mem_cgroup_disabled())
> > > +		return vm_dirty_bytes;
> > > +
> > > +	rcu_read_lock();
> > > +	memcg = mem_cgroup_from_task(current);
> > > +	if (memcg == NULL)
> > > +		dirty_bytes = vm_dirty_bytes;
> > > +	else
> > > +		dirty_bytes = get_dirty_bytes(memcg);
> > > +	rcu_read_unlock();
> > 
> > The rcu_read_lock() isn't protecting anything here.
> 
> Right!

Are we not protecting "memcg" pointer using rcu here?

Thanks
Vivek

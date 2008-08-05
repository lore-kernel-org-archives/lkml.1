Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbYHEKaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbYHEKaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 06:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYHEKZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 06:25:43 -0400
Received: from as4.cineca.com ([130.186.84.251]:46458 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYHEKZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 06:25:42 -0400
X-Greylist: delayed 3450 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Aug 2008 06:25:42 EDT
Message-ID: <48982A9D.2000803@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory subsystem into
 two parts
References: <20080804.175214.226796876.ryov@valinux.co.jp>	<20080804.175254.71094191.ryov@valinux.co.jp>	<20080804.175707.104036289.ryov@valinux.co.jp> <20080804.175748.189722512.ryov@valinux.co.jp>
In-Reply-To: <20080804.175748.189722512.ryov@valinux.co.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue,  5 Aug 2008 12:25:33 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta wrote:
> +static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
> +				gfp_t gfp_mask, enum charge_type ctype,
> +				struct mem_cgroup *memcg)
> +{
> +	struct page_cgroup *pc;
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +	struct mem_cgroup *mem;
> +	unsigned long flags;
> +	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
> +	struct mem_cgroup_per_zone *mz;
> +#endif /* CONFIG_CGROUP_MEM_RES_CTLR */
> +
> +	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
> +	if (unlikely(pc == NULL))
> +		goto err;
> +
> +	/*
> +	 * We always charge the cgroup the mm_struct belongs to.
> +	 * The mm_struct's mem_cgroup changes on task migration if the
> +	 * thread group leader migrates. It's possible that mm is not
> +	 * set, if so charge the init_mm (happens for pagecache usage).
> +	 */
> +	if (likely(!memcg)) {
> +		rcu_read_lock();
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
> +		/*
> +		 * For every charge from the cgroup, increment reference count
> +		 */
> +		css_get(&mem->css);
> +#endif /* CONFIG_CGROUP_MEM_RES_CTLR */
> +		rcu_read_unlock();
> +	} else {
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +		mem = memcg;
> +		css_get(&memcg->css);
> +#endif /* CONFIG_CGROUP_MEM_RES_CTLR */
> +	}
> +
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
> +		if (!(gfp_mask & __GFP_WAIT))
> +			goto out;
> +
> +		if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
> +			continue;
> +
> +		/*
> +		 * try_to_free_mem_cgroup_pages() might not give us a full
> +		 * picture of reclaim. Some pages are reclaimed and might be
> +		 * moved to swap cache or just unmapped from the cgroup.
> +		 * Check the limit again to see if the reclaim reduced the
> +		 * current usage of the cgroup before giving up
> +		 */
> +		if (res_counter_check_under_limit(&mem->res))
> +			continue;
> +
> +		if (!nr_retries--) {
> +			mem_cgroup_out_of_memory(mem, gfp_mask);
> +			goto out;
> +		}
> +	}
> +	pc->mem_cgroup = mem;
> +#endif /* CONFIG_CGROUP_MEM_RES_CTLR */

you can remove some ifdefs doing:

#ifdef CONFIG_CGROUP_MEM_RES_CTLR
	if (likely(!memcg)) {
		rcu_read_lock();
		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
		/*
		 * For every charge from the cgroup, increment reference count
		 */
		css_get(&mem->css);
		rcu_read_unlock();
	} else {
		mem = memcg;
		css_get(&memcg->css);
	}
	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
		if (!(gfp_mask & __GFP_WAIT))
			goto out;

		if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
			continue;

		/*
		 * try_to_free_mem_cgroup_pages() might not give us a full
		 * picture of reclaim. Some pages are reclaimed and might be
		 * moved to swap cache or just unmapped from the cgroup.
		 * Check the limit again to see if the reclaim reduced the
		 * current usage of the cgroup before giving up
		 */
		if (res_counter_check_under_limit(&mem->res))
			continue;

		if (!nr_retries--) {
			mem_cgroup_out_of_memory(mem, gfp_mask);
			goto out;
		}
	}
	pc->mem_cgroup = mem;
#endif /* CONFIG_CGROUP_MEM_RES_CTLR */

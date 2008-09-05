Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYIEIfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYIEIfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYIEIfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:35:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40010 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYIEIfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:35:06 -0400
Date: Fri, 5 Sep 2008 17:40:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Hugh Dickins <hugh@veritas.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "menage@google.com" <menage@google.com>
Subject: Re: [PATCH][mmotm]memcg: handle null dereference of mm->owner
Message-Id: <20080905174021.9fa29b01.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080905165017.b2715fe4.nishimura@mxp.nes.nec.co.jp>
References: <20080905165017.b2715fe4.nishimura@mxp.nes.nec.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 16:50:17 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Hi.
> 
> mm_update_next_owner() may clear mm->owner to NULL
> if it races with swapoff, page migration, etc.
> (This behavior was introduced by mm-owner-fix-race-between-swap-and-exit.patch.)
> 
> But memcg doesn't take account of this situation, and causes:
> 
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000630
> 
> This fixes it.
> 
Thank you for catching this.

BTW, I have a question to Balbir and Paul. (I'm sorry I missed the discussion.)
Recently I wonder why we need MM_OWNER.

- What's bad with thread's cgroup ?
- Why we can't disallow per-thread cgroup under memcg ?)

Thanks,
-Kame


> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> ---
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2979d22..ec2c16b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -244,6 +244,14 @@ static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
>  
>  struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
>  {
> +	/*
> +	 * mm_update_next_owner() may clear mm->owner to NULL
> +	 * if it races with swapoff, page migration, etc.
> +	 * So this can be called with p == NULL.
> +	 */
> +	if (unlikely(!p))
> +		return NULL;
> +
>  	return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
>  				struct mem_cgroup, css);
>  }
> @@ -534,6 +542,11 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
>  	if (likely(!memcg)) {
>  		rcu_read_lock();
>  		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
> +		if (unlikely(!mem)) {
> +			rcu_read_unlock();
> +			kmem_cache_free(page_cgroup_cache, pc);
> +			return 0;
> +		}
>  		/*
>  		 * For every charge from the cgroup, increment reference count
>  		 */
> @@ -790,6 +803,10 @@ int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
>  
>  	rcu_read_lock();
>  	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
> +	if (unlikely(!mem)) {
> +		rcu_read_unlock();
> +		return 0;
> +	}
>  	css_get(&mem->css);
>  	rcu_read_unlock();
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


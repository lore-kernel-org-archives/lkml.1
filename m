Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbXLTKTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbXLTKTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 05:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXLTKTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 05:19:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45592 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXLTKTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 05:19:03 -0500
Date: Thu, 20 Dec 2007 19:21:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Memory controller use rcu_read_lock() in
 mem_cgroup_cache_charge()
Message-Id: <20071220192119.0e0472b0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071220090152.19793.46738.sendpatchset@balbir-laptop>
References: <20071220090152.19793.46738.sendpatchset@balbir-laptop>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 14:31:52 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> 
> Hugh Dickins noticed that we were using rcu_dereference() without
> rcu_read_lock() in the cache charging routine. The patch below fixes
> this problem
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  mm/memcontrol.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff -puN mm/memcontrol.c~memory-controller-use-rcu-lead-lock mm/memcontrol.c
> --- linux-2.6.24-rc5/mm/memcontrol.c~memory-controller-use-rcu-lead-lock	2007-12-19 11:52:44.000000000 +0530
> +++ linux-2.6.24-rc5-balbir/mm/memcontrol.c	2007-12-20 14:01:45.000000000 +0530
> @@ -717,16 +717,20 @@ int mem_cgroup_charge(struct page *page,
>  int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
>  				gfp_t gfp_mask)
>  {
> +	int ret = 0;
>  	struct mem_cgroup *mem;
>  	if (!mm)
>  		mm = &init_mm;
>  
> +	rcu_read_lock();
>  	mem = rcu_dereference(mm->mem_cgroup);
> +	css_get(&mem->css);
> +	rcu_read_unlock();
>  	if (mem->control_type == MEM_CGROUP_TYPE_ALL)
> -		return mem_cgroup_charge_common(page, mm, gfp_mask,
> +		ret = mem_cgroup_charge_common(page, mm, gfp_mask,
>  				MEM_CGROUP_CHARGE_TYPE_CACHE);
> -	else
> -		return 0;
> +	css_put(&mem->css);
> +	return ret;
>  }
>  
>  /*
> _
Seems reasonable to me.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks,
-Kame


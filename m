Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbZDPMEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbZDPMEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 08:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZDPMEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 08:04:06 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:54693 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZDPMEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 08:04:05 -0400
Date: Thu, 16 Apr 2009 17:33:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add file based RSS accounting for memory resource
	controller (v2)
Message-ID: <20090416120316.GG7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090415120510.GX7082@balbir.in.ibm.com> <20090416095303.b4106e9f.kamezawa.hiroyu@jp.fujitsu.com> <20090416015955.GB7082@balbir.in.ibm.com> <20090416110246.c3fef293.kamezawa.hiroyu@jp.fujitsu.com> <20090416164036.03d7347a.kamezawa.hiroyu@jp.fujitsu.com> <20090416171535.cfc4ca84.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090416171535.cfc4ca84.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-16 17:15:35]:

> 
> > Sorry, some troubles found. Ignore above Ack. 3points now.
> > 
> > 1. get_cpu should be after (*)
> > ==mem_cgroup_update_mapped_file_stat()
> > +	int cpu = get_cpu();
> > +
> > +	if (!page_is_file_cache(page))
> > +		return;
> > +
> > +	if (unlikely(!mm))
> > +		mm = &init_mm;
> > +
> > +	mem = try_get_mem_cgroup_from_mm(mm);
> > +	if (!mem)
> > +		return;
> > + ----------------------------------------(*)
> > +	stat = &mem->stat;
> > +	cpustat = &stat->cpustat[cpu];
> > +
> > +	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, val);
> > +	put_cpu();
> > +}
> > ==

Yes or I should have a goto

> > 
> > 2. In above, "mem" shouldn't be got from "mm"....please get "mem" from page_cgroup.
> > (Because it's file cache, pc->mem_cgroup is not NULL always.)

Hmmm.. not sure I understand this part. Are you suggesting that mm can
be NULL? I added the check for !mm as a safety check. Since this
routine is only called from rmap context, mm is not NULL, hence mem
should not be NULL. Did you find a race between mm->owner assignment
and lookup via mm->owner?

> > 
> > I saw this very easily.
> > ==
> > Cache: 4096
> > mapped_file: 20480
> > ==
> > 
> > 3. at force_empty().
> > ==
> > +
> > +	cpu = get_cpu();
> > +	/* Update mapped_file data for mem_cgroup "from" */
> > +	stat = &from->stat;
> > +	cpustat = &stat->cpustat[cpu];
> > +	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, -1);
> > +
> > +	/* Update mapped_file data for mem_cgroup "to" */
> > +	stat = &to->stat;
> > +	cpustat = &stat->cpustat[cpu];
> > +	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, 1);
> > +	put_cpu();
> > 
> > This just breaks counter when page is not mapped. please check page_mapped().
> > 
> > like this:
> > ==
> >     if (page_is_file_cache(page) && page_mapped(page)) {
> > 	modify counter.
> >     }
>

Oh! yeah.. 

 > ==
> > 
> > and call lock_page_cgroup() in  mem_cgroup_update_mapped_file_stat().
> > 
> > This will be slow, but optimization will be very tricky and need some amount of time.
> > 
> 
> This is my fix for above 3 problems. but plz do as you like.
> I'm not very intersted in details.
> ==
> 
> ---
> Index: mmotm-2.6.30-Apr14/mm/memcontrol.c
> ===================================================================
> --- mmotm-2.6.30-Apr14.orig/mm/memcontrol.c
> +++ mmotm-2.6.30-Apr14/mm/memcontrol.c
> @@ -322,33 +322,39 @@ static bool mem_cgroup_is_obsolete(struc
>  	return css_is_removed(&mem->css);
>  }
> 
> -/*
> - * Currently used to update mapped file statistics, but the routine can be
> - * generalized to update other statistics as well.
> - */
> -void mem_cgroup_update_mapped_file_stat(struct page *page, struct mm_struct *mm,
> -					int val)
> +void mem_cgroup_update_mapped_file_stat(struct page *page, bool map)
>  {
>  	struct mem_cgroup *mem;
>  	struct mem_cgroup_stat *stat;
>  	struct mem_cgroup_stat_cpu *cpustat;
> -	int cpu = get_cpu();
> +	struct page_cgroup *pc;
> +	int cpu;
> 
>  	if (!page_is_file_cache(page))
>  		return;
> 
> -	if (unlikely(!mm))
> -		mm = &init_mm;
> -
> -	mem = try_get_mem_cgroup_from_mm(mm);
> -	if (!mem)
> +	pc = lookup_page_cgroup(page);
> +	if (unlikely(!pc))
>  		return;
> -
> -	stat = &mem->stat;
> -	cpustat = &stat->cpustat[cpu];
> -
> -	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, val);
> -	put_cpu();
> +	lock_page_cgroup(pc);
> +	mem = pc->mem_cgroup;
> +	if (mem) {
> +		cpu = get_cpu();
> +		stat = &mem->stat;
> +		cpustat = &stat->cpustat[cpu];
> +		if (map)
> +			__mem_cgroup_stat_add_safe(cpustat,
> +				MEM_CGROUP_STAT_MAPPED_FILE, 1);
> +		else
> +			__mem_cgroup_stat_add_safe(cpustat,
> +				MEM_CGROUP_STAT_MAPPED_FILE, -1);
> +		put_cpu();
> +	}
> +	if (map)
> +		SetPageCgroupMapped(pc);
> +	else
> +		ClearPageCgroupMapped(pc);
> +	unlock_page_cgroup(pc);
>  }
> 
>  /*
> @@ -1149,17 +1155,19 @@ static int mem_cgroup_move_account(struc
>  	res_counter_uncharge(&from->res, PAGE_SIZE);
>  	mem_cgroup_charge_statistics(from, pc, false);
> 
> -	cpu = get_cpu();
> -	/* Update mapped_file data for mem_cgroup "from" */
> -	stat = &from->stat;
> -	cpustat = &stat->cpustat[cpu];
> -	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, -1);
> -
> -	/* Update mapped_file data for mem_cgroup "to" */
> -	stat = &to->stat;
> -	cpustat = &stat->cpustat[cpu];
> -	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, 1);
> -	put_cpu();
> +	if (PageCgroupMapped(pc)) {
> +		cpu = get_cpu();
> +		/* Update mapped_file data for mem_cgroup "from" and "to" */
> +		stat = &from->stat;
> +		cpustat = &stat->cpustat[cpu];
> +		__mem_cgroup_stat_add_safe(cpustat,
> +				MEM_CGROUP_STAT_MAPPED_FILE, -1);
> +		stat = &to->stat;
> +		cpustat = &stat->cpustat[cpu];
> +		__mem_cgroup_stat_add_safe(cpustat,
> +				MEM_CGROUP_STAT_MAPPED_FILE, 1);
> +		put_cpu();
> +	}
> 
>  	if (do_swap_account)
>  		res_counter_uncharge(&from->memsw, PAGE_SIZE);
> Index: mmotm-2.6.30-Apr14/include/linux/page_cgroup.h
> ===================================================================
> --- mmotm-2.6.30-Apr14.orig/include/linux/page_cgroup.h
> +++ mmotm-2.6.30-Apr14/include/linux/page_cgroup.h
> @@ -26,6 +26,7 @@ enum {
>  	PCG_LOCK,  /* page cgroup is locked */
>  	PCG_CACHE, /* charged as cache */
>  	PCG_USED, /* this object is in use. */
> +	PCG_MAPPED, /* mapped file cache */
>  };
> 
>  #define TESTPCGFLAG(uname, lname)			\
> @@ -46,6 +47,10 @@ TESTPCGFLAG(Cache, CACHE)
>  TESTPCGFLAG(Used, USED)
>  CLEARPCGFLAG(Used, USED)
> 
> +TESTPCGFLAG(Mapped, USED)
> +CLEARPCGFLAG(Mapped, USED)
> +SETPCGFLAG(Mapped, USED)
> +
>  static inline int page_cgroup_nid(struct page_cgroup *pc)
>  {
>  	return page_to_nid(pc->page);
> Index: mmotm-2.6.30-Apr14/include/linux/memcontrol.h
> ===================================================================
> --- mmotm-2.6.30-Apr14.orig/include/linux/memcontrol.h
> +++ mmotm-2.6.30-Apr14/include/linux/memcontrol.h
> @@ -116,8 +116,7 @@ static inline bool mem_cgroup_disabled(v
>  }
> 
>  extern bool mem_cgroup_oom_called(struct task_struct *task);
> -void mem_cgroup_update_mapped_file_stat(struct page *page, struct mm_struct *mm,
> -					int val);
> +void mem_cgroup_update_mapped_file_stat(struct page *page, bool map);
>  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
>  struct mem_cgroup;
> 
> @@ -266,8 +265,7 @@ mem_cgroup_print_oom_info(struct mem_cgr
>  }
> 
>  static inline void mem_cgroup_update_mapped_file_stat(struct page *page,
> -							struct mm_struct *mm,
> -							int val)
> +							bool map)
>  {
>  }
> 
> Index: mmotm-2.6.30-Apr14/mm/rmap.c
> ===================================================================
> --- mmotm-2.6.30-Apr14.orig/mm/rmap.c
> +++ mmotm-2.6.30-Apr14/mm/rmap.c
> @@ -690,7 +690,7 @@ void page_add_file_rmap(struct page *pag
>  {
>  	if (atomic_inc_and_test(&page->_mapcount)) {
>  		__inc_zone_page_state(page, NR_FILE_MAPPED);
> -		mem_cgroup_update_mapped_file_stat(page, vma->vm_mm, 1);
> +		mem_cgroup_update_mapped_file_stat(page, true);
>  	}
>  }
> 
> @@ -740,7 +740,7 @@ void page_remove_rmap(struct page *page,
>  			mem_cgroup_uncharge_page(page);
>  		__dec_zone_page_state(page,
>  			PageAnon(page) ? NR_ANON_PAGES : NR_FILE_MAPPED);
> -		mem_cgroup_update_mapped_file_stat(page, vma->vm_mm, -1);
> +		mem_cgroup_update_mapped_file_stat(page, false);
>  		/*
>  		 * It would be tidy to reset the PageAnon mapping here,
>  		 * but that might overwrite a racing page_add_anon_rmap
> 
> 
> 
> 
> 
> 

-- 
	Balbir

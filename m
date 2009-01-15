Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbZAOLa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbZAOLa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZAOLas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:30:48 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:41996 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbZAOLar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:30:47 -0500
Date: Thu, 15 Jan 2009 17:00:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, menage@google.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] mark_page_accessed() in do_swap_page() move latter
	than memcg charge
Message-ID: <20090115113037.GH30358@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090109043257.GB9737@balbir.in.ibm.com> <20090109134736.a995fc49.kamezawa.hiroyu@jp.fujitsu.com> <20090115200545.EBE6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090115200545.EBE6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-01-15 20:08:36]:

> 
> sorry for late responce.
> 
> > > In this case we've hit a case where the page is valid and the pc is
> > > not. This does fix the problem, but won't this impact us getting
> > > correct reclaim stats and thus indirectly impact the working of
> > > pressure?
> > > 
> >  - If retruns NULL, only global LRU's status is updated. 
> > 
> > Because this page is not belongs to any memcg, we cannot update
> > any counters. But yes, your point is a concern.
> > 
> > Maybe moving acitvate_page() to
> > ==
> > do_swap_page()
> > {
> >     
> > - activate_page()
> >    mem_cgroup_try_charge()..
> >    ....
> >    mem_cgroup_commit_charge()....
> >    ....
> > +  activate_page()   
> > }
> > ==
> > is necessary. How do you think, kosaki ?
> 
> 
> OK. it makes sense. and my test found no bug.
> 
> ==
> 
> mark_page_accessed() update reclaim_stat statics.
> but currently, memcg charge is called after mark_page_accessed().
> 
> then, mark_page_accessed() don't update memcg statics correctly.
> 
> fixing here.
> 

Changelog needs to be a bit more elaborate, may be talk about invalid
pointer we hit if mark_page_accessed is not moved, etc.

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> ---
>  mm/memory.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/mm/memory.c
> ===================================================================
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2426,8 +2426,6 @@ static int do_swap_page(struct mm_struct
>  		count_vm_event(PGMAJFAULT);
>  	}
> 
> -	mark_page_accessed(page);
> -
>  	lock_page(page);
>  	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
> 
> @@ -2480,6 +2478,8 @@ static int do_swap_page(struct mm_struct
>  		try_to_free_swap(page);
>  	unlock_page(page);
> 
> +	mark_page_accessed(page);
> +
>  	if (write_access) {
>  		ret |= do_wp_page(mm, vma, address, page_table, pmd, ptl, pte);
>  		if (ret & VM_FAULT_ERROR)
> 
> 
>

Looks good to me otherwise

Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com> 

-- 
	Balbir

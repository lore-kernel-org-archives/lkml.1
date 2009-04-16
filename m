Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZDPD0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZDPD0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 23:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZDPD01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 23:26:27 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60855 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDPD01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 23:26:27 -0400
Date: Thu, 16 Apr 2009 08:55:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg remove warning at DEBUG_VM=off
Message-ID: <20090416032545.GD7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090408142042.3fb62eea.kamezawa.hiroyu@jp.fujitsu.com> <20090408052715.GX7082@balbir.in.ibm.com> <20090409222512.bd026a40.akpm@linux-foundation.org> <20090410153335.b52c5f74.kamezawa.hiroyu@jp.fujitsu.com> <20090415101317.GA3240@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090415101317.GA3240@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi <righi.andrea@gmail.com> [2009-04-15 12:13:17]:

> On Fri, Apr 10, 2009 at 03:33:35PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 9 Apr 2009 22:25:12 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Wed, 8 Apr 2009 10:57:15 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-08 14:20:42]:
> > > > 
> > > > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > > > This is against 2.6.30-rc1. (maybe no problem against mmotm.)
> > > > > 
> > > > > ==
> > > > > Fix warning as
> > > > > 
> > > > >   CC      mm/memcontrol.o
> > > > > mm/memcontrol.c:318: warning: ?$B!Fmem_cgroup_is_obsolete?$B!G defined but not used
> > > > > 
> > > > > This is called only from VM_BUG_ON().
> > > > > 
> > > > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > > > ---
> > > > > Index: linux-2.6.30-rc1/mm/memcontrol.c
> > > > > ===================================================================
> > > > > --- linux-2.6.30-rc1.orig/mm/memcontrol.c
> > > > > +++ linux-2.6.30-rc1/mm/memcontrol.c
> > > > > @@ -314,13 +314,14 @@ static struct mem_cgroup *try_get_mem_cg
> > > > >  	return mem;
> > > > >  }
> > > > > 
> > > > > +#ifdef CONFIG_DEBUG_VM
> > > > >  static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
> > > > >  {
> > > > >  	if (!mem)
> > > > >  		return true;
> > > > >  	return css_is_removed(&mem->css);
> > > > >  }
> > > > > -
> > > > > +#endif
> > > > 
> > > > Can we change the code to use
> > > > 
> > > >         VM_BUG_ON(!mem || css_is_removed(&mem->css));
> > > > 
> > > 
> > > yup.
> > > 
> > > --- a/mm/memcontrol.c~memcg-remove-warning-when-config_debug_vm=n-fix
> > > +++ a/mm/memcontrol.c
> > > @@ -314,14 +314,13 @@ static struct mem_cgroup *try_get_mem_cg
> > >  	return mem;
> > >  }
> > >  
> > > -#ifdef CONFIG_DEBUG_VM
> > >  static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
> > >  {
> > >  	if (!mem)
> > >  		return true;
> > >  	return css_is_removed(&mem->css);
> > >  }
> > > -#endif
> > > +
> > >  
> > >  /*
> > >   * Call callback function against all cgroup under hierarchy tree.
> > > @@ -933,7 +932,7 @@ static int __mem_cgroup_try_charge(struc
> > >  	if (unlikely(!mem))
> > >  		return 0;
> > >  
> > > -	VM_BUG_ON(mem_cgroup_is_obsolete(mem));
> > > +	VM_BUG_ON(!mem || mem_cgroup_is_obsolete(mem));
> > >  
> > >  	while (1) {
> > >  		int ret;
> > > _
> > > 
> > > Although it really should be
> > > 
> > > 	VM_BUG_ON(!mem);
> > > 	VM_BUG_ON(mem_cgroup_is_obsolete(mem));
> > > 
> > > because if that BUG triggers, you'll be wondering which case caused it.
> > > 
> > Ah, sorry, I missed the reply.
> > maybe calling css_is_removed() directly is a choice.
> > I'll prepare v2.
> > 
> > Regards,
> > -Kame
> 
> The warning is still there actually. I've just written a fix and seen
> this discussion, maybe I can offload a little bit Kame. ;)
> 
> -Andrea
> ---
> memcg: remove warning when CONFIG_DEBUG_VM is not set
> 
> Fix the following warning removing mem_cgroup_is_obsolete():
> 
>   mm/memcontrol.c:318: warning: ???mem_cgroup_is_obsolete??? defined but not used
> 
> Moreover, split the VM_BUG_ON() checks in two parts to be aware of which
> one triggered the bug.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  mm/memcontrol.c |   11 ++---------
>  1 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e44fb0f..8cd6358 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -314,14 +314,6 @@ static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
>  	return mem;
>  }
> 
> -static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
> -{
> -	if (!mem)
> -		return true;
> -	return css_is_removed(&mem->css);
> -}
> -
> -
>  /*
>   * Call callback function against all cgroup under hierarchy tree.
>   */
> @@ -932,7 +924,8 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  	if (unlikely(!mem))
>  		return 0;
> 
> -	VM_BUG_ON(!mem || mem_cgroup_is_obsolete(mem));
> +	VM_BUG_ON(!mem);
> +	VM_BUG_ON(css_is_removed(&mem->css));
>

Perfect, this is exactly what I wanted. I was in the middle of writing
this patch.

 
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Balbir

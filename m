Return-Path: <linux-kernel-owner+w=401wt.eu-S937949AbZDJGfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937949AbZDJGfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937819AbZDJGfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:35:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36272 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937776AbZDJGfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:35:10 -0400
Date: Fri, 10 Apr 2009 15:33:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@linux.vnet.ibm.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg remove warning at DEBUG_VM=off
Message-Id: <20090410153335.b52c5f74.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090409222512.bd026a40.akpm@linux-foundation.org>
References: <20090408142042.3fb62eea.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408052715.GX7082@balbir.in.ibm.com>
	<20090409222512.bd026a40.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009 22:25:12 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 8 Apr 2009 10:57:15 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-08 14:20:42]:
> > 
> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > This is against 2.6.30-rc1. (maybe no problem against mmotm.)
> > > 
> > > ==
> > > Fix warning as
> > > 
> > >   CC      mm/memcontrol.o
> > > mm/memcontrol.c:318: warning: ?$B!Fmem_cgroup_is_obsolete?$B!G defined but not used
> > > 
> > > This is called only from VM_BUG_ON().
> > > 
> > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > ---
> > > Index: linux-2.6.30-rc1/mm/memcontrol.c
> > > ===================================================================
> > > --- linux-2.6.30-rc1.orig/mm/memcontrol.c
> > > +++ linux-2.6.30-rc1/mm/memcontrol.c
> > > @@ -314,13 +314,14 @@ static struct mem_cgroup *try_get_mem_cg
> > >  	return mem;
> > >  }
> > > 
> > > +#ifdef CONFIG_DEBUG_VM
> > >  static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
> > >  {
> > >  	if (!mem)
> > >  		return true;
> > >  	return css_is_removed(&mem->css);
> > >  }
> > > -
> > > +#endif
> > 
> > Can we change the code to use
> > 
> >         VM_BUG_ON(!mem || css_is_removed(&mem->css));
> > 
> 
> yup.
> 
> --- a/mm/memcontrol.c~memcg-remove-warning-when-config_debug_vm=n-fix
> +++ a/mm/memcontrol.c
> @@ -314,14 +314,13 @@ static struct mem_cgroup *try_get_mem_cg
>  	return mem;
>  }
>  
> -#ifdef CONFIG_DEBUG_VM
>  static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
>  {
>  	if (!mem)
>  		return true;
>  	return css_is_removed(&mem->css);
>  }
> -#endif
> +
>  
>  /*
>   * Call callback function against all cgroup under hierarchy tree.
> @@ -933,7 +932,7 @@ static int __mem_cgroup_try_charge(struc
>  	if (unlikely(!mem))
>  		return 0;
>  
> -	VM_BUG_ON(mem_cgroup_is_obsolete(mem));
> +	VM_BUG_ON(!mem || mem_cgroup_is_obsolete(mem));
>  
>  	while (1) {
>  		int ret;
> _
> 
> Although it really should be
> 
> 	VM_BUG_ON(!mem);
> 	VM_BUG_ON(mem_cgroup_is_obsolete(mem));
> 
> because if that BUG triggers, you'll be wondering which case caused it.
> 
Ah, sorry, I missed the reply.
maybe calling css_is_removed() directly is a choice.
I'll prepare v2.

Regards,
-Kame


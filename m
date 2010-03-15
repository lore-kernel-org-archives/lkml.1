Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935649Ab0CODXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 23:23:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:46895 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934401Ab0CODXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 23:23:05 -0400
Subject: Re: [BUGFIX][PATCH] memcg: avoid use cmpxchg in swap cgroup
 maintainance (Was Re: 34-rc1-git3 build failure with
 CGROUP_MEM_RES_CTLR_SWAP=y
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Sachin Sant <sachinp@in.ibm.com>, nishimura@mxp.nes.nec.co.jp,
       lizf@cn.fujitsu.com, linux-kernel <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20100315100202.eb735f59.kamezawa.hiroyu@jp.fujitsu.com>
References: <4B9CBEE6.1090509@in.ibm.com>
	 <20100315100202.eb735f59.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 14:21:52 +1100
Message-ID: <1268623312.2209.108.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Oh..ok, powerpc (and other archs?) can't do 2byte cmpxchg and xchg.
> Then, we should use spinlock rather than that.
> 
> How about this ? Nishimura-san, could you consider something better ?
> We need a quick fix.

sparc64 is the same as powerpc in that regard, maybe others. 

Cheers,
Ben.

> ==
> swap_cgroup uses 2bytes data and uses cmpxchg in a new operation.
> 2byte cmpxchg/xchg is not available on some archs. This patch replaces
> cmpxchg/xchg with operations under lock.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/page_cgroup.c |   20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> Index: mmotm-2.6.34-Mar11/mm/page_cgroup.c
> ===================================================================
> --- mmotm-2.6.34-Mar11.orig/mm/page_cgroup.c
> +++ mmotm-2.6.34-Mar11/mm/page_cgroup.c
> @@ -284,6 +284,7 @@ static DEFINE_MUTEX(swap_cgroup_mutex);
>  struct swap_cgroup_ctrl {
>  	struct page **map;
>  	unsigned long length;
> +	spinlock_t	lock;
>  };
>  
>  struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
> @@ -353,16 +354,22 @@ unsigned short swap_cgroup_cmpxchg(swp_e
>  	struct swap_cgroup_ctrl *ctrl;
>  	struct page *mappage;
>  	struct swap_cgroup *sc;
> +	unsigned long flags;
> +	unsigned short retval;
>  
>  	ctrl = &swap_cgroup_ctrl[type];
>  
>  	mappage = ctrl->map[idx];
>  	sc = page_address(mappage);
>  	sc += pos;
> -	if (cmpxchg(&sc->id, old, new) == old)
> -		return old;
> +	spin_lock_irqsave(&ctrl->lock, flags);
> +	retval = sc->id;
> +	if (retval == old)
> +		sc->id = new;
>  	else
> -		return 0;
> +		retval = 0;
> +	spin_unlock_irqrestore(&ctrl->lock, flags);
> +	return retval;
>  }
>  
>  /**
> @@ -383,13 +390,17 @@ unsigned short swap_cgroup_record(swp_en
>  	struct page *mappage;
>  	struct swap_cgroup *sc;
>  	unsigned short old;
> +	unsigned long flags;
>  
>  	ctrl = &swap_cgroup_ctrl[type];
>  
>  	mappage = ctrl->map[idx];
>  	sc = page_address(mappage);
>  	sc += pos;
> -	old = xchg(&sc->id, id);
> +	spin_lock_irqsave(&ctrl->lock, flags);
> +	old = sc->id;
> +	sc->id = id;
> +	spin_unlock_irqrestore(&ctrl->lock, flags);
>  
>  	return old;
>  }
> @@ -441,6 +452,7 @@ int swap_cgroup_swapon(int type, unsigne
>  	mutex_lock(&swap_cgroup_mutex);
>  	ctrl->length = length;
>  	ctrl->map = array;
> +	spin_lock_init(&ctrl->lock);
>  	if (swap_cgroup_prepare(type)) {
>  		/* memory shortage */
>  		ctrl->map = NULL;
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev



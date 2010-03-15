Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935429Ab0CODOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 23:14:21 -0400
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.66]:60329 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab0CODOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 23:14:18 -0400
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Mon, 15 Mar 2010 12:16:51 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Sachin Sant <sachinp@in.ibm.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, nishimura@mxp.nes.nec.co.jp,
       lizf@cn.fujitsu.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       d-nishimura@mtf.biglobe.ne.jp
Subject: Re: [BUGFIX][PATCH] memcg: avoid use cmpxchg in swap cgroup
 maintainance (Was Re: 34-rc1-git3 build failure with
 CGROUP_MEM_RES_CTLR_SWAP=y
Message-Id: <20100315121651.23daf53f.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20100315100202.eb735f59.kamezawa.hiroyu@jp.fujitsu.com>
References: <4B9CBEE6.1090509@in.ibm.com>
	<20100315100202.eb735f59.kamezawa.hiroyu@jp.fujitsu.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 10:02:02 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Sun, 14 Mar 2010 16:18:06 +0530
> Sachin Sant <sachinp@in.ibm.com> wrote:
> 
> > On a PowerPC box, latest 34-rc1 git(d89b218b8...) fails to build
> > with CGROUPS_MEM_RES_CTRL_SWAP=y. 
> > 
> > LD      init/built-in.o
> > LD      .tmp_vmlinux1
> > mm/built-in.o: In function __xchg:
> > arch/powerpc/include/asm/system.h:331: undefined reference to .__xchg_called_with_bad_pointer
> > mm/built-in.o: In function __cmpxchg:
> > arch/powerpc/include/asm/system.h:474: undefined reference to .__cmpxchg_called_with_bad_pointer
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > The code in question was added via commit 024914477e...
> > 
> > memcg: move charges of anonymous swap
> > 
> Oh..ok, powerpc (and other archs?) can't do 2byte cmpxchg and xchg.
> Then, we should use spinlock rather than that.
> 
> How about this ? Nishimura-san, could you consider something better ?
> We need a quick fix.
> 
Thank you for fixing this issue.
I think it increases the size of swap_cgroup_ctrl a bit,
but I think it's a good fix.

> ==
> swap_cgroup uses 2bytes data and uses cmpxchg in a new operation.
> 2byte cmpxchg/xchg is not available on some archs. This patch replaces
> cmpxchg/xchg with operations under lock.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Thanks,
Daisuke Nishimura.
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

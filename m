Return-Path: <linux-kernel-owner+w=401wt.eu-S932422Ab0AGEdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab0AGEdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 23:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599Ab0AGEdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 23:33:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49448 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab0AGEdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 23:33:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 13:30:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm] build fix for
 memcg-move-charges-of-anonymous-swap.patch
Message-Id: <20100107133026.6350bd9d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107130609.31fe83dc.nishimura@mxp.nes.nec.co.jp>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100106171058.f1d6f393.randy.dunlap@oracle.com>
	<20100107111319.7d95fe86.nishimura@mxp.nes.nec.co.jp>
	<20100107112150.2e585f1c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107115901.594330d0.nishimura@mxp.nes.nec.co.jp>
	<20100107120233.f244d4b7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107130609.31fe83dc.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 13:06:09 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> build fix in !CONFIG_SWAP case.
> 
>   CC      mm/memcontrol.o
> mm/memcontrol.c: In function 'is_target_pte_for_mc':
> mm/memcontrol.c:3648: error: implicit declaration of function 'mem_cgroup_count_swap_user'
> make[1]: *** [mm/memcontrol.o] Error 1
> make: *** [mm] Error 2
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Hmm, this doesn't seem include fix for CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n
==
static int is_target_pte_for_mc(struct vm_area_struct *vma,
                unsigned long addr, pte_t ptent, union mc_target *target)
{
....
                else if (is_swap_pte(ptent)) {
                        ent = pte_to_swp_entry(ptent);
                        if (!move_anon || non_swap_entry(ent))
                                return 0;
                        usage_count = mem_cgroup_count_swap_user(ent, &page);
                }
==
At least, !do_swap_account check is necessary, I think.
I'm sorry if I miss something...

-Kame



> ---
> This can be applied after memcg-move-charges-of-anonymous-swap.patch.
> 
>  include/linux/swap.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index d9b06f7..2e1d5c9 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -287,6 +287,10 @@ extern int shmem_unuse(swp_entry_t entry, struct page *page);
>  
>  extern void swap_unplug_io_fn(struct backing_dev_info *, struct page *);
>  
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +extern int mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep);
> +#endif
> +
>  #ifdef CONFIG_SWAP
>  /* linux/mm/page_io.c */
>  extern int swap_readpage(struct page *);
> @@ -356,7 +360,6 @@ static inline void disable_swap_token(void)
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
>  extern void
>  mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
> -extern int mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep);
>  #else
>  static inline void
>  mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
> -- 
> 1.5.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


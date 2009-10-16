Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbZJPIEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbZJPIEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbZJPIEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:04:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59402 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959AbZJPIEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:04:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Oct 2009 17:01:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nitin Gupta <ngupta@vflare.org>, hongshin@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: call pte_unmap() against a proper pte (Re: [PATCH
 7/9] swap_info: swap count continuations)
Message-Id: <20091016170130.82cd4f26.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091016153056.6a1f4fe1.nishimura@mxp.nes.nec.co.jp>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
	<Pine.LNX.4.64.0910150153560.3291@sister.anvils>
	<20091016153056.6a1f4fe1.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009 15:30:56 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Hi.
> 
> > @@ -645,6 +648,7 @@ static int copy_pte_range(struct mm_stru
> >  	spinlock_t *src_ptl, *dst_ptl;
> >  	int progress = 0;
> >  	int rss[2];
> > +	swp_entry_t entry = (swp_entry_t){0};
> >  
> >  again:
> >  	rss[1] = rss[0] = 0;
> > @@ -671,7 +675,10 @@ again:
> >  			progress++;
> >  			continue;
> >  		}
> > -		copy_one_pte(dst_mm, src_mm, dst_pte, src_pte, vma, addr, rss);
> > +		entry.val = copy_one_pte(dst_mm, src_mm, dst_pte, src_pte,
> > +							vma, addr, rss);
> > +		if (entry.val)
> > +			break;
> >  		progress += 8;
> >  	} while (dst_pte++, src_pte++, addr += PAGE_SIZE, addr != end);
> >  
> It isn't the fault of only this patch, but I think breaking the loop without incrementing
> dst_pte(and src_pte) would be bad behavior because we do unmap_pte(dst_pte - 1) later.
> (current copy_pte_range() already does it though... and this is only problematic
> when we break the first loop, IIUC.)
> 

oh, yes. nice catch!

> > @@ -681,6 +688,12 @@ again:
> >  	add_mm_rss(dst_mm, rss[0], rss[1]);
> >  	pte_unmap_unlock(dst_pte - 1, dst_ptl);
> >  	cond_resched();
> > +
> > +	if (entry.val) {
> > +		if (add_swap_count_continuation(entry, GFP_KERNEL) < 0)
> > +			return -ENOMEM;
> > +		progress = 0;
> > +	}
> >  	if (addr != end)
> >  		goto again;
> >  	return 0;
> 
> I've searched other places where we break a similar loop and do pte_unmap(pte - 1).
> Current copy_pte_range() and apply_to_pte_range() has the same problem.
> 

> How about a patch like this ?
> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> There are some places where we do like:
> 
> 	pte = pte_map();
> 	do {
> 		(do break in some conditions)
> 	} while (pte++, ...);
> 	pte_unmap(pte - 1);
> 
> But if the loop breaks at the first loop, pte_unmap() unmaps invalid pte.
> 
> This patch is a fix for this problem.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

seems correct.

Reviewd-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/memory.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 72a2494..492de38 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -641,6 +641,7 @@ static int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		pmd_t *dst_pmd, pmd_t *src_pmd, struct vm_area_struct *vma,
>  		unsigned long addr, unsigned long end)
>  {
> +	pte_t *orig_src_pte, *orig_dst_pte;
>  	pte_t *src_pte, *dst_pte;
>  	spinlock_t *src_ptl, *dst_ptl;
>  	int progress = 0;
> @@ -654,6 +655,8 @@ again:
>  	src_pte = pte_offset_map_nested(src_pmd, addr);
>  	src_ptl = pte_lockptr(src_mm, src_pmd);
>  	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> +	orig_src_pte = src_pte;
> +	orig_dst_pte = dst_pte;
>  	arch_enter_lazy_mmu_mode();
>  
>  	do {
> @@ -677,9 +680,9 @@ again:
>  
>  	arch_leave_lazy_mmu_mode();
>  	spin_unlock(src_ptl);
> -	pte_unmap_nested(src_pte - 1);
> +	pte_unmap_nested(orig_src_pte);
>  	add_mm_rss(dst_mm, rss[0], rss[1]);
> -	pte_unmap_unlock(dst_pte - 1, dst_ptl);
> +	pte_unmap_unlock(orig_dst_pte, dst_ptl);
>  	cond_resched();
>  	if (addr != end)
>  		goto again;
> @@ -1822,10 +1825,10 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  	token = pmd_pgtable(*pmd);
>  
>  	do {
> -		err = fn(pte, token, addr, data);
> +		err = fn(pte++, token, addr, data);
>  		if (err)
>  			break;
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> +	} while (addr += PAGE_SIZE, addr != end);
>  
>  	arch_leave_lazy_mmu_mode();
>  
> 


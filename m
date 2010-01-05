Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832Ab0AEA3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0AEA3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095Ab0AEA3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:29:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34834 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0AEA3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:29:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Jan 2010 09:25:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-Id: <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100104182813.753545361@chello.nl>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jan 2010 19:24:35 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Generic speculative fault handler, tries to service a pagefault
> without holding mmap_sem.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


I'm sorry if I miss something...how does this patch series avoid
that vma is removed while __do_fault()->vma->vm_ops->fault() is called ?
("vma is removed" means all other things as freeing file struct etc..)

Thanks,
-Kame




> ---
>  include/linux/mm.h |    2 +
>  mm/memory.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 60 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/mm/memory.c
> ===================================================================
> --- linux-2.6.orig/mm/memory.c
> +++ linux-2.6/mm/memory.c
> @@ -1998,7 +1998,7 @@ again:
>  	if (!*ptep)
>  		goto out;
>  
> -	if (vma_is_dead(vma, seq))
> +	if (vma && vma_is_dead(vma, seq))
>  		goto unlock;
>  
>  	unpin_page_tables();
> @@ -3112,6 +3112,63 @@ int handle_mm_fault(struct mm_struct *mm
>  	return handle_pte_fault(mm, vma, address, entry, pmd, flags, 0);
>  }
>  
> +int handle_speculative_fault(struct mm_struct *mm, unsigned long address,
> +		unsigned int flags)
> +{
> +	pmd_t *pmd = NULL;
> +	pte_t *pte, entry;
> +	spinlock_t *ptl;
> +	struct vm_area_struct *vma;
> +	unsigned int seq;
> +	int ret = VM_FAULT_RETRY;
> +	int dead;
> +
> +	__set_current_state(TASK_RUNNING);
> +	flags |= FAULT_FLAG_SPECULATIVE;
> +
> +	count_vm_event(PGFAULT);
> +
> +	rcu_read_lock();
> +	if (!pte_map_lock(mm, NULL, address, pmd, flags, 0, &pte, &ptl))
> +		goto out_unlock;
> +
> +	vma = find_vma(mm, address);
> +
> +	if (!vma)
> +		goto out_unmap;
> +
> +	dead = RB_EMPTY_NODE(&vma->vm_rb);
> +	seq = vma->vm_sequence.sequence;
> +	/*
> +	 * Matches both the wmb in write_seqcount_begin/end() and
> +	 * the wmb in detach_vmas_to_be_unmapped()/__unlink_vma().
> +	 */
> +	smp_rmb();
> +	if (dead || seq & 1)
> +		goto out_unmap;
> +
> +	if (!(vma->vm_end > address && vma->vm_start <= address))
> +		goto out_unmap;
> +
> +	if (read_seqcount_retry(&vma->vm_sequence, seq))
> +		goto out_unmap;
> +
> +	entry = *pte;
> +
> +	pte_unmap_unlock(pte, ptl);
> +
> +	ret = handle_pte_fault(mm, vma, address, entry, pmd, flags, seq);
> +
> +out_unlock:
> +	rcu_read_unlock();
> +	return ret;
> +
> +out_unmap:
> +	pte_unmap_unlock(pte, ptl);
> +	goto out_unlock;
> +}
> +
> +
>  #ifndef __PAGETABLE_PUD_FOLDED
>  /*
>   * Allocate page upper directory.
> Index: linux-2.6/include/linux/mm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm.h
> +++ linux-2.6/include/linux/mm.h
> @@ -829,6 +829,8 @@ int invalidate_inode_page(struct page *p
>  #ifdef CONFIG_MMU
>  extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  			unsigned long address, unsigned int flags);
> +extern int handle_speculative_fault(struct mm_struct *mm,
> +			unsigned long address, unsigned int flags);
>  #else
>  static inline int handle_mm_fault(struct mm_struct *mm,
>  			struct vm_area_struct *vma, unsigned long address,
> 
> -- 
> 
> 


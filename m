Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbYGEJni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbYGEJni (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 05:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYGEJn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 05:43:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44470 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYGEJnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 05:43:24 -0400
Date: Sat, 05 Jul 2008 18:42:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC patch 05/12] LTTng instrumentation mm
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
       Dave Hansen <haveblue@us.ibm.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20080704235425.792630712@polymtl.ca>
References: <20080704235207.147809973@polymtl.ca> <20080704235425.792630712@polymtl.ca>
Message-Id: <20080705173449.98DF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Memory management core events.
> 
> Added tracepoints :
> 
> mm_filemap_wait_end
> mm_filemap_wait_start
> mm_handle_fault_entry
> mm_handle_fault_exit
> mm_huge_page_alloc
> mm_huge_page_free
> mm_page_alloc
> mm_page_free
> mm_swap_file_close
> mm_swap_file_open
> mm_swap_in
> mm_swap_out

Mathieu, this patch is too large and have multiple change.
memory subsystem have some feature and is developed by many people.

So, nobody can ack it.
Could you split to more small patch?

and, this patch description is very poor.

I guess

> mm_filemap_wait_end
> mm_filemap_wait_start
	for latency statics by lock_page delay

	if so, we should know who have locking.


> mm_handle_fault_entry
> mm_handle_fault_exit
	??
	please explain.

> mm_page_alloc
> mm_page_free
	for memory leak track
	for memory eater sort out
	etc..

> mm_huge_page_alloc
> mm_huge_page_free
	ditto
	(but, huge page is developed by another person against normal page alloc
	 so, patch separating is better)

> mm_swap_file_close
> mm_swap_file_open
	??
	What do you suppose usage?

> mm_swap_in
> mm_swap_out
	for swap usage statics
	for swap delay accounting


and, some tracepoint is putted on performance critical function.
So, you should write performance result in patch description.


> Index: linux-2.6-lttng/mm/filemap.c
> ===================================================================
> --- linux-2.6-lttng.orig/mm/filemap.c	2008-07-04 18:26:02.000000000 -0400
> +++ linux-2.6-lttng/mm/filemap.c	2008-07-04 18:26:37.000000000 -0400
> @@ -33,6 +33,7 @@
>  #include <linux/cpuset.h>
>  #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
>  #include <linux/memcontrol.h>
> +#include "mm-trace.h"
>  #include "internal.h"
>  
>  /*
> @@ -540,9 +541,11 @@ void wait_on_page_bit(struct page *page,
>  {
>  	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
>  
> +	trace_mm_filemap_wait_start(page, bit_nr);
>  	if (test_bit(bit_nr, &page->flags))
>  		__wait_on_bit(page_waitqueue(page), &wait, sync_page,
>  							TASK_UNINTERRUPTIBLE);
> +	trace_mm_filemap_wait_end(page, bit_nr);
>  }
>  EXPORT_SYMBOL(wait_on_page_bit);

looks good to me.


>  
> Index: linux-2.6-lttng/mm/memory.c
> ===================================================================
> --- linux-2.6-lttng.orig/mm/memory.c	2008-07-04 18:26:02.000000000 -0400
> +++ linux-2.6-lttng/mm/memory.c	2008-07-04 18:26:37.000000000 -0400
> @@ -51,6 +51,7 @@
>  #include <linux/init.h>
>  #include <linux/writeback.h>
>  #include <linux/memcontrol.h>
> +#include "mm-trace.h"
>  
>  #include <asm/pgalloc.h>
>  #include <asm/uaccess.h>
> @@ -2201,6 +2202,7 @@ static int do_swap_page(struct mm_struct
>  		/* Had to read the page from swap area: Major fault */
>  		ret = VM_FAULT_MAJOR;
>  		count_vm_event(PGMAJFAULT);
> +		trace_mm_swap_in(page, entry);
>  	}
>  
>  	if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {

somebody want get swapin delaying statics.
(see delayacct_set_flag() and delayacct_clear_flag())

if swap cache exist, swapin can end very faster.
otherwise, spend very long time.


> +	trace_mm_handle_fault_entry(address, write_access);
> +
>  	__set_current_state(TASK_RUNNING);
>  
>  	count_vm_event(PGFAULT);

mm or vma passing is better?
otherwise, adress is ambiguity.

> -	if (unlikely(is_vm_hugetlb_page(vma)))
> -		return hugetlb_fault(mm, vma, address, write_access);
> +	if (unlikely(is_vm_hugetlb_page(vma))) {
> +		res = hugetlb_fault(mm, vma, address, write_access);
> +		goto end;
> +	}
>  
>  	pgd = pgd_offset(mm, address);
>  	pud = pud_alloc(mm, pgd, address);
> -	if (!pud)
> -		return VM_FAULT_OOM;
> +	if (!pud) {
> +		res = VM_FAULT_OOM;
> +		goto end;
> +	}
>  	pmd = pmd_alloc(mm, pud, address);
> -	if (!pmd)
> -		return VM_FAULT_OOM;
> +	if (!pmd) {
> +		res = VM_FAULT_OOM;
> +		goto end;
> +	}
>  	pte = pte_alloc_map(mm, pmd, address);
> -	if (!pte)
> -		return VM_FAULT_OOM;
> +	if (!pte) {
> +		res = VM_FAULT_OOM;
> +		goto end;
> +	}
>  
> -	return handle_pte_fault(mm, vma, address, pte, pmd, write_access);
> +	res = handle_pte_fault(mm, vma, address, pte, pmd, write_access);
> +end:
> +	trace_mm_handle_fault_exit();
> +	return res;
>  }

no argument?
if two page fault happend in parallel, how do you sort out this two fault?

and, IMHO res variable is very important.
because it is OOM related.
many MM trouble shooting is worked for OOM related.


>  #ifndef __PAGETABLE_PUD_FOLDED
> Index: linux-2.6-lttng/mm/page_alloc.c
> ===================================================================
> --- linux-2.6-lttng.orig/mm/page_alloc.c	2008-07-04 18:26:02.000000000 -0400
> +++ linux-2.6-lttng/mm/page_alloc.c	2008-07-04 18:26:37.000000000 -0400
> @@ -46,6 +46,7 @@
>  #include <linux/page-isolation.h>
>  #include <linux/memcontrol.h>
>  #include <linux/debugobjects.h>
> +#include "mm-trace.h"
>  
>  #include <asm/tlbflush.h>
>  #include <asm/div64.h>
> @@ -510,6 +511,8 @@ static void __free_pages_ok(struct page 
>  	int i;
>  	int reserved = 0;
>  
> +	trace_mm_page_free(page, order);
> +
>  	for (i = 0 ; i < (1 << order) ; ++i)
>  		reserved += free_pages_check(page + i);
>  	if (reserved)
> @@ -966,6 +969,8 @@ static void free_hot_cold_page(struct pa
>  	struct per_cpu_pages *pcp;
>  	unsigned long flags;
>  
> +	trace_mm_page_free(page, 0);
> +
>  	if (PageAnon(page))
>  		page->mapping = NULL;
>  	if (free_pages_check(page))
> @@ -1630,6 +1635,7 @@ nopage:
>  		show_mem();
>  	}
>  got_pg:
> +	trace_mm_page_alloc(page, order);
>  	return page;
>  }
>  

please pass current task.
I guess somebody need memory allocation tracking.



> Index: linux-2.6-lttng/mm/page_io.c
> ===================================================================
> --- linux-2.6-lttng.orig/mm/page_io.c	2008-07-04 18:26:02.000000000 -0400
> +++ linux-2.6-lttng/mm/page_io.c	2008-07-04 18:26:37.000000000 -0400
> @@ -17,6 +17,7 @@
>  #include <linux/bio.h>
>  #include <linux/swapops.h>
>  #include <linux/writeback.h>
> +#include "mm-trace.h"
>  #include <asm/pgtable.h>
>  
>  static struct bio *get_swap_bio(gfp_t gfp_flags, pgoff_t index,
> @@ -114,6 +115,7 @@ int swap_writepage(struct page *page, st
>  		rw |= (1 << BIO_RW_SYNC);
>  	count_vm_event(PSWPOUT);
>  	set_page_writeback(page);
> +	trace_mm_swap_out(page);
>  	unlock_page(page);
>  	submit_bio(rw, bio);
>  out:

this tracepoint probe swapout starting, right.
So, Why you don't probe swapout end?



> Index: linux-2.6-lttng/mm/hugetlb.c
> ===================================================================
> --- linux-2.6-lttng.orig/mm/hugetlb.c	2008-07-04 18:26:02.000000000 -0400
> +++ linux-2.6-lttng/mm/hugetlb.c	2008-07-04 18:26:37.000000000 -0400
> @@ -14,6 +14,7 @@
>  #include <linux/mempolicy.h>
>  #include <linux/cpuset.h>
>  #include <linux/mutex.h>
> +#include "mm-trace.h"
>  
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
> @@ -141,6 +142,7 @@ static void free_huge_page(struct page *
>  	int nid = page_to_nid(page);
>  	struct address_space *mapping;
>  
> +	trace_mm_huge_page_free(page);
>  	mapping = (struct address_space *) page_private(page);
>  	set_page_private(page, 0);
>  	BUG_ON(page_count(page));
> @@ -509,6 +511,7 @@ static struct page *alloc_huge_page(stru
>  	if (!IS_ERR(page)) {
>  		set_page_refcounted(page);
>  		set_page_private(page, (unsigned long) mapping);
> +		trace_mm_huge_page_alloc(page);
>  	}
>  	return page;
>  }

this tracepoint probe to HugePages_Free change, right?
Why you don't probe HugePages_Total and HugePages_Rsvd change?


> Index: linux-2.6-lttng/mm/swapfile.c
> ===================================================================
> --- linux-2.6-lttng.orig/mm/swapfile.c	2008-07-04 18:26:02.000000000 -0400
> +++ linux-2.6-lttng/mm/swapfile.c	2008-07-04 18:26:37.000000000 -0400
> @@ -32,6 +32,7 @@
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
>  #include <linux/swapops.h>
> +#include "mm-trace.h"
>  
>  DEFINE_SPINLOCK(swap_lock);
>  unsigned int nr_swapfiles;

> @@ -1310,6 +1311,7 @@ asmlinkage long sys_swapoff(const char _
>  	swap_map = p->swap_map;
>  	p->swap_map = NULL;
>  	p->flags = 0;
> +	trace_mm_swap_file_close(swap_file);
>  	spin_unlock(&swap_lock);
>  	mutex_unlock(&swapon_mutex);
>  	vfree(swap_map);

Why you choose this point?
and why you don't pass pathname? (you pass it in sys_swapon()) 

IMHO try_to_unuse cause many memory activity and spend many time and 
often cause oom-killer.

I think this point log is needed by somebody.


> @@ -1695,6 +1697,7 @@ asmlinkage long sys_swapon(const char __
>  	} else {
>  		swap_info[prev].next = p - swap_info;
>  	}
> +	trace_mm_swap_file_open(swap_file, name);
>  	spin_unlock(&swap_lock);
>  	mutex_unlock(&swapon_mutex);
>  	error = 0;




Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbZKEBTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbZKEBTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 20:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbZKEBTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 20:19:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45827 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032AbZKEBTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 20:19:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Nov 2009 10:16:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic
Message-Id: <20091105101650.45204e4e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 14:14:41 -0500 (EST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> From: Christoph Lameter <cl@linux-foundation.org>
> Subject: Make mm counters per cpu
> 
> Changing the mm counters to per cpu counters is possible after the introduction
> of the generic per cpu operations (currently in percpu and -next).
> 
> With that the contention on the counters in mm_struct can be avoided. The
> USE_SPLIT_PTLOCKS case distinction can go away. Larger SMP systems do not
> need to perform atomic updates to mm counters anymore. Various code paths
> can be simplified since per cpu counter updates are fast and batching
> of counter updates is no longer needed.
> 
> One price to pay for these improvements is the need to scan over all percpu
> counters when the actual count values are needed.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 

Hmm, I don't fully understand _new_ percpu but...
In logical (even if not realistic), x86-32 supports up to 512 ? cpus in Kconfig.
BIGSMP.

Then, if 65536 process runs, this consumes

65536(nr_proc) * 8 (size) * 512(cpus) = 256MBytes.

But x86's vmalloc area just has 80? MBytes. I (and my customers) don't have
this kind of exteme machine, but cpus tend to be many-core (and still support
32bit mode), now.

If 32, 64 cpus,
65536 * 8 * 32 = 16MB
65536 * 8 * 32 = 32MB

And if I add swap_usage,
65536 * 12 * 32 = 24MB.

It's influenced by the number of deivces attached to the sysytem but
people will see more -ENOMEM.

It seems this consumption/footprint is very big.

Thanks,
-Kame





> ---
>  fs/proc/task_mmu.c       |   14 +++++++++-
>  include/linux/mm_types.h |   16 ++++--------
>  include/linux/sched.h    |   61 ++++++++++++++++++++---------------------------
>  kernel/fork.c            |   25 ++++++++++++++-----
>  mm/filemap_xip.c         |    2 -
>  mm/fremap.c              |    2 -
>  mm/init-mm.c             |    3 ++
>  mm/memory.c              |   20 +++++++--------
>  mm/rmap.c                |   10 +++----
>  mm/swapfile.c            |    2 -
>  10 files changed, 84 insertions(+), 71 deletions(-)
> 
> Index: linux-2.6/include/linux/mm_types.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm_types.h	2009-11-04 13:08:33.000000000 -0600
> +++ linux-2.6/include/linux/mm_types.h	2009-11-04 13:13:42.000000000 -0600
> @@ -24,11 +24,10 @@ struct address_space;
> 
>  #define USE_SPLIT_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
> 
> -#if USE_SPLIT_PTLOCKS
> -typedef atomic_long_t mm_counter_t;
> -#else  /* !USE_SPLIT_PTLOCKS */
> -typedef unsigned long mm_counter_t;
> -#endif /* !USE_SPLIT_PTLOCKS */
> +struct mm_counter {
> +	long file;
> +	long anon;
> +};
> 
>  /*
>   * Each physical page in the system has a struct page associated with
> @@ -223,11 +222,8 @@ struct mm_struct {
>  						 * by mmlist_lock
>  						 */
> 
> -	/* Special counters, in some configurations protected by the
> -	 * page_table_lock, in other configurations by being atomic.
> -	 */
> -	mm_counter_t _file_rss;
> -	mm_counter_t _anon_rss;
> +	/* Special percpu counters */
> +	struct mm_counter *rss;
> 
>  	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
>  	unsigned long hiwater_vm;	/* High-water virtual memory usage */
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h	2009-11-04 13:08:33.000000000 -0600
> +++ linux-2.6/include/linux/sched.h	2009-11-04 13:13:42.000000000 -0600
> @@ -385,41 +385,32 @@ arch_get_unmapped_area_topdown(struct fi
>  extern void arch_unmap_area(struct mm_struct *, unsigned long);
>  extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
> 
> -#if USE_SPLIT_PTLOCKS
> -/*
> - * The mm counters are not protected by its page_table_lock,
> - * so must be incremented atomically.
> - */
> -#define set_mm_counter(mm, member, value) atomic_long_set(&(mm)->_##member, value)
> -#define get_mm_counter(mm, member) ((unsigned long)atomic_long_read(&(mm)->_##member))
> -#define add_mm_counter(mm, member, value) atomic_long_add(value, &(mm)->_##member)
> -#define inc_mm_counter(mm, member) atomic_long_inc(&(mm)->_##member)
> -#define dec_mm_counter(mm, member) atomic_long_dec(&(mm)->_##member)
> -
> -#else  /* !USE_SPLIT_PTLOCKS */
> -/*
> - * The mm counters are protected by its page_table_lock,
> - * so can be incremented directly.
> - */
> -#define set_mm_counter(mm, member, value) (mm)->_##member = (value)
> -#define get_mm_counter(mm, member) ((mm)->_##member)
> -#define add_mm_counter(mm, member, value) (mm)->_##member += (value)
> -#define inc_mm_counter(mm, member) (mm)->_##member++
> -#define dec_mm_counter(mm, member) (mm)->_##member--
> -
> -#endif /* !USE_SPLIT_PTLOCKS */
> -
> -#define get_mm_rss(mm)					\
> -	(get_mm_counter(mm, file_rss) + get_mm_counter(mm, anon_rss))
> -#define update_hiwater_rss(mm)	do {			\
> -	unsigned long _rss = get_mm_rss(mm);		\
> -	if ((mm)->hiwater_rss < _rss)			\
> -		(mm)->hiwater_rss = _rss;		\
> -} while (0)
> -#define update_hiwater_vm(mm)	do {			\
> -	if ((mm)->hiwater_vm < (mm)->total_vm)		\
> -		(mm)->hiwater_vm = (mm)->total_vm;	\
> -} while (0)
> +static inline unsigned long get_mm_rss(struct mm_struct *mm)
> +{
> +	int cpu;
> +	unsigned long r = 0;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct mm_counter *c = per_cpu_ptr(mm->rss, cpu);
> +
> +		r = c->file + c->anon;
> +	}
> +
> +	return r;
> +}
> +
> +static inline void update_hiwater_rss(struct mm_struct *mm)
> +{
> +	unsigned long _rss = get_mm_rss(mm);
> +	if (mm->hiwater_rss < _rss)
> +		mm->hiwater_rss = _rss;
> +}
> +
> +static inline void update_hiwater_vm(struct mm_struct *mm)
> +{
> +	if (mm->hiwater_vm < mm->total_vm)
> +		mm->hiwater_vm = mm->total_vm;
> +}
> 
>  static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
>  {
> Index: linux-2.6/kernel/fork.c
> ===================================================================
> --- linux-2.6.orig/kernel/fork.c	2009-11-04 13:08:33.000000000 -0600
> +++ linux-2.6/kernel/fork.c	2009-11-04 13:14:19.000000000 -0600
> @@ -444,6 +444,8 @@ static void mm_init_aio(struct mm_struct
> 
>  static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
>  {
> +	int cpu;
> +
>  	atomic_set(&mm->mm_users, 1);
>  	atomic_set(&mm->mm_count, 1);
>  	init_rwsem(&mm->mmap_sem);
> @@ -452,8 +454,11 @@ static struct mm_struct * mm_init(struct
>  		(current->mm->flags & MMF_INIT_MASK) : default_dump_filter;
>  	mm->core_state = NULL;
>  	mm->nr_ptes = 0;
> -	set_mm_counter(mm, file_rss, 0);
> -	set_mm_counter(mm, anon_rss, 0);
> +	for_each_possible_cpu(cpu) {
> +		struct mm_counter *m;
> +
> +		memset(m, sizeof(struct mm_counter), 0);
> +	}
>  	spin_lock_init(&mm->page_table_lock);
>  	mm->free_area_cache = TASK_UNMAPPED_BASE;
>  	mm->cached_hole_size = ~0UL;
> @@ -480,7 +485,13 @@ struct mm_struct * mm_alloc(void)
>  	mm = allocate_mm();
>  	if (mm) {
>  		memset(mm, 0, sizeof(*mm));
> -		mm = mm_init(mm, current);
> +		mm->rss = alloc_percpu(struct mm_counter);
> +		if (mm->rss)
> +			mm = mm_init(mm, current);
> +		else {
> +			free_mm(mm);
> +			mm = NULL;
> +		}
>  	}
>  	return mm;
>  }
> @@ -496,6 +507,7 @@ void __mmdrop(struct mm_struct *mm)
>  	mm_free_pgd(mm);
>  	destroy_context(mm);
>  	mmu_notifier_mm_destroy(mm);
> +	free_percpu(mm->rss);
>  	free_mm(mm);
>  }
>  EXPORT_SYMBOL_GPL(__mmdrop);
> @@ -631,6 +643,9 @@ struct mm_struct *dup_mm(struct task_str
>  		goto fail_nomem;
> 
>  	memcpy(mm, oldmm, sizeof(*mm));
> +	mm->rss = alloc_percpu(struct mm_counter);
> +	if (!mm->rss)
> +		goto fail_nomem;
> 
>  	/* Initializing for Swap token stuff */
>  	mm->token_priority = 0;
> @@ -661,15 +676,13 @@ free_pt:
>  	mm->binfmt = NULL;
>  	mmput(mm);
> 
> -fail_nomem:
> -	return NULL;
> -
>  fail_nocontext:
>  	/*
>  	 * If init_new_context() failed, we cannot use mmput() to free the mm
>  	 * because it calls destroy_context()
>  	 */
>  	mm_free_pgd(mm);
> +fail_nomem:
>  	free_mm(mm);
>  	return NULL;
>  }
> Index: linux-2.6/fs/proc/task_mmu.c
> ===================================================================
> --- linux-2.6.orig/fs/proc/task_mmu.c	2009-11-04 13:08:33.000000000 -0600
> +++ linux-2.6/fs/proc/task_mmu.c	2009-11-04 13:13:42.000000000 -0600
> @@ -65,11 +65,21 @@ unsigned long task_vsize(struct mm_struc
>  int task_statm(struct mm_struct *mm, int *shared, int *text,
>  	       int *data, int *resident)
>  {
> -	*shared = get_mm_counter(mm, file_rss);
> +	int cpu;
> +	int anon_rss = 0;
> +	int file_rss = 0;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct mm_counter *c = per_cpu_ptr(mm->rss, cpu);
> +
> +		anon_rss += c->anon;
> +		file_rss += c->file;
> +	}
> +	*shared = file_rss;
>  	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
>  								>> PAGE_SHIFT;
>  	*data = mm->total_vm - mm->shared_vm;
> -	*resident = *shared + get_mm_counter(mm, anon_rss);
> +	*resident = *shared + anon_rss;
>  	return mm->total_vm;
>  }
> 
> Index: linux-2.6/mm/filemap_xip.c
> ===================================================================
> --- linux-2.6.orig/mm/filemap_xip.c	2009-11-04 13:08:33.000000000 -0600
> +++ linux-2.6/mm/filemap_xip.c	2009-11-04 13:13:42.000000000 -0600
> @@ -194,7 +194,7 @@ retry:
>  			flush_cache_page(vma, address, pte_pfn(*pte));
>  			pteval = ptep_clear_flush_notify(vma, address, pte);
>  			page_remove_rmap(page);
> -			dec_mm_counter(mm, file_rss);
> +			__this_cpu_dec(mm->rss->file);
>  			BUG_ON(pte_dirty(pteval));
>  			pte_unmap_unlock(pte, ptl);
>  			page_cache_release(page);
> Index: linux-2.6/mm/fremap.c
> ===================================================================
> --- linux-2.6.orig/mm/fremap.c	2009-11-04 13:08:33.000000000 -0600
> +++ linux-2.6/mm/fremap.c	2009-11-04 13:13:42.000000000 -0600
> @@ -40,7 +40,7 @@ static void zap_pte(struct mm_struct *mm
>  			page_remove_rmap(page);
>  			page_cache_release(page);
>  			update_hiwater_rss(mm);
> -			dec_mm_counter(mm, file_rss);
> +			__this_cpu_dec(mm->rss->file);
>  		}
>  	} else {
>  		if (!pte_file(pte))
> Index: linux-2.6/mm/memory.c
> ===================================================================
> --- linux-2.6.orig/mm/memory.c	2009-11-04 13:08:33.000000000 -0600
> +++ linux-2.6/mm/memory.c	2009-11-04 13:13:42.000000000 -0600
> @@ -379,9 +379,9 @@ int __pte_alloc_kernel(pmd_t *pmd, unsig
>  static inline void add_mm_rss(struct mm_struct *mm, int file_rss, int anon_rss)
>  {
>  	if (file_rss)
> -		add_mm_counter(mm, file_rss, file_rss);
> +		__this_cpu_add(mm->rss->file, file_rss);
>  	if (anon_rss)
> -		add_mm_counter(mm, anon_rss, anon_rss);
> +		__this_cpu_add(mm->rss->anon, anon_rss);
>  }
> 
>  /*
> @@ -1512,7 +1512,7 @@ static int insert_page(struct vm_area_st
> 
>  	/* Ok, finally just insert the thing.. */
>  	get_page(page);
> -	inc_mm_counter(mm, file_rss);
> +	__this_cpu_inc(mm->rss->file);
>  	page_add_file_rmap(page);
>  	set_pte_at(mm, addr, pte, mk_pte(page, prot));
> 
> @@ -2148,11 +2148,11 @@ gotten:
>  	if (likely(pte_same(*page_table, orig_pte))) {
>  		if (old_page) {
>  			if (!PageAnon(old_page)) {
> -				dec_mm_counter(mm, file_rss);
> -				inc_mm_counter(mm, anon_rss);
> +				__this_cpu_dec(mm->rss->file);
> +				__this_cpu_inc(mm->rss->anon);
>  			}
>  		} else
> -			inc_mm_counter(mm, anon_rss);
> +			__this_cpu_inc(mm->rss->anon);
>  		flush_cache_page(vma, address, pte_pfn(orig_pte));
>  		entry = mk_pte(new_page, vma->vm_page_prot);
>  		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> @@ -2579,7 +2579,7 @@ static int do_swap_page(struct mm_struct
>  	 * discarded at swap_free().
>  	 */
> 
> -	inc_mm_counter(mm, anon_rss);
> +	__this_cpu_inc(mm->rss->anon);
>  	pte = mk_pte(page, vma->vm_page_prot);
>  	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
>  		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
> @@ -2663,7 +2663,7 @@ static int do_anonymous_page(struct mm_s
>  	if (!pte_none(*page_table))
>  		goto release;
> 
> -	inc_mm_counter(mm, anon_rss);
> +	__this_cpu_inc(mm->rss->anon);
>  	page_add_new_anon_rmap(page, vma, address);
>  setpte:
>  	set_pte_at(mm, address, page_table, entry);
> @@ -2817,10 +2817,10 @@ static int __do_fault(struct mm_struct *
>  		if (flags & FAULT_FLAG_WRITE)
>  			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>  		if (anon) {
> -			inc_mm_counter(mm, anon_rss);
> +			__this_cpu_inc(mm->rss->anon);
>  			page_add_new_anon_rmap(page, vma, address);
>  		} else {
> -			inc_mm_counter(mm, file_rss);
> +			__this_cpu_inc(mm->rss->file);
>  			page_add_file_rmap(page);
>  			if (flags & FAULT_FLAG_WRITE) {
>  				dirty_page = page;
> Index: linux-2.6/mm/rmap.c
> ===================================================================
> --- linux-2.6.orig/mm/rmap.c	2009-11-04 13:08:33.000000000 -0600
> +++ linux-2.6/mm/rmap.c	2009-11-04 13:13:42.000000000 -0600
> @@ -809,9 +809,9 @@ static int try_to_unmap_one(struct page
> 
>  	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
>  		if (PageAnon(page))
> -			dec_mm_counter(mm, anon_rss);
> +			__this_cpu_dec(mm->rss->anon);
>  		else
> -			dec_mm_counter(mm, file_rss);
> +			__this_cpu_dec(mm->rss->file);
>  		set_pte_at(mm, address, pte,
>  				swp_entry_to_pte(make_hwpoison_entry(page)));
>  	} else if (PageAnon(page)) {
> @@ -829,7 +829,7 @@ static int try_to_unmap_one(struct page
>  					list_add(&mm->mmlist, &init_mm.mmlist);
>  				spin_unlock(&mmlist_lock);
>  			}
> -			dec_mm_counter(mm, anon_rss);
> +			__this_cpu_dec(mm->rss->anon);
>  		} else if (PAGE_MIGRATION) {
>  			/*
>  			 * Store the pfn of the page in a special migration
> @@ -847,7 +847,7 @@ static int try_to_unmap_one(struct page
>  		entry = make_migration_entry(page, pte_write(pteval));
>  		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
>  	} else
> -		dec_mm_counter(mm, file_rss);
> +		__this_cpu_dec(mm->rss->file);
> 
> 
>  	page_remove_rmap(page);
> @@ -967,7 +967,7 @@ static int try_to_unmap_cluster(unsigned
> 
>  		page_remove_rmap(page);
>  		page_cache_release(page);
> -		dec_mm_counter(mm, file_rss);
> +		__this_cpu_dec(mm->rss->file);
>  		(*mapcount)--;
>  	}
>  	pte_unmap_unlock(pte - 1, ptl);
> Index: linux-2.6/mm/swapfile.c
> ===================================================================
> --- linux-2.6.orig/mm/swapfile.c	2009-11-04 13:08:33.000000000 -0600
> +++ linux-2.6/mm/swapfile.c	2009-11-04 13:13:42.000000000 -0600
> @@ -831,7 +831,7 @@ static int unuse_pte(struct vm_area_stru
>  		goto out;
>  	}
> 
> -	inc_mm_counter(vma->vm_mm, anon_rss);
> +	__this_cpu_inc(vma->vm_mm->rss->anon);
>  	get_page(page);
>  	set_pte_at(vma->vm_mm, addr, pte,
>  		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
> Index: linux-2.6/mm/init-mm.c
> ===================================================================
> --- linux-2.6.orig/mm/init-mm.c	2009-11-04 13:08:33.000000000 -0600
> +++ linux-2.6/mm/init-mm.c	2009-11-04 13:13:42.000000000 -0600
> @@ -8,6 +8,8 @@
>  #include <asm/atomic.h>
>  #include <asm/pgtable.h>
> 
> +DEFINE_PER_CPU(struct mm_counter, init_mm_counters);
> +
>  struct mm_struct init_mm = {
>  	.mm_rb		= RB_ROOT,
>  	.pgd		= swapper_pg_dir,
> @@ -17,4 +19,5 @@ struct mm_struct init_mm = {
>  	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
>  	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
>  	.cpu_vm_mask	= CPU_MASK_ALL,
> +	.rss		= &init_mm_counters,
>  };
> 


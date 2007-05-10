Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbXEJUES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbXEJUES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbXEJUEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:04:06 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45228 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119AbXEJUEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:04:04 -0400
Date: Thu, 10 May 2007 21:03:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: slub-i386-support.patch
Message-ID: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 10 May 2007 20:03:59.0358 (UTC) FILETIME=[58FD01E0:01C7933E]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGFrQHN1c2UuZGUAbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwB0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZwBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAGNsYW1ldGVyQHNnaS5jb20Ad2xpQGhvbG9tb3JwaHkuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just want to report that I've been running SLUB on i386, both in -mm
and with slub-i386-support.patch applied to 2.6.21-git, and observed
no problems with it.  I'm anxious that it (or an equivalent) go into
2.6.22-rc1, i386 being now the last ARCH_USES_SLAB_PAGE_STRUCT holdout.

In the frenzy over PowerPC, maybe Linus overlooked that i386
was still not supporting SLUB; and I fear that once people get
"# CONFIG_SLUB is not set" into their .config, they're less likely to
switch over to testing CONFIG_SLUB=y - I remain anxious that it see
as much testing as possible (but under EXPERIMENTAL for 2.6.22, yes).

Though when I look at the patchset (copied below), I do wonder why
it puts a quicklist_trim() into i386's cpu_idle() and flush_tlb_mm():
neither is where I'd expect us to be secretly freeing pages.  Ah,
several arches do it in cpu_idle(): how odd, oh well.

Hugh

> From: Christoph Lameter <clameter@sgi.com>
> 
> SLUB cannot run on i386 at this point because i386 uses the page->private and
> page->index field of slab pages for the pgd cache.
> 
> Make SLUB run on i386 by replacing the pgd slab cache with a quicklist.
> Limit the changes as much as possible. Leave the improvised linked list in place
> etc etc. This has been working here for a couple of weeks now.
> 
> Acked-by: William Lee Irwin III <wli@holomorphy.com>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/i386/Kconfig          |    8 ++++----
>  arch/i386/kernel/process.c |    1 +
>  arch/i386/kernel/smp.c     |    2 +-
>  arch/i386/mm/init.c        |    7 -------
>  arch/i386/mm/pgtable.c     |   26 +++++++++++++++++---------
>  include/asm-i386/pgalloc.h |    2 --
>  include/asm-i386/pgtable.h |    5 ++---
>  7 files changed, 25 insertions(+), 26 deletions(-)
> 
> diff -puN arch/i386/Kconfig~slub-i386-support arch/i386/Kconfig
> --- a/arch/i386/Kconfig~slub-i386-support
> +++ a/arch/i386/Kconfig
> @@ -55,6 +55,10 @@ config ZONE_DMA
>  	bool
>  	default y
>  
> +config QUICKLIST
> +	bool
> +	default y
> +
>  config SBUS
>  	bool
>  
> @@ -79,10 +83,6 @@ config ARCH_MAY_HAVE_PC_FDC
>  	bool
>  	default y
>  
> -config ARCH_USES_SLAB_PAGE_STRUCT
> -	bool
> -	default y
> -
>  config DMI
>  	bool
>  	default y
> diff -puN arch/i386/kernel/process.c~slub-i386-support arch/i386/kernel/process.c
> --- a/arch/i386/kernel/process.c~slub-i386-support
> +++ a/arch/i386/kernel/process.c
> @@ -187,6 +187,7 @@ void cpu_idle(void)
>  			if (__get_cpu_var(cpu_idle_state))
>  				__get_cpu_var(cpu_idle_state) = 0;
>  
> +			check_pgt_cache();
>  			rmb();
>  			idle = pm_idle;
>  
> diff -puN arch/i386/kernel/smp.c~slub-i386-support arch/i386/kernel/smp.c
> --- a/arch/i386/kernel/smp.c~slub-i386-support
> +++ a/arch/i386/kernel/smp.c
> @@ -422,7 +422,7 @@ void flush_tlb_mm (struct mm_struct * mm
>  	}
>  	if (!cpus_empty(cpu_mask))
>  		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
> -
> +	check_pgt_cache();
>  	preempt_enable();
>  }
>  
> diff -puN arch/i386/mm/init.c~slub-i386-support arch/i386/mm/init.c
> --- a/arch/i386/mm/init.c~slub-i386-support
> +++ a/arch/i386/mm/init.c
> @@ -752,7 +752,6 @@ int remove_memory(u64 start, u64 size)
>  EXPORT_SYMBOL_GPL(remove_memory);
>  #endif
>  
> -struct kmem_cache *pgd_cache;
>  struct kmem_cache *pmd_cache;
>  
>  void __init pgtable_cache_init(void)
> @@ -776,12 +775,6 @@ void __init pgtable_cache_init(void)
>  			pgd_size = PAGE_SIZE;
>  		}
>  	}
> -	pgd_cache = kmem_cache_create("pgd",
> -				pgd_size,
> -				pgd_size,
> -				SLAB_PANIC,
> -				pgd_ctor,
> -				(!SHARED_KERNEL_PMD) ? pgd_dtor : NULL);
>  }
>  
>  /*
> diff -puN arch/i386/mm/pgtable.c~slub-i386-support arch/i386/mm/pgtable.c
> --- a/arch/i386/mm/pgtable.c~slub-i386-support
> +++ a/arch/i386/mm/pgtable.c
> @@ -13,6 +13,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/spinlock.h>
>  #include <linux/module.h>
> +#include <linux/quicklist.h>
>  
>  #include <asm/system.h>
>  #include <asm/pgtable.h>
> @@ -205,8 +206,6 @@ void pmd_ctor(void *pmd, struct kmem_cac
>   * against pageattr.c; it is the unique case in which a valid change
>   * of kernel pagetables can't be lazily synchronized by vmalloc faults.
>   * vmalloc faults work because attached pagetables are never freed.
> - * The locking scheme was chosen on the basis of manfred's
> - * recommendations and having no core impact whatsoever.
>   * -- wli
>   */
>  DEFINE_SPINLOCK(pgd_lock);
> @@ -232,9 +231,11 @@ static inline void pgd_list_del(pgd_t *p
>  		set_page_private(next, (unsigned long)pprev);
>  }
>  
> +
> +
>  #if (PTRS_PER_PMD == 1)
>  /* Non-PAE pgd constructor */
> -void pgd_ctor(void *pgd, struct kmem_cache *cache, unsigned long unused)
> +void pgd_ctor(void *pgd)
>  {
>  	unsigned long flags;
>  
> @@ -256,7 +257,7 @@ void pgd_ctor(void *pgd, struct kmem_cac
>  }
>  #else  /* PTRS_PER_PMD > 1 */
>  /* PAE pgd constructor */
> -void pgd_ctor(void *pgd, struct kmem_cache *cache, unsigned long unused)
> +void pgd_ctor(void *pgd)
>  {
>  	/* PAE, kernel PMD may be shared */
>  
> @@ -275,11 +276,12 @@ void pgd_ctor(void *pgd, struct kmem_cac
>  }
>  #endif	/* PTRS_PER_PMD */
>  
> -void pgd_dtor(void *pgd, struct kmem_cache *cache, unsigned long unused)
> +void pgd_dtor(void *pgd)
>  {
>  	unsigned long flags; /* can be called from interrupt context */
>  
> -	BUG_ON(SHARED_KERNEL_PMD);
> +	if (SHARED_KERNEL_PMD)
> +		return;
>  
>  	paravirt_release_pd(__pa(pgd) >> PAGE_SHIFT);
>  	spin_lock_irqsave(&pgd_lock, flags);
> @@ -321,7 +323,7 @@ static void pmd_cache_free(pmd_t *pmd, i
>  pgd_t *pgd_alloc(struct mm_struct *mm)
>  {
>  	int i;
> -	pgd_t *pgd = kmem_cache_alloc(pgd_cache, GFP_KERNEL);
> +	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
>  
>  	if (PTRS_PER_PMD == 1 || !pgd)
>  		return pgd;
> @@ -344,7 +346,7 @@ out_oom:
>  		paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
>  		pmd_cache_free(pmd, i);
>  	}
> -	kmem_cache_free(pgd_cache, pgd);
> +	quicklist_free(0, pgd_dtor, pgd);
>  	return NULL;
>  }
>  
> @@ -361,5 +363,11 @@ void pgd_free(pgd_t *pgd)
>  			pmd_cache_free(pmd, i);
>  		}
>  	/* in the non-PAE case, free_pgtables() clears user pgd entries */
> -	kmem_cache_free(pgd_cache, pgd);
> +	quicklist_free(0, pgd_dtor, pgd);
>  }
> +
> +void check_pgt_cache(void)
> +{
> +	quicklist_trim(0, pgd_dtor, 25, 16);
> +}
> +
> diff -puN include/asm-i386/pgalloc.h~slub-i386-support include/asm-i386/pgalloc.h
> --- a/include/asm-i386/pgalloc.h~slub-i386-support
> +++ a/include/asm-i386/pgalloc.h
> @@ -65,6 +65,4 @@ do {									\
>  #define pud_populate(mm, pmd, pte)	BUG()
>  #endif
>  
> -#define check_pgt_cache()	do { } while (0)
> -
>  #endif /* _I386_PGALLOC_H */
> diff -puN include/asm-i386/pgtable.h~slub-i386-support include/asm-i386/pgtable.h
> --- a/include/asm-i386/pgtable.h~slub-i386-support
> +++ a/include/asm-i386/pgtable.h
> @@ -35,17 +35,16 @@ struct vm_area_struct;
>  #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
>  extern unsigned long empty_zero_page[1024];
>  extern pgd_t swapper_pg_dir[1024];
> -extern struct kmem_cache *pgd_cache;
>  extern struct kmem_cache *pmd_cache;
>  extern spinlock_t pgd_lock;
>  extern struct page *pgd_list;
> +void check_pgt_cache(void);
>  
>  void pmd_ctor(void *, struct kmem_cache *, unsigned long);
> -void pgd_ctor(void *, struct kmem_cache *, unsigned long);
> -void pgd_dtor(void *, struct kmem_cache *, unsigned long);
>  void pgtable_cache_init(void);
>  void paging_init(void);
>  
> +
>  /*
>   * The Linux x86 paging architecture is 'compile-time dual-mode', it
>   * implements both the traditional 2-level x86 page tables and the
> _

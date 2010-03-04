Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0CDXWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:22:40 -0500
Received: from relay1.sgi.com ([192.48.179.29]:40831 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab0CDXWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:22:39 -0500
Date: Thu, 4 Mar 2010 17:22:37 -0600
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 1/1] Replace the memtype_lock spinlock with an rwlock
 -V2.
Message-ID: <20100304232237.GA5685@sgi.com>
References: <20100304231954.511707000@alcatraz.americas.sgi.com>
 <20100304232003.289317000@alcatraz.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304232003.289317000@alcatraz.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh.  Forgot to update the subject.  Could you replace it with:

Subject: [Patch 1/1] Update the page flags for memtype atomically instead of using memtype_lock.

Thanks,
Robin Holt

On Thu, Mar 04, 2010 at 05:19:55PM -0600, Robin Holt wrote:
> 
> While testing an application using the xpmem (out of kernel) driver, we
> noticed a significant page fault rate reduction of x86_64 with respect
> to ia64.  For one test running with 32 cpus, one thread per cpu, it
> took 01:08 for each of the threads to vm_insert_pfn 2GB worth of pages.
> For the same test running on 256 cpus, one thread per cpu, it took 14:48
> to vm_insert_pfn 2 GB worth of pages.
> 
> The slowdown was tracked to lookup_memtype which acquires the
> spinlock memtype_lock.  This heavily contended lock was slowing down
> vm_insert_pfn().
> 
> With the cmpxchg on page->flags method, both the 32 cpu and 256 cpu
> cases take approx 00:01.3 seconds to complete.
> 
> 
> To: H. Peter Anvin <hpa@zytor.com>
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Signed-off-by: Robin Holt <holt@sgi.com>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> ---
> 
> Changes since -V1:
> 1) Introduce atomically setting and clearing the page flags and not
> using the global memtype_lock to protect page->flags.
> 
> 2) This allowed me the opportunity to convert the rwlock back into a
> spinlock and not affect _MY_ tests performance as all the pages my test
> was utilizing are tracked by struct pages.
> 
> 3) Corrected the commit log.  The timings were for 32 cpus and not 256.
> 
>  arch/x86/include/asm/cacheflush.h |   43 +++++++++++++++++++++-----------------
>  arch/x86/mm/pat.c                 |   10 --------
>  2 files changed, 25 insertions(+), 28 deletions(-)
> 
> Index: memtype_lock_rwlock_V1/arch/x86/include/asm/cacheflush.h
> ===================================================================
> --- memtype_lock_rwlock_V1.orig/arch/x86/include/asm/cacheflush.h	2010-02-27 08:01:36.753839923 -0600
> +++ memtype_lock_rwlock_V1/arch/x86/include/asm/cacheflush.h	2010-02-27 08:01:43.646018100 -0600
> @@ -44,9 +44,6 @@ static inline void copy_from_user_page(s
>  	memcpy(dst, src, len);
>  }
>  
> -#define PG_WC				PG_arch_1
> -PAGEFLAG(WC, WC)
> -
>  #ifdef CONFIG_X86_PAT
>  /*
>   * X86 PAT uses page flags WC and Uncached together to keep track of
> @@ -55,16 +52,23 @@ PAGEFLAG(WC, WC)
>   * _PAGE_CACHE_UC_MINUS and fourth state where page's memory type has not
>   * been changed from its default (value of -1 used to denote this).
>   * Note we do not support _PAGE_CACHE_UC here.
> - *
> - * Caller must hold memtype_lock for atomicity.
>   */
> +
> +#define _PGMT_DEFAULT		0
> +#define _PGMT_WC		PG_arch_1
> +#define _PGMT_UC_MINUS		PG_uncached
> +#define _PGMT_WB		(PG_uncached | PG_arch_1)
> +#define _PGMT_MASK		(~(PG_uncached | PG_arch_1))
> +
>  static inline unsigned long get_page_memtype(struct page *pg)
>  {
> -	if (!PageUncached(pg) && !PageWC(pg))
> +	unsigned long pg_flags = pg->flags & (PG_uncached | PG_arch_1);
> +
> +	if (pg_flags == _PGMT_DEFAULT)
>  		return -1;
> -	else if (!PageUncached(pg) && PageWC(pg))
> +	else if (pg_flags == _PGMT_WC)
>  		return _PAGE_CACHE_WC;
> -	else if (PageUncached(pg) && !PageWC(pg))
> +	else if (pg_flags == _PGMT_UC_MINUS)
>  		return _PAGE_CACHE_UC_MINUS;
>  	else
>  		return _PAGE_CACHE_WB;
> @@ -72,25 +76,26 @@ static inline unsigned long get_page_mem
>  
>  static inline void set_page_memtype(struct page *pg, unsigned long memtype)
>  {
> +	unsigned long memtype_flags = _PGMT_DEFAULT;
> +	unsigned long old_flags;
> +	unsigned long new_flags;
> +
>  	switch (memtype) {
>  	case _PAGE_CACHE_WC:
> -		ClearPageUncached(pg);
> -		SetPageWC(pg);
> +		memtype_flags = _PGMT_WC;
>  		break;
>  	case _PAGE_CACHE_UC_MINUS:
> -		SetPageUncached(pg);
> -		ClearPageWC(pg);
> +		memtype_flags = _PGMT_UC_MINUS;
>  		break;
>  	case _PAGE_CACHE_WB:
> -		SetPageUncached(pg);
> -		SetPageWC(pg);
> -		break;
> -	default:
> -	case -1:
> -		ClearPageUncached(pg);
> -		ClearPageWC(pg);
> +		memtype_flags = _PGMT_WB;
>  		break;
>  	}
> +
> +	do {
> +		old_flags = pg->flags;
> +		new_flags = (old_flags & _PGMT_MASK) | memtype_flags;
> +	} while (cmpxchg(&pg->flags, old_flags, new_flags) != old_flags);
>  }
>  #else
>  static inline unsigned long get_page_memtype(struct page *pg) { return -1; }
> Index: memtype_lock_rwlock_V1/arch/x86/mm/pat.c
> ===================================================================
> --- memtype_lock_rwlock_V1.orig/arch/x86/mm/pat.c	2010-02-27 08:01:36.753839923 -0600
> +++ memtype_lock_rwlock_V1/arch/x86/mm/pat.c	2010-02-27 08:01:43.646018100 -0600
> @@ -156,7 +156,7 @@ static char *cattr_name(unsigned long fl
>   * The data structure is a list that is also organized as an rbtree
>   * sorted on the start address of memtype range.
>   *
> - * memtype_lock protects both the linear list and rbtree.
> + * memtype_lock protects the rbtree.
>   */
>  
>  struct memtype {
> @@ -296,8 +296,6 @@ static int pat_pagerange_is_ram(unsigned
>   * Here we do two pass:
>   * - Find the memtype of all the pages in the range, look for any conflicts
>   * - In case of no conflicts, set the new memtype for pages in the range
> - *
> - * Caller must hold memtype_lock for atomicity.
>   */
>  static int reserve_ram_pages_type(u64 start, u64 end, unsigned long req_type,
>  				  unsigned long *new_type)
> @@ -404,9 +402,7 @@ int reserve_memtype(u64 start, u64 end, 
>  	is_range_ram = pat_pagerange_is_ram(start, end);
>  	if (is_range_ram == 1) {
>  
> -		spin_lock(&memtype_lock);
>  		err = reserve_ram_pages_type(start, end, req_type, new_type);
> -		spin_unlock(&memtype_lock);
>  
>  		return err;
>  	} else if (is_range_ram < 0) {
> @@ -501,9 +497,7 @@ int free_memtype(u64 start, u64 end)
>  	is_range_ram = pat_pagerange_is_ram(start, end);
>  	if (is_range_ram == 1) {
>  
> -		spin_lock(&memtype_lock);
>  		err = free_ram_pages_type(start, end);
> -		spin_unlock(&memtype_lock);
>  
>  		return err;
>  	} else if (is_range_ram < 0) {
> @@ -583,10 +577,8 @@ static unsigned long lookup_memtype(u64 
>  
>  	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
>  		struct page *page;
> -		spin_lock(&memtype_lock);
>  		page = pfn_to_page(paddr >> PAGE_SHIFT);
>  		rettype = get_page_memtype(page);
> -		spin_unlock(&memtype_lock);
>  		/*
>  		 * -1 from get_page_memtype() implies RAM page is in its
>  		 * default state and not reserved, and hence of type WB
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

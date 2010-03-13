Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934776Ab0CMAQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:16:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:40930 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934748Ab0CMAQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:16:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,629,1262592000"; 
   d="scan'208";a="548645236"
Subject: Re: [Patch] x86,pat Update the page flags for memtype atomically
 instead of using memtype_lock.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <20100311161700.GC5685@sgi.com>
References: <20100311161700.GC5685@sgi.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 12 Mar 2010 16:15:13 -0800
Message-Id: <1268439313.2793.148.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 08:17 -0800, Robin Holt wrote:
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
> To: Ingo Molnar <mingo@redhat.com>
> To: H. Peter Anvin <hpa@zytor.com>
> To: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Robin Holt <holt@sgi.com>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: x86@kernel.org
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

Can you also include this spinlock to rwlock conversion, which can be
used for non RAM pages as a second patch?

Also, this patch doesn't apply to tip/master because of recent rbtree
changes in tip. Can you please send an updated patch?


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

For WB case it should be _PGMT_WB and for the case of "-1" this should
be _PGMT_DEFAULT, as in the case of free page we mark it _PGMT_DEFAULT
and when there is an explicit request to mark it WB, then we mark it
_PGMT_WB

Other than that it looks good to me.

thanks,
suresh
 	


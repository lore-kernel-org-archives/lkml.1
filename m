Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbXF2EU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbXF2EU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 00:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbXF2EUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 00:20:15 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:61299 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbXF2EUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 00:20:13 -0400
Date: Fri, 29 Jun 2007 00:20:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix x86_64-mm-cpa-cache-flush.patch in 2.6.22-rc4-mm2
Message-ID: <20070629042010.GA22678@Krystal>
References: <20070619170914.GA30623@Krystal> <200706201101.20673.ak@suse.de> <20070620164614.GA8916@Krystal> <200706201953.54322.ak@suse.de> <20070620193912.GA20578@Krystal> <20070625212553.ec2caba9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070625212553.ec2caba9.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:11:11 up 31 days, 12:49,  3 users,  load average: 0.79, 0.63, 0.47
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Seems that Andi has changed
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/cpa-cache-flush so
> hopefully these fixes will not be needed any more..
> 

Hrm, actually, something is very wrong with this patch. Please see
comments below.


...
> Index: linux/arch/x86_64/mm/pageattr.c
> ===================================================================
> --- linux.orig/arch/x86_64/mm/pageattr.c
> +++ linux/arch/x86_64/mm/pageattr.c
> @@ -234,7 +235,10 @@ void global_flush_tlb(void)
>  	flush_map(&l);
>  
>  	list_for_each_entry_safe(pg, next, &l, lru) {
> +		if (page_private(pg) != 0)
> +			continue;
>  		ClearPagePrivate(pg);
> +		clear_bit(PG_arch_1, &pg->flags);


First issue:

clear_bit should be before the if (page_private(pg) != 0). As a result,
in the current patch, the flush won't be done the second time flags
are changed in a page, because the bit would only be cleared when each
pte within the page are set back to normal page attributes.

I would also suggest putting a list_del before the if (page_private(pg)
!= 0). It is not required, but would make sure the pointers are
poisoned.

>  		__free_page(pg);
>  	} 
>  } 
> Index: linux/arch/i386/mm/pageattr.c
> ===================================================================
> --- linux.orig/arch/i386/mm/pageattr.c
> +++ linux/arch/i386/mm/pageattr.c
> @@ -82,7 +82,7 @@ static void flush_kernel_map(void *arg)
>  	struct page *p;
>  
>  	/* High level code is not ready for clflush yet */
> -	if (0 && cpu_has_clflush) {
> +	if (cpu_has_clflush) {
>  		list_for_each_entry (p, lh, lru)
>  			cache_flush_page(p);
>  	} else if (boot_cpu_data.x86_model >= 4)
> @@ -136,6 +136,12 @@ static inline void revert_page(struct pa
>  			    ref_prot));
>  }
>  
> +static inline void save_page(struct page *kpte_page)
> +{
> +	if (!test_and_set_bit(PG_arch_1, &kpte_page->flags))
> +		list_add(&kpte_page->lru, &df_list);
> +}
> +
>  static int
>  __change_page_attr(struct page *page, pgprot_t prot)
>  { 
> @@ -150,6 +156,9 @@ __change_page_attr(struct page *page, pg
>  	if (!kpte)
>  		return -EINVAL;
>  	kpte_page = virt_to_page(kpte);
> +	BUG_ON(PageLRU(kpte_page));
> +	BUG_ON(PageCompound(kpte_page));
> +
>  	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
>  		if (!pte_huge(*kpte)) {
>  			set_pte_atomic(kpte, mk_pte(page, prot)); 
> @@ -179,11 +188,11 @@ __change_page_attr(struct page *page, pg
>  	 * time (not via split_large_page) and in turn we must not
>  	 * replace it with a largepage.
>  	 */
> +
> +	save_page(kpte_page);
>  	if (!PageReserved(kpte_page)) {
>  		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
> -			ClearPagePrivate(kpte_page);
>  			paravirt_release_pt(page_to_pfn(kpte_page));
> -			list_add(&kpte_page->lru, &df_list);
>  			revert_page(kpte_page, address);
>  		}
>  	}
> @@ -236,6 +245,10 @@ void global_flush_tlb(void)
>  	spin_unlock_irq(&cpa_lock);
>  	flush_map(&l);
>  	list_for_each_entry_safe(pg, next, &l, lru) {
> +		if (page_private(pg) != 0)
> +			continue;
> +		ClearPagePrivate(pg);
> +		clear_bit(PG_arch_1, &pg->flags);

Same two issues pointed for x86_64 applies here: clear_bit and a
list_del should be put before the if statement.

Mathieu

>  		__free_page(pg);
>  	}
>  }


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

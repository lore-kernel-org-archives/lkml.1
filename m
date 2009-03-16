Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbZCPWfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbZCPWfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbZCPWeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:34:46 -0400
Received: from gw.goop.org ([64.81.55.164]:56568 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbZCPWeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:34:46 -0400
Message-ID: <49BED400.6040605@goop.org>
Date: Mon, 16 Mar 2009 15:34:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: create a non-zero sized bm_pte only when needed
References: <49B91826.76E4.0078.0@novell.com>
In-Reply-To: <49B91826.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Impact: kernel image size reduction
>
> Since in most configurations the pmd page needed maps the same range of
> virtual addresses which is also mapped by the earlier inserted one for
> covering FIX_DBGP_BASE, that page (and its insertion in the page
> tables) can be avoided altogether by detecting the condition at compile
> time.
>   

Does this depend on CONFIG_EARLY_PRINTK_DBGP being set?  And what's so 
special about FIX_DBGP_BASE, that we should hard-code it in here?  Is it 
just that its the first non-arch-dependent fixmap slot?  Or something 
else?  Will it break if we move FIX_DBGP_BASE?

Is the space saving here just the 1 page for bm_pte[]?  Wouldn't we do 
as well by making it initdata?

I'm picking on this change because its breaking Xen PV booting...

>  static __initdata int after_paging_init;
> -static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
> +#define __FIXADDR_TOP (-PAGE_SIZE)
>   

Will this break in a 32-bit PV kernel where FIXADDR_TOP is shifted?

This seriously needs a good inline comment.

> +static pte_t bm_pte[(__fix_to_virt(FIX_DBGP_BASE)
> +		     ^ __fix_to_virt(FIX_BTMAP_BEGIN)) >> PMD_SHIFT
> +		    ? PAGE_SIZE / sizeof(pte_t) : 0] __page_aligned_bss;
> +#undef __FIXADDR_TOP
> +static __initdata pte_t *bm_ptep;
>  
>  static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
>  {
> @@ -505,6 +510,8 @@ static inline pmd_t * __init early_iorem
>  
>  static inline pte_t * __init early_ioremap_pte(unsigned long addr)
>  {
> +	if (!sizeof(bm_pte))
> +		return &bm_ptep[pte_index(addr)];
>  	return &bm_pte[pte_index(addr)];
>   

Why not just assign bm_ptep = bm_pte if we're using the array?

>  }
>  
> @@ -516,8 +523,14 @@ void __init early_ioremap_init(void)
>  		printk(KERN_INFO "early_ioremap_init()\n");
>  
>  	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
> -	memset(bm_pte, 0, sizeof(bm_pte));
> -	pmd_populate_kernel(&init_mm, pmd, bm_pte);
> +	if (sizeof(bm_pte)) {
> +		memset(bm_pte, 0, sizeof(bm_pte));
> +		pmd_populate_kernel(&init_mm, pmd, bm_pte);
> +	} else {
> +		bm_ptep = pte_offset_kernel(pmd, 0);
> +		if (early_ioremap_debug)
> +			printk(KERN_INFO "bm_ptep=%p\n", bm_ptep);
> +	}

    J

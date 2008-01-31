Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbYAaQSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbYAaQSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbYAaQSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:18:00 -0500
Received: from www.tglx.de ([62.245.132.106]:49420 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbYAaQR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:17:59 -0500
Date: Thu, 31 Jan 2008 17:17:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/9] GBPAGES: Do kernel direct mapping at boot using
 GB pages
In-Reply-To: <20080129050637.BD7441B416E@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0801311713010.9204@apollo.tec.linutronix.de>
References: <20080129606.610336873@suse.de> <20080129050637.BD7441B416E@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Andi Kleen wrote:
>
> +static unsigned long direct_entry(unsigned long paddr)

Please use a more sensible function name. This one has no association
with the functionality at all.

> +{
> +	unsigned long entry;

New line please

> +	entry = __PAGE_KERNEL_LARGE|paddr;
> +	entry &= __supported_pte_mask;
> +	return entry;
> +}

> +static void init_gbpages(void)
> +{
> +#ifdef CONFIG_DEBUG_PAGEALLOC
> +	/* debug pagealloc causes too much recursion with gbpages */
> +	if (direct_gbpages == 0)
> +		return;
> +#endif
> +	if (direct_gbpages >= 0 && cpu_has_gbpages) {
> +		printk(KERN_INFO "Using GB pages for direct mapping\n");
> +		direct_gbpages = 1;
> +	} else
> +		direct_gbpages = 0;
> +}

Please use simple boolean logic. gbpages are either enabled or disabled.

> +static void split_gb_page(pud_t *pud, unsigned long paddr)
> +{
> +	int i;
> +	pmd_t *pmd;
> +	struct page *p = alloc_page(GFP_KERNEL);
> +	if (!p)
> +		return;
> +
> +	paddr &= PUD_PAGE_MASK;
> +	pmd = page_address(p);
> +	for (i = 0; i < PTRS_PER_PTE; i++, paddr += PMD_PAGE_SIZE)
> +		pmd[i] = __pmd(direct_entry(paddr));
> +	pud_populate(NULL, pud, pmd);
> +}
> +
>  /*
>   * Unmap a kernel mapping if it exists. This is useful to avoid
>   * prefetches from the CPU leading to inconsistent cache lines.
> @@ -467,6 +511,8 @@ __clear_kernel_mapping(unsigned long add
>  			continue;
>  
>  		pud = pud_offset(pgd, address);
> +		if (pud_large(*pud))
> +			split_gb_page(pud, __pa(address));
>  		if (pud_none(*pud))
>  			continue;

As I said before, this needs to use CPA and not implement another variant.

Thanks,
	tglx
  
 

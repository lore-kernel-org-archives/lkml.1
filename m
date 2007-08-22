Return-Path: <linux-kernel-owner+w=401wt.eu-S1763539AbXHVPFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763539AbXHVPFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761127AbXHVPF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:05:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39638 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761181AbXHVPFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:05:25 -0400
Date: Wed, 22 Aug 2007 10:29:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH -mm 4/4] Hibernation: Use temporary page tables for kernel text mapping on x86_64
Message-ID: <20070822082948.GD2479@elf.ucw.cz>
References: <200708221015.16493.rjw@sisk.pl> <200708221021.28877.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708221021.28877.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Use temporary page tables for the kernel text mapping during hibernation restore
> on x86_64.
> 
> Without the patch, the original boot kernel's page tables that represent the
> kernel text mapping are used while the core of the image kernel is being
> restored.  However, in principle, if the boot kernel is not identical to the
> image kernel, the location of these page tables in the image kernel need not be
> the same, so we should create a safe copy of the kernel text mapping prior to
> restoring the core of the image kernel.


> @@ -190,25 +190,42 @@ static int res_phys_pud_init(pud_t *pud,
>  	return 0;
>  }
>  
> +static int res_kernel_text_pud_init(pud_t *pud, unsigned long start)
> +{
> +	pmd_t *pmd;
> +	unsigned long paddr;
> +
> +	pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
> +	if (!pmd)
> +		return -ENOMEM;
> +	set_pud(pud + pud_index(start), __pud(__pa(pmd) | _KERNPG_TABLE));
> +	for (paddr = 0; paddr < KERNEL_TEXT_SIZE; pmd++, paddr += PMD_SIZE) {
> +		unsigned long pe;
> +
> +		pe = __PAGE_KERNEL_LARGE_EXEC | _PAGE_GLOBAL | paddr;
> +		pe &= __supported_pte_mask;
> +		set_pmd(pmd, __pmd(pe));
> +	}
> +
> +	return 0;
> +}
> +
>  static int set_up_temporary_mappings(void)
>  {
>  	unsigned long start, end, next;
> +	pud_t *pud;
>  	int error;
>  
>  	temp_level4_pgt = (pgd_t *)get_safe_page(GFP_ATOMIC);
>  	if (!temp_level4_pgt)
>  		return -ENOMEM;
>  
> -	/* It is safe to reuse the original kernel mapping */
> -	set_pgd(temp_level4_pgt + pgd_index(__START_KERNEL_map),
> -		init_level4_pgt[pgd_index(__START_KERNEL_map)]);
> -
>  	/* Set up the direct mapping from scratch */
>  	start = (unsigned long)pfn_to_kaddr(0);
>  	end = (unsigned long)pfn_to_kaddr(end_pfn);
>  
>  	for (; start < end; start = next) {
> -		pud_t *pud = (pud_t *)get_safe_page(GFP_ATOMIC);
> +		pud = (pud_t *)get_safe_page(GFP_ATOMIC);
>  		if (!pud)
>  			return -ENOMEM;

I believe we leak temp_level4_pgt here.

> +	/* Set up the kernel text mapping from scratch */
> +	pud = (pud_t *)get_safe_page(GFP_ATOMIC);
> +	if (!pud)
> +		return -ENOMEM;

...and some more memory here :-(. 
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbYASXXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbYASXXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 18:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbYASXXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 18:23:30 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:32396 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYASXX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 18:23:29 -0500
X-Greylist: delayed 976 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jan 2008 18:23:28 EST
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>
	<1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Jan 2008 00:07:09 +0100
In-Reply-To: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
Message-ID: <87prvxct42.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Jan 2008 23:00:56.0793 (UTC) FILETIME=[26658490:01C85AEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell <ijc@hellion.org.uk> writes:
> +1:
> +#ifdef CONFIG_X86_PAE
> +	btl $5, %eax
> +	jnc err_no_pae
> +#endif
>  
>  	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
>  	jmp 3f
> +
> +#ifdef CONFIG_X86_PAE
> +err_no_pae:
> +	/* It is probably too early but we might as well try... */

Without a low identity mapping early_printk will not work and printk
definitely not.

> +#ifdef CONFIG_PRINTK

You should do the test in the 16 bit boot code. In fact it should
already do it by testing the CPUID REQUIRED_MASK.

The only way this could be entered is if someone skips the 16bit boot code
by using kexec, but has the wrong flags. I'm not sure how to handle
it there.

> +/*
> + * Since a paravirt guest will never come down this path we want
> + * native style page table accessors here.
> + */
> +#undef CONFIG_PARAVIRT

Seems quite fragile. I'm sure that would hurt later.


> +
> +static inline __init pud_t *early_pud_offset(pgd_t *pgd, unsigned long vaddr)
> +{
> +	return (pud_t *)(pgd + pgd_index(vaddr));
> +}
> +
> +static inline __init pmd_t *early_pmd_offset(pud_t *pud, unsigned long vaddr)
> +{
> +#ifndef CONFIG_X86_PAE
> +	return (pmd_t *)pud;
> +#else
> +	return ((pmd_t *)(u32)(pud_val(*pud) & PAGE_MASK))
> +		+ pmd_index(vaddr);
> +#endif
> +}
> +
> +static inline __init pte_t *early_pte_offset(pmd_t *pmd, unsigned long vaddr)
> +{
> +	return ((pte_t *)(u32)(pmd_val(*pmd) & PAGE_MASK))

That will break if the kernel is > 4GB won't it? Also same for pmd.

Also not handling NX is dubious, although you can probably get away from it there.

> +		+ pte_index(vaddr);
> +}
> +
> +static inline __init pmd_t *
> +early_pmd_alloc(pgd_t *pgd_base, unsigned long vaddr, unsigned long *end)
> +{
> +	pud_t *pud = early_pud_offset(pgd_base, vaddr);
> +
> +#ifdef CONFIG_X86_PAE
> +	if (!(pud_val(*pud) & _PAGE_PRESENT)) {


Why not set it in the pgd which is identical? Also the proper test is !pgd_none()



> +{
> +	pmd_t *pmd;
> +
> +	pmd = early_pmd_alloc(pgd_base, vaddr, end);
> +	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {

!pmd_none()

> +		unsigned long phys = *end;
> +		memset((void *)phys, 0, PAGE_SIZE);
> +		set_pmd(pmd, __pmd(phys | _PAGE_TABLE));
> +		*end += PAGE_SIZE;
> +	}
> +	return early_pte_offset(pmd, vaddr);
> +}
> +
> +static __init void early_set_pte_phys(pgd_t *pgd_base, unsigned long vaddr,
> +				      unsigned long phys, unsigned long *end)
> +{
> +	pte_t *pte;
> +	pte = early_pte_alloc(pgd_base, vaddr, end);
> +	set_pte(pte, __pte(phys | _PAGE_KERNEL_EXEC));
> +}
> +
> +void __init early_pgtable_init(void)
> +{
> +	unsigned long addr, end;
> +	pgd_t *pgd_base;
> +
> +	pgd_base = __pavar(swapper_pg_dir);
> +	end = __pa_symbol(pg0);

Are you sure there will be enough memory here? You might need to use
an e820 allocator similar to x86-64.

Typical problems is you running into some other memory used by
someone else.

>  {
>  	enum fixed_addresses idx;
> -	unsigned long *pte, phys, addr;
> +	unsigned long addr, phys;
> +	pte_t *pte;
>  
>  	after_paging_init = 1;
>  	for (idx = FIX_BTMAP_BEGIN; idx <= FIX_BTMAP_END; idx--) {
>  		addr = fix_to_virt(idx);
>  		pte = early_ioremap_pte(addr);
> -		if (!*pte & _PAGE_PRESENT) {
> -			phys = *pte & PAGE_MASK;
> +		if (!(pte_val(*pte) & _PAGE_PRESENT)) {

pte_present(). Ok the old code was wrong too, but no need to do that again.

>  			set_fixmap(idx, phys);
>  		}
>  	}
> @@ -298,7 +304,8 @@ void __init early_ioremap_reset(void)
>  static void __init __early_set_fixmap(enum fixed_addresses idx,
>  				   unsigned long phys, pgprot_t flags)
>  {
> -	unsigned long *pte, addr = __fix_to_virt(idx);
> +	unsigned long addr = __fix_to_virt(idx);
> +	pte_t *pte;

Unrelated?

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYATQp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYATQp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 11:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbYATQpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 11:45:15 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:49116 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287AbYATQpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:45:11 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <87prvxct42.fsf@basil.nowhere.org>
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>
	 <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
	 <87prvxct42.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Sun, 20 Jan 2008 16:44:50 +0000
Message-Id: <1200847490.26633.62.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-20 at 00:07 +0100, Andi Kleen wrote: 
> Ian Campbell <ijc@hellion.org.uk> writes:
> > +#ifdef CONFIG_X86_PAE
> > +err_no_pae:
> > +	/* It is probably too early but we might as well try... */
> 
> Without a low identity mapping early_printk will not work and printk
> definitely not.
> 
> > +#ifdef CONFIG_PRINTK
> 
> You should do the test in the 16 bit boot code. In fact it should
> already do it by testing the CPUID REQUIRED_MASK.

Indeed it does. I don't have any non-PAE to test it but I turned the
failure case into a simple jmp to hlt_loop since we ought never to get
here in any case.

> > +/*
> > + * Since a paravirt guest will never come down this path we want
> > + * native style page table accessors here.
> > + */
> > +#undef CONFIG_PARAVIRT
> 
> Seems quite fragile. I'm sure that would hurt later.

The problem here is that we explicitly want native accessors because
it's too early to use the pv ops since we are still running P==V. A PV
kernel boot will never come down this path -- it is diverted earlier in
head_32.S so using the native versions are appropriate.

I'll try again to use the native_{make,set}_xxx functions but originally
I found the necessary variants weren't defined in all combinations of
PAE/not and PARAVIRT/not.

FWIW we use the same undef trick under arch/x86/boot too and this early
start of day stuff if fairly similar.

> > +static inline __init pte_t *early_pte_offset(pmd_t *pmd, unsigned long vaddr)
> > +{
> > +	return ((pte_t *)(u32)(pmd_val(*pmd) & PAGE_MASK))
> 
> That will break if the kernel is > 4GB won't it? Also same for pmd.

As hpa says we can't be above 4G at this point. Probably I can use some
variant of make_pte now though.

> > +static inline __init pmd_t *
> > +early_pmd_alloc(pgd_t *pgd_base, unsigned long vaddr, unsigned long *end)
> > +{
> > +	pud_t *pud = early_pud_offset(pgd_base, vaddr);
> > +
> > +#ifdef CONFIG_X86_PAE
> > +	if (!(pud_val(*pud) & _PAGE_PRESENT)) {
> 
> Why not set it in the pgd which is identical? Also the proper test is !pgd_none()

I was trying to fit in with the native_foo stuff that is available and
happened to be using pud on my last attempt before I switched to the
#undef CONFIG_PARAVIRT approach. I'll switch to pgd if I can get it to
work.

pgd_none (and pud_none) are hardcoded to 0 in the 32 bit case (in
asm-generic/pgtable-nopud.h and asm-generic/pgtable-nopmd.h or
asm-x86/pgtable-3level.h). Presumably this is because at regular runtime
these entries are guaranteed to exist which isn't true this early at
startup.

In fact since we are always going to need a PMD in the PAE case there is
probably not much wrong with simply unconditionally allocating the pmd
at the start of early_pgtable_init().

> > +{
> > +	pmd_t *pmd;
> > +
> > +	pmd = early_pmd_alloc(pgd_base, vaddr, end);
> > +	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
> 
> !pmd_none()

done (without the !)

> > +void __init early_pgtable_init(void)
> > +{
> > +	unsigned long addr, end;
> > +	pgd_t *pgd_base;
> > +
> > +	pgd_base = __pavar(swapper_pg_dir);
> > +	end = __pa_symbol(pg0);
> 
> Are you sure there will be enough memory here? You might need to use
> an e820 allocator similar to x86-64.

True. However the assembly being replaced makes the same assumptions so
I don't think that should block this patch, it's a fixup that can be
made later.

> > -		if (!*pte & _PAGE_PRESENT) {
> > -			phys = *pte & PAGE_MASK;
> > +		if (!(pte_val(*pte) & _PAGE_PRESENT)) {
> 
> pte_present(). Ok the old code was wrong too, but no need to do that again.

Done.

> > @@ -298,7 +304,8 @@ void __init early_ioremap_reset(void)
> >  static void __init __early_set_fixmap(enum fixed_addresses idx,
> >  				   unsigned long phys, pgprot_t flags)
> >  {
> > -	unsigned long *pte, addr = __fix_to_virt(idx);
> > +	unsigned long addr = __fix_to_virt(idx);
> > +	pte_t *pte;
> 
> Unrelated?

Nope, the return type of early_ioremap_pte() changed unsigned long ->
pte_t and that is what is assigned to pte.

I'll spin another version.

Ian.
-- 
Ian Campbell

"I go on working for the same reason a hen goes on laying eggs."
		-- H. L. Mencken


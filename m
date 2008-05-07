Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbYEGXXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbYEGXXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbYEGXXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:23:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:13657 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbYEGXX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:23:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,450,1204531200"; 
   d="scan'208";a="562004551"
Date: Wed, 7 May 2008 16:23:26 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Frans Pop <elendil@planet.nl>, Jesse Barnes <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org,
       "Packard, Keith" <keith.packard@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [git head] X86_PAT & mprotect
Message-ID: <20080507232326.GB10757@linux-os.sc.intel.com>
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl> <200805050857.57661.jesse.barnes@intel.com> <200805051932.41827.elendil@planet.nl> <20080506224240.GA18706@linux-os.sc.intel.com> <20080507070217.GD32195@elte.hu> <Pine.LNX.4.64.0805071941140.18916@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805071941140.18916@blonde.site>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 08:18:45PM +0100, Hugh Dickins wrote:
> On Wed, 7 May 2008, Ingo Molnar wrote:
> > the pte_modify() change looks correct at first sight.
> > 
> > The _PAGE_PROT_PRESERVE_BITS solution looks a bit ugly (although we do 
> > have a couple of other similar #ifndefs in the MM already).
> > 
> > at minimum we should add vm_get_page_prot_preserve() as an inline 
> > function to mm.h if _PAGE_PROT_PRESERVE_BITS is not defined, and make it 
> > call vm_get_page_prot(). Also, vm_get_page_prot() in mm/mmap.c should 
> > probably be marked inline so that we'll have only a single function call 
> > [vm_get_page_prot() is trivial].
> 
> I've tried doing it slightly differently below,
> don't know whether you'll consider it an improvement or not.

Hugh: Thanks for looking into this. Yes. I like your modified patch. Simpler
and smaller.
 
> > ------------------------------------->
> > Subject: generic, x86, PAT: fix mprotect
> > From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
> > Date: Tue, 6 May 2008 15:42:40 -0700
> > 
> > There is a hole in mprotect, which lets the user to change the page
> > cache type bits by-passing the kernel reserve_memtype and free_memtype
> > wrappers. Fix the hole by not letting mprotect change the PAT bits.
> 
> Maybe say "defect" rather than "hole"?  I stupidly thought for a
> while that you were talking about some gap in the address space.

Yes. we can call it a loophole or defect.

> > @@ -289,7 +291,8 @@ static inline pte_t pte_modify(pte_t pte
> >  	 * Chop off the NX bit (if present), and add the NX portion of
> >  	 * the newprot (if present):
> >  	 */
> > -	val &= _PAGE_CHG_MASK & ~_PAGE_NX;
> 
> (Nothing to do with your patch, but that's a silly line, isn't it?
> _PAGE_NX isn't in _PAGE_CHG_MASK so it doesn't need further masking out.)

Yes. That PAGE_NX part indeed looks bogus.

> > +	/* We also preserve PAT bits from existing pte */
> > +	val &= (_PAGE_CHG_MASK | _PAGE_PROT_PRESERVE_BITS)  & ~_PAGE_NX;
> >  	val |= pgprot_val(newprot) & __supported_pte_mask;
> >  
> >  	return __pte(val);
> 
> An odd thing is that you end up keeping the PAT bits from the old
> pte, and the PAT bits from vm_page_prot.  So if they can get out
> of synch, you'd be oring them together; and if they can't get out
> of synch, then do you need a change here?

They cannot get out of sync. So, we can do without the change here. But, I felt
it is safer to take things from old pte.

> I've followed that dup in my version below, but it's probably wrong.
> Yes, you want the PAT bits in vm_page_prot (so various places
> will automatically set them), but I think here it's more correct
> to take the PAT bits from the old pte and mask out those from the
> vm_page_prot?

Yes. We can mask out these bits from vm_page_prot, that way we will not
'or' them if they get out of sync.
If your below modified patch is OK, I can send an incremental patch to
change pte_modify() to inherit PAT bits only from oldpte.

Thanks,
Venki

> Here's my more minimal alternative; but I think we need to clarify
> on that apparent duplication of the PAT bits in pte_modify.
> 
>  arch/x86/pci/i386.c       |    4 +---
>  include/asm-x86/pgtable.h |   14 +++++++++++++-
>  mm/mprotect.c             |   11 ++++++++++-
>  3 files changed, 24 insertions(+), 5 deletions(-)
> 
> --- 2.6.26-rc1/arch/x86/pci/i386.c	2008-05-03 21:54:41.000000000 +0100
> +++ linux/arch/x86/pci/i386.c	2008-05-07 17:14:53.000000000 +0100
> @@ -301,15 +301,13 @@ int pci_mmap_page_range(struct pci_dev *
>  	prot = pgprot_val(vma->vm_page_prot);
>  	if (pat_wc_enabled && write_combine)
>  		prot |= _PAGE_CACHE_WC;
> -	else if (pat_wc_enabled)
> +	else if (pat_wc_enabled || boot_cpu_data.x86 > 3)
>  		/*
>  		 * ioremap() and ioremap_nocache() defaults to UC MINUS for now.
>  		 * To avoid attribute conflicts, request UC MINUS here
>  		 * aswell.
>  		 */
>  		prot |= _PAGE_CACHE_UC_MINUS;
> -	else if (boot_cpu_data.x86 > 3)
> -		prot |= _PAGE_CACHE_UC;
>  
>  	vma->vm_page_prot = __pgprot(prot);
>  
> --- 2.6.26-rc1/include/asm-x86/pgtable.h	2008-05-03 21:55:10.000000000 +0100
> +++ linux/include/asm-x86/pgtable.h	2008-05-07 19:09:42.000000000 +0100
> @@ -57,7 +57,8 @@
>  #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
>  			 _PAGE_DIRTY)
>  
> -#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
> +#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PWT | _PAGE_PCD |		\
> +			 _PAGE_ACCESSED | _PAGE_DIRTY)
>  
>  #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
>  #define _PAGE_CACHE_WB		(0)
> @@ -294,6 +295,17 @@ static inline pte_t pte_modify(pte_t pte
>  	return __pte(val);
>  }
>  
> +/*
> + * mprotect needs to preserve PAT bits when updating vm_page_prot
> + */
> +#define pgprot_modify pgprot_modify
> +static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
> +{
> +	pgprotval_t preservebits = pgprot_val(oldprot) & _PAGE_CHG_MASK;
> +	pgprotval_t addbits = pgprot_val(newprot);
> +	return __pgprot(preservebits | addbits);
> +}
> +
>  #define pte_pgprot(x) __pgprot(pte_val(x) & (0xfff | _PAGE_NX))
>  
>  #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
> --- 2.6.26-rc1/mm/mprotect.c	2008-01-24 22:58:37.000000000 +0000
> +++ linux/mm/mprotect.c	2008-05-07 18:42:07.000000000 +0100
> @@ -26,6 +26,13 @@
>  #include <asm/cacheflush.h>
>  #include <asm/tlbflush.h>
>  
> +#ifndef pgprot_modify
> +static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
> +{
> +	return newprot;
> +}
> +#endif
> +
>  static void change_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  		unsigned long addr, unsigned long end, pgprot_t newprot,
>  		int dirty_accountable)
> @@ -192,7 +199,9 @@ success:
>  	 * held in write mode.
>  	 */
>  	vma->vm_flags = newflags;
> -	vma->vm_page_prot = vm_get_page_prot(newflags);
> +	vma->vm_page_prot = pgprot_modify(vma->vm_page_prot,
> +					  vm_get_page_prot(newflags));
> +
>  	if (vma_wants_writenotify(vma)) {
>  		vma->vm_page_prot = vm_get_page_prot(newflags & ~VM_SHARED);
>  		dirty_accountable = 1;

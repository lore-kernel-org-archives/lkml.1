Return-Path: <linux-kernel-owner+w=401wt.eu-S933183AbYEGTTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183AbYEGTTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbYEGTT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:19:26 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38862 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbYEGTTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:19:21 -0400
Date: Wed, 7 May 2008 20:18:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Frans Pop <elendil@planet.nl>, Jesse Barnes <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org,
       "Packard, Keith" <keith.packard@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [git head] X86_PAT & mprotect
In-Reply-To: <20080507070217.GD32195@elte.hu>
Message-ID: <Pine.LNX.4.64.0805071941140.18916@blonde.site>
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl>
 <200805050857.57661.jesse.barnes@intel.com> <200805051932.41827.elendil@planet.nl>
 <20080506224240.GA18706@linux-os.sc.intel.com> <20080507070217.GD32195@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Ingo Molnar wrote:
> 
> hm, that's one dangerous looking patch. (Cc:-ed more MM folks. I've 
> attached the patch below for reference.)

Thanks, Ingo.  I've added Nick too (in part because I'm wondering
whether his s390 SPECIAL bit gets destroyed by mprotect and needs
similar attention).

> 
> the purpose of the fix itself seems to make some sense - we dont want 
> mprotect() change the PAT bits in the pte from what they got populated 
> with at fault or mmap time.

Indeed.

> 
> the pte_modify() change looks correct at first sight.
> 
> The _PAGE_PROT_PRESERVE_BITS solution looks a bit ugly (although we do 
> have a couple of other similar #ifndefs in the MM already).
> 
> at minimum we should add vm_get_page_prot_preserve() as an inline 
> function to mm.h if _PAGE_PROT_PRESERVE_BITS is not defined, and make it 
> call vm_get_page_prot(). Also, vm_get_page_prot() in mm/mmap.c should 
> probably be marked inline so that we'll have only a single function call 
> [vm_get_page_prot() is trivial].

I've tried doing it slightly differently below,
don't know whether you'll consider it an improvement or not.

> 
> but i'm wondering why similar issues never came up on other 
> architectures - i thought it would be rather common to have immutable 
> pte details. So maybe i'm missing something here ...

I believe it has come up from time to time in certain drivers,
but they've worked around it somehow, so it's never got important
enough to handle in the core.  Glad we're getting to do so now.

> 
> 	Ingo
> 
> ------------------------------------->
> Subject: generic, x86, PAT: fix mprotect
> From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
> Date: Tue, 6 May 2008 15:42:40 -0700
> 
> There is a hole in mprotect, which lets the user to change the page
> cache type bits by-passing the kernel reserve_memtype and free_memtype
> wrappers. Fix the hole by not letting mprotect change the PAT bits.

Maybe say "defect" rather than "hole"?  I stupidly thought for a
while that you were talking about some gap in the address space.

> 
> Some versions of X used the mprotect hole to change caching type from UC to WB,
> so that it can then use mtrr to program WC for that region [1]. Change the
> mmap of pci space through /sys or /proc interfaces from UC to UC_MINUS.
> With this change, X will not need to use mprotect hole to get WC type.

I'll trust you on that end of it, UC_MINUS is beyond me.

> 
> [1] lkml.org/lkml/2008/4/16/369
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/pci/i386.c       |    4 +---
>  include/asm-x86/pgtable.h |    5 ++++-
>  include/linux/mm.h        |    1 +
>  mm/mmap.c                 |   13 +++++++++++++
>  mm/mprotect.c             |    4 +++-
>  5 files changed, 22 insertions(+), 5 deletions(-)
> 
> Index: linux-x86.q/arch/x86/pci/i386.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/pci/i386.c
> +++ linux-x86.q/arch/x86/pci/i386.c
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
> Index: linux-x86.q/include/asm-x86/pgtable.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/pgtable.h
> +++ linux-x86.q/include/asm-x86/pgtable.h
> @@ -66,6 +66,8 @@
>  #define _PAGE_CACHE_UC_MINUS	(_PAGE_PCD)
>  #define _PAGE_CACHE_UC		(_PAGE_PCD | _PAGE_PWT)
>  
> +#define _PAGE_PROT_PRESERVE_BITS	(_PAGE_CACHE_MASK)
> +

(Amused to see _PAGE_CACHE_MASK is very different from PAGE_CACHE_MASK!)

>  #define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
>  #define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | \
>  				 _PAGE_ACCESSED | _PAGE_NX)
> @@ -289,7 +291,8 @@ static inline pte_t pte_modify(pte_t pte
>  	 * Chop off the NX bit (if present), and add the NX portion of
>  	 * the newprot (if present):
>  	 */
> -	val &= _PAGE_CHG_MASK & ~_PAGE_NX;

(Nothing to do with your patch, but that's a silly line, isn't it?
_PAGE_NX isn't in _PAGE_CHG_MASK so it doesn't need further masking out.)

> +	/* We also preserve PAT bits from existing pte */
> +	val &= (_PAGE_CHG_MASK | _PAGE_PROT_PRESERVE_BITS)  & ~_PAGE_NX;
>  	val |= pgprot_val(newprot) & __supported_pte_mask;
>  
>  	return __pte(val);

An odd thing is that you end up keeping the PAT bits from the old
pte, and the PAT bits from vm_page_prot.  So if they can get out
of synch, you'd be oring them together; and if they can't get out
of synch, then do you need a change here?

I've followed that dup in my version below, but it's probably wrong.
Yes, you want the PAT bits in vm_page_prot (so various places
will automatically set them), but I think here it's more correct
to take the PAT bits from the old pte and mask out those from the
vm_page_prot?

I suggest that way round because I'm vaguely anticipating that
silly case of a MAP_PRIVATE mapping of one of these things: we'll
need to add something in do_wp_page so as not to set the PAT bits
on private COWed copies of the PATted page (but that can follow
later as a fixup patch).

> Index: linux-x86.q/include/linux/mm.h
> ===================================================================
> --- linux-x86.q.orig/include/linux/mm.h
> +++ linux-x86.q/include/linux/mm.h
> @@ -1177,6 +1177,7 @@ static inline unsigned long vma_pages(st
>  }
>  
>  pgprot_t vm_get_page_prot(unsigned long vm_flags);
> +pgprot_t vm_get_page_prot_preserve(unsigned long vm_flags, pgprot_t oldprot);

I'm thinking its equivalent needs to be in asm/pagetable.h.

>  struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
>  int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
>  			unsigned long pfn, unsigned long size, pgprot_t);
> Index: linux-x86.q/mm/mmap.c
> ===================================================================
> --- linux-x86.q.orig/mm/mmap.c
> +++ linux-x86.q/mm/mmap.c
> @@ -77,6 +77,19 @@ pgprot_t vm_get_page_prot(unsigned long 
>  }
>  EXPORT_SYMBOL(vm_get_page_prot);
>  
> +#ifndef _PAGE_PROT_PRESERVE_BITS
> +#define _PAGE_PROT_PRESERVE_BITS	0
> +#endif
> +
> +pgprot_t vm_get_page_prot_preserve(unsigned long vm_flags, pgprot_t oldprot)
> +{
> +	pteval_t newprotval = pgprot_val(oldprot);
> +
> +	newprotval &= _PAGE_PROT_PRESERVE_BITS;
> +	newprotval |= pgprot_val(vm_get_page_prot(vm_flags));
> +	return __pgprot(newprotval);
> +}
> +

I'm not convinced that this anding and oring is necessarily right for
any architecture: I think this function (or my equivalent pgprot_modify)
ought to go down in the arch headers: next to pte_modify helped my focus.

>  int sysctl_overcommit_memory = OVERCOMMIT_GUESS;  /* heuristic overcommit */
>  int sysctl_overcommit_ratio = 50;	/* default is 50% */
>  int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
> Index: linux-x86.q/mm/mprotect.c
> ===================================================================
> --- linux-x86.q.orig/mm/mprotect.c
> +++ linux-x86.q/mm/mprotect.c
> @@ -192,7 +192,9 @@ success:
>  	 * held in write mode.
>  	 */
>  	vma->vm_flags = newflags;
> -	vma->vm_page_prot = vm_get_page_prot(newflags);
> +	vma->vm_page_prot = vm_get_page_prot_preserve(newflags,
> +							vma->vm_page_prot);
> +
>  	if (vma_wants_writenotify(vma)) {
>  		vma->vm_page_prot = vm_get_page_prot(newflags & ~VM_SHARED);
>  		dirty_accountable = 1;

Here's my more minimal alternative; but I think we need to clarify
on that apparent duplication of the PAT bits in pte_modify.

 arch/x86/pci/i386.c       |    4 +---
 include/asm-x86/pgtable.h |   14 +++++++++++++-
 mm/mprotect.c             |   11 ++++++++++-
 3 files changed, 24 insertions(+), 5 deletions(-)

--- 2.6.26-rc1/arch/x86/pci/i386.c	2008-05-03 21:54:41.000000000 +0100
+++ linux/arch/x86/pci/i386.c	2008-05-07 17:14:53.000000000 +0100
@@ -301,15 +301,13 @@ int pci_mmap_page_range(struct pci_dev *
 	prot = pgprot_val(vma->vm_page_prot);
 	if (pat_wc_enabled && write_combine)
 		prot |= _PAGE_CACHE_WC;
-	else if (pat_wc_enabled)
+	else if (pat_wc_enabled || boot_cpu_data.x86 > 3)
 		/*
 		 * ioremap() and ioremap_nocache() defaults to UC MINUS for now.
 		 * To avoid attribute conflicts, request UC MINUS here
 		 * aswell.
 		 */
 		prot |= _PAGE_CACHE_UC_MINUS;
-	else if (boot_cpu_data.x86 > 3)
-		prot |= _PAGE_CACHE_UC;
 
 	vma->vm_page_prot = __pgprot(prot);
 
--- 2.6.26-rc1/include/asm-x86/pgtable.h	2008-05-03 21:55:10.000000000 +0100
+++ linux/include/asm-x86/pgtable.h	2008-05-07 19:09:42.000000000 +0100
@@ -57,7 +57,8 @@
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
 			 _PAGE_DIRTY)
 
-#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PWT | _PAGE_PCD |		\
+			 _PAGE_ACCESSED | _PAGE_DIRTY)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_WB		(0)
@@ -294,6 +295,17 @@ static inline pte_t pte_modify(pte_t pte
 	return __pte(val);
 }
 
+/*
+ * mprotect needs to preserve PAT bits when updating vm_page_prot
+ */
+#define pgprot_modify pgprot_modify
+static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
+{
+	pgprotval_t preservebits = pgprot_val(oldprot) & _PAGE_CHG_MASK;
+	pgprotval_t addbits = pgprot_val(newprot);
+	return __pgprot(preservebits | addbits);
+}
+
 #define pte_pgprot(x) __pgprot(pte_val(x) & (0xfff | _PAGE_NX))
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
--- 2.6.26-rc1/mm/mprotect.c	2008-01-24 22:58:37.000000000 +0000
+++ linux/mm/mprotect.c	2008-05-07 18:42:07.000000000 +0100
@@ -26,6 +26,13 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#ifndef pgprot_modify
+static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
+{
+	return newprot;
+}
+#endif
+
 static void change_pte_range(struct mm_struct *mm, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable)
@@ -192,7 +199,9 @@ success:
 	 * held in write mode.
 	 */
 	vma->vm_flags = newflags;
-	vma->vm_page_prot = vm_get_page_prot(newflags);
+	vma->vm_page_prot = pgprot_modify(vma->vm_page_prot,
+					  vm_get_page_prot(newflags));
+
 	if (vma_wants_writenotify(vma)) {
 		vma->vm_page_prot = vm_get_page_prot(newflags & ~VM_SHARED);
 		dirty_accountable = 1;

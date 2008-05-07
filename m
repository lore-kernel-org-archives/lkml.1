Return-Path: <linux-kernel-owner+w=401wt.eu-S1763038AbYEGHCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763038AbYEGHCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbYEGHCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:02:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYEGHCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:02:39 -0400
Date: Wed, 7 May 2008 09:02:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Frans Pop <elendil@planet.nl>, Jesse Barnes <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org,
       "Packard, Keith" <keith.packard@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git head] X86_PAT & mprotect
Message-ID: <20080507070217.GD32195@elte.hu>
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl> <200805050857.57661.jesse.barnes@intel.com> <200805051932.41827.elendil@planet.nl> <20080506224240.GA18706@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506224240.GA18706@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> There is a hole in mprotect, which lets the user to change the page 
> cache type bits by-passing the kernel reserve_memtype and free_memtype 
> wrappers. Fix the hole by not letting mprotect change the PAT bits.
> 
> Some versions of X used the mprotect hole to change caching type from 
> UC to WB, so that it can then use mtrr to program WC for that region 
> [1]. Change the mmap of pci space through /sys or /proc interfaces 
> from UC to UC_MINUS. With this change, X will not need to use mprotect 
> hole to get WC type.
> 
> [1] lkml.org/lkml/2008/4/16/369
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> ---
>  arch/x86/pci/i386.c       |    4 +---
>  include/asm-x86/pgtable.h |    5 ++++-
>  include/linux/mm.h        |    1 +
>  mm/mmap.c                 |   13 +++++++++++++
>  mm/mprotect.c             |    4 +++-
>  5 files changed, 22 insertions(+), 5 deletions(-)

hm, that's one dangerous looking patch. (Cc:-ed more MM folks. I've 
attached the patch below for reference.)

the purpose of the fix itself seems to make some sense - we dont want 
mprotect() change the PAT bits in the pte from what they got populated 
with at fault or mmap time.

the pte_modify() change looks correct at first sight.

The _PAGE_PROT_PRESERVE_BITS solution looks a bit ugly (although we do 
have a couple of other similar #ifndefs in the MM already).

at minimum we should add vm_get_page_prot_preserve() as an inline 
function to mm.h if _PAGE_PROT_PRESERVE_BITS is not defined, and make it 
call vm_get_page_prot(). Also, vm_get_page_prot() in mm/mmap.c should 
probably be marked inline so that we'll have only a single function call 
[vm_get_page_prot() is trivial].

but i'm wondering why similar issues never came up on other 
architectures - i thought it would be rather common to have immutable 
pte details. So maybe i'm missing something here ...

	Ingo

------------------------------------->
Subject: generic, x86, PAT: fix mprotect
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date: Tue, 6 May 2008 15:42:40 -0700

There is a hole in mprotect, which lets the user to change the page
cache type bits by-passing the kernel reserve_memtype and free_memtype
wrappers. Fix the hole by not letting mprotect change the PAT bits.

Some versions of X used the mprotect hole to change caching type from UC to WB,
so that it can then use mtrr to program WC for that region [1]. Change the
mmap of pci space through /sys or /proc interfaces from UC to UC_MINUS.
With this change, X will not need to use mprotect hole to get WC type.

[1] lkml.org/lkml/2008/4/16/369

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/pci/i386.c       |    4 +---
 include/asm-x86/pgtable.h |    5 ++++-
 include/linux/mm.h        |    1 +
 mm/mmap.c                 |   13 +++++++++++++
 mm/mprotect.c             |    4 +++-
 5 files changed, 22 insertions(+), 5 deletions(-)

Index: linux-x86.q/arch/x86/pci/i386.c
===================================================================
--- linux-x86.q.orig/arch/x86/pci/i386.c
+++ linux-x86.q/arch/x86/pci/i386.c
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
 
Index: linux-x86.q/include/asm-x86/pgtable.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/pgtable.h
+++ linux-x86.q/include/asm-x86/pgtable.h
@@ -66,6 +66,8 @@
 #define _PAGE_CACHE_UC_MINUS	(_PAGE_PCD)
 #define _PAGE_CACHE_UC		(_PAGE_PCD | _PAGE_PWT)
 
+#define _PAGE_PROT_PRESERVE_BITS	(_PAGE_CACHE_MASK)
+
 #define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
 #define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | \
 				 _PAGE_ACCESSED | _PAGE_NX)
@@ -289,7 +291,8 @@ static inline pte_t pte_modify(pte_t pte
 	 * Chop off the NX bit (if present), and add the NX portion of
 	 * the newprot (if present):
 	 */
-	val &= _PAGE_CHG_MASK & ~_PAGE_NX;
+	/* We also preserve PAT bits from existing pte */
+	val &= (_PAGE_CHG_MASK | _PAGE_PROT_PRESERVE_BITS)  & ~_PAGE_NX;
 	val |= pgprot_val(newprot) & __supported_pte_mask;
 
 	return __pte(val);
Index: linux-x86.q/include/linux/mm.h
===================================================================
--- linux-x86.q.orig/include/linux/mm.h
+++ linux-x86.q/include/linux/mm.h
@@ -1177,6 +1177,7 @@ static inline unsigned long vma_pages(st
 }
 
 pgprot_t vm_get_page_prot(unsigned long vm_flags);
+pgprot_t vm_get_page_prot_preserve(unsigned long vm_flags, pgprot_t oldprot);
 struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
Index: linux-x86.q/mm/mmap.c
===================================================================
--- linux-x86.q.orig/mm/mmap.c
+++ linux-x86.q/mm/mmap.c
@@ -77,6 +77,19 @@ pgprot_t vm_get_page_prot(unsigned long 
 }
 EXPORT_SYMBOL(vm_get_page_prot);
 
+#ifndef _PAGE_PROT_PRESERVE_BITS
+#define _PAGE_PROT_PRESERVE_BITS	0
+#endif
+
+pgprot_t vm_get_page_prot_preserve(unsigned long vm_flags, pgprot_t oldprot)
+{
+	pteval_t newprotval = pgprot_val(oldprot);
+
+	newprotval &= _PAGE_PROT_PRESERVE_BITS;
+	newprotval |= pgprot_val(vm_get_page_prot(vm_flags));
+	return __pgprot(newprotval);
+}
+
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS;  /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50;	/* default is 50% */
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
Index: linux-x86.q/mm/mprotect.c
===================================================================
--- linux-x86.q.orig/mm/mprotect.c
+++ linux-x86.q/mm/mprotect.c
@@ -192,7 +192,9 @@ success:
 	 * held in write mode.
 	 */
 	vma->vm_flags = newflags;
-	vma->vm_page_prot = vm_get_page_prot(newflags);
+	vma->vm_page_prot = vm_get_page_prot_preserve(newflags,
+							vma->vm_page_prot);
+
 	if (vma_wants_writenotify(vma)) {
 		vma->vm_page_prot = vm_get_page_prot(newflags & ~VM_SHARED);
 		dirty_accountable = 1;

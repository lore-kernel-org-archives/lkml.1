Return-Path: <linux-kernel-owner+w=401wt.eu-S934145AbYEFWnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145AbYEFWnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934123AbYEFWmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:42:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:44224 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934113AbYEFWml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:42:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,445,1204531200"; 
   d="scan'208";a="325206978"
Date: Tue, 6 May 2008 15:42:40 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [git head] Should X86_PAT really default to yes?
Message-ID: <20080506224240.GA18706@linux-os.sc.intel.com>
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl> <200805050857.57661.jesse.barnes@intel.com> <200805051932.41827.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805051932.41827.elendil@planet.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 07:32:40PM +0200, Frans Pop wrote:
> Sigh. This is going to get complex...
> 
> Note that the "expected mapping type" errors remain the same both with and 
> without framebuffer console.
> 

The patch below plugs the mprotect hole and should eliminate the
"expected mapping type" error messages. Can you check.

Thanks,
Venki



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

---
 arch/x86/pci/i386.c       |    4 +---
 include/asm-x86/pgtable.h |    5 ++++-
 include/linux/mm.h        |    1 +
 mm/mmap.c                 |   13 +++++++++++++
 mm/mprotect.c             |    4 +++-
 5 files changed, 22 insertions(+), 5 deletions(-)

Index: linux-2.6/include/asm-x86/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pgtable.h	2008-05-06 14:16:50.000000000 -0700
+++ linux-2.6/include/asm-x86/pgtable.h	2008-05-06 14:18:57.000000000 -0700
@@ -65,6 +65,8 @@
 #define _PAGE_CACHE_UC_MINUS	(_PAGE_PCD)
 #define _PAGE_CACHE_UC		(_PAGE_PCD | _PAGE_PWT)
 
+#define _PAGE_PROT_PRESERVE_BITS	(_PAGE_CACHE_MASK)
+
 #define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
 #define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | \
 				 _PAGE_ACCESSED | _PAGE_NX)
@@ -288,7 +290,8 @@ static inline pte_t pte_modify(pte_t pte
 	 * Chop off the NX bit (if present), and add the NX portion of
 	 * the newprot (if present):
 	 */
-	val &= _PAGE_CHG_MASK & ~_PAGE_NX;
+	/* We also preserve PAT bits from existing pte */
+	val &= (_PAGE_CHG_MASK | _PAGE_PROT_PRESERVE_BITS)  & ~_PAGE_NX;
 	val |= pgprot_val(newprot) & __supported_pte_mask;
 
 	return __pte(val);
Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c	2008-05-06 14:16:50.000000000 -0700
+++ linux-2.6/arch/x86/pci/i386.c	2008-05-06 15:28:57.000000000 -0700
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
 
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-05-06 14:16:50.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2008-05-06 14:18:57.000000000 -0700
@@ -1177,6 +1177,7 @@ static inline unsigned long vma_pages(st
 }
 
 pgprot_t vm_get_page_prot(unsigned long vm_flags);
+pgprot_t vm_get_page_prot_preserve(unsigned long vm_flags, pgprot_t oldprot);
 struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c	2008-05-06 14:16:50.000000000 -0700
+++ linux-2.6/mm/mmap.c	2008-05-06 14:18:57.000000000 -0700
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
Index: linux-2.6/mm/mprotect.c
===================================================================
--- linux-2.6.orig/mm/mprotect.c	2008-05-06 14:16:50.000000000 -0700
+++ linux-2.6/mm/mprotect.c	2008-05-06 14:18:57.000000000 -0700
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

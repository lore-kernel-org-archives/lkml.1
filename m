Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYEIUJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYEIUJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbYEIUJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:09:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:51955 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbYEIUJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:09:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,462,1204531200"; 
   d="scan'208";a="381962278"
Date: Fri, 9 May 2008 13:09:30 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hugh Dickins <hugh@veritas.com>, Frans Pop <elendil@planet.nl>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Packard, Keith" <keith.packard@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git head] X86_PAT & mprotect
Message-ID: <20080509200930.GA12061@linux-os.sc.intel.com>
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl> <200805050857.57661.jesse.barnes@intel.com> <200805051932.41827.elendil@planet.nl> <20080506224240.GA18706@linux-os.sc.intel.com> <20080507070217.GD32195@elte.hu> <Pine.LNX.4.64.0805071941140.18916@blonde.site> <20080507232326.GB10757@linux-os.sc.intel.com> <20080509100818.GD19617@elte.hu> <20080509200519.GA10897@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509200519.GA10897@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 01:05:19PM -0700, Venki Pallipadi wrote:
> On Fri, May 09, 2008 at 12:08:18PM +0200, Ingo Molnar wrote:
> > 
> > * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> > 
> > > > I've tried doing it slightly differently below, don't know whether 
> > > > you'll consider it an improvement or not.
> > > 
> > > Hugh: Thanks for looking into this. Yes. I like your modified patch. 
> > > Simpler and smaller.
> > 
> > i have stuck your original patch into testing and nothing blew up so 
> > far. Due to the mm/ bits this is not for the scope of x86.git, but 
> > obviously it all looks good and is .26-worthy to me:
> > 
> >  Acked-by: Ingo Molnar <mingo@elte.hu>
> >  Tested-by: Ingo Molnar <mingo@elte.hu>
> > 
> > Venki, could you please send a full patch against -git that has 
> > everything from Hugh included, with an updated changelog, for 
> > Linus/Andrew to ack/apply?
> > 
> 
> Ingo,
> 
> Split up the patch into two parts as the pci part was unrelated to mprotect
> problem in a sense.

And the second patch for mprotect problem.


There is a defect in mprotect, which lets the user to change the page
cache type bits by-passing the kernel reserve_memtype and free_memtype
wrappers. Fix the problem by not letting mprotect change the PAT bits.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Hugh Dickins <hugh@veritas.com>

---
 include/asm-x86/pgtable.h |   16 +++++++++++++---
 mm/mprotect.c             |   11 ++++++++++-
 2 files changed, 23 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/mprotect.c
===================================================================
--- linux-2.6.orig/mm/mprotect.c	2008-05-09 10:50:28.000000000 -0700
+++ linux-2.6/mm/mprotect.c	2008-05-09 11:01:23.000000000 -0700
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
Index: linux-2.6/include/asm-x86/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pgtable.h	2008-05-09 10:50:28.000000000 -0700
+++ linux-2.6/include/asm-x86/pgtable.h	2008-05-09 11:01:23.000000000 -0700
@@ -57,7 +57,8 @@
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
 			 _PAGE_DIRTY)
 
-#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _PAGE_CHG_MASK	(PTE_MASK |_PAGE_PCD | _PAGE_PWT |		\
+			 _PAGE_ACCESSED | _PAGE_DIRTY)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_WB		(0)
@@ -288,12 +289,21 @@ static inline pte_t pte_modify(pte_t pte
 	 * Chop off the NX bit (if present), and add the NX portion of
 	 * the newprot (if present):
 	 */
-	val &= _PAGE_CHG_MASK & ~_PAGE_NX;
-	val |= pgprot_val(newprot) & __supported_pte_mask;
+	val &= _PAGE_CHG_MASK;
+	val |= pgprot_val(newprot) & (~_PAGE_CHG_MASK) & __supported_pte_mask;
 
 	return __pte(val);
 }
 
+/* mprotect needs to preserve PAT bits when updating vm_page_prot */
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

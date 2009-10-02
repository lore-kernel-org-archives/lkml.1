Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbZJBBgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbZJBBgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbZJBBe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:26 -0400
Received: from kroah.org ([198.145.64.141]:33585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067AbZJBBeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:27 2009
Message-Id: <20091002012427.075988827@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, RFeany@mrv.com,
       Rex Feany <rfeany@mrv.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [127/136] powerpc/8xx: Fix regression introduced by cache coherency rewrite
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-8xx-fix-regression-introduced-by-cache-coherency-rewrite.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rex Feany <RFeany@mrv.com>

commit e0908085fc2391c85b85fb814ae1df377c8e0dcb upstream.

After upgrading to the latest kernel on my mpc875 userspace started
running incredibly slow (hours to get to a shell, even!).
I tracked it down to commit 8d30c14cab30d405a05f2aaceda1e9ad57800f36,
that patch removed a work-around for the 8xx. Adding it
back makes my problem go away.

Signed-off-by: Rex Feany <rfeany@mrv.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/pgtable.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -30,6 +30,8 @@
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 
+#include "mmu_decl.h"
+
 static DEFINE_PER_CPU(struct pte_freelist_batch *, pte_freelist_cur);
 static unsigned long pte_freelist_forced_free;
 
@@ -119,7 +121,7 @@ void pte_free_finish(void)
 /*
  * Handle i/d cache flushing, called from set_pte_at() or ptep_set_access_flags()
  */
-static pte_t do_dcache_icache_coherency(pte_t pte)
+static pte_t do_dcache_icache_coherency(pte_t pte, unsigned long addr)
 {
 	unsigned long pfn = pte_pfn(pte);
 	struct page *page;
@@ -128,6 +130,17 @@ static pte_t do_dcache_icache_coherency(
 		return pte;
 	page = pfn_to_page(pfn);
 
+#ifdef CONFIG_8xx
+       /* On 8xx, cache control instructions (particularly
+        * "dcbst" from flush_dcache_icache) fault as write
+        * operation if there is an unpopulated TLB entry
+        * for the address in question. To workaround that,
+        * we invalidate the TLB here, thus avoiding dcbst
+        * misbehaviour.
+        */
+       _tlbil_va(addr, 0 /* 8xx doesn't care about PID */);
+#endif
+
 	if (!PageReserved(page) && !test_bit(PG_arch_1, &page->flags)) {
 		pr_devel("do_dcache_icache_coherency... flushing\n");
 		flush_dcache_icache_page(page);
@@ -198,7 +211,7 @@ void set_pte_at(struct mm_struct *mm, un
 	 */
 	pte = __pte(pte_val(pte) & ~_PAGE_HPTEFLAGS);
 	if (pte_need_exec_flush(pte, 1))
-		pte = do_dcache_icache_coherency(pte);
+		pte = do_dcache_icache_coherency(pte, addr);
 
 	/* Perform the setting of the PTE */
 	__set_pte_at(mm, addr, ptep, pte, 0);
@@ -216,7 +229,7 @@ int ptep_set_access_flags(struct vm_area
 {
 	int changed;
 	if (!dirty && pte_need_exec_flush(entry, 0))
-		entry = do_dcache_icache_coherency(entry);
+		entry = do_dcache_icache_coherency(entry, address);
 	changed = !pte_same(*(ptep), entry);
 	if (changed) {
 		if (!(vma->vm_flags & VM_HUGETLB))



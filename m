Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYACP2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYACP2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYACPYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:43018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbYACPYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:25 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [10/28] CPA: Change kernel_map_pages to not use c_p_a()
Message-Id: <20080103152424.9A7A614E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CONFIG_DEBUG_PAGEALLOC uses change_page_attr to map/unmap mappings for catching
stray kernel mappings. But standard c_p_a() does a lot of unnecessary work for
this simple case with pre-split mappings.

Change kernel_map_pages to just access the page table directly which
is simpler and faster.

I also fixed it to use INVLPG if available.

This is required for  changes to c_p_a() later that make it use kmalloc. Without
this we would risk infinite recursion. Also in general things are easier when
sleeping is allowed.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -258,22 +258,36 @@ void global_flush_tlb(void)
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
+/* Map or unmap pages in the kernel direct mapping for kernel debugging. */
 void kernel_map_pages(struct page *page, int numpages, int enable)
 {
+	unsigned long addr;
+	int i;
+
 	if (PageHighMem(page))
 		return;
+ 	addr = (unsigned long)page_address(page);
 	if (!enable)
-		debug_check_no_locks_freed(page_address(page),
-					   numpages * PAGE_SIZE);
+		debug_check_no_locks_freed((void *)addr, numpages * PAGE_SIZE);
+
+	/* Bootup has forced 4K pages so this is very simple */
+
+	for (i = 0; i < numpages; i++, addr += PAGE_SIZE, page++) {
+		int level;
+		pte_t *pte = lookup_address(addr, &level);
 
-	/* the return value is ignored - the calls cannot fail,
-	 * large pages are disabled at boot time.
-	 */
-	change_page_attr(page, numpages, enable ? PAGE_KERNEL : __pgprot(0));
-	/* we should perform an IPI and flush all tlbs,
-	 * but that can deadlock->flush only current cpu.
-	 */
-	__flush_tlb_all();
+		BUG_ON(level != 3);
+		if (enable) {
+			set_pte_atomic(pte, mk_pte(page, PAGE_KERNEL));
+			/*
+			 * We should perform an IPI and flush all tlbs,
+			 * but that can deadlock->flush only current cpu.
+		 	 */
+			__flush_tlb_one(addr);
+		} else {
+			kpte_clear_flush(pte, addr);
+		}
+	}
 }
 #endif
 

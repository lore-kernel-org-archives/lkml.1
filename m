Return-Path: <linux-kernel-owner+w=401wt.eu-S1764699AbYCUXu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764699AbYCUXu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763450AbYCUXr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:47:56 -0400
Received: from waste.org ([66.93.16.53]:40966 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759113AbYCUXry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:47:54 -0400
Subject: [PATCH] Change pagemap output format to allow for future reporting
	of huge pages
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 18:46:59 -0500
Message-Id: <1206143219.13528.5.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for sitting on this so long, but it would be nice to get this in
before the pagemap stuff is too widespread. We couldn't pin down the
huge page support itself, but I figured we should get the format bits in
place.

From: Hans Rosenfeld <hans.rosenfeld@amd.com>

Change pagemap output format to allow for future reporting of huge pages.

(Format comment and minor cleanups: mpm@selenic.com)

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 2f714c0f5586 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c	Thu Mar 20 09:50:21 2008 -0700
+++ b/fs/proc/task_mmu.c	Fri Mar 21 18:37:36 2008 -0500
@@ -527,13 +527,21 @@
 	char __user *out, *end;
 };
 
-#define PM_ENTRY_BYTES sizeof(u64)
-#define PM_RESERVED_BITS    3
-#define PM_RESERVED_OFFSET  (64 - PM_RESERVED_BITS)
-#define PM_RESERVED_MASK    (((1LL<<PM_RESERVED_BITS)-1) << PM_RESERVED_OFFSET)
-#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) & PM_RESERVED_MASK)
-#define PM_NOT_PRESENT      PM_SPECIAL(1LL)
-#define PM_SWAP             PM_SPECIAL(2LL)
+#define PM_ENTRY_BYTES      sizeof(u64)
+#define PM_STATUS_BITS      3
+#define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
+#define PM_STATUS_MASK      (((1LL << PM_STATUS_BITS) - 1) << PM_STATUS_OFFSET)
+#define PM_STATUS(nr)       (((nr) << PM_STATUS_OFFSET) & PM_STATUS_MASK)
+#define PM_PSHIFT_BITS      6
+#define PM_PSHIFT_OFFSET    (PM_STATUS_OFFSET - PM_PSHIFT_BITS)
+#define PM_PSHIFT_MASK      (((1LL << PM_PSHIFT_BITS) - 1) << PM_PSHIFT_OFFSET)
+#define PM_PSHIFT(x)        (((u64) (x) << PM_PSHIFT_OFFSET) & PM_PSHIFT_MASK)
+#define PM_PFRAME_MASK      ((1LL << PM_PSHIFT_OFFSET) - 1)
+#define PM_PFRAME(x)        ((x) & PM_PFRAME_MASK)
+
+#define PM_PRESENT          PM_STATUS(4LL)
+#define PM_SWAP             PM_STATUS(2LL)
+#define PM_NOT_PRESENT      PM_PSHIFT(PAGE_SHIFT)
 #define PM_END_OF_BUFFER    1
 
 static int add_to_pagemap(unsigned long addr, u64 pfn,
@@ -574,7 +582,7 @@
 u64 swap_pte_to_pagemap_entry(pte_t pte)
 {
 	swp_entry_t e = pte_to_swp_entry(pte);
-	return PM_SWAP | swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
+	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
 }
 
 static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
@@ -588,9 +596,11 @@
 		u64 pfn = PM_NOT_PRESENT;
 		pte = pte_offset_map(pmd, addr);
 		if (is_swap_pte(*pte))
-			pfn = swap_pte_to_pagemap_entry(*pte);
+			pfn = PM_PFRAME(swap_pte_to_pagemap_entry(*pte))
+				| PM_PSHIFT(PAGE_SHIFT) | PM_SWAP;
 		else if (pte_present(*pte))
-			pfn = pte_pfn(*pte);
+			pfn = PM_PFRAME(pte_pfn(*pte))
+				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT;
 		/* unmap so we're not in atomic when we copy to userspace */
 		pte_unmap(pte);
 		err = add_to_pagemap(addr, pfn, pm);
@@ -611,12 +621,20 @@
 /*
  * /proc/pid/pagemap - an array mapping virtual pages to pfns
  *
- * For each page in the address space, this file contains one 64-bit
- * entry representing the corresponding physical page frame number
- * (PFN) if the page is present. If there is a swap entry for the
- * physical page, then an encoding of the swap file number and the
- * page's offset into the swap file are returned. If no page is
- * present at all, PM_NOT_PRESENT is returned. This allows determining
+ * For each page in the address space, this file contains one 64-bit entry
+ * consisting of the following:
+ *
+ * Bits 0-55  page frame number (PFN) if present
+ * Bits 0-4   swap type if swapped
+ * Bits 5-55  swap offset if swapped
+ * Bits 55-60 page shift (page size = 1<<page shift)
+ * Bit  61    reserved for future use
+ * Bit  62    page swapped
+ * Bit  63    page present
+ *
+ * If the page is not present but in swap, then the PFN contains an
+ * encoding of the swap file number and the page's offset into the
+ * swap. Unmapped pages return a null PFN. This allows determining
  * precisely which pages are mapped (or in swap) and comparing mapped
  * pages between processes.
  *

-- 
Mathematics is the supreme nostalgia of our time.


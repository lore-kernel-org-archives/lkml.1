Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbZETSbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbZETSbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbZETSZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:45 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52720 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300AbZETSZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:29 -0400
Subject: [RFC v2][PATCH 21/35] create linux/ptemap.h for arch-independent pte mapping funcs
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:18 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182518.38E9659D@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


linux/mm.h has a couple of completely arch-independent 
pte mapping functions.  Let's move them to their own header
to help separate out their dependencies from the rest of
mm.h.

I'll get the callsites in the next patch.  For now, just
include the new header where its functions used to be.
I'll remove this in the next patch.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/linux/mm.h     |   26 ----------------------
 linux-2.6.git-dave/include/linux/ptemap.h |   34 ++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 26 deletions(-)

diff -puN include/linux/mm.h~linux-ptemap-h include/linux/mm.h
--- linux-2.6.git/include/linux/mm.h~linux-ptemap-h	2009-04-30 15:11:04.000000000 -0700
+++ linux-2.6.git-dave/include/linux/mm.h	2009-04-30 15:11:04.000000000 -0700
@@ -969,32 +969,6 @@ static inline void pgtable_page_dtor(str
 	dec_zone_page_state(page, NR_PAGETABLE);
 }
 
-#define pte_offset_map_lock(mm, pmd, address, ptlp)	\
-({							\
-	spinlock_t *__ptl = pte_lockptr(mm, pmd);	\
-	pte_t *__pte = pte_offset_map(pmd, address);	\
-	*(ptlp) = __ptl;				\
-	spin_lock(__ptl);				\
-	__pte;						\
-})
-
-#define pte_unmap_unlock(pte, ptl)	do {		\
-	spin_unlock(ptl);				\
-	pte_unmap(pte);					\
-} while (0)
-
-#define pte_alloc_map(mm, pmd, address)			\
-	((unlikely(!pmd_present(*(pmd))) && __pte_alloc(mm, pmd, address))? \
-		NULL: pte_offset_map(pmd, address))
-
-#define pte_alloc_map_lock(mm, pmd, address, ptlp)	\
-	((unlikely(!pmd_present(*(pmd))) && __pte_alloc(mm, pmd, address))? \
-		NULL: pte_offset_map_lock(mm, pmd, address, ptlp))
-
-#define pte_alloc_kernel(pmd, address)			\
-	((unlikely(!pmd_present(*(pmd))) && __pte_alloc_kernel(pmd, address))? \
-		NULL: pte_offset_kernel(pmd, address))
-
 extern void free_area_init(unsigned long * zones_size);
 extern void free_area_init_node(int nid, unsigned long * zones_size,
 		unsigned long zone_start_pfn, unsigned long *zholes_size);
diff -puN include/linux/ptemap.h~linux-ptemap-h include/linux/ptemap.h
--- linux-2.6.git/include/linux/ptemap.h~linux-ptemap-h	2009-04-30 15:11:04.000000000 -0700
+++ linux-2.6.git-dave/include/linux/ptemap.h	2009-04-30 15:11:04.000000000 -0700
@@ -0,0 +1,34 @@
+#ifndef _LINUX_PTE_MAP_H
+#define _LINUX_PTE_MAP_H
+
+#include <linux/mm.h>
+#include <asm/ptemap.h>
+
+#define pte_offset_map_lock(mm, pmd, address, ptlp)	\
+({							\
+	spinlock_t *__ptl = pte_lockptr(mm, pmd);	\
+	pte_t *__pte = pte_offset_map(pmd, address);	\
+	*(ptlp) = __ptl;				\
+	spin_lock(__ptl);				\
+	__pte;						\
+})
+
+#define pte_unmap_unlock(pte, ptl)	do {		\
+	spin_unlock(ptl);				\
+	pte_unmap(pte);					\
+} while (0)
+
+#define pte_alloc_map(mm, pmd, address)			\
+	((unlikely(!pmd_present(*(pmd))) && __pte_alloc(mm, pmd, address))? \
+		NULL: pte_offset_map(pmd, address))
+
+#define pte_alloc_map_lock(mm, pmd, address, ptlp)	\
+	((unlikely(!pmd_present(*(pmd))) && __pte_alloc(mm, pmd, address))? \
+		NULL: pte_offset_map_lock(mm, pmd, address, ptlp))
+
+#define pte_alloc_kernel(pmd, address)			\
+	((unlikely(!pmd_present(*(pmd))) && __pte_alloc_kernel(pmd, address))? \
+		NULL: pte_offset_kernel(pmd, address))
+
+
+#endif /* _LINUX_PTE_MAP_H */
_

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761117AbZEAOnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117AbZEAOnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbZEAOmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49041 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbZEAOmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:06 -0400
Subject: [RFC][PATCH 02/35] rework sparc pte functions to be consistent with other arches
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:04 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144204.7D02F25C@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sparc64 has a unique unusual pte_index().  All other architectures
just take a virtual address and give back the offset inside the
pte page of that address's pte.

The sparc64 one actually takes both the pmd_t and the virtual
address and returns the pte_t itself.  This is more akin to what
pte_offset_map() does on all the other implementations.

This patch adds a new implementations of pte_index() and
pmd_page_vaddr() which are pretty straighforward and just copied
from other architectures.

Then, we use the new functions in pte_offset_kernel().  We use
pte_offset_kernel() as the base from which we define 
pte_offset_map() and pte_offset_map_nested().  

All of this brings sparc64 back inline with what all the other
architectures are doing and prepares it for things to come. :)

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/sparc/include/asm/pgtable_64.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/sparc/include/asm/pgtable_64.h~rename-sparc-pte_index arch/sparc/include/asm/pgtable_64.h
--- linux-2.6.git/arch/sparc/include/asm/pgtable_64.h~rename-sparc-pte_index	2009-04-30 15:10:53.000000000 -0700
+++ linux-2.6.git-dave/arch/sparc/include/asm/pgtable_64.h	2009-04-30 15:10:53.000000000 -0700
@@ -619,6 +619,7 @@ static inline int pte_special(pte_t pte)
 #define __pmd_page(pmd)		\
 	((unsigned long) __va((((unsigned long)pmd_val(pmd))<<11UL)))
 #define pmd_page(pmd) 			virt_to_page((void *)__pmd_page(pmd))
+#define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
 #define pud_page_vaddr(pud)		\
 	((unsigned long) __va((((unsigned long)pud_val(pud))<<11UL)))
 #define pud_page(pud) 			virt_to_page((void *)pud_page_vaddr(pud))
@@ -646,13 +647,13 @@ static inline int pte_special(pte_t pte)
 	((pmd_t *) pud_page_vaddr(*(pudp)) + \
 	 (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1)))
 
+#define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+
 /* Find an entry in the third-level page table.. */
-#define pte_index(dir, address)	\
-	((pte_t *) __pmd_page(*(dir)) + \
-	 ((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
-#define pte_offset_kernel		pte_index
-#define pte_offset_map			pte_index
-#define pte_offset_map_nested		pte_index
+#define pte_offset_kernel(dir, address)	\
+	((pte_t *)pmd_page_vaddr(*(dir)) + pte_index(address))
+#define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
+#define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
 #define pte_unmap(pte)			do { } while (0)
 #define pte_unmap_nested(pte)		do { } while (0)
 
_

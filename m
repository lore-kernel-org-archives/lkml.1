Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZETS1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZETS1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbZETSZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34964 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115AbZETSZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:01 -0400
Subject: [RFC v2][PATCH 10/35] m68k: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:01 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182501.EB38DAEB@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/m68k/include/asm/motorola_pgtable.h |    5 --
 linux-2.6.git-dave/arch/m68k/include/asm/ptemap.h           |   22 ++++++++++++
 linux-2.6.git-dave/arch/m68k/include/asm/sun3_pgtable.h     |    6 +--
 3 files changed, 25 insertions(+), 8 deletions(-)

diff -puN arch/m68k/include/asm/motorola_pgtable.h~m68k-ptemaph arch/m68k/include/asm/motorola_pgtable.h
--- linux-2.6.git/arch/m68k/include/asm/motorola_pgtable.h~m68k-ptemaph	2009-04-30 15:10:58.000000000 -0700
+++ linux-2.6.git-dave/arch/m68k/include/asm/motorola_pgtable.h	2009-04-30 15:10:58.000000000 -0700
@@ -220,10 +220,7 @@ static inline pte_t *pte_offset_kernel(p
 	return (pte_t *)__pmd_page(*pmdp) + ((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1));
 }
 
-#define pte_offset_map(pmdp,address) ((pte_t *)__pmd_page(*pmdp) + (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
-#define pte_offset_map_nested(pmdp, address) pte_offset_map(pmdp, address)
-#define pte_unmap(pte)		((void)0)
-#define pte_unmap_nested(pte)	((void)0)
+#include <asm/ptemap.h>
 
 /*
  * Allocate and free page tables. The xxx_kernel() versions are
diff -puN /dev/null arch/m68k/include/asm/ptemap.h
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/arch/m68k/include/asm/ptemap.h	2009-04-30 15:10:58.000000000 -0700
@@ -0,0 +1,22 @@
+#ifndef _M68K_ASM_PTEMAP_H
+#define _M68K_ASM_PTEMAP_H
+
+#ifdef CONFIG_SUN3
+
+#include <linux/mm.h>
+
+#define pte_offset_map(pmd, address) ((pte_t *)kmap(pmd_page(*pmd)) + pte_index(address))
+#define pte_offset_map_nested(pmd, address) pte_offset_map(pmd, address)
+#define pte_unmap(pte) kunmap(pte)
+#define pte_unmap_nested(pte) kunmap(pte)
+
+#else /* !CONFIG_SUN3, Motorola */
+
+#define pte_offset_map(pmdp,address) ((pte_t *)__pmd_page(*pmdp) + (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
+#define pte_offset_map_nested(pmdp, address) pte_offset_map(pmdp, address)
+#define pte_unmap(pte)		((void)0)
+#define pte_unmap_nested(pte)	((void)0)
+
+#endif /* CONFIG_SUN3 */
+
+#endif /* _M68K_ASM_PTEMAP_H */
diff -puN arch/m68k/include/asm/sun3_pgtable.h~m68k-ptemaph arch/m68k/include/asm/sun3_pgtable.h
--- linux-2.6.git/arch/m68k/include/asm/sun3_pgtable.h~m68k-ptemaph	2009-04-30 15:10:58.000000000 -0700
+++ linux-2.6.git-dave/arch/m68k/include/asm/sun3_pgtable.h	2009-04-30 15:10:58.000000000 -0700
@@ -218,10 +218,8 @@ static inline pte_t pgoff_to_pte(unsigne
 #define pte_index(address) ((address >> PAGE_SHIFT) & (PTRS_PER_PTE-1))
 #define pte_offset_kernel(pmd, address) ((pte_t *) __pmd_page(*pmd) + pte_index(address))
 /* FIXME: should we bother with kmap() here? */
-#define pte_offset_map(pmd, address) ((pte_t *)kmap(pmd_page(*pmd)) + pte_index(address))
-#define pte_offset_map_nested(pmd, address) pte_offset_map(pmd, address)
-#define pte_unmap(pte) kunmap(pte)
-#define pte_unmap_nested(pte) kunmap(pte)
+
+#include <asm/ptemap.h>
 
 /* Macros to (de)construct the fake PTEs representing swap pages. */
 #define __swp_type(x)		((x).val & 0x7F)
_

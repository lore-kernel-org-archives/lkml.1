Return-Path: <linux-kernel-owner+w=401wt.eu-S1764757AbZEAOvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764757AbZEAOvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbZEAOmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41194 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760701AbZEAOmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:35 -0400
Subject: [RFC][PATCH 10/35] m68k: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:16 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144216.685FA064@kernel>
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

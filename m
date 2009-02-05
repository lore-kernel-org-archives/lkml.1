Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbZBETjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbZBETjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759986AbZBETcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:33 -0500
Received: from gw.goop.org ([64.81.55.164]:40065 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759506AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 23 of 36] x86: unify pmd_pfn
X-Mercurial-Node: fbc7e470f0309fcc068e21a12a7c23e4b864abc5
Message-Id: <fbc7e470f0309fcc068e.1233862265@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify pmd_pfn.  Unfortunately it can't be demacroed because it has a
cyclic dependency on linux/mm.h:page_to_nid().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    9 +++++++++
 arch/x86/include/asm/pgtable_32.h |    7 -------
 arch/x86/include/asm/pgtable_64.h |    3 ---
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -527,6 +527,15 @@
 	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
 }
 
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ *
+ * (Currently stuck as a macro because of indirect forward reference
+ * to linux/mm.h:page_to_nid())
+ */
+#define mk_pte(page, pgprot)   pfn_pte(page_to_pfn(page), (pgprot))
+
 #if PAGETABLE_LEVELS > 2
 static inline int pud_present(pud_t pud)
 {
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -95,13 +95,6 @@
 # include <asm/pgtable-2level.h>
 #endif
 
-/*
- * Conversion functions: convert a page and protection to a page entry,
- * and a page entry and page directory to the page they refer to.
- */
-#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
-
-
 static inline int pud_large(pud_t pud) { return 0; }
 
 /*
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -197,9 +197,6 @@
 
 /* PTE - Level 1 access. */
 
-/* page, protection -> pte */
-#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn((page)), (pgprot))
-
 #define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address) ((pte_t *) pmd_page_vaddr(*(dir)) + \
 					 pte_index((address)))



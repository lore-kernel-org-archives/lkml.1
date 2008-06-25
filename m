Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbYFYElw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbYFYElw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYFYEhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:23 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37451 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753387AbYFYEhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:16 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 10 of 36] x86: unify pgd_index
X-Mercurial-Node: bbbf042d3854bc723ef096c6736ba46d3f4093e7
Message-Id: <bbbf042d3854bc723ef0.1214367546@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:06 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pgd_index is common for 32 and 64-bit, so move it to a common place.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/pgtable.h    |   20 ++++++++++++++++++++
 include/asm-x86/pgtable_32.h |   20 --------------------
 include/asm-x86/pgtable_64.h |    3 ---
 3 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -357,6 +357,26 @@
 # include "pgtable_64.h"
 #endif
 
+/*
+ * the pgd page can be thought of an array like this: pgd_t[PTRS_PER_PGD]
+ *
+ * this macro returns the index of the entry in the pgd page which would
+ * control the given virtual address
+ */
+#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
+
+/*
+ * pgd_offset() returns a (pgd_t *)
+ * pgd_index() is used get the offset into the pgd page's array of pgd_t's;
+ */
+#define pgd_offset(mm, address) ((mm)->pgd + pgd_index((address)))
+/*
+ * a shortcut which implies the use of the kernel's pgd, instead
+ * of a process's
+ */
+#define pgd_offset_k(address) pgd_offset(&init_mm, (address))
+
+
 #define KERNEL_PGD_BOUNDARY	pgd_index(PAGE_OFFSET)
 #define KERNEL_PGD_PTRS		(PTRS_PER_PGD - KERNEL_PGD_BOUNDARY)
 
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -119,26 +119,6 @@
  */
 #define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
 
-/*
- * the pgd page can be thought of an array like this: pgd_t[PTRS_PER_PGD]
- *
- * this macro returns the index of the entry in the pgd page which would
- * control the given virtual address
- */
-#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
-#define pgd_index_k(addr) pgd_index((addr))
-
-/*
- * pgd_offset() returns a (pgd_t *)
- * pgd_index() is used get the offset into the pgd page's array of pgd_t's;
- */
-#define pgd_offset(mm, address) ((mm)->pgd + pgd_index((address)))
-
-/*
- * a shortcut which implies the use of the kernel's pgd, instead
- * of a process's
- */
-#define pgd_offset_k(address) pgd_offset(&init_mm, (address))
 
 static inline int pud_large(pud_t pud) { return 0; }
 
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -196,9 +196,6 @@
 #define pgd_page_vaddr(pgd)						\
 	((unsigned long)__va((unsigned long)pgd_val((pgd)) & PTE_MASK))
 #define pgd_page(pgd)		(pfn_to_page(pgd_val((pgd)) >> PAGE_SHIFT))
-#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
-#define pgd_offset(mm, address)	((mm)->pgd + pgd_index((address)))
-#define pgd_offset_k(address) (init_level4_pgt + pgd_index((address)))
 #define pgd_present(pgd) (pgd_val(pgd) & _PAGE_PRESENT)
 static inline int pgd_large(pgd_t pgd) { return 0; }
 #define mk_kernel_pgd(address) __pgd((address) | _KERNPG_TABLE)



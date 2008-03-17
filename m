Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYCRFcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYCRFcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYCRFY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:29 -0400
Received: from gw.goop.org ([64.81.55.164]:37855 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYCRFYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 12 of 31] x86/pgtable.h: demacro ptep_set_access_flags
X-Mercurial-Node: 6cb333f0ebd88c279a735c3feb83e9050950972c
Message-Id: <6cb333f0ebd88c279a73.1205797023@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pgtable.c     |   16 ++++++++++++++++
 include/asm-x86/pgtable.h |   13 +++----------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -1,5 +1,6 @@
 #include <linux/mm.h>
 #include <asm/pgalloc.h>
+#include <asm/pgtable.h>
 #include <asm/tlb.h>
 
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
@@ -246,3 +247,18 @@
 	free_page((unsigned long)pgd);
 }
 #endif
+
+int ptep_set_access_flags(struct vm_area_struct *vma,
+			  unsigned long address, pte_t *ptep,
+			  pte_t entry, int dirty)
+{
+	int changed = !pte_same(*ptep, entry);
+
+	if (changed && dirty) {
+		*ptep = entry;
+		pte_update_defer(vma->vm_mm, address, ptep);
+		flush_tlb_page(vma, address);
+	}
+
+	return changed;
+}
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -299,16 +299,9 @@
  * bit at the same time.
  */
 #define  __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-#define ptep_set_access_flags(vma, address, ptep, entry, dirty)		\
-({									\
-	int __changed = !pte_same(*(ptep), entry);			\
-	if (__changed && dirty) {					\
-		*ptep = entry;						\
-		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
-		flush_tlb_page(vma, address);				\
-	}								\
-	__changed;							\
-})
+extern int ptep_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pte_t *ptep,
+				 pte_t entry, int dirty);
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define ptep_test_and_clear_young(vma, addr, ptep) ({			\



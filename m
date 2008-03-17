Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYCRF2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYCRF2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYCRFYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:21 -0400
Received: from gw.goop.org ([64.81.55.164]:37845 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYCRFYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:09 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 13 of 31] x86/pgtable.h: demacro ptep_test_and_clear_young
X-Mercurial-Node: fa1668ffe5ae5645787028a30a12c0bf92be6eaa
Message-Id: <fa1668ffe5ae56457870.1205797024@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pgtable.c     |   15 +++++++++++++++
 include/asm-x86/pgtable.h |   11 ++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -262,3 +262,18 @@
 
 	return changed;
 }
+
+int ptep_test_and_clear_young(struct vm_area_struct *vma,
+			      unsigned long addr, pte_t *ptep)
+{
+	int ret = 0;
+
+	if (pte_young(*ptep))
+		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
+					 &ptep->pte);
+
+	if (ret)
+		pte_update(vma->vm_mm, addr, ptep);
+
+	return ret;
+}
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -304,15 +304,8 @@
 				 pte_t entry, int dirty);
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define ptep_test_and_clear_young(vma, addr, ptep) ({			\
-	int __ret = 0;							\
-	if (pte_young(*(ptep)))						\
-		__ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,		\
-					   &(ptep)->pte);		\
-	if (__ret)							\
-		pte_update((vma)->vm_mm, addr, ptep);			\
-	__ret;								\
-})
+extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
+				     unsigned long addr, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 #define ptep_clear_flush_young(vma, address, ptep)			\



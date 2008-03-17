Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbYCRFae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbYCRFae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYCRFYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:24 -0400
Received: from gw.goop.org ([64.81.55.164]:37857 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbYCRFYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 14 of 31] x86/pgtable.h: demacro ptep_clear_flush_young
X-Mercurial-Node: 4fc7a2f73a55afb3da967b20e7fd76d2c43d7822
Message-Id: <4fc7a2f73a55afb3da96.1205797025@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pgtable.c     |   12 ++++++++++++
 include/asm-x86/pgtable.h |   10 ++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -277,3 +277,15 @@
 
 	return ret;
 }
+
+int ptep_clear_flush_young(struct vm_area_struct *vma,
+			   unsigned long address, pte_t *ptep)
+{
+	int young;
+
+	young = ptep_test_and_clear_young(vma, address, ptep);
+	if (young)
+		flush_tlb_page(vma, address);
+
+	return young;
+}
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -308,14 +308,8 @@
 				     unsigned long addr, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-#define ptep_clear_flush_young(vma, address, ptep)			\
-({									\
-	int __young;							\
-	__young = ptep_test_and_clear_young((vma), (address), (ptep));	\
-	if (__young)							\
-		flush_tlb_page(vma, address);				\
-	__young;							\
-})
+extern int ptep_clear_flush_young(struct vm_area_struct *vma,
+				  unsigned long address, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)



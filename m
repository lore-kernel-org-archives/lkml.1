Return-Path: <linux-kernel-owner+w=401wt.eu-S1765950AbYBBJD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765950AbYBBJD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbYBBJBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:01:34 -0500
Received: from gw.goop.org ([64.81.55.164]:59440 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970AbYBBJBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:01:31 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 5] x86/pgtable.h: demacro ptep_test_and_clear_young
X-Mercurial-Node: 34c85c8865fad0fe75dfab0107e36966b2c92bb7
Message-Id: <34c85c8865fad0fe75df.1201908327@localhost>
In-Reply-To: <patchbomb.1201908323@localhost>
Date: Fri, 01 Feb 2008 15:25:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>,
       Zach Amsden <zach@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/pgtable.h |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -311,15 +311,17 @@
 }
 
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
+static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep)
+{
+	int ret = 0;
+	if (pte_young(*ptep))
+		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
+					 &ptep->pte);
+	if (ret)
+		pte_update(vma->vm_mm, addr, ptep);
+	return ret;
+}
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 #define ptep_clear_flush_young(vma, address, ptep)			\



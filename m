Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbYBBJBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbYBBJBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbYBBJBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:01:31 -0500
Received: from gw.goop.org ([64.81.55.164]:59430 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbYBBJBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:01:30 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 5] x86/pgtable.h: demacro ptep_set_access_flags
X-Mercurial-Node: cfac9c32b71b989fe2567b7216a5af29beeeaf9b
Message-Id: <cfac9c32b71b989fe256.1201908326@localhost>
In-Reply-To: <patchbomb.1201908323@localhost>
Date: Fri, 01 Feb 2008 15:25:26 -0800
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
 include/asm-x86/pgtable.h |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -287,6 +287,8 @@
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
 #endif
 
+#include <asm/tlbflush.h>
+
 /*
  * We only update the dirty/accessed state if we set
  * the dirty bit by hand in the kernel, since the hardware
@@ -295,16 +297,18 @@
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
+static inline int ptep_set_access_flags(struct vm_area_struct *vma,
+					unsigned long address, pte_t *ptep,
+					pte_t entry, int dirty)
+{
+	int changed = !pte_same(*ptep, entry);
+	if (changed && dirty) {
+		*ptep = entry;
+		pte_update_defer(vma->vm_mm, address, ptep);
+		flush_tlb_page(vma, address);
+	}
+	return changed;
+}
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define ptep_test_and_clear_young(vma, addr, ptep) ({			\



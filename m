Return-Path: <linux-kernel-owner+w=401wt.eu-S933150AbYDQJVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbYDQJVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763556AbYDQJL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:26 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59012
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763149AbYDQJLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:06 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 27/45] KVM: s390: Improve pgste accesses
Date: Thu, 17 Apr 2008 12:10:32 +0300
Message-Id: <1208423450-29415-28-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

There is no need to use interlocked updates when the rcp
lock is held. Therefore the simple bitops variants can be
used. This should improve performance.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-s390/pgtable.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-s390/pgtable.h b/include/asm-s390/pgtable.h
index 7fe5c4b..4c0698c 100644
--- a/include/asm-s390/pgtable.h
+++ b/include/asm-s390/pgtable.h
@@ -553,12 +553,12 @@ static inline void ptep_rcp_copy(pte_t *ptep)
 
 	skey = page_get_storage_key(page_to_phys(page));
 	if (skey & _PAGE_CHANGED)
-		set_bit(RCP_GC_BIT, pgste);
+		set_bit_simple(RCP_GC_BIT, pgste);
 	if (skey & _PAGE_REFERENCED)
-		set_bit(RCP_GR_BIT, pgste);
-	if (test_and_clear_bit(RCP_HC_BIT, pgste))
+		set_bit_simple(RCP_GR_BIT, pgste);
+	if (test_and_clear_bit_simple(RCP_HC_BIT, pgste))
 		SetPageDirty(page);
-	if (test_and_clear_bit(RCP_HR_BIT, pgste))
+	if (test_and_clear_bit_simple(RCP_HR_BIT, pgste))
 		SetPageReferenced(page);
 #endif
 }
@@ -732,8 +732,8 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 	young = ((page_get_storage_key(physpage) & _PAGE_REFERENCED) != 0);
 	rcp_lock(ptep);
 	if (young)
-		set_bit(RCP_GR_BIT, pgste);
-	young |= test_and_clear_bit(RCP_HR_BIT, pgste);
+		set_bit_simple(RCP_GR_BIT, pgste);
+	young |= test_and_clear_bit_simple(RCP_HR_BIT, pgste);
 	rcp_unlock(ptep);
 	return young;
 #endif
-- 
1.5.5


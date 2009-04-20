Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZDTBjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZDTBjC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:39:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZDTBiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:38:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45351 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbZDTBiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:38:05 -0400
From: Izik Eidus <ieidus@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com,
       mtosatti@redhat.com, hugh@veritas.com, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 2/5] add get_pte(): helper function: fetching pte for va
Date: Mon, 20 Apr 2009 04:36:03 +0300
Message-Id: <1240191366-10029-3-git-send-email-ieidus@redhat.com>
In-Reply-To: <1240191366-10029-2-git-send-email-ieidus@redhat.com>
References: <1240191366-10029-1-git-send-email-ieidus@redhat.com>
 <1240191366-10029-2-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_pte() receive mm_struct of a task, and a virtual address and return
the pte corresponding to it.

this function return NULL in case it couldnt fetch the pte.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 include/linux/mm.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bff1f0d..9a34109 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -894,6 +894,30 @@ int vma_wants_writenotify(struct vm_area_struct *vma);
 
 extern pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl);
 
+static inline pte_t *get_pte(struct mm_struct *mm, unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep = NULL;
+
+	pgd = pgd_offset(mm, addr);
+	if (!pgd_present(*pgd))
+		goto out;
+
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+		goto out;
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		goto out;
+
+	ptep = pte_offset_map(pmd, addr);
+out:
+	return ptep;
+}
+
 #ifdef __PAGETABLE_PUD_FOLDED
 static inline int __pud_alloc(struct mm_struct *mm, pgd_t *pgd,
 						unsigned long address)
-- 
1.5.6.5


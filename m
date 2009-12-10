Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbZLJHag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbZLJHag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760462AbZLJHaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:30:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44021 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbZLJHae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:30:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH v2  2/8] Introduce __page_check_address
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
In-Reply-To: <20091210154822.2550.A69D9226@jp.fujitsu.com>
References: <20091210154822.2550.A69D9226@jp.fujitsu.com>
Message-Id: <20091210162947.2556.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Dec 2009 16:30:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


page_check_address() need to take ptelock. but it might be contended.
Then we need trylock version and this patch introduce new helper function.

it will be used latter patch.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/rmap.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 278cd27..1b50425 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -268,44 +268,80 @@ unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
  * the page table lock when the pte is not present (helpful when reclaiming
  * highly shared pages).
  *
- * On success returns with pte mapped and locked.
+ * if @noblock is true, page_check_address may return -EAGAIN if lock is
+ * contended.
+ *
+ * Returns valid pte pointer if success.
+ * Returns -EFAULT if address seems invalid.
+ * Returns -EAGAIN if trylock failed.
  */
-pte_t *page_check_address(struct page *page, struct mm_struct *mm,
-			  unsigned long address, spinlock_t **ptlp, int sync)
+static pte_t *__page_check_address(struct page *page, struct mm_struct *mm,
+				   unsigned long address, spinlock_t **ptlp,
+				   int sync, int noblock)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 	spinlock_t *ptl;
+	int err = -EFAULT;
 
 	pgd = pgd_offset(mm, address);
 	if (!pgd_present(*pgd))
-		return NULL;
+		goto out;
 
 	pud = pud_offset(pgd, address);
 	if (!pud_present(*pud))
-		return NULL;
+		goto out;
 
 	pmd = pmd_offset(pud, address);
 	if (!pmd_present(*pmd))
-		return NULL;
+		goto out;
 
 	pte = pte_offset_map(pmd, address);
 	/* Make a quick check before getting the lock */
-	if (!sync && !pte_present(*pte)) {
-		pte_unmap(pte);
-		return NULL;
-	}
+	if (!sync && !pte_present(*pte))
+		goto out_unmap;
 
 	ptl = pte_lockptr(mm, pmd);
-	spin_lock(ptl);
+	if (noblock) {
+		if (!spin_trylock(ptl)) {
+			err = -EAGAIN;
+			goto out_unmap;
+		}
+	} else
+		spin_lock(ptl);
+
 	if (pte_present(*pte) && page_to_pfn(page) == pte_pfn(*pte)) {
 		*ptlp = ptl;
 		return pte;
 	}
-	pte_unmap_unlock(pte, ptl);
-	return NULL;
+
+	spin_unlock(ptl);
+ out_unmap:
+	pte_unmap(pte);
+ out:
+	return ERR_PTR(err);
+}
+
+/*
+ * Check that @page is mapped at @address into @mm.
+ *
+ * If @sync is false, page_check_address may perform a racy check to avoid
+ * the page table lock when the pte is not present (helpful when reclaiming
+ * highly shared pages).
+ *
+ * On success returns with pte mapped and locked.
+ */
+pte_t *page_check_address(struct page *page, struct mm_struct *mm,
+			  unsigned long address, spinlock_t **ptlp, int sync)
+{
+	pte_t *pte;
+
+	pte = __page_check_address(page, mm, address, ptlp, sync, 0);
+	if (IS_ERR(pte))
+		return NULL;
+	return pte;
 }
 
 /**
-- 
1.6.5.2




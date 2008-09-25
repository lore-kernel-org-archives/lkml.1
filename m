Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYIYLy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYIYLy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYIYLyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:54:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55119 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbYIYLyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:54:13 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       Hugh Dickins <hugh@veritas.com>, Adam Litke <agl@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/2] hugepage: support ZERO_PAGE()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080925204323.69E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080925204323.69E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080925205249.69E8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Sep 2008 20:54:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
  v1 -> v3
    o Coding style fix (Thanks mel, adam)


==========================================
Subject: [PATCH v3] hugepage: support ZERO_PAGE()

Now, hugepage doesn't use zero page at all because almost zero page is only used
for coredumping and hugepage can't core dump ago.

However now, we implemented hugepage coredumping. therefore we should implement
the zero page of hugepage.

This patch do it.


Implementation note:
-------------------------------------------------------------
o Why do we only check VM_SHARED for zero page?
  normal page checked as ..

	static inline int use_zero_page(struct vm_area_struct *vma)
	{
	        if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
	                return 0;
	
	        return !vma->vm_ops || !vma->vm_ops->fault;
	}

First, hugepages never mlock()ed. we don't need concern to VM_LOCKED.

Second, hugetlbfs is pseudo filesystem, not real filesystem and it doesn't 
have any file backing.
Then, ops->fault checking is meaningless.


o Why don't we use zero page if !pte.

!pte indicate {pud, pmd} doesn't exist or any error happend.
So, We shouldn't return zero page if any error happend.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Adam Litke <agl@us.ibm.com>
CC: Hugh Dickins <hugh@veritas.com>
CC: Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>
CC: Mel Gorman <mel@skynet.ie>

---
 mm/hugetlb.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

Index: b/mm/hugetlb.c
===================================================================
--- a/mm/hugetlb.c	2008-09-25 21:22:41.000000000 +0900
+++ b/mm/hugetlb.c	2008-09-26 02:54:10.000000000 +0900
@@ -2071,6 +2071,14 @@ follow_huge_pud(struct mm_struct *mm, un
 	return NULL;
 }
 
+static int huge_zeropage_ok(pte_t *ptep, int write, int shared)
+{
+	if (!ptep || write || shared)
+		return 0;
+	else
+		return huge_pte_none(huge_ptep_get(ptep));
+}
+
 int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			struct page **pages, struct vm_area_struct **vmas,
 			unsigned long *position, int *length, int i,
@@ -2080,6 +2088,8 @@ int follow_hugetlb_page(struct mm_struct
 	unsigned long vaddr = *position;
 	int remainder = *length;
 	struct hstate *h = hstate_vma(vma);
+	int zeropage_ok = 0;
+	int shared = vma->vm_flags & VM_SHARED;
 
 	spin_lock(&mm->page_table_lock);
 	while (vaddr < vma->vm_end && remainder) {
@@ -2092,8 +2102,11 @@ int follow_hugetlb_page(struct mm_struct
 		 * first, for the page indexing below to work.
 		 */
 		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h));
+		if (huge_zeropage_ok(pte, write, shared))
+			zeropage_ok = 1;
 
-		if (!pte || huge_pte_none(huge_ptep_get(pte)) ||
+		if (!pte ||
+		    (huge_pte_none(huge_ptep_get(pte)) && !zeropage_ok) ||
 		    (write && !pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
@@ -2113,8 +2126,11 @@ int follow_hugetlb_page(struct mm_struct
 		page = pte_page(huge_ptep_get(pte));
 same_page:
 		if (pages) {
-			get_page(page);
-			pages[i] = page + pfn_offset;
+			if (zeropage_ok)
+				pages[i] = ZERO_PAGE(0);
+			else
+				pages[i] = page + pfn_offset;
+			get_page(pages[i]);
 		}
 
 		if (vmas)



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbXLFUmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbXLFUmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXLFUmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:42:00 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54327 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbXLFUl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:41:59 -0500
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH] hugetlb: handle write-protection faults in follow_hugetlb_page
Date: Thu, 06 Dec 2007 12:41:52 -0800
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Litke <agl@us.ibm.com>, Dave Kleikamp <shaggy@us.ibm.com>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org
Message-Id: <20071206204152.16103.44490.stgit@kernel>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The follow_hugetlb_page() fix I posted (merged as git commit
5b23dbe8173c212d6a326e35347b038705603d39) missed one case.  If the pte is
present, but not writable and write access is requested by the caller to
get_user_pages(), the code will do the wrong thing.  Rather than calling
hugetlb_fault to make the pte writable, it notes the presence of the pte
and continues.

This simple one-liner makes sure we also fault on the pte for this case.
Please apply.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Dave Kleikamp <shaggy@us.ibm.com>
---

 mm/hugetlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6121b57..6f97821 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -907,7 +907,7 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		 */
 		pte = huge_pte_offset(mm, vaddr & HPAGE_MASK);
 
-		if (!pte || pte_none(*pte)) {
+		if (!pte || pte_none(*pte) || (write && !pte_write(*pte))) {
 			int ret;
 
 			spin_unlock(&mm->page_table_lock);

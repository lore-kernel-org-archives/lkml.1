Return-Path: <linux-kernel-owner+w=401wt.eu-S935090AbXHNTlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935090AbXHNTlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934474AbXHNTl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:41:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56595 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934251AbXHNTl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:41:27 -0400
Subject: [PATCH] Fix VM_FAULT flags conversion for hugetlb
From: Adam Litke <agl@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       wli@holomorphy.com, aglitke <agl@us.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Tue, 14 Aug 2007 14:41:21 -0500
Message-Id: <1187120481.14625.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems a simple mistake was made when converting follow_hugetlb_page()
over to the VM_FAULT flags bitmask stuff:
	(commit  83c54070ee1a2d05c89793884bea1a03f2851ed4).

By using the wrong bitmask, hugetlb_fault() failures are not being
recognized.  This results in an infinite loop whenever
follow_hugetlb_page is involved in a failed fault.

Signed-off-by: Adam Litke <agl@us.ibm.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d7ca59d..de4cf45 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -643,7 +643,7 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			spin_unlock(&mm->page_table_lock);
 			ret = hugetlb_fault(mm, vma, vaddr, 0);
 			spin_lock(&mm->page_table_lock);
-			if (!(ret & VM_FAULT_MAJOR))
+			if (!(ret & VM_FAULT_ERROR))
 				continue;
 
 			remainder = 0;

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center


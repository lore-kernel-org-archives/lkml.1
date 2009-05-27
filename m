Return-Path: <linux-kernel-owner+w=401wt.eu-S1762905AbZE0LQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762905AbZE0LQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760573AbZE0LMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:12:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56166 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760398AbZE0LMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:12:30 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org, Linux Memory Management List <linux-mm@kvack.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, starlight@binnacle.cx,
       Eric B Munson <ebmunson@us.ibm.com>, Adam Litke <agl@us.ibm.com>,
       Andy Whitcroft <apw@canonical.com>, wli@movementarian.org
Subject: [PATCH 1/2] x86: Ignore VM_LOCKED when determining if hugetlb-backed page tables can be shared or not
Date: Wed, 27 May 2009 12:12:28 +0100
Message-Id: <1243422749-6256-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243422749-6256-1-git-send-email-mel@csn.ul.ie>
References: <1243422749-6256-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 and x86-64, it is possible that page tables are shared beween shared
mappings backed by hugetlbfs. As part of this, page_table_shareable() checks
a pair of vma->vm_flags and they must match if they are to be shared. All
VMA flags are taken into account, including VM_LOCKED.

The problem is that VM_LOCKED is cleared on fork(). When a process with a
shared memory segment forks() to exec() a helper, there will be shared VMAs
with different flags. The impact is that the shared segment is sometimes
considered shareable and other times not, depending on what process is
checking.

What happens is that the segment page tables are being shared but the count is
inaccurate depending on the ordering of events. As the page tables are freed
with put_page(), bad pmd's are found when some of the children exit. The
hugepage counters also get corrupted and the Total and Free count will
no longer match even when all the hugepage-backed regions are freed. This
requires a reboot of the machine to "fix".

This patch addresses the problem by comparing all flags except VM_LOCKED when
deciding if pagetables should be shared or not for hugetlbfs-backed mapping.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
 arch/x86/mm/hugetlbpage.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 8f307d9..f46c340 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -26,12 +26,16 @@ static unsigned long page_table_shareable(struct vm_area_struct *svma,
 	unsigned long sbase = saddr & PUD_MASK;
 	unsigned long s_end = sbase + PUD_SIZE;
 
+	/* Allow segments to share if only one is marked locked */
+	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED;
+	unsigned long svm_flags = svma->vm_flags & ~VM_LOCKED;
+
 	/*
 	 * match the virtual addresses, permission and the alignment of the
 	 * page table page.
 	 */
 	if (pmd_index(addr) != pmd_index(saddr) ||
-	    vma->vm_flags != svma->vm_flags ||
+	    vm_flags != svm_flags ||
 	    sbase < svma->vm_start || svma->vm_end < s_end)
 		return 0;
 
-- 
1.5.6.5


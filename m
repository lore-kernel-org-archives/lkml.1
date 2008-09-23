Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYIWUq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYIWUq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYIWUpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:45:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48894 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbYIWUpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:45:51 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 1/3] Report the pagesize backing a VMA in /proc/pid/smaps
Date: Tue, 23 Sep 2008 21:45:34 +0100
Message-Id: <1222202736-13311-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1222202736-13311-1-git-send-email-mel@csn.ul.ie>
References: <1222202736-13311-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to verify a hugepage-aware application is using the expected
pagesizes for its memory regions. This patch creates an entry called
KernelPageSize in /proc/pid/smaps that is the size of page used by the kernel
to back a VMA. The entry is not called PageSize as it is possible the MMU
uses a different size. This extension should not break any sensible parser
that skips lines containing unrecognised information.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 fs/proc/task_mmu.c      |    6 ++++--
 include/linux/hugetlb.h |    3 +++
 mm/hugetlb.c            |   17 +++++++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 73d1891..08b453f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -394,7 +394,8 @@ static int show_smap(struct seq_file *m, void *v)
 		   "Private_Clean:  %8lu kB\n"
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n"
-		   "Swap:           %8lu kB\n",
+		   "Swap:           %8lu kB\n"
+		   "KernelPageSize: %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   mss.resident >> 10,
 		   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
@@ -403,7 +404,8 @@ static int show_smap(struct seq_file *m, void *v)
 		   mss.private_clean >> 10,
 		   mss.private_dirty >> 10,
 		   mss.referenced >> 10,
-		   mss.swap >> 10);
+		   mss.swap >> 10,
+		   vma_kernel_pagesize(vma) >> 10);
 
 	return ret;
 }
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 32e0ef0..ace04a7 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -231,6 +231,8 @@ static inline unsigned long huge_page_size(struct hstate *h)
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
+extern unsigned long vma_kernel_pagesize(struct vm_area_struct *vma);
+
 static inline unsigned long huge_page_mask(struct hstate *h)
 {
 	return h->mask;
@@ -271,6 +273,7 @@ struct hstate {};
 #define hstate_inode(i) NULL
 #define huge_page_size(h) PAGE_SIZE
 #define huge_page_mask(h) PAGE_MASK
+#define vma_kernel_pagesize(v) PAGE_SIZE
 #define huge_page_order(h) 0
 #define huge_page_shift(h) PAGE_SHIFT
 static inline unsigned int pages_per_huge_page(struct hstate *h)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 67a7119..9c7ff96 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -219,6 +219,23 @@ static pgoff_t vma_hugecache_offset(struct hstate *h,
 }
 
 /*
+ * Return the size of the pages allocated when backing a VMA. In the majority
+ * cases this will be same size as used by the page table entries. 
+ */
+unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	struct hstate *hstate;
+
+	if (!is_vm_hugetlb_page(vma))
+		return PAGE_SIZE;
+
+	hstate = hstate_vma(vma);
+	VM_BUG_ON(!hstate);
+
+	return 1UL << (hstate->order + PAGE_SHIFT);
+}
+
+/*
  * Flags for MAP_PRIVATE reservations.  These are stored in the bottom
  * bits of the reservation map pointer, which are always clear due to
  * alignment.
-- 
1.5.6.5


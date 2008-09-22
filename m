Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYIVBih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYIVBih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 21:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYIVBiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 21:38:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41761 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbYIVBiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 21:38:16 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 1/2] Report the pagesize backing a VMA in /proc/pid/smaps
Date: Mon, 22 Sep 2008 02:38:11 +0100
Message-Id: <1222047492-27622-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1222047492-27622-1-git-send-email-mel@csn.ul.ie>
References: <1222047492-27622-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to verify that a hugepage-aware application is using the expected
pagesizes in each of its memory regions. This patch reports the pagesize
backing the VMA in /proc/pid/smaps. This should not break any sensible
parser as the file format is multi-line and it should skip information it
does not recognise.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 fs/proc/task_mmu.c      |    6 ++++--
 include/linux/hugetlb.h |   13 +++++++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 73d1891..81a3f91 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -394,7 +394,8 @@ static int show_smap(struct seq_file *m, void *v)
 		   "Private_Clean:  %8lu kB\n"
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n"
-		   "Swap:           %8lu kB\n",
+		   "Swap:           %8lu kB\n"
+		   "PageSize:       %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   mss.resident >> 10,
 		   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
@@ -403,7 +404,8 @@ static int show_smap(struct seq_file *m, void *v)
 		   mss.private_clean >> 10,
 		   mss.private_dirty >> 10,
 		   mss.referenced >> 10,
-		   mss.swap >> 10);
+		   mss.swap >> 10,
+		   vma_page_size(vma) >> 10);
 
 	return ret;
 }
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 32e0ef0..0c83445 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -231,6 +231,19 @@ static inline unsigned long huge_page_size(struct hstate *h)
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
+static inline unsigned long vma_page_size(struct vm_area_struct *vma)
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
 static inline unsigned long huge_page_mask(struct hstate *h)
 {
 	return h->mask;
-- 
1.5.6.5


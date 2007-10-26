Return-Path: <linux-kernel-owner+w=401wt.eu-S1764097AbXJZQgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764097AbXJZQgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbXJZQgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:36:32 -0400
Received: from waste.org ([66.93.16.53]:56548 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751241AbXJZQgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:36:31 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.430487409@selenic.com>
Message-Id: <2.430487409@selenic.com>
Subject: [PATCH 1/12] maps4: add proportional set size accounting in smaps
Date: Fri, 26 Oct 2007 11:36:27 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <wfg@mail.ustc.edu.cn>

The "proportional set size" (PSS) of a process is the count of pages it has
in memory, where each page is divided by the number of processes sharing
it.  So if a process has 1000 pages all to itself, and 1000 shared with one
other process, its PSS will be 1500.

               - lwn.net: "ELC: How much memory are applications really using?"

The PSS proposed by Matt Mackall is a very nice metic for measuring an
process's memory footprint.  So collect and export it via
/proc/<pid>/smaps.

Matt Mackall's pagemap/kpagemap and John Berthels's exmap can also do the
job.  They are comprehensive tools.  But for PSS, let's do it in the simple
way.

Cc: John Berthels <jjberthels@gmail.com>
Cc: Bernardo Innocenti <bernie@codewiz.org>
Cc: Padraig Brady <P@draigBrady.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Hugh Dickins <hugh@veritas.com>
---

 fs/proc/task_mmu.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletion(-)

Index: l/fs/proc/task_mmu.c
===================================================================
--- l.orig/fs/proc/task_mmu.c	2007-10-16 21:13:47.000000000 -0500
+++ l/fs/proc/task_mmu.c	2007-10-22 15:53:12.000000000 -0500
@@ -114,6 +114,25 @@ static void pad_len_spaces(struct seq_fi
 	seq_printf(m, "%*c", len, ' ');
 }
 
+/*
+ * Proportional Set Size(PSS): my share of RSS.
+ *
+ * PSS of a process is the count of pages it has in memory, where each
+ * page is divided by the number of processes sharing it.  So if a
+ * process has 1000 pages all to itself, and 1000 shared with one other
+ * process, its PSS will be 1500.
+ *
+ * To keep (accumulated) division errors low, we adopt a 64bit
+ * fixed-point pss counter to minimize division errors. So (pss >>
+ * PSS_SHIFT) would be the real byte count.
+ *
+ * A shift of 12 before division means (assuming 4K page size):
+ * 	- 1M 3-user-pages add up to 8KB errors;
+ * 	- supports mapcount up to 2^24, or 16M;
+ * 	- supports PSS up to 2^52 bytes, or 4PB.
+ */
+#define PSS_SHIFT 12
+
 struct mem_size_stats
 {
 	unsigned long resident;
@@ -122,6 +141,7 @@ struct mem_size_stats
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+	u64 pss;
 };
 
 struct pmd_walker {
@@ -195,6 +215,7 @@ static int show_map_internal(struct seq_
 		seq_printf(m,
 			   "Size:           %8lu kB\n"
 			   "Rss:            %8lu kB\n"
+			   "Pss:            %8lu kB\n"
 			   "Shared_Clean:   %8lu kB\n"
 			   "Shared_Dirty:   %8lu kB\n"
 			   "Private_Clean:  %8lu kB\n"
@@ -202,6 +223,7 @@ static int show_map_internal(struct seq_
 			   "Referenced:     %8lu kB\n",
 			   (vma->vm_end - vma->vm_start) >> 10,
 			   mss->resident >> 10,
+			   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
 			   mss->shared_clean  >> 10,
 			   mss->shared_dirty  >> 10,
 			   mss->private_clean >> 10,
@@ -226,6 +248,7 @@ static void smaps_pte_range(struct vm_ar
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
+	int mapcount;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
@@ -242,16 +265,19 @@ static void smaps_pte_range(struct vm_ar
 		/* Accumulate the size in pages that have been accessed. */
 		if (pte_young(ptent) || PageReferenced(page))
 			mss->referenced += PAGE_SIZE;
-		if (page_mapcount(page) >= 2) {
+		mapcount = page_mapcount(page);
+		if (mapcount >= 2) {
 			if (pte_dirty(ptent))
 				mss->shared_dirty += PAGE_SIZE;
 			else
 				mss->shared_clean += PAGE_SIZE;
+			mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
 		} else {
 			if (pte_dirty(ptent))
 				mss->private_dirty += PAGE_SIZE;
 			else
 				mss->private_clean += PAGE_SIZE;
+			mss->pss += (PAGE_SIZE << PSS_SHIFT);
 		}
 	}
 	pte_unmap_unlock(pte - 1, ptl);

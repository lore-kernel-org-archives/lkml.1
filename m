Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXHSH4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXHSH4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXHSHzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:55:53 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50431 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751125AbXHSHzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:55:51 -0400
Message-ID: <387510147.10542@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070819075547.445659254@mail.ustc.edu.cn>
References: <20070819075410.411207640@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 19 Aug 2007 15:54:11 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Matt Mackall <mpm@selenic.com>, John Berthels <jjberthels@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] maps: PSS(proportional set size) accounting in smaps
Content-Disposition: inline; filename=smaps-pss.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The "proportional set size" (PSS) of a process is the count of pages it has in
memory, where each page is divided by the number of processes sharing it. So if
a process has 1000 pages all to itself, and 1000 shared with one other process,
its PSS will be 1500.
               - lwn.net: "ELC: How much memory are applications really using?"

The PSS proposed by Matt Mackall is a very nice metic for measuring an process's
memory footprint. So collect and export it via /proc/<pid>/smaps.

Matt Mackall's pagemap/kpagemap and John Berthels's exmap can also do the job.
They are comprehensive tools. But for PSS, let's do it in the simple way. 


Cc: John Berthels <jjberthels@gmail.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/proc/task_mmu.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc2-mm2.orig/fs/proc/task_mmu.c
+++ linux-2.6.23-rc2-mm2/fs/proc/task_mmu.c
@@ -324,6 +324,27 @@ struct mem_size_stats
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+
+	/*
+	 * Proportional Set Size(PSS): my share of RSS.
+	 *
+	 * PSS of a process is the count of pages it has in memory, where each
+	 * page is divided by the number of processes sharing it.  So if a
+	 * process has 1000 pages all to itself, and 1000 shared with one other
+	 * process, its PSS will be 1500.               - Matt Mackall, lwn.net
+	 */
+	u64 	      pss;
+	/*
+	 * To keep (accumulated) division errors low, we adopt 64bit pss and
+	 * use some low bits for division errors. So (pss >> PSS_ERROR_BITS)
+	 * would be the real byte count.
+	 *
+	 * A shift of 12 before division means(assuming 4K page size):
+	 * 	- 1M 3-user-pages add up to 8KB errors;
+	 * 	- supports mapcount up to 2^24, or 16M;
+	 * 	- supports PSS up to 2^52 bytes, or 4PB.
+	 */
+#define PSS_ERROR_BITS	12
 };
 
 struct smaps_arg
@@ -341,6 +362,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
+	int mapcount;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
@@ -357,16 +379,19 @@ static int smaps_pte_range(pmd_t *pmd, u
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
+			mss->pss += (PAGE_SIZE << PSS_ERROR_BITS) / mapcount;
 		} else {
 			if (pte_dirty(ptent))
 				mss->private_dirty += PAGE_SIZE;
 			else
 				mss->private_clean += PAGE_SIZE;
+			mss->pss += (PAGE_SIZE << PSS_ERROR_BITS);
 		}
 	}
 	pte_unmap_unlock(pte - 1, ptl);
@@ -395,6 +420,7 @@ static int show_smap(struct seq_file *m,
 	seq_printf(m,
 		   "Size:           %8lu kB\n"
 		   "Rss:            %8lu kB\n"
+		   "Pss:            %8lu kB\n"
 		   "Shared_Clean:   %8lu kB\n"
 		   "Shared_Dirty:   %8lu kB\n"
 		   "Private_Clean:  %8lu kB\n"
@@ -402,6 +428,7 @@ static int show_smap(struct seq_file *m,
 		   "Referenced:     %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   sarg.mss.resident >> 10,
+		   (unsigned long)(sarg.mss.pss >> (10 + PSS_ERROR_BITS)),
 		   sarg.mss.shared_clean  >> 10,
 		   sarg.mss.shared_dirty  >> 10,
 		   sarg.mss.private_clean >> 10,

-- 

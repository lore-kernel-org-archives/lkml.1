Return-Path: <linux-kernel-owner+w=401wt.eu-S937113AbXHNBeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937113AbXHNBeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 21:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761274AbXHNBd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 21:33:57 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:46619 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757566AbXHNBd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 21:33:56 -0400
Message-ID: <387055231.26624@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 14 Aug 2007 09:33:50 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, John Berthels <jjberthels@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] PSS(proportional set size) accounting in smaps
Message-ID: <20070814013350.GA9182@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>,
	John Berthels <jjberthels@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The "proportional set size" (PSS) of a process is the count of pages it has in
memory, where each page is divided by the number of processes sharing it. So if
a process has 1000 pages all to itself, and 1000 shared with one other process,
its PSS will be 1500.
               - lwn.net: "ELC: How much memory are applications really using?"

The PSS proposed by Matt Mackall is a very nice metic for measuring an process's
memory footprint. So collect and export it via /proc/<pid>/smaps.

Matt Mackall's pagemap/kpagemap and John Berthels's exmap can also do the job,
providing pretty much details.  But for PSS, let's do it in a simple way. 

Cc: Matt Mackall <mpm@selenic.com>
Cc: John Berthels <jjberthels@gmail.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/proc/task_mmu.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/fs/proc/task_mmu.c
+++ linux-2.6.23-rc2-mm2/fs/proc/task_mmu.c
@@ -319,6 +319,7 @@ const struct file_operations proc_maps_o
 struct mem_size_stats
 {
 	unsigned long resident;
+	u64 	      pss;	/* proportional set size: my share of rss */
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
 	unsigned long private_clean;
@@ -341,6 +342,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
+	int mapcount;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
@@ -357,16 +359,19 @@ static int smaps_pte_range(pmd_t *pmd, u
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
+			mss->pss += (PAGE_SIZE << 12) / mapcount;
 		} else {
 			if (pte_dirty(ptent))
 				mss->private_dirty += PAGE_SIZE;
 			else
 				mss->private_clean += PAGE_SIZE;
+			mss->pss += (PAGE_SIZE << 12);
 		}
 	}
 	pte_unmap_unlock(pte - 1, ptl);
@@ -395,18 +400,20 @@ static int show_smap(struct seq_file *m,
 	seq_printf(m,
 		   "Size:           %8lu kB\n"
 		   "Rss:            %8lu kB\n"
+		   "Pss:            %8lu kB\n"
 		   "Shared_Clean:   %8lu kB\n"
 		   "Shared_Dirty:   %8lu kB\n"
 		   "Private_Clean:  %8lu kB\n"
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
-		   sarg.mss.resident >> 10,
+		   sarg.mss.resident      >> 10,
+		   (unsigned long)(mss->pss >> 22),
 		   sarg.mss.shared_clean  >> 10,
 		   sarg.mss.shared_dirty  >> 10,
 		   sarg.mss.private_clean >> 10,
 		   sarg.mss.private_dirty >> 10,
-		   sarg.mss.referenced >> 10);
+		   sarg.mss.referenced    >> 10);
 
 	return ret;
 }


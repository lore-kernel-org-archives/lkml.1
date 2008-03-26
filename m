Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYCZP2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYCZP2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYCZP2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:28:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55161 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYCZP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:28:38 -0400
Subject: [PATCH] smaps: account swap entries
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>, mpm <mpm@selenic.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 16:28:24 +0100
Message-Id: <1206545304.8514.494.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: smaps: account swap entries

Show the amount of swap for each vma. This can be used to see where all the
swap goes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/proc/task_mmu.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.orig/fs/proc/task_mmu.c
+++ linux-2.6/fs/proc/task_mmu.c
@@ -313,6 +313,7 @@ struct mem_size_stats
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+	unsigned long swap;
 	u64 pss;
 };
 
@@ -329,6 +330,12 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
+
+		if (is_swap_pte(ptent)) {
+			mss->swap += PAGE_SIZE;
+			continue;
+		}
+
 		if (!pte_present(ptent))
 			continue;
 
@@ -387,7 +394,8 @@ static int show_smap(struct seq_file *m,
 		   "Shared_Dirty:   %8lu kB\n"
 		   "Private_Clean:  %8lu kB\n"
 		   "Private_Dirty:  %8lu kB\n"
-		   "Referenced:     %8lu kB\n",
+		   "Referenced:     %8lu kB\n"
+		   "Swap:           %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   mss.resident >> 10,
 		   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
@@ -395,7 +403,8 @@ static int show_smap(struct seq_file *m,
 		   mss.shared_dirty  >> 10,
 		   mss.private_clean >> 10,
 		   mss.private_dirty >> 10,
-		   mss.referenced >> 10);
+		   mss.referenced >> 10,
+		   mss.swap >> 10);
 
 	return ret;
 }



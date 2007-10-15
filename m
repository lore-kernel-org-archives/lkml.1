Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbXJOW1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbXJOW1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXJOW0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:26:12 -0400
Received: from waste.org ([66.93.16.53]:1292 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754803AbXJOW0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:26:06 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.290135367@selenic.com>
Message-Id: <7.290135367@selenic.com>
Subject: [PATCH 6/11] maps3: simplify interdependence of maps and smaps
Date: Mon, 15 Oct 2007 17:26:03 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>

This pulls the shared map display code out of show_map and puts it in
show_smap where it belongs.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Index: l/fs/proc/task_mmu.c
===================================================================
--- l.orig/fs/proc/task_mmu.c	2007-10-14 13:37:08.000000000 -0500
+++ l/fs/proc/task_mmu.c	2007-10-14 13:38:43.000000000 -0500
@@ -146,7 +146,7 @@ struct mem_size_stats
 #define PSS_DIV_BITS	12
 };
 
-static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats *mss)
+static int show_map(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
 	struct task_struct *task = priv->task;
@@ -206,35 +206,11 @@ static int show_map_internal(struct seq_
 	}
 	seq_putc(m, '\n');
 
-	if (mss)
-		seq_printf(m,
-			   "Size:           %8lu kB\n"
-			   "Rss:            %8lu kB\n"
-			   "Pss:            %8lu kB\n"
-			   "Shared_Clean:   %8lu kB\n"
-			   "Shared_Dirty:   %8lu kB\n"
-			   "Private_Clean:  %8lu kB\n"
-			   "Private_Dirty:  %8lu kB\n"
-			   "Referenced:     %8lu kB\n",
-			   (vma->vm_end - vma->vm_start) >> 10,
-			   mss->resident >> 10,
-			   (unsigned long)(mss.pss >> (10 + PSS_DIV_BITS)),
-			   mss->shared_clean  >> 10,
-			   mss->shared_dirty  >> 10,
-			   mss->private_clean >> 10,
-			   mss->private_dirty >> 10,
-			   mss->referenced >> 10);
-
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task))? vma->vm_start: 0;
 	return 0;
 }
 
-static int show_map(struct seq_file *m, void *v)
-{
-	return show_map_internal(m, v, NULL);
-}
-
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   void *private)
 {
@@ -313,13 +289,37 @@ static int show_smap(struct seq_file *m,
 {
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
+	int ret;
 
 	memset(&mss, 0, sizeof mss);
 	mss.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
 				&smaps_walk, &mss);
-	return show_map_internal(m, v, &mss);
+
+	ret = show_map(m, v);
+	if (ret)
+		return ret;
+
+	seq_printf(m,
+		   "Size:           %8lu kB\n"
+		   "Rss:            %8lu kB\n"
+		   "Pss:            %8lu kB\n"
+		   "Shared_Clean:   %8lu kB\n"
+		   "Shared_Dirty:   %8lu kB\n"
+		   "Private_Clean:  %8lu kB\n"
+		   "Private_Dirty:  %8lu kB\n"
+		   "Referenced:     %8lu kB\n",
+		   (vma->vm_end - vma->vm_start) >> 10,
+		   mss.resident >> 10,
+		   (unsigned long)(mss.pss >> (10 + PSS_DIV_BITS)),
+		   mss.shared_clean  >> 10,
+		   mss.shared_dirty  >> 10,
+		   mss.private_clean >> 10,
+		   mss.private_dirty >> 10,
+		   mss.referenced >> 10);
+
+	return ret;
 }
 
 static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };

Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbXDFWCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbXDFWCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933203AbXDFWCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:02:19 -0400
Received: from waste.org ([66.93.16.53]:40096 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933174AbXDFWBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:01:42 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.469046093@selenic.com>
Message-Id: <8.469046093@selenic.com>
Subject: [PATCH 7/13] maps#2: Simplify interdependence of /proc/pid/maps and smaps
Date: Fri, 06 Apr 2007 17:03:08 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify interdependence of /proc/pid/maps and smaps

This pulls the shared map display code out of show_map and puts it in
show_smap where it belongs.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/task_mmu.c
===================================================================
--- mm.orig/fs/proc/task_mmu.c	2007-04-03 14:50:33.000000000 -0500
+++ mm/fs/proc/task_mmu.c	2007-04-03 18:35:45.000000000 -0500
@@ -125,7 +125,7 @@ struct mem_size_stats
 	unsigned long referenced;
 };
 
-static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats *mss)
+static int show_map(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
 	struct task_struct *task = priv->task;
@@ -185,33 +185,11 @@ static int show_map_internal(struct seq_
 	}
 	seq_putc(m, '\n');
 
-	if (mss)
-		seq_printf(m,
-			   "Size:           %8lu kB\n"
-			   "Rss:            %8lu kB\n"
-			   "Shared_Clean:   %8lu kB\n"
-			   "Shared_Dirty:   %8lu kB\n"
-			   "Private_Clean:  %8lu kB\n"
-			   "Private_Dirty:  %8lu kB\n"
-			   "Referenced:     %8lu kB\n",
-			   (vma->vm_end - vma->vm_start) >> 10,
-			   mss->resident >> 10,
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
@@ -286,13 +264,35 @@ static int show_smap(struct seq_file *m,
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
+		   "Shared_Clean:   %8lu kB\n"
+		   "Shared_Dirty:   %8lu kB\n"
+		   "Private_Clean:  %8lu kB\n"
+		   "Private_Dirty:  %8lu kB\n"
+		   "Referenced:     %8lu kB\n",
+		   (vma->vm_end - vma->vm_start) >> 10,
+		   mss.resident >> 10,
+		   mss.shared_clean  >> 10,
+		   mss.shared_dirty  >> 10,
+		   mss.private_clean >> 10,
+		   mss.private_dirty >> 10,
+		   mss.referenced >> 10);
+
+	return ret;
 }
 
 static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbXGHFdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbXGHFdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 01:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXGHFdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 01:33:31 -0400
Received: from ozlabs.org ([203.10.76.45]:53819 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXGHFdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 01:33:31 -0400
Subject: maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 15:32:57 +1000
Message-Id: <1183872777.6005.264.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt coded:
> diff -puN fs/proc/task_mmu.c~maps2-eliminate-the-pmd_walker-struct-in-the-page-walker fs/proc/task_mmu.c
> --- a/fs/proc/task_mmu.c~maps2-eliminate-the-pmd_walker-struct-in-the-page-walker
> +++ a/fs/proc/task_mmu.c
> @@ -116,6 +116,7 @@ static void pad_len_spaces(struct seq_fi
>  
>  struct mem_size_stats
>  {
> +	struct vm_area_struct *vma;
>  	unsigned long resident;
>  	unsigned long shared_clean;
>  	unsigned long shared_dirty;

Hi Matt,

	I was looking at this patch, and slapping a vma in a structure called
"*_stats" is fairly ugly.  How about this (applies on top):

==
mmaps2-vma-out-of-mem_size_stats.patch

Putting the vma inside "struct mem_size_stats" to hand it through the
pagewalker is a little gross.  Making a separate struct is more
verbose, but clearer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 6c7143b1a410 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c	Fri Jul 06 10:30:39 2007 +1000
+++ b/fs/proc/task_mmu.c	Sun Jul 08 15:29:00 2007 +1000
@@ -318,7 +318,6 @@ const struct file_operations proc_maps_o
 #ifdef CONFIG_PROC_SMAPS
 struct mem_size_stats
 {
-	struct vm_area_struct *vma;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -327,11 +326,18 @@ struct mem_size_stats
 	unsigned long referenced;
 };
 
+struct smaps_arg
+{
+	struct mem_size_stats mss;
+	struct vm_area_struct *vma;
+};
+
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   void *private)
 {
-	struct mem_size_stats *mss = private;
-	struct vm_area_struct *vma = mss->vma;
+	struct smaps_arg *sarg = private;
+	struct vm_area_struct *vma = sarg->vma;
+	struct mem_size_stats *mss = &sarg->mss;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -373,14 +379,14 @@ static int show_smap(struct seq_file *m,
 static int show_smap(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
-	struct mem_size_stats mss;
+	struct smaps_arg sarg;
 	int ret;
 
-	memset(&mss, 0, sizeof mss);
-	mss.vma = vma;
+	memset(&sarg.mss, 0, sizeof sarg.mss);
+	sarg.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
-				&smaps_walk, &mss);
+				&smaps_walk, &sarg);
 
 	ret = show_map(m, v);
 	if (ret)
@@ -395,12 +401,12 @@ static int show_smap(struct seq_file *m,
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
-		   mss.resident >> 10,
-		   mss.shared_clean  >> 10,
-		   mss.shared_dirty  >> 10,
-		   mss.private_clean >> 10,
-		   mss.private_dirty >> 10,
-		   mss.referenced >> 10);
+		   sarg.mss.resident >> 10,
+		   sarg.mss.shared_clean  >> 10,
+		   sarg.mss.shared_dirty  >> 10,
+		   sarg.mss.private_clean >> 10,
+		   sarg.mss.private_dirty >> 10,
+		   sarg.mss.referenced >> 10);
 
 	return ret;
 }



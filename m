Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYCRBMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYCRBMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 21:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbYCRBJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 21:09:53 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:38154 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYCRBJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 21:09:44 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080318209.039112899@firstfloor.org>
In-Reply-To: <20080318209.039112899@firstfloor.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH prototype] [8/8] Add mmap_full_slurp support
Message-Id: <20080318010942.64C241B41E1@basil.firstfloor.org>
Date: Tue, 18 Mar 2008 02:09:42 +0100 (CET)
X-OriginalArrivalTime: 18 Mar 2008 01:03:07.0689 (UTC) FILETIME=[D3E8F990:01C88893]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the non-subtle brother of pbitmaps. Instead of only prefetching
the pages used last time always prefetch complete mmap areas
(subject to the max_ra_chunk limits)

Main advantage is that it works for shared libraries too (but
the prefetching is currently done for all file backed mmaps, 
not just executable mappings)

Disadvantage is that uses far more memory and does a lot of 
unnecessary work.

Still is faster in some circumstances.

Experimental.  Mainly added for comparison. Off by default. 
Probably not a good idea.  

I'm more including it for easier experimentation.

Signed-off-by: Andi Kleen <andi@firstfloor.org>

---
 include/linux/mm.h |    2 ++
 kernel/sysctl.c    |   10 ++++++++++
 mm/mmap.c          |   10 ++++++++++
 3 files changed, 22 insertions(+)

Index: linux/mm/mmap.c
===================================================================
--- linux.orig/mm/mmap.c
+++ linux/mm/mmap.c
@@ -40,6 +40,8 @@
 #define arch_rebalance_pgtables(addr, len)		(addr)
 #endif
 
+int mmap_full_slurp __read_mostly;
+
 static void unmap_region(struct mm_struct *mm,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
@@ -2023,6 +2025,14 @@ out:
 		mm->locked_vm += len >> PAGE_SHIFT;
 		make_pages_present(addr, addr + len);
 	}
+	if (vma->vm_file && mmap_full_slurp) {
+		up_write(&mm->mmap_sem);
+		force_page_cache_readahead(vma->vm_file->f_mapping,
+					   vma->vm_file,
+					   vma->vm_pgoff,
+					   max_sane_readahead(vma_pages(vma)));
+		down_write(&mm->mmap_sem);
+	}
 	return addr;
 }
 
Index: linux/include/linux/mm.h
===================================================================
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -1077,6 +1077,8 @@ extern int do_munmap(struct mm_struct *,
 
 extern unsigned long do_brk(unsigned long, unsigned long);
 
+extern int mmap_full_slurp;
+
 /* filemap.c */
 extern unsigned long page_unuse(struct page *);
 extern void truncate_inode_pages(struct address_space *, loff_t);
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -909,6 +909,16 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one_hundred,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "mmap_full_slurp",
+		.data		= &mmap_full_slurp,
+		.maxlen 	= sizeof(mmap_full_slurp),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1 	= &zero,
+	},
+	{
 		.procname	= "dirty_writeback_centisecs",
 		.data		= &dirty_writeback_interval,
 		.maxlen		= sizeof(dirty_writeback_interval),

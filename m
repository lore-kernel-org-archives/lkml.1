Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbYBOR6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbYBOR6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbYBOR6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:58:32 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:59340 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430AbYBOR6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:58:31 -0500
Date: Fri, 15 Feb 2008 21:01:52 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Miklos Szeredi <mszeredi@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm] mmap_region: cleanup the final vma_merge() related code
Message-ID: <20080215180152.GA4344@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(textually depends on procfs-task-exe-symlink.patch)

It is not easy to actually understand the "if (!file || !vma_merge())" code,
turn it into "if (file && vma_merge())". This makes immediately obvious that
the subsequent "if (file)" is superfluous.

As Hugh Dickins pointed out, we can also factor out the ->i_writecount
corrections, and add a small comment about that.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/mm/mmap.c~1_MMAP	2008-02-15 17:48:48.000000000 +0300
+++ 25/mm/mmap.c	2008-02-15 18:23:26.000000000 +0300
@@ -1070,7 +1070,6 @@ int vma_wants_writenotify(struct vm_area
 		mapping_cap_account_dirty(vma->vm_file->f_mapping);
 }
 
-
 unsigned long mmap_region(struct file *file, unsigned long addr,
 			  unsigned long len, unsigned long flags,
 			  unsigned int vm_flags, unsigned long pgoff,
@@ -1185,24 +1184,22 @@ munmap_back:
 	if (vma_wants_writenotify(vma))
 		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
 
-	if (!file || !vma_merge(mm, prev, addr, vma->vm_end,
+	if (file && vma_merge(mm, prev, addr, vma->vm_end,
 			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
-		file = vma->vm_file;
-		vma_link(mm, vma, prev, rb_link, rb_parent);
-		if (correct_wcount)
-			atomic_inc(&inode->i_writecount);
-	} else {
-		if (file) {
-			if (correct_wcount)
-				atomic_inc(&inode->i_writecount);
-			fput(file);
-			if (vm_flags & VM_EXECUTABLE)
-				removed_exe_file_vma(mm);
-		}
 		mpol_free(vma_policy(vma));
 		kmem_cache_free(vm_area_cachep, vma);
+		fput(file);
+		if (vm_flags & VM_EXECUTABLE)
+			removed_exe_file_vma(mm);
+	} else {
+		vma_link(mm, vma, prev, rb_link, rb_parent);
+		file = vma->vm_file;
 	}
-out:	
+
+	/* Once vma denies write, undo our temporary denial count */
+	if (correct_wcount)
+		atomic_inc(&inode->i_writecount);
+out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbYBCR6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbYBCR6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 12:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbYBCR6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 12:58:10 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:33655 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180AbYBCR6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 12:58:09 -0500
Date: Sun, 3 Feb 2008 21:01:22 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] mmap_region: cleanup, remove unneeded file != NULL check
Message-ID: <20080203180122.GA5819@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmap_region() checks "file != NULL" when we know "file && vma_merge() == T".
Also, swap these if/else branches, imho make the code a bit more readable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- MM/mm/mmap.c~1_MMAP	2008-01-27 17:09:47.000000000 +0300
+++ MM/mm/mmap.c	2008-02-03 20:49:39.000000000 +0300
@@ -1189,22 +1189,20 @@ munmap_back:
 	if (vma_wants_writenotify(vma))
 		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
 
-	if (!file || !vma_merge(mm, prev, addr, vma->vm_end,
+	if (file && vma_merge(mm, prev, addr, vma->vm_end,
 			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
+		mpol_free(vma_policy(vma));
+		kmem_cache_free(vm_area_cachep, vma);
+		if (correct_wcount)
+			atomic_inc(&inode->i_writecount);
+		fput(file);
+	} else {
 		file = vma->vm_file;
 		vma_link(mm, vma, prev, rb_link, rb_parent);
 		if (correct_wcount)
 			atomic_inc(&inode->i_writecount);
-	} else {
-		if (file) {
-			if (correct_wcount)
-				atomic_inc(&inode->i_writecount);
-			fput(file);
-		}
-		mpol_free(vma_policy(vma));
-		kmem_cache_free(vm_area_cachep, vma);
 	}
-out:	
+out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {


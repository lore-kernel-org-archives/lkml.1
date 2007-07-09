Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbXGISst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbXGISst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbXGISsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:48:42 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:3626 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbXGISsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:48:41 -0400
Date: Mon, 9 Jul 2007 22:49:17 +0400
From: Dmitry Monakhov <dmonakhov@sw.ru>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] mm: recheck lock rlim after f_op->mmap() method
Message-ID: <20070709184917.GA8720@dnb.sw.ru>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SWsoft.
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some device drivers can change vm_flags in their f_op->mmap
method. In order to be on the safe side we have to recheck
lock rlimit. Now we have to check lock rlimit from two places,
let's move this common code to helper functon.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 mm/mmap.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 906ed40..5c89f1d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -885,6 +885,18 @@ void vm_stat_account(struct mm_struct *mm, unsigned long flags,
 }
 #endif /* CONFIG_PROC_FS */
 
+static int check_lock_limit(unsigned long delta, struct mm_struct* mm)
+{
+	unsigned long locked, lock_limit;
+	locked = delta >> PAGE_SHIFT;
+	locked += mm->locked_vm;
+	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit >>= PAGE_SHIFT;
+	if (locked > lock_limit && !capable(CAP_IPC_LOCK))
+		return -EAGAIN;
+	return 0;
+}
+
 /*
  * The caller must hold down_write(current->mm->mmap_sem).
  */
@@ -954,13 +966,9 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 	}
 	/* mlock MCL_FUTURE? */
 	if (vm_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			return -EAGAIN;
+		error = check_lock_limit(len, mm);
+		if (error)
+			return error;
 	}
 
 	inode = file ? file->f_path.dentry->d_inode : NULL;
@@ -1101,6 +1109,17 @@ munmap_back:
 		error = file->f_op->mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
+		
+		if (vma->vm_flags & VM_LOCKED
+				&& !(vm_flags & VM_LOCKED)) {
+		/*
+		 * VM_LOCKED was added in f_op->mmap() method,
+		 * so we have to recheck limit.
+		 */
+			error = check_lock_limit(len, mm);
+			if (error)
+				goto unmap_and_free_vma;
+		}
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
 		if (error)
-- 
1.5.2.2



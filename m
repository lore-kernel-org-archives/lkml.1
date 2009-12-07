Return-Path: <linux-kernel-owner+w=401wt.eu-S933181AbZLGDv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbZLGDv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbZLGDvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:51:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51464 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144AbZLGDvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:51:55 -0500
Date: Mon, 07 Dec 2009 03:52:00 +0000
To: linux-arch@vger.kernel.org
Subject: [PATCH 1/19] untangling do_mremap(), part 1
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NHUdk-0007ul-Oc@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Take locating vma and checks on it to a separate helper (it will be
shared between MREMAP_FIXED/non-MREMAP_FIXED cases when we split
them in the next patch)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/mremap.c |   88 +++++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 97bff25..6776136 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -261,6 +261,58 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	return new_addr;
 }
 
+static struct vm_area_struct *vma_to_resize(unsigned long addr,
+	unsigned long old_len, unsigned long new_len, unsigned long *p)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = find_vma(mm, addr);
+
+	if (!vma || vma->vm_start > addr)
+		goto Efault;
+
+	if (is_vm_hugetlb_page(vma))
+		goto Einval;
+
+	/* We can't remap across vm area boundaries */
+	if (old_len > vma->vm_end - addr)
+		goto Efault;
+
+	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)) {
+		if (new_len > old_len)
+			goto Efault;
+	}
+
+	if (vma->vm_flags & VM_LOCKED) {
+		unsigned long locked, lock_limit;
+		locked = mm->locked_vm << PAGE_SHIFT;
+		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+		locked += new_len - old_len;
+		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
+			goto Eagain;
+	}
+
+	if (!may_expand_vm(mm, (new_len - old_len) >> PAGE_SHIFT))
+		goto Enomem;
+
+	if (vma->vm_flags & VM_ACCOUNT) {
+		unsigned long charged = (new_len - old_len) >> PAGE_SHIFT;
+		if (security_vm_enough_memory(charged))
+			goto Efault;
+		*p = charged;
+	}
+
+	return vma;
+
+Efault:	/* very odd choice for most of the cases, but... */
+	return ERR_PTR(-EFAULT);
+Einval:
+	return ERR_PTR(-EINVAL);
+Enomem:
+	return ERR_PTR(-ENOMEM);
+Eagain:
+	return ERR_PTR(-EAGAIN);
+}
+
 /*
  * Expand (or shrink) an existing mapping, potentially moving it at the
  * same time (controlled by the MREMAP_MAYMOVE flag and available VM space)
@@ -340,41 +392,12 @@ unsigned long do_mremap(unsigned long addr,
 	/*
 	 * Ok, we need to grow..  or relocate.
 	 */
-	ret = -EFAULT;
-	vma = find_vma(mm, addr);
-	if (!vma || vma->vm_start > addr)
-		goto out;
-	if (is_vm_hugetlb_page(vma)) {
-		ret = -EINVAL;
-		goto out;
-	}
-	/* We can't remap across vm area boundaries */
-	if (old_len > vma->vm_end - addr)
-		goto out;
-	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)) {
-		if (new_len > old_len)
-			goto out;
-	}
-	if (vma->vm_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = mm->locked_vm << PAGE_SHIFT;
-		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
-		locked += new_len - old_len;
-		ret = -EAGAIN;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			goto out;
-	}
-	if (!may_expand_vm(mm, (new_len - old_len) >> PAGE_SHIFT)) {
-		ret = -ENOMEM;
+	vma = vma_to_resize(addr, old_len, new_len, &charged);
+	if (IS_ERR(vma)) {
+		ret = PTR_ERR(vma);
 		goto out;
 	}
 
-	if (vma->vm_flags & VM_ACCOUNT) {
-		charged = (new_len - old_len) >> PAGE_SHIFT;
-		if (security_vm_enough_memory(charged))
-			goto out_nc;
-	}
-
 	/* old_len exactly to the end of the area..
 	 * And we're not relocating the area.
 	 */
@@ -430,7 +453,6 @@ unsigned long do_mremap(unsigned long addr,
 out:
 	if (ret & ~PAGE_MASK)
 		vm_unacct_memory(charged);
-out_nc:
 	return ret;
 }
 
-- 
1.5.6.5



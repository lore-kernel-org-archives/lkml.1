Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbXF0CpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbXF0CpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 22:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758320AbXF0CoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 22:44:23 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3554 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242AbXF0CoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 22:44:21 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 26 Jun 2007 19:44:18 -0700
Subject: [patch 2/3] MAP_NOZERO - implement sys_brk2()
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch implements the sys_brk2() syscall, that nothing is
other than a sys_brk() with an extra "flags" parameter. This can be used
to pass the new MAP_NOZERO bit, to ask the kernel to hand over non-zero
pages if possible.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 include/linux/mm.h       |    3 ++-
 include/linux/syscalls.h |    1 +
 mm/mmap.c                |   22 ++++++++++++++++++----
 3 files changed, 21 insertions(+), 5 deletions(-)

Index: linux-2.6.mod/include/linux/mm.h
===================================================================
--- linux-2.6.mod.orig/include/linux/mm.h	2007-06-25 19:27:42.000000000 -0700
+++ linux-2.6.mod/include/linux/mm.h	2007-06-26 18:08:28.000000000 -0700
@@ -1099,7 +1099,8 @@
 }
 
 extern int do_munmap(struct mm_struct *, unsigned long, size_t);
-
+extern unsigned long do_brk_flags(unsigned long addr, unsigned long len,
+				  unsigned long vmflags);
 extern unsigned long do_brk(unsigned long, unsigned long);
 
 /* filemap.c */
Index: linux-2.6.mod/include/linux/syscalls.h
===================================================================
--- linux-2.6.mod.orig/include/linux/syscalls.h	2007-06-25 19:14:49.000000000 -0700
+++ linux-2.6.mod/include/linux/syscalls.h	2007-06-26 18:08:28.000000000 -0700
@@ -263,6 +263,7 @@
 asmlinkage long sys_fremovexattr(int fd, char __user *name);
 
 asmlinkage unsigned long sys_brk(unsigned long brk);
+asmlinkage unsigned long sys_brk2(unsigned long brk, unsigned long flags);
 asmlinkage long sys_mprotect(unsigned long start, size_t len,
 				unsigned long prot);
 asmlinkage unsigned long sys_mremap(unsigned long addr,
Index: linux-2.6.mod/mm/mmap.c
===================================================================
--- linux-2.6.mod.orig/mm/mmap.c	2007-06-25 19:14:49.000000000 -0700
+++ linux-2.6.mod/mm/mmap.c	2007-06-26 18:08:28.000000000 -0700
@@ -35,6 +35,8 @@
 #define arch_mmap_check(addr, len, flags)	(0)
 #endif
 
+#define BRK_ALLOWED_FLAGS	(VM_NOZERO)
+
 static void unmap_region(struct mm_struct *mm,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
@@ -234,7 +236,7 @@
 	return next;
 }
 
-asmlinkage unsigned long sys_brk(unsigned long brk)
+asmlinkage unsigned long sys_brk2(unsigned long brk, unsigned long flags)
 {
 	unsigned long rlim, retval;
 	unsigned long newbrk, oldbrk;
@@ -271,8 +273,10 @@
 	if (find_vma_intersection(mm, oldbrk, newbrk+PAGE_SIZE))
 		goto out;
 
+	flags = BRK_ALLOWED_FLAGS & calc_vm_flag_bits(flags);
+
 	/* Ok, looks good - let it rip. */
-	if (do_brk(oldbrk, newbrk-oldbrk) != oldbrk)
+	if (do_brk_flags(oldbrk, newbrk-oldbrk, flags) != oldbrk)
 		goto out;
 set_brk:
 	mm->brk = brk;
@@ -282,6 +286,11 @@
 	return retval;
 }
 
+asmlinkage unsigned long sys_brk(unsigned long brk)
+{
+	return sys_brk2(brk, 0);
+}
+
 #ifdef DEBUG_MM_RB
 static int browse_rb(struct rb_root *root)
 {
@@ -1863,7 +1872,8 @@
  *  anonymous maps.  eventually we may be able to do some
  *  brk-specific accounting here.
  */
-unsigned long do_brk(unsigned long addr, unsigned long len)
+unsigned long do_brk_flags(unsigned long addr, unsigned long len,
+			   unsigned long vmflags)
 {
 	struct mm_struct * mm = current->mm;
 	struct vm_area_struct * vma, * prev;
@@ -1882,7 +1892,7 @@
 	if (is_hugepage_only_range(mm, addr, len))
 		return -EINVAL;
 
-	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
+	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags | vmflags;
 
 	error = arch_mmap_check(addr, len, flags);
 	if (error)
@@ -1959,6 +1969,10 @@
 	return addr;
 }
 
+unsigned long do_brk(unsigned long addr, unsigned long len)
+{
+	return do_brk_flags(addr, len, 0);
+}
 EXPORT_SYMBOL(do_brk);
 
 /* Release all mmaps. */


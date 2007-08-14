Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbXHNRvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbXHNRvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbXHNRux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:50:53 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:45215 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbXHNRuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:50:52 -0400
Date: Tue, 14 Aug 2007 19:50:47 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, WU Fengguang <wfg@mail.ustc.edu.cn>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@redhat.com>
Subject: Re: [PATCH] fix NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070814175047.GA3024@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	WU Fengguang <wfg@mail.ustc.edu.cn>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	James Morris <jmorris@redhat.com>
References: <20070812141905.4ee423b9@the-village.bc.nu> <386927758.14086@ustc.edu.cn> <20070812161744.200d4252@the-village.bc.nu> <386990734.21206@ustc.edu.cn> <20070813140106.23b93ff5@the-village.bc.nu> <20070813220142.99e46091.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20070813220142.99e46091.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> erp, we have major version skew between 2.6.23-rc1-mm1 and 2.6.23-rc3 here, sorry.
> 
> Could I ask for a redone patch against mainline?

Since I'm seeing this problem on 2.6.23-rc3, I tried adapting it.
I'm running it now and the NULL pointer messages are gone.

Index: linux-2.6.23-rc3/include/linux/mm.h
===================================================================
--- linux-2.6.23-rc3.orig/include/linux/mm.h	2007-08-14 18:33:09.000000000 +0200
+++ linux-2.6.23-rc3/include/linux/mm.h	2007-08-14 19:31:59.000000000 +0200
@@ -1042,7 +1042,7 @@
 }
 
 /* mmap.c */
-extern int __vm_enough_memory(long pages, int cap_sys_admin);
+extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
 extern void vma_adjust(struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert);
 extern struct vm_area_struct *vma_merge(struct mm_struct *,
Index: linux-2.6.23-rc3/include/linux/security.h
===================================================================
--- linux-2.6.23-rc3.orig/include/linux/security.h	2007-08-14 18:33:10.000000000 +0200
+++ linux-2.6.23-rc3/include/linux/security.h	2007-08-14 19:38:24.000000000 +0200
@@ -54,7 +54,7 @@
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
 extern int cap_syslog (int type);
-extern int cap_vm_enough_memory (long pages);
+extern int cap_vm_enough_memory (struct mm_struct *mm, long pages);
 
 struct msghdr;
 struct sk_buff;
@@ -1125,6 +1125,7 @@
  *	Return 0 if permission is granted.
  * @vm_enough_memory:
  *	Check permissions for allocating a new virtual mapping.
+ *	@mm contains the mm struct it is being added to.
  *      @pages contains the number of pages.
  *	Return 0 if permission is granted.
  *
@@ -1169,7 +1170,7 @@
 	int (*quota_on) (struct dentry * dentry);
 	int (*syslog) (int type);
 	int (*settime) (struct timespec *ts, struct timezone *tz);
-	int (*vm_enough_memory) (long pages);
+	int (*vm_enough_memory) (struct mm_struct *mm, long pages);
 
 	int (*bprm_alloc_security) (struct linux_binprm * bprm);
 	void (*bprm_free_security) (struct linux_binprm * bprm);
@@ -1469,10 +1470,14 @@
 	return security_ops->settime(ts, tz);
 }
 
-
 static inline int security_vm_enough_memory(long pages)
 {
-	return security_ops->vm_enough_memory(pages);
+	return security_ops->vm_enough_memory(current->mm, pages);
+}
+
+static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
+{
+	return security_ops->vm_enough_memory(mm, pages);
 }
 
 static inline int security_bprm_alloc (struct linux_binprm *bprm)
@@ -2219,7 +2224,12 @@
 
 static inline int security_vm_enough_memory(long pages)
 {
-	return cap_vm_enough_memory(pages);
+	return cap_vm_enough_memory(current->mm, pages);
+}
+
+static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
+{
+	return cap_vm_enough_memory(mm, pages);
 }
 
 static inline int security_bprm_alloc (struct linux_binprm *bprm)
Index: linux-2.6.23-rc3/mm/mmap.c
===================================================================
--- linux-2.6.23-rc3.orig/mm/mmap.c	2007-08-14 18:33:11.000000000 +0200
+++ linux-2.6.23-rc3/mm/mmap.c	2007-08-14 19:31:59.000000000 +0200
@@ -93,7 +93,7 @@
  * Note this is a helper function intended to be used by LSMs which
  * wish to use this logic.
  */
-int __vm_enough_memory(long pages, int cap_sys_admin)
+int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 {
 	unsigned long free, allowed;
 
@@ -166,7 +166,7 @@
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= current->mm->total_vm / 32;
+	allowed -= mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space
@@ -2077,7 +2077,7 @@
 	if (__vma && __vma->vm_start < vma->vm_end)
 		return -ENOMEM;
 	if ((vma->vm_flags & VM_ACCOUNT) &&
-	     security_vm_enough_memory(vma_pages(vma)))
+	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
 		return -ENOMEM;
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	return 0;
Index: linux-2.6.23-rc3/mm/nommu.c
===================================================================
--- linux-2.6.23-rc3.orig/mm/nommu.c	2007-08-14 18:33:12.000000000 +0200
+++ linux-2.6.23-rc3/mm/nommu.c	2007-08-14 19:31:59.000000000 +0200
@@ -1270,7 +1270,7 @@
  * Note this is a helper function intended to be used by LSMs which
  * wish to use this logic.
  */
-int __vm_enough_memory(long pages, int cap_sys_admin)
+int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 {
 	unsigned long free, allowed;
 
Index: linux-2.6.23-rc3/security/commoncap.c
===================================================================
--- linux-2.6.23-rc3.orig/security/commoncap.c	2007-08-14 18:33:13.000000000 +0200
+++ linux-2.6.23-rc3/security/commoncap.c	2007-08-14 19:31:59.000000000 +0200
@@ -315,13 +315,13 @@
 	return 0;
 }
 
-int cap_vm_enough_memory(long pages)
+int cap_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int cap_sys_admin = 0;
 
 	if (cap_capable(current, CAP_SYS_ADMIN) == 0)
 		cap_sys_admin = 1;
-	return __vm_enough_memory(pages, cap_sys_admin);
+	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
 EXPORT_SYMBOL(cap_capable);
Index: linux-2.6.23-rc3/security/dummy.c
===================================================================
--- linux-2.6.23-rc3.orig/security/dummy.c	2007-08-14 18:33:13.000000000 +0200
+++ linux-2.6.23-rc3/security/dummy.c	2007-08-14 19:31:59.000000000 +0200
@@ -108,13 +108,13 @@
 	return 0;
 }
 
-static int dummy_vm_enough_memory(long pages)
+static int dummy_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int cap_sys_admin = 0;
 
 	if (dummy_capable(current, CAP_SYS_ADMIN) == 0)
 		cap_sys_admin = 1;
-	return __vm_enough_memory(pages, cap_sys_admin);
+	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
 static int dummy_bprm_alloc_security (struct linux_binprm *bprm)
Index: linux-2.6.23-rc3/security/selinux/hooks.c
===================================================================
--- linux-2.6.23-rc3.orig/security/selinux/hooks.c	2007-08-14 18:33:13.000000000 +0200
+++ linux-2.6.23-rc3/security/selinux/hooks.c	2007-08-14 19:31:59.000000000 +0200
@@ -1584,7 +1584,7 @@
  * Do not audit the selinux permission check, as this is applied to all
  * processes that allocate mappings.
  */
-static int selinux_vm_enough_memory(long pages)
+static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int rc, cap_sys_admin = 0;
 	struct task_security_struct *tsec = current->security;
@@ -1600,7 +1600,7 @@
 	if (rc == 0)
 		cap_sys_admin = 1;
 
-	return __vm_enough_memory(pages, cap_sys_admin);
+	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
 /* binprm security operations */

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。

Return-Path: <linux-kernel-owner+w=401wt.eu-S948128AbXHMPMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948128AbXHMPMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945747AbXHMMx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:53:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46238 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S945720AbXHMMxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:53:54 -0400
Date: Mon, 13 Aug 2007 14:01:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: WU Fengguang <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@redhat.com>
Subject: [PATCH] fix NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070813140106.23b93ff5@the-village.bc.nu>
In-Reply-To: <386990734.21206@ustc.edu.cn>
References: <20070812141905.4ee423b9@the-village.bc.nu>
	<386927758.14086@ustc.edu.cn>
	<20070812161744.200d4252@the-village.bc.nu>
	<386990734.21206@ustc.edu.cn>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 15:38:53 +0800
WU Fengguang <wfg@mail.ustc.edu.cn> wrote:

> On Sun, Aug 12, 2007 at 04:17:44PM +0100, Alan Cox wrote:
> > Try this (it compiles but isnt tested). Its a weekend here, the sun is
> > shining, the beach is a short walk, and I have more interesting things to
> > do right now 8)
> 
> Have a nice day~~~ It works!

Ok please apply the patch then Andrew

---

The new exec code inserts an accounted vma into an mm struct which is not
current->mm. The existing memory check code has a hard coded assumption
that this does not happen as does the security code.

As the correct mm is known we pass the mm to the security method and the
helper function. A new security test is added for the case where we need
to pass the mm and the existing one is modified to pass current->mm to
avoid the need to change large amounts of code.

Signed-off-by: Alan Cox <alan@redhat.com>


diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/include/linux/mm.h linux-2.6.23rc1-mm1/include/linux/mm.h
--- linux.vanilla-2.6.23rc1-mm1/include/linux/mm.h	2007-07-26 15:02:58.000000000 +0100
+++ linux-2.6.23rc1-mm1/include/linux/mm.h	2007-08-12 13:54:24.614647536 +0100
@@ -1079,7 +1079,7 @@
 }
 
 /* mmap.c */
-extern int __vm_enough_memory(long pages, int cap_sys_admin);
+extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
 extern void vma_adjust(struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert);
 extern struct vm_area_struct *vma_merge(struct mm_struct *,
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/include/linux/security.h linux-2.6.23rc1-mm1/include/linux/security.h
--- linux.vanilla-2.6.23rc1-mm1/include/linux/security.h	2007-07-26 15:02:58.000000000 +0100
+++ linux-2.6.23rc1-mm1/include/linux/security.h	2007-08-12 14:13:10.383504656 +0100
@@ -58,7 +58,7 @@
 extern int cap_task_setioprio (struct task_struct *p, int ioprio);
 extern int cap_task_setnice (struct task_struct *p, int nice);
 extern int cap_syslog (int type);
-extern int cap_vm_enough_memory (long pages);
+extern int cap_vm_enough_memory (struct mm_struct *mm, long pages);
 
 struct msghdr;
 struct sk_buff;
@@ -1129,6 +1129,7 @@
  *	Return 0 if permission is granted.
  * @vm_enough_memory:
  *	Check permissions for allocating a new virtual mapping.
+ *	@mm contains the mm struct it is being added to.
  *      @pages contains the number of pages.
  *	Return 0 if permission is granted.
  *
@@ -1173,7 +1174,7 @@
 	int (*quota_on) (struct dentry * dentry);
 	int (*syslog) (int type);
 	int (*settime) (struct timespec *ts, struct timezone *tz);
-	int (*vm_enough_memory) (long pages);
+	int (*vm_enough_memory) (struct mm_struct *mm, long pages);
 
 	int (*bprm_alloc_security) (struct linux_binprm * bprm);
 	void (*bprm_free_security) (struct linux_binprm * bprm);
@@ -1439,6 +1440,7 @@
 int security_syslog(int type);
 int security_settime(struct timespec *ts, struct timezone *tz);
 int security_vm_enough_memory(long pages);
+int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
 int security_bprm_alloc(struct linux_binprm *bprm);
 void security_bprm_free(struct linux_binprm *bprm);
 void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/mm/mmap.c linux-2.6.23rc1-mm1/mm/mmap.c
--- linux.vanilla-2.6.23rc1-mm1/mm/mmap.c	2007-07-26 15:02:58.000000000 +0100
+++ linux-2.6.23rc1-mm1/mm/mmap.c	2007-08-12 13:53:22.000000000 +0100
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
@@ -2058,7 +2058,7 @@
 	if (__vma && __vma->vm_start < vma->vm_end)
 		return -ENOMEM;
 	if ((vma->vm_flags & VM_ACCOUNT) &&
-	     security_vm_enough_memory(vma_pages(vma)))
+	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
 		return -ENOMEM;
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	return 0;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/mm/nommu.c linux-2.6.23rc1-mm1/mm/nommu.c
--- linux.vanilla-2.6.23rc1-mm1/mm/nommu.c	2007-07-26 15:02:08.000000000 +0100
+++ linux-2.6.23rc1-mm1/mm/nommu.c	2007-08-12 13:53:57.000000000 +0100
@@ -1270,7 +1270,7 @@
  * Note this is a helper function intended to be used by LSMs which
  * wish to use this logic.
  */
-int __vm_enough_memory(long pages, int cap_sys_admin)
+int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 {
 	unsigned long free, allowed;
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/security/commoncap.c linux-2.6.23rc1-mm1/security/commoncap.c
--- linux.vanilla-2.6.23rc1-mm1/security/commoncap.c	2007-07-26 15:02:59.000000000 +0100
+++ linux-2.6.23rc1-mm1/security/commoncap.c	2007-08-12 14:13:29.000000000 +0100
@@ -489,13 +489,13 @@
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/security/dummy.c linux-2.6.23rc1-mm1/security/dummy.c
--- linux.vanilla-2.6.23rc1-mm1/security/dummy.c	2007-07-26 15:02:59.000000000 +0100
+++ linux-2.6.23rc1-mm1/security/dummy.c	2007-08-12 14:10:49.000000000 +0100
@@ -107,13 +107,13 @@
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/security/security.c linux-2.6.23rc1-mm1/security/security.c
--- linux.vanilla-2.6.23rc1-mm1/security/security.c	2007-07-26 15:02:59.000000000 +0100
+++ linux-2.6.23rc1-mm1/security/security.c	2007-08-12 13:47:53.000000000 +0100
@@ -237,10 +237,14 @@
 	return security_ops->settime(ts, tz);
 }
 
-
 int security_vm_enough_memory(long pages)
 {
-	return security_ops->vm_enough_memory(pages);
+	return security_ops->vm_enough_memory(current->mm, pages);
+}
+
+int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
+{
+	return security_ops->vm_enough_memory(mm, pages);
 }
 
 int security_bprm_alloc(struct linux_binprm *bprm)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/security/selinux/hooks.c linux-2.6.23rc1-mm1/security/selinux/hooks.c
--- linux.vanilla-2.6.23rc1-mm1/security/selinux/hooks.c	2007-07-26 15:02:59.000000000 +0100
+++ linux-2.6.23rc1-mm1/security/selinux/hooks.c	2007-08-12 14:11:21.000000000 +0100
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

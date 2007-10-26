Return-Path: <linux-kernel-owner+w=401wt.eu-S1764803AbXJZQjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764803AbXJZQjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763747AbXJZQgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:36:40 -0400
Received: from waste.org ([66.93.16.53]:56575 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754495AbXJZQgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:36:35 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.430487409@selenic.com>
Message-Id: <8.430487409@selenic.com>
Subject: [PATCH 7/12] maps4: move clear_refs code to task_mmu.c
Date: Fri, 26 Oct 2007 11:36:33 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>

This puts all the clear_refs code where it belongs and probably lets things
compile on MMU-less systems as well.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Index: l/fs/proc/base.c
===================================================================
--- l.orig/fs/proc/base.c	2007-10-16 21:13:45.000000000 -0500
+++ l/fs/proc/base.c	2007-10-22 16:23:05.000000000 -0500
@@ -85,10 +85,6 @@
  *	in /proc for a task before it execs a suid executable.
  */
 
-
-/* Worst case buffer size needed for holding an integer. */
-#define PROC_NUMBUF 13
-
 struct pid_entry {
 	char *name;
 	int len;
@@ -713,42 +709,6 @@ static const struct file_operations proc
 	.write		= oom_adjust_write,
 };
 
-#ifdef CONFIG_MMU
-static ssize_t clear_refs_write(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	struct task_struct *task;
-	char buffer[PROC_NUMBUF], *end;
-	struct mm_struct *mm;
-
-	memset(buffer, 0, sizeof(buffer));
-	if (count > sizeof(buffer) - 1)
-		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count))
-		return -EFAULT;
-	if (!simple_strtol(buffer, &end, 0))
-		return -EINVAL;
-	if (*end == '\n')
-		end++;
-	task = get_proc_task(file->f_path.dentry->d_inode);
-	if (!task)
-		return -ESRCH;
-	mm = get_task_mm(task);
-	if (mm) {
-		clear_refs_smap(mm);
-		mmput(mm);
-	}
-	put_task_struct(task);
-	if (end - buffer == 0)
-		return -EIO;
-	return end - buffer;
-}
-
-static struct file_operations proc_clear_refs_operations = {
-	.write		= clear_refs_write,
-};
-#endif
-
 #ifdef CONFIG_AUDITSYSCALL
 #define TMPBUFLEN 21
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
Index: l/fs/proc/internal.h
===================================================================
--- l.orig/fs/proc/internal.h	2007-10-16 21:13:45.000000000 -0500
+++ l/fs/proc/internal.h	2007-10-22 16:19:32.000000000 -0500
@@ -49,11 +49,7 @@ extern int proc_pid_statm(struct task_st
 extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
 extern const struct file_operations proc_smaps_operations;
-
-extern const struct file_operations proc_maps_operations;
-extern const struct file_operations proc_numa_maps_operations;
-extern const struct file_operations proc_smaps_operations;
-
+extern const struct file_operations proc_clear_refs_operations;
 
 void free_proc_entry(struct proc_dir_entry *de);
 
Index: l/fs/proc/task_mmu.c
===================================================================
--- l.orig/fs/proc/task_mmu.c	2007-10-22 16:00:49.000000000 -0500
+++ l/fs/proc/task_mmu.c	2007-10-22 16:22:54.000000000 -0500
@@ -323,19 +323,47 @@ static int show_smap(struct seq_file *m,
 
 static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
 
-void clear_refs_smap(struct mm_struct *mm)
+static ssize_t clear_refs_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
 {
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF], *end;
+	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 
-	down_read(&mm->mmap_sem);
-	for (vma = mm->mmap; vma; vma = vma->vm_next)
-		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-			walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
-					&clear_refs_walk, vma);
-	flush_tlb_mm(mm);
-	up_read(&mm->mmap_sem);
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+	if (!simple_strtol(buffer, &end, 0))
+		return -EINVAL;
+	if (*end == '\n')
+		end++;
+	task = get_proc_task(file->f_path.dentry->d_inode);
+	if (!task)
+		return -ESRCH;
+	mm = get_task_mm(task);
+	if (mm) {
+		down_read(&mm->mmap_sem);
+		for (vma = mm->mmap; vma; vma = vma->vm_next)
+			if (!is_vm_hugetlb_page(vma))
+				walk_page_range(mm, vma->vm_start, vma->vm_end,
+						&clear_refs_walk, vma);
+		flush_tlb_mm(mm);
+		up_read(&mm->mmap_sem);
+		mmput(mm);
+	}
+	put_task_struct(task);
+	if (end - buffer == 0)
+		return -EIO;
+	return end - buffer;
 }
 
+const struct file_operations proc_clear_refs_operations = {
+	.write		= clear_refs_write,
+};
+
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
Index: l/include/linux/proc_fs.h
===================================================================
--- l.orig/include/linux/proc_fs.h	2007-10-16 21:13:45.000000000 -0500
+++ l/include/linux/proc_fs.h	2007-10-22 16:22:43.000000000 -0500
@@ -18,6 +18,8 @@ struct completion;
  */
 #define FIRST_PROCESS_ENTRY 256
 
+/* Worst case buffer size needed for holding an integer. */
+#define PROC_NUMBUF 13
 
 /*
  * We always define these enumerators
@@ -116,7 +118,6 @@ int proc_pid_readdir(struct file * filp,
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
 char *task_mem(struct mm_struct *, char *);
-void clear_refs_smap(struct mm_struct *mm);
 
 struct proc_dir_entry *de_get(struct proc_dir_entry *de);
 void de_put(struct proc_dir_entry *de);

Return-Path: <linux-kernel-owner+w=401wt.eu-S2992432AbXDDCpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992432AbXDDCpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966307AbXDDCnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:43:08 -0400
Received: from waste.org ([66.93.16.53]:54647 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966308AbXDDCm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:42:27 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.486631555@selenic.com>
Message-Id: <9.486631555@selenic.com>
Subject: [PATCH 8/13] maps: Move clear_refs code to task_mmu.c
Date: Tue, 03 Apr 2007 21:43:39 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move clear_refs code to task_mmu.c

This puts all the clear_refs code where it belongs and probably lets
things compile on MMU-less systems as well.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/base.c
===================================================================
--- mm.orig/fs/proc/base.c	2007-03-29 13:00:41.000000000 -0500
+++ mm/fs/proc/base.c	2007-03-29 13:01:49.000000000 -0500
@@ -750,40 +750,6 @@ static const struct file_operations proc
 	.write		= oom_adjust_write,
 };
 
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
-
 #ifdef CONFIG_AUDITSYSCALL
 #define TMPBUFLEN 21
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
Index: mm/fs/proc/internal.h
===================================================================
--- mm.orig/fs/proc/internal.h	2007-03-29 13:00:41.000000000 -0500
+++ mm/fs/proc/internal.h	2007-03-29 13:01:49.000000000 -0500
@@ -45,11 +45,7 @@ extern int proc_pid_statm(struct task_st
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
 
Index: mm/fs/proc/task_mmu.c
===================================================================
--- mm.orig/fs/proc/task_mmu.c	2007-03-29 13:01:44.000000000 -0500
+++ mm/fs/proc/task_mmu.c	2007-03-29 13:01:49.000000000 -0500
@@ -297,19 +297,47 @@ static int show_smap(struct seq_file *m,
 
 static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
 
-void clear_refs_smap(struct mm_struct *mm)
+static ssize_t clear_refs_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
 {
+	struct task_struct *task;
+	char buffer[13], *end;
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
Index: mm/include/linux/proc_fs.h
===================================================================
--- mm.orig/include/linux/proc_fs.h	2007-03-29 13:00:41.000000000 -0500
+++ mm/include/linux/proc_fs.h	2007-03-29 13:01:49.000000000 -0500
@@ -117,7 +117,6 @@ int proc_pid_readdir(struct file * filp,
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
 char *task_mem(struct mm_struct *, char *);
-void clear_refs_smap(struct mm_struct *mm);
 
 struct proc_dir_entry *de_get(struct proc_dir_entry *de);
 void de_put(struct proc_dir_entry *de);

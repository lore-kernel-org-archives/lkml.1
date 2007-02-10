Return-Path: <linux-kernel-owner+w=401wt.eu-S1946816AbXBJBCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946816AbXBJBCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946815AbXBJBCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:02:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58499 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946816AbXBJBCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:02:06 -0500
Date: Fri, 9 Feb 2007 17:01:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: David Rientjes <rientjes@google.com>, Hugh Dickins <hugh@veritas.com>,
       Paul Mundt <lethal@linux-sh.org>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: + smaps-add-clear_refs-file-to-clear-reference.patch added to
 -mm tree
Message-Id: <20070209170145.aba2cae8.akpm@linux-foundation.org>
In-Reply-To: <20070210003958.GA3047@tv-sign.ru>
References: <20070210003958.GA3047@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007 03:39:58 +0300
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> David Rientjes wrote:
> >
> > +static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> > +				size_t count, loff_t *ppos)
> > +{
> > ...
> > +	task = get_proc_task(file->f_path.dentry->d_inode);
> > +	if (!task)
> > +		return -ESRCH;
> > +	clear_refs_smap(task->mm->mmap);
> 
> task->mm may be NULL and not stable, this needs get_task_mm() (may fail).

yup.

> Don't we also need ->mmap_sem to iterate vmas?

and yup.

Like this?

--- a/fs/proc/base.c~smaps-add-clear_refs-file-to-clear-reference-fix
+++ a/fs/proc/base.c
@@ -720,6 +720,7 @@ static ssize_t clear_refs_write(struct f
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF], *end;
+	struct mm_struct *mm;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
@@ -733,7 +734,11 @@ static ssize_t clear_refs_write(struct f
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
-	clear_refs_smap(task->mm->mmap);
+	mm = get_task_mm(task);
+	if (mm) {
+		clear_refs_smap(mm);
+		mmput(mm);
+	}
 	put_task_struct(task);
 	if (end - buffer == 0)
 		return -EIO;
diff -puN fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference-fix
+++ a/fs/proc/task_mmu.c
@@ -350,11 +350,15 @@ static int show_smap(struct seq_file *m,
 	return show_map_internal(m, v, &mss);
 }
 
-void clear_refs_smap(struct vm_area_struct *vma)
+void clear_refs_smap(struct mm_struct *mm)
 {
-	for (; vma; vma = vma->vm_next)
+	struct vm_area_struct *vma;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 			for_each_pmd(vma, clear_refs_one_pmd, NULL);
+	up_read(&mm->mmap_sem);
 }
 
 static void *m_start(struct seq_file *m, loff_t *pos)
diff -puN include/linux/proc_fs.h~smaps-add-clear_refs-file-to-clear-reference-fix include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~smaps-add-clear_refs-file-to-clear-reference-fix
+++ a/include/linux/proc_fs.h
@@ -104,7 +104,7 @@ int proc_pid_readdir(struct file * filp,
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
 char *task_mem(struct mm_struct *, char *);
-void clear_refs_smap(struct vm_area_struct *);
+void clear_refs_smap(struct mm_struct *mm);
 
 extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 						struct proc_dir_entry *parent);
_


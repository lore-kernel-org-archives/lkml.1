Return-Path: <linux-kernel-owner+w=401wt.eu-S2992781AbXBITgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992781AbXBITgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992780AbXBITg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:36:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16892 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992776AbXBITgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:36:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=gWTR67SgMMhui5sfWDvZpBDjyz3o4goIdw+kTZxzD5h9UJU0Ebj7Rygw5QTW6tbgx
	oTQYUu1ck9owj2OH7o9eA==
Date: Fri, 9 Feb 2007 11:36:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 3/3] smaps: add clear_refs file to clear reference
In-Reply-To: <Pine.LNX.4.64.0702082209440.10206@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0702082210100.10206@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0702082208270.10206@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702082209440.10206@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds /proc/pid/clear_refs.  When any non-zero number is written to this
file, pte_mkold() and ClearPageReferenced() is called for each pte and its
corresponding page, respectively, in that task's VMAs.  This file is only
writable by the user who owns the task.

It is now possible to measure _approximately_ how much memory a task is
using by clearing the reference bits with

	echo 1 > /proc/pid/clear_refs

and checking the reference count for each VMA from the /proc/pid/smaps
output at a measured time interval.  For example, to observe the
approximate change in memory footprint for a task, write a script that
clears the references (echo 1 > /proc/pid/clear_refs), sleeps, and then
greps for Pgs_Referenced and extracts the size in kB.  Add the sizes for
each VMA together for the total referenced footprint.  Moments later,
repeat the process and observe the difference.

For example, using an efficient Mozilla:

	accumulated time		referenced memory
	----------------		-----------------
		 0 s				 408 kB
		 1 s				 408 kB
		 2 s				 556 kB
		 3 s				1028 kB
		 4 s				 872 kB
		 5 s				1956 kB
		 6 s				 416 kB
		 7 s				1560 kB
		 8 s				2336 kB
		 9 s				1044 kB
		10 s				 416 kB

This is a valuable tool to get an approximate measurement of the memory
footprint for a task.

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/proc/base.c          |   31 +++++++++++++++++++++++++++++++
 fs/proc/task_mmu.c      |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h |    1 +
 3 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -715,6 +715,35 @@ static struct file_operations proc_oom_adjust_operations = {
 	.write		= oom_adjust_write,
 };
 
+static ssize_t clear_refs_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF], *end;
+
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
+	clear_refs_smap(task->mm->mmap);
+	put_task_struct(task);
+	if (end - buffer == 0)
+		return -EIO;
+	return end - buffer;
+}
+
+static struct file_operations proc_clear_refs_operations = {
+	.write		= clear_refs_write,
+};
+
 #ifdef CONFIG_AUDITSYSCALL
 #define TMPBUFLEN 21
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
@@ -1856,6 +1885,7 @@ static struct pid_entry tgid_base_stuff[] = {
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
+	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),
 #endif
 #ifdef CONFIG_SECURITY
@@ -2137,6 +2167,7 @@ static struct pid_entry tid_base_stuff[] = {
 	LNK("exe",       exe),
 	REG("mounts",    S_IRUGO, mounts),
 #ifdef CONFIG_MMU
+	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",     S_IRUGO, smaps),
 #endif
 #ifdef CONFIG_SECURITY
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -254,6 +254,36 @@ static void smaps_one_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 	cond_resched();
 }
 
+static void clear_refs_one_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+			       unsigned long addr, unsigned long end,
+			       void *private)
+{
+	pte_t *pte, ptent;
+	spinlock_t *ptl;
+	struct page *page;
+
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		ptent = *pte;
+		if (!pte_present(ptent))
+			continue;
+
+		page = vm_normal_page(vma, addr, ptent);
+		if (!page)
+			continue;
+
+		/* Clear accessed and referenced bits. */
+		if (pte_young(ptent)) {
+			ptent = pte_mkold(ptent);
+			set_pte_at(vma->vm_mm, addr, pte, ptent);
+			flush_tlb_page(vma, addr);
+		}
+		ClearPageReferenced(page);
+	}
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+}
+
 static inline void for_each_pmd_in_pud(struct pmd_walker *walker, pud_t *pud,
 				       unsigned long addr, unsigned long end)
 {
@@ -320,6 +350,13 @@ static int show_smap(struct seq_file *m, void *v)
 	return show_map_internal(m, v, &mss);
 }
 
+void clear_refs_smap(struct vm_area_struct *vma)
+{
+	for (; vma; vma = vma->vm_next)
+		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
+			for_each_pmd(vma, clear_refs_one_pmd, NULL);
+}
+
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -104,6 +104,7 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
 char *task_mem(struct mm_struct *, char *);
+void clear_refs_smap(struct vm_area_struct *);
 
 extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 						struct proc_dir_entry *parent);

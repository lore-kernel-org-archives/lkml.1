Return-Path: <linux-kernel-owner+w=401wt.eu-S965641AbXBGF1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641AbXBGF1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 00:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965643AbXBGF1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 00:27:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:63406 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965641AbXBGF1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 00:27:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=DZO8aFRigff/Zuq0OPWjtRSsJ3ma3VZDNhuXCS3gZZrzhBFj/i2YNnrcLiByQQjnP
	sGKmvb40d84HXTKFeqYqA==
Date: Tue, 6 Feb 2007 21:27:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@osdl.org>
cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 3/3] smaps: add clear_refs file to clear reference
In-Reply-To: <Pine.LNX.4.64.0702062122540.8623@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0702062123240.8623@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0702062121160.8623@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702062122540.8623@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds an additional file to /proc/pid: clear_refs.  When any non-zero
number is written to this file, all the PG_referenced flags (meaning the
page has been accessed) are cleared within each VMA for the corresponding
task.

It is now possible to measure how much memory a task is using by clearing
the reference bits with

	echo 1 > /proc/pid/clear_refs

and checking the reference count for each VMA from the /proc/pid/smaps
output at a time interval later.

The /proc/pid/clear_refs file is only writable by the user who owns the
task.

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/proc/base.c          |   31 +++++++++++++++++++++++++++++++
 fs/proc/task_mmu.c      |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h |    1 +
 3 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1a979ea..b50315f 100644
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
index a1f5e87..10714c9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -322,6 +322,26 @@ static void smaps_pte_func(struct pte_walker *walker, pte_t *pte,
 }
 
 /*
+ * Called for each PTE in the struct pte_walker address range.  For all normal,
+ * present pages, we clear their referenced bits.
+ */
+static void clear_refs_pte_func(struct pte_walker *walker, pte_t *pte,
+				unsigned long addr)
+{
+	struct page *page;
+	pte_t ptent;
+
+	ptent = *pte;
+	if (!pte_present(ptent))
+		return;
+
+	page = vm_normal_page(walker->vma, addr, ptent);
+	if (!page)
+		return;
+	ClearPageReferenced(page);
+}
+
+/*
  * Displays the smap for the process.  smaps_pte_func() is called for each PTE
  * in the range from vma->vm_start to vma->vm_end.
  */
@@ -343,6 +363,22 @@ static int show_smap(struct seq_file *m, void *v)
 	return show_map_internal(m, v, &mss);
 }
 
+void clear_refs_smap(struct vm_area_struct *vma)
+{
+	for (; vma; vma = vma->vm_next) {
+		struct pte_walker walker = {
+			.vma		= vma,
+			.start		= vma->vm_start,
+			.end		= vma->vm_end,
+			.private	= NULL,
+			.func		= clear_refs_pte_func,
+		};
+
+		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
+			walk_pgds(&walker);
+	};
+}
+
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 87dec8f..f3d426b 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -104,6 +104,7 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
 char *task_mem(struct mm_struct *, char *);
+void clear_refs_smap(struct vm_area_struct *);
 
 extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 						struct proc_dir_entry *parent);

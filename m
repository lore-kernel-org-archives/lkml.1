Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbXCEUfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbXCEUfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932341AbXCEUff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:35:35 -0500
Received: from mylar.outflux.net ([69.93.193.226]:57055 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbXCEUfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:35:34 -0500
X-Greylist: delayed 1221 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2007 15:35:34 EST
Date: Mon, 5 Mar 2007 12:15:11 -0800
From: Kees Cook <kees@outflux.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: maps protection
Message-ID: <20070305201511.GD9727@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the same logic for the checks done on /proc/$pid/mem, but 
extend them to /proc/$pid/{maps,smaps,numa_maps}.  This means that only 
processes and their ptrace parents can read their maps files.

Signed-off-by: Kees Cook <kees@outflux.net>
---

This is a continuation of a much earlier discussion[1].  As I 
understand, the problem is:

- "maps" should not be world-readable, especially if programs expect any 
  kind of ASLR protection from local attackers.
- "maps" cannot just be 0400 because "-D_FORTIFY_SOURCE=2 -O2" makes glibc
  check the maps when %n is in a *printf call, and a setuid(getuid()) 
  process wouldn't be able to read its own maps file.

It seemed that one solution would be to protect the maps file in the 
same way that the mem file is.  So, that's what this patch does.

Running this patch locally, gdb and the setuid glibc tests appear happy.  
What do others think of this?

[1] http://marc.theaimsgroup.com/?l=linux-kernel&m=113796842515034&w=2

---
 base.c       |    9 ---------
 internal.h   |    9 +++++++++
 task_mmu.c   |   16 +++++++++++++++-
 task_nommu.c |    6 ++++++
 4 files changed, 30 insertions(+), 10 deletions(-)
---
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1a979ea..9bf7585 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -65,8 +65,6 @@
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
 #include <linux/mount.h>
-#include <linux/security.h>
-#include <linux/ptrace.h>
 #include <linux/seccomp.h>
 #include <linux/cpuset.h>
 #include <linux/audit.h>
@@ -189,13 +187,6 @@ static int proc_root_link(struct inode *inode, struct dentry **dentry, struct vf
 	return result;
 }
 
-#define MAY_PTRACE(task) \
-	(task == current || \
-	(task->parent == current && \
-	(task->ptrace & PT_PTRACED) && \
-	 (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
-	 security_ptrace(current,task) == 0))
-
 static int proc_pid_environ(struct task_struct *task, char * buffer)
 {
 	int res = 0;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 987c773..3c5ccc9 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -10,6 +10,8 @@
  */
 
 #include <linux/proc_fs.h>
+#include <linux/security.h>
+#include <linux/ptrace.h>
 
 struct vmalloc_info {
 	unsigned long	used;
@@ -31,6 +33,13 @@ do {						\
 extern int nommu_vma_show(struct seq_file *, struct vm_area_struct *);
 #endif
 
+#define MAY_PTRACE(task) \
+        (task == current || \
+        (task->parent == current && \
+         (task->ptrace & PT_PTRACED) && \
+         (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
+         security_ptrace(current,task) == 0))
+
 extern void create_seq_entry(char *name, mode_t mode, const struct file_operations *f);
 extern int proc_exe_link(struct inode *, struct dentry **, struct vfsmount **);
 extern int proc_tid_stat(struct task_struct *,  char *);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 55ade0d..85486d4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -134,6 +134,9 @@ static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats
 	dev_t dev = 0;
 	int len;
 
+	if (!MAY_PTRACE(task) || !ptrace_may_attach(task))
+		return -EACCES;
+
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
@@ -444,11 +447,22 @@ struct file_operations proc_maps_operations = {
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
 
+static int show_numa_map_checked(struct seq_file *m, void *v)
+{
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
+
+	if (!MAY_PTRACE(task) || !ptrace_may_attach(task))
+		return -EACCES;
+	
+	return show_numa_map(m, v);
+}
+
 static struct seq_operations proc_pid_numa_maps_op = {
         .start  = m_start,
         .next   = m_next,
         .stop   = m_stop,
-        .show   = show_numa_map
+        .show   = show_numa_map_checked
 };
 
 static int numa_maps_open(struct inode *inode, struct file *file)
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index fcc5caf..985a6ff 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -143,6 +143,12 @@ out:
 static int show_map(struct seq_file *m, void *_vml)
 {
 	struct vm_list_struct *vml = _vml;
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
+	
+	if (!MAY_PTRACE(task) || !ptrace_may_attach(task))
+		return -EPERM;
+
 	return nommu_vma_show(m, vml->vma);
 }
 


-- 
Kees Cook

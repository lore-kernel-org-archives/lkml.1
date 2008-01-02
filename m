Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYABOKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYABOKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 09:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYABOKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 09:10:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57602 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbYABOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 09:10:00 -0500
Date: Wed, 2 Jan 2008 14:09:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] restrict reading from /proc/<pid>/maps to those who share ->mm or can ptrace pid
Message-ID: <20080102140957.GR27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Contents of /proc/*/maps is sensitive and may become sensitive
after open() (e.g. if target originally shares our ->mm and later
does exec on suid-root binary).
	Check at read() (actually, ->start() of iterator) time that
mm_struct we'd grabbed and locked is
	* still the ->mm of target
	* equal to reader's ->mm or the target is ptracable by reader.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 02a63ac..7411bfb 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -202,6 +202,26 @@ static int proc_root_link(struct inode *inode, struct dentry **dentry, struct vf
 	 (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
 	 security_ptrace(current,task) == 0))
 
+struct mm_struct *mm_for_maps(struct task_struct *task)
+{
+	struct mm_struct *mm = get_task_mm(task);
+	if (!mm)
+		return NULL;
+	down_read(&mm->mmap_sem);
+	task_lock(task);
+	if (task->mm != mm)
+		goto out;
+	if (task->mm != current->mm && __ptrace_may_attach(task) < 0)
+		goto out;
+	task_unlock(task);
+	return mm;
+out:
+	task_unlock(task);
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+	return NULL;
+}
+
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 {
 	int res = 0;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 1820eb2..05b3e90 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -27,6 +27,8 @@ struct vmalloc_info {
 	unsigned long	largest_chunk;
 };
 
+extern struct mm_struct *mm_for_maps(struct task_struct *);
+
 #ifdef CONFIG_MMU
 #define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
 extern void get_vmalloc_info(struct vmalloc_info *vmi);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index c24d81a..8043a3e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -397,12 +397,11 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	if (!priv->task)
 		return NULL;
 
-	mm = get_task_mm(priv->task);
+	mm = mm_for_maps(priv->task);
 	if (!mm)
 		return NULL;
 
 	priv->tail_vma = tail_vma = get_gate_vma(priv->task);
-	down_read(&mm->mmap_sem);
 
 	/* Start with last addr hint */
 	if (last_addr && (vma = find_vma(mm, last_addr))) {
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index d8b8c71..1932c2c 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -165,15 +165,13 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	if (!priv->task)
 		return NULL;
 
-	mm = get_task_mm(priv->task);
+	mm = mm_for_maps(priv->task);
 	if (!mm) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
 		return NULL;
 	}
 
-	down_read(&mm->mmap_sem);
-
 	/* start from the Nth VMA */
 	for (vml = mm->context.vmlist; vml; vml = vml->next)
 		if (n-- == 0)
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index ae8146a..3ea5750 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -97,6 +97,7 @@ extern void __ptrace_link(struct task_struct *child,
 extern void __ptrace_unlink(struct task_struct *child);
 extern void ptrace_untrace(struct task_struct *child);
 extern int ptrace_may_attach(struct task_struct *task);
+extern int __ptrace_may_attach(struct task_struct *task);
 
 static inline void ptrace_link(struct task_struct *child,
 			       struct task_struct *new_parent)
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 7c76f2f..0c65d30 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -120,7 +120,7 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 	return ret;
 }
 
-static int may_attach(struct task_struct *task)
+int __ptrace_may_attach(struct task_struct *task)
 {
 	/* May we inspect the given task?
 	 * This check is used both for attaching with ptrace
@@ -154,7 +154,7 @@ int ptrace_may_attach(struct task_struct *task)
 {
 	int err;
 	task_lock(task);
-	err = may_attach(task);
+	err = __ptrace_may_attach(task);
 	task_unlock(task);
 	return !err;
 }

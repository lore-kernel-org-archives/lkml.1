Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYADPTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYADPTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 10:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYADPTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 10:19:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59992 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYADPTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:19:36 -0500
Date: Fri, 4 Jan 2008 15:19:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: return -EPERM when preventing read of /proc/*/maps
Message-ID: <20080104151931.GC27894@ZenIV.linux.org.uk>
References: <20080104135731.2908.90012.stgit@localhost.localdomain> <20080104141443.GB27894@ZenIV.linux.org.uk> <20080104153557.13e24970@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104153557.13e24970@inria.fr>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 03:35:57PM +0100, Guillaume Chazarain wrote:
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > vma_stop() doesn't need changes either...
> 
> Hmmm, not sure ;-)

Umm...  Actually, m_next() and m_stop() both appear to be too convoluted.

* m_next() never gets v == NULL
* the only reason why we do that mmput et.al. both from ->next() and
  ->stop() is that we try to avoid having priv->mm; why bother?
* why the _hell_ is proc_maps_private defined in include/linux/proc_fs.h,
  of all places?
* while we are at it, why is it in any header at all?  Having that sucker
  in task_mmu.c and task_nommu.c would be more than enough (and we'd avoid
  that ifdef in definition, while we are at it).

How about this:

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7411bfb..3aebc85 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -219,7 +219,7 @@ out:
 	task_unlock(task);
 	up_read(&mm->mmap_sem);
 	mmput(mm);
-	return NULL;
+	return ERR_PTR(-EPERM);
 }
 
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8043a3e..75bef20 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -131,12 +131,19 @@ struct pmd_walker {
 		       unsigned long, void *);
 };
 
+struct proc_maps_private {
+	struct pid *pid;
+	struct task_struct *task;
+	struct vm_area_struct *tail_vma;
+	struct mm_struct *mm;
+};
+
 static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats *mss)
 {
 	struct proc_maps_private *priv = m->private;
 	struct task_struct *task = priv->task;
+	struct mm_struct *mm = priv->mm;
 	struct vm_area_struct *vma = v;
-	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
@@ -381,6 +388,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 
 	/* Clear the per syscall fields in priv */
 	priv->task = NULL;
+	priv->mm = NULL;
 	priv->tail_vma = NULL;
 
 	/*
@@ -398,10 +406,11 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 		return NULL;
 
 	mm = mm_for_maps(priv->task);
-	if (!mm)
-		return NULL;
+	if (!mm || IS_ERR(mm))
+		return ERR_CAST(mm);
 
 	priv->tail_vma = tail_vma = get_gate_vma(priv->task);
+	priv->mm = mm;
 
 	/* Start with last addr hint */
 	if (last_addr && (vma = find_vma(mm, last_addr))) {
@@ -430,20 +439,9 @@ out:
 
 	/* End of vmas has been reached */
 	m->version = (tail_vma != NULL)? 0: -1UL;
-	up_read(&mm->mmap_sem);
-	mmput(mm);
 	return tail_vma;
 }
 
-static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
-{
-	if (vma && vma != priv->tail_vma) {
-		struct mm_struct *mm = vma->vm_mm;
-		up_read(&mm->mmap_sem);
-		mmput(mm);
-	}
-}
-
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
@@ -451,18 +449,22 @@ static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 	struct vm_area_struct *tail_vma = priv->tail_vma;
 
 	(*pos)++;
-	if (vma && (vma != tail_vma) && vma->vm_next)
+	if (vma == tail_vma)
+		return NULL;
+	else if (vma->vm_next)
 		return vma->vm_next;
-	vma_stop(priv, vma);
-	return (vma != tail_vma)? tail_vma: NULL;
+	else
+		return tail_vma;
 }
 
 static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *vma = v;
 
-	vma_stop(priv, vma);
+	if (priv->mm) {
+		up_read(&priv->mm->mmap_sem);
+		mmput(priv->mm);
+	}
 	if (priv->task)
 		put_task_struct(priv->task);
 }
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 1932c2c..a156b62 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -138,6 +138,12 @@ out:
 	return result;
 }
 
+struct proc_maps_private {
+	struct pid *pid;
+	struct task_struct *task;
+	struct mm_struct *mm;
+};
+
 /*
  * display mapping lines for a particular process's /proc/pid/maps
  */
@@ -161,16 +167,16 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	loff_t n = *pos;
 
 	/* pin the task and mm whilst we play with them */
+	priv->mm = NULL;
 	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
 	if (!priv->task)
 		return NULL;
 
 	mm = mm_for_maps(priv->task);
-	if (!mm) {
-		put_task_struct(priv->task);
-		priv->task = NULL;
-		return NULL;
-	}
+	if (!mm || IS_ERR(mm))
+		return ERR_CAST(mm);
+
+	priv->mm = mm;
 
 	/* start from the Nth VMA */
 	for (vml = mm->context.vmlist; vml; vml = vml->next)
@@ -183,12 +189,12 @@ static void m_stop(struct seq_file *m, void *_vml)
 {
 	struct proc_maps_private *priv = m->private;
 
-	if (priv->task) {
-		struct mm_struct *mm = priv->task->mm;
-		up_read(&mm->mmap_sem);
-		mmput(mm);
-		put_task_struct(priv->task);
+	if (priv->mm) {
+		up_read(&priv->mm->mmap_sem);
+		mmput(priv->mm);
 	}
+	if (priv->task)
+		put_task_struct(priv->task);
 }
 
 static void *m_next(struct seq_file *m, void *_vml, loff_t *pos)
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index a531682..192a5c4 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -286,12 +286,4 @@ static inline struct net *PDE_NET(struct proc_dir_entry *pde)
 
 struct net *get_proc_net(const struct inode *inode);
 
-struct proc_maps_private {
-	struct pid *pid;
-	struct task_struct *task;
-#ifdef CONFIG_MMU
-	struct vm_area_struct *tail_vma;
-#endif
-};
-
 #endif /* _LINUX_PROC_FS_H */

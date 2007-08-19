Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbXHSH47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbXHSH47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXHSHzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:55:55 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50432 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751280AbXHSHzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:55:52 -0400
Message-ID: <387510147.93529@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070819075547.562443204@mail.ustc.edu.cn>
References: <20070819075410.411207640@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 19 Aug 2007 15:54:12 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Matt Mackall <mpm@selenic.com>, Al Viro <viro@ftp.linux.org.uk>
Cc: John Berthels <jjberthels@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] maps: address based vma walking
Content-Disposition: inline; filename=maps-enable-address-based-pos.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Split large vmas into page groups of proc_maps_private.batch_size bytes, and
iterate them one by one for seqfile->show.

This allows us to export large scale process address space information via the
seqfile interface. The old behavior of walking one vma at a time can be
achieved by setting the batching size to ~0UL.

The conversion to address based walking makes the code more
- clean:  code size is one half
- fast:   rbtree faster than lists
- stable: won't miss/dup vma in case of vma insertion/deletion

Cc: Matt Mackall <mpm@selenic.com>
Cc: Al Viro <viro@ftp.linux.org.uk>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/proc/task_mmu.c      |  101 ++++++++++++--------------------------
 include/linux/proc_fs.h |    7 +-
 mm/mempolicy.c          |    2 
 3 files changed, 36 insertions(+), 74 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/include/linux/proc_fs.h
+++ linux-2.6.23-rc2-mm2/include/linux/proc_fs.h
@@ -283,9 +283,10 @@ static inline struct proc_dir_entry *PDE
 struct proc_maps_private {
 	struct pid *pid;
 	struct task_struct *task;
-#ifdef CONFIG_MMU
-	struct vm_area_struct *tail_vma;
-#endif
+	struct mm_struct *mm;
+	/* walk min(batch_size, remaining_size_of(vma)) bytes at a time */
+	unsigned long batch_size;
+	unsigned long addr;
 };
 
 #endif /* _LINUX_PROC_FS_H */
--- linux-2.6.23-rc2-mm2.orig/mm/mempolicy.c
+++ linux-2.6.23-rc2-mm2/mm/mempolicy.c
@@ -1937,7 +1937,5 @@ out:
 	seq_putc(m, '\n');
 	kfree(md);
 
-	if (m->count < m->size)
-		m->version = (vma != priv->tail_vma) ? vma->vm_start : 0;
 	return 0;
 }
--- linux-2.6.23-rc2-mm2.orig/fs/proc/task_mmu.c
+++ linux-2.6.23-rc2-mm2/fs/proc/task_mmu.c
@@ -115,99 +115,63 @@ static void pad_len_spaces(struct seq_fi
 	seq_printf(m, "%*c", len, ' ');
 }
 
-static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
+static void *seek_vma_addr(struct seq_file *m,
+			   struct vm_area_struct *vma, loff_t *pos)
 {
-	if (vma && vma != priv->tail_vma) {
-		struct mm_struct *mm = vma->vm_mm;
-		up_read(&mm->mmap_sem);
-		mmput(mm);
+	struct proc_maps_private *priv = m->private;
+	unsigned long addr = *pos;
+
+	if (addr & 1) { /* time for next batch */
+		if (vma->vm_end - addr < priv->batch_size) {
+			vma = vma->vm_next;
+			if (!vma || vma == get_gate_vma(priv->task))
+				return NULL;
+		} else
+			addr = (addr + priv->batch_size) & ~1;
 	}
+	if (addr < vma->vm_start)
+	    addr = vma->vm_start;
+
+	*pos = priv->addr = addr;
+	return vma;
 }
 
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
-	unsigned long last_addr = m->version;
-	struct mm_struct *mm;
-	struct vm_area_struct *vma, *tail_vma = NULL;
-	loff_t l = *pos;
-
-	/* Clear the per syscall fields in priv */
-	priv->task = NULL;
-	priv->tail_vma = NULL;
-
-	/*
-	 * We remember last_addr rather than next_addr to hit with
-	 * mmap_cache most of the time. We have zero last_addr at
-	 * the beginning and also after lseek. We will have -1 last_addr
-	 * after the end of the vmas.
-	 */
-
-	if (last_addr == -1UL)
-		return NULL;
+	struct vm_area_struct *vma;
 
+	priv->mm = NULL;
 	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
 	if (!priv->task)
 		return NULL;
 
-	mm = get_task_mm(priv->task);
-	if (!mm)
+	priv->mm = get_task_mm(priv->task);
+	if (!priv->mm)
 		return NULL;
 
-	priv->tail_vma = tail_vma = get_gate_vma(priv->task);
-	down_read(&mm->mmap_sem);
+	down_read(&priv->mm->mmap_sem);
 
-	/* Start with last addr hint */
-	if (last_addr && (vma = find_vma(mm, last_addr))) {
-		vma = vma->vm_next;
-		goto out;
-	}
-
-	/*
-	 * Check the vma index is within the range and do
-	 * sequential scan until m_index.
-	 */
-	vma = NULL;
-	if ((unsigned long)l < mm->map_count) {
-		vma = mm->mmap;
-		while (l-- && vma)
-			vma = vma->vm_next;
-		goto out;
-	}
-
-	if (l != mm->map_count)
-		tail_vma = NULL; /* After gate vma */
-
-out:
-	if (vma)
-		return vma;
+	vma = find_vma(priv->mm, *pos);
+	if (!vma || vma == get_gate_vma(priv->task))
+		return NULL;
 
-	/* End of vmas has been reached */
-	m->version = (tail_vma != NULL)? 0: -1UL;
-	up_read(&mm->mmap_sem);
-	mmput(mm);
-	return tail_vma;
+	return seek_vma_addr(m, vma, pos);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *vma = v;
-	struct vm_area_struct *tail_vma = priv->tail_vma;
-
 	(*pos)++;
-	if (vma && (vma != tail_vma) && vma->vm_next)
-		return vma->vm_next;
-	vma_stop(priv, vma);
-	return (vma != tail_vma)? tail_vma: NULL;
+	return seek_vma_addr(m, v, pos);
 }
 
 static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *vma = v;
-
-	vma_stop(priv, vma);
+	if (priv->mm) {
+		up_read(&priv->mm->mmap_sem);
+		mmput(priv->mm);
+	}
 	if (priv->task)
 		put_task_struct(priv->task);
 }
@@ -220,6 +184,7 @@ static int do_maps_open(struct inode *in
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv) {
 		priv->pid = proc_pid(inode);
+		priv->batch_size = ~0;
 		ret = seq_open(file, ops);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
@@ -291,8 +256,6 @@ static int show_map(struct seq_file *m, 
 	}
 	seq_putc(m, '\n');
 
-	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != get_gate_vma(task))? vma->vm_start: 0;
 	return 0;
 }
 

-- 

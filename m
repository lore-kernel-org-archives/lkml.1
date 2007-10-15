Return-Path: <linux-kernel-owner+w=401wt.eu-S1764983AbXJOW2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764983AbXJOW2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759975AbXJOW0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:26:16 -0400
Received: from waste.org ([66.93.16.53]:1297 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756829AbXJOW0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:26:08 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.290135367@selenic.com>
Message-Id: <9.290135367@selenic.com>
Subject: [PATCH 8/11] maps3: regroup task_mmu by interface
Date: Mon, 15 Oct 2007 17:26:05 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>

Reorder source so that all the code and data for each interface is together.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Index: l/fs/proc/task_mmu.c
===================================================================
--- l.orig/fs/proc/task_mmu.c	2007-10-14 13:42:11.000000000 -0500
+++ l/fs/proc/task_mmu.c	2007-10-14 18:07:26.000000000 -0500
@@ -114,37 +114,121 @@ static void pad_len_spaces(struct seq_fi
 	seq_printf(m, "%*c", len, ' ');
 }
 
-struct mem_size_stats
+static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
 {
-	struct vm_area_struct *vma;
-	unsigned long resident;
-	unsigned long shared_clean;
-	unsigned long shared_dirty;
-	unsigned long private_clean;
-	unsigned long private_dirty;
-	unsigned long referenced;
+	if (vma && vma != priv->tail_vma) {
+		struct mm_struct *mm = vma->vm_mm;
+		up_read(&mm->mmap_sem);
+		mmput(mm);
+	}
+}
+
+static void *m_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_maps_private *priv = m->private;
+	unsigned long last_addr = m->version;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma, *tail_vma = NULL;
+	loff_t l = *pos;
+
+	/* Clear the per syscall fields in priv */
+	priv->task = NULL;
+	priv->tail_vma = NULL;
 
 	/*
-	 * Proportional Set Size(PSS): my share of RSS.
-	 *
-	 * PSS of a process is the count of pages it has in memory, where each
-	 * page is divided by the number of processes sharing it.  So if a
-	 * process has 1000 pages all to itself, and 1000 shared with one other
-	 * process, its PSS will be 1500.               - Matt Mackall, lwn.net
+	 * We remember last_addr rather than next_addr to hit with
+	 * mmap_cache most of the time. We have zero last_addr at
+	 * the beginning and also after lseek. We will have -1 last_addr
+	 * after the end of the vmas.
 	 */
-	u64 	      pss;
+
+	if (last_addr == -1UL)
+		return NULL;
+
+	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
+	if (!priv->task)
+		return NULL;
+
+	mm = get_task_mm(priv->task);
+	if (!mm)
+		return NULL;
+
+	priv->tail_vma = tail_vma = get_gate_vma(priv->task);
+	down_read(&mm->mmap_sem);
+
+	/* Start with last addr hint */
+	if (last_addr && (vma = find_vma(mm, last_addr))) {
+		vma = vma->vm_next;
+		goto out;
+	}
+
 	/*
-	 * To keep (accumulated) division errors low, we adopt 64bit pss and
-	 * use some low bits for division errors. So (pss >> PSS_DIV_BITS)
-	 * would be the real byte count.
-	 *
-	 * A shift of 12 before division means(assuming 4K page size):
-	 * 	- 1M 3-user-pages add up to 8KB errors;
-	 * 	- supports mapcount up to 2^24, or 16M;
-	 * 	- supports PSS up to 2^52 bytes, or 4PB.
+	 * Check the vma index is within the range and do
+	 * sequential scan until m_index.
 	 */
-#define PSS_DIV_BITS	12
-};
+	vma = NULL;
+	if ((unsigned long)l < mm->map_count) {
+		vma = mm->mmap;
+		while (l-- && vma)
+			vma = vma->vm_next;
+		goto out;
+	}
+
+	if (l != mm->map_count)
+		tail_vma = NULL; /* After gate vma */
+
+out:
+	if (vma)
+		return vma;
+
+	/* End of vmas has been reached */
+	m->version = (tail_vma != NULL)? 0: -1UL;
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+	return tail_vma;
+}
+
+static void *m_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct proc_maps_private *priv = m->private;
+	struct vm_area_struct *vma = v;
+	struct vm_area_struct *tail_vma = priv->tail_vma;
+
+	(*pos)++;
+	if (vma && (vma != tail_vma) && vma->vm_next)
+		return vma->vm_next;
+	vma_stop(priv, vma);
+	return (vma != tail_vma)? tail_vma: NULL;
+}
+
+static void m_stop(struct seq_file *m, void *v)
+{
+	struct proc_maps_private *priv = m->private;
+	struct vm_area_struct *vma = v;
+
+	vma_stop(priv, vma);
+	if (priv->task)
+		put_task_struct(priv->task);
+}
+
+static int do_maps_open(struct inode *inode, struct file *file,
+			struct seq_operations *ops)
+{
+	struct proc_maps_private *priv;
+	int ret = -ENOMEM;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv) {
+		priv->pid = proc_pid(inode);
+		ret = seq_open(file, ops);
+		if (!ret) {
+			struct seq_file *m = file->private_data;
+			m->private = priv;
+		} else {
+			kfree(priv);
+		}
+	}
+	return ret;
+}
 
 static int show_map(struct seq_file *m, void *v)
 {
@@ -211,6 +295,57 @@ static int show_map(struct seq_file *m, 
 	return 0;
 }
 
+static struct seq_operations proc_pid_maps_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= show_map
+};
+
+static int maps_open(struct inode *inode, struct file *file)
+{
+	return do_maps_open(inode, file, &proc_pid_maps_op);
+}
+
+const struct file_operations proc_maps_operations = {
+	.open		= maps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+
+struct mem_size_stats
+{
+	struct vm_area_struct *vma;
+	unsigned long resident;
+	unsigned long shared_clean;
+	unsigned long shared_dirty;
+	unsigned long private_clean;
+	unsigned long private_dirty;
+	unsigned long referenced;
+
+	/*
+	 * Proportional Set Size(PSS): my share of RSS.
+	 *
+	 * PSS of a process is the count of pages it has in memory, where each
+	 * page is divided by the number of processes sharing it.  So if a
+	 * process has 1000 pages all to itself, and 1000 shared with one other
+	 * process, its PSS will be 1500.               - Matt Mackall, lwn.net
+	 */
+	u64 	      pss;
+	/*
+	 * To keep (accumulated) division errors low, we adopt 64bit pss and
+	 * use some low bits for division errors. So (pss >> PSS_DIV_BITS)
+	 * would be the real byte count.
+	 *
+	 * A shift of 12 before division means(assuming 4K page size):
+	 * 	- 1M 3-user-pages add up to 8KB errors;
+	 * 	- supports mapcount up to 2^24, or 16M;
+	 * 	- supports PSS up to 2^52 bytes, or 4PB.
+	 */
+#define PSS_DIV_BITS	12
+};
+
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   void *private)
 {
@@ -256,33 +391,6 @@ static int smaps_pte_range(pmd_t *pmd, u
 	return 0;
 }
 
-static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
-				unsigned long end, void *private)
-{
-	struct vm_area_struct *vma = private;
-	pte_t *pte, ptent;
-	spinlock_t *ptl;
-	struct page *page;
-
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE) {
-		ptent = *pte;
-		if (!pte_present(ptent))
-			continue;
-
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page)
-			continue;
-
-		/* Clear accessed and referenced bits. */
-		ptep_test_and_clear_young(vma, addr, pte);
-		ClearPageReferenced(page);
-	}
-	pte_unmap_unlock(pte - 1, ptl);
-	cond_resched();
-	return 0;
-}
-
 static struct mm_walk smaps_walk = { .pmd_entry = smaps_pte_range };
 
 static int show_smap(struct seq_file *m, void *v)
@@ -322,6 +430,52 @@ static int show_smap(struct seq_file *m,
 	return ret;
 }
 
+static struct seq_operations proc_pid_smaps_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= show_smap
+};
+
+static int smaps_open(struct inode *inode, struct file *file)
+{
+	return do_maps_open(inode, file, &proc_pid_smaps_op);
+}
+
+const struct file_operations proc_smaps_operations = {
+	.open		= smaps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+
+static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
+				unsigned long end, void *private)
+{
+	struct vm_area_struct *vma = private;
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
+		ptep_test_and_clear_young(vma, addr, pte);
+		ClearPageReferenced(page);
+	}
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+	return 0;
+}
+
 static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
 
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
@@ -365,148 +519,6 @@ const struct file_operations proc_clear_
 	.write		= clear_refs_write,
 };
 
-static void *m_start(struct seq_file *m, loff_t *pos)
-{
-	struct proc_maps_private *priv = m->private;
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
-
-	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
-	if (!priv->task)
-		return NULL;
-
-	mm = get_task_mm(priv->task);
-	if (!mm)
-		return NULL;
-
-	priv->tail_vma = tail_vma = get_gate_vma(priv->task);
-	down_read(&mm->mmap_sem);
-
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
-
-	/* End of vmas has been reached */
-	m->version = (tail_vma != NULL)? 0: -1UL;
-	up_read(&mm->mmap_sem);
-	mmput(mm);
-	return tail_vma;
-}
-
-static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
-{
-	if (vma && vma != priv->tail_vma) {
-		struct mm_struct *mm = vma->vm_mm;
-		up_read(&mm->mmap_sem);
-		mmput(mm);
-	}
-}
-
-static void *m_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *vma = v;
-	struct vm_area_struct *tail_vma = priv->tail_vma;
-
-	(*pos)++;
-	if (vma && (vma != tail_vma) && vma->vm_next)
-		return vma->vm_next;
-	vma_stop(priv, vma);
-	return (vma != tail_vma)? tail_vma: NULL;
-}
-
-static void m_stop(struct seq_file *m, void *v)
-{
-	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *vma = v;
-
-	vma_stop(priv, vma);
-	if (priv->task)
-		put_task_struct(priv->task);
-}
-
-static struct seq_operations proc_pid_maps_op = {
-	.start	= m_start,
-	.next	= m_next,
-	.stop	= m_stop,
-	.show	= show_map
-};
-
-static struct seq_operations proc_pid_smaps_op = {
-	.start	= m_start,
-	.next	= m_next,
-	.stop	= m_stop,
-	.show	= show_smap
-};
-
-static int do_maps_open(struct inode *inode, struct file *file,
-			struct seq_operations *ops)
-{
-	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->pid = proc_pid(inode);
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
-}
-
-static int maps_open(struct inode *inode, struct file *file)
-{
-	return do_maps_open(inode, file, &proc_pid_maps_op);
-}
-
-const struct file_operations proc_maps_operations = {
-	.open		= maps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};
-
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
 
@@ -541,14 +553,3 @@ const struct file_operations proc_numa_m
 };
 #endif
 
-static int smaps_open(struct inode *inode, struct file *file)
-{
-	return do_maps_open(inode, file, &proc_pid_smaps_op);
-}
-
-const struct file_operations proc_smaps_operations = {
-	.open		= smaps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};

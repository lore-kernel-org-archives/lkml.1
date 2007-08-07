Return-Path: <linux-kernel-owner+w=401wt.eu-S934446AbXHGOXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbXHGOXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXHGOX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:23:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbXHGOXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:23:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46B86FC1.7050601@t-online.de>
References: <46B86FC1.7050601@t-online.de> <46695F6D.5050600@t-online.de> <8772.1186149811@redhat.com>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH] NOMMU: Separate out VMAs
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 07 Aug 2007 14:17:03 +0100
Message-ID: <23249.1186492623@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schmidt <bernds_cb1@t-online.de> wrote:

> There is a leak:

Yes.  I found the major leak this morning.  There may be a minor leak, but I'm
not convinced it's in the mmap stuff.  See revised patch.

The leak was due to the fact that I wasn't setting the usage count on the 2nd+
pages when I made a >0 order allocation.

David

---
[PATCH] NOMMU: Make VMAs per MM as for MMU-mode linux

From: David Howells <dhowells@redhat.com>

Make VMAs per mm_struct as for MMU-mode linux.  This solves the nattch problem
for SYSV SHM where nattch for a segment does not reflect the number of shmat's
(and forks) done.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 arch/frv/Makefile        |    2 
 arch/frv/kernel/ptrace.c |   11 -
 fs/binfmt_elf_fdpic.c    |   29 --
 fs/proc/internal.h       |    2 
 fs/proc/nommu.c          |   71 ++--
 fs/proc/task_nommu.c     |  135 +++++--
 include/asm-frv/mmu.h    |    1 
 include/linux/mm.h       |   43 +-
 ipc/shm.c                |   12 +
 mm/nommu.c               |  852 +++++++++++++++++++++++++++++++---------------
 10 files changed, 740 insertions(+), 418 deletions(-)

diff --git a/arch/frv/Makefile b/arch/frv/Makefile
index 9bf7345..038e3a8 100644
--- a/arch/frv/Makefile
+++ b/arch/frv/Makefile
@@ -88,7 +88,7 @@ ASFLAGS		+= -mno-fdpic
 # make sure the .S files get compiled with debug info
 # and disable optimisations that are unhelpful whilst debugging
 ifdef CONFIG_DEBUG_INFO
-#CFLAGS		+= -O1
+CFLAGS		+= -O1
 AFLAGS		+= -Wa,--gdwarf2
 ASFLAGS		+= -Wa,--gdwarf2
 endif
diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index 709e9bd..e9af8de 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -69,7 +69,8 @@ static inline int put_reg(struct task_struct *task, int regno,
 }
 
 /*
- * check that an address falls within the bounds of the target process's memory mappings
+ * check that an address falls within the bounds of the target process's memory
+ * mappings
  */
 static inline int is_user_addr_valid(struct task_struct *child,
 				     unsigned long start, unsigned long len)
@@ -79,11 +80,11 @@ static inline int is_user_addr_valid(struct task_struct *child,
 		return -EIO;
 	return 0;
 #else
-	struct vm_list_struct *vml;
+	struct vm_area_struct *vma;
 
-	for (vml = child->mm->context.vmlist; vml; vml = vml->next)
-		if (start >= vml->vma->vm_start && start + len <= vml->vma->vm_end)
-			return 0;
+	vma = find_vma(child->mm, start);
+	if (start >= vma->vm_start && start + len <= vma->vm_end)
+		return 0;
 
 	return -EIO;
 #endif
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 2f5d8db..c76070f 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -384,7 +384,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	}
 
 	/* expand the stack mapping to use up the entire allocation granule */
-	fullsize = ksize((char *) current->mm->start_brk);
+	fullsize = PAGE_ALIGN(current->mm->start_brk);
 	if (!IS_ERR_VALUE(do_mremap(current->mm->start_brk, stack_size,
 				    fullsize, 0, 0)))
 		stack_size = fullsize;
@@ -1524,11 +1524,9 @@ end_coredump:
 static int elf_fdpic_dump_segments(struct file *file, size_t *size,
 			   unsigned long *limit, unsigned long mm_flags)
 {
-	struct vm_list_struct *vml;
-
-	for (vml = current->mm->context.vmlist; vml; vml = vml->next) {
-	struct vm_area_struct *vma = vml->vma;
+	struct vm_area_struct *vma;
 
+	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		if (!maydump(vma, mm_flags))
 			continue;
 
@@ -1576,9 +1574,6 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
 	elf_fpxregset_t *xfpu = NULL;
 #endif
 	int thread_status_size = 0;
-#ifndef CONFIG_MMU
-	struct vm_list_struct *vml;
-#endif
 	elf_addr_t *auxv;
 	unsigned long mm_flags;
 
@@ -1645,13 +1640,7 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
 	fill_prstatus(prstatus, current, signr);
 	elf_core_copy_regs(&prstatus->pr_reg, regs);
 
-#ifdef CONFIG_MMU
 	segs = current->mm->map_count;
-#else
-	segs = 0;
-	for (vml = current->mm->context.vmlist; vml; vml = vml->next)
-	    segs++;
-#endif
 #ifdef ELF_CORE_EXTRA_PHDRS
 	segs += ELF_CORE_EXTRA_PHDRS;
 #endif
@@ -1726,20 +1715,10 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
 	mm_flags = current->mm->flags;
 
 	/* write program headers for segments dump */
-	for (
-#ifdef CONFIG_MMU
-		vma = current->mm->mmap; vma; vma = vma->vm_next
-#else
-			vml = current->mm->context.vmlist; vml; vml = vml->next
-#endif
-	     ) {
+	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		struct elf_phdr phdr;
 		size_t sz;
 
-#ifndef CONFIG_MMU
-		vma = vml->vma;
-#endif
-
 		sz = vma->vm_end - vma->vm_start;
 
 		phdr.p_type = PT_LOAD;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index b215c35..e8aa8d3 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -33,8 +33,6 @@ do {						\
 	(vmi)->used = 0;			\
 	(vmi)->largest_chunk = 0;		\
 } while(0)
-
-extern int nommu_vma_show(struct seq_file *, struct vm_area_struct *);
 #endif
 
 extern int maps_protect;
diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
index 22f789d..c3b6b24 100644
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -33,33 +33,33 @@
 #include "internal.h"
 
 /*
- * display a single VMA to a sequenced file
+ * display a single region to a sequenced file
  */
-int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
+static int nommu_region_show(struct seq_file *m, struct vm_region *region)
 {
 	unsigned long ino = 0;
 	struct file *file;
 	dev_t dev = 0;
 	int flags, len;
 
-	flags = vma->vm_flags;
-	file = vma->vm_file;
+	flags = region->vm_flags;
+	file = region->vm_file;
 
 	if (file) {
-		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+		struct inode *inode = region->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
 	}
 
 	seq_printf(m,
 		   "%08lx-%08lx %c%c%c%c %08lx %02x:%02x %lu %n",
-		   vma->vm_start,
-		   vma->vm_end,
+		   region->vm_start,
+		   region->vm_end,
 		   flags & VM_READ ? 'r' : '-',
 		   flags & VM_WRITE ? 'w' : '-',
 		   flags & VM_EXEC ? 'x' : '-',
 		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
-		   vma->vm_pgoff << PAGE_SHIFT,
+		   region->vm_pgoff << PAGE_SHIFT,
 		   MAJOR(dev), MINOR(dev), ino, &len);
 
 	if (file) {
@@ -75,61 +75,54 @@ int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
 }
 
 /*
- * display a list of all the VMAs the kernel knows about
+ * display a list of all the REGIONs the kernel knows about
  * - nommu kernals have a single flat list
  */
-static int nommu_vma_list_show(struct seq_file *m, void *v)
+static int nommu_region_list_show(struct seq_file *m, void *_p)
 {
-	struct vm_area_struct *vma;
+	struct rb_node *p = _p;
 
-	vma = rb_entry((struct rb_node *) v, struct vm_area_struct, vm_rb);
-	return nommu_vma_show(m, vma);
+	return nommu_region_show(m, rb_entry(p, struct vm_region, vm_rb));
 }
 
-static void *nommu_vma_list_start(struct seq_file *m, loff_t *_pos)
+static void *nommu_region_list_start(struct seq_file *m, loff_t *_pos)
 {
-	struct rb_node *_rb;
+	struct rb_node *p;
 	loff_t pos = *_pos;
-	void *next = NULL;
 
-	down_read(&nommu_vma_sem);
+	down_read(&nommu_region_sem);
 
-	for (_rb = rb_first(&nommu_vma_tree); _rb; _rb = rb_next(_rb)) {
-		if (pos == 0) {
-			next = _rb;
-			break;
-		}
-		pos--;
-	}
-
-	return next;
+	for (p = rb_first(&nommu_region_tree); p; p = rb_next(p))
+		if (pos-- == 0)
+			return p;
+	return NULL;
 }
 
-static void nommu_vma_list_stop(struct seq_file *m, void *v)
+static void nommu_region_list_stop(struct seq_file *m, void *v)
 {
-	up_read(&nommu_vma_sem);
+	up_read(&nommu_region_sem);
 }
 
-static void *nommu_vma_list_next(struct seq_file *m, void *v, loff_t *pos)
+static void *nommu_region_list_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	(*pos)++;
 	return rb_next((struct rb_node *) v);
 }
 
-static struct seq_operations proc_nommu_vma_list_seqop = {
-	.start	= nommu_vma_list_start,
-	.next	= nommu_vma_list_next,
-	.stop	= nommu_vma_list_stop,
-	.show	= nommu_vma_list_show
+static struct seq_operations proc_nommu_region_list_seqop = {
+	.start	= nommu_region_list_start,
+	.next	= nommu_region_list_next,
+	.stop	= nommu_region_list_stop,
+	.show	= nommu_region_list_show
 };
 
-static int proc_nommu_vma_list_open(struct inode *inode, struct file *file)
+static int proc_nommu_region_list_open(struct inode *inode, struct file *file)
 {
-	return seq_open(file, &proc_nommu_vma_list_seqop);
+	return seq_open(file, &proc_nommu_region_list_seqop);
 }
 
-static const struct file_operations proc_nommu_vma_list_operations = {
-	.open    = proc_nommu_vma_list_open,
+static const struct file_operations proc_nommu_region_list_operations = {
+	.open    = proc_nommu_region_list_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
 	.release = seq_release,
@@ -137,7 +130,7 @@ static const struct file_operations proc_nommu_vma_list_operations = {
 
 static int __init proc_nommu_init(void)
 {
-	create_seq_entry("maps", S_IRUGO, &proc_nommu_vma_list_operations);
+	create_seq_entry("maps", S_IRUGO, &proc_nommu_region_list_operations);
 	return 0;
 }
 
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index d8b8c71..5a79c5a 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -14,25 +14,25 @@
  */
 char *task_mem(struct mm_struct *mm, char *buffer)
 {
-	struct vm_list_struct *vml;
+	struct vm_area_struct *vma;
+	struct rb_node *p;
 	unsigned long bytes = 0, sbytes = 0, slack = 0;
         
 	down_read(&mm->mmap_sem);
-	for (vml = mm->context.vmlist; vml; vml = vml->next) {
-		if (!vml->vma)
-			continue;
+	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
+		vma = rb_entry(p, struct vm_area_struct, vm_rb);
 
-		bytes += kobjsize(vml);
+		bytes += kobjsize(vma);
 		if (atomic_read(&mm->mm_count) > 1 ||
-		    atomic_read(&vml->vma->vm_usage) > 1
-		    ) {
-			sbytes += kobjsize((void *) vml->vma->vm_start);
-			sbytes += kobjsize(vml->vma);
+		    vma->vm_region ||
+		    vma->vm_flags & VM_MAYSHARE) {
+			sbytes += kobjsize((void *) vma->vm_start);
+			if (vma->vm_region)
+				sbytes += kobjsize(vma->vm_region);
 		} else {
-			bytes += kobjsize((void *) vml->vma->vm_start);
-			bytes += kobjsize(vml->vma);
-			slack += kobjsize((void *) vml->vma->vm_start) -
-				(vml->vma->vm_end - vml->vma->vm_start);
+			bytes += kobjsize((void *) vma->vm_start);
+			slack += kobjsize((void *) vma->vm_start) -
+				(vma->vm_end - vma->vm_start);
 		}
 	}
 
@@ -70,13 +70,14 @@ char *task_mem(struct mm_struct *mm, char *buffer)
 
 unsigned long task_vsize(struct mm_struct *mm)
 {
-	struct vm_list_struct *tbp;
+	struct vm_area_struct *vma;
+	struct rb_node *p;
 	unsigned long vsize = 0;
 
 	down_read(&mm->mmap_sem);
-	for (tbp = mm->context.vmlist; tbp; tbp = tbp->next) {
-		if (tbp->vma)
-			vsize += kobjsize((void *) tbp->vma->vm_start);
+	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
+		vma = rb_entry(p, struct vm_area_struct, vm_rb);
+		vsize += vma->vm_region->vm_end - vma->vm_region->vm_start;
 	}
 	up_read(&mm->mmap_sem);
 	return vsize;
@@ -85,16 +86,15 @@ unsigned long task_vsize(struct mm_struct *mm)
 int task_statm(struct mm_struct *mm, int *shared, int *text,
 	       int *data, int *resident)
 {
-	struct vm_list_struct *tbp;
+	struct vm_area_struct *vma;
+	struct rb_node *p;
 	int size = kobjsize(mm);
 
 	down_read(&mm->mmap_sem);
-	for (tbp = mm->context.vmlist; tbp; tbp = tbp->next) {
-		size += kobjsize(tbp);
-		if (tbp->vma) {
-			size += kobjsize(tbp->vma);
-			size += kobjsize((void *) tbp->vma->vm_start);
-		}
+	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
+		vma = rb_entry(p, struct vm_area_struct, vm_rb);
+		size += kobjsize(vma);
+		size += kobjsize((void *) vma->vm_start);
 	}
 
 	size += (*text = mm->end_code - mm->start_code);
@@ -106,32 +106,24 @@ int task_statm(struct mm_struct *mm, int *shared, int *text,
 
 int proc_exe_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
 {
-	struct vm_list_struct *vml;
 	struct vm_area_struct *vma;
 	struct task_struct *task = get_proc_task(inode);
 	struct mm_struct *mm = get_task_mm(task);
+	struct rb_node *p;
 	int result = -ENOENT;
 
 	if (!mm)
 		goto out;
-	down_read(&mm->mmap_sem);
 
-	vml = mm->context.vmlist;
-	vma = NULL;
-	while (vml) {
-		if ((vml->vma->vm_flags & VM_EXECUTABLE) && vml->vma->vm_file) {
-			vma = vml->vma;
-			break;
+	down_read(&mm->mmap_sem);
+	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
+		vma = rb_entry(p, struct vm_area_struct, vm_rb);
+		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file) {
+			*mnt = mntget(vma->vm_file->f_path.mnt);
+			*dentry = dget(vma->vm_file->f_path.dentry);
+			result = 0;
 		}
-		vml = vml->next;
-	}
-
-	if (vma) {
-		*mnt = mntget(vma->vm_file->f_path.mnt);
-		*dentry = dget(vma->vm_file->f_path.dentry);
-		result = 0;
 	}
-
 	up_read(&mm->mmap_sem);
 	mmput(mm);
 out:
@@ -139,25 +131,66 @@ out:
 }
 
 /*
+ * display a single VMA to a sequenced file
+ */
+static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
+{
+	unsigned long ino = 0;
+	struct file *file;
+	dev_t dev = 0;
+	int flags, len;
+
+	flags = vma->vm_flags;
+	file = vma->vm_file;
+
+	if (file) {
+		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+		dev = inode->i_sb->s_dev;
+		ino = inode->i_ino;
+	}
+
+	seq_printf(m,
+		   "%08lx-%08lx %c%c%c%c %08lx %02x:%02x %lu %n",
+		   vma->vm_start,
+		   vma->vm_end,
+		   flags & VM_READ ? 'r' : '-',
+		   flags & VM_WRITE ? 'w' : '-',
+		   flags & VM_EXEC ? 'x' : '-',
+		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
+		   vma->vm_pgoff << PAGE_SHIFT,
+		   MAJOR(dev), MINOR(dev), ino, &len);
+
+	if (file) {
+		len = 25 + sizeof(void *) * 6 - len;
+		if (len < 1)
+			len = 1;
+		seq_printf(m, "%*c", len, ' ');
+		seq_path(m, file->f_path.mnt, file->f_path.dentry, "");
+	}
+
+	seq_putc(m, '\n');
+	return 0;
+}
+
+/*
  * display mapping lines for a particular process's /proc/pid/maps
  */
-static int show_map(struct seq_file *m, void *_vml)
+static int show_map(struct seq_file *m, void *_p)
 {
-	struct vm_list_struct *vml = _vml;
 	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
+	struct rb_node *p = _p;
 
-	if (maps_protect && !ptrace_may_attach(task))
+	if (maps_protect && !ptrace_may_attach(priv->task))
 		return -EACCES;
 
-	return nommu_vma_show(m, vml->vma);
+	return nommu_vma_show(m, rb_entry(p, struct vm_area_struct, vm_rb));
 }
 
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
-	struct vm_list_struct *vml;
 	struct mm_struct *mm;
+	struct rb_node *p;
 	loff_t n = *pos;
 
 	/* pin the task and mm whilst we play with them */
@@ -175,9 +208,9 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	down_read(&mm->mmap_sem);
 
 	/* start from the Nth VMA */
-	for (vml = mm->context.vmlist; vml; vml = vml->next)
+	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p))
 		if (n-- == 0)
-			return vml;
+			return p;
 	return NULL;
 }
 
@@ -193,12 +226,12 @@ static void m_stop(struct seq_file *m, void *_vml)
 	}
 }
 
-static void *m_next(struct seq_file *m, void *_vml, loff_t *pos)
+static void *m_next(struct seq_file *m, void *_p, loff_t *pos)
 {
-	struct vm_list_struct *vml = _vml;
+	struct rb_node *p = _p;
 
 	(*pos)++;
-	return vml ? vml->next : NULL;
+	return p ? rb_next(p) : NULL;
 }
 
 static struct seq_operations proc_pid_maps_ops = {
diff --git a/include/asm-frv/mmu.h b/include/asm-frv/mmu.h
index 22c0371..86ca0e8 100644
--- a/include/asm-frv/mmu.h
+++ b/include/asm-frv/mmu.h
@@ -22,7 +22,6 @@ typedef struct {
 	unsigned long	dtlb_ptd_mapping;	/* [DAMR5] PTD mapping for dtlb cached PGE */
 
 #else
-	struct vm_list_struct	*vmlist;
 	unsigned long		end_brk;
 
 #endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 655094d..8c18ae8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -50,6 +50,30 @@ extern int sysctl_legacy_va_layout;
  * mmap() functions).
  */
 
+#ifndef CONFIG_MMU
+/*
+ * A region containing a mapping of a non-memory backed file under NOMMU
+ * conditions.  These are held in a global tree and are pinned by the VMAs that
+ * map parts of them.
+ */
+struct vm_region {
+	struct rb_node	vm_rb;		/* link in global region tree */
+	/* the first parameters define the region as for the VMA */
+	unsigned long	vm_flags;
+	unsigned long	vm_start;
+	unsigned long	vm_end;
+	unsigned long	vm_pgoff;
+	struct file	*vm_file;
+
+	atomic_t	vm_usage;	/* region usage count */
+};
+
+extern struct rb_root nommu_region_tree;
+extern struct rw_semaphore nommu_region_sem;
+
+extern unsigned int kobjsize(const void *objp);
+#endif
+
 /*
  * This struct defines a memory VMM memory area. There is one of these
  * per VM-area/task.  A VM area is any part of the process virtual memory
@@ -106,7 +130,7 @@ struct vm_area_struct {
 	unsigned long vm_truncate_count;/* truncate_count or restart_addr */
 
 #ifndef CONFIG_MMU
-	atomic_t vm_usage;		/* refcount (VMAs shared if !MMU) */
+	struct vm_region *vm_region;	/* NOMMU mapping region */
 #endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
@@ -116,23 +140,6 @@ struct vm_area_struct {
 extern struct kmem_cache *vm_area_cachep;
 
 /*
- * This struct defines the per-mm list of VMAs for uClinux. If CONFIG_MMU is
- * disabled, then there's a single shared list of VMAs maintained by the
- * system, and mm's subscribe to these individually
- */
-struct vm_list_struct {
-	struct vm_list_struct	*next;
-	struct vm_area_struct	*vma;
-};
-
-#ifndef CONFIG_MMU
-extern struct rb_root nommu_vma_tree;
-extern struct rw_semaphore nommu_vma_sem;
-
-extern unsigned int kobjsize(const void *objp);
-#endif
-
-/*
  * vm_flags..
  */
 #define VM_READ		0x00000001	/* currently active flags */
diff --git a/ipc/shm.c b/ipc/shm.c
index a86a3a5..d0f1bf8 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -1033,6 +1033,7 @@ asmlinkage long sys_shmdt(char __user *shmaddr)
 	 */
 	vma = find_vma(mm, addr);
 
+#ifdef CONFIG_MMU
 	while (vma) {
 		next = vma->vm_next;
 
@@ -1077,6 +1078,17 @@ asmlinkage long sys_shmdt(char __user *shmaddr)
 		vma = next;
 	}
 
+#else /* CONFIG_MMU */
+	/* under NOMMU conditions, the exact address to be destroyed must be
+	 * given */
+	retval = -EINVAL;
+	if (vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
+		do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
+		retval = 0;
+	}
+
+#endif
+
 	up_write(&mm->mmap_sem);
 	return retval;
 }
diff --git a/mm/nommu.c b/mm/nommu.c
index 9eef6a3..01253f6 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -6,7 +6,7 @@
  *
  *  See Documentation/nommu-mmap.txt
  *
- *  Copyright (c) 2004-2005 David Howells <dhowells@redhat.com>
+ *  Copyright (c) 2004-2007 David Howells <dhowells@redhat.com>
  *  Copyright (c) 2000-2003 David McCullough <davidm@snapgear.com>
  *  Copyright (c) 2000-2001 D Jeff Dionne <jeff@uClinux.org>
  *  Copyright (c) 2002      Greg Ungerer <gerg@snapgear.com>
@@ -32,11 +32,23 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
+#if 1
+#define kenter(FMT, ...) printk("==> %s("FMT")\n",__FUNCTION__ ,##__VA_ARGS__)
+#define kleave(FMT, ...) printk("<== %s()"FMT"\n",__FUNCTION__ ,##__VA_ARGS__)
+#define kdebug(FMT, ...) printk(FMT"\n" ,##__VA_ARGS__)
+#else
+#define kenter(FMT, ...) do {} while(0)
+#define kleave(FMT, ...) do {} while(0)
+#define kdebug(FMT, ...) do {} while(0)
+#endif
+#define _enter(FMT, ...) do {} while(0)
+#define _leave(FMT, ...) do {} while(0)
+#define _debug(FMT, ...) do {} while(0)
+
 void *high_memory;
 struct page *mem_map;
 unsigned long max_mapnr;
 unsigned long num_physpages;
-unsigned long askedalloc, realalloc;
 atomic_t vm_committed_space = ATOMIC_INIT(0);
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
@@ -47,13 +59,17 @@ EXPORT_SYMBOL(mem_map);
 EXPORT_SYMBOL(__vm_enough_memory);
 EXPORT_SYMBOL(num_physpages);
 
-/* list of shareable VMAs */
-struct rb_root nommu_vma_tree = RB_ROOT;
-DECLARE_RWSEM(nommu_vma_sem);
+/* list of shareable regions */
+struct rb_root nommu_region_tree = RB_ROOT;
+DECLARE_RWSEM(nommu_region_sem);
 
 struct vm_operations_struct generic_file_vm_ops = {
 };
 
+static atomic_t pages_allocated;
+
+#define static static noinline
+
 /*
  * Handle all mappings that got truncated by a "truncate()"
  * system call.
@@ -113,7 +129,7 @@ unsigned int kobjsize(const void *objp)
 	BUG_ON(page->index < 0);
 	BUG_ON(page->index >= MAX_ORDER);
 
-	return (PAGE_SIZE << page->index);
+	return PAGE_SIZE << page->index;
 }
 
 /*
@@ -341,16 +357,104 @@ static void show_process_blocks(void)
  * add a VMA into a process's mm_struct in the appropriate place in the list
  * - should be called with mm->mmap_sem held writelocked
  */
-static void add_vma_to_mm(struct mm_struct *mm, struct vm_list_struct *vml)
+static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	struct vm_list_struct **ppv;
+	struct vm_area_struct *pvma, **pp;
+	struct address_space *mapping;
+	struct rb_node **p, *parent;
+
+	_enter(",%p", vma);
+
+	BUG_ON(!vma->vm_region);
+
+	mm->map_count++;
+	vma->vm_mm = mm;
+
+	/* add the VMA to the mapping */
+	if (vma->vm_file) {
+		mapping = vma->vm_file->f_mapping;
+
+		flush_dcache_mmap_lock(mapping);
+		vma_prio_tree_insert(vma, &mapping->i_mmap);
+		flush_dcache_mmap_unlock(mapping);
+	}
+
+	/* add the VMA to the tree */
+	parent = NULL;
+	p = &mm->mm_rb.rb_node;
+	while (*p) {
+		parent = *p;
+		pvma = rb_entry(parent, struct vm_area_struct, vm_rb);
+
+		/* sort by: start addr, end addr, VMA struct addr in that order
+		 * (the latter is necessary as we may get identical VMAs) */
+		if (vma->vm_start < pvma->vm_start)
+			p = &(*p)->rb_left;
+		else if (vma->vm_start > pvma->vm_start)
+			p = &(*p)->rb_right;
+		else if (vma->vm_end < pvma->vm_end)
+			p = &(*p)->rb_left;
+		else if (vma->vm_end > pvma->vm_end)
+			p = &(*p)->rb_right;
+		else if (vma < pvma)
+			p = &(*p)->rb_left;
+		else if (vma > pvma)
+			p = &(*p)->rb_right;
+		else
+			BUG();
+	}
 
-	for (ppv = &current->mm->context.vmlist; *ppv; ppv = &(*ppv)->next)
-		if ((*ppv)->vma->vm_start > vml->vma->vm_start)
+	rb_link_node(&vma->vm_rb, parent, p);
+	rb_insert_color(&vma->vm_rb, &mm->mm_rb);
+
+	/* add VMA to the VMA list also */
+	for (pp = &mm->mmap; (pvma = *pp); pp = &(*pp)->vm_next) {
+		if (pvma->vm_start > vma->vm_start)
 			break;
+		if (pvma->vm_start < vma->vm_start)
+			continue;
+		if (pvma->vm_end < vma->vm_end)
+			break;
+	}
 
-	vml->next = *ppv;
-	*ppv = vml;
+	vma->vm_next = *pp;
+	*pp = vma;
+}
+
+/*
+ * delete a VMA from an mm_struct
+ */
+static void delete_vma_from_mm(struct vm_area_struct *vma)
+{
+	struct vm_area_struct **pp;
+	struct address_space *mapping;
+	struct mm_struct *mm = vma->vm_mm;
+
+	_enter("%p", vma);
+
+	mm->map_count--;
+	if (mm->mmap_cache == vma)
+		mm->mmap_cache = NULL;
+
+	/* remove the VMA from the mapping */
+	if (vma->vm_file) {
+		mapping = vma->vm_file->f_mapping;
+
+		flush_dcache_mmap_lock(mapping);
+		vma_prio_tree_remove(vma, &mapping->i_mmap);
+		flush_dcache_mmap_unlock(mapping);
+	}
+
+	/* remove from the MM's tree and list */
+	rb_erase(&vma->vm_rb, &mm->mm_rb);
+	for (pp = &mm->mmap; *pp; pp = &(*pp)->vm_next) {
+		if (*pp == vma) {
+			*pp = vma->vm_next;
+			break;
+		}
+	}
+
+	vma->vm_mm = NULL;
 }
 
 /*
@@ -359,18 +463,25 @@ static void add_vma_to_mm(struct mm_struct *mm, struct vm_list_struct *vml)
  */
 struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
-	struct vm_list_struct *loop, *vml;
+	struct vm_area_struct *vma;
+	struct rb_node *n = mm->mm_rb.rb_node;
 
-	/* search the vm_start ordered list */
-	vml = NULL;
-	for (loop = mm->context.vmlist; loop; loop = loop->next) {
-		if (loop->vma->vm_start > addr)
-			break;
-		vml = loop;
-	}
+	/* check the cache first */
+	vma = mm->mmap_cache;
+	if (vma && vma->vm_start <= addr && vma->vm_end > addr)
+		return vma;
 
-	if (vml && vml->vma->vm_end > addr)
-		return vml->vma;
+	/* trawl the tree (there may be multiple mappings in which addr
+	 * resides) */
+	for (n = rb_first(&mm->mm_rb); n; n = rb_next(n)) {
+		vma = rb_entry(n, struct vm_area_struct, vm_rb);
+		if (vma->vm_start > addr)
+			return NULL;
+		if (vma->vm_end > addr) {
+			mm->mmap_cache = vma;
+			return vma;
+		}
+	}
 
 	return NULL;
 }
@@ -394,111 +505,161 @@ int expand_stack(struct vm_area_struct *vma, unsigned long address)
  * look up the first VMA exactly that exactly matches addr
  * - should be called with mm->mmap_sem at least held readlocked
  */
-static inline struct vm_area_struct *find_vma_exact(struct mm_struct *mm,
-						    unsigned long addr)
+static struct vm_area_struct *find_vma_exact(struct mm_struct *mm,
+					     unsigned long addr,
+					     unsigned long len)
 {
-	struct vm_list_struct *vml;
+	struct vm_area_struct *vma;
+	struct rb_node *n = mm->mm_rb.rb_node;
+	unsigned long end = addr + len;
 
-	/* search the vm_start ordered list */
-	for (vml = mm->context.vmlist; vml; vml = vml->next) {
-		if (vml->vma->vm_start == addr)
-			return vml->vma;
-		if (vml->vma->vm_start > addr)
-			break;
+	/* check the cache first */
+	vma = mm->mmap_cache;
+	if (vma && vma->vm_start == addr && vma->vm_end == end)
+		return vma;
+
+	/* trawl the tree (there may be multiple mappings in which addr
+	 * resides) */
+	for (n = rb_first(&mm->mm_rb); n; n = rb_next(n)) {
+		vma = rb_entry(n, struct vm_area_struct, vm_rb);
+		if (vma->vm_start < addr)
+			continue;
+		if (vma->vm_start > addr)
+			return NULL;
+		if (vma->vm_end == end) {
+			mm->mmap_cache = vma;
+			return vma;
+		}
 	}
 
 	return NULL;
 }
 
 /*
- * find a VMA in the global tree
+ * check a region tree
  */
-static inline struct vm_area_struct *find_nommu_vma(unsigned long start)
+static noinline bool check_tree_aux(struct rb_node *node,
+				    struct rb_node *parent,
+				    int depth, char lr)
 {
-	struct vm_area_struct *vma;
-	struct rb_node *n = nommu_vma_tree.rb_node;
+	struct vm_region *region;
+	bool bad = false;
+
+	if (!node)
+		return false;
+
+	if (node->rb_left)
+		bad = check_tree_aux(node->rb_left, node, depth + 2, '/');
+
+	region = rb_entry(node, struct vm_region, vm_rb);
+	_debug("%c %*.*s%c%p {%lx-%lx}",
+	       rb_is_red(node) ? 'R' : 'B',
+	       depth, depth, "", lr,
+	       region, region->vm_start, region->vm_end);
+	if (rb_parent(node) != parent) {
+		printk("BAD: %p != %p\n", rb_parent(node), parent);
+		bad = true;
+	}
 
-	while (n) {
-		vma = rb_entry(n, struct vm_area_struct, vm_rb);
+	if (node->rb_right)
+		bad |= check_tree_aux(node->rb_right, node, depth + 2, '\\');
 
-		if (start < vma->vm_start)
-			n = n->rb_left;
-		else if (start > vma->vm_start)
-			n = n->rb_right;
-		else
-			return vma;
-	}
+	return bad;
+}
 
-	return NULL;
+static noinline void check_region_tree(void)
+{
+	if (check_tree_aux(nommu_region_tree.rb_node, NULL, 0, '-'))
+		BUG();
 }
 
 /*
- * add a VMA in the global tree
+ * add a region into the global tree
  */
-static void add_nommu_vma(struct vm_area_struct *vma)
+static void add_nommu_region(struct vm_region *region)
 {
-	struct vm_area_struct *pvma;
-	struct address_space *mapping;
-	struct rb_node **p = &nommu_vma_tree.rb_node;
-	struct rb_node *parent = NULL;
+	struct vm_region *pregion;
+	struct rb_node **p, *parent;
 
-	/* add the VMA to the mapping */
-	if (vma->vm_file) {
-		mapping = vma->vm_file->f_mapping;
-
-		flush_dcache_mmap_lock(mapping);
-		vma_prio_tree_insert(vma, &mapping->i_mmap);
-		flush_dcache_mmap_unlock(mapping);
-	}
-
-	/* add the VMA to the master list */
+	parent = NULL;
+	p = &nommu_region_tree.rb_node;
 	while (*p) {
 		parent = *p;
-		pvma = rb_entry(parent, struct vm_area_struct, vm_rb);
-
-		if (vma->vm_start < pvma->vm_start) {
+		pregion = rb_entry(parent, struct vm_region, vm_rb);
+		if (region->vm_start < pregion->vm_start)
 			p = &(*p)->rb_left;
-		}
-		else if (vma->vm_start > pvma->vm_start) {
+		else if (region->vm_start > pregion->vm_start)
 			p = &(*p)->rb_right;
-		}
-		else {
-			/* mappings are at the same address - this can only
-			 * happen for shared-mem chardevs and shared file
-			 * mappings backed by ramfs/tmpfs */
-			BUG_ON(!(pvma->vm_flags & VM_SHARED));
-
-			if (vma < pvma)
-				p = &(*p)->rb_left;
-			else if (vma > pvma)
-				p = &(*p)->rb_right;
-			else
-				BUG();
-		}
+		else if (pregion == region)
+			return;
+		else
+			BUG();
 	}
 
-	rb_link_node(&vma->vm_rb, parent, p);
-	rb_insert_color(&vma->vm_rb, &nommu_vma_tree);
+	rb_link_node(&region->vm_rb, parent, p);
+	rb_insert_color(&region->vm_rb, &nommu_region_tree);
 }
 
 /*
- * delete a VMA from the global list
+ * delete a region from the global tree
  */
-static void delete_nommu_vma(struct vm_area_struct *vma)
+static void delete_nommu_region(struct vm_region *region)
 {
-	struct address_space *mapping;
+	check_region_tree();
+	BUG_ON(!nommu_region_tree.rb_node);
+	rb_erase(&region->vm_rb, &nommu_region_tree);
+	BUG_ON(!nommu_region_tree.rb_node);
+}
 
-	/* remove the VMA from the mapping */
-	if (vma->vm_file) {
-		mapping = vma->vm_file->f_mapping;
+/*
+ * free a series of pages
+ */
+static void free_page_series(unsigned long from, unsigned long to)
+{
+	for (; from < to; from += PAGE_SIZE) {
+		_debug("- free %lx", from);
+		atomic_dec(&pages_allocated);
+		put_page(virt_to_page(from));
+	}
+}
 
-		flush_dcache_mmap_lock(mapping);
-		vma_prio_tree_remove(vma, &mapping->i_mmap);
-		flush_dcache_mmap_unlock(mapping);
+/*
+ * release a reference to a region
+ * - the caller must hold the region semaphore, which this releases
+ */
+static void __put_nommu_region(struct vm_region *region)
+	__releases(nommu_region_sem)
+{
+	_enter("%p{%d}", region, atomic_read(&region->vm_usage));
+
+	BUG_ON(!nommu_region_tree.rb_node);
+
+	if (atomic_dec_and_test(&region->vm_usage)) {
+		delete_nommu_region(region);
+		up_write(&nommu_region_sem);
+
+		if (region->vm_file)
+			fput(region->vm_file);
+
+		/* IO memory and memory shared directly out of the pagecache from
+		 * ramfs/tmpfs mustn't be released here */
+		if (region->vm_flags & VM_MAPPED_COPY) {
+			_debug("free series");
+			free_page_series(region->vm_start, region->vm_end);
+		}
+		kfree(region);
+	} else {
+		up_write(&nommu_region_sem);
 	}
+}
 
-	/* remove from the master list */
-	rb_erase(&vma->vm_rb, &nommu_vma_tree);
+/*
+ * release a reference to a region
+ */
+static void put_nommu_region(struct vm_region *region)
+{
+	down_write(&nommu_region_sem);
+	__put_nommu_region(region);
 }
 
 /*
@@ -712,9 +873,10 @@ static unsigned long determine_vm_flags(struct file *file,
 }
 
 /*
- * set up a shared mapping on a file
+ * set up a shared mapping on a file (the driver or filesystem provides and
+ * pins the storage)
  */
-static int do_mmap_shared_file(struct vm_area_struct *vma, unsigned long len)
+static int do_mmap_shared_file(struct vm_area_struct *vma)
 {
 	int ret;
 
@@ -732,10 +894,14 @@ static int do_mmap_shared_file(struct vm_area_struct *vma, unsigned long len)
 /*
  * set up a private mapping or an anonymous shared mapping
  */
-static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
+static int do_mmap_private(struct vm_area_struct *vma,
+			   struct vm_region *region,
+			   unsigned long len)
 {
+	struct page *pages;
+	unsigned long total, point;
 	void *base;
-	int ret;
+	int ret, order;
 
 	/* invoke the file's mapping function so that it can keep track of
 	 * shared mappings on devices or memory
@@ -754,23 +920,41 @@ static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
 		 * make a private copy of the data and map that instead */
 	}
 
+	len = PAGE_ALIGN(len);
+
 	/* allocate some memory to hold the mapping
 	 * - note that this may not return a page-aligned address if the object
 	 *   we're allocating is smaller than a page
 	 */
-	base = kmalloc(len, GFP_KERNEL|__GFP_COMP);
-	if (!base)
+	order = get_order(len);
+	_debug("alloc order %d for %lx", order, len);
+
+	pages = alloc_pages(GFP_KERNEL, order);
+	if (!pages)
 		goto enomem;
 
-	vma->vm_start = (unsigned long) base;
-	vma->vm_end = vma->vm_start + len;
-	vma->vm_flags |= VM_MAPPED_COPY;
+	/* we allocated a power-of-2 sized page set, so we need to trim off the
+	 * excess */
+	total = 1 << order;
+	atomic_add(total, &pages_allocated);
+
+	point = len >> PAGE_SHIFT;
+	while (point < total) {
+		order = ilog2(total - point);
+		_debug("shave %u/%lu", 1 << order, total - point);
+		atomic_sub(1 << order, &pages_allocated);
+		__free_pages(pages + point, order);
+		point += 1 << order;
+	}
 
-#ifdef WARN_ON_SLACK
-	if (len + WARN_ON_SLACK <= kobjsize(result))
-		printk("Allocation of %lu bytes from process %d has %lu bytes of slack\n",
-		       len, current->pid, kobjsize(result) - len);
-#endif
+	total = len >> PAGE_SHIFT;
+	for (point = 0; point > PAGE_SHIFT; point++)
+		BUG_ON(page_count(&pages[point]) != 1);
+
+	base = page_address(pages);
+	region->vm_start = vma->vm_start = (unsigned long) base;
+	region->vm_end   = vma->vm_end   = vma->vm_start + len;
+	region->vm_flags = vma->vm_flags |= VM_MAPPED_COPY;
 
 	if (vma->vm_file) {
 		/* read the contents of a file into the copy */
@@ -800,7 +984,7 @@ static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
 	return 0;
 
 error_free:
-	kfree(base);
+	free_page_series(region->vm_start, region->vm_end);
 	vma->vm_start = 0;
 	return ret;
 
@@ -821,84 +1005,127 @@ unsigned long do_mmap_pgoff(struct file *file,
 			    unsigned long flags,
 			    unsigned long pgoff)
 {
-	struct vm_list_struct *vml = NULL;
 	struct vm_area_struct *vma = NULL;
+	struct vm_region *region = NULL;
 	struct rb_node *rb;
-	unsigned long capabilities, vm_flags;
-	void *result;
+	unsigned long capabilities, vm_flags, result;
 	int ret;
 
+	_enter(",%lx,%lx,%lx,%lx,%lx", addr, len, prot, flags, pgoff);
+
 	/* decide whether we should attempt the mapping, and if so what sort of
 	 * mapping */
 	ret = validate_mmap_request(file, addr, len, prot, flags, pgoff,
 				    &capabilities);
-	if (ret < 0)
+	if (ret < 0) {
+		_leave(" = %d [val]", ret);
 		return ret;
+	}
 
 	/* we've determined that we can make the mapping, now translate what we
 	 * now know into VMA flags */
 	vm_flags = determine_vm_flags(file, prot, flags, capabilities);
 
-	/* we're going to need to record the mapping if it works */
-	vml = kzalloc(sizeof(struct vm_list_struct), GFP_KERNEL);
-	if (!vml)
-		goto error_getting_vml;
+	/* we're going to need to record the mapping */
+	region = kzalloc(sizeof(struct vm_region), GFP_KERNEL);
+	if (!region)
+		goto error_getting_region;
+	atomic_set(&region->vm_usage, 1);
+	region->vm_file  = file;
+	region->vm_flags = vm_flags;
+	region->vm_pgoff = pgoff;
+
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
+	if (!vma)
+		goto error_getting_vma;
 
-	down_write(&nommu_vma_sem);
+	INIT_LIST_HEAD(&vma->anon_vma_node);
+	vma->vm_file	= file;
+	vma->vm_flags	= vm_flags;
+	vma->vm_pgoff	= pgoff;
 
-	/* if we want to share, we need to check for VMAs created by other
+	if (file) {
+		get_file(file);
+		get_file(file);
+	}
+
+	down_write(&nommu_region_sem);
+
+	/* if we want to share, we need to check for regions created by other
 	 * mmap() calls that overlap with our proposed mapping
-	 * - we can only share with an exact match on most regular files
+	 * - we can only share with a superset match on most regular files
 	 * - shared mappings on character devices and memory backed files are
 	 *   permitted to overlap inexactly as far as we are concerned for in
 	 *   these cases, sharing is handled in the driver or filesystem rather
 	 *   than here
 	 */
 	if (vm_flags & VM_MAYSHARE) {
-		unsigned long pglen = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		unsigned long vmpglen;
+		struct vm_region *pregion;
+		unsigned long pglen, rpglen, pgend, rpgend, start;
 
-		/* suppress VMA sharing for shared regions */
-		if (vm_flags & VM_SHARED &&
-		    capabilities & BDI_CAP_MAP_DIRECT)
-			goto dont_share_VMAs;
+		pglen = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		pgend = pgoff + pglen;
 
-		for (rb = rb_first(&nommu_vma_tree); rb; rb = rb_next(rb)) {
-			vma = rb_entry(rb, struct vm_area_struct, vm_rb);
+		for (rb = rb_first(&nommu_region_tree); rb; rb = rb_next(rb)) {
+			pregion = rb_entry(rb, struct vm_region, vm_rb);
 
-			if (!(vma->vm_flags & VM_MAYSHARE))
+			if (!(pregion->vm_flags & VM_MAYSHARE))
 				continue;
 
 			/* search for overlapping mappings on the same file */
-			if (vma->vm_file->f_path.dentry->d_inode != file->f_path.dentry->d_inode)
+			if (pregion->vm_file->f_path.dentry->d_inode !=
+			    file->f_path.dentry->d_inode)
 				continue;
 
-			if (vma->vm_pgoff >= pgoff + pglen)
+			if (pregion->vm_pgoff >= pgend)
 				continue;
 
-			vmpglen = vma->vm_end - vma->vm_start + PAGE_SIZE - 1;
-			vmpglen >>= PAGE_SHIFT;
-			if (pgoff >= vma->vm_pgoff + vmpglen)
+			rpglen = pregion->vm_end - pregion->vm_start;
+			rpglen = (rpglen + PAGE_SIZE - 1) >> PAGE_SHIFT;
+			rpgend = pregion->vm_pgoff + rpglen;
+			if (pgoff >= rpgend)
 				continue;
 
-			/* handle inexactly overlapping matches between mappings */
-			if (vma->vm_pgoff != pgoff || vmpglen != pglen) {
+			/* handle inexactly overlapping matches between
+			 * mappings */
+			if ((pregion->vm_pgoff != pgoff || rpglen != pglen) &&
+			    !(pgoff >= pregion->vm_pgoff && pgend <= rpgend)) {
+				/* new mapping is not a subset of the region */
 				if (!(capabilities & BDI_CAP_MAP_DIRECT))
 					goto sharing_violation;
 				continue;
 			}
 
-			/* we've found a VMA we can share */
-			atomic_inc(&vma->vm_usage);
-
-			vml->vma = vma;
-			result = (void *) vma->vm_start;
-			goto shared;
+			/* we've found a region we can share */
+			atomic_inc(&pregion->vm_usage);
+			vma->vm_region = pregion;
+			start = pregion->vm_start;
+			start += (pgoff - pregion->vm_pgoff) << PAGE_SHIFT;
+			vma->vm_start = start;
+			vma->vm_end = start + len;
+
+			if (pregion->vm_flags & VM_MAPPED_COPY) {
+				_debug("share copy");
+				vma->vm_flags |= VM_MAPPED_COPY;
+			} else {
+				_debug("share mmap");
+				ret = do_mmap_shared_file(vma);
+				if (ret < 0) {
+					vma->vm_region = NULL;
+					vma->vm_start = 0;
+					vma->vm_end = 0;
+					atomic_dec(&pregion->vm_usage);
+					pregion = NULL;
+					goto error_just_free;
+				}
+			}
+			fput(region->vm_file);
+			kfree(region);
+			region = pregion;
+			result = start;
+			goto share;
 		}
 
-	dont_share_VMAs:
-		vma = NULL;
-
 		/* obtain the address at which to make a shared mapping
 		 * - this is the hook for quasi-memory character devices to
 		 *   tell us the location of a shared mapping
@@ -909,105 +1136,92 @@ unsigned long do_mmap_pgoff(struct file *file,
 			if (IS_ERR((void *) addr)) {
 				ret = addr;
 				if (ret != (unsigned long) -ENOSYS)
-					goto error;
+					goto error_just_free;
 
 				/* the driver refused to tell us where to site
 				 * the mapping so we'll have to attempt to copy
 				 * it */
 				ret = (unsigned long) -ENODEV;
 				if (!(capabilities & BDI_CAP_MAP_COPY))
-					goto error;
+					goto error_just_free;
 
 				capabilities &= ~BDI_CAP_MAP_DIRECT;
+			} else {
+				vma->vm_start = region->vm_start = addr;
+				vma->vm_end = region->vm_end = addr + len;
 			}
 		}
 	}
 
-	/* we're going to need a VMA struct as well */
-	vma = kzalloc(sizeof(struct vm_area_struct), GFP_KERNEL);
-	if (!vma)
-		goto error_getting_vma;
-
-	INIT_LIST_HEAD(&vma->anon_vma_node);
-	atomic_set(&vma->vm_usage, 1);
-	if (file)
-		get_file(file);
-	vma->vm_file	= file;
-	vma->vm_flags	= vm_flags;
-	vma->vm_start	= addr;
-	vma->vm_end	= addr + len;
-	vma->vm_pgoff	= pgoff;
-
-	vml->vma = vma;
+	vma->vm_region = region;
+	add_nommu_region(region);
 
 	/* set up the mapping */
 	if (file && vma->vm_flags & VM_SHARED)
-		ret = do_mmap_shared_file(vma, len);
+		ret = do_mmap_shared_file(vma);
 	else
-		ret = do_mmap_private(vma, len);
+		ret = do_mmap_private(vma, region, len);
 	if (ret < 0)
-		goto error;
+		goto error_put_region;
 
 	/* okay... we have a mapping; now we have to register it */
-	result = (void *) vma->vm_start;
-
-	if (vma->vm_flags & VM_MAPPED_COPY) {
-		realalloc += kobjsize(result);
-		askedalloc += len;
-	}
-
-	realalloc += kobjsize(vma);
-	askedalloc += sizeof(*vma);
+	result = vma->vm_start;
 
 	current->mm->total_vm += len >> PAGE_SHIFT;
 
-	add_nommu_vma(vma);
-
- shared:
-	realalloc += kobjsize(vml);
-	askedalloc += sizeof(*vml);
+share:
+	add_vma_to_mm(current->mm, vma);
 
-	add_vma_to_mm(current->mm, vml);
-
-	up_write(&nommu_vma_sem);
+	up_write(&nommu_region_sem);
 
 	if (prot & PROT_EXEC)
-		flush_icache_range((unsigned long) result,
-				   (unsigned long) result + len);
+		flush_icache_range(result, result + len);
 
 #ifdef DEBUG
 	printk("do_mmap:\n");
 	show_process_blocks();
 #endif
 
-	return (unsigned long) result;
+	_leave(" = %lx", result);
+	return result;
 
- error:
-	up_write(&nommu_vma_sem);
-	kfree(vml);
+error_put_region:
+	__put_nommu_region(region);
 	if (vma) {
 		if (vma->vm_file)
 			fput(vma->vm_file);
-		kfree(vma);
+		kmem_cache_free(vm_area_cachep, vma);
 	}
+	_leave(" = %d [pr]", ret);
 	return ret;
 
- sharing_violation:
-	up_write(&nommu_vma_sem);
+error_just_free:
+	up_write(&nommu_region_sem);
+error:
+	fput(region->vm_file);
+	kfree(region);
+	fput(vma->vm_file);
+	kmem_cache_free(vm_area_cachep, vma);
+	_leave(" = %d", ret);
+	return ret;
+
+sharing_violation:
+	up_write(&nommu_region_sem);
 	printk("Attempt to share mismatched mappings\n");
-	kfree(vml);
-	return -EINVAL;
+	ret = -EINVAL;
+	goto error;
 
- error_getting_vma:
-	up_write(&nommu_vma_sem);
-	kfree(vml);
-	printk("Allocation of vma for %lu byte allocation from process %d failed\n",
+error_getting_vma:
+	kfree(region);
+	printk("Allocation of vma for %lu byte allocation"
+	       " from process %d failed\n",
 	       len, current->pid);
 	show_free_areas();
 	return -ENOMEM;
 
- error_getting_vml:
-	printk("Allocation of vml for %lu byte allocation from process %d failed\n",
+error_getting_region:
+	printk("Allocation of vm region for %lu byte allocation"
+	       " from process %d failed\n",
 	       len, current->pid);
 	show_free_areas();
 	return -ENOMEM;
@@ -1015,82 +1229,178 @@ unsigned long do_mmap_pgoff(struct file *file,
 EXPORT_SYMBOL(do_mmap_pgoff);
 
 /*
- * handle mapping disposal for uClinux
+ * destroy a VMA record
  */
 static void put_vma(struct vm_area_struct *vma)
 {
-	if (vma) {
-		down_write(&nommu_vma_sem);
+	_enter("%p", vma);
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
+	if (vma->vm_file)
+		fput(vma->vm_file);
+	put_nommu_region(vma->vm_region);
+	kmem_cache_free(vm_area_cachep, vma);
+}
 
-		if (atomic_dec_and_test(&vma->vm_usage)) {
-			delete_nommu_vma(vma);
+/*
+ * split a vma into two pieces at address 'addr', a new vma is allocated either
+ * for the first part or the tail.
+ */
+int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
+	      unsigned long addr, int new_below)
+{
+	struct vm_area_struct *new;
+	struct vm_region *region;
+	unsigned long npages;
 
-			if (vma->vm_ops && vma->vm_ops->close)
-				vma->vm_ops->close(vma);
+	_enter("");
 
-			/* IO memory and memory shared directly out of the pagecache from
-			 * ramfs/tmpfs mustn't be released here */
-			if (vma->vm_flags & VM_MAPPED_COPY) {
-				realalloc -= kobjsize((void *) vma->vm_start);
-				askedalloc -= vma->vm_end - vma->vm_start;
-				kfree((void *) vma->vm_start);
-			}
+	if (mm->map_count >= sysctl_max_map_count)
+		return -ENOMEM;
 
-			realalloc -= kobjsize(vma);
-			askedalloc -= sizeof(*vma);
+	region = kmalloc(sizeof(*region), GFP_KERNEL);
+	if (!region)
+		return -ENOMEM;
 
-			if (vma->vm_file)
-				fput(vma->vm_file);
-			kfree(vma);
-		}
+	new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	if (!new) {
+		kfree(region);
+		return -ENOMEM;
+	}
 
-		up_write(&nommu_vma_sem);
+	/* most fields are the same, copy all, and then fixup */
+	*new = *vma;
+	*region = *vma->vm_region;
+	new->vm_region = region;
+
+	npages = (addr - vma->vm_start) >> PAGE_SHIFT;
+
+	if (new_below) {
+		region->vm_end = new->vm_end = addr;
+	} else {
+		region->vm_start = new->vm_start = addr;
+		region->vm_pgoff = new->vm_pgoff += npages;
 	}
+
+	if (new->vm_file) {
+		get_file(new->vm_file);
+		get_file(region->vm_file);
+	}
+
+	if (new->vm_ops && new->vm_ops->open)
+		new->vm_ops->open(new);
+
+	delete_vma_from_mm(vma);
+	down_write(&nommu_region_sem);
+	delete_nommu_region(vma->vm_region);
+	if (new_below) {
+		vma->vm_region->vm_start = vma->vm_start = addr;
+		vma->vm_region->vm_pgoff = vma->vm_pgoff += npages;
+	} else {
+		vma->vm_region->vm_end = vma->vm_end = addr;
+	}
+	add_nommu_region(vma->vm_region);
+	add_nommu_region(new->vm_region);
+	up_write(&nommu_region_sem);
+	add_vma_to_mm(mm, vma);
+	add_vma_to_mm(mm, new);
+	return 0;
 }
 
 /*
- * release a mapping
- * - under NOMMU conditions the parameters must match exactly to the mapping to
- *   be removed
+ * shrink a VMA by removing the specified region from either the beginning or
+ * the end
  */
-int do_munmap(struct mm_struct *mm, unsigned long addr, size_t len)
+static int shrink_vma(struct vm_area_struct *vma,
+		      unsigned long from, unsigned long to)
 {
-	struct vm_list_struct *vml, **parent;
-	unsigned long end = addr + len;
+	struct vm_region *region;
 
-#ifdef DEBUG
-	printk("do_munmap:\n");
-#endif
+	_enter("");
 
-	for (parent = &mm->context.vmlist; *parent; parent = &(*parent)->next) {
-		if ((*parent)->vma->vm_start > addr)
-			break;
-		if ((*parent)->vma->vm_start == addr &&
-		    ((len == 0) || ((*parent)->vma->vm_end == end)))
-			goto found;
-	}
+	/* adjust the VMA's pointers, which may reposition it in the MM's tree
+	 * and list */
+	delete_vma_from_mm(vma);
+	if (from > vma->vm_start)
+		vma->vm_end = from;
+	else
+		vma->vm_start = to;
+	add_vma_to_mm(vma->vm_mm, vma);
 
-	printk("munmap of non-mmaped memory by process %d (%s): %p\n",
-	       current->pid, current->comm, (void *) addr);
-	return -EINVAL;
+	/* cut the region down to size */
+	region = vma->vm_region;
+	BUG_ON(atomic_read(&region->vm_usage) != 1);
 
- found:
-	vml = *parent;
+	down_write(&nommu_region_sem);
+	delete_nommu_region(region);
+	if (from > region->vm_start)
+		region->vm_end = from;
+	else
+		region->vm_start = to;
+	add_nommu_region(region);
+	up_write(&nommu_region_sem);
 
-	put_vma(vml->vma);
+	free_page_series(from, to);
+	return 0;
+}
 
-	*parent = vml->next;
-	realalloc -= kobjsize(vml);
-	askedalloc -= sizeof(*vml);
-	kfree(vml);
+/*
+ * release a mapping
+ * - under NOMMU conditions the region to be unmapped must be backed by a
+ *   single VMA, though it need not cover the whole VMA
+ */
+int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
+{
+	struct vm_area_struct *vma;
+	struct rb_node *rb;
+	unsigned long end = start + len;
+	int ret;
 
-	update_hiwater_vm(mm);
-	mm->total_vm -= len >> PAGE_SHIFT;
+	_enter(",%lx,%zx", start, len);
 
-#ifdef DEBUG
-	show_process_blocks();
-#endif
+	/* find the first potentially overlapping VMA */
+	vma = find_vma(mm, start);
+	if (!vma) {
+		_leave(" = -EINVAL [no]");
+		return -EINVAL;
+	}
 
+	/* we're allowed to split an anonymous VMA but not a file-backed one */
+	if (vma->vm_file) {
+		do {
+			if (start > vma->vm_start) {
+				_leave(" = -EINVAL [miss]");
+				return -EINVAL;
+			}
+			if (end == vma->vm_end)
+				goto erase_whole_vma;
+			rb = rb_next(&vma->vm_rb);
+			vma = rb_entry(rb, struct vm_area_struct, vm_rb);
+		} while (rb);
+		_leave(" = -EINVAL [split file]");
+		return -EINVAL;
+	} else {
+		/* the region must be a subset of the VMA found */
+		if (start == vma->vm_start && end == vma->vm_end)
+			goto erase_whole_vma;
+		if (start < vma->vm_start || end > vma->vm_end) {
+			_leave(" = -EINVAL [superset]");
+			return -EINVAL;
+		}
+		if (start != vma->vm_start && end != vma->vm_end) {
+			ret = split_vma(mm, vma, start, 1);
+			if (ret < 0) {
+				_leave(" = %d [split]", ret);
+				return ret;
+			}
+		}
+		return shrink_vma(vma, start, end);
+	}
+
+erase_whole_vma:
+	delete_vma_from_mm(vma);
+	put_vma(vma);
+	_leave(" = 0");
 	return 0;
 }
 EXPORT_SYMBOL(do_munmap);
@@ -1107,32 +1417,26 @@ asmlinkage long sys_munmap(unsigned long addr, size_t len)
 }
 
 /*
- * Release all mappings
+ * release all the mappings made in a process's VM space
  */
-void exit_mmap(struct mm_struct * mm)
+void exit_mmap(struct mm_struct *mm)
 {
-	struct vm_list_struct *tmp;
-
-	if (mm) {
-#ifdef DEBUG
-		printk("Exit_mmap:\n");
-#endif
+	struct vm_area_struct *vma;
 
-		mm->total_vm = 0;
+	if (!mm)
+		return;
 
-		while ((tmp = mm->context.vmlist)) {
-			mm->context.vmlist = tmp->next;
-			put_vma(tmp->vma);
+	_enter("");
 
-			realalloc -= kobjsize(tmp);
-			askedalloc -= sizeof(*tmp);
-			kfree(tmp);
-		}
+	mm->total_vm = 0;
 
-#ifdef DEBUG
-		show_process_blocks();
-#endif
+	while ((vma = mm->mmap)) {
+		mm->mmap = vma->vm_next;
+		delete_vma_from_mm(vma);
+		put_vma(vma);
 	}
+
+	_leave("");
 }
 
 unsigned long do_brk(unsigned long addr, unsigned long len)
@@ -1163,7 +1467,7 @@ unsigned long do_mremap(unsigned long addr,
 	if (flags & MREMAP_FIXED && new_addr != addr)
 		return (unsigned long) -EINVAL;
 
-	vma = find_vma_exact(current->mm, addr);
+	vma = find_vma_exact(current->mm, addr, old_len);
 	if (!vma)
 		return (unsigned long) -EINVAL;
 
@@ -1173,15 +1477,11 @@ unsigned long do_mremap(unsigned long addr,
 	if (vma->vm_flags & VM_MAYSHARE)
 		return (unsigned long) -EPERM;
 
-	if (new_len > kobjsize((void *) addr))
+	if (new_len > vma->vm_region->vm_end - vma->vm_region->vm_start)
 		return (unsigned long) -ENOMEM;
 
 	/* all checks complete - do it */
 	vma->vm_end = vma->vm_start + new_len;
-
-	askedalloc -= old_len;
-	askedalloc += new_len;
-
 	return vma->vm_start;
 }
 EXPORT_SYMBOL(do_mremap);

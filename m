Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbYE1QsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbYE1QsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYE1Qr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:47:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbYE1Qry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:47:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <483C3874.9010004@t-online.de>
References: <483C3874.9010004@t-online.de>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: dhowells@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Ungerer <gerg@snapgear.com>,
       David McCullough <davidm@snapgear.com>,
       Paul Mundt <lethal@linux-sh.org>, Matt Mackall <mpm@selenic.com>,
       "Wu, Bryan" <Bryan.Wu@analog.com>,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH, RFD] Unbreaking nommu mmap, v2
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 28 May 2008 17:47:14 +0100
Message-ID: <31103.1211993234@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schmidt <bernds_cb1@t-online.de> wrote:

> I'd like to submit this for inclusion.  Any acks or objections?

I'd like to counter with this patch.  This goes for proper VMAs and doesn't
make use of compound pages.  This makes things more similar to MMU-mode.

Note that this patch unconditionally trims allocations, whereas on yours this
is optional.  That can be easily remedied, if, in fact, the ability to request
untrimmed allocations is worth doing.

David
---
[PATCH] NOMMU: Make VMAs per MM as for MMU-mode linux

From: David Howells <dhowells@redhat.com>

Make VMAs per mm_struct as for MMU-mode linux.  This solves the nattch problem
for SYSV SHM where nattch for a segment does not reflect the number of shmat's
(and forks) done.

A new struct (vm_region) is introduced to track a mapped region and to remember
the circumstances under which it may be shared and the vm_list_struct structure
is discarded as it's no longer required.

This patch makes the following additional changes:

 (1) Regions are now allocated with alloc_pages() rather than kmalloc() and
     with no recourse to __GFP_COMP, so the pages are not composite.  Instead,
     each page has a reference on it held by the region.  Anything else that is
     interested in such a page will have to get a reference on it to retain it.
     When the pages are released due to unmapping, each page is passed to
     put_page() and will be freed when the page usage count reaches zero.

 (2) Excess pages are trimmed after an allocation as the allocation must be
     made as a power-of-2 quantity of pages.

 (3) VMAs are added to the parent MM's R/B tree and mmap lists.  As an MM may
     end up with overlapping VMAs within the tree, the VMA struct address is
     appended to the sort key.

 (4) Non-anonymous VMAs are now added to the backing inode's prio list.

 (5) Holes may be punched in anonymous VMAs with munmap(), releasing parts of
     the backing region.  The VMA and region structs will be split if
     necessary.

 (6) sys_shmdt() only releases one attachment to a SYSV IPC shared memory
     segment instead of all the attachments at that addresss.  Multiple
     shmat()'s return the same address under NOMMU-mode instead of different
     virtual addresses as under MMU-mode.

 (7) Core dumping for ELF-FDPIC requires fewer exceptions for NOMMU-mode.

 (8) /proc/maps is now the global list of mapped regions, and may list bits
     that aren't actually mapped anywhere.

 (9) /proc/meminfo gains a line (tagged "MmapCopy") that indicates the amount
     of RAM currently allocated by mmap to hold mappable regions that can't be
     mapped directly.  These are copies of the backing device or file if not
     anonymous.

(10) askedalloc and realalloc are removed.

These changes make NOMMU mode more similar to MMU mode.  The downside is that
NOMMU mode requires some extra memory to track things over NOMMU without this
patch (VMAs are no longer shared, and there are now region structs).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/ptrace.c |   11 -
 fs/binfmt_elf_fdpic.c    |   29 -
 fs/proc/internal.h       |    2 
 fs/proc/nommu.c          |   71 ++--
 fs/proc/proc_misc.c      |    6 
 fs/proc/task_nommu.c     |  111 ++++--
 include/asm-frv/mmu.h    |    1 
 include/linux/mm.h       |   18 -
 include/linux/mm_types.h |   19 +
 ipc/shm.c                |   12 +
 kernel/fork.c            |    4 
 mm/mmap.c                |   10 +
 mm/nommu.c               |  918 ++++++++++++++++++++++++++++++----------------
 13 files changed, 770 insertions(+), 442 deletions(-)


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
index 54a526e..27accf2 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -390,7 +390,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	}
 
 	/* expand the stack mapping to use up the entire allocation granule */
-	fullsize = kobjsize((char *) current->mm->start_brk);
+	fullsize = PAGE_ALIGN(current->mm->start_brk);
 	if (!IS_ERR_VALUE(do_mremap(current->mm->start_brk, stack_size,
 				    fullsize, 0, 0)))
 		stack_size = fullsize;
@@ -1535,11 +1535,9 @@ end_coredump:
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
 
@@ -1586,9 +1584,6 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
 	elf_fpxregset_t *xfpu = NULL;
 #endif
 	int thread_status_size = 0;
-#ifndef CONFIG_MMU
-	struct vm_list_struct *vml;
-#endif
 	elf_addr_t *auxv;
 	unsigned long mm_flags;
 
@@ -1655,13 +1650,7 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
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
@@ -1736,20 +1725,10 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
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
index 28cbca8..1ea897c 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -41,8 +41,6 @@ do {						\
 	(vmi)->used = 0;			\
 	(vmi)->largest_chunk = 0;		\
 } while(0)
-
-extern int nommu_vma_show(struct seq_file *, struct vm_area_struct *);
 #endif
 
 extern int maps_protect;
diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
index 79ecd28..9e32305 100644
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
 
-static const struct seq_operations proc_nommu_vma_list_seqop = {
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
-	proc_create("maps", S_IRUGO, NULL, &proc_nommu_vma_list_operations);
+	proc_create("maps", S_IRUGO, NULL, &proc_nommu_region_list_operations);
 	return 0;
 }
 
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 32dc14c..0579f0c 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -167,6 +167,9 @@ static int meminfo_read_proc(char *page, char **start, off_t off,
 		"LowTotal:     %8lu kB\n"
 		"LowFree:      %8lu kB\n"
 #endif
+#ifndef CONFIG_MMU
+		"MmapCopy:     %8lu kB\n"
+#endif
 		"SwapTotal:    %8lu kB\n"
 		"SwapFree:     %8lu kB\n"
 		"Dirty:        %8lu kB\n"
@@ -198,6 +201,9 @@ static int meminfo_read_proc(char *page, char **start, off_t off,
 		K(i.totalram-i.totalhigh),
 		K(i.freeram-i.freehigh),
 #endif
+#ifndef CONFIG_MMU
+		K((unsigned long) atomic_read(&mmap_pages_allocated)),
+#endif
 		K(i.totalswap),
 		K(i.freeswap),
 		K(global_page_state(NR_FILE_DIRTY)),
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 4b4f9cc..a28e61e 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -15,25 +15,25 @@
  */
 void task_mem(struct seq_file *m, struct mm_struct *mm)
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
 
@@ -70,13 +70,14 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
 
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
@@ -105,25 +105,66 @@ int task_statm(struct mm_struct *mm, int *shared, int *text,
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
+		seq_path(m, &file->f_path, "");
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
@@ -139,9 +180,9 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	}
 
 	/* start from the Nth VMA */
-	for (vml = mm->context.vmlist; vml; vml = vml->next)
+	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p))
 		if (n-- == 0)
-			return vml;
+			return p;
 	return NULL;
 }
 
@@ -157,12 +198,12 @@ static void m_stop(struct seq_file *m, void *_vml)
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
 
 static const struct seq_operations proc_pid_maps_ops = {
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
index c31a9cd..22a9f7d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -52,19 +52,9 @@ extern unsigned long mmap_min_addr;
 
 extern struct kmem_cache *vm_area_cachep;
 
-/*
- * This struct defines the per-mm list of VMAs for uClinux. If CONFIG_MMU is
- * disabled, then there's a single shared list of VMAs maintained by the
- * system, and mm's subscribe to these individually
- */
-struct vm_list_struct {
-	struct vm_list_struct	*next;
-	struct vm_area_struct	*vma;
-};
-
 #ifndef CONFIG_MMU
-extern struct rb_root nommu_vma_tree;
-extern struct rw_semaphore nommu_vma_sem;
+extern struct rb_root nommu_region_tree;
+extern struct rw_semaphore nommu_region_sem;
 
 extern unsigned int kobjsize(const void *objp);
 #endif
@@ -1020,6 +1010,7 @@ extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
 extern void setup_per_zone_pages_min(void);
 extern void mem_init(void);
+extern void __init mmap_init(void);
 extern void show_mem(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
@@ -1030,6 +1021,9 @@ extern void setup_per_cpu_pageset(void);
 static inline void setup_per_cpu_pageset(void) {}
 #endif
 
+/* nommu.c */
+extern atomic_t mmap_pages_allocated;
+
 /* prio_tree.c */
 void vma_prio_tree_add(struct vm_area_struct *, struct vm_area_struct *old);
 void vma_prio_tree_insert(struct vm_area_struct *, struct prio_tree_root *);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 02a27ae..ffdc476 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -97,6 +97,23 @@ struct page {
 };
 
 /*
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
+/*
  * This struct defines a memory VMM memory area. There is one of these
  * per VM-area/task.  A VM area is any part of the process virtual memory
  * space that has a special rule for the page-fault handlers (ie a shared
@@ -152,7 +169,7 @@ struct vm_area_struct {
 	unsigned long vm_truncate_count;/* truncate_count or restart_addr */
 
 #ifndef CONFIG_MMU
-	atomic_t vm_usage;		/* refcount (VMAs shared if !MMU) */
+	struct vm_region *vm_region;	/* NOMMU mapping region */
 #endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
diff --git a/ipc/shm.c b/ipc/shm.c
index 554429a..5cd7571 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -1008,6 +1008,7 @@ asmlinkage long sys_shmdt(char __user *shmaddr)
 	 */
 	vma = find_vma(mm, addr);
 
+#ifdef CONFIG_MMU
 	while (vma) {
 		next = vma->vm_next;
 
@@ -1052,6 +1053,17 @@ asmlinkage long sys_shmdt(char __user *shmaddr)
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
diff --git a/kernel/fork.c b/kernel/fork.c
index 19908b2..6e5fd4f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1426,12 +1426,10 @@ void __init proc_caches_init(void)
 	fs_cachep = kmem_cache_create("fs_cache",
 			sizeof(struct fs_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
-	vm_area_cachep = kmem_cache_create("vm_area_struct",
-			sizeof(struct vm_area_struct), 0,
-			SLAB_PANIC, NULL);
 	mm_cachep = kmem_cache_create("mm_struct",
 			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+	mmap_init();
 }
 
 /*
diff --git a/mm/mmap.c b/mm/mmap.c
index 669499e..7236e0d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2255,3 +2255,13 @@ int install_special_mapping(struct mm_struct *mm,
 
 	return 0;
 }
+
+/*
+ * initialise the VMA slab
+ */
+void __init mmap_init(void)
+{
+	vm_area_cachep = kmem_cache_create("vm_area_struct",
+			sizeof(struct vm_area_struct), 0,
+			SLAB_PANIC, NULL);
+}
diff --git a/mm/nommu.c b/mm/nommu.c
index f220e4a..c85b23d 100644
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
@@ -33,24 +33,48 @@
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
+#include "internal.h"
+
+static inline __attribute__((format(printf, 1, 2)))
+void no_printk(const char *fmt, ...)
+{
+}
+
+#if 0
+#define kenter(FMT, ...) \
+	printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
+#define kleave(FMT, ...) \
+	printk(KERN_DEBUG "<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
+#define kdebug(FMT, ...) \
+	printk(KERN_DEBUG "xxx" FMT"yyy\n", ##__VA_ARGS__)
+#else
+#define kenter(FMT, ...) \
+	no_printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
+#define kleave(FMT, ...) \
+	no_printk(KERN_DEBUG "<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
+#define kdebug(FMT, ...) \
+	no_printk(KERN_DEBUG FMT"\n", ##__VA_ARGS__)
+#endif
 
 void *high_memory;
 struct page *mem_map;
 unsigned long max_mapnr;
 unsigned long num_physpages;
-unsigned long askedalloc, realalloc;
 atomic_long_t vm_committed_space = ATOMIC_LONG_INIT(0);
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
 int heap_stack_gap = 0;
 
+atomic_t mmap_pages_allocated;
+
 EXPORT_SYMBOL(mem_map);
 EXPORT_SYMBOL(num_physpages);
 
-/* list of shareable VMAs */
-struct rb_root nommu_vma_tree = RB_ROOT;
-DECLARE_RWSEM(nommu_vma_sem);
+/* list of mapped, potentially shareable regions */
+static struct kmem_cache *vm_region_jar;
+struct rb_root nommu_region_tree = RB_ROOT;
+DECLARE_RWSEM(nommu_region_sem);
 
 struct vm_operations_struct generic_file_vm_ops = {
 };
@@ -128,7 +152,7 @@ unsigned int kobjsize(const void *objp)
 	BUG_ON(page->index < 0);
 	BUG_ON(page->index >= MAX_ORDER);
 
-	return (PAGE_SIZE << page->index);
+	return PAGE_SIZE << page->index;
 }
 
 /*
@@ -361,129 +385,128 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
 	return mm->brk = brk;
 }
 
-#ifdef DEBUG
-static void show_process_blocks(void)
-{
-	struct vm_list_struct *vml;
-
-	printk("Process blocks %d:", current->pid);
-
-	for (vml = &current->mm->context.vmlist; vml; vml = vml->next) {
-		printk(" %p: %p", vml, vml->vma);
-		if (vml->vma)
-			printk(" (%d @%lx #%d)",
-			       kobjsize((void *) vml->vma->vm_start),
-			       vml->vma->vm_start,
-			       atomic_read(&vml->vma->vm_usage));
-		printk(vml->next ? " ->" : ".\n");
-	}
-}
-#endif /* DEBUG */
-
 /*
- * add a VMA into a process's mm_struct in the appropriate place in the list
- * - should be called with mm->mmap_sem held writelocked
+ * initialise the VMA and region record slabs
  */
-static void add_vma_to_mm(struct mm_struct *mm, struct vm_list_struct *vml)
+void __init mmap_init(void)
 {
-	struct vm_list_struct **ppv;
-
-	for (ppv = &current->mm->context.vmlist; *ppv; ppv = &(*ppv)->next)
-		if ((*ppv)->vma->vm_start > vml->vma->vm_start)
-			break;
-
-	vml->next = *ppv;
-	*ppv = vml;
+	vm_region_jar = kmem_cache_create("vm_region_jar",
+					  sizeof(struct vm_region), 0,
+					  SLAB_PANIC, NULL);
+	vm_area_cachep = kmem_cache_create("vm_area_struct",
+					   sizeof(struct vm_area_struct), 0,
+					   SLAB_PANIC, NULL);
 }
 
 /*
- * look up the first VMA in which addr resides, NULL if none
- * - should be called with mm->mmap_sem at least held readlocked
+ * add a region into the global tree
  */
-struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
+static void add_nommu_region(struct vm_region *region)
 {
-	struct vm_list_struct *loop, *vml;
+	struct vm_region *pregion;
+	struct rb_node **p, *parent;
 
-	/* search the vm_start ordered list */
-	vml = NULL;
-	for (loop = mm->context.vmlist; loop; loop = loop->next) {
-		if (loop->vma->vm_start > addr)
-			break;
-		vml = loop;
+	parent = NULL;
+	p = &nommu_region_tree.rb_node;
+	while (*p) {
+		parent = *p;
+		pregion = rb_entry(parent, struct vm_region, vm_rb);
+		if (region->vm_start < pregion->vm_start)
+			p = &(*p)->rb_left;
+		else if (region->vm_start > pregion->vm_start)
+			p = &(*p)->rb_right;
+		else if (pregion == region)
+			return;
+		else
+			BUG();
 	}
 
-	if (vml && vml->vma->vm_end > addr)
-		return vml->vma;
-
-	return NULL;
+	rb_link_node(&region->vm_rb, parent, p);
+	rb_insert_color(&region->vm_rb, &nommu_region_tree);
 }
-EXPORT_SYMBOL(find_vma);
 
 /*
- * find a VMA
- * - we don't extend stack VMAs under NOMMU conditions
+ * delete a region from the global tree
  */
-struct vm_area_struct *find_extend_vma(struct mm_struct *mm, unsigned long addr)
+static void delete_nommu_region(struct vm_region *region)
 {
-	return find_vma(mm, addr);
-}
-
-int expand_stack(struct vm_area_struct *vma, unsigned long address)
-{
-	return -ENOMEM;
+	BUG_ON(!nommu_region_tree.rb_node);
+	rb_erase(&region->vm_rb, &nommu_region_tree);
 }
 
 /*
- * look up the first VMA exactly that exactly matches addr
- * - should be called with mm->mmap_sem at least held readlocked
+ * free a contiguous series of pages
  */
-static inline struct vm_area_struct *find_vma_exact(struct mm_struct *mm,
-						    unsigned long addr)
+static void free_page_series(unsigned long from, unsigned long to)
 {
-	struct vm_list_struct *vml;
-
-	/* search the vm_start ordered list */
-	for (vml = mm->context.vmlist; vml; vml = vml->next) {
-		if (vml->vma->vm_start == addr)
-			return vml->vma;
-		if (vml->vma->vm_start > addr)
-			break;
+	for (; from < to; from += PAGE_SIZE) {
+		struct page *page = virt_to_page(from);
+
+		kdebug("- free %lx", from);
+		atomic_dec(&mmap_pages_allocated);
+		if (page_count(page) != 1)
+			kdebug("free page %p [%d]", page, page_count(page));
+		put_page(page);
 	}
-
-	return NULL;
 }
 
 /*
- * find a VMA in the global tree
+ * release a reference to a region
+ * - the caller must hold the region semaphore, which this releases
  */
-static inline struct vm_area_struct *find_nommu_vma(unsigned long start)
+static void __put_nommu_region(struct vm_region *region)
+	__releases(nommu_region_sem)
 {
-	struct vm_area_struct *vma;
-	struct rb_node *n = nommu_vma_tree.rb_node;
+	kenter("%p{%d}", region, atomic_read(&region->vm_usage));
 
-	while (n) {
-		vma = rb_entry(n, struct vm_area_struct, vm_rb);
+	BUG_ON(!nommu_region_tree.rb_node);
 
-		if (start < vma->vm_start)
-			n = n->rb_left;
-		else if (start > vma->vm_start)
-			n = n->rb_right;
-		else
-			return vma;
+	if (atomic_dec_and_test(&region->vm_usage)) {
+		delete_nommu_region(region);
+		up_write(&nommu_region_sem);
+
+		if (region->vm_file)
+			fput(region->vm_file);
+
+		/* IO memory and memory shared directly out of the pagecache
+		 * from ramfs/tmpfs mustn't be released here */
+		if (region->vm_flags & VM_MAPPED_COPY) {
+			kdebug("free series");
+			free_page_series(region->vm_start, region->vm_end);
+		}
+		kmem_cache_free(vm_region_jar, region);
+	} else {
+		up_write(&nommu_region_sem);
 	}
+}
 
-	return NULL;
+/*
+ * release a reference to a region
+ */
+static void put_nommu_region(struct vm_region *region)
+{
+	down_write(&nommu_region_sem);
+	__put_nommu_region(region);
 }
 
 /*
- * add a VMA in the global tree
+ * add a VMA into a process's mm_struct in the appropriate place in the list
+ * and tree and add to the address space's page tree also if not an anonymous
+ * page
+ * - should be called with mm->mmap_sem held writelocked
  */
-static void add_nommu_vma(struct vm_area_struct *vma)
+static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	struct vm_area_struct *pvma;
+	struct vm_area_struct *pvma, **pp;
 	struct address_space *mapping;
-	struct rb_node **p = &nommu_vma_tree.rb_node;
-	struct rb_node *parent = NULL;
+	struct rb_node **p, *parent;
+
+	kenter(",%p", vma);
+
+	BUG_ON(!vma->vm_region);
+
+	mm->map_count++;
+	vma->vm_mm = mm;
 
 	/* add the VMA to the mapping */
 	if (vma->vm_file) {
@@ -494,42 +517,62 @@ static void add_nommu_vma(struct vm_area_struct *vma)
 		flush_dcache_mmap_unlock(mapping);
 	}
 
-	/* add the VMA to the master list */
+	/* add the VMA to the tree */
+	parent = NULL;
+	p = &mm->mm_rb.rb_node;
 	while (*p) {
 		parent = *p;
 		pvma = rb_entry(parent, struct vm_area_struct, vm_rb);
 
-		if (vma->vm_start < pvma->vm_start) {
+		/* sort by: start addr, end addr, VMA struct addr in that order
+		 * (the latter is necessary as we may get identical VMAs) */
+		if (vma->vm_start < pvma->vm_start)
 			p = &(*p)->rb_left;
-		}
-		else if (vma->vm_start > pvma->vm_start) {
+		else if (vma->vm_start > pvma->vm_start)
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
 	}
 
 	rb_link_node(&vma->vm_rb, parent, p);
-	rb_insert_color(&vma->vm_rb, &nommu_vma_tree);
+	rb_insert_color(&vma->vm_rb, &mm->mm_rb);
+
+	/* add VMA to the VMA list also */
+	for (pp = &mm->mmap; (pvma = *pp); pp = &(*pp)->vm_next) {
+		if (pvma->vm_start > vma->vm_start)
+			break;
+		if (pvma->vm_start < vma->vm_start)
+			continue;
+		if (pvma->vm_end < vma->vm_end)
+			break;
+	}
+
+	vma->vm_next = *pp;
+	*pp = vma;
 }
 
 /*
- * delete a VMA from the global list
+ * delete a VMA from its owning mm_struct and address space
  */
-static void delete_nommu_vma(struct vm_area_struct *vma)
+static void delete_vma_from_mm(struct vm_area_struct *vma)
 {
+	struct vm_area_struct **pp;
 	struct address_space *mapping;
+	struct mm_struct *mm = vma->vm_mm;
+
+	kenter("%p", vma);
+
+	mm->map_count--;
+	if (mm->mmap_cache == vma)
+		mm->mmap_cache = NULL;
 
 	/* remove the VMA from the mapping */
 	if (vma->vm_file) {
@@ -540,8 +583,115 @@ static void delete_nommu_vma(struct vm_area_struct *vma)
 		flush_dcache_mmap_unlock(mapping);
 	}
 
-	/* remove from the master list */
-	rb_erase(&vma->vm_rb, &nommu_vma_tree);
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
+}
+
+/*
+ * destroy a VMA record
+ */
+static void delete_vma(struct mm_struct *mm, struct vm_area_struct *vma)
+{
+	kenter("%p", vma);
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
+	if (vma->vm_file) {
+		fput(vma->vm_file);
+		if (vma->vm_flags & VM_EXECUTABLE)
+			removed_exe_file_vma(mm);
+	}
+	put_nommu_region(vma->vm_region);
+	kmem_cache_free(vm_area_cachep, vma);
+}
+
+/*
+ * look up the first VMA in which addr resides, NULL if none
+ * - should be called with mm->mmap_sem at least held readlocked
+ */
+struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
+{
+	struct vm_area_struct *vma;
+	struct rb_node *n = mm->mm_rb.rb_node;
+
+	/* check the cache first */
+	vma = mm->mmap_cache;
+	if (vma && vma->vm_start <= addr && vma->vm_end > addr)
+		return vma;
+
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
+
+	return NULL;
+}
+EXPORT_SYMBOL(find_vma);
+
+/*
+ * find a VMA
+ * - we don't extend stack VMAs under NOMMU conditions
+ */
+struct vm_area_struct *find_extend_vma(struct mm_struct *mm, unsigned long addr)
+{
+	return find_vma(mm, addr);
+}
+
+/*
+ * expand a stack to a given address
+ * - not supported under NOMMU conditions
+ */
+int expand_stack(struct vm_area_struct *vma, unsigned long address)
+{
+	return -ENOMEM;
+}
+
+/*
+ * look up the first VMA exactly that exactly matches addr
+ * - should be called with mm->mmap_sem at least held readlocked
+ */
+static struct vm_area_struct *find_vma_exact(struct mm_struct *mm,
+					     unsigned long addr,
+					     unsigned long len)
+{
+	struct vm_area_struct *vma;
+	struct rb_node *n = mm->mm_rb.rb_node;
+	unsigned long end = addr + len;
+
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
+	}
+
+	return NULL;
 }
 
 /*
@@ -755,9 +905,10 @@ static unsigned long determine_vm_flags(struct file *file,
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
 
@@ -775,10 +926,14 @@ static int do_mmap_shared_file(struct vm_area_struct *vma, unsigned long len)
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
@@ -797,23 +952,41 @@ static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
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
+	kdebug("alloc order %d for %lx", order, len);
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
+	atomic_add(total, &mmap_pages_allocated);
+
+	point = len >> PAGE_SHIFT;
+	while (point < total) {
+		order = ilog2(total - point);
+		kdebug("shave %u/%lu", 1 << order, total - point);
+		atomic_sub(1 << order, &mmap_pages_allocated);
+		__free_pages(pages + point, order);
+		point += 1 << order;
+	}
 
-#ifdef WARN_ON_SLACK
-	if (len + WARN_ON_SLACK <= kobjsize(result))
-		printk("Allocation of %lu bytes from process %d has %lu bytes of slack\n",
-		       len, current->pid, kobjsize(result) - len);
-#endif
+	total = len >> PAGE_SHIFT;
+	for (point = 1; point < total; point++)
+		set_page_refcounted(&pages[point]);
+
+	base = page_address(pages);
+	region->vm_start = vma->vm_start = (unsigned long) base;
+	region->vm_end   = vma->vm_end   = vma->vm_start + len;
+	region->vm_flags = vma->vm_flags |= VM_MAPPED_COPY;
 
 	if (vma->vm_file) {
 		/* read the contents of a file into the copy */
@@ -843,7 +1016,7 @@ static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
 	return 0;
 
 error_free:
-	kfree(base);
+	free_page_series(region->vm_start, region->vm_end);
 	vma->vm_start = 0;
 	return ret;
 
@@ -864,13 +1037,14 @@ unsigned long do_mmap_pgoff(struct file *file,
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
 
+	kenter(",%lx,%lx,%lx,%lx,%lx", addr, len, prot, flags, pgoff);
+
 	if (!(flags & MAP_FIXED))
 		addr = round_hint_to_min(addr);
 
@@ -878,73 +1052,120 @@ unsigned long do_mmap_pgoff(struct file *file,
 	 * mapping */
 	ret = validate_mmap_request(file, addr, len, prot, flags, pgoff,
 				    &capabilities);
-	if (ret < 0)
+	if (ret < 0) {
+		kleave(" = %d [val]", ret);
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
+	region = kmem_cache_zalloc(vm_region_jar, GFP_KERNEL);
+	if (!region)
+		goto error_getting_region;
+
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
+	if (!vma)
+		goto error_getting_vma;
+
+	atomic_set(&region->vm_usage, 1);
+	region->vm_flags = vm_flags;
+	region->vm_pgoff = pgoff;
 
-	down_write(&nommu_vma_sem);
+	INIT_LIST_HEAD(&vma->anon_vma_node);
+	vma->vm_flags = vm_flags;
+	vma->vm_pgoff = pgoff;
 
-	/* if we want to share, we need to check for VMAs created by other
+	if (file) {
+		region->vm_file = file;
+		get_file(file);
+		vma->vm_file = file;
+		get_file(file);
+		if (vm_flags & VM_EXECUTABLE) {
+			added_exe_file_vma(current->mm);
+			vma->vm_mm = current->mm;
+		}
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
+				kdebug("share copy");
+				vma->vm_flags |= VM_MAPPED_COPY;
+			} else {
+				kdebug("share mmap");
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
+			kmem_cache_free(vm_region_jar, region);
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
@@ -955,113 +1176,92 @@ unsigned long do_mmap_pgoff(struct file *file,
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
-	if (file) {
-		get_file(file);
-		if (vm_flags & VM_EXECUTABLE) {
-			added_exe_file_vma(current->mm);
-			vma->vm_mm = current->mm;
-		}
-	}
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
 
-#ifdef DEBUG
-	printk("do_mmap:\n");
-	show_process_blocks();
-#endif
+	kleave(" = %lx", result);
+	return result;
 
-	return (unsigned long) result;
-
- error:
-	up_write(&nommu_vma_sem);
-	kfree(vml);
+error_put_region:
+	__put_nommu_region(region);
 	if (vma) {
 		if (vma->vm_file) {
 			fput(vma->vm_file);
 			if (vma->vm_flags & VM_EXECUTABLE)
 				removed_exe_file_vma(vma->vm_mm);
 		}
-		kfree(vma);
+		kmem_cache_free(vm_area_cachep, vma);
 	}
+	kleave(" = %d [pr]", ret);
 	return ret;
 
- sharing_violation:
-	up_write(&nommu_vma_sem);
-	printk("Attempt to share mismatched mappings\n");
-	kfree(vml);
-	return -EINVAL;
+error_just_free:
+	up_write(&nommu_region_sem);
+error:
+	fput(region->vm_file);
+	kmem_cache_free(vm_region_jar, region);
+	fput(vma->vm_file);
+	if (vma->vm_flags & VM_EXECUTABLE)
+		removed_exe_file_vma(vma->vm_mm);
+	kmem_cache_free(vm_area_cachep, vma);
+	kleave(" = %d", ret);
+	return ret;
+
+sharing_violation:
+	up_write(&nommu_region_sem);
+	printk(KERN_WARNING "Attempt to share mismatched mappings\n");
+	ret = -EINVAL;
+	goto error;
 
- error_getting_vma:
-	up_write(&nommu_vma_sem);
-	kfree(vml);
-	printk("Allocation of vma for %lu byte allocation from process %d failed\n",
+error_getting_vma:
+	kmem_cache_free(vm_region_jar, region);
+	printk(KERN_WARNING "Allocation of vma for %lu byte allocation"
+	       " from process %d failed\n",
 	       len, current->pid);
 	show_free_areas();
 	return -ENOMEM;
 
- error_getting_vml:
-	printk("Allocation of vml for %lu byte allocation from process %d failed\n",
+error_getting_region:
+	printk(KERN_WARNING "Allocation of vm region for %lu byte allocation"
+	       " from process %d failed\n",
 	       len, current->pid);
 	show_free_areas();
 	return -ENOMEM;
@@ -1069,85 +1269,171 @@ unsigned long do_mmap_pgoff(struct file *file,
 EXPORT_SYMBOL(do_mmap_pgoff);
 
 /*
- * handle mapping disposal for uClinux
+ * split a vma into two pieces at address 'addr', a new vma is allocated either
+ * for the first part or the tail.
  */
-static void put_vma(struct mm_struct *mm, struct vm_area_struct *vma)
+int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
+	      unsigned long addr, int new_below)
 {
-	if (vma) {
-		down_write(&nommu_vma_sem);
+	struct vm_area_struct *new;
+	struct vm_region *region;
+	unsigned long npages;
 
-		if (atomic_dec_and_test(&vma->vm_usage)) {
-			delete_nommu_vma(vma);
+	kenter("");
 
-			if (vma->vm_ops && vma->vm_ops->close)
-				vma->vm_ops->close(vma);
+	/* we're only permitted to split anonymous regions that have a single
+	 * owner */
+	if (vma->vm_file ||
+	    atomic_read(&vma->vm_region->vm_usage) != 1)
+		return -ENOMEM;
 
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
+	region = kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
+	if (!region)
+		return -ENOMEM;
 
-			if (vma->vm_file) {
-				fput(vma->vm_file);
-				if (vma->vm_flags & VM_EXECUTABLE)
-					removed_exe_file_vma(mm);
-			}
-			kfree(vma);
-		}
+	new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	if (!new) {
+		kmem_cache_free(vm_region_jar, region);
+		return -ENOMEM;
+	}
+
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
+	}
 
-		up_write(&nommu_vma_sem);
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
 	}
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
+	kenter("");
 
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
 
-	put_vma(mm, vml->vma);
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
+	kenter(",%lx,%zx", start, len);
 
-#ifdef DEBUG
-	show_process_blocks();
-#endif
+	if (len == 0)
+		return -EINVAL;
+
+	/* find the first potentially overlapping VMA */
+	vma = find_vma(mm, start);
+	if (!vma) {
+		printk(KERN_WARNING
+		       "munmap of memory not mmapped by process %d (%s):"
+		       " 0x%lx-0x%lx\n",
+		       current->pid, current->comm, start, start + len - 1);
+		return -EINVAL;
+	}
 
+	/* we're allowed to split an anonymous VMA but not a file-backed one */
+	if (vma->vm_file) {
+		do {
+			if (start > vma->vm_start) {
+				kleave(" = -EINVAL [miss]");
+				return -EINVAL;
+			}
+			if (end == vma->vm_end)
+				goto erase_whole_vma;
+			rb = rb_next(&vma->vm_rb);
+			vma = rb_entry(rb, struct vm_area_struct, vm_rb);
+		} while (rb);
+		kleave(" = -EINVAL [split file]");
+		return -EINVAL;
+	} else {
+		/* the region must be a subset of the VMA found */
+		if (start == vma->vm_start && end == vma->vm_end)
+			goto erase_whole_vma;
+		if (start < vma->vm_start || end > vma->vm_end) {
+			kleave(" = -EINVAL [superset]");
+			return -EINVAL;
+		}
+		if (start != vma->vm_start && end != vma->vm_end) {
+			ret = split_vma(mm, vma, start, 1);
+			if (ret < 0) {
+				kleave(" = %d [split]", ret);
+				return ret;
+			}
+		}
+		return shrink_vma(vma, start, end);
+	}
+
+erase_whole_vma:
+	delete_vma_from_mm(vma);
+	delete_vma(mm, vma);
+	kleave(" = 0");
 	return 0;
 }
 EXPORT_SYMBOL(do_munmap);
@@ -1164,32 +1450,26 @@ asmlinkage long sys_munmap(unsigned long addr, size_t len)
 }
 
 /*
- * Release all mappings
+ * release all the mappings made in a process's VM space
  */
-void exit_mmap(struct mm_struct * mm)
+void exit_mmap(struct mm_struct *mm)
 {
-	struct vm_list_struct *tmp;
+	struct vm_area_struct *vma;
 
-	if (mm) {
-#ifdef DEBUG
-		printk("Exit_mmap:\n");
-#endif
+	if (!mm)
+		return;
 
-		mm->total_vm = 0;
+	kenter("");
 
-		while ((tmp = mm->context.vmlist)) {
-			mm->context.vmlist = tmp->next;
-			put_vma(mm, tmp->vma);
+	mm->total_vm = 0;
 
-			realalloc -= kobjsize(tmp);
-			askedalloc -= sizeof(*tmp);
-			kfree(tmp);
-		}
-
-#ifdef DEBUG
-		show_process_blocks();
-#endif
+	while ((vma = mm->mmap)) {
+		mm->mmap = vma->vm_next;
+		delete_vma_from_mm(vma);
+		delete_vma(mm, vma);
 	}
+
+	kleave("");
 }
 
 unsigned long do_brk(unsigned long addr, unsigned long len)
@@ -1202,8 +1482,8 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
  * time (controlled by the MREMAP_MAYMOVE flag and available VM space)
  *
  * under NOMMU conditions, we only permit changing a mapping's size, and only
- * as long as it stays within the hole allocated by the kmalloc() call in
- * do_mmap_pgoff() and the block is not shareable
+ * as long as it stays within the region allocated by do_mmap_private() and the
+ * block is not shareable
  *
  * MREMAP_FIXED is not supported under NOMMU conditions
  */
@@ -1214,13 +1494,16 @@ unsigned long do_mremap(unsigned long addr,
 	struct vm_area_struct *vma;
 
 	/* insanity checks first */
-	if (new_len == 0)
+	if (old_len == 0 || new_len == 0)
 		return (unsigned long) -EINVAL;
 
+	if (addr & ~PAGE_MASK)
+		return -EINVAL;
+
 	if (flags & MREMAP_FIXED && new_addr != addr)
 		return (unsigned long) -EINVAL;
 
-	vma = find_vma_exact(current->mm, addr);
+	vma = find_vma_exact(current->mm, addr, old_len);
 	if (!vma)
 		return (unsigned long) -EINVAL;
 
@@ -1230,22 +1513,19 @@ unsigned long do_mremap(unsigned long addr,
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
 
-asmlinkage unsigned long sys_mremap(unsigned long addr,
-	unsigned long old_len, unsigned long new_len,
-	unsigned long flags, unsigned long new_addr)
+asmlinkage
+unsigned long sys_mremap(unsigned long addr,
+			 unsigned long old_len, unsigned long new_len,
+			 unsigned long flags, unsigned long new_addr)
 {
 	unsigned long ret;
 

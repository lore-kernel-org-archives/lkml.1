Return-Path: <linux-kernel-owner+w=401wt.eu-S1765270AbZDJCda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765270AbZDJCda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbZDJCdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:33:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:37038 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763310AbZDJCdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QutIWS0k7k3MH0zN2z/lHf+B2VEp8DIeAPE+HKByPHhwZ1rd/rRMbGbAF3z4vb2Kz3
         5Se9ekZyyYBI2AoXS94qH9GTE0ADy9uKDZBDIfEZu5ztOk37vxxlB5AyRbwwYhJh5qNS
         h+wYm9HzK2A9yDBJt6CQWL86jjSZmx3Z903kg=
Date: Fri, 10 Apr 2009 06:33:12 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/30] Remove struct mm_struct::exe_file et al
Message-ID: <20090410023312.GC27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 925d1c401fa6cfd0df5d2e37da8981494ccdec07 aka "procfs task exe symlink".
introduced struct mm_struct::exe_file and struct
mm_struct::num_exe_file_vmas.

The rationale is weak: unifying MMU and no-MMU version of /proc/*/exe code.
For this a) struct mm_struct becomes bigger, b) mmap/munmap/exit become slower,
c) patch adds more code than removes in fact.

After commit 8feae13110d60cc6287afabc2887366b0eb226c2 aka
"NOMMU: Make VMAs per MM as for MMU-mode linux" no-MMU kernels also
maintain list of VMAs in ->mmap, so we can switch back for MMU version
of /proc/*/exe.

This also helps C/R, no need to save and restore ->exe_file and to count
additional references.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/exec.c                |    2 
 fs/proc/base.c           |  105 +++++++++++++----------------------------------
 include/linux/mm.h       |   12 -----
 include/linux/mm_types.h |    6 --
 include/linux/proc_fs.h  |   20 --------
 kernel/fork.c            |    3 -
 mm/mmap.c                |   22 +--------
 mm/nommu.c               |   16 -------
 8 files changed, 36 insertions(+), 150 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -966,8 +966,6 @@ int flush_old_exec(struct linux_binprm * bprm)
 	if (retval)
 		goto out;
 
-	set_mm_exe_file(bprm->mm, bprm->file);
-
 	/*
 	 * Release all of the old mmap stuff
 	 */
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -201,6 +201,36 @@ static int proc_root_link(struct inode *inode, struct path *path)
 	return result;
 }
 
+static int proc_exe_link(struct inode *inode, struct path *path)
+{
+	struct task_struct *tsk;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+
+	tsk = get_proc_task(inode);
+	if (!tsk)
+		return -ENOENT;
+	mm = get_task_mm(tsk);
+	put_task_struct(tsk);
+	if (!mm)
+		return -ENOENT;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file) {
+			*path = vma->vm_file->f_path;
+			path_get(&vma->vm_file->f_path);
+
+			up_read(&mm->mmap_sem);
+			mmput(mm);
+			return 0;
+		}
+	}
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+	return -ENOENT;
+}
+
 /*
  * Return zero if current may access user memory in @task, -error if not.
  */
@@ -1248,81 +1278,6 @@ static const struct file_operations proc_pid_sched_operations = {
 
 #endif
 
-/*
- * We added or removed a vma mapping the executable. The vmas are only mapped
- * during exec and are not mapped with the mmap system call.
- * Callers must hold down_write() on the mm's mmap_sem for these
- */
-void added_exe_file_vma(struct mm_struct *mm)
-{
-	mm->num_exe_file_vmas++;
-}
-
-void removed_exe_file_vma(struct mm_struct *mm)
-{
-	mm->num_exe_file_vmas--;
-	if ((mm->num_exe_file_vmas == 0) && mm->exe_file){
-		fput(mm->exe_file);
-		mm->exe_file = NULL;
-	}
-
-}
-
-void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file)
-{
-	if (new_exe_file)
-		get_file(new_exe_file);
-	if (mm->exe_file)
-		fput(mm->exe_file);
-	mm->exe_file = new_exe_file;
-	mm->num_exe_file_vmas = 0;
-}
-
-struct file *get_mm_exe_file(struct mm_struct *mm)
-{
-	struct file *exe_file;
-
-	/* We need mmap_sem to protect against races with removal of
-	 * VM_EXECUTABLE vmas */
-	down_read(&mm->mmap_sem);
-	exe_file = mm->exe_file;
-	if (exe_file)
-		get_file(exe_file);
-	up_read(&mm->mmap_sem);
-	return exe_file;
-}
-
-void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm)
-{
-	/* It's safe to write the exe_file pointer without exe_file_lock because
-	 * this is called during fork when the task is not yet in /proc */
-	newmm->exe_file = get_mm_exe_file(oldmm);
-}
-
-static int proc_exe_link(struct inode *inode, struct path *exe_path)
-{
-	struct task_struct *task;
-	struct mm_struct *mm;
-	struct file *exe_file;
-
-	task = get_proc_task(inode);
-	if (!task)
-		return -ENOENT;
-	mm = get_task_mm(task);
-	put_task_struct(task);
-	if (!mm)
-		return -ENOENT;
-	exe_file = get_mm_exe_file(mm);
-	mmput(mm);
-	if (exe_file) {
-		*exe_path = exe_file->f_path;
-		path_get(&exe_file->f_path);
-		fput(exe_file);
-		return 0;
-	} else
-		return -ENOENT;
-}
-
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1121,18 +1121,6 @@ extern void exit_mmap(struct mm_struct *);
 extern int mm_take_all_locks(struct mm_struct *mm);
 extern void mm_drop_all_locks(struct mm_struct *mm);
 
-#ifdef CONFIG_PROC_FS
-/* From fs/proc/base.c. callers must _not_ hold the mm's exe_file_lock */
-extern void added_exe_file_vma(struct mm_struct *mm);
-extern void removed_exe_file_vma(struct mm_struct *mm);
-#else
-static inline void added_exe_file_vma(struct mm_struct *mm)
-{}
-
-static inline void removed_exe_file_vma(struct mm_struct *mm)
-{}
-#endif /* CONFIG_PROC_FS */
-
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -269,12 +269,6 @@ struct mm_struct {
 	 */
 	struct task_struct *owner;
 #endif
-
-#ifdef CONFIG_PROC_FS
-	/* store ref to file /proc/<pid>/exe symlink points to */
-	struct file *exe_file;
-	unsigned long num_exe_file_vmas;
-#endif
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -188,12 +188,6 @@ extern void proc_net_remove(struct net *net, const char *name);
 extern struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
 	struct proc_dir_entry *parent);
 
-/* While the {get|set|dup}_mm_exe_file functions are for mm_structs, they are
- * only needed to implement /proc/<pid>|self/exe so we define them here. */
-extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
-extern struct file *get_mm_exe_file(struct mm_struct *mm);
-extern void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm);
-
 #else
 
 #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
@@ -240,20 +234,6 @@ static inline int pid_ns_prepare_proc(struct pid_namespace *ns)
 static inline void pid_ns_release_proc(struct pid_namespace *ns)
 {
 }
-
-static inline void set_mm_exe_file(struct mm_struct *mm,
-				   struct file *new_exe_file)
-{}
-
-static inline struct file *get_mm_exe_file(struct mm_struct *mm)
-{
-	return NULL;
-}
-
-static inline void dup_mm_exe_file(struct mm_struct *oldmm,
-	       			   struct mm_struct *newmm)
-{}
-
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -488,7 +488,6 @@ void mmput(struct mm_struct *mm)
 	if (atomic_dec_and_test(&mm->mm_users)) {
 		exit_aio(mm);
 		exit_mmap(mm);
-		set_mm_exe_file(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {
 			spin_lock(&mmlist_lock);
 			list_del(&mm->mmlist);
@@ -611,8 +610,6 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
 	if (init_new_context(tsk, mm))
 		goto fail_nocontext;
 
-	dup_mm_exe_file(oldmm, mm);
-
 	err = dup_mmap(mm, oldmm);
 	if (err)
 		goto free_pt;
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -236,11 +236,8 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
 	might_sleep();
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
-	if (vma->vm_file) {
+	if (vma->vm_file)
 		fput(vma->vm_file);
-		if (vma->vm_flags & VM_EXECUTABLE)
-			removed_exe_file_vma(vma->vm_mm);
-	}
 	mpol_put(vma_policy(vma));
 	kmem_cache_free(vm_area_cachep, vma);
 	return next;
@@ -637,11 +634,8 @@ again:			remove_next = 1 + (end > next->vm_end);
 		spin_unlock(&mapping->i_mmap_lock);
 
 	if (remove_next) {
-		if (file) {
+		if (file)
 			fput(file);
-			if (next->vm_flags & VM_EXECUTABLE)
-				removed_exe_file_vma(mm);
-		}
 		mm->map_count--;
 		mpol_put(vma_policy(next));
 		kmem_cache_free(vm_area_cachep, next);
@@ -1196,8 +1190,6 @@ munmap_back:
 		error = file->f_op->mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
-		if (vm_flags & VM_EXECUTABLE)
-			added_exe_file_vma(mm);
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
 		if (error)
@@ -1853,11 +1845,8 @@ int split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	}
 	vma_set_policy(new, pol);
 
-	if (new->vm_file) {
+	if (new->vm_file)
 		get_file(new->vm_file);
-		if (vma->vm_flags & VM_EXECUTABLE)
-			added_exe_file_vma(mm);
-	}
 
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
@@ -2204,11 +2193,8 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 			new_vma->vm_start = addr;
 			new_vma->vm_end = addr + len;
 			new_vma->vm_pgoff = pgoff;
-			if (new_vma->vm_file) {
+			if (new_vma->vm_file)
 				get_file(new_vma->vm_file);
-				if (vma->vm_flags & VM_EXECUTABLE)
-					added_exe_file_vma(mm);
-			}
 			if (new_vma->vm_ops && new_vma->vm_ops->open)
 				new_vma->vm_ops->open(new_vma);
 			vma_link(mm, new_vma, prev, rb_link, rb_parent);
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -719,11 +719,8 @@ static void delete_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 	kenter("%p", vma);
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
-	if (vma->vm_file) {
+	if (vma->vm_file)
 		fput(vma->vm_file);
-		if (vma->vm_flags & VM_EXECUTABLE)
-			removed_exe_file_vma(mm);
-	}
 	put_nommu_region(vma->vm_region);
 	kmem_cache_free(vm_area_cachep, vma);
 }
@@ -1216,10 +1213,6 @@ unsigned long do_mmap_pgoff(struct file *file,
 		get_file(file);
 		vma->vm_file = file;
 		get_file(file);
-		if (vm_flags & VM_EXECUTABLE) {
-			added_exe_file_vma(current->mm);
-			vma->vm_mm = current->mm;
-		}
 	}
 
 	down_write(&nommu_region_sem);
@@ -1357,11 +1350,8 @@ share:
 error_put_region:
 	__put_nommu_region(region);
 	if (vma) {
-		if (vma->vm_file) {
+		if (vma->vm_file)
 			fput(vma->vm_file);
-			if (vma->vm_flags & VM_EXECUTABLE)
-				removed_exe_file_vma(vma->vm_mm);
-		}
 		kmem_cache_free(vm_area_cachep, vma);
 	}
 	kleave(" = %d [pr]", ret);
@@ -1373,8 +1363,6 @@ error:
 	fput(region->vm_file);
 	kmem_cache_free(vm_region_jar, region);
 	fput(vma->vm_file);
-	if (vma->vm_flags & VM_EXECUTABLE)
-		removed_exe_file_vma(vma->vm_mm);
 	kmem_cache_free(vm_area_cachep, vma);
 	kleave(" = %d", ret);
 	return ret;

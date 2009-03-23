Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZCWNK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZCWNK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZCWNKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:10:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:57815 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbZCWNKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=icn5zfxo18hzCEPT5z3uSLMRk4ovxT/mS2zjaWxTrL/UhtUNvITADi9whSoyNyzVgE
         OrY1KVyvw+48ZuWltQjVRO2db0GQZ88y15vPAMkmkHTd1FlQT7tIJZFa+mrYCzDKIhk8
         Uf072H+ZYMzdl4XLBSk91CkrP8lFGMU6nHJ+A=
Date: Mon, 23 Mar 2009 16:17:26 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, matthltc@us.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove struct mm_struct::exe_file et al
Message-ID: <20090323131725.GA4089@x200.localdomain>
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

->exe_file maybe well defined, but doesn't make sense always. After original
executable is unmapped, /proc/*/exe will still report it and, more importantly,
pin corresponding struct file.

->num_exe_file_vmas is even worse -- it just counts number of executable
file-backed VMAs even if those VMAs aren't related to ->exe_file.

After commit 8feae13110d60cc6287afabc2887366b0eb226c2 aka
"NOMMU: Make VMAs per MM as for MMU-mode linux" no-MMU kernels also
maintain list of VMAs in ->mmap, so we can switch back for MMU version
of /proc/*/exe.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/binfmt_flat.c         |    3 -
 fs/exec.c                |    2 
 fs/proc/base.c           |  105 +++++++++++++----------------------------------
 include/linux/mm.h       |   12 -----
 include/linux/mm_types.h |    6 --
 include/linux/proc_fs.h  |   20 --------
 kernel/fork.c            |    3 -
 mm/mmap.c                |   22 +--------
 mm/nommu.c               |   16 -------
 9 files changed, 37 insertions(+), 152 deletions(-)

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -531,8 +531,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 		DBG_FLT("BINFMT_FLAT: ROM mapping of file (we hope)\n");
 
 		down_write(&current->mm->mmap_sem);
-		textpos = do_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC,
-				  MAP_PRIVATE|MAP_EXECUTABLE, 0);
+		textpos = do_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC, MAP_PRIVATE, 0);
 		up_write(&current->mm->mmap_sem);
 		if (!textpos  || textpos >= (unsigned long) -4096) {
 			if (!textpos)
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -958,8 +958,6 @@ int flush_old_exec(struct linux_binprm * bprm)
 	if (retval)
 		goto out;
 
-	set_mm_exe_file(bprm->mm, bprm->file);
-
 	/*
 	 * Release all of the old mmap stuff
 	 */
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -211,6 +211,36 @@ static int proc_root_link(struct inode *inode, struct path *path)
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
@@ -1265,81 +1295,6 @@ static const struct file_operations proc_pid_sched_operations = {
 
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
@@ -1118,18 +1118,6 @@ extern void exit_mmap(struct mm_struct *);
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
@@ -265,12 +265,6 @@ struct mm_struct {
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
@@ -192,12 +192,6 @@ extern void proc_net_remove(struct net *net, const char *name);
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
@@ -244,20 +238,6 @@ static inline int pid_ns_prepare_proc(struct pid_namespace *ns)
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
@@ -482,7 +482,6 @@ void mmput(struct mm_struct *mm)
 	if (atomic_dec_and_test(&mm->mm_users)) {
 		exit_aio(mm);
 		exit_mmap(mm);
-		set_mm_exe_file(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {
 			spin_lock(&mmlist_lock);
 			list_del(&mm->mmlist);
@@ -605,8 +604,6 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
 	if (init_new_context(tsk, mm))
 		goto fail_nocontext;
 
-	dup_mm_exe_file(oldmm, mm);
-
 	err = dup_mmap(mm, oldmm);
 	if (err)
 		goto free_pt;
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -235,11 +235,8 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
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
@@ -636,11 +633,8 @@ again:			remove_next = 1 + (end > next->vm_end);
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
@@ -1192,8 +1186,6 @@ munmap_back:
 		error = file->f_op->mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
-		if (vm_flags & VM_EXECUTABLE)
-			added_exe_file_vma(mm);
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
 		if (error)
@@ -1849,11 +1841,8 @@ int split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
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
@@ -2200,11 +2189,8 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
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
@@ -726,11 +726,8 @@ static void delete_vma(struct mm_struct *mm, struct vm_area_struct *vma)
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
@@ -1223,10 +1220,6 @@ unsigned long do_mmap_pgoff(struct file *file,
 		get_file(file);
 		vma->vm_file = file;
 		get_file(file);
-		if (vm_flags & VM_EXECUTABLE) {
-			added_exe_file_vma(current->mm);
-			vma->vm_mm = current->mm;
-		}
 	}
 
 	down_write(&nommu_region_sem);
@@ -1364,11 +1357,8 @@ share:
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
@@ -1380,8 +1370,6 @@ error:
 	fput(region->vm_file);
 	kmem_cache_free(vm_region_jar, region);
 	fput(vma->vm_file);
-	if (vma->vm_flags & VM_EXECUTABLE)
-		removed_exe_file_vma(vma->vm_mm);
 	kmem_cache_free(vm_area_cachep, vma);
 	kleave(" = %d", ret);
 	return ret;

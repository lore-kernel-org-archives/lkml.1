Return-Path: <linux-kernel-owner+w=401wt.eu-S1030276AbXBTQ6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030276AbXBTQ6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030288AbXBTQ6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:58:36 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52755 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030276AbXBTQ62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:58:28 -0500
Date: Tue, 20 Feb 2007 10:58:24 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Mimi Zohar <zohar@us.ibm.com>, Kylene Jo Hall <kjhall@us.ibm.com>,
       David Safford <safford@watson.ibm.com>
Subject: [PATCH] slim: move file revocation into file_table.c and mprotect.c
Message-ID: <20070220165824.GA31315@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a attempt at resolving some of the complaints against the
slim security module.  The file revocation is perceived as too intrusive
to live in a security module itself, so it is moved into file_table.c.

This patch retains the explicit file->f_mode tweaking to revoke
FMODE_WRITE.  That can be removed by using an approach like Pekka's
revokefs, using files in the revokefs filesystem with ->read() passed
through to the original file, but ->write() intercepted.

Comments greatly appreciated.

thanks,
-serge

From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH] slim: move file revocation into file_table.c and mprotect.c

Move the file revocation code out of slim.  This first verison is
very limited:

	1. if any aio is pending, we deny the action rather than
	   demote
	2. if there are any threads, then deny the action

We should be able to switch to only denying the action if there
are write aio's, and perhaps even to the target file.

Supporting threads will take more work:

	1. we need to be able to pull the other threads sharing
	   the mm_struct off the runqueue
	   (if any of the threads are currently running on a cpu,
	   we must return -EAGAIN)
	2. we need to check whether any of the threads are sleeping
	   in a write syscall
	3. need to check for pending aio in all the threads
	4. then do revocation for all the threads

Changelog:
	Feb 1: Incorporate bugfix comments from Mimi
	Feb 1: Fix sleep under spinlock problem - drop cur_tsec->lock
		around call to fd_revoke_write_iter.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
(cherry picked from f45727a9ba555802b6f85c198e5c77c3c210b1fc commit)

---

 fs/file_table.c          |   77 ++++++++++++
 include/linux/fs.h       |    2 
 include/linux/mm.h       |    2 
 include/linux/sched.h    |   11 ++
 mm/mprotect.c            |   49 +++++++
 security/slim/slm_main.c |  308 +++++++++++-----------------------------------
 6 files changed, 212 insertions(+), 237 deletions(-)

35132187f8ff3475b31f4789ecbaa2416ec29e82
diff --git a/fs/file_table.c b/fs/file_table.c
index 6e6632c..72d9416 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -265,6 +265,83 @@ void file_kill(struct file *file)
 	}
 }
 
+/*
+ * Called with both task_lock and files_lock held.
+ *
+ * if f_mode tweaking is not acceptable, we'll have to switch
+ * to making use of Pekka's revokefs.
+ */
+static void __fd_revoke_write_locked(struct file *file)
+{
+	file->f_mode &= ~FMODE_WRITE;
+	put_write_access(file->f_dentry->d_inode);
+}
+
+extern void mm_revoke_mmap_write(int(*need_revoke)(struct inode *, void *),
+							void *l);
+
+/*
+ * Currently, bail if there is >1 thread
+ * Later, the idea is to
+ *   for each thread
+ *     if on a cpu, bail and return -EAGAIN
+ *     else pull off runqueue
+ *     if in  write syscall, bail and return -EAGAIN
+ *   for each thread
+ *     revoke files if need_revoke()
+ *   for each thread
+ *     put back on runqueue
+ */
+int fd_revoke_write_iter(int(*need_revoke)(struct inode *, void *),
+		void *l)
+{
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+	unsigned long fd = 0;
+	struct file *file;
+	int num_revoked = 0;
+	int ret = 0;
+
+	if (!files)
+		return 0;
+
+	if (!thread_group_empty(current))
+		return -EAGAIN;
+
+	if (has_pending_aio_writes(current->active_mm))
+		return -EPERM;
+
+	/* here's where we would pull all threads off the runqueue */
+
+	/*
+	 * here's wehre we'd check for any thread sleeping during a
+	 * write syscall
+	 */
+
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+	while ((fd = find_next_bit(fdt->open_fds->fds_bits,
+				   fdt->max_fds, fd)) < fdt->max_fds) {
+		struct inode *inode;
+
+		file = fdt->fd[fd++];
+		if (!file)
+			continue;
+		if (!(file->f_mode & FMODE_WRITE))
+			continue;
+		if (!(inode = file->f_dentry->d_inode))
+			continue;
+		if (!need_revoke(inode, l))
+			continue;
+		__fd_revoke_write_locked(file);
+		num_revoked++;
+	}
+	spin_unlock(&files->file_lock);
+	mm_revoke_mmap_write(need_revoke, l);
+
+	return ret;
+}
+
 int fs_may_remount_ro(struct super_block *sb)
 {
 	struct list_head *p;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a0f97c6..c438388 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1597,6 +1597,8 @@ extern const struct file_operations read
 extern const struct file_operations write_fifo_fops;
 extern const struct file_operations rdwr_fifo_fops;
 
+extern int fd_revoke_write_iter(int(*need_revoke)(struct inode *, void *),
+		void *l);
 extern int fs_may_remount_ro(struct super_block *);
 
 #ifdef CONFIG_BLOCK
diff --git a/include/linux/mm.h b/include/linux/mm.h
index aa8a1ac..eb8f327 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -141,6 +141,8 @@ extern unsigned int kobjsize(const void 
 #define VM_EXEC		0x00000004
 #define VM_SHARED	0x00000008
 
+extern void mm_revoke_mmap_write(int(*need_revoke)(struct inode *, void *),
+							void *l);
 extern int do_mprotect(unsigned long start, size_t len, unsigned long prot);
 
 /* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f7d49bc..5896fb3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -381,6 +381,17 @@ struct mm_struct {
 	struct kioctx		*ioctx_list;
 };
 
+static inline int has_pending_aio_writes(struct mm_struct *mm)
+{
+	int ret = 0;
+	
+	read_lock(&mm->ioctx_list_lock);
+	if (mm->ioctx_list != NULL)
+		ret = 1;
+	read_unlock(&mm->ioctx_list_lock);
+	return 0;
+}
+
 struct sighand_struct {
 	atomic_t		count;
 	struct k_sigaction	action[_NSIG];
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 07f04fa..d1d182f 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -312,6 +312,55 @@ out:
 	return error;
 }
 
+static inline void do_revoke_mmap_write(struct vm_area_struct *mpnt)
+{
+	unsigned long start = mpnt->vm_start;
+	unsigned long end = mpnt->vm_end;
+	size_t len = end - start;
+
+	if (do_mprotect(start, len, PROT_READ) < 0)
+		printk(KERN_WARNING "%s: do_mprotect failed", __FUNCTION__);
+}
+
+/*
+ * Revoke write permission to underlying mmap file (MAP_SHARED)
+ */
+void mm_revoke_mmap_write(int(*need_revoke)(struct inode *, void *),
+							void *l)
+{
+	struct vm_area_struct *mpnt;
+
+	flush_cache_mm(current->mm);
+
+	down_write(&current->mm->mmap_sem);
+	for (mpnt = current->mm->mmap; mpnt; mpnt = mpnt->vm_next) {
+		struct file *file = mpnt->vm_file;
+		struct dentry *dentry;
+		struct inode *inode;
+
+		if (!file)
+			continue;
+
+		if (!(dentry = file->f_dentry))
+			continue;
+
+		if (!(inode = dentry->d_inode))
+			continue;
+
+		if (!(mpnt->vm_flags & (VM_WRITE | VM_MAYWRITE)))
+			continue;   
+
+    		if (!(mpnt->vm_flags & VM_SHARED))
+			continue;   
+
+		if (!need_revoke(inode, l))
+			continue;
+
+		do_revoke_mmap_write(mpnt);
+	}
+	up_write(&current->mm->mmap_sem);
+}
+
 asmlinkage long
 sys_mprotect(unsigned long start, size_t len, unsigned long prot)
 {
diff --git a/security/slim/slm_main.c b/security/slim/slm_main.c
index 3d60651..8a08022 100644
--- a/security/slim/slm_main.c
+++ b/security/slim/slm_main.c
@@ -107,123 +107,17 @@ static int is_isec_defined(struct slm_is
 	return 0;
 }
 
-/*
- * Called with current->files->file_lock. There is not a great lock to grab
- * for demotion of this type.  The only place f_mode is changed after install
- * is in mark_files_ro in the filesystem code.  That function is also changing
- * taking away write rights so even if we race the outcome is the same.
- */
-static inline int mark_has_file_wperm(struct file *file,
-					struct slm_file_xattr *cur_level)
+static int need_revoke(struct inode *inode, void *l)
 {
-	struct inode *inode;
+	struct slm_file_xattr *curl;
 	struct slm_isec_data *isec;
-	int rc = 0;
 
-	inode = file->f_dentry->d_inode;
-	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
+	if (!S_ISREG(inode->i_mode))
 		return 0;
-
+	curl = (struct slm_file_xattr *) l;
 	isec = inode->i_security;
-	spin_lock(&isec->lock);
-	if (is_lower_integrity(cur_level, &isec->level)) {
-		rc = 1;
-		if (file->f_dentry->d_name.name)
-			dprintk(SLM_BASE, "pid %d - has write perm "
-				"for %s\n", current->pid,
-				file->f_dentry->d_name.name);
-	}
-	spin_unlock(&isec->lock);
-	return rc;
-}
-
-/*
- * Determine if a file is opened with write permissions.
- */
-static int has_file_wperm(struct slm_file_xattr *cur_level)
-{
-	struct files_struct *files = current->files;
-	unsigned long fd = 0;
-	struct fdtable *fdt;
-	struct file *file;
-	int rc = 0;
-
-	if (is_kernel_thread(current))
-		return 0;
-
-	if (!files || !cur_level)
-		return 0;
-
-	spin_lock(&files->file_lock);
-	fdt = files_fdtable(files);
-
-	while ((fd = find_next_bit(fdt->open_fds->fds_bits,
-				   fdt->max_fds, fd)) < fdt->max_fds) {
-		file = fdt->fd[fd++];
-		if (file)
-			rc = mark_has_file_wperm(file, cur_level);
-	}
-
-	spin_unlock(&files->file_lock);
-	return rc;
-}
 
-static inline void do_revoke_mmap_wperm(struct vm_area_struct *mpnt,
-					struct slm_isec_data *isec,
-					struct slm_file_xattr *cur_level)
-{
-	unsigned long start = mpnt->vm_start;
-	unsigned long end = mpnt->vm_end;
-	size_t len = end - start;
- 	struct dentry *dentry = mpnt->vm_file->f_dentry;
-
-	if ((mpnt->vm_flags & (VM_WRITE | VM_MAYWRITE))
-	    && (mpnt->vm_flags & VM_SHARED)
-	    && (cur_level->iac_level < isec->level.iac_level)) {
-		dprintk(SLM_BASE,
-			"%s: pid %d - revoking write"
-			" perm for %s\n", __FUNCTION__,
-			current->pid, dentry->d_name.name);
-		if (do_mprotect(start, len, PROT_READ) < 0)
-			dprintk(SLM_BASE, "do_mprotect failed");
- 	}
-}
-
-/*
- * Revoke write permission to underlying mmap file (MAP_SHARED)
- */
-static void revoke_mmap_wperm(struct slm_file_xattr *cur_level)
-{
-	struct vm_area_struct *mpnt;
-	struct file *file;
-	struct dentry *dentry;
-	struct slm_isec_data *isec;
-
-	flush_cache_mm(current->mm);
-
-	down_write(&current->mm->mmap_sem);
-	for (mpnt = current->mm->mmap; mpnt; mpnt = mpnt->vm_next) {
-		file = mpnt->vm_file;
-		if (!file)
-			continue;
-
-		dentry = file->f_dentry;
-		if (!dentry || !dentry->d_inode)
-			continue;
-
-		isec = dentry->d_inode->i_security;
-		do_revoke_mmap_wperm(mpnt, isec, cur_level);
-	}
-	up_write(&current->mm->mmap_sem);
-}
-
-/*
- * revoke write permission for shared memory for demoted threads
- */
-static void revoke_permissions(struct slm_file_xattr *cur_level)
-{
-	if (!is_kernel_thread(current))
-		revoke_mmap_wperm(cur_level);
+	return is_lower_integrity(curl, &isec->level);
 }
 
 #define EXEMPT_STR "EXEMPT"
@@ -517,47 +411,30 @@ static int enforce_integrity_read(struct
 {
 	struct slm_tsec_data *cur_tsec = current->security;
 	int rc = 0;
+	int count = 0;
+
+	if (is_kernel_thread(current))
+		return rc;
 
+again:
 	spin_lock(&cur_tsec->lock);
 	if (!is_iac_less_than_or_exempt(level, cur_tsec->iac_r)) {
-		rc = has_file_wperm(level);
-		if (current->mm && atomic_read(&current->mm->mm_users) != 1)
-			rc = 1;
-		if (rc) {
-			dprintk(SLM_BASE, "ppid %d(%s p=%d-%s) "
-				" pid %d(%s p=%d-%s) can't revoke, not demoting\n",
-				parent_tsk->pid, parent_tsk->comm,
-				parent_tsec->iac_r,
-				(parent_tsec->iac_wx != parent_tsec->iac_r)
-				? "GUARD" : slm_iac_str[parent_tsec-> iac_r],
-				current->pid, current->comm,
-				cur_tsec->iac_r, (cur_tsec->iac_wx != cur_tsec->iac_r)
-				? "GUARD" : slm_iac_str[cur_tsec->iac_r]);
-			spin_unlock(&cur_tsec->lock);
-		} else {
-			/* Reading lower integrity, demote process */
-			dprintk(SLM_BASE, "ppid %d(%s p=%d-%s) "
-				" pid %d(%s p=%d-%s) demoting integrity to"
-				" iac=%d-%s(%s)\n",
-				parent_tsk->pid, parent_tsk->comm,
-				parent_tsec->iac_r,
-				(parent_tsec->iac_wx != parent_tsec->iac_r)
-				? "GUARD" : slm_iac_str[parent_tsec-> iac_r],
-				current->pid, current->comm,
-				cur_tsec->iac_r, (cur_tsec->iac_wx != cur_tsec->iac_r)
-				? "GUARD" : slm_iac_str[cur_tsec->iac_r],
-				level->iac_level, slm_iac_str[level->iac_level], name);
-
-			/* Even in the case of a integrity guard process. */
+		spin_unlock(&cur_tsec->lock);
+		rc = fd_revoke_write_iter(need_revoke, (void *)level);
+		spin_lock(&cur_tsec->lock);
+		if (rc == 0) {
 			cur_tsec->iac_r = level->iac_level;
 			cur_tsec->iac_wx = level->iac_level;
+		} else if (rc == -EAGAIN && count < 5) {
+			count++;
 			spin_unlock(&cur_tsec->lock);
-			revoke_permissions(level);
-		}
-		return rc ? -EACCES : 0;
+			schedule();
+			goto again;
+		} else
+			rc = -EPERM;
 	}
 	spin_unlock(&cur_tsec->lock);
-	return 0;
+	return rc;
 }
 
 static int do_task_may_read(struct slm_file_xattr *level,
@@ -1065,46 +942,40 @@ static int slm_inode_alloc_security(stru
  */
 static int slm_socket_create(int family, int type, int protocol, int kern)
 {
-	struct task_struct *parent_tsk;
-	struct slm_tsec_data *cur_tsec = current->security, *parent_tsec;
+	struct slm_tsec_data *cur_tsec = current->security;
 	struct slm_file_xattr level;
+	int count = 0;
 	int rc = 0;
 
+	if (is_kernel_thread(current))
+		return rc;
+
 	/* demoting all but UNIX and NETLINK sockets */
-	if ((family != AF_UNIX) && (family != AF_NETLINK)) {
-		spin_lock(&cur_tsec->lock);
-		if (cur_tsec->iac_r > SLM_IAC_UNTRUSTED) {
-			parent_tsk = current->parent;
-			parent_tsec = parent_tsk->security;
-			memset(&level, 0, sizeof(struct slm_file_xattr));
-			level.iac_level = SLM_IAC_UNTRUSTED;
-			rc = has_file_wperm(&level);
-			if (current->mm && atomic_read(&current->mm->mm_users) != 1)
-				rc = 1;
-			if (rc) {
-				dprintk(SLM_BASE,
-					"%s: ppid %d pid %d can't revoke, refusing socket\n",
-					__FUNCTION__, parent_tsk->pid, current->pid);
-				spin_unlock(&cur_tsec->lock);
-				return -EPERM;
-			} else {
-				dprintk(SLM_INTEGRITY,
-					"%s: ppid %d pid %d demoting "
-					"family %d type %d protocol %d kern %d"
-					" to untrusted.\n", __FUNCTION__,
-					parent_tsk->pid, current->pid, family,
-					type, protocol, kern);
-				cur_tsec->iac_r = SLM_IAC_UNTRUSTED;
-				cur_tsec->iac_wx = SLM_IAC_UNTRUSTED;
-				spin_unlock(&cur_tsec->lock);
+	if (family == AF_UNIX || family == AF_NETLINK)
+		return rc;
 
-				revoke_permissions(&level);
-				return 0;
-			}
-		}
+again:
+	spin_lock(&cur_tsec->lock);
+	if (cur_tsec->iac_r > SLM_IAC_UNTRUSTED) {
+		memset(&level, 0, sizeof(struct slm_file_xattr));
+		level.iac_level = SLM_IAC_UNTRUSTED;
 		spin_unlock(&cur_tsec->lock);
+		rc = fd_revoke_write_iter(need_revoke, (void *)&level);
+		spin_lock(&cur_tsec->lock);
+		if (rc == 0) {
+			cur_tsec->iac_r = SLM_IAC_UNTRUSTED;
+			cur_tsec->iac_wx = SLM_IAC_UNTRUSTED;
+		} else if (rc == -EAGAIN && count < 5) {
+			count++;
+			spin_unlock(&cur_tsec->lock);
+			schedule();
+			goto again;
+		} else
+			rc = -EPERM;
 	}
-	return 0;
+	spin_unlock(&cur_tsec->lock);
+
+	return rc;
 }
 
 /*
@@ -1260,74 +1131,37 @@ static int enforce_integrity_execute(str
 				      struct slm_file_xattr *level,
 				      struct slm_tsec_data *cur_tsec)
 {
-	struct task_struct *parent_tsk = current->parent;
-	struct slm_tsec_data *parent_tsec = parent_tsk->security;
 	int rc = 0;
+	int count = 0;
 
+	if (is_kernel_thread(current))
+		return rc;
+
+again:
 	spin_lock(&cur_tsec->lock);
 	if (is_iac_less_than_or_exempt(level, cur_tsec->iac_wx)) {
-		dprintk(SLM_INTEGRITY,
-			"%s: ppid %d(%s %d-%s) pid %d(%s %d-%s)"
-			" %s executing\n",
-			__FUNCTION__, parent_tsk->pid,
-			parent_tsk->comm,
-			(!parent_tsec) ? 0 : parent_tsec->iac_wx,
-			(parent_tsec->iac_wx != parent_tsec->iac_r)
-			? "GUARD" : slm_iac_str[parent_tsec->
-						iac_wx],
-			current->pid, current->comm,
-			cur_tsec->iac_wx,
-			(cur_tsec->iac_wx != cur_tsec->iac_r)
-			? "GUARD" : slm_iac_str[cur_tsec->iac_wx],
-			bprm->filename);
-
 		/* Being a guard process is not inherited */
 		cur_tsec->iac_r = cur_tsec->iac_wx;
-	} else {
-		rc = has_file_wperm(level);
-		if (current->mm && atomic_read(&current->mm->mm_users) != 1)
-			rc = 1;
-		if (rc) {
-			dprintk(SLM_BASE,
-				"%s: ppid %d(%s %d-%s) pid %d(%s %d-%s)"
-				" %s can't revoke, deny execution\n",
-				__FUNCTION__, parent_tsk->pid,
-				parent_tsk->comm, parent_tsec->iac_wx,
-				(parent_tsec->iac_wx != parent_tsec->iac_r)
-				? "GUARD" : slm_iac_str[parent_tsec->
-						iac_wx],
-				current->pid, current->comm,
-				cur_tsec->iac_wx,
-				(cur_tsec->iac_wx != cur_tsec->iac_r)
-				? "GUARD" : slm_iac_str[cur_tsec->iac_wx],
-				bprm->filename);
-			spin_unlock(&cur_tsec->lock);
-		} else {
-			dprintk(SLM_BASE,
-				"%s: ppid %d(%s %d-%s) pid %d(%s %d-%s)"
-				" %s executing, demoting integrity to "
-				" iac=%d-%s\n",
-				__FUNCTION__, parent_tsk->pid,
-				parent_tsk->comm, parent_tsec->iac_wx,
-				(parent_tsec->iac_wx != parent_tsec->iac_r)
-				? "GUARD" : slm_iac_str[parent_tsec->
-						iac_wx],
-				current->pid, current->comm,
-				cur_tsec->iac_wx,
-				(cur_tsec->iac_wx != cur_tsec->iac_r)
-				? "GUARD" : slm_iac_str[cur_tsec->iac_wx],
-				bprm->filename, level->iac_level,
-				slm_iac_str[level->iac_level]);
-
-			cur_tsec->iac_r = level->iac_level;
-			cur_tsec->iac_wx = level->iac_level;
-			spin_unlock(&cur_tsec->lock);
-			revoke_permissions(level);
-		}
-		return rc ? -EACCES : 0;
+		goto out;
 	}
+
 	spin_unlock(&cur_tsec->lock);
-	return 0;
+	rc = fd_revoke_write_iter(need_revoke, (void *)level);
+	spin_lock(&cur_tsec->lock);
+	if (rc == 0) {
+		cur_tsec->iac_r = level->iac_level;
+		cur_tsec->iac_wx = level->iac_level;
+	} else if (rc == -EAGAIN && count < 5) {
+		count++;
+		spin_unlock(&cur_tsec->lock);
+		schedule();
+		goto again;
+	} else
+		rc = -EPERM;
+
+out:
+	spin_unlock(&cur_tsec->lock);
+	return rc;
 }
 
 static void enforce_guard_integrity_execute(struct linux_binprm *bprm,
-- 
1.1.6

----- End forwarded message -----

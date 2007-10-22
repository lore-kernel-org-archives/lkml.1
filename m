Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbXJVHDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbXJVHDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbXJVHDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:03:38 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59677 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbXJVHDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:03:37 -0400
Date: Mon, 22 Oct 2007 12:33:29 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Blunck <jblunck@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH 12/13] Use struct path argument in proc_get_link()
Message-ID: <20071022070329.GM6489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022065352.GA6489@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the (vfsmnt, dentry) arguments in proc_inode operation proc_get_link()
by struct path.

Also, this should eventually allow do_proc_readlink() to call d_path() with
a struct path argument.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/proc/base.c          |   60 +++++++++++++++++++++---------------------------
 fs/proc/internal.h      |    2 -
 fs/proc/task_mmu.c      |    6 ++--
 fs/proc/task_nommu.c    |    6 ++--
 include/linux/proc_fs.h |    2 -
 5 files changed, 35 insertions(+), 41 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -153,7 +153,7 @@ static int get_nr_threads(struct task_st
 	return count;
 }
 
-static int proc_cwd_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+static int proc_cwd_link(struct inode *inode, struct path *path)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct fs_struct *fs = NULL;
@@ -165,8 +165,8 @@ static int proc_cwd_link(struct inode *i
 	}
 	if (fs) {
 		read_lock(&fs->lock);
-		*mnt = mntget(fs->pwd.mnt);
-		*dentry = dget(fs->pwd.dentry);
+		*path = fs->pwd;
+		path_get(path);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
@@ -174,7 +174,7 @@ static int proc_cwd_link(struct inode *i
 	return result;
 }
 
-static int proc_root_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+static int proc_root_link(struct inode *inode, struct path *path)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct fs_struct *fs = NULL;
@@ -186,8 +186,8 @@ static int proc_root_link(struct inode *
 	}
 	if (fs) {
 		read_lock(&fs->lock);
-		*mnt = mntget(fs->root.mnt);
-		*dentry = dget(fs->root.dentry);
+		*path = fs->root;
+		path_get(path);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
@@ -1039,34 +1039,32 @@ static void *proc_pid_follow_link(struct
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path.dentry,
-						&nd->path.mnt);
+	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path);
 	nd->last_type = LAST_BIND;
 out:
 	return ERR_PTR(error);
 }
 
-static int do_proc_readlink(struct dentry *dentry, struct vfsmount *mnt,
-			    char __user *buffer, int buflen)
+static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
 {
 	struct inode * inode;
 	char *tmp = (char*)__get_free_page(GFP_TEMPORARY);
-	char *path;
+	char *pathname;
 	int len;
 
 	if (!tmp)
 		return -ENOMEM;
 
-	inode = dentry->d_inode;
-	path = d_path(dentry, mnt, tmp, PAGE_SIZE);
-	len = PTR_ERR(path);
-	if (IS_ERR(path))
+	inode = path->dentry->d_inode;
+	pathname = d_path(path->dentry, path->mnt, tmp, PAGE_SIZE);
+	len = PTR_ERR(pathname);
+	if (IS_ERR(pathname))
 		goto out;
-	len = tmp + PAGE_SIZE - 1 - path;
+	len = tmp + PAGE_SIZE - 1 - pathname;
 
 	if (len > buflen)
 		len = buflen;
-	if (copy_to_user(buffer, path, len))
+	if (copy_to_user(buffer, pathname, len))
 		len = -EFAULT;
  out:
 	free_page((unsigned long)tmp);
@@ -1077,20 +1075,18 @@ static int proc_pid_readlink(struct dent
 {
 	int error = -EACCES;
 	struct inode *inode = dentry->d_inode;
-	struct dentry *de;
-	struct vfsmount *mnt = NULL;
+	struct path path;
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &de, &mnt);
+	error = PROC_I(inode)->op.proc_get_link(inode, &path);
 	if (error)
 		goto out;
 
-	error = do_proc_readlink(de, mnt, buffer, buflen);
-	dput(de);
-	mntput(mnt);
+	error = do_proc_readlink(&path, buffer, buflen);
+	path_put(&path);
 out:
 	return error;
 }
@@ -1317,8 +1313,7 @@ out:
 
 #define PROC_FDINFO_MAX 64
 
-static int proc_fd_info(struct inode *inode, struct dentry **dentry,
-			struct vfsmount **mnt, char *info)
+static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct files_struct *files = NULL;
@@ -1337,10 +1332,10 @@ static int proc_fd_info(struct inode *in
 		spin_lock(&files->file_lock);
 		file = fcheck_files(files, fd);
 		if (file) {
-			if (mnt)
-				*mnt = mntget(file->f_path.mnt);
-			if (dentry)
-				*dentry = dget(file->f_path.dentry);
+			if (path) {
+				*path = file->f_path;
+				path_get(path);
+			}
 			if (info)
 				snprintf(info, PROC_FDINFO_MAX,
 					 "pos:\t%lli\n"
@@ -1357,10 +1352,9 @@ static int proc_fd_info(struct inode *in
 	return -ENOENT;
 }
 
-static int proc_fd_link(struct inode *inode, struct dentry **dentry,
-			struct vfsmount **mnt)
+static int proc_fd_link(struct inode *inode, struct path *path)
 {
-	return proc_fd_info(inode, dentry, mnt, NULL);
+	return proc_fd_info(inode, path, NULL);
 }
 
 static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
@@ -1554,7 +1548,7 @@ static ssize_t proc_fdinfo_read(struct f
 				      size_t len, loff_t *ppos)
 {
 	char tmp[PROC_FDINFO_MAX];
-	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, NULL, tmp);
+	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, tmp);
 	if (!err)
 		err = simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
 	return err;
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -45,7 +45,7 @@ extern int nommu_vma_show(struct seq_fil
 extern int maps_protect;
 
 extern void create_seq_entry(char *name, mode_t mode, const struct file_operations *f);
-extern int proc_exe_link(struct inode *, struct dentry **, struct vfsmount **);
+extern int proc_exe_link(struct inode *, struct path *);
 extern int proc_tid_stat(struct task_struct *,  char *);
 extern int proc_tgid_stat(struct task_struct *, char *);
 extern int proc_pid_status(struct task_struct *, char *);
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -73,7 +73,7 @@ int task_statm(struct mm_struct *mm, int
 	return mm->total_vm;
 }
 
-int proc_exe_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+int proc_exe_link(struct inode *inode, struct path *path)
 {
 	struct vm_area_struct * vma;
 	int result = -ENOENT;
@@ -96,8 +96,8 @@ int proc_exe_link(struct inode *inode, s
 	}
 
 	if (vma) {
-		*mnt = mntget(vma->vm_file->f_path.mnt);
-		*dentry = dget(vma->vm_file->f_path.dentry);
+		*path = vma->vm_file->f_path;
+		path_get(path);
 		result = 0;
 	}
 
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -104,7 +104,7 @@ int task_statm(struct mm_struct *mm, int
 	return size;
 }
 
-int proc_exe_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+int proc_exe_link(struct inode *inode, struct path *path)
 {
 	struct vm_list_struct *vml;
 	struct vm_area_struct *vma;
@@ -127,8 +127,8 @@ int proc_exe_link(struct inode *inode, s
 	}
 
 	if (vma) {
-		*mnt = mntget(vma->vm_file->f_path.mnt);
-		*dentry = dget(vma->vm_file->f_path.dentry);
+		*path = vma->vm_file->f_path;
+		path_get(path);
 		result = 0;
 	}
 
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -257,7 +257,7 @@ extern void kclist_add(struct kcore_list
 #endif
 
 union proc_op {
-	int (*proc_get_link)(struct inode *, struct dentry **, struct vfsmount **);
+	int (*proc_get_link)(struct inode *, struct path *);
 	int (*proc_read)(struct task_struct *task, char *page);
 };
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbXIMT5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbXIMT5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbXIMT5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:57:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbXIMT50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:57:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: viro@ftp.linux.org.uk, hch@infradead.org
cc: dhowells@redhat.com, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Credentials test patch
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 13 Sep 2007 20:56:52 +0100
Message-ID: <1577.1189713412@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Al, Christoph,

Here's a patch that implements a very basic set of COW credentials.  It
compiles and links for x86_64 with EXT3, (V)FAT, NFS, AFS, SELinux and keyrings
all enabled.  Most other filesystems are disabled, apart from things like proc.
It is not intended to completely cover the kernel at this point.

Note that the keyrings cause a little bit of a problem as the thread, process
and session keyrings can all be installed on one task by another.  Furthermore,
the session keyring can be changed by another task.

Currently the cred struct shadows the actual keyring pointers, and current_cred
will update the extant cred pointer.  I don't like this because it won't work
if the cred struct is being overridden.  I can think of three ways of doing it:

 (1) Permit one process to change another process's cred struct.  This means
     that a process wishing to read its own creds must use RCU read to do so,
     and a lock must be held when replacing the cred struct.

 (2) Explicitly update the cred struct on entry to syscalls that might want to
     use it.

 (3) Count the number of stacked overrides, and suppress the update behaviour
     if it's more than zero.

Note that it might be possible to fill in the thread and process keyring
pointers on cred structs that have that pointer set to NULL.  However, this
doesn't help for the session keyring pointer.

David
---

CRED: Introduce a COW credentials record

From: David Howells <dhowells@redhat.com>

Introduce a copy on write credentials record (struct cred).  The fsuid, fsgid,
supplementary groups list and thread keyring move into it (DAC security).  The
session and process keyrings are reflected in it, but don't primarily reside
there as they aren't per-thread.

The LSM security information (MAC security) does *not* migrate from task_struct
at this point, but will be addressed by a later patch.

task_struct then gains an RCU-governed pointer to the credentials as a
replacement to the members it lost.

struct file gains a pointer to (f_cred) and a reference on the cred struct that
the opener was using at the time the file was opened.  This replaces f_uid and
f_gid.

To alter the credentials record, a copy must be made.  This copy may then be
altered and then the pointer in the task_struct redirected to it.  From that
point on the new record should be considered immutable.

In addition, the default setting of i_uid and i_gid to fsuid and fsgid has
been moved from the callers of new_inode() into new_inode() itself.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86_64/kernel/init_task.c   |    1 
 fs/anon_inodes.c                 |    2 
 fs/attr.c                        |    4 -
 fs/devpts/inode.c                |    6 +
 fs/dquot.c                       |    2 
 fs/exec.c                        |   29 +++++-
 fs/ext3/balloc.c                 |    2 
 fs/ext3/ialloc.c                 |    4 -
 fs/file_table.c                  |    3 -
 fs/inode.c                       |    6 +
 fs/locks.c                       |    2 
 fs/namei.c                       |    8 +-
 fs/nfs/inode.c                   |    2 
 fs/open.c                        |   15 ++-
 fs/pipe.c                        |    2 
 fs/posix_acl.c                   |    4 -
 fs/proc/array.c                  |   12 +--
 fs/ramfs/inode.c                 |    2 
 include/linux/binfmts.h          |    1 
 include/linux/cred.h             |  174 ++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h               |    5 +
 include/linux/init_task.h        |    6 +
 include/linux/sched.h            |    7 +-
 include/linux/sunrpc/auth.h      |   17 +---
 kernel/Makefile                  |    2 
 kernel/auditsc.c                 |   13 ++-
 kernel/cred.c                    |  154 ++++++++++++++++++++++++++++++++++
 kernel/exit.c                    |    1 
 kernel/fork.c                    |   62 ++++++++++++--
 kernel/sys.c                     |  145 +++++++++++++++++++++++---------
 kernel/uid16.c                   |    7 +-
 mm/shmem.c                       |    6 -
 net/socket.c                     |    2 
 net/sunrpc/auth.c                |   25 +----
 net/sunrpc/auth_gss/auth_gss.c   |    6 +
 net/sunrpc/auth_null.c           |    4 -
 net/sunrpc/auth_unix.c           |    6 +
 security/dummy.c                 |   13 ++-
 security/keys/key.c              |    2 
 security/keys/keyctl.c           |    2 
 security/keys/permission.c       |   16 ++-
 security/keys/process_keys.c     |   58 ++++---------
 security/keys/request_key.c      |   10 +-
 security/keys/request_key_auth.c |    2 
 44 files changed, 640 insertions(+), 212 deletions(-)

diff --git a/arch/x86_64/kernel/init_task.c b/arch/x86_64/kernel/init_task.c
index 4ff33d4..531432a 100644
--- a/arch/x86_64/kernel/init_task.c
+++ b/arch/x86_64/kernel/init_task.c
@@ -14,6 +14,7 @@ static struct fs_struct init_fs = INIT_FS;
 static struct files_struct init_files = INIT_FILES;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+struct cred init_cred = INIT_CRED;
 struct mm_struct init_mm = INIT_MM(init_mm);
 
 EXPORT_SYMBOL(init_mm);
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index b4a7588..921087b 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -163,8 +163,6 @@ static struct inode *anon_inode_mkinode(void)
 	 */
 	inode->i_state = I_DIRTY;
 	inode->i_mode = S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	return inode;
 }
diff --git a/fs/attr.c b/fs/attr.c
index f8dfc22..c4eea66 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -29,13 +29,13 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
 
 	/* Make sure a caller can chown. */
 	if ((ia_valid & ATTR_UID) &&
-	    (current->fsuid != inode->i_uid ||
+	    (current_fsuid != inode->i_uid ||
 	     attr->ia_uid != inode->i_uid) && !capable(CAP_CHOWN))
 		goto error;
 
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
-	    (current->fsuid != inode->i_uid ||
+	    (current_fsuid != inode->i_uid ||
 	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
 	    !capable(CAP_CHOWN))
 		goto error;
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 06ef9a2..af6bcff 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -172,8 +172,10 @@ int devpts_pty_new(struct tty_struct *tty)
 		return -ENOMEM;
 
 	inode->i_ino = number+2;
-	inode->i_uid = config.setuid ? config.uid : current->fsuid;
-	inode->i_gid = config.setgid ? config.gid : current->fsgid;
+	if (config.setuid)
+		inode->i_uid = config.uid;
+	if (config.setgid)
+		inode->i_gid = config.gid;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	init_special_inode(inode, S_IFCHR|config.mode, device);
 	inode->i_private = tty;
diff --git a/fs/dquot.c b/fs/dquot.c
index de9a29f..4969dfd 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -832,7 +832,7 @@ static inline int need_print_warning(struct dquot *dquot)
 
 	switch (dquot->dq_type) {
 		case USRQUOTA:
-			return current->fsuid == dquot->dq_id;
+			return current_fsuid == dquot->dq_id;
 		case GRPQUOTA:
 			return in_group_p(dquot->dq_id);
 	}
diff --git a/fs/exec.c b/fs/exec.c
index c21a8cc..e1d6f8e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1140,6 +1140,11 @@ int prepare_binprm(struct linux_binprm *bprm)
 		}
 	}
 
+	/* prepare the new credentials */
+	bprm->cred = dup_cred(current_cred);
+	if (!bprm->cred)
+		return -ENOMEM;
+
 	/* fill in binprm security blob */
 	retval = security_bprm_set(bprm);
 	if (retval)
@@ -1181,7 +1186,9 @@ void compute_creds(struct linux_binprm *bprm)
 	task_lock(current);
 	unsafe = unsafe_exec(current);
 	security_bprm_apply_creds(bprm, unsafe);
+	set_current_cred(bprm->cred);
 	task_unlock(current);
+	bprm->cred = NULL;
 	security_bprm_post_apply_creds(bprm);
 }
 EXPORT_SYMBOL(compute_creds);
@@ -1412,6 +1419,8 @@ out:
 	free_arg_pages(bprm);
 	if (bprm->security)
 		security_bprm_free(bprm);
+	if (bprm->cred)
+		put_cred(bprm->cred);
 
 out_mm:
 	if (bprm->mm)
@@ -1719,8 +1728,8 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	struct linux_binfmt * binfmt;
 	struct inode * inode;
 	struct file * file;
+	struct cred *cred;
 	int retval = 0;
-	int fsuid = current->fsuid;
 	int flag = 0;
 	int ispipe = 0;
 
@@ -1735,6 +1744,10 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 		goto fail;
 	}
 
+	cred = dup_cred(current_cred);
+	if (!cred)
+		goto fail;
+
 	/*
 	 *	We cannot trust fsuid as being the "true" uid of the
 	 *	process nor do we know its entire history. We only know it
@@ -1742,13 +1755,13 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 */
 	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
-		current->fsuid = 0;	/* Dump root private */
+		change_fsuid(cred, 0);	/* Dump root private */
 	}
 	set_dumpable(mm, 0);
 
 	retval = coredump_wait(exit_code);
 	if (retval < 0)
-		goto fail;
+		goto fail_cred;
 
 	/*
 	 * Clear any false indication of pending signals that might
@@ -1766,19 +1779,20 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
  	lock_kernel();
 	ispipe = format_corename(corename, core_pattern, signr);
 	unlock_kernel();
+	cred = __set_current_cred(cred);
  	if (ispipe) {
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
- 			goto fail_unlock;
+ 			goto fail_restore_cred;
  		}
  	} else
  		file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
 	if (IS_ERR(file))
-		goto fail_unlock;
+		goto fail_restore_cred;
 	inode = file->f_path.dentry->d_inode;
 	if (inode->i_nlink > 1)
 		goto close_fail;	/* multiple links - don't dump */
@@ -1802,9 +1816,12 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 		current->signal->group_exit_code |= 0x80;
 close_fail:
 	filp_close(file, NULL);
+fail_restore_cred:
+	set_current_cred(cred);
 fail_unlock:
-	current->fsuid = fsuid;
 	complete_all(&mm->core_done);
+fail_cred:
+	put_cred(cred);
 fail:
 	return retval;
 }
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index ca8aee6..98a36cc 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1360,7 +1360,7 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
+		sbi->s_resuid != current_fsuid &&
 		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
 		return 0;
 	}
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index e45dbd6..c10ec0c 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -546,15 +546,13 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 	sb->s_dirt = 1;
 
-	inode->i_uid = current->fsuid;
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-	} else
-		inode->i_gid = current->fsgid;
+	}
 	inode->i_mode = mode;
 
 	inode->i_ino = ino;
diff --git a/fs/file_table.c b/fs/file_table.c
index d17fd69..f4c772c 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -115,8 +115,7 @@ struct file *get_empty_filp(void)
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
-	f->f_uid = tsk->fsuid;
-	f->f_gid = tsk->fsgid;
+	f->f_cred = get_current_cred();
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
 	return f;
diff --git a/fs/inode.c b/fs/inode.c
index 29f5068..a8b8ae3 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -531,6 +531,10 @@ repeat:
  *	mapping_set_gfp_mask() must be called with suitable flags on the
  *	newly created inode's mapping
  *
+ *	The inode's user and group IDs are set to the current task's fsuid and
+ *	fsgid respectively as a default, but this should be overridden by the
+ *	caller as appropriate.
+ *
  */
 struct inode *new_inode(struct super_block *sb)
 {
@@ -553,6 +557,8 @@ struct inode *new_inode(struct super_block *sb)
 		inode->i_ino = ++last_ino;
 		inode->i_state = 0;
 		spin_unlock(&inode_lock);
+		inode->i_uid = current_fsuid;
+		inode->i_gid = current_fsgid;
 	}
 	return inode;
 }
diff --git a/fs/locks.c b/fs/locks.c
index c795eaa..429b9b8 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1341,7 +1341,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 	struct inode *inode = dentry->d_inode;
 	int error, rdlease_count = 0, wrlease_count = 0;
 
-	if ((current->fsuid != inode->i_uid) && !capable(CAP_LEASE))
+	if ((current_fsuid != inode->i_uid) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
diff --git a/fs/namei.c b/fs/namei.c
index a83160a..5c5e0e8 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -185,7 +185,7 @@ int generic_permission(struct inode *inode, int mask,
 {
 	umode_t			mode = inode->i_mode;
 
-	if (current->fsuid == inode->i_uid)
+	if (current_fsuid == inode->i_uid)
 		mode >>= 6;
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl) {
@@ -437,7 +437,7 @@ static int exec_permission_lite(struct inode *inode,
 	if (inode->i_op && inode->i_op->permission)
 		return -EAGAIN;
 
-	if (current->fsuid == inode->i_uid)
+	if (current_fsuid == inode->i_uid)
 		mode >>= 6;
 	else if (in_group_p(inode->i_gid))
 		mode >>= 3;
@@ -1406,9 +1406,9 @@ static inline int check_sticky(struct inode *dir, struct inode *inode)
 {
 	if (!(dir->i_mode & S_ISVTX))
 		return 0;
-	if (inode->i_uid == current->fsuid)
+	if (inode->i_uid == current_fsuid)
 		return 0;
-	if (dir->i_uid == current->fsuid)
+	if (dir->i_uid == current_fsuid)
 		return 0;
 	return !capable(CAP_FOWNER);
 }
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 71a49c3..c99f654 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -285,8 +285,6 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 			nfsi->change_attr = fattr->change_attr;
 		inode->i_size = nfs_size_to_loff_t(fattr->size);
 		inode->i_nlink = fattr->nlink;
-		inode->i_uid = fattr->uid;
-		inode->i_gid = fattr->gid;
 		if (fattr->valid & (NFS_ATTR_FATTR_V3 | NFS_ATTR_FATTR_V4)) {
 			/*
 			 * report the blocks in 512byte units
diff --git a/fs/open.c b/fs/open.c
index 1d9e5e9..da31832 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -421,19 +421,20 @@ out:
 asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 {
 	struct nameidata nd;
-	int old_fsuid, old_fsgid;
 	kernel_cap_t old_cap;
+	struct cred *cred;
 	int res;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
 
-	old_fsuid = current->fsuid;
-	old_fsgid = current->fsgid;
 	old_cap = current->cap_effective;
+	cred = dup_cred(current_cred);
+	if (!cred)
+		return -ENOMEM;
 
-	current->fsuid = current->uid;
-	current->fsgid = current->gid;
+	change_fsuid(cred, current->uid);
+	change_fsgid(cred, current->gid);
 
 	/*
 	 * Clear the capabilities if we switch to a non-root user
@@ -448,6 +449,7 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	else
 		current->cap_effective = current->cap_permitted;
 
+	cred = __set_current_cred(cred);
 	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
 	if (res)
 		goto out;
@@ -464,8 +466,7 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 out_path_release:
 	path_release(&nd);
 out:
-	current->fsuid = old_fsuid;
-	current->fsgid = old_fsgid;
+	set_current_cred(cred);
 	current->cap_effective = old_cap;
 
 	return res;
diff --git a/fs/pipe.c b/fs/pipe.c
index 6b3d91a..18bf2ce 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -939,8 +939,6 @@ static struct inode * get_pipe_inode(void)
 	 */
 	inode->i_state = I_DIRTY;
 	inode->i_mode = S_IFIFO | S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 
 	return inode;
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index aec931e..8a9dc50 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -217,11 +217,11 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
                 switch(pa->e_tag) {
                         case ACL_USER_OBJ:
 				/* (May have been checked already) */
-                                if (inode->i_uid == current->fsuid)
+                                if (inode->i_uid == current_fsuid)
                                         goto check_perm;
                                 break;
                         case ACL_USER:
-                                if (pa->e_id == current->fsuid)
+                                if (pa->e_id == current_fsuid)
                                         goto mask;
 				break;
                         case ACL_GROUP_OBJ:
diff --git a/fs/proc/array.c b/fs/proc/array.c
index ee4814d..dc2f83a 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -159,10 +159,12 @@ static inline const char *get_task_state(struct task_struct *tsk)
 static inline char *task_state(struct task_struct *p, char *buffer)
 {
 	struct group_info *group_info;
+	struct cred *cred;
 	int g;
 	struct fdtable *fdt = NULL;
 
 	rcu_read_lock();
+	cred = get_task_cred(p);
 	buffer += sprintf(buffer,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
@@ -175,8 +177,8 @@ static inline char *task_state(struct task_struct *p, char *buffer)
 		p->tgid, p->pid,
 		pid_alive(p) ? rcu_dereference(p->real_parent)->tgid : 0,
 		pid_alive(p) && p->ptrace ? rcu_dereference(p->parent)->pid : 0,
-		p->uid, p->euid, p->suid, p->fsuid,
-		p->gid, p->egid, p->sgid, p->fsgid);
+		p->uid, p->euid, p->suid, cred->uid,
+		p->gid, p->egid, p->sgid, cred->gid);
 
 	task_lock(p);
 	if (p->files)
@@ -186,14 +188,12 @@ static inline char *task_state(struct task_struct *p, char *buffer)
 		"Groups:\t",
 		fdt ? fdt->max_fds : 0);
 	rcu_read_unlock();
-
-	group_info = p->group_info;
-	get_group_info(group_info);
 	task_unlock(p);
 
+	group_info = cred->group_info;
 	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
 		buffer += sprintf(buffer, "%d ", GROUP_AT(group_info, g));
-	put_group_info(group_info);
+	put_cred(cred);
 
 	buffer += sprintf(buffer, "\n");
 	return buffer;
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index ef2b46d..8c92fe0 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -55,8 +55,6 @@ struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev)
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 91c8c07..f20f057 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -39,6 +39,7 @@ struct linux_binprm{
 	int e_uid, e_gid;
 	kernel_cap_t cap_inheritable, cap_permitted, cap_effective;
 	void *security;
+	struct cred *cred;
 	int argc, envc;
 	char * filename;	/* Name of binary as seen by procps */
 	char * interp;		/* Name of the binary really executed. Most
diff --git a/include/linux/cred.h b/include/linux/cred.h
new file mode 100644
index 0000000..18148bd
--- /dev/null
+++ b/include/linux/cred.h
@@ -0,0 +1,174 @@
+/* Credentials management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_CRED_H
+#define _LINUX_CRED_H
+
+#include <linux/rcupdate.h>
+
+#ifdef __KERNEL__
+
+/*
+ * credentials record
+ * - COW semantics apply
+ */
+struct cred {
+	atomic_t		usage;
+	uid_t			uid;		/* fsuid as was */
+	gid_t			gid;		/* fsgid as was */
+	struct rcu_head		exterminate;	/* cred destroyer */
+	struct group_info	*group_info;
+
+	/* caches for references to the three task keyrings
+	 * - note that key_ref_t isn't typedef'd at this point, hence the odd
+	 *   types
+	 */
+#ifdef CONFIG_KEYS
+	struct __key_reference_with_attributes *session_keyring;
+	struct __key_reference_with_attributes *process_keyring;
+	struct __key_reference_with_attributes *thread_keyring;
+#endif
+};
+
+extern struct cred init_cred;
+
+#ifndef CONFIG_KEYS
+#define __current_cred()	({ current->cred; })
+#else
+extern struct cred *__current_cred(void);
+#endif
+
+/**
+ * current_cred - Get a pointer to the current credentials record
+ *
+ * Get a pointer to the current credentials record, potentially updating it at
+ * the same time.
+ */
+#define current_cred		({ __current_cred(); })
+
+extern void put_cred(struct cred *);
+extern void change_fsuid(struct cred *, uid_t);
+extern void change_fsgid(struct cred *, gid_t);
+extern void change_group_info(struct cred *, struct group_info *);
+extern struct cred *dup_cred(const struct cred *);
+
+#define current_fsuid		(current_cred->uid)
+#define current_fsgid		(current_cred->uid)
+#define current_group_info	(current_cred->group_info)
+
+#define __task_fsuid(tsk)	(task_cred(tsk)->uid)
+#define __task_fsgid(tsk)	(task_cred(tsk)->gid)
+
+#define task_fsuid(tsk)				\
+({						\
+	uid_t ____x;				\
+	rcu_read_lock();			\
+	____x = __task_fsuid(tsk);		\
+	rcu_read_unlock();			\
+	____x;					\
+})
+
+#define task_fsgid(tsk)				\
+({						\
+	gid_t ____x;				\
+	rcu_read_lock();			\
+	____x = __task_fsgid(tsk);		\
+	rcu_read_unlock();			\
+	____x;					\
+})
+
+/**
+ * get_cred - Get an extra reference on a credentials record
+ * @cred: The credentials record to reference
+ *
+ * Get an extra reference on a credentials record.  This must be released by
+ * calling put_cred().
+ */
+static inline struct cred *get_cred(struct cred *cred)
+{
+	atomic_inc(&cred->usage);
+	return cred;
+}
+
+/**
+ * get_current_cred - Get an extra reference on the current's credentials record
+ *
+ * Get an extra reference on the credentials record attached to the current
+ * task.  This must be released by calling put_cred().
+ */
+#define get_current_cred() \
+	({ get_cred(current_cred); })
+
+/**
+ * task_cred - Access the credentials of another task
+ * @tsk: The task to access
+ *
+ * Get a pointer to the credentials record of the given task.  The caller must
+ * have done rcu_read_lock() first.  The credentials record is can only be
+ * accessed as long as the RCU readlock is held by the caller.  If the
+ * credentials are required for longer, then a reference should be obtained on
+ * the cred struct.
+ *
+ * This is not required for the a task to access its own credentials.  Tasks
+ * may not alter the credentials of other tasks.
+ */
+#define task_cred(tsk) \
+	({ rcu_dereference((tsk)->cred); })
+
+/**
+ * get_task_cred - Get an extra reference on a credentials record of a task
+ * @tsk: The task to look in
+ *
+ * Get an extra reference on a credentials record of the given task and return
+ * a pointer to it.  This must be released by calling put_cred().  The caller
+ * must have done rcu_read_lock() first.
+ */
+#define get_task_cred(tsk) \
+	({ get_cred(task_cred((tsk))); })
+
+/**
+ * __set_current_cred - Swap the current credentials on the current task
+ * @cred: The revised credentials
+ *
+ * Exchange the credential record of the current task for an updated one.  This
+ * transfers a reference on the passed credential to the current task_struct,
+ * so the caller may need to get an extra reference first.  The old credentials
+ * are returned and must be disposed of appropriately.
+ *
+ * Write-locking is achieved by the fact that a thread's credentials may only
+ * be changed by that thread itself, so no explicit locking is required.
+ */
+#define __set_current_cred(CRED)			\
+({							\
+	struct cred *___old = current->cred;		\
+	rcu_assign_pointer(current->cred, (CRED));	\
+	___old;						\
+})
+
+/**
+ * set_current_cred - Change the current credentials on the current task
+ * @cred: The revised credentials
+ *
+ * Exchange the credential record of the current task for an updated one.  This
+ * transfers a reference on the passed credential to the current task_struct,
+ * so the caller may need to get an extra reference first.  The old credentials
+ * are released.
+ *
+ * Write-locking is achieved by the fact that a thread's credentials may only
+ * be changed by that thread itself, so no explicit locking is required.
+ */
+#define set_current_cred(CRED)				\
+do {							\
+	put_cred(__set_current_cred(CRED));		\
+} while(0)
+
+#endif /* __KERNEL__ */
+#endif /* _LINUX_CRED_H */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 16421f6..15f10ad 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -285,6 +285,7 @@ extern int dir_notify_enable;
 #include <linux/mutex.h>
 #include <linux/sysctl.h>
 #include <linux/capability.h>
+#include <linux/cred.h>
 
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
@@ -736,7 +737,7 @@ struct file {
 	mode_t			f_mode;
 	loff_t			f_pos;
 	struct fown_struct	f_owner;
-	unsigned int		f_uid, f_gid;
+	struct cred		*f_cred;
 	struct file_ra_state	f_ra;
 
 	unsigned long		f_version;
@@ -999,7 +1000,7 @@ enum {
 #define has_fs_excl() atomic_read(&current->fs_excl)
 
 #define is_owner_or_cap(inode)	\
-	((current->fsuid == (inode)->i_uid) || capable(CAP_FOWNER))
+	((current_fsuid == (inode)->i_uid) || capable(CAP_FOWNER))
 
 /* not quite ready to be deprecated, but... */
 extern void lock_super(struct super_block *);
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index cab741c..92cf1d1 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -89,7 +89,9 @@ extern struct nsproxy init_nsproxy;
 	.signalfd_list	= LIST_HEAD_INIT(sighand.signalfd_list),	\
 }
 
-extern struct group_info init_groups;
+#define INIT_CRED {				\
+	.usage		= ATOMIC_INIT(2),	\
+}
 
 #define INIT_STRUCT_PID {						\
 	.count 		= ATOMIC_INIT(1),				\
@@ -142,7 +144,7 @@ extern struct group_info init_groups;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	.group_info	= &init_groups,					\
+	.cred		= &init_cred,					\
 	.cap_effective	= CAP_INIT_EFF_SET,				\
 	.cap_inheritable = CAP_INIT_INH_SET,				\
 	.cap_permitted	= CAP_FULL_SET,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f4e324e..ea85955 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -79,6 +79,7 @@ struct sched_param {
 #include <linux/rcupdate.h>
 #include <linux/futex.h>
 #include <linux/rtmutex.h>
+#include <linux/cred.h>
 
 #include <linux/time.h>
 #include <linux/param.h>
@@ -1033,9 +1034,9 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	uid_t uid,euid,suid,fsuid;
-	gid_t gid,egid,sgid,fsgid;
-	struct group_info *group_info;
+	struct cred *cred;
+	uid_t uid,euid,suid;
+	gid_t gid,egid,sgid;
 	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted;
 	unsigned keep_capabilities:1;
 	struct user_struct *user;
diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
index 7a69ca3..c06891d 100644
--- a/include/linux/sunrpc/auth.h
+++ b/include/linux/sunrpc/auth.h
@@ -21,13 +21,6 @@
 /* size of the nodename buffer */
 #define UNX_MAXNODENAME	32
 
-/* Work around the lack of a VFS credential */
-struct auth_cred {
-	uid_t	uid;
-	gid_t	gid;
-	struct group_info *group_info;
-};
-
 /*
  * Client user credentials
  */
@@ -103,8 +96,8 @@ struct rpc_authops {
 	struct rpc_auth *	(*create)(struct rpc_clnt *, rpc_authflavor_t);
 	void			(*destroy)(struct rpc_auth *);
 
-	struct rpc_cred *	(*lookup_cred)(struct rpc_auth *, struct auth_cred *, int);
-	struct rpc_cred *	(*crcreate)(struct rpc_auth*, struct auth_cred *, int);
+	struct rpc_cred *	(*lookup_cred)(struct rpc_auth *, struct cred *, int);
+	struct rpc_cred *	(*crcreate)(struct rpc_auth*, struct cred *, int);
 };
 
 struct rpc_credops {
@@ -112,7 +105,7 @@ struct rpc_credops {
 	int			(*cr_init)(struct rpc_auth *, struct rpc_cred *);
 	void			(*crdestroy)(struct rpc_cred *);
 
-	int			(*crmatch)(struct auth_cred *, struct rpc_cred *, int);
+	int			(*crmatch)(struct cred *, struct rpc_cred *, int);
 	__be32 *		(*crmarshal)(struct rpc_task *, __be32 *);
 	int			(*crrefresh)(struct rpc_task *);
 	__be32 *		(*crvalidate)(struct rpc_task *, __be32 *);
@@ -133,8 +126,8 @@ int			rpcauth_register(const struct rpc_authops *);
 int			rpcauth_unregister(const struct rpc_authops *);
 struct rpc_auth *	rpcauth_create(rpc_authflavor_t, struct rpc_clnt *);
 void			rpcauth_release(struct rpc_auth *);
-struct rpc_cred *	rpcauth_lookup_credcache(struct rpc_auth *, struct auth_cred *, int);
-void			rpcauth_init_cred(struct rpc_cred *, const struct auth_cred *, struct rpc_auth *, const struct rpc_credops *);
+struct rpc_cred *	rpcauth_lookup_credcache(struct rpc_auth *, struct cred *, int);
+void			rpcauth_init_cred(struct rpc_cred *, const struct cred *, struct rpc_auth *, const struct rpc_credops *);
 struct rpc_cred *	rpcauth_lookupcred(struct rpc_auth *, int);
 struct rpc_cred *	rpcauth_bindcred(struct rpc_task *);
 void			rpcauth_holdcred(struct rpc_task *);
diff --git a/kernel/Makefile b/kernel/Makefile
index 2a99983..1f1f17b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o \
-	    utsname.o
+	    utsname.o cred.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 04f3ffb..282e041 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -303,7 +303,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 			result = audit_comparator(tsk->suid, f->op, f->val);
 			break;
 		case AUDIT_FSUID:
-			result = audit_comparator(tsk->fsuid, f->op, f->val);
+			result = audit_comparator(task_fsuid(tsk), f->op,
+						  f->val);
 			break;
 		case AUDIT_GID:
 			result = audit_comparator(tsk->gid, f->op, f->val);
@@ -315,7 +316,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 			result = audit_comparator(tsk->sgid, f->op, f->val);
 			break;
 		case AUDIT_FSGID:
-			result = audit_comparator(tsk->fsgid, f->op, f->val);
+			result = audit_comparator(task_fsgid(tsk), f->op,
+						  f->val);
 			break;
 		case AUDIT_PERS:
 			result = audit_comparator(tsk->personality, f->op, f->val);
@@ -885,12 +887,15 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	context->gid = tsk->gid;
 	context->euid = tsk->euid;
 	context->suid = tsk->suid;
-	context->fsuid = tsk->fsuid;
 	context->egid = tsk->egid;
 	context->sgid = tsk->sgid;
-	context->fsgid = tsk->fsgid;
 	context->personality = tsk->personality;
 
+	rcu_read_lock();
+	context->fsuid = __task_fsuid(tsk);
+	context->fsgid = __task_fsgid(tsk);
+	rcu_read_unlock();
+
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_SYSCALL);
 	if (!ab)
 		return;		/* audit_panic has been called */
diff --git a/kernel/cred.c b/kernel/cred.c
new file mode 100644
index 0000000..18b2f48
--- /dev/null
+++ b/kernel/cred.c
@@ -0,0 +1,154 @@
+/* Credential caching/management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/security.h>
+#include <linux/key.h>
+
+/**
+ * __current_cred - Bring the current creds up to date and return a pointer
+ *
+ * Bring the current credentials up to date with respect to the keyrings they
+ * shadow and return a pointer to them.  The process and session level may get
+ * changed by sibling threads with the same process, but the change can't be
+ * applied back to this thread's cred struct except by this thread itself.
+ */
+struct cred *__current_cred(void)
+{
+	struct signal_struct *sig = current->signal;
+	struct cred *cred = current->cred;
+	struct key *keyring;
+
+	if (
+#ifdef CONFIG_KEYS
+		key_ref_to_ptr(cred->session_keyring) != sig->session_keyring ||
+		key_ref_to_ptr(cred->process_keyring) != sig->process_keyring ||
+		key_ref_to_ptr(cred->thread_keyring) != current->thread_keyring ||
+#endif
+		false
+	    ) {
+		cred = kmalloc(sizeof(struct cred), GFP_KERNEL);
+		if (!cred)
+			/* can't update - use the old creds */
+			return current->cred;
+
+		*cred = *current->cred;
+		atomic_set(&cred->usage, 1);
+		get_group_info(cred->group_info);
+
+#ifdef CONFIG_KEYS
+		rcu_read_lock();
+		keyring = key_get(rcu_dereference(sig->session_keyring));
+		rcu_read_unlock();
+		if (!keyring)
+			keyring = key_get(current->user->session_keyring);
+			cred->session_keyring = make_key_ref(keyring, 1);
+
+		keyring = key_get(sig->process_keyring);
+		if (keyring)
+			cred->process_keyring = make_key_ref(keyring, 1);
+		else
+			cred->process_keyring = NULL;
+
+		cred->thread_keyring = NULL;
+#endif
+
+		set_current_cred(cred);
+	}
+	return cred;
+}
+
+EXPORT_SYMBOL(__current_cred);
+
+/**
+ * dup_cred - Duplicate a credentials structure
+ * @pcred: The credentials record to duplicate
+ *
+ * Duplicate and return a credentials structure so that the copy can be
+ * modified.  NULL is returned if there is insufficient memory to make the
+ * copy.
+ */
+struct cred *dup_cred(const struct cred *pcred)
+{
+	struct cred *cred;
+
+	cred = kmalloc(sizeof(struct cred), GFP_KERNEL);
+	if (likely(cred)) {
+		*cred = *pcred;
+		atomic_set(&cred->usage, 1);
+		get_group_info(cred->group_info);
+		key_get(key_ref_to_ptr(cred->session_keyring));
+		key_get(key_ref_to_ptr(cred->process_keyring));
+		key_get(key_ref_to_ptr(cred->thread_keyring));
+	}
+	return cred;
+}
+
+EXPORT_SYMBOL(dup_cred);
+
+/*
+ * RCU-based credentials destroyer
+ */
+static void put_cred_rcu(struct rcu_head *rcu)
+{
+	struct cred *cred = container_of(rcu, struct cred, exterminate);
+
+	put_group_info(cred->group_info);
+	key_ref_put(cred->session_keyring);
+	key_ref_put(cred->process_keyring);
+	key_ref_put(cred->thread_keyring);
+	kfree(cred);
+}
+
+/**
+ * put_cred - Release a reference to a credentials record
+ * cred: The credentials record to release
+ *
+ * Release a reference to a credentials record.  When the last reference is
+ * released, the record will be deleted with due care for RCU accesses still
+ * ongoing.
+ */
+void put_cred(struct cred *cred)
+{
+	if (atomic_dec_and_test(&cred->usage))
+		call_rcu(&cred->exterminate, put_cred_rcu);
+}
+
+EXPORT_SYMBOL(put_cred);
+
+/*
+ * change the VFS applicable UID in a new credential record
+ */
+void change_fsuid(struct cred *cred, uid_t uid)
+{
+	cred->uid = uid;
+}
+
+/*
+ * change the VFS applicable GID in a new credential record
+ */
+void change_fsgid(struct cred *cred, gid_t gid)
+{
+	cred->gid = gid;
+}
+
+/*
+ * change the groups list in a new credential record
+ */
+void change_group_info(struct cred *cred, struct group_info *group_info)
+{
+	struct group_info *old = cred->group_info;
+
+	get_group_info(group_info);
+	cred->group_info = group_info;
+	put_group_info(old);
+}
diff --git a/kernel/exit.c b/kernel/exit.c
index 06b24b3..d1aa7fb 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -297,6 +297,7 @@ static void reparent_to_kthreadd(void)
 	/* cpus_allowed? */
 	/* rt_priority? */
 	/* signals? */
+	set_current_cred(get_cred(&init_cred));
 	security_task_reparent_to_init(current);
 	memcpy(current->signal->rlim, init_task.signal->rlim,
 	       sizeof(current->signal->rlim));
diff --git a/kernel/fork.c b/kernel/fork.c
index 7332e23..c5ad5c8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -121,7 +121,7 @@ void __put_task_struct(struct task_struct *tsk)
 
 	security_task_free(tsk);
 	free_uid(tsk->user);
-	put_group_info(tsk->group_info);
+	put_cred(tsk->cred);
 	delayacct_tsk_free(tsk);
 
 	if (!profile_handoff_task(tsk))
@@ -949,6 +949,56 @@ static inline void rt_mutex_init_task(struct task_struct *p)
 }
 
 /*
+ * Copy a set of credentials
+ */
+static int copy_cred(struct task_struct *p)
+{
+	struct cred *cred;
+#ifdef CONFIG_KEYS
+	struct key *session_keyring, *process_keyring;
+#endif
+
+	/* share the credentials if we can */
+	if (
+#ifdef CONFIG_KEYS
+		!p->cred->thread_keyring &&
+#endif
+		true
+	    ) {
+		atomic_inc(&p->cred->usage);
+	} else {
+		cred = kmalloc(sizeof(struct cred), GFP_KERNEL);
+		if (!cred)
+			return -ENOMEM;
+
+		*cred = *p->cred;
+		atomic_set(&cred->usage, 1);
+		get_group_info(cred->group_info);
+		
+#ifdef CONFIG_KEYS
+		rcu_read_lock();
+		session_keyring =
+			key_get(rcu_dereference(p->signal->session_keyring));
+		rcu_read_unlock();
+		if (!session_keyring)
+			session_keyring = key_get(p->user->session_keyring);
+			cred->session_keyring = make_key_ref(session_keyring, 1);
+
+		process_keyring = key_get(p->signal->process_keyring);
+		if (process_keyring)
+			cred->process_keyring = make_key_ref(process_keyring, 1);
+		else
+			cred->process_keyring = NULL;
+
+		cred->thread_keyring = NULL;
+#endif
+
+		p->cred = cred;
+	}
+	return 0;
+}
+
+/*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
  *
@@ -1010,7 +1060,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	atomic_inc(&p->user->__count);
 	atomic_inc(&p->user->processes);
-	get_group_info(p->group_info);
+	if ((retval = copy_cred(p) < 0))
+		goto bad_fork_cleanup_count;
 
 	/*
 	 * If multiple threads are within copy_process(), then this check
@@ -1018,10 +1069,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * to stop root fork bombs.
 	 */
 	if (nr_threads >= max_threads)
-		goto bad_fork_cleanup_count;
+		goto bad_fork_cleanup_cred;
 
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
-		goto bad_fork_cleanup_count;
+		goto bad_fork_cleanup_cred;
 
 	if (p->binfmt && !try_module_get(p->binfmt->module))
 		goto bad_fork_cleanup_put_domain;
@@ -1309,8 +1360,9 @@ bad_fork_cleanup_delays_binfmt:
 		module_put(p->binfmt->module);
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
+bad_fork_cleanup_cred:
+	put_cred(p->cred);
 bad_fork_cleanup_count:
-	put_group_info(p->group_info);
 	atomic_dec(&p->user->processes);
 	free_uid(p->user);
 bad_fork_free:
diff --git a/kernel/sys.c b/kernel/sys.c
index 1b33b05..86b1ba2 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1011,6 +1011,7 @@ void ctrl_alt_del(void)
  */
 asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 {
+	struct cred *cred;
 	int old_rgid = current->gid;
 	int old_egid = current->egid;
 	int new_rgid = old_rgid;
@@ -1038,6 +1039,11 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 		else
 			return -EPERM;
 	}
+
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (new_egid != old_egid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
@@ -1045,9 +1051,10 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 	if (rgid != (gid_t) -1 ||
 	    (egid != (gid_t) -1 && egid != old_rgid))
 		current->sgid = new_egid;
-	current->fsgid = new_egid;
 	current->egid = new_egid;
 	current->gid = new_rgid;
+	change_fsgid(cred, new_egid);
+	set_current_cred(cred);
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -1060,6 +1067,7 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
  */
 asmlinkage long sys_setgid(gid_t gid)
 {
+	struct cred *cred;
 	int old_egid = current->egid;
 	int retval;
 
@@ -1067,22 +1075,29 @@ asmlinkage long sys_setgid(gid_t gid)
 	if (retval)
 		return retval;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (capable(CAP_SETGID)) {
 		if (old_egid != gid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->gid = current->egid = current->sgid = current->fsgid = gid;
+		current->gid = current->egid = current->sgid = gid;
 	} else if ((gid == current->gid) || (gid == current->sgid)) {
 		if (old_egid != gid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->egid = current->fsgid = gid;
-	}
-	else
+		current->egid = gid;
+	} else {
+		put_cred(cred);
 		return -EPERM;
-
+	}
+ 
+	change_fsgid(cred, gid);
+	set_current_cred(cred);
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -1130,6 +1145,7 @@ static int set_user(uid_t new_ruid, int dumpclear)
  */
 asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 {
+	struct cred *cred;
 	int old_ruid, old_euid, old_suid, new_ruid, new_euid;
 	int retval;
 
@@ -1158,19 +1174,26 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 			return -EPERM;
 	}
 
-	if (new_ruid != old_ruid && set_user(new_ruid, new_euid != old_euid) < 0)
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
+	if (new_ruid != old_ruid && set_user(new_ruid, new_euid != old_euid) < 0) {
+		put_cred(cred);
 		return -EAGAIN;
+	}
 
 	if (new_euid != old_euid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = new_euid;
+	current->euid = new_euid;
 	if (ruid != (uid_t) -1 ||
 	    (euid != (uid_t) -1 && euid != old_ruid))
 		current->suid = current->euid;
-	current->fsuid = current->euid;
 
+	change_fsuid(cred, new_euid);
+	set_current_cred(cred);
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
@@ -1192,6 +1215,7 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
  */
 asmlinkage long sys_setuid(uid_t uid)
 {
+	struct cred *cred;
 	int old_euid = current->euid;
 	int old_ruid, old_suid, new_suid;
 	int retval;
@@ -1200,24 +1224,33 @@ asmlinkage long sys_setuid(uid_t uid)
 	if (retval)
 		return retval;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	old_ruid = current->uid;
 	old_suid = current->suid;
 	new_suid = old_suid;
 	
 	if (capable(CAP_SETUID)) {
-		if (uid != old_ruid && set_user(uid, old_euid != uid) < 0)
+		if (uid != old_ruid && set_user(uid, old_euid != uid) < 0) {
+			put_cred(cred);
 			return -EAGAIN;
+		}
 		new_suid = uid;
-	} else if ((uid != current->uid) && (uid != new_suid))
+	} else if ((uid != current->uid) && (uid != new_suid)) {
+		put_cred(cred);
 		return -EPERM;
+	}
 
 	if (old_euid != uid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = uid;
+	current->euid = uid;
 	current->suid = new_suid;
-
+	change_fsuid(cred, uid);
+	set_current_cred(cred);
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
@@ -1231,6 +1264,7 @@ asmlinkage long sys_setuid(uid_t uid)
  */
 asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 {
+	struct cred *cred;
 	int old_ruid = current->uid;
 	int old_euid = current->euid;
 	int old_suid = current->suid;
@@ -1251,9 +1285,16 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 		    (suid != current->euid) && (suid != current->suid))
 			return -EPERM;
 	}
+
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (ruid != (uid_t) -1) {
-		if (ruid != current->uid && set_user(ruid, euid != current->euid) < 0)
+		if (ruid != current->uid && set_user(ruid, euid != current->euid) < 0) {
+			put_cred(cred);
 			return -EAGAIN;
+		}
 	}
 	if (euid != (uid_t) -1) {
 		if (euid != current->euid) {
@@ -1262,10 +1303,10 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 		}
 		current->euid = euid;
 	}
-	current->fsuid = current->euid;
 	if (suid != (uid_t) -1)
 		current->suid = suid;
-
+	change_fsuid(cred, current->euid);
+	set_current_cred(cred);
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
@@ -1288,6 +1329,7 @@ asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __us
  */
 asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 {
+	struct cred *cred;
 	int retval;
 
 	retval = security_task_setgid(rgid, egid, sgid, LSM_SETID_RES);
@@ -1305,6 +1347,11 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 		    (sgid != current->egid) && (sgid != current->sgid))
 			return -EPERM;
 	}
+
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (egid != (gid_t) -1) {
 		if (egid != current->egid) {
 			set_dumpable(current->mm, suid_dumpable);
@@ -1312,12 +1359,13 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 		}
 		current->egid = egid;
 	}
-	current->fsgid = current->egid;
 	if (rgid != (gid_t) -1)
 		current->gid = rgid;
 	if (sgid != (gid_t) -1)
 		current->sgid = sgid;
 
+	change_fsgid(cred, current->egid);
+	set_current_cred(cred);
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -1343,23 +1391,31 @@ asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __us
  */
 asmlinkage long sys_setfsuid(uid_t uid)
 {
+	struct cred *cred;
 	int old_fsuid;
 
-	old_fsuid = current->fsuid;
+	old_fsuid = current_fsuid;
 	if (security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS))
 		return old_fsuid;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (uid == current->uid || uid == current->euid ||
-	    uid == current->suid || uid == current->fsuid || 
+	    uid == current->suid || uid == current_fsuid || 
 	    capable(CAP_SETUID)) {
 		if (uid != old_fsuid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsuid = uid;
+		change_fsuid(cred, uid);
+		set_current_cred(cred);
+		key_fsuid_changed(current);
+	} else {
+		put_cred(cred);
 	}
 
-	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
 	security_task_post_setuid(old_fsuid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS);
@@ -1372,22 +1428,30 @@ asmlinkage long sys_setfsuid(uid_t uid)
  */
 asmlinkage long sys_setfsgid(gid_t gid)
 {
+	struct cred *cred;
 	int old_fsgid;
 
-	old_fsgid = current->fsgid;
+	old_fsgid = current_fsgid;
 	if (security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_FS))
 		return old_fsgid;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (gid == current->gid || gid == current->egid ||
-	    gid == current->sgid || gid == current->fsgid || 
+	    gid == current->sgid || gid == current_fsgid || 
 	    capable(CAP_SETGID)) {
 		if (gid != old_fsgid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsgid = gid;
+		change_fsgid(cred, gid);
+		set_current_cred(cred);
 		key_fsgid_changed(current);
 		proc_id_connector(current, PROC_EVENT_GID);
+	} else {
+		put_cred(cred);
 	}
 	return old_fsgid;
 }
@@ -1754,23 +1818,20 @@ int groups_search(struct group_info *group_info, gid_t grp)
 /* validate and set current->group_info */
 int set_current_groups(struct group_info *group_info)
 {
+	struct cred *cred;
 	int retval;
-	struct group_info *old_info;
 
 	retval = security_task_setgroups(group_info);
 	if (retval)
 		return retval;
 
-	groups_sort(group_info);
-	get_group_info(group_info);
-
-	task_lock(current);
-	old_info = current->group_info;
-	current->group_info = group_info;
-	task_unlock(current);
-
-	put_group_info(old_info);
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
 
+	groups_sort(group_info);
+	change_group_info(cred, group_info);
+	set_current_cred(cred);
 	return 0;
 }
 
@@ -1778,24 +1839,24 @@ EXPORT_SYMBOL(set_current_groups);
 
 asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist)
 {
+	struct group_info *group_info = current_group_info;
 	int i = 0;
 
 	/*
-	 *	SMP: Nobody else can change our grouplist. Thus we are
-	 *	safe.
+	 *	SMP: Nobody else can change our credentials.  Thus we are safe.
 	 */
 
 	if (gidsetsize < 0)
 		return -EINVAL;
 
 	/* no need to grab task_lock here; it cannot change */
-	i = current->group_info->ngroups;
+	i = group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups_to_user(grouplist, current->group_info)) {
+		if (groups_to_user(grouplist, group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
@@ -1839,9 +1900,11 @@ asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist)
  */
 int in_group_p(gid_t grp)
 {
+	struct cred *cred = current->cred;
 	int retval = 1;
-	if (grp != current->fsgid)
-		retval = groups_search(current->group_info, grp);
+
+	if (grp != cred->gid)
+		retval = groups_search(cred->group_info, grp);
 	return retval;
 }
 
@@ -1851,7 +1914,7 @@ int in_egroup_p(gid_t grp)
 {
 	int retval = 1;
 	if (grp != current->egid)
-		retval = groups_search(current->group_info, grp);
+		retval = groups_search(current_group_info, grp);
 	return retval;
 }
 
diff --git a/kernel/uid16.c b/kernel/uid16.c
index dd308ba..5a8b95e 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -161,25 +161,24 @@ static int groups16_from_user(struct group_info *group_info,
 
 asmlinkage long sys_getgroups16(int gidsetsize, old_gid_t __user *grouplist)
 {
+	struct group_info *group_info = current->cred->group_info;
 	int i = 0;
 
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	i = group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
 	return i;
 }
 
diff --git a/mm/shmem.c b/mm/shmem.c
index fcd19d3..ff670c6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1394,8 +1394,6 @@ shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
 	inode = new_inode(sb);
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_mapping->backing_dev_info = &shmem_backing_dev_info;
@@ -2212,8 +2210,8 @@ static int shmem_fill_super(struct super_block *sb,
 	struct inode *inode;
 	struct dentry *root;
 	int mode   = S_IRWXUGO | S_ISVTX;
-	uid_t uid = current->fsuid;
-	gid_t gid = current->fsgid;
+	uid_t uid = current_fsuid;
+	gid_t gid = current_fsgid;
 	int err = -ENOMEM;
 	struct shmem_sb_info *sbinfo;
 	unsigned long blocks = 0;
diff --git a/net/socket.c b/net/socket.c
index 7d44453..50bfeef 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -483,8 +483,6 @@ static struct socket *sock_alloc(void)
 	sock = SOCKET_I(inode);
 
 	inode->i_mode = S_IFSOCK | S_IRWXUGO;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
 
 	get_cpu_var(sockets_in_use)++;
 	put_cpu_var(sockets_in_use);
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 1ea2755..4919eba 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -267,7 +267,7 @@ rpcauth_cache_shrinker(int nr_to_scan, gfp_t gfp_mask)
  * Look up a process' credentials in the authentication cache
  */
 struct rpc_cred *
-rpcauth_lookup_credcache(struct rpc_auth *auth, struct auth_cred * acred,
+rpcauth_lookup_credcache(struct rpc_auth *auth, struct cred * acred,
 		int flags)
 {
 	LIST_HEAD(free);
@@ -336,23 +336,13 @@ out:
 struct rpc_cred *
 rpcauth_lookupcred(struct rpc_auth *auth, int flags)
 {
-	struct auth_cred acred = {
-		.uid = current->fsuid,
-		.gid = current->fsgid,
-		.group_info = current->group_info,
-	};
-	struct rpc_cred *ret;
-
 	dprintk("RPC:       looking up %s cred\n",
 		auth->au_ops->au_name);
-	get_group_info(acred.group_info);
-	ret = auth->au_ops->lookup_cred(auth, &acred, flags);
-	put_group_info(acred.group_info);
-	return ret;
+	return auth->au_ops->lookup_cred(auth, current_cred, flags);
 }
 
 void
-rpcauth_init_cred(struct rpc_cred *cred, const struct auth_cred *acred,
+rpcauth_init_cred(struct rpc_cred *cred, const struct cred *acred,
 		  struct rpc_auth *auth, const struct rpc_credops *ops)
 {
 	INIT_HLIST_NODE(&cred->cr_hash);
@@ -372,25 +362,18 @@ struct rpc_cred *
 rpcauth_bindcred(struct rpc_task *task)
 {
 	struct rpc_auth *auth = task->tk_client->cl_auth;
-	struct auth_cred acred = {
-		.uid = current->fsuid,
-		.gid = current->fsgid,
-		.group_info = current->group_info,
-	};
 	struct rpc_cred *ret;
 	int flags = 0;
 
 	dprintk("RPC: %5u looking up %s cred\n",
 		task->tk_pid, task->tk_client->cl_auth->au_ops->au_name);
-	get_group_info(acred.group_info);
 	if (task->tk_flags & RPC_TASK_ROOTCREDS)
 		flags |= RPCAUTH_LOOKUP_ROOTCREDS;
-	ret = auth->au_ops->lookup_cred(auth, &acred, flags);
+	ret = auth->au_ops->lookup_cred(auth, current_cred, flags);
 	if (!IS_ERR(ret))
 		task->tk_msg.rpc_cred = ret;
 	else
 		task->tk_status = PTR_ERR(ret);
-	put_group_info(acred.group_info);
 	return ret;
 }
 
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 53995af..bad2698 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -793,13 +793,13 @@ gss_destroy_cred(struct rpc_cred *cred)
  * Lookup RPCSEC_GSS cred for the current process
  */
 static struct rpc_cred *
-gss_lookup_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+gss_lookup_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	return rpcauth_lookup_credcache(auth, acred, flags);
 }
 
 static struct rpc_cred *
-gss_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+gss_create_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	struct gss_auth *gss_auth = container_of(auth, struct gss_auth, rpc_auth);
 	struct gss_cred	*cred = NULL;
@@ -840,7 +840,7 @@ gss_cred_init(struct rpc_auth *auth, struct rpc_cred *cred)
 }
 
 static int
-gss_match(struct auth_cred *acred, struct rpc_cred *rc, int flags)
+gss_match(struct cred *acred, struct rpc_cred *rc, int flags)
 {
 	struct gss_cred *gss_cred = container_of(rc, struct gss_cred, gc_base);
 
diff --git a/net/sunrpc/auth_null.c b/net/sunrpc/auth_null.c
index 537d0e8..c2fcefa 100644
--- a/net/sunrpc/auth_null.c
+++ b/net/sunrpc/auth_null.c
@@ -34,7 +34,7 @@ nul_destroy(struct rpc_auth *auth)
  * Lookup NULL creds for current process
  */
 static struct rpc_cred *
-nul_lookup_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+nul_lookup_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	return get_rpccred(&null_cred);
 }
@@ -51,7 +51,7 @@ nul_destroy_cred(struct rpc_cred *cred)
  * Match cred handle against current process
  */
 static int
-nul_match(struct auth_cred *acred, struct rpc_cred *cred, int taskflags)
+nul_match(struct cred *acred, struct rpc_cred *cred, int taskflags)
 {
 	return 1;
 }
diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index 5ed91e5..f5ab6d7 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -51,13 +51,13 @@ unx_destroy(struct rpc_auth *auth)
  * Lookup AUTH_UNIX creds for current process
  */
 static struct rpc_cred *
-unx_lookup_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+unx_lookup_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	return rpcauth_lookup_credcache(auth, acred, flags);
 }
 
 static struct rpc_cred *
-unx_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+unx_create_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	struct unx_cred	*cred;
 	int		i;
@@ -115,7 +115,7 @@ unx_destroy_cred(struct rpc_cred *cred)
  * request root creds (e.g. for NFS swapping).
  */
 static int
-unx_match(struct auth_cred *acred, struct rpc_cred *rcred, int flags)
+unx_match(struct cred *acred, struct rpc_cred *rcred, int flags)
 {
 	struct unx_cred	*cred = container_of(rcred, struct unx_cred, uc_base);
 	int		i;
diff --git a/security/dummy.c b/security/dummy.c
index 853ec22..62de89c 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -43,10 +43,12 @@ static int dummy_capget (struct task_struct *target, kernel_cap_t * effective,
 			*permitted |= (~0 & ~CAP_FS_MASK);
 			*effective |= (~0 & ~CAP_TO_MASK(CAP_SETPCAP) & ~CAP_FS_MASK);
 		}
-		if (target->fsuid == 0) {
+		rcu_read_lock();
+		if (task_cred(target)->uid == 0) {
 			*permitted |= CAP_FS_MASK;
 			*effective |= CAP_FS_MASK;
 		}
+		rcu_read_unlock();
 	}
 	return 0;
 }
@@ -138,8 +140,11 @@ static void dummy_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 		}
 	}
 
-	current->suid = current->euid = current->fsuid = bprm->e_uid;
-	current->sgid = current->egid = current->fsgid = bprm->e_gid;
+	current->suid = current->euid = bprm->e_uid;
+	current->sgid = current->egid = bprm->e_gid;
+
+	change_fsuid(bprm->cred, bprm->e_uid);
+	change_fsgid(bprm->cred, bprm->e_gid);
 
 	dummy_capget(current, &current->cap_effective, &current->cap_inheritable, &current->cap_permitted);
 }
@@ -572,7 +577,7 @@ static int dummy_task_prctl (int option, unsigned long arg2, unsigned long arg3,
 
 static void dummy_task_reparent_to_init (struct task_struct *p)
 {
-	p->euid = p->fsuid = 0;
+	p->euid = 0;
 	return;
 }
 
diff --git a/security/keys/key.c b/security/keys/key.c
index 01bbc6d..ec3f7f9 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -817,7 +817,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 		perm |= KEY_USR_WRITE;
 
 	/* allocate a new key */
-	key = key_alloc(ktype, description, current->fsuid, current->fsgid,
+	key = key_alloc(ktype, description, current_fsuid, current_fsgid,
 			current, perm, flags);
 	if (IS_ERR(key)) {
 		key_ref = ERR_PTR(PTR_ERR(key));
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index d9ca15c..62558ff 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -794,7 +794,7 @@ long keyctl_setperm_key(key_serial_t id, key_perm_t perm)
 	down_write(&key->sem);
 
 	/* if we're not the sysadmin, we can only change a key that we own */
-	if (capable(CAP_SYS_ADMIN) || key->uid == current->fsuid) {
+	if (capable(CAP_SYS_ADMIN) || key->uid == current_fsuid) {
 		key->perm = perm;
 		ret = 0;
 	}
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 3b41f9b..f0f0452 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -22,14 +22,19 @@ int key_task_permission(const key_ref_t key_ref,
 			struct task_struct *context,
 			key_perm_t perm)
 {
+	struct cred *cred;
 	struct key *key;
 	key_perm_t kperm;
 	int ret;
 
+	rcu_read_lock();
+	cred = get_task_cred(context);
+	rcu_read_unlock();
+
 	key = key_ref_to_ptr(key_ref);
 
 	/* use the second 8-bits of permissions for keys the caller owns */
-	if (key->uid == context->fsuid) {
+	if (key->uid == cred->uid) {
 		kperm = key->perm >> 16;
 		goto use_these_perms;
 	}
@@ -37,15 +42,12 @@ int key_task_permission(const key_ref_t key_ref,
 	/* use the third 8-bits of permissions for keys the caller has a group
 	 * membership in common with */
 	if (key->gid != -1 && key->perm & KEY_GRP_ALL) {
-		if (key->gid == context->fsgid) {
+		if (key->gid == cred->gid) {
 			kperm = key->perm >> 8;
 			goto use_these_perms;
 		}
 
-		task_lock(context);
-		ret = groups_search(context->group_info, key->gid);
-		task_unlock(context);
-
+		ret = groups_search(cred->group_info, key->gid);
 		if (ret) {
 			kperm = key->perm >> 8;
 			goto use_these_perms;
@@ -56,6 +58,8 @@ int key_task_permission(const key_ref_t key_ref,
 	kperm = key->perm;
 
 use_these_perms:
+	put_cred(cred);
+
 	/* use the top 8-bits of permissions for keys the caller possesses
 	 * - possessor permissions are additive with other permissions
 	 */
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index b6f8680..97c99d1 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -357,13 +357,14 @@ int suid_keys(struct task_struct *tsk)
 /*****************************************************************************/
 /*
  * the filesystem user ID changed
+ * - can only be used for current task
  */
 void key_fsuid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
 	if (tsk->thread_keyring) {
 		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->uid = tsk->fsuid;
+		tsk->thread_keyring->uid = tsk->cred->uid;
 		up_write(&tsk->thread_keyring->sem);
 	}
 
@@ -372,13 +373,14 @@ void key_fsuid_changed(struct task_struct *tsk)
 /*****************************************************************************/
 /*
  * the filesystem group ID changed
+ * - can only be used for current task
  */
 void key_fsgid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
 	if (tsk->thread_keyring) {
 		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->gid = tsk->fsgid;
+		tsk->thread_keyring->gid = tsk->cred->gid;
 		up_write(&tsk->thread_keyring->sem);
 	}
 
@@ -398,10 +400,13 @@ key_ref_t search_process_keyrings(struct key_type *type,
 				  struct task_struct *context)
 {
 	struct request_key_auth *rka;
+	struct cred *cred;
 	key_ref_t key_ref, ret, err;
 
 	might_sleep();
 
+	cred = get_current_cred();
+
 	/* we want to return -EAGAIN or -ENOKEY if any of the keyrings were
 	 * searchable, but we failed to find a key or we found a negative key;
 	 * otherwise we want to return a sample error (probably -EACCES) if
@@ -414,10 +419,9 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	err = ERR_PTR(-EAGAIN);
 
 	/* search the thread keyring first */
-	if (context->thread_keyring) {
-		key_ref = keyring_search_aux(
-			make_key_ref(context->thread_keyring, 1),
-			context, type, description, match);
+	if (cred->thread_keyring) {
+		key_ref = keyring_search_aux(cred->thread_keyring, context,
+					     type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -435,10 +439,9 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	}
 
 	/* search the process keyring second */
-	if (context->signal->process_keyring) {
-		key_ref = keyring_search_aux(
-			make_key_ref(context->signal->process_keyring, 1),
-			context, type, description, match);
+	if (cred->process_keyring) {
+		key_ref = keyring_search_aux(cred->process_keyring, context,
+					     type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -455,36 +458,10 @@ key_ref_t search_process_keyrings(struct key_type *type,
 		}
 	}
 
-	/* search the session keyring */
-	if (context->signal->session_keyring) {
-		rcu_read_lock();
-		key_ref = keyring_search_aux(
-			make_key_ref(rcu_dereference(
-					     context->signal->session_keyring),
-				     1),
-			context, type, description, match);
-		rcu_read_unlock();
-
-		if (!IS_ERR(key_ref))
-			goto found;
-
-		switch (PTR_ERR(key_ref)) {
-		case -EAGAIN: /* no key */
-			if (ret)
-				break;
-		case -ENOKEY: /* negative key */
-			ret = key_ref;
-			break;
-		default:
-			err = key_ref;
-			break;
-		}
-	}
-	/* or search the user-session keyring */
-	else {
-		key_ref = keyring_search_aux(
-			make_key_ref(context->user->session_keyring, 1),
-			context, type, description, match);
+	/* search the session or user-session keyring */
+	if (cred->session_keyring) {
+		key_ref = keyring_search_aux(cred->session_keyring, context,
+					     type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -543,6 +520,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	key_ref = ret ? ret : err;
 
 found:
+	put_cred(cred);
 	return key_ref;
 
 } /* end search_process_keyrings() */
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 5575001..2717ed9 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -49,7 +49,7 @@ static int call_sbin_request_key(struct key *key,
 	/* allocate a new session keyring */
 	sprintf(desc, "_req.%u", key->serial);
 
-	keyring = keyring_alloc(desc, current->fsuid, current->fsgid, current,
+	keyring = keyring_alloc(desc, current_fsuid, current_fsgid, current,
 				KEY_ALLOC_QUOTA_OVERRUN, NULL);
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
@@ -62,8 +62,8 @@ static int call_sbin_request_key(struct key *key,
 		goto error_link;
 
 	/* record the UID and GID */
-	sprintf(uid_str, "%d", current->fsuid);
-	sprintf(gid_str, "%d", current->fsgid);
+	sprintf(uid_str, "%d", current_fsuid);
+	sprintf(gid_str, "%d", current_fsgid);
 
 	/* we say which key is under construction */
 	sprintf(key_str, "%d", key->serial);
@@ -142,7 +142,7 @@ static struct key *__request_key_construction(struct key_type *type,
 
 	/* create a key and add it to the queue */
 	key = key_alloc(type, description,
-			current->fsuid, current->fsgid, current, KEY_POS_ALL,
+			current_fsuid, current_fsgid, current, KEY_POS_ALL,
 			flags);
 	if (IS_ERR(key))
 		goto alloc_failed;
@@ -428,7 +428,7 @@ struct key *request_key_and_link(struct key_type *type,
 			goto error;
 
 		/* - get hold of the user's construction queue */
-		user = key_user_lookup(current->fsuid);
+		user = key_user_lookup(current_fsuid);
 		if (!user)
 			goto nomem;
 
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index cbf58a9..d556c4e 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -185,7 +185,7 @@ struct key *request_key_auth_new(struct key *target, const char *callout_info)
 	sprintf(desc, "%x", target->serial);
 
 	authkey = key_alloc(&key_type_request_key_auth, desc,
-			    current->fsuid, current->fsgid, current,
+			    current_fsuid, current_fsgid, current,
 			    KEY_POS_VIEW | KEY_POS_READ | KEY_POS_SEARCH |
 			    KEY_USR_VIEW, KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(authkey)) {


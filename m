Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbYH0N7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbYH0N7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbYH0NvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:51:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757663AbYH0Nu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:50:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 48/59] CRED: Wrap task credential accesses in the filesystem
	subsystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 27 Aug 2008 14:49:50 +0100
Message-ID: <20080827134949.19980.24110.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---

 fs/anon_inodes.c      |    4 ++--
 fs/attr.c             |    4 ++--
 fs/binfmt_elf_fdpic.c |    8 ++++----
 fs/dquot.c            |    4 ++--
 fs/exec.c             |   18 +++++++++---------
 fs/fcntl.c            |    2 +-
 fs/inotify_user.c     |    2 +-
 fs/ioprio.c           |    4 ++--
 fs/locks.c            |    2 +-
 fs/namei.c            |   10 ++++++----
 fs/namespace.c        |    2 +-
 fs/pipe.c             |    4 ++--
 fs/posix_acl.c        |    4 ++--
 fs/quota.c            |    4 ++--
 include/linux/fs.h    |    2 +-
 15 files changed, 38 insertions(+), 36 deletions(-)


diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 3662dd4..c16d9be 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -154,8 +154,8 @@ static struct inode *anon_inode_mkinode(void)
 	 */
 	inode->i_state = I_DIRTY;
 	inode->i_mode = S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	return inode;
 }
diff --git a/fs/attr.c b/fs/attr.c
index 26c71ba..faa433a 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -29,13 +29,13 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
 
 	/* Make sure a caller can chown. */
 	if ((ia_valid & ATTR_UID) &&
-	    (current->fsuid != inode->i_uid ||
+	    (current_fsuid() != inode->i_uid ||
 	     attr->ia_uid != inode->i_uid) && !capable(CAP_CHOWN))
 		goto error;
 
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
-	    (current->fsuid != inode->i_uid ||
+	    (current_fsuid() != inode->i_uid ||
 	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
 	    !capable(CAP_CHOWN))
 		goto error;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 80c1f95..cee7ed4 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -586,10 +586,10 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	NEW_AUX_ENT(AT_BASE,	interp_params->elfhdr_addr);
 	NEW_AUX_ENT(AT_FLAGS,	0);
 	NEW_AUX_ENT(AT_ENTRY,	exec_params->entry_addr);
-	NEW_AUX_ENT(AT_UID,	(elf_addr_t) current->uid);
-	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current->euid);
-	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current->gid);
-	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current->egid);
+	NEW_AUX_ENT(AT_UID,	(elf_addr_t) current_uid());
+	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current_euid());
+	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current_gid());
+	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current_egid());
 
 #ifdef ARCH_DLINFO
 	nr = 0;
diff --git a/fs/dquot.c b/fs/dquot.c
index ebfaf40..3b18a1b 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -876,7 +876,7 @@ static inline int need_print_warning(struct dquot *dquot)
 
 	switch (dquot->dq_type) {
 		case USRQUOTA:
-			return current->fsuid == dquot->dq_id;
+			return current_fsuid() == dquot->dq_id;
 		case GRPQUOTA:
 			return in_group_p(dquot->dq_id);
 	}
@@ -983,7 +983,7 @@ static void send_warning(const struct dquot *dquot, const char warntype)
 		MINOR(dquot->dq_sb->s_dev));
 	if (ret)
 		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current->user->uid);
+	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current_uid());
 	if (ret)
 		goto attr_err_out;
 	genlmsg_end(skb, msg_head);
diff --git a/fs/exec.c b/fs/exec.c
index cd76695..a04cfff 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -982,7 +982,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 	/* This is the point of no return */
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
-	if (current->euid == current->uid && current->egid == current->gid)
+	if (current_euid() == current_uid() && current_egid() == current_gid())
 		set_dumpable(current->mm, 1);
 	else
 		set_dumpable(current->mm, suid_dumpable);
@@ -1009,7 +1009,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 */
 	current->mm->task_size = TASK_SIZE;
 
-	if (bprm->e_uid != current->euid || bprm->e_gid != current->egid) {
+	if (bprm->e_uid != current_euid() || bprm->e_gid != current_egid()) {
 		suid_keys(current);
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
@@ -1049,8 +1049,8 @@ int prepare_binprm(struct linux_binprm *bprm)
 	if (bprm->file->f_op == NULL)
 		return -EACCES;
 
-	bprm->e_uid = current->euid;
-	bprm->e_gid = current->egid;
+	bprm->e_uid = current_euid();
+	bprm->e_gid = current_egid();
 
 	if(!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
 		/* Set-uid? */
@@ -1098,7 +1098,7 @@ void compute_creds(struct linux_binprm *bprm)
 {
 	int unsafe;
 
-	if (bprm->e_uid != current->uid) {
+	if (bprm->e_uid != current_uid()) {
 		suid_keys(current);
 		current->pdeath_signal = 0;
 	}
@@ -1426,7 +1426,7 @@ static int format_corename(char *corename, int nr_threads, long signr)
 			/* uid */
 			case 'u':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", current->uid);
+					      "%d", current_uid());
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1434,7 +1434,7 @@ static int format_corename(char *corename, int nr_threads, long signr)
 			/* gid */
 			case 'g':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", current->gid);
+					      "%d", current_gid());
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1712,7 +1712,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	struct inode * inode;
 	struct file * file;
 	int retval = 0;
-	int fsuid = current->fsuid;
+	int fsuid = current_fsuid();
 	int flag = 0;
 	int ispipe = 0;
 	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
@@ -1818,7 +1818,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 * Dont allow local users get cute and trick others to coredump
 	 * into their pre-created files:
 	 */
-	if (inode->i_uid != current->fsuid)
+	if (inode->i_uid != current_fsuid())
 		goto close_fail;
 	if (!file->f_op)
 		goto close_fail;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index ac4f7db..bf049a8 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -211,7 +211,7 @@ int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
 	if (err)
 		return err;
 
-	f_modown(filp, pid, type, current->uid, current->euid, force);
+	f_modown(filp, pid, type, current_uid(), current_euid(), force);
 	return 0;
 }
 EXPORT_SYMBOL(__f_setown);
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 6024942..90eed91 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -591,7 +591,7 @@ asmlinkage long sys_inotify_init1(int flags)
 		goto out_put_fd;
 	}
 
-	user = get_uid(current->user);
+	user = get_current_user();
 	if (unlikely(atomic_read(&user->inotify_devs) >=
 			inotify_max_user_instances)) {
 		ret = -EMFILE;
diff --git a/fs/ioprio.c b/fs/ioprio.c
index da3cc46..68d2cd8 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -32,8 +32,8 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
 	int err;
 	struct io_context *ioc;
 
-	if (task->uid != current->euid &&
-	    task->uid != current->uid && !capable(CAP_SYS_NICE))
+	if (task->uid != current_euid() &&
+	    task->uid != current_uid() && !capable(CAP_SYS_NICE))
 		return -EPERM;
 
 	err = security_task_setioprio(task, ioprio);
diff --git a/fs/locks.c b/fs/locks.c
index 5eb259e..ba4ff5a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1349,7 +1349,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 	struct inode *inode = dentry->d_inode;
 	int error, rdlease_count = 0, wrlease_count = 0;
 
-	if ((current->fsuid != inode->i_uid) && !capable(CAP_LEASE))
+	if ((current_fsuid() != inode->i_uid) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
diff --git a/fs/namei.c b/fs/namei.c
index 2b8f823..6162f95 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -186,7 +186,7 @@ int generic_permission(struct inode *inode, int mask,
 
 	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
 
-	if (current->fsuid == inode->i_uid)
+	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl) {
@@ -454,7 +454,7 @@ static int exec_permission_lite(struct inode *inode)
 	if (inode->i_op && inode->i_op->permission)
 		return -EAGAIN;
 
-	if (current->fsuid == inode->i_uid)
+	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
 	else if (in_group_p(inode->i_gid))
 		mode >>= 3;
@@ -1347,11 +1347,13 @@ static int user_path_parent(int dfd, const char __user *path,
  */
 static inline int check_sticky(struct inode *dir, struct inode *inode)
 {
+	uid_t fsuid = current_fsuid();
+
 	if (!(dir->i_mode & S_ISVTX))
 		return 0;
-	if (inode->i_uid == current->fsuid)
+	if (inode->i_uid == fsuid)
 		return 0;
-	if (dir->i_uid == current->fsuid)
+	if (dir->i_uid == fsuid)
 		return 0;
 	return !capable(CAP_FOWNER);
 }
diff --git a/fs/namespace.c b/fs/namespace.c
index f527a0d..961072a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1176,7 +1176,7 @@ static int mount_is_safe(struct path *path)
 	if (S_ISLNK(path->dentry->d_inode->i_mode))
 		return -EPERM;
 	if (path->dentry->d_inode->i_mode & S_ISVTX) {
-		if (current->uid != path->dentry->d_inode->i_uid)
+		if (current_uid() != path->dentry->d_inode->i_uid)
 			return -EPERM;
 	}
 	if (inode_permission(path->dentry->d_inode, MAY_WRITE))
diff --git a/fs/pipe.c b/fs/pipe.c
index fcba654..8b4e3ed 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -902,8 +902,8 @@ static struct inode * get_pipe_inode(void)
 	 */
 	inode->i_state = I_DIRTY;
 	inode->i_mode = S_IFIFO | S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 
 	return inode;
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index aec931e..39df95a 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -217,11 +217,11 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
                 switch(pa->e_tag) {
                         case ACL_USER_OBJ:
 				/* (May have been checked already) */
-                                if (inode->i_uid == current->fsuid)
+				if (inode->i_uid == current_fsuid())
                                         goto check_perm;
                                 break;
                         case ACL_USER:
-                                if (pa->e_id == current->fsuid)
+				if (pa->e_id == current_fsuid())
                                         goto mask;
 				break;
                         case ACL_GROUP_OBJ:
diff --git a/fs/quota.c b/fs/quota.c
index 7f4386e..b7fe44e 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -79,7 +79,7 @@ static int generic_quotactl_valid(struct super_block *sb, int type, int cmd, qid
 
 	/* Check privileges */
 	if (cmd == Q_GETQUOTA) {
-		if (((type == USRQUOTA && current->euid != id) ||
+		if (((type == USRQUOTA && current_euid() != id) ||
 		     (type == GRPQUOTA && !in_egroup_p(id))) &&
 		    !capable(CAP_SYS_ADMIN))
 			return -EPERM;
@@ -130,7 +130,7 @@ static int xqm_quotactl_valid(struct super_block *sb, int type, int cmd, qid_t i
 
 	/* Check privileges */
 	if (cmd == Q_XGETQUOTA) {
-		if (((type == XQM_USRQUOTA && current->euid != id) ||
+		if (((type == XQM_USRQUOTA && current_euid() != id) ||
 		     (type == XQM_GRPQUOTA && !in_egroup_p(id))) &&
 		     !capable(CAP_SYS_ADMIN))
 			return -EPERM;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3707784..de03039 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1185,7 +1185,7 @@ enum {
 #define has_fs_excl() atomic_read(&current->fs_excl)
 
 #define is_owner_or_cap(inode)	\
-	((current->fsuid == (inode)->i_uid) || capable(CAP_FOWNER))
+	((current_fsuid() == (inode)->i_uid) || capable(CAP_FOWNER))
 
 /* not quite ready to be deprecated, but... */
 extern void lock_super(struct super_block *);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757843AbYAOXvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbYAOXvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbYAOXsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:48:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525AbYAOXr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:47:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/26] Security: Separate task security context from
	task_struct
To: sds@tycho.nsa.gov, casey@schaufler-ca.com, Trond.Myklebust@netapp.com,
       npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Tue, 15 Jan 2008 23:47:25 +0000
Message-ID: <20080115234724.22183.9603.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the task security context from task_struct.  At this point, the
security data is temporarily embedded in the task_struct with two pointers
pointing to it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/block/loop.c             |    5 -
 drivers/char/agp/frontend.c      |    2 
 drivers/char/drm/drm_fops.c      |    2 
 drivers/char/tty_audit.c         |    2 
 fs/affs/super.c                  |    4 -
 fs/autofs/inode.c                |    4 -
 fs/autofs4/inode.c               |    4 -
 fs/autofs4/waitq.c               |    4 -
 fs/binfmt_elf.c                  |   12 +-
 fs/cifs/connect.c                |    5 -
 fs/cifs/ioctl.c                  |    2 
 fs/ecryptfs/messaging.c          |   15 +-
 fs/exec.c                        |   20 ++-
 fs/fat/inode.c                   |    4 -
 fs/fcntl.c                       |    7 +
 fs/file_table.c                  |    4 -
 fs/fuse/dir.c                    |   12 +-
 fs/hfs/super.c                   |    4 -
 fs/hfsplus/options.c             |    4 -
 fs/hpfs/super.c                  |    4 -
 fs/hugetlbfs/inode.c             |    4 -
 fs/inotify_user.c                |    2 
 fs/ioprio.c                      |   12 +-
 fs/namei.c                       |    6 +
 fs/ncpfs/ioctl.c                 |   32 ++---
 fs/open.c                        |   22 ++-
 fs/proc/array.c                  |   14 +-
 fs/proc/base.c                   |   16 +-
 fs/proc/proc_sysctl.c            |    4 -
 fs/quota.c                       |    4 -
 fs/smbfs/dir.c                   |    4 -
 fs/smbfs/inode.c                 |    2 
 fs/smbfs/proc.c                  |    2 
 include/linux/init_task.h        |   23 +++
 include/linux/sched.h            |   78 +++++++++---
 include/net/scm.h                |    4 -
 ipc/mqueue.c                     |    4 -
 ipc/msg.c                        |    4 -
 ipc/sem.c                        |    4 -
 ipc/shm.c                        |   16 +-
 ipc/util.c                       |    7 +
 kernel/acct.c                    |    8 +
 kernel/auditsc.c                 |   40 +++---
 kernel/cgroup.c                  |    5 -
 kernel/exit.c                    |   12 +-
 kernel/fork.c                    |   23 ++-
 kernel/futex.c                   |    8 +
 kernel/futex_compat.c            |    5 -
 kernel/ptrace.c                  |   14 +-
 kernel/sched.c                   |    9 +
 kernel/signal.c                  |   26 ++--
 kernel/sys.c                     |  251 ++++++++++++++++++++------------------
 kernel/sysctl.c                  |    2 
 kernel/timer.c                   |    8 +
 kernel/uid16.c                   |   28 ++--
 kernel/user.c                    |    4 -
 kernel/user_namespace.c          |    2 
 mm/oom_kill.c                    |    6 -
 net/core/scm.c                   |   10 +-
 net/sunrpc/auth.c                |    4 -
 net/unix/af_unix.c               |   12 +-
 security/commoncap.c             |  110 ++++++++++-------
 security/dummy.c                 |   40 ++++--
 security/keys/key.c              |    2 
 security/keys/keyctl.c           |   25 ++--
 security/keys/permission.c       |   11 +-
 security/keys/process_keys.c     |   76 ++++++------
 security/keys/request_key.c      |   17 +--
 security/keys/request_key_auth.c |   14 +-
 security/selinux/exports.c       |    4 -
 security/selinux/hooks.c         |  111 ++++++++---------
 security/selinux/selinuxfs.c     |    2 
 72 files changed, 698 insertions(+), 575 deletions(-)


diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b8af22e..30232fb 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -928,7 +928,8 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	int err;
 	struct loop_func_table *xfer;
 
-	if (lo->lo_encrypt_key_size && lo->lo_key_owner != current->uid &&
+	if (lo->lo_encrypt_key_size &&
+	    lo->lo_key_owner != current->act_as->uid &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (lo->lo_state != Lo_bound)
@@ -979,7 +980,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	if (info->lo_encrypt_key_size) {
 		memcpy(lo->lo_encrypt_key, info->lo_encrypt_key,
 		       info->lo_encrypt_key_size);
-		lo->lo_key_owner = current->uid;
+		lo->lo_key_owner = current->act_as->uid;
 	}	
 
 	return 0;
diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index 7791e98..b07d2d2 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -689,7 +689,7 @@ static int agp_open(struct inode *inode, struct file *file)
 	set_bit(AGP_FF_ALLOW_CLIENT, &priv->access_flags);
 	priv->my_pid = current->pid;
 
-	if ((current->uid == 0) || (current->suid == 0)) {
+	if ((current->act_as->uid == 0) || (current->act_as->suid == 0)) {
 		/* Root priv, can be controller */
 		set_bit(AGP_FF_ALLOW_CONTROLLER, &priv->access_flags);
 	}
diff --git a/drivers/char/drm/drm_fops.c b/drivers/char/drm/drm_fops.c
index 3992f73..1f8d0a7 100644
--- a/drivers/char/drm/drm_fops.c
+++ b/drivers/char/drm/drm_fops.c
@@ -243,7 +243,7 @@ static int drm_open_helper(struct inode *inode, struct file *filp,
 	memset(priv, 0, sizeof(*priv));
 	filp->private_data = priv;
 	priv->filp = filp;
-	priv->uid = current->euid;
+	priv->uid = current->act_as->euid;
 	priv->pid = task_pid_nr(current);
 	priv->minor = minor;
 	priv->head = drm_heads[minor];
diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index d222012..625c12b 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -86,7 +86,7 @@ static void tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
 		char name[sizeof(tsk->comm)];
 
 		audit_log_format(ab, "tty pid=%u uid=%u auid=%u major=%d "
-				 "minor=%d comm=", tsk->pid, tsk->uid,
+				 "minor=%d comm=", tsk->pid, tsk->sec->uid,
 				 loginuid, buf->major, buf->minor);
 		get_task_comm(name, tsk);
 		audit_log_untrustedstring(ab, name);
diff --git a/fs/affs/super.c b/fs/affs/super.c
index b53e5d0..ed79ab3 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -159,8 +159,8 @@ parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s
 
 	/* Fill in defaults */
 
-	*uid        = current->uid;
-	*gid        = current->gid;
+	*uid        = current->sec->uid;
+	*gid        = current->sec->gid;
 	*reserved   = 2;
 	*root       = -1;
 	*blocksize  = -1;
diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index 45f5992..ac3bd58 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -78,8 +78,8 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 
-	*uid = current->uid;
-	*gid = current->gid;
+	*uid = current->sec->uid;
+	*gid = current->sec->gid;
 	*pgrp = task_pgrp_nr(current);
 
 	*minproto = *maxproto = AUTOFS_PROTO_VERSION;
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 7f05d6c..fac6121 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -224,8 +224,8 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 
-	*uid = current->uid;
-	*gid = current->gid;
+	*uid = current->sec->uid;
+	*gid = current->sec->gid;
 	*pgrp = task_pgrp_nr(current);
 
 	*minproto = AUTOFS_MIN_PROTO_VERSION;
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 1fe28e4..f41f5b7 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -294,8 +294,8 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		wq->len = len;
 		wq->dev = autofs4_get_dev(sbi);
 		wq->ino = autofs4_get_ino(sbi);
-		wq->uid = current->uid;
-		wq->gid = current->gid;
+		wq->uid = current->sec->uid;
+		wq->gid = current->sec->gid;
 		wq->pid = current->pid;
 		wq->tgid = current->tgid;
 		wq->status = -EINTR; /* Status return if interrupted */
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f0b3171..307a65e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -200,10 +200,10 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
 	NEW_AUX_ENT(AT_FLAGS, 0);
 	NEW_AUX_ENT(AT_ENTRY, exec->e_entry);
-	NEW_AUX_ENT(AT_UID, tsk->uid);
-	NEW_AUX_ENT(AT_EUID, tsk->euid);
-	NEW_AUX_ENT(AT_GID, tsk->gid);
-	NEW_AUX_ENT(AT_EGID, tsk->egid);
+	NEW_AUX_ENT(AT_UID, tsk->sec->uid);
+	NEW_AUX_ENT(AT_EUID, tsk->sec->euid);
+	NEW_AUX_ENT(AT_GID, tsk->sec->gid);
+	NEW_AUX_ENT(AT_EGID, tsk->sec->egid);
  	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
 	if (k_platform) {
 		NEW_AUX_ENT(AT_PLATFORM,
@@ -1440,8 +1440,8 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	psinfo->pr_zomb = psinfo->pr_sname == 'Z';
 	psinfo->pr_nice = task_nice(p);
 	psinfo->pr_flag = p->flags;
-	SET_UID(psinfo->pr_uid, p->uid);
-	SET_GID(psinfo->pr_gid, p->gid);
+	SET_UID(psinfo->pr_uid, p->sec->uid);
+	SET_GID(psinfo->pr_gid, p->sec->gid);
 	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 	
 	return 0;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fd9147c..77b3e30 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -818,8 +818,9 @@ cifs_parse_mount_options(char *options, const char *devname,
 	/* null target name indicates to use *SMBSERVR default called name
 	   if we end up sending RFC1001 session initialize */
 	vol->target_rfc1001_name[0] = 0;
-	vol->linux_uid = current->uid;	/* current->euid instead? */
-	vol->linux_gid = current->gid;
+	vol->linux_uid = current->sec->uid;  /* use current->act_as->euid
+					      * instead? */
+	vol->linux_gid = current->sec->gid;
 	vol->dir_mode = S_IRWXUGO;
 	/* 2767 perms indicate mandatory locking support */
 	vol->file_mode = (S_IRWXUGO | S_ISGID) & (~S_IXGRP);
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index d24fe68..bf61a78 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -65,7 +65,7 @@ int cifs_ioctl (struct inode *inode, struct file *filep,
 	switch (command) {
 		case CIFS_IOC_CHECKUMOUNT:
 			cFYI(1, ("User unmount attempted"));
-			if (cifs_sb->mnt_uid == current->uid)
+			if (cifs_sb->mnt_uid == current->sec->uid)
 				rc = 0;
 			else {
 				rc = -EACCES;
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index 9cc2aec..d035a5f 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -264,26 +264,27 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t uid,
 	}
 	msg_ctx = &ecryptfs_msg_ctx_arr[msg->index];
 	mutex_lock(&msg_ctx->mux);
-	if (ecryptfs_find_daemon_id(msg_ctx->task->euid, &id)) {
+	if (ecryptfs_find_daemon_id(msg_ctx->task->sec->euid, &id)) {
 		rc = -EBADMSG;
 		ecryptfs_printk(KERN_WARNING, "User [%d] received a "
 				"message response from process [%d] but does "
 				"not have a registered daemon\n",
-				msg_ctx->task->euid, pid);
+				msg_ctx->task->sec->euid, pid);
 		goto wake_up;
 	}
-	if (msg_ctx->task->euid != uid) {
+	if (msg_ctx->task->sec->euid != uid) {
 		rc = -EBADMSG;
 		ecryptfs_printk(KERN_WARNING, "Received message from user "
 				"[%d]; expected message from user [%d]\n",
-				uid, msg_ctx->task->euid);
+				uid, msg_ctx->task->sec->euid);
 		goto unlock;
 	}
 	if (id->pid != pid) {
 		rc = -EBADMSG;
 		ecryptfs_printk(KERN_ERR, "User [%d] received a "
 				"message response from an unrecognized "
-				"process [%d]\n", msg_ctx->task->euid, pid);
+				"process [%d]\n",
+				msg_ctx->task->sec->euid, pid);
 		goto unlock;
 	}
 	if (msg_ctx->state != ECRYPTFS_MSG_CTX_STATE_PENDING) {
@@ -331,11 +332,11 @@ int ecryptfs_send_message(unsigned int transport, char *data, int data_len,
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_id_hash_mux);
-	if (ecryptfs_find_daemon_id(current->euid, &id)) {
+	if (ecryptfs_find_daemon_id(current->act_as->euid, &id)) {
 		mutex_unlock(&ecryptfs_daemon_id_hash_mux);
 		rc = -ENOTCONN;
 		ecryptfs_printk(KERN_ERR, "User [%d] does not have a daemon "
-				"registered\n", current->euid);
+				"registered\n", current->sec->euid);
 		goto out;
 	}
 	mutex_unlock(&ecryptfs_daemon_id_hash_mux);
diff --git a/fs/exec.c b/fs/exec.c
index a09ce1b..da01655 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1000,7 +1000,8 @@ int flush_old_exec(struct linux_binprm * bprm)
 
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
-	if (current->euid == current->uid && current->egid == current->gid)
+	if (current->sec->euid == current->sec->uid &&
+	    current->sec->egid == current->sec->gid)
 		set_dumpable(current->mm, 1);
 	else
 		set_dumpable(current->mm, suid_dumpable);
@@ -1027,7 +1028,8 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 */
 	current->mm->task_size = TASK_SIZE;
 
-	if (bprm->e_uid != current->euid || bprm->e_gid != current->egid) {
+	if (bprm->e_uid != current->sec->euid ||
+	    bprm->e_gid != current->sec->egid) {
 		suid_keys(current);
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
@@ -1069,8 +1071,8 @@ int prepare_binprm(struct linux_binprm *bprm)
 	if (bprm->file->f_op == NULL)
 		return -EACCES;
 
-	bprm->e_uid = current->euid;
-	bprm->e_gid = current->egid;
+	bprm->e_uid = current->sec->euid;
+	bprm->e_gid = current->sec->egid;
 
 	if(!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
 		/* Set-uid? */
@@ -1123,7 +1125,7 @@ void compute_creds(struct linux_binprm *bprm)
 {
 	int unsafe;
 
-	if (bprm->e_uid != current->uid) {
+	if (bprm->e_uid != current->sec->uid) {
 		suid_keys(current);
 		current->pdeath_signal = 0;
 	}
@@ -1441,7 +1443,7 @@ static int format_corename(char *corename, const char *pattern, long signr)
 			/* uid */
 			case 'u':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", current->uid);
+					      "%d", current->sec->uid);
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1449,7 +1451,7 @@ static int format_corename(char *corename, const char *pattern, long signr)
 			/* gid */
 			case 'g':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", current->gid);
+					      "%d", current->sec->gid);
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1707,7 +1709,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 */
 	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
-		current->fsuid = 0;	/* Dump root private */
+		current->act_as->fsuid = 0;	/* Dump root private */
 	}
 
 	retval = coredump_wait(exit_code);
@@ -1803,7 +1805,7 @@ fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
 
-	current->fsuid = fsuid;
+	current->act_as->fsuid = fsuid;
 	complete_all(&mm->core_done);
 fail:
 	return retval;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 920a576..f49733f 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -934,8 +934,8 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 
 	opts->isvfat = is_vfat;
 
-	opts->fs_uid = current->uid;
-	opts->fs_gid = current->gid;
+	opts->fs_uid = current->sec->uid;
+	opts->fs_gid = current->sec->gid;
 	opts->fs_fmask = opts->fs_dmask = current->fs->umask;
 	opts->codepage = fat_default_codepage;
 	opts->iocharset = fat_default_iocharset;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 8685263..35d8f74 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -276,7 +276,8 @@ int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
 	if (err)
 		return err;
 
-	f_modown(filp, pid, type, current->uid, current->euid, force);
+	f_modown(filp, pid, type, current->sec->uid, current->act_as->euid,
+		 force);
 	return 0;
 }
 EXPORT_SYMBOL(__f_setown);
@@ -461,8 +462,8 @@ static inline int sigio_perm(struct task_struct *p,
                              struct fown_struct *fown, int sig)
 {
 	return (((fown->euid == 0) ||
-		 (fown->euid == p->suid) || (fown->euid == p->uid) ||
-		 (fown->uid == p->suid) || (fown->uid == p->uid)) &&
+		 (fown->euid == p->sec->suid) || (fown->euid == p->sec->uid) ||
+		 (fown->uid == p->sec->suid) || (fown->uid == p->sec->uid)) &&
 		!security_file_send_sigiotask(p, fown, sig));
 }
 
diff --git a/fs/file_table.c b/fs/file_table.c
index 664e3f2..e559b50 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -114,8 +114,8 @@ struct file *get_empty_filp(void)
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
-	f->f_uid = tsk->fsuid;
-	f->f_gid = tsk->fsgid;
+	f->f_uid = tsk->act_as->fsuid;
+	f->f_gid = tsk->act_as->fsgid;
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
 	return f;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 80d2f52..0c78b97 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -830,12 +830,12 @@ int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task)
 	if (fc->flags & FUSE_ALLOW_OTHER)
 		return 1;
 
-	if (task->euid == fc->user_id &&
-	    task->suid == fc->user_id &&
-	    task->uid == fc->user_id &&
-	    task->egid == fc->group_id &&
-	    task->sgid == fc->group_id &&
-	    task->gid == fc->group_id)
+	if (task->sec->euid == fc->user_id &&
+	    task->sec->suid == fc->user_id &&
+	    task->sec->uid == fc->user_id &&
+	    task->sec->egid == fc->group_id &&
+	    task->sec->sgid == fc->group_id &&
+	    task->sec->gid == fc->group_id)
 		return 1;
 
 	return 0;
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 16cbd90..54a1d32 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -210,8 +210,8 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
 	int tmp, token;
 
 	/* initialize the sb with defaults */
-	hsb->s_uid = current->uid;
-	hsb->s_gid = current->gid;
+	hsb->s_uid = current->sec->uid;
+	hsb->s_gid = current->sec->gid;
 	hsb->s_file_umask = 0133;
 	hsb->s_dir_umask = 0022;
 	hsb->s_type = hsb->s_creator = cpu_to_be32(0x3f3f3f3f);	/* == '????' */
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index dc64fac..fa5e015 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -49,8 +49,8 @@ void hfsplus_fill_defaults(struct hfsplus_sb_info *opts)
 	opts->creator = HFSPLUS_DEF_CR_TYPE;
 	opts->type = HFSPLUS_DEF_CR_TYPE;
 	opts->umask = current->fs->umask;
-	opts->uid = current->uid;
-	opts->gid = current->gid;
+	opts->uid = current->sec->uid;
+	opts->gid = current->sec->gid;
 	opts->part = -1;
 	opts->session = -1;
 }
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 00971d9..cf4c6b5 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -464,8 +464,8 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 
 	init_MUTEX(&sbi->hpfs_creation_de);
 
-	uid = current->uid;
-	gid = current->gid;
+	uid = current->sec->uid;
+	gid = current->sec->gid;
 	umask = current->fs->umask;
 	lowercase = 0;
 	conv = CONV_BINARY;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 39ad919..1e4d411 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -921,7 +921,7 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
 	if (!can_do_hugetlb_shm())
 		return ERR_PTR(-EPERM);
 
-	if (!user_shm_lock(size, current->user))
+	if (!user_shm_lock(size, current->sec->user))
 		return ERR_PTR(-ENOMEM);
 
 	root = hugetlbfs_vfsmount->mnt_root;
@@ -960,7 +960,7 @@ out_inode:
 out_dentry:
 	dput(dentry);
 out_shm_unlock:
-	user_shm_unlock(size, current->user);
+	user_shm_unlock(size, current->sec->user);
 	return ERR_PTR(error);
 }
 
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 5e00933..6d68f3e 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -558,7 +558,7 @@ asmlinkage long sys_inotify_init(void)
 		goto out_put_fd;
 	}
 
-	user = get_uid(current->user);
+	user = get_uid(current->sec->user);
 	if (unlikely(atomic_read(&user->inotify_devs) >=
 			inotify_max_user_instances)) {
 		ret = -EMFILE;
diff --git a/fs/ioprio.c b/fs/ioprio.c
index e4e01bc..5392a60 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -32,8 +32,8 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
 	int err;
 	struct io_context *ioc;
 
-	if (task->uid != current->euid &&
-	    task->uid != current->uid && !capable(CAP_SYS_NICE))
+	if (task->sec->uid != current->act_as->euid &&
+	    task->sec->uid != current->act_as->uid && !capable(CAP_SYS_NICE))
 		return -EPERM;
 
 	err = security_task_setioprio(task, ioprio);
@@ -115,7 +115,7 @@ asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
-				user = current->user;
+				user = current->sec->user;
 			else
 				user = find_user(who);
 
@@ -123,7 +123,7 @@ asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 				break;
 
 			do_each_thread(g, p) {
-				if (p->uid != who)
+				if (p->sec->uid != who)
 					continue;
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
@@ -206,7 +206,7 @@ asmlinkage long sys_ioprio_get(int which, int who)
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
-				user = current->user;
+				user = current->sec->user;
 			else
 				user = find_user(who);
 
@@ -214,7 +214,7 @@ asmlinkage long sys_ioprio_get(int which, int who)
 				break;
 
 			do_each_thread(g, p) {
-				if (p->uid != user->uid)
+				if (p->sec->uid != user->uid)
 					continue;
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
diff --git a/fs/namei.c b/fs/namei.c
index b07ae67..f121975 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1433,11 +1433,13 @@ int fastcall __user_walk(const char __user *name, unsigned flags, struct nameida
  */
 static inline int check_sticky(struct inode *dir, struct inode *inode)
 {
+	uid_t fsuid = current->act_as->fsuid;
+
 	if (!(dir->i_mode & S_ISVTX))
 		return 0;
-	if (inode->i_uid == current_fsuid())
+	if (inode->i_uid == fsuid)
 		return 0;
-	if (dir->i_uid == current_fsuid())
+	if (dir->i_uid == fsuid)
 		return 0;
 	return !capable(CAP_FOWNER);
 }
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index c67b4bd..5f1adaf 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -40,7 +40,7 @@ ncp_get_fs_info(struct ncp_server * server, struct file *file,
 	struct ncp_fs_info info;
 
 	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	    && (current->act_as->uid != server->m.mounted_uid)) {
 		return -EACCES;
 	}
 	if (copy_from_user(&info, arg, sizeof(info)))
@@ -70,7 +70,7 @@ ncp_get_fs_info_v2(struct ncp_server * server, struct file *file,
 	struct ncp_fs_info_v2 info2;
 
 	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	    && (current->act_as->uid != server->m.mounted_uid)) {
 		return -EACCES;
 	}
 	if (copy_from_user(&info2, arg, sizeof(info2)))
@@ -141,7 +141,7 @@ ncp_get_compat_fs_info_v2(struct ncp_server * server, struct file *file,
 	struct compat_ncp_fs_info_v2 info2;
 
 	if ((file_permission(file, MAY_WRITE) != 0)
-	    && (current->uid != server->m.mounted_uid)) {
+	    && (current->act_as->uid != server->m.mounted_uid)) {
 		return -EACCES;
 	}
 	if (copy_from_user(&info2, arg, sizeof(info2)))
@@ -276,7 +276,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 #endif
 	case NCP_IOC_NCPREQUEST:
 		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid)) {
+		    && (current->act_as->uid != server->m.mounted_uid)) {
 			return -EACCES;
 		}
 #ifdef CONFIG_COMPAT
@@ -356,7 +356,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 	case NCP_IOC_GETMOUNTUID32:
 	case NCP_IOC_GETMOUNTUID64:
 		if ((file_permission(filp, MAY_READ) != 0)
-			&& (current->uid != server->m.mounted_uid)) {
+			&& (current->act_as->uid != server->m.mounted_uid)) {
 			return -EACCES;
 		}
 		if (cmd == NCP_IOC_GETMOUNTUID16) {
@@ -380,7 +380,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 			struct ncp_setroot_ioctl sr;
 
 			if ((file_permission(filp, MAY_READ) != 0)
-			    && (current->uid != server->m.mounted_uid))
+			    && (current->act_as->uid != server->m.mounted_uid))
 			{
 				return -EACCES;
 			}
@@ -455,7 +455,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 #ifdef CONFIG_NCPFS_PACKET_SIGNING	
 	case NCP_IOC_SIGN_INIT:
 		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid))
+		    && (current->act_as->uid != server->m.mounted_uid))
 		{
 			return -EACCES;
 		}
@@ -478,7 +478,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 		
         case NCP_IOC_SIGN_WANTED:
 		if ((file_permission(filp, MAY_READ) != 0)
-		    && (current->uid != server->m.mounted_uid))
+		    && (current->act_as->uid != server->m.mounted_uid))
 		{
 			return -EACCES;
 		}
@@ -491,7 +491,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 			int newstate;
 
 			if ((file_permission(filp, MAY_WRITE) != 0)
-			    && (current->uid != server->m.mounted_uid))
+			    && (current->act_as->uid != server->m.mounted_uid))
 			{
 				return -EACCES;
 			}
@@ -512,7 +512,7 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 #ifdef CONFIG_NCPFS_IOCTL_LOCKING
 	case NCP_IOC_LOCKUNLOCK:
 		if ((file_permission(filp, MAY_WRITE) != 0)
-		    && (current->uid != server->m.mounted_uid))
+		    && (current->act_as->uid != server->m.mounted_uid))
 		{
 			return -EACCES;
 		}
@@ -585,7 +585,7 @@ outrel:
 
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_GETOBJECTNAME_32:
-		if (current->uid != server->m.mounted_uid) {
+		if (current->act_as->uid != server->m.mounted_uid) {
 			return -EACCES;
 		}
 		{
@@ -610,7 +610,7 @@ outrel:
 		}
 #endif
 	case NCP_IOC_GETOBJECTNAME:
-		if (current->uid != server->m.mounted_uid) {
+		if (current->act_as->uid != server->m.mounted_uid) {
 			return -EACCES;
 		}
 		{
@@ -637,7 +637,7 @@ outrel:
 	case NCP_IOC_SETOBJECTNAME_32:
 #endif
 	case NCP_IOC_SETOBJECTNAME:
-		if (current->uid != server->m.mounted_uid) {
+		if (current->act_as->uid != server->m.mounted_uid) {
 			return -EACCES;
 		}
 		{
@@ -695,7 +695,7 @@ outrel:
 	case NCP_IOC_GETPRIVATEDATA_32:
 #endif
 	case NCP_IOC_GETPRIVATEDATA:
-		if (current->uid != server->m.mounted_uid) {
+		if (current->act_as->uid != server->m.mounted_uid) {
 			return -EACCES;
 		}
 		{
@@ -740,7 +740,7 @@ outrel:
 	case NCP_IOC_SETPRIVATEDATA_32:
 #endif
 	case NCP_IOC_SETPRIVATEDATA:
-		if (current->uid != server->m.mounted_uid) {
+		if (current->act_as->uid != server->m.mounted_uid) {
 			return -EACCES;
 		}
 		{
@@ -795,7 +795,7 @@ outrel:
 
 	case NCP_IOC_SETDENTRYTTL:
 		if ((file_permission(filp, MAY_WRITE) != 0) &&
-				 (current->uid != server->m.mounted_uid))
+		    current->act_as->uid != server->m.mounted_uid)
 			return -EACCES;
 		{
 			u_int32_t user;
diff --git a/fs/open.c b/fs/open.c
index 4932b4d..6d7a29c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -428,12 +428,12 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
 
-	old_fsuid = current->fsuid;
-	old_fsgid = current->fsgid;
-	old_cap = current->cap_effective;
+	old_fsuid = current->act_as->fsuid;
+	old_fsgid = current->act_as->fsgid;
+	old_cap = current->act_as->cap_effective;
 
-	current->fsuid = current->uid;
-	current->fsgid = current->gid;
+	current->act_as->fsuid = current->act_as->uid;
+	current->act_as->fsgid = current->act_as->gid;
 
 	/*
 	 * Clear the capabilities if we switch to a non-root user
@@ -443,10 +443,10 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	 * value below.  We should hold task_capabilities_lock,
 	 * but we cannot because user_path_walk can sleep.
 	 */
-	if (current->uid)
-		cap_clear(current->cap_effective);
+	if (current->act_as->uid)
+		cap_clear(current->act_as->cap_effective);
 	else
-		current->cap_effective = current->cap_permitted;
+		current->act_as->cap_effective = current->act_as->cap_permitted;
 
 	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
 	if (res)
@@ -464,9 +464,9 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 out_path_release:
 	path_release(&nd);
 out:
-	current->fsuid = old_fsuid;
-	current->fsgid = old_fsgid;
-	current->cap_effective = old_cap;
+	current->act_as->fsuid = old_fsuid;
+	current->act_as->fsgid = old_fsgid;
+	current->act_as->cap_effective = old_cap;
 
 	return res;
 }
diff --git a/fs/proc/array.c b/fs/proc/array.c
index eb97f28..595fe90 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -182,8 +182,8 @@ static inline char *task_state(struct task_struct *p, char *buffer)
 		task_tgid_nr_ns(p, ns),
 		task_pid_nr_ns(p, ns),
 		ppid, tpid,
-		p->uid, p->euid, p->suid, p->fsuid,
-		p->gid, p->egid, p->sgid, p->fsgid);
+		p->sec->uid, p->sec->euid, p->sec->suid, p->sec->fsuid,
+		p->sec->gid, p->sec->egid, p->sec->sgid, p->sec->fsgid);
 
 	task_lock(p);
 	if (p->files)
@@ -194,7 +194,7 @@ static inline char *task_state(struct task_struct *p, char *buffer)
 		fdt ? fdt->max_fds : 0);
 	rcu_read_unlock();
 
-	group_info = p->group_info;
+	group_info = p->sec->group_info;
 	get_group_info(group_info);
 	task_unlock(p);
 
@@ -267,7 +267,7 @@ static inline char *task_sig(struct task_struct *p, char *buffer)
 		blocked = p->blocked;
 		collect_sigign_sigcatch(p, &ignored, &caught);
 		num_threads = atomic_read(&p->signal->count);
-		qsize = atomic_read(&p->user->sigpending);
+		qsize = atomic_read(&p->sec->user->sigpending);
 		qlim = p->signal->rlim[RLIMIT_SIGPENDING].rlim_cur;
 		unlock_task_sighand(p, &flags);
 	}
@@ -291,9 +291,9 @@ static inline char *task_cap(struct task_struct *p, char *buffer)
     return buffer + sprintf(buffer, "CapInh:\t%016x\n"
 			    "CapPrm:\t%016x\n"
 			    "CapEff:\t%016x\n",
-			    cap_t(p->cap_inheritable),
-			    cap_t(p->cap_permitted),
-			    cap_t(p->cap_effective));
+			    cap_t(p->sec->cap_inheritable),
+			    cap_t(p->sec->cap_permitted),
+			    cap_t(p->sec->cap_effective));
 }
 
 static inline char *task_context_switch_counts(struct task_struct *p,
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7411bfb..43e3782 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1201,8 +1201,8 @@ static struct inode *proc_pid_make_inode(struct super_block * sb, struct task_st
 	inode->i_uid = 0;
 	inode->i_gid = 0;
 	if (task_dumpable(task)) {
-		inode->i_uid = task->euid;
-		inode->i_gid = task->egid;
+		inode->i_uid = task->sec->euid;
+		inode->i_gid = task->sec->egid;
 	}
 	security_task_to_inode(task, inode);
 
@@ -1227,8 +1227,8 @@ static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat
 	if (task) {
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
-			stat->uid = task->euid;
-			stat->gid = task->egid;
+			stat->uid = task->sec->euid;
+			stat->gid = task->sec->egid;
 		}
 	}
 	rcu_read_unlock();
@@ -1259,8 +1259,8 @@ static int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
 	if (task) {
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
-			inode->i_uid = task->euid;
-			inode->i_gid = task->egid;
+			inode->i_uid = task->sec->euid;
+			inode->i_gid = task->sec->egid;
 		} else {
 			inode->i_uid = 0;
 			inode->i_gid = 0;
@@ -1433,8 +1433,8 @@ static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
 				rcu_read_unlock();
 				put_files_struct(files);
 				if (task_dumpable(task)) {
-					inode->i_uid = task->euid;
-					inode->i_gid = task->egid;
+					inode->i_uid = task->sec->euid;
+					inode->i_gid = task->sec->egid;
 				} else {
 					inode->i_uid = 0;
 					inode->i_gid = 0;
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 4e57fcf..e4ddfdb 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -393,9 +393,9 @@ static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *
 	error = -EACCES;
 	mode = inode->i_mode;
 
-	if (current->euid == 0)
+	if (current->act_as->euid == 0)
 		mode >>= 6;
-	else if (in_group_p(0))
+	else if (in_egroup_p(0))
 		mode >>= 3;
 
 	if ((mode & mask & (MAY_READ|MAY_WRITE|MAY_EXEC)) == mask)
diff --git a/fs/quota.c b/fs/quota.c
index 99b24b5..ab4f1d9 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -80,7 +80,7 @@ static int generic_quotactl_valid(struct super_block *sb, int type, int cmd, qid
 
 	/* Check privileges */
 	if (cmd == Q_GETQUOTA) {
-		if (((type == USRQUOTA && current->euid != id) ||
+		if (((type == USRQUOTA && current->act_as->euid != id) ||
 		     (type == GRPQUOTA && !in_egroup_p(id))) &&
 		    !capable(CAP_SYS_ADMIN))
 			return -EPERM;
@@ -131,7 +131,7 @@ static int xqm_quotactl_valid(struct super_block *sb, int type, int cmd, qid_t i
 
 	/* Check privileges */
 	if (cmd == Q_XGETQUOTA) {
-		if (((type == XQM_USRQUOTA && current->euid != id) ||
+		if (((type == XQM_USRQUOTA && current->act_as->euid != id) ||
 		     (type == XQM_GRPQUOTA && !in_egroup_p(id))) &&
 		     !capable(CAP_SYS_ADMIN))
 			return -EPERM;
diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
index 48da4fa..53e03a3 100644
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -667,8 +667,8 @@ smb_make_node(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 
 	attr.ia_valid = ATTR_MODE | ATTR_UID | ATTR_GID;
 	attr.ia_mode = mode;
-	attr.ia_uid = current->euid;
-	attr.ia_gid = current->egid;
+	attr.ia_uid = current->act_as->euid;
+	attr.ia_gid = current->act_as->egid;
 
 	if (!new_valid_dev(dev))
 		return -EINVAL;
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index 9416ead..95a2455 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -579,7 +579,7 @@ static int smb_fill_super(struct super_block *sb, void *raw_data, int silent)
 		if (parse_options(mnt, raw_data))
 			goto out_bad_option;
 	}
-	mnt->mounted_uid = current->uid;
+	mnt->mounted_uid = current->act_as->uid;
 	smb_setcodepage(server, &mnt->codepage);
 
 	/*
diff --git a/fs/smbfs/proc.c b/fs/smbfs/proc.c
index d517a27..a55d9cd 100644
--- a/fs/smbfs/proc.c
+++ b/fs/smbfs/proc.c
@@ -865,7 +865,7 @@ smb_newconn(struct smb_sb_info *server, struct smb_conn_opt *opt)
 		goto out;
 
 	error = -EACCES;
-	if (current->uid != server->mnt->mounted_uid && 
+	if (current->act_as->uid != server->mnt->mounted_uid &&
 	    !capable(CAP_SYS_ADMIN))
 		goto out;
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index cae35b6..6fa8413 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -114,6 +114,20 @@ extern struct group_info init_groups;
 	.pid = &init_struct_pid,				\
 }
 
+extern struct task_security init_task_security;
+
+#define INIT_TASK_SECURITY(p)					\
+{								\
+	.usage			= ATOMIC_INIT(3),		\
+	.keep_capabilities	= 0,				\
+	.cap_inheritable	= CAP_INIT_INH_SET,		\
+	.cap_permitted		= CAP_FULL_SET,			\
+	.cap_effective		= CAP_INIT_EFF_SET,		\
+	.user			= INIT_USER,			\
+	.group_info		= &init_groups,			\
+	.lock			= __SPIN_LOCK_UNLOCKED(p.lock),	\
+}
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -143,12 +157,9 @@ extern struct group_info init_groups;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	.group_info	= &init_groups,					\
-	.cap_effective	= CAP_INIT_EFF_SET,				\
-	.cap_inheritable = CAP_INIT_INH_SET,				\
-	.cap_permitted	= CAP_FULL_SET,					\
-	.keep_capabilities = 0,						\
-	.user		= INIT_USER,					\
+	.__temp_sec	= INIT_TASK_SECURITY(tsk.__temp_sec),		\
+	.sec		= &tsk.__temp_sec,				\
+	.act_as		= &tsk.__temp_sec,				\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c500e4c..de7ae87 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -570,6 +570,63 @@ extern struct user_struct *find_user(uid_t);
 extern struct user_struct root_user;
 #define INIT_USER (&root_user)
 
+
+/*
+ * The security context of a task
+ *
+ * The parts of the context break down into two categories:
+ *
+ *  (1) The objective context of a task.  These parts are used when some other
+ *	task is attempting to affect this one.
+ *
+ *  (2) The subjective context.  These details are used when the task is acting
+ *	upon another object, be that a file, a task, a key or whatever.
+ *
+ * Note that some members of this structure belong to both categories - the
+ * LSM security pointer for instance.
+ *
+ * A task has two security pointers.  task->sec points to the objective context
+ * that defines that task's actual details.  The objective part of this context
+ * is used whenever that task is acted upon.
+ *
+ * task->act_as points to the subjective context that defines the details of
+ * how that task is going to act upon another object.  This may be overridden
+ * temporarily to point to another security context, but normally points to the
+ * same context as task->sec.
+ */
+struct task_security {
+	atomic_t	usage;
+	uid_t		uid;		/* real UID of the task */
+	gid_t		gid;		/* real GID of the task */
+	uid_t		suid;		/* saved UID of the task */
+	gid_t		sgid;		/* saved GID of the task */
+	uid_t		euid;		/* effective UID of the task */
+	gid_t		egid;		/* effective GID of the task */
+	uid_t		fsuid;		/* UID for VFS ops */
+	gid_t		fsgid;		/* GID for VFS ops */
+	unsigned	keep_capabilities:1;
+	kernel_cap_t	cap_inheritable; /* caps our children can inherit */
+	kernel_cap_t	cap_permitted;	/* caps we're permitted */
+	kernel_cap_t	cap_effective;	/* caps we can actually use */
+#ifdef CONFIG_KEYS
+	unsigned char	jit_keyring;	/* default keyring to attach requested
+					 * keys to */
+	struct key	*thread_keyring; /* keyring private to this thread */
+	struct key	*request_key_auth; /* assumed request_key authority */
+#endif
+#ifdef CONFIG_SECURITY
+	void		*security;	/* subjective LSM security */
+#endif
+	struct user_struct *user;	/* real user ID subscription */
+	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
+	spinlock_t	lock;		/* lock for pointer changes */
+};
+
+#define current_fsuid() (current->act_as->fsuid)
+#define current_fsgid() (current->act_as->fsgid)
+#define current_cap()	(current->act_as->cap_effective)
+
+
 struct backing_dev_info;
 struct reclaim_state;
 
@@ -1025,17 +1082,10 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	uid_t uid,euid,suid,fsuid;
-	gid_t gid,egid,sgid,fsgid;
-	struct group_info *group_info;
-	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted;
-	unsigned keep_capabilities:1;
-	struct user_struct *user;
-#ifdef CONFIG_KEYS
-	struct key *request_key_auth;	/* assumed request_key authority */
-	struct key *thread_keyring;	/* keyring private to this thread */
-	unsigned char jit_keyring;	/* default keyring to attach requested keys to */
-#endif
+	struct task_security __temp_sec __deprecated; /* temporary security to be removed */
+	struct task_security *sec;	/* actual/objective task security */
+	struct task_security *act_as;	/* effective/subjective task security */
+
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
 				       it with task_lock())
@@ -1067,9 +1117,6 @@ struct task_struct {
 	int (*notifier)(void *priv);
 	void *notifier_data;
 	sigset_t *notifier_mask;
-#ifdef CONFIG_SECURITY
-	void *security;
-#endif
 	struct audit_context *audit_context;
 	seccomp_t seccomp;
 
@@ -1180,9 +1227,6 @@ struct task_struct {
 	struct prop_local_single dirties;
 };
 
-#define current_fsuid() (current->fsuid)
-#define current_fsgid() (current->fsgid)
-
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
diff --git a/include/net/scm.h b/include/net/scm.h
index 06df126..b133114 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -54,8 +54,8 @@ static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
 			       struct scm_cookie *scm)
 {
 	struct task_struct *p = current;
-	scm->creds.uid = p->uid;
-	scm->creds.gid = p->gid;
+	scm->creds.uid = p->sec->uid;
+	scm->creds.gid = p->sec->gid;
 	scm->creds.pid = task_tgid_vnr(p);
 	scm->fp = NULL;
 	scm->seq = 0;
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 590045a..43a3228 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -118,7 +118,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb, int mode,
 		if (S_ISREG(mode)) {
 			struct mqueue_inode_info *info;
 			struct task_struct *p = current;
-			struct user_struct *u = p->user;
+			struct user_struct *u = p->sec->user;
 			unsigned long mq_bytes, mq_msg_tblsz;
 
 			inode->i_fop = &mqueue_file_operations;
@@ -511,7 +511,7 @@ static void __do_notify(struct mqueue_inode_info *info)
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
 			sig_i.si_pid = task_pid_vnr(current);
-			sig_i.si_uid = current->uid;
+			sig_i.si_uid = current->act_as->uid;
 
 			kill_pid_info(info->notify.sigev_signo,
 				      &sig_i, info->notify_owner);
diff --git a/ipc/msg.c b/ipc/msg.c
index fdf3db5..83c7a29 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -551,8 +551,8 @@ asmlinkage long sys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
 	}
 
 	err = -EPERM;
-	if (current->euid != ipcp->cuid &&
-	    current->euid != ipcp->uid && !capable(CAP_SYS_ADMIN))
+	if (current->act_as->euid != ipcp->cuid &&
+	    current->act_as->euid != ipcp->uid && !capable(CAP_SYS_ADMIN))
 		/* We _could_ check for CAP_CHOWN above, but we don't */
 		goto out_unlock_up;
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 35952c0..35736f5 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -924,8 +924,8 @@ static int semctl_down(struct ipc_namespace *ns, int semid, int semnum,
 		if (err)
 			goto out_unlock;
 	}
-	if (current->euid != ipcp->cuid && 
-	    current->euid != ipcp->uid && !capable(CAP_SYS_ADMIN)) {
+	if (current->act_as->euid != ipcp->cuid &&
+	    current->act_as->euid != ipcp->uid && !capable(CAP_SYS_ADMIN)) {
 	    	err=-EPERM;
 		goto out_unlock;
 	}
diff --git a/ipc/shm.c b/ipc/shm.c
index 3818fae..89e232e 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -417,7 +417,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	if (shmflg & SHM_HUGETLB) {
 		/* hugetlb_file_setup takes care of mlock user accounting */
 		file = hugetlb_file_setup(name, size);
-		shp->mlock_user = current->user;
+		shp->mlock_user = current->sec->user;
 	} else {
 		int acctflag = VM_ACCOUNT;
 		/*
@@ -770,8 +770,8 @@ asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 
 		if (!capable(CAP_IPC_LOCK)) {
 			err = -EPERM;
-			if (current->euid != shp->shm_perm.uid &&
-			    current->euid != shp->shm_perm.cuid)
+			if (current->act_as->euid != shp->shm_perm.uid &&
+			    current->act_as->euid != shp->shm_perm.cuid)
 				goto out_unlock;
 			if (cmd == SHM_LOCK &&
 			    !current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
@@ -783,7 +783,7 @@ asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 			goto out_unlock;
 		
 		if(cmd==SHM_LOCK) {
-			struct user_struct * user = current->user;
+			struct user_struct *user = current->act_as->user;
 			if (!is_file_hugepages(shp->shm_file)) {
 				err = shmem_lock(shp->shm_file, 1, user);
 				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
@@ -822,8 +822,8 @@ asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 		if (err)
 			goto out_unlock_up;
 
-		if (current->euid != shp->shm_perm.uid &&
-		    current->euid != shp->shm_perm.cuid && 
+		if (current->act_as->euid != shp->shm_perm.uid &&
+		    current->act_as->euid != shp->shm_perm.cuid &&
 		    !capable(CAP_SYS_ADMIN)) {
 			err=-EPERM;
 			goto out_unlock_up;
@@ -862,8 +862,8 @@ asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 		if (err)
 			goto out_unlock_up;
 		err=-EPERM;
-		if (current->euid != shp->shm_perm.uid &&
-		    current->euid != shp->shm_perm.cuid && 
+		if (current->act_as->euid != shp->shm_perm.uid &&
+		    current->act_as->euid != shp->shm_perm.cuid &&
 		    !capable(CAP_SYS_ADMIN)) {
 			goto out_unlock_up;
 		}
diff --git a/ipc/util.c b/ipc/util.c
index 1aa0ebf..fc22a9c 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -283,8 +283,8 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 
 	ids->in_use++;
 
-	new->cuid = new->uid = current->euid;
-	new->gid = new->cgid = current->egid;
+	new->cuid = new->uid = current->act_as->euid;
+	new->gid = new->cgid = current->act_as->egid;
 
 	new->seq = ids->seq++;
 	if(ids->seq > ids->seq_max)
@@ -632,7 +632,8 @@ int ipcperms (struct kern_ipc_perm *ipcp, short flag)
 		return err;
 	requested_mode = (flag >> 6) | (flag >> 3) | flag;
 	granted_mode = ipcp->mode;
-	if (current->euid == ipcp->cuid || current->euid == ipcp->uid)
+	if (current->act_as->euid == ipcp->cuid ||
+	    current->act_as->euid == ipcp->uid)
 		granted_mode >>= 6;
 	else if (in_group_p(ipcp->cgid) || in_group_p(ipcp->gid))
 		granted_mode >>= 3;
diff --git a/kernel/acct.c b/kernel/acct.c
index 521dfa5..f2d1783 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -470,15 +470,15 @@ static void do_acct_process(struct file *file)
 	do_div(elapsed, AHZ);
 	ac.ac_btime = get_seconds() - elapsed;
 	/* we really need to bite the bullet and change layout */
-	ac.ac_uid = current->uid;
-	ac.ac_gid = current->gid;
+	ac.ac_uid = current->sec->uid;
+	ac.ac_gid = current->sec->gid;
 #if ACCT_VERSION==2
 	ac.ac_ahz = AHZ;
 #endif
 #if ACCT_VERSION==1 || ACCT_VERSION==2
 	/* backward-compatible 16 bit fields */
-	ac.ac_uid16 = current->uid;
-	ac.ac_gid16 = current->gid;
+	ac.ac_uid16 = current->sec->uid;
+	ac.ac_gid16 = current->sec->gid;
 #endif
 #if ACCT_VERSION==3
 	ac.ac_pid = current->tgid;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index bce9ecd..46fe72a 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -394,6 +394,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 			      struct audit_names *name,
 			      enum audit_state *state)
 {
+	struct task_security *sec = tsk->sec;
 	int i, j, need_sid = 1;
 	u32 sid;
 
@@ -413,28 +414,28 @@ static int audit_filter_rules(struct task_struct *tsk,
 			}
 			break;
 		case AUDIT_UID:
-			result = audit_comparator(tsk->uid, f->op, f->val);
+			result = audit_comparator(sec->uid, f->op, f->val);
 			break;
 		case AUDIT_EUID:
-			result = audit_comparator(tsk->euid, f->op, f->val);
+			result = audit_comparator(sec->euid, f->op, f->val);
 			break;
 		case AUDIT_SUID:
-			result = audit_comparator(tsk->suid, f->op, f->val);
+			result = audit_comparator(sec->suid, f->op, f->val);
 			break;
 		case AUDIT_FSUID:
-			result = audit_comparator(tsk->fsuid, f->op, f->val);
+			result = audit_comparator(sec->fsuid, f->op, f->val);
 			break;
 		case AUDIT_GID:
-			result = audit_comparator(tsk->gid, f->op, f->val);
+			result = audit_comparator(sec->gid, f->op, f->val);
 			break;
 		case AUDIT_EGID:
-			result = audit_comparator(tsk->egid, f->op, f->val);
+			result = audit_comparator(sec->egid, f->op, f->val);
 			break;
 		case AUDIT_SGID:
-			result = audit_comparator(tsk->sgid, f->op, f->val);
+			result = audit_comparator(sec->sgid, f->op, f->val);
 			break;
 		case AUDIT_FSGID:
-			result = audit_comparator(tsk->fsgid, f->op, f->val);
+			result = audit_comparator(sec->fsgid, f->op, f->val);
 			break;
 		case AUDIT_PERS:
 			result = audit_comparator(tsk->personality, f->op, f->val);
@@ -997,6 +998,7 @@ static void audit_log_execve_info(struct audit_buffer *ab,
 
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
+	struct task_security *sec = tsk->sec;
 	int i, call_panic = 0;
 	struct audit_buffer *ab;
 	struct audit_aux_data *aux;
@@ -1006,14 +1008,14 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	context->pid = tsk->pid;
 	if (!context->ppid)
 		context->ppid = sys_getppid();
-	context->uid = tsk->uid;
-	context->gid = tsk->gid;
-	context->euid = tsk->euid;
-	context->suid = tsk->suid;
-	context->fsuid = tsk->fsuid;
-	context->egid = tsk->egid;
-	context->sgid = tsk->sgid;
-	context->fsgid = tsk->fsgid;
+	context->uid = sec->uid;
+	context->gid = sec->gid;
+	context->euid = sec->euid;
+	context->suid = sec->suid;
+	context->fsuid = sec->fsuid;
+	context->egid = sec->egid;
+	context->sgid = sec->sgid;
+	context->fsgid = sec->fsgid;
 	context->personality = tsk->personality;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_SYSCALL);
@@ -1788,7 +1790,7 @@ int audit_set_loginuid(struct task_struct *task, uid_t loginuid)
 			if (ab) {
 				audit_log_format(ab, "login pid=%d uid=%u "
 					"old auid=%u new auid=%u",
-					task->pid, task->uid,
+					task->pid, task->sec->uid,
 					context->loginuid, loginuid);
 				audit_log_end(ab);
 			}
@@ -2219,7 +2221,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 			if (ctx)
 				audit_sig_uid = ctx->loginuid;
 			else
-				audit_sig_uid = tsk->uid;
+				audit_sig_uid = tsk->sec->uid;
 			selinux_get_task_sid(tsk, &audit_sig_sid);
 		}
 		if (!audit_signals || audit_dummy_context())
@@ -2274,7 +2276,7 @@ void audit_core_dumps(long signr)
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
 	audit_log_format(ab, "auid=%u uid=%u gid=%u",
 			audit_get_loginuid(current->audit_context),
-			current->uid, current->gid);
+			current->sec->uid, current->sec->gid);
 	selinux_get_task_sid(current, &sid);
 	if (sid) {
 		char *ctx = NULL;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1b85df5..0016012 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1247,8 +1247,9 @@ static int attach_task_by_pid(struct cgroup *cgrp, char *pidbuf)
 		get_task_struct(tsk);
 		rcu_read_unlock();
 
-		if ((current->euid) && (current->euid != tsk->uid)
-		    && (current->euid != tsk->suid)) {
+		if (current->act_as->euid &&
+		    current->act_as->euid != tsk->sec->uid &&
+		    current->act_as->euid != tsk->sec->suid) {
 			put_task_struct(tsk);
 			return -EACCES;
 		}
diff --git a/kernel/exit.c b/kernel/exit.c
index 549c055..d793e22 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -147,7 +147,7 @@ void release_task(struct task_struct * p)
 	struct task_struct *leader;
 	int zap_leader;
 repeat:
-	atomic_dec(&p->user->processes);
+	atomic_dec(&p->sec->user->processes);
 	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
 	ptrace_unlink(p);
@@ -1198,7 +1198,7 @@ static int wait_task_zombie(struct task_struct *p, int noreap,
 
 	if (unlikely(noreap)) {
 		pid_t pid = task_pid_nr_ns(p, ns);
-		uid_t uid = p->uid;
+		uid_t uid = p->sec->uid;
 		int exit_code = p->exit_code;
 		int why, status;
 
@@ -1318,7 +1318,7 @@ static int wait_task_zombie(struct task_struct *p, int noreap,
 	if (!retval && infop)
 		retval = put_user(task_pid_nr_ns(p, ns), &infop->si_pid);
 	if (!retval && infop)
-		retval = put_user(p->uid, &infop->si_uid);
+		retval = put_user(p->sec->uid, &infop->si_uid);
 	if (!retval)
 		retval = task_pid_nr_ns(p, ns);
 
@@ -1381,7 +1381,7 @@ static int wait_task_stopped(struct task_struct *p, int delayed_group_leader,
 	read_unlock(&tasklist_lock);
 
 	if (unlikely(noreap)) {
-		uid_t uid = p->uid;
+		uid_t uid = p->sec->uid;
 		int why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 
 		exit_code = p->exit_code;
@@ -1452,7 +1452,7 @@ bail_ref:
 	if (!retval && infop)
 		retval = put_user(pid, &infop->si_pid);
 	if (!retval && infop)
-		retval = put_user(p->uid, &infop->si_uid);
+		retval = put_user(p->sec->uid, &infop->si_uid);
 	if (!retval)
 		retval = pid;
 	put_task_struct(p);
@@ -1491,7 +1491,7 @@ static int wait_task_continued(struct task_struct *p, int noreap,
 
 	ns = current->nsproxy->pid_ns;
 	pid = task_pid_nr_ns(p, ns);
-	uid = p->uid;
+	uid = p->sec->uid;
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 8dd8ff2..6caab9a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -122,8 +122,8 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(tsk == current);
 
 	security_task_free(tsk);
-	free_uid(tsk->user);
-	put_group_info(tsk->group_info);
+	free_uid(tsk->__temp_sec.user);
+	put_group_info(tsk->__temp_sec.group_info);
 	delayacct_tsk_free(tsk);
 
 	if (!profile_handoff_task(tsk))
@@ -1014,17 +1014,18 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
+	p->act_as = p->sec = &p->__temp_sec;
 	retval = -EAGAIN;
-	if (atomic_read(&p->user->processes) >=
+	if (atomic_read(&p->sec->user->processes) >=
 			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
-		    p->user != current->nsproxy->user_ns->root_user)
+		    p->sec->user != current->nsproxy->user_ns->root_user)
 			goto bad_fork_free;
 	}
 
-	atomic_inc(&p->user->__count);
-	atomic_inc(&p->user->processes);
-	get_group_info(p->group_info);
+	atomic_inc(&p->sec->user->__count);
+	atomic_inc(&p->sec->user->processes);
+	get_group_info(p->sec->group_info);
 
 	/*
 	 * If multiple threads are within copy_process(), then this check
@@ -1080,7 +1081,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
 #ifdef CONFIG_SECURITY
-	p->security = NULL;
+	p->sec->security = NULL;
 #endif
 	p->io_context = NULL;
 	p->audit_context = NULL;
@@ -1350,9 +1351,9 @@ bad_fork_cleanup_cgroup:
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-	put_group_info(p->group_info);
-	atomic_dec(&p->user->processes);
-	free_uid(p->user);
+	put_group_info(p->sec->group_info);
+	atomic_dec(&p->sec->user->processes);
+	free_uid(p->sec->user);
 bad_fork_free:
 	free_task(p);
 fork_out:
diff --git a/kernel/futex.c b/kernel/futex.c
index db9824d..169bf75 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -444,7 +444,8 @@ static struct task_struct * futex_find_get_task(pid_t pid)
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
-	if (!p || ((current->euid != p->euid) && (current->euid != p->uid)))
+	if (!p || (current->act_as->euid != p->sec->euid &&
+		   current->act_as->euid != p->sec->uid))
 		p = ERR_PTR(-ESRCH);
 	else
 		get_task_struct(p);
@@ -1889,8 +1890,9 @@ sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
-		if ((current->euid != p->euid) && (current->euid != p->uid) &&
-				!capable(CAP_SYS_PTRACE))
+		if (current->act_as->euid != p->sec->euid &&
+		    current->act_as->euid != p->sec->uid &&
+		    !capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->robust_list;
 		rcu_read_unlock();
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 0a43def..ae41737 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -141,8 +141,9 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
-		if ((current->euid != p->euid) && (current->euid != p->uid) &&
-				!capable(CAP_SYS_PTRACE))
+		if (current->act_as->euid != p->sec->euid &&
+		    current->act_as->euid != p->sec->uid &&
+		    !capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->compat_robust_list;
 		read_unlock(&tasklist_lock);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index c25db86..d1f3503 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -122,6 +122,8 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 
 int __ptrace_may_attach(struct task_struct *task)
 {
+	struct task_security *sec = current->act_as, *tsec = task->sec;
+
 	/* May we inspect the given task?
 	 * This check is used both for attaching with ptrace
 	 * and for allowing access to sensitive information in /proc.
@@ -134,12 +136,12 @@ int __ptrace_may_attach(struct task_struct *task)
 	/* Don't let security modules deny introspection */
 	if (task == current)
 		return 0;
-	if (((current->uid != task->euid) ||
-	     (current->uid != task->suid) ||
-	     (current->uid != task->uid) ||
-	     (current->gid != task->egid) ||
-	     (current->gid != task->sgid) ||
-	     (current->gid != task->gid)) && !capable(CAP_SYS_PTRACE))
+	if (((sec->uid != tsec->euid) ||
+	     (sec->uid != tsec->suid) ||
+	     (sec->uid != tsec->uid) ||
+	     (sec->gid != tsec->egid) ||
+	     (sec->gid != tsec->sgid) ||
+	     (sec->gid != tsec->gid)) && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 	smp_rmb();
 	if (task->mm)
diff --git a/kernel/sched.c b/kernel/sched.c
index 37cf07a..0084245 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4311,8 +4311,8 @@ recheck:
 			return -EPERM;
 
 		/* can't change other user's priorities */
-		if ((current->euid != p->euid) &&
-		    (current->euid != p->uid))
+		if ((current->act_as->euid != p->sec->euid) &&
+		    (current->act_as->euid != p->sec->uid))
 			return -EPERM;
 	}
 
@@ -4509,8 +4509,9 @@ long sched_setaffinity(pid_t pid, cpumask_t new_mask)
 	read_unlock(&tasklist_lock);
 
 	retval = -EPERM;
-	if ((current->euid != p->euid) && (current->euid != p->uid) &&
-			!capable(CAP_SYS_NICE))
+	if ((current->act_as->euid != p->sec->euid) &&
+	    (current->act_as->euid != p->sec->uid) &&
+	    !capable(CAP_SYS_NICE))
 		goto out_unlock;
 
 	retval = security_task_setscheduler(p, 0, NULL);
diff --git a/kernel/signal.c b/kernel/signal.c
index afa4f78..5c093a0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -174,7 +174,7 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	 * In order to avoid problems with "switch_user()", we want to make
 	 * sure that the compiler doesn't re-load "t->user"
 	 */
-	user = t->user;
+	user = t->sec->user;
 	barrier();
 	atomic_inc(&user->sigpending);
 	if (override_rlimit ||
@@ -537,8 +537,10 @@ static int check_kill_permission(int sig, struct siginfo *info,
 		error = -EPERM;
 		if (((sig != SIGCONT) ||
 			(task_session_nr(current) != task_session_nr(t)))
-		    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
-		    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
+		    && (current->act_as->euid ^ t->sec->suid)
+		    && (current->act_as->euid ^ t->sec->uid)
+		    && (current->act_as->uid ^ t->sec->suid)
+		    && (current->act_as->uid ^ t->sec->uid)
 		    && !capable(CAP_KILL))
 		return error;
 	}
@@ -695,7 +697,7 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			q->info.si_errno = 0;
 			q->info.si_code = SI_USER;
 			q->info.si_pid = task_pid_vnr(current);
-			q->info.si_uid = current->uid;
+			q->info.si_uid = current->act_as->uid;
 			break;
 		case (unsigned long) SEND_SIG_PRIV:
 			q->info.si_signo = sig;
@@ -1111,8 +1113,8 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 		goto out_unlock;
 	}
 	if ((info == SEND_SIG_NOINFO || (!is_si_special(info) && SI_FROMUSER(info)))
-	    && (euid != p->suid) && (euid != p->uid)
-	    && (uid != p->suid) && (uid != p->uid)) {
+	    && (euid != p->sec->suid) && (euid != p->sec->uid)
+	    && (uid != p->sec->suid) && (uid != p->sec->uid)) {
 		ret = -EPERM;
 		goto out_unlock;
 	}
@@ -1464,7 +1466,7 @@ void do_notify_parent(struct task_struct *tsk, int sig)
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
 	rcu_read_unlock();
 
-	info.si_uid = tsk->uid;
+	info.si_uid = tsk->sec->uid;
 
 	/* FIXME: find out whether or not this is supposed to be c*time. */
 	info.si_utime = cputime_to_jiffies(cputime_add(tsk->utime,
@@ -1535,7 +1537,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
 	rcu_read_unlock();
 
-	info.si_uid = tsk->uid;
+	info.si_uid = tsk->sec->uid;
 
 	/* FIXME: find out whether or not this is supposed to be c*time. */
 	info.si_utime = cputime_to_jiffies(tsk->utime);
@@ -1661,7 +1663,7 @@ void ptrace_notify(int exit_code)
 	info.si_signo = SIGTRAP;
 	info.si_code = exit_code;
 	info.si_pid = task_pid_vnr(current);
-	info.si_uid = current->uid;
+	info.si_uid = current->sec->uid;
 
 	/* Let the debugger run.  */
 	spin_lock_irq(&current->sighand->siglock);
@@ -1831,7 +1833,7 @@ relock:
 				info->si_errno = 0;
 				info->si_code = SI_USER;
 				info->si_pid = task_pid_vnr(current->parent);
-				info->si_uid = current->parent->uid;
+				info->si_uid = current->parent->sec->uid;
 			}
 
 			/* If the (new) signal is now blocked, requeue it.  */
@@ -2218,7 +2220,7 @@ sys_kill(int pid, int sig)
 	info.si_errno = 0;
 	info.si_code = SI_USER;
 	info.si_pid = task_tgid_vnr(current);
-	info.si_uid = current->uid;
+	info.si_uid = current->act_as->uid;
 
 	return kill_something_info(sig, &info, pid);
 }
@@ -2234,7 +2236,7 @@ static int do_tkill(int tgid, int pid, int sig)
 	info.si_errno = 0;
 	info.si_code = SI_TKILL;
 	info.si_pid = task_tgid_vnr(current);
-	info.si_uid = current->uid;
+	info.si_uid = current->act_as->uid;
 
 	read_lock(&tasklist_lock);
 	p = find_task_by_vpid(pid);
diff --git a/kernel/sys.c b/kernel/sys.c
index d1fe71e..14acc1b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -110,8 +110,8 @@ static int set_one_prio(struct task_struct *p, int niceval, int error)
 {
 	int no_nice;
 
-	if (p->uid != current->euid &&
-		p->euid != current->euid && !capable(CAP_SYS_NICE)) {
+	if (p->sec->uid != current->act_as->euid &&
+	    p->sec->euid != current->act_as->euid && !capable(CAP_SYS_NICE)) {
 		error = -EPERM;
 		goto out;
 	}
@@ -168,18 +168,19 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
 			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
-			user = current->user;
+			user = current->sec->user;
 			if (!who)
-				who = current->uid;
+				who = current->sec->uid;
 			else
-				if ((who != current->uid) && !(user = find_user(who)))
+				if ((who != current->sec->uid) &&
+				    !(user = find_user(who)))
 					goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p)
-				if (p->uid == who)
+				if (p->sec->uid == who)
 					error = set_one_prio(p, niceval, error);
 			while_each_thread(g, p);
-			if (who != current->uid)
+			if (who != current->sec->uid)
 				free_uid(user);		/* For find_user() */
 			break;
 	}
@@ -230,21 +231,22 @@ asmlinkage long sys_getpriority(int which, int who)
 			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
-			user = current->user;
+			user = current->sec->user;
 			if (!who)
-				who = current->uid;
+				who = current->sec->uid;
 			else
-				if ((who != current->uid) && !(user = find_user(who)))
+				if ((who != current->sec->uid) &&
+				    !(user = find_user(who)))
 					goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p)
-				if (p->uid == who) {
+				if (p->sec->uid == who) {
 					niceval = 20 - task_nice(p);
 					if (niceval > retval)
 						retval = niceval;
 				}
 			while_each_thread(g, p);
-			if (who != current->uid)
+			if (who != current->sec->uid)
 				free_uid(user);		/* for find_user() */
 			break;
 	}
@@ -481,8 +483,9 @@ void ctrl_alt_del(void)
  */
 asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 {
-	int old_rgid = current->gid;
-	int old_egid = current->egid;
+	struct task_security *sec = current->sec;
+	int old_rgid = sec->gid;
+	int old_egid = sec->egid;
 	int new_rgid = old_rgid;
 	int new_egid = old_egid;
 	int retval;
@@ -493,7 +496,7 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 
 	if (rgid != (gid_t) -1) {
 		if ((old_rgid == rgid) ||
-		    (current->egid==rgid) ||
+		    (sec->egid == rgid) ||
 		    capable(CAP_SETGID))
 			new_rgid = rgid;
 		else
@@ -501,8 +504,8 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 	}
 	if (egid != (gid_t) -1) {
 		if ((old_rgid == egid) ||
-		    (current->egid == egid) ||
-		    (current->sgid == egid) ||
+		    (sec->egid == egid) ||
+		    (sec->sgid == egid) ||
 		    capable(CAP_SETGID))
 			new_egid = egid;
 		else
@@ -514,10 +517,10 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 	}
 	if (rgid != (gid_t) -1 ||
 	    (egid != (gid_t) -1 && egid != old_rgid))
-		current->sgid = new_egid;
-	current->fsgid = new_egid;
-	current->egid = new_egid;
-	current->gid = new_rgid;
+		sec->sgid = new_egid;
+	sec->fsgid = new_egid;
+	sec->egid = new_egid;
+	sec->gid = new_rgid;
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -530,7 +533,8 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
  */
 asmlinkage long sys_setgid(gid_t gid)
 {
-	int old_egid = current->egid;
+	struct task_security *sec = current->sec;
+	int old_egid = sec->egid;
 	int retval;
 
 	retval = security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_ID);
@@ -542,13 +546,13 @@ asmlinkage long sys_setgid(gid_t gid)
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->gid = current->egid = current->sgid = current->fsgid = gid;
-	} else if ((gid == current->gid) || (gid == current->sgid)) {
+		sec->gid = sec->egid = sec->sgid = sec->fsgid = gid;
+	} else if ((gid == sec->gid) || (gid == sec->sgid)) {
 		if (old_egid != gid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->egid = current->fsgid = gid;
+		sec->egid = sec->fsgid = gid;
 	}
 	else
 		return -EPERM;
@@ -579,7 +583,7 @@ static int set_user(uid_t new_ruid, int dumpclear)
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->uid = new_ruid;
+	current->sec->uid = new_ruid;
 	return 0;
 }
 
@@ -600,6 +604,7 @@ static int set_user(uid_t new_ruid, int dumpclear)
  */
 asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 {
+	struct task_security *sec = current->sec;
 	int old_ruid, old_euid, old_suid, new_ruid, new_euid;
 	int retval;
 
@@ -607,14 +612,14 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 	if (retval)
 		return retval;
 
-	new_ruid = old_ruid = current->uid;
-	new_euid = old_euid = current->euid;
-	old_suid = current->suid;
+	new_ruid = old_ruid = sec->uid;
+	new_euid = old_euid = sec->euid;
+	old_suid = sec->suid;
 
 	if (ruid != (uid_t) -1) {
 		new_ruid = ruid;
 		if ((old_ruid != ruid) &&
-		    (current->euid != ruid) &&
+		    (sec->euid != ruid) &&
 		    !capable(CAP_SETUID))
 			return -EPERM;
 	}
@@ -622,8 +627,8 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 	if (euid != (uid_t) -1) {
 		new_euid = euid;
 		if ((old_ruid != euid) &&
-		    (current->euid != euid) &&
-		    (current->suid != euid) &&
+		    (sec->euid != euid) &&
+		    (sec->suid != euid) &&
 		    !capable(CAP_SETUID))
 			return -EPERM;
 	}
@@ -635,11 +640,11 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = new_euid;
+	sec->fsuid = sec->euid = new_euid;
 	if (ruid != (uid_t) -1 ||
 	    (euid != (uid_t) -1 && euid != old_ruid))
-		current->suid = current->euid;
-	current->fsuid = current->euid;
+		sec->suid = sec->euid;
+	sec->fsuid = sec->euid;
 
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
@@ -662,7 +667,8 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
  */
 asmlinkage long sys_setuid(uid_t uid)
 {
-	int old_euid = current->euid;
+	struct task_security *sec = current->sec;
+	int old_euid = sec->euid;
 	int old_ruid, old_suid, new_suid;
 	int retval;
 
@@ -670,23 +676,23 @@ asmlinkage long sys_setuid(uid_t uid)
 	if (retval)
 		return retval;
 
-	old_ruid = current->uid;
-	old_suid = current->suid;
+	old_ruid = sec->uid;
+	old_suid = sec->suid;
 	new_suid = old_suid;
 	
 	if (capable(CAP_SETUID)) {
 		if (uid != old_ruid && set_user(uid, old_euid != uid) < 0)
 			return -EAGAIN;
 		new_suid = uid;
-	} else if ((uid != current->uid) && (uid != new_suid))
+	} else if ((uid != sec->uid) && (uid != new_suid))
 		return -EPERM;
 
 	if (old_euid != uid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = uid;
-	current->suid = new_suid;
+	sec->fsuid = sec->euid = uid;
+	sec->suid = new_suid;
 
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
@@ -701,9 +707,10 @@ asmlinkage long sys_setuid(uid_t uid)
  */
 asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 {
-	int old_ruid = current->uid;
-	int old_euid = current->euid;
-	int old_suid = current->suid;
+	struct task_security *sec = current->sec;
+	int old_ruid = sec->uid;
+	int old_euid = sec->euid;
+	int old_suid = sec->suid;
 	int retval;
 
 	retval = security_task_setuid(ruid, euid, suid, LSM_SETID_RES);
@@ -711,30 +718,31 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 		return retval;
 
 	if (!capable(CAP_SETUID)) {
-		if ((ruid != (uid_t) -1) && (ruid != current->uid) &&
-		    (ruid != current->euid) && (ruid != current->suid))
+		if ((ruid != (uid_t) -1) && (ruid != sec->uid) &&
+		    (ruid != sec->euid) && (ruid != sec->suid))
 			return -EPERM;
-		if ((euid != (uid_t) -1) && (euid != current->uid) &&
-		    (euid != current->euid) && (euid != current->suid))
+		if ((euid != (uid_t) -1) && (euid != sec->uid) &&
+		    (euid != sec->euid) && (euid != sec->suid))
 			return -EPERM;
-		if ((suid != (uid_t) -1) && (suid != current->uid) &&
-		    (suid != current->euid) && (suid != current->suid))
+		if ((suid != (uid_t) -1) && (suid != sec->uid) &&
+		    (suid != sec->euid) && (suid != sec->suid))
 			return -EPERM;
 	}
 	if (ruid != (uid_t) -1) {
-		if (ruid != current->uid && set_user(ruid, euid != current->euid) < 0)
+		if (ruid != sec->uid &&
+		    set_user(ruid, euid != sec->euid) < 0)
 			return -EAGAIN;
 	}
 	if (euid != (uid_t) -1) {
-		if (euid != current->euid) {
+		if (euid != sec->euid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->euid = euid;
+		sec->euid = euid;
 	}
-	current->fsuid = current->euid;
+	sec->fsuid = sec->euid;
 	if (suid != (uid_t) -1)
-		current->suid = suid;
+		sec->suid = suid;
 
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
@@ -744,11 +752,12 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 
 asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __user *suid)
 {
+	struct task_security *sec = current->sec;
 	int retval;
 
-	if (!(retval = put_user(current->uid, ruid)) &&
-	    !(retval = put_user(current->euid, euid)))
-		retval = put_user(current->suid, suid);
+	if (!(retval = put_user(sec->uid, ruid)) &&
+	    !(retval = put_user(sec->euid, euid)))
+		retval = put_user(sec->suid, suid);
 
 	return retval;
 }
@@ -758,6 +767,7 @@ asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __us
  */
 asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 {
+	struct task_security *sec = current->sec;
 	int retval;
 
 	retval = security_task_setgid(rgid, egid, sgid, LSM_SETID_RES);
@@ -765,28 +775,28 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 		return retval;
 
 	if (!capable(CAP_SETGID)) {
-		if ((rgid != (gid_t) -1) && (rgid != current->gid) &&
-		    (rgid != current->egid) && (rgid != current->sgid))
+		if ((rgid != (gid_t) -1) && (rgid != sec->gid) &&
+		    (rgid != sec->egid) && (rgid != sec->sgid))
 			return -EPERM;
-		if ((egid != (gid_t) -1) && (egid != current->gid) &&
-		    (egid != current->egid) && (egid != current->sgid))
+		if ((egid != (gid_t) -1) && (egid != sec->gid) &&
+		    (egid != sec->egid) && (egid != sec->sgid))
 			return -EPERM;
-		if ((sgid != (gid_t) -1) && (sgid != current->gid) &&
-		    (sgid != current->egid) && (sgid != current->sgid))
+		if ((sgid != (gid_t) -1) && (sgid != sec->gid) &&
+		    (sgid != sec->egid) && (sgid != sec->sgid))
 			return -EPERM;
 	}
 	if (egid != (gid_t) -1) {
-		if (egid != current->egid) {
+		if (egid != sec->egid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->egid = egid;
+		sec->egid = egid;
 	}
-	current->fsgid = current->egid;
+	sec->fsgid = sec->egid;
 	if (rgid != (gid_t) -1)
-		current->gid = rgid;
+		sec->gid = rgid;
 	if (sgid != (gid_t) -1)
-		current->sgid = sgid;
+		sec->sgid = sgid;
 
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
@@ -795,11 +805,12 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 
 asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __user *sgid)
 {
+	struct task_security *sec = current->sec;
 	int retval;
 
-	if (!(retval = put_user(current->gid, rgid)) &&
-	    !(retval = put_user(current->egid, egid)))
-		retval = put_user(current->sgid, sgid);
+	if (!(retval = put_user(sec->gid, rgid)) &&
+	    !(retval = put_user(sec->egid, egid)))
+		retval = put_user(sec->sgid, sgid);
 
 	return retval;
 }
@@ -813,20 +824,21 @@ asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __us
  */
 asmlinkage long sys_setfsuid(uid_t uid)
 {
+	struct task_security *sec = current->sec;
 	int old_fsuid;
 
-	old_fsuid = current->fsuid;
+	old_fsuid = sec->fsuid;
 	if (security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS))
 		return old_fsuid;
 
-	if (uid == current->uid || uid == current->euid ||
-	    uid == current->suid || uid == current->fsuid || 
+	if (uid == sec->uid || uid == sec->euid ||
+	    uid == sec->suid || uid == sec->fsuid ||
 	    capable(CAP_SETUID)) {
 		if (uid != old_fsuid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsuid = uid;
+		sec->fsuid = uid;
 	}
 
 	key_fsuid_changed(current);
@@ -842,20 +854,21 @@ asmlinkage long sys_setfsuid(uid_t uid)
  */
 asmlinkage long sys_setfsgid(gid_t gid)
 {
+	struct task_security *sec = current->sec;
 	int old_fsgid;
 
-	old_fsgid = current->fsgid;
+	old_fsgid = sec->fsgid;
 	if (security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_FS))
 		return old_fsgid;
 
-	if (gid == current->gid || gid == current->egid ||
-	    gid == current->sgid || gid == current->fsgid || 
+	if (gid == sec->gid || gid == sec->egid ||
+	    gid == sec->sgid || gid == sec->fsgid ||
 	    capable(CAP_SETGID)) {
 		if (gid != old_fsgid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsgid = gid;
+		sec->fsgid = gid;
 		key_fsgid_changed(current);
 		proc_id_connector(current, PROC_EVENT_GID);
 	}
@@ -1235,6 +1248,7 @@ int groups_search(struct group_info *group_info, gid_t grp)
 /* validate and set current->group_info */
 int set_current_groups(struct group_info *group_info)
 {
+	struct task_security *sec = current->sec;
 	int retval;
 	struct group_info *old_info;
 
@@ -1245,10 +1259,10 @@ int set_current_groups(struct group_info *group_info)
 	groups_sort(group_info);
 	get_group_info(group_info);
 
-	task_lock(current);
-	old_info = current->group_info;
-	current->group_info = group_info;
-	task_unlock(current);
+	spin_lock(&sec->lock);
+	old_info = sec->group_info;
+	sec->group_info = group_info;
+	spin_unlock(&sec->lock);
 
 	put_group_info(old_info);
 
@@ -1259,6 +1273,7 @@ EXPORT_SYMBOL(set_current_groups);
 
 asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist)
 {
+	struct task_security *sec = current->sec;
 	int i = 0;
 
 	/*
@@ -1270,13 +1285,13 @@ asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist)
 		return -EINVAL;
 
 	/* no need to grab task_lock here; it cannot change */
-	i = current->group_info->ngroups;
+	i = sec->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups_to_user(grouplist, current->group_info)) {
+		if (groups_to_user(grouplist, sec->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
@@ -1320,9 +1335,10 @@ asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist)
  */
 int in_group_p(gid_t grp)
 {
+	struct task_security *act_as = current->act_as;
 	int retval = 1;
-	if (grp != current->fsgid)
-		retval = groups_search(current->group_info, grp);
+	if (grp != act_as->fsgid)
+		retval = groups_search(act_as->group_info, grp);
 	return retval;
 }
 
@@ -1330,9 +1346,10 @@ EXPORT_SYMBOL(in_group_p);
 
 int in_egroup_p(gid_t grp)
 {
+	struct task_security *act_as = current->act_as;
 	int retval = 1;
-	if (grp != current->egid)
-		retval = groups_search(current->group_info, grp);
+	if (grp != act_as->egid)
+		retval = groups_search(act_as->group_info, grp);
 	return retval;
 }
 
@@ -1641,6 +1658,9 @@ asmlinkage long sys_umask(int mask)
 asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5)
 {
+	struct task_struct *me = current;
+	struct task_security *sec = me->sec;
+	unsigned char comm[sizeof(me->comm)];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -1653,39 +1673,39 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 				error = -EINVAL;
 				break;
 			}
-			current->pdeath_signal = arg2;
+			me->pdeath_signal = arg2;
 			break;
 		case PR_GET_PDEATHSIG:
-			error = put_user(current->pdeath_signal, (int __user *)arg2);
+			error = put_user(me->pdeath_signal, (int __user *)arg2);
 			break;
 		case PR_GET_DUMPABLE:
-			error = get_dumpable(current->mm);
+			error = get_dumpable(me->mm);
 			break;
 		case PR_SET_DUMPABLE:
 			if (arg2 < 0 || arg2 > 1) {
 				error = -EINVAL;
 				break;
 			}
-			set_dumpable(current->mm, arg2);
+			set_dumpable(me->mm, arg2);
 			break;
 
 		case PR_SET_UNALIGN:
-			error = SET_UNALIGN_CTL(current, arg2);
+			error = SET_UNALIGN_CTL(me, arg2);
 			break;
 		case PR_GET_UNALIGN:
-			error = GET_UNALIGN_CTL(current, arg2);
+			error = GET_UNALIGN_CTL(me, arg2);
 			break;
 		case PR_SET_FPEMU:
-			error = SET_FPEMU_CTL(current, arg2);
+			error = SET_FPEMU_CTL(me, arg2);
 			break;
 		case PR_GET_FPEMU:
-			error = GET_FPEMU_CTL(current, arg2);
+			error = GET_FPEMU_CTL(me, arg2);
 			break;
 		case PR_SET_FPEXC:
-			error = SET_FPEXC_CTL(current, arg2);
+			error = SET_FPEXC_CTL(me, arg2);
 			break;
 		case PR_GET_FPEXC:
-			error = GET_FPEXC_CTL(current, arg2);
+			error = GET_FPEXC_CTL(me, arg2);
 			break;
 		case PR_GET_TIMING:
 			error = PR_TIMING_STATISTICAL;
@@ -1698,7 +1718,7 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 			break;
 
 		case PR_GET_KEEPCAPS:
-			if (current->keep_capabilities)
+			if (sec->keep_capabilities)
 				error = 1;
 			break;
 		case PR_SET_KEEPCAPS:
@@ -1706,33 +1726,26 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 				error = -EINVAL;
 				break;
 			}
-			current->keep_capabilities = arg2;
+			sec->keep_capabilities = arg2;
 			break;
-		case PR_SET_NAME: {
-			struct task_struct *me = current;
-			unsigned char ncomm[sizeof(me->comm)];
-
-			ncomm[sizeof(me->comm)-1] = 0;
-			if (strncpy_from_user(ncomm, (char __user *)arg2,
+		case PR_SET_NAME:
+			comm[sizeof(me->comm)-1] = 0;
+			if (strncpy_from_user(comm, (char __user *)arg2,
 						sizeof(me->comm)-1) < 0)
 				return -EFAULT;
-			set_task_comm(me, ncomm);
+			set_task_comm(me, comm);
 			return 0;
-		}
-		case PR_GET_NAME: {
-			struct task_struct *me = current;
-			unsigned char tcomm[sizeof(me->comm)];
-
-			get_task_comm(tcomm, me);
-			if (copy_to_user((char __user *)arg2, tcomm, sizeof(tcomm)))
+		case PR_GET_NAME:
+			get_task_comm(comm, me);
+			if (copy_to_user((char __user *)arg2, comm,
+					 sizeof(comm)))
 				return -EFAULT;
 			return 0;
-		}
 		case PR_GET_ENDIAN:
-			error = GET_ENDIAN(current, arg2);
+			error = GET_ENDIAN(me, arg2);
 			break;
 		case PR_SET_ENDIAN:
-			error = SET_ENDIAN(current, arg2);
+			error = SET_ENDIAN(me, arg2);
 			break;
 
 		case PR_GET_SECCOMP:
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c68f68d..44a2903 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1382,7 +1382,7 @@ out:
 
 static int test_perm(int mode, int op)
 {
-	if (!current->euid)
+	if (!current->act_as->euid)
 		mode >>= 6;
 	else if (in_egroup_p(0))
 		mode >>= 3;
diff --git a/kernel/timer.c b/kernel/timer.c
index 26671f4..015ffcc 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -987,25 +987,25 @@ asmlinkage long sys_getppid(void)
 asmlinkage long sys_getuid(void)
 {
 	/* Only we change this so SMP safe */
-	return current->uid;
+	return current->sec->uid;
 }
 
 asmlinkage long sys_geteuid(void)
 {
 	/* Only we change this so SMP safe */
-	return current->euid;
+	return current->sec->euid;
 }
 
 asmlinkage long sys_getgid(void)
 {
 	/* Only we change this so SMP safe */
-	return current->gid;
+	return current->sec->gid;
 }
 
 asmlinkage long sys_getegid(void)
 {
 	/* Only we change this so SMP safe */
-	return  current->egid;
+	return  current->sec->egid;
 }
 
 #endif
diff --git a/kernel/uid16.c b/kernel/uid16.c
index dd308ba..c56f6fe 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -86,9 +86,9 @@ asmlinkage long sys_getresuid16(old_uid_t __user *ruid, old_uid_t __user *euid,
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowuid(current->uid), ruid)) &&
-	    !(retval = put_user(high2lowuid(current->euid), euid)))
-		retval = put_user(high2lowuid(current->suid), suid);
+	if (!(retval = put_user(high2lowuid(current->sec->uid), ruid)) &&
+	    !(retval = put_user(high2lowuid(current->sec->euid), euid)))
+		retval = put_user(high2lowuid(current->sec->suid), suid);
 
 	return retval;
 }
@@ -106,9 +106,9 @@ asmlinkage long sys_getresgid16(old_gid_t __user *rgid, old_gid_t __user *egid,
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowgid(current->gid), rgid)) &&
-	    !(retval = put_user(high2lowgid(current->egid), egid)))
-		retval = put_user(high2lowgid(current->sgid), sgid);
+	if (!(retval = put_user(high2lowgid(current->sec->gid), rgid)) &&
+	    !(retval = put_user(high2lowgid(current->sec->egid), egid)))
+		retval = put_user(high2lowgid(current->sec->sgid), sgid);
 
 	return retval;
 }
@@ -166,20 +166,20 @@ asmlinkage long sys_getgroups16(int gidsetsize, old_gid_t __user *grouplist)
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	get_group_info(current->sec->group_info);
+	i = current->sec->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, current->sec->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
+	put_group_info(current->sec->group_info);
 	return i;
 }
 
@@ -210,20 +210,20 @@ asmlinkage long sys_setgroups16(int gidsetsize, old_gid_t __user *grouplist)
 
 asmlinkage long sys_getuid16(void)
 {
-	return high2lowuid(current->uid);
+	return high2lowuid(current->sec->uid);
 }
 
 asmlinkage long sys_geteuid16(void)
 {
-	return high2lowuid(current->euid);
+	return high2lowuid(current->sec->euid);
 }
 
 asmlinkage long sys_getgid16(void)
 {
-	return high2lowgid(current->gid);
+	return high2lowgid(current->sec->gid);
 }
 
 asmlinkage long sys_getegid16(void)
 {
-	return high2lowgid(current->egid);
+	return high2lowgid(current->sec->egid);
 }
diff --git a/kernel/user.c b/kernel/user.c
index 8320a87..d9a84b1 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -416,11 +416,11 @@ void switch_uid(struct user_struct *new_user)
 	 * cheaply with the new uid cache, so if it matters
 	 * we should be checking for it.  -DaveM
 	 */
-	old_user = current->user;
+	old_user = current->sec->user;
 	atomic_inc(&new_user->processes);
 	atomic_dec(&old_user->processes);
 	switch_uid_keyring(new_user);
-	current->user = new_user;
+	current->sec->user = new_user;
 	sched_switch_user(current);
 
 	/*
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 7af90fc..fef8023 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -49,7 +49,7 @@ static struct user_namespace *clone_user_ns(struct user_namespace *old_ns)
 	}
 
 	/* Reset current->user with a new one */
-	new_user = alloc_uid(ns, current->uid);
+	new_user = alloc_uid(ns, current->sec->uid);
 	if (!new_user) {
 		free_uid(ns->root_user);
 		kfree(ns);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 91a081a..917a90e 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -125,8 +125,8 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * Superuser processes are usually more important, so we make it
 	 * less likely that we kill those.
 	 */
-	if (cap_t(p->cap_effective) & CAP_TO_MASK(CAP_SYS_ADMIN) ||
-				p->uid == 0 || p->euid == 0)
+	if (cap_t(p->sec->cap_effective) & CAP_TO_MASK(CAP_SYS_ADMIN) ||
+				p->sec->uid == 0 || p->sec->euid == 0)
 		points /= 4;
 
 	/*
@@ -135,7 +135,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * tend to only have this flag set on applications they think
 	 * of as important.
 	 */
-	if (cap_t(p->cap_effective) & CAP_TO_MASK(CAP_SYS_RAWIO))
+	if (cap_t(p->sec->cap_effective) & CAP_TO_MASK(CAP_SYS_RAWIO))
 		points /= 4;
 
 	/*
diff --git a/net/core/scm.c b/net/core/scm.c
index 10f5c65..703b174 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -44,11 +44,13 @@
 
 static __inline__ int scm_check_creds(struct ucred *creds)
 {
+	struct task_security *sec = current->act_as;
+
 	if ((creds->pid == task_tgid_vnr(current) || capable(CAP_SYS_ADMIN)) &&
-	    ((creds->uid == current->uid || creds->uid == current->euid ||
-	      creds->uid == current->suid) || capable(CAP_SETUID)) &&
-	    ((creds->gid == current->gid || creds->gid == current->egid ||
-	      creds->gid == current->sgid) || capable(CAP_SETGID))) {
+	    ((creds->uid == sec->uid || creds->uid == sec->euid ||
+	      creds->uid == sec->suid) || capable(CAP_SETUID)) &&
+	    ((creds->gid == sec->gid || creds->gid == sec->egid ||
+	      creds->gid == sec->sgid) || capable(CAP_SETGID))) {
 	       return 0;
 	}
 	return -EPERM;
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 390a1ec..e254e56 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -339,7 +339,7 @@ rpcauth_lookupcred(struct rpc_auth *auth, int flags)
 	struct auth_cred acred = {
 		.uid = current_fsuid(),
 		.gid = current_fsgid(),
-		.group_info = current->group_info,
+		.group_info = current->act_as->group_info,
 	};
 	struct rpc_cred *ret;
 
@@ -375,7 +375,7 @@ rpcauth_bindcred(struct rpc_task *task)
 	struct auth_cred acred = {
 		.uid = current_fsuid(),
 		.gid = current_fsgid(),
-		.group_info = current->group_info,
+		.group_info = current->act_as->group_info,
 	};
 	struct rpc_cred *ret;
 	int flags = 0;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 060bba4..974037d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -484,8 +484,8 @@ static int unix_listen(struct socket *sock, int backlog)
 	sk->sk_state		= TCP_LISTEN;
 	/* set credentials so connect can copy them */
 	sk->sk_peercred.pid	= task_tgid_vnr(current);
-	sk->sk_peercred.uid	= current->euid;
-	sk->sk_peercred.gid	= current->egid;
+	sk->sk_peercred.uid	= current->act_as->euid;
+	sk->sk_peercred.gid	= current->act_as->egid;
 	err = 0;
 
 out_unlock:
@@ -1135,8 +1135,8 @@ restart:
 	newsk->sk_state		= TCP_ESTABLISHED;
 	newsk->sk_type		= sk->sk_type;
 	newsk->sk_peercred.pid	= task_tgid_vnr(current);
-	newsk->sk_peercred.uid	= current->euid;
-	newsk->sk_peercred.gid	= current->egid;
+	newsk->sk_peercred.uid	= current->act_as->euid;
+	newsk->sk_peercred.gid	= current->act_as->egid;
 	newu = unix_sk(newsk);
 	newsk->sk_sleep		= &newu->peer_wait;
 	otheru = unix_sk(other);
@@ -1196,8 +1196,8 @@ static int unix_socketpair(struct socket *socka, struct socket *sockb)
 	unix_peer(ska)=skb;
 	unix_peer(skb)=ska;
 	ska->sk_peercred.pid = skb->sk_peercred.pid = task_tgid_vnr(current);
-	ska->sk_peercred.uid = skb->sk_peercred.uid = current->euid;
-	ska->sk_peercred.gid = skb->sk_peercred.gid = current->egid;
+	ska->sk_peercred.uid = skb->sk_peercred.uid = current->act_as->euid;
+	ska->sk_peercred.gid = skb->sk_peercred.gid = current->act_as->egid;
 
 	if (ska->sk_type != SOCK_DGRAM) {
 		ska->sk_state = TCP_ESTABLISHED;
diff --git a/security/commoncap.c b/security/commoncap.c
index bbe188e..13c21c7 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -46,7 +46,7 @@ EXPORT_SYMBOL(securebits);
 
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
-	NETLINK_CB(skb).eff_cap = current->cap_effective;
+	NETLINK_CB(skb).eff_cap = current_cap();
 	return 0;
 }
 
@@ -62,7 +62,7 @@ EXPORT_SYMBOL(cap_netlink_recv);
 int cap_capable (struct task_struct *tsk, int cap)
 {
 	/* Derived from include/linux/sched.h:capable. */
-	if (cap_raised(tsk->cap_effective, cap))
+	if (cap_raised(tsk->act_as->cap_effective, cap))
 		return 0;
 	return -EPERM;
 }
@@ -77,7 +77,8 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
 int cap_ptrace (struct task_struct *parent, struct task_struct *child)
 {
 	/* Derived from arch/i386/kernel/ptrace.c:sys_ptrace. */
-	if (!cap_issubset(child->cap_permitted, parent->cap_permitted) &&
+	if (!cap_issubset(child->sec->cap_permitted,
+			  parent->act_as->cap_permitted) &&
 	    !__capable(parent, CAP_SYS_PTRACE))
 		return -EPERM;
 	return 0;
@@ -86,10 +87,12 @@ int cap_ptrace (struct task_struct *parent, struct task_struct *child)
 int cap_capget (struct task_struct *target, kernel_cap_t *effective,
 		kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
+	struct task_security *sec = target->sec;
+
 	/* Derived from kernel/capability.c:sys_capget. */
-	*effective = cap_t (target->cap_effective);
-	*inheritable = cap_t (target->cap_inheritable);
-	*permitted = cap_t (target->cap_permitted);
+	*effective = cap_t(sec->cap_effective);
+	*inheritable = cap_t(sec->cap_inheritable);
+	*permitted = cap_t(sec->cap_permitted);
 	return 0;
 }
 
@@ -123,21 +126,24 @@ static inline int cap_inh_is_capped(void) { return 1; }
 int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
 		      kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
+	struct task_security *act_as = current->act_as;
+	struct task_security *sec = target->sec;
+
 	if (cap_block_setpcap(target)) {
 		return -EPERM;
 	}
 	if (cap_inh_is_capped()
 	    && !cap_issubset(*inheritable,
-			     cap_combine(target->cap_inheritable,
-					 current->cap_permitted))) {
+			     cap_combine(sec->cap_inheritable,
+					 act_as->cap_permitted))) {
 		/* incapable of using this inheritable set */
 		return -EPERM;
 	}
 
 	/* verify restrictions on target's new Permitted set */
 	if (!cap_issubset (*permitted,
-			   cap_combine (target->cap_permitted,
-					current->cap_permitted))) {
+			   cap_combine (sec->cap_permitted,
+					act_as->cap_permitted))) {
 		return -EPERM;
 	}
 
@@ -152,9 +158,11 @@ int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
 void cap_capset_set (struct task_struct *target, kernel_cap_t *effective,
 		     kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
-	target->cap_effective = *effective;
-	target->cap_inheritable = *inheritable;
-	target->cap_permitted = *permitted;
+	struct task_security *sec = target->sec;
+
+	sec->cap_effective = *effective;
+	sec->cap_inheritable = *inheritable;
+	sec->cap_permitted = *permitted;
 }
 
 static inline void bprm_clear_caps(struct linux_binprm *bprm)
@@ -298,7 +306,7 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 	 */
 
 	if (!issecure (SECURE_NOROOT)) {
-		if (bprm->e_uid == 0 || current->uid == 0) {
+		if (bprm->e_uid == 0 || current->sec->uid == 0) {
 			cap_set_full (bprm->cap_inheritable);
 			cap_set_full (bprm->cap_permitted);
 		}
@@ -311,51 +319,54 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 
 void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
+	struct task_security *sec = current->sec;
 	/* Derived from fs/exec.c:compute_creds. */
 	kernel_cap_t new_permitted, working;
 
 	new_permitted = cap_intersect (bprm->cap_permitted, cap_bset);
 	working = cap_intersect (bprm->cap_inheritable,
-				 current->cap_inheritable);
+				 sec->cap_inheritable);
 	new_permitted = cap_combine (new_permitted, working);
 
-	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
-	    !cap_issubset (new_permitted, current->cap_permitted)) {
+	if (bprm->e_uid != sec->uid || bprm->e_gid != sec->gid ||
+	    !cap_issubset (new_permitted, sec->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
-				bprm->e_uid = current->uid;
-				bprm->e_gid = current->gid;
+				bprm->e_uid = sec->uid;
+				bprm->e_gid = sec->gid;
 			}
 			if (!capable (CAP_SETPCAP)) {
 				new_permitted = cap_intersect (new_permitted,
-							current->cap_permitted);
+							sec->cap_permitted);
 			}
 		}
 	}
 
-	current->suid = current->euid = current_fsuid() = bprm->e_uid;
-	current->sgid = current->egid = current_fsgid() = bprm->e_gid;
+	sec->suid = sec->euid = sec->fsuid = bprm->e_uid;
+	sec->sgid = sec->egid = sec->fsgid = bprm->e_gid;
 
 	/* For init, we want to retain the capabilities set
 	 * in the init_task struct. Thus we skip the usual
 	 * capability rules */
 	if (!is_global_init(current)) {
-		current->cap_permitted = new_permitted;
-		current->cap_effective = bprm->cap_effective ?
+		sec->cap_permitted = new_permitted;
+		sec->cap_effective = bprm->cap_effective ?
 				new_permitted : 0;
 	}
 
-	/* AUD: Audit candidate if current->cap_effective is set */
+	/* AUD: Audit candidate if sec->cap_effective is set */
 
-	current->keep_capabilities = 0;
+	sec->keep_capabilities = 0;
 }
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
 {
-	if (current->uid != 0) {
+	struct task_security *sec = current->sec;
+
+	if (sec->uid != 0) {
 		if (bprm->cap_effective)
 			return 1;
 		if (!cap_isclear(bprm->cap_permitted))
@@ -364,8 +375,8 @@ int cap_bprm_secureexec (struct linux_binprm *bprm)
 			return 1;
 	}
 
-	return (current->euid != current->uid ||
-		current->egid != current->gid);
+	return (sec->euid != sec->uid ||
+		sec->egid != sec->gid);
 }
 
 int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
@@ -428,23 +439,27 @@ int cap_inode_removexattr(struct dentry *dentry, char *name)
 static inline void cap_emulate_setxuid (int old_ruid, int old_euid,
 					int old_suid)
 {
+	struct task_security *sec = current->sec;
+
 	if ((old_ruid == 0 || old_euid == 0 || old_suid == 0) &&
-	    (current->uid != 0 && current->euid != 0 && current->suid != 0) &&
-	    !current->keep_capabilities) {
-		cap_clear (current->cap_permitted);
-		cap_clear (current->cap_effective);
+	    (sec->uid != 0 && sec->euid != 0 && sec->suid != 0) &&
+	    !sec->keep_capabilities) {
+		cap_clear (sec->cap_permitted);
+		cap_clear (sec->cap_effective);
 	}
-	if (old_euid == 0 && current->euid != 0) {
-		cap_clear (current->cap_effective);
+	if (old_euid == 0 && sec->euid != 0) {
+		cap_clear (sec->cap_effective);
 	}
-	if (old_euid != 0 && current->euid == 0) {
-		current->cap_effective = current->cap_permitted;
+	if (old_euid != 0 && sec->euid == 0) {
+		sec->cap_effective = sec->cap_permitted;
 	}
 }
 
 int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 			  int flags)
 {
+	struct task_security *sec = current->sec;
+
 	switch (flags) {
 	case LSM_SETID_RE:
 	case LSM_SETID_ID:
@@ -466,13 +481,13 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 			 */
 
 			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
-				if (old_fsuid == 0 && current_fsuid() != 0) {
-					cap_t (current->cap_effective) &=
+				if (old_fsuid == 0 && sec->fsuid != 0) {
+					cap_t (sec->cap_effective) &=
 					    ~CAP_FS_MASK;
 				}
-				if (old_fsuid != 0 && current_fsuid() == 0) {
-					cap_t (current->cap_effective) |=
-					    (cap_t (current->cap_permitted) &
+				if (old_fsuid != 0 && sec->fsuid == 0) {
+					cap_t (sec->cap_effective) |=
+					    (cap_t (sec->cap_permitted) &
 					     CAP_FS_MASK);
 				}
 			}
@@ -577,11 +592,12 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 
 void cap_task_reparent_to_init (struct task_struct *p)
 {
-	p->cap_effective = CAP_INIT_EFF_SET;
-	p->cap_inheritable = CAP_INIT_INH_SET;
-	p->cap_permitted = CAP_FULL_SET;
-	p->keep_capabilities = 0;
-	return;
+	struct task_security *sec = p->sec;
+
+	sec->cap_effective = CAP_INIT_EFF_SET;
+	sec->cap_inheritable = CAP_INIT_INH_SET;
+	sec->cap_permitted = CAP_FULL_SET;
+	sec->keep_capabilities = 0;
 }
 
 int cap_syslog (int type)
diff --git a/security/dummy.c b/security/dummy.c
index 0e7f35c..ba7a197 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -37,11 +37,11 @@ static int dummy_capget (struct task_struct *target, kernel_cap_t * effective,
 			 kernel_cap_t * inheritable, kernel_cap_t * permitted)
 {
 	*effective = *inheritable = *permitted = 0;
-	if (target->euid == 0) {
+	if (target->sec->euid == 0) {
 		*permitted |= (~0 & ~CAP_FS_MASK);
 		*effective |= (~0 & ~CAP_TO_MASK(CAP_SETPCAP) & ~CAP_FS_MASK);
 	}
-	if (target->fsuid == 0) {
+	if (target->sec->fsuid == 0) {
 		*permitted |= CAP_FS_MASK;
 		*effective |= CAP_FS_MASK;
 	}
@@ -71,7 +71,7 @@ static int dummy_acct (struct file *file)
 
 static int dummy_capable (struct task_struct *tsk, int cap)
 {
-	if (cap_raised (tsk->cap_effective, cap))
+	if (cap_raised(tsk->act_as->cap_effective, cap))
 		return 0;
 	return -EPERM;
 }
@@ -93,7 +93,7 @@ static int dummy_quota_on (struct dentry *dentry)
 
 static int dummy_syslog (int type)
 {
-	if ((type != 3 && type != 10) && current->euid)
+	if ((type != 3 && type != 10) && current->act_as->euid)
 		return -EPERM;
 	return 0;
 }
@@ -126,19 +126,24 @@ static void dummy_bprm_free_security (struct linux_binprm *bprm)
 
 static void dummy_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
-	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid) {
+	struct task_security *sec = current->sec;
+
+	if (bprm->e_uid != sec->uid || bprm->e_gid != sec->gid) {
 		set_dumpable(current->mm, suid_dumpable);
 
 		if ((unsafe & ~LSM_UNSAFE_PTRACE_CAP) && !capable(CAP_SETUID)) {
-			bprm->e_uid = current->uid;
-			bprm->e_gid = current->gid;
+			bprm->e_uid = sec->uid;
+			bprm->e_gid = sec->gid;
 		}
 	}
 
-	current->suid = current->euid = current->fsuid = bprm->e_uid;
-	current->sgid = current->egid = current->fsgid = bprm->e_gid;
+	sec->suid = sec->euid = sec->fsuid = bprm->e_uid;
+	sec->sgid = sec->egid = sec->fsgid = bprm->e_gid;
 
-	dummy_capget(current, &current->cap_effective, &current->cap_inheritable, &current->cap_permitted);
+	dummy_capget(current,
+		     &sec->cap_effective,
+		     &sec->cap_inheritable,
+		     &sec->cap_permitted);
 }
 
 static void dummy_bprm_post_apply_creds (struct linux_binprm *bprm)
@@ -162,8 +167,8 @@ static int dummy_bprm_secureexec (struct linux_binprm *bprm)
 	   in the AT_SECURE field to decide whether secure mode
 	   is required.  Hence, this logic is required to preserve
 	   the legacy decision algorithm used by the old userland. */
-	return (current->euid != current->uid ||
-		current->egid != current->gid);
+	return (current->sec->euid != current->sec->uid ||
+		current->sec->egid != current->sec->gid);
 }
 
 static int dummy_sb_alloc_security (struct super_block *sb)
@@ -492,7 +497,12 @@ static int dummy_task_setuid (uid_t id0, uid_t id1, uid_t id2, int flags)
 
 static int dummy_task_post_setuid (uid_t id0, uid_t id1, uid_t id2, int flags)
 {
-	dummy_capget(current, &current->cap_effective, &current->cap_inheritable, &current->cap_permitted);
+	struct task_security *sec = current->sec;
+
+	dummy_capget(current,
+		     &sec->cap_effective,
+		     &sec->cap_inheritable,
+		     &sec->cap_permitted);
 	return 0;
 }
 
@@ -579,7 +589,7 @@ static int dummy_task_prctl (int option, unsigned long arg2, unsigned long arg3,
 
 static void dummy_task_reparent_to_init (struct task_struct *p)
 {
-	p->euid = p->fsuid = 0;
+	p->sec->euid = p->sec->fsuid = 0;
 	return;
 }
 
@@ -689,7 +699,7 @@ static int dummy_sem_semop (struct sem_array *sma,
 
 static int dummy_netlink_send (struct sock *sk, struct sk_buff *skb)
 {
-	NETLINK_CB(skb).eff_cap = current->cap_effective;
+	NETLINK_CB(skb).eff_cap = current->act_as->cap_effective;
 	return 0;
 }
 
diff --git a/security/keys/key.c b/security/keys/key.c
index 48fabb1..1692988 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -817,7 +817,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 		perm |= KEY_USR_WRITE;
 
 	/* allocate a new key */
-	key = key_alloc(ktype, description, current_fsuid(), current->fsgid,
+	key = key_alloc(ktype, description, current_fsuid(), current_fsgid(),
 			current, perm, flags);
 	if (IS_ERR(key)) {
 		key_ref = ERR_PTR(PTR_ERR(key));
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index b3a63dd..4051948 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -846,7 +846,7 @@ long keyctl_instantiate_key(key_serial_t id,
 	/* the appropriate instantiation authorisation key must have been
 	 * assumed before calling this */
 	ret = -EPERM;
-	instkey = current->request_key_auth;
+	instkey = current->sec->request_key_auth;
 	if (!instkey)
 		goto error;
 
@@ -895,8 +895,8 @@ long keyctl_instantiate_key(key_serial_t id,
 	/* discard the assumed authority if it's just been disabled by
 	 * instantiation of the key */
 	if (ret == 0) {
-		key_put(current->request_key_auth);
-		current->request_key_auth = NULL;
+		key_put(current->sec->request_key_auth);
+		current->sec->request_key_auth = NULL;
 	}
 
 error2:
@@ -924,7 +924,7 @@ long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 	/* the appropriate instantiation authorisation key must have been
 	 * assumed before calling this */
 	ret = -EPERM;
-	instkey = current->request_key_auth;
+	instkey = current->sec->request_key_auth;
 	if (!instkey)
 		goto error;
 
@@ -952,8 +952,8 @@ long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 	/* discard the assumed authority if it's just been disabled by
 	 * instantiation of the key */
 	if (ret == 0) {
-		key_put(current->request_key_auth);
-		current->request_key_auth = NULL;
+		key_put(current->sec->request_key_auth);
+		current->sec->request_key_auth = NULL;
 	}
 
 error:
@@ -968,6 +968,7 @@ error:
  */
 long keyctl_set_reqkey_keyring(int reqkey_defl)
 {
+	struct task_security *sec = current->sec;
 	int ret;
 
 	switch (reqkey_defl) {
@@ -987,10 +988,10 @@ long keyctl_set_reqkey_keyring(int reqkey_defl)
 	case KEY_REQKEY_DEFL_USER_KEYRING:
 	case KEY_REQKEY_DEFL_USER_SESSION_KEYRING:
 	set:
-		current->jit_keyring = reqkey_defl;
+		sec->jit_keyring = reqkey_defl;
 
 	case KEY_REQKEY_DEFL_NO_CHANGE:
-		return current->jit_keyring;
+		return sec->jit_keyring;
 
 	case KEY_REQKEY_DEFL_GROUP_KEYRING:
 	default:
@@ -1055,8 +1056,8 @@ long keyctl_assume_authority(key_serial_t id)
 
 	/* we divest ourselves of authority if given an ID of 0 */
 	if (id == 0) {
-		key_put(current->request_key_auth);
-		current->request_key_auth = NULL;
+		key_put(current->sec->request_key_auth);
+		current->sec->request_key_auth = NULL;
 		ret = 0;
 		goto error;
 	}
@@ -1072,8 +1073,8 @@ long keyctl_assume_authority(key_serial_t id)
 		goto error;
 	}
 
-	key_put(current->request_key_auth);
-	current->request_key_auth = authkey;
+	key_put(current->sec->request_key_auth);
+	current->sec->request_key_auth = authkey;
 	ret = authkey->serial;
 
 error:
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 3b41f9b..07898bd 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -22,6 +22,7 @@ int key_task_permission(const key_ref_t key_ref,
 			struct task_struct *context,
 			key_perm_t perm)
 {
+	struct task_security *sec = context->act_as;
 	struct key *key;
 	key_perm_t kperm;
 	int ret;
@@ -29,7 +30,7 @@ int key_task_permission(const key_ref_t key_ref,
 	key = key_ref_to_ptr(key_ref);
 
 	/* use the second 8-bits of permissions for keys the caller owns */
-	if (key->uid == context->fsuid) {
+	if (key->uid == sec->fsuid) {
 		kperm = key->perm >> 16;
 		goto use_these_perms;
 	}
@@ -37,14 +38,14 @@ int key_task_permission(const key_ref_t key_ref,
 	/* use the third 8-bits of permissions for keys the caller has a group
 	 * membership in common with */
 	if (key->gid != -1 && key->perm & KEY_GRP_ALL) {
-		if (key->gid == context->fsgid) {
+		if (key->gid == sec->fsgid) {
 			kperm = key->perm >> 8;
 			goto use_these_perms;
 		}
 
-		task_lock(context);
-		ret = groups_search(context->group_info, key->gid);
-		task_unlock(context);
+		spin_lock(&sec->lock);
+		ret = groups_search(sec->group_info, key->gid);
+		spin_unlock(&sec->lock);
 
 		if (ret) {
 			kperm = key->perm >> 8;
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 2a0eb94..98854b2 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -145,7 +145,7 @@ int install_thread_keyring(struct task_struct *tsk)
 
 	sprintf(buf, "_tid.%u", tsk->pid);
 
-	keyring = keyring_alloc(buf, tsk->uid, tsk->gid, tsk,
+	keyring = keyring_alloc(buf, tsk->sec->uid, tsk->sec->gid, tsk,
 				KEY_ALLOC_QUOTA_OVERRUN, NULL);
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
@@ -153,8 +153,8 @@ int install_thread_keyring(struct task_struct *tsk)
 	}
 
 	task_lock(tsk);
-	old = tsk->thread_keyring;
-	tsk->thread_keyring = keyring;
+	old = tsk->sec->thread_keyring;
+	tsk->sec->thread_keyring = keyring;
 	task_unlock(tsk);
 
 	ret = 0;
@@ -180,7 +180,7 @@ int install_process_keyring(struct task_struct *tsk)
 	if (!tsk->signal->process_keyring) {
 		sprintf(buf, "_pid.%u", tsk->tgid);
 
-		keyring = keyring_alloc(buf, tsk->uid, tsk->gid, tsk,
+		keyring = keyring_alloc(buf, tsk->sec->uid, tsk->sec->gid, tsk,
 					KEY_ALLOC_QUOTA_OVERRUN, NULL);
 		if (IS_ERR(keyring)) {
 			ret = PTR_ERR(keyring);
@@ -226,7 +226,7 @@ static int install_session_keyring(struct task_struct *tsk,
 		if (tsk->signal->session_keyring)
 			flags = KEY_ALLOC_IN_QUOTA;
 
-		keyring = keyring_alloc(buf, tsk->uid, tsk->gid, tsk,
+		keyring = keyring_alloc(buf, tsk->sec->uid, tsk->sec->gid, tsk,
 					flags, NULL);
 		if (IS_ERR(keyring))
 			return PTR_ERR(keyring);
@@ -280,14 +280,14 @@ int copy_thread_group_keys(struct task_struct *tsk)
  */
 int copy_keys(unsigned long clone_flags, struct task_struct *tsk)
 {
-	key_check(tsk->thread_keyring);
-	key_check(tsk->request_key_auth);
+	key_check(tsk->sec->thread_keyring);
+	key_check(tsk->sec->request_key_auth);
 
 	/* no thread keyring yet */
-	tsk->thread_keyring = NULL;
+	tsk->sec->thread_keyring = NULL;
 
 	/* copy the request_key() authorisation for this thread */
-	key_get(tsk->request_key_auth);
+	key_get(tsk->sec->request_key_auth);
 
 	return 0;
 
@@ -310,8 +310,8 @@ void exit_thread_group_keys(struct signal_struct *tg)
  */
 void exit_keys(struct task_struct *tsk)
 {
-	key_put(tsk->thread_keyring);
-	key_put(tsk->request_key_auth);
+	key_put(tsk->sec->thread_keyring);
+	key_put(tsk->sec->request_key_auth);
 
 } /* end exit_keys() */
 
@@ -325,8 +325,8 @@ int exec_keys(struct task_struct *tsk)
 
 	/* newly exec'd tasks don't get a thread keyring */
 	task_lock(tsk);
-	old = tsk->thread_keyring;
-	tsk->thread_keyring = NULL;
+	old = tsk->sec->thread_keyring;
+	tsk->sec->thread_keyring = NULL;
 	task_unlock(tsk);
 
 	key_put(old);
@@ -361,10 +361,11 @@ int suid_keys(struct task_struct *tsk)
 void key_fsuid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
-	if (tsk->thread_keyring) {
-		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->uid = tsk->fsuid;
-		up_write(&tsk->thread_keyring->sem);
+	BUG_ON(!tsk->sec);
+	if (tsk->sec->thread_keyring) {
+		down_write(&tsk->sec->thread_keyring->sem);
+		tsk->sec->thread_keyring->uid = tsk->sec->fsuid;
+		up_write(&tsk->sec->thread_keyring->sem);
 	}
 
 } /* end key_fsuid_changed() */
@@ -376,10 +377,11 @@ void key_fsuid_changed(struct task_struct *tsk)
 void key_fsgid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
-	if (tsk->thread_keyring) {
-		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->gid = tsk->fsgid;
-		up_write(&tsk->thread_keyring->sem);
+	BUG_ON(!tsk->sec);
+	if (tsk->sec->thread_keyring) {
+		down_write(&tsk->sec->thread_keyring->sem);
+		tsk->sec->thread_keyring->gid = tsk->sec->fsgid;
+		up_write(&tsk->sec->thread_keyring->sem);
 	}
 
 } /* end key_fsgid_changed() */
@@ -414,9 +416,9 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	err = ERR_PTR(-EAGAIN);
 
 	/* search the thread keyring first */
-	if (context->thread_keyring) {
+	if (context->sec->thread_keyring) {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->thread_keyring, 1),
+			make_key_ref(context->sec->thread_keyring, 1),
 			context, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
@@ -483,7 +485,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	/* or search the user-session keyring */
 	else {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->user->session_keyring, 1),
+			make_key_ref(context->sec->user->session_keyring, 1),
 			context, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
@@ -505,20 +507,20 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	 * search the keyrings of the process mentioned there
 	 * - we don't permit access to request_key auth keys via this method
 	 */
-	if (context->request_key_auth &&
+	if (context->sec->request_key_auth &&
 	    context == current &&
 	    type != &key_type_request_key_auth
 	    ) {
 		/* defend against the auth key being revoked */
-		down_read(&context->request_key_auth->sem);
+		down_read(&context->sec->request_key_auth->sem);
 
-		if (key_validate(context->request_key_auth) == 0) {
-			rka = context->request_key_auth->payload.data;
+		if (key_validate(context->sec->request_key_auth) == 0) {
+			rka = context->sec->request_key_auth->payload.data;
 
 			key_ref = search_process_keyrings(type, description,
 							  match, rka->context);
 
-			up_read(&context->request_key_auth->sem);
+			up_read(&context->sec->request_key_auth->sem);
 
 			if (!IS_ERR(key_ref))
 				goto found;
@@ -535,7 +537,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 				break;
 			}
 		} else {
-			up_read(&context->request_key_auth->sem);
+			up_read(&context->sec->request_key_auth->sem);
 		}
 	}
 
@@ -577,7 +579,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 
 	switch (id) {
 	case KEY_SPEC_THREAD_KEYRING:
-		if (!context->thread_keyring) {
+		if (!context->sec->thread_keyring) {
 			if (!create)
 				goto error;
 
@@ -588,7 +590,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 			}
 		}
 
-		key = context->thread_keyring;
+		key = context->sec->thread_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
@@ -615,7 +617,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 			/* always install a session keyring upon access if one
 			 * doesn't exist yet */
 			ret = install_session_keyring(
-				context, context->user->session_keyring);
+				context, context->sec->user->session_keyring);
 			if (ret < 0)
 				goto error;
 		}
@@ -628,13 +630,13 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		break;
 
 	case KEY_SPEC_USER_KEYRING:
-		key = context->user->uid_keyring;
+		key = context->sec->user->uid_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_USER_SESSION_KEYRING:
-		key = context->user->session_keyring;
+		key = context->sec->user->session_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
@@ -645,7 +647,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		goto error;
 
 	case KEY_SPEC_REQKEY_AUTH_KEY:
-		key = context->request_key_auth;
+		key = context->sec->request_key_auth;
 		if (!key)
 			goto error;
 
@@ -747,7 +749,7 @@ long join_session_keyring(const char *name)
 	keyring = find_keyring_by_name(name, 0);
 	if (PTR_ERR(keyring) == -ENOKEY) {
 		/* not found - try and create a new one */
-		keyring = keyring_alloc(name, tsk->uid, tsk->gid, tsk,
+		keyring = keyring_alloc(name, tsk->sec->uid, tsk->sec->gid, tsk,
 					KEY_ALLOC_IN_QUOTA, NULL);
 		if (IS_ERR(keyring)) {
 			ret = PTR_ERR(keyring);
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 6d25911..54b03bb 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -76,7 +76,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 	/* allocate a new session keyring */
 	sprintf(desc, "_req.%u", key->serial);
 
-	keyring = keyring_alloc(desc, current_fsuid(), current->fsgid, current,
+	keyring = keyring_alloc(desc, current_fsuid(), current_fsgid(), current,
 				KEY_ALLOC_QUOTA_OVERRUN, NULL);
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
@@ -97,7 +97,8 @@ static int call_sbin_request_key(struct key_construction *cons,
 
 	/* we specify the process's default keyrings */
 	sprintf(keyring_str[0], "%d",
-		tsk->thread_keyring ? tsk->thread_keyring->serial : 0);
+		tsk->act_as->thread_keyring ?
+		tsk->act_as->thread_keyring->serial : 0);
 
 	prkey = 0;
 	if (tsk->signal->process_keyring)
@@ -110,7 +111,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 		sskey = rcu_dereference(tsk->signal->session_keyring)->serial;
 		rcu_read_unlock();
 	} else {
-		sskey = tsk->user->session_keyring->serial;
+		sskey = tsk->act_as->user->session_keyring->serial;
 	}
 
 	sprintf(keyring_str[2], "%d", sskey);
@@ -216,10 +217,10 @@ static void construct_key_make_link(struct key *key, struct key *dest_keyring)
 
 	/* find the appropriate keyring */
 	if (!dest_keyring) {
-		switch (tsk->jit_keyring) {
+		switch (tsk->act_as->jit_keyring) {
 		case KEY_REQKEY_DEFL_DEFAULT:
 		case KEY_REQKEY_DEFL_THREAD_KEYRING:
-			dest_keyring = tsk->thread_keyring;
+			dest_keyring = tsk->act_as->thread_keyring;
 			if (dest_keyring)
 				break;
 
@@ -239,11 +240,11 @@ static void construct_key_make_link(struct key *key, struct key *dest_keyring)
 				break;
 
 		case KEY_REQKEY_DEFL_USER_SESSION_KEYRING:
-			dest_keyring = tsk->user->session_keyring;
+			dest_keyring = tsk->act_as->user->session_keyring;
 			break;
 
 		case KEY_REQKEY_DEFL_USER_KEYRING:
-			dest_keyring = tsk->user->uid_keyring;
+			dest_keyring = tsk->act_as->user->uid_keyring;
 			break;
 
 		case KEY_REQKEY_DEFL_GROUP_KEYRING:
@@ -278,7 +279,7 @@ static int construct_alloc_key(struct key_type *type,
 	mutex_lock(&user->cons_lock);
 
 	key = key_alloc(type, description,
-			current_fsuid(), current->fsgid, current, KEY_POS_ALL,
+			current_fsuid(), current_fsgid(), current, KEY_POS_ALL,
 			flags);
 	if (IS_ERR(key))
 		goto alloc_failed;
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index cce6b4d..9598670 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -162,22 +162,22 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 
 	/* see if the calling process is already servicing the key request of
 	 * another process */
-	if (current->request_key_auth) {
+	if (current->act_as->request_key_auth) {
 		/* it is - use that instantiation context here too */
-		down_read(&current->request_key_auth->sem);
+		down_read(&current->act_as->request_key_auth->sem);
 
 		/* if the auth key has been revoked, then the key we're
 		 * servicing is already instantiated */
 		if (test_bit(KEY_FLAG_REVOKED,
-			     &current->request_key_auth->flags))
+			     &current->act_as->request_key_auth->flags))
 			goto auth_key_revoked;
 
-		irka = current->request_key_auth->payload.data;
+		irka = current->act_as->request_key_auth->payload.data;
 		rka->context = irka->context;
 		rka->pid = irka->pid;
 		get_task_struct(rka->context);
 
-		up_read(&current->request_key_auth->sem);
+		up_read(&current->act_as->request_key_auth->sem);
 	}
 	else {
 		/* it isn't - use this process as the context */
@@ -194,7 +194,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 	sprintf(desc, "%x", target->serial);
 
 	authkey = key_alloc(&key_type_request_key_auth, desc,
-			    current_fsuid(), current->fsgid, current,
+			    current_fsuid(), current_fsgid(), current,
 			    KEY_POS_VIEW | KEY_POS_READ | KEY_POS_SEARCH |
 			    KEY_USR_VIEW, KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(authkey)) {
@@ -211,7 +211,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 	return authkey;
 
 auth_key_revoked:
-	up_read(&current->request_key_auth->sem);
+	up_read(&current->act_as->request_key_auth->sem);
 	kfree(rka->callout_info);
 	kfree(rka);
 	kleave("= -EKEYREVOKED");
diff --git a/security/selinux/exports.c b/security/selinux/exports.c
index b6f9694..f660690 100644
--- a/security/selinux/exports.c
+++ b/security/selinux/exports.c
@@ -56,7 +56,7 @@ void selinux_get_ipc_sid(const struct kern_ipc_perm *ipcp, u32 *sid)
 void selinux_get_task_sid(struct task_struct *tsk, u32 *sid)
 {
 	if (selinux_enabled) {
-		struct task_security_struct *tsec = tsk->security;
+		struct task_security_struct *tsec = tsk->sec->security;
 		*sid = tsec->sid;
 		return;
 	}
@@ -77,7 +77,7 @@ EXPORT_SYMBOL_GPL(selinux_string_to_sid);
 int selinux_relabel_packet_permission(u32 sid)
 {
 	if (selinux_enabled) {
-		struct task_security_struct *tsec = current->security;
+		struct task_security_struct *tsec = current->act_as->security;
 
 		return avc_has_perm(tsec->sid, sid, SECCLASS_PACKET,
 				    PACKET__RELABELTO, NULL);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index bd4cfab..e56529f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -165,21 +165,21 @@ static int task_alloc_security(struct task_struct *task)
 
 	tsec->task = task;
 	tsec->osid = tsec->sid = tsec->ptrace_sid = SECINITSID_UNLABELED;
-	task->security = tsec;
+	task->sec->security = tsec;
 
 	return 0;
 }
 
 static void task_free_security(struct task_struct *task)
 {
-	struct task_security_struct *tsec = task->security;
-	task->security = NULL;
+	struct task_security_struct *tsec = task->sec->security;
+	task->sec->security = NULL;
 	kfree(tsec);
 }
 
 static int inode_alloc_security(struct inode *inode)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct inode_security_struct *isec;
 
 	isec = kmem_cache_zalloc(sel_inode_cache, GFP_KERNEL);
@@ -213,7 +213,7 @@ static void inode_free_security(struct inode *inode)
 
 static int file_alloc_security(struct file *file)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct file_security_struct *fsec;
 
 	fsec = kzalloc(sizeof(struct file_security_struct), GFP_KERNEL);
@@ -373,7 +373,7 @@ static int try_context_mount(struct super_block *sb, void *data)
 	const char *name;
 	u32 sid;
 	int alloc = 0, rc = 0, seen = 0;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct superblock_security_struct *sbsec = sb->s_security;
 
 	if (!data)
@@ -1033,8 +1033,8 @@ static int task_has_perm(struct task_struct *tsk1,
 {
 	struct task_security_struct *tsec1, *tsec2;
 
-	tsec1 = tsk1->security;
-	tsec2 = tsk2->security;
+	tsec1 = tsk1->act_as->security;
+	tsec2 = tsk2->sec->security;
 	return avc_has_perm(tsec1->sid, tsec2->sid,
 			    SECCLASS_PROCESS, perms, NULL);
 }
@@ -1046,7 +1046,7 @@ static int task_has_capability(struct task_struct *tsk,
 	struct task_security_struct *tsec;
 	struct avc_audit_data ad;
 
-	tsec = tsk->security;
+	tsec = tsk->sec->security;
 
 	AVC_AUDIT_DATA_INIT(&ad,CAP);
 	ad.tsk = tsk;
@@ -1062,7 +1062,7 @@ static int task_has_system(struct task_struct *tsk,
 {
 	struct task_security_struct *tsec;
 
-	tsec = tsk->security;
+	tsec = tsk->sec->security;
 
 	return avc_has_perm(tsec->sid, SECINITSID_KERNEL,
 			    SECCLASS_SYSTEM, perms, NULL);
@@ -1083,7 +1083,7 @@ static int inode_has_perm(struct task_struct *tsk,
 	if (unlikely (IS_PRIVATE (inode)))
 		return 0;
 
-	tsec = tsk->security;
+	tsec = tsk->sec->security;
 	isec = inode->i_security;
 
 	if (!adp) {
@@ -1123,7 +1123,7 @@ static int file_has_perm(struct task_struct *tsk,
 				struct file *file,
 				u32 av)
 {
-	struct task_security_struct *tsec = tsk->security;
+	struct task_security_struct *tsec = tsk->sec->security;
 	struct file_security_struct *fsec = file->f_security;
 	struct vfsmount *mnt = file->f_path.mnt;
 	struct dentry *dentry = file->f_path.dentry;
@@ -1163,7 +1163,7 @@ static int may_create(struct inode *dir,
 	struct avc_audit_data ad;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	dsec = dir->i_security;
 	sbsec = dir->i_sb->s_security;
 
@@ -1200,7 +1200,7 @@ static int may_create_key(u32 ksid,
 {
 	struct task_security_struct *tsec;
 
-	tsec = ctx->security;
+	tsec = ctx->sec->security;
 
 	return avc_has_perm(tsec->sid, ksid, SECCLASS_KEY, KEY__CREATE, NULL);
 }
@@ -1221,7 +1221,7 @@ static int may_link(struct inode *dir,
 	u32 av;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	dsec = dir->i_security;
 	isec = dentry->d_inode->i_security;
 
@@ -1265,7 +1265,7 @@ static inline int may_rename(struct inode *old_dir,
 	int old_is_dir, new_is_dir;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	old_dsec = old_dir->i_security;
 	old_isec = old_dentry->d_inode->i_security;
 	old_is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
@@ -1318,7 +1318,7 @@ static int superblock_has_perm(struct task_struct *tsk,
 	struct task_security_struct *tsec;
 	struct superblock_security_struct *sbsec;
 
-	tsec = tsk->security;
+	tsec = tsk->act_as->security;
 	sbsec = sb->s_security;
 	return avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
 			    perms, ad);
@@ -1373,8 +1373,8 @@ static inline u32 file_to_av(struct file *file)
 
 static int selinux_ptrace(struct task_struct *parent, struct task_struct *child)
 {
-	struct task_security_struct *psec = parent->security;
-	struct task_security_struct *csec = child->security;
+	struct task_security_struct *psec = parent->act_as->security;
+	struct task_security_struct *csec = child->sec->security;
 	int rc;
 
 	rc = secondary_ops->ptrace(parent,child);
@@ -1482,7 +1482,7 @@ static int selinux_sysctl(ctl_table *table, int op)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 
 	rc = selinux_sysctl_get_sid(table, (op == 0001) ?
 				    SECCLASS_DIR : SECCLASS_FILE, &tsid);
@@ -1591,7 +1591,7 @@ static int selinux_syslog(int type)
 static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int rc, cap_sys_admin = 0;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 
 	rc = secondary_ops->capable(current, CAP_SYS_ADMIN);
 	if (rc == 0)
@@ -1644,7 +1644,7 @@ static int selinux_bprm_set_security(struct linux_binprm *bprm)
 	if (bsec->set)
 		return 0;
 
-	tsec = current->security;
+	tsec = current->sec->security;
 	isec = inode->i_security;
 
 	/* Default to the current task SID. */
@@ -1710,7 +1710,7 @@ static int selinux_bprm_check_security (struct linux_binprm *bprm)
 
 static int selinux_bprm_secureexec (struct linux_binprm *bprm)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->sec->security;
 	int atsecure = 0;
 
 	if (tsec->osid != tsec->sid) {
@@ -1833,7 +1833,7 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 
 	secondary_ops->bprm_apply_creds(bprm, unsafe);
 
-	tsec = current->security;
+	tsec = current->sec->security;
 
 	bsec = bprm->security;
 	sid = bsec->sid;
@@ -1878,7 +1878,7 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
 	struct bprm_security_struct *bsec;
 	int rc, i;
 
-	tsec = current->security;
+	tsec = current->sec->security;
 	bsec = bprm->security;
 
 	if (bsec->unsafe) {
@@ -2133,7 +2133,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	int rc;
 	char *namep = NULL, *context;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	dsec = dir->i_security;
 	sbsec = dir->i_sb->s_security;
 
@@ -2318,7 +2318,7 @@ static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
 
 static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct inode *inode = dentry->d_inode;
 	struct inode_security_struct *isec = inode->i_security;
 	struct superblock_security_struct *sbsec;
@@ -2492,7 +2492,7 @@ static int selinux_revalidate_file_permission(struct file *file, int mask)
 static int selinux_file_permission(struct file *file, int mask)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->act_as->security;
 	struct file_security_struct *fsec = file->f_security;
 	struct inode_security_struct *isec = inode->i_security;
 
@@ -2600,7 +2600,8 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 			     unsigned long addr, unsigned long addr_only)
 {
 	int rc = 0;
-	u32 sid = ((struct task_security_struct*)(current->security))->sid;
+	u32 sid = ((struct task_security_struct *)
+		   (current->act_as->security))->sid;
 
 	if (addr < mmap_min_addr)
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
@@ -2712,7 +2713,7 @@ static int selinux_file_set_fowner(struct file *file)
 	struct task_security_struct *tsec;
 	struct file_security_struct *fsec;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	fsec = file->f_security;
 	fsec->fown_sid = tsec->sid;
 
@@ -2730,7 +2731,7 @@ static int selinux_file_send_sigiotask(struct task_struct *tsk,
 	/* struct fown_struct is never outside the context of a struct file */
         file = container_of(fown, struct file, f_owner);
 
-	tsec = tsk->security;
+	tsec = tsk->sec->security;
 	fsec = file->f_security;
 
 	if (!signum)
@@ -2793,12 +2794,12 @@ static int selinux_task_alloc_security(struct task_struct *tsk)
 	struct task_security_struct *tsec1, *tsec2;
 	int rc;
 
-	tsec1 = current->security;
+	tsec1 = current->act_as->security;
 
 	rc = task_alloc_security(tsk);
 	if (rc)
 		return rc;
-	tsec2 = tsk->security;
+	tsec2 = tsk->sec->security;
 
 	tsec2->osid = tsec1->osid;
 	tsec2->sid = tsec1->sid;
@@ -2955,7 +2956,7 @@ static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
 		perm = PROCESS__SIGNULL; /* null signal; existence test */
 	else
 		perm = signal_to_av(sig);
-	tsec = p->security;
+	tsec = p->sec->security;
 	if (secid)
 		rc = avc_has_perm(secid, tsec->sid, SECCLASS_PROCESS, perm, NULL);
 	else
@@ -2986,7 +2987,7 @@ static void selinux_task_reparent_to_init(struct task_struct *p)
 
 	secondary_ops->task_reparent_to_init(p);
 
-	tsec = p->security;
+	tsec = p->sec->security;
 	tsec->osid = tsec->sid;
 	tsec->sid = SECINITSID_KERNEL;
 	return;
@@ -2995,7 +2996,7 @@ static void selinux_task_reparent_to_init(struct task_struct *p)
 static void selinux_task_to_inode(struct task_struct *p,
 				  struct inode *inode)
 {
-	struct task_security_struct *tsec = p->security;
+	struct task_security_struct *tsec = p->sec->security;
 	struct inode_security_struct *isec = inode->i_security;
 
 	isec->sid = tsec->sid;
@@ -3227,7 +3228,7 @@ static int socket_has_perm(struct task_struct *task, struct socket *sock,
 	struct avc_audit_data ad;
 	int err = 0;
 
-	tsec = task->security;
+	tsec = task->act_as->security;
 	isec = SOCK_INODE(sock)->i_security;
 
 	if (isec->sid == SECINITSID_KERNEL)
@@ -3251,7 +3252,7 @@ static int selinux_socket_create(int family, int type,
 	if (kern)
 		goto out;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	newsid = tsec->sockcreate_sid ? : tsec->sid;
 	err = avc_has_perm(tsec->sid, newsid,
 			   socket_type_to_security_class(family, type,
@@ -3272,7 +3273,7 @@ static int selinux_socket_post_create(struct socket *sock, int family,
 
 	isec = SOCK_INODE(sock)->i_security;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	newsid = tsec->sockcreate_sid ? : tsec->sid;
 	isec->sclass = socket_type_to_security_class(family, type, protocol);
 	isec->sid = kern ? SECINITSID_KERNEL : newsid;
@@ -3317,7 +3318,7 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 		struct sock *sk = sock->sk;
 		u32 sid, node_perm, addrlen;
 
-		tsec = current->security;
+		tsec = current->act_as->security;
 		isec = SOCK_INODE(sock)->i_security;
 
 		if (family == PF_INET) {
@@ -4091,7 +4092,7 @@ static int ipc_alloc_security(struct task_struct *task,
 			      struct kern_ipc_perm *perm,
 			      u16 sclass)
 {
-	struct task_security_struct *tsec = task->security;
+	struct task_security_struct *tsec = task->act_as->security;
 	struct ipc_security_struct *isec;
 
 	isec = kzalloc(sizeof(struct ipc_security_struct), GFP_KERNEL);
@@ -4143,7 +4144,7 @@ static int ipc_has_perm(struct kern_ipc_perm *ipc_perms,
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = ipc_perms->security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4174,7 +4175,7 @@ static int selinux_msg_queue_alloc_security(struct msg_queue *msq)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = msq->q_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4200,7 +4201,7 @@ static int selinux_msg_queue_associate(struct msg_queue *msq, int msqflg)
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = msq->q_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4246,7 +4247,7 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 	struct avc_audit_data ad;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = msq->q_perm.security;
 	msec = msg->security;
 
@@ -4294,7 +4295,7 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 	struct avc_audit_data ad;
 	int rc;
 
-	tsec = target->security;
+	tsec = target->act_as->security;
 	isec = msq->q_perm.security;
 	msec = msg->security;
 
@@ -4321,7 +4322,7 @@ static int selinux_shm_alloc_security(struct shmid_kernel *shp)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = shp->shm_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4347,7 +4348,7 @@ static int selinux_shm_associate(struct shmid_kernel *shp, int shmflg)
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = shp->shm_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4420,7 +4421,7 @@ static int selinux_sem_alloc_security(struct sem_array *sma)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = sma->sem_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4446,7 +4447,7 @@ static int selinux_sem_associate(struct sem_array *sma, int semflg)
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->act_as->security;
 	isec = sma->sem_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4565,7 +4566,7 @@ static int selinux_getprocattr(struct task_struct *p,
 			return error;
 	}
 
-	tsec = p->security;
+	tsec = p->sec->security;
 
 	if (!strcmp(name, "current"))
 		sid = tsec->sid;
@@ -4642,7 +4643,7 @@ static int selinux_setprocattr(struct task_struct *p,
 	   operation.  See selinux_bprm_set_security for the execve
 	   checks and may_create for the file creation checks. The
 	   operation will then fail if the context is not permitted. */
-	tsec = p->security;
+	tsec = p->sec->security;
 	if (!strcmp(name, "exec"))
 		tsec->exec_sid = sid;
 	else if (!strcmp(name, "fscreate"))
@@ -4720,7 +4721,7 @@ static void selinux_release_secctx(char *secdata, u32 seclen)
 static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
 			     unsigned long flags)
 {
-	struct task_security_struct *tsec = tsk->security;
+	struct task_security_struct *tsec = tsk->sec->security;
 	struct key_security_struct *ksec;
 
 	ksec = kzalloc(sizeof(struct key_security_struct), GFP_KERNEL);
@@ -4755,7 +4756,7 @@ static int selinux_key_permission(key_ref_t key_ref,
 
 	key = key_ref_to_ptr(key_ref);
 
-	tsec = ctx->security;
+	tsec = ctx->sec->security;
 	ksec = key->security;
 
 	/* if no specific permissions are requested, we skip the
@@ -4978,7 +4979,7 @@ static __init int selinux_init(void)
 	/* Set the security state for the initial task. */
 	if (task_alloc_security(current))
 		panic("SELinux:  Failed to initialize initial task.\n");
-	tsec = current->security;
+	tsec = current->sec->security;
 	tsec->osid = tsec->sid = SECINITSID_KERNEL;
 
 	sel_inode_cache = kmem_cache_create("selinux_inode_security",
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 2fa483f..ad306e1 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -80,7 +80,7 @@ static int task_has_security(struct task_struct *tsk,
 {
 	struct task_security_struct *tsec;
 
-	tsec = tsk->security;
+	tsec = tsk->act_as->security;
 	if (!tsec)
 		return -EACCES;
 


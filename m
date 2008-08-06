Return-Path: <linux-kernel-owner+w=401wt.eu-S1030770AbYHFPwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030770AbYHFPwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbYHFPix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:38:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759656AbYHFPia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:38:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/24] CRED: Separate task security context from task_struct
	[ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:37:55 +0100
Message-ID: <20080806153755.14351.66357.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
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

Note that the Alpha arch is altered as it refers to (E)UID and (E)GID in
entry.S via asm-offsets.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 arch/alpha/kernel/asm-offsets.c   |   11 +-
 arch/alpha/kernel/entry.S         |   10 +
 arch/mips/kernel/kspd.c           |    4 -
 arch/s390/kernel/compat_linux.c   |   28 ++--
 arch/sparc64/kernel/sys_sparc32.c |   28 ++--
 drivers/connector/cn_proc.c       |    8 +
 fs/binfmt_elf.c                   |   12 +-
 fs/binfmt_elf_fdpic.c             |   12 +-
 fs/exec.c                         |    4 -
 fs/fcntl.c                        |    4 -
 fs/file_table.c                   |    4 -
 fs/fuse/dir.c                     |   12 +-
 fs/hugetlbfs/inode.c              |    4 -
 fs/ioprio.c                       |   12 +-
 fs/nfsd/auth.c                    |   22 ++-
 fs/nfsd/nfs4recover.c             |   12 +-
 fs/nfsd/nfsfh.c                   |    6 -
 fs/open.c                         |   17 +-
 fs/proc/array.c                   |   18 +--
 fs/proc/base.c                    |   16 +-
 fs/xfs/linux-2.6/xfs_cred.h       |    6 -
 fs/xfs/linux-2.6/xfs_globals.h    |    2 
 fs/xfs/linux-2.6/xfs_ioctl.c      |    2 
 fs/xfs/xfs_inode.h                |    2 
 fs/xfs/xfs_vnodeops.h             |   10 +
 include/linux/cred.h              |  155 +++++++++++++++++++---
 include/linux/init_task.h         |   24 ++-
 include/linux/sched.h             |   52 +------
 include/linux/securebits.h        |    2 
 ipc/mqueue.c                      |    2 
 ipc/shm.c                         |    4 -
 kernel/auditsc.c                  |   44 +++---
 kernel/capability.c               |    4 -
 kernel/cgroup.c                   |    4 -
 kernel/exit.c                     |   10 +
 kernel/fork.c                     |   24 ++-
 kernel/futex.c                    |    6 +
 kernel/futex_compat.c             |    5 -
 kernel/ptrace.c                   |   19 +--
 kernel/sched.c                    |   10 +
 kernel/signal.c                   |   16 +-
 kernel/sys.c                      |  261 +++++++++++++++++++++----------------
 kernel/trace/trace.c              |    2 
 kernel/tsacct.c                   |    4 -
 kernel/uid16.c                    |   28 ++--
 kernel/user.c                     |    4 -
 mm/mempolicy.c                    |   10 +
 mm/migrate.c                      |   10 +
 mm/oom_kill.c                     |    2 
 net/core/scm.c                    |   10 +
 net/sunrpc/auth.c                 |    2 
 security/commoncap.c              |  152 +++++++++++-----------
 security/keys/keyctl.c            |   25 ++--
 security/keys/permission.c        |   11 +-
 security/keys/process_keys.c      |   98 +++++++-------
 security/keys/request_key.c       |   18 +--
 security/keys/request_key_auth.c  |   12 +-
 security/selinux/exports.c        |    2 
 security/selinux/hooks.c          |  120 +++++++++--------
 security/selinux/selinuxfs.c      |    2 
 security/selinux/xfrm.c           |    6 -
 security/smack/smack_access.c     |    4 -
 security/smack/smack_lsm.c        |   77 ++++++-----
 security/smack/smackfs.c          |    6 -
 64 files changed, 832 insertions(+), 681 deletions(-)


diff --git a/arch/alpha/kernel/asm-offsets.c b/arch/alpha/kernel/asm-offsets.c
index 4b18cd9..6ff8886 100644
--- a/arch/alpha/kernel/asm-offsets.c
+++ b/arch/alpha/kernel/asm-offsets.c
@@ -19,15 +19,18 @@ void foo(void)
 	BLANK();
 
         DEFINE(TASK_BLOCKED, offsetof(struct task_struct, blocked));
-        DEFINE(TASK_UID, offsetof(struct task_struct, uid));
-        DEFINE(TASK_EUID, offsetof(struct task_struct, euid));
-        DEFINE(TASK_GID, offsetof(struct task_struct, gid));
-        DEFINE(TASK_EGID, offsetof(struct task_struct, egid));
+        DEFINE(TASK_CRED, offsetof(struct task_struct, cred));
         DEFINE(TASK_REAL_PARENT, offsetof(struct task_struct, real_parent));
         DEFINE(TASK_GROUP_LEADER, offsetof(struct task_struct, group_leader));
         DEFINE(TASK_TGID, offsetof(struct task_struct, tgid));
         BLANK();
 
+        DEFINE(CRED_UID,  offsetof(struct cred, uid));
+        DEFINE(CRED_EUID, offsetof(struct cred, euid));
+        DEFINE(CRED_GID,  offsetof(struct cred, gid));
+        DEFINE(CRED_EGID, offsetof(struct cred, egid));
+        BLANK();
+
 	DEFINE(SIZEOF_PT_REGS, sizeof(struct pt_regs));
 	DEFINE(PT_PTRACED, PT_PTRACED);
 	DEFINE(CLONE_VM, CLONE_VM);
diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index 5fc61e2..f77345b 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -850,8 +850,9 @@ osf_getpriority:
 sys_getxuid:
 	.prologue 0
 	ldq	$2, TI_TASK($8)
-	ldl	$0, TASK_UID($2)
-	ldl	$1, TASK_EUID($2)
+	ldq	$3, TASK_CRED($2)
+	ldl	$0, CRED_UID($3)
+	ldl	$1, CRED_EUID($3)
 	stq	$1, 80($sp)
 	ret
 .end sys_getxuid
@@ -862,8 +863,9 @@ sys_getxuid:
 sys_getxgid:
 	.prologue 0
 	ldq	$2, TI_TASK($8)
-	ldl	$0, TASK_GID($2)
-	ldl	$1, TASK_EGID($2)
+	ldq	$3, TASK_CRED($2)
+	ldl	$0, CRED_GID($3)
+	ldl	$1, CRED_EGID($3)
 	stq	$1, 80($sp)
 	ret
 .end sys_getxgid
diff --git a/arch/mips/kernel/kspd.c b/arch/mips/kernel/kspd.c
index b0591ae..fd6e512 100644
--- a/arch/mips/kernel/kspd.c
+++ b/arch/mips/kernel/kspd.c
@@ -174,8 +174,8 @@ static unsigned int translate_open_flags(int flags)
 
 static void sp_setfsuidgid( uid_t uid, gid_t gid)
 {
-	current->fsuid = uid;
-	current->fsgid = gid;
+	current->cred->fsuid = uid;
+	current->cred->fsgid = gid;
 
 	key_fsuid_changed(current);
 	key_fsgid_changed(current);
diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index d7f2222..4ae7268 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -148,9 +148,9 @@ asmlinkage long sys32_getresuid16(u16 __user *ruid, u16 __user *euid, u16 __user
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowuid(current->uid), ruid)) &&
-	    !(retval = put_user(high2lowuid(current->euid), euid)))
-		retval = put_user(high2lowuid(current->suid), suid);
+	if (!(retval = put_user(high2lowuid(current->cred->uid), ruid)) &&
+	    !(retval = put_user(high2lowuid(current->cred->euid), euid)))
+		retval = put_user(high2lowuid(current->cred->suid), suid);
 
 	return retval;
 }
@@ -165,9 +165,9 @@ asmlinkage long sys32_getresgid16(u16 __user *rgid, u16 __user *egid, u16 __user
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowgid(current->gid), rgid)) &&
-	    !(retval = put_user(high2lowgid(current->egid), egid)))
-		retval = put_user(high2lowgid(current->sgid), sgid);
+	if (!(retval = put_user(high2lowgid(current->cred->gid), rgid)) &&
+	    !(retval = put_user(high2lowgid(current->cred->egid), egid)))
+		retval = put_user(high2lowgid(current->cred->sgid), sgid);
 
 	return retval;
 }
@@ -217,20 +217,20 @@ asmlinkage long sys32_getgroups16(int gidsetsize, u16 __user *grouplist)
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	get_group_info(current->cred->group_info);
+	i = current->cred->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, current->cred->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
+	put_group_info(current->cred->group_info);
 	return i;
 }
 
@@ -261,22 +261,22 @@ asmlinkage long sys32_setgroups16(int gidsetsize, u16 __user *grouplist)
 
 asmlinkage long sys32_getuid16(void)
 {
-	return high2lowuid(current->uid);
+	return high2lowuid(current->cred->uid);
 }
 
 asmlinkage long sys32_geteuid16(void)
 {
-	return high2lowuid(current->euid);
+	return high2lowuid(current->cred->euid);
 }
 
 asmlinkage long sys32_getgid16(void)
 {
-	return high2lowgid(current->gid);
+	return high2lowgid(current->cred->gid);
 }
 
 asmlinkage long sys32_getegid16(void)
 {
-	return high2lowgid(current->egid);
+	return high2lowgid(current->cred->egid);
 }
 
 /* 32-bit timeval and related flotsam.  */
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index 97b77fb..3546500 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -103,9 +103,9 @@ asmlinkage long sys32_getresuid16(u16 __user *ruid, u16 __user *euid, u16 __user
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowuid(current->uid), ruid)) &&
-	    !(retval = put_user(high2lowuid(current->euid), euid)))
-		retval = put_user(high2lowuid(current->suid), suid);
+	if (!(retval = put_user(high2lowuid(current->cred->uid), ruid)) &&
+	    !(retval = put_user(high2lowuid(current->cred->euid), euid)))
+		retval = put_user(high2lowuid(current->cred->suid), suid);
 
 	return retval;
 }
@@ -120,9 +120,9 @@ asmlinkage long sys32_getresgid16(u16 __user *rgid, u16 __user *egid, u16 __user
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowgid(current->gid), rgid)) &&
-	    !(retval = put_user(high2lowgid(current->egid), egid)))
-		retval = put_user(high2lowgid(current->sgid), sgid);
+	if (!(retval = put_user(high2lowgid(current->cred->gid), rgid)) &&
+	    !(retval = put_user(high2lowgid(current->cred->egid), egid)))
+		retval = put_user(high2lowgid(current->cred->sgid), sgid);
 
 	return retval;
 }
@@ -172,20 +172,20 @@ asmlinkage long sys32_getgroups16(int gidsetsize, u16 __user *grouplist)
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	get_group_info(current->cred->group_info);
+	i = current->cred->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, current->cred->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
+	put_group_info(current->cred->group_info);
 	return i;
 }
 
@@ -216,22 +216,22 @@ asmlinkage long sys32_setgroups16(int gidsetsize, u16 __user *grouplist)
 
 asmlinkage long sys32_getuid16(void)
 {
-	return high2lowuid(current->uid);
+	return high2lowuid(current->cred->uid);
 }
 
 asmlinkage long sys32_geteuid16(void)
 {
-	return high2lowuid(current->euid);
+	return high2lowuid(current->cred->euid);
 }
 
 asmlinkage long sys32_getgid16(void)
 {
-	return high2lowgid(current->gid);
+	return high2lowgid(current->cred->gid);
 }
 
 asmlinkage long sys32_getegid16(void)
 {
-	return high2lowgid(current->egid);
+	return high2lowgid(current->cred->egid);
 }
 
 /* 32-bit timeval and related flotsam.  */
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 5c9f67f..354c1ff 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -116,11 +116,11 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	ev->event_data.id.process_pid = task->pid;
 	ev->event_data.id.process_tgid = task->tgid;
 	if (which_id == PROC_EVENT_UID) {
-	 	ev->event_data.id.r.ruid = task->uid;
-	 	ev->event_data.id.e.euid = task->euid;
+		ev->event_data.id.r.ruid = task->cred->uid;
+		ev->event_data.id.e.euid = task->cred->euid;
 	} else if (which_id == PROC_EVENT_GID) {
-	   	ev->event_data.id.r.rgid = task->gid;
-	   	ev->event_data.id.e.egid = task->egid;
+		ev->event_data.id.r.rgid = task->cred->gid;
+		ev->event_data.id.e.egid = task->cred->egid;
 	} else
 	     	return;
 	get_seq(&msg->seq, &ev->cpu);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 655ed8d..0bf141e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -223,10 +223,10 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
 	NEW_AUX_ENT(AT_FLAGS, 0);
 	NEW_AUX_ENT(AT_ENTRY, exec->e_entry);
-	NEW_AUX_ENT(AT_UID, tsk->uid);
-	NEW_AUX_ENT(AT_EUID, tsk->euid);
-	NEW_AUX_ENT(AT_GID, tsk->gid);
-	NEW_AUX_ENT(AT_EGID, tsk->egid);
+	NEW_AUX_ENT(AT_UID, tsk->cred->uid);
+	NEW_AUX_ENT(AT_EUID, tsk->cred->euid);
+	NEW_AUX_ENT(AT_GID, tsk->cred->gid);
+	NEW_AUX_ENT(AT_EGID, tsk->cred->egid);
  	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
 	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
 	if (k_platform) {
@@ -1385,8 +1385,8 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	psinfo->pr_zomb = psinfo->pr_sname == 'Z';
 	psinfo->pr_nice = task_nice(p);
 	psinfo->pr_flag = p->flags;
-	SET_UID(psinfo->pr_uid, p->uid);
-	SET_GID(psinfo->pr_gid, p->gid);
+	SET_UID(psinfo->pr_uid, p->cred->uid);
+	SET_GID(psinfo->pr_gid, p->cred->gid);
 	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 	
 	return 0;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index cee7ed4..779423e 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -586,10 +586,10 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	NEW_AUX_ENT(AT_BASE,	interp_params->elfhdr_addr);
 	NEW_AUX_ENT(AT_FLAGS,	0);
 	NEW_AUX_ENT(AT_ENTRY,	exec_params->entry_addr);
-	NEW_AUX_ENT(AT_UID,	(elf_addr_t) current_uid());
-	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current_euid());
-	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current_gid());
-	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current_egid());
+	NEW_AUX_ENT(AT_UID,	(elf_addr_t) current->cred->uid);
+	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current->cred->euid);
+	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current->cred->gid);
+	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current->cred->egid);
 
 #ifdef ARCH_DLINFO
 	nr = 0;
@@ -1406,8 +1406,8 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	psinfo->pr_zomb = psinfo->pr_sname == 'Z';
 	psinfo->pr_nice = task_nice(p);
 	psinfo->pr_flag = p->flags;
-	SET_UID(psinfo->pr_uid, p->uid);
-	SET_GID(psinfo->pr_gid, p->gid);
+	SET_UID(psinfo->pr_uid, p->cred->uid);
+	SET_GID(psinfo->pr_gid, p->cred->gid);
 	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 
 	return 0;
diff --git a/fs/exec.c b/fs/exec.c
index 08c884c..93e9b1c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1744,7 +1744,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 */
 	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
-		current->fsuid = 0;	/* Dump root private */
+		current->cred->fsuid = 0;	/* Dump root private */
 	}
 
 	retval = coredump_wait(exit_code, &core_state);
@@ -1840,7 +1840,7 @@ fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
 
-	current->fsuid = fsuid;
+	current->cred->fsuid = fsuid;
 	coredump_finish(mm);
 fail:
 	return retval;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index bf049a8..63964d8 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -401,8 +401,8 @@ static inline int sigio_perm(struct task_struct *p,
                              struct fown_struct *fown, int sig)
 {
 	return (((fown->euid == 0) ||
-		 (fown->euid == p->suid) || (fown->euid == p->uid) ||
-		 (fown->uid == p->suid) || (fown->uid == p->uid)) &&
+		 (fown->euid == p->cred->suid) || (fown->euid == p->cred->uid) ||
+		 (fown->uid == p->cred->suid) || (fown->uid == p->cred->uid)) &&
 		!security_file_send_sigiotask(p, fown, sig));
 }
 
diff --git a/fs/file_table.c b/fs/file_table.c
index f45a449..a807eb0 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -122,8 +122,8 @@ struct file *get_empty_filp(void)
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_long_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
-	f->f_uid = tsk->fsuid;
-	f->f_gid = tsk->fsgid;
+	f->f_uid = tsk->cred->fsuid;
+	f->f_gid = tsk->cred->fsgid;
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
 	return f;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index fd03330..e97a989 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -872,12 +872,12 @@ int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task)
 	if (fc->flags & FUSE_ALLOW_OTHER)
 		return 1;
 
-	if (task->euid == fc->user_id &&
-	    task->suid == fc->user_id &&
-	    task->uid == fc->user_id &&
-	    task->egid == fc->group_id &&
-	    task->sgid == fc->group_id &&
-	    task->gid == fc->group_id)
+	if (task->cred->euid == fc->user_id &&
+	    task->cred->suid == fc->user_id &&
+	    task->cred->uid == fc->user_id &&
+	    task->cred->egid == fc->group_id &&
+	    task->cred->sgid == fc->group_id &&
+	    task->cred->gid == fc->group_id)
 		return 1;
 
 	return 0;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 4c428f5..0cecb9e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -958,7 +958,7 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
 	if (!can_do_hugetlb_shm())
 		return ERR_PTR(-EPERM);
 
-	if (!user_shm_lock(size, current->user))
+	if (!user_shm_lock(size, current->cred->user))
 		return ERR_PTR(-ENOMEM);
 
 	root = hugetlbfs_vfsmount->mnt_root;
@@ -998,7 +998,7 @@ out_inode:
 out_dentry:
 	dput(dentry);
 out_shm_unlock:
-	user_shm_unlock(size, current->user);
+	user_shm_unlock(size, current->cred->user);
 	return ERR_PTR(error);
 }
 
diff --git a/fs/ioprio.c b/fs/ioprio.c
index b1214b9..fa55afc 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -32,8 +32,8 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
 	int err;
 	struct io_context *ioc;
 
-	if (task->uid != current_euid() &&
-	    task->uid != current_uid() && !capable(CAP_SYS_NICE))
+	if (task->cred->uid != current_euid() &&
+	    task->cred->uid != current_uid() && !capable(CAP_SYS_NICE))
 		return -EPERM;
 
 	err = security_task_setioprio(task, ioprio);
@@ -123,7 +123,7 @@ asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
-				user = current->user;
+				user = current->cred->user;
 			else
 				user = find_user(who);
 
@@ -131,7 +131,7 @@ asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 				break;
 
 			do_each_thread(g, p) {
-				if (p->uid != who)
+				if (p->cred->uid != who)
 					continue;
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
@@ -216,7 +216,7 @@ asmlinkage long sys_ioprio_get(int which, int who)
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
-				user = current->user;
+				user = current->cred->user;
 			else
 				user = find_user(who);
 
@@ -224,7 +224,7 @@ asmlinkage long sys_ioprio_get(int which, int who)
 				break;
 
 			do_each_thread(g, p) {
-				if (p->uid != user->uid)
+				if (p->cred->uid != user->uid)
 					continue;
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 294992e..808fc03 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -27,6 +27,7 @@ int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
 
 int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 {
+	struct cred *act_as = current->cred ;
 	struct svc_cred	cred = rqstp->rq_cred;
 	int i;
 	int flags = nfsexp_flags(rqstp, exp);
@@ -55,25 +56,26 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 		get_group_info(cred.cr_group_info);
 
 	if (cred.cr_uid != (uid_t) -1)
-		current->fsuid = cred.cr_uid;
+		act_as->fsuid = cred.cr_uid;
 	else
-		current->fsuid = exp->ex_anon_uid;
+		act_as->fsuid = exp->ex_anon_uid;
 	if (cred.cr_gid != (gid_t) -1)
-		current->fsgid = cred.cr_gid;
+		act_as->fsgid = cred.cr_gid;
 	else
-		current->fsgid = exp->ex_anon_gid;
+		act_as->fsgid = exp->ex_anon_gid;
 
 	if (!cred.cr_group_info)
 		return -ENOMEM;
-	ret = set_current_groups(cred.cr_group_info);
+	ret = set_groups(act_as, cred.cr_group_info);
 	put_group_info(cred.cr_group_info);
 	if ((cred.cr_uid)) {
-		current->cap_effective =
-			cap_drop_nfsd_set(current->cap_effective);
+		act_as->cap_effective =
+			cap_drop_nfsd_set(act_as->cap_effective);
 	} else {
-		current->cap_effective =
-			cap_raise_nfsd_set(current->cap_effective,
-					   current->cap_permitted);
+		act_as->cap_effective =
+			cap_raise_nfsd_set(act_as->cap_effective,
+					   act_as->cap_permitted);
 	}
 	return ret;
 }
+
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 145b3c8..6e751e7 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -57,17 +57,17 @@ static int rec_dir_init = 0;
 static void
 nfs4_save_user(uid_t *saveuid, gid_t *savegid)
 {
-	*saveuid = current->fsuid;
-	*savegid = current->fsgid;
-	current->fsuid = 0;
-	current->fsgid = 0;
+	*saveuid = current->cred->fsuid;
+	*savegid = current->cred->fsgid;
+	current->cred->fsuid = 0;
+	current->cred->fsgid = 0;
 }
 
 static void
 nfs4_reset_user(uid_t saveuid, gid_t savegid)
 {
-	current->fsuid = saveuid;
-	current->fsgid = savegid;
+	current->cred->fsuid = saveuid;
+	current->cred->fsgid = savegid;
 }
 
 static void
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index ea37c96..54be127 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -186,9 +186,9 @@ static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
 		 * access control settings being in effect, we cannot
 		 * fix that case easily.
 		 */
-		current->cap_effective =
-			cap_raise_nfsd_set(current->cap_effective,
-					   current->cap_permitted);
+		current->cred->cap_effective =
+			cap_raise_nfsd_set(current->cred->cap_effective,
+					   current->cred->cap_permitted);
 	} else {
 		error = nfsd_setuser_and_check_port(rqstp, exp);
 		if (error)
diff --git a/fs/open.c b/fs/open.c
index 0f410b1..a8ddf81 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -425,6 +425,7 @@ out:
  */
 asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 {
+	struct cred *cred = current->cred;
 	struct path path;
 	struct inode *inode;
 	int old_fsuid, old_fsgid;
@@ -434,18 +435,18 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
 
-	old_fsuid = current->fsuid;
-	old_fsgid = current->fsgid;
+	old_fsuid = cred->fsuid;
+	old_fsgid = cred->fsgid;
 
-	current->fsuid = current->uid;
-	current->fsgid = current->gid;
+	cred->fsuid = cred->uid;
+	cred->fsgid = cred->gid;
 
 	if (!issecure(SECURE_NO_SETUID_FIXUP)) {
 		/* Clear the capabilities if we switch to a non-root user */
-		if (current->uid)
+		if (current->cred->uid)
 			old_cap = cap_set_effective(__cap_empty_set);
 		else
-			old_cap = cap_set_effective(current->cap_permitted);
+			old_cap = cap_set_effective(cred->cap_permitted);
 	}
 
 	res = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
@@ -484,8 +485,8 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 out_path_release:
 	path_put(&path);
 out:
-	current->fsuid = old_fsuid;
-	current->fsgid = old_fsgid;
+	cred->fsuid = old_fsuid;
+	cred->fsgid = old_fsgid;
 
 	if (!issecure(SECURE_NO_SETUID_FIXUP))
 		cap_set_effective(old_cap);
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 0d6eb33..af0962b 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -187,8 +187,8 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		task_tgid_nr_ns(p, ns),
 		pid_nr_ns(pid, ns),
 		ppid, tpid,
-		p->uid, p->euid, p->suid, p->fsuid,
-		p->gid, p->egid, p->sgid, p->fsgid);
+		p->cred->uid, p->cred->euid, p->cred->suid, p->cred->fsuid,
+		p->cred->gid, p->cred->egid, p->cred->sgid, p->cred->fsgid);
 
 	task_lock(p);
 	if (p->files)
@@ -199,7 +199,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		fdt ? fdt->max_fds : 0);
 	rcu_read_unlock();
 
-	group_info = p->group_info;
+	group_info = p->cred->group_info;
 	get_group_info(group_info);
 	task_unlock(p);
 
@@ -268,7 +268,7 @@ static inline void task_sig(struct seq_file *m, struct task_struct *p)
 		blocked = p->blocked;
 		collect_sigign_sigcatch(p, &ignored, &caught);
 		num_threads = atomic_read(&p->signal->count);
-		qsize = atomic_read(&p->user->sigpending);
+		qsize = atomic_read(&p->cred->user->sigpending);
 		qlim = p->signal->rlim[RLIMIT_SIGPENDING].rlim_cur;
 		unlock_task_sighand(p, &flags);
 	}
@@ -300,10 +300,12 @@ static void render_cap_t(struct seq_file *m, const char *header,
 
 static inline void task_cap(struct seq_file *m, struct task_struct *p)
 {
-	render_cap_t(m, "CapInh:\t", &p->cap_inheritable);
-	render_cap_t(m, "CapPrm:\t", &p->cap_permitted);
-	render_cap_t(m, "CapEff:\t", &p->cap_effective);
-	render_cap_t(m, "CapBnd:\t", &p->cap_bset);
+	struct cred *cred = p->cred;
+
+	render_cap_t(m, "CapInh:\t", &cred->cap_inheritable);
+	render_cap_t(m, "CapPrm:\t", &cred->cap_permitted);
+	render_cap_t(m, "CapEff:\t", &cred->cap_effective);
+	render_cap_t(m, "CapBnd:\t", &cred->cap_bset);
 }
 
 static inline void task_context_switch_counts(struct seq_file *m,
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 01ed610..96fb315 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1436,8 +1436,8 @@ static struct inode *proc_pid_make_inode(struct super_block * sb, struct task_st
 	inode->i_uid = 0;
 	inode->i_gid = 0;
 	if (task_dumpable(task)) {
-		inode->i_uid = task->euid;
-		inode->i_gid = task->egid;
+		inode->i_uid = task->cred->euid;
+		inode->i_gid = task->cred->egid;
 	}
 	security_task_to_inode(task, inode);
 
@@ -1462,8 +1462,8 @@ static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat
 	if (task) {
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
-			stat->uid = task->euid;
-			stat->gid = task->egid;
+			stat->uid = task->cred->euid;
+			stat->gid = task->cred->egid;
 		}
 	}
 	rcu_read_unlock();
@@ -1494,8 +1494,8 @@ static int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
 	if (task) {
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
-			inode->i_uid = task->euid;
-			inode->i_gid = task->egid;
+			inode->i_uid = task->cred->euid;
+			inode->i_gid = task->cred->egid;
 		} else {
 			inode->i_uid = 0;
 			inode->i_gid = 0;
@@ -1666,8 +1666,8 @@ static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
 				rcu_read_unlock();
 				put_files_struct(files);
 				if (task_dumpable(task)) {
-					inode->i_uid = task->euid;
-					inode->i_gid = task->egid;
+					inode->i_uid = task->cred->euid;
+					inode->i_gid = task->cred->egid;
 				} else {
 					inode->i_uid = 0;
 					inode->i_gid = 0;
diff --git a/fs/xfs/linux-2.6/xfs_cred.h b/fs/xfs/linux-2.6/xfs_cred.h
index 293043a..8c022cd 100644
--- a/fs/xfs/linux-2.6/xfs_cred.h
+++ b/fs/xfs/linux-2.6/xfs_cred.h
@@ -23,11 +23,9 @@
 /*
  * Credentials
  */
-typedef struct cred {
-       /* EMPTY */
-} cred_t;
+typedef const struct cred cred_t;
 
-extern struct cred *sys_cred;
+extern cred_t *sys_cred;
 
 /* this is a hack.. (assumes sys_cred is the only cred_t in the system) */
 static inline int capable_cred(cred_t *cr, int cid)
diff --git a/fs/xfs/linux-2.6/xfs_globals.h b/fs/xfs/linux-2.6/xfs_globals.h
index 2770b00..6eda8a3 100644
--- a/fs/xfs/linux-2.6/xfs_globals.h
+++ b/fs/xfs/linux-2.6/xfs_globals.h
@@ -19,6 +19,6 @@
 #define __XFS_GLOBALS_H__
 
 extern uint64_t	xfs_panic_mask;		/* set to cause more panics */
-extern struct cred *sys_cred;
+extern cred_t *sys_cred;
 
 #endif	/* __XFS_GLOBALS_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index acb978d..acc3fd9 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1008,7 +1008,7 @@ xfs_ioctl_setattr(
 	 * to the file owner ID, except in cases where the
 	 * CAP_FSETID capability is applicable.
 	 */
-	if (current->fsuid != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
+	if (current_fsuid() != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
 		code = XFS_ERROR(EPERM);
 		goto error_return;
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 17a04b6..171e939 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -492,7 +492,7 @@ int		xfs_iread(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 			  xfs_inode_t **, xfs_daddr_t, uint);
 int		xfs_iread_extents(struct xfs_trans *, xfs_inode_t *, int);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
-			   xfs_nlink_t, xfs_dev_t, struct cred *, xfs_prid_t,
+			   xfs_nlink_t, xfs_dev_t, cred_t *, xfs_prid_t,
 			   int, struct xfs_buf **, boolean_t *, xfs_inode_t **);
 void		xfs_dinode_from_disk(struct xfs_icdinode *,
 				     struct xfs_dinode_core *);
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index e932a96..7b0c2ab 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -16,7 +16,7 @@ struct xfs_iomap;
 
 int xfs_open(struct xfs_inode *ip);
 int xfs_setattr(struct xfs_inode *ip, struct iattr *vap, int flags,
-		struct cred *credp);
+		cred_t *credp);
 #define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */
 #define	XFS_ATTR_NONBLOCK	0x02	/* return EAGAIN if operation would block */
 #define XFS_ATTR_NOLOCK		0x04	/* Don't grab any conflicting locks */
@@ -28,24 +28,24 @@ int xfs_inactive(struct xfs_inode *ip);
 int xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode **ipp, struct xfs_name *ci_name);
 int xfs_create(struct xfs_inode *dp, struct xfs_name *name, mode_t mode,
-		xfs_dev_t rdev, struct xfs_inode **ipp, struct cred *credp);
+		xfs_dev_t rdev, struct xfs_inode **ipp, cred_t *credp);
 int xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
 int xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
 		struct xfs_name *target_name);
 int xfs_mkdir(struct xfs_inode *dp, struct xfs_name *dir_name,
-		mode_t mode, struct xfs_inode **ipp, struct cred *credp);
+		mode_t mode, struct xfs_inode **ipp, cred_t *credp);
 int xfs_readdir(struct xfs_inode	*dp, void *dirent, size_t bufsize,
 		       xfs_off_t *offset, filldir_t filldir);
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 		const char *target_path, mode_t mode, struct xfs_inode **ipp,
-		struct cred *credp);
+		cred_t *credp);
 int xfs_inode_flush(struct xfs_inode *ip, int flags);
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
 int xfs_reclaim(struct xfs_inode *ip);
 int xfs_change_file_space(struct xfs_inode *ip, int cmd,
 		xfs_flock64_t *bf, xfs_off_t offset,
-		struct cred *credp, int	attr_flags);
+		cred_t *credp, int	attr_flags);
 int xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
 		struct xfs_inode *src_ip, struct xfs_inode *target_dp,
 		struct xfs_name *target_name, struct xfs_inode *target_ip);
diff --git a/include/linux/cred.h b/include/linux/cred.h
index b69222c..17ad725 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -12,39 +12,150 @@
 #ifndef _LINUX_CRED_H
 #define _LINUX_CRED_H
 
-#define get_current_user()	(get_uid(current->user))
-
-#define task_uid(task)		((task)->uid)
-#define task_gid(task)		((task)->gid)
-#define task_euid(task)		((task)->euid)
-#define task_egid(task)		((task)->egid)
-
-#define current_uid()		(current->uid)
-#define current_gid()		(current->gid)
-#define current_euid()		(current->euid)
-#define current_egid()		(current->egid)
-#define current_suid()		(current->suid)
-#define current_sgid()		(current->sgid)
-#define current_fsuid()		(current->fsuid)
-#define current_fsgid()		(current->fsgid)
-#define current_cap()		(current->cap_effective)
+#include <linux/capability.h>
+#include <linux/key.h>
+#include <asm/atomic.h>
+
+struct user_struct;
+struct cred;
+
+/*
+ * COW Supplementary groups list
+ */
+#define NGROUPS_SMALL		32
+#define NGROUPS_PER_BLOCK	((unsigned int)(PAGE_SIZE / sizeof(gid_t)))
+
+struct group_info {
+	atomic_t	usage;
+	int		ngroups;
+	int		nblocks;
+	gid_t		small_block[NGROUPS_SMALL];
+	gid_t		*blocks[0];
+};
+
+/**
+ * get_group_info - Get a reference to a group info structure
+ * @group_info: The group info to reference
+ *
+ * This must be called with the owning task locked (via task_lock()) when task
+ * != current.  The reason being that the vast majority of callers are looking
+ * at current->group_info, which can not be changed except by the current task.
+ * Changing current->group_info requires the task lock, too.
+ */
+#define get_group_info(group_info)		\
+do {						\
+	atomic_inc(&(group_info)->usage);	\
+} while (0)
+
+/**
+ * put_group_info - Release a reference to a group info structure
+ * @group_info: The group info to release
+ */
+#define put_group_info(group_info)			\
+do {							\
+	if (atomic_dec_and_test(&(group_info)->usage))	\
+		groups_free(group_info);		\
+} while (0)
+
+extern struct group_info *groups_alloc(int);
+extern void groups_free(struct group_info *);
+extern int set_current_groups(struct group_info *);
+extern int set_groups(struct cred *, struct group_info *);
+extern int groups_search(struct group_info *, gid_t);
+
+/* access the groups "array" with this macro */
+#define GROUP_AT(gi, i) \
+	((gi)->blocks[(i) / NGROUPS_PER_BLOCK][(i) % NGROUPS_PER_BLOCK])
+
+extern int in_group_p(gid_t);
+extern int in_egroup_p(gid_t);
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
+struct cred {
+	atomic_t	usage;
+	uid_t		uid;		/* real UID of the task */
+	gid_t		gid;		/* real GID of the task */
+	uid_t		suid;		/* saved UID of the task */
+	gid_t		sgid;		/* saved GID of the task */
+	uid_t		euid;		/* effective UID of the task */
+	gid_t		egid;		/* effective GID of the task */
+	uid_t		fsuid;		/* UID for VFS ops */
+	gid_t		fsgid;		/* GID for VFS ops */
+	unsigned	securebits;	/* SUID-less security management */
+	kernel_cap_t	cap_inheritable; /* caps our children can inherit */
+	kernel_cap_t	cap_permitted;	/* caps we're permitted */
+	kernel_cap_t	cap_effective;	/* caps we can actually use */
+	kernel_cap_t	cap_bset;	/* capability bounding set */
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
+	struct rcu_head	rcu;		/* RCU deletion hook */
+	spinlock_t	lock;		/* lock for pointer changes */
+};
+
+#define get_current_user()	(get_uid(current->cred->user))
+
+#define task_uid(task)		((task)->cred->uid)
+#define task_gid(task)		((task)->cred->gid)
+#define task_euid(task)		((task)->cred->euid)
+#define task_egid(task)		((task)->cred->egid)
+
+#define current_uid()		(current->cred->uid)
+#define current_gid()		(current->cred->gid)
+#define current_euid()		(current->cred->euid)
+#define current_egid()		(current->cred->egid)
+#define current_suid()		(current->cred->suid)
+#define current_sgid()		(current->cred->sgid)
+#define current_fsuid()		(current->cred->fsuid)
+#define current_fsgid()		(current->cred->fsgid)
+#define current_cap()		(current->cred->cap_effective)
 
 #define current_uid_gid(_uid, _gid)		\
 do {						\
-	*(_uid) = current->uid;			\
-	*(_gid) = current->gid;			\
+	*(_uid) = current->cred->uid;		\
+	*(_gid) = current->cred->gid;		\
 } while(0)
 
 #define current_euid_egid(_uid, _gid)		\
 do {						\
-	*(_uid) = current->euid;		\
-	*(_gid) = current->egid;		\
+	*(_uid) = current->cred->euid;		\
+	*(_gid) = current->cred->egid;		\
 } while(0)
 
 #define current_fsuid_fsgid(_uid, _gid)		\
 do {						\
-	*(_uid) = current->fsuid;		\
-	*(_gid) = current->fsgid;		\
+	*(_uid) = current->cred->fsuid;		\
+	*(_gid) = current->cred->fsgid;		\
 } while(0)
 
 #endif /* _LINUX_CRED_H */
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 021d8e7..0abd837 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -113,6 +113,21 @@ extern struct group_info init_groups;
 # define CAP_INIT_BSET  CAP_INIT_EFF_SET
 #endif
 
+extern struct cred init_cred;
+
+#define INIT_CRED(p)						\
+{								\
+	.usage			= ATOMIC_INIT(3),		\
+	.securebits		= SECUREBITS_DEFAULT,		\
+	.cap_inheritable	= CAP_INIT_INH_SET,		\
+	.cap_permitted		= CAP_FULL_SET,			\
+	.cap_effective		= CAP_INIT_EFF_SET,		\
+	.cap_bset		= CAP_INIT_BSET,		\
+	.user			= INIT_USER,			\
+	.group_info		= &init_groups,			\
+	.lock			= __SPIN_LOCK_UNLOCKED(p.lock),	\
+}
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -147,13 +162,8 @@ extern struct group_info init_groups;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	.group_info	= &init_groups,					\
-	.cap_effective	= CAP_INIT_EFF_SET,				\
-	.cap_inheritable = CAP_INIT_INH_SET,				\
-	.cap_permitted	= CAP_FULL_SET,					\
-	.cap_bset 	= CAP_INIT_BSET,				\
-	.securebits     = SECUREBITS_DEFAULT,				\
-	.user		= INIT_USER,					\
+	.__temp_cred	= INIT_CRED(tsk.__temp_cred),			\
+	.cred		= &tsk.__temp_cred,				\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9fd5694..304ede6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -618,6 +618,7 @@ extern struct user_struct *find_user(uid_t);
 extern struct user_struct root_user;
 #define INIT_USER (&root_user)
 
+
 struct backing_dev_info;
 struct reclaim_state;
 
@@ -842,38 +843,7 @@ partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 #endif	/* !CONFIG_SMP */
 
 struct io_context;			/* See blkdev.h */
-#define NGROUPS_SMALL		32
-#define NGROUPS_PER_BLOCK	((unsigned int)(PAGE_SIZE / sizeof(gid_t)))
-struct group_info {
-	int ngroups;
-	atomic_t usage;
-	gid_t small_block[NGROUPS_SMALL];
-	int nblocks;
-	gid_t *blocks[0];
-};
-
-/*
- * get_group_info() must be called with the owning task locked (via task_lock())
- * when task != current.  The reason being that the vast majority of callers are
- * looking at current->group_info, which can not be changed except by the
- * current task.  Changing current->group_info requires the task lock, too.
- */
-#define get_group_info(group_info) do { \
-	atomic_inc(&(group_info)->usage); \
-} while (0)
 
-#define put_group_info(group_info) do { \
-	if (atomic_dec_and_test(&(group_info)->usage)) \
-		groups_free(group_info); \
-} while (0)
-
-extern struct group_info *groups_alloc(int gidsetsize);
-extern void groups_free(struct group_info *group_info);
-extern int set_current_groups(struct group_info *group_info);
-extern int groups_search(struct group_info *group_info, gid_t grp);
-/* access the groups "array" with this macro */
-#define GROUP_AT(gi, i) \
-    ((gi)->blocks[(i)/NGROUPS_PER_BLOCK][(i)%NGROUPS_PER_BLOCK])
 
 #ifdef ARCH_HAS_PREFETCH_SWITCH_STACK
 extern void prefetch_stack(struct task_struct *t);
@@ -1139,17 +1109,9 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	uid_t uid,euid,suid,fsuid;
-	gid_t gid,egid,sgid,fsgid;
-	struct group_info *group_info;
-	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted, cap_bset;
-	struct user_struct *user;
-	unsigned securebits;
-#ifdef CONFIG_KEYS
-	unsigned char jit_keyring;	/* default keyring to attach requested keys to */
-	struct key *request_key_auth;	/* assumed request_key authority */
-	struct key *thread_keyring;	/* keyring private to this thread */
-#endif
+	struct cred __temp_cred __deprecated; /* temporary credentials to be removed */
+	struct cred *cred;	/* actual/objective task credentials */
+
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
 				       it with task_lock())
@@ -1186,9 +1148,6 @@ struct task_struct {
 	int (*notifier)(void *priv);
 	void *notifier_data;
 	sigset_t *notifier_mask;
-#ifdef CONFIG_SECURITY
-	void *security;
-#endif
 	struct audit_context *audit_context;
 #ifdef CONFIG_AUDITSYSCALL
 	uid_t loginuid;
@@ -1756,9 +1715,6 @@ extern void wake_up_new_task(struct task_struct *tsk,
 extern void sched_fork(struct task_struct *p, int clone_flags);
 extern void sched_dead(struct task_struct *p);
 
-extern int in_group_p(gid_t);
-extern int in_egroup_p(gid_t);
-
 extern void proc_caches_init(void);
 extern void flush_signals(struct task_struct *);
 extern void ignore_signals(struct task_struct *);
diff --git a/include/linux/securebits.h b/include/linux/securebits.h
index 92f09bd..6d38949 100644
--- a/include/linux/securebits.h
+++ b/include/linux/securebits.h
@@ -32,7 +32,7 @@
    setting is locked or not. A setting which is locked cannot be
    changed from user-level. */
 #define issecure_mask(X)	(1 << (X))
-#define issecure(X)		(issecure_mask(X) & current->securebits)
+#define issecure(X)		(issecure_mask(X) & current->cred->securebits)
 
 #define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
 				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 51d9588..4d5c116 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -118,7 +118,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb, int mode,
 		if (S_ISREG(mode)) {
 			struct mqueue_inode_info *info;
 			struct task_struct *p = current;
-			struct user_struct *u = p->user;
+			struct user_struct *u = p->cred->user;
 			unsigned long mq_bytes, mq_msg_tblsz;
 
 			inode->i_fop = &mqueue_file_operations;
diff --git a/ipc/shm.c b/ipc/shm.c
index c46a7e6..da04353 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -366,7 +366,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	if (shmflg & SHM_HUGETLB) {
 		/* hugetlb_file_setup takes care of mlock user accounting */
 		file = hugetlb_file_setup(name, size);
-		shp->mlock_user = current->user;
+		shp->mlock_user = current->cred->user;
 	} else {
 		int acctflag = VM_ACCOUNT;
 		/*
@@ -763,7 +763,7 @@ asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
 			goto out_unlock;
 		
 		if(cmd==SHM_LOCK) {
-			struct user_struct * user = current->user;
+			struct user_struct *user = current->cred->user;
 			if (!is_file_hugepages(shp->shm_file)) {
 				err = shmem_lock(shp->shm_file, 1, user);
 				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index af446be..9e817df 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -413,6 +413,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 			      struct audit_names *name,
 			      enum audit_state *state)
 {
+	struct cred *cred = tsk->cred;
 	int i, j, need_sid = 1;
 	u32 sid;
 
@@ -432,28 +433,28 @@ static int audit_filter_rules(struct task_struct *tsk,
 			}
 			break;
 		case AUDIT_UID:
-			result = audit_comparator(tsk->uid, f->op, f->val);
+			result = audit_comparator(cred->uid, f->op, f->val);
 			break;
 		case AUDIT_EUID:
-			result = audit_comparator(tsk->euid, f->op, f->val);
+			result = audit_comparator(cred->euid, f->op, f->val);
 			break;
 		case AUDIT_SUID:
-			result = audit_comparator(tsk->suid, f->op, f->val);
+			result = audit_comparator(cred->suid, f->op, f->val);
 			break;
 		case AUDIT_FSUID:
-			result = audit_comparator(tsk->fsuid, f->op, f->val);
+			result = audit_comparator(cred->fsuid, f->op, f->val);
 			break;
 		case AUDIT_GID:
-			result = audit_comparator(tsk->gid, f->op, f->val);
+			result = audit_comparator(cred->gid, f->op, f->val);
 			break;
 		case AUDIT_EGID:
-			result = audit_comparator(tsk->egid, f->op, f->val);
+			result = audit_comparator(cred->egid, f->op, f->val);
 			break;
 		case AUDIT_SGID:
-			result = audit_comparator(tsk->sgid, f->op, f->val);
+			result = audit_comparator(cred->sgid, f->op, f->val);
 			break;
 		case AUDIT_FSGID:
-			result = audit_comparator(tsk->fsgid, f->op, f->val);
+			result = audit_comparator(cred->fsgid, f->op, f->val);
 			break;
 		case AUDIT_PERS:
 			result = audit_comparator(tsk->personality, f->op, f->val);
@@ -1165,6 +1166,7 @@ static void audit_log_execve_info(struct audit_context *context,
 
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
+	struct cred *cred = tsk->cred;
 	int i, call_panic = 0;
 	struct audit_buffer *ab;
 	struct audit_aux_data *aux;
@@ -1174,14 +1176,14 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
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
+	context->uid = cred->uid;
+	context->gid = cred->gid;
+	context->euid = cred->euid;
+	context->suid = cred->suid;
+	context->fsuid = cred->fsuid;
+	context->egid = cred->egid;
+	context->sgid = cred->sgid;
+	context->fsgid = cred->fsgid;
 	context->personality = tsk->personality;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_SYSCALL);
@@ -1971,7 +1973,7 @@ int audit_set_loginuid(struct task_struct *task, uid_t loginuid)
 			audit_log_format(ab, "login pid=%d uid=%u "
 				"old auid=%u new auid=%u"
 				" old ses=%u new ses=%u",
-				task->pid, task->uid,
+				task->pid, task->cred->uid,
 				task->loginuid, loginuid,
 				task->sessionid, sessionid);
 			audit_log_end(ab);
@@ -2354,7 +2356,7 @@ void __audit_ptrace(struct task_struct *t)
 
 	context->target_pid = t->pid;
 	context->target_auid = audit_get_loginuid(t);
-	context->target_uid = t->uid;
+	context->target_uid = t->cred->uid;
 	context->target_sessionid = audit_get_sessionid(t);
 	security_task_getsecid(t, &context->target_sid);
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
@@ -2380,7 +2382,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 			if (tsk->loginuid != -1)
 				audit_sig_uid = tsk->loginuid;
 			else
-				audit_sig_uid = tsk->uid;
+				audit_sig_uid = tsk->cred->uid;
 			security_task_getsecid(tsk, &audit_sig_sid);
 		}
 		if (!audit_signals || audit_dummy_context())
@@ -2392,7 +2394,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	if (!ctx->target_pid) {
 		ctx->target_pid = t->tgid;
 		ctx->target_auid = audit_get_loginuid(t);
-		ctx->target_uid = t->uid;
+		ctx->target_uid = t->cred->uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
 		security_task_getsecid(t, &ctx->target_sid);
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
@@ -2413,7 +2415,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 
 	axp->target_pid[axp->pid_count] = t->tgid;
 	axp->target_auid[axp->pid_count] = audit_get_loginuid(t);
-	axp->target_uid[axp->pid_count] = t->uid;
+	axp->target_uid[axp->pid_count] = t->cred->uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
 	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
diff --git a/kernel/capability.c b/kernel/capability.c
index bb96b53..758bfe1 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -159,8 +159,8 @@ kernel_cap_t cap_set_effective(const kernel_cap_t pE_new)
 
 	spin_lock(&task_capability_lock);
 
-	pE_old = current->cap_effective;
-	current->cap_effective = pE_new;
+	pE_old = current->cred->cap_effective;
+	current->cred->cap_effective = pE_new;
 
 	spin_unlock(&task_capability_lock);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9f5a62a..5658dc3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1290,7 +1290,9 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid)
 		rcu_read_unlock();
 
 		euid = current_euid();
-		if (euid && euid != tsk->uid && euid != tsk->suid) {
+		if (euid &&
+		    euid != tsk->cred->uid &&
+		    euid != tsk->cred->suid) {
 			put_task_struct(tsk);
 			return -EACCES;
 		}
diff --git a/kernel/exit.c b/kernel/exit.c
index 38ec406..5ba3db3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -159,7 +159,7 @@ void release_task(struct task_struct * p)
 	int zap_leader;
 repeat:
 	tracehook_prepare_release_task(p);
-	atomic_dec(&p->user->processes);
+	atomic_dec(&p->cred->user->processes);
 	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
 	tracehook_finish_release_task(p);
@@ -1272,7 +1272,7 @@ static int wait_task_zombie(struct task_struct *p, int options,
 		return 0;
 
 	if (unlikely(options & WNOWAIT)) {
-		uid_t uid = p->uid;
+		uid_t uid = p->cred->uid;
 		int exit_code = p->exit_code;
 		int why, status;
 
@@ -1389,7 +1389,7 @@ static int wait_task_zombie(struct task_struct *p, int options,
 	if (!retval && infop)
 		retval = put_user(pid, &infop->si_pid);
 	if (!retval && infop)
-		retval = put_user(p->uid, &infop->si_uid);
+		retval = put_user(p->cred->uid, &infop->si_uid);
 	if (!retval)
 		retval = pid;
 
@@ -1454,7 +1454,7 @@ static int wait_task_stopped(int ptrace, struct task_struct *p,
 	if (!unlikely(options & WNOWAIT))
 		p->exit_code = 0;
 
-	uid = p->uid;
+	uid = p->cred->uid;
 unlock_sig:
 	spin_unlock_irq(&p->sighand->siglock);
 	if (!exit_code)
@@ -1531,7 +1531,7 @@ static int wait_task_continued(struct task_struct *p, int options,
 	spin_unlock_irq(&p->sighand->siglock);
 
 	pid = task_pid_vnr(p);
-	uid = p->uid;
+	uid = p->cred->uid;
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 7ce2ebe..be0c716 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -146,8 +146,8 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(tsk == current);
 
 	security_task_free(tsk);
-	free_uid(tsk->user);
-	put_group_info(tsk->group_info);
+	free_uid(tsk->__temp_cred.user);
+	put_group_info(tsk->__temp_cred.group_info);
 	delayacct_tsk_free(tsk);
 
 	if (!profile_handoff_task(tsk))
@@ -938,17 +938,18 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
+	p->cred = &p->__temp_cred;
 	retval = -EAGAIN;
-	if (atomic_read(&p->user->processes) >=
+	if (atomic_read(&p->cred->user->processes) >=
 			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
-		    p->user != current->nsproxy->user_ns->root_user)
+		    p->cred->user != current->nsproxy->user_ns->root_user)
 			goto bad_fork_free;
 	}
 
-	atomic_inc(&p->user->__count);
-	atomic_inc(&p->user->processes);
-	get_group_info(p->group_info);
+	atomic_inc(&p->cred->user->__count);
+	atomic_inc(&p->cred->user->processes);
+	get_group_info(p->cred->group_info);
 
 	/*
 	 * If multiple threads are within copy_process(), then this check
@@ -1007,9 +1008,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
 #ifdef CONFIG_SECURITY
-	p->security = NULL;
+	p->cred->security = NULL;
 #endif
-	p->cap_bset = current->cap_bset;
 	p->io_context = NULL;
 	p->audit_context = NULL;
 	cgroup_fork(p);
@@ -1284,9 +1284,9 @@ bad_fork_cleanup_cgroup:
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-	put_group_info(p->group_info);
-	atomic_dec(&p->user->processes);
-	free_uid(p->user);
+	put_group_info(p->cred->group_info);
+	atomic_dec(&p->cred->user->processes);
+	free_uid(p->cred->user);
 bad_fork_free:
 	free_task(p);
 fork_out:
diff --git a/kernel/futex.c b/kernel/futex.c
index a28b82b..3f594ac 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -443,7 +443,8 @@ static struct task_struct * futex_find_get_task(pid_t pid)
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
-	if (!p || (euid != p->euid && euid != p->uid))
+	if (!p || (euid != p->cred->euid &&
+		   euid != p->cred->uid))
 		p = ERR_PTR(-ESRCH);
 	else
 		get_task_struct(p);
@@ -1843,7 +1844,8 @@ sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
-		if (euid != p->euid && euid != p->uid &&
+		if (euid != p->cred->euid &&
+		    euid != p->cred->uid &&
 		    !capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->robust_list;
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 3254d4e..2c3fd5e 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -151,8 +151,9 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
-		if (euid != p->euid && euid != p->uid &&
-				!capable(CAP_SYS_PTRACE))
+		if (euid != p->cred->euid &&
+		    euid != p->cred->uid &&
+		    !capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->compat_robust_list;
 		read_unlock(&tasklist_lock);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 0dafab1..efa4556 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -115,6 +115,8 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 
 int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
+	struct cred *cred = current->cred, *tcred = task->cred;
+
 	/* May we inspect the given task?
 	 * This check is used both for attaching with ptrace
 	 * and for allowing access to sensitive information in /proc.
@@ -123,19 +125,18 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	 * because setting up the necessary parent/child relationship
 	 * or halting the specified task is impossible.
 	 */
-	uid_t uid;
-	gid_t gid;
+	uid_t uid = cred->uid;
+	gid_t gid = cred->gid;
 	int dumpable = 0;
 	/* Don't let security modules deny introspection */
 	if (task == current)
 		return 0;
-	current_uid_gid(&uid, &gid);
-	if ((uid != task->euid ||
-	     uid != task->suid ||
-	     uid != task->uid  ||
-	     gid != task->egid ||
-	     gid != task->sgid ||
-	     gid != task->gid) && !capable(CAP_SYS_PTRACE))
+	if ((uid != tcred->euid ||
+	     uid != tcred->suid ||
+	     uid != tcred->uid  ||
+	     gid != tcred->egid ||
+	     gid != tcred->sgid ||
+	     gid != tcred->gid) && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 	smp_rmb();
 	if (task->mm)
diff --git a/kernel/sched.c b/kernel/sched.c
index 4a97b29..152ea80 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -339,7 +339,7 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct task_group *tg;
 
 #ifdef CONFIG_USER_SCHED
-	tg = p->user->tg;
+	tg = p->cred->user->tg;
 #elif defined(CONFIG_CGROUP_SCHED)
 	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
 				struct task_group, css);
@@ -5001,8 +5001,8 @@ recheck:
 
 		/* can't change other user's priorities */
 		euid = current_euid();
-		if (euid != p->euid &&
-		    euid != p->uid)
+		if (euid != p->cred->euid &&
+		    euid != p->cred->uid)
 			return -EPERM;
 	}
 
@@ -5233,7 +5233,9 @@ long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
 
 	euid = current_euid();
 	retval = -EPERM;
-	if (euid != p->euid && euid != p->uid && !capable(CAP_SYS_NICE))
+	if (euid != p->cred->euid &&
+	    euid != p->cred->uid &&
+	    !capable(CAP_SYS_NICE))
 		goto out_unlock;
 
 	retval = security_task_setscheduler(p, 0, NULL);
diff --git a/kernel/signal.c b/kernel/signal.c
index 9ad5b74..dfdbaaf 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -186,7 +186,7 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	 * In order to avoid problems with "switch_user()", we want to make
 	 * sure that the compiler doesn't re-load "t->user"
 	 */
-	user = t->user;
+	user = t->cred->user;
 	barrier();
 	atomic_inc(&user->sigpending);
 	if (override_rlimit ||
@@ -581,8 +581,8 @@ static int check_kill_permission(int sig, struct siginfo *info,
 
 	uid = current_uid();
 	euid = current_euid();
-	if ((euid ^ t->suid) && (euid ^ t->uid) &&
-	    (uid  ^ t->suid) && (uid  ^ t->uid) &&
+	if ((euid ^ t->cred->suid) && (euid ^ t->cred->uid) &&
+	    (uid  ^ t->cred->suid) && (uid  ^ t->cred->uid) &&
 	    !capable(CAP_KILL)) {
 		switch (sig) {
 		case SIGCONT:
@@ -1097,8 +1097,8 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 		goto out_unlock;
 	}
 	if ((info == SEND_SIG_NOINFO || (!is_si_special(info) && SI_FROMUSER(info)))
-	    && (euid != p->suid) && (euid != p->uid)
-	    && (uid != p->suid) && (uid != p->uid)) {
+	    && (euid != p->cred->suid) && (euid != p->cred->uid)
+	    && (uid != p->cred->suid) && (uid != p->cred->uid)) {
 		ret = -EPERM;
 		goto out_unlock;
 	}
@@ -1367,7 +1367,7 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
 	rcu_read_unlock();
 
-	info.si_uid = tsk->uid;
+	info.si_uid = tsk->cred->uid;
 
 	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
 						       tsk->signal->utime));
@@ -1439,7 +1439,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
 	rcu_read_unlock();
 
-	info.si_uid = tsk->uid;
+	info.si_uid = tsk->cred->uid;
 
 	info.si_utime = cputime_to_clock_t(tsk->utime);
 	info.si_stime = cputime_to_clock_t(tsk->stime);
@@ -1707,7 +1707,7 @@ static int ptrace_signal(int signr, siginfo_t *info,
 		info->si_errno = 0;
 		info->si_code = SI_USER;
 		info->si_pid = task_pid_vnr(current->parent);
-		info->si_uid = current->parent->uid;
+		info->si_uid = current->parent->cred->uid;
 	}
 
 	/* If the (new) signal is now blocked, requeue it.  */
diff --git a/kernel/sys.c b/kernel/sys.c
index f498f30..48cbb5b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -117,7 +117,9 @@ static int set_one_prio(struct task_struct *p, int niceval, int error)
 	uid_t euid = current_euid();
 	int no_nice;
 
-	if (p->uid != euid && p->euid != euid && !capable(CAP_SYS_NICE)) {
+	if (p->cred->uid  != euid &&
+	    p->cred->euid != euid &&
+	    !capable(CAP_SYS_NICE)) {
 		error = -EPERM;
 		goto out;
 	}
@@ -174,7 +176,7 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
 			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
-			user = current->user;
+			user = current->cred->user;
 			if (!who)
 				who = current_uid();
 			else
@@ -182,7 +184,7 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
 					goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p)
-				if (p->uid == who)
+				if (p->cred->uid == who)
 					error = set_one_prio(p, niceval, error);
 			while_each_thread(g, p);
 			if (who != current_uid())
@@ -236,7 +238,7 @@ asmlinkage long sys_getpriority(int which, int who)
 			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
-			user = current->user;
+			user = current->cred->user;
 			if (!who)
 				who = current_uid();
 			else
@@ -244,7 +246,7 @@ asmlinkage long sys_getpriority(int which, int who)
 					goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p)
-				if (p->uid == who) {
+				if (p->cred->uid == who) {
 					niceval = 20 - task_nice(p);
 					if (niceval > retval)
 						retval = niceval;
@@ -472,8 +474,9 @@ void ctrl_alt_del(void)
  */
 asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 {
-	int old_rgid = current->gid;
-	int old_egid = current->egid;
+	struct cred *cred = current->cred;
+	int old_rgid = cred->gid;
+	int old_egid = cred->egid;
 	int new_rgid = old_rgid;
 	int new_egid = old_egid;
 	int retval;
@@ -484,7 +487,7 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 
 	if (rgid != (gid_t) -1) {
 		if ((old_rgid == rgid) ||
-		    (current->egid==rgid) ||
+		    (cred->egid == rgid) ||
 		    capable(CAP_SETGID))
 			new_rgid = rgid;
 		else
@@ -492,8 +495,8 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 	}
 	if (egid != (gid_t) -1) {
 		if ((old_rgid == egid) ||
-		    (current->egid == egid) ||
-		    (current->sgid == egid) ||
+		    (cred->egid == egid) ||
+		    (cred->sgid == egid) ||
 		    capable(CAP_SETGID))
 			new_egid = egid;
 		else
@@ -505,10 +508,10 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 	}
 	if (rgid != (gid_t) -1 ||
 	    (egid != (gid_t) -1 && egid != old_rgid))
-		current->sgid = new_egid;
-	current->fsgid = new_egid;
-	current->egid = new_egid;
-	current->gid = new_rgid;
+		cred->sgid = new_egid;
+	cred->fsgid = new_egid;
+	cred->egid = new_egid;
+	cred->gid = new_rgid;
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -521,7 +524,8 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
  */
 asmlinkage long sys_setgid(gid_t gid)
 {
-	int old_egid = current->egid;
+	struct cred *cred = current->cred;
+	int old_egid = cred->egid;
 	int retval;
 
 	retval = security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_ID);
@@ -533,13 +537,13 @@ asmlinkage long sys_setgid(gid_t gid)
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->gid = current->egid = current->sgid = current->fsgid = gid;
-	} else if ((gid == current->gid) || (gid == current->sgid)) {
+		cred->gid = cred->egid = cred->sgid = cred->fsgid = gid;
+	} else if ((gid == cred->gid) || (gid == cred->sgid)) {
 		if (old_egid != gid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->egid = current->fsgid = gid;
+		cred->egid = cred->fsgid = gid;
 	}
 	else
 		return -EPERM;
@@ -570,7 +574,7 @@ static int set_user(uid_t new_ruid, int dumpclear)
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->uid = new_ruid;
+	current->cred->uid = new_ruid;
 	return 0;
 }
 
@@ -591,6 +595,7 @@ static int set_user(uid_t new_ruid, int dumpclear)
  */
 asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 {
+	struct cred *cred = current->cred;
 	int old_ruid, old_euid, old_suid, new_ruid, new_euid;
 	int retval;
 
@@ -598,14 +603,14 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 	if (retval)
 		return retval;
 
-	new_ruid = old_ruid = current->uid;
-	new_euid = old_euid = current->euid;
-	old_suid = current->suid;
+	new_ruid = old_ruid = cred->uid;
+	new_euid = old_euid = cred->euid;
+	old_suid = cred->suid;
 
 	if (ruid != (uid_t) -1) {
 		new_ruid = ruid;
 		if ((old_ruid != ruid) &&
-		    (current->euid != ruid) &&
+		    (cred->euid != ruid) &&
 		    !capable(CAP_SETUID))
 			return -EPERM;
 	}
@@ -613,8 +618,8 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 	if (euid != (uid_t) -1) {
 		new_euid = euid;
 		if ((old_ruid != euid) &&
-		    (current->euid != euid) &&
-		    (current->suid != euid) &&
+		    (cred->euid != euid) &&
+		    (cred->suid != euid) &&
 		    !capable(CAP_SETUID))
 			return -EPERM;
 	}
@@ -626,11 +631,11 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = new_euid;
+	cred->fsuid = cred->euid = new_euid;
 	if (ruid != (uid_t) -1 ||
 	    (euid != (uid_t) -1 && euid != old_ruid))
-		current->suid = current->euid;
-	current->fsuid = current->euid;
+		cred->suid = cred->euid;
+	cred->fsuid = cred->euid;
 
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
@@ -653,7 +658,8 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
  */
 asmlinkage long sys_setuid(uid_t uid)
 {
-	int old_euid = current->euid;
+	struct cred *cred = current->cred;
+	int old_euid = cred->euid;
 	int old_ruid, old_suid, new_suid;
 	int retval;
 
@@ -661,23 +667,23 @@ asmlinkage long sys_setuid(uid_t uid)
 	if (retval)
 		return retval;
 
-	old_ruid = current->uid;
-	old_suid = current->suid;
+	old_ruid = cred->uid;
+	old_suid = cred->suid;
 	new_suid = old_suid;
 	
 	if (capable(CAP_SETUID)) {
 		if (uid != old_ruid && set_user(uid, old_euid != uid) < 0)
 			return -EAGAIN;
 		new_suid = uid;
-	} else if ((uid != current->uid) && (uid != new_suid))
+	} else if ((uid != cred->uid) && (uid != new_suid))
 		return -EPERM;
 
 	if (old_euid != uid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = uid;
-	current->suid = new_suid;
+	cred->fsuid = cred->euid = uid;
+	cred->suid = new_suid;
 
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
@@ -692,9 +698,10 @@ asmlinkage long sys_setuid(uid_t uid)
  */
 asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 {
-	int old_ruid = current->uid;
-	int old_euid = current->euid;
-	int old_suid = current->suid;
+	struct cred *cred = current->cred;
+	int old_ruid = cred->uid;
+	int old_euid = cred->euid;
+	int old_suid = cred->suid;
 	int retval;
 
 	retval = security_task_setuid(ruid, euid, suid, LSM_SETID_RES);
@@ -702,30 +709,31 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 		return retval;
 
 	if (!capable(CAP_SETUID)) {
-		if ((ruid != (uid_t) -1) && (ruid != current->uid) &&
-		    (ruid != current->euid) && (ruid != current->suid))
+		if ((ruid != (uid_t) -1) && (ruid != cred->uid) &&
+		    (ruid != cred->euid) && (ruid != cred->suid))
 			return -EPERM;
-		if ((euid != (uid_t) -1) && (euid != current->uid) &&
-		    (euid != current->euid) && (euid != current->suid))
+		if ((euid != (uid_t) -1) && (euid != cred->uid) &&
+		    (euid != cred->euid) && (euid != cred->suid))
 			return -EPERM;
-		if ((suid != (uid_t) -1) && (suid != current->uid) &&
-		    (suid != current->euid) && (suid != current->suid))
+		if ((suid != (uid_t) -1) && (suid != cred->uid) &&
+		    (suid != cred->euid) && (suid != cred->suid))
 			return -EPERM;
 	}
 	if (ruid != (uid_t) -1) {
-		if (ruid != current->uid && set_user(ruid, euid != current->euid) < 0)
+		if (ruid != cred->uid &&
+		    set_user(ruid, euid != cred->euid) < 0)
 			return -EAGAIN;
 	}
 	if (euid != (uid_t) -1) {
-		if (euid != current->euid) {
+		if (euid != cred->euid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->euid = euid;
+		cred->euid = euid;
 	}
-	current->fsuid = current->euid;
+	cred->fsuid = cred->euid;
 	if (suid != (uid_t) -1)
-		current->suid = suid;
+		cred->suid = suid;
 
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
@@ -735,11 +743,12 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 
 asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __user *suid)
 {
+	struct cred *cred = current->cred;
 	int retval;
 
-	if (!(retval = put_user(current->uid, ruid)) &&
-	    !(retval = put_user(current->euid, euid)))
-		retval = put_user(current->suid, suid);
+	if (!(retval = put_user(cred->uid, ruid)) &&
+	    !(retval = put_user(cred->euid, euid)))
+		retval = put_user(cred->suid, suid);
 
 	return retval;
 }
@@ -749,6 +758,7 @@ asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __us
  */
 asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 {
+	struct cred *cred = current->cred;
 	int retval;
 
 	retval = security_task_setgid(rgid, egid, sgid, LSM_SETID_RES);
@@ -756,28 +766,28 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 		return retval;
 
 	if (!capable(CAP_SETGID)) {
-		if ((rgid != (gid_t) -1) && (rgid != current->gid) &&
-		    (rgid != current->egid) && (rgid != current->sgid))
+		if ((rgid != (gid_t) -1) && (rgid != cred->gid) &&
+		    (rgid != cred->egid) && (rgid != cred->sgid))
 			return -EPERM;
-		if ((egid != (gid_t) -1) && (egid != current->gid) &&
-		    (egid != current->egid) && (egid != current->sgid))
+		if ((egid != (gid_t) -1) && (egid != cred->gid) &&
+		    (egid != cred->egid) && (egid != cred->sgid))
 			return -EPERM;
-		if ((sgid != (gid_t) -1) && (sgid != current->gid) &&
-		    (sgid != current->egid) && (sgid != current->sgid))
+		if ((sgid != (gid_t) -1) && (sgid != cred->gid) &&
+		    (sgid != cred->egid) && (sgid != cred->sgid))
 			return -EPERM;
 	}
 	if (egid != (gid_t) -1) {
-		if (egid != current->egid) {
+		if (egid != cred->egid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->egid = egid;
+		cred->egid = egid;
 	}
-	current->fsgid = current->egid;
+	cred->fsgid = cred->egid;
 	if (rgid != (gid_t) -1)
-		current->gid = rgid;
+		cred->gid = rgid;
 	if (sgid != (gid_t) -1)
-		current->sgid = sgid;
+		cred->sgid = sgid;
 
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
@@ -786,11 +796,12 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 
 asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __user *sgid)
 {
+	struct cred *cred = current->cred;
 	int retval;
 
-	if (!(retval = put_user(current->gid, rgid)) &&
-	    !(retval = put_user(current->egid, egid)))
-		retval = put_user(current->sgid, sgid);
+	if (!(retval = put_user(cred->gid, rgid)) &&
+	    !(retval = put_user(cred->egid, egid)))
+		retval = put_user(cred->sgid, sgid);
 
 	return retval;
 }
@@ -804,20 +815,21 @@ asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __us
  */
 asmlinkage long sys_setfsuid(uid_t uid)
 {
+	struct cred *cred = current->cred;
 	int old_fsuid;
 
-	old_fsuid = current->fsuid;
+	old_fsuid = cred->fsuid;
 	if (security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS))
 		return old_fsuid;
 
-	if (uid == current->uid || uid == current->euid ||
-	    uid == current->suid || uid == current->fsuid || 
+	if (uid == cred->uid || uid == cred->euid ||
+	    uid == cred->suid || uid == cred->fsuid ||
 	    capable(CAP_SETUID)) {
 		if (uid != old_fsuid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsuid = uid;
+		cred->fsuid = uid;
 	}
 
 	key_fsuid_changed(current);
@@ -833,20 +845,21 @@ asmlinkage long sys_setfsuid(uid_t uid)
  */
 asmlinkage long sys_setfsgid(gid_t gid)
 {
+	struct cred *cred = current->cred;
 	int old_fsgid;
 
-	old_fsgid = current->fsgid;
+	old_fsgid = cred->fsgid;
 	if (security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_FS))
 		return old_fsgid;
 
-	if (gid == current->gid || gid == current->egid ||
-	    gid == current->sgid || gid == current->fsgid || 
+	if (gid == cred->gid || gid == cred->egid ||
+	    gid == cred->sgid || gid == cred->fsgid ||
 	    capable(CAP_SETGID)) {
 		if (gid != old_fsgid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsgid = gid;
+		cred->fsgid = gid;
 		key_fsgid_changed(current);
 		proc_id_connector(current, PROC_EVENT_GID);
 	}
@@ -1220,8 +1233,15 @@ int groups_search(struct group_info *group_info, gid_t grp)
 	return 0;
 }
 
-/* validate and set current->group_info */
-int set_current_groups(struct group_info *group_info)
+/**
+ * set_groups - Change a group subscription in a security record
+ * @sec: The security record to alter
+ * @group_info: The group list to impose
+ *
+ * Validate a group subscription and, if valid, impose it upon a task security
+ * record.
+ */
+int set_groups(struct cred *cred, struct group_info *group_info)
 {
 	int retval;
 	struct group_info *old_info;
@@ -1233,20 +1253,34 @@ int set_current_groups(struct group_info *group_info)
 	groups_sort(group_info);
 	get_group_info(group_info);
 
-	task_lock(current);
-	old_info = current->group_info;
-	current->group_info = group_info;
-	task_unlock(current);
+	spin_lock(&cred->lock);
+	old_info = cred->group_info;
+	cred->group_info = group_info;
+	spin_unlock(&cred->lock);
 
 	put_group_info(old_info);
-
 	return 0;
 }
 
+EXPORT_SYMBOL(set_groups);
+
+/**
+ * set_current_groups - Change current's group subscription
+ * @group_info: The group list to impose
+ *
+ * Validate a group subscription and, if valid, impose it upon current's task
+ * security record.
+ */
+int set_current_groups(struct group_info *group_info)
+{
+	return set_groups(current->cred, group_info);
+}
+
 EXPORT_SYMBOL(set_current_groups);
 
 asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist)
 {
+	struct cred *cred = current->cred;
 	int i = 0;
 
 	/*
@@ -1258,13 +1292,13 @@ asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist)
 		return -EINVAL;
 
 	/* no need to grab task_lock here; it cannot change */
-	i = current->group_info->ngroups;
+	i = cred->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups_to_user(grouplist, current->group_info)) {
+		if (groups_to_user(grouplist, cred->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
@@ -1308,9 +1342,10 @@ asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist)
  */
 int in_group_p(gid_t grp)
 {
+	struct cred *cred = current->cred;
 	int retval = 1;
-	if (grp != current->fsgid)
-		retval = groups_search(current->group_info, grp);
+	if (grp != cred->fsgid)
+		retval = groups_search(cred->group_info, grp);
 	return retval;
 }
 
@@ -1318,9 +1353,10 @@ EXPORT_SYMBOL(in_group_p);
 
 int in_egroup_p(gid_t grp)
 {
+	struct cred *cred = current->cred;
 	int retval = 1;
-	if (grp != current->egid)
-		retval = groups_search(current->group_info, grp);
+	if (grp != cred->egid)
+		retval = groups_search(cred->group_info, grp);
 	return retval;
 }
 
@@ -1635,7 +1671,9 @@ asmlinkage long sys_umask(int mask)
 asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5)
 {
-	long error = 0;
+	struct task_struct *me = current;
+	unsigned char comm[sizeof(me->comm)];
+	long uninitialized_var(error);
 
 	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
 		return error;
@@ -1646,39 +1684,39 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
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
@@ -1688,31 +1726,24 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 				error = -EINVAL;
 			break;
 
-		case PR_SET_NAME: {
-			struct task_struct *me = current;
-			unsigned char ncomm[sizeof(me->comm)];
-
-			ncomm[sizeof(me->comm)-1] = 0;
-			if (strncpy_from_user(ncomm, (char __user *)arg2,
-						sizeof(me->comm)-1) < 0)
+		case PR_SET_NAME:
+			comm[sizeof(me->comm)-1] = 0;
+			if (strncpy_from_user(comm, (char __user *)arg2,
+					      sizeof(me->comm) - 1) < 0)
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
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8f3fb3d..c97b5bb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -257,7 +257,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
 	data->pid = tsk->pid;
-	data->uid = tsk->uid;
+	data->uid = task_uid(tsk);
 	data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
 	data->policy = tsk->policy;
 	data->rt_priority = tsk->rt_priority;
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 8ebcd85..6d1ed07 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -53,8 +53,8 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 		stats->ac_flag |= AXSIG;
 	stats->ac_nice	 = task_nice(tsk);
 	stats->ac_sched	 = tsk->policy;
-	stats->ac_uid	 = tsk->uid;
-	stats->ac_gid	 = tsk->gid;
+	stats->ac_uid	 = tsk->cred->uid;
+	stats->ac_gid	 = tsk->cred->gid;
 	stats->ac_pid	 = tsk->pid;
 	rcu_read_lock();
 	stats->ac_ppid	 = pid_alive(tsk) ?
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 3e41c16..71f07fc 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -86,9 +86,9 @@ asmlinkage long sys_getresuid16(old_uid_t __user *ruid, old_uid_t __user *euid,
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowuid(current->uid), ruid)) &&
-	    !(retval = put_user(high2lowuid(current->euid), euid)))
-		retval = put_user(high2lowuid(current->suid), suid);
+	if (!(retval = put_user(high2lowuid(current->cred->uid), ruid)) &&
+	    !(retval = put_user(high2lowuid(current->cred->euid), euid)))
+		retval = put_user(high2lowuid(current->cred->suid), suid);
 
 	return retval;
 }
@@ -106,9 +106,9 @@ asmlinkage long sys_getresgid16(old_gid_t __user *rgid, old_gid_t __user *egid,
 {
 	int retval;
 
-	if (!(retval = put_user(high2lowgid(current->gid), rgid)) &&
-	    !(retval = put_user(high2lowgid(current->egid), egid)))
-		retval = put_user(high2lowgid(current->sgid), sgid);
+	if (!(retval = put_user(high2lowgid(current->cred->gid), rgid)) &&
+	    !(retval = put_user(high2lowgid(current->cred->egid), egid)))
+		retval = put_user(high2lowgid(current->cred->sgid), sgid);
 
 	return retval;
 }
@@ -166,20 +166,20 @@ asmlinkage long sys_getgroups16(int gidsetsize, old_gid_t __user *grouplist)
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	get_group_info(current->cred->group_info);
+	i = current->cred->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, current->cred->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
+	put_group_info(current->cred->group_info);
 	return i;
 }
 
@@ -210,20 +210,20 @@ asmlinkage long sys_setgroups16(int gidsetsize, old_gid_t __user *grouplist)
 
 asmlinkage long sys_getuid16(void)
 {
-	return high2lowuid(current->uid);
+	return high2lowuid(current->cred->uid);
 }
 
 asmlinkage long sys_geteuid16(void)
 {
-	return high2lowuid(current->euid);
+	return high2lowuid(current->cred->euid);
 }
 
 asmlinkage long sys_getgid16(void)
 {
-	return high2lowgid(current->gid);
+	return high2lowgid(current->cred->gid);
 }
 
 asmlinkage long sys_getegid16(void)
 {
-	return high2lowgid(current->egid);
+	return high2lowgid(current->cred->egid);
 }
diff --git a/kernel/user.c b/kernel/user.c
index 865ecf5..9c9e27b 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -457,11 +457,11 @@ void switch_uid(struct user_struct *new_user)
 	 * cheaply with the new uid cache, so if it matters
 	 * we should be checking for it.  -DaveM
 	 */
-	old_user = current->user;
+	old_user = current->cred->user;
 	atomic_inc(&new_user->processes);
 	atomic_dec(&old_user->processes);
 	switch_uid_keyring(new_user);
-	current->user = new_user;
+	current->cred->user = new_user;
 	sched_switch_user(current);
 
 	/*
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6419497..4374a83 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1106,12 +1106,12 @@ asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
 		const unsigned long __user *old_nodes,
 		const unsigned long __user *new_nodes)
 {
+	struct cred *cred, *tcred;
 	struct mm_struct *mm;
 	struct task_struct *task;
 	nodemask_t old;
 	nodemask_t new;
 	nodemask_t task_nodes;
-	uid_t uid, euid;
 	int err;
 
 	err = get_nodes(&old, old_nodes, maxnode);
@@ -1141,10 +1141,10 @@ asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	uid = current_uid();
-	euid = current_euid();
-	if (euid != task->suid && euid != task->uid &&
-	    uid  != task->suid && uid  != task->uid &&
+	cred = current->cred;
+	tcred = task->cred;
+	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
+	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
 	    !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
 		goto out;
diff --git a/mm/migrate.c b/mm/migrate.c
index efc200b..78af7fd 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -984,13 +984,13 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
 			const int __user *nodes,
 			int __user *status, int flags)
 {
+	struct cred *cred, *tcred;
 	int err = 0;
 	int i;
 	struct task_struct *task;
 	nodemask_t task_nodes;
 	struct mm_struct *mm;
 	struct page_to_node *pm = NULL;
-	uid_t uid, euid;
 
 	/* Check flags */
 	if (flags & ~(MPOL_MF_MOVE|MPOL_MF_MOVE_ALL))
@@ -1018,10 +1018,10 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	uid = current_uid();
-	euid = current_euid();
-	if (euid != task->suid && euid != task->uid &&
-	    uid  != task->suid && uid  != task->uid &&
+	cred = current->cred;
+	tcred = task->cred;
+	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
+	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
 	    !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
 		goto out2;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 64e5b4b..c156ffb 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -298,7 +298,7 @@ static void dump_tasks(const struct mem_cgroup *mem)
 
 		task_lock(p);
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
-		       p->pid, p->uid, p->tgid, p->mm->total_vm,
+		       p->pid, p->cred->uid, p->tgid, p->mm->total_vm,
 		       get_mm_rss(p->mm), (int)task_cpu(p), p->oomkilladj,
 		       p->comm);
 		task_unlock(p);
diff --git a/net/core/scm.c b/net/core/scm.c
index 4681d8f..c28ca32 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -44,11 +44,13 @@
 
 static __inline__ int scm_check_creds(struct ucred *creds)
 {
+	struct cred *cred = current->cred;
+
 	if ((creds->pid == task_tgid_vnr(current) || capable(CAP_SYS_ADMIN)) &&
-	    ((creds->uid == current_uid()   || creds->uid == current_euid() ||
-	      creds->uid == current_suid()) || capable(CAP_SETUID)) &&
-	    ((creds->gid == current_gid()   || creds->gid == current_egid() ||
-	      creds->gid == current_sgid()) || capable(CAP_SETGID))) {
+	    ((creds->uid == cred->uid   || creds->uid == cred->euid ||
+	      creds->uid == cred->suid) || capable(CAP_SETUID)) &&
+	    ((creds->gid == cred->gid   || creds->gid == cred->egid ||
+	      creds->gid == cred->sgid) || capable(CAP_SETGID))) {
 	       return 0;
 	}
 	return -EPERM;
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 9dd8062..9515fef 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -353,7 +353,7 @@ rpcauth_lookupcred(struct rpc_auth *auth, int flags)
 	struct auth_cred acred = {
 		.uid = current_fsuid(),
 		.gid = current_fsgid(),
-		.group_info = current->group_info,
+		.group_info = current->cred->group_info,
 	};
 	struct rpc_cred *ret;
 
diff --git a/security/commoncap.c b/security/commoncap.c
index 570fd75..cb4da7d 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -29,7 +29,7 @@
 
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
-	NETLINK_CB(skb).eff_cap = current->cap_effective;
+	NETLINK_CB(skb).eff_cap = current_cap();
 	return 0;
 }
 
@@ -51,7 +51,7 @@ EXPORT_SYMBOL(cap_netlink_recv);
 int cap_capable (struct task_struct *tsk, int cap)
 {
 	/* Derived from include/linux/sched.h:capable. */
-	if (cap_raised(tsk->cap_effective, cap))
+	if (cap_raised(tsk->cred->cap_effective, cap))
 		return 0;
 	return -EPERM;
 }
@@ -66,7 +66,8 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
 int cap_ptrace_may_access(struct task_struct *child, unsigned int mode)
 {
 	/* Derived from arch/i386/kernel/ptrace.c:sys_ptrace. */
-	if (cap_issubset(child->cap_permitted, current->cap_permitted))
+	if (cap_issubset(child->cred->cap_permitted,
+			 current->cred->cap_permitted))
 		return 0;
 	if (capable(CAP_SYS_PTRACE))
 		return 0;
@@ -75,8 +76,8 @@ int cap_ptrace_may_access(struct task_struct *child, unsigned int mode)
 
 int cap_ptrace_traceme(struct task_struct *parent)
 {
-	/* Derived from arch/i386/kernel/ptrace.c:sys_ptrace. */
-	if (cap_issubset(current->cap_permitted, parent->cap_permitted))
+	if (cap_issubset(current->cred->cap_permitted,
+			 parent->cred->cap_permitted))
 		return 0;
 	if (has_capability(parent, CAP_SYS_PTRACE))
 		return 0;
@@ -86,10 +87,12 @@ int cap_ptrace_traceme(struct task_struct *parent)
 int cap_capget (struct task_struct *target, kernel_cap_t *effective,
 		kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
+	struct cred *cred = target->cred;
+
 	/* Derived from kernel/capability.c:sys_capget. */
-	*effective = target->cap_effective;
-	*inheritable = target->cap_inheritable;
-	*permitted = target->cap_permitted;
+	*effective   = cred->cap_effective;
+	*inheritable = cred->cap_inheritable;
+	*permitted   = cred->cap_permitted;
 	return 0;
 }
 
@@ -121,24 +124,26 @@ int cap_capset_check(const kernel_cap_t *effective,
 		     const kernel_cap_t *inheritable,
 		     const kernel_cap_t *permitted)
 {
+	const struct cred *cred = current->cred;
+
 	if (cap_inh_is_capped()
 	    && !cap_issubset(*inheritable,
-			     cap_combine(current->cap_inheritable,
-					 current->cap_permitted))) {
+			     cap_combine(cred->cap_inheritable,
+					 cred->cap_permitted))) {
 		/* incapable of using this inheritable set */
 		return -EPERM;
 	}
 	if (!cap_issubset(*inheritable,
-			   cap_combine(current->cap_inheritable,
-				       current->cap_bset))) {
+			   cap_combine(cred->cap_inheritable,
+				       cred->cap_bset))) {
 		/* no new pI capabilities outside bounding set */
 		return -EPERM;
 	}
 
 	/* verify restrictions on target's new Permitted set */
 	if (!cap_issubset (*permitted,
-			   cap_combine (current->cap_permitted,
-					current->cap_permitted))) {
+			   cap_combine (cred->cap_permitted,
+					cred->cap_permitted))) {
 		return -EPERM;
 	}
 
@@ -154,9 +159,11 @@ void cap_capset_set(const kernel_cap_t *effective,
 		    const kernel_cap_t *inheritable,
 		    const kernel_cap_t *permitted)
 {
-	current->cap_effective = *effective;
-	current->cap_inheritable = *inheritable;
-	current->cap_permitted = *permitted;
+	struct cred *cred = current->cred;
+
+	cred->cap_effective   = *effective;
+	cred->cap_inheritable = *inheritable;
+	cred->cap_permitted   = *permitted;
 }
 
 static inline void bprm_clear_caps(struct linux_binprm *bprm)
@@ -241,8 +248,8 @@ static inline int cap_from_disk(struct vfs_cap_data *caps,
 		 */
 		value_cpu = le32_to_cpu(caps->data[i].permitted);
 		bprm->cap_post_exec_permitted.cap[i] =
-			(current->cap_bset.cap[i] & value_cpu) |
-			(current->cap_inheritable.cap[i] &
+			(current->cred->cap_bset.cap[i] & value_cpu) |
+			(current->cred->cap_inheritable.cap[i] &
 				le32_to_cpu(caps->data[i].inheritable));
 		if (value_cpu & ~bprm->cap_post_exec_permitted.cap[i]) {
 			/*
@@ -337,8 +344,8 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 		if (bprm->e_uid == 0 || current_uid() == 0) {
 			/* pP' = (cap_bset & ~0) | (pI & ~0) */
 			bprm->cap_post_exec_permitted = cap_combine(
-				current->cap_bset, current->cap_inheritable
-				);
+				current->cred->cap_bset,
+				current->cred->cap_inheritable);
 			bprm->cap_effective = (bprm->e_uid == 0);
 			ret = 0;
 		}
@@ -349,60 +356,59 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 
 void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
-	uid_t uid;
-	gid_t gid;
+	struct cred *cred = current->cred;
 
-	current_uid_gid(&uid, &gid);
-
-	if (bprm->e_uid != uid || bprm->e_gid != gid ||
+	if (bprm->e_uid != cred->uid || bprm->e_gid != cred->gid ||
 	    !cap_issubset(bprm->cap_post_exec_permitted,
-			  current->cap_permitted)) {
+			  cred->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
-				bprm->e_uid = uid;
-				bprm->e_gid = gid;
+				bprm->e_uid = cred->uid;
+				bprm->e_gid = cred->gid;
 			}
 			if (cap_limit_ptraced_target()) {
 				bprm->cap_post_exec_permitted = cap_intersect(
 					bprm->cap_post_exec_permitted,
-					current->cap_permitted);
+					cred->cap_permitted);
 			}
 		}
 	}
 
-	current->suid = current->euid = current->fsuid = bprm->e_uid;
-	current->sgid = current->egid = current->fsgid = bprm->e_gid;
+	cred->suid = cred->euid = cred->fsuid = bprm->e_uid;
+	cred->sgid = cred->egid = cred->fsgid = bprm->e_gid;
 
 	/* For init, we want to retain the capabilities set
 	 * in the init_task struct. Thus we skip the usual
 	 * capability rules */
 	if (!is_global_init(current)) {
-		current->cap_permitted = bprm->cap_post_exec_permitted;
+		cred->cap_permitted = bprm->cap_post_exec_permitted;
 		if (bprm->cap_effective)
-			current->cap_effective = bprm->cap_post_exec_permitted;
+			cred->cap_effective = bprm->cap_post_exec_permitted;
 		else
-			cap_clear(current->cap_effective);
+			cap_clear(cred->cap_effective);
 	}
 
-	/* AUD: Audit candidate if current->cap_effective is set */
+	/* AUD: Audit candidate if cred->cap_effective is set */
 
-	current->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
+	cred->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
 }
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
 {
-	if (current_uid() != 0) {
+	const struct cred *cred = current->cred;
+
+	if (cred->uid != 0) {
 		if (bprm->cap_effective)
 			return 1;
 		if (!cap_isclear(bprm->cap_post_exec_permitted))
 			return 1;
 	}
 
-	return (current_euid() != current_uid() ||
-		current_egid() != current_gid());
+	return (cred->euid != cred->uid ||
+		cred->egid != cred->gid);
 }
 
 int cap_inode_setxattr(struct dentry *dentry, const char *name,
@@ -465,25 +471,27 @@ int cap_inode_removexattr(struct dentry *dentry, const char *name)
 static inline void cap_emulate_setxuid (int old_ruid, int old_euid,
 					int old_suid)
 {
-	uid_t euid = current_euid();
+	struct cred *cred = current->cred;
 
 	if ((old_ruid == 0 || old_euid == 0 || old_suid == 0) &&
-	    (current_uid()  != 0 && euid != 0 && current_suid() != 0) &&
+	    (cred->uid != 0 && cred->euid != 0 && cred->suid != 0) &&
 	    !issecure(SECURE_KEEP_CAPS)) {
-		cap_clear (current->cap_permitted);
-		cap_clear (current->cap_effective);
+		cap_clear (cred->cap_permitted);
+		cap_clear (cred->cap_effective);
 	}
-	if (old_euid == 0 && euid != 0) {
-		cap_clear (current->cap_effective);
+	if (old_euid == 0 && cred->euid != 0) {
+		cap_clear (cred->cap_effective);
 	}
-	if (old_euid != 0 && euid == 0) {
-		current->cap_effective = current->cap_permitted;
+	if (old_euid != 0 && cred->euid == 0) {
+		cred->cap_effective = cred->cap_permitted;
 	}
 }
 
 int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 			  int flags)
 {
+	struct cred *cred = current->cred;
+
 	switch (flags) {
 	case LSM_SETID_RE:
 	case LSM_SETID_ID:
@@ -505,16 +513,16 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 			 */
 
 			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
-				if (old_fsuid == 0 && current_fsuid() != 0) {
-					current->cap_effective =
+				if (old_fsuid == 0 && cred->fsuid != 0) {
+					cred->cap_effective =
 						cap_drop_fs_set(
-						    current->cap_effective);
+							cred->cap_effective);
 				}
-				if (old_fsuid != 0 && current_fsuid() == 0) {
-					current->cap_effective =
+				if (old_fsuid != 0 && cred->fsuid == 0) {
+					cred->cap_effective =
 						cap_raise_fs_set(
-						    current->cap_effective,
-						    current->cap_permitted);
+						    cred->cap_effective,
+						    cred->cap_permitted);
 				}
 			}
 			break;
@@ -539,7 +547,8 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
  */
 static inline int cap_safe_nice(struct task_struct *p)
 {
-	if (!cap_issubset(p->cap_permitted, current->cap_permitted) &&
+	if (!cap_issubset(p->cred->cap_permitted,
+			  current->cred->cap_permitted) &&
 	    !capable(CAP_SYS_NICE))
 		return -EPERM;
 	return 0;
@@ -574,7 +583,7 @@ static long cap_prctl_drop(unsigned long cap)
 		return -EPERM;
 	if (!cap_valid(cap))
 		return -EINVAL;
-	cap_lower(current->cap_bset, cap);
+	cap_lower(current->cred->cap_bset, cap);
 	return 0;
 }
 
@@ -597,6 +606,7 @@ int cap_task_setnice (struct task_struct *p, int nice)
 int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		   unsigned long arg4, unsigned long arg5, long *rc_p)
 {
+	struct cred *cred = current->cred;
 	long error = 0;
 
 	switch (option) {
@@ -604,7 +614,7 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		if (!cap_valid(arg2))
 			error = -EINVAL;
 		else
-			error = !!cap_raised(current->cap_bset, arg2);
+			error = !!cap_raised(cred->cap_bset, arg2);
 		break;
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 	case PR_CAPBSET_DROP:
@@ -631,9 +641,9 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 	 * capability-based-privilege environment.
 	 */
 	case PR_SET_SECUREBITS:
-		if ((((current->securebits & SECURE_ALL_LOCKS) >> 1)
-		     & (current->securebits ^ arg2))                  /*[1]*/
-		    || ((current->securebits & SECURE_ALL_LOCKS
+		if ((((cred->securebits & SECURE_ALL_LOCKS) >> 1)
+		     & (cred->securebits ^ arg2))                  /*[1]*/
+		    || ((cred->securebits & SECURE_ALL_LOCKS
 			 & ~arg2))                                    /*[2]*/
 		    || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS)) /*[3]*/
 		    || (cap_capable(current, CAP_SETPCAP) != 0)) {    /*[4]*/
@@ -646,11 +656,11 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			 */
 			error = -EPERM;  /* cannot change a locked bit */
 		} else {
-			current->securebits = arg2;
+			cred->securebits = arg2;
 		}
 		break;
 	case PR_GET_SECUREBITS:
-		error = current->securebits;
+		error = cred->securebits;
 		break;
 
 #endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
@@ -665,10 +675,9 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		else if (issecure(SECURE_KEEP_CAPS_LOCKED))
 			error = -EPERM;
 		else if (arg2)
-			current->securebits |= issecure_mask(SECURE_KEEP_CAPS);
+			cred->securebits |= issecure_mask(SECURE_KEEP_CAPS);
 		else
-			current->securebits &=
-				~issecure_mask(SECURE_KEEP_CAPS);
+			cred->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
 		break;
 
 	default:
@@ -683,11 +692,12 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 
 void cap_task_reparent_to_init (struct task_struct *p)
 {
-	cap_set_init_eff(p->cap_effective);
-	cap_clear(p->cap_inheritable);
-	cap_set_full(p->cap_permitted);
-	p->securebits = SECUREBITS_DEFAULT;
-	return;
+	struct cred *cred = p->cred;
+
+	cap_set_init_eff(cred->cap_effective);
+	cap_clear(cred->cap_inheritable);
+	cap_set_full(cred->cap_permitted);
+	p->cred->securebits = SECUREBITS_DEFAULT;
 }
 
 int cap_syslog (int type)
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index fcce331..8833b44 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -889,7 +889,7 @@ long keyctl_instantiate_key(key_serial_t id,
 	/* the appropriate instantiation authorisation key must have been
 	 * assumed before calling this */
 	ret = -EPERM;
-	instkey = current->request_key_auth;
+	instkey = current->cred->request_key_auth;
 	if (!instkey)
 		goto error;
 
@@ -932,8 +932,8 @@ long keyctl_instantiate_key(key_serial_t id,
 	/* discard the assumed authority if it's just been disabled by
 	 * instantiation of the key */
 	if (ret == 0) {
-		key_put(current->request_key_auth);
-		current->request_key_auth = NULL;
+		key_put(current->cred->request_key_auth);
+		current->cred->request_key_auth = NULL;
 	}
 
 error2:
@@ -960,7 +960,7 @@ long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 	/* the appropriate instantiation authorisation key must have been
 	 * assumed before calling this */
 	ret = -EPERM;
-	instkey = current->request_key_auth;
+	instkey = current->cred->request_key_auth;
 	if (!instkey)
 		goto error;
 
@@ -983,8 +983,8 @@ long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 	/* discard the assumed authority if it's just been disabled by
 	 * instantiation of the key */
 	if (ret == 0) {
-		key_put(current->request_key_auth);
-		current->request_key_auth = NULL;
+		key_put(current->cred->request_key_auth);
+		current->cred->request_key_auth = NULL;
 	}
 
 error:
@@ -999,6 +999,7 @@ error:
  */
 long keyctl_set_reqkey_keyring(int reqkey_defl)
 {
+	struct cred *cred = current->cred;
 	int ret;
 
 	switch (reqkey_defl) {
@@ -1018,10 +1019,10 @@ long keyctl_set_reqkey_keyring(int reqkey_defl)
 	case KEY_REQKEY_DEFL_USER_KEYRING:
 	case KEY_REQKEY_DEFL_USER_SESSION_KEYRING:
 	set:
-		current->jit_keyring = reqkey_defl;
+		cred->jit_keyring = reqkey_defl;
 
 	case KEY_REQKEY_DEFL_NO_CHANGE:
-		return current->jit_keyring;
+		return cred->jit_keyring;
 
 	case KEY_REQKEY_DEFL_GROUP_KEYRING:
 	default:
@@ -1086,8 +1087,8 @@ long keyctl_assume_authority(key_serial_t id)
 
 	/* we divest ourselves of authority if given an ID of 0 */
 	if (id == 0) {
-		key_put(current->request_key_auth);
-		current->request_key_auth = NULL;
+		key_put(current->cred->request_key_auth);
+		current->cred->request_key_auth = NULL;
 		ret = 0;
 		goto error;
 	}
@@ -1103,8 +1104,8 @@ long keyctl_assume_authority(key_serial_t id)
 		goto error;
 	}
 
-	key_put(current->request_key_auth);
-	current->request_key_auth = authkey;
+	key_put(current->cred->request_key_auth);
+	current->cred->request_key_auth = authkey;
 	ret = authkey->serial;
 
 error:
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 3b41f9b..baf3d5f 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -22,6 +22,7 @@ int key_task_permission(const key_ref_t key_ref,
 			struct task_struct *context,
 			key_perm_t perm)
 {
+	struct cred *cred = context->cred;
 	struct key *key;
 	key_perm_t kperm;
 	int ret;
@@ -29,7 +30,7 @@ int key_task_permission(const key_ref_t key_ref,
 	key = key_ref_to_ptr(key_ref);
 
 	/* use the second 8-bits of permissions for keys the caller owns */
-	if (key->uid == context->fsuid) {
+	if (key->uid == cred->fsuid) {
 		kperm = key->perm >> 16;
 		goto use_these_perms;
 	}
@@ -37,14 +38,14 @@ int key_task_permission(const key_ref_t key_ref,
 	/* use the third 8-bits of permissions for keys the caller has a group
 	 * membership in common with */
 	if (key->gid != -1 && key->perm & KEY_GRP_ALL) {
-		if (key->gid == context->fsgid) {
+		if (key->gid == cred->fsgid) {
 			kperm = key->perm >> 8;
 			goto use_these_perms;
 		}
 
-		task_lock(context);
-		ret = groups_search(context->group_info, key->gid);
-		task_unlock(context);
+		spin_lock(&cred->lock);
+		ret = groups_search(cred->group_info, key->gid);
+		spin_unlock(&cred->lock);
 
 		if (ret) {
 			kperm = key->perm >> 8;
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 324093d..248ad13 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -42,7 +42,7 @@ struct key_user root_key_user = {
  */
 static int install_user_keyrings(void)
 {
-	struct user_struct *user = current->user;
+	struct user_struct *user = current->cred->user;
 	struct key *uid_keyring, *session_keyring;
 	char buf[20];
 	int ret;
@@ -156,7 +156,7 @@ int install_thread_keyring(void)
 
 	sprintf(buf, "_tid.%u", tsk->pid);
 
-	keyring = keyring_alloc(buf, tsk->uid, tsk->gid, tsk,
+	keyring = keyring_alloc(buf, tsk->cred->uid, tsk->cred->gid, tsk,
 				KEY_ALLOC_QUOTA_OVERRUN, NULL);
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
@@ -164,8 +164,8 @@ int install_thread_keyring(void)
 	}
 
 	task_lock(tsk);
-	old = tsk->thread_keyring;
-	tsk->thread_keyring = keyring;
+	old = tsk->cred->thread_keyring;
+	tsk->cred->thread_keyring = keyring;
 	task_unlock(tsk);
 
 	ret = 0;
@@ -192,7 +192,7 @@ int install_process_keyring(void)
 	if (!tsk->signal->process_keyring) {
 		sprintf(buf, "_pid.%u", tsk->tgid);
 
-		keyring = keyring_alloc(buf, tsk->uid, tsk->gid, tsk,
+		keyring = keyring_alloc(buf, tsk->cred->uid, tsk->cred->gid, tsk,
 					KEY_ALLOC_QUOTA_OVERRUN, NULL);
 		if (IS_ERR(keyring)) {
 			ret = PTR_ERR(keyring);
@@ -238,7 +238,7 @@ static int install_session_keyring(struct key *keyring)
 		if (tsk->signal->session_keyring)
 			flags = KEY_ALLOC_IN_QUOTA;
 
-		keyring = keyring_alloc(buf, tsk->uid, tsk->gid, tsk,
+		keyring = keyring_alloc(buf, tsk->cred->uid, tsk->cred->gid, tsk,
 					flags, NULL);
 		if (IS_ERR(keyring))
 			return PTR_ERR(keyring);
@@ -292,14 +292,14 @@ int copy_thread_group_keys(struct task_struct *tsk)
  */
 int copy_keys(unsigned long clone_flags, struct task_struct *tsk)
 {
-	key_check(tsk->thread_keyring);
-	key_check(tsk->request_key_auth);
+	key_check(tsk->cred->thread_keyring);
+	key_check(tsk->cred->request_key_auth);
 
 	/* no thread keyring yet */
-	tsk->thread_keyring = NULL;
+	tsk->cred->thread_keyring = NULL;
 
 	/* copy the request_key() authorisation for this thread */
-	key_get(tsk->request_key_auth);
+	key_get(tsk->cred->request_key_auth);
 
 	return 0;
 
@@ -322,8 +322,8 @@ void exit_thread_group_keys(struct signal_struct *tg)
  */
 void exit_keys(struct task_struct *tsk)
 {
-	key_put(tsk->thread_keyring);
-	key_put(tsk->request_key_auth);
+	key_put(tsk->cred->thread_keyring);
+	key_put(tsk->cred->request_key_auth);
 
 } /* end exit_keys() */
 
@@ -337,8 +337,8 @@ int exec_keys(struct task_struct *tsk)
 
 	/* newly exec'd tasks don't get a thread keyring */
 	task_lock(tsk);
-	old = tsk->thread_keyring;
-	tsk->thread_keyring = NULL;
+	old = tsk->cred->thread_keyring;
+	tsk->cred->thread_keyring = NULL;
 	task_unlock(tsk);
 
 	key_put(old);
@@ -373,10 +373,11 @@ int suid_keys(struct task_struct *tsk)
 void key_fsuid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
-	if (tsk->thread_keyring) {
-		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->uid = tsk->fsuid;
-		up_write(&tsk->thread_keyring->sem);
+	BUG_ON(!tsk->cred);
+	if (tsk->cred->thread_keyring) {
+		down_write(&tsk->cred->thread_keyring->sem);
+		tsk->cred->thread_keyring->uid = tsk->cred->fsuid;
+		up_write(&tsk->cred->thread_keyring->sem);
 	}
 
 } /* end key_fsuid_changed() */
@@ -388,10 +389,11 @@ void key_fsuid_changed(struct task_struct *tsk)
 void key_fsgid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
-	if (tsk->thread_keyring) {
-		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->gid = tsk->fsgid;
-		up_write(&tsk->thread_keyring->sem);
+	BUG_ON(!tsk->cred);
+	if (tsk->cred->thread_keyring) {
+		down_write(&tsk->cred->thread_keyring->sem);
+		tsk->cred->thread_keyring->gid = tsk->cred->fsgid;
+		up_write(&tsk->cred->thread_keyring->sem);
 	}
 
 } /* end key_fsgid_changed() */
@@ -426,9 +428,9 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	err = ERR_PTR(-EAGAIN);
 
 	/* search the thread keyring first */
-	if (context->thread_keyring) {
+	if (context->cred->thread_keyring) {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->thread_keyring, 1),
+			make_key_ref(context->cred->thread_keyring, 1),
 			context, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
@@ -493,9 +495,9 @@ key_ref_t search_process_keyrings(struct key_type *type,
 		}
 	}
 	/* or search the user-session keyring */
-	else if (context->user->session_keyring) {
+	else if (context->cred->user->session_keyring) {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->user->session_keyring, 1),
+			make_key_ref(context->cred->user->session_keyring, 1),
 			context, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
@@ -517,20 +519,20 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	 * search the keyrings of the process mentioned there
 	 * - we don't permit access to request_key auth keys via this method
 	 */
-	if (context->request_key_auth &&
+	if (context->cred->request_key_auth &&
 	    context == current &&
 	    type != &key_type_request_key_auth
 	    ) {
 		/* defend against the auth key being revoked */
-		down_read(&context->request_key_auth->sem);
+		down_read(&context->cred->request_key_auth->sem);
 
-		if (key_validate(context->request_key_auth) == 0) {
-			rka = context->request_key_auth->payload.data;
+		if (key_validate(context->cred->request_key_auth) == 0) {
+			rka = context->cred->request_key_auth->payload.data;
 
 			key_ref = search_process_keyrings(type, description,
 							  match, rka->context);
 
-			up_read(&context->request_key_auth->sem);
+			up_read(&context->cred->request_key_auth->sem);
 
 			if (!IS_ERR(key_ref))
 				goto found;
@@ -547,7 +549,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 				break;
 			}
 		} else {
-			up_read(&context->request_key_auth->sem);
+			up_read(&context->cred->request_key_auth->sem);
 		}
 	}
 
@@ -580,15 +582,16 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 {
 	struct request_key_auth *rka;
 	struct task_struct *t = current;
-	key_ref_t key_ref, skey_ref;
+	struct cred *cred = t->cred;
 	struct key *key;
+	key_ref_t key_ref, skey_ref;
 	int ret;
 
 	key_ref = ERR_PTR(-ENOKEY);
 
 	switch (id) {
 	case KEY_SPEC_THREAD_KEYRING:
-		if (!t->thread_keyring) {
+		if (!cred->thread_keyring) {
 			if (!create)
 				goto error;
 
@@ -599,7 +602,7 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 			}
 		}
 
-		key = t->thread_keyring;
+		key = cred->thread_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
@@ -628,7 +631,8 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 			ret = install_user_keyrings();
 			if (ret < 0)
 				goto error;
-			ret = install_session_keyring(t->user->session_keyring);
+			ret = install_session_keyring(
+				cred->user->session_keyring);
 			if (ret < 0)
 				goto error;
 		}
@@ -641,25 +645,25 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 		break;
 
 	case KEY_SPEC_USER_KEYRING:
-		if (!t->user->uid_keyring) {
+		if (!cred->user->uid_keyring) {
 			ret = install_user_keyrings();
 			if (ret < 0)
 				goto error;
 		}
 
-		key = t->user->uid_keyring;
+		key = cred->user->uid_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_USER_SESSION_KEYRING:
-		if (!t->user->session_keyring) {
+		if (!cred->user->session_keyring) {
 			ret = install_user_keyrings();
 			if (ret < 0)
 				goto error;
 		}
 
-		key = t->user->session_keyring;
+		key = cred->user->session_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
@@ -670,7 +674,7 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 		goto error;
 
 	case KEY_SPEC_REQKEY_AUTH_KEY:
-		key = t->request_key_auth;
+		key = cred->request_key_auth;
 		if (!key)
 			goto error;
 
@@ -679,19 +683,19 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 		break;
 
 	case KEY_SPEC_REQUESTOR_KEYRING:
-		if (!t->request_key_auth)
+		if (!cred->request_key_auth)
 			goto error;
 
-		down_read(&t->request_key_auth->sem);
-		if (t->request_key_auth->flags & KEY_FLAG_REVOKED) {
+		down_read(&cred->request_key_auth->sem);
+		if (cred->request_key_auth->flags & KEY_FLAG_REVOKED) {
 			key_ref = ERR_PTR(-EKEYREVOKED);
 			key = NULL;
 		} else {
-			rka = t->request_key_auth->payload.data;
+			rka = cred->request_key_auth->payload.data;
 			key = rka->dest_keyring;
 			atomic_inc(&key->usage);
 		}
-		up_read(&t->request_key_auth->sem);
+		up_read(&cred->request_key_auth->sem);
 		if (!key)
 			goto error;
 		key_ref = make_key_ref(key, 1);
@@ -791,7 +795,7 @@ long join_session_keyring(const char *name)
 	keyring = find_keyring_by_name(name, false);
 	if (PTR_ERR(keyring) == -ENOKEY) {
 		/* not found - try and create a new one */
-		keyring = keyring_alloc(name, tsk->uid, tsk->gid, tsk,
+		keyring = keyring_alloc(name, tsk->cred->uid, tsk->cred->gid, tsk,
 					KEY_ALLOC_IN_QUOTA, NULL);
 		if (IS_ERR(keyring)) {
 			ret = PTR_ERR(keyring);
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index d7a4e25..8ffd86e 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -100,7 +100,8 @@ static int call_sbin_request_key(struct key_construction *cons,
 
 	/* we specify the process's default keyrings */
 	sprintf(keyring_str[0], "%d",
-		tsk->thread_keyring ? tsk->thread_keyring->serial : 0);
+		tsk->cred->thread_keyring ?
+		tsk->cred->thread_keyring->serial : 0);
 
 	prkey = 0;
 	if (tsk->signal->process_keyring)
@@ -113,7 +114,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 		sskey = rcu_dereference(tsk->signal->session_keyring)->serial;
 		rcu_read_unlock();
 	} else {
-		sskey = tsk->user->session_keyring->serial;
+		sskey = tsk->cred->user->session_keyring->serial;
 	}
 
 	sprintf(keyring_str[2], "%d", sskey);
@@ -228,11 +229,11 @@ static void construct_get_dest_keyring(struct key **_dest_keyring)
 	} else {
 		/* use a default keyring; falling through the cases until we
 		 * find one that we actually have */
-		switch (tsk->jit_keyring) {
+		switch (tsk->cred->jit_keyring) {
 		case KEY_REQKEY_DEFL_DEFAULT:
 		case KEY_REQKEY_DEFL_REQUESTOR_KEYRING:
-			if (tsk->request_key_auth) {
-				authkey = tsk->request_key_auth;
+			if (tsk->cred->request_key_auth) {
+				authkey = tsk->cred->request_key_auth;
 				down_read(&authkey->sem);
 				rka = authkey->payload.data;
 				if (!test_bit(KEY_FLAG_REVOKED,
@@ -245,7 +246,7 @@ static void construct_get_dest_keyring(struct key **_dest_keyring)
 			}
 
 		case KEY_REQKEY_DEFL_THREAD_KEYRING:
-			dest_keyring = key_get(tsk->thread_keyring);
+			dest_keyring = key_get(tsk->cred->thread_keyring);
 			if (dest_keyring)
 				break;
 
@@ -264,11 +265,12 @@ static void construct_get_dest_keyring(struct key **_dest_keyring)
 				break;
 
 		case KEY_REQKEY_DEFL_USER_SESSION_KEYRING:
-			dest_keyring = key_get(tsk->user->session_keyring);
+			dest_keyring =
+				key_get(tsk->cred->user->session_keyring);
 			break;
 
 		case KEY_REQKEY_DEFL_USER_KEYRING:
-			dest_keyring = key_get(tsk->user->uid_keyring);
+			dest_keyring = key_get(tsk->cred->user->uid_keyring);
 			break;
 
 		case KEY_REQKEY_DEFL_GROUP_KEYRING:
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 1762d44..2125579 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -164,22 +164,22 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 
 	/* see if the calling process is already servicing the key request of
 	 * another process */
-	if (current->request_key_auth) {
+	if (current->cred->request_key_auth) {
 		/* it is - use that instantiation context here too */
-		down_read(&current->request_key_auth->sem);
+		down_read(&current->cred->request_key_auth->sem);
 
 		/* if the auth key has been revoked, then the key we're
 		 * servicing is already instantiated */
 		if (test_bit(KEY_FLAG_REVOKED,
-			     &current->request_key_auth->flags))
+			     &current->cred->request_key_auth->flags))
 			goto auth_key_revoked;
 
-		irka = current->request_key_auth->payload.data;
+		irka = current->cred->request_key_auth->payload.data;
 		rka->context = irka->context;
 		rka->pid = irka->pid;
 		get_task_struct(rka->context);
 
-		up_read(&current->request_key_auth->sem);
+		up_read(&current->cred->request_key_auth->sem);
 	}
 	else {
 		/* it isn't - use this process as the context */
@@ -214,7 +214,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 	return authkey;
 
 auth_key_revoked:
-	up_read(&current->request_key_auth->sem);
+	up_read(&current->cred->request_key_auth->sem);
 	kfree(rka->callout_info);
 	kfree(rka);
 	kleave("= -EKEYREVOKED");
diff --git a/security/selinux/exports.c b/security/selinux/exports.c
index 64af2d3..cf02490 100644
--- a/security/selinux/exports.c
+++ b/security/selinux/exports.c
@@ -39,7 +39,7 @@ EXPORT_SYMBOL_GPL(selinux_string_to_sid);
 int selinux_secmark_relabel_packet_permission(u32 sid)
 {
 	if (selinux_enabled) {
-		struct task_security_struct *tsec = current->security;
+		struct task_security_struct *tsec = current->cred->security;
 
 		return avc_has_perm(tsec->sid, sid, SECCLASS_PACKET,
 				    PACKET__RELABELTO, NULL);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9cc59f6..3e8900e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -166,21 +166,21 @@ static int task_alloc_security(struct task_struct *task)
 		return -ENOMEM;
 
 	tsec->osid = tsec->sid = SECINITSID_UNLABELED;
-	task->security = tsec;
+	task->cred->security = tsec;
 
 	return 0;
 }
 
 static void task_free_security(struct task_struct *task)
 {
-	struct task_security_struct *tsec = task->security;
-	task->security = NULL;
+	struct task_security_struct *tsec = task->cred->security;
+	task->cred->security = NULL;
 	kfree(tsec);
 }
 
 static int inode_alloc_security(struct inode *inode)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->cred->security;
 	struct inode_security_struct *isec;
 
 	isec = kmem_cache_zalloc(sel_inode_cache, GFP_NOFS);
@@ -214,7 +214,7 @@ static void inode_free_security(struct inode *inode)
 
 static int file_alloc_security(struct file *file)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->cred->security;
 	struct file_security_struct *fsec;
 
 	fsec = kzalloc(sizeof(struct file_security_struct), GFP_KERNEL);
@@ -552,7 +552,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 				struct security_mnt_opts *opts)
 {
 	int rc = 0, i;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->cred->security;
 	struct superblock_security_struct *sbsec = sb->s_security;
 	const char *name = sb->s_type->name;
 	struct inode *inode = sbsec->sb->s_root->d_inode;
@@ -1351,8 +1351,8 @@ static int task_has_perm(struct task_struct *tsk1,
 {
 	struct task_security_struct *tsec1, *tsec2;
 
-	tsec1 = tsk1->security;
-	tsec2 = tsk2->security;
+	tsec1 = tsk1->cred->security;
+	tsec2 = tsk2->cred->security;
 	return avc_has_perm(tsec1->sid, tsec2->sid,
 			    SECCLASS_PROCESS, perms, NULL);
 }
@@ -1370,7 +1370,7 @@ static int task_has_capability(struct task_struct *tsk,
 	u16 sclass;
 	u32 av = CAP_TO_MASK(cap);
 
-	tsec = tsk->security;
+	tsec = tsk->cred->security;
 
 	AVC_AUDIT_DATA_INIT(&ad, CAP);
 	ad.tsk = tsk;
@@ -1397,7 +1397,7 @@ static int task_has_system(struct task_struct *tsk,
 {
 	struct task_security_struct *tsec;
 
-	tsec = tsk->security;
+	tsec = tsk->cred->security;
 
 	return avc_has_perm(tsec->sid, SECINITSID_KERNEL,
 			    SECCLASS_SYSTEM, perms, NULL);
@@ -1418,7 +1418,7 @@ static int inode_has_perm(struct task_struct *tsk,
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 
-	tsec = tsk->security;
+	tsec = tsk->cred->security;
 	isec = inode->i_security;
 
 	if (!adp) {
@@ -1458,7 +1458,7 @@ static int file_has_perm(struct task_struct *tsk,
 				struct file *file,
 				u32 av)
 {
-	struct task_security_struct *tsec = tsk->security;
+	struct task_security_struct *tsec = tsk->cred->security;
 	struct file_security_struct *fsec = file->f_security;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct avc_audit_data ad;
@@ -1495,7 +1495,7 @@ static int may_create(struct inode *dir,
 	struct avc_audit_data ad;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	dsec = dir->i_security;
 	sbsec = dir->i_sb->s_security;
 
@@ -1532,7 +1532,7 @@ static int may_create_key(u32 ksid,
 {
 	struct task_security_struct *tsec;
 
-	tsec = ctx->security;
+	tsec = ctx->cred->security;
 
 	return avc_has_perm(tsec->sid, ksid, SECCLASS_KEY, KEY__CREATE, NULL);
 }
@@ -1553,7 +1553,7 @@ static int may_link(struct inode *dir,
 	u32 av;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	dsec = dir->i_security;
 	isec = dentry->d_inode->i_security;
 
@@ -1598,7 +1598,7 @@ static inline int may_rename(struct inode *old_dir,
 	int old_is_dir, new_is_dir;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	old_dsec = old_dir->i_security;
 	old_isec = old_dentry->d_inode->i_security;
 	old_is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
@@ -1651,7 +1651,7 @@ static int superblock_has_perm(struct task_struct *tsk,
 	struct task_security_struct *tsec;
 	struct superblock_security_struct *sbsec;
 
-	tsec = tsk->security;
+	tsec = tsk->cred->security;
 	sbsec = sb->s_security;
 	return avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
 			    perms, ad);
@@ -1749,8 +1749,8 @@ static int selinux_ptrace_may_access(struct task_struct *child,
 		return rc;
 
 	if (mode == PTRACE_MODE_READ) {
-		struct task_security_struct *tsec = current->security;
-		struct task_security_struct *csec = child->security;
+		struct task_security_struct *tsec = current->cred->security;
+		struct task_security_struct *csec = child->cred->security;
 		return avc_has_perm(tsec->sid, csec->sid,
 				    SECCLASS_FILE, FILE__READ, NULL);
 	}
@@ -1865,7 +1865,7 @@ static int selinux_sysctl(ctl_table *table, int op)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 
 	rc = selinux_sysctl_get_sid(table, (op == 0001) ?
 				    SECCLASS_DIR : SECCLASS_FILE, &tsid);
@@ -1972,7 +1972,7 @@ static int selinux_syslog(int type)
 static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int rc, cap_sys_admin = 0;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->cred->security;
 
 	rc = secondary_ops->capable(current, CAP_SYS_ADMIN);
 	if (rc == 0)
@@ -2024,7 +2024,7 @@ static int selinux_bprm_set_security(struct linux_binprm *bprm)
 	if (bsec->set)
 		return 0;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	isec = inode->i_security;
 
 	/* Default to the current task SID. */
@@ -2089,7 +2089,7 @@ static int selinux_bprm_check_security(struct linux_binprm *bprm)
 
 static int selinux_bprm_secureexec(struct linux_binprm *bprm)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->cred->security;
 	int atsecure = 0;
 
 	if (tsec->osid != tsec->sid) {
@@ -2212,7 +2212,7 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 
 	secondary_ops->bprm_apply_creds(bprm, unsafe);
 
-	tsec = current->security;
+	tsec = current->cred->security;
 
 	bsec = bprm->security;
 	sid = bsec->sid;
@@ -2241,7 +2241,7 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 			rcu_read_lock();
 			tracer = tracehook_tracer_task(current);
 			if (likely(tracer != NULL)) {
-				sec = tracer->security;
+				sec = tracer->cred->security;
 				ptsid = sec->sid;
 			}
 			rcu_read_unlock();
@@ -2270,7 +2270,7 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
 	struct bprm_security_struct *bsec;
 	int rc, i;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	bsec = bprm->security;
 
 	if (bsec->unsafe) {
@@ -2518,7 +2518,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	int rc;
 	char *namep = NULL, *context;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	dsec = dir->i_security;
 	sbsec = dir->i_sb->s_security;
 
@@ -2703,7 +2703,7 @@ static int selinux_inode_setotherxattr(struct dentry *dentry, const char *name)
 static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 				  const void *value, size_t size, int flags)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->cred->security;
 	struct inode *inode = dentry->d_inode;
 	struct inode_security_struct *isec = inode->i_security;
 	struct superblock_security_struct *sbsec;
@@ -2811,7 +2811,7 @@ static int selinux_inode_getsecurity(const struct inode *inode, const char *name
 	u32 size;
 	int error;
 	char *context = NULL;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->cred->security;
 	struct inode_security_struct *isec = inode->i_security;
 
 	if (strcmp(name, XATTR_SELINUX_SUFFIX))
@@ -2922,7 +2922,7 @@ static int selinux_revalidate_file_permission(struct file *file, int mask)
 static int selinux_file_permission(struct file *file, int mask)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->cred->security;
 	struct file_security_struct *fsec = file->f_security;
 	struct inode_security_struct *isec = inode->i_security;
 
@@ -2999,7 +2999,8 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 			     unsigned long addr, unsigned long addr_only)
 {
 	int rc = 0;
-	u32 sid = ((struct task_security_struct *)(current->security))->sid;
+	u32 sid = ((struct task_security_struct *)
+		   (current->cred->security))->sid;
 
 	if (addr < mmap_min_addr)
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
@@ -3111,7 +3112,7 @@ static int selinux_file_set_fowner(struct file *file)
 	struct task_security_struct *tsec;
 	struct file_security_struct *fsec;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	fsec = file->f_security;
 	fsec->fown_sid = tsec->sid;
 
@@ -3129,7 +3130,7 @@ static int selinux_file_send_sigiotask(struct task_struct *tsk,
 	/* struct fown_struct is never outside the context of a struct file */
 	file = container_of(fown, struct file, f_owner);
 
-	tsec = tsk->security;
+	tsec = tsk->cred->security;
 	fsec = file->f_security;
 
 	if (!signum)
@@ -3192,12 +3193,12 @@ static int selinux_task_alloc_security(struct task_struct *tsk)
 	struct task_security_struct *tsec1, *tsec2;
 	int rc;
 
-	tsec1 = current->security;
+	tsec1 = current->cred->security;
 
 	rc = task_alloc_security(tsk);
 	if (rc)
 		return rc;
-	tsec2 = tsk->security;
+	tsec2 = tsk->cred->security;
 
 	tsec2->osid = tsec1->osid;
 	tsec2->sid = tsec1->sid;
@@ -3255,7 +3256,7 @@ static int selinux_task_getsid(struct task_struct *p)
 
 static void selinux_task_getsecid(struct task_struct *p, u32 *secid)
 {
-	struct task_security_struct *tsec = p->security;
+	struct task_security_struct *tsec = p->cred->security;
 	*secid = tsec->sid;
 }
 
@@ -3347,7 +3348,7 @@ static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
 		perm = PROCESS__SIGNULL; /* null signal; existence test */
 	else
 		perm = signal_to_av(sig);
-	tsec = p->security;
+	tsec = p->cred->security;
 	if (secid)
 		rc = avc_has_perm(secid, tsec->sid, SECCLASS_PROCESS, perm, NULL);
 	else
@@ -3379,7 +3380,7 @@ static void selinux_task_reparent_to_init(struct task_struct *p)
 
 	secondary_ops->task_reparent_to_init(p);
 
-	tsec = p->security;
+	tsec = p->cred->security;
 	tsec->osid = tsec->sid;
 	tsec->sid = SECINITSID_KERNEL;
 	return;
@@ -3388,7 +3389,7 @@ static void selinux_task_reparent_to_init(struct task_struct *p)
 static void selinux_task_to_inode(struct task_struct *p,
 				  struct inode *inode)
 {
-	struct task_security_struct *tsec = p->security;
+	struct task_security_struct *tsec = p->cred->security;
 	struct inode_security_struct *isec = inode->i_security;
 
 	isec->sid = tsec->sid;
@@ -3636,7 +3637,7 @@ static int socket_has_perm(struct task_struct *task, struct socket *sock,
 	struct avc_audit_data ad;
 	int err = 0;
 
-	tsec = task->security;
+	tsec = task->cred->security;
 	isec = SOCK_INODE(sock)->i_security;
 
 	if (isec->sid == SECINITSID_KERNEL)
@@ -3660,7 +3661,7 @@ static int selinux_socket_create(int family, int type,
 	if (kern)
 		goto out;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	newsid = tsec->sockcreate_sid ? : tsec->sid;
 	err = avc_has_perm(tsec->sid, newsid,
 			   socket_type_to_security_class(family, type,
@@ -3681,7 +3682,7 @@ static int selinux_socket_post_create(struct socket *sock, int family,
 
 	isec = SOCK_INODE(sock)->i_security;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	newsid = tsec->sockcreate_sid ? : tsec->sid;
 	isec->sclass = socket_type_to_security_class(family, type, protocol);
 	isec->sid = kern ? SECINITSID_KERNEL : newsid;
@@ -3727,7 +3728,7 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 		struct sock *sk = sock->sk;
 		u32 sid, node_perm;
 
-		tsec = current->security;
+		tsec = current->cred->security;
 		isec = SOCK_INODE(sock)->i_security;
 
 		if (family == PF_INET) {
@@ -4667,7 +4668,7 @@ static int ipc_alloc_security(struct task_struct *task,
 			      struct kern_ipc_perm *perm,
 			      u16 sclass)
 {
-	struct task_security_struct *tsec = task->security;
+	struct task_security_struct *tsec = task->cred->security;
 	struct ipc_security_struct *isec;
 
 	isec = kzalloc(sizeof(struct ipc_security_struct), GFP_KERNEL);
@@ -4717,7 +4718,7 @@ static int ipc_has_perm(struct kern_ipc_perm *ipc_perms,
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	isec = ipc_perms->security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4748,7 +4749,7 @@ static int selinux_msg_queue_alloc_security(struct msg_queue *msq)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	isec = msq->q_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4774,7 +4775,7 @@ static int selinux_msg_queue_associate(struct msg_queue *msq, int msqflg)
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	isec = msq->q_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4820,7 +4821,7 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 	struct avc_audit_data ad;
 	int rc;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	isec = msq->q_perm.security;
 	msec = msg->security;
 
@@ -4868,7 +4869,7 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 	struct avc_audit_data ad;
 	int rc;
 
-	tsec = target->security;
+	tsec = target->cred->security;
 	isec = msq->q_perm.security;
 	msec = msg->security;
 
@@ -4895,7 +4896,7 @@ static int selinux_shm_alloc_security(struct shmid_kernel *shp)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	isec = shp->shm_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4921,7 +4922,7 @@ static int selinux_shm_associate(struct shmid_kernel *shp, int shmflg)
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	isec = shp->shm_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -4994,7 +4995,7 @@ static int selinux_sem_alloc_security(struct sem_array *sma)
 	if (rc)
 		return rc;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	isec = sma->sem_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -5020,7 +5021,7 @@ static int selinux_sem_associate(struct sem_array *sma, int semflg)
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
 
-	tsec = current->security;
+	tsec = current->cred->security;
 	isec = sma->sem_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
@@ -5127,7 +5128,7 @@ static int selinux_getprocattr(struct task_struct *p,
 			return error;
 	}
 
-	tsec = p->security;
+	tsec = p->cred->security;
 
 	if (!strcmp(name, "current"))
 		sid = tsec->sid;
@@ -5211,7 +5212,7 @@ static int selinux_setprocattr(struct task_struct *p,
 	   operation.  See selinux_bprm_set_security for the execve
 	   checks and may_create for the file creation checks. The
 	   operation will then fail if the context is not permitted. */
-	tsec = p->security;
+	tsec = p->cred->security;
 	if (!strcmp(name, "exec"))
 		tsec->exec_sid = sid;
 	else if (!strcmp(name, "fscreate"))
@@ -5255,7 +5256,8 @@ static int selinux_setprocattr(struct task_struct *p,
 		rcu_read_lock();
 		tracer = tracehook_tracer_task(p);
 		if (tracer != NULL) {
-			struct task_security_struct *ptsec = tracer->security;
+			struct task_security_struct *ptsec =
+				tracer->cred->security;
 			u32 ptsid = ptsec->sid;
 			rcu_read_unlock();
 			error = avc_has_perm_noaudit(ptsid, sid,
@@ -5299,7 +5301,7 @@ static void selinux_release_secctx(char *secdata, u32 seclen)
 static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
 			     unsigned long flags)
 {
-	struct task_security_struct *tsec = tsk->security;
+	struct task_security_struct *tsec = tsk->cred->security;
 	struct key_security_struct *ksec;
 
 	ksec = kzalloc(sizeof(struct key_security_struct), GFP_KERNEL);
@@ -5333,7 +5335,7 @@ static int selinux_key_permission(key_ref_t key_ref,
 
 	key = key_ref_to_ptr(key_ref);
 
-	tsec = ctx->security;
+	tsec = ctx->cred->security;
 	ksec = key->security;
 
 	/* if no specific permissions are requested, we skip the
@@ -5577,7 +5579,7 @@ static __init int selinux_init(void)
 	/* Set the security state for the initial task. */
 	if (task_alloc_security(current))
 		panic("SELinux:  Failed to initialize initial task.\n");
-	tsec = current->security;
+	tsec = current->cred->security;
 	tsec->osid = tsec->sid = SECINITSID_KERNEL;
 
 	sel_inode_cache = kmem_cache_create("selinux_inode_security",
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 69c9dcc..10715d1 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -97,7 +97,7 @@ static int task_has_security(struct task_struct *tsk,
 {
 	struct task_security_struct *tsec;
 
-	tsec = tsk->security;
+	tsec = tsk->cred->security;
 	if (!tsec)
 		return -EACCES;
 
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 8f17f54..d7db766 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -197,7 +197,7 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	struct xfrm_user_sec_ctx *uctx, u32 sid)
 {
 	int rc = 0;
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->cred->security;
 	struct xfrm_sec_ctx *ctx = NULL;
 	char *ctx_str = NULL;
 	u32 str_len;
@@ -333,7 +333,7 @@ void selinux_xfrm_policy_free(struct xfrm_sec_ctx *ctx)
  */
 int selinux_xfrm_policy_delete(struct xfrm_sec_ctx *ctx)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->cred->security;
 	int rc = 0;
 
 	if (ctx) {
@@ -378,7 +378,7 @@ void selinux_xfrm_state_free(struct xfrm_state *x)
   */
 int selinux_xfrm_state_delete(struct xfrm_state *x)
 {
-	struct task_security_struct *tsec = current->security;
+	struct task_security_struct *tsec = current->cred->security;
 	struct xfrm_sec_ctx *ctx = x->security;
 	int rc = 0;
 
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 79ff21e..b6dd4fc 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -164,7 +164,7 @@ int smk_curacc(char *obj_label, u32 mode)
 {
 	int rc;
 
-	rc = smk_access(current->security, obj_label, mode);
+	rc = smk_access(current->cred->security, obj_label, mode);
 	if (rc == 0)
 		return 0;
 
@@ -173,7 +173,7 @@ int smk_curacc(char *obj_label, u32 mode)
 	 * only one that gets privilege and current does not
 	 * have that label.
 	 */
-	if (smack_onlycap != NULL && smack_onlycap != current->security)
+	if (smack_onlycap != NULL && smack_onlycap != current->cred->security)
 		return rc;
 
 	if (capable(CAP_MAC_OVERRIDE))
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 87d7541..ccded56 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -102,7 +102,8 @@ static int smack_ptrace_may_access(struct task_struct *ctp, unsigned int mode)
 	if (rc != 0)
 		return rc;
 
-	rc = smk_access(current->security, ctp->security, MAY_READWRITE);
+	rc = smk_access(current->cred->security, ctp->cred->security,
+			MAY_READWRITE);
 	if (rc != 0 && capable(CAP_MAC_OVERRIDE))
 		return 0;
 	return rc;
@@ -124,7 +125,8 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
 	if (rc != 0)
 		return rc;
 
-	rc = smk_access(ptp->security, current->security, MAY_READWRITE);
+	rc = smk_access(ptp->cred->security, current->cred->security,
+			MAY_READWRITE);
 	if (rc != 0 && has_capability(ptp, CAP_MAC_OVERRIDE))
 		return 0;
 	return rc;
@@ -141,7 +143,7 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
 static int smack_syslog(int type)
 {
 	int rc;
-	char *sp = current->security;
+	char *sp = current->cred->security;
 
 	rc = cap_syslog(type);
 	if (rc != 0)
@@ -373,7 +375,7 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
  */
 static int smack_inode_alloc_security(struct inode *inode)
 {
-	inode->i_security = new_inode_smack(current->security);
+	inode->i_security = new_inode_smack(current->cred->security);
 	if (inode->i_security == NULL)
 		return -ENOMEM;
 	return 0;
@@ -818,7 +820,7 @@ static int smack_file_permission(struct file *file, int mask)
  */
 static int smack_file_alloc_security(struct file *file)
 {
-	file->f_security = current->security;
+	file->f_security = current->cred->security;
 	return 0;
 }
 
@@ -916,7 +918,7 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
  */
 static int smack_file_set_fowner(struct file *file)
 {
-	file->f_security = current->security;
+	file->f_security = current->cred->security;
 	return 0;
 }
 
@@ -941,7 +943,7 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 	 * struct fown_struct is never outside the context of a struct file
 	 */
 	file = container_of(fown, struct file, f_owner);
-	rc = smk_access(file->f_security, tsk->security, MAY_WRITE);
+	rc = smk_access(file->f_security, tsk->cred->security, MAY_WRITE);
 	if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
 		return 0;
 	return rc;
@@ -984,7 +986,7 @@ static int smack_file_receive(struct file *file)
  */
 static int smack_task_alloc_security(struct task_struct *tsk)
 {
-	tsk->security = current->security;
+	tsk->cred->security = current->cred->security;
 
 	return 0;
 }
@@ -999,7 +1001,7 @@ static int smack_task_alloc_security(struct task_struct *tsk)
  */
 static void smack_task_free_security(struct task_struct *task)
 {
-	task->security = NULL;
+	task->cred->security = NULL;
 }
 
 /**
@@ -1011,7 +1013,7 @@ static void smack_task_free_security(struct task_struct *task)
  */
 static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	return smk_curacc(p->cred->security, MAY_WRITE);
 }
 
 /**
@@ -1022,7 +1024,7 @@ static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
  */
 static int smack_task_getpgid(struct task_struct *p)
 {
-	return smk_curacc(p->security, MAY_READ);
+	return smk_curacc(p->cred->security, MAY_READ);
 }
 
 /**
@@ -1033,7 +1035,7 @@ static int smack_task_getpgid(struct task_struct *p)
  */
 static int smack_task_getsid(struct task_struct *p)
 {
-	return smk_curacc(p->security, MAY_READ);
+	return smk_curacc(p->cred->security, MAY_READ);
 }
 
 /**
@@ -1045,7 +1047,7 @@ static int smack_task_getsid(struct task_struct *p)
  */
 static void smack_task_getsecid(struct task_struct *p, u32 *secid)
 {
-	*secid = smack_to_secid(p->security);
+	*secid = smack_to_secid(p->cred->security);
 }
 
 /**
@@ -1061,7 +1063,7 @@ static int smack_task_setnice(struct task_struct *p, int nice)
 
 	rc = cap_task_setnice(p, nice);
 	if (rc == 0)
-		rc = smk_curacc(p->security, MAY_WRITE);
+		rc = smk_curacc(p->cred->security, MAY_WRITE);
 	return rc;
 }
 
@@ -1078,7 +1080,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
 
 	rc = cap_task_setioprio(p, ioprio);
 	if (rc == 0)
-		rc = smk_curacc(p->security, MAY_WRITE);
+		rc = smk_curacc(p->cred->security, MAY_WRITE);
 	return rc;
 }
 
@@ -1090,7 +1092,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
  */
 static int smack_task_getioprio(struct task_struct *p)
 {
-	return smk_curacc(p->security, MAY_READ);
+	return smk_curacc(p->cred->security, MAY_READ);
 }
 
 /**
@@ -1108,7 +1110,7 @@ static int smack_task_setscheduler(struct task_struct *p, int policy,
 
 	rc = cap_task_setscheduler(p, policy, lp);
 	if (rc == 0)
-		rc = smk_curacc(p->security, MAY_WRITE);
+		rc = smk_curacc(p->cred->security, MAY_WRITE);
 	return rc;
 }
 
@@ -1120,7 +1122,7 @@ static int smack_task_setscheduler(struct task_struct *p, int policy,
  */
 static int smack_task_getscheduler(struct task_struct *p)
 {
-	return smk_curacc(p->security, MAY_READ);
+	return smk_curacc(p->cred->security, MAY_READ);
 }
 
 /**
@@ -1131,7 +1133,7 @@ static int smack_task_getscheduler(struct task_struct *p)
  */
 static int smack_task_movememory(struct task_struct *p)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	return smk_curacc(p->cred->security, MAY_WRITE);
 }
 
 /**
@@ -1154,13 +1156,13 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 	 * can write the receiver.
 	 */
 	if (secid == 0)
-		return smk_curacc(p->security, MAY_WRITE);
+		return smk_curacc(p->cred->security, MAY_WRITE);
 	/*
 	 * If the secid isn't 0 we're dealing with some USB IO
 	 * specific behavior. This is not clean. For one thing
 	 * we can't take privilege into account.
 	 */
-	return smk_access(smack_from_secid(secid), p->security, MAY_WRITE);
+	return smk_access(smack_from_secid(secid), p->cred->security, MAY_WRITE);
 }
 
 /**
@@ -1173,7 +1175,7 @@ static int smack_task_wait(struct task_struct *p)
 {
 	int rc;
 
-	rc = smk_access(current->security, p->security, MAY_WRITE);
+	rc = smk_access(current->cred->security, p->cred->security, MAY_WRITE);
 	if (rc == 0)
 		return 0;
 
@@ -1204,7 +1206,7 @@ static int smack_task_wait(struct task_struct *p)
 static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
 {
 	struct inode_smack *isp = inode->i_security;
-	isp->smk_inode = p->security;
+	isp->smk_inode = p->cred->security;
 }
 
 /*
@@ -1223,7 +1225,7 @@ static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
  */
 static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
 {
-	char *csp = current->security;
+	char *csp = current->cred->security;
 	struct socket_smack *ssp;
 
 	ssp = kzalloc(sizeof(struct socket_smack), gfp_flags);
@@ -1448,7 +1450,7 @@ static int smack_flags_to_may(int flags)
  */
 static int smack_msg_msg_alloc_security(struct msg_msg *msg)
 {
-	msg->security = current->security;
+	msg->security = current->cred->security;
 	return 0;
 }
 
@@ -1484,7 +1486,7 @@ static int smack_shm_alloc_security(struct shmid_kernel *shp)
 {
 	struct kern_ipc_perm *isp = &shp->shm_perm;
 
-	isp->security = current->security;
+	isp->security = current->cred->security;
 	return 0;
 }
 
@@ -1593,7 +1595,7 @@ static int smack_sem_alloc_security(struct sem_array *sma)
 {
 	struct kern_ipc_perm *isp = &sma->sem_perm;
 
-	isp->security = current->security;
+	isp->security = current->cred->security;
 	return 0;
 }
 
@@ -1697,7 +1699,7 @@ static int smack_msg_queue_alloc_security(struct msg_queue *msq)
 {
 	struct kern_ipc_perm *kisp = &msq->q_perm;
 
-	kisp->security = current->security;
+	kisp->security = current->cred->security;
 	return 0;
 }
 
@@ -1852,7 +1854,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	struct super_block *sbp;
 	struct superblock_smack *sbsp;
 	struct inode_smack *isp;
-	char *csp = current->security;
+	char *csp = current->cred->security;
 	char *fetched;
 	char *final;
 	struct dentry *dp;
@@ -2009,7 +2011,7 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 	if (strcmp(name, "current") != 0)
 		return -EINVAL;
 
-	cp = kstrdup(p->security, GFP_KERNEL);
+	cp = kstrdup(p->cred->security, GFP_KERNEL);
 	if (cp == NULL)
 		return -ENOMEM;
 
@@ -2055,7 +2057,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (newsmack == NULL)
 		return -EINVAL;
 
-	p->security = newsmack;
+	p->cred->security = newsmack;
 	return size;
 }
 
@@ -2285,8 +2287,8 @@ static void smack_sock_graft(struct sock *sk, struct socket *parent)
 		return;
 
 	ssp = sk->sk_security;
-	ssp->smk_in = current->security;
-	ssp->smk_out = current->security;
+	ssp->smk_in = current->cred->security;
+	ssp->smk_out = current->cred->security;
 	ssp->smk_packet[0] = '\0';
 
 	rc = smack_netlabel(sk);
@@ -2359,7 +2361,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 static int smack_key_alloc(struct key *key, struct task_struct *tsk,
 			   unsigned long flags)
 {
-	key->security = tsk->security;
+	key->security = tsk->cred->security;
 	return 0;
 }
 
@@ -2400,10 +2402,11 @@ static int smack_key_permission(key_ref_t key_ref,
 	/*
 	 * This should not occur
 	 */
-	if (context->security == NULL)
+	if (context->cred->security == NULL)
 		return -EACCES;
 
-	return smk_access(context->security, keyp->security, MAY_READWRITE);
+	return smk_access(context->cred->security, keyp->security,
+			  MAY_READWRITE);
 }
 #endif /* CONFIG_KEYS */
 
@@ -2723,7 +2726,7 @@ static __init int smack_init(void)
 	/*
 	 * Set the security state for the initial task.
 	 */
-	current->security = &smack_known_floor.smk_known;
+	current->cred->security = &smack_known_floor.smk_known;
 
 	/*
 	 * Initialize locks
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index e7c6424..7f84906 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -336,7 +336,7 @@ static void smk_cipso_doi(void)
 
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
-	audit_info.secid = smack_to_secid(current->security);
+	audit_info.secid = smack_to_secid(current->cred->security);
 
 	rc = netlbl_cfg_map_del(NULL, &audit_info);
 	if (rc != 0)
@@ -369,7 +369,7 @@ static void smk_unlbl_ambient(char *oldambient)
 
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
-	audit_info.secid = smack_to_secid(current->security);
+	audit_info.secid = smack_to_secid(current->cred->security);
 
 	if (oldambient != NULL) {
 		rc = netlbl_cfg_map_del(oldambient, &audit_info);
@@ -841,7 +841,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
 	char in[SMK_LABELLEN];
-	char *sp = current->security;
+	char *sp = current->cred->security;
 
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;


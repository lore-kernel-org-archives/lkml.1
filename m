Return-Path: <linux-kernel-owner+w=401wt.eu-S1763416AbXIUTu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763416AbXIUTu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762575AbXIUTti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:49:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762995AbXIUTtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:49:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/22] CRED: Move the effective capabilities into the cred
	struct
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 21 Sep 2007 15:47:19 +0100
Message-ID: <20070921144719.8323.38937.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
References: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the effective capabilities mask from the task struct into the credentials
record.

Note that the effective capabilities mask in the cred struct shadows that in
the task_struct because a thread can have its capabilities masks changed by
another thread.  The shadowing is performed by update_current_cred() which is
invoked on entry to any system call that might need it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/buffer.c               |    3 +++
 fs/ioprio.c               |    3 +++
 fs/open.c                 |   27 +++++++++------------------
 fs/proc/array.c           |    2 +-
 fs/readdir.c              |    3 +++
 include/linux/cred.h      |    2 ++
 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |    2 +-
 ipc/msg.c                 |    3 +++
 ipc/sem.c                 |    3 +++
 ipc/shm.c                 |    3 +++
 kernel/acct.c             |    3 +++
 kernel/capability.c       |    3 +++
 kernel/compat.c           |    3 +++
 kernel/cred.c             |   36 +++++++++++++++++++++++++++++-------
 kernel/exit.c             |    2 ++
 kernel/fork.c             |    6 +++++-
 kernel/futex.c            |    3 +++
 kernel/futex_compat.c     |    3 +++
 kernel/kexec.c            |    3 +++
 kernel/module.c           |    6 ++++++
 kernel/ptrace.c           |    3 +++
 kernel/sched.c            |    9 +++++++++
 kernel/signal.c           |    6 ++++++
 kernel/sys.c              |   39 +++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c           |    3 +++
 kernel/time.c             |    9 +++++++++
 kernel/uid16.c            |    3 +++
 mm/mempolicy.c            |    6 ++++++
 mm/migrate.c              |    3 +++
 mm/mlock.c                |    4 ++++
 mm/mmap.c                 |    3 +++
 mm/mremap.c               |    3 +++
 mm/oom_kill.c             |    9 +++++++--
 mm/swapfile.c             |    6 ++++++
 net/compat.c              |    6 ++++++
 net/socket.c              |   45 +++++++++++++++++++++++++++++++++++++++++++++
 security/dummy.c          |   22 ++++++++++++++++++----
 38 files changed, 265 insertions(+), 35 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 0e5ec37..9aabf79 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2909,6 +2909,9 @@ asmlinkage long sys_bdflush(int func, long data)
 {
 	static int msg_count;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
diff --git a/fs/ioprio.c b/fs/ioprio.c
index 10d2c21..d32b7b7 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -63,6 +63,9 @@ asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 	struct pid *pgrp;
 	int ret;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	switch (class) {
 		case IOPRIO_CLASS_RT:
 			if (!capable(CAP_SYS_ADMIN))
diff --git a/fs/open.c b/fs/open.c
index 0c05863..f765ec5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -450,7 +450,7 @@ out:
 asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 {
 	struct nameidata nd;
-	kernel_cap_t old_cap;
+	kernel_cap_t old_cap, want_cap = CAP_EMPTY_SET;
 	struct cred *cred;
 	int res;
 
@@ -461,33 +461,26 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	if (res < 0)
 		return res;
 
-	old_cap = current->cap_effective;
+	/* Clear the capabilities if we switch to a non-root user */
+	if (!current->uid)
+		want_cap = current->cap_permitted;
+
+	old_cap = current->cred->cap_effective;
 
 	if (current->cred->uid != current->uid ||
-	    current->cred->gid != current->gid) {
+	    current->cred->gid != current->gid ||
+	    current->cred->cap_effective != want_cap) {
 		cred = dup_cred(current->cred);
 		if (!cred)
 			return -ENOMEM;
 
 		change_fsuid(cred, current->uid);
 		change_fsgid(cred, current->gid);
+		change_cap(cred, want_cap);
 	} else {
 		cred = get_current_cred();
 	}
 
-	/*
-	 * Clear the capabilities if we switch to a non-root user
-	 *
-	 * FIXME: There is a race here against sys_capset.  The
-	 * capabilities can change yet we will restore the old
-	 * value below.  We should hold task_capabilities_lock,
-	 * but we cannot because user_path_walk can sleep.
-	 */
-	if (current->uid)
-		cap_clear(current->cap_effective);
-	else
-		current->cap_effective = current->cap_permitted;
-
 	cred = __set_current_cred(cred);
 	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
 	if (res)
@@ -506,8 +499,6 @@ out_path_release:
 	path_release(&nd);
 out:
 	set_current_cred(cred);
-	current->cap_effective = old_cap;
-
 	return res;
 }
 
diff --git a/fs/proc/array.c b/fs/proc/array.c
index dc2f83a..1a406c7 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -286,7 +286,7 @@ static inline char *task_cap(struct task_struct *p, char *buffer)
 			    "CapEff:\t%016x\n",
 			    cap_t(p->cap_inheritable),
 			    cap_t(p->cap_permitted),
-			    cap_t(p->cap_effective));
+			    cap_t(p->_cap_effective));
 }
 
 static inline char *task_context_switch_counts(struct task_struct *p,
diff --git a/fs/readdir.c b/fs/readdir.c
index 57e6aa9..33c69ac 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -103,6 +103,9 @@ asmlinkage long old_readdir(unsigned int fd, struct old_linux_dirent __user * di
 	struct file * file;
 	struct readdir_callback buf;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	error = -EBADF;
 	file = fget(fd);
 	if (!file)
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 98d5279..f2df1c3 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -24,6 +24,7 @@ struct cred {
 	atomic_t		usage;
 	uid_t			uid;		/* fsuid as was */
 	gid_t			gid;		/* fsgid as was */
+	kernel_cap_t		cap_effective;
 	struct rcu_head		exterminate;	/* cred destroyer */
 	struct group_info	*group_info;
 	void			*security;
@@ -46,6 +47,7 @@ extern void put_cred(struct cred *);
 extern void change_fsuid(struct cred *, uid_t);
 extern void change_fsgid(struct cred *, gid_t);
 extern void change_groups(struct cred *, struct group_info *);
+extern void change_cap(struct cred *, kernel_cap_t);
 extern struct cred *dup_cred(const struct cred *);
 
 /**
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 5cb7931..56d4be3 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -141,7 +141,7 @@ extern struct nsproxy init_nsproxy;
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
 	.cred		= &init_cred,					\
-	.cap_effective	= CAP_INIT_EFF_SET,				\
+	._cap_effective	= CAP_INIT_EFF_SET,				\
 	.cap_inheritable = CAP_INIT_INH_SET,				\
 	.cap_permitted	= CAP_FULL_SET,					\
 	.keep_capabilities = 0,						\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ca0d553..52f2b64 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1037,7 +1037,7 @@ struct task_struct {
 	struct cred *cred;
 	uid_t uid,euid,suid;
 	gid_t gid,egid,sgid;
-	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted;
+	kernel_cap_t _cap_effective, cap_inheritable, cap_permitted;
 	unsigned keep_capabilities:1;
 	struct user_struct *user;
 #ifdef CONFIG_KEYS
diff --git a/ipc/msg.c b/ipc/msg.c
index a03fcb5..a351c89 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -393,6 +393,9 @@ asmlinkage long sys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
 	if (msqid < 0 || cmd < 0)
 		return -EINVAL;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	version = ipc_parse_version(&cmd);
 	ns = current->nsproxy->ipc_ns;
 
diff --git a/ipc/sem.c b/ipc/sem.c
index b676fef..9691b40 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -927,6 +927,9 @@ asmlinkage long sys_semctl (int semid, int semnum, int cmd, union semun arg)
 	if (semid < 0)
 		return -EINVAL;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	version = ipc_parse_version(&cmd);
 	ns = current->nsproxy->ipc_ns;
 
diff --git a/ipc/shm.c b/ipc/shm.c
index a86a3a5..709a4fe 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -589,6 +589,9 @@ asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 		goto out;
 	}
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	version = ipc_parse_version(&cmd);
 	ns = current->nsproxy->ipc_ns;
 
diff --git a/kernel/acct.c b/kernel/acct.c
index 24f0f8b..01961a5 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -253,6 +253,9 @@ asmlinkage long sys_acct(const char __user *name)
 {
 	int error;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!capable(CAP_SYS_PACCT))
 		return -EPERM;
 
diff --git a/kernel/capability.c b/kernel/capability.c
index c8d3c77..3ae73f9 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -178,6 +178,9 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
      int ret;
      pid_t pid;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
      if (get_user(version, &header->version))
 	     return -EFAULT; 
 
diff --git a/kernel/compat.c b/kernel/compat.c
index 3bae374..04be932 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -909,6 +909,9 @@ asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp)
 	struct timex txc;
 	int ret;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	memset(&txc, 0, sizeof(struct timex));
 
 	if (!access_ok(VERIFY_READ, utp, sizeof(struct compat_timex)) ||
diff --git a/kernel/cred.c b/kernel/cred.c
index 5b827cb..c391f66 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -21,16 +21,19 @@
  */
 struct cred init_cred = {
 	.usage		= ATOMIC_INIT(2),
+	.cap_effective	= CAP_INIT_EFF_SET,
 	.group_info	= &init_groups,
 };
 
 /**
  * update_current_cred - Bring the current task's creds up to date
  *
- * Bring the current task's credentials up to date with respect to the keyrings
- * they shadow.  The process and session level keyrings may get changed by
- * sibling threads with the same process, but the change can't be applied back
- * to this thread's cred struct except by this thread itself.
+ * Bring the current task's credential record up to date with respect to the
+ * effective capability mask and keyrings it shadows.  The capabilities mask
+ * may get changed by other processes, and process and session level keyrings
+ * may get changed by sibling threads with the same process, but the change
+ * can't be applied back to this thread's cred struct except by this thread
+ * itself.
  */
 int update_current_cred(void)
 {
@@ -44,16 +47,21 @@ int update_current_cred(void)
 		key_ref_to_ptr(cred->process_keyring) == sig->process_keyring &&
 		key_ref_to_ptr(cred->thread_keyring) == current->thread_keyring &&
 #endif
-		true)
+		cred->cap_effective != current->_cap_effective)
 		return 0;
 
-	cred = kmalloc(sizeof(struct cred), GFP_KERNEL);
+	cred = kmemdup(current->cred, sizeof(struct cred), GFP_KERNEL);
 	if (!cred)
 		return -ENOMEM;
 
-	*cred = *current->cred;
+	if (security_cred_dup(cred) < 0) {
+		kfree(cred);
+		return -ENOMEM;
+	}
+
 	atomic_set(&cred->usage, 1);
 	get_group_info(cred->group_info);
+	cred->cap_effective = current->_cap_effective;
 
 #ifdef CONFIG_KEYS
 	rcu_read_lock();
@@ -184,3 +192,17 @@ void change_groups(struct cred *cred, struct group_info *group_info)
 }
 
 EXPORT_SYMBOL(change_groups);
+
+/**
+ * change_cap - Change the supplementary groups in a new credential record
+ * @cred: The credential record to alter
+ * @cap: The capabilities to set
+ *
+ * Change the effective capabilities in a new credential record.
+ */
+void change_cap(struct cred *cred, kernel_cap_t cap)
+{
+	cred->cap_effective = cap;
+}
+
+EXPORT_SYMBOL(change_cap);
diff --git a/kernel/exit.c b/kernel/exit.c
index c366ae7..a9916e5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -888,6 +888,8 @@ fastcall NORET_TYPE void do_exit(long code)
 	struct task_struct *tsk = current;
 	int group_dead;
 
+	update_current_cred();
+
 	profile_task_exit(tsk);
 
 	WARN_ON(atomic_read(&tsk->fs_excl));
diff --git a/kernel/fork.c b/kernel/fork.c
index 677c353..e2948ed 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1422,9 +1422,13 @@ long do_fork(unsigned long clone_flags,
 {
 	struct task_struct *p;
 	int trace = 0;
-	struct pid *pid = alloc_pid();
+	struct pid *pid;
 	long nr;
 
+	if (update_current_cred())
+		return -ENOMEM;
+
+	pid = alloc_pid();
 	if (!pid)
 		return -EAGAIN;
 	nr = pid->nr;
diff --git a/kernel/futex.c b/kernel/futex.c
index e8935b1..40070fe 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1846,6 +1846,9 @@ sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
 	struct robust_list_head __user *head;
 	unsigned long ret;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!pid)
 		head = current->robust_list;
 	else {
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 7e52eb0..a872029 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -109,6 +109,9 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 	struct compat_robust_list_head __user *head;
 	unsigned long ret;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!pid)
 		head = current->compat_robust_list;
 	else {
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 25db14b..e1feb2f 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -921,6 +921,9 @@ asmlinkage long sys_kexec_load(unsigned long entry, unsigned long nr_segments,
 	int locked;
 	int result;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	/* We only trust the superuser with rebooting the system. */
 	if (!capable(CAP_SYS_BOOT))
 		return -EPERM;
diff --git a/kernel/module.c b/kernel/module.c
index db0ead0..32893a5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -660,6 +660,9 @@ sys_delete_module(const char __user *name_user, unsigned int flags)
 	char name[MODULE_NAME_LEN];
 	int ret, forced = 0;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!capable(CAP_SYS_MODULE))
 		return -EPERM;
 
@@ -1978,6 +1981,9 @@ sys_init_module(void __user *umod,
 	struct module *mod;
 	int ret = 0;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	/* Must have permission */
 	if (!capable(CAP_SYS_MODULE))
 		return -EPERM;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 3eca7a5..15fb1ff 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -456,6 +456,9 @@ asmlinkage long sys_ptrace(long request, long pid, long addr, long data)
 	struct task_struct *child;
 	long ret;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	/*
 	 * This lock_kernel fixes a subtle race with suid exec
 	 */
diff --git a/kernel/sched.c b/kernel/sched.c
index 6107a0c..602f526 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4063,6 +4063,9 @@ asmlinkage long sys_nice(int increment)
 {
 	long nice, retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	/*
 	 * Setpriority might change our priority at the same moment.
 	 * We don't have to worry. Conceptually one call occurs first
@@ -4295,6 +4298,9 @@ do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
 	struct task_struct *p;
 	int retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!param || pid < 0)
 		return -EINVAL;
 	if (copy_from_user(&lparam, param, sizeof(struct sched_param)))
@@ -4468,6 +4474,9 @@ asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 	cpumask_t new_mask;
 	int retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	retval = get_user_cpu_mask(user_mask_ptr, len, &new_mask);
 	if (retval)
 		return retval;
diff --git a/kernel/signal.c b/kernel/signal.c
index 9fb91a3..0a3358f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2197,6 +2197,9 @@ sys_kill(int pid, int sig)
 {
 	struct siginfo info;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	info.si_signo = sig;
 	info.si_errno = 0;
 	info.si_code = SI_USER;
@@ -2212,6 +2215,9 @@ static int do_tkill(int tgid, int pid, int sig)
 	struct siginfo info;
 	struct task_struct *p;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	error = -ESRCH;
 	info.si_signo = sig;
 	info.si_errno = 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index 9bb591f..ff34679 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -670,6 +670,9 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
 	int error = -EINVAL;
 	struct pid *pgrp;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (which > PRIO_USER || which < PRIO_PROCESS)
 		goto out;
 
@@ -896,6 +899,9 @@ asmlinkage long sys_reboot(int magic1, int magic2, unsigned int cmd, void __user
 {
 	char buffer[256];
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	/* We only trust the superuser with rebooting the system. */
 	if (!capable(CAP_SYS_BOOT))
 		return -EPERM;
@@ -1019,6 +1025,9 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 	int new_egid = old_egid;
 	int retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	retval = security_task_setgid(rgid, egid, (gid_t)-1, LSM_SETID_RE);
 	if (retval)
 		return retval;
@@ -1072,6 +1081,9 @@ asmlinkage long sys_setgid(gid_t gid)
 	int old_egid = current->egid;
 	int retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	retval = security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_ID);
 	if (retval)
 		return retval;
@@ -1150,6 +1162,9 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 	int old_ruid, old_euid, old_suid, new_ruid, new_euid;
 	int retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	retval = security_task_setuid(ruid, euid, (uid_t)-1, LSM_SETID_RE);
 	if (retval)
 		return retval;
@@ -1221,6 +1236,9 @@ asmlinkage long sys_setuid(uid_t uid)
 	int old_ruid, old_suid, new_suid;
 	int retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	retval = security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_ID);
 	if (retval)
 		return retval;
@@ -1271,6 +1289,9 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	int old_suid = current->suid;
 	int retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	retval = security_task_setuid(ruid, euid, suid, LSM_SETID_RES);
 	if (retval)
 		return retval;
@@ -1333,6 +1354,9 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 	struct cred *cred;
 	int retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	retval = security_task_setgid(rgid, egid, sgid, LSM_SETID_RES);
 	if (retval)
 		return retval;
@@ -1876,6 +1900,9 @@ asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist)
 	struct group_info *group_info;
 	int retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!capable(CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
@@ -1941,6 +1968,9 @@ asmlinkage long sys_sethostname(char __user *name, int len)
 	int errno;
 	char tmp[__NEW_UTS_LEN];
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (len < 0 || len > __NEW_UTS_LEN)
@@ -1986,6 +2016,9 @@ asmlinkage long sys_setdomainname(char __user *name, int len)
 	int errno;
 	char tmp[__NEW_UTS_LEN];
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (len < 0 || len > __NEW_UTS_LEN)
@@ -2045,6 +2078,9 @@ asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
 	unsigned long it_prof_secs;
 	int retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
 	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
@@ -2226,6 +2262,9 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 {
 	long error;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
 	if (error)
 		return error;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 53a456e..9447293 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1347,6 +1347,9 @@ asmlinkage long sys_sysctl(struct __sysctl_args __user *args)
 	struct __sysctl_args tmp;
 	int error;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
 		return -EFAULT;
 
diff --git a/kernel/time.c b/kernel/time.c
index 2289a8d..975f47d 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -82,6 +82,9 @@ asmlinkage long sys_stime(time_t __user *tptr)
 	struct timespec tv;
 	int err;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (get_user(tv.tv_sec, tptr))
 		return -EFAULT;
 
@@ -186,6 +189,9 @@ asmlinkage long sys_settimeofday(struct timeval __user *tv,
 	struct timespec	new_ts;
 	struct timezone new_tz;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (tv) {
 		if (copy_from_user(&user_tv, tv, sizeof(*tv)))
 			return -EFAULT;
@@ -205,6 +211,9 @@ asmlinkage long sys_adjtimex(struct timex __user *txc_p)
 	struct timex txc;		/* Local copy of parameter */
 	int ret;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	/* Copy the user data space into the kernel copy
 	 * structure. But bear in mind that the structures
 	 * may change
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 5a8b95e..5238a96 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -187,6 +187,9 @@ asmlinkage long sys_setgroups16(int gidsetsize, old_gid_t __user *grouplist)
 	struct group_info *group_info;
 	int retval;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!capable(CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3d6ac95..64cfcf2 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -878,6 +878,9 @@ asmlinkage long sys_mbind(unsigned long start, unsigned long len,
 	nodemask_t nodes;
 	int err;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
@@ -914,6 +917,9 @@ asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
 	nodemask_t task_nodes;
 	int err;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	err = get_nodes(&old, old_nodes, maxnode);
 	if (err)
 		return err;
diff --git a/mm/migrate.c b/mm/migrate.c
index e2fdbce..79a1909 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -915,6 +915,9 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
 	struct mm_struct *mm;
 	struct page_to_node *pm = NULL;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	/* Check flags */
 	if (flags & ~(MPOL_MF_MOVE|MPOL_MF_MOVE_ALL))
 		return -EINVAL;
diff --git a/mm/mlock.c b/mm/mlock.c
index 7b26560..67985f4 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -138,6 +138,8 @@ asmlinkage long sys_mlock(unsigned long start, size_t len)
 	unsigned long lock_limit;
 	int error = -ENOMEM;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
 	if (!can_do_mlock())
 		return -EPERM;
 
@@ -203,6 +205,8 @@ asmlinkage long sys_mlockall(int flags)
 	if (!flags || (flags & ~(MCL_CURRENT | MCL_FUTURE)))
 		goto out;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
 	ret = -EPERM;
 	if (!can_do_mlock())
 		goto out;
diff --git a/mm/mmap.c b/mm/mmap.c
index 0d40e66..1b7b0ff 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -240,6 +240,9 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
 	unsigned long newbrk, oldbrk;
 	struct mm_struct *mm = current->mm;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	down_write(&mm->mmap_sem);
 
 	if (brk < mm->end_code)
diff --git a/mm/mremap.c b/mm/mremap.c
index 8ea5c24..0d49048 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -418,6 +418,9 @@ asmlinkage unsigned long sys_mremap(unsigned long addr,
 {
 	unsigned long ret;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	down_write(&current->mm->mmap_sem);
 	ret = do_mremap(addr, old_len, new_len, flags, new_addr);
 	up_write(&current->mm->mmap_sem);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index f9b82ad..df5edda 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -53,6 +53,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	unsigned long points, cpu_time, run_time, s;
 	struct mm_struct *mm;
 	struct task_struct *child;
+	kernel_cap_t cap_effective;
 
 	task_lock(p);
 	mm = p->mm;
@@ -123,7 +124,11 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * Superuser processes are usually more important, so we make it
 	 * less likely that we kill those.
 	 */
-	if (cap_t(p->cap_effective) & CAP_TO_MASK(CAP_SYS_ADMIN) ||
+	rcu_read_lock();
+	cap_effective = task_cred(p)->cap_effective;
+	rcu_read_unlock();
+
+	if (cap_t(cap_effective) & CAP_TO_MASK(CAP_SYS_ADMIN) ||
 				p->uid == 0 || p->euid == 0)
 		points /= 4;
 
@@ -133,7 +138,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * tend to only have this flag set on applications they think
 	 * of as important.
 	 */
-	if (cap_t(p->cap_effective) & CAP_TO_MASK(CAP_SYS_RAWIO))
+	if (cap_t(cap_effective) & CAP_TO_MASK(CAP_SYS_RAWIO))
 		points /= 4;
 
 	/*
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f071648..9539da4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1183,6 +1183,9 @@ asmlinkage long sys_swapoff(const char __user * specialfile)
 	int i, type, prev;
 	int err;
 	
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -1433,6 +1436,9 @@ asmlinkage long sys_swapon(const char __user * specialfile, int swap_flags)
 	struct inode *inode = NULL;
 	int did_down = 0;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	spin_lock(&swap_lock);
diff --git a/net/compat.c b/net/compat.c
index d74d821..c20f404 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -483,6 +483,9 @@ asmlinkage long compat_sys_setsockopt(int fd, int level, int optname,
 	int err;
 	struct socket *sock;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (level == SOL_IPV6 && optname == IPT_SO_SET_REPLACE)
 		return do_netfilter_replace(fd, level, optname,
 					    optval, optlen);
@@ -603,6 +606,9 @@ asmlinkage long compat_sys_getsockopt(int fd, int level, int optname,
 	int err;
 	struct socket *sock;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if ((sock = sockfd_lookup(fd, &err))!=NULL)
 	{
 		err = security_socket_getsockopt(sock, level,
diff --git a/net/socket.c b/net/socket.c
index 50bfeef..034d221 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1200,6 +1200,9 @@ asmlinkage long sys_socket(int family, int type, int protocol)
 	int retval;
 	struct socket *sock;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	retval = sock_create(family, type, protocol, &sock);
 	if (retval < 0)
 		goto out;
@@ -1228,6 +1231,9 @@ asmlinkage long sys_socketpair(int family, int type, int protocol,
 	int fd1, fd2, err;
 	struct file *newfile1, *newfile2;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	/*
 	 * Obtain the first socket and check if the underlying protocol
 	 * supports the socketpair call.
@@ -1323,6 +1329,9 @@ asmlinkage long sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen)
 	char address[MAX_SOCK_ADDR];
 	int err, fput_needed;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock) {
 		err = move_addr_to_kernel(umyaddr, addrlen, address);
@@ -1353,6 +1362,9 @@ asmlinkage long sys_listen(int fd, int backlog)
 	struct socket *sock;
 	int err, fput_needed;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock) {
 		if ((unsigned)backlog > sysctl_somaxconn)
@@ -1387,6 +1399,9 @@ asmlinkage long sys_accept(int fd, struct sockaddr __user *upeer_sockaddr,
 	int err, len, newfd, fput_needed;
 	char address[MAX_SOCK_ADDR];
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
@@ -1476,6 +1491,9 @@ asmlinkage long sys_connect(int fd, struct sockaddr __user *uservaddr,
 	char address[MAX_SOCK_ADDR];
 	int err, fput_needed;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
@@ -1508,6 +1526,9 @@ asmlinkage long sys_getsockname(int fd, struct sockaddr __user *usockaddr,
 	char address[MAX_SOCK_ADDR];
 	int len, err, fput_needed;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
@@ -1539,6 +1560,9 @@ asmlinkage long sys_getpeername(int fd, struct sockaddr __user *usockaddr,
 	char address[MAX_SOCK_ADDR];
 	int len, err, fput_needed;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
 		err = security_socket_getpeername(sock);
@@ -1576,6 +1600,9 @@ asmlinkage long sys_sendto(int fd, void __user *buff, size_t len,
 	int fput_needed;
 	struct file *sock_file;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	sock_file = fget_light(fd, &fput_needed);
 	err = -EBADF;
 	if (!sock_file)
@@ -1637,6 +1664,9 @@ asmlinkage long sys_recvfrom(int fd, void __user *ubuf, size_t size,
 	struct file *sock_file;
 	int fput_needed;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	sock_file = fget_light(fd, &fput_needed);
 	err = -EBADF;
 	if (!sock_file)
@@ -1693,6 +1723,9 @@ asmlinkage long sys_setsockopt(int fd, int level, int optname,
 	if (optlen < 0)
 		return -EINVAL;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
 		err = security_socket_setsockopt(sock, level, optname);
@@ -1724,6 +1757,9 @@ asmlinkage long sys_getsockopt(int fd, int level, int optname,
 	int err, fput_needed;
 	struct socket *sock;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
 		err = security_socket_getsockopt(sock, level, optname);
@@ -1753,6 +1789,9 @@ asmlinkage long sys_shutdown(int fd, int how)
 	int err, fput_needed;
 	struct socket *sock;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
 		err = security_socket_shutdown(sock, how);
@@ -1789,6 +1828,9 @@ asmlinkage long sys_sendmsg(int fd, struct msghdr __user *msg, unsigned flags)
 	int err, ctl_len, iov_size, total_len;
 	int fput_needed;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	err = -EFAULT;
 	if (MSG_CMSG_COMPAT & flags) {
 		if (get_compat_msghdr(&msg_sys, msg_compat))
@@ -1896,6 +1938,9 @@ asmlinkage long sys_recvmsg(int fd, struct msghdr __user *msg,
 	struct sockaddr __user *uaddr;
 	int __user *uaddr_len;
 
+	if (update_current_cred() < 0)
+		return -ENOMEM;
+
 	if (MSG_CMSG_COMPAT & flags) {
 		if (get_compat_msghdr(&msg_sys, msg_compat))
 			return -EFAULT;
diff --git a/security/dummy.c b/security/dummy.c
index f535cc6..f403658 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -76,7 +76,13 @@ static int dummy_acct (struct file *file)
 
 static int dummy_capable (struct task_struct *tsk, int cap)
 {
-	if (cap_raised (tsk->cap_effective, cap))
+	kernel_cap_t cap_effective;
+
+	rcu_read_lock();
+	cap_effective = task_cred(tsk)->cap_effective;
+	rcu_read_unlock();
+
+	if (cap_raised (cap_effective, cap))
 		return 0;
 	return -EPERM;
 }
@@ -146,7 +152,12 @@ static void dummy_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 	change_fsuid(bprm->cred, bprm->e_uid);
 	change_fsgid(bprm->cred, bprm->e_gid);
 
-	dummy_capget(current, &current->cap_effective, &current->cap_inheritable, &current->cap_permitted);
+	dummy_capget(current,
+		     &current->_cap_effective,
+		     &current->cap_inheritable,
+		     &current->cap_permitted);
+
+	change_cap(bprm->cred, current->_cap_effective);
 }
 
 static void dummy_bprm_post_apply_creds (struct linux_binprm *bprm)
@@ -499,7 +510,10 @@ static int dummy_task_setuid (uid_t id0, uid_t id1, uid_t id2, int flags)
 
 static int dummy_task_post_setuid (uid_t id0, uid_t id1, uid_t id2, int flags)
 {
-	dummy_capget(current, &current->cap_effective, &current->cap_inheritable, &current->cap_permitted);
+	dummy_capget(current,
+		     &current->_cap_effective,
+		     &current->cap_inheritable,
+		     &current->cap_permitted);
 	return 0;
 }
 
@@ -696,7 +710,7 @@ static int dummy_sem_semop (struct sem_array *sma,
 
 static int dummy_netlink_send (struct sock *sk, struct sk_buff *skb)
 {
-	NETLINK_CB(skb).eff_cap = current->cap_effective;
+	NETLINK_CB(skb).eff_cap = current->cred->cap_effective;
 	return 0;
 }
 


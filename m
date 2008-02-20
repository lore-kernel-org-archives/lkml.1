Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbYBTQT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbYBTQT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765150AbYBTQKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:10:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764297AbYBTQJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:09:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/37] Security: De-embed task security record from task and
	use refcounting
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:06:36 +0000
Message-ID: <20080220160635.4715.81967.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the temporarily embedded task security record from task_struct.  Instead
it is made to dangle from the task_struct::sec and task_struct::act_as pointers
with references counted for each.

do_coredump() is made to create a copy of the security record, modify it and
then use that to override the main one for a task.  sys_faccessat() is made to
do the same.

The process and session keyrings are moved from signal_struct into a new
thread_group_security struct.  This is then refcounted, with pointers coming
from the task_security struct instead of from signal_struct.

The keyring functions then take pointers to task_security structs rather than
task_structs for their security contexts.  This is so that request_key() can
proceed asynchronously without having to worry about the initiator task's
act_as pointer changing.

The LSM hooks for dealing with task security are modified to deal with the task
security struct directly rather than going via the task_struct as appopriate.

This permits the subjective security context of a task to be overridden by
changing its act_as pointer without altering its objective security pointer,
and thus not breaking signalling, ptrace, etc. whilst the override is in force.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/exec.c                         |   15 +-
 fs/open.c                         |   37 ++---
 include/linux/init_task.h         |   18 --
 include/linux/key-ui.h            |   10 +
 include/linux/key.h               |   31 +---
 include/linux/sched.h             |   40 ++++-
 include/linux/security.h          |   43 ++++-
 kernel/Makefile                   |    2 
 kernel/cred.c                     |  140 ++++++++++++++++++
 kernel/exit.c                     |    1 
 kernel/fork.c                     |   40 ++---
 kernel/kmod.c                     |   10 +
 kernel/sys.c                      |   16 +-
 kernel/user.c                     |    2 
 net/rxrpc/ar-key.c                |    4 -
 security/dummy.c                  |   14 +-
 security/keys/internal.h          |   10 +
 security/keys/key.c               |    6 -
 security/keys/keyctl.c            |    6 -
 security/keys/keyring.c           |   14 +-
 security/keys/permission.c        |    5 -
 security/keys/proc.c              |    2 
 security/keys/process_keys.c      |  290 +++++++++++++++++--------------------
 security/keys/request_key.c       |   59 ++++----
 security/keys/request_key_auth.c  |   38 ++---
 security/security.c               |   20 ++-
 security/selinux/hooks.c          |   40 ++++-
 security/selinux/include/objsec.h |    1 
 security/smack/smack_lsm.c        |   32 +++-
 29 files changed, 543 insertions(+), 403 deletions(-)
 create mode 100644 kernel/cred.c


diff --git a/fs/exec.c b/fs/exec.c
index 3463f81..5fc0586 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1653,13 +1653,13 @@ int get_dumpable(struct mm_struct *mm)
 
 int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 {
+	struct task_security *sec, *old_act_as;
 	char corename[CORENAME_MAX_SIZE + 1];
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
 	struct inode * inode;
 	struct file * file;
 	int retval = 0;
-	int fsuid = current_fsuid();
 	int flag = 0;
 	int ispipe = 0;
 	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
@@ -1671,7 +1671,10 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 
 	binfmt = current->binfmt;
 	if (!binfmt || !binfmt->core_dump)
-		goto fail;
+		goto fail_nosubj;
+	sec = dup_task_security(current->sec);
+	if (!sec)
+		goto fail_nosubj;
 	down_write(&mm->mmap_sem);
 	/*
 	 * If another thread got here first, or we are not dumpable, bail out.
@@ -1686,9 +1689,11 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 *	process nor do we know its entire history. We only know it
 	 *	was tainted so we dump it as root in mode 2.
 	 */
+	old_act_as = current->act_as;
 	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
-		current->act_as->fsuid = 0;	/* Dump root private */
+		sec->fsuid = 0;		/* Dump root private */
+		current->act_as = sec;
 	}
 
 	retval = coredump_wait(exit_code);
@@ -1784,8 +1789,10 @@ fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
 
-	current->act_as->fsuid = fsuid;
+	current->act_as = old_act_as;
 	complete_all(&mm->core_done);
 fail:
+	put_task_security(sec);
+fail_nosubj:
 	return retval;
 }
diff --git a/fs/open.c b/fs/open.c
index 2f93f85..3f5aec4 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -420,34 +420,27 @@ out:
  */
 asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 {
+	struct task_security *sec, *old_act_as;
 	struct nameidata nd;
-	int old_fsuid, old_fsgid;
-	kernel_cap_t old_cap;
 	int res;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
 
-	old_fsuid = current->act_as->fsuid;
-	old_fsgid = current->act_as->fsgid;
-	old_cap = current->act_as->cap_effective;
+	sec = dup_task_security(current->sec);
+	if (!sec)
+		return -ENOMEM;
+	sec->fsuid = current->sec->uid;
+	sec->fsgid = current->sec->gid;
 
-	current->act_as->fsuid = current->act_as->uid;
-	current->act_as->fsgid = current->act_as->gid;
-
-	/*
-	 * Clear the capabilities if we switch to a non-root user
-	 *
-	 * FIXME: There is a race here against sys_capset.  The
-	 * capabilities can change yet we will restore the old
-	 * value below.  We should hold task_capabilities_lock,
-	 * but we cannot because user_path_walk can sleep.
-	 */
-	if (current->act_as->uid)
-		cap_clear(current->act_as->cap_effective);
+	/* Clear the capabilities if we switch to a non-root user */
+	if (current->sec->uid)
+		cap_clear(sec->cap_effective);
 	else
-		current->act_as->cap_effective = current->act_as->cap_permitted;
+		sec->cap_effective = current->sec->cap_permitted;
 
+	old_act_as = current->act_as;
+	current->act_as = sec;
 	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
 	if (res)
 		goto out;
@@ -464,10 +457,8 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 out_path_release:
 	path_put(&nd.path);
 out:
-	current->act_as->fsuid = old_fsuid;
-	current->act_as->fsgid = old_fsgid;
-	current->act_as->cap_effective = old_cap;
-
+	current->act_as = old_act_as;
+	put_task_security(sec);
 	return res;
 }
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index a26c30e..25bda17 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -135,19 +135,6 @@ extern struct group_info init_groups;
 
 extern struct task_security init_task_security;
 
-#define INIT_TASK_SECURITY(p)					\
-{								\
-	.usage			= ATOMIC_INIT(3),		\
-	.keep_capabilities	= 0,				\
-	.cap_inheritable	= CAP_INIT_INH_SET,		\
-	.cap_permitted		= CAP_FULL_SET,			\
-	.cap_effective		= CAP_INIT_EFF_SET,		\
-	.cap_bset		= CAP_INIT_BSET,		\
-	.user			= INIT_USER,			\
-	.group_info		= &init_groups,			\
-	.lock			= __SPIN_LOCK_UNLOCKED(p.lock),	\
-}
-
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -179,9 +166,8 @@ extern struct task_security init_task_security;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	.__temp_sec	= INIT_TASK_SECURITY(tsk.__temp_sec),		\
-	.sec		= &tsk.__temp_sec,				\
-	.act_as		= &tsk.__temp_sec,				\
+	.sec		= &init_task_security,				\
+	.act_as		= &init_task_security,				\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
diff --git a/include/linux/key-ui.h b/include/linux/key-ui.h
index e8b8a7a..f15ea9d 100644
--- a/include/linux/key-ui.h
+++ b/include/linux/key-ui.h
@@ -43,15 +43,13 @@ struct keyring_list {
  * check to see whether permission is granted to use a key in the desired way
  */
 extern int key_task_permission(const key_ref_t key_ref,
-			       struct task_struct *context,
+			       struct task_security *sec,
 			       key_perm_t perm);
 
-static inline int key_permission(const key_ref_t key_ref, key_perm_t perm)
-{
-	return key_task_permission(key_ref, current, perm);
-}
+#define key_permission(key_ref, perm) \
+	key_task_permission((key_ref), current->act_as, (perm))
 
-extern key_ref_t lookup_user_key(struct task_struct *context,
+extern key_ref_t lookup_user_key(struct task_security *sec,
 				 key_serial_t id, int create, int partial,
 				 key_perm_t perm);
 
diff --git a/include/linux/key.h b/include/linux/key.h
index 163f864..ce07205 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -70,6 +70,8 @@ struct key;
 struct seq_file;
 struct user_struct;
 struct signal_struct;
+struct task_security;
+struct thread_group_security;
 
 struct key_type;
 struct key_owner;
@@ -178,7 +180,7 @@ struct key {
 extern struct key *key_alloc(struct key_type *type,
 			     const char *desc,
 			     uid_t uid, gid_t gid,
-			     struct task_struct *ctx,
+			     struct task_security *sec,
 			     key_perm_t perm,
 			     unsigned long flags);
 
@@ -245,7 +247,7 @@ extern int key_unlink(struct key *keyring,
 		      struct key *key);
 
 extern struct key *keyring_alloc(const char *description, uid_t uid, gid_t gid,
-				 struct task_struct *ctx,
+				 struct task_security *sec,
 				 unsigned long flags,
 				 struct key *dest);
 
@@ -267,24 +269,16 @@ extern struct key *key_lookup(key_serial_t id);
  */
 extern struct key root_user_keyring, root_session_keyring;
 extern int alloc_uid_keyring(struct user_struct *user,
-			     struct task_struct *ctx);
+			     struct task_security *sec);
 extern void switch_uid_keyring(struct user_struct *new_user);
-extern int copy_keys(unsigned long clone_flags, struct task_struct *tsk);
-extern int copy_thread_group_keys(struct task_struct *tsk);
-extern void exit_keys(struct task_struct *tsk);
-extern void exit_thread_group_keys(struct signal_struct *tg);
+extern int copy_thread_group_keys(struct thread_group_security *tgsec);
 extern int suid_keys(struct task_struct *tsk);
 extern int exec_keys(struct task_struct *tsk);
-extern void key_fsuid_changed(struct task_struct *tsk);
-extern void key_fsgid_changed(struct task_struct *tsk);
+extern void key_fsuid_changed(struct task_security *sec);
+extern void key_fsgid_changed(struct task_security *sec);
 extern void key_init(void);
-
-#define __install_session_keyring(tsk, keyring)			\
-({								\
-	struct key *old_session = tsk->signal->session_keyring;	\
-	tsk->signal->session_keyring = keyring;			\
-	old_session;						\
-})
+extern void __install_session_keyring(struct task_struct *tsk,
+				      struct key *keyring);
 
 #else /* CONFIG_KEYS */
 
@@ -298,11 +292,8 @@ extern void key_init(void);
 #define is_key_possessed(k)		0
 #define alloc_uid_keyring(u,c)		0
 #define switch_uid_keyring(u)		do { } while(0)
-#define __install_session_keyring(t, k)	({ NULL; })
-#define copy_keys(f,t)			0
+#define __install_session_keyring(t, k)	do {} while (0)
 #define copy_thread_group_keys(t)	0
-#define exit_keys(t)			do { } while(0)
-#define exit_thread_group_keys(tg)	do { } while(0)
 #define suid_keys(t)			do { } while(0)
 #define exec_keys(t)			do { } while(0)
 #define key_fsuid_changed(t)		do { } while(0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 546ebec..1fbe740 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -525,12 +525,6 @@ struct signal_struct {
 
 	struct list_head cpu_timers[3];
 
-	/* keep the process-shared keyrings here so that they do the right
-	 * thing in threads created with CLONE_THREAD */
-#ifdef CONFIG_KEYS
-	struct key *session_keyring;	/* keyring inherited over fork */
-	struct key *process_keyring;	/* keyring private to this process */
-#endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct pacct_struct pacct;	/* per-process accounting information */
 #endif
@@ -608,6 +602,20 @@ extern struct user_struct root_user;
 
 
 /*
+ * The common security details for a thread group
+ * - shared by CLONE_THREAD
+ */
+#ifdef CONFIG_KEYS
+struct thread_group_security {
+	atomic_t	usage;
+	pid_t		tgid;			/* thread group process ID */
+	spinlock_t	lock;
+	struct key	*session_keyring;	/* keyring inherited over fork */
+	struct key	*process_keyring;	/* keyring private to this process */
+};
+#endif
+
+/*
  * The security context of a task
  *
  * The parts of the context break down into two categories:
@@ -650,6 +658,7 @@ struct task_security {
 					 * keys to */
 	struct key	*thread_keyring; /* keyring private to this thread */
 	struct key	*request_key_auth; /* assumed request_key authority */
+	struct thread_group_security *tgsec;
 #endif
 #ifdef CONFIG_SECURITY
 	void		*security;	/* subjective LSM security */
@@ -659,10 +668,28 @@ struct task_security {
 	spinlock_t	lock;		/* lock for pointer changes */
 };
 
+extern struct task_security *dup_task_security(struct task_security *);
+extern int copy_task_security(struct task_struct *, unsigned long);
+extern void put_task_security(struct task_security *);
+
 #define current_fsuid() (current->act_as->fsuid)
 #define current_fsgid() (current->act_as->fsgid)
 #define current_cap()	(current->act_as->cap_effective)
 
+/**
+ * get_task_security - Get an extra reference on a task security record
+ * @sec: The security record to get the reference on
+ *
+ * Get an extra reference on a task security record.  The caller must arrange
+ * for this to be released.
+ */
+static inline
+struct task_security *get_task_security(struct task_security *sec)
+{
+	atomic_inc(&sec->usage);
+	return sec;
+}
+
 
 struct backing_dev_info;
 struct reclaim_state;
@@ -1155,7 +1182,6 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	struct task_security __temp_sec __deprecated; /* temporary security to be removed */
 	struct task_security *sec;	/* actual/objective task security */
 	struct task_security *act_as;	/* effective/subjective task security */
 
diff --git a/include/linux/security.h b/include/linux/security.h
index a33fd03..9bf93c7 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -561,8 +561,13 @@ struct request_sock;
  *	allocated.
  *	Return 0 if operation was successful.
  * @task_free_security:
- *	@p contains the task_struct for process.
+ *	@p points to the task_security struct to be freed.
  *	Deallocate and clear the p->security field.
+ * @task_dup_security:
+ *	@p points to the task_security struct to be copied
+ *	Duplicate and attach the security structure currently attached to the
+ *	p->security field.
+ *	Return 0 if operation was successful.
  * @task_setuid:
  *	Check permission before setting one or more of the user identity
  *	attributes of the current process.  The @flags parameter indicates
@@ -955,6 +960,7 @@ struct request_sock;
  *	Permit allocation of a key and assign security data. Note that key does
  *	not have a serial number assigned at this point.
  *	@key points to the key.
+ *	@sec points to the task security record to use.
  *	@flags is the allocation flags
  *	Return 0 if permission is granted, -ve error otherwise.
  * @key_free:
@@ -965,8 +971,8 @@ struct request_sock;
  *	See whether a specific operational right is granted to a process on a
  *      key.
  *	@key_ref refers to the key (key pointer + possession attribute bit).
- *	@context points to the process to provide the context against which to
- *       evaluate the security data on the key.
+ *	@sec points to the process's security recored to provide the context
+ *       against which to evaluate the security data on the key.
  *	@perm describes the combination of permissions required of this key.
  *	Return 1 if permission granted, 0 if permission denied and -ve it the
  *      normal permissions model should be effected.
@@ -1333,8 +1339,9 @@ struct security_operations {
 	int (*dentry_open)  (struct file *file);
 
 	int (*task_create) (unsigned long clone_flags);
-	int (*task_alloc_security) (struct task_struct * p);
-	void (*task_free_security) (struct task_struct * p);
+	int (*task_alloc_security) (struct task_struct *p);
+	void (*task_free_security) (struct task_security *p);
+	int (*task_dup_security) (struct task_security *p);
 	int (*task_setuid) (uid_t id0, uid_t id1, uid_t id2, int flags);
 	int (*task_post_setuid) (uid_t old_ruid /* or fsuid */ ,
 				 uid_t old_euid, uid_t old_suid, int flags);
@@ -1465,10 +1472,11 @@ struct security_operations {
 
 	/* key management security hooks */
 #ifdef CONFIG_KEYS
-	int (*key_alloc)(struct key *key, struct task_struct *tsk, unsigned long flags);
+	int (*key_alloc)(struct key *key, struct task_security *context,
+			 unsigned long flags);
 	void (*key_free)(struct key *key);
 	int (*key_permission)(key_ref_t key_ref,
-			      struct task_struct *context,
+			      struct task_security *context,
 			      key_perm_t perm);
 	int (*key_getsecurity)(struct key *key, char **_buffer);
 #endif	/* CONFIG_KEYS */
@@ -1589,7 +1597,8 @@ int security_file_receive(struct file *file);
 int security_dentry_open(struct file *file);
 int security_task_create(unsigned long clone_flags);
 int security_task_alloc(struct task_struct *p);
-void security_task_free(struct task_struct *p);
+void security_task_free(struct task_security *p);
+int security_task_dup(struct task_security *p);
 int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags);
 int security_task_post_setuid(uid_t old_ruid, uid_t old_euid,
 			       uid_t old_suid, int flags);
@@ -2058,14 +2067,19 @@ static inline int security_task_create (unsigned long clone_flags)
 	return 0;
 }
 
-static inline int security_task_alloc (struct task_struct *p)
+static inline int security_task_alloc(struct task_struct *p)
 {
 	return 0;
 }
 
-static inline void security_task_free (struct task_struct *p)
+static inline void security_task_free(struct task_security *p)
 { }
 
+static inline int security_task_dup(struct task_security *p)
+{
+	return 0;
+}
+
 static inline int security_task_setuid (uid_t id0, uid_t id1, uid_t id2,
 					int flags)
 {
@@ -2607,16 +2621,17 @@ static inline void security_skb_classify_flow(struct sk_buff *skb, struct flowi
 #ifdef CONFIG_KEYS
 #ifdef CONFIG_SECURITY
 
-int security_key_alloc(struct key *key, struct task_struct *tsk, unsigned long flags);
+int security_key_alloc(struct key *key, struct task_security *sec,
+		       unsigned long flags);
 void security_key_free(struct key *key);
 int security_key_permission(key_ref_t key_ref,
-			    struct task_struct *context, key_perm_t perm);
+			    struct task_security *sec, key_perm_t perm);
 int security_key_getsecurity(struct key *key, char **_buffer);
 
 #else
 
 static inline int security_key_alloc(struct key *key,
-				     struct task_struct *tsk,
+				     struct task_security *sec,
 				     unsigned long flags)
 {
 	return 0;
@@ -2627,7 +2642,7 @@ static inline void security_key_free(struct key *key)
 }
 
 static inline int security_key_permission(key_ref_t key_ref,
-					  struct task_struct *context,
+					  struct task_security *sec,
 					  key_perm_t perm)
 {
 	return 0;
diff --git a/kernel/Makefile b/kernel/Makefile
index 6c584c5..79fcbea 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o nsproxy.o srcu.o \
+	    hrtimer.o rwsem.o nsproxy.o srcu.o cred.o \
 	    notifier.o ksysfs.o pm_qos_params.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_check.o
diff --git a/kernel/cred.c b/kernel/cred.c
new file mode 100644
index 0000000..298f26e
--- /dev/null
+++ b/kernel/cred.c
@@ -0,0 +1,140 @@
+/* Tasks security and credentials management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/key.h>
+#include <linux/init_task.h>
+#include <linux/security.h>
+
+#ifdef CONFIG_KEYS
+static struct thread_group_security init_thread_group_security = {
+	.usage	= ATOMIC_INIT(2),
+	.lock	= __SPIN_LOCK_UNLOCKED(init_thread_group_security.lock),
+};
+#endif
+
+struct task_security init_task_security = {
+	.usage			= ATOMIC_INIT(3),
+	.keep_capabilities	= 0,
+	.cap_inheritable	= CAP_INIT_INH_SET,
+	.cap_permitted		= CAP_FULL_SET,
+	.cap_effective		= CAP_INIT_EFF_SET,
+	.cap_bset		= CAP_INIT_BSET,
+	.user			= INIT_USER,
+#ifdef CONFIG_KEYS
+	.tgsec			= &init_thread_group_security,
+#endif
+	.group_info		= &init_groups,
+	.lock			= __SPIN_LOCK_UNLOCKED(init_task_security.lock),
+};
+
+/**
+ * dup_task_security - Duplicate task security record
+ * @sec: The record to duplicate
+ *
+ * Returns a duplicate of a task security record or NULL if out of memory.
+ */
+struct task_security *dup_task_security(struct task_security *_sec)
+{
+	struct task_security *sec;
+
+	sec = kmemdup(_sec, sizeof(*sec), GFP_KERNEL);
+	if (sec) {
+		atomic_set(&sec->usage, 1);
+		get_uid(sec->user);
+		get_group_info(sec->group_info);
+		key_get(sec->thread_keyring);
+		key_get(sec->request_key_auth);
+		security_task_dup(sec);
+	}
+	return sec;
+}
+EXPORT_SYMBOL(dup_task_security);
+
+/**
+ * copy_task_security - Copy the task security records for fork
+ * @p: The new task
+ * @clone_flags: The details of what the new process shares of the old
+ *
+ * Copy the task security records on a task so that it can affect objects
+ * in the same way as its parent.  Returns 0 if successful or -ENOMEM if out of
+ * memory.
+ */
+int copy_task_security(struct task_struct *p, unsigned long clone_flags)
+{
+	struct task_security *sec;
+
+	sec = kmemdup(p->sec, sizeof(*sec), GFP_KERNEL);
+	if (!sec)
+		return -ENOMEM;
+
+	atomic_set(&sec->usage, 2);
+	spin_lock_init(&sec->lock);
+	get_group_info(sec->group_info);
+	get_uid(p->sec->user);
+
+#ifdef CONFIG_KEYS
+	if (clone_flags & CLONE_THREAD) {
+		atomic_inc(&sec->tgsec->usage);
+	} else {
+		struct thread_group_security *tgsec;
+
+		tgsec = kmalloc(sizeof(*tgsec), GFP_KERNEL);
+		if (!tgsec) {
+			kfree(sec);
+			return -ENOMEM;
+		}
+		atomic_set(&tgsec->usage, 1);
+		spin_lock_init(&tgsec->lock);
+		tgsec->tgid = p->tgid;
+		copy_thread_group_keys(tgsec);
+		sec->tgsec = tgsec;
+	}
+	key_get(sec->request_key_auth);
+	sec->thread_keyring = NULL;
+#endif
+
+#ifdef CONFIG_SECURITY
+	sec->security = NULL;
+#endif
+
+	p->act_as = p->sec = sec;
+	return 0;
+}
+EXPORT_SYMBOL(copy_task_security);
+
+/**
+ * put_task_security - Release a ref on a task security record
+ * @sec: The record to release
+ *
+ * Release a reference to a task security record and destroy it when
+ * there are no references remaining.
+ */
+void put_task_security(struct task_security *sec)
+{
+	if (sec && atomic_dec_and_test(&sec->usage)) {
+		security_task_free(sec);
+		key_put(sec->thread_keyring);
+		key_put(sec->request_key_auth);
+		put_group_info(sec->group_info);
+		free_uid(sec->user);
+
+#ifdef CONFIG_KEYS
+		if (atomic_dec_and_test(&sec->tgsec->usage)) {
+			key_put(sec->tgsec->session_keyring);
+			key_put(sec->tgsec->process_keyring);
+		}
+#endif
+
+		kfree(sec);
+	}
+}
+EXPORT_SYMBOL(put_task_security);
diff --git a/kernel/exit.c b/kernel/exit.c
index 121a759..62061f6 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -976,7 +976,6 @@ NORET_TYPE void do_exit(long code)
 	check_stack_usage();
 	exit_thread();
 	cgroup_exit(tsk, 1);
-	exit_keys(tsk);
 
 	if (group_dead && tsk->signal->leader)
 		disassociate_ctty(1);
diff --git a/kernel/fork.c b/kernel/fork.c
index 2125868..5f3e7e0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -123,9 +123,8 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
-	security_task_free(tsk);
-	free_uid(tsk->__temp_sec.user);
-	put_group_info(tsk->__temp_sec.group_info);
+	put_task_security(tsk->sec);
+	put_task_security(tsk->act_as);
 	delayacct_tsk_free(tsk);
 
 	if (!profile_handoff_task(tsk))
@@ -877,7 +876,6 @@ void __cleanup_sighand(struct sighand_struct *sighand)
 static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct signal_struct *sig;
-	int ret;
 
 	if (clone_flags & CLONE_THREAD) {
 		atomic_inc(&current->signal->count);
@@ -889,12 +887,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	if (!sig)
 		return -ENOMEM;
 
-	ret = copy_thread_group_keys(tsk);
-	if (ret < 0) {
-		kmem_cache_free(signal_cachep, sig);
-		return ret;
-	}
-
 	atomic_set(&sig->count, 1);
 	atomic_set(&sig->live, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
@@ -951,7 +943,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 
 void __cleanup_signal(struct signal_struct *sig)
 {
-	exit_thread_group_keys(sig);
 	kmem_cache_free(signal_cachep, sig);
 }
 
@@ -1045,18 +1036,19 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
-	p->act_as = p->sec = &p->__temp_sec;
+	retval = copy_task_security(p, clone_flags);
+	if (retval < 0)
+		goto bad_fork_free;
+
 	retval = -EAGAIN;
 	if (atomic_read(&p->sec->user->processes) >=
 			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
 		    p->sec->user != current->nsproxy->user_ns->root_user)
-			goto bad_fork_free;
+			goto bad_fork_cleanup_put_task_sec;
 	}
 
-	atomic_inc(&p->sec->user->__count);
 	atomic_inc(&p->sec->user->processes);
-	get_group_info(p->sec->group_info);
 
 	/*
 	 * If multiple threads are within copy_process(), then this check
@@ -1120,9 +1112,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	do_posix_clock_monotonic_gettime(&p->start_time);
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
-#ifdef CONFIG_SECURITY
-	p->sec->security = NULL;
-#endif
 	p->io_context = NULL;
 	p->audit_context = NULL;
 	cgroup_fork(p);
@@ -1170,7 +1159,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if ((retval = security_task_alloc(p)))
 		goto bad_fork_cleanup_policy;
 	if ((retval = audit_alloc(p)))
-		goto bad_fork_cleanup_security;
+		goto bad_fork_cleanup_policy;
 	/* copy all the process information */
 	if ((retval = copy_semundo(clone_flags, p)))
 		goto bad_fork_cleanup_audit;
@@ -1184,10 +1173,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_sighand;
 	if ((retval = copy_mm(clone_flags, p)))
 		goto bad_fork_cleanup_signal;
-	if ((retval = copy_keys(clone_flags, p)))
-		goto bad_fork_cleanup_mm;
 	if ((retval = copy_namespaces(clone_flags, p)))
-		goto bad_fork_cleanup_keys;
+		goto bad_fork_cleanup_mm;
 	if ((retval = copy_io(clone_flags, p)))
 		goto bad_fork_cleanup_namespaces;
 	retval = copy_thread(0, clone_flags, stack_start, stack_size, p, regs);
@@ -1364,8 +1351,6 @@ bad_fork_cleanup_io:
 	put_io_context(p->io_context);
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
-bad_fork_cleanup_keys:
-	exit_keys(p);
 bad_fork_cleanup_mm:
 	if (p->mm)
 		mmput(p->mm);
@@ -1381,8 +1366,6 @@ bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_audit:
 	audit_free(p);
-bad_fork_cleanup_security:
-	security_task_free(p);
 bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
 	mpol_free(p->mempolicy);
@@ -1395,9 +1378,10 @@ bad_fork_cleanup_cgroup:
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-	put_group_info(p->sec->group_info);
 	atomic_dec(&p->sec->user->processes);
-	free_uid(p->sec->user);
+bad_fork_cleanup_put_task_sec:
+	put_task_security(p->act_as);
+	put_task_security(p->sec);
 bad_fork_free:
 	free_task(p);
 fork_out:
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 22be3ff..cf91693 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -133,20 +133,18 @@ struct subprocess_info {
 static int ____call_usermodehelper(void *data)
 {
 	struct subprocess_info *sub_info = data;
-	struct key *new_session, *old_session;
 	int retval;
 
-	/* Unblock all signals and set the session keyring. */
-	new_session = key_get(sub_info->ring);
+	/* Set the session keyring. */
+	__install_session_keyring(current, sub_info->ring);
+
+	/* Unblock all signals. */
 	spin_lock_irq(&current->sighand->siglock);
-	old_session = __install_session_keyring(current, new_session);
 	flush_signal_handlers(current, 1);
 	sigemptyset(&current->blocked);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	key_put(old_session);
-
 	/* Install input pipe when needed */
 	if (sub_info->stdin) {
 		struct files_struct *f = current->files;
diff --git a/kernel/sys.c b/kernel/sys.c
index e8383ee..ec0c251 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -521,7 +521,7 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 	sec->fsgid = new_egid;
 	sec->egid = new_egid;
 	sec->gid = new_rgid;
-	key_fsgid_changed(current);
+	key_fsgid_changed(sec);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
 }
@@ -557,7 +557,7 @@ asmlinkage long sys_setgid(gid_t gid)
 	else
 		return -EPERM;
 
-	key_fsgid_changed(current);
+	key_fsgid_changed(sec);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
 }
@@ -646,7 +646,7 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 		sec->suid = sec->euid;
 	sec->fsuid = sec->euid;
 
-	key_fsuid_changed(current);
+	key_fsuid_changed(sec);
 	proc_id_connector(current, PROC_EVENT_UID);
 
 	return security_task_post_setuid(old_ruid, old_euid, old_suid, LSM_SETID_RE);
@@ -694,7 +694,7 @@ asmlinkage long sys_setuid(uid_t uid)
 	sec->fsuid = sec->euid = uid;
 	sec->suid = new_suid;
 
-	key_fsuid_changed(current);
+	key_fsuid_changed(sec);
 	proc_id_connector(current, PROC_EVENT_UID);
 
 	return security_task_post_setuid(old_ruid, old_euid, old_suid, LSM_SETID_ID);
@@ -744,7 +744,7 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	if (suid != (uid_t) -1)
 		sec->suid = suid;
 
-	key_fsuid_changed(current);
+	key_fsuid_changed(sec);
 	proc_id_connector(current, PROC_EVENT_UID);
 
 	return security_task_post_setuid(old_ruid, old_euid, old_suid, LSM_SETID_RES);
@@ -798,7 +798,7 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 	if (sgid != (gid_t) -1)
 		sec->sgid = sgid;
 
-	key_fsgid_changed(current);
+	key_fsgid_changed(sec);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
 }
@@ -841,7 +841,7 @@ asmlinkage long sys_setfsuid(uid_t uid)
 		sec->fsuid = uid;
 	}
 
-	key_fsuid_changed(current);
+	key_fsuid_changed(sec);
 	proc_id_connector(current, PROC_EVENT_UID);
 
 	security_task_post_setuid(old_fsuid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS);
@@ -869,7 +869,7 @@ asmlinkage long sys_setfsgid(gid_t gid)
 			smp_wmb();
 		}
 		sec->fsgid = gid;
-		key_fsgid_changed(current);
+		key_fsgid_changed(sec);
 		proc_id_connector(current, PROC_EVENT_GID);
 	}
 	return old_fsgid;
diff --git a/kernel/user.c b/kernel/user.c
index e85be3b..2fe9a29 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -393,7 +393,7 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
 #endif
 		new->locked_shm = 0;
 
-		if (alloc_uid_keyring(new, current) < 0)
+		if (alloc_uid_keyring(new, current->sec) < 0)
 			goto out_free_user;
 
 		if (sched_create_user(new) < 0)
diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index 9a8ff68..14979a5 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -297,7 +297,7 @@ int rxrpc_get_server_data_key(struct rxrpc_connection *conn,
 
 	_enter("");
 
-	key = key_alloc(&key_type_rxrpc, "x", 0, 0, current, 0,
+	key = key_alloc(&key_type_rxrpc, "x", 0, 0, current->act_as, 0,
 			KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(key)) {
 		_leave(" = -ENOMEM [alloc %ld]", PTR_ERR(key));
@@ -343,7 +343,7 @@ struct key *rxrpc_get_null_key(const char *keyname)
 	struct key *key;
 	int ret;
 
-	key = key_alloc(&key_type_rxrpc, keyname, 0, 0, current,
+	key = key_alloc(&key_type_rxrpc, keyname, 0, 0, current->act_as,
 			KEY_POS_SEARCH, KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(key))
 		return key;
diff --git a/security/dummy.c b/security/dummy.c
index 28413ae..cc516ab 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -503,16 +503,21 @@ static int dummy_task_create (unsigned long clone_flags)
 	return 0;
 }
 
-static int dummy_task_alloc_security (struct task_struct *p)
+static int dummy_task_alloc_security(struct task_struct *p)
 {
 	return 0;
 }
 
-static void dummy_task_free_security (struct task_struct *p)
+static void dummy_task_free_security(struct task_security *sec)
 {
 	return;
 }
 
+static int dummy_task_dup_security(struct task_security *p)
+{
+	return 0;
+}
+
 static int dummy_task_setuid (uid_t id0, uid_t id1, uid_t id2, int flags)
 {
 	return 0;
@@ -971,7 +976,7 @@ static void dummy_release_secctx(char *secdata, u32 seclen)
 }
 
 #ifdef CONFIG_KEYS
-static inline int dummy_key_alloc(struct key *key, struct task_struct *ctx,
+static inline int dummy_key_alloc(struct key *key, struct task_security *sec,
 				  unsigned long flags)
 {
 	return 0;
@@ -982,7 +987,7 @@ static inline void dummy_key_free(struct key *key)
 }
 
 static inline int dummy_key_permission(key_ref_t key_ref,
-				       struct task_struct *context,
+				       struct task_security *sec,
 				       key_perm_t perm)
 {
 	return 0;
@@ -1087,6 +1092,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, task_create);
 	set_to_dummy_if_null(ops, task_alloc_security);
 	set_to_dummy_if_null(ops, task_free_security);
+	set_to_dummy_if_null(ops, task_dup_security);
 	set_to_dummy_if_null(ops, task_setuid);
 	set_to_dummy_if_null(ops, task_post_setuid);
 	set_to_dummy_if_null(ops, task_setgid);
diff --git a/security/keys/internal.h b/security/keys/internal.h
index f004835..a439889 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -92,7 +92,7 @@ extern struct key *keyring_search_instkey(struct key *keyring,
 typedef int (*key_match_func_t)(const struct key *, const void *);
 
 extern key_ref_t keyring_search_aux(key_ref_t keyring_ref,
-				    struct task_struct *tsk,
+				    struct task_security *sec,
 				    struct key_type *type,
 				    const void *description,
 				    key_match_func_t match);
@@ -100,12 +100,12 @@ extern key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 extern key_ref_t search_process_keyrings(struct key_type *type,
 					 const void *description,
 					 key_match_func_t match,
-					 struct task_struct *tsk);
+					 struct task_security *sec);
 
 extern struct key *find_keyring_by_name(const char *name, key_serial_t bound);
 
-extern int install_thread_keyring(struct task_struct *tsk);
-extern int install_process_keyring(struct task_struct *tsk);
+extern int install_thread_keyring(struct task_security *sec);
+extern int install_process_keyring(struct task_security *sec);
 
 extern struct key *request_key_and_link(struct key_type *type,
 					const char *description,
@@ -120,7 +120,7 @@ extern struct key *request_key_and_link(struct key_type *type,
  */
 struct request_key_auth {
 	struct key		*target_key;
-	struct task_struct	*context;
+	struct task_security	*sec;
 	void			*callout_info;
 	size_t			callout_len;
 	pid_t			pid;
diff --git a/security/keys/key.c b/security/keys/key.c
index 4d1a253..f6ca221 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -243,7 +243,7 @@ serial_exists:
  *   instantiate the key or discard it before returning
  */
 struct key *key_alloc(struct key_type *type, const char *desc,
-		      uid_t uid, gid_t gid, struct task_struct *ctx,
+		      uid_t uid, gid_t gid, struct task_security *sec,
 		      key_perm_t perm, unsigned long flags)
 {
 	struct key_user *user = NULL;
@@ -314,7 +314,7 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 #endif
 
 	/* let the security module know about the key */
-	ret = security_key_alloc(key, ctx, flags);
+	ret = security_key_alloc(key, sec, flags);
 	if (ret < 0)
 		goto security_error;
 
@@ -818,7 +818,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 
 	/* allocate a new key */
 	key = key_alloc(ktype, description, current_fsuid(), current_fsgid(),
-			current, perm, flags);
+			current->act_as, perm, flags);
 	if (IS_ERR(key)) {
 		key_ref = ERR_CAST(key);
 		goto error_3;
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 4051948..2900451 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -878,7 +878,7 @@ long keyctl_instantiate_key(key_serial_t id,
 	 * requesting task */
 	keyring_ref = NULL;
 	if (ringid) {
-		keyring_ref = lookup_user_key(rka->context, ringid, 1, 0,
+		keyring_ref = lookup_user_key(rka->sec, ringid, 1, 0,
 					      KEY_WRITE);
 		if (IS_ERR(keyring_ref)) {
 			ret = PTR_ERR(keyring_ref);
@@ -973,13 +973,13 @@ long keyctl_set_reqkey_keyring(int reqkey_defl)
 
 	switch (reqkey_defl) {
 	case KEY_REQKEY_DEFL_THREAD_KEYRING:
-		ret = install_thread_keyring(current);
+		ret = install_thread_keyring(sec);
 		if (ret < 0)
 			return ret;
 		goto set;
 
 	case KEY_REQKEY_DEFL_PROCESS_KEYRING:
-		ret = install_process_keyring(current);
+		ret = install_process_keyring(sec);
 		if (ret < 0)
 			return ret;
 
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 76b89b2..6ccd8f8 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -244,14 +244,14 @@ static long keyring_read(const struct key *keyring,
  * allocate a keyring and link into the destination keyring
  */
 struct key *keyring_alloc(const char *description, uid_t uid, gid_t gid,
-			  struct task_struct *ctx, unsigned long flags,
+			  struct task_security *sec, unsigned long flags,
 			  struct key *dest)
 {
 	struct key *keyring;
 	int ret;
 
 	keyring = key_alloc(&key_type_keyring, description,
-			    uid, gid, ctx,
+			    uid, gid, sec,
 			    (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_ALL,
 			    flags);
 
@@ -280,7 +280,7 @@ struct key *keyring_alloc(const char *description, uid_t uid, gid_t gid,
  * - we propagate the possession attribute from the keyring ref to the key ref
  */
 key_ref_t keyring_search_aux(key_ref_t keyring_ref,
-			     struct task_struct *context,
+			     struct task_security *sec,
 			     struct key_type *type,
 			     const void *description,
 			     key_match_func_t match)
@@ -303,7 +303,7 @@ key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 	key_check(keyring);
 
 	/* top keyring must have search permission to begin the search */
-        err = key_task_permission(keyring_ref, context, KEY_SEARCH);
+	err = key_task_permission(keyring_ref, sec, KEY_SEARCH);
 	if (err < 0) {
 		key_ref = ERR_PTR(err);
 		goto error;
@@ -376,7 +376,7 @@ descend:
 
 		/* key must have search permissions */
 		if (key_task_permission(make_key_ref(key, possessed),
-					context, KEY_SEARCH) < 0)
+					sec, KEY_SEARCH) < 0)
 			continue;
 
 		/* we set a different error code if we pass a negative key */
@@ -403,7 +403,7 @@ ascend:
 			continue;
 
 		if (key_task_permission(make_key_ref(key, possessed),
-					context, KEY_SEARCH) < 0)
+					sec, KEY_SEARCH) < 0)
 			continue;
 
 		/* stack the current position */
@@ -458,7 +458,7 @@ key_ref_t keyring_search(key_ref_t keyring,
 	if (!type->match)
 		return ERR_PTR(-ENOKEY);
 
-	return keyring_search_aux(keyring, current,
+	return keyring_search_aux(keyring, current->sec,
 				  type, description, type->match);
 
 } /* end keyring_search() */
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 07898bd..eff3e29 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -19,10 +19,9 @@
  * but permit the security modules to override
  */
 int key_task_permission(const key_ref_t key_ref,
-			struct task_struct *context,
+			struct task_security *sec,
 			key_perm_t perm)
 {
-	struct task_security *sec = context->act_as;
 	struct key *key;
 	key_perm_t kperm;
 	int ret;
@@ -69,7 +68,7 @@ use_these_perms:
 		return -EACCES;
 
 	/* let LSM be the final arbiter */
-	return security_key_permission(key_ref, context, perm);
+	return security_key_permission(key_ref, sec, perm);
 
 } /* end key_task_permission() */
 
diff --git a/security/keys/proc.c b/security/keys/proc.c
index 6941260..d83d5b5 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -141,7 +141,7 @@ static int proc_keys_show(struct seq_file *m, void *v)
 
 	/* check whether the current task is allowed to view the key (assuming
 	 * non-possession) */
-	rc = key_task_permission(make_key_ref(key, 0), current, KEY_VIEW);
+	rc = key_task_permission(make_key_ref(key, 0), current->sec, KEY_VIEW);
 	if (rc < 0)
 		return 0;
 
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index a016e9b..0bf03fa 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -68,7 +68,7 @@ struct key root_session_keyring = {
  * allocate the keyrings to be associated with a UID
  */
 int alloc_uid_keyring(struct user_struct *user,
-		      struct task_struct *ctx)
+		      struct task_security *sec)
 {
 	struct key *uid_keyring, *session_keyring;
 	char buf[20];
@@ -77,7 +77,7 @@ int alloc_uid_keyring(struct user_struct *user,
 	/* concoct a default session keyring */
 	sprintf(buf, "_uid_ses.%u", user->uid);
 
-	session_keyring = keyring_alloc(buf, user->uid, (gid_t) -1, ctx,
+	session_keyring = keyring_alloc(buf, user->uid, (gid_t) -1, sec,
 					KEY_ALLOC_IN_QUOTA, NULL);
 	if (IS_ERR(session_keyring)) {
 		ret = PTR_ERR(session_keyring);
@@ -88,7 +88,7 @@ int alloc_uid_keyring(struct user_struct *user,
 	 * keyring */
 	sprintf(buf, "_uid.%u", user->uid);
 
-	uid_keyring = keyring_alloc(buf, user->uid, (gid_t) -1, ctx,
+	uid_keyring = keyring_alloc(buf, user->uid, (gid_t) -1, sec,
 				    KEY_ALLOC_IN_QUOTA, session_keyring);
 	if (IS_ERR(uid_keyring)) {
 		key_put(session_keyring);
@@ -135,33 +135,29 @@ void switch_uid_keyring(struct user_struct *new_user)
 
 /*****************************************************************************/
 /*
- * install a fresh thread keyring, discarding the old one
+ * make sure a thread keyring is installed
  */
-int install_thread_keyring(struct task_struct *tsk)
+int install_thread_keyring(struct task_security *sec)
 {
-	struct key *keyring, *old;
+	struct key *keyring;
 	char buf[20];
-	int ret;
 
-	sprintf(buf, "_tid.%u", tsk->pid);
+	sprintf(buf, "_tid.%u", current->pid);
 
-	keyring = keyring_alloc(buf, tsk->sec->uid, tsk->sec->gid, tsk,
+	keyring = keyring_alloc(buf, sec->uid, sec->gid, sec,
 				KEY_ALLOC_QUOTA_OVERRUN, NULL);
-	if (IS_ERR(keyring)) {
-		ret = PTR_ERR(keyring);
-		goto error;
-	}
-
-	task_lock(tsk);
-	old = tsk->sec->thread_keyring;
-	tsk->sec->thread_keyring = keyring;
-	task_unlock(tsk);
+	if (IS_ERR(keyring))
+		return PTR_ERR(keyring);
 
-	ret = 0;
+	spin_lock(&sec->lock);
+	if (!sec->thread_keyring) {
+		sec->thread_keyring = keyring;
+		keyring = NULL;
+	}
+	spin_unlock(&sec->lock);
 
-	key_put(old);
-error:
-	return ret;
+	key_put(keyring);
+	return 0;
 
 } /* end install_thread_keyring() */
 
@@ -169,38 +165,36 @@ error:
 /*
  * make sure a process keyring is installed
  */
-int install_process_keyring(struct task_struct *tsk)
+int install_process_keyring(struct task_security *sec)
 {
+	struct thread_group_security *tgsec;
 	struct key *keyring;
 	char buf[20];
-	int ret;
 
 	might_sleep();
+	sec = current->sec;
+	tgsec = sec->tgsec;
 
-	if (!tsk->signal->process_keyring) {
-		sprintf(buf, "_pid.%u", tsk->tgid);
+	if (!tgsec->process_keyring) {
+		sprintf(buf, "_pid.%u", tgsec->tgid);
 
-		keyring = keyring_alloc(buf, tsk->sec->uid, tsk->sec->gid, tsk,
+		keyring = keyring_alloc(buf, sec->uid, sec->gid, sec,
 					KEY_ALLOC_QUOTA_OVERRUN, NULL);
-		if (IS_ERR(keyring)) {
-			ret = PTR_ERR(keyring);
-			goto error;
-		}
+		if (IS_ERR(keyring))
+			return PTR_ERR(keyring);
 
 		/* attach keyring */
-		spin_lock_irq(&tsk->sighand->siglock);
-		if (!tsk->signal->process_keyring) {
-			tsk->signal->process_keyring = keyring;
+		spin_lock(&tgsec->lock);
+		if (!tgsec->process_keyring) {
+			tgsec->process_keyring = keyring;
 			keyring = NULL;
 		}
-		spin_unlock_irq(&tsk->sighand->siglock);
+		spin_unlock(&tgsec->lock);
 
 		key_put(keyring);
 	}
 
-	ret = 0;
-error:
-	return ret;
+	return 0;
 
 } /* end install_process_keyring() */
 
@@ -209,37 +203,38 @@ error:
  * install a session keyring, discarding the old one
  * - if a keyring is not supplied, an empty one is invented
  */
-static int install_session_keyring(struct task_struct *tsk,
+static int install_session_keyring(struct task_security *sec,
 				   struct key *keyring)
 {
+	struct thread_group_security *tgsec;
 	unsigned long flags;
 	struct key *old;
 	char buf[20];
 
 	might_sleep();
+	tgsec = sec->tgsec;
 
 	/* create an empty session keyring */
 	if (!keyring) {
-		sprintf(buf, "_ses.%u", tsk->tgid);
+		sprintf(buf, "_ses.%u", tgsec->tgid);
 
 		flags = KEY_ALLOC_QUOTA_OVERRUN;
-		if (tsk->signal->session_keyring)
+		if (tgsec->session_keyring)
 			flags = KEY_ALLOC_IN_QUOTA;
 
-		keyring = keyring_alloc(buf, tsk->sec->uid, tsk->sec->gid, tsk,
+		keyring = keyring_alloc(buf, sec->uid, sec->gid, sec,
 					flags, NULL);
 		if (IS_ERR(keyring))
 			return PTR_ERR(keyring);
-	}
-	else {
+	} else {
 		atomic_inc(&keyring->usage);
 	}
 
 	/* install the keyring */
-	spin_lock_irq(&tsk->sighand->siglock);
-	old = tsk->signal->session_keyring;
-	rcu_assign_pointer(tsk->signal->session_keyring, keyring);
-	spin_unlock_irq(&tsk->sighand->siglock);
+	spin_lock_irq(&tgsec->lock);
+	old = tgsec->session_keyring;
+	rcu_assign_pointer(tgsec->session_keyring, keyring);
+	spin_unlock_irq(&tgsec->lock);
 
 	/* we're using RCU on the pointer, but there's no point synchronising
 	 * on it if it didn't previously point to anything */
@@ -252,68 +247,49 @@ static int install_session_keyring(struct task_struct *tsk,
 
 } /* end install_session_keyring() */
 
-/*****************************************************************************/
 /*
- * copy the keys in a thread group for fork without CLONE_THREAD
+ * install a session keyring for kmod
  */
-int copy_thread_group_keys(struct task_struct *tsk)
+void __install_session_keyring(struct task_struct *tsk, struct key *keyring)
 {
-	key_check(current->thread_group->session_keyring);
-	key_check(current->thread_group->process_keyring);
-
-	/* no process keyring yet */
-	tsk->signal->process_keyring = NULL;
+	struct thread_group_security *tgsec = tsk->sec->tgsec;
+	struct key *old;
 
-	/* same session keyring */
-	rcu_read_lock();
-	tsk->signal->session_keyring =
-		key_get(rcu_dereference(current->signal->session_keyring));
-	rcu_read_unlock();
+	key_get(keyring);
 
-	return 0;
+	spin_lock(&tgsec->lock);
+	old = tgsec->session_keyring;
+	rcu_assign_pointer(tgsec->session_keyring, keyring);
+	spin_unlock(&tgsec->lock);
 
-} /* end copy_thread_group_keys() */
+	/* we're using RCU on the pointer, but there's no point synchronising
+	 * on it if it didn't previously point to anything */
+	if (old) {
+		synchronize_rcu();
+		key_put(old);
+	}
+}
 
 /*****************************************************************************/
 /*
- * copy the keys for fork
+ * copy the keys in a thread group for fork without CLONE_THREAD
  */
-int copy_keys(unsigned long clone_flags, struct task_struct *tsk)
+int copy_thread_group_keys(struct thread_group_security *tgsec)
 {
-	key_check(tsk->sec->thread_keyring);
-	key_check(tsk->sec->request_key_auth);
+	key_check(tgsec->session_keyring);
+	key_check(tgsec->process_keyring);
 
-	/* no thread keyring yet */
-	tsk->sec->thread_keyring = NULL;
+	/* no process keyring yet */
+	tgsec->process_keyring = NULL;
 
-	/* copy the request_key() authorisation for this thread */
-	key_get(tsk->sec->request_key_auth);
+	/* same session keyring */
+	rcu_read_lock();
+	tgsec->session_keyring =
+		key_get(rcu_dereference(current->sec->tgsec->session_keyring));
+	rcu_read_unlock();
 
 	return 0;
-
-} /* end copy_keys() */
-
-/*****************************************************************************/
-/*
- * dispose of thread group keys upon thread group destruction
- */
-void exit_thread_group_keys(struct signal_struct *tg)
-{
-	key_put(tg->session_keyring);
-	key_put(tg->process_keyring);
-
-} /* end exit_thread_group_keys() */
-
-/*****************************************************************************/
-/*
- * dispose of per-thread keys upon thread exit
- */
-void exit_keys(struct task_struct *tsk)
-{
-	key_put(tsk->sec->thread_keyring);
-	key_put(tsk->sec->request_key_auth);
-
-} /* end exit_keys() */
+}
 
 /*****************************************************************************/
 /*
@@ -321,21 +297,23 @@ void exit_keys(struct task_struct *tsk)
  */
 int exec_keys(struct task_struct *tsk)
 {
+	struct thread_group_security *tgsec = tsk->sec->tgsec;
+	struct task_security *sec = tsk->sec;
 	struct key *old;
 
 	/* newly exec'd tasks don't get a thread keyring */
-	task_lock(tsk);
-	old = tsk->sec->thread_keyring;
-	tsk->sec->thread_keyring = NULL;
-	task_unlock(tsk);
+	spin_lock(&sec->lock);
+	old = sec->thread_keyring;
+	sec->thread_keyring = NULL;
+	spin_unlock(&sec->lock);
 
 	key_put(old);
 
 	/* discard the process keyring from a newly exec'd task */
-	spin_lock_irq(&tsk->sighand->siglock);
-	old = tsk->signal->process_keyring;
-	tsk->signal->process_keyring = NULL;
-	spin_unlock_irq(&tsk->sighand->siglock);
+	spin_lock(&tgsec->lock);
+	old = tgsec->process_keyring;
+	tgsec->process_keyring = NULL;
+	spin_unlock(&tgsec->lock);
 
 	key_put(old);
 
@@ -358,14 +336,13 @@ int suid_keys(struct task_struct *tsk)
 /*
  * the filesystem user ID changed
  */
-void key_fsuid_changed(struct task_struct *tsk)
+void key_fsuid_changed(struct task_security *sec)
 {
 	/* update the ownership of the thread keyring */
-	BUG_ON(!tsk->sec);
-	if (tsk->sec->thread_keyring) {
-		down_write(&tsk->sec->thread_keyring->sem);
-		tsk->sec->thread_keyring->uid = tsk->sec->fsuid;
-		up_write(&tsk->sec->thread_keyring->sem);
+	if (sec->thread_keyring) {
+		down_write(&sec->thread_keyring->sem);
+		sec->thread_keyring->uid = sec->fsuid;
+		up_write(&sec->thread_keyring->sem);
 	}
 
 } /* end key_fsuid_changed() */
@@ -374,14 +351,13 @@ void key_fsuid_changed(struct task_struct *tsk)
 /*
  * the filesystem group ID changed
  */
-void key_fsgid_changed(struct task_struct *tsk)
+void key_fsgid_changed(struct task_security *sec)
 {
 	/* update the ownership of the thread keyring */
-	BUG_ON(!tsk->sec);
-	if (tsk->sec->thread_keyring) {
-		down_write(&tsk->sec->thread_keyring->sem);
-		tsk->sec->thread_keyring->gid = tsk->sec->fsgid;
-		up_write(&tsk->sec->thread_keyring->sem);
+	if (sec->thread_keyring) {
+		down_write(&sec->thread_keyring->sem);
+		sec->thread_keyring->gid = sec->fsgid;
+		up_write(&sec->thread_keyring->sem);
 	}
 
 } /* end key_fsgid_changed() */
@@ -397,7 +373,7 @@ void key_fsgid_changed(struct task_struct *tsk)
 key_ref_t search_process_keyrings(struct key_type *type,
 				  const void *description,
 				  key_match_func_t match,
-				  struct task_struct *context)
+				  struct task_security *sec)
 {
 	struct request_key_auth *rka;
 	key_ref_t key_ref, ret, err;
@@ -416,10 +392,10 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	err = ERR_PTR(-EAGAIN);
 
 	/* search the thread keyring first */
-	if (context->sec->thread_keyring) {
+	if (sec->thread_keyring) {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->sec->thread_keyring, 1),
-			context, type, description, match);
+			make_key_ref(sec->thread_keyring, 1),
+			sec, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -437,10 +413,10 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	}
 
 	/* search the process keyring second */
-	if (context->signal->process_keyring) {
+	if (sec->tgsec->process_keyring) {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->signal->process_keyring, 1),
-			context, type, description, match);
+			make_key_ref(sec->tgsec->process_keyring, 1),
+			sec, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -458,13 +434,13 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	}
 
 	/* search the session keyring */
-	if (context->signal->session_keyring) {
+	if (sec->tgsec->session_keyring) {
 		rcu_read_lock();
 		key_ref = keyring_search_aux(
 			make_key_ref(rcu_dereference(
-					     context->signal->session_keyring),
+					     sec->tgsec->session_keyring),
 				     1),
-			context, type, description, match);
+			sec, type, description, match);
 		rcu_read_unlock();
 
 		if (!IS_ERR(key_ref))
@@ -485,8 +461,8 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	/* or search the user-session keyring */
 	else {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->sec->user->session_keyring, 1),
-			context, type, description, match);
+			make_key_ref(sec->user->session_keyring, 1),
+			sec, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -507,20 +483,20 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	 * search the keyrings of the process mentioned there
 	 * - we don't permit access to request_key auth keys via this method
 	 */
-	if (context->sec->request_key_auth &&
-	    context == current &&
+	if (sec->request_key_auth &&
+	    sec == current->sec &&
 	    type != &key_type_request_key_auth
 	    ) {
 		/* defend against the auth key being revoked */
-		down_read(&context->sec->request_key_auth->sem);
+		down_read(&sec->request_key_auth->sem);
 
-		if (key_validate(context->sec->request_key_auth) == 0) {
-			rka = context->sec->request_key_auth->payload.data;
+		if (key_validate(sec->request_key_auth) == 0) {
+			rka = sec->request_key_auth->payload.data;
 
 			key_ref = search_process_keyrings(type, description,
-							  match, rka->context);
+							  match, rka->sec);
 
-			up_read(&context->sec->request_key_auth->sem);
+			up_read(&sec->request_key_auth->sem);
 
 			if (!IS_ERR(key_ref))
 				goto found;
@@ -537,7 +513,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 				break;
 			}
 		} else {
-			up_read(&context->sec->request_key_auth->sem);
+			up_read(&sec->request_key_auth->sem);
 		}
 	}
 
@@ -565,78 +541,78 @@ static int lookup_user_key_possessed(const struct key *key, const void *target)
  * - don't create special keyrings unless so requested
  * - partially constructed keys aren't found unless requested
  */
-key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
+key_ref_t lookup_user_key(struct task_security *sec, key_serial_t id,
 			  int create, int partial, key_perm_t perm)
 {
 	key_ref_t key_ref, skey_ref;
 	struct key *key;
 	int ret;
 
-	if (!context)
-		context = current;
+	if (!sec)
+		sec = current->act_as;
 
 	key_ref = ERR_PTR(-ENOKEY);
 
 	switch (id) {
 	case KEY_SPEC_THREAD_KEYRING:
-		if (!context->sec->thread_keyring) {
+		if (!sec->thread_keyring) {
 			if (!create)
 				goto error;
 
-			ret = install_thread_keyring(context);
+			ret = install_thread_keyring(sec);
 			if (ret < 0) {
 				key = ERR_PTR(ret);
 				goto error;
 			}
 		}
 
-		key = context->sec->thread_keyring;
+		key = sec->thread_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_PROCESS_KEYRING:
-		if (!context->signal->process_keyring) {
+		if (!sec->tgsec->process_keyring) {
 			if (!create)
 				goto error;
 
-			ret = install_process_keyring(context);
+			ret = install_process_keyring(sec);
 			if (ret < 0) {
 				key = ERR_PTR(ret);
 				goto error;
 			}
 		}
 
-		key = context->signal->process_keyring;
+		key = sec->tgsec->process_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_SESSION_KEYRING:
-		if (!context->signal->session_keyring) {
+		if (!sec->tgsec->session_keyring) {
 			/* always install a session keyring upon access if one
 			 * doesn't exist yet */
 			ret = install_session_keyring(
-				context, context->sec->user->session_keyring);
+				sec, sec->user->session_keyring);
 			if (ret < 0)
 				goto error;
 		}
 
 		rcu_read_lock();
-		key = rcu_dereference(context->signal->session_keyring);
+		key = rcu_dereference(sec->tgsec->session_keyring);
 		atomic_inc(&key->usage);
 		rcu_read_unlock();
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_USER_KEYRING:
-		key = context->sec->user->uid_keyring;
+		key = sec->user->uid_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_USER_SESSION_KEYRING:
-		key = context->sec->user->session_keyring;
+		key = sec->user->session_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
@@ -647,7 +623,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		goto error;
 
 	case KEY_SPEC_REQKEY_AUTH_KEY:
-		key = context->sec->request_key_auth;
+		key = sec->request_key_auth;
 		if (!key)
 			goto error;
 
@@ -671,7 +647,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		/* check to see if we possess the key */
 		skey_ref = search_process_keyrings(key->type, key,
 						   lookup_user_key_possessed,
-						   current);
+						   sec);
 
 		if (!IS_ERR(skey_ref)) {
 			key_put(key);
@@ -703,7 +679,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		goto invalid_key;
 
 	/* check the permissions */
-	ret = key_task_permission(key_ref, context, perm);
+	ret = key_task_permission(key_ref, sec, perm);
 	if (ret < 0)
 		goto invalid_key;
 
@@ -726,18 +702,18 @@ invalid_key:
  */
 long join_session_keyring(const char *name)
 {
-	struct task_struct *tsk = current;
+	struct task_security *sec = current->sec;
 	struct key *keyring;
 	long ret;
 
 	/* if no name is provided, install an anonymous keyring */
 	if (!name) {
-		ret = install_session_keyring(tsk, NULL);
+		ret = install_session_keyring(sec, NULL);
 		if (ret < 0)
 			goto error;
 
 		rcu_read_lock();
-		ret = rcu_dereference(tsk->signal->session_keyring)->serial;
+		ret = rcu_dereference(sec->tgsec->session_keyring)->serial;
 		rcu_read_unlock();
 		goto error;
 	}
@@ -749,7 +725,7 @@ long join_session_keyring(const char *name)
 	keyring = find_keyring_by_name(name, 0);
 	if (PTR_ERR(keyring) == -ENOKEY) {
 		/* not found - try and create a new one */
-		keyring = keyring_alloc(name, tsk->sec->uid, tsk->sec->gid, tsk,
+		keyring = keyring_alloc(name, sec->uid, sec->gid, sec,
 					KEY_ALLOC_IN_QUOTA, NULL);
 		if (IS_ERR(keyring)) {
 			ret = PTR_ERR(keyring);
@@ -762,7 +738,7 @@ long join_session_keyring(const char *name)
 	}
 
 	/* we've got a keyring - now to install it */
-	ret = install_session_keyring(tsk, keyring);
+	ret = install_session_keyring(sec, keyring);
 	if (ret < 0)
 		goto error2;
 
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 5b5ad42..00ee92e 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -63,7 +63,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 				 const char *op,
 				 void *aux)
 {
-	struct task_struct *tsk = current;
+	struct task_security *sec = current->act_as;
 	key_serial_t prkey, sskey;
 	struct key *key = cons->key, *authkey = cons->authkey, *keyring;
 	char *argv[9], *envp[3], uid_str[12], gid_str[12];
@@ -76,7 +76,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 	/* allocate a new session keyring */
 	sprintf(desc, "_req.%u", key->serial);
 
-	keyring = keyring_alloc(desc, current_fsuid(), current_fsgid(), current,
+	keyring = keyring_alloc(desc, sec->fsuid, sec->fsgid, sec,
 				KEY_ALLOC_QUOTA_OVERRUN, NULL);
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
@@ -89,29 +89,27 @@ static int call_sbin_request_key(struct key_construction *cons,
 		goto error_link;
 
 	/* record the UID and GID */
-	sprintf(uid_str, "%d", current_fsuid());
-	sprintf(gid_str, "%d", current_fsgid());
+	sprintf(uid_str, "%d", sec->fsuid);
+	sprintf(gid_str, "%d", sec->fsgid);
 
 	/* we say which key is under construction */
 	sprintf(key_str, "%d", key->serial);
 
 	/* we specify the process's default keyrings */
-	sprintf(keyring_str[0], "%d",
-		tsk->act_as->thread_keyring ?
-		tsk->act_as->thread_keyring->serial : 0);
+	sprintf(keyring_str[0], "%d", key_serial(sec->thread_keyring));
 
 	prkey = 0;
-	if (tsk->signal->process_keyring)
-		prkey = tsk->signal->process_keyring->serial;
+	if (sec->tgsec->process_keyring)
+		prkey = sec->tgsec->process_keyring->serial;
 
 	sprintf(keyring_str[1], "%d", prkey);
 
-	if (tsk->signal->session_keyring) {
+	if (sec->tgsec->session_keyring) {
 		rcu_read_lock();
-		sskey = rcu_dereference(tsk->signal->session_keyring)->serial;
+		sskey = rcu_dereference(sec->tgsec->session_keyring)->serial;
 		rcu_read_unlock();
 	} else {
-		sskey = tsk->act_as->user->session_keyring->serial;
+		sskey = sec->user->session_keyring->serial;
 	}
 
 	sprintf(keyring_str[2], "%d", sskey);
@@ -210,29 +208,29 @@ static int construct_key(struct key *key, const void *callout_info,
  */
 static void construct_key_make_link(struct key *key, struct key *dest_keyring)
 {
-	struct task_struct *tsk = current;
+	struct task_security *sec = current->sec;
 	struct key *drop = NULL;
 
 	kenter("{%d},%p", key->serial, dest_keyring);
 
 	/* find the appropriate keyring */
 	if (!dest_keyring) {
-		switch (tsk->act_as->jit_keyring) {
+		switch (sec->jit_keyring) {
 		case KEY_REQKEY_DEFL_DEFAULT:
 		case KEY_REQKEY_DEFL_THREAD_KEYRING:
-			dest_keyring = tsk->act_as->thread_keyring;
+			dest_keyring = sec->thread_keyring;
 			if (dest_keyring)
 				break;
 
 		case KEY_REQKEY_DEFL_PROCESS_KEYRING:
-			dest_keyring = tsk->signal->process_keyring;
+			dest_keyring = sec->tgsec->process_keyring;
 			if (dest_keyring)
 				break;
 
 		case KEY_REQKEY_DEFL_SESSION_KEYRING:
 			rcu_read_lock();
 			dest_keyring = key_get(
-				rcu_dereference(tsk->signal->session_keyring));
+				rcu_dereference(sec->tgsec->session_keyring));
 			rcu_read_unlock();
 			drop = dest_keyring;
 
@@ -240,11 +238,11 @@ static void construct_key_make_link(struct key *key, struct key *dest_keyring)
 				break;
 
 		case KEY_REQKEY_DEFL_USER_SESSION_KEYRING:
-			dest_keyring = tsk->act_as->user->session_keyring;
+			dest_keyring = sec->user->session_keyring;
 			break;
 
 		case KEY_REQKEY_DEFL_USER_KEYRING:
-			dest_keyring = tsk->act_as->user->uid_keyring;
+			dest_keyring = sec->user->uid_keyring;
 			break;
 
 		case KEY_REQKEY_DEFL_GROUP_KEYRING:
@@ -268,6 +266,7 @@ static int construct_alloc_key(struct key_type *type,
 			       const char *description,
 			       struct key *dest_keyring,
 			       unsigned long flags,
+			       struct task_security *sec,
 			       struct key_user *user,
 			       struct key **_key)
 {
@@ -278,9 +277,8 @@ static int construct_alloc_key(struct key_type *type,
 
 	mutex_lock(&user->cons_lock);
 
-	key = key_alloc(type, description,
-			current_fsuid(), current_fsgid(), current, KEY_POS_ALL,
-			flags);
+	key = key_alloc(type, description, sec->fsuid, sec->fsgid, sec,
+			KEY_POS_ALL, flags);
 	if (IS_ERR(key))
 		goto alloc_failed;
 
@@ -294,8 +292,7 @@ static int construct_alloc_key(struct key_type *type,
 	 * waited for locks */
 	mutex_lock(&key_construction_mutex);
 
-	key_ref = search_process_keyrings(type, description, type->match,
-					  current);
+	key_ref = search_process_keyrings(type, description, type->match, sec);
 	if (!IS_ERR(key_ref))
 		goto key_already_present;
 
@@ -336,18 +333,19 @@ static struct key *construct_key_and_link(struct key_type *type,
 					  size_t callout_len,
 					  void *aux,
 					  struct key *dest_keyring,
+					  struct task_security *sec,
 					  unsigned long flags)
 {
 	struct key_user *user;
 	struct key *key;
 	int ret;
 
-	user = key_user_lookup(current_fsuid());
+	user = key_user_lookup(sec->fsuid);
 	if (!user)
 		return ERR_PTR(-ENOMEM);
 
-	ret = construct_alloc_key(type, description, dest_keyring, flags, user,
-				  &key);
+	ret = construct_alloc_key(type, description, dest_keyring, flags, sec,
+				  user, &key);
 	key_user_put(user);
 
 	if (ret == 0) {
@@ -379,6 +377,7 @@ struct key *request_key_and_link(struct key_type *type,
 				 struct key *dest_keyring,
 				 unsigned long flags)
 {
+	struct task_security *sec = current->sec;
 	struct key *key;
 	key_ref_t key_ref;
 
@@ -387,9 +386,7 @@ struct key *request_key_and_link(struct key_type *type,
 	       dest_keyring, flags);
 
 	/* search all the process keyrings for a key */
-	key_ref = search_process_keyrings(type, description, type->match,
-					  current);
-
+	key_ref = search_process_keyrings(type, description, type->match, sec);
 	if (!IS_ERR(key_ref)) {
 		key = key_ref_to_ptr(key_ref);
 	} else if (PTR_ERR(key_ref) != -EAGAIN) {
@@ -403,7 +400,7 @@ struct key *request_key_and_link(struct key_type *type,
 
 		key = construct_key_and_link(type, description, callout_info,
 					     callout_len, aux, dest_keyring,
-					     flags);
+					     sec, flags);
 	}
 
 error:
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index d306412..2513d90 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -104,10 +104,8 @@ static void request_key_auth_revoke(struct key *key)
 
 	kenter("{%d}", key->serial);
 
-	if (rka->context) {
-		put_task_struct(rka->context);
-		rka->context = NULL;
-	}
+	put_task_security(rka->sec);
+	rka->sec = NULL;
 
 } /* end request_key_auth_revoke() */
 
@@ -121,11 +119,7 @@ static void request_key_auth_destroy(struct key *key)
 
 	kenter("{%d}", key->serial);
 
-	if (rka->context) {
-		put_task_struct(rka->context);
-		rka->context = NULL;
-	}
-
+	put_task_security(rka->sec);
 	key_put(rka->target_key);
 	kfree(rka->callout_info);
 	kfree(rka);
@@ -141,6 +135,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 				 size_t callout_len)
 {
 	struct request_key_auth *rka, *irka;
+	struct task_security *sec = current->sec;
 	struct key *authkey = NULL;
 	char desc[20];
 	int ret;
@@ -162,28 +157,25 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 
 	/* see if the calling process is already servicing the key request of
 	 * another process */
-	if (current->act_as->request_key_auth) {
+	if (sec->request_key_auth) {
 		/* it is - use that instantiation context here too */
-		down_read(&current->act_as->request_key_auth->sem);
+		down_read(&sec->request_key_auth->sem);
 
 		/* if the auth key has been revoked, then the key we're
 		 * servicing is already instantiated */
-		if (test_bit(KEY_FLAG_REVOKED,
-			     &current->act_as->request_key_auth->flags))
+		if (test_bit(KEY_FLAG_REVOKED, &sec->request_key_auth->flags))
 			goto auth_key_revoked;
 
-		irka = current->act_as->request_key_auth->payload.data;
-		rka->context = irka->context;
+		irka = sec->request_key_auth->payload.data;
+		rka->sec = irka->sec;
 		rka->pid = irka->pid;
-		get_task_struct(rka->context);
+		get_task_security(rka->sec);
 
-		up_read(&current->act_as->request_key_auth->sem);
-	}
-	else {
+		up_read(&sec->request_key_auth->sem);
+	} else {
 		/* it isn't - use this process as the context */
-		rka->context = current;
+		rka->sec = get_task_security(sec);
 		rka->pid = current->pid;
-		get_task_struct(rka->context);
 	}
 
 	rka->target_key = key_get(target);
@@ -194,7 +186,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 	sprintf(desc, "%x", target->serial);
 
 	authkey = key_alloc(&key_type_request_key_auth, desc,
-			    current_fsuid(), current_fsgid(), current,
+			    sec->fsuid, sec->fsgid, sec,
 			    KEY_POS_VIEW | KEY_POS_READ | KEY_POS_SEARCH |
 			    KEY_USR_VIEW, KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(authkey)) {
@@ -260,7 +252,7 @@ struct key *key_get_instantiation_authkey(key_serial_t target_id)
 		&key_type_request_key_auth,
 		(void *) (unsigned long) target_id,
 		key_get_instantiation_authkey_match,
-		current);
+		current->act_as);
 
 	if (IS_ERR(authkey_ref)) {
 		authkey = ERR_CAST(authkey_ref);
diff --git a/security/security.c b/security/security.c
index 3e75b90..3aceeac 100644
--- a/security/security.c
+++ b/security/security.c
@@ -590,9 +590,14 @@ int security_task_alloc(struct task_struct *p)
 	return security_ops->task_alloc_security(p);
 }
 
-void security_task_free(struct task_struct *p)
+void security_task_free(struct task_security *sec)
 {
-	security_ops->task_free_security(p);
+	security_ops->task_free_security(sec);
+}
+
+int security_task_dup(struct task_security *sec)
+{
+	return security_ops->task_dup_security(sec);
 }
 
 int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
@@ -1086,9 +1091,10 @@ EXPORT_SYMBOL(security_skb_classify_flow);
 
 #ifdef CONFIG_KEYS
 
-int security_key_alloc(struct key *key, struct task_struct *tsk, unsigned long flags)
+int security_key_alloc(struct key *key, struct task_security *sec,
+		       unsigned long flags)
 {
-	return security_ops->key_alloc(key, tsk, flags);
+	return security_ops->key_alloc(key, sec, flags);
 }
 
 void security_key_free(struct key *key)
@@ -1096,10 +1102,10 @@ void security_key_free(struct key *key)
 	security_ops->key_free(key);
 }
 
-int security_key_permission(key_ref_t key_ref,
-			    struct task_struct *context, key_perm_t perm)
+int security_key_permission(key_ref_t key_ref, struct task_security *sec,
+			    key_perm_t perm)
 {
-	return security_ops->key_permission(key_ref, context, perm);
+	return security_ops->key_permission(key_ref, sec, perm);
 }
 
 int security_key_getsecurity(struct key *key, char **_buffer)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 793cd4e..ca180b6 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -161,17 +161,16 @@ static int task_alloc_security(struct task_struct *task)
 	if (!tsec)
 		return -ENOMEM;
 
-	tsec->task = task;
 	tsec->osid = tsec->sid = tsec->ptrace_sid = SECINITSID_UNLABELED;
 	task->sec->security = tsec;
 
 	return 0;
 }
 
-static void task_free_security(struct task_struct *task)
+static void task_free_security(struct task_security *sec)
 {
-	struct task_security_struct *tsec = task->sec->security;
-	task->sec->security = NULL;
+	struct task_security_struct *tsec = sec->security;
+	sec->security = NULL;
 	kfree(tsec);
 }
 
@@ -3077,9 +3076,25 @@ static int selinux_task_alloc_security(struct task_struct *tsk)
 	return 0;
 }
 
-static void selinux_task_free_security(struct task_struct *tsk)
+static void selinux_task_free_security(struct task_security *sec)
 {
-	task_free_security(tsk);
+	task_free_security(sec);
+}
+
+static int selinux_task_dup_security(struct task_security *sec)
+{
+	struct task_security_struct *tsec1, *tsec2;
+
+	tsec1 = sec->security;
+
+	tsec2 = kmemdup(tsec1, sizeof(*tsec1), GFP_KERNEL);
+	if (!tsec2)
+		return -ENOMEM;
+
+	tsec2->ptrace_sid = SECINITSID_UNLABELED;
+	sec->security = tsec2;
+
+	return 0;
 }
 
 static int selinux_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
@@ -5166,10 +5181,10 @@ static void selinux_release_secctx(char *secdata, u32 seclen)
 
 #ifdef CONFIG_KEYS
 
-static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
+static int selinux_key_alloc(struct key *k, struct task_security *context,
 			     unsigned long flags)
 {
-	struct task_security_struct *tsec = tsk->sec->security;
+	struct task_security_struct *tsec = context->security;
 	struct key_security_struct *ksec;
 
 	ksec = kzalloc(sizeof(struct key_security_struct), GFP_KERNEL);
@@ -5195,7 +5210,7 @@ static void selinux_key_free(struct key *k)
 }
 
 static int selinux_key_permission(key_ref_t key_ref,
-			    struct task_struct *ctx,
+			    struct task_security *context,
 			    key_perm_t perm)
 {
 	struct key *key;
@@ -5204,7 +5219,7 @@ static int selinux_key_permission(key_ref_t key_ref,
 
 	key = key_ref_to_ptr(key_ref);
 
-	tsec = ctx->sec->security;
+	tsec = context->security;
 	ksec = key->security;
 
 	/* if no specific permissions are requested, we skip the
@@ -5311,6 +5326,7 @@ static struct security_operations selinux_ops = {
 	.task_create =			selinux_task_create,
 	.task_alloc_security =		selinux_task_alloc_security,
 	.task_free_security =		selinux_task_free_security,
+	.task_dup_security =		selinux_task_dup_security,
 	.task_setuid =			selinux_task_setuid,
 	.task_post_setuid =		selinux_task_post_setuid,
 	.task_setgid =			selinux_task_setgid,
@@ -5453,9 +5469,9 @@ static __init int selinux_init(void)
 
 #ifdef CONFIG_KEYS
 	/* Add security information to initial keyrings */
-	selinux_key_alloc(&root_user_keyring, current,
+	selinux_key_alloc(&root_user_keyring, current->sec,
 			  KEY_ALLOC_NOT_IN_QUOTA);
-	selinux_key_alloc(&root_session_keyring, current,
+	selinux_key_alloc(&root_session_keyring, current->sec,
 			  KEY_ALLOC_NOT_IN_QUOTA);
 #endif
 
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index c6c2bb4..2864600 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -28,7 +28,6 @@
 #include "avc.h"
 
 struct task_security_struct {
-	struct task_struct *task;      /* back pointer to task object */
 	u32 osid;            /* SID prior to last execve */
 	u32 sid;             /* current SID */
 	u32 exec_sid;        /* exec SID */
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index a49d94f..dbce607 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -957,9 +957,22 @@ static int smack_task_alloc_security(struct task_struct *tsk)
  * points to an immutable list. The blobs never go away.
  * There is no leak here.
  */
-static void smack_task_free_security(struct task_struct *task)
+static void smack_task_free_security(struct task_security *sec)
 {
-	task->sec->security = NULL;
+	sec->security = NULL;
+}
+
+/**
+ * task_dup_security - Duplicate task security
+ * @p points to the task_security struct that has been copied
+ *
+ * Duplicate the security structure currently attached to the p->security field
+ * and attach back to p->security (the pointer itself was copied, so there's
+ * nothing to be done here).
+ */
+static int smack_task_dup_security(struct task_security *sec)
+{
+	return 0;
 }
 
 /**
@@ -2276,17 +2289,17 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 /**
  * smack_key_alloc - Set the key security blob
  * @key: object
- * @tsk: the task associated with the key
+ * @context: the task security associated with the key
  * @flags: unused
  *
  * No allocation required
  *
  * Returns 0
  */
-static int smack_key_alloc(struct key *key, struct task_struct *tsk,
+static int smack_key_alloc(struct key *key, struct task_security *context,
 			   unsigned long flags)
 {
-	key->security = tsk->act_as->security;
+	key->security = context->security;
 	return 0;
 }
 
@@ -2304,14 +2317,14 @@ static void smack_key_free(struct key *key)
 /*
  * smack_key_permission - Smack access on a key
  * @key_ref: gets to the object
- * @context: task involved
+ * @context: task security involved
  * @perm: unused
  *
  * Return 0 if the task has read and write to the object,
  * an error code otherwise
  */
 static int smack_key_permission(key_ref_t key_ref,
-				struct task_struct *context, key_perm_t perm)
+				struct task_security *context, key_perm_t perm)
 {
 	struct key *keyp;
 
@@ -2327,10 +2340,10 @@ static int smack_key_permission(key_ref_t key_ref,
 	/*
 	 * This should not occur
 	 */
-	if (context->act_as->security == NULL)
+	if (context->security == NULL)
 		return -EACCES;
 
-	return smk_access(context->act_as->security, keyp->security,
+	return smk_access(context->security, keyp->security,
 			  MAY_READWRITE);
 }
 #endif /* CONFIG_KEYS */
@@ -2430,6 +2443,7 @@ static struct security_operations smack_ops = {
 
 	.task_alloc_security = 		smack_task_alloc_security,
 	.task_free_security = 		smack_task_free_security,
+	.task_dup_security =		smack_task_dup_security,
 	.task_post_setuid =		cap_task_post_setuid,
 	.task_setpgid = 		smack_task_setpgid,
 	.task_getpgid = 		smack_task_getpgid,


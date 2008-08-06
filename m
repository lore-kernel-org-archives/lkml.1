Return-Path: <linux-kernel-owner+w=401wt.eu-S1763143AbYHFPvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763143AbYHFPvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759745AbYHFPic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:38:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757759AbYHFPiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:38:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/24] CRED: Detach the credentials from task_struct [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:00 +0100
Message-ID: <20080806153800.14351.26949.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detach the credentials from task_struct, duplicating them in copy_process()
and releasing them in __put_task_struct().

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 include/linux/cred.h       |   29 ++++++++++++++
 include/linux/init_task.h  |   16 -------
 include/linux/sched.h      |    1 
 include/linux/security.h   |   26 ++++++------
 kernel/Makefile            |    2 -
 kernel/cred.c              |   94 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c              |   24 +++--------
 security/capability.c      |    8 ++--
 security/security.c        |    8 ++--
 security/selinux/hooks.c   |   32 +++++++--------
 security/smack/smack_lsm.c |   20 +++++----
 11 files changed, 177 insertions(+), 83 deletions(-)
 create mode 100644 kernel/cred.c


diff --git a/include/linux/cred.h b/include/linux/cred.h
index 17ad725..a0fefc0 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -158,4 +158,33 @@ do {						\
 	*(_gid) = current->cred->fsgid;		\
 } while(0)
 
+extern void __put_cred(struct cred *);
+extern int copy_creds(struct task_struct *, unsigned long);
+
+/**
+ * get_cred - Get a reference on a set of credentials
+ * @cred: The credentials to reference
+ *
+ * Get a reference on the specified set of credentials.  The caller must
+ * release the reference.
+ */
+static inline struct cred *get_cred(struct cred *cred)
+{
+	atomic_inc(&cred->usage);
+	return cred;
+}
+
+/**
+ * put_cred - Release a reference to a set of credentials
+ * @cred: The credentials to release
+ *
+ * Release a reference to a set of credentials, deleting them when the last ref
+ * is released.
+ */
+static inline void put_cred(struct cred *cred)
+{
+	if (atomic_dec_and_test(&(cred)->usage))
+		__put_cred(cred);
+}
+
 #endif /* _LINUX_CRED_H */
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 0abd837..234c24a 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -115,19 +115,6 @@ extern struct group_info init_groups;
 
 extern struct cred init_cred;
 
-#define INIT_CRED(p)						\
-{								\
-	.usage			= ATOMIC_INIT(3),		\
-	.securebits		= SECUREBITS_DEFAULT,		\
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
@@ -162,8 +149,7 @@ extern struct cred init_cred;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	.__temp_cred	= INIT_CRED(tsk.__temp_cred),			\
-	.cred		= &tsk.__temp_cred,				\
+	.cred		= &init_cred,					\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 304ede6..041b153 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1109,7 +1109,6 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	struct cred __temp_cred __deprecated; /* temporary credentials to be removed */
 	struct cred *cred;	/* actual/objective task credentials */
 
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
diff --git a/include/linux/security.h b/include/linux/security.h
index c3eed5a..a0f5886 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -589,15 +589,15 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	manual page for definitions of the @clone_flags.
  *	@clone_flags contains the flags indicating what should be shared.
  *	Return 0 if permission is granted.
- * @task_alloc_security:
- *	@p contains the task_struct for child process.
- *	Allocate and attach a security structure to the p->security field. The
- *	security field is initialized to NULL when the task structure is
+ * @cred_alloc_security:
+ *	@cred contains the cred struct for child process.
+ *	Allocate and attach a security structure to the cred->security field.
+ *	The security field is initialized to NULL when the task structure is
  *	allocated.
  *	Return 0 if operation was successful.
- * @task_free_security:
- *	@p contains the task_struct for process.
- *	Deallocate and clear the p->security field.
+ * @cred_free:
+ *	@cred points to the credentials.
+ *	Deallocate and clear the cred->security field in a set of credentials.
  * @task_setuid:
  *	Check permission before setting one or more of the user identity
  *	attributes of the current process.  The @flags parameter indicates
@@ -1401,8 +1401,8 @@ struct security_operations {
 	int (*dentry_open) (struct file *file);
 
 	int (*task_create) (unsigned long clone_flags);
-	int (*task_alloc_security) (struct task_struct *p);
-	void (*task_free_security) (struct task_struct *p);
+	int (*cred_alloc_security) (struct cred *cred);
+	void (*cred_free) (struct cred *cred);
 	int (*task_setuid) (uid_t id0, uid_t id1, uid_t id2, int flags);
 	int (*task_post_setuid) (uid_t old_ruid /* or fsuid */ ,
 				 uid_t old_euid, uid_t old_suid, int flags);
@@ -1659,8 +1659,8 @@ int security_file_send_sigiotask(struct task_struct *tsk,
 int security_file_receive(struct file *file);
 int security_dentry_open(struct file *file);
 int security_task_create(unsigned long clone_flags);
-int security_task_alloc(struct task_struct *p);
-void security_task_free(struct task_struct *p);
+int security_cred_alloc(struct cred *cred);
+void security_cred_free(struct cred *cred);
 int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags);
 int security_task_post_setuid(uid_t old_ruid, uid_t old_euid,
 			      uid_t old_suid, int flags);
@@ -2170,12 +2170,12 @@ static inline int security_task_create(unsigned long clone_flags)
 	return 0;
 }
 
-static inline int security_task_alloc(struct task_struct *p)
+static inline int security_cred_alloc(struct cred *cred)
 {
 	return 0;
 }
 
-static inline void security_task_free(struct task_struct *p)
+static inline void security_cred_free(struct cred *cred)
 { }
 
 static inline int security_task_setuid(uid_t id0, uid_t id1, uid_t id2,
diff --git a/kernel/Makefile b/kernel/Makefile
index 4e1d7df..8e6ab9c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
-	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
+	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o
 
 CFLAGS_REMOVE_sched.o = -mno-spe
 
diff --git a/kernel/cred.c b/kernel/cred.c
new file mode 100644
index 0000000..2195841
--- /dev/null
+++ b/kernel/cred.c
@@ -0,0 +1,94 @@
+/* Task credentials management
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/cred.h>
+#include <linux/sched.h>
+#include <linux/key.h>
+#include <linux/keyctl.h>
+#include <linux/init_task.h>
+#include <linux/security.h>
+
+/*
+ * The initial credentials for the initial task
+ */
+struct cred init_cred = {
+	.usage			= ATOMIC_INIT(3),
+	.securebits		= SECUREBITS_DEFAULT,
+	.cap_inheritable	= CAP_INIT_INH_SET,
+	.cap_permitted		= CAP_FULL_SET,
+	.cap_effective		= CAP_INIT_EFF_SET,
+	.cap_bset		= CAP_INIT_BSET,
+	.user			= INIT_USER,
+	.group_info		= &init_groups,
+};
+
+/*
+ * The RCU callback to actually dispose of a set of credentials
+ */
+static void put_cred_rcu(struct rcu_head *rcu)
+{
+	struct cred *cred = container_of(rcu, struct cred, rcu);
+
+	BUG_ON(atomic_read(&cred->usage) != 0);
+
+	key_put(cred->thread_keyring);
+	key_put(cred->request_key_auth);
+	put_group_info(cred->group_info);
+	free_uid(cred->user);
+	security_cred_free(cred);
+	kfree(cred);
+}
+
+/**
+ * __put_cred - Destroy a set of credentials
+ * @sec: The record to release
+ *
+ * Destroy a set of credentials on which no references remain.
+ */
+void __put_cred(struct cred *cred)
+{
+	call_rcu(&cred->rcu, put_cred_rcu);
+}
+EXPORT_SYMBOL(__put_cred);
+
+/*
+ * Copy credentials for the new process created by fork()
+ */
+int copy_creds(struct task_struct *p, unsigned long clone_flags)
+{
+	struct cred *pcred;
+	int ret;
+
+	pcred = kmemdup(p->cred, sizeof(*p->cred), GFP_KERNEL);
+	if (!pcred)
+		return -ENOMEM;
+
+#ifdef CONFIG_SECURITY
+	pcred->security = NULL;
+#endif
+
+	ret = security_cred_alloc(pcred);
+	if (ret < 0) {
+		kfree(pcred);
+		return ret;
+	}
+
+	atomic_set(&pcred->usage, 1);
+	get_group_info(pcred->group_info);
+	get_uid(pcred->user);
+	key_get(pcred->thread_keyring);
+	key_get(pcred->request_key_auth);
+
+	/* RCU assignment is unneeded here as no-one can have accessed this
+	 * pointer yet, barring us */
+	p->cred = pcred;
+	return 0;
+}
diff --git a/kernel/fork.c b/kernel/fork.c
index be0c716..8993a45 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -145,9 +145,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
-	security_task_free(tsk);
-	free_uid(tsk->__temp_cred.user);
-	put_group_info(tsk->__temp_cred.group_info);
+	put_cred(tsk->cred);
 	delayacct_tsk_free(tsk);
 
 	if (!profile_handoff_task(tsk))
@@ -938,7 +936,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
-	p->cred = &p->__temp_cred;
 	retval = -EAGAIN;
 	if (atomic_read(&p->cred->user->processes) >=
 			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
@@ -947,9 +944,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 			goto bad_fork_free;
 	}
 
-	atomic_inc(&p->cred->user->__count);
-	atomic_inc(&p->cred->user->processes);
-	get_group_info(p->cred->group_info);
+	retval = copy_creds(p, clone_flags);
+	if (retval < 0)
+		goto bad_fork_free;
 
 	/*
 	 * If multiple threads are within copy_process(), then this check
@@ -1007,9 +1004,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	do_posix_clock_monotonic_gettime(&p->start_time);
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
-#ifdef CONFIG_SECURITY
-	p->cred->security = NULL;
-#endif
 	p->io_context = NULL;
 	p->audit_context = NULL;
 	cgroup_fork(p);
@@ -1054,10 +1048,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
 
-	if ((retval = security_task_alloc(p)))
-		goto bad_fork_cleanup_policy;
 	if ((retval = audit_alloc(p)))
-		goto bad_fork_cleanup_security;
+		goto bad_fork_cleanup_policy;
 	/* copy all the process information */
 	if ((retval = copy_semundo(clone_flags, p)))
 		goto bad_fork_cleanup_audit;
@@ -1270,8 +1262,6 @@ bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_audit:
 	audit_free(p);
-bad_fork_cleanup_security:
-	security_task_free(p);
 bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
@@ -1284,9 +1274,7 @@ bad_fork_cleanup_cgroup:
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-	put_group_info(p->cred->group_info);
-	atomic_dec(&p->cred->user->processes);
-	free_uid(p->cred->user);
+	put_cred(p->cred);
 bad_fork_free:
 	free_task(p);
 fork_out:
diff --git a/security/capability.c b/security/capability.c
index 2458748..6c4b513 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -340,12 +340,12 @@ static int cap_task_create(unsigned long clone_flags)
 	return 0;
 }
 
-static int cap_task_alloc_security(struct task_struct *p)
+static int cap_cred_alloc_security(struct cred *cred)
 {
 	return 0;
 }
 
-static void cap_task_free_security(struct task_struct *p)
+static void cap_cred_free(struct cred *cred)
 {
 }
 
@@ -890,8 +890,8 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, file_receive);
 	set_to_cap_if_null(ops, dentry_open);
 	set_to_cap_if_null(ops, task_create);
-	set_to_cap_if_null(ops, task_alloc_security);
-	set_to_cap_if_null(ops, task_free_security);
+	set_to_cap_if_null(ops, cred_alloc_security);
+	set_to_cap_if_null(ops, cred_free);
 	set_to_cap_if_null(ops, task_setuid);
 	set_to_cap_if_null(ops, task_post_setuid);
 	set_to_cap_if_null(ops, task_setgid);
diff --git a/security/security.c b/security/security.c
index c2203f5..23c3c91 100644
--- a/security/security.c
+++ b/security/security.c
@@ -602,14 +602,14 @@ int security_task_create(unsigned long clone_flags)
 	return security_ops->task_create(clone_flags);
 }
 
-int security_task_alloc(struct task_struct *p)
+int security_cred_alloc(struct cred *cred)
 {
-	return security_ops->task_alloc_security(p);
+	return security_ops->cred_alloc_security(cred);
 }
 
-void security_task_free(struct task_struct *p)
+void security_cred_free(struct cred *cred)
 {
-	security_ops->task_free_security(p);
+	security_ops->cred_free(cred);
 }
 
 int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3e8900e..1efc990 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -157,7 +157,7 @@ static int selinux_secmark_enabled(void)
 
 /* Allocate and free functions for each kind of security blob. */
 
-static int task_alloc_security(struct task_struct *task)
+static int cred_alloc_security(struct cred *cred)
 {
 	struct task_security_struct *tsec;
 
@@ -166,18 +166,11 @@ static int task_alloc_security(struct task_struct *task)
 		return -ENOMEM;
 
 	tsec->osid = tsec->sid = SECINITSID_UNLABELED;
-	task->cred->security = tsec;
+	cred->security = tsec;
 
 	return 0;
 }
 
-static void task_free_security(struct task_struct *task)
-{
-	struct task_security_struct *tsec = task->cred->security;
-	task->cred->security = NULL;
-	kfree(tsec);
-}
-
 static int inode_alloc_security(struct inode *inode)
 {
 	struct task_security_struct *tsec = current->cred->security;
@@ -3188,17 +3181,17 @@ static int selinux_task_create(unsigned long clone_flags)
 	return task_has_perm(current, current, PROCESS__FORK);
 }
 
-static int selinux_task_alloc_security(struct task_struct *tsk)
+static int selinux_cred_alloc_security(struct cred *cred)
 {
 	struct task_security_struct *tsec1, *tsec2;
 	int rc;
 
 	tsec1 = current->cred->security;
 
-	rc = task_alloc_security(tsk);
+	rc = cred_alloc_security(cred);
 	if (rc)
 		return rc;
-	tsec2 = tsk->cred->security;
+	tsec2 = cred->security;
 
 	tsec2->osid = tsec1->osid;
 	tsec2->sid = tsec1->sid;
@@ -3212,9 +3205,14 @@ static int selinux_task_alloc_security(struct task_struct *tsk)
 	return 0;
 }
 
-static void selinux_task_free_security(struct task_struct *tsk)
+/*
+ * detach and free the LSM part of a set of credentials
+ */
+static void selinux_cred_free(struct cred *cred)
 {
-	task_free_security(tsk);
+	struct task_security_struct *tsec = cred->security;
+	cred->security = NULL;
+	kfree(tsec);
 }
 
 static int selinux_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
@@ -5446,8 +5444,8 @@ static struct security_operations selinux_ops = {
 	.dentry_open =			selinux_dentry_open,
 
 	.task_create =			selinux_task_create,
-	.task_alloc_security =		selinux_task_alloc_security,
-	.task_free_security =		selinux_task_free_security,
+	.cred_alloc_security =		selinux_cred_alloc_security,
+	.cred_free =			selinux_cred_free,
 	.task_setuid =			selinux_task_setuid,
 	.task_post_setuid =		selinux_task_post_setuid,
 	.task_setgid =			selinux_task_setgid,
@@ -5577,7 +5575,7 @@ static __init int selinux_init(void)
 	printk(KERN_INFO "SELinux:  Initializing.\n");
 
 	/* Set the security state for the initial task. */
-	if (task_alloc_security(current))
+	if (cred_alloc_security(current->cred))
 		panic("SELinux:  Failed to initialize initial task.\n");
 	tsec = current->cred->security;
 	tsec->osid = tsec->sid = SECINITSID_KERNEL;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ccded56..7da592f 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -975,8 +975,8 @@ static int smack_file_receive(struct file *file)
  */
 
 /**
- * smack_task_alloc_security - "allocate" a task blob
- * @tsk: the task in need of a blob
+ * smack_cred_alloc_security - "allocate" a task cred blob
+ * @cred: the task creds in need of a blob
  *
  * Smack isn't using copies of blobs. Everyone
  * points to an immutable list. No alloc required.
@@ -984,24 +984,24 @@ static int smack_file_receive(struct file *file)
  *
  * Always returns 0
  */
-static int smack_task_alloc_security(struct task_struct *tsk)
+static int smack_cred_alloc_security(struct cred *cred)
 {
-	tsk->cred->security = current->cred->security;
+	cred->security = current->cred->security;
 
 	return 0;
 }
 
 /**
- * smack_task_free_security - "free" a task blob
- * @task: the task with the blob
+ * smack_cred_free - "free" task-level security credentials
+ * @cred: the credentials in question
  *
  * Smack isn't using copies of blobs. Everyone
  * points to an immutable list. The blobs never go away.
  * There is no leak here.
  */
-static void smack_task_free_security(struct task_struct *task)
+static void smack_cred_free(struct cred *cred)
 {
-	task->cred->security = NULL;
+	cred->security = NULL;
 }
 
 /**
@@ -2627,8 +2627,8 @@ struct security_operations smack_ops = {
 	.file_send_sigiotask = 		smack_file_send_sigiotask,
 	.file_receive = 		smack_file_receive,
 
-	.task_alloc_security = 		smack_task_alloc_security,
-	.task_free_security = 		smack_task_free_security,
+	.cred_alloc_security = 		smack_cred_alloc_security,
+	.cred_free =			smack_cred_free,
 	.task_post_setuid =		cap_task_post_setuid,
 	.task_setpgid = 		smack_task_setpgid,
 	.task_getpgid = 		smack_task_getpgid,


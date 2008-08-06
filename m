Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbYHFPpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbYHFPpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964831AbYHFPkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:40:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964811AbYHFPj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:39:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/24] CRED: Differentiate objective and effective subjective
	credentials on a task [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:39:07 +0100
Message-ID: <20080806153907.14351.98173.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Differentiate the objective and real subjective credentials from the effective
subjective credentials on a task by introducing a second credentials pointer
into the task_struct.

task_struct::real_cred then refers to the objective and apparent real
subjective credentials of a task, as perceived by the other tasks in the
system.

task_struct::cred then refers to the effective subjective credentials of a
task, as used by that task when it's actually running.  These are not visible
to the other tasks in the system.

__task_cred(task) then refers to the objective/real credentials of the task in
question.

current_cred() refers to the effective subjective credentials of the current
task.

prepare_creds() uses the objective creds as a base and commit_creds() changes
both pointers in the task_struct (indeed commit_creds() requires them to be the
same).

override_creds() and revert_creds() change the subjective creds pointer only,
and the former returns the old subjective creds.  These are used by NFSD,
faccessat() and do_coredump(), and will by used by CacheFiles.

In SELinux, current_has_perm() is provided as an alternative to
task_has_perm().  This uses the effective subjective context of current,
whereas task_has_perm() uses the objective/real context of the subject.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfsd/auth.c            |    5 +++
 include/linux/cred.h      |   29 ++++++++++----------
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    5 +++
 kernel/cred.c             |   38 ++++++++++++++++++--------
 kernel/fork.c             |    6 +++-
 security/selinux/hooks.c  |   65 ++++++++++++++++++++++++++++-----------------
 7 files changed, 95 insertions(+), 54 deletions(-)


diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 836ffa1..0184fe9 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -34,6 +34,8 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 	int flags = nfsexp_flags(rqstp, exp);
 	int ret;
 
+	/* discard any old override before preparing the new set */
+	revert_creds(get_cred(current->real_cred));
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
@@ -82,7 +84,8 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 	else
 		new->cap_effective = cap_raise_nfsd_set(new->cap_effective,
 							new->cap_permitted);
-	return commit_creds(new);
+	put_cred(override_creds(new));
+	return 0;
 
 oom:
 	ret = -ENOMEM;
diff --git a/include/linux/cred.h b/include/linux/cred.h
index c508f4d..7efcecb 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -146,8 +146,8 @@ extern struct cred *prepare_exec_creds(void);
 extern struct cred *prepare_usermodehelper_creds(void);
 extern int commit_creds(struct cred *);
 extern void abort_creds(struct cred *);
-extern const struct cred *override_creds(const struct cred *) __deprecated;
-extern void revert_creds(const struct cred *) __deprecated;
+extern const struct cred *override_creds(const struct cred *);
+extern void revert_creds(const struct cred *);
 extern void __init cred_init(void);
 
 /**
@@ -192,32 +192,32 @@ static inline void put_cred(const struct cred *_cred)
 }
 
 /**
- * current_cred - Access the current task's credentials
+ * current_cred - Access the current task's subjective credentials
  *
- * Access the credentials of the current task.
+ * Access the subjective credentials of the current task.
  */
 #define current_cred() \
 	(current->cred)
 
 /**
- * __task_cred - Access another task's credentials
+ * __task_cred - Access a task's objective credentials
  * @task: The task to query
  *
- * Access the credentials of another task.  The caller must hold the
- * RCU readlock.
+ * Access the objective credentials of a task.  The caller must hold the RCU
+ * readlock.
  *
  * The caller must make sure task doesn't go away, either by holding a ref on
  * task or by holding tasklist_lock to prevent it from being unlinked.
  */
 #define __task_cred(task) \
-	((const struct cred *)(rcu_dereference((task)->cred)))
+	((const struct cred *)(rcu_dereference((task)->real_cred)))
 
 /**
- * get_task_cred - Get another task's credentials
+ * get_task_cred - Get another task's objective credentials
  * @task: The task to query
  *
- * Get the credentials of a task, pinning them so that they can't go away.
- * Accessing a task's credentials directly is not permitted.
+ * Get the objective credentials of a task, pinning them so that they can't go
+ * away.  Accessing a task's credentials directly is not permitted.
  *
  * The caller must make sure task doesn't go away, either by holding a ref on
  * task or by holding tasklist_lock to prevent it from being unlinked.
@@ -233,10 +233,11 @@ static inline void put_cred(const struct cred *_cred)
 })
 
 /**
- * get_current_cred - Get the current task's credentials
+ * get_current_cred - Get the current task's subjective credentials
  *
- * Get the credentials of the current task, pinning them so that they can't go
- * away.  Accessing the current task's credentials directly is not permitted.
+ * Get the subjective credentials of the current task, pinning them so that
+ * they can't go away.  Accessing the current task's credentials directly is
+ * not permitted.
  */
 #define get_current_cred()				\
 	(get_cred(current_cred()))
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index e0cc816..edf0285 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -149,6 +149,7 @@ extern struct cred init_cred;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
+	.real_cred	= &init_cred,					\
 	.cred		= &init_cred,					\
 	.cred_exec_mutex =						\
 		 __MUTEX_INITIALIZER(tsk.cred_exec_mutex),		\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index fd1126a..3b1001d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1103,7 +1103,10 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	const struct cred *cred;	/* actual/objective task credentials (COW) */
+	const struct cred *real_cred;	/* objective and real subjective task
+					 * credentials (COW) */
+	const struct cred *cred;	/* effective (overridable) subjective task
+					 * credentials (COW) */
 	struct mutex cred_exec_mutex;	/* execve vs ptrace cred calculation mutex */
 
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
diff --git a/kernel/cred.c b/kernel/cred.c
index 319614d..eff48a4 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -35,7 +35,7 @@ static struct thread_group_cred init_tgcred = {
  * The initial credentials for the initial task
  */
 struct cred init_cred = {
-	.usage			= ATOMIC_INIT(3),
+	.usage			= ATOMIC_INIT(4),
 	.securebits		= SECUREBITS_DEFAULT,
 	.cap_inheritable	= CAP_INIT_INH_SET,
 	.cap_permitted		= CAP_FULL_SET,
@@ -133,6 +133,8 @@ struct cred *alloc_creds(const struct cred *old, gfp_t gfp)
  * prepare a new copy, which the caller then modifies and then commits by
  * calling commit_creds().
  *
+ * Preparation involves making a copy of the objective creds for modification.
+ *
  * Returns a pointer to the new creds-to-be if successful, NULL otherwise.
  *
  * Call commit_creds() or abort_creds() to clean up.
@@ -143,7 +145,7 @@ struct cred *prepare_creds(void)
 	const struct cred *old;
 	struct cred *new;
 
-	BUG_ON(atomic_read(&task->cred->usage) < 1);
+	BUG_ON(atomic_read(&task->real_cred->usage) < 1);
 
 	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
 	if (!new)
@@ -275,6 +277,9 @@ error:
  *
  * We share if we can, but under some circumstances we have to generate a new
  * set.
+ *
+ * The new process gets the current process's subjective credentials as its
+ * objective and subjective credentials
  */
 int copy_creds(struct task_struct *p, unsigned long clone_flags)
 {
@@ -284,6 +289,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	mutex_init(&p->cred_exec_mutex);
 
 	if (!p->cred->thread_keyring && clone_flags & CLONE_THREAD) {
+		p->real_cred = get_cred(p->cred);
 		get_cred(p->cred);
 		return 0;
 	}
@@ -322,7 +328,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 #endif
 
 	atomic_inc(&new->user->processes);
-	p->cred = new;
+	p->cred = p->real_cred = get_cred(new);
 	return 0;
 }
 
@@ -331,7 +337,9 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
  * @new: The credentials to be assigned
  *
  * Install a new set of credentials to the current task, using RCU to replace
- * the old set.
+ * the old set.  Both the objective and the subjective credentials pointers are
+ * updated.  This function may not be called if the subjective credentials are
+ * in an overridden state.
  *
  * This function eats the caller's reference to the new credentials.
  *
@@ -343,12 +351,15 @@ int commit_creds(struct cred *new)
 	struct task_struct *task = current;
 	const struct cred *old;
 
+	BUG_ON(task->cred != task->real_cred);
+	BUG_ON(atomic_read(&task->real_cred->usage) < 2);
 	BUG_ON(atomic_read(&new->usage) < 1);
-	BUG_ON(atomic_read(&task->cred->usage) < 1);
 
-	old = task->cred;
+	old = task->real_cred;
 	security_commit_creds(new, old);
 
+	get_cred(new); /* we will require a ref for the subj creds too */
+
 	/* dumpability changes */
 	if (old->euid != new->euid ||
 	    old->egid != new->egid ||
@@ -374,6 +385,7 @@ int commit_creds(struct cred *new)
 	 */
 	if (new->user != old->user)
 		atomic_inc(&new->user->processes);
+	rcu_assign_pointer(task->real_cred, new);
 	rcu_assign_pointer(task->cred, new);
 	if (new->user != old->user)
 		atomic_dec(&old->user->processes);
@@ -393,6 +405,8 @@ int commit_creds(struct cred *new)
 	    new->fsgid != old->fsgid)
 		proc_id_connector(task, PROC_EVENT_GID);
 
+	/* release the old obj and subj refs both */
+	put_cred(old);
 	put_cred(old);
 	return 0;
 }
@@ -413,11 +427,11 @@ void abort_creds(struct cred *new)
 EXPORT_SYMBOL(abort_creds);
 
 /**
- * override_creds - Temporarily override the current process's credentials
+ * override_creds - Override the current process's subjective credentials
  * @new: The credentials to be assigned
  *
- * Install a set of temporary override credentials on the current process,
- * returning the old set for later reversion.
+ * Install a set of temporary override subjective credentials on the current
+ * process, returning the old set for later reversion.
  */
 const struct cred *override_creds(const struct cred *new)
 {
@@ -429,11 +443,11 @@ const struct cred *override_creds(const struct cred *new)
 EXPORT_SYMBOL(override_creds);
 
 /**
- * revert_creds - Revert a temporary credentials override
+ * revert_creds - Revert a temporary subjective credentials override
  * @old: The credentials to be restored
  *
- * Revert a temporary set of override credentials to an old set, discarding the
- * override set.
+ * Revert a temporary set of override subjective credentials to an old set,
+ * discarding the override set.
  */
 extern void revert_creds(const struct cred *old)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index a7cf83a..e65f424 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -145,6 +145,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
+	put_cred(tsk->real_cred);
 	put_cred(tsk->cred);
 	delayacct_tsk_free(tsk);
 
@@ -929,10 +930,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
 	retval = -EAGAIN;
-	if (atomic_read(&p->cred->user->processes) >=
+	if (atomic_read(&p->real_cred->user->processes) >=
 			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
-		    p->cred->user != current->nsproxy->user_ns->root_user)
+		    p->real_cred->user != current->nsproxy->user_ns->root_user)
 			goto bad_fork_free;
 	}
 
@@ -1263,6 +1264,7 @@ bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
 	atomic_dec(&p->cred->user->processes);
+	put_cred(p->real_cred);
 	put_cred(p->cred);
 bad_fork_free:
 	free_task(p);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f934830..14067df 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -160,7 +160,7 @@ static int selinux_secmark_enabled(void)
  */
 static void cred_init_security(void)
 {
-	struct cred *cred = (struct cred *) current->cred;
+	struct cred *cred = (struct cred *) current->real_cred;
 	struct task_security_struct *tsec;
 
 	tsec = kzalloc(sizeof(struct task_security_struct), GFP_KERNEL);
@@ -183,7 +183,7 @@ static inline u32 cred_sid(const struct cred *cred)
 }
 
 /*
- * get the security ID of a task
+ * get the objective security ID of a task
  */
 static inline u32 task_sid(const struct task_struct *task)
 {
@@ -196,7 +196,7 @@ static inline u32 task_sid(const struct task_struct *task)
 }
 
 /*
- * get the security ID of the current task
+ * get the subjective security ID of the current task
  */
 static inline u32 current_sid(void)
 {
@@ -1393,6 +1393,7 @@ static int cred_has_perm(const struct cred *actor,
  * Check permission between a pair of tasks, e.g. signal checks,
  * fork check, ptrace check, etc.
  * tsk1 is the actor and tsk2 is the target
+ * - this uses the default subjective creds of tsk1
  */
 static int task_has_perm(const struct task_struct *tsk1,
 			 const struct task_struct *tsk2,
@@ -1408,6 +1409,22 @@ static int task_has_perm(const struct task_struct *tsk1,
 	return avc_has_perm(sid1, sid2, SECCLASS_PROCESS, perms, NULL);
 }
 
+/*
+ * Check permission between current and another task, e.g. signal checks,
+ * fork check, ptrace check, etc.
+ * current is the actor and tsk2 is the target
+ * - this uses current's subjective creds
+ */
+static int current_has_perm(const struct task_struct *tsk,
+			    u32 perms)
+{
+	u32 sid, tsid;
+
+	sid = current_sid();
+	tsid = task_sid(tsk);
+	return avc_has_perm(sid, tsid, SECCLASS_PROCESS, perms, NULL);
+}
+
 #if CAP_LAST_CAP > 63
 #error Fix SELinux to handle capabilities > 63.
 #endif
@@ -1798,7 +1815,7 @@ static int selinux_ptrace_may_access(struct task_struct *child,
 		return avc_has_perm(sid, csid, SECCLASS_FILE, FILE__READ, NULL);
 	}
 
-	return task_has_perm(current, child, PROCESS__PTRACE);
+	return current_has_perm(child, PROCESS__PTRACE);
 }
 
 static int selinux_ptrace_traceme(struct task_struct *parent)
@@ -1817,7 +1834,7 @@ static int selinux_capget(struct task_struct *target, kernel_cap_t *effective,
 {
 	int error;
 
-	error = task_has_perm(current, target, PROCESS__GETCAP);
+	error = current_has_perm(target, PROCESS__GETCAP);
 	if (error)
 		return error;
 
@@ -3076,7 +3093,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 		} else if (!vma->vm_file &&
 			   vma->vm_start <= vma->vm_mm->start_stack &&
 			   vma->vm_end >= vma->vm_mm->start_stack) {
-			rc = task_has_perm(current, current, PROCESS__EXECSTACK);
+			rc = current_has_perm(current, PROCESS__EXECSTACK);
 		} else if (vma->vm_file && vma->anon_vma) {
 			/*
 			 * We are making executable a file mapping that has
@@ -3225,7 +3242,7 @@ static int selinux_task_create(unsigned long clone_flags)
 	if (rc)
 		return rc;
 
-	return task_has_perm(current, current, PROCESS__FORK);
+	return current_has_perm(current, PROCESS__FORK);
 }
 
 /*
@@ -3290,17 +3307,17 @@ static int selinux_task_setgid(gid_t id0, gid_t id1, gid_t id2, int flags)
 
 static int selinux_task_setpgid(struct task_struct *p, pid_t pgid)
 {
-	return task_has_perm(current, p, PROCESS__SETPGID);
+	return current_has_perm(p, PROCESS__SETPGID);
 }
 
 static int selinux_task_getpgid(struct task_struct *p)
 {
-	return task_has_perm(current, p, PROCESS__GETPGID);
+	return current_has_perm(p, PROCESS__GETPGID);
 }
 
 static int selinux_task_getsid(struct task_struct *p)
 {
-	return task_has_perm(current, p, PROCESS__GETSESSION);
+	return current_has_perm(p, PROCESS__GETSESSION);
 }
 
 static void selinux_task_getsecid(struct task_struct *p, u32 *secid)
@@ -3322,7 +3339,7 @@ static int selinux_task_setnice(struct task_struct *p, int nice)
 	if (rc)
 		return rc;
 
-	return task_has_perm(current, p, PROCESS__SETSCHED);
+	return current_has_perm(p, PROCESS__SETSCHED);
 }
 
 static int selinux_task_setioprio(struct task_struct *p, int ioprio)
@@ -3333,12 +3350,12 @@ static int selinux_task_setioprio(struct task_struct *p, int ioprio)
 	if (rc)
 		return rc;
 
-	return task_has_perm(current, p, PROCESS__SETSCHED);
+	return current_has_perm(p, PROCESS__SETSCHED);
 }
 
 static int selinux_task_getioprio(struct task_struct *p)
 {
-	return task_has_perm(current, p, PROCESS__GETSCHED);
+	return current_has_perm(p, PROCESS__GETSCHED);
 }
 
 static int selinux_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
@@ -3355,7 +3372,7 @@ static int selinux_task_setrlimit(unsigned int resource, struct rlimit *new_rlim
 	   later be used as a safe reset point for the soft limit
 	   upon context transitions.  See selinux_bprm_committing_creds. */
 	if (old_rlim->rlim_max != new_rlim->rlim_max)
-		return task_has_perm(current, current, PROCESS__SETRLIMIT);
+		return current_has_perm(current, PROCESS__SETRLIMIT);
 
 	return 0;
 }
@@ -3368,17 +3385,17 @@ static int selinux_task_setscheduler(struct task_struct *p, int policy, struct s
 	if (rc)
 		return rc;
 
-	return task_has_perm(current, p, PROCESS__SETSCHED);
+	return current_has_perm(p, PROCESS__SETSCHED);
 }
 
 static int selinux_task_getscheduler(struct task_struct *p)
 {
-	return task_has_perm(current, p, PROCESS__GETSCHED);
+	return current_has_perm(p, PROCESS__GETSCHED);
 }
 
 static int selinux_task_movememory(struct task_struct *p)
 {
-	return task_has_perm(current, p, PROCESS__SETSCHED);
+	return current_has_perm(p, PROCESS__SETSCHED);
 }
 
 static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
@@ -3399,7 +3416,7 @@ static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
 		rc = avc_has_perm(secid, task_sid(p),
 				  SECCLASS_PROCESS, perm, NULL);
 	else
-		rc = task_has_perm(current, p, perm);
+		rc = current_has_perm(p, perm);
 	return rc;
 }
 
@@ -5154,7 +5171,7 @@ static int selinux_getprocattr(struct task_struct *p,
 	unsigned len;
 
 	if (current != p) {
-		error = task_has_perm(current, p, PROCESS__GETATTR);
+		error = current_has_perm(p, PROCESS__GETATTR);
 		if (error)
 			return error;
 	}
@@ -5213,15 +5230,15 @@ static int selinux_setprocattr(struct task_struct *p,
 	 * above restriction is ever removed.
 	 */
 	if (!strcmp(name, "exec"))
-		error = task_has_perm(current, p, PROCESS__SETEXEC);
+		error = current_has_perm(p, PROCESS__SETEXEC);
 	else if (!strcmp(name, "fscreate"))
-		error = task_has_perm(current, p, PROCESS__SETFSCREATE);
+		error = current_has_perm(p, PROCESS__SETFSCREATE);
 	else if (!strcmp(name, "keycreate"))
-		error = task_has_perm(current, p, PROCESS__SETKEYCREATE);
+		error = current_has_perm(p, PROCESS__SETKEYCREATE);
 	else if (!strcmp(name, "sockcreate"))
-		error = task_has_perm(current, p, PROCESS__SETSOCKCREATE);
+		error = current_has_perm(p, PROCESS__SETSOCKCREATE);
 	else if (!strcmp(name, "current"))
-		error = task_has_perm(current, p, PROCESS__SETCURRENT);
+		error = current_has_perm(p, PROCESS__SETCURRENT);
 	else
 		error = -EINVAL;
 	if (error)


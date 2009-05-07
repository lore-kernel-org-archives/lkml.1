Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbZEGJvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbZEGJvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbZEGJu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:50:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51141 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbZEGJu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:50:58 -0400
Date: Thu, 7 May 2009 11:49:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [patch 1/2] ptrace, security: rename ptrace_may_access =>
	ptrace_access_check
Message-ID: <20090507094947.GA4911@elte.hu>
References: <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu> <20090507093124.GA355@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507093124.GA355@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ptrace_may_access() methods are named confusingly - some 
variants return a bool, while the security subsystem methods have a 
retval convention.

Rename it to ptrace_access_check, to reduce the confusion factor. A 
followup patch eliminates the bool usage.

[ Impact: cleanup, no code changed ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
LKML-Reference: <20090507084943.GB19133@elte.hu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/array.c            |    2 +-
 fs/proc/base.c             |   10 +++++-----
 fs/proc/task_mmu.c         |    2 +-
 include/linux/ptrace.h     |    4 ++--
 include/linux/security.h   |   14 +++++++-------
 kernel/ptrace.c            |   10 +++++-----
 security/capability.c      |    2 +-
 security/commoncap.c       |    4 ++--
 security/root_plug.c       |    2 +-
 security/security.c        |    4 ++--
 security/selinux/hooks.c   |    6 +++---
 security/smack/smack_lsm.c |    8 ++++----
 12 files changed, 34 insertions(+), 34 deletions(-)

Index: linux/fs/proc/array.c
===================================================================
--- linux.orig/fs/proc/array.c
+++ linux/fs/proc/array.c
@@ -366,7 +366,7 @@ static int do_task_stat(struct seq_file 
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
-	permitted = ptrace_may_access(task, PTRACE_MODE_READ);
+	permitted = ptrace_access_check(task, PTRACE_MODE_READ);
 	mm = get_task_mm(task);
 	if (mm) {
 		vsize = task_vsize(mm);
Index: linux/fs/proc/base.c
===================================================================
--- linux.orig/fs/proc/base.c
+++ linux/fs/proc/base.c
@@ -222,7 +222,7 @@ static int check_mem_permission(struct t
 		rcu_read_lock();
 		match = (tracehook_tracer_task(task) == current);
 		rcu_read_unlock();
-		if (match && ptrace_may_access(task, PTRACE_MODE_ATTACH))
+		if (match && ptrace_access_check(task, PTRACE_MODE_ATTACH))
 			return 0;
 	}
 
@@ -242,7 +242,7 @@ struct mm_struct *mm_for_maps(struct tas
 	if (task->mm != mm)
 		goto out;
 	if (task->mm != current->mm &&
-	    __ptrace_may_access(task, PTRACE_MODE_READ) < 0)
+	    __ptrace_access_check(task, PTRACE_MODE_READ) < 0)
 		goto out;
 	task_unlock(task);
 	return mm;
@@ -322,7 +322,7 @@ static int proc_pid_wchan(struct task_st
 	wchan = get_wchan(task);
 
 	if (lookup_symbol_name(wchan, symname) < 0)
-		if (!ptrace_may_access(task, PTRACE_MODE_READ))
+		if (!ptrace_access_check(task, PTRACE_MODE_READ))
 			return 0;
 		else
 			return sprintf(buffer, "%lu", wchan);
@@ -559,7 +559,7 @@ static int proc_fd_access_allowed(struct
 	 */
 	task = get_proc_task(inode);
 	if (task) {
-		allowed = ptrace_may_access(task, PTRACE_MODE_READ);
+		allowed = ptrace_access_check(task, PTRACE_MODE_READ);
 		put_task_struct(task);
 	}
 	return allowed;
@@ -938,7 +938,7 @@ static ssize_t environ_read(struct file 
 	if (!task)
 		goto out_no_task;
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+	if (!ptrace_access_check(task, PTRACE_MODE_READ))
 		goto out;
 
 	ret = -ENOMEM;
Index: linux/fs/proc/task_mmu.c
===================================================================
--- linux.orig/fs/proc/task_mmu.c
+++ linux/fs/proc/task_mmu.c
@@ -656,7 +656,7 @@ static ssize_t pagemap_read(struct file 
 		goto out;
 
 	ret = -EACCES;
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+	if (!ptrace_access_check(task, PTRACE_MODE_READ))
 		goto out_task;
 
 	ret = -EINVAL;
Index: linux/include/linux/ptrace.h
===================================================================
--- linux.orig/include/linux/ptrace.h
+++ linux/include/linux/ptrace.h
@@ -99,9 +99,9 @@ extern void ptrace_fork(struct task_stru
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
-extern int __ptrace_may_access(struct task_struct *task, unsigned int mode);
+extern int __ptrace_access_check(struct task_struct *task, unsigned int mode);
 /* Returns true on success, false on denial. */
-extern bool ptrace_may_access(struct task_struct *task, unsigned int mode);
+extern bool ptrace_access_check(struct task_struct *task, unsigned int mode);
 
 static inline int ptrace_reparented(struct task_struct *child)
 {
Index: linux/include/linux/security.h
===================================================================
--- linux.orig/include/linux/security.h
+++ linux/include/linux/security.h
@@ -52,7 +52,7 @@ struct audit_krule;
 extern int cap_capable(struct task_struct *tsk, const struct cred *cred,
 		       int cap, int audit);
 extern int cap_settime(struct timespec *ts, struct timezone *tz);
-extern int cap_ptrace_may_access(struct task_struct *child, unsigned int mode);
+extern int cap_ptrace_access_check(struct task_struct *child, unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern int cap_capset(struct cred *new, const struct cred *old,
@@ -1209,7 +1209,7 @@ static inline void security_free_mnt_opt
  *	@alter contains the flag indicating whether changes are to be made.
  *	Return 0 if permission is granted.
  *
- * @ptrace_may_access:
+ * @ptrace_access_check:
  *	Check permission before allowing the current process to trace the
  *	@child process.
  *	Security modules may also want to perform a process tracing check
@@ -1224,7 +1224,7 @@ static inline void security_free_mnt_opt
  *	Check that the @parent process has sufficient permission to trace the
  *	current process before allowing the current process to present itself
  *	to the @parent process for tracing.
- *	The parent process will still have to undergo the ptrace_may_access
+ *	The parent process will still have to undergo the ptrace_access_check
  *	checks before it is allowed to trace this one.
  *	@parent contains the task_struct structure for debugger process.
  *	Return 0 if permission is granted.
@@ -1336,7 +1336,7 @@ static inline void security_free_mnt_opt
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
 
-	int (*ptrace_may_access) (struct task_struct *child, unsigned int mode);
+	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
 	int (*ptrace_traceme) (struct task_struct *parent);
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
@@ -1617,7 +1617,7 @@ extern int security_module_enable(struct
 extern int register_security(struct security_operations *ops);
 
 /* Security operations */
-int security_ptrace_may_access(struct task_struct *child, unsigned int mode);
+int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
 int security_capget(struct task_struct *target,
 		    kernel_cap_t *effective,
@@ -1798,10 +1798,10 @@ static inline int security_init(void)
 	return 0;
 }
 
-static inline int security_ptrace_may_access(struct task_struct *child,
+static inline int security_ptrace_access_check(struct task_struct *child,
 					     unsigned int mode)
 {
-	return cap_ptrace_may_access(child, mode);
+	return cap_ptrace_access_check(child, mode);
 }
 
 static inline int security_ptrace_traceme(struct task_struct *parent)
Index: linux/kernel/ptrace.c
===================================================================
--- linux.orig/kernel/ptrace.c
+++ linux/kernel/ptrace.c
@@ -127,7 +127,7 @@ int ptrace_check_attach(struct task_stru
 	return ret;
 }
 
-int __ptrace_may_access(struct task_struct *task, unsigned int mode)
+int __ptrace_access_check(struct task_struct *task, unsigned int mode)
 {
 	const struct cred *cred = current_cred(), *tcred;
 
@@ -162,14 +162,14 @@ int __ptrace_may_access(struct task_stru
 	if (!dumpable && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 
-	return security_ptrace_may_access(task, mode);
+	return security_ptrace_access_check(task, mode);
 }
 
-bool ptrace_may_access(struct task_struct *task, unsigned int mode)
+bool ptrace_access_check(struct task_struct *task, unsigned int mode)
 {
 	int err;
 	task_lock(task);
-	err = __ptrace_may_access(task, mode);
+	err = __ptrace_access_check(task, mode);
 	task_unlock(task);
 	return !err;
 }
@@ -217,7 +217,7 @@ repeat:
 	/* the same process cannot be attached many times */
 	if (task->ptrace & PT_PTRACED)
 		goto bad;
-	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
+	retval = __ptrace_access_check(task, PTRACE_MODE_ATTACH);
 	if (retval)
 		goto bad;
 
Index: linux/security/capability.c
===================================================================
--- linux.orig/security/capability.c
+++ linux/security/capability.c
@@ -863,7 +863,7 @@ struct security_operations default_secur
 
 void security_fixup_ops(struct security_operations *ops)
 {
-	set_to_cap_if_null(ops, ptrace_may_access);
+	set_to_cap_if_null(ops, ptrace_access_check);
 	set_to_cap_if_null(ops, ptrace_traceme);
 	set_to_cap_if_null(ops, capget);
 	set_to_cap_if_null(ops, capset);
Index: linux/security/commoncap.c
===================================================================
--- linux.orig/security/commoncap.c
+++ linux/security/commoncap.c
@@ -79,7 +79,7 @@ int cap_settime(struct timespec *ts, str
 }
 
 /**
- * cap_ptrace_may_access - Determine whether the current process may access
+ * cap_ptrace_access_check - Determine whether the current process may access
  *			   another
  * @child: The process to be accessed
  * @mode: The mode of attachment.
@@ -87,7 +87,7 @@ int cap_settime(struct timespec *ts, str
  * Determine whether a process may access another, returning 0 if permission
  * granted, -ve if denied.
  */
-int cap_ptrace_may_access(struct task_struct *child, unsigned int mode)
+int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
 	int ret = 0;
 
Index: linux/security/root_plug.c
===================================================================
--- linux.orig/security/root_plug.c
+++ linux/security/root_plug.c
@@ -72,7 +72,7 @@ static int rootplug_bprm_check_security 
 
 static struct security_operations rootplug_security_ops = {
 	/* Use the capability functions for some of the hooks */
-	.ptrace_may_access =		cap_ptrace_may_access,
+	.ptrace_access_check =		cap_ptrace_access_check,
 	.ptrace_traceme =		cap_ptrace_traceme,
 	.capget =			cap_capget,
 	.capset =			cap_capset,
Index: linux/security/security.c
===================================================================
--- linux.orig/security/security.c
+++ linux/security/security.c
@@ -127,9 +127,9 @@ int register_security(struct security_op
 
 /* Security operations */
 
-int security_ptrace_may_access(struct task_struct *child, unsigned int mode)
+int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
-	return security_ops->ptrace_may_access(child, mode);
+	return security_ops->ptrace_access_check(child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
Index: linux/security/selinux/hooks.c
===================================================================
--- linux.orig/security/selinux/hooks.c
+++ linux/security/selinux/hooks.c
@@ -1854,12 +1854,12 @@ static inline u32 open_file_to_av(struct
 
 /* Hook functions begin here. */
 
-static int selinux_ptrace_may_access(struct task_struct *child,
+static int selinux_ptrace_access_check(struct task_struct *child,
 				     unsigned int mode)
 {
 	int rc;
 
-	rc = cap_ptrace_may_access(child, mode);
+	rc = cap_ptrace_access_check(child, mode);
 	if (rc)
 		return rc;
 
@@ -5318,7 +5318,7 @@ static int selinux_key_getsecurity(struc
 static struct security_operations selinux_ops = {
 	.name =				"selinux",
 
-	.ptrace_may_access =		selinux_ptrace_may_access,
+	.ptrace_access_check =		selinux_ptrace_access_check,
 	.ptrace_traceme =		selinux_ptrace_traceme,
 	.capget =			selinux_capget,
 	.capset =			selinux_capset,
Index: linux/security/smack/smack_lsm.c
===================================================================
--- linux.orig/security/smack/smack_lsm.c
+++ linux/security/smack/smack_lsm.c
@@ -92,7 +92,7 @@ struct inode_smack *new_inode_smack(char
  */
 
 /**
- * smack_ptrace_may_access - Smack approval on PTRACE_ATTACH
+ * smack_ptrace_access_check - Smack approval on PTRACE_ATTACH
  * @ctp: child task pointer
  * @mode: ptrace attachment mode
  *
@@ -100,11 +100,11 @@ struct inode_smack *new_inode_smack(char
  *
  * Do the capability checks, and require read and write.
  */
-static int smack_ptrace_may_access(struct task_struct *ctp, unsigned int mode)
+static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 {
 	int rc;
 
-	rc = cap_ptrace_may_access(ctp, mode);
+	rc = cap_ptrace_access_check(ctp, mode);
 	if (rc != 0)
 		return rc;
 
@@ -2826,7 +2826,7 @@ static void smack_release_secctx(char *s
 struct security_operations smack_ops = {
 	.name =				"smack",
 
-	.ptrace_may_access =		smack_ptrace_may_access,
+	.ptrace_access_check =		smack_ptrace_access_check,
 	.ptrace_traceme =		smack_ptrace_traceme,
 	.capget = 			cap_capget,
 	.capset = 			cap_capset,

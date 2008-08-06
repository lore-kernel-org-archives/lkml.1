Return-Path: <linux-kernel-owner+w=401wt.eu-S964993AbYHFPtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993AbYHFPtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbYHFPhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:37:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209AbYHFPhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:37:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/24] Fix setting of PF_SUPERPRIV by __capable() [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:37:19 +0100
Message-ID: <20080806153719.14351.82518.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the setting of PF_SUPERPRIV by __capable() as it could corrupt the flags
the target process if that is not the current process and it is trying to
change its own flags in a different way at the same time.

__capable() is using neither atomic ops nor locking to protect t->flags.  This
patch removes __capable() and introduces has_capability() that doesn't set
PF_SUPERPRIV on the process being queried.

This patch further splits security_ptrace() in two:

 (1) security_ptrace_may_access().  This passes judgement on whether one
     process may access another only (PTRACE_MODE_ATTACH for ptrace() and
     PTRACE_MODE_READ for /proc), and takes a pointer to the child process.
     current is the parent.

 (2) security_ptrace_traceme().  This passes judgement on PTRACE_TRACEME only,
     and takes only a pointer to the parent process.  current is the child.

     In Smack and commoncap, this uses has_capability() to determine whether
     the parent will be permitted to use PTRACE_ATTACH if normal checks fail.
     This does not set PF_SUPERPRIV.


Two of the instances of __capable() actually only act on current, and so have
been changed to calls to capable().

Of the places that were using __capable():

 (1) The OOM killer calls __capable() thrice when weighing the killability of a
     process.  All of these now use has_capability().

 (2) cap_ptrace() and smack_ptrace() were using __capable() to check to see
     whether the parent was allowed to trace any process.  As mentioned above,
     these have been split.  For PTRACE_ATTACH and /proc, capable() is now
     used, and for PTRACE_TRACEME, has_capability() is used.

 (3) cap_safe_nice() only ever saw current, so now uses capable().

 (4) smack_setprocattr() rejected accesses to tasks other than current just
     after calling __capable(), so the order of these two tests have been
     switched and capable() is used instead.

 (5) In smack_file_send_sigiotask(), we need to allow privileged processes to
     receive SIGIO on files they're manipulating.

 (6) In smack_task_wait(), we let a process wait for a privileged process,
     whether or not the process doing the waiting is privileged.

I've tested this with the LTP SELinux and syscalls testscripts.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: James Morris <jmorris@namei.org>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
---

 include/linux/capability.h |   15 ++++++++++++-
 include/linux/security.h   |   39 ++++++++++++++++++++++-------------
 kernel/capability.c        |   21 ++++++++++++-------
 kernel/ptrace.c            |    5 ++--
 mm/oom_kill.c              |    6 ++++-
 security/capability.c      |    3 ++-
 security/commoncap.c       |   24 +++++++++++++++-------
 security/root_plug.c       |    3 ++-
 security/security.c        |   10 ++++++---
 security/selinux/hooks.c   |   25 ++++++++++++++++------
 security/smack/smack_lsm.c |   49 +++++++++++++++++++++++++++++++-------------
 11 files changed, 137 insertions(+), 63 deletions(-)


diff --git a/include/linux/capability.h b/include/linux/capability.h
index 0267384..9d1fe30 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -503,8 +503,19 @@ extern const kernel_cap_t __cap_init_eff_set;
 
 kernel_cap_t cap_set_effective(const kernel_cap_t pE_new);
 
-int capable(int cap);
-int __capable(struct task_struct *t, int cap);
+/**
+ * has_capability - Determine if a task has a superior capability available
+ * @t: The task in question
+ * @cap: The capability to be tested for
+ *
+ * Return true if the specified task has the given superior capability
+ * currently in effect, false if not.
+ *
+ * Note that this does not set PF_SUPERPRIV on the task.
+ */
+#define has_capability(t, cap) (security_capable((t), (cap)) == 0)
+
+extern int capable(int cap);
 
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/security.h b/include/linux/security.h
index fd96e7f..80c4d00 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -46,8 +46,8 @@ struct audit_krule;
  */
 extern int cap_capable(struct task_struct *tsk, int cap);
 extern int cap_settime(struct timespec *ts, struct timezone *tz);
-extern int cap_ptrace(struct task_struct *parent, struct task_struct *child,
-		      unsigned int mode);
+extern int cap_ptrace_may_access(struct task_struct *child, unsigned int mode);
+extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern int cap_capset_check(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern void cap_capset_set(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
@@ -1157,17 +1157,24 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@alter contains the flag indicating whether changes are to be made.
  *	Return 0 if permission is granted.
  *
- * @ptrace:
- *	Check permission before allowing the @parent process to trace the
+ * @ptrace_may_access:
+ *	Check permission before allowing the current process to trace the
  *	@child process.
  *	Security modules may also want to perform a process tracing check
  *	during an execve in the set_security or apply_creds hooks of
  *	binprm_security_ops if the process is being traced and its security
  *	attributes would be changed by the execve.
- *	@parent contains the task_struct structure for parent process.
- *	@child contains the task_struct structure for child process.
+ *	@child contains the task_struct structure for the target process.
  *	@mode contains the PTRACE_MODE flags indicating the form of access.
  *	Return 0 if permission is granted.
+ * @ptrace_traceme:
+ *	Check that the @parent process has sufficient permission to trace the
+ *	current process before allowing the current process to present itself
+ *	to the @parent process for tracing.
+ *	The parent process will still have to undergo the ptrace_may_access
+ *	checks before it is allowed to trace this one.
+ *	@parent contains the task_struct structure for debugger process.
+ *	Return 0 if permission is granted.
  * @capget:
  *	Get the @effective, @inheritable, and @permitted capability sets for
  *	the @target process.  The hook may also perform permission checking to
@@ -1287,8 +1294,8 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
 
-	int (*ptrace) (struct task_struct *parent, struct task_struct *child,
-		       unsigned int mode);
+	int (*ptrace_may_access) (struct task_struct *child, unsigned int mode);
+	int (*ptrace_traceme) (struct task_struct *parent);
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
 		       kernel_cap_t *inheritable, kernel_cap_t *permitted);
@@ -1560,8 +1567,8 @@ extern struct dentry *securityfs_create_dir(const char *name, struct dentry *par
 extern void securityfs_remove(struct dentry *dentry);
 
 /* Security operations */
-int security_ptrace(struct task_struct *parent, struct task_struct *child,
-		    unsigned int mode);
+int security_ptrace_may_access(struct task_struct *child, unsigned int mode);
+int security_ptrace_traceme(struct task_struct *parent);
 int security_capget(struct task_struct *target,
 		    kernel_cap_t *effective,
 		    kernel_cap_t *inheritable,
@@ -1742,11 +1749,15 @@ static inline int security_init(void)
 	return 0;
 }
 
-static inline int security_ptrace(struct task_struct *parent,
-				  struct task_struct *child,
-				  unsigned int mode)
+static inline int security_ptrace_may_access(struct task_struct *child,
+					     unsigned int mode)
+{
+	return cap_ptrace_may_access(child, mode);
+}
+
+static inline int security_ptrace_traceme(struct task_struct *parent)
 {
-	return cap_ptrace(parent, child, mode);
+	return cap_ptrace_traceme(parent);
 }
 
 static inline int security_capget(struct task_struct *target,
diff --git a/kernel/capability.c b/kernel/capability.c
index 0101e84..33e51e7 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -486,17 +486,22 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 	return ret;
 }
 
-int __capable(struct task_struct *t, int cap)
+/**
+ * capable - Determine if the current task has a superior capability in effect
+ * @cap: The capability to be tested for
+ *
+ * Return true if the current task has the given superior capability currently
+ * available for use, false if not.
+ *
+ * This sets PF_SUPERPRIV on the task if the capability is available on the
+ * assumption that it's about to be used.
+ */
+int capable(int cap)
 {
-	if (security_capable(t, cap) == 0) {
-		t->flags |= PF_SUPERPRIV;
+	if (has_capability(current, cap)) {
+		current->flags |= PF_SUPERPRIV;
 		return 1;
 	}
 	return 0;
 }
-
-int capable(int cap)
-{
-	return __capable(current, cap);
-}
 EXPORT_SYMBOL(capable);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 082b3fc..356699a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -140,7 +140,7 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	if (!dumpable && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 
-	return security_ptrace(current, task, mode);
+	return security_ptrace_may_access(task, mode);
 }
 
 bool ptrace_may_access(struct task_struct *task, unsigned int mode)
@@ -499,8 +499,7 @@ repeat:
 			goto repeat;
 		}
 
-		ret = security_ptrace(current->parent, current,
-				      PTRACE_MODE_ATTACH);
+		ret = security_ptrace_traceme(current->parent);
 
 		/*
 		 * Set the ptrace bit in the process ptrace flags.
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 8a5467e..64e5b4b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/memcontrol.h>
+#include <linux/security.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
@@ -128,7 +129,8 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * Superuser processes are usually more important, so we make it
 	 * less likely that we kill those.
 	 */
-	if (__capable(p, CAP_SYS_ADMIN) || __capable(p, CAP_SYS_RESOURCE))
+	if (has_capability(p, CAP_SYS_ADMIN) ||
+	    has_capability(p, CAP_SYS_RESOURCE))
 		points /= 4;
 
 	/*
@@ -137,7 +139,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * tend to only have this flag set on applications they think
 	 * of as important.
 	 */
-	if (__capable(p, CAP_SYS_RAWIO))
+	if (has_capability(p, CAP_SYS_RAWIO))
 		points /= 4;
 
 	/*
diff --git a/security/capability.c b/security/capability.c
index 63d10da..2458748 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -811,7 +811,8 @@ struct security_operations default_security_ops = {
 
 void security_fixup_ops(struct security_operations *ops)
 {
-	set_to_cap_if_null(ops, ptrace);
+	set_to_cap_if_null(ops, ptrace_may_access);
+	set_to_cap_if_null(ops, ptrace_traceme);
 	set_to_cap_if_null(ops, capget);
 	set_to_cap_if_null(ops, capset_check);
 	set_to_cap_if_null(ops, capset_set);
diff --git a/security/commoncap.c b/security/commoncap.c
index 4afbece..e4c4b3f 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -63,14 +63,24 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
 	return 0;
 }
 
-int cap_ptrace (struct task_struct *parent, struct task_struct *child,
-		unsigned int mode)
+int cap_ptrace_may_access(struct task_struct *child, unsigned int mode)
 {
 	/* Derived from arch/i386/kernel/ptrace.c:sys_ptrace. */
-	if (!cap_issubset(child->cap_permitted, parent->cap_permitted) &&
-	    !__capable(parent, CAP_SYS_PTRACE))
-		return -EPERM;
-	return 0;
+	if (cap_issubset(child->cap_permitted, current->cap_permitted))
+		return 0;
+	if (capable(CAP_SYS_PTRACE))
+		return 0;
+	return -EPERM;
+}
+
+int cap_ptrace_traceme(struct task_struct *parent)
+{
+	/* Derived from arch/i386/kernel/ptrace.c:sys_ptrace. */
+	if (cap_issubset(current->cap_permitted, parent->cap_permitted))
+		return 0;
+	if (has_capability(parent, CAP_SYS_PTRACE))
+		return 0;
+	return -EPERM;
 }
 
 int cap_capget (struct task_struct *target, kernel_cap_t *effective,
@@ -534,7 +544,7 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 static inline int cap_safe_nice(struct task_struct *p)
 {
 	if (!cap_issubset(p->cap_permitted, current->cap_permitted) &&
-	    !__capable(current, CAP_SYS_NICE))
+	    !capable(CAP_SYS_NICE))
 		return -EPERM;
 	return 0;
 }
diff --git a/security/root_plug.c b/security/root_plug.c
index be0ebec..c3f68b5 100644
--- a/security/root_plug.c
+++ b/security/root_plug.c
@@ -72,7 +72,8 @@ static int rootplug_bprm_check_security (struct linux_binprm *bprm)
 
 static struct security_operations rootplug_security_ops = {
 	/* Use the capability functions for some of the hooks */
-	.ptrace =			cap_ptrace,
+	.ptrace_may_access =		cap_ptrace_may_access,
+	.ptrace_traceme =		cap_ptrace_traceme,
 	.capget =			cap_capget,
 	.capset_check =			cap_capset_check,
 	.capset_set =			cap_capset_set,
diff --git a/security/security.c b/security/security.c
index ff70687..3a4b4f5 100644
--- a/security/security.c
+++ b/security/security.c
@@ -127,10 +127,14 @@ int register_security(struct security_operations *ops)
 
 /* Security operations */
 
-int security_ptrace(struct task_struct *parent, struct task_struct *child,
-		    unsigned int mode)
+int security_ptrace_may_access(struct task_struct *child, unsigned int mode)
 {
-	return security_ops->ptrace(parent, child, mode);
+	return security_ops->ptrace_may_access(child, mode);
+}
+
+int security_ptrace_traceme(struct task_struct *parent)
+{
+	return security_ops->ptrace_traceme(parent);
 }
 
 int security_capget(struct task_struct *target,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3eae306..6b5790b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1739,24 +1739,34 @@ static inline u32 file_to_av(struct file *file)
 
 /* Hook functions begin here. */
 
-static int selinux_ptrace(struct task_struct *parent,
-			  struct task_struct *child,
-			  unsigned int mode)
+static int selinux_ptrace_may_access(struct task_struct *child,
+				     unsigned int mode)
 {
 	int rc;
 
-	rc = secondary_ops->ptrace(parent, child, mode);
+	rc = secondary_ops->ptrace_may_access(child, mode);
 	if (rc)
 		return rc;
 
 	if (mode == PTRACE_MODE_READ) {
-		struct task_security_struct *tsec = parent->security;
+		struct task_security_struct *tsec = current->security;
 		struct task_security_struct *csec = child->security;
 		return avc_has_perm(tsec->sid, csec->sid,
 				    SECCLASS_FILE, FILE__READ, NULL);
 	}
 
-	return task_has_perm(parent, child, PROCESS__PTRACE);
+	return task_has_perm(current, child, PROCESS__PTRACE);
+}
+
+static int selinux_ptrace_traceme(struct task_struct *parent)
+{
+	int rc;
+
+	rc = secondary_ops->ptrace_traceme(parent);
+	if (rc)
+		return rc;
+
+	return task_has_perm(parent, current, PROCESS__PTRACE);
 }
 
 static int selinux_capget(struct task_struct *target, kernel_cap_t *effective,
@@ -5353,7 +5363,8 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 static struct security_operations selinux_ops = {
 	.name =				"selinux",
 
-	.ptrace =			selinux_ptrace,
+	.ptrace_may_access =		selinux_ptrace_may_access,
+	.ptrace_traceme =		selinux_ptrace_traceme,
 	.capget =			selinux_capget,
 	.capset_check =			selinux_capset_check,
 	.capset_set =			selinux_capset_set,
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 1b40e55..87d7541 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -87,27 +87,46 @@ struct inode_smack *new_inode_smack(char *smack)
  */
 
 /**
- * smack_ptrace - Smack approval on ptrace
- * @ptp: parent task pointer
+ * smack_ptrace_may_access - Smack approval on PTRACE_ATTACH
  * @ctp: child task pointer
  *
  * Returns 0 if access is OK, an error code otherwise
  *
  * Do the capability checks, and require read and write.
  */
-static int smack_ptrace(struct task_struct *ptp, struct task_struct *ctp,
-			unsigned int mode)
+static int smack_ptrace_may_access(struct task_struct *ctp, unsigned int mode)
 {
 	int rc;
 
-	rc = cap_ptrace(ptp, ctp, mode);
+	rc = cap_ptrace_may_access(ctp, mode);
 	if (rc != 0)
 		return rc;
 
-	rc = smk_access(ptp->security, ctp->security, MAY_READWRITE);
-	if (rc != 0 && __capable(ptp, CAP_MAC_OVERRIDE))
+	rc = smk_access(current->security, ctp->security, MAY_READWRITE);
+	if (rc != 0 && capable(CAP_MAC_OVERRIDE))
 		return 0;
+	return rc;
+}
+
+/**
+ * smack_ptrace_traceme - Smack approval on PTRACE_TRACEME
+ * @ptp: parent task pointer
+ *
+ * Returns 0 if access is OK, an error code otherwise
+ *
+ * Do the capability checks, and require read and write.
+ */
+static int smack_ptrace_traceme(struct task_struct *ptp)
+{
+	int rc;
+
+	rc = cap_ptrace_traceme(ptp);
+	if (rc != 0)
+		return rc;
 
+	rc = smk_access(ptp->security, current->security, MAY_READWRITE);
+	if (rc != 0 && has_capability(ptp, CAP_MAC_OVERRIDE))
+		return 0;
 	return rc;
 }
 
@@ -923,7 +942,7 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 	 */
 	file = container_of(fown, struct file, f_owner);
 	rc = smk_access(file->f_security, tsk->security, MAY_WRITE);
-	if (rc != 0 && __capable(tsk, CAP_MAC_OVERRIDE))
+	if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
 		return 0;
 	return rc;
 }
@@ -1164,12 +1183,12 @@ static int smack_task_wait(struct task_struct *p)
 	 * account for the smack labels having gotten to
 	 * be different in the first place.
 	 *
-	 * This breaks the strict subjet/object access
+	 * This breaks the strict subject/object access
 	 * control ideal, taking the object's privilege
 	 * state into account in the decision as well as
 	 * the smack value.
 	 */
-	if (capable(CAP_MAC_OVERRIDE) || __capable(p, CAP_MAC_OVERRIDE))
+	if (capable(CAP_MAC_OVERRIDE) || has_capability(p, CAP_MAC_OVERRIDE))
 		return 0;
 
 	return rc;
@@ -2016,9 +2035,6 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 {
 	char *newsmack;
 
-	if (!__capable(p, CAP_MAC_ADMIN))
-		return -EPERM;
-
 	/*
 	 * Changing another process' Smack value is too dangerous
 	 * and supports no sane use case.
@@ -2026,6 +2042,9 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (p != current)
 		return -EPERM;
 
+	if (!capable(CAP_MAC_ADMIN))
+		return -EPERM;
+
 	if (value == NULL || size == 0 || size >= SMK_LABELLEN)
 		return -EINVAL;
 
@@ -2552,7 +2571,8 @@ static void smack_release_secctx(char *secdata, u32 seclen)
 struct security_operations smack_ops = {
 	.name =				"smack",
 
-	.ptrace = 			smack_ptrace,
+	.ptrace_may_access =		smack_ptrace_may_access,
+	.ptrace_traceme =		smack_ptrace_traceme,
 	.capget = 			cap_capget,
 	.capset_check = 		cap_capset_check,
 	.capset_set = 			cap_capset_set,
@@ -2729,4 +2749,3 @@ static __init int smack_init(void)
  * all processes and objects when they are created.
  */
 security_initcall(smack_init);
-


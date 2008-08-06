Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbYHFPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbYHFPlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbYHFPjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:39:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbYHFPjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:39:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/24] CRED: Prettify commoncap.c [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:52 +0100
Message-ID: <20080806153852.14351.50309.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prettify commoncap.c.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: James Morris <jmorris@namei.org>
---

 security/commoncap.c |  304 +++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 247 insertions(+), 57 deletions(-)


diff --git a/security/commoncap.c b/security/commoncap.c
index 3da0ada..c91b1af 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -39,16 +39,22 @@ int cap_netlink_recv(struct sk_buff *skb, int cap)
 		return -EPERM;
 	return 0;
 }
-
 EXPORT_SYMBOL(cap_netlink_recv);
 
-/*
+/**
+ * cap_capable - Determine whether a task has a particular effective capability
+ * @tsk: The task to query
+ * @cap: The capability to check for
+ *
+ * Determine whether the nominated task has the specified capability amongst
+ * its effective set, returning 0 if it does, -ve if it does not.
+ *
  * NOTE WELL: cap_capable() cannot be used like the kernel's capable()
- * function.  That is, it has the reverse semantics: cap_capable()
- * returns 0 when a task has a capability, but the kernel's capable()
- * returns 1 for this case.
+ * function.  That is, it has the reverse semantics: cap_capable() returns 0
+ * when a task has a capability, but the kernel's capable() returns 1 for this
+ * case.
  */
-int cap_capable (struct task_struct *tsk, int cap)
+int cap_capable(struct task_struct *tsk, int cap)
 {
 	__u32 cap_raised;
 
@@ -59,6 +65,14 @@ int cap_capable (struct task_struct *tsk, int cap)
 	return cap_raised ? 0 : -EPERM;
 }
 
+/**
+ * cap_settime - Determine whether the current process may set the system clock
+ * @ts: The time to set
+ * @tz: The timezone to set
+ *
+ * Determine whether the current process may set the system clock and timezone
+ * information, returning 0 if permission granted, -ve if denied.
+ */
 int cap_settime(struct timespec *ts, struct timezone *tz)
 {
 	if (!capable(CAP_SYS_TIME))
@@ -66,6 +80,15 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
 	return 0;
 }
 
+/**
+ * cap_ptrace_may_access - Determine whether the current process may access
+ *			   another
+ * @child: The process to be accessed
+ * @mode: The mode of attachment.
+ *
+ * Determine whether a process may access another, returning 0 if permission
+ * granted, -ve if denied.
+ */
 int cap_ptrace_may_access(struct task_struct *child, unsigned int mode)
 {
 	int ret = 0;
@@ -79,6 +102,13 @@ int cap_ptrace_may_access(struct task_struct *child, unsigned int mode)
 	return ret;
 }
 
+/**
+ * cap_ptrace_traceme - Determine whether another process may trace the current
+ * @parent: The task proposed to be the tracer
+ *
+ * Determine whether the nominated task is permitted to trace the current
+ * process, returning 0 if permission is granted, -ve if denied.
+ */
 int cap_ptrace_traceme(struct task_struct *parent)
 {
 	int ret = 0;
@@ -92,8 +122,18 @@ int cap_ptrace_traceme(struct task_struct *parent)
 	return ret;
 }
 
-int cap_capget (struct task_struct *target, kernel_cap_t *effective,
-		kernel_cap_t *inheritable, kernel_cap_t *permitted)
+/**
+ * cap_capget - Retrieve a task's capability sets
+ * @target: The task from which to retrieve the capability sets
+ * @effective: The place to record the effective set
+ * @inheritable: The place to record the inheritable set
+ * @permitted: The place to record the permitted set
+ *
+ * This function retrieves the capabilities of the nominated task and returns
+ * them to the caller.
+ */
+int cap_capget(struct task_struct *target, kernel_cap_t *effective,
+	       kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
 	const struct cred *cred;
 
@@ -107,30 +147,35 @@ int cap_capget (struct task_struct *target, kernel_cap_t *effective,
 	return 0;
 }
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
-
+/*
+ * Determine whether the inheritable capabilities are limited to the old
+ * permitted set.  Returns 1 if they are limited, 0 if they are not.
+ */
 static inline int cap_inh_is_capped(void)
 {
-	/*
-	 * Return 1 if changes to the inheritable set are limited
-	 * to the old permitted set. That is, if the current task
-	 * does *not* possess the CAP_SETPCAP capability.
-	 */
-	return cap_capable(current, CAP_SETPCAP) != 0;
-}
-
-static inline int cap_limit_ptraced_target(void) { return 1; }
-
-#else /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
-static inline int cap_inh_is_capped(void) { return 1; }
-static inline int cap_limit_ptraced_target(void)
-{
-	return !capable(CAP_SETPCAP);
+	/* they are so limited unless the current task has the CAP_SETPCAP
+	 * capability
+	 */
+	if (cap_capable(current, CAP_SETPCAP) == 0)
+		return 0;
+#endif
+	return 1;
 }
 
-#endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
-
+/**
+ * cap_capset - Validate and apply proposed changes to current's capabilities
+ * @new: The proposed new credentials; alterations should be made here
+ * @old: The current task's current credentials
+ * @effective: A pointer to the proposed new effective capabilities set
+ * @inheritable: A pointer to the proposed new inheritable capabilities set
+ * @permitted: A pointer to the proposed new permitted capabilities set
+ *
+ * This function validates and applies a proposed mass change to the current
+ * process's capability sets.  The changes are made to the proposed new
+ * credentials, and assuming no error, will be committed by the caller of LSM.
+ */
 int cap_capset(struct cred *new,
 	       const struct cred *old,
 	       const kernel_cap_t *effective,
@@ -164,6 +209,9 @@ int cap_capset(struct cred *new,
 	return 0;
 }
 
+/*
+ * Clear proposed capability sets for execve().
+ */
 static inline void bprm_clear_caps(struct linux_binprm *bprm)
 {
 	cap_clear(bprm->cred->cap_permitted);
@@ -172,6 +220,17 @@ static inline void bprm_clear_caps(struct linux_binprm *bprm)
 
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
+/**
+ * cap_inode_need_killpriv - Determine if inode change affects privileges
+ * @dentry: The inode/dentry in being changed with change marked ATTR_KILL_PRIV
+ *
+ * Determine if an inode having a change applied that's marked ATTR_KILL_PRIV
+ * affects the security markings on that inode, and if it is, should
+ * inode_killpriv() be invoked or the change rejected?
+ *
+ * Returns 0 if granted; +ve if granted, but inode_killpriv() is required; and
+ * -ve to deny the change.
+ */
 int cap_inode_need_killpriv(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
@@ -186,6 +245,14 @@ int cap_inode_need_killpriv(struct dentry *dentry)
 	return 1;
 }
 
+/**
+ * cap_inode_killpriv - Erase the security markings on an inode
+ * @dentry: The inode/dentry to alter
+ *
+ * Erase the privilege-enhancing security markings on an inode.
+ *
+ * Returns 0 if successful, -ve on error.
+ */
 int cap_inode_killpriv(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
@@ -196,6 +263,9 @@ int cap_inode_killpriv(struct dentry *dentry)
 	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
 }
 
+/*
+ * Extract the on-exec-apply capability sets for an executable file.
+ */
 static inline int cap_from_disk(struct vfs_cap_data *caps,
 				struct linux_binprm *bprm, unsigned size,
 				bool *effective)
@@ -264,7 +334,11 @@ static inline int cap_from_disk(struct vfs_cap_data *caps,
 	return *effective ? ret : 0;
 }
 
-/* Locate any VFS capabilities: */
+/*
+ * Attempt to get the on-exec apply capability sets for an executable file from
+ * its xattrs and, if present, apply them to the proposed credentials being
+ * constructed by execve().
+ */
 static int get_file_caps(struct linux_binprm *bprm, bool *effective)
 {
 	struct dentry *dentry;
@@ -324,7 +398,31 @@ static inline int get_file_caps(struct linux_binprm *bprm, bool *effective)
 #endif
 
 /*
- * set up the new credentials for an exec'd task
+ * Determine whether a exec'ing process's new permitted capabilities should be
+ * limited to just what it already has.
+ *
+ * This prevents processes that are being ptraced from gaining access to
+ * CAP_SETPCAP, unless the process they're tracing already has it, and the
+ * binary they're executing has filecaps that elevate it.
+ *
+ *  Returns 1 if they should be limited, 0 if they are not.
+ */
+static inline int cap_limit_ptraced_target(void)
+{
+#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
+	if (capable(CAP_SETPCAP))
+		return 0;
+#endif
+	return 1;
+}
+
+/**
+ * cap_bprm_set_creds - Set up the proposed credentials for execve().
+ * @bprm: The execution parameters, including the proposed creds
+ *
+ * Set up the proposed credentials for a new execution context being
+ * constructed by execve().  The proposed creds in @bprm->cred is altered,
+ * which won't take effect immediately.  Returns 0 if successful, -ve on error.
  */
 int cap_bprm_set_creds(struct linux_binprm *bprm)
 {
@@ -392,10 +490,15 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 	return 0;
 }
 
-/*
- * determine whether a secure execution is required
- * - the creds have been committed at this point, and are no longer available
- *   through bprm
+/**
+ * cap_bprm_secureexec - Determine whether a secure execution is required
+ * @bprm: The execution parameters
+ *
+ * Determine whether a secure execution is required, return 1 if it is, and 0
+ * if it is not.
+ *
+ * The credentials have been committed by this point, and so are no longer
+ * available through @bprm->cred.
  */
 int cap_bprm_secureexec(struct linux_binprm *bprm)
 {
@@ -412,6 +515,20 @@ int cap_bprm_secureexec(struct linux_binprm *bprm)
 		cred->egid != cred->gid);
 }
 
+/**
+ * cap_inode_setxattr - Determine whether an xattr may be altered
+ * @dentry: The inode/dentry being altered
+ * @name: The name of the xattr to be changed
+ * @value: The value that the xattr will be changed to
+ * @size: The size of value
+ * @flags: The replacement flag
+ *
+ * Determine whether an xattr may be altered or set on an inode, returning 0 if
+ * permission is granted, -ve if denied.
+ *
+ * This is used to make sure security xattrs don't get updated or set by those
+ * who aren't privileged to do so.
+ */
 int cap_inode_setxattr(struct dentry *dentry, const char *name,
 		       const void *value, size_t size, int flags)
 {
@@ -419,28 +536,42 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
 		if (!capable(CAP_SETFCAP))
 			return -EPERM;
 		return 0;
-	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	}
+
+	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
 
+/**
+ * cap_inode_removexattr - Determine whether an xattr may be removed
+ * @dentry: The inode/dentry being altered
+ * @name: The name of the xattr to be changed
+ *
+ * Determine whether an xattr may be removed from an inode, returning 0 if
+ * permission is granted, -ve if denied.
+ *
+ * This is used to make sure security xattrs don't get removed by those who
+ * aren't privileged to remove them.
+ */
 int cap_inode_removexattr(struct dentry *dentry, const char *name)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
 		if (!capable(CAP_SETFCAP))
 			return -EPERM;
 		return 0;
-	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	}
+
+	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
 
-/* moved from kernel/sys.c. */
-/* 
+/*
  * cap_emulate_setxuid() fixes the effective / permitted capabilities of
  * a process after a call to setuid, setreuid, or setresuid.
  *
@@ -454,10 +585,10 @@ int cap_inode_removexattr(struct dentry *dentry, const char *name)
  *  3) When set*uiding _from_ euid != 0 _to_ euid == 0, the effective
  *  capabilities are set to the permitted capabilities.
  *
- *  fsuid is handled elsewhere. fsuid == 0 and {r,e,s}uid!= 0 should 
+ *  fsuid is handled elsewhere. fsuid == 0 and {r,e,s}uid!= 0 should
  *  never happen.
  *
- *  -astor 
+ *  -astor
  *
  * cevans - New behaviour, Oct '99
  * A process may, via prctl(), elect to keep its capabilities when it
@@ -483,35 +614,46 @@ static inline void cap_emulate_setxuid(struct cred *new, const struct cred *old)
 		new->cap_effective = new->cap_permitted;
 }
 
+/**
+ * cap_task_fix_setuid - Fix up the results of setuid() call
+ * @new: The proposed credentials
+ * @old: The current task's current credentials
+ * @flags: Indications of what has changed
+ *
+ * Fix up the results of setuid() call before the credential changes are
+ * actually applied, returning 0 to grant the changes, -ve to deny them.
+ */
 int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags)
 {
 	switch (flags) {
 	case LSM_SETID_RE:
 	case LSM_SETID_ID:
 	case LSM_SETID_RES:
-		/* Copied from kernel/sys.c:setreuid/setuid/setresuid. */
+		/* juggle the capabilities to follow [RES]UID changes unless
+		 * otherwise suppressed */
 		if (!issecure(SECURE_NO_SETUID_FIXUP))
 			cap_emulate_setxuid(new, old);
 		break;
-	case LSM_SETID_FS:
-		/* Copied from kernel/sys.c:setfsuid. */
 
-		/*
+	case LSM_SETID_FS:
+		/* juggle the capabilties to follow FSUID changes, unless
+		 * otherwise suppressed
+		 *
 		 * FIXME - is fsuser used for all CAP_FS_MASK capabilities?
 		 *          if not, we might be a bit too harsh here.
 		 */
 		if (!issecure(SECURE_NO_SETUID_FIXUP)) {
-			if (old->fsuid == 0 && new->fsuid != 0) {
+			if (old->fsuid == 0 && new->fsuid != 0)
 				new->cap_effective =
 					cap_drop_fs_set(new->cap_effective);
-			}
-			if (old->fsuid != 0 && new->fsuid == 0) {
+
+			if (old->fsuid != 0 && new->fsuid == 0)
 				new->cap_effective =
 					cap_raise_fs_set(new->cap_effective,
 							 new->cap_permitted);
-			}
 		}
 		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -544,28 +686,50 @@ static inline int cap_safe_nice(struct task_struct *p)
 	return 0;
 }
 
-int cap_task_setscheduler (struct task_struct *p, int policy,
+/**
+ * cap_task_setscheduler - Detemine if scheduler policy change is permitted
+ * @p: The task to affect
+ * @policy: The policy to effect
+ * @lp: The parameters to the scheduling policy
+ *
+ * Detemine if the requested scheduler policy change is permitted for the
+ * specified task, returning 0 if permission is granted, -ve if denied.
+ */
+int cap_task_setscheduler(struct task_struct *p, int policy,
 			   struct sched_param *lp)
 {
 	return cap_safe_nice(p);
 }
 
-int cap_task_setioprio (struct task_struct *p, int ioprio)
+/**
+ * cap_task_ioprio - Detemine if I/O priority change is permitted
+ * @p: The task to affect
+ * @ioprio: The I/O priority to set
+ *
+ * Detemine if the requested I/O priority change is permitted for the specified
+ * task, returning 0 if permission is granted, -ve if denied.
+ */
+int cap_task_setioprio(struct task_struct *p, int ioprio)
 {
 	return cap_safe_nice(p);
 }
 
-int cap_task_setnice (struct task_struct *p, int nice)
+/**
+ * cap_task_ioprio - Detemine if task priority change is permitted
+ * @p: The task to affect
+ * @nice: The nice value to set
+ *
+ * Detemine if the requested task priority change is permitted for the
+ * specified task, returning 0 if permission is granted, -ve if denied.
+ */
+int cap_task_setnice(struct task_struct *p, int nice)
 {
 	return cap_safe_nice(p);
 }
 
 /*
- * called from kernel/sys.c for prctl(PR_CABSET_DROP)
- * done without task_capability_lock() because it introduces
- * no new races - i.e. only another task doing capget() on
- * this task could get inconsistent info.  There can be no
- * racing writer bc a task can only change its own caps.
+ * Implement PR_CAPBSET_DROP.  Attempt to remove the specified capability from
+ * the current task's bounding set.  Returns 0 on success, -ve on error.
  */
 static long cap_prctl_drop(struct cred *new, unsigned long cap)
 {
@@ -594,6 +758,18 @@ int cap_task_setnice (struct task_struct *p, int nice)
 }
 #endif
 
+/**
+ * cap_task_prctl - Implement process control functions for this security module
+ * @option: The process control function requested
+ * @arg2, @arg3, @arg4, @arg5: The argument data for this function
+ *
+ * Allow process control functions (sys_prctl()) to alter capabilities; may
+ * also deny access to other functions not otherwise implemented here.
+ *
+ * Returns 0 or +ve on success, -ENOSYS if this function is not implemented
+ * here, other -ve on error.  If -ENOSYS is returned, sys_prctl() and other LSM
+ * modules will consider performing the function.
+ */
 int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		   unsigned long arg4, unsigned long arg5)
 {
@@ -699,13 +875,28 @@ error:
 	return error;
 }
 
-int cap_syslog (int type)
+/**
+ * cap_syslog - Determine whether syslog function is permitted
+ * @type: Function requested
+ *
+ * Determine whether the current process is permitted to use a particular
+ * syslog function, returning 0 if permission is granted, -ve if not.
+ */
+int cap_syslog(int type)
 {
 	if ((type != 3 && type != 10) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
 
+/**
+ * cap_vm_enough_memory - Determine whether a new virtual mapping is permitted
+ * @mm: The VM space in which the new mapping is to be made
+ * @pages: The size of the mapping
+ *
+ * Determine whether the allocation of a new virtual mapping by the current
+ * task is permitted, returning 0 if permission is granted, -ve if not.
+ */
 int cap_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int cap_sys_admin = 0;
@@ -714,4 +905,3 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
 		cap_sys_admin = 1;
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
-


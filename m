Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbYHFPup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbYHFPup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759178AbYHFPh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:37:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758283AbYHFPhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:37:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/24] CRED: Neuter sys_capset() [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:37:34 +0100
Message-ID: <20080806153734.14351.10896.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take away the ability for sys_capset() to affect processes other than current.

This means that current will not need to lock its own credentials when reading
them against interference by other processes.

This has effectively been the case for a while anyway, since:

 (1) Without LSM enabled, sys_capset() is disallowed.

 (2) With file-based capabilities, sys_capset() is neutered.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: James Morris <jmorris@namei.org>
---

 fs/open.c                |   12 ---
 include/linux/security.h |   48 +++-------
 kernel/capability.c      |  215 +++-------------------------------------------
 security/commoncap.c     |   29 ++----
 security/security.c      |   18 ++--
 security/selinux/hooks.c |   10 +-
 6 files changed, 52 insertions(+), 280 deletions(-)


diff --git a/fs/open.c b/fs/open.c
index 07da935..0f410b1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -441,17 +441,7 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	current->fsgid = current->gid;
 
 	if (!issecure(SECURE_NO_SETUID_FIXUP)) {
-		/*
-		 * Clear the capabilities if we switch to a non-root user
-		 */
-#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
-		/*
-		 * FIXME: There is a race here against sys_capset.  The
-		 * capabilities can change yet we will restore the old
-		 * value below.  We should hold task_capabilities_lock,
-		 * but we cannot because user_path_at can sleep.
-		 */
-#endif /* ndef CONFIG_SECURITY_FILE_CAPABILITIES */
+		/* Clear the capabilities if we switch to a non-root user */
 		if (current->uid)
 			old_cap = cap_set_effective(__cap_empty_set);
 		else
diff --git a/include/linux/security.h b/include/linux/security.h
index 80c4d00..dc23a3d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -49,8 +49,8 @@ extern int cap_settime(struct timespec *ts, struct timezone *tz);
 extern int cap_ptrace_may_access(struct task_struct *child, unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
-extern int cap_capset_check(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
-extern void cap_capset_set(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
+extern int cap_capset_check(kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
+extern void cap_capset_set(kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern int cap_bprm_set_security(struct linux_binprm *bprm);
 extern void cap_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
@@ -1187,24 +1187,14 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Return 0 if the capability sets were successfully obtained.
  * @capset_check:
  *	Check permission before setting the @effective, @inheritable, and
- *	@permitted capability sets for the @target process.
- *	Caveat:  @target is also set to current if a set of processes is
- *	specified (i.e. all processes other than current and init or a
- *	particular process group).  Hence, the capset_set hook may need to
- *	revalidate permission to the actual target process.
- *	@target contains the task_struct structure for target process.
+ *	@permitted capability sets for the current process.
  *	@effective contains the effective capability set.
  *	@inheritable contains the inheritable capability set.
  *	@permitted contains the permitted capability set.
  *	Return 0 if permission is granted.
  * @capset_set:
  *	Set the @effective, @inheritable, and @permitted capability sets for
- *	the @target process.  Since capset_check cannot always check permission
- *	to the real @target process, this hook may also perform permission
- *	checking to determine if the current process is allowed to set the
- *	capability sets of the @target process.  However, this hook has no way
- *	of returning an error due to the structure of the sys_capset code.
- *	@target contains the task_struct structure for target process.
+ *	the current process.
  *	@effective contains the effective capability set.
  *	@inheritable contains the inheritable capability set.
  *	@permitted contains the permitted capability set.
@@ -1299,12 +1289,10 @@ struct security_operations {
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
 		       kernel_cap_t *inheritable, kernel_cap_t *permitted);
-	int (*capset_check) (struct task_struct *target,
-			     kernel_cap_t *effective,
+	int (*capset_check) (kernel_cap_t *effective,
 			     kernel_cap_t *inheritable,
 			     kernel_cap_t *permitted);
-	void (*capset_set) (struct task_struct *target,
-			    kernel_cap_t *effective,
+	void (*capset_set) (kernel_cap_t *effective,
 			    kernel_cap_t *inheritable,
 			    kernel_cap_t *permitted);
 	int (*capable) (struct task_struct *tsk, int cap);
@@ -1573,12 +1561,10 @@ int security_capget(struct task_struct *target,
 		    kernel_cap_t *effective,
 		    kernel_cap_t *inheritable,
 		    kernel_cap_t *permitted);
-int security_capset_check(struct task_struct *target,
-			  kernel_cap_t *effective,
+int security_capset_check(kernel_cap_t *effective,
 			  kernel_cap_t *inheritable,
 			  kernel_cap_t *permitted);
-void security_capset_set(struct task_struct *target,
-			 kernel_cap_t *effective,
+void security_capset_set(kernel_cap_t *effective,
 			 kernel_cap_t *inheritable,
 			 kernel_cap_t *permitted);
 int security_capable(struct task_struct *tsk, int cap);
@@ -1768,20 +1754,18 @@ static inline int security_capget(struct task_struct *target,
 	return cap_capget(target, effective, inheritable, permitted);
 }
 
-static inline int security_capset_check(struct task_struct *target,
-					 kernel_cap_t *effective,
-					 kernel_cap_t *inheritable,
-					 kernel_cap_t *permitted)
+static inline int security_capset_check(kernel_cap_t *effective,
+					kernel_cap_t *inheritable,
+					kernel_cap_t *permitted)
 {
-	return cap_capset_check(target, effective, inheritable, permitted);
+	return cap_capset_check(effective, inheritable, permitted);
 }
 
-static inline void security_capset_set(struct task_struct *target,
-					kernel_cap_t *effective,
-					kernel_cap_t *inheritable,
-					kernel_cap_t *permitted)
+static inline void security_capset_set(kernel_cap_t *effective,
+				       kernel_cap_t *inheritable,
+				       kernel_cap_t *permitted)
 {
-	cap_capset_set(target, effective, inheritable, permitted);
+	cap_capset_set(effective, inheritable, permitted);
 }
 
 static inline int security_capable(struct task_struct *tsk, int cap)
diff --git a/kernel/capability.c b/kernel/capability.c
index 33e51e7..bb96b53 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -115,160 +115,6 @@ static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
 	return 0;
 }
 
-#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
-
-/*
- * Without filesystem capability support, we nominally support one process
- * setting the capabilities of another
- */
-static inline int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
-				     kernel_cap_t *pIp, kernel_cap_t *pPp)
-{
-	struct task_struct *target;
-	int ret;
-
-	spin_lock(&task_capability_lock);
-	read_lock(&tasklist_lock);
-
-	if (pid && pid != task_pid_vnr(current)) {
-		target = find_task_by_vpid(pid);
-		if (!target) {
-			ret = -ESRCH;
-			goto out;
-		}
-	} else
-		target = current;
-
-	ret = security_capget(target, pEp, pIp, pPp);
-
-out:
-	read_unlock(&tasklist_lock);
-	spin_unlock(&task_capability_lock);
-
-	return ret;
-}
-
-/*
- * cap_set_pg - set capabilities for all processes in a given process
- * group.  We call this holding task_capability_lock and tasklist_lock.
- */
-static inline int cap_set_pg(int pgrp_nr, kernel_cap_t *effective,
-			     kernel_cap_t *inheritable,
-			     kernel_cap_t *permitted)
-{
-	struct task_struct *g, *target;
-	int ret = -EPERM;
-	int found = 0;
-	struct pid *pgrp;
-
-	spin_lock(&task_capability_lock);
-	read_lock(&tasklist_lock);
-
-	pgrp = find_vpid(pgrp_nr);
-	do_each_pid_task(pgrp, PIDTYPE_PGID, g) {
-		target = g;
-		while_each_thread(g, target) {
-			if (!security_capset_check(target, effective,
-						   inheritable, permitted)) {
-				security_capset_set(target, effective,
-						    inheritable, permitted);
-				ret = 0;
-			}
-			found = 1;
-		}
-	} while_each_pid_task(pgrp, PIDTYPE_PGID, g);
-
-	read_unlock(&tasklist_lock);
-	spin_unlock(&task_capability_lock);
-
-	if (!found)
-		ret = 0;
-	return ret;
-}
-
-/*
- * cap_set_all - set capabilities for all processes other than init
- * and self.  We call this holding task_capability_lock and tasklist_lock.
- */
-static inline int cap_set_all(kernel_cap_t *effective,
-			      kernel_cap_t *inheritable,
-			      kernel_cap_t *permitted)
-{
-	struct task_struct *g, *target;
-	int ret = -EPERM;
-	int found = 0;
-
-	spin_lock(&task_capability_lock);
-	read_lock(&tasklist_lock);
-
-	do_each_thread(g, target) {
-		if (target == current
-		    || is_container_init(target->group_leader))
-			continue;
-		found = 1;
-		if (security_capset_check(target, effective, inheritable,
-					  permitted))
-			continue;
-		ret = 0;
-		security_capset_set(target, effective, inheritable, permitted);
-	} while_each_thread(g, target);
-
-	read_unlock(&tasklist_lock);
-	spin_unlock(&task_capability_lock);
-
-	if (!found)
-		ret = 0;
-
-	return ret;
-}
-
-/*
- * Given the target pid does not refer to the current process we
- * need more elaborate support... (This support is not present when
- * filesystem capabilities are configured.)
- */
-static inline int do_sys_capset_other_tasks(pid_t pid, kernel_cap_t *effective,
-					    kernel_cap_t *inheritable,
-					    kernel_cap_t *permitted)
-{
-	struct task_struct *target;
-	int ret;
-
-	if (!capable(CAP_SETPCAP))
-		return -EPERM;
-
-	if (pid == -1)	          /* all procs other than current and init */
-		return cap_set_all(effective, inheritable, permitted);
-
-	else if (pid < 0)                    /* all procs in process group */
-		return cap_set_pg(-pid, effective, inheritable, permitted);
-
-	/* target != current */
-	spin_lock(&task_capability_lock);
-	read_lock(&tasklist_lock);
-
-	target = find_task_by_vpid(pid);
-	if (!target)
-		ret = -ESRCH;
-	else {
-		ret = security_capset_check(target, effective, inheritable,
-					    permitted);
-
-		/* having verified that the proposed changes are legal,
-		   we now put them into effect. */
-		if (!ret)
-			security_capset_set(target, effective, inheritable,
-					    permitted);
-	}
-
-	read_unlock(&tasklist_lock);
-	spin_unlock(&task_capability_lock);
-
-	return ret;
-}
-
-#else /* ie., def CONFIG_SECURITY_FILE_CAPABILITIES */
-
 /*
  * If we have configured with filesystem capability support, then the
  * only thing that can change the capabilities of the current process
@@ -303,22 +149,6 @@ static inline int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
 }
 
 /*
- * With filesystem capability support configured, the kernel does not
- * permit the changing of capabilities in one process by another
- * process. (CAP_SETPCAP has much less broad semantics when configured
- * this way.)
- */
-static inline int do_sys_capset_other_tasks(pid_t pid,
-					    kernel_cap_t *effective,
-					    kernel_cap_t *inheritable,
-					    kernel_cap_t *permitted)
-{
-	return -EPERM;
-}
-
-#endif /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
-
-/*
  * Atomically modify the effective capabilities returning the original
  * value. No permission check is performed here - it is assumed that the
  * caller is permitted to set the desired effective capabilities.
@@ -412,16 +242,14 @@ asmlinkage long sys_capget(cap_user_header_t header, cap_user_data_t dataptr)
  * @data: pointer to struct that contains the effective, permitted,
  *	and inheritable capabilities
  *
- * Set capabilities for a given process, all processes, or all
- * processes in a given process group.
+ * Set capabilities for the current process only.  The ability to any other
+ * process(es) has been deprecated and removed.
  *
  * The restrictions on setting capabilities are specified as:
  *
- * [pid is for the 'target' task.  'current' is the calling task.]
- *
- * I: any raised capabilities must be a subset of the (old current) permitted
- * P: any raised capabilities must be a subset of the (old current) permitted
- * E: must be set to a subset of (new target) permitted
+ * I: any raised capabilities must be a subset of the old permitted
+ * P: any raised capabilities must be a subset of the old permitted
+ * E: must be set to a subset of new permitted
  *
  * Returns 0 on success and < 0 on error.
  */
@@ -440,6 +268,10 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 	if (get_user(pid, &header->pid))
 		return -EFAULT;
 
+	/* may only affect current now */
+	if (pid != 0 && pid != task_pid_vnr(current))
+		return -EPERM;
+
 	if (copy_from_user(&kdata, data, tocopy
 			   * sizeof(struct __user_cap_data_struct))) {
 		return -EFAULT;
@@ -457,32 +289,13 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 		i++;
 	}
 
-	if (pid && (pid != task_pid_vnr(current)))
-		ret = do_sys_capset_other_tasks(pid, &effective, &inheritable,
-						&permitted);
-	else {
-		/*
-		 * This lock is required even when filesystem
-		 * capability support is configured - it protects the
-		 * sys_capget() call from returning incorrect data in
-		 * the case that the targeted process is not the
-		 * current one.
-		 */
-		spin_lock(&task_capability_lock);
-
-		ret = security_capset_check(current, &effective, &inheritable,
-					    &permitted);
-		/*
-		 * Having verified that the proposed changes are
-		 * legal, we now put them into effect.
-		 */
-		if (!ret)
-			security_capset_set(current, &effective, &inheritable,
-					    &permitted);
-		spin_unlock(&task_capability_lock);
-	}
+	spin_lock(&task_capability_lock);
 
+	ret = security_capset_check(&effective, &inheritable, &permitted);
+	if (!ret)
+		security_capset_set(&effective, &inheritable, &permitted);
 
+	spin_unlock(&task_capability_lock);
 	return ret;
 }
 
diff --git a/security/commoncap.c b/security/commoncap.c
index e4c4b3f..059a131 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -95,15 +95,6 @@ int cap_capget (struct task_struct *target, kernel_cap_t *effective,
 
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
-static inline int cap_block_setpcap(struct task_struct *target)
-{
-	/*
-	 * No support for remote process capability manipulation with
-	 * filesystem capability support.
-	 */
-	return (target != current);
-}
-
 static inline int cap_inh_is_capped(void)
 {
 	/*
@@ -118,7 +109,6 @@ static inline int cap_limit_ptraced_target(void) { return 1; }
 
 #else /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
 
-static inline int cap_block_setpcap(struct task_struct *t) { return 0; }
 static inline int cap_inh_is_capped(void) { return 1; }
 static inline int cap_limit_ptraced_target(void)
 {
@@ -127,21 +117,18 @@ static inline int cap_limit_ptraced_target(void)
 
 #endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
 
-int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
+int cap_capset_check (kernel_cap_t *effective,
 		      kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
-	if (cap_block_setpcap(target)) {
-		return -EPERM;
-	}
 	if (cap_inh_is_capped()
 	    && !cap_issubset(*inheritable,
-			     cap_combine(target->cap_inheritable,
+			     cap_combine(current->cap_inheritable,
 					 current->cap_permitted))) {
 		/* incapable of using this inheritable set */
 		return -EPERM;
 	}
 	if (!cap_issubset(*inheritable,
-			   cap_combine(target->cap_inheritable,
+			   cap_combine(current->cap_inheritable,
 				       current->cap_bset))) {
 		/* no new pI capabilities outside bounding set */
 		return -EPERM;
@@ -149,7 +136,7 @@ int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
 
 	/* verify restrictions on target's new Permitted set */
 	if (!cap_issubset (*permitted,
-			   cap_combine (target->cap_permitted,
+			   cap_combine (current->cap_permitted,
 					current->cap_permitted))) {
 		return -EPERM;
 	}
@@ -162,12 +149,12 @@ int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
 	return 0;
 }
 
-void cap_capset_set (struct task_struct *target, kernel_cap_t *effective,
+void cap_capset_set (kernel_cap_t *effective,
 		     kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
-	target->cap_effective = *effective;
-	target->cap_inheritable = *inheritable;
-	target->cap_permitted = *permitted;
+	current->cap_effective = *effective;
+	current->cap_inheritable = *inheritable;
+	current->cap_permitted = *permitted;
 }
 
 static inline void bprm_clear_caps(struct linux_binprm *bprm)
diff --git a/security/security.c b/security/security.c
index 3a4b4f5..78502ac 100644
--- a/security/security.c
+++ b/security/security.c
@@ -145,20 +145,18 @@ int security_capget(struct task_struct *target,
 	return security_ops->capget(target, effective, inheritable, permitted);
 }
 
-int security_capset_check(struct task_struct *target,
-			   kernel_cap_t *effective,
-			   kernel_cap_t *inheritable,
-			   kernel_cap_t *permitted)
+int security_capset_check(kernel_cap_t *effective,
+			  kernel_cap_t *inheritable,
+			  kernel_cap_t *permitted)
 {
-	return security_ops->capset_check(target, effective, inheritable, permitted);
+	return security_ops->capset_check(effective, inheritable, permitted);
 }
 
-void security_capset_set(struct task_struct *target,
-			  kernel_cap_t *effective,
-			  kernel_cap_t *inheritable,
-			  kernel_cap_t *permitted)
+void security_capset_set(kernel_cap_t *effective,
+			 kernel_cap_t *inheritable,
+			 kernel_cap_t *permitted)
 {
-	security_ops->capset_set(target, effective, inheritable, permitted);
+	security_ops->capset_set(effective, inheritable, permitted);
 }
 
 int security_capable(struct task_struct *tsk, int cap)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6b5790b..b040887 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1781,22 +1781,22 @@ static int selinux_capget(struct task_struct *target, kernel_cap_t *effective,
 	return secondary_ops->capget(target, effective, inheritable, permitted);
 }
 
-static int selinux_capset_check(struct task_struct *target, kernel_cap_t *effective,
+static int selinux_capset_check(kernel_cap_t *effective,
 				kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
 	int error;
 
-	error = secondary_ops->capset_check(target, effective, inheritable, permitted);
+	error = secondary_ops->capset_check(effective, inheritable, permitted);
 	if (error)
 		return error;
 
-	return task_has_perm(current, target, PROCESS__SETCAP);
+	return task_has_perm(current, current, PROCESS__SETCAP);
 }
 
-static void selinux_capset_set(struct task_struct *target, kernel_cap_t *effective,
+static void selinux_capset_set(kernel_cap_t *effective,
 			       kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
-	secondary_ops->capset_set(target, effective, inheritable, permitted);
+	secondary_ops->capset_set(effective, inheritable, permitted);
 }
 
 static int selinux_capable(struct task_struct *tsk, int cap)


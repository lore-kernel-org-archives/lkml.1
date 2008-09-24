Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbYIXCF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbYIXCF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 22:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYIXCFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 22:05:50 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34307 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYIXCFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 22:05:48 -0400
Date: Tue, 23 Sep 2008 21:05:26 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-security-module@vger.kernel.org, James Morris <jmorris@redhat.com>,
       Andrew Morgan <morgan@kernel.org>, Andreas Gruenbacher <agruen@suse.de>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 2/2] file capabilities: remove
	CONFIG_SECURITY_FILE_CAPABILITIES
Message-ID: <20080924020526.GA26058@us.ibm.com>
References: <20080924020432.GA25997@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924020432.GA25997@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the option to compile the kernel without file capabilities.  Not
compiling file capabilities actually makes the kernel less safe, as it
includes the possibility for a task changing another task's capabilities.

Some are concerned that userspace tools (and user education) are not
up to the task of properly configuring file capabilities on a system.
For those cases, there is now the ability to boot with the no_file_caps
boot option.  This will prevent file capabilities from being used in
the capabilities recalculation at exec, but will not change the rest
of the kernel behavior which used to be switchable using the
CONFIG_SECURITY_FILE_CAPABILITIES option.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/open.c                  |    8 --
 include/linux/capability.h |    2 -
 include/linux/init_task.h  |    4 -
 kernel/capability.c        |  158 --------------------------------------------
 security/Kconfig           |    9 ---
 security/commoncap.c       |   53 ---------------
 6 files changed, 0 insertions(+), 234 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 07da935..6e1cd6e 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -444,14 +444,6 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 		/*
 		 * Clear the capabilities if we switch to a non-root user
 		 */
-#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
-		/*
-		 * FIXME: There is a race here against sys_capset.  The
-		 * capabilities can change yet we will restore the old
-		 * value below.  We should hold task_capabilities_lock,
-		 * but we cannot because user_path_at can sleep.
-		 */
-#endif /* ndef CONFIG_SECURITY_FILE_CAPABILITIES */
 		if (current->uid)
 			old_cap = cap_set_effective(__cap_empty_set);
 		else
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 5bc145b..07a9ada 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -68,9 +68,7 @@ typedef struct __user_cap_data_struct {
 #define VFS_CAP_U32             VFS_CAP_U32_2
 #define VFS_CAP_REVISION	VFS_CAP_REVISION_2
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 extern int file_caps_enabled;
-#endif
 
 struct vfs_cap_data {
 	__le32 magic_etc;            /* Little endian */
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 021d8e7..7c177b9 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -102,16 +102,12 @@ extern struct group_info init_groups;
 #define INIT_IDS
 #endif
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 /*
  * Because of the reduced scope of CAP_SETPCAP when filesystem
  * capabilities are in effect, it is safe to allow CAP_SETPCAP to
  * be available in the default configuration.
  */
 # define CAP_INIT_BSET  CAP_FULL_SET
-#else
-# define CAP_INIT_BSET  CAP_INIT_EFF_SET
-#endif
 
 /*
  *  INIT_TASK is used to set up the first task table, touch at
diff --git a/kernel/capability.c b/kernel/capability.c
index e13a685..d39c989 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -33,7 +33,6 @@ EXPORT_SYMBOL(__cap_empty_set);
 EXPORT_SYMBOL(__cap_full_set);
 EXPORT_SYMBOL(__cap_init_eff_set);
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 int file_caps_enabled = 1;
 
 static int __init file_caps_disable(char *str)
@@ -42,7 +41,6 @@ static int __init file_caps_disable(char *str)
 	return 1;
 }
 __setup("no_file_caps", file_caps_disable);
-#endif
 
 /*
  * More recent versions of libcap are available from:
@@ -126,160 +124,6 @@ static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
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
@@ -327,8 +171,6 @@ static inline int do_sys_capset_other_tasks(pid_t pid,
 	return -EPERM;
 }
 
-#endif /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
-
 /*
  * Atomically modify the effective capabilities returning the original
  * value. No permission check is performed here - it is assumed that the
diff --git a/security/Kconfig b/security/Kconfig
index 5592939..2cf7fb9 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -73,15 +73,6 @@ config SECURITY_NETWORK_XFRM
 	  IPSec.
 	  If you are unsure how to answer this question, answer N.
 
-config SECURITY_FILE_CAPABILITIES
-	bool "File POSIX Capabilities"
-	default n
-	help
-	  This enables filesystem capabilities, allowing you to give
-	  binaries a subset of root's powers without using setuid 0.
-
-	  If in doubt, answer N.
-
 config SECURITY_ROOTPLUG
 	bool "Root Plug Support"
 	depends on USB=y && SECURITY
diff --git a/security/commoncap.c b/security/commoncap.c
index 5f1fec0..9bfef94 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -93,8 +93,6 @@ int cap_capget (struct task_struct *target, kernel_cap_t *effective,
 	return 0;
 }
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
-
 static inline int cap_block_setpcap(struct task_struct *target)
 {
 	/*
@@ -116,17 +114,6 @@ static inline int cap_inh_is_capped(void)
 
 static inline int cap_limit_ptraced_target(void) { return 1; }
 
-#else /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
-
-static inline int cap_block_setpcap(struct task_struct *t) { return 0; }
-static inline int cap_inh_is_capped(void) { return 1; }
-static inline int cap_limit_ptraced_target(void)
-{
-	return !capable(CAP_SETPCAP);
-}
-
-#endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
-
 int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
 		      kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
@@ -176,8 +163,6 @@ static inline void bprm_clear_caps(struct linux_binprm *bprm)
 	bprm->cap_effective = false;
 }
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
-
 int cap_inode_need_killpriv(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
@@ -317,24 +302,6 @@ out:
 	return rc;
 }
 
-#else
-int cap_inode_need_killpriv(struct dentry *dentry)
-{
-	return 0;
-}
-
-int cap_inode_killpriv(struct dentry *dentry)
-{
-	return 0;
-}
-
-static inline int get_file_caps(struct linux_binprm *bprm)
-{
-	bprm_clear_caps(bprm);
-	return 0;
-}
-#endif
-
 int cap_bprm_set_security (struct linux_binprm *bprm)
 {
 	int ret;
@@ -535,7 +502,6 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 	return 0;
 }
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 /*
  * Rationale: code calling task_setscheduler, task_setioprio, and
  * task_setnice, assumes that
@@ -587,22 +553,6 @@ static long cap_prctl_drop(unsigned long cap)
 	return 0;
 }
 
-#else
-int cap_task_setscheduler (struct task_struct *p, int policy,
-			   struct sched_param *lp)
-{
-	return 0;
-}
-int cap_task_setioprio (struct task_struct *p, int ioprio)
-{
-	return 0;
-}
-int cap_task_setnice (struct task_struct *p, int nice)
-{
-	return 0;
-}
-#endif
-
 int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		   unsigned long arg4, unsigned long arg5, long *rc_p)
 {
@@ -615,7 +565,6 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		else
 			error = !!cap_raised(current->cap_bset, arg2);
 		break;
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 	case PR_CAPBSET_DROP:
 		error = cap_prctl_drop(arg2);
 		break;
@@ -662,8 +611,6 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		error = current->securebits;
 		break;
 
-#endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
-
 	case PR_GET_KEEPCAPS:
 		if (issecure(SECURE_KEEP_CAPS))
 			error = 1;
-- 
1.5.4.3


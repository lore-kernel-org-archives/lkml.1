Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZKTUTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZKTUTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbZKTUTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:19:49 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:48036 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbZKTUTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:19:46 -0500
Date: Fri, 20 Nov 2009 14:19:33 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Steve Grubb <sgrubb@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Kees Cook <kees.cook@canonical.com>, Andrew Morgan <morgan@kernel.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: [RFC] remove CONFIG_SECURITY_FILE_CAPABILITIES compile option
Message-ID: <20091120201933.GA16694@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I know, all distros currently ship kernels with default
CONFIG_SECURITY_FILE_CAPABILITIES=y.  Since having the option on
leaves a 'no_file_caps' option to boot without file capabilities,
the main reason to keep the option is that turning it off saves
you (on my s390x partition) 5k.  In particular, vmlinux sizes
came to:

SECURITY=n,SECURITY_FILE_CAPABILITIES=n: 53641039
SECURITY=n,SECURITY_FILE_CAPABILITIES=y: 53646053

Against this we must weigh the fact that there is no simple way for
userspace to figure out whether file capabilities are supported,
while things like per-process securebits, capability bounding
sets, and adding bits to pI if CAP_SETPCAP is in pE are not supported
with SECURITY_FILE_CAPABILITIES=n, leaving a bit of a problem for
applications wanting to know whether they can use them and/or why
something failed.

It also adds another subtly different set of semantics which we must
maintain at the risk of severe security regressions.

So this patch removes the SECURITY_FILE_CAPABILITIES compile
option.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/capability.h |    2 -
 include/linux/init_task.h  |    4 ---
 kernel/capability.c        |    2 -
 security/Kconfig           |    9 --------
 security/commoncap.c       |   50 --------------------------------------------
 5 files changed, 0 insertions(+), 67 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index c8f2a5f..39e5ff5 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -92,9 +92,7 @@ struct vfs_cap_data {
 #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
 #define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 extern int file_caps_enabled;
-#endif
 
 typedef struct kernel_cap_struct {
 	__u32 cap[_KERNEL_CAPABILITY_U32S];
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 21a6f5d..8d10aa7 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -83,16 +83,12 @@ extern struct group_info init_groups;
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
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 #define INIT_TASK_RCU_PREEMPT(tsk)					\
diff --git a/kernel/capability.c b/kernel/capability.c
index 4e17041..31ad005 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -29,7 +29,6 @@ EXPORT_SYMBOL(__cap_empty_set);
 EXPORT_SYMBOL(__cap_full_set);
 EXPORT_SYMBOL(__cap_init_eff_set);
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 int file_caps_enabled = 1;
 
 static int __init file_caps_disable(char *str)
@@ -38,7 +37,6 @@ static int __init file_caps_disable(char *str)
 	return 1;
 }
 __setup("no_file_caps", file_caps_disable);
-#endif
 
 /*
  * More recent versions of libcap are available from:
diff --git a/security/Kconfig b/security/Kconfig
index fb363cd..5fdd57d 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -91,15 +91,6 @@ config SECURITY_PATH
 	  implement pathname based access controls.
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
index fe30751..21bcfd3 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -173,7 +173,6 @@ int cap_capget(struct task_struct *target, kernel_cap_t *effective,
  */
 static inline int cap_inh_is_capped(void)
 {
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
 	/* they are so limited unless the current task has the CAP_SETPCAP
 	 * capability
@@ -181,7 +180,6 @@ static inline int cap_inh_is_capped(void)
 	if (cap_capable(current, current_cred(), CAP_SETPCAP,
 			SECURITY_CAP_AUDIT) == 0)
 		return 0;
-#endif
 	return 1;
 }
 
@@ -239,8 +237,6 @@ static inline void bprm_clear_caps(struct linux_binprm *bprm)
 	bprm->cap_effective = false;
 }
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
-
 /**
  * cap_inode_need_killpriv - Determine if inode change affects privileges
  * @dentry: The inode/dentry in being changed with change marked ATTR_KILL_PRIV
@@ -421,30 +417,6 @@ out:
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
-int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps)
-{
-	memset(cpu_caps, 0, sizeof(struct cpu_vfs_cap_data));
- 	return -ENODATA;
-}
-
-static inline int get_file_caps(struct linux_binprm *bprm, bool *effective)
-{
-	bprm_clear_caps(bprm);
-	return 0;
-}
-#endif
-
 /*
  * Determine whether a exec'ing process's new permitted capabilities should be
  * limited to just what it already has.
@@ -457,10 +429,8 @@ static inline int get_file_caps(struct linux_binprm *bprm, bool *effective)
  */
 static inline int cap_limit_ptraced_target(void)
 {
-#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
 	if (capable(CAP_SETPCAP))
 		return 0;
-#endif
 	return 1;
 }
 
@@ -739,7 +709,6 @@ int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags)
 	return 0;
 }
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 /*
  * Rationale: code calling task_setscheduler, task_setioprio, and
  * task_setnice, assumes that
@@ -820,22 +789,6 @@ static long cap_prctl_drop(struct cred *new, unsigned long cap)
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
 /**
  * cap_task_prctl - Implement process control functions for this security module
  * @option: The process control function requested
@@ -866,7 +819,6 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		error = !!cap_raised(new->cap_bset, arg2);
 		goto no_change;
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 	case PR_CAPBSET_DROP:
 		error = cap_prctl_drop(new, arg2);
 		if (error < 0)
@@ -917,8 +869,6 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		error = new->securebits;
 		goto no_change;
 
-#endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
-
 	case PR_GET_KEEPCAPS:
 		if (issecure(SECURE_KEEP_CAPS))
 			error = 1;
-- 
1.6.1


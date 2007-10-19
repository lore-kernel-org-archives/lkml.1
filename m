Return-Path: <linux-kernel-owner+w=401wt.eu-S936409AbXJSUfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936409AbXJSUfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759583AbXJSUfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:35:41 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59736 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764787AbXJSUfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:35:40 -0400
Date: Fri, 19 Oct 2007 15:35:27 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <morgan@kernel.org>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH RFC] capabilities: fix compilation with strict type checking
Message-ID: <20071019203527.GA23716@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From cd7c384f76d2c0f6b12a1c0936d54ae9c5e7cb4c Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Fri, 19 Oct 2007 15:39:10 -0400
Subject: [PATCH RFC] capabilities: fix compilation with strict type checking (v2)

Since at least 1998 the code under STRICT_CAP_T_TYPECHECKS option has
not been used.  (See
http://www.uwsg.iu.edu/hypermail/linux/kernel/9810.2/0705.html)

There are two options - we can remove this option altogether
or, as this patch attempts to do, fix compilation with
STRICT_CAP_T_TYPECHECKS so it can be enabled.

This patch replaces the always-undefined STRICT_CAP_T_TYPECHECKS
with a Kconfig variable (CONFIG_CAP_STRICT_TYPECHECKS), and
hopefully fixes all the places in the code which broke with
that option set.  This compiles with capabilities, selinux,
and dummy modules.  It passes ltp with capabilities and file
capabilities.

However this patch is only for comment.  Much more testing and
proofreading is needed before considering applying.  I will
also be sending out the alternative patch which simply removes
the strict typechecking.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 fs/nfsd/auth.c             |    2 +-
 include/linux/capability.h |   45 +++++++++++++++++++------------------------
 kernel/capability.c        |   12 ++++++++++-
 security/Kconfig           |   12 +++++++++++
 security/commoncap.c       |   22 +++++++++++---------
 security/dummy.c           |   13 +++++++----
 6 files changed, 64 insertions(+), 42 deletions(-)

diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 2192805..43b3340 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -72,7 +72,7 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 		cap_t(current->cap_effective) &= ~CAP_NFSD_MASK;
 	} else {
 		cap_t(current->cap_effective) |= (CAP_NFSD_MASK &
-						  current->cap_permitted);
+					  cap_t(current->cap_permitted));
 	}
 	return ret;
 }
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 7a8d7ad..f752bed 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -62,28 +62,6 @@ struct vfs_cap_data {
 	} data[1];
 };
 
-#ifdef __KERNEL__
-
-/* #define STRICT_CAP_T_TYPECHECKS */
-
-#ifdef STRICT_CAP_T_TYPECHECKS
-
-typedef struct kernel_cap_struct {
-	__u32 cap;
-} kernel_cap_t;
-
-#else
-
-typedef __u32 kernel_cap_t;
-
-#endif
-
-#define _USER_CAP_HEADER_SIZE  (2*sizeof(__u32))
-#define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
-
-#endif
-
-
 /**
  ** POSIX-draft defined capabilities.
  **/
@@ -315,15 +293,27 @@ typedef __u32 kernel_cap_t;
  * Internal kernel functions only
  */
 
-#ifdef STRICT_CAP_T_TYPECHECKS
+#define _USER_CAP_HEADER_SIZE  (2*sizeof(__u32))
+#define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
+#define CAP_TO_MASK(x) (1 << (x))
+
+#ifdef CONFIG_CAP_STRICT_TYPECHECKS
 
-#define to_cap_t(x) { x }
+typedef struct kernel_cap_struct {
+	__u32 cap;
+} kernel_cap_t;
+
+#define to_cap_t(x) { .cap = x, }
 #define cap_t(x) (x).cap
+#define cap_assign(x, v) { x.cap = v; }
 
 #else
 
+typedef __u32 kernel_cap_t;
+
 #define to_cap_t(x) (x)
 #define cap_t(x) (x)
+#define cap_assign(cap, v) { cap = v; }
 
 #endif
 
@@ -332,7 +322,12 @@ typedef __u32 kernel_cap_t;
 #define CAP_INIT_EFF_SET    to_cap_t(~0 & ~CAP_TO_MASK(CAP_SETPCAP))
 #define CAP_INIT_INH_SET    to_cap_t(0)
 
-#define CAP_TO_MASK(x) (1 << (x))
+extern kernel_cap_t cap_empty_set;
+extern kernel_cap_t cap_full_set;
+extern kernel_cap_t cap_init_eff_set;
+extern kernel_cap_t cap_init_inh_set;
+extern kernel_cap_t cap_fs_mask_set;
+
 #define cap_raise(c, flag)   (cap_t(c) |=  CAP_TO_MASK(flag))
 #define cap_lower(c, flag)   (cap_t(c) &= ~CAP_TO_MASK(flag))
 #define cap_raised(c, flag)  (cap_t(c) & CAP_TO_MASK(flag))
diff --git a/kernel/capability.c b/kernel/capability.c
index 4a881b8..7094ad9 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -15,6 +15,12 @@
 #include <linux/pid_namespace.h>
 #include <asm/uaccess.h>
 
+kernel_cap_t cap_empty_set	= CAP_EMPTY_SET;
+kernel_cap_t cap_full_set	= CAP_FULL_SET;
+kernel_cap_t cap_init_eff_set	= CAP_INIT_EFF_SET;
+kernel_cap_t cap_init_inh_set	= CAP_INIT_INH_SET;
+kernel_cap_t cap_fs_mask_set	= to_cap_t(CAP_FS_MASK);
+
 /*
  * This lock protects task->cap_* for all tasks including current.
  * Locking rule: acquire this prior to tasklist_lock.
@@ -43,6 +49,7 @@ asmlinkage long sys_capget(cap_user_header_t header, cap_user_data_t dataptr)
 	__u32 version;
 	struct task_struct *target;
 	struct __user_cap_data_struct data;
+	kernel_cap_t pE, pP, pI;
 
 	if (get_user(version, &header->version))
 		return -EFAULT;
@@ -71,7 +78,10 @@ asmlinkage long sys_capget(cap_user_header_t header, cap_user_data_t dataptr)
 	} else
 		target = current;
 
-	ret = security_capget(target, &data.effective, &data.inheritable, &data.permitted);
+	ret = security_capget(target, &pE, &pI, &pP);
+	data.effective = cap_t(pE);
+	data.inheritable = cap_t(pI);
+	data.permitted = cap_t(pP);
 
 out:
 	read_unlock(&tasklist_lock);
diff --git a/security/Kconfig b/security/Kconfig
index 8086e61..c011eba 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -39,6 +39,18 @@ config KEYS_DEBUG_PROC_KEYS
 
 	  If you are unsure as to whether this is required, answer N.
 
+config CAP_STRICT_TYPECHECKS
+	bool "Strict capability type checks"
+	default n
+	help
+	  This option compiles the kernel with strict checks on
+	  capability types.
+	  
+	  This results in no functional difference, but is useful for
+	  verification of proper use of the in-kernel capability API.
+
+	  If you are unsure, answer N.
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
diff --git a/security/commoncap.c b/security/commoncap.c
index 43f9027..36d8361 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -87,9 +87,9 @@ int cap_capget (struct task_struct *target, kernel_cap_t *effective,
 		kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
 	/* Derived from kernel/capability.c:sys_capget. */
-	*effective = cap_t (target->cap_effective);
-	*inheritable = cap_t (target->cap_inheritable);
-	*permitted = cap_t (target->cap_permitted);
+	*effective = target->cap_effective;
+	*inheritable = target->cap_inheritable;
+	*permitted = target->cap_permitted;
 	return 0;
 }
 
@@ -206,8 +206,8 @@ static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
 			bprm->cap_effective = true;
 		else
 			bprm->cap_effective = false;
-		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps[1]) );
-		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps[2]) );
+		cap_assign(bprm->cap_permitted, le32_to_cpu(caps[1]));
+		cap_assign(bprm->cap_inheritable, le32_to_cpu(caps[2]));
 		return 0;
 	default:
 		return -EINVAL;
@@ -337,8 +337,10 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 	 * capability rules */
 	if (!is_global_init(current)) {
 		current->cap_permitted = new_permitted;
-		current->cap_effective = bprm->cap_effective ?
-				new_permitted : 0;
+		if (bprm->cap_effective)
+			current->cap_effective = new_permitted;
+		else
+			current->cap_effective = cap_empty_set;
 	}
 
 	/* AUD: Audit candidate if current->cap_effective is set */
@@ -557,9 +559,9 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 
 void cap_task_reparent_to_init (struct task_struct *p)
 {
-	p->cap_effective = CAP_INIT_EFF_SET;
-	p->cap_inheritable = CAP_INIT_INH_SET;
-	p->cap_permitted = CAP_FULL_SET;
+	p->cap_effective = cap_init_eff_set;
+	p->cap_inheritable = cap_init_inh_set;
+	p->cap_permitted = cap_full_set;
 	p->keep_capabilities = 0;
 	return;
 }
diff --git a/security/dummy.c b/security/dummy.c
index 6d895ad..c85538f 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -36,14 +36,17 @@ static int dummy_ptrace (struct task_struct *parent, struct task_struct *child)
 static int dummy_capget (struct task_struct *target, kernel_cap_t * effective,
 			 kernel_cap_t * inheritable, kernel_cap_t * permitted)
 {
-	*effective = *inheritable = *permitted = 0;
+	kernel_cap_t pcapmask = to_cap_t(CAP_TO_MASK(CAP_SETPCAP));
+
+	*effective = *inheritable = *permitted = cap_empty_set;
 	if (target->euid == 0) {
-		*permitted |= (~0 & ~CAP_FS_MASK);
-		*effective |= (~0 & ~CAP_TO_MASK(CAP_SETPCAP) & ~CAP_FS_MASK);
+		*permitted = cap_drop(cap_full_set, cap_fs_mask_set);
+		*effective = cap_drop(cap_full_set, pcapmask);
+		*effective = cap_drop(*effective, cap_fs_mask_set);
 	}
 	if (target->fsuid == 0) {
-		*permitted |= CAP_FS_MASK;
-		*effective |= CAP_FS_MASK;
+		*permitted = cap_combine(*permitted, cap_fs_mask_set);
+		*effective = cap_combine(*effective, cap_fs_mask_set);
 	}
 	return 0;
 }
-- 
1.5.1.1.GIT


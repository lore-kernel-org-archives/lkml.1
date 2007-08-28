Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbXH1HUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbXH1HUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 03:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXH1HUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 03:20:33 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:56974 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXH1HUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 03:20:31 -0400
Message-ID: <46D3CCBA.1020204@kernel.org>
Date: Tue, 28 Aug 2007 00:20:26 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
       sds@tycho.nsa.gov
CC: chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [2.6 patch] remove securebits
References: <20070824210649.GG30705@stusta.de> <20070824211942.GA24478@vino.hallyn.com> <46CFA6F2.9030209@kernel.org> <20070825182846.GN30705@stusta.de> <20070827150941.GA31042@vino.hallyn.com> <20070827151751.GD4121@stusta.de> <20070827152817.GA31632@vino.hallyn.com> <20070827155855.GE4121@stusta.de>
In-Reply-To: <20070827155855.GE4121@stusta.de>
X-Enigmail-Version: 0.94.4.0
Content-Type: multipart/mixed;
 boundary="------------080509000404030706020703"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080509000404030706020703
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Attached is what I consider only an RFC patch.

I've not really thought through (to my satisfaction) the re-purposing of
current->keep_capabilities in the non-filesystem-supporting-capability
configuration, but this is basically the code I'm thinking about. (I'm
typing this email from a system running this patch over 2.6.23-rc3-mm1
so its not 'obviously' broken.)

Adrian Bunk wrote:
>> The user would be userspace...
>>
>> Unless by 'the user' you actually mean the patch itself which will allow
>> the setting of secure_noroot per-process.  I don't know for sure, but
>> suspect Andrew might like to wait until file capabilities make it into
>> and stabilize in Linus' tree before going on with that.
> 
> That's what I am talking about.
> 
> This patch should be submitted and discussed together with the changes 
> Andrew has for securebits.

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFG08y0QheEq9QabfIRAnUhAKCEHyUko292kULNTkRqQOGki2NohgCdGXvV
bc+bHzBbI6sPimdf4UTAzGY=
=vB0u
-----END PGP SIGNATURE-----

--------------080509000404030706020703
Content-Type: text/x-patch;
 name="0001-Remove-global-securebits-from-the-kernel.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Remove-global-securebits-from-the-kernel.patch"

>From a8366ab7a12ed4283e24096e891ac13c1d471756 Mon Sep 17 00:00:00 2001
From: Andrew Morgan <morgan@kernel.org>
Date: Mon, 27 Aug 2007 23:09:20 -0700
Subject: [PATCH] Remove global securebits from the kernel.

In the absence of filesystem capability support, there is no
longer any internal support for disabling root. The plain fact is
that while there was internal support for it, the userspace API for
enabling it was not implemented, and having a global personality
of this sort was almost impossible to use.

With filesystem capability support, a new prctl(PR_[GS]ET_CAPONLY)
per-process flag is available. Once set (to 1) a process and all
of its children will irrevocably lose root-is-all-capable privilege.

NOTE: just because root within a given process tree is not capable,
it does not mean root is impotent. Most Linux systems are riddled
with critical system files that are owned by root (uid=0), so much
care should be used relying on the security provided by this support.
It is likely that the best way to use this feature is within some
sort of restricted (chroot etc.) environment. Be especially careful
of where you mount /proc/....
---
 include/linux/capability.h |   10 +++-
 include/linux/prctl.h      |    4 +
 include/linux/sched.h      |    1 -
 include/linux/securebits.h |   30 ----------
 include/linux/security.h   |   17 ++++--
 kernel/sys.c               |   14 +----
 security/capability.c      |    1 +
 security/commoncap.c       |  132 +++++++++++++++++++++++++++++---------------
 security/dummy.c           |    5 +-
 security/security.c        |    5 +-
 security/selinux/hooks.c   |    6 +-
 11 files changed, 124 insertions(+), 101 deletions(-)
 delete mode 100644 include/linux/securebits.h

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 7a8d7ad..0fcef09 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -147,8 +147,14 @@ typedef __u32 kernel_cap_t;
  ** Linux-specific capabilities
  **/
 
-/* Transfer any capability in your permitted set to any pid,
-   remove any capability in your permitted set from any pid */
+/* With filesystem support for capabilities configured:
+ *   Permit the current process to raise any capability in its inheritable set.
+ *   Permit the current process to lock the process into capability-only mode
+ *     - prctl(PR_SET_CAPONLY, 1, ...)
+ * Otherwise:
+ *   Transfer any capability in your permitted set to any pid,
+ *   remove any capability in your permitted set from any pid
+ */
 
 #define CAP_SETPCAP          8
 
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index e2eff90..e3f49a7 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -63,4 +63,8 @@
 #define PR_GET_SECCOMP	21
 #define PR_SET_SECCOMP	22
 
+/* Get/Set process personality to secure-by-capabilities alone */
+#define PR_GET_CAPONLY  23
+#define PR_SET_CAPONLY  24
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2b3c936..be2e9c4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -67,7 +67,6 @@ struct sched_param {
 #include <linux/smp.h>
 #include <linux/sem.h>
 #include <linux/signal.h>
-#include <linux/securebits.h>
 #include <linux/fs_struct.h>
 #include <linux/compiler.h>
 #include <linux/completion.h>
diff --git a/include/linux/securebits.h b/include/linux/securebits.h
deleted file mode 100644
index 5b06178..0000000
--- a/include/linux/securebits.h
+++ /dev/null
@@ -1,30 +0,0 @@
-#ifndef _LINUX_SECUREBITS_H
-#define _LINUX_SECUREBITS_H 1
-
-#define SECUREBITS_DEFAULT 0x00000000
-
-extern unsigned securebits;
-
-/* When set UID 0 has no special privileges. When unset, we support
-   inheritance of root-permissions and suid-root executable under
-   compatibility mode. We raise the effective and inheritable bitmasks
-   *of the executable file* if the effective uid of the new process is
-   0. If the real uid is 0, we raise the inheritable bitmask of the
-   executable file. */
-#define SECURE_NOROOT            0
-
-/* When set, setuid to/from uid 0 does not trigger capability-"fixes"
-   to be compatible with old programs relying on set*uid to loose
-   privileges. When unset, setuid doesn't change privileges. */
-#define SECURE_NO_SETUID_FIXUP   2
-
-/* Each securesetting is implemented using two bits. One bit specify
-   whether the setting is on or off. The other bit specify whether the
-   setting is fixed or not. A setting which is fixed cannot be changed
-   from user-level. */
-
-#define issecure(X) ( (1 << (X+1)) & SECUREBITS_DEFAULT ? 	\
-		      (1 << (X)) & SECUREBITS_DEFAULT :		\
-		      (1 << (X)) & securebits )
-
-#endif /* !_LINUX_SECUREBITS_H */
diff --git a/include/linux/security.h b/include/linux/security.h
index 13d48fd..4227464 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -660,13 +660,18 @@ struct request_sock;
  *	Return 0 if permission is granted.
  * @task_prctl:
  *	Check permission before performing a process control operation on the
- *	current process.
+ *	current process. This hook can also be used to provide LSM specific
+ *      process control functions.
  *	@option contains the operation.
  *	@arg2 contains a argument.
  *	@arg3 contains a argument.
  *	@arg4 contains a argument.
  *	@arg5 contains a argument.
- *	Return 0 if permission is granted.
+ *      @errorp contains a pointer to the kernel variable holding the return
+ *      value.
+ *	Return 0 if permission is granted (pass-through); return 1
+ *	(and set *errorp to the appropriate value, if the LSM is
+ *	overriding default behavior.
  * @task_reparent_to_init:
  * 	Set the security attributes in @p->security for a kernel thread that
  * 	is being reparented to the init task.
@@ -1304,7 +1309,7 @@ struct security_operations {
 	int (*task_wait) (struct task_struct * p);
 	int (*task_prctl) (int option, unsigned long arg2,
 			   unsigned long arg3, unsigned long arg4,
-			   unsigned long arg5);
+			   unsigned long arg5, long *errorp);
 	void (*task_reparent_to_init) (struct task_struct * p);
 	void (*task_to_inode)(struct task_struct *p, struct inode *inode);
 
@@ -1550,7 +1555,8 @@ int security_task_kill(struct task_struct *p, struct siginfo *info,
 			int sig, u32 secid);
 int security_task_wait(struct task_struct *p);
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			 unsigned long arg4, unsigned long arg5);
+			 unsigned long arg4, unsigned long arg5,
+			 long *errorp);
 void security_task_reparent_to_init(struct task_struct *p);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
@@ -2096,7 +2102,8 @@ static inline int security_task_wait (struct task_struct *p)
 static inline int security_task_prctl (int option, unsigned long arg2,
 				       unsigned long arg3,
 				       unsigned long arg4,
-				       unsigned long arg5)
+				       unsigned long arg5,
+				       long *errorp)
 {
 	return 0;
 }
diff --git a/kernel/sys.c b/kernel/sys.c
index c7c4fa4..42f26fd 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1639,8 +1639,7 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 {
 	long error;
 
-	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
-	if (error)
+	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
 		return error;
 
 	switch (option) {
@@ -1693,17 +1692,6 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 				error = -EINVAL;
 			break;
 
-		case PR_GET_KEEPCAPS:
-			if (current->keep_capabilities)
-				error = 1;
-			break;
-		case PR_SET_KEEPCAPS:
-			if (arg2 != 0 && arg2 != 1) {
-				error = -EINVAL;
-				break;
-			}
-			current->keep_capabilities = arg2;
-			break;
 		case PR_SET_NAME: {
 			struct task_struct *me = current;
 			unsigned char ncomm[sizeof(me->comm)];
diff --git a/security/capability.c b/security/capability.c
index 9e99f36..8340655 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -45,6 +45,7 @@ static struct security_operations capability_ops = {
 	.task_setioprio =		cap_task_setioprio,
 	.task_setnice =			cap_task_setnice,
 	.task_post_setuid =		cap_task_post_setuid,
+	.task_prctl =                   cap_task_prctl,
 	.task_reparent_to_init =	cap_task_reparent_to_init,
 
 	.syslog =                       cap_syslog,
diff --git a/security/commoncap.c b/security/commoncap.c
index d65ddd3..44bf3fc 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -24,6 +24,7 @@
 #include <linux/hugetlb.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
+#include <linux/prctl.h>
 
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 /*
@@ -39,11 +40,6 @@
 kernel_cap_t cap_bset = CAP_INIT_BSET;    /* systemwide capability bound */
 EXPORT_SYMBOL(cap_bset);
 
-/* Global security state */
-
-unsigned securebits = SECUREBITS_DEFAULT; /* systemwide security settings */
-EXPORT_SYMBOL(securebits);
-
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
 	NETLINK_CB(skb).eff_cap = current->cap_effective;
@@ -164,6 +160,27 @@ static inline void bprm_clear_caps(struct linux_binprm *bprm)
 	bprm->cap_effective = false;
 }
 
+static inline void bprm_force_uid0_caps(struct linux_binprm *bprm)
+{
+	/*
+	 *  To support inheritance of root-permissions and suid-root
+	 *  executables under compatibility mode, we raise all three
+	 *  capability sets for the file.
+	 *
+	 *  If only the real uid is 0, we only raise the inheritable
+	 *  and permitted sets of the executable file.
+	 */
+	if (bprm->e_uid == 0 || current->uid == 0) {
+		cap_set_full (bprm->cap_inheritable);
+		cap_set_full (bprm->cap_permitted);
+	}
+	if (bprm->e_uid == 0) {
+		bprm->cap_effective = true;
+	}
+
+	return;
+}
+
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
 int cap_inode_need_killpriv(struct dentry *dentry)
@@ -215,7 +232,7 @@ static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
 }
 
 /* Locate any VFS capabilities: */
-static int get_file_caps(struct linux_binprm *bprm)
+int cap_bprm_set_security(struct linux_binprm *bprm)
 {
 	struct dentry *dentry;
 	int rc = 0;
@@ -223,8 +240,7 @@ static int get_file_caps(struct linux_binprm *bprm)
 	struct inode *inode;
 
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
-		bprm_clear_caps(bprm);
-		return 0;
+		goto out_no_dentry;
 	}
 
 	dentry = dget(bprm->file->f_dentry);
@@ -249,8 +265,16 @@ static int get_file_caps(struct linux_binprm *bprm)
 
 out:
 	dput(dentry);
-	if (rc)
+
+	if (rc) {
+out_no_dentry:
 		bprm_clear_caps(bprm);
+	}
+
+	if (! current->keep_capabilities) {
+		bprm_force_uid0_caps(bprm);
+		rc = 0;
+	}
 
 	return rc;
 }
@@ -266,42 +290,15 @@ int cap_inode_killpriv(struct dentry *dentry)
 	return 0;
 }
 
-static inline int get_file_caps(struct linux_binprm *bprm)
+int cap_bprm_set_security(struct linux_binprm *bprm)
 {
 	bprm_clear_caps(bprm);
+	bprm_force_uid0_caps(bprm);
+	current->keep_capabilities = 0;
 	return 0;
 }
 #endif
 
-int cap_bprm_set_security (struct linux_binprm *bprm)
-{
-	int ret;
-
-	ret = get_file_caps(bprm);
-	if (ret)
-		printk(KERN_NOTICE "%s: get_file_caps returned %d for %s\n",
-			__FUNCTION__, ret, bprm->filename);
-
-	/*  To support inheritance of root-permissions and suid-root
-	 *  executables under compatibility mode, we raise all three
-	 *  capability sets for the file.
-	 *
-	 *  If only the real uid is 0, we only raise the inheritable
-	 *  and permitted sets of the executable file.
-	 */
-
-	if (!issecure (SECURE_NOROOT)) {
-		if (bprm->e_uid == 0 || current->uid == 0) {
-			cap_set_full (bprm->cap_inheritable);
-			cap_set_full (bprm->cap_permitted);
-		}
-		if (bprm->e_uid == 0)
-			bprm->cap_effective = true;
-	}
-
-	return ret;
-}
-
 void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
 	/* Derived from fs/exec.c:compute_creds. */
@@ -341,8 +338,6 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 	}
 
 	/* AUD: Audit candidate if current->cap_effective is set */
-
-	current->keep_capabilities = 0;
 }
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
@@ -441,8 +436,7 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 	case LSM_SETID_RE:
 	case LSM_SETID_ID:
 	case LSM_SETID_RES:
-		/* Copied from kernel/sys.c:setreuid/setuid/setresuid. */
-		if (!issecure (SECURE_NO_SETUID_FIXUP)) {
+		if (! current->keep_capabilities) {
 			cap_emulate_setxuid (old_ruid, old_euid, old_suid);
 		}
 		break;
@@ -457,7 +451,7 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 			 *          if not, we might be a bit too harsh here.
 			 */
 
-			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
+			if (! current->keep_capabilities) {
 				if (old_fsuid == 0 && current->fsuid != 0) {
 					cap_t (current->cap_effective) &=
 					    ~CAP_FS_MASK;
@@ -579,3 +573,53 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
+int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
+		   unsigned long arg4, unsigned long arg5, long *errorp)
+{
+	switch (option) {
+
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+
+	case PR_GET_CAPONLY:
+		*errorp = current->keep_capabilities;
+		break;
+
+	case PR_SET_CAPONLY:
+		/*
+		 * Only permit setting to 1
+		 */
+		if ((arg2 != 1) || !cap_capable(current, CAP_SETPCAP)) {
+			*errorp = -EPERM;
+		} else {
+			/*
+			 * Once locked, no unlocking for this process
+			 * and its children
+			 */
+			current->keep_capabilities = 1;
+			*errorp = 0;
+		}
+		break;
+
+#else /* ie. ndef CONFIG_SECURITY_FILE_CAPABILITIES */
+
+	case PR_GET_KEEPCAPS:
+		if (current->keep_capabilities)
+			*errorp = 1;
+		break;
+
+	case PR_SET_KEEPCAPS:
+		if (arg2 != 0 && arg2 != 1) {
+			*errorp = -EINVAL;
+			break;
+		}
+		current->keep_capabilities = arg2;
+		break;
+
+#endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
+
+	default:
+		return 0;  /* pass-through */
+	}
+
+	return 1;      /* overridden by capability LSM */
+}
diff --git a/security/dummy.c b/security/dummy.c
index 88bb1bc..0497dc8 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -566,8 +566,9 @@ static int dummy_task_kill (struct task_struct *p, struct siginfo *info,
 	return 0;
 }
 
-static int dummy_task_prctl (int option, unsigned long arg2, unsigned long arg3,
-			     unsigned long arg4, unsigned long arg5)
+static int dummy_task_prctl (int option, unsigned long arg2,
+			     unsigned long arg3, unsigned long arg4,
+			     unsigned long arg5, long *errorp)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index e6d53b3..e3a4285 100644
--- a/security/security.c
+++ b/security/security.c
@@ -665,9 +665,10 @@ int security_task_wait(struct task_struct *p)
 }
 
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			 unsigned long arg4, unsigned long arg5)
+			unsigned long arg4, unsigned long arg5, long *errorp)
 {
-	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
+	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5,
+					errorp);
 }
 
 void security_task_reparent_to_init(struct task_struct *p)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index dc196b9..c8aac50 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2913,12 +2913,14 @@ static int selinux_task_prctl(int option,
 			      unsigned long arg2,
 			      unsigned long arg3,
 			      unsigned long arg4,
-			      unsigned long arg5)
+			      unsigned long arg5,
+			      long *errorp)
 {
 	/* The current prctl operations do not appear to require
 	   any SELinux controls since they merely observe or modify
 	   the state of the current process. */
-	return 0;
+	return secondary_ops->task_prctl(option, arg2, arg3, arg4, arg5,
+					 errorp);
 }
 
 static int selinux_task_wait(struct task_struct *p)
-- 
1.5.1.3


--------------080509000404030706020703--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbZHRXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbZHRXjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZHRXjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:39:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46574 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbZHRXjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:39:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Add a keyctl to install a process's session keyring on
	its parent [RFC]
To: torvalds@osdl.org, jmorris@namei.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Date: Wed, 19 Aug 2009 00:37:59 +0100
Message-ID: <20090818233759.3348.75835.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[[ NOTE!  This patch is not yet complete: support has not been added to Smack
    or Tomoyo, nor have all arches been modified. ]]]

Add a keyctl to install a process's session keyring onto its parent.  This
replaces the parent's session keyring.  Because the COW credential code does
not permit one process to change another process's credentials directly, the
change is deferred until userspace next starts executing again.  Normally this
will be after a wait*() syscall.

To support this, three new security hooks have been provided:
cred_alloc_blank() to allocate unset security creds, cred_transfer() to fill in
the blank security creds and key_session_to_parent() - which asks the LSM if
the process may replace its parent's session keyring.

The replacement may only happen if the process has the same ownership details
as its parent, and the process has LINK permission on the session keyring, and
the session keyring is owned by the process, and the LSM permits it.

This allows the userspace AFS pioctl emulation to fully emulate newpag() and
the VIOCSETTOK and VIOCSETTOK2 pioctls, all of which require the ability to
alter the parent process's PAG membership.  However, since kAFS doesn't use
PAGs per se, but rather dumps the keys into the session keyring, the session
keyring of the parent must be replaced if, for example, VIOCSETTOK is passed
the newpag flag.

This can be tested with the following program:

	#include <stdio.h>
	#include <stdlib.h>
	#include <keyutils.h>

	#define KEYCTL_SESSION_TO_PARENT	18

	#define OSERROR(X, S) do { if ((long)(X) == -1) { perror(S); exit(1); } } while(0)

	int main(int argc, char **argv)
	{
		key_serial_t keyring, key;
		long ret;

		keyring = keyctl_join_session_keyring(argv[1]);
		OSERROR(keyring, "keyctl_join_session_keyring");

		key = add_key("user", "a", "b", 1, keyring);
		OSERROR(key, "add_key");

		ret = keyctl(KEYCTL_SESSION_TO_PARENT);
		OSERROR(ret, "KEYCTL_SESSION_TO_PARENT");

		return 0;
	}

Compiled and linked with -lkeyutils, you should see something like:

	[dhowells@andromeda ~]$ keyctl show
	Session Keyring
	       -3 --alswrv   4043  4043  keyring: _ses
	355907932 --alswrv   4043    -1   \_ keyring: _uid.4043
	[dhowells@andromeda ~]$ /tmp/newpag
	[dhowells@andromeda ~]$ keyctl show
	Session Keyring
	       -3 --alswrv   4043  4043  keyring: _ses
	1055658746 --alswrv   4043  4043   \_ user: a
	[dhowells@andromeda ~]$ /tmp/newpag hello
	[dhowells@andromeda ~]$ keyctl show
	Session Keyring
	       -3 --alswrv   4043  4043  keyring: hello
	340417692 --alswrv   4043  4043   \_ user: a

Where the test program creates a new session keyring, sticks a user key named
'a' into it and then installs it on its parent.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/keys.txt       |   20 ++++++++
 arch/x86/kernel/signal.c     |    2 +
 include/linux/cred.h         |    1 
 include/linux/key.h          |    3 +
 include/linux/keyctl.h       |    1 
 include/linux/sched.h        |    1 
 include/linux/security.h     |   38 ++++++++++++++++
 kernel/cred.c                |   41 +++++++++++++++++
 security/capability.c        |    8 +++
 security/keys/compat.c       |    3 +
 security/keys/internal.h     |    1 
 security/keys/keyctl.c       |  102 ++++++++++++++++++++++++++++++++++++++++++
 security/keys/process_keys.c |   49 ++++++++++++++++++++
 security/security.c          |   17 +++++++
 security/selinux/hooks.c     |   28 ++++++++++++
 15 files changed, 315 insertions(+), 0 deletions(-)


diff --git a/Documentation/keys.txt b/Documentation/keys.txt
index 203487e..e4dbbdb 100644
--- a/Documentation/keys.txt
+++ b/Documentation/keys.txt
@@ -757,6 +757,26 @@ The keyctl syscall functions are:
      successful.
 
 
+ (*) Install the calling process's session keyring on its parent.
+
+	long keyctl(KEYCTL_SESSION_TO_PARENT);
+
+     This functions attempts to install the calling process's session keyring
+     on to the calling process's parent, replacing the parent's current session
+     keyring.
+
+     The calling process must have the same ownership as its parent, the
+     keyring must have the same ownership as the calling process, the calling
+     process must have LINK permission on the keyring and the active LSM module
+     mustn't deny permission, otherwise error EPERM will be returned.
+
+     Error ENOMEM will be returned if there was insufficient memory to complete
+     the operation, otherwise 0 will be returned to indicate success.
+
+     The keyring will be replaced next time the parent process leaves the
+     kernel and resumes executing userspace.
+
+
 ===============
 KERNEL SERVICES
 ===============
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4c57875..81e5823 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -869,6 +869,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
+		if (current->replacement_session_keyring)
+			key_replace_session_keyring();
 	}
 
 #ifdef CONFIG_X86_32
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 8d0ffaa..01ff078 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -152,6 +152,7 @@ struct cred {
 extern void __put_cred(struct cred *);
 extern void exit_creds(struct task_struct *);
 extern int copy_creds(struct task_struct *, unsigned long);
+extern struct cred *cred_alloc_blank(void);
 extern struct cred *prepare_creds(void);
 extern struct cred *prepare_exec_creds(void);
 extern struct cred *prepare_usermodehelper_creds(void);
diff --git a/include/linux/key.h b/include/linux/key.h
index 33e0165..cd50dfa 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -278,6 +278,8 @@ static inline key_serial_t key_serial(struct key *key)
 extern ctl_table key_sysctls[];
 #endif
 
+extern void key_replace_session_keyring(void);
+
 /*
  * the userspace interface
  */
@@ -300,6 +302,7 @@ extern void key_init(void);
 #define key_fsuid_changed(t)		do { } while(0)
 #define key_fsgid_changed(t)		do { } while(0)
 #define key_init()			do { } while(0)
+#define key_replace_session_keyring()	do { } while(0)
 
 #endif /* CONFIG_KEYS */
 #endif /* __KERNEL__ */
diff --git a/include/linux/keyctl.h b/include/linux/keyctl.h
index c0688eb..bd383f1 100644
--- a/include/linux/keyctl.h
+++ b/include/linux/keyctl.h
@@ -52,5 +52,6 @@
 #define KEYCTL_SET_TIMEOUT		15	/* set key timeout */
 #define KEYCTL_ASSUME_AUTHORITY		16	/* assume request_key() authorisation */
 #define KEYCTL_GET_SECURITY		17	/* get key security label */
+#define KEYCTL_SESSION_TO_PARENT	18	/* apply session keyring to parent process */
 
 #endif /*  _LINUX_KEYCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7f4e30b..469cad9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1294,6 +1294,7 @@ struct task_struct {
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
 					 * (notably. ptrace) */
+	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
 
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
diff --git a/include/linux/security.h b/include/linux/security.h
index 5eff459..29eff6f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -633,6 +633,11 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	manual page for definitions of the @clone_flags.
  *	@clone_flags contains the flags indicating what should be shared.
  *	Return 0 if permission is granted.
+ * @cred_alloc_blank:
+ *	@cred points to the credentials.
+ *	@gfp indicates the atomicity of any memory allocations.
+ *	Only allocate sufficient memory and attach to @cred such that
+ *	cred_transfer() will not get ENOMEM.
  * @cred_free:
  *	@cred points to the credentials.
  *	Deallocate and clear the cred->security field in a set of credentials.
@@ -645,6 +650,10 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@new points to the new credentials.
  *	@old points to the original credentials.
  *	Install a new set of credentials.
+ * @cred_transfer:
+ *	@new points to the new credentials.
+ *	@old points to the original credentials.
+ *	Transfer data from original creds to new creds
  * @kernel_act_as:
  *	Set the credentials for a kernel service to act as (subjective context).
  *	@new points to the credentials to be modified.
@@ -1068,6 +1077,13 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Return the length of the string (including terminating NUL) or -ve if
  *      an error.
  *	May also return 0 (and a NULL buffer pointer) if there is no label.
+ * @key_session_to_parent:
+ *	Forcibly assign the session keyring from a process to its parent
+ *	process.
+ *	@cred: Pointer to process's credentials
+ *	@parent_cred: Pointer to parent process's credentials
+ *	@keyring: Proposed new session keyring
+ *	Return 0 if permission is granted, -ve error otherwise.
  *
  * Security hooks affecting all System V IPC operations.
  *
@@ -1463,10 +1479,12 @@ struct security_operations {
 	int (*dentry_open) (struct file *file, const struct cred *cred);
 
 	int (*task_create) (unsigned long clone_flags);
+	int (*cred_alloc_blank) (struct cred *cred, gfp_t gfp);
 	void (*cred_free) (struct cred *cred);
 	int (*cred_prepare)(struct cred *new, const struct cred *old,
 			    gfp_t gfp);
 	void (*cred_commit)(struct cred *new, const struct cred *old);
+	void (*cred_transfer)(struct cred *new, const struct cred *old);
 	int (*kernel_act_as)(struct cred *new, u32 secid);
 	int (*kernel_create_files_as)(struct cred *new, struct inode *inode);
 	int (*task_setuid) (uid_t id0, uid_t id1, uid_t id2, int flags);
@@ -1600,6 +1618,9 @@ struct security_operations {
 			       const struct cred *cred,
 			       key_perm_t perm);
 	int (*key_getsecurity)(struct key *key, char **_buffer);
+	int (*key_session_to_parent)(const struct cred *cred,
+				     const struct cred *parent_cred,
+				     struct key *key);
 #endif	/* CONFIG_KEYS */
 
 #ifdef CONFIG_AUDIT
@@ -1716,9 +1737,11 @@ int security_file_send_sigiotask(struct task_struct *tsk,
 int security_file_receive(struct file *file);
 int security_dentry_open(struct file *file, const struct cred *cred);
 int security_task_create(unsigned long clone_flags);
+int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
 void security_cred_free(struct cred *cred);
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp);
 void security_commit_creds(struct cred *new, const struct cred *old);
+void security_transfer_creds(struct cred *new, const struct cred *old);
 int security_kernel_act_as(struct cred *new, u32 secid);
 int security_kernel_create_files_as(struct cred *new, struct inode *inode);
 int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags);
@@ -2248,6 +2271,9 @@ static inline int security_task_create(unsigned long clone_flags)
 	return 0;
 }
 
+static inline void security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
+{ }
+
 static inline void security_cred_free(struct cred *cred)
 { }
 
@@ -2263,6 +2289,11 @@ static inline void security_commit_creds(struct cred *new,
 {
 }
 
+static inline void security_transfer_creds(struct cred *new,
+					   const struct cred *old)
+{
+}
+
 static inline int security_kernel_act_as(struct cred *cred, u32 secid)
 {
 	return 0;
@@ -2863,6 +2894,9 @@ void security_key_free(struct key *key);
 int security_key_permission(key_ref_t key_ref,
 			    const struct cred *cred, key_perm_t perm);
 int security_key_getsecurity(struct key *key, char **_buffer);
+int security_key_session_to_parent(const struct cred *cred,
+				   const struct cred *parent_cred,
+				   struct key *key);
 
 #else
 
@@ -2890,6 +2924,10 @@ static inline int security_key_getsecurity(struct key *key, char **_buffer)
 	return 0;
 }
 
+static inline int security_key_session_to_parent(const struct cred *cred,
+						 const struct cred *parent_cred,
+						 struct key *key);
+
 #endif
 #endif /* CONFIG_KEYS */
 
diff --git a/kernel/cred.c b/kernel/cred.c
index 36d595f..668fcf5 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -199,6 +199,47 @@ void exit_creds(struct task_struct *tsk)
 	validate_creds(cred);
 	alter_cred_subscribers(cred, -1);
 	put_cred(cred);
+
+	cred = (struct cred *) tsk->replacement_session_keyring;
+	if (cred) {
+		tsk->replacement_session_keyring = NULL;
+		validate_creds(cred);
+		put_cred(cred);
+	}
+}
+
+/*
+ * Allocate blank credentials, such that the credentials can be filled in at a
+ * later date without risk of ENOMEM.
+ */
+struct cred *cred_alloc_blank(void)
+{
+	struct cred *new;
+
+	new = kmem_cache_zalloc(cred_jar, GFP_KERNEL);
+	if (!new)
+		return NULL;
+
+#ifdef CONFIG_KEYS
+	new->tgcred = kzalloc(sizeof(*new->tgcred), GFP_KERNEL);
+	if (!new->tgcred) {
+		kfree(new);
+		return NULL;
+	}
+	atomic_set(&new->tgcred->usage, 1);
+#endif
+
+	atomic_set(&new->usage, 1);
+
+	if (security_cred_alloc_blank(new, GFP_KERNEL) < 0)
+		goto error;
+
+	new->magic = CRED_MAGIC;
+	return new;
+
+error:
+	abort_creds(new);
+	return NULL;
 }
 
 /**
diff --git a/security/capability.c b/security/capability.c
index 21b6cea..cb66f3b 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -824,6 +824,13 @@ static int cap_key_getsecurity(struct key *key, char **_buffer)
 	return 0;
 }
 
+static int cap_key_session_to_parent(const struct cred *cred,
+				     const struct cred *parent_cred,
+				     struct key *key)
+{
+	return 0;
+}
+
 #endif /* CONFIG_KEYS */
 
 #ifdef CONFIG_AUDIT
@@ -1047,6 +1054,7 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, key_free);
 	set_to_cap_if_null(ops, key_permission);
 	set_to_cap_if_null(ops, key_getsecurity);
+	set_to_cap_if_null(ops, key_session_to_parent);
 #endif	/* CONFIG_KEYS */
 #ifdef CONFIG_AUDIT
 	set_to_cap_if_null(ops, audit_rule_init);
diff --git a/security/keys/compat.c b/security/keys/compat.c
index c766c68..792c0a6 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -82,6 +82,9 @@ asmlinkage long compat_sys_keyctl(u32 option,
 	case KEYCTL_GET_SECURITY:
 		return keyctl_get_security(arg2, compat_ptr(arg3), arg4);
 
+	case KEYCTL_SESSION_TO_PARENT:
+		return keyctl_session_to_parent();
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/security/keys/internal.h b/security/keys/internal.h
index fb83051..24ba030 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -201,6 +201,7 @@ extern long keyctl_set_timeout(key_serial_t, unsigned);
 extern long keyctl_assume_authority(key_serial_t);
 extern long keyctl_get_security(key_serial_t keyid, char __user *buffer,
 				size_t buflen);
+extern long keyctl_session_to_parent(void);
 
 /*
  * debugging key validation
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 736d780..74c9685 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1228,6 +1228,105 @@ long keyctl_get_security(key_serial_t keyid,
 	return ret;
 }
 
+/*
+ * attempt to install the calling process's session keyring on the process's
+ * parent process
+ * - the keyring must exist and must grant us LINK permission
+ * - implements keyctl(KEYCTL_SESSION_TO_PARENT)
+ */
+long keyctl_session_to_parent(void)
+{
+	struct task_struct *me, *parent;
+	const struct cred *mycred, *pcred;
+	struct cred *cred, *oldcred;
+	key_ref_t keyring_r;
+	int ret;
+
+	keyring_r = lookup_user_key(KEY_SPEC_SESSION_KEYRING, 0, KEY_LINK);
+	if (IS_ERR(keyring_r))
+		return PTR_ERR(keyring_r);
+
+	/* our parent is going to need a new cred struct, a new tgcred struct
+	 * and new security data, so we allocate them here to prevent ENOMEM in
+	 * our parent */
+	ret = -ENOMEM;
+	cred = cred_alloc_blank();
+	if (!cred)
+		goto error_keyring;
+
+	cred->tgcred->session_keyring = key_ref_to_ptr(keyring_r);
+	keyring_r = NULL;
+
+	me = current;
+	write_lock_irq(&tasklist_lock);
+
+	parent = me->real_parent;
+	ret = -EPERM;
+
+	/* the parent mustn't be init and mustn't be a kernel thread */
+	if (parent->pid <= 1 || !parent->mm)
+		goto not_permitted;
+
+	/* the parent must be single threaded */
+	if (atomic_read(&parent->signal->count) != 1)
+		goto not_permitted;
+
+	/* the parent and the child must have different session keyrings or
+	 * there's no point */
+	mycred = current_cred();
+	pcred = __task_cred(parent);
+	if (mycred == pcred ||
+	    mycred->tgcred->session_keyring == pcred->tgcred->session_keyring)
+		goto already_same;
+
+	/* the parent must have the same effective ownership and mustn't be
+	 * SUID/SGID */
+	if (pcred-> uid	!= mycred->euid	||
+	    pcred->euid	!= mycred->euid	||
+	    pcred->suid	!= mycred->euid	||
+	    pcred-> gid	!= mycred->egid	||
+	    pcred->egid	!= mycred->egid	||
+	    pcred->sgid	!= mycred->egid)
+		goto not_permitted;
+
+	/* the keyrings must have the same UID */
+	if (pcred ->tgcred->session_keyring->uid != mycred->euid ||
+	    mycred->tgcred->session_keyring->uid != mycred->euid)
+		goto not_permitted;
+
+	/* the LSM must permit the replacement of the parent's keyring with the
+	 * keyring from this process */
+	ret = security_key_session_to_parent(mycred, pcred,
+					     key_ref_to_ptr(keyring_r));
+	if (ret < 0)
+		goto not_permitted;
+
+	/* if there's an already pending keyring replacement, then we replace
+	 * that */
+	oldcred = parent->replacement_session_keyring;
+
+	/* the replacement session keyring is applied just prior to userspace
+	 * restarting */
+	parent->replacement_session_keyring = cred;
+	cred = NULL;
+	set_ti_thread_flag(task_thread_info(parent), TIF_NOTIFY_RESUME);
+
+	write_unlock_irq(&tasklist_lock);
+	if (oldcred)
+		put_cred(oldcred);
+	return 0;
+
+already_same:
+	ret = 0;
+not_permitted:
+	put_cred(cred);
+	return ret;
+
+error_keyring:
+	key_ref_put(keyring_r);
+	return ret;
+}
+
 /*****************************************************************************/
 /*
  * the key control system call
@@ -1313,6 +1412,9 @@ SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
 					   (char __user *) arg3,
 					   (size_t) arg4);
 
+	case KEYCTL_SESSION_TO_PARENT:
+		return keyctl_session_to_parent();
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 349c315..4f2bf4e 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/security.h>
 #include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 #include "internal.h"
@@ -768,3 +769,51 @@ error:
 	abort_creds(new);
 	return ret;
 }
+
+/*
+ * Replace a process's session keyring when that process resumes userspace on
+ * behalf of one of its children
+ */
+void key_replace_session_keyring(void)
+{
+	const struct cred *old;
+	struct cred *new;
+
+	if (!current->replacement_session_keyring)
+		return;
+
+	write_lock_irq(&tasklist_lock);
+	new = current->replacement_session_keyring;
+	current->replacement_session_keyring = NULL;
+	write_unlock_irq(&tasklist_lock);
+
+	if (!new)
+		return;
+
+	old = current_cred();
+	new->  uid	= old->  uid;
+	new-> euid	= old-> euid;
+	new-> suid	= old-> suid;
+	new->fsuid	= old->fsuid;
+	new->  gid	= old->  gid;
+	new-> egid	= old-> egid;
+	new-> sgid	= old-> sgid;
+	new->fsgid	= old->fsgid;
+	new->user	= get_uid(old->user);
+	new->group_info	= get_group_info(old->group_info);
+
+	new->securebits	= old->securebits;
+	new->cap_inheritable	= old->cap_inheritable;
+	new->cap_permitted	= old->cap_permitted;
+	new->cap_effective	= old->cap_effective;
+	new->cap_bset		= old->cap_bset;
+
+	new->jit_keyring	= old->jit_keyring;
+	new->thread_keyring	= key_get(old->thread_keyring);
+	new->tgcred->tgid	= old->tgcred->tgid;
+	new->tgcred->process_keyring = key_get(old->tgcred->process_keyring);
+
+	security_transfer_creds(new, old);
+
+	commit_creds(new);
+}
diff --git a/security/security.c b/security/security.c
index fe6b812..6b51c1d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -685,6 +685,11 @@ int security_task_create(unsigned long clone_flags)
 	return security_ops->task_create(clone_flags);
 }
 
+int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
+{
+	return security_ops->cred_alloc_blank(cred, gfp);
+}
+
 void security_cred_free(struct cred *cred)
 {
 	security_ops->cred_free(cred);
@@ -700,6 +705,11 @@ void security_commit_creds(struct cred *new, const struct cred *old)
 	security_ops->cred_commit(new, old);
 }
 
+void security_transfer_creds(struct cred *new, const struct cred *old)
+{
+	security_ops->cred_transfer(new, old);
+}
+
 int security_kernel_act_as(struct cred *new, u32 secid)
 {
 	return security_ops->kernel_act_as(new, secid);
@@ -1219,6 +1229,13 @@ int security_key_getsecurity(struct key *key, char **_buffer)
 	return security_ops->key_getsecurity(key, _buffer);
 }
 
+int security_key_session_to_parent(const struct cred *cred,
+				   const struct cred *parent_cred,
+				   struct key *key)
+{
+	return security_ops->key_session_to_parent(cred, parent_cred, key);
+}
+
 #endif	/* CONFIG_KEYS */
 
 #ifdef CONFIG_AUDIT
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5741ed6..179a791 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3210,6 +3210,21 @@ static int selinux_task_create(unsigned long clone_flags)
 }
 
 /*
+ * allocate the SELinux part of blank credentials
+ */
+static int selinux_cred_alloc_blank(struct cred *cred, gfp_t gfp)
+{
+	struct task_security_struct *tsec;
+
+	tsec = kzalloc(sizeof(struct task_security_struct), gfp);
+	if (!tsec)
+		return -ENOMEM;
+
+	cred->security = tsec;
+	return 0;
+}
+
+/*
  * detach and free the LSM part of a set of credentials
  */
 static void selinux_cred_free(struct cred *cred)
@@ -3241,6 +3256,17 @@ static int selinux_cred_prepare(struct cred *new, const struct cred *old,
 }
 
 /*
+ * transfer the SELinux data to a blank set of creds
+ */
+static void selinux_cred_transfer(struct cred *new, const struct cred *old)
+{
+	const struct task_security_struct *old_tsec = old->security;
+	struct task_security_struct *tsec = new->security;
+
+	*tsec = *old_tsec;
+}
+
+/*
  * set the security data for a kernel service
  * - all the creation contexts are set to unlabelled
  */
@@ -5388,8 +5414,10 @@ static struct security_operations selinux_ops = {
 	.dentry_open =			selinux_dentry_open,
 
 	.task_create =			selinux_task_create,
+	.cred_alloc_blank =		selinux_cred_alloc_blank,
 	.cred_free =			selinux_cred_free,
 	.cred_prepare =			selinux_cred_prepare,
+	.cred_transfer =		selinux_cred_transfer,
 	.kernel_act_as =		selinux_kernel_act_as,
 	.kernel_create_files_as =	selinux_kernel_create_files_as,
 	.task_setpgid =			selinux_task_setpgid,


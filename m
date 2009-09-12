Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274AbZILIUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbZILIUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 04:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZILIUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 04:20:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbZILIUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 04:20:23 -0400
Date: Sat, 12 Sep 2009 10:19:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [origin tree boot crash #2] kernel BUG at kernel/cred.c:855!
Message-ID: <20090912081941.GA16903@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com> <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org> <20090912072450.GA6767@elte.hu> <20090912075816.GA27306@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912075816.GA27306@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.3 required=5.9 tests=BAYES_00,FUZZY_CREDIT autolearn=no SpamAssassin version=3.2.5
	1.2 FUZZY_CREDIT           BODY: Attempt to obfuscate words in spam
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> I'll try a blind (and manual) revert of:
> 
> ee18d64: KEYS: Add a keyctl to install a process's session keyring 
> on its parent [try #6

that didnt do the trick, nor did this:

  1a51e09: Revert "KEYS: Add a keyctl to install a process's session keyring on its parent

These were the only two changes to cred.c.

	Ingo

-------------->
>From 1a51e095bae9e89170296e5a27ac19a666e84b3a Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 12 Sep 2009 09:56:14 +0200
Subject: [PATCH] Revert "KEYS: Add a keyctl to install a process's session keyring on its parent [try #6]"

This reverts commit ee18d64c1f632043a02e6f5ba5e045bb26a5465f.

Conflicts:

	include/linux/security.h
---
 Documentation/keys.txt        |   20 --------
 arch/alpha/kernel/signal.c    |    2 -
 arch/arm/kernel/signal.c      |    2 -
 arch/avr32/kernel/signal.c    |    2 -
 arch/cris/kernel/ptrace.c     |    2 -
 arch/frv/kernel/signal.c      |    2 -
 arch/h8300/kernel/signal.c    |    2 -
 arch/ia64/kernel/process.c    |    2 -
 arch/m32r/kernel/signal.c     |    2 -
 arch/mips/kernel/signal.c     |    2 -
 arch/mn10300/kernel/signal.c  |    2 -
 arch/parisc/kernel/signal.c   |    2 -
 arch/s390/kernel/signal.c     |    2 -
 arch/sh/kernel/signal_32.c    |    2 -
 arch/sh/kernel/signal_64.c    |    2 -
 arch/sparc/kernel/signal_32.c |    2 -
 arch/sparc/kernel/signal_64.c |    3 -
 arch/x86/kernel/signal.c      |    2 -
 include/linux/cred.h          |    1 -
 include/linux/key.h           |    3 -
 include/linux/keyctl.h        |    1 -
 include/linux/sched.h         |    1 -
 include/linux/security.h      |   43 -----------------
 kernel/cred.c                 |   43 -----------------
 security/capability.c         |   19 --------
 security/keys/compat.c        |    3 -
 security/keys/gc.c            |    1 -
 security/keys/internal.h      |    1 -
 security/keys/keyctl.c        |  102 -----------------------------------------
 security/keys/process_keys.c  |   49 --------------------
 security/security.c           |   17 -------
 security/selinux/hooks.c      |   28 -----------
 security/smack/smack_lsm.c    |   30 ------------
 security/tomoyo/tomoyo.c      |   17 -------
 34 files changed, 0 insertions(+), 414 deletions(-)

diff --git a/Documentation/keys.txt b/Documentation/keys.txt
index e4dbbdb..203487e 100644
--- a/Documentation/keys.txt
+++ b/Documentation/keys.txt
@@ -757,26 +757,6 @@ The keyctl syscall functions are:
      successful.
 
 
- (*) Install the calling process's session keyring on its parent.
-
-	long keyctl(KEYCTL_SESSION_TO_PARENT);
-
-     This functions attempts to install the calling process's session keyring
-     on to the calling process's parent, replacing the parent's current session
-     keyring.
-
-     The calling process must have the same ownership as its parent, the
-     keyring must have the same ownership as the calling process, the calling
-     process must have LINK permission on the keyring and the active LSM module
-     mustn't deny permission, otherwise error EPERM will be returned.
-
-     Error ENOMEM will be returned if there was insufficient memory to complete
-     the operation, otherwise 0 will be returned to indicate success.
-
-     The keyring will be replaced next time the parent process leaves the
-     kernel and resumes executing userspace.
-
-
 ===============
 KERNEL SERVICES
 ===============
diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index 0932dbb..a58f857 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -688,7 +688,5 @@ do_notify_resume(struct pt_regs *regs, struct switch_stack *sw,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index b76fe06..cab2c53 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -712,7 +712,5 @@ do_notify_resume(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 	if (thread_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index 64f886f..0d512c5 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -327,7 +327,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, struct thread_info *ti)
 	if (ti->flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/cris/kernel/ptrace.c b/arch/cris/kernel/ptrace.c
index 48b0f39..5c969ab 100644
--- a/arch/cris/kernel/ptrace.c
+++ b/arch/cris/kernel/ptrace.c
@@ -41,7 +41,5 @@ void do_notify_resume(int canrestart, struct pt_regs *regs,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 6b0a2b6..4a7a62c 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -572,8 +572,6 @@ asmlinkage void do_notify_resume(__u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(__frame);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 
 } /* end do_notify_resume() */
diff --git a/arch/h8300/kernel/signal.c b/arch/h8300/kernel/signal.c
index af842c3..14c46e8 100644
--- a/arch/h8300/kernel/signal.c
+++ b/arch/h8300/kernel/signal.c
@@ -557,7 +557,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 135d849..04da55e 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -192,8 +192,6 @@ do_notify_resume_user(sigset_t *unused, struct sigscratch *scr, long in_syscall)
 	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(&scr->pt);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 
 	/* copy user rbs to kernel rbs */
diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index 144b0f1..91fea76 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -412,8 +412,6 @@ void do_notify_resume(struct pt_regs *regs, sigset_t *oldset,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 
 	clear_thread_flag(TIF_IRET);
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index 6254041..6149b04 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -705,7 +705,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, void *unused,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index a21f43b..feb2f2e 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -568,7 +568,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(__frame);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 8eb3c63..0408aac 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -650,7 +650,5 @@ void do_notify_resume(struct pt_regs *regs, long in_syscall)
 	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 6b4fef8..062bd64 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -536,6 +536,4 @@ void do_notify_resume(struct pt_regs *regs)
 {
 	clear_thread_flag(TIF_NOTIFY_RESUME);
 	tracehook_notify_resume(regs);
-	if (current->replacement_session_keyring)
-		key_replace_session_keyring();
 }
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 04a2188..b5afbec 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -640,7 +640,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, unsigned int save_r0,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index 9e5c9b1..0663a0e 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -772,7 +772,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, unsigned long thread_info
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/sparc/kernel/signal_32.c b/arch/sparc/kernel/signal_32.c
index 7ce1a10..181d069 100644
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -590,8 +590,6 @@ void do_notify_resume(struct pt_regs *regs, unsigned long orig_i0,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index 647afbd..ec82d76 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -613,8 +613,5 @@ void do_notify_resume(struct pt_regs *regs, unsigned long orig_i0, unsigned long
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
-
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 81e5823..4c57875 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -869,8 +869,6 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 
 #ifdef CONFIG_X86_32
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 24520a5..85439ab 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -152,7 +152,6 @@ struct cred {
 extern void __put_cred(struct cred *);
 extern void exit_creds(struct task_struct *);
 extern int copy_creds(struct task_struct *, unsigned long);
-extern struct cred *cred_alloc_blank(void);
 extern struct cred *prepare_creds(void);
 extern struct cred *prepare_exec_creds(void);
 extern struct cred *prepare_usermodehelper_creds(void);
diff --git a/include/linux/key.h b/include/linux/key.h
index cd50dfa..33e0165 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -278,8 +278,6 @@ static inline key_serial_t key_serial(struct key *key)
 extern ctl_table key_sysctls[];
 #endif
 
-extern void key_replace_session_keyring(void);
-
 /*
  * the userspace interface
  */
@@ -302,7 +300,6 @@ extern void key_init(void);
 #define key_fsuid_changed(t)		do { } while(0)
 #define key_fsgid_changed(t)		do { } while(0)
 #define key_init()			do { } while(0)
-#define key_replace_session_keyring()	do { } while(0)
 
 #endif /* CONFIG_KEYS */
 #endif /* __KERNEL__ */
diff --git a/include/linux/keyctl.h b/include/linux/keyctl.h
index bd383f1..c0688eb 100644
--- a/include/linux/keyctl.h
+++ b/include/linux/keyctl.h
@@ -52,6 +52,5 @@
 #define KEYCTL_SET_TIMEOUT		15	/* set key timeout */
 #define KEYCTL_ASSUME_AUTHORITY		16	/* assume request_key() authorisation */
 #define KEYCTL_GET_SECURITY		17	/* get key security label */
-#define KEYCTL_SESSION_TO_PARENT	18	/* apply session keyring to parent process */
 
 #endif /*  _LINUX_KEYCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f3d74bd..039ccbd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1303,7 +1303,6 @@ struct task_struct {
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
 					 * (notably. ptrace) */
-	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
 
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
diff --git a/include/linux/security.h b/include/linux/security.h
index d050b66..0e75a10 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -653,11 +653,6 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	manual page for definitions of the @clone_flags.
  *	@clone_flags contains the flags indicating what should be shared.
  *	Return 0 if permission is granted.
- * @cred_alloc_blank:
- *	@cred points to the credentials.
- *	@gfp indicates the atomicity of any memory allocations.
- *	Only allocate sufficient memory and attach to @cred such that
- *	cred_transfer() will not get ENOMEM.
  * @cred_free:
  *	@cred points to the credentials.
  *	Deallocate and clear the cred->security field in a set of credentials.
@@ -670,10 +665,6 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@new points to the new credentials.
  *	@old points to the original credentials.
  *	Install a new set of credentials.
- * @cred_transfer:
- *	@new points to the new credentials.
- *	@old points to the original credentials.
- *	Transfer data from original creds to new creds
  * @kernel_act_as:
  *	Set the credentials for a kernel service to act as (subjective context).
  *	@new points to the credentials to be modified.
@@ -1112,13 +1103,6 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Return the length of the string (including terminating NUL) or -ve if
  *      an error.
  *	May also return 0 (and a NULL buffer pointer) if there is no label.
- * @key_session_to_parent:
- *	Forcibly assign the session keyring from a process to its parent
- *	process.
- *	@cred: Pointer to process's credentials
- *	@parent_cred: Pointer to parent process's credentials
- *	@keyring: Proposed new session keyring
- *	Return 0 if permission is granted, -ve error otherwise.
  *
  * Security hooks affecting all System V IPC operations.
  *
@@ -1549,12 +1533,10 @@ struct security_operations {
 	int (*dentry_open) (struct file *file, const struct cred *cred);
 
 	int (*task_create) (unsigned long clone_flags);
-	int (*cred_alloc_blank) (struct cred *cred, gfp_t gfp);
 	void (*cred_free) (struct cred *cred);
 	int (*cred_prepare)(struct cred *new, const struct cred *old,
 			    gfp_t gfp);
 	void (*cred_commit)(struct cred *new, const struct cred *old);
-	void (*cred_transfer)(struct cred *new, const struct cred *old);
 	int (*kernel_act_as)(struct cred *new, u32 secid);
 	int (*kernel_create_files_as)(struct cred *new, struct inode *inode);
 	int (*kernel_module_request)(void);
@@ -1696,9 +1678,6 @@ struct security_operations {
 			       const struct cred *cred,
 			       key_perm_t perm);
 	int (*key_getsecurity)(struct key *key, char **_buffer);
-	int (*key_session_to_parent)(const struct cred *cred,
-				     const struct cred *parent_cred,
-				     struct key *key);
 #endif	/* CONFIG_KEYS */
 
 #ifdef CONFIG_AUDIT
@@ -1815,11 +1794,9 @@ int security_file_send_sigiotask(struct task_struct *tsk,
 int security_file_receive(struct file *file);
 int security_dentry_open(struct file *file, const struct cred *cred);
 int security_task_create(unsigned long clone_flags);
-int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
 void security_cred_free(struct cred *cred);
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp);
 void security_commit_creds(struct cred *new, const struct cred *old);
-void security_transfer_creds(struct cred *new, const struct cred *old);
 int security_kernel_act_as(struct cred *new, u32 secid);
 int security_kernel_create_files_as(struct cred *new, struct inode *inode);
 int security_kernel_module_request(void);
@@ -2351,11 +2328,6 @@ static inline int security_task_create(unsigned long clone_flags)
 	return 0;
 }
 
-static inline int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
-{
-	return 0;
-}
-
 static inline void security_cred_free(struct cred *cred)
 { }
 
@@ -2371,11 +2343,6 @@ static inline void security_commit_creds(struct cred *new,
 {
 }
 
-static inline void security_transfer_creds(struct cred *new,
-					   const struct cred *old)
-{
-}
-
 static inline int security_kernel_act_as(struct cred *cred, u32 secid)
 {
 	return 0;
@@ -3011,9 +2978,6 @@ void security_key_free(struct key *key);
 int security_key_permission(key_ref_t key_ref,
 			    const struct cred *cred, key_perm_t perm);
 int security_key_getsecurity(struct key *key, char **_buffer);
-int security_key_session_to_parent(const struct cred *cred,
-				   const struct cred *parent_cred,
-				   struct key *key);
 
 #else
 
@@ -3041,13 +3005,6 @@ static inline int security_key_getsecurity(struct key *key, char **_buffer)
 	return 0;
 }
 
-static inline int security_key_session_to_parent(const struct cred *cred,
-						 const struct cred *parent_cred,
-						 struct key *key)
-{
-	return 0;
-}
-
 #endif
 #endif /* CONFIG_KEYS */
 
diff --git a/kernel/cred.c b/kernel/cred.c
index 006fcab..24dd2f5 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -199,49 +199,6 @@ void exit_creds(struct task_struct *tsk)
 	validate_creds(cred);
 	alter_cred_subscribers(cred, -1);
 	put_cred(cred);
-
-	cred = (struct cred *) tsk->replacement_session_keyring;
-	if (cred) {
-		tsk->replacement_session_keyring = NULL;
-		validate_creds(cred);
-		put_cred(cred);
-	}
-}
-
-/*
- * Allocate blank credentials, such that the credentials can be filled in at a
- * later date without risk of ENOMEM.
- */
-struct cred *cred_alloc_blank(void)
-{
-	struct cred *new;
-
-	new = kmem_cache_zalloc(cred_jar, GFP_KERNEL);
-	if (!new)
-		return NULL;
-
-#ifdef CONFIG_KEYS
-	new->tgcred = kzalloc(sizeof(*new->tgcred), GFP_KERNEL);
-	if (!new->tgcred) {
-		kfree(new);
-		return NULL;
-	}
-	atomic_set(&new->tgcred->usage, 1);
-#endif
-
-	atomic_set(&new->usage, 1);
-
-	if (security_cred_alloc_blank(new, GFP_KERNEL) < 0)
-		goto error;
-
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	new->magic = CRED_MAGIC;
-#endif
-	return new;
-
-error:
-	abort_creds(new);
-	return NULL;
 }
 
 /**
diff --git a/security/capability.c b/security/capability.c
index 13781e9..790d5c9 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -374,11 +374,6 @@ static int cap_task_create(unsigned long clone_flags)
 	return 0;
 }
 
-static int cap_cred_alloc_blank(struct cred *cred, gfp_t gfp)
-{
-	return 0;
-}
-
 static void cap_cred_free(struct cred *cred)
 {
 }
@@ -392,10 +387,6 @@ static void cap_cred_commit(struct cred *new, const struct cred *old)
 {
 }
 
-static void cap_cred_transfer(struct cred *new, const struct cred *old)
-{
-}
-
 static int cap_kernel_act_as(struct cred *new, u32 secid)
 {
 	return 0;
@@ -863,13 +854,6 @@ static int cap_key_getsecurity(struct key *key, char **_buffer)
 	return 0;
 }
 
-static int cap_key_session_to_parent(const struct cred *cred,
-				     const struct cred *parent_cred,
-				     struct key *key)
-{
-	return 0;
-}
-
 #endif /* CONFIG_KEYS */
 
 #ifdef CONFIG_AUDIT
@@ -995,11 +979,9 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, file_receive);
 	set_to_cap_if_null(ops, dentry_open);
 	set_to_cap_if_null(ops, task_create);
-	set_to_cap_if_null(ops, cred_alloc_blank);
 	set_to_cap_if_null(ops, cred_free);
 	set_to_cap_if_null(ops, cred_prepare);
 	set_to_cap_if_null(ops, cred_commit);
-	set_to_cap_if_null(ops, cred_transfer);
 	set_to_cap_if_null(ops, kernel_act_as);
 	set_to_cap_if_null(ops, kernel_create_files_as);
 	set_to_cap_if_null(ops, kernel_module_request);
@@ -1102,7 +1084,6 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, key_free);
 	set_to_cap_if_null(ops, key_permission);
 	set_to_cap_if_null(ops, key_getsecurity);
-	set_to_cap_if_null(ops, key_session_to_parent);
 #endif	/* CONFIG_KEYS */
 #ifdef CONFIG_AUDIT
 	set_to_cap_if_null(ops, audit_rule_init);
diff --git a/security/keys/compat.c b/security/keys/compat.c
index 792c0a6..c766c68 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -82,9 +82,6 @@ asmlinkage long compat_sys_keyctl(u32 option,
 	case KEYCTL_GET_SECURITY:
 		return keyctl_get_security(arg2, compat_ptr(arg3), arg4);
 
-	case KEYCTL_SESSION_TO_PARENT:
-		return keyctl_session_to_parent();
-
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/security/keys/gc.c b/security/keys/gc.c
index 1e616ae..44adc32 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -65,7 +65,6 @@ static void key_gc_timer_func(unsigned long data)
  * - return true if we altered the keyring
  */
 static bool key_gc_keyring(struct key *keyring, time_t limit)
-	__releases(key_serial_lock)
 {
 	struct keyring_list *klist;
 	struct key *key;
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 24ba030..fb83051 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -201,7 +201,6 @@ extern long keyctl_set_timeout(key_serial_t, unsigned);
 extern long keyctl_assume_authority(key_serial_t);
 extern long keyctl_get_security(key_serial_t keyid, char __user *buffer,
 				size_t buflen);
-extern long keyctl_session_to_parent(void);
 
 /*
  * debugging key validation
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 74c9685..736d780 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1228,105 +1228,6 @@ long keyctl_get_security(key_serial_t keyid,
 	return ret;
 }
 
-/*
- * attempt to install the calling process's session keyring on the process's
- * parent process
- * - the keyring must exist and must grant us LINK permission
- * - implements keyctl(KEYCTL_SESSION_TO_PARENT)
- */
-long keyctl_session_to_parent(void)
-{
-	struct task_struct *me, *parent;
-	const struct cred *mycred, *pcred;
-	struct cred *cred, *oldcred;
-	key_ref_t keyring_r;
-	int ret;
-
-	keyring_r = lookup_user_key(KEY_SPEC_SESSION_KEYRING, 0, KEY_LINK);
-	if (IS_ERR(keyring_r))
-		return PTR_ERR(keyring_r);
-
-	/* our parent is going to need a new cred struct, a new tgcred struct
-	 * and new security data, so we allocate them here to prevent ENOMEM in
-	 * our parent */
-	ret = -ENOMEM;
-	cred = cred_alloc_blank();
-	if (!cred)
-		goto error_keyring;
-
-	cred->tgcred->session_keyring = key_ref_to_ptr(keyring_r);
-	keyring_r = NULL;
-
-	me = current;
-	write_lock_irq(&tasklist_lock);
-
-	parent = me->real_parent;
-	ret = -EPERM;
-
-	/* the parent mustn't be init and mustn't be a kernel thread */
-	if (parent->pid <= 1 || !parent->mm)
-		goto not_permitted;
-
-	/* the parent must be single threaded */
-	if (atomic_read(&parent->signal->count) != 1)
-		goto not_permitted;
-
-	/* the parent and the child must have different session keyrings or
-	 * there's no point */
-	mycred = current_cred();
-	pcred = __task_cred(parent);
-	if (mycred == pcred ||
-	    mycred->tgcred->session_keyring == pcred->tgcred->session_keyring)
-		goto already_same;
-
-	/* the parent must have the same effective ownership and mustn't be
-	 * SUID/SGID */
-	if (pcred-> uid	!= mycred->euid	||
-	    pcred->euid	!= mycred->euid	||
-	    pcred->suid	!= mycred->euid	||
-	    pcred-> gid	!= mycred->egid	||
-	    pcred->egid	!= mycred->egid	||
-	    pcred->sgid	!= mycred->egid)
-		goto not_permitted;
-
-	/* the keyrings must have the same UID */
-	if (pcred ->tgcred->session_keyring->uid != mycred->euid ||
-	    mycred->tgcred->session_keyring->uid != mycred->euid)
-		goto not_permitted;
-
-	/* the LSM must permit the replacement of the parent's keyring with the
-	 * keyring from this process */
-	ret = security_key_session_to_parent(mycred, pcred,
-					     key_ref_to_ptr(keyring_r));
-	if (ret < 0)
-		goto not_permitted;
-
-	/* if there's an already pending keyring replacement, then we replace
-	 * that */
-	oldcred = parent->replacement_session_keyring;
-
-	/* the replacement session keyring is applied just prior to userspace
-	 * restarting */
-	parent->replacement_session_keyring = cred;
-	cred = NULL;
-	set_ti_thread_flag(task_thread_info(parent), TIF_NOTIFY_RESUME);
-
-	write_unlock_irq(&tasklist_lock);
-	if (oldcred)
-		put_cred(oldcred);
-	return 0;
-
-already_same:
-	ret = 0;
-not_permitted:
-	put_cred(cred);
-	return ret;
-
-error_keyring:
-	key_ref_put(keyring_r);
-	return ret;
-}
-
 /*****************************************************************************/
 /*
  * the key control system call
@@ -1412,9 +1313,6 @@ SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
 					   (char __user *) arg3,
 					   (size_t) arg4);
 
-	case KEYCTL_SESSION_TO_PARENT:
-		return keyctl_session_to_parent();
-
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 5c23afb..4739cfb 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -17,7 +17,6 @@
 #include <linux/fs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
-#include <linux/security.h>
 #include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 #include "internal.h"
@@ -769,51 +768,3 @@ error:
 	abort_creds(new);
 	return ret;
 }
-
-/*
- * Replace a process's session keyring when that process resumes userspace on
- * behalf of one of its children
- */
-void key_replace_session_keyring(void)
-{
-	const struct cred *old;
-	struct cred *new;
-
-	if (!current->replacement_session_keyring)
-		return;
-
-	write_lock_irq(&tasklist_lock);
-	new = current->replacement_session_keyring;
-	current->replacement_session_keyring = NULL;
-	write_unlock_irq(&tasklist_lock);
-
-	if (!new)
-		return;
-
-	old = current_cred();
-	new->  uid	= old->  uid;
-	new-> euid	= old-> euid;
-	new-> suid	= old-> suid;
-	new->fsuid	= old->fsuid;
-	new->  gid	= old->  gid;
-	new-> egid	= old-> egid;
-	new-> sgid	= old-> sgid;
-	new->fsgid	= old->fsgid;
-	new->user	= get_uid(old->user);
-	new->group_info	= get_group_info(old->group_info);
-
-	new->securebits	= old->securebits;
-	new->cap_inheritable	= old->cap_inheritable;
-	new->cap_permitted	= old->cap_permitted;
-	new->cap_effective	= old->cap_effective;
-	new->cap_bset		= old->cap_bset;
-
-	new->jit_keyring	= old->jit_keyring;
-	new->thread_keyring	= key_get(old->thread_keyring);
-	new->tgcred->tgid	= old->tgcred->tgid;
-	new->tgcred->process_keyring = key_get(old->tgcred->process_keyring);
-
-	security_transfer_creds(new, old);
-
-	commit_creds(new);
-}
diff --git a/security/security.c b/security/security.c
index c4c6732..3a89c9a 100644
--- a/security/security.c
+++ b/security/security.c
@@ -684,11 +684,6 @@ int security_task_create(unsigned long clone_flags)
 	return security_ops->task_create(clone_flags);
 }
 
-int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
-{
-	return security_ops->cred_alloc_blank(cred, gfp);
-}
-
 void security_cred_free(struct cred *cred)
 {
 	security_ops->cred_free(cred);
@@ -704,11 +699,6 @@ void security_commit_creds(struct cred *new, const struct cred *old)
 	security_ops->cred_commit(new, old);
 }
 
-void security_transfer_creds(struct cred *new, const struct cred *old)
-{
-	security_ops->cred_transfer(new, old);
-}
-
 int security_kernel_act_as(struct cred *new, u32 secid)
 {
 	return security_ops->kernel_act_as(new, secid);
@@ -1269,13 +1259,6 @@ int security_key_getsecurity(struct key *key, char **_buffer)
 	return security_ops->key_getsecurity(key, _buffer);
 }
 
-int security_key_session_to_parent(const struct cred *cred,
-				   const struct cred *parent_cred,
-				   struct key *key)
-{
-	return security_ops->key_session_to_parent(cred, parent_cred, key);
-}
-
 #endif	/* CONFIG_KEYS */
 
 #ifdef CONFIG_AUDIT
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d7afdb1..ec04cc2 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3238,21 +3238,6 @@ static int selinux_task_create(unsigned long clone_flags)
 }
 
 /*
- * allocate the SELinux part of blank credentials
- */
-static int selinux_cred_alloc_blank(struct cred *cred, gfp_t gfp)
-{
-	struct task_security_struct *tsec;
-
-	tsec = kzalloc(sizeof(struct task_security_struct), gfp);
-	if (!tsec)
-		return -ENOMEM;
-
-	cred->security = tsec;
-	return 0;
-}
-
-/*
  * detach and free the LSM part of a set of credentials
  */
 static void selinux_cred_free(struct cred *cred)
@@ -3284,17 +3269,6 @@ static int selinux_cred_prepare(struct cred *new, const struct cred *old,
 }
 
 /*
- * transfer the SELinux data to a blank set of creds
- */
-static void selinux_cred_transfer(struct cred *new, const struct cred *old)
-{
-	const struct task_security_struct *old_tsec = old->security;
-	struct task_security_struct *tsec = new->security;
-
-	*tsec = *old_tsec;
-}
-
-/*
  * set the security data for a kernel service
  * - all the creation contexts are set to unlabelled
  */
@@ -5526,10 +5500,8 @@ static struct security_operations selinux_ops = {
 	.dentry_open =			selinux_dentry_open,
 
 	.task_create =			selinux_task_create,
-	.cred_alloc_blank =		selinux_cred_alloc_blank,
 	.cred_free =			selinux_cred_free,
 	.cred_prepare =			selinux_cred_prepare,
-	.cred_transfer =		selinux_cred_transfer,
 	.kernel_act_as =		selinux_kernel_act_as,
 	.kernel_create_files_as =	selinux_kernel_create_files_as,
 	.kernel_module_request =	selinux_kernel_module_request,
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index acae7ef..aba5c9a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1080,22 +1080,6 @@ static int smack_file_receive(struct file *file)
  */
 
 /**
- * smack_cred_alloc_blank - "allocate" blank task-level security credentials
- * @new: the new credentials
- * @gfp: the atomicity of any memory allocations
- *
- * Prepare a blank set of credentials for modification.  This must allocate all
- * the memory the LSM module might require such that cred_transfer() can
- * complete without error.
- */
-static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
-{
-	cred->security = NULL;
-	return 0;
-}
-
-
-/**
  * smack_cred_free - "free" task-level security credentials
  * @cred: the credentials in question
  *
@@ -1133,18 +1117,6 @@ static void smack_cred_commit(struct cred *new, const struct cred *old)
 }
 
 /**
- * smack_cred_transfer - Transfer the old credentials to the new credentials
- * @new: the new credentials
- * @old: the original credentials
- *
- * Fill in a set of blank credentials from another set of credentials.
- */
-static void smack_cred_transfer(struct cred *new, const struct cred *old)
-{
-	new->security = old->security;
-}
-
-/**
  * smack_kernel_act_as - Set the subjective context in a set of credentials
  * @new: points to the set of credentials to be modified.
  * @secid: specifies the security ID to be set
@@ -3123,11 +3095,9 @@ struct security_operations smack_ops = {
 	.file_send_sigiotask = 		smack_file_send_sigiotask,
 	.file_receive = 		smack_file_receive,
 
-	.cred_alloc_blank =		smack_cred_alloc_blank,
 	.cred_free =			smack_cred_free,
 	.cred_prepare =			smack_cred_prepare,
 	.cred_commit =			smack_cred_commit,
-	.cred_transfer =		smack_cred_transfer,
 	.kernel_act_as =		smack_kernel_act_as,
 	.kernel_create_files_as =	smack_kernel_create_files_as,
 	.task_setpgid = 		smack_task_setpgid,
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index 9548a09..35a13e7 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -14,12 +14,6 @@
 #include "tomoyo.h"
 #include "realpath.h"
 
-static int tomoyo_cred_alloc_blank(struct cred *new, gfp_t gfp)
-{
-	new->security = NULL;
-	return 0;
-}
-
 static int tomoyo_cred_prepare(struct cred *new, const struct cred *old,
 			       gfp_t gfp)
 {
@@ -31,15 +25,6 @@ static int tomoyo_cred_prepare(struct cred *new, const struct cred *old,
 	return 0;
 }
 
-static void tomoyo_cred_transfer(struct cred *new, const struct cred *old)
-{
-	/*
-	 * Since "struct tomoyo_domain_info *" is a sharable pointer,
-	 * we don't need to duplicate.
-	 */
-	new->security = old->security;
-}
-
 static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
 {
 	int rc;
@@ -277,9 +262,7 @@ static int tomoyo_dentry_open(struct file *f, const struct cred *cred)
  */
 static struct security_operations tomoyo_security_ops = {
 	.name                = "tomoyo",
-	.cred_alloc_blank    = tomoyo_cred_alloc_blank,
 	.cred_prepare        = tomoyo_cred_prepare,
-	.cred_transfer	     = tomoyo_cred_transfer,
 	.bprm_set_creds      = tomoyo_bprm_set_creds,
 	.bprm_check_security = tomoyo_bprm_check_security,
 #ifdef CONFIG_SYSCTL

>From 14a0881feaf6004fe1060584a4c814c92f26a545 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 12 Sep 2009 10:16:42 +0200
Subject: [PATCH] Revert "CRED: Add some configurable debugging [try #6]"

This reverts commit e0e817392b9acf2c98d3be80c233dddb1b52003d.
---
 fs/nfsd/auth.c           |    4 -
 fs/nfsd/nfssvc.c         |    2 -
 fs/nfsd/vfs.c            |    3 -
 fs/open.c                |    2 -
 include/linux/cred.h     |   65 +------------
 kernel/cred.c            |  250 +--------------------------------------------
 kernel/exit.c            |    4 -
 kernel/fork.c            |    6 +-
 kernel/kmod.c            |    1 -
 lib/Kconfig.debug        |   15 ---
 security/selinux/hooks.c |    6 +-
 11 files changed, 12 insertions(+), 346 deletions(-)

diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 36fcabb..5573508 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -34,8 +34,6 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 	int flags = nfsexp_flags(rqstp, exp);
 	int ret;
 
-	validate_process_creds();
-
 	/* discard any old override before preparing the new set */
 	revert_creds(get_cred(current->real_cred));
 	new = prepare_creds();
@@ -88,10 +86,8 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 	else
 		new->cap_effective = cap_raise_nfsd_set(new->cap_effective,
 							new->cap_permitted);
-	validate_process_creds();
 	put_cred(override_creds(new));
 	put_cred(new);
-	validate_process_creds();
 	return 0;
 
 oom:
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 24d58ad..492c79b 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -496,9 +496,7 @@ nfsd(void *vrqstp)
 		/* Lock the export hash tables for reading. */
 		exp_readlock();
 
-		validate_process_creds();
 		svc_process(rqstp);
-		validate_process_creds();
 
 		/* Unlock export hash tables */
 		exp_readunlock();
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 8fa09bf..23341c1 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -684,8 +684,6 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 	__be32		err;
 	int		host_err;
 
-	validate_process_creds();
-
 	/*
 	 * If we get here, then the client has already done an "open",
 	 * and (hopefully) checked permission - so allow OWNER_OVERRIDE
@@ -742,7 +740,6 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 out_nfserr:
 	err = nfserrno(host_err);
 out:
-	validate_process_creds();
 	return err;
 }
 
diff --git a/fs/open.c b/fs/open.c
index 31191bf..40d1fa2 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -959,8 +959,6 @@ struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags,
 	int error;
 	struct file *f;
 
-	validate_creds(cred);
-
 	/*
 	 * We must always pass in a valid mount pointer.   Historically
 	 * callers got away with not passing it, but we must enforce this at
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 85439ab..b3c76e8 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -114,13 +114,6 @@ struct thread_group_cred {
  */
 struct cred {
 	atomic_t	usage;
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	atomic_t	subscribers;	/* number of processes subscribed */
-	void		*put_addr;
-	unsigned	magic;
-#define CRED_MAGIC	0x43736564
-#define CRED_MAGIC_DEAD	0x44656144
-#endif
 	uid_t		uid;		/* real UID of the task */
 	gid_t		gid;		/* real GID of the task */
 	uid_t		suid;		/* saved UID of the task */
@@ -150,7 +143,6 @@ struct cred {
 };
 
 extern void __put_cred(struct cred *);
-extern void exit_creds(struct task_struct *);
 extern int copy_creds(struct task_struct *, unsigned long);
 extern struct cred *prepare_creds(void);
 extern struct cred *prepare_exec_creds(void);
@@ -166,60 +158,6 @@ extern int set_security_override_from_ctx(struct cred *, const char *);
 extern int set_create_files_as(struct cred *, struct inode *);
 extern void __init cred_init(void);
 
-/*
- * check for validity of credentials
- */
-#ifdef CONFIG_DEBUG_CREDENTIALS
-extern void __invalid_creds(const struct cred *, const char *, unsigned);
-extern void __validate_process_creds(struct task_struct *,
-				     const char *, unsigned);
-
-static inline bool creds_are_invalid(const struct cred *cred)
-{
-	if (cred->magic != CRED_MAGIC)
-		return true;
-	if (atomic_read(&cred->usage) < atomic_read(&cred->subscribers))
-		return true;
-#ifdef CONFIG_SECURITY_SELINUX
-	if ((unsigned long) cred->security < PAGE_SIZE)
-		return true;
-	if ((*(u32*)cred->security & 0xffffff00) ==
-	    (POISON_FREE << 24 | POISON_FREE << 16 | POISON_FREE << 8))
-		return true;
-#endif
-	return false;
-}
-
-static inline void __validate_creds(const struct cred *cred,
-				    const char *file, unsigned line)
-{
-	if (unlikely(creds_are_invalid(cred)))
-		__invalid_creds(cred, file, line);
-}
-
-#define validate_creds(cred)				\
-do {							\
-	__validate_creds((cred), __FILE__, __LINE__);	\
-} while(0)
-
-#define validate_process_creds()				\
-do {								\
-	__validate_process_creds(current, __FILE__, __LINE__);	\
-} while(0)
-
-extern void validate_creds_for_do_exit(struct task_struct *);
-#else
-static inline void validate_creds(const struct cred *cred)
-{
-}
-static inline void validate_creds_for_do_exit(struct task_struct *tsk)
-{
-}
-static inline void validate_process_creds(void)
-{
-}
-#endif
-
 /**
  * get_new_cred - Get a reference on a new set of credentials
  * @cred: The new credentials to reference
@@ -249,7 +187,6 @@ static inline struct cred *get_new_cred(struct cred *cred)
 static inline const struct cred *get_cred(const struct cred *cred)
 {
 	struct cred *nonconst_cred = (struct cred *) cred;
-	validate_creds(cred);
 	return get_new_cred(nonconst_cred);
 }
 
@@ -268,7 +205,7 @@ static inline void put_cred(const struct cred *_cred)
 {
 	struct cred *cred = (struct cred *) _cred;
 
-	validate_creds(cred);
+	BUG_ON(atomic_read(&(cred)->usage) <= 0);
 	if (atomic_dec_and_test(&(cred)->usage))
 		__put_cred(cred);
 }
diff --git a/kernel/cred.c b/kernel/cred.c
index 24dd2f5..1bb4d7e 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -18,18 +18,6 @@
 #include <linux/cn_proc.h>
 #include "cred-internals.h"
 
-#if 0
-#define kdebug(FMT, ...) \
-	printk("[%-5.5s%5u] "FMT"\n", current->comm, current->pid ,##__VA_ARGS__)
-#else
-static inline __attribute__((format(printf, 1, 2)))
-void no_printk(const char *fmt, ...)
-{
-}
-#define kdebug(FMT, ...) \
-	no_printk("[%-5.5s%5u] "FMT"\n", current->comm, current->pid ,##__VA_ARGS__)
-#endif
-
 static struct kmem_cache *cred_jar;
 
 /*
@@ -48,10 +36,6 @@ static struct thread_group_cred init_tgcred = {
  */
 struct cred init_cred = {
 	.usage			= ATOMIC_INIT(4),
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	.subscribers		= ATOMIC_INIT(2),
-	.magic			= CRED_MAGIC,
-#endif
 	.securebits		= SECUREBITS_DEFAULT,
 	.cap_inheritable	= CAP_INIT_INH_SET,
 	.cap_permitted		= CAP_FULL_SET,
@@ -64,31 +48,6 @@ struct cred init_cred = {
 #endif
 };
 
-static inline void set_cred_subscribers(struct cred *cred, int n)
-{
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	atomic_set(&cred->subscribers, n);
-#endif
-}
-
-static inline int read_cred_subscribers(const struct cred *cred)
-{
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	return atomic_read(&cred->subscribers);
-#else
-	return 0;
-#endif
-}
-
-static inline void alter_cred_subscribers(const struct cred *_cred, int n)
-{
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	struct cred *cred = (struct cred *) _cred;
-
-	atomic_add(n, &cred->subscribers);
-#endif
-}
-
 /*
  * Dispose of the shared task group credentials
  */
@@ -126,22 +85,9 @@ static void put_cred_rcu(struct rcu_head *rcu)
 {
 	struct cred *cred = container_of(rcu, struct cred, rcu);
 
-	kdebug("put_cred_rcu(%p)", cred);
-
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	if (cred->magic != CRED_MAGIC_DEAD ||
-	    atomic_read(&cred->usage) != 0 ||
-	    read_cred_subscribers(cred) != 0)
-		panic("CRED: put_cred_rcu() sees %p with"
-		      " mag %x, put %p, usage %d, subscr %d\n",
-		      cred, cred->magic, cred->put_addr,
-		      atomic_read(&cred->usage),
-		      read_cred_subscribers(cred));
-#else
 	if (atomic_read(&cred->usage) != 0)
 		panic("CRED: put_cred_rcu() sees %p with usage %d\n",
 		      cred, atomic_read(&cred->usage));
-#endif
 
 	security_cred_free(cred);
 	key_put(cred->thread_keyring);
@@ -160,47 +106,12 @@ static void put_cred_rcu(struct rcu_head *rcu)
  */
 void __put_cred(struct cred *cred)
 {
-	kdebug("__put_cred(%p{%d,%d})", cred,
-	       atomic_read(&cred->usage),
-	       read_cred_subscribers(cred));
-
 	BUG_ON(atomic_read(&cred->usage) != 0);
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	BUG_ON(read_cred_subscribers(cred) != 0);
-	cred->magic = CRED_MAGIC_DEAD;
-	cred->put_addr = __builtin_return_address(0);
-#endif
-	BUG_ON(cred == current->cred);
-	BUG_ON(cred == current->real_cred);
 
 	call_rcu(&cred->rcu, put_cred_rcu);
 }
 EXPORT_SYMBOL(__put_cred);
 
-/*
- * Clean up a task's credentials when it exits
- */
-void exit_creds(struct task_struct *tsk)
-{
-	struct cred *cred;
-
-	kdebug("exit_creds(%u,%p,%p,{%d,%d})", tsk->pid, tsk->real_cred, tsk->cred,
-	       atomic_read(&tsk->cred->usage),
-	       read_cred_subscribers(tsk->cred));
-
-	cred = (struct cred *) tsk->real_cred;
-	tsk->real_cred = NULL;
-	validate_creds(cred);
-	alter_cred_subscribers(cred, -1);
-	put_cred(cred);
-
-	cred = (struct cred *) tsk->cred;
-	tsk->cred = NULL;
-	validate_creds(cred);
-	alter_cred_subscribers(cred, -1);
-	put_cred(cred);
-}
-
 /**
  * prepare_creds - Prepare a new set of credentials for modification
  *
@@ -221,19 +132,16 @@ struct cred *prepare_creds(void)
 	const struct cred *old;
 	struct cred *new;
 
-	validate_process_creds();
+	BUG_ON(atomic_read(&task->real_cred->usage) < 1);
 
 	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
 	if (!new)
 		return NULL;
 
-	kdebug("prepare_creds() alloc %p", new);
-
 	old = task->cred;
 	memcpy(new, old, sizeof(struct cred));
 
 	atomic_set(&new->usage, 1);
-	set_cred_subscribers(new, 0);
 	get_group_info(new->group_info);
 	get_uid(new->user);
 
@@ -249,7 +157,6 @@ struct cred *prepare_creds(void)
 
 	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
 		goto error;
-	validate_creds(new);
 	return new;
 
 error:
@@ -322,12 +229,9 @@ struct cred *prepare_usermodehelper_creds(void)
 	if (!new)
 		return NULL;
 
-	kdebug("prepare_usermodehelper_creds() alloc %p", new);
-
 	memcpy(new, &init_cred, sizeof(struct cred));
 
 	atomic_set(&new->usage, 1);
-	set_cred_subscribers(new, 0);
 	get_group_info(new->group_info);
 	get_uid(new->user);
 
@@ -346,7 +250,6 @@ struct cred *prepare_usermodehelper_creds(void)
 #endif
 	if (security_prepare_creds(new, &init_cred, GFP_ATOMIC) < 0)
 		goto error;
-	validate_creds(new);
 
 	BUG_ON(atomic_read(&new->usage) != 1);
 	return new;
@@ -383,10 +286,6 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	    ) {
 		p->real_cred = get_cred(p->cred);
 		get_cred(p->cred);
-		alter_cred_subscribers(p->cred, 2);
-		kdebug("share_creds(%p{%d,%d})",
-		       p->cred, atomic_read(&p->cred->usage),
-		       read_cred_subscribers(p->cred));
 		atomic_inc(&p->cred->user->processes);
 		return 0;
 	}
@@ -432,8 +331,6 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 
 	atomic_inc(&new->user->processes);
 	p->cred = p->real_cred = get_cred(new);
-	alter_cred_subscribers(new, 2);
-	validate_creds(new);
 	return 0;
 
 error_put:
@@ -458,20 +355,13 @@ error_put:
 int commit_creds(struct cred *new)
 {
 	struct task_struct *task = current;
-	const struct cred *old = task->real_cred;
-
-	kdebug("commit_creds(%p{%d,%d})", new,
-	       atomic_read(&new->usage),
-	       read_cred_subscribers(new));
+	const struct cred *old;
 
-	BUG_ON(task->cred != old);
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	BUG_ON(read_cred_subscribers(old) < 2);
-	validate_creds(old);
-	validate_creds(new);
-#endif
+	BUG_ON(task->cred != task->real_cred);
+	BUG_ON(atomic_read(&task->real_cred->usage) < 2);
 	BUG_ON(atomic_read(&new->usage) < 1);
 
+	old = task->real_cred;
 	security_commit_creds(new, old);
 
 	get_cred(new); /* we will require a ref for the subj creds too */
@@ -500,14 +390,12 @@ int commit_creds(struct cred *new)
 	 *   cheaply with the new uid cache, so if it matters
 	 *   we should be checking for it.  -DaveM
 	 */
-	alter_cred_subscribers(new, 2);
 	if (new->user != old->user)
 		atomic_inc(&new->user->processes);
 	rcu_assign_pointer(task->real_cred, new);
 	rcu_assign_pointer(task->cred, new);
 	if (new->user != old->user)
 		atomic_dec(&old->user->processes);
-	alter_cred_subscribers(old, -2);
 
 	sched_switch_user(task);
 
@@ -540,13 +428,6 @@ EXPORT_SYMBOL(commit_creds);
  */
 void abort_creds(struct cred *new)
 {
-	kdebug("abort_creds(%p{%d,%d})", new,
-	       atomic_read(&new->usage),
-	       read_cred_subscribers(new));
-
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	BUG_ON(read_cred_subscribers(new) != 0);
-#endif
 	BUG_ON(atomic_read(&new->usage) < 1);
 	put_cred(new);
 }
@@ -563,20 +444,7 @@ const struct cred *override_creds(const struct cred *new)
 {
 	const struct cred *old = current->cred;
 
-	kdebug("override_creds(%p{%d,%d})", new,
-	       atomic_read(&new->usage),
-	       read_cred_subscribers(new));
-
-	validate_creds(old);
-	validate_creds(new);
-	get_cred(new);
-	alter_cred_subscribers(new, 1);
-	rcu_assign_pointer(current->cred, new);
-	alter_cred_subscribers(old, -1);
-
-	kdebug("override_creds() = %p{%d,%d}", old,
-	       atomic_read(&old->usage),
-	       read_cred_subscribers(old));
+	rcu_assign_pointer(current->cred, get_cred(new));
 	return old;
 }
 EXPORT_SYMBOL(override_creds);
@@ -592,15 +460,7 @@ void revert_creds(const struct cred *old)
 {
 	const struct cred *override = current->cred;
 
-	kdebug("revert_creds(%p{%d,%d})", old,
-	       atomic_read(&old->usage),
-	       read_cred_subscribers(old));
-
-	validate_creds(old);
-	validate_creds(override);
-	alter_cred_subscribers(old, 1);
 	rcu_assign_pointer(current->cred, old);
-	alter_cred_subscribers(override, -1);
 	put_cred(override);
 }
 EXPORT_SYMBOL(revert_creds);
@@ -642,15 +502,11 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	if (!new)
 		return NULL;
 
-	kdebug("prepare_kernel_cred() alloc %p", new);
-
 	if (daemon)
 		old = get_task_cred(daemon);
 	else
 		old = get_cred(&init_cred);
 
-	validate_creds(old);
-
 	*new = *old;
 	get_uid(new->user);
 	get_group_info(new->group_info);
@@ -670,9 +526,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 		goto error;
 
 	atomic_set(&new->usage, 1);
-	set_cred_subscribers(new, 0);
 	put_cred(old);
-	validate_creds(new);
 	return new;
 
 error:
@@ -735,95 +589,3 @@ int set_create_files_as(struct cred *new, struct inode *inode)
 	return security_kernel_create_files_as(new, inode);
 }
 EXPORT_SYMBOL(set_create_files_as);
-
-#ifdef CONFIG_DEBUG_CREDENTIALS
-
-/*
- * dump invalid credentials
- */
-static void dump_invalid_creds(const struct cred *cred, const char *label,
-			       const struct task_struct *tsk)
-{
-	printk(KERN_ERR "CRED: %s credentials: %p %s%s%s\n",
-	       label, cred,
-	       cred == &init_cred ? "[init]" : "",
-	       cred == tsk->real_cred ? "[real]" : "",
-	       cred == tsk->cred ? "[eff]" : "");
-	printk(KERN_ERR "CRED: ->magic=%x, put_addr=%p\n",
-	       cred->magic, cred->put_addr);
-	printk(KERN_ERR "CRED: ->usage=%d, subscr=%d\n",
-	       atomic_read(&cred->usage),
-	       read_cred_subscribers(cred));
-	printk(KERN_ERR "CRED: ->*uid = { %d,%d,%d,%d }\n",
-	       cred->uid, cred->euid, cred->suid, cred->fsuid);
-	printk(KERN_ERR "CRED: ->*gid = { %d,%d,%d,%d }\n",
-	       cred->gid, cred->egid, cred->sgid, cred->fsgid);
-#ifdef CONFIG_SECURITY
-	printk(KERN_ERR "CRED: ->security is %p\n", cred->security);
-	if ((unsigned long) cred->security >= PAGE_SIZE &&
-	    (((unsigned long) cred->security & 0xffffff00) !=
-	     (POISON_FREE << 24 | POISON_FREE << 16 | POISON_FREE << 8)))
-		printk(KERN_ERR "CRED: ->security {%x, %x}\n",
-		       ((u32*)cred->security)[0],
-		       ((u32*)cred->security)[1]);
-#endif
-}
-
-/*
- * report use of invalid credentials
- */
-void __invalid_creds(const struct cred *cred, const char *file, unsigned line)
-{
-	printk(KERN_ERR "CRED: Invalid credentials\n");
-	printk(KERN_ERR "CRED: At %s:%u\n", file, line);
-	dump_invalid_creds(cred, "Specified", current);
-	BUG();
-}
-EXPORT_SYMBOL(__invalid_creds);
-
-/*
- * check the credentials on a process
- */
-void __validate_process_creds(struct task_struct *tsk,
-			      const char *file, unsigned line)
-{
-	if (tsk->cred == tsk->real_cred) {
-		if (unlikely(read_cred_subscribers(tsk->cred) < 2 ||
-			     creds_are_invalid(tsk->cred)))
-			goto invalid_creds;
-	} else {
-		if (unlikely(read_cred_subscribers(tsk->real_cred) < 1 ||
-			     read_cred_subscribers(tsk->cred) < 1 ||
-			     creds_are_invalid(tsk->real_cred) ||
-			     creds_are_invalid(tsk->cred)))
-			goto invalid_creds;
-	}
-	return;
-
-invalid_creds:
-	printk(KERN_ERR "CRED: Invalid process credentials\n");
-	printk(KERN_ERR "CRED: At %s:%u\n", file, line);
-
-	dump_invalid_creds(tsk->real_cred, "Real", tsk);
-	if (tsk->cred != tsk->real_cred)
-		dump_invalid_creds(tsk->cred, "Effective", tsk);
-	else
-		printk(KERN_ERR "CRED: Effective creds == Real creds\n");
-	BUG();
-}
-EXPORT_SYMBOL(__validate_process_creds);
-
-/*
- * check creds for do_exit()
- */
-void validate_creds_for_do_exit(struct task_struct *tsk)
-{
-	kdebug("validate_creds_for_do_exit(%p,%p{%d,%d})",
-	       tsk->real_cred, tsk->cred,
-	       atomic_read(&tsk->cred->usage),
-	       read_cred_subscribers(tsk->cred));
-
-	__validate_process_creds(tsk, __FILE__, __LINE__);
-}
-
-#endif /* CONFIG_DEBUG_CREDENTIALS */
diff --git a/kernel/exit.c b/kernel/exit.c
index ae5d866..263f95e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -901,8 +901,6 @@ NORET_TYPE void do_exit(long code)
 
 	tracehook_report_exit(&code);
 
-	validate_creds_for_do_exit(tsk);
-
 	/*
 	 * We're taking recursive faults here in do_exit. Safest is to just
 	 * leave this task alone and wait for reboot.
@@ -1011,8 +1009,6 @@ NORET_TYPE void do_exit(long code)
 	if (tsk->splice_pipe)
 		__free_pipe_info(tsk->splice_pipe);
 
-	validate_creds_for_do_exit(tsk);
-
 	preempt_disable();
 	exit_rcu();
 	/* causes final put_task_struct in finish_task_switch(). */
diff --git a/kernel/fork.c b/kernel/fork.c
index bfee931..637520c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -152,7 +152,8 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
-	exit_creds(tsk);
+	put_cred(tsk->real_cred);
+	put_cred(tsk->cred);
 	delayacct_tsk_free(tsk);
 
 	if (!profile_handoff_task(tsk))
@@ -1293,7 +1294,8 @@ bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
 	atomic_dec(&p->cred->user->processes);
-	exit_creds(p);
+	put_cred(p->real_cred);
+	put_cred(p->cred);
 bad_fork_free:
 	free_task(p);
 fork_out:
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 9fcb53a..94abc21 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -470,7 +470,6 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info,
 	int retval = 0;
 
 	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
-	validate_creds(sub_info->cred);
 
 	helper_lock();
 	if (sub_info->path[0] == '\0')
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e08ffa1..63f0906 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -652,21 +652,6 @@ config DEBUG_NOTIFIERS
 	  This is a relatively cheap check but if you care about maximum
 	  performance, say N.
 
-config DEBUG_CREDENTIALS
-	bool "Debug credential management"
-	depends on DEBUG_KERNEL
-	help
-	  Enable this to turn on some debug checking for credential
-	  management.  The additional code keeps track of the number of
-	  pointers from task_structs to any given cred struct, and checks to
-	  see that this number never exceeds the usage count of the cred
-	  struct.
-
-	  Furthermore, if SELinux is enabled, this also checks that the
-	  security pointer in the cred struct is never seen to be invalid.
-
-	  If unsure, say N.
-
 #
 # Select this config option from the architecture Kconfig, if it
 # it is preferred to always offer frame pointers as a config
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ec04cc2..772c1fa 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1535,8 +1535,6 @@ static int inode_has_perm(const struct cred *cred,
 	struct common_audit_data ad;
 	u32 sid;
 
-	validate_creds(cred);
-
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 
@@ -3243,9 +3241,7 @@ static int selinux_task_create(unsigned long clone_flags)
 static void selinux_cred_free(struct cred *cred)
 {
 	struct task_security_struct *tsec = cred->security;
-
-	BUG_ON((unsigned long) cred->security < PAGE_SIZE);
-	cred->security = (void *) 0x7UL;
+	cred->security = NULL;
 	kfree(tsec);
 }
 

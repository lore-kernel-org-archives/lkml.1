Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbZEGJ5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbZEGJ5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZEGJ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:56:57 -0400
Received: from tundra.namei.org ([65.99.196.166]:37543 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbZEGJ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:56:56 -0400
Date: Thu, 7 May 2009 19:54:24 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-security-module@vger.kernel.org
In-Reply-To: <20090507092009.GC3036@sequoia.sous-sol.org>
Message-ID: <alpine.LRH.2.00.0905071951530.29219@tundra.namei.org>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com>
 <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu> <20090507092009.GC3036@sequoia.sous-sol.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Chris Wright wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:

[Added LSM list to the CC; please do so whenever making changes in this 
area...]

> > They have no active connection to the core kernel 
> > ptrace_may_access() check in any case:
> 
> Not sure what you mean:
> 
> ptrace_may_access
>  __ptrace_may_access
>   security_ptrace_may_access
> 
> Looks like your patch won't compile.
> 

Below is an updated version which fixes the bug, against 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

Boot tested with SELinux.

commit c4c79671177dc3e8387c337f75f3c664cdf08838
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu May 7 19:26:19 2009 +1000

    security: rename ptrace_may_access => ptrace_access_check
    
    The ->ptrace_may_access() methods are named confusingly - the real
    ptrace_may_access() returns a bool, while these security checks have
    a retval convention.
    
    Rename it to ptrace_access_check, to reduce the confusion factor.
    
    [ Impact: cleanup, no code changed ]
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: James Morris <jmorris@namei.org>

diff --git a/include/linux/security.h b/include/linux/security.h
index 54ed157..0147def 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -51,7 +51,7 @@ struct audit_krule;
 extern int cap_capable(struct task_struct *tsk, const struct cred *cred,
 		       int cap, int audit);
 extern int cap_settime(struct timespec *ts, struct timezone *tz);
-extern int cap_ptrace_may_access(struct task_struct *child, unsigned int mode);
+extern int cap_ptrace_access_check(struct task_struct *child, unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern int cap_capset(struct cred *new, const struct cred *old,
@@ -1208,7 +1208,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@alter contains the flag indicating whether changes are to be made.
  *	Return 0 if permission is granted.
  *
- * @ptrace_may_access:
+ * @ptrace_access_check:
  *	Check permission before allowing the current process to trace the
  *	@child process.
  *	Security modules may also want to perform a process tracing check
@@ -1223,7 +1223,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Check that the @parent process has sufficient permission to trace the
  *	current process before allowing the current process to present itself
  *	to the @parent process for tracing.
- *	The parent process will still have to undergo the ptrace_may_access
+ *	The parent process will still have to undergo the ptrace_access_check
  *	checks before it is allowed to trace this one.
  *	@parent contains the task_struct structure for debugger process.
  *	Return 0 if permission is granted.
@@ -1335,7 +1335,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
 
-	int (*ptrace_may_access) (struct task_struct *child, unsigned int mode);
+	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
 	int (*ptrace_traceme) (struct task_struct *parent);
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
@@ -1616,7 +1616,7 @@ extern int security_module_enable(struct security_operations *ops);
 extern int register_security(struct security_operations *ops);
 
 /* Security operations */
-int security_ptrace_may_access(struct task_struct *child, unsigned int mode);
+int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
 int security_capget(struct task_struct *target,
 		    kernel_cap_t *effective,
@@ -1797,10 +1797,10 @@ static inline int security_init(void)
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
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index c9cf48b..284d0ac 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -160,7 +160,7 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	if (!dumpable && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 
-	return security_ptrace_may_access(task, mode);
+	return security_ptrace_access_check(task, mode);
 }
 
 bool ptrace_may_access(struct task_struct *task, unsigned int mode)
diff --git a/security/capability.c b/security/capability.c
index 21b6cea..f218dd3 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -863,7 +863,7 @@ struct security_operations default_security_ops = {
 
 void security_fixup_ops(struct security_operations *ops)
 {
-	set_to_cap_if_null(ops, ptrace_may_access);
+	set_to_cap_if_null(ops, ptrace_access_check);
 	set_to_cap_if_null(ops, ptrace_traceme);
 	set_to_cap_if_null(ops, capget);
 	set_to_cap_if_null(ops, capset);
diff --git a/security/commoncap.c b/security/commoncap.c
index 97ac1f1..e57611a 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -101,7 +101,7 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
 }
 
 /**
- * cap_ptrace_may_access - Determine whether the current process may access
+ * cap_ptrace_access_check - Determine whether the current process may access
  *			   another
  * @child: The process to be accessed
  * @mode: The mode of attachment.
@@ -109,7 +109,7 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
  * Determine whether a process may access another, returning 0 if permission
  * granted, -ve if denied.
  */
-int cap_ptrace_may_access(struct task_struct *child, unsigned int mode)
+int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
 	int ret = 0;
 
diff --git a/security/root_plug.c b/security/root_plug.c
index 40fb4f1..e8d5861 100644
--- a/security/root_plug.c
+++ b/security/root_plug.c
@@ -72,7 +72,7 @@ static int rootplug_bprm_check_security (struct linux_binprm *bprm)
 
 static struct security_operations rootplug_security_ops = {
 	/* Use the capability functions for some of the hooks */
-	.ptrace_may_access =		cap_ptrace_may_access,
+	.ptrace_access_check =		cap_ptrace_access_check,
 	.ptrace_traceme =		cap_ptrace_traceme,
 	.capget =			cap_capget,
 	.capset =			cap_capset,
diff --git a/security/security.c b/security/security.c
index 206e538..a3e6918 100644
--- a/security/security.c
+++ b/security/security.c
@@ -127,9 +127,9 @@ int register_security(struct security_operations *ops)
 
 /* Security operations */
 
-int security_ptrace_may_access(struct task_struct *child, unsigned int mode)
+int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
-	return security_ops->ptrace_may_access(child, mode);
+	return security_ops->ptrace_access_check(child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 39046dd..e30c4bb 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1854,12 +1854,12 @@ static inline u32 open_file_to_av(struct file *file)
 
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
 
@@ -5310,7 +5310,7 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 static struct security_operations selinux_ops = {
 	.name =				"selinux",
 
-	.ptrace_may_access =		selinux_ptrace_may_access,
+	.ptrace_access_check =		selinux_ptrace_access_check,
 	.ptrace_traceme =		selinux_ptrace_traceme,
 	.capget =			selinux_capget,
 	.capset =			selinux_capset,
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index f557767..79949f9 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -91,7 +91,7 @@ struct inode_smack *new_inode_smack(char *smack)
  */
 
 /**
- * smack_ptrace_may_access - Smack approval on PTRACE_ATTACH
+ * smack_ptrace_access_check - Smack approval on PTRACE_ATTACH
  * @ctp: child task pointer
  * @mode: ptrace attachment mode
  *
@@ -99,13 +99,13 @@ struct inode_smack *new_inode_smack(char *smack)
  *
  * Do the capability checks, and require read and write.
  */
-static int smack_ptrace_may_access(struct task_struct *ctp, unsigned int mode)
+static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 {
 	int rc;
 	struct smk_audit_info ad;
 	char *sp, *tsp;
 
-	rc = cap_ptrace_may_access(ctp, mode);
+	rc = cap_ptrace_access_check(ctp, mode);
 	if (rc != 0)
 		return rc;
 
@@ -3031,7 +3031,7 @@ static void smack_release_secctx(char *secdata, u32 seclen)
 struct security_operations smack_ops = {
 	.name =				"smack",
 
-	.ptrace_may_access =		smack_ptrace_may_access,
+	.ptrace_access_check =		smack_ptrace_access_check,
 	.ptrace_traceme =		smack_ptrace_traceme,
 	.capget = 			cap_capget,
 	.capset = 			cap_capset,

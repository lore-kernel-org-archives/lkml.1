Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbZEGJGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbZEGJGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbZEGJGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:06:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48637 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbZEGJGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:06:12 -0400
Date: Thu, 7 May 2009 11:04:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090507090459.GE19133@elte.hu>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507085742.GB3036@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> > > Agreed, but what about security_operations->ptrace_may_access ?
> > > It has the same (bad) name, but returns the error code or 0 on 
> > > success.
> > 
> > Bad code should generally be fixed, or in exceptional circumstances 
> > it can tolerated if it's pre-existing bad code, but it should never 
> > be propagated. It has not spread _that_ widely yet, and is isolated 
> > to the security subsystem:
> 
> And the security hooks tend to all follow the 0 success -ve ERR on error.

I just sent a patch (see below) that renames them to 
ptrace_access_check().

They have no active connection to the core kernel 
ptrace_may_access() check in any case: the methods seem to be 
home-brewn, security-module specific checks for how wide ptrace is 
allowed to go.

The design around that code does not seem to be very consistent.

One solution would be for the default "plain Linux" security module 
to have a stock ->ptrace_access_check() that does the current 
ptrace_may_access() check, and then procfs could be updated to use 
that callback - instead of calling into the ptrace core code 
directly.

This would mean that in the end the 'may' usage is eliminated 
altogether, and we have a clean ptrace_access_check() facility with 
a retval convention.

	Ingo

-------------->
Subject: security: rename ptrace_may_access => ptrace_access_check
From: Ingo Molnar <mingo@elte.hu>

The ->ptrace_may_access methods are named confusingly - the real
ptrace_may_access() returns a bool, while these security checks have
a retval convention.

Rename it to ptrace_access_check, to reduce the confusion factor.

[ Impact: cleanup, no code changed ]

Signed-off-by-if-you-test-it: Ingo Molnar <mingo@elte.hu>
---
 include/linux/security.h   |   14 +++++++-------
 security/capability.c      |    2 +-
 security/commoncap.c       |    4 ++--
 security/root_plug.c       |    2 +-
 security/security.c        |    4 ++--
 security/selinux/hooks.c   |    6 +++---
 security/smack/smack_lsm.c |    8 ++++----
 7 files changed, 20 insertions(+), 20 deletions(-)

Index: tip/include/linux/security.h
===================================================================
--- tip.orig/include/linux/security.h
+++ tip/include/linux/security.h
@@ -52,7 +52,7 @@ struct audit_krule;
 extern int cap_capable(struct task_struct *tsk, const struct cred *cred,
 		       int cap, int audit);
 extern int cap_settime(struct timespec *ts, struct timezone *tz);
-extern int cap_ptrace_may_access(struct task_struct *child, unsigned int mode);
+extern int cap_ptrace_access_check(struct task_struct *child, unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
 extern int cap_capset(struct cred *new, const struct cred *old,
@@ -1209,7 +1209,7 @@ static inline void security_free_mnt_opt
  *	@alter contains the flag indicating whether changes are to be made.
  *	Return 0 if permission is granted.
  *
- * @ptrace_may_access:
+ * @ptrace_access_check:
  *	Check permission before allowing the current process to trace the
  *	@child process.
  *	Security modules may also want to perform a process tracing check
@@ -1224,7 +1224,7 @@ static inline void security_free_mnt_opt
  *	Check that the @parent process has sufficient permission to trace the
  *	current process before allowing the current process to present itself
  *	to the @parent process for tracing.
- *	The parent process will still have to undergo the ptrace_may_access
+ *	The parent process will still have to undergo the ptrace_access_check
  *	checks before it is allowed to trace this one.
  *	@parent contains the task_struct structure for debugger process.
  *	Return 0 if permission is granted.
@@ -1336,7 +1336,7 @@ static inline void security_free_mnt_opt
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
 
-	int (*ptrace_may_access) (struct task_struct *child, unsigned int mode);
+	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
 	int (*ptrace_traceme) (struct task_struct *parent);
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
@@ -1617,7 +1617,7 @@ extern int security_module_enable(struct
 extern int register_security(struct security_operations *ops);
 
 /* Security operations */
-int security_ptrace_may_access(struct task_struct *child, unsigned int mode);
+int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
 int security_capget(struct task_struct *target,
 		    kernel_cap_t *effective,
@@ -1798,10 +1798,10 @@ static inline int security_init(void)
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
Index: tip/security/capability.c
===================================================================
--- tip.orig/security/capability.c
+++ tip/security/capability.c
@@ -867,7 +867,7 @@ struct security_operations default_secur
 
 void security_fixup_ops(struct security_operations *ops)
 {
-	set_to_cap_if_null(ops, ptrace_may_access);
+	set_to_cap_if_null(ops, ptrace_access_check);
 	set_to_cap_if_null(ops, ptrace_traceme);
 	set_to_cap_if_null(ops, capget);
 	set_to_cap_if_null(ops, capset);
Index: tip/security/commoncap.c
===================================================================
--- tip.orig/security/commoncap.c
+++ tip/security/commoncap.c
@@ -79,7 +79,7 @@ int cap_settime(struct timespec *ts, str
 }
 
 /**
- * cap_ptrace_may_access - Determine whether the current process may access
+ * cap_ptrace_access_check - Determine whether the current process may access
  *			   another
  * @child: The process to be accessed
  * @mode: The mode of attachment.
@@ -87,7 +87,7 @@ int cap_settime(struct timespec *ts, str
  * Determine whether a process may access another, returning 0 if permission
  * granted, -ve if denied.
  */
-int cap_ptrace_may_access(struct task_struct *child, unsigned int mode)
+int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
 	int ret = 0;
 
Index: tip/security/root_plug.c
===================================================================
--- tip.orig/security/root_plug.c
+++ tip/security/root_plug.c
@@ -72,7 +72,7 @@ static int rootplug_bprm_check_security 
 
 static struct security_operations rootplug_security_ops = {
 	/* Use the capability functions for some of the hooks */
-	.ptrace_may_access =		cap_ptrace_may_access,
+	.ptrace_access_check =		cap_ptrace_access_check,
 	.ptrace_traceme =		cap_ptrace_traceme,
 	.capget =			cap_capget,
 	.capset =			cap_capset,
Index: tip/security/security.c
===================================================================
--- tip.orig/security/security.c
+++ tip/security/security.c
@@ -127,9 +127,9 @@ int register_security(struct security_op
 
 /* Security operations */
 
-int security_ptrace_may_access(struct task_struct *child, unsigned int mode)
+int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
-	return security_ops->ptrace_may_access(child, mode);
+	return security_ops->ptrace_access_check(child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
Index: tip/security/selinux/hooks.c
===================================================================
--- tip.orig/security/selinux/hooks.c
+++ tip/security/selinux/hooks.c
@@ -1854,12 +1854,12 @@ static inline u32 open_file_to_av(struct
 
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
 
@@ -5318,7 +5318,7 @@ static int selinux_key_getsecurity(struc
 static struct security_operations selinux_ops = {
 	.name =				"selinux",
 
-	.ptrace_may_access =		selinux_ptrace_may_access,
+	.ptrace_access_check =		selinux_ptrace_access_check,
 	.ptrace_traceme =		selinux_ptrace_traceme,
 	.capget =			selinux_capget,
 	.capset =			selinux_capset,
Index: tip/security/smack/smack_lsm.c
===================================================================
--- tip.orig/security/smack/smack_lsm.c
+++ tip/security/smack/smack_lsm.c
@@ -92,7 +92,7 @@ struct inode_smack *new_inode_smack(char
  */
 
 /**
- * smack_ptrace_may_access - Smack approval on PTRACE_ATTACH
+ * smack_ptrace_access_check - Smack approval on PTRACE_ATTACH
  * @ctp: child task pointer
  * @mode: ptrace attachment mode
  *
@@ -100,11 +100,11 @@ struct inode_smack *new_inode_smack(char
  *
  * Do the capability checks, and require read and write.
  */
-static int smack_ptrace_may_access(struct task_struct *ctp, unsigned int mode)
+static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 {
 	int rc;
 
-	rc = cap_ptrace_may_access(ctp, mode);
+	rc = cap_ptrace_access_check(ctp, mode);
 	if (rc != 0)
 		return rc;
 
@@ -2826,7 +2826,7 @@ static void smack_release_secctx(char *s
 struct security_operations smack_ops = {
 	.name =				"smack",
 
-	.ptrace_may_access =		smack_ptrace_may_access,
+	.ptrace_access_check =		smack_ptrace_access_check,
 	.ptrace_traceme =		smack_ptrace_traceme,
 	.capget = 			cap_capget,
 	.capset = 			cap_capset,


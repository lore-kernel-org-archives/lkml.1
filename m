Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbYBYRmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbYBYRmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYBYRmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:42:03 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42150 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbYBYRmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:42:00 -0500
Date: Mon, 25 Feb 2008 20:42:29 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       David Quigley <dpquigl@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Eric Paris <eparis@redhat.com>, Harald Welte <laforge@gnumonks.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] security_task_kill: kill now unused "secid" argument
Message-ID: <20080225174229.GA22087@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous patch security_task_kill() is always called with secid == 0.
Remove this argument and simplify the ->task_kill() implementations.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/security.h   |   13 +++++--------
 kernel/signal.c            |    2 +-
 security/security.c        |    5 ++---
 security/commoncap.c       |   14 ++------------
 security/dummy.c           |    2 +-
 security/smack/smack_lsm.c |   12 ++----------
 security/selinux/hooks.c   |   13 ++++---------
 7 files changed, 17 insertions(+), 44 deletions(-)

--- 25/include/linux/security.h~3_STK_NO_SECID	2008-02-15 16:59:17.000000000 +0300
+++ 25/include/linux/security.h	2008-02-25 20:00:01.000000000 +0300
@@ -63,7 +63,7 @@ extern int cap_inode_need_killpriv(struc
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
-extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig, u32 secid);
+extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig);
 extern int cap_task_setscheduler (struct task_struct *p, int policy, struct sched_param *lp);
 extern int cap_task_setioprio (struct task_struct *p, int ioprio);
 extern int cap_task_setnice (struct task_struct *p, int nice);
@@ -669,7 +669,6 @@ struct request_sock;
  *	@p contains the task_struct for process.
  *	@info contains the signal information.
  *	@sig contains the signal value.
- *	@secid contains the sid of the process where the signal originated
  *	Return 0 if permission is granted.
  * @task_wait:
  *	Check permission before allowing a process to reap a child process @p
@@ -1342,7 +1341,7 @@ struct security_operations {
 	int (*task_getscheduler) (struct task_struct * p);
 	int (*task_movememory) (struct task_struct * p);
 	int (*task_kill) (struct task_struct * p,
-			  struct siginfo * info, int sig, u32 secid);
+			  struct siginfo * info, int sig);
 	int (*task_wait) (struct task_struct * p);
 	int (*task_prctl) (int option, unsigned long arg2,
 			   unsigned long arg3, unsigned long arg4,
@@ -1596,8 +1595,7 @@ int security_task_setscheduler(struct ta
 				int policy, struct sched_param *lp);
 int security_task_getscheduler(struct task_struct *p);
 int security_task_movememory(struct task_struct *p);
-int security_task_kill(struct task_struct *p, struct siginfo *info,
-			int sig, u32 secid);
+int security_task_kill(struct task_struct *p, struct siginfo *info, int sig);
 int security_task_wait(struct task_struct *p);
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			 unsigned long arg4, unsigned long arg5);
@@ -2135,10 +2133,9 @@ static inline int security_task_movememo
 }
 
 static inline int security_task_kill (struct task_struct *p,
-				      struct siginfo *info, int sig,
-				      u32 secid)
+				      struct siginfo *info, int sig)
 {
-	return cap_task_kill(p, info, sig, secid);
+	return cap_task_kill(p, info, sig);
 }
 
 static inline int security_task_wait (struct task_struct *p)
--- 25/kernel/signal.c~3_STK_NO_SECID	2008-02-25 19:13:56.000000000 +0300
+++ 25/kernel/signal.c	2008-02-25 20:01:07.000000000 +0300
@@ -544,7 +544,7 @@ static int check_kill_permission(int sig
 	    && !capable(CAP_KILL))
 		return -EPERM;
 
-	return security_task_kill(t, info, sig, 0);
+	return security_task_kill(t, info, sig);
 }
 
 /* forward decl */
--- 25/security/security.c~3_STK_NO_SECID	2008-02-15 16:59:20.000000000 +0300
+++ 25/security/security.c	2008-02-25 20:03:09.000000000 +0300
@@ -673,10 +673,9 @@ int security_task_movememory(struct task
 	return security_ops->task_movememory(p);
 }
 
-int security_task_kill(struct task_struct *p, struct siginfo *info,
-			int sig, u32 secid)
+int security_task_kill(struct task_struct *p, struct siginfo *info, int sig)
 {
-	return security_ops->task_kill(p, info, sig, secid);
+	return security_ops->task_kill(p, info, sig);
 }
 
 int security_task_wait(struct task_struct *p)
--- 25/security/commoncap.c~3_STK_NO_SECID	2008-02-25 18:52:16.000000000 +0300
+++ 25/security/commoncap.c	2008-02-25 20:16:06.000000000 +0300
@@ -540,8 +540,7 @@ int cap_task_setnice (struct task_struct
 	return cap_safe_nice(p);
 }
 
-int cap_task_kill(struct task_struct *p, struct siginfo *info,
-				int sig, u32 secid)
+int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig)
 {
 	/*
 	 * Running a setuid root program raises your capabilities.
@@ -556,14 +555,6 @@ int cap_task_kill(struct task_struct *p,
 	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
 		return 0;
 
-	if (secid)
-		/*
-		 * Signal sent as a particular user.
-		 * Capabilities are ignored.  May be wrong, but it's the
-		 * only thing we can do at the moment.
-		 * Used only by usb drivers?
-		 */
-		return 0;
 	if (cap_issubset(p->cap_permitted, current->cap_permitted))
 		return 0;
 	if (capable(CAP_KILL))
@@ -602,8 +593,7 @@ int cap_task_setnice (struct task_struct
 {
 	return 0;
 }
-int cap_task_kill(struct task_struct *p, struct siginfo *info,
-				int sig, u32 secid)
+int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig)
 {
 	return 0;
 }
--- 25/security/dummy.c~3_STK_NO_SECID	2008-02-15 16:59:20.000000000 +0300
+++ 25/security/dummy.c	2008-02-25 20:08:47.000000000 +0300
@@ -589,7 +589,7 @@ static int dummy_task_wait (struct task_
 }
 
 static int dummy_task_kill (struct task_struct *p, struct siginfo *info,
-			    int sig, u32 secid)
+			    int sig)
 {
 	return 0;
 }
--- 25/security/smack/smack_lsm.c~3_STK_NO_SECID	2008-02-25 18:54:01.000000000 +0300
+++ 25/security/smack/smack_lsm.c	2008-02-25 20:10:08.000000000 +0300
@@ -1083,7 +1083,6 @@ static int smack_task_movememory(struct 
  * @p: the task object
  * @info: unused
  * @sig: unused
- * @secid: identifies the smack to use in lieu of current's
  *
  * Return 0 if write access is permitted
  *
@@ -1091,20 +1090,13 @@ static int smack_task_movememory(struct 
  * in the USB code. Someday it may go away.
  */
 static int smack_task_kill(struct task_struct *p, struct siginfo *info,
-			   int sig, u32 secid)
+			   int sig)
 {
 	/*
 	 * Sending a signal requires that the sender
 	 * can write the receiver.
 	 */
-	if (secid == 0)
-		return smk_curacc(p->security, MAY_WRITE);
-	/*
-	 * If the secid isn't 0 we're dealing with some USB IO
-	 * specific behavior. This is not clean. For one thing
-	 * we can't take privilege into account.
-	 */
-	return smk_access(smack_from_secid(secid), p->security, MAY_WRITE);
+	return smk_curacc(p->security, MAY_WRITE);
 }
 
 /**
--- 25/security/selinux/hooks.c~3_STK_NO_SECID	2008-02-25 18:57:23.000000000 +0300
+++ 25/security/selinux/hooks.c	2008-02-25 20:13:43.000000000 +0300
@@ -3184,13 +3184,12 @@ static int selinux_task_movememory(struc
 }
 
 static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
-				int sig, u32 secid)
+				int sig)
 {
 	u32 perm;
 	int rc;
-	struct task_security_struct *tsec;
 
-	rc = secondary_ops->task_kill(p, info, sig, secid);
+	rc = secondary_ops->task_kill(p, info, sig);
 	if (rc)
 		return rc;
 
@@ -3198,12 +3197,8 @@ static int selinux_task_kill(struct task
 		perm = PROCESS__SIGNULL; /* null signal; existence test */
 	else
 		perm = signal_to_av(sig);
-	tsec = p->security;
-	if (secid)
-		rc = avc_has_perm(secid, tsec->sid, SECCLASS_PROCESS, perm, NULL);
-	else
-		rc = task_has_perm(current, p, perm);
-	return rc;
+
+	return task_has_perm(current, p, perm);
 }
 
 static int selinux_task_prctl(int option,


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYBYRj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYBYRj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYBYRju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:39:50 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:35081 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbYBYRju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:39:50 -0500
Date: Mon, 25 Feb 2008 20:42:25 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       David Quigley <dpquigl@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Eric Paris <eparis@redhat.com>, Harald Welte <laforge@gnumonks.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] signals: cleanup security_task_kill() usage/implementation
Message-ID: <20080225174225.GA22081@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every implementation of ->task_kill() does nothing when the signal comes from
the kernel. This is correct, but means that check_kill_permission() should call
security_task_kill() only for SI_FROMUSER() case, and we can remove the same
check from ->task_kill() implementations.

(sadly, check_kill_permission() is the last user of signal->session/__session
 but we can't s/task_session_nr/task_session/ here).

NOTE: Eric W. Biederman pointed out cap_task_kill() should die, and I think he
is very right.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 kernel/signal.c            |   27 ++++++++++++++-------------
 security/commoncap.c       |    3 ---
 security/selinux/hooks.c   |    3 ---
 security/smack/smack_lsm.c |    9 ---------
 4 files changed, 14 insertions(+), 28 deletions(-)

--- 25/kernel/signal.c~1_LSM_KILL	2008-02-25 18:12:57.000000000 +0300
+++ 25/kernel/signal.c	2008-02-25 18:15:38.000000000 +0300
@@ -526,22 +526,23 @@ static int rm_from_queue(unsigned long m
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
 {
-	int error = -EINVAL;
+	int error;
+
 	if (!valid_signal(sig))
-		return error;
+		return -EINVAL;
 
-	if (info == SEND_SIG_NOINFO || (!is_si_special(info) && SI_FROMUSER(info))) {
-		error = audit_signal_info(sig, t); /* Let audit system see the signal */
-		if (error)
-			return error;
-		error = -EPERM;
-		if (((sig != SIGCONT) ||
-			(task_session_nr(current) != task_session_nr(t)))
-		    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
-		    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
-		    && !capable(CAP_KILL))
+	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
+		return 0;
+
+	error = audit_signal_info(sig, t); /* Let audit system see the signal */
+	if (error)
 		return error;
-	}
+
+	if (((sig != SIGCONT) || (task_session_nr(current) != task_session_nr(t)))
+	    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
+	    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
+	    && !capable(CAP_KILL))
+		return -EPERM;
 
 	return security_task_kill(t, info, sig, 0);
 }
--- 25/security/commoncap.c~1_LSM_KILL	2008-02-25 18:07:54.000000000 +0300
+++ 25/security/commoncap.c	2008-02-25 18:52:16.000000000 +0300
@@ -543,9 +543,6 @@ int cap_task_setnice (struct task_struct
 int cap_task_kill(struct task_struct *p, struct siginfo *info,
 				int sig, u32 secid)
 {
-	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
-		return 0;
-
 	/*
 	 * Running a setuid root program raises your capabilities.
 	 * Killing your own setuid root processes was previously
--- 25/security/smack/smack_lsm.c~1_LSM_KILL	2008-02-15 16:59:20.000000000 +0300
+++ 25/security/smack/smack_lsm.c	2008-02-25 18:54:01.000000000 +0300
@@ -1094,15 +1094,6 @@ static int smack_task_kill(struct task_s
 			   int sig, u32 secid)
 {
 	/*
-	 * Special cases where signals really ought to go through
-	 * in spite of policy. Stephen Smalley suggests it may
-	 * make sense to change the caller so that it doesn't
-	 * bother with the LSM hook in these cases.
-	 */
-	if (info != SEND_SIG_NOINFO &&
-	    (is_si_special(info) || SI_FROMKERNEL(info)))
-		return 0;
-	/*
 	 * Sending a signal requires that the sender
 	 * can write the receiver.
 	 */
--- 25/security/selinux/hooks.c~1_LSM_KILL	2008-02-15 16:59:20.000000000 +0300
+++ 25/security/selinux/hooks.c	2008-02-25 18:57:23.000000000 +0300
@@ -3194,9 +3194,6 @@ static int selinux_task_kill(struct task
 	if (rc)
 		return rc;
 
-	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
-		return 0;
-
 	if (!sig)
 		perm = PROCESS__SIGNULL; /* null signal; existence test */
 	else


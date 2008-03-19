Return-Path: <linux-kernel-owner+w=401wt.eu-S937133AbYCSV0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937133AbYCSV0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762062AbYCSUA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:00:58 -0400
Received: from over.ny.us.ibm.com ([32.97.182.150]:33535 "EHLO
	over.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYCSUA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:00:57 -0400
Date: Wed, 19 Mar 2008 11:56:35 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, Andrew Morgan <morgan@kernel.org>,
       buraphalinuxserver@gmail.com,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: [PATCH 1/1] file capabilities: remove cap_task_kill() (-git)
Message-ID: <20080319165635.GH5935@sergelap.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending once against -git.  I had sent against -stable in
http://lkml.org/lkml/2008/2/28/225.  Without this patch,
atd is broken at least on some distros.)

The original justification for cap_task_kill() was as follows:

	check_kill_permission() does appropriate uid equivalence checks.
	However with file capabilities it becomes possible for an
	unprivileged user to execute a file with file capabilities
	resulting in a more privileged task with the same uid.

However now that cap_task_kill() always returns 0 (permission
granted) when p->uid==current->uid, the whole hook is worthless,
and only likely to create more subtle problems in the corner cases
where it might still be called but return -EPERM.  Those cases
are basically when uids are different but euid/suid is equivalent
as per the check in check_kill_permission().

One example of a still-broken application is 'at' for non-root users.

This patch removes cap_task_kill().

Signed-off-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
---
 include/linux/security.h |    3 +--
 security/capability.c    |    1 -
 security/commoncap.c     |   40 ----------------------------------------
 3 files changed, 1 insertions(+), 43 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index b07357c..c673dfd 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -57,7 +57,6 @@ extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
-extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig, u32 secid);
 extern int cap_task_setscheduler (struct task_struct *p, int policy, struct sched_param *lp);
 extern int cap_task_setioprio (struct task_struct *p, int ioprio);
 extern int cap_task_setnice (struct task_struct *p, int nice);
@@ -2187,7 +2186,7 @@ static inline int security_task_kill (struct task_struct *p,
 				      struct siginfo *info, int sig,
 				      u32 secid)
 {
-	return cap_task_kill(p, info, sig, secid);
+	return 0;
 }
 
 static inline int security_task_wait (struct task_struct *p)
diff --git a/security/capability.c b/security/capability.c
index 9e99f36..2c6e06d 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -40,7 +40,6 @@ static struct security_operations capability_ops = {
 	.inode_need_killpriv =		cap_inode_need_killpriv,
 	.inode_killpriv =		cap_inode_killpriv,
 
-	.task_kill =			cap_task_kill,
 	.task_setscheduler =		cap_task_setscheduler,
 	.task_setioprio =		cap_task_setioprio,
 	.task_setnice =			cap_task_setnice,
diff --git a/security/commoncap.c b/security/commoncap.c
index bb0c095..06d5c94 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -540,41 +540,6 @@ int cap_task_setnice (struct task_struct *p, int nice)
 	return cap_safe_nice(p);
 }
 
-int cap_task_kill(struct task_struct *p, struct siginfo *info,
-				int sig, u32 secid)
-{
-	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
-		return 0;
-
-	/*
-	 * Running a setuid root program raises your capabilities.
-	 * Killing your own setuid root processes was previously
-	 * allowed.
-	 * We must preserve legacy signal behavior in this case.
-	 */
-	if (p->uid == current->uid)
-		return 0;
-
-	/* sigcont is permitted within same session */
-	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
-		return 0;
-
-	if (secid)
-		/*
-		 * Signal sent as a particular user.
-		 * Capabilities are ignored.  May be wrong, but it's the
-		 * only thing we can do at the moment.
-		 * Used only by usb drivers?
-		 */
-		return 0;
-	if (cap_issubset(p->cap_permitted, current->cap_permitted))
-		return 0;
-	if (capable(CAP_KILL))
-		return 0;
-
-	return -EPERM;
-}
-
 /*
  * called from kernel/sys.c for prctl(PR_CABSET_DROP)
  * done without task_capability_lock() because it introduces
@@ -605,11 +570,6 @@ int cap_task_setnice (struct task_struct *p, int nice)
 {
 	return 0;
 }
-int cap_task_kill(struct task_struct *p, struct siginfo *info,
-				int sig, u32 secid)
-{
-	return 0;
-}
 #endif
 
 void cap_task_reparent_to_init (struct task_struct *p)
-- 
1.5.2.5


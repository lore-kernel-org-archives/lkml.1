Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbYB1RlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbYB1RlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYB1RlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:41:08 -0500
Received: from smtp110.sbc.mail.re2.yahoo.com ([68.142.229.95]:27458 "HELO
	smtp110.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752083AbYB1RlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:41:07 -0500
X-YMail-OSG: Vb6xrHMVM1njHbNtUMN9NJv3AiuMfheKY9T6XV6TCg923Ctslzglz7hV_iioz3SI8rb3r0McTrWu0ix4623jmL7_d6w9CRQGaVQjh52cmLg1OrOX7Q--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 28 Feb 2008 11:38:17 -0600
From: serge@hallyn.com
To: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
Cc: Andrew Morgan <morgan@kernel.org>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Mike Galbraith <efault@gmx.de>, buraphalinuxserver@gmail.com,
       elendil@planet.nl
Subject: [PATCH 1/1] file capabilities: remove cap_task_kill()
Message-ID: <20080228173817.GA32661@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This patch removes cap_task_kill().

Signed-off-by: Serge Hallyn <serge@hallyn.com>
---
 include/linux/security.h   |    3 +--
 security/capability.c      |    1 -
 security/commoncap.c       |   40 ----------------------------------------
 security/smack/smack_lsm.c |    5 -----
 4 files changed, 1 insertions(+), 48 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index fe52cde..95cb830 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -63,7 +63,6 @@ extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
-extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig, u32 secid);
 extern int cap_task_setscheduler (struct task_struct *p, int policy, struct sched_param *lp);
 extern int cap_task_setioprio (struct task_struct *p, int ioprio);
 extern int cap_task_setnice (struct task_struct *p, int nice);
@@ -2138,7 +2137,7 @@ static inline int security_task_kill (struct task_struct *p,
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
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 770eb06..a9ca412 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1124,11 +1124,6 @@ static int smack_task_movememory(struct task_struct *p)
 static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 			   int sig, u32 secid)
 {
-	int rc;
-
-	rc = cap_task_kill(p, info, sig, secid);
-	if (rc != 0)
-		return rc;
 	/*
 	 * Special cases where signals really ought to go through
 	 * in spite of policy. Stephen Smalley suggests it may
-- 
1.5.2.5


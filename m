Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbYCTNZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbYCTNZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 09:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYCTNZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 09:25:18 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51003 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbYCTNZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 09:25:15 -0400
Date: Thu, 20 Mar 2008 08:25:09 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       morgan@kernel.org, buraphalinuxserver@gmail.com,
       lcapitulino@mandriva.com.br
Subject: Re: [PATCH 1/1] file capabilities: remove cap_task_kill() (-git)
Message-ID: <20080320132509.GA8229@sergelap.austin.ibm.com>
References: <20080319165635.GH5935@sergelap.ibm.com> <20080319164601.d105e3df.akpm@linux-foundation.org> <alpine.LFD.1.00.0803191912360.3020@woody.linux-foundation.org> <20080320031803.GA23254@sergelap.austin.ibm.com> <alpine.LFD.1.00.0803192115370.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803192115370.3020@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds (torvalds@linux-foundation.org):
> 
> 
> On Wed, 19 Mar 2008, Serge E. Hallyn wrote:
> > 
> > Right, that was against
> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
> > which doesn't yet have smack.  I should've been clear about that.
> 
> Ok, now I'm _really_ confused. I have smack in my tree, it got merged 
> before -rc1.

No clearly I'm the one confused/on drugs.

I see it now.  I swear I checked my own freshly pulled tree and
gitweb several times...

> So any patch that is against some version without smack is not a patch 
> against a -git tree for the last several weeks.
> 
> Me confused.
> 
> 		Linus

New patch against -git attached.

thanks,
-serge


>From a0e56351e00b7b7442723b7ca6247c267c2628fd Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serge@hallyn.com>
Date: Fri, 29 Feb 2008 15:14:57 +0000
Subject: [PATCH 1/1] file capabilities: remove cap_task_kill() (-git)

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
 include/linux/security.h   |    3 +--
 security/capability.c      |    1 -
 security/commoncap.c       |   40 ----------------------------------------
 security/smack/smack_lsm.c |    5 -----
 4 files changed, 1 insertions(+), 48 deletions(-)

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
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 38d7075..732ba27 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1117,11 +1117,6 @@ static int smack_task_movememory(struct task_struct *p)
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


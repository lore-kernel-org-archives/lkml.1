Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbYBAU3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbYBAU3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbYBAU3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:29:25 -0500
Received: from smtp119.sbc.mail.re3.yahoo.com ([66.196.96.92]:46508 "HELO
	smtp119.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756307AbYBAU3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:29:24 -0500
X-YMail-OSG: ZG61FeoVM1kQfclVTL9P5OvksZeafHkUz7hN7gxKuT8oc9JcKlR2FZr240xBheEhmQlqoTnrnXBw1zSvvRGpDRe8SRp3quTnb4Tg7rIRYlmcJnN3AUx5VpDzc9afrh2.vfRLNyui7MmeZ10-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 1 Feb 2008 14:15:26 -0600
From: serge@hallyn.com
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] per-process securebits
Message-ID: <20080201201526.GA4684@vino.hallyn.com>
References: <47A2D439.9050704@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A2D439.9050704@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Here is the patch to add per-process securebits.
>
> Its all code that lives inside the capability LSM and the new securebits
> implementation is only active if CONFIG_SECURITY_FILE_CAPABILITIES is
> enabled (it doesn't make much sense to support this feature without
> filesystem capabilities).
>
> The patch assumes the CAP_SETPCAP fix of last week, but is otherwise on
> top of 2.6.24-rc8-mm1.

Hey Andrew,  I'm about to set up some ltp tests, but noticed the
following patch is needed on top of yours.

-serge

>From feac61b47be8375e25b0f6ee876cf096c8b1b9cc Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Fri, 1 Feb 2008 14:13:29 +0000
Subject: [PATCH 1/1] per-process securebits: security_task_prctl takes a long

Fix a mismatch between prototypes and callers for the updated
security_task_prctl().  The newly introduced argument, error,
is a long, not an int.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/security.h |    8 ++++----
 security/commoncap.c     |    4 ++--
 security/dummy.c         |    2 +-
 security/security.c      |    2 +-
 security/selinux/hooks.c |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index c550079..c789a0d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -63,7 +63,7 @@ extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 extern void cap_task_reparent_to_init (struct task_struct *p);
 extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig, u32 secid);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			  unsigned long arg4, unsigned long arg5, int *rc_p);
+			  unsigned long arg4, unsigned long arg5, long *rc_p);
 extern int cap_task_setscheduler (struct task_struct *p, int policy, struct sched_param *lp);
 extern int cap_task_setioprio (struct task_struct *p, int ioprio);
 extern int cap_task_setnice (struct task_struct *p, int nice);
@@ -1348,7 +1348,7 @@ struct security_operations {
 	int (*task_wait) (struct task_struct * p);
 	int (*task_prctl) (int option, unsigned long arg2,
 			   unsigned long arg3, unsigned long arg4,
-			   unsigned long arg5, int *rc_p);
+			   unsigned long arg5, long *rc_p);
 	void (*task_reparent_to_init) (struct task_struct * p);
 	void (*task_to_inode)(struct task_struct *p, struct inode *inode);
 
@@ -1602,7 +1602,7 @@ int security_task_kill(struct task_struct *p, struct siginfo *info,
 			int sig, u32 secid);
 int security_task_wait(struct task_struct *p);
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			 unsigned long arg4, unsigned long arg5, int *rc_p);
+			 unsigned long arg4, unsigned long arg5, long *rc_p);
 void security_task_reparent_to_init(struct task_struct *p);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
@@ -2151,7 +2151,7 @@ static inline int security_task_wait (struct task_struct *p)
 static inline int security_task_prctl (int option, unsigned long arg2,
 				       unsigned long arg3,
 				       unsigned long arg4,
-				       unsigned long arg5, int *rc_p)
+				       unsigned long arg5, long *rc_p)
 {
 	return 0;
 }
diff --git a/security/commoncap.c b/security/commoncap.c
index 9b87182..858387a 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -611,9 +611,9 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 #endif
 
 int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-		   unsigned long arg4, unsigned long arg5, int *rc_p)
+		   unsigned long arg4, unsigned long arg5, long *rc_p)
 {
-	int error = 0;
+	long error = 0;
 
 	switch (option) {
 	case PR_CAPBSET_READ:
diff --git a/security/dummy.c b/security/dummy.c
index c9e6d9f..e79f988 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -595,7 +595,7 @@ static int dummy_task_kill (struct task_struct *p, struct siginfo *info,
 }
 
 static int dummy_task_prctl (int option, unsigned long arg2, unsigned long arg3,
-			     unsigned long arg4, unsigned long arg5, int *rc_p)
+			     unsigned long arg4, unsigned long arg5, long *rc_p)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index c3cc14e..6f53155 100644
--- a/security/security.c
+++ b/security/security.c
@@ -683,7 +683,7 @@ int security_task_wait(struct task_struct *p)
 }
 
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			 unsigned long arg4, unsigned long arg5, int *rc_p)
+			 unsigned long arg4, unsigned long arg5, long *rc_p)
 {
 	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5, rc_p);
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3c88858..a553984 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3210,7 +3210,7 @@ static int selinux_task_prctl(int option,
 			      unsigned long arg3,
 			      unsigned long arg4,
 			      unsigned long arg5,
-			      int *rc_p)
+			      long *rc_p)
 {
 	/* The current prctl operations do not appear to require
 	   any SELinux controls since they merely observe or modify
-- 
1.5.2.5


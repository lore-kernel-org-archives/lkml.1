Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZJQVVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZJQVVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 17:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZJQVV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 17:21:26 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60863 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbZJQVVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 17:21:22 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH -repost 2/8] SECURITY: add task_struct to setrlimit
Date: Sat, 17 Oct 2009 23:21:16 +0200
Message-Id: <1255814482-13994-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255814482-13994-1-git-send-email-jirislaby@gmail.com>
References: <1255814482-13994-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add task_struct to task_setrlimit of security_operations to be able to set
rlimit of different task than current.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Eric Paris <eparis@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
---
 include/linux/security.h |    9 ++++++---
 kernel/sys.c             |    2 +-
 security/capability.c    |    3 ++-
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    7 ++++---
 5 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index ed0faea..3f3844a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1590,7 +1590,8 @@ struct security_operations {
 	int (*task_setnice) (struct task_struct *p, int nice);
 	int (*task_setioprio) (struct task_struct *p, int ioprio);
 	int (*task_getioprio) (struct task_struct *p);
-	int (*task_setrlimit) (unsigned int resource, struct rlimit *new_rlim);
+	int (*task_setrlimit) (struct task_struct *p, unsigned int resource,
+			struct rlimit *new_rlim);
 	int (*task_setscheduler) (struct task_struct *p, int policy,
 				  struct sched_param *lp);
 	int (*task_getscheduler) (struct task_struct *p);
@@ -1855,7 +1856,8 @@ int security_task_setgroups(struct group_info *group_info);
 int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
-int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim);
+int security_task_setrlimit(struct task_struct *p, unsigned int resource,
+		struct rlimit *new_rlim);
 int security_task_setscheduler(struct task_struct *p,
 				int policy, struct sched_param *lp);
 int security_task_getscheduler(struct task_struct *p);
@@ -2471,7 +2473,8 @@ static inline int security_task_getioprio(struct task_struct *p)
 	return 0;
 }
 
-static inline int security_task_setrlimit(unsigned int resource,
+static inline int security_task_setrlimit(struct task_struct *p,
+					  unsigned int resource,
 					  struct rlimit *new_rlim)
 {
 	return 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index 1828f8d..57ffd4c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1256,7 +1256,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
 		return -EPERM;
 
-	retval = security_task_setrlimit(resource, &new_rlim);
+	retval = security_task_setrlimit(current, resource, &new_rlim);
 	if (retval)
 		return retval;
 
diff --git a/security/capability.c b/security/capability.c
index 4f3ab47..d30a8e8 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -466,7 +466,8 @@ static int cap_task_getioprio(struct task_struct *p)
 	return 0;
 }
 
-static int cap_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
+static int cap_task_setrlimit(struct task_struct *p, unsigned int resource,
+		struct rlimit *new_rlim)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 2797573..000e225 100644
--- a/security/security.c
+++ b/security/security.c
@@ -801,9 +801,10 @@ int security_task_getioprio(struct task_struct *p)
 	return security_ops->task_getioprio(p);
 }
 
-int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
+int security_task_setrlimit(struct task_struct *p, unsigned int resource,
+		struct rlimit *new_rlim)
 {
-	return security_ops->task_setrlimit(resource, new_rlim);
+	return security_ops->task_setrlimit(p, resource, new_rlim);
 }
 
 int security_task_setscheduler(struct task_struct *p,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5718abc..1a4c113 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3389,16 +3389,17 @@ static int selinux_task_getioprio(struct task_struct *p)
 	return current_has_perm(p, PROCESS__GETSCHED);
 }
 
-static int selinux_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
+static int selinux_task_setrlimit(struct task_struct *p, unsigned int resource,
+		struct rlimit *new_rlim)
 {
-	struct rlimit *old_rlim = current->signal->rlim + resource;
+	struct rlimit *old_rlim = p->signal->rlim + resource;
 
 	/* Control the ability to change the hard limit (whether
 	   lowering or raising it), so that the hard limit can
 	   later be used as a safe reset point for the soft limit
 	   upon context transitions.  See selinux_bprm_committing_creds. */
 	if (old_rlim->rlim_max != new_rlim->rlim_max)
-		return current_has_perm(current, PROCESS__SETRLIMIT);
+		return current_has_perm(p, PROCESS__SETRLIMIT);
 
 	return 0;
 }
-- 
1.6.4.2


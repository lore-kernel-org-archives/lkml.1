Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZK0XGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZK0XGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZK0XGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:06:10 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60404 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZK0XGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com
Subject: [PATCH v3 02/27] SECURITY: add task_struct to setrlimit
Date: Sat, 28 Nov 2009 00:05:42 +0100
Message-Id: <1259363167-9347-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

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
index 239e40d..193b3d9 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1570,7 +1570,8 @@ struct security_operations {
 	int (*task_setnice) (struct task_struct *p, int nice);
 	int (*task_setioprio) (struct task_struct *p, int ioprio);
 	int (*task_getioprio) (struct task_struct *p);
-	int (*task_setrlimit) (unsigned int resource, struct rlimit *new_rlim);
+	int (*task_setrlimit) (struct task_struct *p, unsigned int resource,
+			struct rlimit *new_rlim);
 	int (*task_setscheduler) (struct task_struct *p, int policy,
 				  struct sched_param *lp);
 	int (*task_getscheduler) (struct task_struct *p);
@@ -1835,7 +1836,8 @@ int security_task_setgroups(struct group_info *group_info);
 int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
-int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim);
+int security_task_setrlimit(struct task_struct *p, unsigned int resource,
+		struct rlimit *new_rlim);
 int security_task_setscheduler(struct task_struct *p,
 				int policy, struct sched_param *lp);
 int security_task_getscheduler(struct task_struct *p);
@@ -2451,7 +2453,8 @@ static inline int security_task_getioprio(struct task_struct *p)
 	return 0;
 }
 
-static inline int security_task_setrlimit(unsigned int resource,
+static inline int security_task_setrlimit(struct task_struct *p,
+					  unsigned int resource,
 					  struct rlimit *new_rlim)
 {
 	return 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index ce17760..9898a8a 100644
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
index fce07a7..5882ec0 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -450,7 +450,8 @@ static int cap_task_getioprio(struct task_struct *p)
 	return 0;
 }
 
-static int cap_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
+static int cap_task_setrlimit(struct task_struct *p, unsigned int resource,
+		struct rlimit *new_rlim)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index c4c6732..4b23d83 100644
--- a/security/security.c
+++ b/security/security.c
@@ -781,9 +781,10 @@ int security_task_getioprio(struct task_struct *p)
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
index 36d9e25..1167f01 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3390,16 +3390,17 @@ static int selinux_task_getioprio(struct task_struct *p)
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
1.6.5.3


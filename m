Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZJQVV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZJQVV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 17:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZJQVVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 17:21:25 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60866 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbZJQVVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 17:21:22 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH -repost 5/8] core: split sys_setrlimit
Date: Sat, 17 Oct 2009 23:21:19 +0200
Message-Id: <1255814482-13994-5-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255814482-13994-1-git-send-email-jirislaby@gmail.com>
References: <1255814482-13994-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create setrlimit from sys_setrlimit and declare setrlimit in
the resource header. This is to allow rlimits to be changed not
only by syscall, but later from proc code too.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 include/linux/resource.h |    2 ++
 kernel/sys.c             |   44 ++++++++++++++++++++++++++------------------
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/include/linux/resource.h b/include/linux/resource.h
index 40fc7e6..4301d67 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -71,5 +71,7 @@ struct rlimit {
 #include <asm/resource.h>
 
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru);
+int setrlimit(struct task_struct *tsk, unsigned int resource,
+		struct rlimit *new_rlim);
 
 #endif
diff --git a/kernel/sys.c b/kernel/sys.c
index 4b3a966..2dc84b9 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1238,42 +1238,39 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 
 #endif
 
-SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
+int setrlimit(struct task_struct *tsk, unsigned int resource,
+		struct rlimit *new_rlim)
 {
-	struct rlimit new_rlim, *old_rlim;
+	struct rlimit *old_rlim;
 	int retval;
 
-	if (resource >= RLIM_NLIMITS)
-		return -EINVAL;
-	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
-		return -EFAULT;
-	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+	if (new_rlim->rlim_cur > new_rlim->rlim_max)
 		return -EINVAL;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
+	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
 		return -EPERM;
 
-	retval = security_task_setrlimit(current, resource, &new_rlim);
+	retval = security_task_setrlimit(tsk, resource, new_rlim);
 	if (retval)
 		return retval;
 
-	if (resource == RLIMIT_CPU && new_rlim.rlim_cur == 0) {
+	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
 		 * The caller is asking for an immediate RLIMIT_CPU
 		 * expiry.  But we use the zero value to mean "it was
 		 * never set".  So let's cheat and make it one second
 		 * instead
 		 */
-		new_rlim.rlim_cur = 1;
+		new_rlim->rlim_cur = 1;
 	}
 
-	old_rlim = current->signal->rlim + resource;
-	task_lock(current->group_leader);
-	if ((new_rlim.rlim_max <= old_rlim->rlim_max) ||
+	old_rlim = tsk->signal->rlim + resource;
+	task_lock(tsk->group_leader);
+	if ((new_rlim->rlim_max <= old_rlim->rlim_max) ||
 				capable(CAP_SYS_RESOURCE))
-		*old_rlim = new_rlim;
+		*old_rlim = *new_rlim;
 	else
 		retval = -EPERM;
-	task_unlock(current->group_leader);
+	task_unlock(tsk->group_leader);
 
 	if (retval || resource != RLIMIT_CPU)
 		goto out;
@@ -1284,14 +1281,25 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	 * very long-standing error, and fixing it now risks breakage of
 	 * applications, so we live with it
 	 */
-	if (new_rlim.rlim_cur == RLIM_INFINITY)
+	if (new_rlim->rlim_cur == RLIM_INFINITY)
 		goto out;
 
-	update_rlimit_cpu(current, new_rlim.rlim_cur);
+	update_rlimit_cpu(tsk, new_rlim->rlim_cur);
 out:
 	return retval;
 }
 
+SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
+{
+	struct rlimit new_rlim;
+
+	if (resource >= RLIM_NLIMITS)
+		return -EINVAL;
+	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
+		return -EFAULT;
+	return setrlimit(current, resource, &new_rlim);
+}
+
 /*
  * It would make sense to put struct rusage in the task_struct,
  * except that would make the task_struct be *really big*.  After
-- 
1.6.4.2


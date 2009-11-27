Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbZK0XHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbZK0XHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbZK0XGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:06:08 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60419 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZK0XGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com
Subject: [PATCH v3 05/27] core: split sys_setrlimit
Date: Sat, 28 Nov 2009 00:05:45 +0100
Message-Id: <1259363167-9347-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

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
index 4377cb3..398f9e1 100644
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
1.6.5.3


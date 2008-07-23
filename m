Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYGWMen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYGWMen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYGWMdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:33:54 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:56406 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbYGWMdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:33:52 -0400
Message-ID: <488722E9.1050100@miraclelinux.com>
Date: Wed, 23 Jul 2008 21:24:09 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: menage@google.com
Subject: [RFC][PATCH][3/3] restructure sys_setrlimit
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.7.23.121701
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
---
 include/linux/resource.h |    2 +
 kernel/sys.c             |   56 ++++++++++++++++++++++++++---------------------
 2 files changed, 34 insertions(+), 24 deletions(-)

--- linux-2.6.26-rc8-mm1.orig/kernel/sys.c	2008-07-22 21:22:30.000000000 +0900
+++ linux-2.6.26-rc8-mm1/kernel/sys.c	2008-07-22 21:23:00.000000000 +0900
@@ -1457,42 +1457,37 @@ asmlinkage long sys_old_getrlimit(unsign

 #endif

-asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
+long __setrlimit(struct task_struct *tsk, unsigned int resource,
+		  struct rlimit *new_rlim)
 {
-	struct rlimit new_rlim, *old_rlim;
+	struct rlimit *old_rlim;
 	unsigned long it_prof_secs;
 	int retval;

-	if (resource >= RLIM_NLIMITS)
-		return -EINVAL;
-	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
-		return -EFAULT;
-	if (new_rlim.rlim_cur > new_rlim.rlim_max)
-		return -EINVAL;
-	old_rlim = current->signal->rlim + resource;
-	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
+	old_rlim = tsk->signal->rlim + resource;
+	if ((new_rlim->rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
+	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
 		return -EPERM;

-	retval = security_task_setrlimit(resource, &new_rlim);
+	retval = security_task_setrlimit(resource, new_rlim);
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

-	task_lock(current->group_leader);
-	*old_rlim = new_rlim;
-	task_unlock(current->group_leader);
+	task_lock(tsk->group_leader);
+	*old_rlim = *new_rlim;
+	task_unlock(tsk->group_leader);

 	if (resource != RLIMIT_CPU)
 		goto out;
@@ -1503,25 +1498,38 @@ asmlinkage long sys_setrlimit(unsigned i
 	 * very long-standing error, and fixing it now risks breakage of
 	 * applications, so we live with it
 	 */
-	if (new_rlim.rlim_cur == RLIM_INFINITY)
+	if (new_rlim->rlim_cur == RLIM_INFINITY)
 		goto out;

-	it_prof_secs = cputime_to_secs(current->signal->it_prof_expires);
-	if (it_prof_secs == 0 || new_rlim.rlim_cur <= it_prof_secs) {
-		unsigned long rlim_cur = new_rlim.rlim_cur;
+	it_prof_secs = cputime_to_secs(tsk->signal->it_prof_expires);
+	if (it_prof_secs == 0 || new_rlim->rlim_cur <= it_prof_secs) {
+		unsigned long rlim_cur = new_rlim->rlim_cur;
 		cputime_t cputime;

 		cputime = secs_to_cputime(rlim_cur);
 		read_lock(&tasklist_lock);
-		spin_lock_irq(&current->sighand->siglock);
-		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
-		spin_unlock_irq(&current->sighand->siglock);
+		spin_lock_irq(&tsk->sighand->siglock);
+		set_process_cpu_timer(tsk, CPUCLOCK_PROF, &cputime, NULL);
+		spin_unlock_irq(&tsk->sighand->siglock);
 		read_unlock(&tasklist_lock);
 	}
 out:
 	return 0;
 }

+asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
+{
+	struct rlimit new_rlim;
+
+	if (resource >= RLIM_NLIMITS)
+		return -EINVAL;
+	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
+		return -EFAULT;
+	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+		return -EINVAL;
+	return __setrlimit(current, resource, &new_rlim);
+}
+
 /*
  * It would make sense to put struct rusage in the task_struct,
  * except that would make the task_struct be *really big*.  After
--- linux-2.6.26-rc8-mm1.orig/include/linux/resource.h	2008-07-22 21:23:59.000000000 +0900
+++ linux-2.6.26-rc8-mm1/include/linux/resource.h	2008-07-22 21:24:02.000000000 +0900
@@ -96,4 +96,6 @@ static const struct limit_names lnames[R

 int getrusage(struct task_struct *p, int who, struct rusage __user *ru);

+long __setrlimit(struct task_struct *tsk, unsigned int resource,
+		  struct rlimit *new_rlim);
 #endif



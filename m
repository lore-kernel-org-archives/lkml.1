Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZB0Jom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZB0Jom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZB0Jod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:44:33 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:37532 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbZB0Joc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:44:32 -0500
Date: Fri, 27 Feb 2009 15:13:54 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Chris Friesen <cfriesen@nortel.com>, mingo@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, mtk.manpages@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] sched: Don't allow setuid to succeed if the user does not
	have rt bandwidth
Message-ID: <20090227094354.GA6444@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <4999BC0C.1010304@fatooh.org> <20090217050033.GA10409@linux.vnet.ibm.com> <20090217101542.GB15989@linux.vnet.ibm.com> <1234869339.4744.77.camel@laptop> <20090223114541.GD31277@linux.vnet.ibm.com> <1235390396.4645.87.camel@laptop> <20090224091849.GA18693@linux.vnet.ibm.com> <874oyj4yiz.fsf@basil.nowhere.org> <1235493365.4645.2061.camel@laptop> <49A44A86.2030409@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A44A86.2030409@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Corey Hickey reported that on using setuid to change the uid of a
rt process, the process would be unkillable and not be running.
This is because there was no rt runtime for that user group. Add
in a check to see if a user can attach an rt task to its task group.
On failure, return EINVAL, which is also returned in
CONFIG_CGROUP_SCHED.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    4 ++++
 kernel/sched.c        |   13 +++++++++++--
 kernel/sys.c          |   31 ++++++++++++++++++++-----------
 kernel/user.c         |   18 ++++++++++++++++++
 4 files changed, 53 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2330,9 +2330,13 @@
 extern int sched_group_set_rt_period(struct task_group *tg,
 				      long rt_period_us);
 extern long sched_group_rt_period(struct task_group *tg);
+extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
 #endif
 #endif
 
+extern int task_can_switch_user(struct user_struct *up,
+					struct task_struct *tsk);
+
 #ifdef CONFIG_TASK_XACCT
 static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
 {
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -9466,6 +9466,16 @@
 
 	return ret;
 }
+
+int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
+{
+	/* Don't accept realtime tasks when there is no way for them to run */
+	if (rt_task(tsk) && tg->rt_bandwidth.rt_runtime == 0)
+		return 0;
+
+	return 1;
+}
+
 #else /* !CONFIG_RT_GROUP_SCHED */
 static int sched_rt_global_constraints(void)
 {
@@ -9559,8 +9569,7 @@
 		      struct task_struct *tsk)
 {
 #ifdef CONFIG_RT_GROUP_SCHED
-	/* Don't accept realtime tasks when there is no way for them to run */
-	if (rt_task(tsk) && cgroup_tg(cgrp)->rt_bandwidth.rt_runtime == 0)
+	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
 		return -EINVAL;
 #else
 	/* We don't support RT-tasks being in separate groups */
Index: linux-2.6/kernel/user.c
===================================================================
--- linux-2.6.orig/kernel/user.c
+++ linux-2.6/kernel/user.c
@@ -362,6 +362,24 @@
 
 #endif
 
+#if defined(CONFIG_RT_GROUP_SCHED) && defined(CONFIG_USER_SCHED)
+/*
+ * We need to check if a setuid can take place. This function should be called
+ * before successfully completing the setuid.
+ */
+int task_can_switch_user(struct user_struct *up, struct task_struct *tsk)
+{
+
+	return sched_rt_can_attach(up->tg, tsk);
+
+}
+#else
+int task_can_switch_user(struct user_struct *up, struct task_struct *tsk)
+{
+	return 1;
+}
+#endif
+
 /*
  * Locate the user_struct for the passed UID.  If found, take a ref on it.  The
  * caller must undo that ref with free_uid().
Index: linux-2.6/kernel/sys.c
===================================================================
--- linux-2.6.orig/kernel/sys.c
+++ linux-2.6/kernel/sys.c
@@ -560,7 +560,7 @@
 	abort_creds(new);
 	return retval;
 }
-  
+
 /*
  * change the user struct in a credentials set to match the new UID
  */
@@ -572,6 +572,11 @@
 	if (!new_user)
 		return -EAGAIN;
 
+	if (!task_can_switch_user(new_user, current)) {
+		free_uid(new_user);
+		return -EINVAL;
+	}
+
 	if (atomic_read(&new_user->processes) >=
 				current->signal->rlim[RLIMIT_NPROC].rlim_cur &&
 			new_user != INIT_USER) {
@@ -632,10 +637,11 @@
 			goto error;
 	}
 
-	retval = -EAGAIN;
-	if (new->uid != old->uid && set_user(new) < 0)
-		goto error;
-
+	if (new->uid != old->uid) {
+		retval = set_user(new);
+		if (retval < 0)
+			goto error;
+	}
 	if (ruid != (uid_t) -1 ||
 	    (euid != (uid_t) -1 && euid != old->uid))
 		new->suid = new->euid;
@@ -681,9 +687,10 @@
 	retval = -EPERM;
 	if (capable(CAP_SETUID)) {
 		new->suid = new->uid = uid;
-		if (uid != old->uid && set_user(new) < 0) {
-			retval = -EAGAIN;
-			goto error;
+		if (uid != old->uid) {
+			retval = set_user(new);
+			if (retval < 0)
+				goto error;
 		}
 	} else if (uid != old->uid && uid != new->suid) {
 		goto error;
@@ -735,11 +742,13 @@
 			goto error;
 	}
 
-	retval = -EAGAIN;
 	if (ruid != (uid_t) -1) {
 		new->uid = ruid;
-		if (ruid != old->uid && set_user(new) < 0)
-			goto error;
+		if (ruid != old->uid) {
+			retval = set_user(new);
+			if (retval < 0)
+				goto error;
+		}
 	}
 	if (euid != (uid_t) -1)
 		new->euid = euid;
-- 
regards,
Dhaval

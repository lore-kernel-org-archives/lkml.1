Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZBXJTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZBXJTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 04:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbZBXJT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 04:19:28 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52756 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbZBXJTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 04:19:25 -0500
Date: Tue, 24 Feb 2009 14:48:49 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RT scheduling and a way to make a process hang, unkillable
Message-ID: <20090224091849.GA18693@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20090216120213.GB3925@linux.vnet.ibm.com> <1234787082.30178.3.camel@laptop> <20090216131440.GC3925@linux.vnet.ibm.com> <20090216132014.GD3925@linux.vnet.ibm.com> <4999BC0C.1010304@fatooh.org> <20090217050033.GA10409@linux.vnet.ibm.com> <20090217101542.GB15989@linux.vnet.ibm.com> <1234869339.4744.77.camel@laptop> <20090223114541.GD31277@linux.vnet.ibm.com> <1235390396.4645.87.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235390396.4645.87.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I'd say go for the ENOTIME thing.

OK, how does the following do?
--
sched: Don't allow setuid to succeed if the user does not have rt bandwidth

Corey Hickey reported that on using setuid to change the uid of a
rt process, the process would be unkillable and not be running.
This is because there was no rt runtime for that user group. Add
in a check to see if a user can attach an rt task to its task group.

Returns a new error ENOTIME

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

---
 include/asm-generic/errno.h |    2 ++
 include/linux/sched.h       |    4 ++++
 kernel/sched.c              |   13 +++++++++++--
 kernel/sys.c                |   31 ++++++++++++++++++++-----------
 kernel/user.c               |   18 ++++++++++++++++++
 5 files changed, 55 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2320,9 +2320,13 @@
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
+		return -ENOTIME;
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
Index: linux-2.6/include/asm-generic/errno.h
===================================================================
--- linux-2.6.orig/include/asm-generic/errno.h
+++ linux-2.6/include/asm-generic/errno.h
@@ -106,4 +106,6 @@
 #define	EOWNERDEAD	130	/* Owner died */
 #define	ENOTRECOVERABLE	131	/* State not recoverable */
 
+#define ENOTIME		132	/* No time available to run process */
+
 #endif

-- 
regards,
Dhaval

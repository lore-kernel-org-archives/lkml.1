Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZBQKQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZBQKQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZBQKQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:16:18 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:50616 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZBQKQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:16:17 -0500
Date: Tue, 17 Feb 2009 15:45:43 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Corey Hickey <bugfood-ml@fatooh.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com
Subject: Re: RT scheduling and a way to make a process hang, unkillable
Message-ID: <20090217101542.GB15989@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <4997672B.1000301@fatooh.org> <1234697096.4713.24.camel@laptop> <20090216103636.GC17355@linux.vnet.ibm.com> <1234782516.4703.15.camel@laptop> <20090216120213.GB3925@linux.vnet.ibm.com> <1234787082.30178.3.camel@laptop> <20090216131440.GC3925@linux.vnet.ibm.com> <20090216132014.GD3925@linux.vnet.ibm.com> <4999BC0C.1010304@fatooh.org> <20090217050033.GA10409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217050033.GA10409@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This was on top of tip I think. But yeah, that would be expected.
> Yesterday was really not working out, I figured out this one, and had
> fixed this in the next version. I have a better patch arond here.
> 

This is on top of tip, and should have everything fixed up.

/me has his fingers crossed :)


sched: Don't allow setuid to succeed if the user does not have rt bandwidth

Corey Hickey reported that on using setuid to change the uid of a
rt process, the process would be unkillable and not be running.
This is because there was no rt runtime for that user group. Add
in a check to see if a user can attach an rt task to its task group.

Changes from v5:
1. free up the user struct on failure
2. Use the user struct obtained in set_user
3. Change the return value to ENOSPC, since this makes more sense, we do
not have RT runtime available to us.

Changes from v4:
1. Check if find_user returns a valid user struct.

Changes from v3:
1. Actually fix the leak.

Changes from v2:
1. Patch compiles for CONFIG_CGROUP_SCHED as well
2. Fix two memory leaks.

Changes from v1:
1. Peter suggested that rt_task_can_change_user should be renamed to
task_can_change_user
2. Changed sched_rt_can_attach to boolean.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>


Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2320,9 +2320,13 @@ extern long sched_group_rt_runtime(struc
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
@@ -9466,6 +9466,16 @@ static int sched_rt_global_constraints(v
 
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
@@ -9559,8 +9569,7 @@ cpu_cgroup_can_attach(struct cgroup_subs
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
@@ -362,6 +362,24 @@ static void free_user(struct user_struct
 
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
@@ -560,7 +560,7 @@ error:
 	abort_creds(new);
 	return retval;
 }
-  
+
 /*
  * change the user struct in a credentials set to match the new UID
  */
@@ -572,6 +572,11 @@ static int set_user(struct cred *new)
 	if (!new_user)
 		return -EAGAIN;
 
+	if (!task_can_switch_user(new_user, current)) {
+		free_uid(new_user);
+		return -ENOSPC;
+	}
+
 	if (atomic_read(&new_user->processes) >=
 				current->signal->rlim[RLIMIT_NPROC].rlim_cur &&
 			new_user != INIT_USER) {
@@ -632,10 +637,11 @@ SYSCALL_DEFINE2(setreuid, uid_t, ruid, u
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
@@ -681,9 +687,10 @@ SYSCALL_DEFINE1(setuid, uid_t, uid)
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
@@ -735,11 +742,13 @@ SYSCALL_DEFINE3(setresuid, uid_t, ruid, 
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

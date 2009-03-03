Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbZCCVDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbZCCVDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZCCVDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:03:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38823 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbZCCVDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:03:02 -0500
Date: Tue, 3 Mar 2009 22:02:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20090303210247.GA31244@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Dhaval Giani (1):
      sched: don't allow setuid to succeed if the user does not have rt bandwidth

Hiroshi Shimamoto (1):
      sched_rt: don't start timer when rt bandwidth disabled


 include/linux/sched.h |    4 ++++
 kernel/sched.c        |   15 ++++++++++++---
 kernel/sys.c          |   31 ++++++++++++++++++++-----------
 kernel/user.c         |   18 ++++++++++++++++++
 4 files changed, 54 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8981e52..8c216e0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2291,9 +2291,13 @@ extern long sched_group_rt_runtime(struct task_group *tg);
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
diff --git a/kernel/sched.c b/kernel/sched.c
index 410eec4..8e2558c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -223,7 +223,7 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 {
 	ktime_t now;
 
-	if (rt_bandwidth_enabled() && rt_b->rt_runtime == RUNTIME_INF)
+	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return;
 
 	if (hrtimer_active(&rt_b->rt_period_timer))
@@ -9224,6 +9224,16 @@ static int sched_rt_global_constraints(void)
 
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
@@ -9317,8 +9327,7 @@ cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		      struct task_struct *tsk)
 {
 #ifdef CONFIG_RT_GROUP_SCHED
-	/* Don't accept realtime tasks when there is no way for them to run */
-	if (rt_task(tsk) && cgroup_tg(cgrp)->rt_bandwidth.rt_runtime == 0)
+	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
 		return -EINVAL;
 #else
 	/* We don't support RT-tasks being in separate groups */
diff --git a/kernel/sys.c b/kernel/sys.c
index f145c41..37f458e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -559,7 +559,7 @@ error:
 	abort_creds(new);
 	return retval;
 }
-  
+
 /*
  * change the user struct in a credentials set to match the new UID
  */
@@ -571,6 +571,11 @@ static int set_user(struct cred *new)
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
@@ -631,10 +636,11 @@ SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
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
@@ -680,9 +686,10 @@ SYSCALL_DEFINE1(setuid, uid_t, uid)
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
@@ -734,11 +741,13 @@ SYSCALL_DEFINE3(setresuid, uid_t, ruid, uid_t, euid, uid_t, suid)
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
diff --git a/kernel/user.c b/kernel/user.c
index 3551ac7..6a9b696 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -362,6 +362,24 @@ static void free_user(struct user_struct *up, unsigned long flags)
 
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

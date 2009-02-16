Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbZBPNUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbZBPNUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbZBPNUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:20:45 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58016 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320AbZBPNUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:20:44 -0500
Date: Mon, 16 Feb 2009 18:50:14 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com
Subject: Re: RT scheduling and a way to make a process hang, unkillable
Message-ID: <20090216132014.GD3925@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <4997672B.1000301@fatooh.org> <1234697096.4713.24.camel@laptop> <20090216103636.GC17355@linux.vnet.ibm.com> <1234782516.4703.15.camel@laptop> <20090216120213.GB3925@linux.vnet.ibm.com> <1234787082.30178.3.camel@laptop> <20090216131440.GC3925@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216131440.GC3925@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 06:44:40PM +0530, Dhaval Giani wrote:
> On Mon, Feb 16, 2009 at 01:24:42PM +0100, Peter Zijlstra wrote:
> > On Mon, 2009-02-16 at 17:32 +0530, Dhaval Giani wrote:
> > 
> > > Yeah, made it boolean. how does the following look?
> > 
> > Much better, but look below.
> > 
> 
> <snip>
> 
> > > Index: linux-2.6/kernel/sys.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/sys.c
> > > +++ linux-2.6/kernel/sys.c
> > > @@ -579,6 +579,9 @@ static int set_user(struct cred *new)
> > >  		return -EAGAIN;
> > >  	}
> > >  
> > > +	if (!task_can_switch_user(new->uid, current))
> > > +		return -EAGAIN;
> > 
> > you're leaking new_user here.
> > 
> > Best might be to place this test on top before allocating it.
> > 
> 
> Yep, also another memory leak was there, which I fixed in this version.
> What about this? (This is not a good day!)
> 

And it continues on! Please try this version.

sched: Don't allow setuid to succeed if the user does not have rt bandwidth

Corey Hickey reported that on using setuid to change the uid of a
rt process, the process would be unkillable and not be running.
This is because there was no rt runtime for that user group. Add
in a check to see if a user can attach an rt task to its task group.

Disclaimer: Not sure about the return values, and if setuid allows
return values other than EPERM and EAGAIN.

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
@@ -2320,9 +2320,12 @@ extern long sched_group_rt_runtime(struc
 extern int sched_group_set_rt_period(struct task_group *tg,
 				      long rt_period_us);
 extern long sched_group_rt_period(struct task_group *tg);
+extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
 #endif
 #endif
 
+extern int task_can_switch_user(uid_t uid, struct task_struct *tsk);
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
@@ -362,6 +362,28 @@ static void free_user(struct user_struct
 
 #endif
 
+#if defined(CONFIG_RT_GROUP_SCHED) && defined(CONFIG_USER_SCHED)
+/*
+ * We need to check if a setuid can take place. This function should be called
+ * before successfully completing the setuid.
+ */
+int task_can_switch_user(uid_t uid, struct task_struct *tsk)
+{
+	int ret = 1;
+	struct user_struct *up = find_user(uid);
+
+	ret = sched_rt_can_attach(up->tg, tsk);
+	free_uid(up);
+
+	return ret;
+}
+#else
+int task_can_switch_user(uid_t uid, struct task_struct *tsk)
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
@@ -568,6 +568,9 @@ static int set_user(struct cred *new)
 {
 	struct user_struct *new_user;
 
+	if (!task_can_switch_user(new->uid, current))
+		return -EAGAIN;
+
 	new_user = alloc_uid(current_user_ns(), new->uid);
 	if (!new_user)
 		return -EAGAIN;
-- 
regards,
Dhaval

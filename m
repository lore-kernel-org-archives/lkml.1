Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYFWD5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYFWD5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYFWD5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:57:20 -0400
Received: from ozlabs.org ([203.10.76.45]:49791 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbYFWD5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:57:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG][PATCH -mm] avoid BUG() in __stop_machine_run()
Date: Mon, 23 Jun 2008 13:55:38 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <485A806A.2090602@goop.org> <20080620132110.GB19740@elte.hu>
In-Reply-To: <20080620132110.GB19740@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806231355.39329.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 June 2008 23:21:10 Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >> This simply introduces a flag to allow us to disable the capability
> >> checks for internal callers (this is simpler than splitting the
> >> sched_setscheduler() function, since it loops checking permissions).
> >
> > What about?
> >
> > int sched_setscheduler(struct task_struct *p, int policy,
> > 		       struct sched_param *param)
> > {
> > 	return __sched_setscheduler(p, policy, param, true);
> > }
> >
> >
> > int sched_setscheduler_nocheck(struct task_struct *p, int policy,
> > 		               struct sched_param *param)
> > {
> > 	return __sched_setscheduler(p, policy, param, false);
> > }
> >
> >
> > (With the appropriate transformation of sched_setscheduler -> __)
> >
> > Better than scattering stray true/falses around the code.
>
> agreed - it would also be less intrusive on the API change side.

Yes, here's the patch.  I've put it in my tree for testing, too.

sched_setscheduler_nocheck: add a flag to control access checks

Hidehiro Kawai noticed that sched_setscheduler() can fail in
stop_machine: it calls sched_setscheduler() from insmod, which can
have CAP_SYS_MODULE without CAP_SYS_NICE.

Two cases could have failed, so are changed to sched_setscheduler_nocheck:
  kernel/softirq.c:cpu_callback()
	- CPU hotplug callback
  kernel/stop_machine.c:__stop_machine_run()
	- Called from various places, including modprobe()

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 91c45b8d7775 include/linux/sched.h
--- a/include/linux/sched.h	Mon Jun 23 13:49:26 2008 +1000
+++ b/include/linux/sched.h	Mon Jun 23 13:54:55 2008 +1000
@@ -1655,6 +1655,8 @@ extern int task_curr(const struct task_s
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, struct sched_param *);
+extern int sched_setscheduler_nocheck(struct task_struct *, int,
+				      struct sched_param *);
 extern struct task_struct *idle_task(int cpu);
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
diff -r 91c45b8d7775 kernel/sched.c
--- a/kernel/sched.c	Mon Jun 23 13:49:26 2008 +1000
+++ b/kernel/sched.c	Mon Jun 23 13:54:55 2008 +1000
@@ -4744,16 +4744,8 @@ __setscheduler(struct rq *rq, struct tas
 	set_load_weight(p);
 }
 
-/**
- * sched_setscheduler - change the scheduling policy and/or RT priority of a thread.
- * @p: the task in question.
- * @policy: new policy.
- * @param: structure containing the new RT priority.
- *
- * NOTE that the task may be already dead.
- */
-int sched_setscheduler(struct task_struct *p, int policy,
-		       struct sched_param *param)
+static int __sched_setscheduler(struct task_struct *p, int policy,
+				struct sched_param *param, bool user)
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	unsigned long flags;
@@ -4785,7 +4777,7 @@ recheck:
 	/*
 	 * Allow unprivileged RT tasks to decrease priority:
 	 */
-	if (!capable(CAP_SYS_NICE)) {
+	if (user && !capable(CAP_SYS_NICE)) {
 		if (rt_policy(policy)) {
 			unsigned long rlim_rtprio;
 
@@ -4821,7 +4813,8 @@ recheck:
 	 * Do not allow realtime tasks into groups that have no runtime
 	 * assigned.
 	 */
-	if (rt_policy(policy) && task_group(p)->rt_bandwidth.rt_runtime == 0)
+	if (user
+	    && rt_policy(policy) && task_group(p)->rt_bandwidth.rt_runtime == 0)
 		return -EPERM;
 #endif
 
@@ -4870,7 +4863,38 @@ recheck:
 
 	return 0;
 }
+
+/**
+ * sched_setscheduler - change the scheduling policy and/or RT priority of a thread.
+ * @p: the task in question.
+ * @policy: new policy.
+ * @param: structure containing the new RT priority.
+ *
+ * NOTE that the task may be already dead.
+ */
+int sched_setscheduler(struct task_struct *p, int policy,
+		       struct sched_param *param)
+{
+	return __sched_setscheduler(p, policy, param, true);
+}
 EXPORT_SYMBOL_GPL(sched_setscheduler);
+
+/**
+ * sched_setscheduler_nocheck - change the scheduling policy and/or RT priority of a thread 
from kernelspace.
+ * @p: the task in question.
+ * @policy: new policy.
+ * @param: structure containing the new RT priority.
+ *
+ * Just like sched_setscheduler, only don't bother checking if the
+ * current context has permission.  For example, this is needed in
+ * stop_machine(): we create temporary high priority worker threads,
+ * but our caller might not have that capability.
+ */
+int sched_setscheduler_nocheck(struct task_struct *p, int policy,
+			       struct sched_param *param)
+{
+	return __sched_setscheduler(p, policy, param, false);
+}
 
 static int
 do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
diff -r 91c45b8d7775 kernel/softirq.c
--- a/kernel/softirq.c	Mon Jun 23 13:49:26 2008 +1000
+++ b/kernel/softirq.c	Mon Jun 23 13:54:55 2008 +1000
@@ -645,7 +645,7 @@ static int __cpuinit cpu_callback(struct
 
 		p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
-		sched_setscheduler(p, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 		kthread_stop(p);
 		takeover_tasklets(hotcpu);
 		break;
diff -r 91c45b8d7775 kernel/stop_machine.c
--- a/kernel/stop_machine.c	Mon Jun 23 13:49:26 2008 +1000
+++ b/kernel/stop_machine.c	Mon Jun 23 13:54:55 2008 +1000
@@ -187,7 +187,7 @@ struct task_struct *__stop_machine_run(i
 		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
 		/* One high-prio thread per cpu.  We'll do this one. */
-		sched_setscheduler(p, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 		kthread_bind(p, cpu);
 		wake_up_process(p);
 		wait_for_completion(&smdata.done);

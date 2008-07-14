Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYGNO3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYGNO3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYGNO3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:29:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbYGNO3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:29:22 -0400
Date: Mon, 14 Jul 2008 16:29:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] sched/new-API-sched_setscheduler
Message-ID: <20080714142908.GA18120@elte.hu>
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

Please pull the sched/new-API-sched_setscheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched/new-API-sched_setscheduler

this is a single commit that adds a new scheduler API. (which was kept 
in a separate topic branch to make it pullable by other maintainers in 
the development window without them having to pick up other scheduler 
changes)

Thanks,

	Ingo

------------------>
Rusty Russell (1):
      sched: add new API sched_setscheduler_nocheck: add a flag to control access checks


 include/linux/sched.h |    2 ++
 kernel/sched.c        |   48 ++++++++++++++++++++++++++++++++++++------------
 kernel/softirq.c      |    2 +-
 kernel/stop_machine.c |    2 +-
 4 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5d3f84..fe3b9b5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1655,6 +1655,8 @@ extern int can_nice(const struct task_struct *p, const int nice);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, struct sched_param *);
+extern int sched_setscheduler_nocheck(struct task_struct *, int,
+				      struct sched_param *);
 extern struct task_struct *idle_task(int cpu);
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index 3aaa5c8..7c0e706 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4744,16 +4744,8 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
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
 
@@ -4870,8 +4863,39 @@ recheck:
 
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
 
+/**
+ * sched_setscheduler_nocheck - change the scheduling policy and/or RT priority of a thread from kernelspace.
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
+
 static int
 do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
 {
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 36e0617..afd9120 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -645,7 +645,7 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 
 		p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
-		sched_setscheduler(p, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 		kthread_stop(p);
 		takeover_tasklets(hotcpu);
 		break;
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index b7350bb..ba9b205 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -187,7 +187,7 @@ struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
 		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
 		/* One high-prio thread per cpu.  We'll do this one. */
-		sched_setscheduler(p, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 		kthread_bind(p, cpu);
 		wake_up_process(p);
 		wait_for_completion(&smdata.done);

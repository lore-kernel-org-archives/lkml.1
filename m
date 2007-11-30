Return-Path: <linux-kernel-owner+w=401wt.eu-S935563AbXK3RIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935563AbXK3RIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935435AbXK3RIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:08:12 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:43066
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935429AbXK3RIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:08:09 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/4] Subject: SCHED - Make the wake-up priority a config option
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML 
	<"linux-kernel@vger.kernel.org>, linux-rt-users"@vger.kernel.org>,
       mingo@elte.hu
Date: Fri, 30 Nov 2007 11:46:49 -0500
Message-ID: <20071130164649.30588.20031.stgit@novell1.haskins.net>
In-Reply-To: <20071130163638.30588.47845.stgit@novell1.haskins.net>
References: <20071130163638.30588.47845.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We recently changed the behavior of the wake-up logic such that a higher
priority task does not preempt a lower-priority task if that task is RT.
Instead, it tries to pre-route the higher task to a different cpu.

This causes a performance regression for me in at least preempt-test.  I
suspect there may be other regressions as well.  We make it easier on people
to select which method they want by making the algorithm a config option,
with the default being the current behavior.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/Kconfig.preempt |   31 +++++++++++++++++++++++++++++++
 kernel/sched_rt.c      |   32 ++++++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index c64ce9c..c35b1d3 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -52,6 +52,37 @@ config PREEMPT
 
 endchoice
 
+choice 
+	prompt "Realtime Wakeup Policy"
+	default RTWAKEUP_FAVOR_HOT_TASK
+
+config RTWAKEUP_FAVOR_HOT_TASK
+	bool "Favor hot tasks"
+	help
+	 This setting strives to avoid creating an RT overload condition
+         by always favoring a hot RT task over a high priority RT task. The
+	 idea is that a newly woken RT task is not likely to be cache hot
+	 anyway.  Therefore it's cheaper to migrate the new task to some
+	 other processor rather than to preempt a currently executing RT
+	 task, even if the new task is of higher priority than the current.
+	 
+	 RT tasks behave differently than other tasks. If one gets preempted,
+	 we try to push it off to another queue. So trying to keep a
+	 preempting RT task on the same cache hot CPU will force the
+	 running RT task to a cold CPU. So we waste all the cache for the lower
+	 RT task in hopes of saving some of a RT task that is just being
+	 woken and probably will have cold cache anyway.
+
+config RTWAKEUP_FAVOR_HIGHER_TASK
+	bool "Favor highest priority"
+	help
+	  This setting strives to make sure the highest priority task has 
+	  the shortest wakeup latency possible by honoring its affinity when
+	  possible.  Some tests reveal that this results in higher
+	  performance, but this is still experimental.
+
+endchoice
+
 config PREEMPT_BKL
 	bool "Preempt The Big Kernel Lock"
 	depends on SMP || PREEMPT
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 0bd14bd..a9675dc 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -150,12 +150,19 @@ yield_task_rt(struct rq *rq)
 }
 
 #ifdef CONFIG_SMP
-static int find_lowest_rq(struct task_struct *task);
 
-static int select_task_rq_rt(struct task_struct *p, int sync)
+#ifdef CONFIG_RTWAKEUP_FAVOR_HIGHER_TASK
+static inline int rt_wakeup_premigrate(struct task_struct *p, struct rq *rq)
 {
-	struct rq *rq = task_rq(p);
+	if ((p->prio >= rq->rt.highest_prio) &&
+	    (p->nr_cpus_allowed > 1))
+		return 1;
 
+	return 0;
+}
+#else
+static inline int rt_wakeup_premigrate(struct task_struct *p, struct rq *rq)
+{
 	/*
 	 * If the current task is an RT task, then
 	 * try to see if we can wake this RT task up on another
@@ -174,7 +181,24 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
 	 * cold cache anyway.
 	 */
 	if (unlikely(rt_task(rq->curr)) &&
-	    (p->nr_cpus_allowed > 1)) {
+	    (p->nr_cpus_allowed > 1))
+		return 1;
+
+	return 0;
+}
+#endif
+
+static int find_lowest_rq(struct task_struct *task);
+
+static int select_task_rq_rt(struct task_struct *p, int sync)
+{
+	struct rq *rq = task_rq(p);
+
+	/*
+	 * Check to see if we should move this task away from its affined
+	 * RQ before we even initially wake it
+	 */
+	if (rt_wakeup_premigrate(p, rq)) {
 		int cpu = find_lowest_rq(p);
 
 		return (cpu == -1) ? task_cpu(p) : cpu;


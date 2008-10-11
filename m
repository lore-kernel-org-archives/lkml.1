Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYJKLCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYJKLCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 07:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYJKLCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 07:02:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:58735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYJKLCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 07:02:35 -0400
Subject: Re: [PATCH] sched: fair scheduler should not resched rt tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <clark.williams@gmail.com>
In-Reply-To: <alpine.DEB.1.10.0810110258310.12625@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810110258310.12625@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Sat, 11 Oct 2008 13:02:39 +0200
Message-Id: <1223722959.8485.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-11 at 03:01 -0400, Steven Rostedt wrote:
> Using ftrace, I noticed latencies in real-time tasks where they were
> needlessly calling schedule due to sched_fair sending out time slices.
> 
> This patch prevents a call to resched_task by the sched fair class if
> the task it wants to reschedule is an rt task.

Right, thats not a good thing, however this patch looks wrong, we should
never call hrtick_start_fair() on a rt task to begin with.

The way I can see that happening is through enqueue/dequeue_task_fair()
where we want to re-programm the hrtick because nr_running changes (and
thus the current tasks desired runtime).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5d39d92..6bcceec 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -73,6 +73,8 @@ unsigned int sysctl_sched_wakeup_granularity = 5000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
+static const struct sched_class fair_sched_class;
+
 /**************************************************************
  * CFS operations on generic schedulable entities:
  */
@@ -849,11 +851,31 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 		hrtick_start(rq, delta);
 	}
 }
+
+/*
+ * called from enqueue/dequeue and updates the hrtick when the
+ * current task is from our class and nr_running is low enough
+ * to matter.
+ */
+static void hrtick_update(struct rq *rq)
+{
+	struct task_struct *curr = rq->curr;
+
+	if (curr->sched_class != &fair_sched_class)
+		return;
+
+	if (cfs_rq_of(&curr->se)->nr_running < sched_nr_latency)
+		hrtick_start_fair(rq, curr);
+}
 #else /* !CONFIG_SCHED_HRTICK */
 static inline void
 hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
 }
+
+static inline void hrtick_update(struct rq *rq)
+{
+}
 #endif
 
 /*
@@ -874,7 +896,7 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 		wakeup = 1;
 	}
 
-	hrtick_start_fair(rq, rq->curr);
+	hrtick_update(rq);
 }
 
 /*
@@ -896,7 +918,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
 		sleep = 1;
 	}
 
-	hrtick_start_fair(rq, rq->curr);
+	hrtick_update(rq);
 }
 
 /*
@@ -1002,8 +1024,6 @@ static inline int wake_idle(int cpu, struct task_struct *p)
 
 #ifdef CONFIG_SMP
 
-static const struct sched_class fair_sched_class;
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
  * effective_load() calculates the load change as seen from the root_task_group



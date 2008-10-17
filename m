Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbYJQRbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbYJQRbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbYJQR37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:29:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:49811 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbYJQR36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:29:58 -0400
Message-Id: <20081017172829.637489523@chello.nl>
References: <20081017172701.047939625@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 17 Oct 2008 19:27:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/4] sched: fair scheduler should not resched rt tasks
Content-Disposition: inline; filename=hrtick-rostedt.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With use of ftrace Steven noticed that some RT tasks got rescheduled due
to sched_fair interaction.

What happens is that we reprogram the hrtick from enqueue/dequeue_fair_task()
because that can change nr_running, and thus a current tasks ideal runtime.
However, its possible the current task isn't a fair_sched_class task, and thus
doesn't have a hrtick set to change.

Fix this by wrapping those hrtick_start_fair() calls in a hrtick_update()
function, which will check for the right conditions.

Reported-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_fair.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -73,6 +73,8 @@ unsigned int sysctl_sched_wakeup_granula
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
+static const struct sched_class fair_sched_class;
+
 /**************************************************************
  * CFS operations on generic schedulable entities:
  */
@@ -848,11 +850,31 @@ static void hrtick_start_fair(struct rq 
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
@@ -873,7 +895,7 @@ static void enqueue_task_fair(struct rq 
 		wakeup = 1;
 	}
 
-	hrtick_start_fair(rq, rq->curr);
+	hrtick_update(rq);
 }
 
 /*
@@ -895,7 +917,7 @@ static void dequeue_task_fair(struct rq 
 		sleep = 1;
 	}
 
-	hrtick_start_fair(rq, rq->curr);
+	hrtick_update(rq);
 }
 
 /*
@@ -1001,8 +1023,6 @@ static inline int wake_idle(int cpu, str
 
 #ifdef CONFIG_SMP
 
-static const struct sched_class fair_sched_class;
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
  * effective_load() calculates the load change as seen from the root_task_group

-- 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbZKZIAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbZKZIAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759228AbZKZIAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:00:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55929 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759227AbZKZIAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:00:15 -0500
Date: Thu, 26 Nov 2009 19:00:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the workqueues tree with the tip tree
Message-Id: <20091126190018.88a6dd77.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
kernel/sched.c between commit eae0c9dfb534cb3449888b9601228efa6480fdb5
("sched: Fix and clean up rate-limit newidle code") from the tip tree and
commit 710c15b748f5ce9c573cc047f419cf007a677a9a ("sched: refactor
try_to_wake_up() and implement try_to_wake_up_local()") from the
workqueues tree.

I did the following fixup which should be checked ... I can carry this
fix (if it is suitable).

However, I have gone back to a previous version of the workqueues tree
for another issue (build problem for an interaction with the sound tree),
so this is not in linux-next today.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sched.c
index 686be36,e488e07..0000000
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@@ -2323,7 -2336,58 +2335,69 @@@ void task_oncpu_function_call(struct ta
  	preempt_enable();
  }
  
- /***
+ static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
+ 				 bool is_sync, bool is_migrate, bool is_local)
+ {
+ 	schedstat_inc(p, se.nr_wakeups);
+ 	if (is_sync)
+ 		schedstat_inc(p, se.nr_wakeups_sync);
+ 	if (is_migrate)
+ 		schedstat_inc(p, se.nr_wakeups_migrate);
+ 	if (is_local)
+ 		schedstat_inc(p, se.nr_wakeups_local);
+ 	else
+ 		schedstat_inc(p, se.nr_wakeups_remote);
+ 
+ 	activate_task(rq, p, 1);
+ 
+ 	/*
+ 	 * Only attribute actual wakeups done by this task.
+ 	 */
+ 	if (!in_interrupt()) {
+ 		struct sched_entity *se = &current->se;
+ 		u64 sample = se->sum_exec_runtime;
+ 
+ 		if (se->last_wakeup)
+ 			sample -= se->last_wakeup;
+ 		else
+ 			sample -= se->start_runtime;
+ 		update_avg(&se->avg_wakeup, sample);
+ 
+ 		se->last_wakeup = se->sum_exec_runtime;
+ 	}
+ }
+ 
+ static inline void ttwu_woken_up(struct task_struct *p, struct rq *rq,
+ 				 int wake_flags, bool success)
+ {
+ 	trace_sched_wakeup(rq, p, success);
+ 	check_preempt_curr(rq, p, wake_flags);
+ 
+ 	p->state = TASK_RUNNING;
+ #ifdef CONFIG_SMP
+ 	if (p->sched_class->task_wake_up)
+ 		p->sched_class->task_wake_up(rq, p);
++
++	if (unlikely(rq->idle_stamp)) {
++		u64 delta = rq->clock - rq->idle_stamp;
++		u64 max = 2*sysctl_sched_migration_cost;
++
++		if (delta > max)
++			rq->avg_idle = max;
++		else
++			update_avg(&rq->avg_idle, delta);
++		rq->idle_stamp = 0;
++	}
+ #endif
+ 	/*
+ 	 * Wake up is complete, fire wake up notifier.  This allows
+ 	 * try_to_wake_up_local() to be called from wake up notifiers.
+ 	 */
+ 	if (success)
+ 		fire_sched_notifier(p, wakeup);
+ }
+ 
+ /**
   * try_to_wake_up - wake up a thread
   * @p: the to-be-woken-up thread
   * @state: the mask of task states that can be woken

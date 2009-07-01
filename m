Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbZGAGVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbZGAGVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZGAGV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:21:29 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59698 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZGAGV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:21:29 -0400
Date: Wed, 01 Jul 2009 15:21:15 +0900 (JST)
Message-Id: <20090701.152115.706994265076015808.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] Adding information of counts processes acquired how
 many spinlocks to schedstat
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I wrote a test patch which add information of counts processes acquired how many spinlocks to schedstat.
After applied this patch, /proc/<PID>/sched will change like this,

init (1, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        482130.851458
se.vruntime                        :         26883.107980
se.sum_exec_runtime                :          2316.651816
se.avg_overlap                     :             0.480053
se.avg_wakeup                      :            14.999993
....
se.nr_wakeups_passive              :                    1
se.nr_wakeups_idle                 :                    0
se.nr_acquired_spinlock            :                74483
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
avg_atom                           :             2.181404
avg_per_cpu                        :           772.217272
nr_switches                        :                 1062
...

The line underlined with ^^^ is new one.
This means init process acquired spinlock 74483 times.
Today, spinlock is an importatnt factor for scalability.
This information must be useful for people working on multicore.

If you think this is useful, I would like to add more information related to spinlocks,
like average waiting time(or cycle count), max waiting time, etc...

But this patch has a point to consider, the line
        current->se.nr_acquired_spinlock++;
This breaks convention that incrementing member of sched_entity related to SCHEDSTAT
with schedstat_inc.
I couldn't write the point with schedstat_inc because of the structure of sched_stats.h.

How do you think about this?

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0085d75..f63b11f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1127,6 +1127,8 @@ struct sched_entity {
 	u64			nr_wakeups_affine_attempts;
 	u64			nr_wakeups_passive;
 	u64			nr_wakeups_idle;
+
+	u64			nr_acquired_spinlock;
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 70c7e0b..792b0f7 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -426,6 +426,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.nr_wakeups_affine_attempts);
 	P(se.nr_wakeups_passive);
 	P(se.nr_wakeups_idle);
+	P(se.nr_acquired_spinlock);
 
 	{
 		u64 avg_atom, avg_per_cpu;
@@ -500,6 +501,7 @@ void proc_sched_set_task(struct task_struct *p)
 	p->se.nr_wakeups_affine_attempts	= 0;
 	p->se.nr_wakeups_passive		= 0;
 	p->se.nr_wakeups_idle			= 0;
+	p->se.nr_acquired_spinlock		= 0;
 	p->sched_info.bkl_count			= 0;
 #endif
 	p->se.sum_exec_runtime			= 0;
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 7932653..92c1ed6 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -181,6 +181,10 @@ void __lockfunc _spin_lock(spinlock_t *lock)
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+
+#ifdef CONFIG_SCHEDSTATS
+	current->se.nr_acquired_spinlock++;
+#endif
 }
 
 EXPORT_SYMBOL(_spin_lock);

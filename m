Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZGWTVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZGWTVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZGWTVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:21:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZGWTVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:11 -0400
Message-Id: <20090723191957.713275352@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:54 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Arjan van de Ven <arjan@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/13] sched: Provide iowait counters
Content-Disposition: inline; filename=arjan-sched-Provide_iowait_counters.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For counting how long an application has been waiting for (disk) IO,
there currently is only the HZ sample driven information available, while
for all other counters in this class, a high resolution version is
available via CONFIG_SCHEDSTATS.

In order to make an improved bootchart tool possible, we also need
a higher resolution version of the iowait time.

This patch below adds this scheduler statistic to the kernel.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4A64B813.1080506@linux.intel.com>
---
 include/linux/sched.h |    3 +++
 kernel/sched.c        |    4 ++++
 kernel/sched_debug.c  |    4 ++++
 kernel/sched_fair.c   |    5 +++++
 4 files changed, 16 insertions(+)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1112,6 +1112,8 @@ struct sched_entity {
 	u64			wait_max;
 	u64			wait_count;
 	u64			wait_sum;
+	u64			iowait_count;
+	u64			iowait_sum;
 
 	u64			sleep_start;
 	u64			sleep_max;
@@ -1231,6 +1233,7 @@ struct task_struct {
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
+	unsigned in_iowait:1;
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6703,7 +6703,9 @@ void __sched io_schedule(void)
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	current->in_iowait = 1;
 	schedule();
+	current->in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 }
@@ -6716,7 +6718,9 @@ long __sched io_schedule_timeout(long ti
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
+	current->in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 	return ret;
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -409,6 +409,8 @@ void proc_sched_show_task(struct task_st
 	PN(se.wait_max);
 	PN(se.wait_sum);
 	P(se.wait_count);
+	PN(se.iowait_sum);
+	P(se.iowait_count);
 	P(sched_info.bkl_count);
 	P(se.nr_migrations);
 	P(se.nr_migrations_cold);
@@ -479,6 +481,8 @@ void proc_sched_set_task(struct task_str
 	p->se.wait_max				= 0;
 	p->se.wait_sum				= 0;
 	p->se.wait_count			= 0;
+	p->se.iowait_sum			= 0;
+	p->se.iowait_count			= 0;
 	p->se.sleep_max				= 0;
 	p->se.sum_sleep_runtime			= 0;
 	p->se.block_max				= 0;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -639,6 +639,11 @@ static void enqueue_sleeper(struct cfs_r
 		se->block_start = 0;
 		se->sum_sleep_runtime += delta;
 
+		if (tsk->in_iowait) {
+			se->iowait_sum += delta;
+			se->iowait_count++;
+		}
+
 		/*
 		 * Blocking time is in units of nanosecs, so shift by 20 to
 		 * get a milliseconds-range estimation of the amount of

-- 


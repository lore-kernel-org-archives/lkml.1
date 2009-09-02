Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZIBHB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZIBHB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 03:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZIBHBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 03:01:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:59163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbZIBHBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 03:01:24 -0400
Date: Wed, 2 Sep 2009 07:00:46 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A64B813.1080506@linux.intel.com>
References: <4A64B813.1080506@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Provide iowait counters
Message-ID: <tip-8f0dfc34e9b323a028c2ec41abb7e9de477b7a94@git.kernel.org>
Git-Commit-ID: 8f0dfc34e9b323a028c2ec41abb7e9de477b7a94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 07:00:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f0dfc34e9b323a028c2ec41abb7e9de477b7a94
Gitweb:     http://git.kernel.org/tip/8f0dfc34e9b323a028c2ec41abb7e9de477b7a94
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Mon, 20 Jul 2009 11:26:58 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Sep 2009 08:44:08 +0200

sched: Provide iowait counters

For counting how long an application has been waiting for
(disk) IO, there currently is only the HZ sample driven
information available, while for all other counters in this
class, a high resolution version is available via
CONFIG_SCHEDSTATS.

In order to make an improved bootchart tool possible, we also
need a higher resolution version of the iowait time.

This patch below adds this scheduler statistic to the kernel.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4A64B813.1080506@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    4 ++++
 kernel/sched.c        |    4 ++++
 kernel/sched_debug.c  |    4 ++++
 kernel/sched_fair.c   |    5 +++++
 4 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e209ae0..9c96ef2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1111,6 +1111,8 @@ struct sched_entity {
 	u64			wait_max;
 	u64			wait_count;
 	u64			wait_sum;
+	u64			iowait_count;
+	u64			iowait_sum;
 
 	u64			sleep_start;
 	u64			sleep_max;
@@ -1231,6 +1233,8 @@ struct task_struct {
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
+	unsigned in_iowait:1;
+
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
diff --git a/kernel/sched.c b/kernel/sched.c
index 6244d24..38d05a8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6754,7 +6754,9 @@ void __sched io_schedule(void)
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	current->in_iowait = 1;
 	schedule();
+	current->in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 }
@@ -6767,7 +6769,9 @@ long __sched io_schedule_timeout(long timeout)
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
+	current->in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 	return ret;
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 70c7e0b..5ddbd08 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -409,6 +409,8 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.wait_max);
 	PN(se.wait_sum);
 	P(se.wait_count);
+	PN(se.iowait_sum);
+	P(se.iowait_count);
 	P(sched_info.bkl_count);
 	P(se.nr_migrations);
 	P(se.nr_migrations_cold);
@@ -479,6 +481,8 @@ void proc_sched_set_task(struct task_struct *p)
 	p->se.wait_max				= 0;
 	p->se.wait_sum				= 0;
 	p->se.wait_count			= 0;
+	p->se.iowait_sum			= 0;
+	p->se.iowait_count			= 0;
 	p->se.sleep_max				= 0;
 	p->se.sum_sleep_runtime			= 0;
 	p->se.block_max				= 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 342000b..471fa28 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -652,6 +652,11 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		se->sum_sleep_runtime += delta;
 
 		if (tsk) {
+			if (tsk->in_iowait) {
+				se->iowait_sum += delta;
+				se->iowait_count++;
+			}
+
 			/*
 			 * Blocking time is in units of nanosecs, so shift by
 			 * 20 to get a milliseconds-range estimation of the

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbZGTSbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbZGTSbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZGTSbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:31:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:41066 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbZGTSbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:31:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,235,1246863600"; 
   d="scan'208,223";a="431760273"
Message-ID: <4A64B813.1080506@linux.intel.com>
Date: Mon, 20 Jul 2009 11:31:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: [PATCH] sched: Provide iowait counters
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From cb80fe74bab69449c828d7433fbbea807816eee8 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 20 Jul 2009 11:26:58 -0700
Subject: [PATCH] sched: Provide iowait counters

For counting how long an application has been waiting for (disk) IO,
there currently is only the HZ sample driven information available, while
for all other counters in this class, a high resolution version is
available via CONFIG_SCHEDSTATS.

In order to make an improved bootchart tool possible, we also need
a higher resolution version of the iowait time.

This patch below adds this scheduler statistic to the kernel.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
  include/linux/sched.h |    3 +++
  kernel/sched.c        |    4 ++++
  kernel/sched_debug.c  |    4 ++++
  kernel/sched_fair.c   |    5 +++++
  4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 16a982e..2b8f1f5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1110,6 +1110,8 @@ struct sched_entity {
  	u64			wait_max;
  	u64			wait_count;
  	u64			wait_sum;
+	u64			iowait_count;
+	u64			iowait_sum;

  	u64			sleep_start;
  	u64			sleep_max;
@@ -1229,6 +1231,7 @@ struct task_struct {
  	unsigned did_exec:1;
  	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
  				 * execve */
+	unsigned in_iowait:1;
  	pid_t pid;
  	pid_t tgid;

diff --git a/kernel/sched.c b/kernel/sched.c
index 98972d3..caa1974 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6662,7 +6662,9 @@ void __sched io_schedule(void)

  	delayacct_blkio_start();
  	atomic_inc(&rq->nr_iowait);
+	current->in_iowait = 1;
  	schedule();
+	current->in_iowait = 0;
  	atomic_dec(&rq->nr_iowait);
  	delayacct_blkio_end();
  }
@@ -6675,7 +6677,9 @@ long __sched io_schedule_timeout(long timeout)

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
index 7c248dc..3db22e6 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -633,6 +633,11 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
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
1.6.0.6


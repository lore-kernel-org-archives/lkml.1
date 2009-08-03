Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZHCNW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZHCNW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZHCNWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:22:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:51940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbZHCNWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:22:24 -0400
Date: Mon, 3 Aug 2009 13:21:50 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A64B813.1080506@linux.intel.com>
References: <4A64B813.1080506@linux.intel.com>
Subject: [tip:sched/core] sched: Provide iowait counters
Message-ID: <tip-c4bdb9728146c75ac78a4a98892cd216a00aef8f@git.kernel.org>
Git-Commit-ID: c4bdb9728146c75ac78a4a98892cd216a00aef8f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 13:21:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4bdb9728146c75ac78a4a98892cd216a00aef8f
Gitweb:     http://git.kernel.org/tip/c4bdb9728146c75ac78a4a98892cd216a00aef8f
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Mon, 20 Jul 2009 11:26:58 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 3 Aug 2009 14:35:36 +0200

sched: Provide iowait counters

For counting how long an application has been waiting for
(disk) IO, there currently is only the HZ sample driven
information available, while for all other counters in this
class, a high resolution version is available via
CONFIG_SCHEDSTATS.

In order to make an improved bootchart tool possible, we also
need a higher resolution version of the iowait time.

This patch below adds this scheduler statistic to the
kernel - the next patch will extend perfcounters to
make use of it.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4A64B813.1080506@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    4 ++++
 kernel/sched.c        |    4 ++++
 kernel/sched_debug.c  |    2 ++
 kernel/sched_fair.c   |    5 +++++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 195d72d..9da9506 100644
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
@@ -1230,6 +1232,8 @@ struct task_struct {
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
+	unsigned in_iowait:1;
+
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
diff --git a/kernel/sched.c b/kernel/sched.c
index 7f83be3..668bfbe 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6748,7 +6748,9 @@ void __sched io_schedule(void)
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	current->in_iowait = 1;
 	schedule();
+	current->in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 }
@@ -6761,7 +6763,9 @@ long __sched io_schedule_timeout(long timeout)
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
+	current->in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 	return ret;
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 70c7e0b..7d3f0a4 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -479,6 +479,8 @@ void proc_sched_set_task(struct task_struct *p)
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

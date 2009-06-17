Return-Path: <linux-kernel-owner+w=401wt.eu-S1764063AbZFQNVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764063AbZFQNVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZFQNU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:20:57 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60734 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZFQNU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:20:56 -0400
Date: Wed, 17 Jun 2009 22:20:55 +0900 (JST)
Message-Id: <20090617.222055.374768827975756908.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] Hiding runqueues from direct refer at source code level
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,

I found a trivial problem in sched.c and sched_debug.c .
There are some points which refer the per-cpu value "runqueues" directly.
sched.c provides nice abstraction, such as cpu_rq() and this_rq(),
so we should use these macros when looking runqueues.

I fixed these points and made patch.
If there is a reason to refer runqueues directly, sorry,
this patch doesn't make sense.
But I think that someday the abstraction will help someone.

one-line description: Hiding runqueues from direct refer at source code level

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

diff --git a/kernel/sched.c b/kernel/sched.c
index 8ec9d13..60dc315 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6625,7 +6625,7 @@ EXPORT_SYMBOL(yield);
  */
 void __sched io_schedule(void)
 {
-	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	struct rq *rq = this_rq();
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
@@ -6637,7 +6637,7 @@ EXPORT_SYMBOL(io_schedule);
 
 long __sched io_schedule_timeout(long timeout)
 {
-	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	struct rq *rq = this_rq();
 	long ret;
 
 	delayacct_blkio_start();
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 467ca72..70c7e0b 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -162,7 +162,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
 		spread, rq0_min_vruntime, spread0;
-	struct rq *rq = &per_cpu(runqueues, cpu);
+	struct rq *rq = cpu_rq(cpu);
 	struct sched_entity *last;
 	unsigned long flags;
 
@@ -191,7 +191,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	if (last)
 		max_vruntime = last->vruntime;
 	min_vruntime = cfs_rq->min_vruntime;
-	rq0_min_vruntime = per_cpu(runqueues, 0).cfs.min_vruntime;
+	rq0_min_vruntime = cpu_rq(0)->cfs.min_vruntime;
 	spin_unlock_irqrestore(&rq->lock, flags);
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
 			SPLIT_NS(MIN_vruntime));
@@ -248,7 +248,7 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 
 static void print_cpu(struct seq_file *m, int cpu)
 {
-	struct rq *rq = &per_cpu(runqueues, cpu);
+	struct rq *rq = cpu_rq(cpu);
 
 #ifdef CONFIG_X86
 	{

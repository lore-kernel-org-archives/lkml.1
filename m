Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbZFQPE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbZFQPE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZFQPET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:04:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:48889 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbZFQPES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:04:18 -0400
Date: Wed, 17 Jun 2009 15:03:50 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090617.222055.374768827975756908.mitake@dcl.info.waseda.ac.jp>
References: <20090617.222055.374768827975756908.mitake@dcl.info.waseda.ac.jp>
Subject: [tip:sched/urgent] sched: Hide runqueues from direct refer at source code level
Message-ID: <tip-d11ad9b3631b942b0d2e5b754a6c62158efb799f@git.kernel.org>
Git-Commit-ID: d11ad9b3631b942b0d2e5b754a6c62158efb799f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 15:03:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d11ad9b3631b942b0d2e5b754a6c62158efb799f
Gitweb:     http://git.kernel.org/tip/d11ad9b3631b942b0d2e5b754a6c62158efb799f
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Wed, 17 Jun 2009 22:20:55 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 17:02:38 +0200

sched: Hide runqueues from direct refer at source code level

There are some points which refer the per-cpu value "runqueues" directly.
sched.c provides nice abstraction, such as cpu_rq() and this_rq(),
so we should use these macros when looking runqueues.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
LKML-Reference: <20090617.222055.374768827975756908.mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c       |    4 ++--
 kernel/sched_debug.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0056795..6240309 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6630,7 +6630,7 @@ EXPORT_SYMBOL(yield);
  */
 void __sched io_schedule(void)
 {
-	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	struct rq *rq = this_rq();
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
@@ -6642,7 +6642,7 @@ EXPORT_SYMBOL(io_schedule);
 
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

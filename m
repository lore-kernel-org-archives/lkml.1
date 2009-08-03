Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbZHCOjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbZHCOjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156AbZHCOjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:39:14 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:3990 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151AbZHCOjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:39:13 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:sched/core] sched: Add wait, sleep and iowait accounting
 tracepoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, arjan@linux.intel.com,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20090803132433.GA7118@elte.hu>
References: <tip-5f3e60fb2a0e05cdaf9b59acb0bb249bb1e96362@git.kernel.org>
	 <20090803132433.GA7118@elte.hu>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 16:24:49 +0200
Message-Id: <1249309489.7924.99.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 15:24 +0200, Ingo Molnar wrote:
> * tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Commit-ID:  5f3e60fb2a0e05cdaf9b59acb0bb249bb1e96362
> > Gitweb:     http://git.kernel.org/tip/5f3e60fb2a0e05cdaf9b59acb0bb249bb1e96362
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Thu, 23 Jul 2009 20:13:26 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 3 Aug 2009 14:35:37 +0200
> 
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -546,6 +546,11 @@ update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
> >  	schedstat_set(se->wait_sum, se->wait_sum +
> >  			rq_of(cfs_rq)->clock - se->wait_start);
> >  	schedstat_set(se->wait_start, 0);
> > +
> > +	if (entity_is_task(se)) {
> > +		trace_sched_stat_wait(task_of(se),
> > +			rq_of(cfs_rq)->clock - se->wait_start);
> > +	}
> 
> FYI, this doesnt build with !SCHEDSTATS. I suspect we shold maintain 
> se->wait_start unconditionally.

Also noticed that we have this TASK_INTERRUPTIBLE vs
TASK_UNINTERRUPTIBLE split in sleep vs block which I overlooked the
other day.

Since all the other trace_sched_stat tracepoints are under
CONFIG_SCHEDSTAT I fixed the above error by adding ifdefs.

This probably wants folding back into the original patch.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/trace/events/sched.h |   36 ++++++++++++++++++++++++++++++++----
 kernel/sched_fair.c          |    3 +++
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index a4c369e..c201b51 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -376,8 +376,7 @@ TRACE_EVENT(sched_stat_wait,
 );
 
 /*
- * Tracepoint for accounting sleep time (time the task is not runnable,
- * including iowait, see below).
+ * Tracepoint for accounting sleep time, TASK_INTERRUPTIBLE
  */
 TRACE_EVENT(sched_stat_sleep,
 
@@ -406,8 +405,37 @@ TRACE_EVENT(sched_stat_sleep,
 );
 
 /*
- * Tracepoint for accounting iowait time (time the task is not runnable
- * due to waiting on IO to complete).
+ * Tracepoint for accounting block time, TASK_UNINTERRUPTIBLE
+ * (including iowait).
+ */
+TRACE_EVENT(sched_stat_block,
+
+	TP_PROTO(struct task_struct *tsk, u64 delay),
+
+	TP_ARGS(tsk, delay),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	delay			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid	= tsk->pid;
+		__entry->delay	= delay;
+	)
+	TP_perf_assign(
+		__perf_count(delay);
+	),
+
+	TP_printk("task: %s:%d block: %Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->delay)
+);
+
+/*
+ * Tracepoint for accounting iowait time, TASK_UNINTERRUPTIBLE
  */
 TRACE_EVENT(sched_stat_iowait,
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0e4d6c5..abc8e6c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -540,6 +540,7 @@ static void update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static void
 update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
+#ifdef CONFIG_SCHEDSTATS
 	schedstat_set(se->wait_max, max(se->wait_max,
 			rq_of(cfs_rq)->clock - se->wait_start));
 	schedstat_set(se->wait_count, se->wait_count + 1);
@@ -551,6 +552,7 @@ update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		trace_sched_stat_wait(task_of(se),
 			rq_of(cfs_rq)->clock - se->wait_start);
 	}
+#endif
 }
 
 static inline void
@@ -664,6 +666,7 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 				se->iowait_count++;
 				trace_sched_stat_iowait(tsk, delta);
 			}
+			trace_sched_stat_block(tsk, delta);
 
 			/*
 			 * Blocking time is in units of nanosecs, so shift by



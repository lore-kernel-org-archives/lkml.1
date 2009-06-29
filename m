Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbZF2XqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbZF2XqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZF2XqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:46:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34496 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZF2XqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:46:05 -0400
Date: Tue, 30 Jun 2009 01:46:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: [patch] perf_counter: Add enable-on-exec attribute
Message-ID: <20090629234601.GA5869@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy> <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy> <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu> <20090627064404.GA19368@elte.hu> <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vince@deater.net> wrote:

>> If the 5 thousand cycles measurement overhead _still_ matters to 
>> you under such circumstances then by all means please submit the 
>> patches to improve it. Despite your claims this is totally 
>> fixable with the current perfcounters design, Peter outlined the 
>> steps of how to solve it, you can utilize ptrace if you want to.
>
> Is it really "totally" fixible?  I don't just mean getting the 
> overhead from ~3000 down to ~100, I mean down to zero.

Yes, it's truly very easy to get exactly the same output as pfmon, 
for the 'million.s' test app you posted:

  titan:~> perf stat -e 0:1:u ./million

   Performance counter stats for './million':

          1000001  instructions            

      0.000489736  seconds time elapsed

See the small patch below.

( Note that this approach does not use ptrace, hence it can be used
  to measure debuggers too. ptrace attach has the limitation of
  being exclusive - no task can be attached to twice. perfmon used
  ptrace attach, which limited its capabilities unreasonably. )

The question was really not whether we can do it - but whether we 
want to do it. I have no strong feelings either way - because as i 
told you in my first mail, all the other noise sources in the system 
dominate the metrics far more than this very small constant startup 
offset.

And the thing is, as a perfmon contributor i assume you have 
experience in these matters. Had you taken a serious, unbiased look 
at perfcounters, and had this problem truly bothered you personally, 
you could have come up with a similar patch yourself as well, while 
only spending a fraction of the energies you are putting into these 
emails. Instead you ignored our technical arguments, you refused to 
touch the code and you went on rambling against how perfcounters 
supposedly cannot solve this problem. Not very productive IMO.

	Ingo

---------------->
Subject: perf_counter: Add enable-on-exec attribute
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Jun 29 22:05:11 CEST 2009

Add another attribute variant: attr.enable_on_exec.

The purpose is to allow the auto-enabling of such counters
on exec(), to measure exec()-ed workloads precisely, from
the first to the last instruction.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/exec.c                    |    3 +--
 include/linux/perf_counter.h |    5 ++++-
 kernel/perf_counter.c        |   39 ++++++++++++++++++++++++++++++++++++---
 tools/perf/builtin-stat.c    |    5 +++--
 4 files changed, 44 insertions(+), 8 deletions(-)

Index: linux/fs/exec.c
===================================================================
--- linux.orig/fs/exec.c
+++ linux/fs/exec.c
@@ -996,8 +996,7 @@ int flush_old_exec(struct linux_binprm *
 	 * Flush performance counters when crossing a
 	 * security domain:
 	 */
-	if (!get_dumpable(current->mm))
-		perf_counter_exit_task(current);
+	perf_counter_exec(current);
 
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
Index: linux/include/linux/perf_counter.h
===================================================================
--- linux.orig/include/linux/perf_counter.h
+++ linux/include/linux/perf_counter.h
@@ -179,8 +179,9 @@ struct perf_counter_attr {
 				comm	       :  1, /* include comm data     */
 				freq           :  1, /* use freq, not period  */
 				inherit_stat   :  1, /* per task counts       */
+				enable_on_exec :  1, /* enable on exec        */
 
-				__reserved_1   : 52;
+				__reserved_1   : 51;
 
 	__u32			wakeup_events;	/* wakeup every n events */
 	__u32			__reserved_2;
@@ -712,6 +713,7 @@ static inline void perf_counter_mmap(str
 
 extern void perf_counter_comm(struct task_struct *tsk);
 extern void perf_counter_fork(struct task_struct *tsk);
+extern void perf_counter_exec(struct task_struct *tsk);
 
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
@@ -752,6 +754,7 @@ perf_swcounter_event(u32 event, u64 nr, 
 static inline void perf_counter_mmap(struct vm_area_struct *vma)	{ }
 static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_fork(struct task_struct *tsk)		{ }
+static inline void perf_counter_exec(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
 #endif
 
Index: linux/kernel/perf_counter.c
===================================================================
--- linux.orig/kernel/perf_counter.c
+++ linux/kernel/perf_counter.c
@@ -903,6 +903,9 @@ static void perf_counter_enable(struct p
 	struct perf_counter_context *ctx = counter->ctx;
 	struct task_struct *task = ctx->task;
 
+	if (counter->attr.enable_on_exec)
+		return;
+
 	if (!task) {
 		/*
 		 * Enable the counter on the cpu that it's on
@@ -2856,6 +2859,32 @@ void perf_counter_fork(struct task_struc
 	perf_counter_fork_event(&fork_event);
 }
 
+void perf_counter_exec(struct task_struct *task)
+{
+	struct perf_counter_context *ctx;
+	struct perf_counter *counter;
+
+	if (!get_dumpable(task->mm)) {
+		perf_counter_exit_task(task);
+		return;
+	}
+
+	if (!task->perf_counter_ctxp)
+		return;
+
+	rcu_read_lock();
+	ctx = task->perf_counter_ctxp;
+	if (ctx) {
+		list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+			if (counter->attr.enable_on_exec) {
+				counter->attr.enable_on_exec = 0;
+				__perf_counter_enable(counter);
+			}
+		}
+	}
+	rcu_read_unlock();
+}
+
 /*
  * comm tracking
  */
@@ -4064,10 +4093,14 @@ inherit_counter(struct perf_counter *par
 	 * not its attr.disabled bit.  We hold the parent's mutex,
 	 * so we won't race with perf_counter_{en, dis}able_family.
 	 */
-	if (parent_counter->state >= PERF_COUNTER_STATE_INACTIVE)
-		child_counter->state = PERF_COUNTER_STATE_INACTIVE;
-	else
+	if (parent_counter->state >= PERF_COUNTER_STATE_INACTIVE) {
+		if (child_counter->attr.enable_on_exec)
+			child_counter->state = PERF_COUNTER_STATE_OFF;
+		else
+			child_counter->state = PERF_COUNTER_STATE_INACTIVE;
+	} else {
 		child_counter->state = PERF_COUNTER_STATE_OFF;
+	}
 
 	if (parent_counter->attr.freq)
 		child_counter->hw.sample_period = parent_counter->hw.sample_period;
Index: linux/tools/perf/builtin-stat.c
===================================================================
--- linux.orig/tools/perf/builtin-stat.c
+++ linux/tools/perf/builtin-stat.c
@@ -116,8 +116,9 @@ static void create_perf_stat_counter(int
 					fd[cpu][counter], strerror(errno));
 		}
 	} else {
-		attr->inherit	= inherit;
-		attr->disabled	= 1;
+		attr->inherit		= inherit;
+		attr->disabled		= 1;
+		attr->enable_on_exec	= 1;
 
 		fd[0][counter] = sys_perf_counter_open(attr, pid, -1, -1, 0);
 		if (fd[0][counter] < 0 && verbose)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYKJQER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYKJQER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYKJQEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:04:01 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:52602 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbYKJQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:04:00 -0500
Date: Mon, 10 Nov 2008 21:34:09 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH -v2] sched: Include group statistics in
	/proc/sched_debug
Message-ID: <20081110160409.GB3933@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20081110092350.GA3679@in.ibm.com> <1226309407.2697.4034.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226309407.2697.4034.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 10:30:07AM +0100, Peter Zijlstra wrote:
> On Mon, 2008-11-10 at 14:53 +0530, Bharata B Rao wrote:
> 
> > An extract of /proc/sched_debug showing group stats obtained from
> > this patch:
> > 
> > group[1]:/3/a/1
> >   .se->exec_start                : 256484.781577
> >   .se->vruntime                  : 12868.176994
> >   .se->sum_exec_runtime          : 3243.669709
> >   .se->wait_start                : 0.000000
> >   .se->sleep_start               : 0.000000
> >   .se->block_start               : 0.000000
> >   .se->sleep_max                 : 0.000000
> >   .se->block_max                 : 0.000000
> >   .se->exec_max                  : 1.002095
> >   .se->slice_max                 : 13.997073
> >   .se->wait_max                  : 67.978322
> >   .se->wait_sum                  : 7141.676906
> >   .se->wait_count                : 203
> >   .se->load.weight               : 255
> 
> Why not simply add them to the cfs_rq[n]:/path sections we already have?

Makes sense. Here is the updated patch which puts group statistics
under cfs_rq[n]:/path section as you suggest.

Include group statistics in /proc/sched_debug.

Since the statistics of a group entity isn't exported directly from the
kernel, it becomes difficult to obtain some of the group statistics.
For example, the current method to obtain exec time of a group entity
is not always accurate. One has to read the exec times of all
the tasks(/proc/<pid>/sched) in the group and add them. This method
fails (or becomes difficult) if we want to collect stats of a group over
a duration where tasks get created and terminated.

This patch makes it easier to obtain group stats by directly including
them in /proc/sched_debug. Stats like group exec time would help user
programs (like LTP) to accurately measure the group fairness.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
 kernel/sched_debug.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -53,6 +53,40 @@ static unsigned long nsec_low(unsigned l
 
 #define SPLIT_NS(x) nsec_high(x), nsec_low(x)
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void print_cfs_group_stats(struct seq_file *m, int cpu,
+		struct task_group *tg)
+{
+	struct sched_entity *se = tg->se[cpu];
+	if (!se)
+		return;
+
+#define P(F) \
+	SEQ_printf(m, "  .%-30s: %lld\n", #F, (long long)F)
+#define PN(F) \
+	SEQ_printf(m, "  .%-30s: %lld.%06ld\n", #F, SPLIT_NS((long long)F))
+
+	PN(se->exec_start);
+	PN(se->vruntime);
+	PN(se->sum_exec_runtime);
+#ifdef CONFIG_SCHEDSTATS
+	PN(se->wait_start);
+	PN(se->sleep_start);
+	PN(se->block_start);
+	PN(se->sleep_max);
+	PN(se->block_max);
+	PN(se->exec_max);
+	PN(se->slice_max);
+	PN(se->wait_max);
+	PN(se->wait_sum);
+	P(se->wait_count);
+#endif
+	P(se->load.weight);
+#undef PN
+#undef P
+}
+#endif
+
 static void
 print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 {
@@ -186,6 +220,7 @@ void print_cfs_rq(struct seq_file *m, in
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
 #endif
+	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
 
@@ -271,7 +306,7 @@ static int sched_debug_show(struct seq_f
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.07, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.08, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);

--
An example output of group stats from /proc/sched_debug:

cfs_rq[3]:/3/a/1
  .exec_clock                    : 89.598007
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 256300.970506
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -25373.372248
  .nr_running                    : 0
  .load                          : 0
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 4474
  .sched_switch                  : 0
  .sched_count                   : 40507
  .sched_goidle                  : 12686
  .ttwu_count                    : 15114
  .ttwu_local                    : 11950
  .bkl_count                     : 67
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 113676.727170
  .se->vruntime                  : 1592.612714
  .se->sum_exec_runtime          : 89.598007
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 1.000282
  .se->slice_max                 : 1.999750
  .se->wait_max                  : 54.981093
  .se->wait_sum                  : 217.610521
  .se->wait_count                : 50
  .se->load.weight               : 2

Regards,
Bharata.

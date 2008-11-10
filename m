Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbYKJJXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbYKJJXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYKJJXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:23:34 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51590 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYKJJXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:23:32 -0500
Date: Mon, 10 Nov 2008 14:53:50 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: [PATCH] sched: Include group statistics in /proc/sched_debug
Message-ID: <20081110092350.GA3679@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 kernel/sched_debug.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -53,6 +53,70 @@ static unsigned long nsec_low(unsigned l
 
 #define SPLIT_NS(x) nsec_high(x), nsec_low(x)
 
+#ifdef CONFIG_GROUP_SCHED
+
+static void print_group_stats(struct seq_file *m, struct task_group *tg,
+	int cpu)
+{
+	struct sched_entity *se = tg->se[cpu];
+
+#if defined(CONFIG_CGROUP_SCHED)
+	char path[128] = "";
+	struct cgroup *cgroup = NULL;
+
+	if (tg)
+		cgroup = tg->css.cgroup;
+
+	if (cgroup)
+		cgroup_path(cgroup, path, sizeof(path));
+
+	SEQ_printf(m, "\ngroup[%d]:%s\n", cpu, path);
+#else
+	SEQ_printf(m, "\ngroup[%d]:\n", cpu);
+#endif
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
+
+static void print_tg_stats(struct seq_file *m, int cpu)
+{
+	struct task_group *tg;
+
+	rcu_read_lock();
+	list_for_each_entry(tg, &task_groups, list) {
+		if (tg->se[cpu])
+			print_group_stats(m, tg, cpu);
+	}
+	rcu_read_unlock();
+}
+#else
+static void print_tg_stats(struct seq_file *m, int cpu)
+{
+	return;
+}
+#endif
+
 static void
 print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 {
@@ -264,6 +328,7 @@ static void print_cpu(struct seq_file *m
 	print_rt_stats(m, cpu);
 
 	print_rq(m, rq, cpu);
+	print_tg_stats(m, cpu);
 }
 
 static int sched_debug_show(struct seq_file *m, void *v)
@@ -271,7 +336,7 @@ static int sched_debug_show(struct seq_f
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.07, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.08, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
--

An extract of /proc/sched_debug showing group stats obtained from
this patch:

group[1]:/3/a/1
  .se->exec_start                : 256484.781577
  .se->vruntime                  : 12868.176994
  .se->sum_exec_runtime          : 3243.669709
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 1.002095
  .se->slice_max                 : 13.997073
  .se->wait_max                  : 67.978322
  .se->wait_sum                  : 7141.676906
  .se->wait_count                : 203
  .se->load.weight               : 255

group[1]:/3/a
  .se->exec_start                : 256484.781577
  .se->vruntime                  : 18649.700858
  .se->sum_exec_runtime          : 3302.827997
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 1.009411
  .se->slice_max                 : 7.015594
  .se->wait_max                  : 67.978322
  .se->wait_sum                  : 7082.536617
  .se->wait_count                : 214
  .se->load.weight               : 255

group[1]:/3
  .se->exec_start                : 256484.781577
  .se->vruntime                  : 224861.311011
  .se->sum_exec_runtime          : 3302.827997
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 1.002095
  .se->slice_max                 : 19.007546
  .se->wait_max                  : 67.978322
  .se->wait_sum                  : 7082.536617
  .se->wait_count                : 214
  .se->load.weight               : 24

Regards,
Bharata.

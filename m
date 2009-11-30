Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbZK3LRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbZK3LRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZK3LQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:16:48 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:53785 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZK3LQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:16:43 -0500
From: ehrhardt@linux.vnet.ibm.com
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: ehrhardt@linux.vnet.ibm.com, Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       schwidefsky@de.ibm.com
Subject: [PATCH 2/3] sched: make tunable scaling style configurable
Date: Mon, 30 Nov 2009 12:16:47 +0100
Message-Id: <1259579808-11357-3-git-send-email-ehrhardt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259579808-11357-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
References: <1259579808-11357-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

As scaling now takes place on all kind of cpu add/remove events a user that
configures values via proc should be able to configure if his set values are
still rescaled or kept whatever happens.

As the comments state that log2 was just a second guess that worked the
interface is not just designed for on/off, but to choose a scaling type.
Currently this allows none, log and linear, but more important it allwos us
to keep the interface even if someone has an even better idea how to scale
the values.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 include/linux/sched.h |   10 +++++++++-
 kernel/sched.c        |   15 +++++++++++++++
 kernel/sched_debug.c  |   10 ++++++++++
 kernel/sched_fair.c   |   13 +++++++++++++
 kernel/sysctl.c       |   14 ++++++++++++++
 5 files changed, 61 insertions(+), 1 deletion(-)

[diff]
Index: linux-2.6-git-schedrecalc/include/linux/sched.h
===================================================================
--- linux-2.6-git-schedrecalc.orig/include/linux/sched.h
+++ linux-2.6-git-schedrecalc/include/linux/sched.h
@@ -1899,6 +1899,14 @@ extern unsigned int sysctl_sched_wakeup_
 extern unsigned int sysctl_sched_shares_ratelimit;
 extern unsigned int sysctl_sched_shares_thresh;
 extern unsigned int sysctl_sched_child_runs_first;
+
+enum sched_tunable_scaling {
+	SCHED_TUNABLESCALING_NONE,
+	SCHED_TUNABLESCALING_LOG,
+	SCHED_TUNABLESCALING_LINEAR,
+	SCHED_TUNABLESCALING_END,
+};
+extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
@@ -1906,7 +1914,7 @@ extern unsigned int sysctl_sched_nr_migr
 extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
 
-int sched_nr_latency_handler(struct ctl_table *table, int write,
+int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
 		loff_t *ppos);
 #endif
Index: linux-2.6-git-schedrecalc/kernel/sched.c
===================================================================
--- linux-2.6-git-schedrecalc.orig/kernel/sched.c
+++ linux-2.6-git-schedrecalc/kernel/sched.c
@@ -7010,6 +7010,21 @@ static void update_sysctl(void)
 	unsigned int cpus = max(num_online_cpus(), 8U);
 	unsigned int factor = 1 + ilog2(cpus);
 
+	unsigned int factor;
+
+	switch (sysctl_sched_tunable_scaling) {
+	case SCHED_TUNABLESCALING_NONE:
+		factor = 1;
+		break;
+	case SCHED_TUNABLESCALING_LINEAR:
+		factor = cpus;
+		break;
+	case SCHED_TUNABLESCALING_LOG:
+	default:
+		factor = 1 + ilog2(cpus);
+		break;
+	}
+
 #define SET_SYSCTL(name) \
 	(sysctl_##name = (factor) * normalized_sysctl_##name)
 	SET_SYSCTL(sched_min_granularity);
Index: linux-2.6-git-schedrecalc/kernel/sched_fair.c
===================================================================
--- linux-2.6-git-schedrecalc.orig/kernel/sched_fair.c
+++ linux-2.6-git-schedrecalc/kernel/sched_fair.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/latencytop.h>
+#include <linux/sched.h>
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
@@ -38,6 +39,18 @@ unsigned int sysctl_sched_latency = 5000
 unsigned int normalized_sysctl_sched_latency = 5000000ULL;
 
 /*
+ * The initial- and re-scaling of tunables is configurable
+ * (default SCHED_TUNABLESCALING_LOG = *(1+ilog(ncpus))
+ *
+ * Options are:
+ * SCHED_TUNABLESCALING_NONE - unscaled, always *1
+ * SCHED_TUNABLESCALING_LOG - scaled logarithmical, *1+ilog(ncpus)
+ * SCHED_TUNABLESCALING_LINEAR - scaled linear, *ncpus
+ */
+enum sched_tunable_scaling sysctl_sched_tunable_scaling
+	= SCHED_TUNABLESCALING_LOG;
+
+/*
  * Minimal preemption granularity for CPU-bound tasks:
  * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
Index: linux-2.6-git-schedrecalc/kernel/sysctl.c
===================================================================
--- linux-2.6-git-schedrecalc.orig/kernel/sysctl.c
+++ linux-2.6-git-schedrecalc/kernel/sysctl.c
@@ -248,6 +248,8 @@ static int min_sched_granularity_ns = 10
 static int max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 static int min_wakeup_granularity_ns;			/* 0 usecs */
 static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
+static int min_sched_tunable_scaling = SCHED_TUNABLESCALING_NONE;
+static int max_sched_tunable_scaling = SCHED_TUNABLESCALING_END-1;
 #endif
 
 static struct ctl_table kern_table[] = {
@@ -303,6 +305,18 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_tunable_scaling",
+		.data		= &sysctl_sched_tunable_scaling,
+		.maxlen		= sizeof(enum sched_tunable_scaling),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_sched_tunable_scaling,
+		.extra2		= &max_sched_tunable_scaling,
+	},
+
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_shares_thresh",
 		.data		= &sysctl_sched_shares_thresh,
 		.maxlen		= sizeof(unsigned int),
Index: linux-2.6-git-schedrecalc/kernel/sched_debug.c
===================================================================
--- linux-2.6-git-schedrecalc.orig/kernel/sched_debug.c
+++ linux-2.6-git-schedrecalc/kernel/sched_debug.c
@@ -305,6 +305,12 @@ static void print_cpu(struct seq_file *m
 	print_rq(m, rq, cpu);
 }
 
+static const char *sched_tunable_scaling_names[] = {
+	"none",
+	"logaritmic",
+	"linear"
+};
+
 static int sched_debug_show(struct seq_file *m, void *v)
 {
 	u64 now = ktime_to_ns(ktime_get());
@@ -330,6 +336,10 @@ static int sched_debug_show(struct seq_f
 #undef PN
 #undef P
 
+	SEQ_printf(m, "  .%-40s: %d (%s)\n", "sysctl_sched_tunable_scaling",
+		sysctl_sched_tunable_scaling,
+		sched_tunable_scaling_names[sysctl_sched_tunable_scaling]);
+
 	for_each_online_cpu(cpu)
 		print_cpu(m, cpu);
 

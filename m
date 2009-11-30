Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZK3LQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZK3LQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbZK3LQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:16:46 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:55329 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZK3LQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:16:43 -0500
From: ehrhardt@linux.vnet.ibm.com
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: ehrhardt@linux.vnet.ibm.com, Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       schwidefsky@de.ibm.com
Subject: [PATCH 3/3] sched: update normalized values on user updates via proc v2
Date: Mon, 30 Nov 2009 12:16:48 +0100
Message-Id: <1259579808-11357-4-git-send-email-ehrhardt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259579808-11357-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
References: <1259579808-11357-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

*updates in v2*
The normalized values are also recalculated in case the scaling factor changes.

This patch updates the internally used scheduler tuning values that are
normalized to one cpu in case a user sets new values via sysfs.

Together with patch 2 of this series this allows to let user configured
values scale (or not) to cpu add/remove events taking place later.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 sched.c      |   12 +++++++++---
 sched_fair.c |   11 ++++++++++-
 sysctl.c     |   14 +++++++++-----
 3 files changed, 28 insertions(+), 9 deletions(-)

[diff]
Index: linux-2.6-git-schedrecalc/kernel/sched.c
===================================================================
--- linux-2.6-git-schedrecalc.orig/kernel/sched.c
+++ linux-2.6-git-schedrecalc/kernel/sched.c
@@ -1812,6 +1812,7 @@ static void cfs_rq_set_shares(struct cfs
 
 static void calc_load_account_active(struct rq *this_rq);
 static void update_sysctl(void);
+static int get_update_sysctl_factor(void);
 
 #include "sched_stats.h"
 #include "sched_idletask.c"
@@ -7005,11 +7006,9 @@ cpumask_var_t nohz_cpu_mask;
  *
  * This idea comes from the SD scheduler of Con Kolivas:
  */
-static void update_sysctl(void)
+static int get_update_sysctl_factor(void)
 {
 	unsigned int cpus = max(num_online_cpus(), 8U);
-	unsigned int factor = 1 + ilog2(cpus);
-
 	unsigned int factor;
 
 	switch (sysctl_sched_tunable_scaling) {
@@ -7025,6 +7024,13 @@ static void update_sysctl(void)
 		break;
 	}
 
+	return factor;
+}
+
+static void update_sysctl(void)
+{
+	unsigned int factor = get_update_sysctl_factor();
+
 #define SET_SYSCTL(name) \
 	(sysctl_##name = (factor) * normalized_sysctl_##name)
 	SET_SYSCTL(sched_min_granularity);
Index: linux-2.6-git-schedrecalc/kernel/sched_fair.c
===================================================================
--- linux-2.6-git-schedrecalc.orig/kernel/sched_fair.c
+++ linux-2.6-git-schedrecalc/kernel/sched_fair.c
@@ -399,11 +399,12 @@ static struct sched_entity *__pick_last_
  */
 
 #ifdef CONFIG_SCHED_DEBUG
-int sched_nr_latency_handler(struct ctl_table *table, int write,
+int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
 	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	int factor = get_update_sysctl_factor();
 
 	if (ret || !write)
 		return ret;
@@ -411,6 +412,14 @@ int sched_nr_latency_handler(struct ctl_
 	sched_nr_latency = DIV_ROUND_UP(sysctl_sched_latency,
 					sysctl_sched_min_granularity);
 
+#define WRT_SYSCTL(name) \
+	(normalized_sysctl_##name = sysctl_##name / (factor))
+	WRT_SYSCTL(sched_min_granularity);
+	WRT_SYSCTL(sched_latency);
+	WRT_SYSCTL(sched_wakeup_granularity);
+	WRT_SYSCTL(sched_shares_ratelimit);
+#undef WRT_SYSCTL
+
 	return 0;
 }
 #endif
Index: linux-2.6-git-schedrecalc/kernel/sysctl.c
===================================================================
--- linux-2.6-git-schedrecalc.orig/kernel/sysctl.c
+++ linux-2.6-git-schedrecalc/kernel/sysctl.c
@@ -250,6 +250,8 @@ static int min_wakeup_granularity_ns;
 static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 static int min_sched_tunable_scaling = SCHED_TUNABLESCALING_NONE;
 static int max_sched_tunable_scaling = SCHED_TUNABLESCALING_END-1;
+static int min_sched_shares_ratelimit = 100000; /* 100 usec */
+static int max_sched_shares_ratelimit = NSEC_PER_SEC; /* 1 second */
 #endif
 
 static struct ctl_table kern_table[] = {
@@ -268,7 +270,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_min_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
@@ -279,7 +281,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_latency,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
@@ -290,7 +292,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_wakeup_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_wakeup_granularity_ns,
 		.extra2		= &max_wakeup_granularity_ns,
@@ -301,7 +303,9 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_shares_ratelimit,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &sched_proc_update_handler,
+		.extra1		= &min_sched_shares_ratelimit,
+		.extra2		= &max_sched_shares_ratelimit,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -309,7 +313,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_tunable_scaling,
 		.maxlen		= sizeof(enum sched_tunable_scaling),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_sched_tunable_scaling,
 		.extra2		= &max_sched_tunable_scaling,

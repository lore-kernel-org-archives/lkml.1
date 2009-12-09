Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZLIJ5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZLIJ5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZLIJ5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:57:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:45723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbZLIJ5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:57:01 -0500
Date: Wed, 9 Dec 2009 09:56:30 GMT
From: tip-bot for Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, ehrhardt@linux.vnet.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, ehrhardt@linux.vnet.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1259579808-11357-4-git-send-email-ehrhardt@linux.vnet.ibm.com>
References: <1259579808-11357-4-git-send-email-ehrhardt@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Update normalized values on user updates via proc
Message-ID: <tip-acb4a848da821a095ae9e4d8b22ae2d9633ba5cd@git.kernel.org>
Git-Commit-ID: acb4a848da821a095ae9e4d8b22ae2d9633ba5cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acb4a848da821a095ae9e4d8b22ae2d9633ba5cd
Gitweb:     http://git.kernel.org/tip/acb4a848da821a095ae9e4d8b22ae2d9633ba5cd
Author:     Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
AuthorDate: Mon, 30 Nov 2009 12:16:48 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:04:02 +0100

sched: Update normalized values on user updates via proc

The normalized values are also recalculated in case the scaling factor
changes.

This patch updates the internally used scheduler tuning values that are
normalized to one cpu in case a user sets new values via sysfs.

Together with patch 2 of this series this allows to let user configured
values scale (or not) to cpu add/remove events taking place later.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1259579808-11357-4-git-send-email-ehrhardt@linux.vnet.ibm.com>
[ v2: fix warning ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |   12 ++++++++++--
 kernel/sched_fair.c |   11 ++++++++++-
 kernel/sysctl.c     |   14 +++++++++-----
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 116efed..0a60e8e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1816,6 +1816,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 
 static void calc_load_account_active(struct rq *this_rq);
 static void update_sysctl(void);
+static int get_update_sysctl_factor(void);
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
@@ -7030,9 +7031,9 @@ cpumask_var_t nohz_cpu_mask;
  *
  * This idea comes from the SD scheduler of Con Kolivas:
  */
-static void update_sysctl(void)
+static int get_update_sysctl_factor(void)
 {
-	unsigned int cpus = min(num_online_cpus(), 8U);
+	unsigned int cpus = min(num_online_cpus(), 8);
 	unsigned int factor;
 
 	switch (sysctl_sched_tunable_scaling) {
@@ -7048,6 +7049,13 @@ static void update_sysctl(void)
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
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 455106d..804a411 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -399,11 +399,12 @@ static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
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
@@ -411,6 +412,14 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
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
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d10406e..b9e5a45 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -253,6 +253,8 @@ static int min_wakeup_granularity_ns;			/* 0 usecs */
 static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 static int min_sched_tunable_scaling = SCHED_TUNABLESCALING_NONE;
 static int max_sched_tunable_scaling = SCHED_TUNABLESCALING_END-1;
+static int min_sched_shares_ratelimit = 100000; /* 100 usec */
+static int max_sched_shares_ratelimit = NSEC_PER_SEC; /* 1 second */
 #endif
 
 static struct ctl_table kern_table[] = {
@@ -271,7 +273,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_min_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
@@ -282,7 +284,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_latency,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
@@ -293,7 +295,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_wakeup_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_wakeup_granularity_ns,
 		.extra2		= &max_wakeup_granularity_ns,
@@ -304,7 +306,9 @@ static struct ctl_table kern_table[] = {
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
@@ -312,7 +316,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_tunable_scaling,
 		.maxlen		= sizeof(enum sched_tunable_scaling),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_sched_tunable_scaling,
 		.extra2		= &max_sched_tunable_scaling,

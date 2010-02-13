Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0BMC4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:56:17 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58796 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0BMC4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:56:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=u/FjSyHFvAcX2rHvU2RKomCrguX9HpI6xaViGa6RhDXsRj5MMOKWjRPiLkEMWvalM
	NL/NR5+4jTfFhHZ46Z8Ng==
Subject: [RFC PATCH v1 2/4] sched: accumulate per-cfs_rq cpu usage
To: linux-kernel@vger.kernel.org
From: Paul <pjt@google.com>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Date: Fri, 12 Feb 2010 18:55:02 -0800
Message-ID: <20100213025502.23325.47815.stgit@kitami.corp.google.com>
In-Reply-To: <20100213025417.23325.90048.stgit@kitami.corp.google.com>
References: <20100213025417.23325.90048.stgit@kitami.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

Introduce account_cfs_rq_quota() to account bandwidth usage on the cfs_rq
level versus task_groups for which bandwidth has been assigned.  This is
tracked by whether the local cfs_rq->quota_assigned is finite or infinite
(RUNTIME_INF).

For cfs_rq's that belong to a bandwidth constrained task_group we introduce
tg_request_cfs_quota() which attempts to allocate quota from the global pool
for use locally.  Updates involving the global pool are currently protected
under cfs_bandwidth->lock, local pools are protected by rq->lock.

This patch only attempts to assign and track quota, no action is taken in the
case that cfs_rq->quota_used exceeds cfs_rq->quota_assigned.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 include/linux/sched.h |    4 ++++
 kernel/sched.c        |   13 +++++++++++++
 kernel/sched_fair.c   |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c       |   10 ++++++++++
 4 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78efe7c..8c9d401 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1963,6 +1963,10 @@ int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
+
 extern unsigned int sysctl_sched_compat_yield;
 
 #ifdef CONFIG_RT_MUTEXES
diff --git a/kernel/sched.c b/kernel/sched.c
index 6cc4bf4..fb2ffc6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1923,6 +1923,19 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
  * default: 0.5s
  */
 static u64 sched_cfs_bandwidth_period = 500000000ULL;
+
+/*
+ * default slice of quota to allocate from global tg to local cfs_rq pool on
+ * each refresh
+ * default: 10ms
+ */
+unsigned int sysctl_sched_cfs_bandwidth_slice = 10000UL;
+
+static inline u64 sched_cfs_bandwidth_slice(void)
+{
+	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
+}
+
 #endif
 
 #include "sched_stats.h"
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7b109ff..f2741ab 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -266,6 +266,16 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 }
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+#ifdef CONFIG_CFS_BANDWIDTH
+static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
+{
+	return &tg->cfs_bandwidth;
+}
+
+static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
+		unsigned long delta_exec);
+#endif
+
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
  */
@@ -544,6 +554,9 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
+#ifdef CONFIG_CFS_BANDWIDTH
+	account_cfs_rq_quota(cfs_rq, delta_exec);
+#endif
 }
 
 static inline void
@@ -1145,6 +1158,43 @@ static void yield_task_fair(struct rq *rq)
 }
 
 #ifdef CONFIG_CFS_BANDWIDTH
+static u64 tg_request_cfs_quota(struct task_group *tg)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	u64 delta = 0;
+
+	if (cfs_b->runtime > 0 || cfs_b->quota == RUNTIME_INF) {
+		raw_spin_lock(&cfs_b->lock);
+		/*
+		 * it's possible a bandwidth update has changed the global
+		 * pool.
+		 */
+		if (cfs_b->quota == RUNTIME_INF)
+			delta = sched_cfs_bandwidth_slice();
+		else {
+			delta = min(cfs_b->runtime, 
+					sched_cfs_bandwidth_slice());
+			cfs_b->runtime -= delta;
+		}
+		raw_spin_unlock(&cfs_b->lock);
+	}
+	return delta;
+}
+
+static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
+		unsigned long delta_exec)
+{
+	if (cfs_rq->quota_assigned == RUNTIME_INF)
+		return;
+
+	cfs_rq->quota_used += delta_exec;
+
+	if (cfs_rq->quota_used < cfs_rq->quota_assigned)
+		return;
+
+	cfs_rq->quota_assigned += tg_request_cfs_quota(cfs_rq->tg);
+}
+
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
 	return 1;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8a68b24..cc5ccce 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -364,6 +364,16 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		.procname	= "sched_cfs_bandwidth_slice_us",
+		.data		= &sysctl_sched_cfs_bandwidth_slice,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+	},
+#endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",


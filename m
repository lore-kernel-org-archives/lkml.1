Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbXK0FIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbXK0FIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbXK0FIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:08:36 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42243 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbXK0FIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:08:35 -0500
Date: Tue, 27 Nov 2007 10:51:21 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: [Patch 4/5] sched: introduce a mutex and corresponding API to serialize access to doms_cur[] array
Message-ID: <20071127052121.GF20083@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu> <20071126050044.GA5304@linux.vnet.ibm.com> <20071126050905.GF5304@linux.vnet.ibm.com> <20071126202836.GA17012@elte.hu> <20071127050652.GA20083@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127050652.GA20083@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

doms_cur[] array represents various scheduling domains which are mutually
exclusive. Currently cpusets code can modify this array (by calling
partition_sched_domains()) as a result of user modifying sched_load_balance 
flag for various cpusets.

This patch introduces a mutex and corresponding API (only when
CONFIG_FAIR_GROUP_SCHED is defined) which allows a reader to safely read the
doms_cur[] array w/o worrying abt concurrent modifications to the array.

The fair group scheduler code (introduced in next patch of this series)
makes use of this mutex to walk thr' doms_cur[] array while rebalancing
shares of task groups across cpus.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 kernel/sched.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -186,6 +186,9 @@ static struct cfs_rq *init_cfs_rq_p[NR_C
  */
 static DEFINE_MUTEX(task_group_mutex);
 
+/* doms_cur_mutex serializes access to doms_cur[] array */
+static DEFINE_MUTEX(doms_cur_mutex);
+
 /* Default task group.
  *	Every task in system belong to this group at bootup.
  */
@@ -236,11 +239,23 @@ static inline void unlock_task_group_lis
 	mutex_unlock(&task_group_mutex);
 }
 
+static inline void lock_doms_cur(void)
+{
+	mutex_lock(&doms_cur_mutex);
+}
+
+static inline void unlock_doms_cur(void)
+{
+	mutex_unlock(&doms_cur_mutex);
+}
+
 #else
 
 static inline void set_task_cfs_rq(struct task_struct *p, unsigned int cpu) { }
 static inline void lock_task_group_list(void) { }
 static inline void unlock_task_group_list(void) { }
+static inline void lock_doms_cur(void) { }
+static inline void unlock_doms_cur(void) { }
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
@@ -6547,6 +6562,8 @@ void partition_sched_domains(int ndoms_n
 {
 	int i, j;
 
+	lock_doms_cur();
+
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
 
@@ -6587,6 +6604,8 @@ match2:
 	ndoms_cur = ndoms_new;
 
 	register_sched_domain_sysctl();
+
+	unlock_doms_cur();
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)


-- 
Regards,
vatsa

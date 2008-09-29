Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYI2SMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYI2SMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYI2SDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58642 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754007AbYI2SCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:54 -0400
Message-Id: <20080929180253.530146000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:15 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 25/31] cpumask: clean rcu files
Content-Disposition: inline; filename=clean-rcu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 include/linux/rcuclassic.h |    2 +-
 kernel/rcuclassic.c        |    2 +-
 kernel/rcupreempt.c        |    2 +-
 kernel/rcutorture.c        |   12 ++++++------
 4 files changed, 9 insertions(+), 9 deletions(-)

--- struct-cpumasks.orig/include/linux/rcuclassic.h
+++ struct-cpumasks/include/linux/rcuclassic.h
@@ -53,7 +53,7 @@ struct rcu_ctrlblk {
 	int	signaled;
 
 	spinlock_t	lock	____cacheline_internodealigned_in_smp;
-	cpumask_t	cpumask; /* CPUs that need to switch in order    */
+	cpumask_map_t	cpumask; /* CPUs that need to switch in order    */
 				 /* for current batch to proceed.        */
 } ____cacheline_internodealigned_in_smp;
 
--- struct-cpumasks.orig/kernel/rcuclassic.c
+++ struct-cpumasks/kernel/rcuclassic.c
@@ -85,7 +85,7 @@ static void force_quiescent_state(struct
 			struct rcu_ctrlblk *rcp)
 {
 	int cpu;
-	cpumask_t cpumask;
+	cpumask_var_t cpumask;
 	unsigned long flags;
 
 	set_need_resched();
--- struct-cpumasks.orig/kernel/rcupreempt.c
+++ struct-cpumasks/kernel/rcupreempt.c
@@ -164,7 +164,7 @@ static char *rcu_try_flip_state_names[] 
 	{ "idle", "waitack", "waitzero", "waitmb" };
 #endif /* #ifdef CONFIG_RCU_TRACE */
 
-static cpumask_t rcu_cpu_online_map __read_mostly = CPU_MASK_NONE;
+static cpumask_map_t rcu_cpu_online_map __read_mostly = CPU_MASK_NONE;
 
 /*
  * Enum and per-CPU flag to determine when each CPU has seen
--- struct-cpumasks.orig/kernel/rcutorture.c
+++ struct-cpumasks/kernel/rcutorture.c
@@ -843,7 +843,7 @@ static int rcu_idle_cpu;	/* Force all to
  */
 static void rcu_torture_shuffle_tasks(void)
 {
-	cpumask_t tmp_mask;
+	cpumask_var_t tmp_mask;
 	int i;
 
 	cpus_setall(tmp_mask);
@@ -858,27 +858,27 @@ static void rcu_torture_shuffle_tasks(vo
 	if (rcu_idle_cpu != -1)
 		cpu_clear(rcu_idle_cpu, tmp_mask);
 
-	set_cpus_allowed(current, &tmp_mask);
+	set_cpus_allowed(current, tmp_mask);
 
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
 			if (reader_tasks[i])
 				set_cpus_allowed(reader_tasks[i],
-						     &tmp_mask);
+						     tmp_mask);
 	}
 
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
 				set_cpus_allowed(fakewriter_tasks[i],
-						     &tmp_mask);
+						     tmp_mask);
 	}
 
 	if (writer_task)
-		set_cpus_allowed(writer_task, &tmp_mask);
+		set_cpus_allowed(writer_task, tmp_mask);
 
 	if (stats_task)
-		set_cpus_allowed(stats_task, &tmp_mask);
+		set_cpus_allowed(stats_task, tmp_mask);
 
 	if (rcu_idle_cpu == -1)
 		rcu_idle_cpu = num_online_cpus() - 1;

-- 

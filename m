Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbZCSHhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbZCSHhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZCSHhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:37:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:34444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbZCSHhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:37:34 -0400
Date: Thu, 19 Mar 2009 07:36:34 GMT
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com>
Subject: [tip:cpus4096] cpumask: remove cpumask allocation from idle_balance
Message-ID: <tip-df7c8e845e8e2030e8ae947e0ace56d184d0e9a0@git.kernel.org>
Git-Commit-ID: df7c8e845e8e2030e8ae947e0ace56d184d0e9a0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Mar 2009 07:36:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df7c8e845e8e2030e8ae947e0ace56d184d0e9a0
Gitweb:     http://git.kernel.org/tip/df7c8e845e8e2030e8ae947e0ace56d184d0e9a0
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Thu, 19 Mar 2009 15:22:20 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Mar 2009 08:15:15 +0100

cpumask: remove cpumask allocation from idle_balance

Impact: fix circular locking

Steven reports a circular locking from alloc_cpumask_var doing
a wakeup. We get rid of this using the tried-and-true technique
of using a per-cpu cpumask_var_t rather than doing an alloc
every time.

Simpler and more robust than a rare, implicit allocation within
an atomic codepath.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5dabd80..48862d4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3448,19 +3448,23 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
  */
 #define MAX_PINNED_INTERVAL	512
 
+/* Working cpumask for load_balance and load_balance_newidle. */
+static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *balance, struct cpumask *cpus)
+			int *balance)
 {
 	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
 	unsigned long flags;
+	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
 	cpumask_setall(cpus);
 
@@ -3615,8 +3619,7 @@ out:
  * this_rq is locked.
  */
 static int
-load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
-			struct cpumask *cpus)
+load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 {
 	struct sched_group *group;
 	struct rq *busiest = NULL;
@@ -3624,6 +3627,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
 	int ld_moved = 0;
 	int sd_idle = 0;
 	int all_pinned = 0;
+	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
 	cpumask_setall(cpus);
 
@@ -3764,10 +3768,6 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
-	cpumask_var_t tmpmask;
-
-	if (!alloc_cpumask_var(&tmpmask, GFP_ATOMIC))
-		return;
 
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -3778,7 +3778,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		if (sd->flags & SD_BALANCE_NEWIDLE)
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance_newidle(this_cpu, this_rq,
-							   sd, tmpmask);
+							   sd);
 
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
@@ -3793,7 +3793,6 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		 */
 		this_rq->next_balance = next_balance;
 	}
-	free_cpumask_var(tmpmask);
 }
 
 /*
@@ -3943,11 +3942,6 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
 	int need_serialize;
-	cpumask_var_t tmp;
-
-	/* Fails alloc?  Rebalancing probably not a priority right now. */
-	if (!alloc_cpumask_var(&tmp, GFP_ATOMIC))
-		return;
 
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -3972,7 +3966,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance, tmp)) {
+			if (load_balance(cpu, rq, sd, idle, &balance)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is
@@ -4006,8 +4000,6 @@ out:
 	 */
 	if (likely(update_next_balance))
 		rq->next_balance = next_balance;
-
-	free_cpumask_var(tmp);
 }
 
 /*
@@ -8304,6 +8296,9 @@ void __init sched_init(void)
 #ifdef CONFIG_USER_SCHED
 	alloc_size *= 2;
 #endif
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	alloc_size *= num_possible_cpus() * cpumask_size();
+#endif
 	/*
 	 * As sched_init() is called before page_alloc is setup,
 	 * we use alloc_bootmem().
@@ -8341,6 +8336,12 @@ void __init sched_init(void)
 		ptr += nr_cpu_ids * sizeof(void **);
 #endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_RT_GROUP_SCHED */
+#ifdef CONFIG_CPUMASK_OFFSTACK
+		for_each_possible_cpu(i) {
+			per_cpu(load_balance_tmpmask, i) = (void *)ptr;
+			ptr += cpumask_size();
+		}
+#endif /* CONFIG_CPUMASK_OFFSTACK */
 	}
 
 #ifdef CONFIG_SMP

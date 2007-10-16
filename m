Return-Path: <linux-kernel-owner+w=401wt.eu-S965327AbXJPTH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965327AbXJPTH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759529AbXJPTHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:07:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:2054 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759551AbXJPTHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:07:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=R/DsxxCDxddCf3vbO3nTBsP/O8jeSULqqS2iu3dfuN9Mo4p2mdqHTmoTSRxPNyllW
	cAwz7CtIZl1V4mqen/GsQ==
Message-ID: <b040c32a0710161207s4d6d4d4cq1fa7f0dd1a7f017d@mail.gmail.com>
Date: Tue, 16 Oct 2007 12:07:06 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [patch] sched: fix improper load balance across sched domain
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We recently discovered a nasty performance bug in the kernel CPU load
balancer where we were hit by 50% performance regression.

When tasks are assigned to a subset of CPUs that span across
sched_domains (either ccNUMA node or the new multi-core domain) via
cpu affinity, kernel fails to perform proper load balance at
these domains, due to several logic in find_busiest_group() miss
identified busiest sched group within a given domain. This leads to
inadequate load balance and causes 50% performance hit.

To give you a concrete example, on a dual-core, 2 socket numa system,
there are 4 logical cpu, organized as:

CPU0 attaching sched-domain:
 domain 0: span 0003  groups: 0001 0002
 domain 1: span 000f  groups: 0003 000c
CPU1 attaching sched-domain:
 domain 0: span 0003  groups: 0002 0001
 domain 1: span 000f  groups: 0003 000c
CPU2 attaching sched-domain:
 domain 0: span 000c  groups: 0004 0008
 domain 1: span 000f  groups: 000c 0003
CPU3 attaching sched-domain:
 domain 0: span 000c  groups: 0008 0004
 domain 1: span 000f  groups: 000c 0003

If I run 2 tasks with CPU affinity set to 0x5.  There are situation
where cpu0 has run queue length of 2, and cpu2 will be idle.  The
kernel load balancer is unable to balance out these two tasks over
cpu0 and cpu2 due to at least three logics in find_busiest_group()
that heavily bias load balance towards power saving mode. e.g. while
determining "busiest" variable, kernel only set it when
"sum_nr_running > group_capacity".  This test is flawed that
"sum_nr_running" is not necessary same as
sum-tasks-allowed-to-run-within-the sched-group.  The end result is
that kernel "think" everything is balanced, but in reality we have an
imbalance and thus causing one CPU to be over-subscribed and leaving
other idle.  There are two other logic in the same function will also
causing similar effect.  The nastiness of this bug is that kernel not
be able to get unstuck in this unfortunate broken state.  From what
we've seen in our environment, kernel will stuck in imbalanced state
for extended period of time and it is also very easy for the kernel to
stuck into that state (it's pretty much 100% reproducible for us).

So proposing the following fix: add addition logic in
find_busiest_group to detect intrinsic imbalance within the busiest
group.  When such condition is detected, load balance goes into spread
mode instead of default grouping mode.


Signed-off-by: Ken Chen <kenchen@google.com>


--- ./kernel/sched.c.orig	2007-10-16 10:08:01.000000000 -0700
+++ ./kernel/sched.c	2007-10-16 10:56:13.000000000 -0700
@@ -2339,7 +2339,7 @@
 	unsigned long max_pull;
 	unsigned long busiest_load_per_task, busiest_nr_running;
 	unsigned long this_load_per_task, this_nr_running;
-	int load_idx;
+	int load_idx, group_imb = 0;
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 	int power_savings_balance = 1;
 	unsigned long leader_nr_running = 0, min_load_per_task = 0;
@@ -2358,9 +2358,10 @@
 		load_idx = sd->idle_idx;

 	do {
-		unsigned long load, group_capacity;
+		unsigned long load, group_capacity, max_cpu_load, min_cpu_load;
 		int local_group;
 		int i;
+		int __group_imb = 0;
 		unsigned int balance_cpu = -1, first_idle_cpu = 0;
 		unsigned long sum_nr_running, sum_weighted_load;

@@ -2371,6 +2372,8 @@

 		/* Tally up the load of all CPUs in the group */
 		sum_weighted_load = sum_nr_running = avg_load = 0;
+		max_cpu_load = 0;
+		min_cpu_load = ~0UL;

 		for_each_cpu_mask(i, group->cpumask) {
 			struct rq *rq;
@@ -2391,8 +2394,13 @@
 				}

 				load = target_load(i, load_idx);
-			} else
+			} else {
 				load = source_load(i, load_idx);
+				if (load > max_cpu_load)
+					max_cpu_load = load;
+				if (min_cpu_load > load)
+					min_cpu_load = load;
+			}

 			avg_load += load;
 			sum_nr_running += rq->nr_running;
@@ -2418,6 +2426,9 @@
 		avg_load = sg_div_cpu_power(group,
 				avg_load * SCHED_LOAD_SCALE);

+		if ((max_cpu_load - min_cpu_load) > SCHED_LOAD_SCALE)
+			__group_imb = 1;
+
 		group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;

 		if (local_group) {
@@ -2426,11 +2437,12 @@
 			this_nr_running = sum_nr_running;
 			this_load_per_task = sum_weighted_load;
 		} else if (avg_load > max_load &&
-			   sum_nr_running > group_capacity) {
+			   (sum_nr_running > group_capacity || __group_imb)) {
 			max_load = avg_load;
 			busiest = group;
 			busiest_nr_running = sum_nr_running;
 			busiest_load_per_task = sum_weighted_load;
+			group_imb = __group_imb;
 		}

 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -2502,6 +2514,9 @@
 		goto out_balanced;

 	busiest_load_per_task /= busiest_nr_running;
+	if (group_imb)
+		busiest_load_per_task = min(busiest_load_per_task, avg_load);
+
 	/*
 	 * We're trying to get all the cpus to the average_load, so we don't
 	 * want to push ourselves above the average load, nor do we wish to

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbZEGJ76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbZEGJ76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZEGJ7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:59:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47920 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZEGJ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:59:45 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH v3] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090507185831.9D24.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu,  7 May 2009 18:59:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changelog:
  since v2
  - revert using percpu_counter_sum()

  since v1
  - use percpu_counter_sum() instead percpu_counter_read()


-------------------------------------
Subject: [PATCH v3] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count

cpuacct_update_stats() is called at every tick updating. and it use percpu_counter
for avoiding performance degression.

For archs which define VIRT_CPU_ACCOUNTING, every tick would result
in >1000 units of cputime updates and since this is much much greater
than percpu_batch_counter, we end up taking spinlock on every tick.

This patch change batch rule. now, any cpu can store "percpu_counter_bach * jiffies"
cputime in per-cpu cache.
it mean this patch don't have behavior change if VIRT_CPU_ACCOUNTING=n.

Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Balaji Rao <balajirrao@gmail.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/sched.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c	2009-04-30 11:37:47.000000000 +0900
+++ b/kernel/sched.c	2009-05-07 16:34:00.000000000 +0900
@@ -10221,6 +10221,7 @@ struct cpuacct {
 };
 
 struct cgroup_subsys cpuacct_subsys;
+static s32 cpuacct_batch;
 
 /* return cpu accounting group corresponding to this container */
 static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
@@ -10250,6 +10251,9 @@ static struct cgroup_subsys_state *cpuac
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
+	if (!cpuacct_batch)
+		cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
+
 	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
 		if (percpu_counter_init(&ca->cpustat[i], 0))
 			goto out_free_counters;
@@ -10446,7 +10450,7 @@ static void cpuacct_update_stats(struct 
 	ca = task_ca(tsk);
 
 	do {
-		percpu_counter_add(&ca->cpustat[idx], val);
+		__percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();



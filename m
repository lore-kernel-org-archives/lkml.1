Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbZD1Gxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbZD1Gxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 02:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbZD1Gxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 02:53:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48395 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZD1Gxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 02:53:34 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       seto.hidetoshi@jp.fujitsu.com
Subject: [PATCH] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090428153611.EBC6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 28 Apr 2009 15:53:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm not cpuacct expert. please give me comment.

====================
Subject: [PATCH] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime caching

impact: little performance improvement

cpuacct_update_stats() is called at every tick updating. and it use percpu_counter
for avoiding performance degression.

Unfortunately, it doesn't works on VIRT_CPU_ACCOUNTING=y environment properly.
if VIRT_CPU_ACCOUNTING=y, every tick update much than 1000 cputime.
Thus every percpu_counter_add() makes spinlock grabbing and update non-percpu-variable.

This patch change the batch rule. now, every cpu can store "percpu_counter_bach x jiffies"
cputime in percpu cache.
it mean this patch don't have behavior change if VIRT_CPU_ACCOUNTING=n, but
works well on VIRT_CPU_ACCOUNTING=y too.


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
--- a/kernel/sched.c	2009-04-28 14:18:36.000000000 +0900
+++ b/kernel/sched.c	2009-04-28 15:18:07.000000000 +0900
@@ -10117,6 +10117,7 @@ struct cpuacct {
 };
 
 struct cgroup_subsys cpuacct_subsys;
+static s32 cpuacct_batch;
 
 /* return cpu accounting group corresponding to this container */
 static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
@@ -10146,6 +10147,9 @@ static struct cgroup_subsys_state *cpuac
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
+	if (!cpuacct_batch)
+		cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
+
 	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
 		if (percpu_counter_init(&ca->cpustat[i], 0))
 			goto out_free_counters;
@@ -10342,7 +10346,7 @@ static void cpuacct_update_stats(struct 
 	ca = task_ca(tsk);
 
 	do {
-		percpu_counter_add(&ca->cpustat[idx], val);
+		__percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326Ab0ARAxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0ARAxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295Ab0ARAxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:53:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:54212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab0ARAxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:05 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/40] sched: consult online mask instead of active in select_fallback_rq()
Date: Mon, 18 Jan 2010 09:57:13 +0900
Message-Id: <1263776272-382-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If called after sched_class chooses a CPU which isn't in a task's
cpus_allowed mask, select_fallback_rq() can end up migrating a task
which is bound to a !active but online cpu to an active cpu.  This is
dangerous because active is cleared before CPU_DOWN_PREPARE is called
and subsystems expect affinities of kthreads and other tasks to be
maintained till their CPU_DOWN_PREPARE callbacks are complete.

Consult cpu_online_mask instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c535cc4..09d97e3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2288,12 +2288,12 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
 
 	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
+	for_each_cpu_and(dest_cpu, nodemask, cpu_online_mask)
 		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
 			return dest_cpu;
 
 	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
+	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_online_mask);
 	if (dest_cpu < nr_cpu_ids)
 		return dest_cpu;
 
@@ -2302,6 +2302,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 		rcu_read_lock();
 		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
 		rcu_read_unlock();
+		/* breaking affinity, consider active mask instead */
 		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
 
 		/*
-- 
1.6.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936004Ab0BZMOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:14:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:43402 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935983Ab0BZMOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:43 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/43] sched: consult online mask instead of active in select_fallback_rq()
Date: Fri, 26 Feb 2010 21:22:38 +0900
Message-Id: <1267187000-18791-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:21 +0000 (UTC)
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
index 3a8fb30..ca32adc 100644
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


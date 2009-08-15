Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbZHOQyc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 15 Aug 2009 12:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932118AbZHOQxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:53:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50751 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbZHOQxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:53:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   josht@linux.vnet.ibm.com, akpm@linux-foundation.org,
   mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip/core/rcu 4/6] Make preemptable RCU scan all CPUs when summing RCU counters.
Date: Sat, 15 Aug 2009 09:53:49 -0700
Message-Id: <12503552312863-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090815165153.GA8886@linux.vnet.ibm.com>
References: <20090815165153.GA8886@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This patch eliminates the counter-moving during CPU-offline
notifiers, eliminating potential confusion if counters are
scanned during counter-movement process.  This confusion
could result in premature ending of an RCU grace period.
For example, if there are two tasks in RCU read-side critical
sections (so that the sum of the counters is two), and the
counter for the CPU going offline is -2, then moving the
count to another CPU can result in the sum momentarily appearing
to be zero.  Since there are no memory barriers in either case,
many more such scenarios are possible.

So just don't move the counts!!!

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupreempt.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 9b87f51..2748b89 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -849,7 +849,7 @@ rcu_try_flip_waitzero(void)
 	/* Check to see if the sum of the "last" counters is zero. */
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_z1);
-	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map))
+	for_each_possible_cpu(cpu)
 		sum += RCU_DATA_CPU(cpu)->rcu_flipctr[lastidx];
 	if (sum != 0) {
 		RCU_TRACE_ME(rcupreempt_trace_try_flip_ze1);
@@ -1067,12 +1067,6 @@ void rcu_offline_cpu(int cpu)
 			   /*  seen -after- acknowledgement. */
 	}
 
-	RCU_DATA_ME()->rcu_flipctr[0] += RCU_DATA_CPU(cpu)->rcu_flipctr[0];
-	RCU_DATA_ME()->rcu_flipctr[1] += RCU_DATA_CPU(cpu)->rcu_flipctr[1];
-
-	RCU_DATA_CPU(cpu)->rcu_flipctr[0] = 0;
-	RCU_DATA_CPU(cpu)->rcu_flipctr[1] = 0;
-
 	cpumask_clear_cpu(cpu, to_cpumask(rcu_cpu_online_map));
 
 	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
-- 
1.5.2.5


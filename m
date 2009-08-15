Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbZHORIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbZHORIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbZHORIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:08:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:33768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbZHORIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:08:40 -0400
Date: Sat, 15 Aug 2009 17:07:42 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12503552312863-git-send-email->
References: <12503552312863-git-send-email->
Subject: [tip:core/rcu] rcu: Make preemptable RCU scan all CPUs when summing RCU counters
Message-ID: <tip-8064d54929f23613e649dc7e14f7a94454487d58@git.kernel.org>
Git-Commit-ID: 8064d54929f23613e649dc7e14f7a94454487d58
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 17:07:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8064d54929f23613e649dc7e14f7a94454487d58
Gitweb:     http://git.kernel.org/tip/8064d54929f23613e649dc7e14f7a94454487d58
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 15 Aug 2009 09:53:49 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 15 Aug 2009 19:02:08 +0200

rcu: Make preemptable RCU scan all CPUs when summing RCU counters

This patch eliminates the counter-moving during CPU-offline
notifiers, eliminating potential confusion if counters are
scanned during counter-movement process.

This confusion could result in premature ending of an RCU grace
period. For example, if there are two tasks in RCU read-side
critical sections (so that the sum of the counters is two), and
the counter for the CPU going offline is -2, then moving the
count to another CPU can result in the sum momentarily
appearing to be zero.  Since there are no memory barriers in
either case, many more such scenarios are possible.

So just don't move the counts!!!

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: josht@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: hugh.dickins@tiscali.co.uk
Cc: benh@kernel.crashing.org
LKML-Reference: <12503552312863-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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

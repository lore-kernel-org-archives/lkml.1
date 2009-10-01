Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbZJAHqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbZJAHqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbZJAHqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:46:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:51841 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733AbZJAHqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:46:40 -0400
Date: Thu, 1 Oct 2009 07:46:00 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       paulmck@linux.vnet.ibm.com, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12541998232366-git-send-email->
References: <12541998232366-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Replace the rcu_barrier enum with pointer to call_rcu*() function
Message-ID: <tip-0e29f18291cb35b84d0a42c1a79886571b6e5409@git.kernel.org>
Git-Commit-ID: 0e29f18291cb35b84d0a42c1a79886571b6e5409
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 07:46:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e29f18291cb35b84d0a42c1a79886571b6e5409
Gitweb:     http://git.kernel.org/tip/0e29f18291cb35b84d0a42c1a79886571b6e5409
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 28 Sep 2009 21:50:21 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 09:18:31 +0200

rcu: Replace the rcu_barrier enum with pointer to call_rcu*() function

The rcu_barrier enum causes several problems:

  (1) you have to define the enum somewhere, and there is no
      convenient place,

  (2) the difference between TREE_RCU and TREE_PREEMPT_RCU causes
      problems when you need to map from rcu_barrier enum to struct
      rcu_state,

  (3) the switch statement are large, and

  (4) TINY_RCU really needs a different rcu_barrier() than do the
      treercu implementations.

So replace it with a functionally equivalent but cleaner function
pointer abstraction.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12541998232366-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcupdate.c |   32 ++++++++++----------------------
 1 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 2480534..fd3ec49 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -53,12 +53,6 @@ struct lockdep_map rcu_lock_map =
 EXPORT_SYMBOL_GPL(rcu_lock_map);
 #endif
 
-enum rcu_barrier {
-	RCU_BARRIER_STD,
-	RCU_BARRIER_BH,
-	RCU_BARRIER_SCHED,
-};
-
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
@@ -188,19 +182,12 @@ static void rcu_barrier_func(void *type)
 {
 	int cpu = smp_processor_id();
 	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
+	void (*call_rcu_func)(struct rcu_head *head,
+			      void (*func)(struct rcu_head *head));
 
 	atomic_inc(&rcu_barrier_cpu_count);
-	switch ((enum rcu_barrier)type) {
-	case RCU_BARRIER_STD:
-		call_rcu(head, rcu_barrier_callback);
-		break;
-	case RCU_BARRIER_BH:
-		call_rcu_bh(head, rcu_barrier_callback);
-		break;
-	case RCU_BARRIER_SCHED:
-		call_rcu_sched(head, rcu_barrier_callback);
-		break;
-	}
+	call_rcu_func = type;
+	call_rcu_func(head, rcu_barrier_callback);
 }
 
 static inline void wait_migrated_callbacks(void)
@@ -213,7 +200,8 @@ static inline void wait_migrated_callbacks(void)
  * Orchestrate the specified type of RCU barrier, waiting for all
  * RCU callbacks of the specified type to complete.
  */
-static void _rcu_barrier(enum rcu_barrier type)
+static void _rcu_barrier(void (*call_rcu_func)(struct rcu_head *head,
+					       void (*func)(struct rcu_head *head)))
 {
 	BUG_ON(in_interrupt());
 	/* Take cpucontrol mutex to protect against CPU hotplug */
@@ -229,7 +217,7 @@ static void _rcu_barrier(enum rcu_barrier type)
 	 * early.
 	 */
 	atomic_set(&rcu_barrier_cpu_count, 1);
-	on_each_cpu(rcu_barrier_func, (void *)type, 1);
+	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
 		complete(&rcu_barrier_completion);
 	wait_for_completion(&rcu_barrier_completion);
@@ -242,7 +230,7 @@ static void _rcu_barrier(enum rcu_barrier type)
  */
 void rcu_barrier(void)
 {
-	_rcu_barrier(RCU_BARRIER_STD);
+	_rcu_barrier(call_rcu);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
@@ -251,7 +239,7 @@ EXPORT_SYMBOL_GPL(rcu_barrier);
  */
 void rcu_barrier_bh(void)
 {
-	_rcu_barrier(RCU_BARRIER_BH);
+	_rcu_barrier(call_rcu_bh);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_bh);
 
@@ -260,7 +248,7 @@ EXPORT_SYMBOL_GPL(rcu_barrier_bh);
  */
 void rcu_barrier_sched(void)
 {
-	_rcu_barrier(RCU_BARRIER_SCHED);
+	_rcu_barrier(call_rcu_sched);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 

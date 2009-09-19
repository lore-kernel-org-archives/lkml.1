Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZISH7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZISH7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbZISH7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:59:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:53846 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbZISH7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:59:08 -0400
Date: Sat, 19 Sep 2009 07:58:51 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12532926201851-git-send-email->
References: <12532926201851-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Apply results of code inspection of kernel/rcutree_plugin.h
Message-ID: <tip-e7d8842ed34a7fe19d1ed90f84c211fb056ac523@git.kernel.org>
Git-Commit-ID: e7d8842ed34a7fe19d1ed90f84c211fb056ac523
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 07:58:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7d8842ed34a7fe19d1ed90f84c211fb056ac523
Gitweb:     http://git.kernel.org/tip/e7d8842ed34a7fe19d1ed90f84c211fb056ac523
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 18 Sep 2009 09:50:18 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 08:53:21 +0200

rcu: Apply results of code inspection of kernel/rcutree_plugin.h

o Drop the calls to cpu_quiet() from the online/offline code.
  These are unnecessary, since force_quiescent_state() will
  clean up, and removing them simplifies the code a bit.

o Add a warning to check that we don't enqueue the same blocked
  task twice onto the ->blocked_tasks[] lists.

o Rework the phase computation in rcu_preempt_note_context_switch()
  to be more readable, as suggested by Josh Triplett.

o Disable irqs to close a race between the scheduling clock
  interrupt and rcu_preempt_note_context_switch() WRT the
  ->rcu_read_unlock_special field.

o Add comments to rnp->lock acquisition and release within
  rcu_read_unlock_special() noting that irqs are already
  disabled.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
LKML-Reference: <12532926201851-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree.c        |   27 +++++----------------------
 kernel/rcutree_plugin.h |   10 ++++++----
 2 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e8624eb..ae4a553 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -767,10 +767,10 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 
 /*
  * Record a quiescent state for the specified CPU, which must either be
- * the current CPU or an offline CPU.  The lastcomp argument is used to
- * make sure we are still in the grace period of interest.  We don't want
- * to end the current grace period based on quiescent states detected in
- * an earlier grace period!
+ * the current CPU.  The lastcomp argument is used to make sure we are
+ * still in the grace period of interest.  We don't want to end the current
+ * grace period based on quiescent states detected in an earlier grace
+ * period!
  */
 static void
 cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
@@ -805,7 +805,6 @@ cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
 		 * This GP can't end until cpu checks in, so all of our
 		 * callbacks can be processed during the next GP.
 		 */
-		rdp = rsp->rda[smp_processor_id()];
 		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 
 		cpu_quiet_msk(mask, rsp, rnp, flags); /* releases rnp->lock */
@@ -881,9 +880,6 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 
 	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
 
-	/* Being offline is a quiescent state, so go record it. */
-	cpu_quiet(cpu, rsp, rdp, lastcomp);
-
 	/*
 	 * Move callbacks from the outgoing CPU to the running CPU.
 	 * Note that the outgoing CPU is now quiscent, so it is now
@@ -1448,20 +1444,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 		rnp = rnp->parent;
 	} while (rnp != NULL && !(rnp->qsmaskinit & mask));
 
-	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
-
-	/*
-	 * A new grace period might start here.  If so, we will be part of
-	 * it, and its gpnum will be greater than ours, so we will
-	 * participate.  It is also possible for the gpnum to have been
-	 * incremented before this function was called, and the bitmasks
-	 * to not be filled out until now, in which case we will also
-	 * participate due to our gpnum being behind.
-	 */
-
-	/* Since it is coming online, the CPU is in a quiescent state. */
-	cpu_quiet(cpu, rsp, rdp, lastcomp);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
 static void __cpuinit rcu_online_cpu(int cpu)
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 5f94619..cd6047c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -117,9 +117,9 @@ static void rcu_preempt_note_context_switch(int cpu)
 		 * on line!
 		 */
 		WARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);
-		phase = !(rnp->qsmask & rdp->grpmask) ^ (rnp->gpnum & 0x1);
+		WARN_ON_ONCE(!list_empty(&t->rcu_node_entry));
+		phase = (rnp->gpnum + !(rnp->qsmask & rdp->grpmask)) & 0x1;
 		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
-		smp_mb();  /* Ensure later ctxt swtch seen after above. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
@@ -133,7 +133,9 @@ static void rcu_preempt_note_context_switch(int cpu)
 	 * means that we continue to block the current grace period.
 	 */
 	rcu_preempt_qs(cpu);
+	local_irq_save(flags);
 	t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+	local_irq_restore(flags);
 }
 
 /*
@@ -189,10 +191,10 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 */
 		for (;;) {
 			rnp = t->rcu_blocked_node;
-			spin_lock(&rnp->lock);
+			spin_lock(&rnp->lock);  /* irqs already disabled. */
 			if (rnp == t->rcu_blocked_node)
 				break;
-			spin_unlock(&rnp->lock);
+			spin_unlock(&rnp->lock);  /* irqs remain disabled. */
 		}
 		empty = list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
 		list_del_init(&t->rcu_node_entry);

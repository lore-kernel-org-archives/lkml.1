Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0BQQXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:23:33 -0500
Received: from www.tglx.de ([62.245.132.106]:58314 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab0BQQXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:23:31 -0500
Message-Id: <20100217162054.114542795@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 17 Feb 2010 16:23:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [patch -tip/core/rcu] rcu: Convert to raw_spinlocks
Content-Disposition: inline; filename=rcutree-convert-to-raw-spinlocks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spinlocks in rcutree need to be real spinlocks in
preempt-rt. Convert them to raw_spinlocks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/rcutree.c        |  132 ++++++++++++++++++++++++------------------------
 kernel/rcutree.h        |    6 +-
 kernel/rcutree_plugin.h |   46 ++++++++--------
 3 files changed, 92 insertions(+), 92 deletions(-)

Index: linux-2.6-tip/kernel/rcutree.c
===================================================================
--- linux-2.6-tip.orig/kernel/rcutree.c
+++ linux-2.6-tip/kernel/rcutree.c
@@ -66,11 +66,11 @@ static struct lock_class_key rcu_node_cl
 	.signaled = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
-	.onofflock = __SPIN_LOCK_UNLOCKED(&name.onofflock), \
+	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&name.onofflock), \
 	.orphan_cbs_list = NULL, \
 	.orphan_cbs_tail = &name.orphan_cbs_list, \
 	.orphan_qlen = 0, \
-	.fqslock = __SPIN_LOCK_UNLOCKED(&name.fqslock), \
+	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&name.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
 }
@@ -457,10 +457,10 @@ static void print_other_cpu_stall(struct
 
 	/* Only let one CPU complain about others per time interval. */
 
-	spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	delta = jiffies - rsp->jiffies_stall;
 	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp)) {
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
@@ -470,7 +470,7 @@ static void print_other_cpu_stall(struct
 	 * due to CPU offlining.
 	 */
 	rcu_print_task_stall(rnp);
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/* OK, time to rat on our buddy... */
 
@@ -499,11 +499,11 @@ static void print_cpu_stall(struct rcu_s
 			smp_processor_id(), jiffies - rsp->gp_start);
 	trigger_all_cpu_backtrace();
 
-	spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if ((long)(jiffies - rsp->jiffies_stall) >= 0)
 		rsp->jiffies_stall =
 			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	set_need_resched();  /* kick ourselves to get things going. */
 }
@@ -563,12 +563,12 @@ static void note_new_gpnum(struct rcu_st
 	local_irq_save(flags);
 	rnp = rdp->mynode;
 	if (rdp->gpnum == ACCESS_ONCE(rnp->gpnum) || /* outside lock. */
-	    !spin_trylock(&rnp->lock)) { /* irqs already off, retry later. */
+	    !raw_spin_trylock(&rnp->lock)) { /* irqs already off, retry later. */
 		local_irq_restore(flags);
 		return;
 	}
 	__note_new_gpnum(rsp, rnp, rdp);
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -627,12 +627,12 @@ rcu_process_gp_end(struct rcu_state *rsp
 	local_irq_save(flags);
 	rnp = rdp->mynode;
 	if (rdp->completed == ACCESS_ONCE(rnp->completed) || /* outside lock. */
-	    !spin_trylock(&rnp->lock)) { /* irqs already off, retry later. */
+	    !raw_spin_trylock(&rnp->lock)) { /* irqs already off, retry later. */
 		local_irq_restore(flags);
 		return;
 	}
 	__rcu_process_gp_end(rsp, rnp, rdp);
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -681,10 +681,10 @@ rcu_start_gp(struct rcu_state *rsp, unsi
 		if (cpu_needs_another_gp(rsp, rdp))
 			rsp->fqs_need_gp = 1;
 		if (rnp->completed == rsp->completed) {
-			spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
 		}
-		spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
+		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
 
 		/*
 		 * Propagate new ->completed value to rcu_node structures
@@ -692,9 +692,9 @@ rcu_start_gp(struct rcu_state *rsp, unsi
 		 * of the next grace period to process their callbacks.
 		 */
 		rcu_for_each_node_breadth_first(rsp, rnp) {
-			spin_lock(&rnp->lock);	 /* irqs already disabled. */
+			raw_spin_lock(&rnp->lock);	 /* irqs already disabled. */
 			rnp->completed = rsp->completed;
-			spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		}
 		local_irq_restore(flags);
 		return;
@@ -715,15 +715,15 @@ rcu_start_gp(struct rcu_state *rsp, unsi
 		rnp->completed = rsp->completed;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		rcu_start_gp_per_cpu(rsp, rnp, rdp);
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 
-	spin_unlock(&rnp->lock);  /* leave irqs disabled. */
+	raw_spin_unlock(&rnp->lock);  /* leave irqs disabled. */
 
 
 	/* Exclude any concurrent CPU-hotplug operations. */
-	spin_lock(&rsp->onofflock);  /* irqs already disabled. */
+	raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
 
 	/*
 	 * Set the quiescent-state-needed bits in all the rcu_node
@@ -743,21 +743,21 @@ rcu_start_gp(struct rcu_state *rsp, unsi
 	 * irqs disabled.
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
-		spin_lock(&rnp->lock);		/* irqs already disabled. */
+		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
 		rnp->completed = rsp->completed;
 		if (rnp == rdp->mynode)
 			rcu_start_gp_per_cpu(rsp, rnp, rdp);
-		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
+		raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	}
 
 	rnp = rcu_get_root(rsp);
-	spin_lock(&rnp->lock);			/* irqs already disabled. */
+	raw_spin_lock(&rnp->lock);		/* irqs already disabled. */
 	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
-	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
-	spin_unlock_irqrestore(&rsp->onofflock, flags);
+	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
+	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
 /*
@@ -796,14 +796,14 @@ rcu_report_qs_rnp(unsigned long mask, st
 		if (!(rnp->qsmask & mask)) {
 
 			/* Our bit has already been cleared, so done. */
-			spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
 		}
 		rnp->qsmask &= ~mask;
 		if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
 
 			/* Other bits still set at this level, so done. */
-			spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
 		}
 		mask = rnp->grpmask;
@@ -813,10 +813,10 @@ rcu_report_qs_rnp(unsigned long mask, st
 
 			break;
 		}
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		rnp_c = rnp;
 		rnp = rnp->parent;
-		spin_lock_irqsave(&rnp->lock, flags);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		WARN_ON_ONCE(rnp_c->qsmask);
 	}
 
@@ -845,7 +845,7 @@ rcu_report_qs_rdp(int cpu, struct rcu_st
 	struct rcu_node *rnp;
 
 	rnp = rdp->mynode;
-	spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (lastcomp != rnp->completed) {
 
 		/*
@@ -857,12 +857,12 @@ rcu_report_qs_rdp(int cpu, struct rcu_st
 		 * race occurred.
 		 */
 		rdp->passed_quiesc = 0;	/* try again later! */
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 	mask = rdp->grpmask;
 	if ((rnp->qsmask & mask) == 0) {
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	} else {
 		rdp->qs_pending = 0;
 
@@ -926,7 +926,7 @@ static void rcu_send_cbs_to_orphanage(st
 
 	if (rdp->nxtlist == NULL)
 		return;  /* irqs disabled, so comparison is stable. */
-	spin_lock(&rsp->onofflock);  /* irqs already disabled. */
+	raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
 	*rsp->orphan_cbs_tail = rdp->nxtlist;
 	rsp->orphan_cbs_tail = rdp->nxttail[RCU_NEXT_TAIL];
 	rdp->nxtlist = NULL;
@@ -934,7 +934,7 @@ static void rcu_send_cbs_to_orphanage(st
 		rdp->nxttail[i] = &rdp->nxtlist;
 	rsp->orphan_qlen += rdp->qlen;
 	rdp->qlen = 0;
-	spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
+	raw_spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
 }
 
 /*
@@ -945,10 +945,10 @@ static void rcu_adopt_orphan_cbs(struct 
 	unsigned long flags;
 	struct rcu_data *rdp;
 
-	spin_lock_irqsave(&rsp->onofflock, flags);
+	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 	rdp = rsp->rda[smp_processor_id()];
 	if (rsp->orphan_cbs_list == NULL) {
-		spin_unlock_irqrestore(&rsp->onofflock, flags);
+		raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 		return;
 	}
 	*rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_list;
@@ -957,7 +957,7 @@ static void rcu_adopt_orphan_cbs(struct 
 	rsp->orphan_cbs_list = NULL;
 	rsp->orphan_cbs_tail = &rsp->orphan_cbs_list;
 	rsp->orphan_qlen = 0;
-	spin_unlock_irqrestore(&rsp->onofflock, flags);
+	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
 /*
@@ -973,23 +973,23 @@ static void __rcu_offline_cpu(int cpu, s
 	struct rcu_node *rnp;
 
 	/* Exclude any attempts to start a new grace period. */
-	spin_lock_irqsave(&rsp->onofflock, flags);
+	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 
 	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
 	rnp = rdp->mynode;	/* this is the outgoing CPU's rnp. */
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
 	do {
-		spin_lock(&rnp->lock);		/* irqs already disabled. */
+		raw_spin_lock(&rnp->lock);		/* irqs already disabled. */
 		rnp->qsmaskinit &= ~mask;
 		if (rnp->qsmaskinit != 0) {
 			if (rnp != rdp->mynode)
-				spin_unlock(&rnp->lock); /* irqs remain disabled. */
+				raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
 		if (rnp == rdp->mynode)
 			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
 		else
-			spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		mask = rnp->grpmask;
 		rnp = rnp->parent;
 	} while (rnp != NULL);
@@ -1000,12 +1000,12 @@ static void __rcu_offline_cpu(int cpu, s
 	 * because invoking rcu_report_unblock_qs_rnp() with ->onofflock
 	 * held leads to deadlock.
 	 */
-	spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
+	raw_spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
 	rnp = rdp->mynode;
 	if (need_report & RCU_OFL_TASKS_NORM_GP)
 		rcu_report_unblock_qs_rnp(rnp, flags);
 	else
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (need_report & RCU_OFL_TASKS_EXP_GP)
 		rcu_report_exp_rnp(rsp, rnp);
 
@@ -1176,13 +1176,13 @@ static void force_qs_rnp(struct rcu_stat
 
 	rcu_for_each_leaf_node(rsp, rnp) {
 		mask = 0;
-		spin_lock_irqsave(&rnp->lock, flags);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		if (!rcu_gp_in_progress(rsp)) {
-			spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
 		}
 		if (rnp->qsmask == 0) {
-			spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			continue;
 		}
 		cpu = rnp->grplo;
@@ -1197,7 +1197,7 @@ static void force_qs_rnp(struct rcu_stat
 			rcu_report_qs_rnp(mask, rsp, rnp, flags);
 			continue;
 		}
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 }
 
@@ -1212,7 +1212,7 @@ static void force_quiescent_state(struct
 
 	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
-	if (!spin_trylock_irqsave(&rsp->fqslock, flags)) {
+	if (!raw_spin_trylock_irqsave(&rsp->fqslock, flags)) {
 		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
 		return;	/* Someone else is already on the job. */
 	}
@@ -1220,11 +1220,11 @@ static void force_quiescent_state(struct
 	    (long)(rsp->jiffies_force_qs - jiffies) >= 0)
 		goto unlock_fqs_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
-	spin_lock(&rnp->lock);  /* irqs already disabled */
+	raw_spin_lock(&rnp->lock);  /* irqs already disabled */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
-		spin_unlock(&rnp->lock);  /* irqs remain disabled */
+		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 		goto unlock_fqs_ret;  /* no GP in progress, time updated. */
 	}
 	rsp->fqs_active = 1;
@@ -1236,13 +1236,13 @@ static void force_quiescent_state(struct
 
 	case RCU_SAVE_DYNTICK:
 
-		spin_unlock(&rnp->lock);  /* irqs remain disabled */
+		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
 		force_qs_rnp(rsp, dyntick_save_progress_counter);
-		spin_lock(&rnp->lock);  /* irqs already disabled */
+		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
 		if (rcu_gp_in_progress(rsp))
 			rsp->signaled = RCU_FORCE_QS;
 		break;
@@ -1250,24 +1250,24 @@ static void force_quiescent_state(struct
 	case RCU_FORCE_QS:
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
-		spin_unlock(&rnp->lock);  /* irqs remain disabled */
+		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
 
-		spin_lock(&rnp->lock);  /* irqs already disabled */
+		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
 		break;
 	}
 	rsp->fqs_active = 0;
 	if (rsp->fqs_need_gp) {
-		spin_unlock(&rsp->fqslock); /* irqs remain disabled */
+		raw_spin_unlock(&rsp->fqslock); /* irqs remain disabled */
 		rsp->fqs_need_gp = 0;
 		rcu_start_gp(rsp, flags); /* releases rnp->lock */
 		return;
 	}
-	spin_unlock(&rnp->lock);  /* irqs remain disabled */
+	raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 unlock_fqs_ret:
-	spin_unlock_irqrestore(&rsp->fqslock, flags);
+	raw_spin_unlock_irqrestore(&rsp->fqslock, flags);
 }
 
 #else /* #ifdef CONFIG_SMP */
@@ -1309,7 +1309,7 @@ __rcu_process_callbacks(struct rcu_state
 
 	/* Does this CPU require a not-yet-started grace period? */
 	if (cpu_needs_another_gp(rsp, rdp)) {
-		spin_lock_irqsave(&rcu_get_root(rsp)->lock, flags);
+		raw_spin_lock_irqsave(&rcu_get_root(rsp)->lock, flags);
 		rcu_start_gp(rsp, flags);  /* releases above lock */
 	}
 
@@ -1374,7 +1374,7 @@ __call_rcu(struct rcu_head *head, void (
 		unsigned long nestflag;
 		struct rcu_node *rnp_root = rcu_get_root(rsp);
 
-		spin_lock_irqsave(&rnp_root->lock, nestflag);
+		raw_spin_lock_irqsave(&rnp_root->lock, nestflag);
 		rcu_start_gp(rsp, nestflag);  /* releases rnp_root->lock. */
 	}
 
@@ -1664,7 +1664,7 @@ rcu_boot_init_percpu_data(int cpu, struc
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
-	spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
@@ -1674,7 +1674,7 @@ rcu_boot_init_percpu_data(int cpu, struc
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 #endif /* #ifdef CONFIG_NO_HZ */
 	rdp->cpu = cpu;
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -1692,7 +1692,7 @@ rcu_init_percpu_data(int cpu, struct rcu
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
-	spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
 	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
@@ -1700,7 +1700,7 @@ rcu_init_percpu_data(int cpu, struct rcu
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
-	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
+	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/*
 	 * A new grace period might start here.  If so, we won't be part
@@ -1708,14 +1708,14 @@ rcu_init_percpu_data(int cpu, struct rcu
 	 */
 
 	/* Exclude any attempts to start a new GP on large systems. */
-	spin_lock(&rsp->onofflock);		/* irqs already disabled. */
+	raw_spin_lock(&rsp->onofflock);		/* irqs already disabled. */
 
 	/* Add CPU to rcu_node bitmasks. */
 	rnp = rdp->mynode;
 	mask = rdp->grpmask;
 	do {
 		/* Exclude any attempts to start a new GP on small systems. */
-		spin_lock(&rnp->lock);	/* irqs already disabled. */
+		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rnp->qsmaskinit |= mask;
 		mask = rnp->grpmask;
 		if (rnp == rdp->mynode) {
@@ -1723,11 +1723,11 @@ rcu_init_percpu_data(int cpu, struct rcu
 			rdp->completed = rnp->completed;
 			rdp->passed_quiesc_completed = rnp->completed - 1;
 		}
-		spin_unlock(&rnp->lock); /* irqs already disabled. */
+		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
 		rnp = rnp->parent;
 	} while (rnp != NULL && !(rnp->qsmaskinit & mask));
 
-	spin_unlock_irqrestore(&rsp->onofflock, flags);
+	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
 static void __cpuinit rcu_online_cpu(int cpu)
@@ -1834,7 +1834,7 @@ static void __init rcu_init_one(struct r
 		cpustride *= rsp->levelspread[i];
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
-			spin_lock_init(&rnp->lock);
+			raw_spin_lock_init(&rnp->lock);
 			lockdep_set_class_and_name(&rnp->lock,
 						   &rcu_node_class[i], buf[i]);
 			rnp->gpnum = 0;
Index: linux-2.6-tip/kernel/rcutree.h
===================================================================
--- linux-2.6-tip.orig/kernel/rcutree.h
+++ linux-2.6-tip/kernel/rcutree.h
@@ -90,7 +90,7 @@ struct rcu_dynticks {
  * Definition for node within the RCU grace-period-detection hierarchy.
  */
 struct rcu_node {
-	spinlock_t lock;	/* Root rcu_node's lock protects some */
+	raw_spinlock_t lock;	/* Root rcu_node's lock protects some */
 				/*  rcu_state fields as well as following. */
 	long	gpnum;		/* Current grace period for this node. */
 				/*  This will either be equal to or one */
@@ -288,7 +288,7 @@ struct rcu_state {
 
 	/* End of fields guarded by root rcu_node's lock. */
 
-	spinlock_t onofflock;			/* exclude on/offline and */
+	raw_spinlock_t onofflock;		/* exclude on/offline and */
 						/*  starting new GP.  Also */
 						/*  protects the following */
 						/*  orphan_cbs fields. */
@@ -298,7 +298,7 @@ struct rcu_state {
 						/*  going offline. */
 	struct rcu_head **orphan_cbs_tail;	/* And tail pointer. */
 	long orphan_qlen;			/* Number of orphaned cbs. */
-	spinlock_t fqslock;			/* Only one task forcing */
+	raw_spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
Index: linux-2.6-tip/kernel/rcutree_plugin.h
===================================================================
--- linux-2.6-tip.orig/kernel/rcutree_plugin.h
+++ linux-2.6-tip/kernel/rcutree_plugin.h
@@ -111,7 +111,7 @@ static void rcu_preempt_note_context_swi
 		/* Possibly blocking in an RCU read-side critical section. */
 		rdp = rcu_preempt_state.rda[cpu];
 		rnp = rdp->mynode;
-		spin_lock_irqsave(&rnp->lock, flags);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
 		t->rcu_blocked_node = rnp;
 
@@ -132,7 +132,7 @@ static void rcu_preempt_note_context_swi
 		WARN_ON_ONCE(!list_empty(&t->rcu_node_entry));
 		phase = (rnp->gpnum + !(rnp->qsmask & rdp->grpmask)) & 0x1;
 		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
 	/*
@@ -189,7 +189,7 @@ static void rcu_report_unblock_qs_rnp(st
 	struct rcu_node *rnp_p;
 
 	if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;  /* Still need more quiescent states! */
 	}
 
@@ -206,8 +206,8 @@ static void rcu_report_unblock_qs_rnp(st
 
 	/* Report up the rest of the hierarchy. */
 	mask = rnp->grpmask;
-	spin_unlock(&rnp->lock);	/* irqs remain disabled. */
-	spin_lock(&rnp_p->lock);	/* irqs already disabled. */
+	raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
+	raw_spin_lock(&rnp_p->lock);	/* irqs already disabled. */
 	rcu_report_qs_rnp(mask, &rcu_preempt_state, rnp_p, flags);
 }
 
@@ -257,10 +257,10 @@ static void rcu_read_unlock_special(stru
 		 */
 		for (;;) {
 			rnp = t->rcu_blocked_node;
-			spin_lock(&rnp->lock);  /* irqs already disabled. */
+			raw_spin_lock(&rnp->lock);  /* irqs already disabled. */
 			if (rnp == t->rcu_blocked_node)
 				break;
-			spin_unlock(&rnp->lock);  /* irqs remain disabled. */
+			raw_spin_unlock(&rnp->lock);  /* irqs remain disabled. */
 		}
 		empty = !rcu_preempted_readers(rnp);
 		empty_exp = !rcu_preempted_readers_exp(rnp);
@@ -274,7 +274,7 @@ static void rcu_read_unlock_special(stru
 		 * Note that rcu_report_unblock_qs_rnp() releases rnp->lock.
 		 */
 		if (empty)
-			spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		else
 			rcu_report_unblock_qs_rnp(rnp, flags);
 
@@ -324,12 +324,12 @@ static void rcu_print_task_stall(struct 
 	struct task_struct *t;
 
 	if (rcu_preempted_readers(rnp)) {
-		spin_lock_irqsave(&rnp->lock, flags);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		phase = rnp->gpnum & 0x1;
 		lp = &rnp->blocked_tasks[phase];
 		list_for_each_entry(t, lp, rcu_node_entry)
 			printk(" P%d", t->pid);
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 }
 
@@ -400,11 +400,11 @@ static int rcu_preempt_offline_tasks(str
 		lp_root = &rnp_root->blocked_tasks[i];
 		while (!list_empty(lp)) {
 			tp = list_entry(lp->next, typeof(*tp), rcu_node_entry);
-			spin_lock(&rnp_root->lock); /* irqs already disabled */
+			raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
 			list_del(&tp->rcu_node_entry);
 			tp->rcu_blocked_node = rnp_root;
 			list_add(&tp->rcu_node_entry, lp_root);
-			spin_unlock(&rnp_root->lock); /* irqs remain disabled */
+			raw_spin_unlock(&rnp_root->lock); /* irqs remain disabled */
 		}
 	}
 	return retval;
@@ -528,7 +528,7 @@ static void rcu_report_exp_rnp(struct rc
 	unsigned long flags;
 	unsigned long mask;
 
-	spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	for (;;) {
 		if (!sync_rcu_preempt_exp_done(rnp))
 			break;
@@ -537,12 +537,12 @@ static void rcu_report_exp_rnp(struct rc
 			break;
 		}
 		mask = rnp->grpmask;
-		spin_unlock(&rnp->lock); /* irqs remain disabled */
+		raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
 		rnp = rnp->parent;
-		spin_lock(&rnp->lock); /* irqs already disabled */
+		raw_spin_lock(&rnp->lock); /* irqs already disabled */
 		rnp->expmask &= ~mask;
 	}
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -557,11 +557,11 @@ sync_rcu_preempt_exp_init(struct rcu_sta
 {
 	int must_wait;
 
-	spin_lock(&rnp->lock); /* irqs already disabled */
+	raw_spin_lock(&rnp->lock); /* irqs already disabled */
 	list_splice_init(&rnp->blocked_tasks[0], &rnp->blocked_tasks[2]);
 	list_splice_init(&rnp->blocked_tasks[1], &rnp->blocked_tasks[3]);
 	must_wait = rcu_preempted_readers_exp(rnp);
-	spin_unlock(&rnp->lock); /* irqs remain disabled */
+	raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
 	if (!must_wait)
 		rcu_report_exp_rnp(rsp, rnp);
 }
@@ -606,13 +606,13 @@ void synchronize_rcu_expedited(void)
 	/* force all RCU readers onto blocked_tasks[]. */
 	synchronize_sched_expedited();
 
-	spin_lock_irqsave(&rsp->onofflock, flags);
+	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 
 	/* Initialize ->expmask for all non-leaf rcu_node structures. */
 	rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) {
-		spin_lock(&rnp->lock); /* irqs already disabled. */
+		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
 		rnp->expmask = rnp->qsmaskinit;
-		spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
 
 	/* Snapshot current state of ->blocked_tasks[] lists. */
@@ -621,7 +621,7 @@ void synchronize_rcu_expedited(void)
 	if (NUM_RCU_NODES > 1)
 		sync_rcu_preempt_exp_init(rsp, rcu_get_root(rsp));
 
-	spin_unlock_irqrestore(&rsp->onofflock, flags);
+	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 
 	/* Wait for snapshotted ->blocked_tasks[] lists to drain. */
 	rnp = rcu_get_root(rsp);
@@ -756,7 +756,7 @@ static int rcu_preempted_readers(struct 
 /* Because preemptible RCU does not exist, no quieting of tasks. */
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 {
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */



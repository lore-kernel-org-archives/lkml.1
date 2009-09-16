Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbZIPX0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbZIPX0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760398AbZIPX0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:26:08 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47954 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbZIPX0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:26:07 -0400
Date: Wed, 16 Sep 2009 16:26:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RCU callbacks and TREE_PREEMPT_RCU
Message-ID: <20090916232609.GK6737@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1253110641.31751.92.camel@pc1117.cambridge.arm.com> <20090916152929.GA6737@linux.vnet.ibm.com> <1253115255.31751.96.camel@pc1117.cambridge.arm.com> <20090916154716.GC6737@linux.vnet.ibm.com> <20090916155719.GA10588@linux.vnet.ibm.com> <1253143186.9006.0.camel@queen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253143186.9006.0.camel@queen>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 01:19:46AM +0200, Eric Sesterhenn wrote:
> On Wed, 2009-09-16 at 08:57 -0700, Paul E. McKenney wrote:
> > On Wed, Sep 16, 2009 at 08:47:16AM -0700, Paul E. McKenney wrote:
> > > On Wed, Sep 16, 2009 at 04:34:15PM +0100, Catalin Marinas wrote:
> > > > On Wed, 2009-09-16 at 08:29 -0700, Paul E. McKenney wrote:
> > > > > On Wed, Sep 16, 2009 at 03:17:21PM +0100, Catalin Marinas wrote:
> > > > > > When TREE_PREEMPT_RCU is enabled, the rcu list traversing above fails
> > > > > > with access to 0x6b6b6b6b but it is fine with TREE_PREEMPT_RCU=n and
> > > > > > TREE_RCU=y. During clean-up, kmemleak objects should no longer be freed
> > > > > > by other means since kmemleak was disabled and all callbacks are
> > > > > > ignored. The system is a 900Mhz P3, 256MB RAM, CONFIG_SMP=n.
> > > > > > 
> > > > > > Is there something I'm doing wrong in kmemleak or a bug with RCU
> > > > > > preemption? The kernel oops looks like this:
> > > > > 
> > > > > From your description and the code above, I must suspect a bug with
> > > > > RCU preemption.  A new one, as the only bugs I am currently chasing
> > > > > involve NR_CPUS>32 (>64 on 64-bit systems).
> > > > > 
> > > > > CONFIG_SMP=n implies NR_CPUS==1 in your build, correct?
> > > > 
> > > > CONFIG_NR_CPUS=1.
> > > 
> > > I was afraid of that.  ;-)
> > 
> > PS to previous -- there -is- a bug in mainline for TREE_PREEMPT_RCU for
> > single-CPU operation, but it is with synchronize_rcu() rather than
> > call_rcu().  The fix is in tip/core/urgent, commit #366b04ca.  Or see
> > the following patch.
> > 
> > So, could you please give the following patch a try?
> 
> Sadly this does not fix the issue, is there any further information I
> can provide to you?

:-(

Would you be willing to give the attached diagnostic patch a go?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 2454999..211442c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -623,8 +623,8 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
-		rnp->qsmask = rnp->qsmaskinit;
 		rcu_preempt_check_blocked_tasks(rnp);
+		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
@@ -657,8 +657,8 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	rnp_end = &rsp->node[NUM_RCU_NODES];
 	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++) {
 		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
-		rnp_cur->qsmask = rnp_cur->qsmaskinit;
 		rcu_preempt_check_blocked_tasks(rnp);
+		rnp_cur->qsmask = rnp_cur->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
 		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
 	}
@@ -703,6 +703,7 @@ rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
 static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
 	__releases(rnp->lock)
 {
+	WARN_ON_ONCE(rsp->completed == rsp->gpnum);
 	rsp->completed = rsp->gpnum;
 	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
@@ -720,6 +721,8 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 	      unsigned long flags)
 	__releases(rnp->lock)
 {
+	struct rcu_node *rnp_c;
+
 	/* Walk up the rcu_node hierarchy. */
 	for (;;) {
 		if (!(rnp->qsmask & mask)) {
@@ -743,8 +746,10 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 			break;
 		}
 		spin_unlock_irqrestore(&rnp->lock, flags);
+		rnp_c = rnp;
 		rnp = rnp->parent;
 		spin_lock_irqsave(&rnp->lock, flags);
+		WARN_ON_ONCE(rnp_c->qsmask);
 	}
 
 	/*
@@ -853,7 +858,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	spin_lock_irqsave(&rsp->onofflock, flags);
 
 	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
-	rnp = rdp->mynode;
+	rnp = rdp->mynode;	/* this is the outgoing CPU's rnp. */
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
 	do {
 		spin_lock(&rnp->lock);		/* irqs already disabled. */
@@ -862,7 +867,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 			spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
-		rcu_preempt_offline_tasks(rsp, rnp);
+		rcu_preempt_offline_tasks(rsp, rnp, rdp);
 		mask = rnp->grpmask;
 		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index eb4bae3..2b996c3 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -206,7 +206,8 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 */
 		if (!empty && rnp->qsmask == 0 &&
 		    list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1])) {
-			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+			struct rcu_node *rnp_p;
+
 			if (rnp->parent == NULL) {
 				/* Only one rcu_node in the tree. */
 				cpu_quiet_msk_finish(&rcu_preempt_state, flags);
@@ -215,9 +216,10 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			/* Report up the rest of the hierarchy. */
 			mask = rnp->grpmask;
 			spin_unlock_irqrestore(&rnp->lock, flags);
-			rnp = rnp->parent;
-			spin_lock_irqsave(&rnp->lock, flags);
-			cpu_quiet_msk(mask, &rcu_preempt_state, rnp, flags);
+			rnp_p = rnp->parent;
+			spin_lock_irqsave(&rnp_p->lock, flags);
+			WARN_ON_ONCE(rnp->qsmask);
+			cpu_quiet_msk(mask, &rcu_preempt_state, rnp_p, flags);
 			return;
 		}
 		spin_unlock(&rnp->lock);
@@ -278,6 +280,7 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 {
 	WARN_ON_ONCE(!list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]));
+	WARN_ON_ONCE(rnp->qsmask);
 }
 
 /*
@@ -302,7 +305,8 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
  * The caller must hold rnp->lock with irqs disabled.
  */
 static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp)
+				      struct rcu_node *rnp,
+				      struct rcu_data *rdp)
 {
 	int i;
 	struct list_head *lp;
@@ -314,6 +318,9 @@ static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
 		WARN_ONCE(1, "Last CPU thought to be offlined?");
 		return;  /* Shouldn't happen: at least one CPU online. */
 	}
+	WARN_ON_ONCE(rnp != rdp->mynode &&
+		     (!list_empty(&rnp->blocked_tasks[0]) ||
+		      !list_empty(&rnp->blocked_tasks[1])));
 
 	/*
 	 * Move tasks up to root rcu_node.  Rely on the fact that the
@@ -489,7 +496,8 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
  * tasks that were blocked within RCU read-side critical sections.
  */
 static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp)
+				      struct rcu_node *rnp,
+				      struct rcu_data *rdp)
 {
 }
 

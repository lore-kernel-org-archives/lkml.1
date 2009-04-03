Return-Path: <linux-kernel-owner+w=401wt.eu-S1760410AbZDCB1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410AbZDCB1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZDCB1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:27:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50604 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbZDCB1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:27:35 -0400
Date: Thu, 2 Apr 2009 18:27:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, dipankar@in.ibm.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090403012733.GA26871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090321215109.717a3f12@infradead.org> <20090322051822.GG7148@linux.vnet.ibm.com> <20090321225318.5b25f0a7@infradead.org> <20090322165324.GH7148@linux.vnet.ibm.com> <20090322124632.5d5d6266@infradead.org> <20090322205212.GI7148@linux.vnet.ibm.com> <20090322154433.1b2cb1b1@infradead.org> <20090322230331.GM7148@linux.vnet.ibm.com> <20090322161637.056a43c5@infradead.org> <20090323012737.GO7148@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323012737.GO7148@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 06:27:37PM -0700, Paul E. McKenney wrote:
> On Sun, Mar 22, 2009 at 04:16:37PM -0700, Arjan van de Ven wrote:
> > On Sun, 22 Mar 2009 16:03:31 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

[ . . . ]

> > > But in any case, I will see what I can do about speeding up
> > > synchronize_rcu().  I will likely start with TREE_RCU, and I may need
> > > some sort of indication that boot is in progress.
> > 
> > system_state == SYSTEM_BOOTING is not a very elegant test but it works
> 
> Fair enough...  This would be until init, correct?

Here is a first attempt.  The idea is to accelerate grace-period
detection when all but one of the CPUs is in nohz state by checking
for nohz CPUs immediately upon starting a grace period, instead of
waiting for three jiffies in that case.  Lightly tested.

Not for inclusion.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 97ce315..77ce937 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -373,7 +373,26 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	return rcu_implicit_offline_qs(rdp);
 }
 
-#endif /* #ifdef CONFIG_SMP */
+/*
+ * If almost all the other CPUs are in dyntick-idle mode, invoke
+ * force_quiescent_state() in order to make the RCU grace period
+ * happen more quickly.  The main purpose is to speed up boot
+ * on multiprocessor machines with CONFIG_NO_HZ.
+ */
+static void accelerate_almost_idle(struct rcu_state *rsp)
+{
+	if (cpumask_weight(cpu_online_mask) -
+	    cpumask_weight(nohz_cpu_mask) <= 1)
+		force_quiescent_state(rsp, 0);
+}
+
+#else /* #ifdef CONFIG_SMP */
+
+static void accelerate_almost_idle(struct rcu_state *rsp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_SMP */
 
 #else /* #ifdef CONFIG_NO_HZ */
 
@@ -407,6 +426,10 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #endif /* #ifdef CONFIG_SMP */
 
+static void accelerate_almost_idle(struct rcu_state *rsp)
+{
+}
+
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
@@ -577,6 +600,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rnp->qsmask = rnp->qsmaskinit;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
+		accelerate_almost_idle(rsp);
 		return;
 	}
 
@@ -627,6 +651,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 
 	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
 	spin_unlock_irqrestore(&rsp->onofflock, flags);
+	accelerate_almost_idle(rsp);
 }
 
 /*

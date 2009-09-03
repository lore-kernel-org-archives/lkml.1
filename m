Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZICFO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZICFO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 01:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZICFO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 01:14:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47245 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbZICFO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 01:14:26 -0400
Date: Wed, 2 Sep 2009 22:14:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tree rcu: call_rcu scalability problem?
Message-ID: <20090903051427.GD7138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090902094835.GB12251@wotan.suse.de> <20090902122756.GC12251@wotan.suse.de> <1251919064.10394.25.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251919064.10394.25.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 09:17:44PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-09-02 at 14:27 +0200, Nick Piggin wrote:
> 
> > It seems like nearly 2/3 of the cost is here:
> >         /* Add the callback to our list. */
> >         *rdp->nxttail[RCU_NEXT_TAIL] = head; <<<
> >         rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
> > 
> > In loading the pointer to the next tail pointer. If I'm reading the profile
> > correctly. Can't see why that should be a probem though...
> > 
> > ffffffff8107dee0 <__call_rcu>: /* __call_rcu total: 320971 100.000 */
> >    697  0.2172 :ffffffff8107dee0:       push   %r12
> 
> >    921  0.2869 :ffffffff8107df57:       push   %rdx
> >    151  0.0470 :ffffffff8107df58:       popfq
> > 183507 57.1725 :ffffffff8107df59:       mov    0x50(%rbx),%rax
> >    995  0.3100 :ffffffff8107df5d:       mov    %rdi,(%rax)
> 
> I'd guess at popfq to be the expensive op here.. skid usually causes the
> attribution to be a few ops down the line.

I believe that Nick's workload is routinely driving the number of
callbacks queued on a given CPU above 10,000, which would provoke numerous
(and possibly inlined) calls to force_quiescent_state().  Like about
400,000 such calls per second.  Hey, I was naively assuming that no one
would see more than 10,000 callbacks queued on a single CPU unless there
was some sort of major emergency underway, and coded accordingly.  ;-)

I offer the attached experimental (untested, might not even compile) patch.

							Thanx, Paul

------------------------------------------------------------------------

>From 0544d2da54bad95556a320e57658e244cb2ae8c6 Mon Sep 17 00:00:00 2001
From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date: Wed, 2 Sep 2009 22:01:50 -0700
Subject: [PATCH] Remove grace-period machinery from rcutree __call_rcu()

The grace-period machinery in __call_rcu() was a failed attempt to avoid
implementing synchronize_rcu_expedited().  But now that this attempt has
failed, try removing the machinery.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d2a372f..104de9e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1201,26 +1201,14 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 */
 	local_irq_save(flags);
 	rdp = rsp->rda[smp_processor_id()];
-	rcu_process_gp_end(rsp, rdp);
-	check_for_new_grace_period(rsp, rdp);
 
 	/* Add the callback to our list. */
 	*rdp->nxttail[RCU_NEXT_TAIL] = head;
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 
-	/* Start a new grace period if one not already started. */
-	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum)) {
-		unsigned long nestflag;
-		struct rcu_node *rnp_root = rcu_get_root(rsp);
-
-		spin_lock_irqsave(&rnp_root->lock, nestflag);
-		rcu_start_gp(rsp, nestflag);  /* releases rnp_root->lock. */
-	}
-
 	/* Force the grace period if too many callbacks or too long waiting. */
 	if (unlikely(++rdp->qlen > qhimark)) {
 		rdp->blimit = LONG_MAX;
-		force_quiescent_state(rsp, 0);
 	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
 		force_quiescent_state(rsp, 1);
 	local_irq_restore(flags);
-- 
1.5.2.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZIQWVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZIQWVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZIQWVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:21:20 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40624 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZIQWVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:21:19 -0400
Date: Thu, 17 Sep 2009 15:21:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RCU callbacks and TREE_PREEMPT_RCU
Message-ID: <20090917222123.GF6766@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1253110641.31751.92.camel@pc1117.cambridge.arm.com> <20090916152929.GA6737@linux.vnet.ibm.com> <1253115255.31751.96.camel@pc1117.cambridge.arm.com> <20090916154716.GC6737@linux.vnet.ibm.com> <20090916155719.GA10588@linux.vnet.ibm.com> <1253143186.9006.0.camel@queen> <20090916232609.GK6737@linux.vnet.ibm.com> <1253176142.3615.3.camel@queen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253176142.3615.3.camel@queen>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:29:02AM +0200, Eric Sesterhenn wrote:
> On Wed, 2009-09-16 at 16:26 -0700, Paul E. McKenney wrote:
> > On Thu, Sep 17, 2009 at 01:19:46AM +0200, Eric Sesterhenn wrote:
> > > On Wed, 2009-09-16 at 08:57 -0700, Paul E. McKenney wrote:
> > > > On Wed, Sep 16, 2009 at 08:47:16AM -0700, Paul E. McKenney wrote:
> > > > > On Wed, Sep 16, 2009 at 04:34:15PM +0100, Catalin Marinas wrote:
> > > > > > On Wed, 2009-09-16 at 08:29 -0700, Paul E. McKenney wrote:
> > > > > > > On Wed, Sep 16, 2009 at 03:17:21PM +0100, Catalin Marinas wrote:
> > > > > > > > When TREE_PREEMPT_RCU is enabled, the rcu list traversing above fails
> > > > > > > > with access to 0x6b6b6b6b but it is fine with TREE_PREEMPT_RCU=n and
> > > > > > > > TREE_RCU=y. During clean-up, kmemleak objects should no longer be freed
> > > > > > > > by other means since kmemleak was disabled and all callbacks are
> > > > > > > > ignored. The system is a 900Mhz P3, 256MB RAM, CONFIG_SMP=n.
> > > > > > > > 
> > > > > > > > Is there something I'm doing wrong in kmemleak or a bug with RCU
> > > > > > > > preemption? The kernel oops looks like this:
> > > > > > > 
> > > > > > > From your description and the code above, I must suspect a bug with
> > > > > > > RCU preemption.  A new one, as the only bugs I am currently chasing
> > > > > > > involve NR_CPUS>32 (>64 on 64-bit systems).
> > > > > > > 
> > > > > > > CONFIG_SMP=n implies NR_CPUS==1 in your build, correct?
> > > > > > 
> > > > > > CONFIG_NR_CPUS=1.
> > > > > 
> > > > > I was afraid of that.  ;-)
> > > > 
> > > > PS to previous -- there -is- a bug in mainline for TREE_PREEMPT_RCU for
> > > > single-CPU operation, but it is with synchronize_rcu() rather than
> > > > call_rcu().  The fix is in tip/core/urgent, commit #366b04ca.  Or see
> > > > the following patch.
> > > > 
> > > > So, could you please give the following patch a try?
> > > 
> > > Sadly this does not fix the issue, is there any further information I
> > > can provide to you?
> > 
> > :-(
> > 
> > Would you be willing to give the attached diagnostic patch a go?
> > 
> > 							Thanx, Paul
> 
> It does not apply cleanly against current -git
> (rcu_preempt_check_blocked_tasks is missing in my rcutree_plugin.h for
> example) I tried to apply it by hand as good as possible, and will test
> it today.
> 
> root@whiterabbit:/usr/src/linux# patch -p1 < ~/RCU_callbacks_and_TREE_PREEMPT_RCU-debug
> patching file kernel/rcutree.c
> Hunk #1 FAILED at 623.
> Hunk #2 FAILED at 657.
> Hunk #3 succeeded at 722 (offset 19 lines).
> Hunk #4 succeeded at 740 (offset 19 lines).
> Hunk #5 succeeded at 765 (offset 19 lines).
> Hunk #6 succeeded at 877 (offset 19 lines).
> Hunk #7 succeeded at 886 (offset 19 lines).
> 2 out of 7 hunks FAILED -- saving rejects to file kernel/rcutree.c.rej
> patching file kernel/rcutree_plugin.h
> Hunk #1 FAILED at 206.
> Hunk #2 succeeded at 206 (offset -10 lines).
> Hunk #3 FAILED at 270.
> Hunk #4 succeeded at 283 (offset -22 lines).
> Hunk #5 succeeded at 296 (offset -22 lines).
> Hunk #6 succeeded at 473 (offset -23 lines).
> 2 out of 6 hunks FAILED -- saving rejects to file
> kernel/rcutree_plugin.h.rej

Sigh!!!  I lost track of what was in mainline vs. -tip.  You certainly
need the following patch from -tip as well.

Please accept apologies for my confusion!!!

							Thanx, Paul

------------------------------------------------------------------------

Commit-ID:  de078d875cc7fc709f7818f26d38389c04369826
Gitweb:     http://git.kernel.org/tip/de078d875cc7fc709f7818f26d38389c04369826
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 8 Sep 2009 15:54:36 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 00:04:54 +0200

rcu: Need to update rnp->gpnum if preemptable RCU is to be reliable

Without this patch, tasks preempted in RCU read-side critical
sections can fail to block the grace period, given that
rnp->gpnum is used to determine which rnp->blocked_tasks[]
element the preempted task is enqueued on.

Before the patch, rnp->gpnum is always zero, so preempted tasks
are always enqueued on rnp->blocked_tasks[0], which is correct
only when the current CPU has not checked into the current
grace period and the grace-period number is even, or,
similarly, if the current CPU -has- checked into the current
grace period and the grace-period number is odd.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
LKML-Reference: <12524504771622-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6b11b07..c634a92 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -632,6 +632,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
 		rnp->qsmask = rnp->qsmaskinit;
+		rnp->gpnum = rsp->gpnum;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
@@ -657,8 +658,10 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 */

 	rnp_end = rsp->level[NUM_RCU_LVLS - 1];
-	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++)
+	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++) {
 		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		rnp->gpnum = rsp->gpnum;
+	}

 	/*
 	 * Now set up the leaf nodes.  Here we must be careful.  First,
@@ -679,6 +682,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	for (; rnp_cur < rnp_end; rnp_cur++) {
 		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
 		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		rnp->gpnum = rsp->gpnum;
 		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


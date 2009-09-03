Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZICN25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZICN25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZICN24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:28:56 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38558 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbZICN24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:28:56 -0400
Date: Thu, 3 Sep 2009 06:28:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tree rcu: call_rcu scalability problem?
Message-ID: <20090903132857.GF7138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090902094835.GB12251@wotan.suse.de> <20090902122756.GC12251@wotan.suse.de> <1251919064.10394.25.camel@laptop> <20090903051427.GD7138@linux.vnet.ibm.com> <20090903090126.GG979@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903090126.GG979@wotan.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 11:01:26AM +0200, Nick Piggin wrote:
> On Wed, Sep 02, 2009 at 10:14:27PM -0700, Paul E. McKenney wrote:
> > >From 0544d2da54bad95556a320e57658e244cb2ae8c6 Mon Sep 17 00:00:00 2001
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Date: Wed, 2 Sep 2009 22:01:50 -0700
> > Subject: [PATCH] Remove grace-period machinery from rcutree __call_rcu()
> > 
> > The grace-period machinery in __call_rcu() was a failed attempt to avoid
> > implementing synchronize_rcu_expedited().  But now that this attempt has
> > failed, try removing the machinery.
> 
> OK, the workload is parallel processes performing a close(open()) loop
> in a tmpfs filesystem within different cwds (to avoid contention on the
> cwd dentry). The kernel is first patched with my vfs scalability patches,
> so the comparison is with/without Paul's rcu patch.
> 
> System is 2s8c opteron, with processes bound to CPUs (first within the
> same socket, then over both sockets as count increases).
> 
> procs  tput-base          tput-rcu
> 1         595238 (x1.00)    645161 (x1.00)
> 2        1041666 (x1.75)   1136363 (x1.76)
> 4        1960784 (x3.29)   2298850 (x3.56)
> 8        3636363 (x6.11)   4545454 (x7.05)
> 
> Scalability is improved (from 2-8 way it is now actually linear), and
> single thread performance is significantly improved too.
> 
> oprofile results collecting clk unhalted samples shows the following
> results for __call_rcu symbol:
> 
> procs  samples  %        app name                 symbol name
> tput-base
> 1      12153     3.8122  vmlinux                  __call_rcu
> 2      29253     3.9899  vmlinux                  __call_rcu
> 4      84503     5.4667  vmlinux                  __call_rcu
> 8      312816    9.5287  vmlinux                  __call_rcu
> 
> tput-rcu
> 1      8722      2.8770  vmlinux                  __call_rcu
> 2      17275     2.5804  vmlinux                  __call_rcu
> 4      33848     2.6015  vmlinux                  __call_rcu
> 8      67158     2.5561  vmlinux                  __call_rcu
> 
> Scaling is cearly much better (it is more important to look at absolute
> samples because %age is dependent on other parts of the kernel too).
> 
> Feel free to add any of this to your changelog if you think it's important.

Very cool!!!

I got a dissenting view from the people trying to get rid of interrupts
in computational workloads.  But I believe that it is possible to
split the difference, getting you almost all the performance benefits
while still permitting them to turn off the scheduling-clock interrupt.
The reason that I believe it should get you the performance benefits is
that deleting the rcu_process_gp_end() and check_for_new_grace_period()
didn't do much for you.  Their overhead is quite small compared to
hammering the system with a full set of IPIs every ten microseconds
or so.  ;-)

So could you please give the following experimental patch a go?
If it works for you, I will put together a production-ready patch
along these lines.

							Thanx, Paul

------------------------------------------------------------------------

>From 57b7f98303a5c5aa50648c71758760006af49bab Mon Sep 17 00:00:00 2001
From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date: Thu, 3 Sep 2009 06:19:45 -0700
Subject: [PATCH] Reduce grace-period-encouragement impact on rcutree __call_rcu()

Remove only the emergency force_quiescent_state() from __call_rcu(),
which should get most of the reduction in overhead while still
allowing the tick to be turned off when non-idle, as proposed in
http://lkml.org/lkml/2009/9/1/229, and which reduced interrupts to
one per ten seconds in a CPU-bound computational workload according to
http://lkml.org/lkml/2009/9/3/7.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d2a372f..4c8e0d2 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1220,7 +1220,6 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	/* Force the grace period if too many callbacks or too long waiting. */
 	if (unlikely(++rdp->qlen > qhimark)) {
 		rdp->blimit = LONG_MAX;
-		force_quiescent_state(rsp, 0);
 	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
 		force_quiescent_state(rsp, 1);
 	local_irq_restore(flags);
-- 
1.5.2.5


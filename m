Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbZI1Ger@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbZI1Ger (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 02:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZI1Ger
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 02:34:47 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52069 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZI1Geq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 02:34:46 -0400
Date: Sun, 27 Sep 2009 21:35:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 2/2] rcu: Apply review feedback from Josh
	Triplett, part 4
Message-ID: <20090928043513.GD6282@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090927064753.GA9394@linux.vnet.ibm.com> <20090927153107.GA2445@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927153107.GA2445@feather>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 08:31:08AM -0700, Josh Triplett wrote:
> On Sat, Sep 26, 2009 at 11:49:51PM -0700, Paul E. McKenney wrote:
> > These issues identified during an old-fashioned face-to-face code
> > review extending over many hours.  This group improves an existing
> > abstraction and introduces two new ones.
> > 
> > o	Make RCU_INIT_FLAVOR() declare its own variables, removing
> > 	the need to declare them at each call site.
> > 
> > o	Create an rcu_for_each_leaf() macro that scans the leaf nodes
> > 	of the rcu_node tree.
> > 
> > o	Create an rcu_for_each_node_breadth_first() macro that does
> > 	a breadth-first traversal of the rcu_node tree, AKA stepping
> > 	through the array in index-number order.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> I noticed one bit of unrelated code in this patch, which the commit
> message doesn't mention:

Good point -- this was not from our code review, but rather from my
mini-code-review introducing the relevant fixes.

> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> [...]
> > @@ -473,18 +471,24 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
> >  		return;
> >  	}
> >  	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
> > +
> > +	/*
> > +	 * Now rat on any tasks that got kicked up to the root rcu_node
> > +	 * due to CPU offlining.
> > +	 */
> > +	rcu_print_task_stall(rnp);
> >  	spin_unlock_irqrestore(&rnp->lock, flags);

The old code only checked for tasks blocked in RCU read-side critical
sections that were queued in the leaves of the rcu_node tree.  Of
course, if all of the CPUs corresponding to a given rcu_node leaf have
gone offline since the tasks where queued, then they are moved to the
root rcu_node structure.  So we need to check for stalled tasks in the
root rcu_node structure as well in the leaf rcu_node structures.

						Thanx, Paul

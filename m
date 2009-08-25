Return-Path: <linux-kernel-owner+w=401wt.eu-S932395AbZHYXa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbZHYXa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932336AbZHYXa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:30:27 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36975 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312AbZHYXa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:30:27 -0400
Date: Tue, 25 Aug 2009 16:30:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH -tip] Create rcutree plugins to handle hotplug CPU for
	multi-level trees
Message-ID: <20090825233027.GO6616@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090825182204.GA26736@linux.vnet.ibm.com> <1251225483.2706.4.camel@josh-work.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251225483.2706.4.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 11:38:03AM -0700, Josh Triplett wrote:
> On Tue, 2009-08-25 at 11:22 -0700, Paul E. McKenney wrote:
> > When offlining CPUs from a multi-level tree, there is the possibility
> > of offlining the last CPU from a given node when there are preempted
> > RCU read-side critical sections that started life on one of the CPUs on
> > that node.  In this case, the corresponding tasks will be enqueued via
> > the task_struct's rcu_node_entry list_head onto one of the rcu_node's
> > blocked_tasks[] lists.  These tasks need to be moved somewhere else
> > so that they will prevent the current grace period from ending.
> > That somewhere is the root rcu_node.
> > 
> > With this patch, TREE_PREEMPT_RCU passes moderate rcutorture testing
> > with aggressive CPU-hotplugging (no delay between inserting/removing
> > randomly selected CPU).
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Looks good.  One comment below.
> 
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1208,7 +1208,7 @@ struct task_struct {
> >  #ifdef CONFIG_TREE_PREEMPT_RCU
> >  	int rcu_read_lock_nesting;
> >  	char rcu_read_unlock_special;
> > -	int rcu_blocked_cpu;
> > +	void *rcu_blocked_node;
> 
> This should use struct rcu_node *, not void *.  That would eliminate
> several casts in the changes below.  You can forward-declare struct
> rcu_node if you want to avoid including RCU headers in sched.h.

Good point -- it would be nice to avoid the casts.

> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -92,7 +92,7 @@ static void rcu_preempt_qs(int cpu)
> >  		rnp = rdp->mynode;
> >  		spin_lock(&rnp->lock);
> >  		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
> > -		t->rcu_blocked_cpu = cpu;
> > +		t->rcu_blocked_node = (void *)rnp;
> 
> Regardless of whether you change the type in the structure, you never
> need to cast a pointer to type void *; any non-function pointer will
> become void * without complaint.
> 
> > @@ -170,12 +170,21 @@ static void rcu_read_unlock_special(struct task_struct *t)
> >  	if (special & RCU_READ_UNLOCK_BLOCKED) {
> >  		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
> > 
> > -		/* Remove this task from the list it blocked on. */
> > -		rnp = rcu_preempt_state.rda[t->rcu_blocked_cpu]->mynode;
> > -		spin_lock(&rnp->lock);
> > +		/*
> > +		 * Remove this task from the list it blocked on.  The
> > +		 * task can migrate while we acquire the lock, but at
> > +		 * most one time.  So at most two passes through loop.
> > +		 */
> > +		for (;;) {
> > +			rnp = (struct rcu_node *)t->rcu_blocked_node;
> > +			spin_lock(&rnp->lock);
> > +			if (rnp == (struct rcu_node *)t->rcu_blocked_node)
> > +				break;
> > +			spin_unlock(&rnp->lock);
> > +		}
> 
> Both of the casts of t->rcu_blocked_node can go away here, given the
> type change in the structure.

Indeed.  Fixed, will submit early tomorrow.

							Thanx, Paul

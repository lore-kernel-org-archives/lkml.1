Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbZHYXvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbZHYXvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932692AbZHYXvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:51:05 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40387 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691AbZHYXvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:51:03 -0400
Date: Tue, 25 Aug 2009 16:51:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH -tip] Create rcutree plugins to handle hotplug CPU for
	multi-level trees
Message-ID: <20090825235104.GP6616@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090825182204.GA26736@linux.vnet.ibm.com> <20090825184800.GD2448@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825184800.GD2448@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 02:48:00PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
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
> > ---
> [...]
> >  /*
> > + * Handle tasklist migration for case in which all CPUs covered by the
> > + * specified rcu_node have gone offline.  Move them up to the root
> > + * rcu_node.  The reason for not just moving them to the immediate
> > + * parent is to remove the need for rcu_read_unlock_special() to
> > + * make more than two attempts to acquire the target rcu_node's lock.
> > + *
> > + * The caller must hold rnp->lock with irqs disabled.
> > + */
> > +static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
> > +				      struct rcu_node *rnp)
> > +{
> > +	int i;
> > +	struct list_head *lp;
> > +	struct list_head *lp_root;
> > +	struct rcu_node *rnp_root = rcu_get_root(rsp);
> > +	struct task_struct *tp;
> > +
> > +	if (rnp == rnp_root)
> > +		return;  /* Shouldn't happen: at least one CPU online. */
> > +
> 
> Hrm, is it "shouldn't happen" or "could be called, but we should not
> move anything" ?
> 
> If it is really the former, we could put a WARN_ON_ONCE (or, more
> aggressively, a BUG_ON) there and see when the caller is going crazy
> rather than ignoring the error.

The only way this could happen is if we managed to offline the last CPU.
Which does raise the question as to exactly what would be executing
this code, doesn't it?  ;-)

So, yes, WARN_ON_ONCE() seems reasonable here.  Or perhaps WARN_ONCE().

I added a WARN_ONCE().  Will send patch later.

> > +	/*
> > +	 * Move tasks up to root rcu_node.  Rely on the fact that the
> > +	 * root rcu_node can be at most one ahead of the rest of the
> > +	 * rcu_nodes in terms of gp_num value.
> 
> Do you gather the description of such constraints in a central place
> somewhere around the code or design documentation in the kernel tree ?
> I just want to point out that every clever assumption like this, which
> is based on the constraints imposed by the current design, should be
> easy to list in a year from now if we ever decide to move from tree to
> hashed RCU (or whichever next step will be necessary then).

Interesting point...  The LWN article doesn't get to this level of
detail (http://lwn.net/Articles/305782/), and in any case struct
rcu_node didn't have a gpnum when that article was written.

For the moment, I added a comment to the ->gpnum field's comment.

> I am just worried that migration helpers seems to be added to the design
> as an afterthought, and therefore might make future evolution more
> difficult.

Ah!

No, this limitation is inherent, at least for any rcu_node covering at
least one online CPU.  The root rcu_node's ->gpnum field cannot advance
until all subordinate nodes' ->gpnum fields have caught up, as this
defines a grace period.

As to the case of the rcu_node that has no online CPUs, such nodes had
better not be able to have additional CPUs go offline, as the code is in
no shape to tolerate negative numbers of online CPUs per node.  Nor do
I plan to add support for this situation.  ;-)

							Thanx, Paul

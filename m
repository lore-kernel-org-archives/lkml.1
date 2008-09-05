Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbYIEXyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbYIEXyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYIEXyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:54:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbYIEXyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:54:08 -0400
Date: Fri, 5 Sep 2008 16:52:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       manfred@colorfullife.com, dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       penberg@cs.helsinki.fi, andi@firstfloor.org
Subject: Re: [PATCH, RFC] v4 scalable classic RCU implementation
Message-Id: <20080905165235.c086581e.akpm@linux-foundation.org>
In-Reply-To: <20080905230411.GC6737@linux.vnet.ibm.com>
References: <20080821234318.GA1754@linux.vnet.ibm.com>
	<20080825000738.GA24339@linux.vnet.ibm.com>
	<20080830004935.GA28548@linux.vnet.ibm.com>
	<20080905152930.GA8124@linux.vnet.ibm.com>
	<20080905123340.bbb26f27.akpm@linux-foundation.org>
	<20080905230411.GC6737@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 16:04:11 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>
> ...
>
> > > +#if (NR_CPUS) <= RCU_FANOUT
> > > +#  define NUM_RCU_LVLS	      1
> > > +#  define NUM_RCU_LVL_0	      1
> > > +#  define NUM_RCU_LVL_1	      (NR_CPUS)
> > > +#  define NUM_RCU_LVL_2	      0
> > > +#  define NUM_RCU_LVL_3	      0
> > > +#elif (NR_CPUS) <= RCU_FANOUT_SQ
> > > +#  define NUM_RCU_LVLS	      2
> > > +#  define NUM_RCU_LVL_0	      1
> > > +#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
> > > +#  define NUM_RCU_LVL_2	      (NR_CPUS)
> > > +#  define NUM_RCU_LVL_3	      0
> > > +#elif (NR_CPUS) <= RCU_FANOUT_CUBE
> > > +#  define NUM_RCU_LVLS	      3
> > > +#  define NUM_RCU_LVL_0	      1
> > > +#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
> > > +#  define NUM_RCU_LVL_2	      (((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
> > > +#  define NUM_RCU_LVL_3	      NR_CPUS
> > > +#else
> > > +# error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
> > > +#endif /* #if (NR_CPUS) <= RCU_FANOUT */
> > 
> > Using NR_CPUS for anything at all is grossly, grossly inaccurate. 
> > Vendors can and will ship kernels with NR_CPUS=1024 and their customers
> > can and will run those kernels on 4-cpu machines.  Lots of customers.
> > 
> > That's a two-and-a-half-order-of-magnitude inaccuracy.  It makes all
> > your above work meaningless.
> > 
> > To be useful, these decisions should be made at runtime.
> 
> I agree in principle, but this case is an exception.
> 
> Suppose that we have NR_CPUS=1024 on a 4-CPU 64-bit machine.  Since 64^2
> is greater than 1024, we end up with a two-level hierarchy, with one
> rcu_node structure at the root and 16 rcu_node leaf structures, each
> of which takes up a single 128-byte cache line.  There will be two such
> structures in the system, one for rcu and one for rcu_bh.
> 
> So I do not believe that this will be a problem.
> 
> One laptops, this is even less of an issue -- NR_CPUS=8 on my laptop,
> which would reduce to a pair rcu_node structures, one for rcu, the other
> for rcu_bh.

Is it likely that anyone will ship kernels with NR_CPUS=8?  What are
distros presently using, and what will they be using 1-2 years hence?

> Making the decision at runtime would bloat the code by much more than the
> extra data consumed.  And introduce yet more races between online/offline
> and everything else.  Besides, this way I am being bloat-compatible
> with DEFINE_PER_CPU().  ;-)
> 
> > > +#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
> > > +#define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
> > > +
> > > +/*
> > > + * Definition for node within the RCU grace-period-detection hierarchy.
> > > + */
> > > +struct rcu_node {
> > > +	spinlock_t lock;
> > > +	unsigned long qsmask;	/* CPUs or groups that need to switch in */
> > > +				/*  order for current grace period to proceed.*/
> > > +	unsigned long qsmaskinit;
> > > +				/* Per-GP initialization for qsmask. */
> > > +	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
> > > +	int	grplo;		/* lowest-numbered CPU or group here. */
> > > +	int	grphi;		/* highest-numbered CPU or group here. */
> > > +	u8	grpnum;		/* CPU/group number for next level up. */
> > > +	u8	level;		/* root is at level 0. */
> > > +	struct rcu_node *parent;
> > > +} ____cacheline_internodealigned_in_smp;
> > 
> > So this is a 4096-byte structure on some setups.
> 
> You lost me on this one.  On a 64-bit system, I have 8 bytes each for
> lock, qsmask, qsmaskinit, grpmask, and parent, four bytes each for grplo
> and grphi, and another byte each for grpnum and level, for a total of
> 50 bytes for each struct rcu_node, which comes to a single cache line
> for most large system.  Given the default CONFIG_RCU_FANOUT=64 and
> NR_CPUS=4096, we have a two-level hierarchy with one root rcu_node
> structure and 64 leaf rcu_node structures.  This gives a total of
> 65 cache lines.

____cacheline_internodealigned_in_smp will expand this structure to
4096 bytes on CONFIG_X86_VSMP=y.

> > It's a pretty big pill to swallow.  Nice performance testing results
> > will help it to slide down.
> 
> Well, the read side is easy -- exactly the same code sequence as for
> Classic RCU.  On the update side, this is more of a bug fix for large
> numbers of CPUs, where unadorned Classic RCU is said to suffer terminal
> lock contention.  I will see what I can come up with, but at the end of
> the day, this will need some testing on machines larger than the 128-CPU
> systems that I have access to.
> 

OK, thanks.  As it's effectively a bugfix, a full description of the
bug would grease some wheels.


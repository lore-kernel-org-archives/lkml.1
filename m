Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbYIGS2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbYIGS2x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 14:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbYIGS2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 14:28:17 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53403 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbYIGS2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 14:28:14 -0400
Date: Fri, 5 Sep 2008 21:16:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       manfred@colorfullife.com, dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       penberg@cs.helsinki.fi, andi@firstfloor.org
Subject: Re: [PATCH, RFC] v4 scalable classic RCU implementation
Message-ID: <20080906041627.GA6843@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080905123340.bbb26f27.akpm@linux-foundation.org> <20080905230411.GC6737@linux.vnet.ibm.com> <20080905165235.c086581e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905165235.c086581e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 04:52:35PM -0700, Andrew Morton wrote:
> On Fri, 5 Sep 2008 16:04:11 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >
> > ...
> >
> > > > +#if (NR_CPUS) <= RCU_FANOUT
> > > > +#  define NUM_RCU_LVLS	      1
> > > > +#  define NUM_RCU_LVL_0	      1
> > > > +#  define NUM_RCU_LVL_1	      (NR_CPUS)
> > > > +#  define NUM_RCU_LVL_2	      0
> > > > +#  define NUM_RCU_LVL_3	      0
> > > > +#elif (NR_CPUS) <= RCU_FANOUT_SQ
> > > > +#  define NUM_RCU_LVLS	      2
> > > > +#  define NUM_RCU_LVL_0	      1
> > > > +#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
> > > > +#  define NUM_RCU_LVL_2	      (NR_CPUS)
> > > > +#  define NUM_RCU_LVL_3	      0
> > > > +#elif (NR_CPUS) <= RCU_FANOUT_CUBE
> > > > +#  define NUM_RCU_LVLS	      3
> > > > +#  define NUM_RCU_LVL_0	      1
> > > > +#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
> > > > +#  define NUM_RCU_LVL_2	      (((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
> > > > +#  define NUM_RCU_LVL_3	      NR_CPUS
> > > > +#else
> > > > +# error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
> > > > +#endif /* #if (NR_CPUS) <= RCU_FANOUT */
> > > 
> > > Using NR_CPUS for anything at all is grossly, grossly inaccurate. 
> > > Vendors can and will ship kernels with NR_CPUS=1024 and their customers
> > > can and will run those kernels on 4-cpu machines.  Lots of customers.
> > > 
> > > That's a two-and-a-half-order-of-magnitude inaccuracy.  It makes all
> > > your above work meaningless.
> > > 
> > > To be useful, these decisions should be made at runtime.
> > 
> > I agree in principle, but this case is an exception.
> > 
> > Suppose that we have NR_CPUS=1024 on a 4-CPU 64-bit machine.  Since 64^2
> > is greater than 1024, we end up with a two-level hierarchy, with one
> > rcu_node structure at the root and 16 rcu_node leaf structures, each
> > of which takes up a single 128-byte cache line.  There will be two such
> > structures in the system, one for rcu and one for rcu_bh.
> > 
> > So I do not believe that this will be a problem.
> > 
> > One laptops, this is even less of an issue -- NR_CPUS=8 on my laptop,
> > which would reduce to a pair rcu_node structures, one for rcu, the other
> > for rcu_bh.
> 
> Is it likely that anyone will ship kernels with NR_CPUS=8?  What are
> distros presently using, and what will they be using 1-2 years hence?

Ubuntu Feisty ships with NR_CPUS=8, but yes, I imagine that this number
will increase.  Perhaps a table for 64-bit CPUs:

			 Cachelines per	      Total
       NR_CPUs		 Implementation	    Cachelines

	1-64			 1		 2	[laptop distros]
       65-128			 3		 6	[x86 distros, Power]
      129-192			 4		 8
      193-256			 5		10
      257-320			 6		12
      321-384			 7		14
      385-448			 8		16
      449-512			 9		18	[SGI ca. 2004]
      513-576			10		20
      577-640			11		22
      641-704			12		24
      705-768			13		26
      769-832			14		28
      833-896			15		30
      897-960			16		32
      961-1024			17		34	[SGI ca. 2006?]

      . . .

     3967-4032			64	       128
     4033-4096			65	       130	[SGI ca. 2008/9?]
     4097-4160			67	       134
     4161-4224			68	       136

And so on, limiting out at 262,144 CPUs, which should be at least
3-5 years in the future (famous last words).  The "Cachelines per
Implementation" column is for each of rcu and rcu_bh, while the "Total
Cachelines" column is for the combination of both.  As you can see, the
number of cachelines consumed by the rcu_nodes hierarchy is quite modest
as a function of the number of CPUs, even for pretty big numbers of CPUs.

So I really do not believe that this is a real issue.

> > Making the decision at runtime would bloat the code by much more than the
> > extra data consumed.  And introduce yet more races between online/offline
> > and everything else.  Besides, this way I am being bloat-compatible
> > with DEFINE_PER_CPU().  ;-)
> > 
> > > > +#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
> > > > +#define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
> > > > +
> > > > +/*
> > > > + * Definition for node within the RCU grace-period-detection hierarchy.
> > > > + */
> > > > +struct rcu_node {
> > > > +	spinlock_t lock;
> > > > +	unsigned long qsmask;	/* CPUs or groups that need to switch in */
> > > > +				/*  order for current grace period to proceed.*/
> > > > +	unsigned long qsmaskinit;
> > > > +				/* Per-GP initialization for qsmask. */
> > > > +	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
> > > > +	int	grplo;		/* lowest-numbered CPU or group here. */
> > > > +	int	grphi;		/* highest-numbered CPU or group here. */
> > > > +	u8	grpnum;		/* CPU/group number for next level up. */
> > > > +	u8	level;		/* root is at level 0. */
> > > > +	struct rcu_node *parent;
> > > > +} ____cacheline_internodealigned_in_smp;
> > > 
> > > So this is a 4096-byte structure on some setups.
> > 
> > You lost me on this one.  On a 64-bit system, I have 8 bytes each for
> > lock, qsmask, qsmaskinit, grpmask, and parent, four bytes each for grplo
> > and grphi, and another byte each for grpnum and level, for a total of
> > 50 bytes for each struct rcu_node, which comes to a single cache line
> > for most large system.  Given the default CONFIG_RCU_FANOUT=64 and
> > NR_CPUS=4096, we have a two-level hierarchy with one root rcu_node
> > structure and 64 leaf rcu_node structures.  This gives a total of
> > 65 cache lines.
> 
> ____cacheline_internodealigned_in_smp will expand this structure to
> 4096 bytes on CONFIG_X86_VSMP=y.

Ah!  I guess that I have not been paying sufficient attention.

OK, http://www.scalemp.com/ says that they go to 128 cores, so perhaps
256 hardware threads, and 1TB of memory.  This is about 4GB per hardware
thread.  My approach costs them 4096/64=64 bytes per hardware thread,
or about 2 millionths of a percent of memory.

I think that this is OK.  If not, one option is to pick a smaller
alignment for that architecture.

> > > It's a pretty big pill to swallow.  Nice performance testing results
> > > will help it to slide down.
> > 
> > Well, the read side is easy -- exactly the same code sequence as for
> > Classic RCU.  On the update side, this is more of a bug fix for large
> > numbers of CPUs, where unadorned Classic RCU is said to suffer terminal
> > lock contention.  I will see what I can come up with, but at the end of
> > the day, this will need some testing on machines larger than the 128-CPU
> > systems that I have access to.
> 
> OK, thanks.  As it's effectively a bugfix, a full description of the
> bug would grease some wheels.

Here is the gist of what I was told:

	Above several hundred CPUs, the current RCU implementation
	suffers from severe lock contention, rendering the machine
	useless.  Crude workarounds exist, but are expected to cause
	their own problems at higher CPU counts.

I never have used a machine with that many CPUs, so am just passing on
what I heard.  But given that Classic RCU was designed with 32-64 CPUs
in mind, I actually would have expected it to hit the wall much sooner.

Is the above sufficient?

							Thanx, Paul

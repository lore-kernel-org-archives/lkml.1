Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab0BXGHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 01:07:18 -0500
Received: from ozlabs.org ([203.10.76.45]:53733 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab0BXGHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 01:07:15 -0500
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for Power7
In-reply-to: <1266942281.11845.521.camel@laptop>
References: <1264017638.5717.121.camel@jschopp-laptop> <1264017847.5717.132.camel@jschopp-laptop> <1264548495.12239.56.camel@jschopp-laptop> <1264720855.9660.22.camel@jschopp-laptop> <1264721088.10385.1.camel@jschopp-laptop> <1265403478.6089.41.camel@jschopp-laptop> <1266142340.5273.418.camel@laptop> <25851.1266445258@neuling.org> <1266499023.26719.597.camel@laptop> <14639.1266559532@neuling.org> <1266573672.1806.70.camel@laptop> <24165.1266577276@neuling.org> <23662.1266905307@neuling.org> <1266942281.11845.521.camel@laptop>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Tue, 23 Feb 2010 17:24:41 +0100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Wed, 24 Feb 2010 17:07:13 +1100
Message-ID: <4886.1266991633@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1266942281.11845.521.camel@laptop> you wrote:
> On Tue, 2010-02-23 at 17:08 +1100, Michael Neuling wrote:
> 
> > I have some comments on the code inline but... 
> > 
> > So when I run this, I don't get processes pulled down to the lower
> > threads.  A simple test case of running 1 CPU intensive process at
> > SCHED_OTHER on a machine with 2 way SMT system (a POWER6 but enabling
> > SD_ASYM_PACKING).  The single processes doesn't move to lower threads as
> > I'd hope.
> > 
> > Also, are you sure you want to put this in generic code?  It seem to be
> > quite POWER7 specific functionality, so would be logically better in
> > arch/powerpc.  I guess some other arch *might* need it, but seems
> > unlikely.  
> 
> Well, there are no arch hooks in the load-balancing (aside from the
> recent cpu_power stuff, and that really is the wrong thing to poke at
> for this), and I did hear some other people express interest in such a
> constraint.

Interesting.  Can I ask, were people interesting in this at the SMT
level or higher in the hierarchy?

> Also, load-balancing is complex enough as it is, so I prefer to keep
> everything in the generic code where possible, clearly things like
> sched_domain creation need arch topology bits, and the arch_scale*
> things require other arch information like cpu frequency.

OK

> > > @@ -2493,6 +2494,28 @@ static inline void update_sg_lb_stats(st
> > >  		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
> > >  }
> > >  
> > > +static int update_sd_pick_busiest(struct sched_domain *sd,
> > > +	       			  struct sd_lb_stats *sds,
> > > +				  struct sched_group *sg,
> > > +			  	  struct sg_lb_stats *sgs)
> > > +{
> > > +	if (sgs->sum_nr_running > sgs->group_capacity)
> > > +		return 1;
> > > +
> > > +	if (sgs->group_imb)
> > > +		return 1;
> > > +
> > > +	if ((sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running) {
> > 
> > If we are asymetric packing...
> > 
> > 
> > > +		if (!sds->busiest)
> > > +			return 1;
> > 
> > This just seems to be a null pointer check.
> > 
> > From the tracing I've done, this is always true (always NULL) at this
> > point so we return here.
> 
> Right, so we need to have a busiest group to take a task from, if there
> is no busiest yet, take this group.
> 
> And in your scenario, with there being only a single task, we'd only hit
> this once at most, so yes it makes sense this is always NULL.

OK

> 
> > > +
> > > +		if (group_first_cpu(sds->busiest) < group_first_cpu(sg))
> > > +			return 1;
> > 
> > I'm a bit lost as to what this is for.  Any clues you could provide
> > would be appreciated. :-)
> > 
> > Is the first cpu in this domain's busiest group before the first cpu in
> > this group.  If, so pick this as the busiest?
> > 
> > Should this be the other way around if we want to pack the busiest to
> > the first cpu?  Mark it as the busiest if it's after (not before).  
> > 
> > Is group_first_cpu guaranteed to give us the first physical cpu (ie.
> > thread 0 in our case) or are these virtualised at this point?
> > 
> > I'm not seeing this hit anyway due to the null pointer check above.
> 
> So this says, if all things being equal, and we already have a busiest,
> but this candidate (sg) is higher than the current (busiest) take this
> one.
> 
> The idea is to move the highest SMT task down.

So in the p7 case, I don't think this is required, as the threads are
all of the same performance when in a given SMT mode.  So we don't need
to change the order if the lower groups are busy anyway.  It's only once
they became idle that we'd need to rebalanced.

That being said, it probably doesn't hurt?

> 
> > > @@ -2562,6 +2585,38 @@ static inline void update_sd_lb_stats(st
> > >  	} while (group != sd->groups);
> > >  }
> > >  
> > > +int __weak sd_asym_packing_arch(void)
> > > +{
> > > +	return 0;
> > > +}
> 
> arch_sd_asym_packing() is what you used in topology.h

Oops, thanks.  That would make the function even weaker than I'd
intended :-)

> > > +static int check_asym_packing(struct sched_domain *sd,
> > > +				    struct sd_lb_stats *sds,
> > > +				    unsigned long *imbalance)
> > > +{
> > > +	int i, cpu, busiest_cpu;
> > > +
> > > +	if (!(sd->flags & SD_ASYM_PACKING))
> > > +		return 0;
> > > +
> > > +	if (!sds->busiest)
> > > +		return 0;
> > > +
> > > +	i = 0;
> > > +	busiest_cpu = group_first_cpu(sds->busiest);
> > > +	for_each_cpu(cpu, sched_domain_span(sd)) {
> > > +		i++;
> > > +		if (cpu == busiest_cpu)
> > > +			break;
> > > +	}
> > > +
> > > +	if (sds->total_nr_running > i)
> > > +		return 0;
> > 
> > This seems to be the core of the packing logic.
> > 
> > We make sure the busiest_cpu is not past total_nr_running.  If it is we
> > mark as imbalanced.  Correct?
> > 
> > It seems if a non zero thread/group had a pile of processes running on
> > it and a lower thread had much less, this wouldn't fire, but I'm
> > guessing normal load balancing would kick in that case to fix the
> > imbalance.
> > 
> > Any corrections to my ramblings appreciated :-)
> 
> Right, so we're concerned the scenario where there's less tasks than SMT
> siblings, if there's more they should all be running and the regular
> load-balancer will deal with it.

Yes

> If there's less the group will normally be balanced and we fall out and
> end up in check_asym_packing().
> 
> So what I tried doing with that loop is detect if there's a hole in the
> packing before busiest. Now that I think about it, what we need to check
> is if this_cpu (the removed cpu argument) is idle and less than busiest.
> 
> So something like:
> 
> static int check_asym_pacing(struct sched_domain *sd,
>                              struct sd_lb_stats *sds,
>                              int this_cpu, unsigned long *imbalance)
> {
> 	int busiest_cpu;
> 
> 	if (!(sd->flags & SD_ASYM_PACKING))
> 		return 0;
> 
> 	if (!sds->busiest)
> 		return 0;
> 
> 	busiest_cpu = group_first_cpu(sds->busiest);
> 	if (cpu_rq(this_cpu)->nr_running || this_cpu > busiest_cpu)
> 		return 0;
> 
> 	*imbalance = (sds->max_load * sds->busiest->cpu_power) /
> 			SCHED_LOAD_SCALE;
> 	return 1;
> }
> 
> Does that make sense?

I think so.

I'm seeing check_asym_packing do the right thing with the simple SMT2
with 1 process case.  It marks cpu0 as imbalanced when cpu0 is idle and
cpu1 is busy.

Unfortunately the process doesn't seem to be get migrated down though.
Do we need to give *imbalance a higher value? 

FYI this version doesn't use sgs->total_nr_running anymore so I've
removed it.

> 
> I still see two problems with this though,.. regular load-balancing only
> balances on the first cpu of a domain (see the *balance = 0, condition
> in update_sg_lb_stats()), this means that if SMT[12] are idle we'll not
> pull properly. Also, nohz balancing might mess this up further.

I do have CONFIG_NO_HZ set but turning it off doesn't help with the
above issue.

> We could maybe play some games with the balance decision in
> update_sg_lb_stats() for SD_ASYM_PACKING domains and idle == CPU_IDLE,
> no ideas yet on nohz though.

OK

<from followup email>
> Hmm, we could change the bit in find_busiest_group() to:
> 
>   if (idle == CPU_IDLE && check_asym_packing())
>
> and skip the nr_running test..

ok, changed.

This is the patch so far minus the trivial PPC bits.

Thanks!
Mikey
---
 include/linux/sched.h    |    4 ++
 include/linux/topology.h |    1 
 kernel/sched_fair.c      |   65 ++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 66 insertions(+), 4 deletions(-)

Index: linux-next/include/linux/sched.h
===================================================================
--- linux-next.orig/include/linux/sched.h
+++ linux-next/include/linux/sched.h
@@ -849,7 +849,7 @@ enum cpu_idle_type {
 #define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
-
+#define SD_ASYM_PACKING		0x0800  /* Asymmetric SMT packing */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 
 enum powersavings_balance_level {
@@ -881,6 +881,8 @@ static inline int sd_balance_for_package
 	return SD_PREFER_SIBLING;
 }
 
+extern int arch_sd_asym_packing(void);
+
 /*
  * Optimise SD flags for power savings:
  * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
Index: linux-next/include/linux/topology.h
===================================================================
--- linux-next.orig/include/linux/topology.h
+++ linux-next/include/linux/topology.h
@@ -102,6 +102,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
+				| arch_sd_asym_packing()		\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
Index: linux-next/kernel/sched_fair.c
===================================================================
--- linux-next.orig/kernel/sched_fair.c
+++ linux-next/kernel/sched_fair.c
@@ -2494,6 +2494,32 @@ static inline void update_sg_lb_stats(st
 }
 
 /**
+ * update_sd_pick_busiest - return 1 on busiest group
+ */
+static int update_sd_pick_busiest(struct sched_domain *sd,
+				  struct sd_lb_stats *sds,
+				  struct sched_group *sg,
+				  struct sg_lb_stats *sgs)
+{
+	if (sgs->sum_nr_running > sgs->group_capacity)
+		return 1;
+
+	if (sgs->group_imb)
+		return 1;
+
+	/* Check packing mode for this domain */
+	if ((sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running) {
+		if (!sds->busiest)
+			return 1;
+
+		if (group_first_cpu(sds->busiest) > group_first_cpu(sg))
+			return 1;
+	}
+
+	return 0;
+}
+
+/**
  * update_sd_lb_stats - Update sched_group's statistics for load balancing.
  * @sd: sched_domain whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
@@ -2547,9 +2573,8 @@ static inline void update_sd_lb_stats(st
 			sds->this = group;
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
-		} else if (sgs.avg_load > sds->max_load &&
-			   (sgs.sum_nr_running > sgs.group_capacity ||
-				sgs.group_imb)) {
+		} else if (sgs.avg_load >= sds->max_load &&
+			   update_sd_pick_busiest(sd, sds, group, &sgs)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = group;
 			sds->busiest_nr_running = sgs.sum_nr_running;
@@ -2562,6 +2587,36 @@ static inline void update_sd_lb_stats(st
 	} while (group != sd->groups);
 }
 
+int __weak arch_sd_asym_packing(void)
+{
+	return 0*SD_ASYM_PACKING;
+}
+
+/**
+ * check_asym_packing - Check to see if we the group is packed into
+ *			the sched doman
+ */
+static int check_asym_packing(struct sched_domain *sd,
+			      struct sd_lb_stats *sds,
+			      int this_cpu, unsigned long *imbalance)
+{
+	int busiest_cpu;
+
+	if (!(sd->flags & SD_ASYM_PACKING))
+		return 0;
+
+	if (!sds->busiest)
+		return 0;
+
+	busiest_cpu = group_first_cpu(sds->busiest);
+	if (this_cpu > busiest_cpu)
+		return 0;
+
+	*imbalance = (sds->max_load * sds->busiest->cpu_power) /
+			SCHED_LOAD_SCALE;
+	return 1;
+}
+
 /**
  * fix_small_imbalance - Calculate the minor imbalance that exists
  *			amongst the groups of a sched_domain, during
@@ -2761,6 +2816,10 @@ find_busiest_group(struct sched_domain *
 	return sds.busiest;
 
 out_balanced:
+	if (idle == CPU_IDLE &&
+	    check_asym_packing(sd, &sds, this_cpu, imbalance))
+		return sds.busiest;
+
 	/*
 	 * There is no obvious imbalance. But check if we can do some balancing
 	 * to save power.

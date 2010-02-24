Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0BXLNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 06:13:47 -0500
Received: from ozlabs.org ([203.10.76.45]:41507 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab0BXLNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 06:13:46 -0500
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for Power7
In-reply-to: <4886.1266991633@neuling.org>
References: <1264017638.5717.121.camel@jschopp-laptop> <1264017847.5717.132.camel@jschopp-laptop> <1264548495.12239.56.camel@jschopp-laptop> <1264720855.9660.22.camel@jschopp-laptop> <1264721088.10385.1.camel@jschopp-laptop> <1265403478.6089.41.camel@jschopp-laptop> <1266142340.5273.418.camel@laptop> <25851.1266445258@neuling.org> <1266499023.26719.597.camel@laptop> <14639.1266559532@neuling.org> <1266573672.1806.70.camel@laptop> <24165.1266577276@neuling.org> <23662.1266905307@neuling.org> <1266942281.11845.521.camel@laptop> <4886.1266991633@neuling.org>
Comments: In-reply-to Michael Neuling <mikey@neuling.org>
   message dated "Wed, 24 Feb 2010 17:07:13 +1100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Wed, 24 Feb 2010 22:13:44 +1100
Message-ID: <11927.1267010024@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If there's less the group will normally be balanced and we fall out and
> > end up in check_asym_packing().
> > 
> > So what I tried doing with that loop is detect if there's a hole in the
> > packing before busiest. Now that I think about it, what we need to check
> > is if this_cpu (the removed cpu argument) is idle and less than busiest.
> > 
> > So something like:
> > 
> > static int check_asym_pacing(struct sched_domain *sd,
> >                              struct sd_lb_stats *sds,
> >                              int this_cpu, unsigned long *imbalance)
> > {
> > 	int busiest_cpu;
> > 
> > 	if (!(sd->flags & SD_ASYM_PACKING))
> > 		return 0;
> > 
> > 	if (!sds->busiest)
> > 		return 0;
> > 
> > 	busiest_cpu = group_first_cpu(sds->busiest);
> > 	if (cpu_rq(this_cpu)->nr_running || this_cpu > busiest_cpu)
> > 		return 0;
> > 
> > 	*imbalance = (sds->max_load * sds->busiest->cpu_power) /
> > 			SCHED_LOAD_SCALE;
> > 	return 1;
> > }
> > 
> > Does that make sense?
> 
> I think so.
> 
> I'm seeing check_asym_packing do the right thing with the simple SMT2
> with 1 process case.  It marks cpu0 as imbalanced when cpu0 is idle and
> cpu1 is busy.
> 
> Unfortunately the process doesn't seem to be get migrated down though.
> Do we need to give *imbalance a higher value? 

So with ego help, I traced this down a bit more.  

In my simple test case (SMT2, t0 idle, t1 active) if f_b_g() hits our
new case in check_asym_packing(), load_balance then runs f_b_q().
f_b_q() has this:

  		if (capacity && rq->nr_running == 1 && wl > imbalance)
			continue;

when check_asym_packing() hits, wl = 1783 and imbalance = 1024, so we
continue and busiest remains NULL. 

load_balance then does "goto out_balanced" and it doesn't attempt to
move the task.

Based on this and on egos suggestion I pulled in Suresh Siddha patch
from: http://lkml.org/lkml/2010/2/12/352.  This fixes the problem.  The
process is moved down to t0.  

I've only tested SMT2 so far.  

Mikey

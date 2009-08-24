Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZHXPk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZHXPk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZHXPk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:40:56 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:52594 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZHXPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:40:56 -0400
Date: Mon, 24 Aug 2009 21:10:13 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/15] sched: Check for sched_mn_power_savings when
 doing load balancing
Message-ID: <20090824154013.GM6474@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090820131243.GO29327@alberich.amd.com>
 <20090820134104.GY29327@alberich.amd.com>
 <1251126220.7538.273.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1251126220.7538.273.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2009-08-24 17:03:40]:

> On Thu, 2009-08-20 at 15:41 +0200, Andreas Herrmann wrote:
> > The patch adds support for POWERSAVINGS_BALANCE_BASIC for MN domain
> > level. Currently POWERSAVINGS_BALANCE_WAKEUP is not used for MN domain.
> > 
> > (I have to admit that so far I don't have the correct understanding
> > what's the benefit of POWERSAVINGS_BALANCE_WAKEUP (when an deticated
> > wakeup CPU is used) in contrast to POWERSAVINGS_BALANCE_BASIC.  I also
> > have not found an example that would demonstrate the difference
> > between those two powersaving levels.)
> 
> blame svaidy for not writing enough comments ;-)

I am here to explain ;)

> iirc it moves tasks to sched_mv_preferred_wakeup_cpu instead of waking
> an idle cpu, this leaves idle cpus idle longer at the cost of creating
> overload on other cpus.

Yes, as Peter said, the POWERSAVINGS_BALANCE_WAKEUP biases task
wakeups to sched_mc_preferred_wakeup_cpu which has been nominated from
previous load balance loops.

Task wakeup biasing of sched_mc=2 works for most workloads like
kernbench and other sleeping tasks that come in and out of runqueue.
The default sched_mc=1 will work only for jobs running much longer
than the loadbalance interval or almost 100% CPU intensive job where
the load balancer can take time to identify the load pattern and
initiate a task migrate.

The wakeup biasing (sched_mc=2) will help move bursty jobs faster and
statistically pack them in single package and save power.
 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  kernel/sched.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index ebcda58..7a0d710 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -4591,7 +4591,8 @@ static int find_new_ilb(int cpu)
> >  	 * Have idle load balancer selection from semi-idle packages only
> >  	 * when power-aware load balancing is enabled
> >  	 */
> > -	if (!(sched_smt_power_savings || sched_mc_power_savings))
> > +	if (!(sched_smt_power_savings || sched_mc_power_savings ||
> > +	      sched_mn_power_savings))
> >  		goto out_done;
> >  
> >  	/*
> > @@ -4681,7 +4682,7 @@ int select_nohz_load_balancer(int stop_tick)
> >  			int new_ilb;
> >  
> >  			if (!(sched_smt_power_savings ||
> > -						sched_mc_power_savings))
> > +			      sched_mc_power_savings || sched_mn_power_savings))
> >  				return 1;
> >  			/*
> >  			 * Check to see if there is a more power-efficient


You can achieve the balancing effects by propagating the SD_ flags at
the right domain level with the same sysfs interface.  At some point
we wanted to change to sched_power_savings=N and set the flags
according to system topology to provide consolidation at the right
sched_domain and save power.

--Vaidy


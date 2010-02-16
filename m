Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab0BPSq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 13:46:59 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:46712 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab0BPSq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 13:46:58 -0500
Date: Wed, 17 Feb 2010 00:16:49 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, ego@in.ibm.com
Subject: Re: [patch] sched: fix SMT scheduler regression in
 find_busiest_queue()
Message-ID: <20100216184649.GA32472@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
 <20100213182748.GB5882@dirshya.in.ibm.com>
 <20100213202552.GI5882@dirshya.in.ibm.com>
 <20100213203611.GJ5882@dirshya.in.ibm.com>
 <1266142318.5273.407.camel@laptop>
 <20100215123538.GE8006@dirshya.in.ibm.com>
 <1266238843.15770.323.camel@laptop>
 <20100216155906.GC8777@dirshya.in.ibm.com>
 <1266341325.9432.283.camel@laptop>
 <20100216182346.GA19327@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100216182346.GA19327@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2010-02-16 23:55:30]:

> * Peter Zijlstra <peterz@infradead.org> [2010-02-16 18:28:44]:
> 
> > On Tue, 2010-02-16 at 21:29 +0530, Vaidyanathan Srinivasan wrote:
> > > Agreed.  Placement control should be handled by SD_PREFER_SIBLING
> > > and SD_POWER_SAVINGS flags.
> > > 
> > > --Vaidy
> > > 
> > > ---
> > > 
> > >     sched_smt_powersavings for threaded systems need this fix for
> > >     consolidation to sibling threads to work.  Since threads have 
> > >     fractional capacity, group_capacity will turn out to be one 
> > >     always and not accommodate another task in the sibling thread.
> > > 
> > >     This fix makes group_capacity a function of cpumask_weight that
> > >     will enable the power saving load balancer to pack tasks among
> > >     sibling threads and keep more cores idle.
> > >     
> > >     Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > > 
> > > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > > index 522cf0e..ec3a5c5 100644
> > > --- a/kernel/sched_fair.c
> > > +++ b/kernel/sched_fair.c
> > > @@ -2538,9 +2538,17 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
> > >                  * In case the child domain prefers tasks go to siblings
> > >                  * first, lower the group capacity to one so that we'll try
> > >                  * and move all the excess tasks away.
> > 
> > I prefer a blank line in between two paragraphs, but even better would
> > be to place this comment at the else if site.
> > 
> > > +                * If power savings balance is set at this domain, then
> > > +                * make capacity equal to number of hardware threads to
> > > +                * accomodate more tasks until capacity is reached.  The
> > 
> > my spell checker seems to prefer: accommodate 
> 
> ok, will fix the comment.

Thanks for the review, here is the updated patch:
---
    sched: Fix group_capacity for sched_smt_powersavings

    sched_smt_powersavings for threaded systems need this fix for
    consolidation to sibling threads to work.  Since threads have 
    fractional capacity, group_capacity will turn out to be one 
    always and not accommodate another task in the sibling thread.

    This fix makes group_capacity a function of cpumask_weight that
    will enable the power saving load balancer to pack tasks among
    sibling threads and keep more cores idle.
    
    Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 522cf0e..4466144 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2541,6 +2541,21 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		 */
 		if (prefer_sibling)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
+		/*
+		 * If power savings balance is set at this domain, then
+		 * make capacity equal to number of hardware threads to
+		 * accommodate more tasks until capacity is reached.
+		 */
+		else if (sd->flags & SD_POWERSAVINGS_BALANCE)
+			sgs.group_capacity =
+				cpumask_weight(sched_group_cpus(group));
+
+			/*
+			 * The default group_capacity is rounded from sum of
+			 * fractional cpu_powers of sibling hardware threads
+			 * in order to enable fair use of available hardware
+			 * resources.
+			 */
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
@@ -2855,7 +2870,8 @@ static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle)
 		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 			return 0;
 
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP &&
+		    sched_smt_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
 			return 0;
 	}
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0BONCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 08:02:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab0BONCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 08:02:07 -0500
Subject: Re: [patch] sched: fix SMT scheduler regression in
 find_busiest_queue()
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, ego@in.ibm.com
In-Reply-To: <20100215123538.GE8006@dirshya.in.ibm.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <20100213182748.GB5882@dirshya.in.ibm.com>
	 <20100213202552.GI5882@dirshya.in.ibm.com>
	 <20100213203611.GJ5882@dirshya.in.ibm.com>
	 <1266142318.5273.407.camel@laptop>
	 <20100215123538.GE8006@dirshya.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 14:00:43 +0100
Message-ID: <1266238843.15770.323.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 18:05 +0530, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <peterz@infradead.org> [2010-02-14 11:11:58]:
> 
> > On Sun, 2010-02-14 at 02:06 +0530, Vaidyanathan Srinivasan wrote:
> > > > > > @@ -4119,12 +4119,23 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
> > > > > >                   continue;
> > > > > > 
> > > > > >           rq = cpu_rq(i);
> > > > > > -         wl = weighted_cpuload(i) * SCHED_LOAD_SCALE;
> > > > > > -         wl /= power;
> > > > > > +         wl = weighted_cpuload(i);
> > > > > > 
> > > > > > +         /*
> > > > > > +          * When comparing with imbalance, use weighted_cpuload()
> > > > > > +          * which is not scaled with the cpu power.
> > > > > > +          */
> > > > > >           if (capacity && rq->nr_running == 1 && wl > imbalance)
> > > > > >                   continue;
> > > > > > 
> > > > > > +         /*
> > > > > > +          * For the load comparisons with the other cpu's, consider
> > > > > > +          * the weighted_cpuload() scaled with the cpu power, so that
> > > > > > +          * the load can be moved away from the cpu that is potentially
> > > > > > +          * running at a lower capacity.
> > > > > > +          */
> > > > > > +         wl = (wl * SCHED_LOAD_SCALE) / power;
> > > > > > +
> > > > > >           if (wl > max_load) {
> > > > > >                   max_load = wl;
> > > > > >                   busiest = rq;
> > > > > > 
> > > > > >
> > > 
> > > In addition to the above fix, for sched_smt_powersavings to work, the
> > > group capacity of the core (mc level) should be made 2 in
> > > update_sg_lb_stats() by changing the DIV_ROUND_CLOSEST to
> > > DIV_RPUND_UP()
> > > 
> > >         sgs->group_capacity =
> > >                 DIV_ROUND_UP(group->cpu_power, SCHED_LOAD_SCALE);
> > > 
> > > Ideally we can change this to DIV_ROUND_UP and let SD_PREFER_SIBLING
> > > flag to force capacity to 1.  Need to see if there are any side
> > > effects of setting SD_PREFER_SIBLING at SIBLING level sched domain
> > > based on sched_smt_powersavings flag. 
> > 
> > OK, so while I think that Suresh' patch can make sense (haven't had time
> > to think it through), the above really sounds wrong. Things should not
> > rely on the cpu_power value like that.
> 
> Hi Peter,
> 
> The reason rounding is a problem is because threads have fractional
> cpu_power and we lose some power in DIV_ROUND_CLOSEST().  At MC level
> a group has 2*589=1178 and group_capacity will be 1 always if
> DIV_ROUND_CLOSEST() is used irrespective of the SD_PREFER_SIBLING
> flag.
> 
> We are reducing group capacity here to 1 even though we have 2 sibling
> threads in the group.  In the sched_smt_powassavings>0 case, the
> group_capacity should be 2 to allow task consolidation to this group
> while leaving other groups completely idle.
> 
> DIV_ROUND_UP(group->cpu_power, SCHED_LOAD_SCALE) will ensure any spare
> capacity is rounded up and counted.  
> 
> While, if SD_REFER_SIBLING is set, 
> 
> update_sd_lb_stats():
>         if (prefer_sibling)
> 		sgs.group_capacity = min(sgs.group_capacity, 1UL);
> 
> will ensure the group_capacity is 1 and allows spreading of tasks.                

We should be weakening this link between cpu_power and capacity, not
strengthening it. What I think you want is to use
cpumask_weight(sched_gropu_cpus(group)) or something as capacity.

The setup for cpu_power is that it can reflect the actual capacity for
work, esp with todays asymmetric cpus where a socket can run on a
different frequency we need to make sure this is so.

So no, that DIV_ROUND_UP is utterly broken, as there might be many ways
for cpu_power of multiple threads/cpus to be less than the number of
cpus.

Furthermore, for powersavings it makes sense to make the capacity a
function of an overload argument/tunable, so that you can specify the
threshold of packing.

So really, cpu_power is a normalization factor to equally distribute
load across cpus that have asymmetric work capacity, if you need any
placement constraints outside of that, do _NOT_ touch cpu_power.


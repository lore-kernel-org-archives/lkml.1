Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab0BOMfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 07:35:47 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:56515 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0BOMfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 07:35:45 -0500
Date: Mon, 15 Feb 2010 18:05:38 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, ego@in.ibm.com
Subject: Re: [patch] sched: fix SMT scheduler regression in
 find_busiest_queue()
Message-ID: <20100215123538.GE8006@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
 <20100213182748.GB5882@dirshya.in.ibm.com>
 <20100213202552.GI5882@dirshya.in.ibm.com>
 <20100213203611.GJ5882@dirshya.in.ibm.com>
 <1266142318.5273.407.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1266142318.5273.407.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-02-14 11:11:58]:

> On Sun, 2010-02-14 at 02:06 +0530, Vaidyanathan Srinivasan wrote:
> > > > > @@ -4119,12 +4119,23 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
> > > > >                   continue;
> > > > > 
> > > > >           rq = cpu_rq(i);
> > > > > -         wl = weighted_cpuload(i) * SCHED_LOAD_SCALE;
> > > > > -         wl /= power;
> > > > > +         wl = weighted_cpuload(i);
> > > > > 
> > > > > +         /*
> > > > > +          * When comparing with imbalance, use weighted_cpuload()
> > > > > +          * which is not scaled with the cpu power.
> > > > > +          */
> > > > >           if (capacity && rq->nr_running == 1 && wl > imbalance)
> > > > >                   continue;
> > > > > 
> > > > > +         /*
> > > > > +          * For the load comparisons with the other cpu's, consider
> > > > > +          * the weighted_cpuload() scaled with the cpu power, so that
> > > > > +          * the load can be moved away from the cpu that is potentially
> > > > > +          * running at a lower capacity.
> > > > > +          */
> > > > > +         wl = (wl * SCHED_LOAD_SCALE) / power;
> > > > > +
> > > > >           if (wl > max_load) {
> > > > >                   max_load = wl;
> > > > >                   busiest = rq;
> > > > > 
> > > > >
> > 
> > In addition to the above fix, for sched_smt_powersavings to work, the
> > group capacity of the core (mc level) should be made 2 in
> > update_sg_lb_stats() by changing the DIV_ROUND_CLOSEST to
> > DIV_RPUND_UP()
> > 
> >         sgs->group_capacity =
> >                 DIV_ROUND_UP(group->cpu_power, SCHED_LOAD_SCALE);
> > 
> > Ideally we can change this to DIV_ROUND_UP and let SD_PREFER_SIBLING
> > flag to force capacity to 1.  Need to see if there are any side
> > effects of setting SD_PREFER_SIBLING at SIBLING level sched domain
> > based on sched_smt_powersavings flag. 
> 
> OK, so while I think that Suresh' patch can make sense (haven't had time
> to think it through), the above really sounds wrong. Things should not
> rely on the cpu_power value like that.

Hi Peter,

The reason rounding is a problem is because threads have fractional
cpu_power and we lose some power in DIV_ROUND_CLOSEST().  At MC level
a group has 2*589=1178 and group_capacity will be 1 always if
DIV_ROUND_CLOSEST() is used irrespective of the SD_PREFER_SIBLING
flag.

We are reducing group capacity here to 1 even though we have 2 sibling
threads in the group.  In the sched_smt_powassavings>0 case, the
group_capacity should be 2 to allow task consolidation to this group
while leaving other groups completely idle.

DIV_ROUND_UP(group->cpu_power, SCHED_LOAD_SCALE) will ensure any spare
capacity is rounded up and counted.  

While, if SD_REFER_SIBLING is set, 

update_sd_lb_stats():
        if (prefer_sibling)
		sgs.group_capacity = min(sgs.group_capacity, 1UL);

will ensure the group_capacity is 1 and allows spreading of tasks.                

--Vaidy


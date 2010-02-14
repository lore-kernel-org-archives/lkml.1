Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab0BNKMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 05:12:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab0BNKMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 05:12:34 -0500
Subject: Re: [patch] sched: fix SMT scheduler regression in
 find_busiest_queue()
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, ego@in.ibm.com
In-Reply-To: <20100213203611.GJ5882@dirshya.in.ibm.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <20100213182748.GB5882@dirshya.in.ibm.com>
	 <20100213202552.GI5882@dirshya.in.ibm.com>
	 <20100213203611.GJ5882@dirshya.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 11:11:58 +0100
Message-ID: <1266142318.5273.407.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-14 at 02:06 +0530, Vaidyanathan Srinivasan wrote:
> > > > @@ -4119,12 +4119,23 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
> > > >                   continue;
> > > > 
> > > >           rq = cpu_rq(i);
> > > > -         wl = weighted_cpuload(i) * SCHED_LOAD_SCALE;
> > > > -         wl /= power;
> > > > +         wl = weighted_cpuload(i);
> > > > 
> > > > +         /*
> > > > +          * When comparing with imbalance, use weighted_cpuload()
> > > > +          * which is not scaled with the cpu power.
> > > > +          */
> > > >           if (capacity && rq->nr_running == 1 && wl > imbalance)
> > > >                   continue;
> > > > 
> > > > +         /*
> > > > +          * For the load comparisons with the other cpu's, consider
> > > > +          * the weighted_cpuload() scaled with the cpu power, so that
> > > > +          * the load can be moved away from the cpu that is potentially
> > > > +          * running at a lower capacity.
> > > > +          */
> > > > +         wl = (wl * SCHED_LOAD_SCALE) / power;
> > > > +
> > > >           if (wl > max_load) {
> > > >                   max_load = wl;
> > > >                   busiest = rq;
> > > > 
> > > >
> 
> In addition to the above fix, for sched_smt_powersavings to work, the
> group capacity of the core (mc level) should be made 2 in
> update_sg_lb_stats() by changing the DIV_ROUND_CLOSEST to
> DIV_RPUND_UP()
> 
>         sgs->group_capacity =
>                 DIV_ROUND_UP(group->cpu_power, SCHED_LOAD_SCALE);
> 
> Ideally we can change this to DIV_ROUND_UP and let SD_PREFER_SIBLING
> flag to force capacity to 1.  Need to see if there are any side
> effects of setting SD_PREFER_SIBLING at SIBLING level sched domain
> based on sched_smt_powersavings flag. 

OK, so while I think that Suresh' patch can make sense (haven't had time
to think it through), the above really sounds wrong. Things should not
rely on the cpu_power value like that.



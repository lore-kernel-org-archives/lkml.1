Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602Ab0A2OI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab0A2OI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449Ab0A2OI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:08:26 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59551 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0A2OI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:08:26 -0500
Date: Fri, 29 Jan 2010 19:37:31 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v5 PATCH 1/8] sched: Rename struct rt_bandwidth to
	sched_bandwidth
Message-ID: <20100129140731.GA3532@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20100105075703.GE27899@in.ibm.com> <20100105075824.GF27899@in.ibm.com> <20100129085949.GD25191@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129085949.GD25191@balbir.in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 02:29:49PM +0530, Balbir Singh wrote:
> * Bharata B Rao <bharata@linux.vnet.ibm.com> [2010-01-05 13:28:24]:
> 
> > sched: Rename struct rt_bandwidth to sched_bandwidth
> > 
> > From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > 
> > Rename struct rt_bandwidth to sched_bandwidth and rename some of the
> > routines to generic names (s/rt_/sched_) so that they can be used
> > by CFS hard limits code in the subsequent patches.
> > 
> > No functionality change by this patch.
> > 
> > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> Looks good, some nit picks below
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Thanks Balbir.

> 
> 
> > ---
> >  kernel/sched.c    |  127 ++++++++++++++++++++++++++---------------------------
> >  kernel/sched_rt.c |   46 ++++++++++---------
> >  2 files changed, 86 insertions(+), 87 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index c535cc4..21cf0d5 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -139,50 +139,50 @@ struct rt_prio_array {
> >  	struct list_head queue[MAX_RT_PRIO];
> >  };
> > 
> > -struct rt_bandwidth {
> > +struct sched_bandwidth {
> >  	/* nests inside the rq lock: */
> > -	raw_spinlock_t		rt_runtime_lock;
> > -	ktime_t			rt_period;
> > -	u64			rt_runtime;
> > -	struct hrtimer		rt_period_timer;
> > +	raw_spinlock_t		runtime_lock;
> > +	ktime_t			period;
> > +	u64			runtime;
> > +	struct hrtimer		period_timer;
> >  };
> > 
> > -static struct rt_bandwidth def_rt_bandwidth;
> > +static struct sched_bandwidth def_rt_bandwidth;
> > 
> > -static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
> > +static int do_sched_rt_period_timer(struct sched_bandwidth *sched_b, int overrun);
> > 
> >  static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
> >  {
> > -	struct rt_bandwidth *rt_b =
> > -		container_of(timer, struct rt_bandwidth, rt_period_timer);
> > +	struct sched_bandwidth *sched_b =
> > +		container_of(timer, struct sched_bandwidth, period_timer);
> >  	ktime_t now;
> >  	int overrun;
> >  	int idle = 0;
> > 
> >  	for (;;) {
> >  		now = hrtimer_cb_get_time(timer);
> > -		overrun = hrtimer_forward(timer, now, rt_b->rt_period);
> > +		overrun = hrtimer_forward(timer, now, sched_b->period);
> > 
> >  		if (!overrun)
> >  			break;
> > 
> > -		idle = do_sched_rt_period_timer(rt_b, overrun);
> > +		idle = do_sched_rt_period_timer(sched_b, overrun);
> >  	}
> > 
> >  	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
> >  }
> > 
> > -static
> > -void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
> > +static void init_sched_bandwidth(struct sched_bandwidth *sched_b, u64 period,
> > +	u64 runtime, enum hrtimer_restart (*period_timer)(struct hrtimer *))
> >  {
> > -	rt_b->rt_period = ns_to_ktime(period);
> > -	rt_b->rt_runtime = runtime;
> > +	sched_b->period = ns_to_ktime(period);
> > +	sched_b->runtime = runtime;
> > 
> > -	raw_spin_lock_init(&rt_b->rt_runtime_lock);
> > +	raw_spin_lock_init(&sched_b->runtime_lock);
> > 
> > -	hrtimer_init(&rt_b->rt_period_timer,
> > +	hrtimer_init(&sched_b->period_timer,
> >  			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> > -	rt_b->rt_period_timer.function = sched_rt_period_timer;
> > +	sched_b->period_timer.function = *period_timer;
> 
> Hmm.. may be I forgetting the "C" language, but why do you dereference
> the pointer before assignment? You should be able to directly assign a
> function address to the function pointer. Did you see a warning?

This is a carry over from old patches. I will fix this
in the next iteration.

> 
> >  }
> > 
> >  static inline int rt_bandwidth_enabled(void)
> > @@ -190,42 +190,40 @@ static inline int rt_bandwidth_enabled(void)
> >  	return sysctl_sched_rt_runtime >= 0;
> >  }
> > 
> > -static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
> > +static void start_sched_bandwidth(struct sched_bandwidth *sched_b)
> >  {
> >  	ktime_t now;
> > 
> > -	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
> > +	if (!rt_bandwidth_enabled() || sched_b->runtime == RUNTIME_INF)
> >  		return;
> > 
> > -	if (hrtimer_active(&rt_b->rt_period_timer))
> > +	if (hrtimer_active(&sched_b->period_timer))
> >  		return;
> > 
> > -	raw_spin_lock(&rt_b->rt_runtime_lock);
> > +	raw_spin_lock(&sched_b->runtime_lock);
> 
> I don't quite understand why this is a raw_spin_lock

- When upgrading from v4 (2.6.32-rc6) to v5 (2.6.33-rc2), I needed
  to change most of the spin_locks in hard limits code in sched.c
  since they had become raw_spin_lock_t.
- If your question is why couldn't we use spin_lock_t (sleepable types),
  this routine is called from RT and CFS with rq->lock (raw type) held.
  So I guess it is not possible to use sleepable version here.

Thanks for your reivew. Would appreciate review of other patches also :)

Regards,
Bharata.

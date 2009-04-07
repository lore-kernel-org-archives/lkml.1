Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbZDGC1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbZDGC1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZDGC1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:27:33 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:42858 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZDGC1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:27:32 -0400
Date: Tue, 7 Apr 2009 07:56:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 3/9] soft limit update filter
Message-ID: <20090407022656.GM7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com> <20090403171202.cd7e094b.kamezawa.hiroyu@jp.fujitsu.com> <20090406094351.GI7082@balbir.in.ibm.com> <20090407090438.9646e90c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090407090438.9646e90c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-07 09:04:38]:

> On Mon, 6 Apr 2009 15:13:51 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-03 17:12:02]:
> > 
> > > No changes from v1.
> > > ==
> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > > Check/Update softlimit information at every charge is over-killing, so
> > > we need some filter.
> > > 
> > > This patch tries to count events in the memcg and if events > threshold
> > > tries to update memcg's soft limit status and reset event counter to 0.
> > > 
> > > Event counter is maintained by per-cpu which has been already used,
> > > Then, no siginificant overhead(extra cache-miss etc..) in theory.
> > > 
> > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > ---
> > > Index: mmotm-2.6.29-Mar23/mm/memcontrol.c
> > > ===================================================================
> > > --- mmotm-2.6.29-Mar23.orig/mm/memcontrol.c
> > > +++ mmotm-2.6.29-Mar23/mm/memcontrol.c
> > > @@ -66,6 +66,7 @@ enum mem_cgroup_stat_index {
> > >  	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
> > >  	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
> > > 
> > > +	MEM_CGROUP_STAT_EVENTS,  /* sum of page-in/page-out for internal use */
> > >  	MEM_CGROUP_STAT_NSTATS,
> > >  };
> > > 
> > > @@ -105,6 +106,22 @@ static s64 mem_cgroup_local_usage(struct
> > >  	return ret;
> > >  }
> > > 
> > > +/* For intenal use of per-cpu event counting. */
> > > +
> > > +static inline void
> > > +__mem_cgroup_stat_reset_safe(struct mem_cgroup_stat_cpu *stat,
> > > +		enum mem_cgroup_stat_index idx)
> > > +{
> > > +	stat->count[idx] = 0;
> > > +}
> > 
> > Why do we do this and why do we need a special event?
> > 
> 2 points.
> 
>   1.  we do "reset" this counter.
>   2.  We're counting page-in/page-out. I wonder I should counter others...
> 
> > > +
> > > +static inline s64
> > > +__mem_cgroup_stat_read_local(struct mem_cgroup_stat_cpu *stat,
> > > +			    enum mem_cgroup_stat_index idx)
> > > +{
> > > +	return stat->count[idx];
> > > +}
> > > +
> > >  /*
> > >   * per-zone information in memory controller.
> > >   */
> > > @@ -235,6 +252,8 @@ static void mem_cgroup_charge_statistics
> > >  	else
> > >  		__mem_cgroup_stat_add_safe(cpustat,
> > >  				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
> > > +	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_EVENTS, 1);
> > > +
> > >  	put_cpu();
> > >  }
> > > 
> > > @@ -897,9 +916,26 @@ static void record_last_oom(struct mem_c
> > >  	mem_cgroup_walk_tree(mem, NULL, record_last_oom_cb);
> > >  }
> > > 
> > > +#define SOFTLIMIT_EVENTS_THRESH (1024) /* 1024 times of page-in/out */
> > > +/*
> > > + * Returns true if sum of page-in/page-out events since last check is
> > > + * over SOFTLIMIT_EVENT_THRESH. (counter is per-cpu.)
> > > + */
> > >  static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
> > >  {
> > > -	return false;
> > > +	bool ret = false;
> > > +	int cpu = get_cpu();
> > > +	s64 val;
> > > +	struct mem_cgroup_stat_cpu *cpustat;
> > > +
> > > +	cpustat = &mem->stat.cpustat[cpu];
> > > +	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
> > > +	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
> > > +		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
> > > +		ret = true;
> > > +	}
> > > +	put_cpu();
> > > +	return ret;
> > >  }
> > >
> > 
> > It is good to have the caller and the function in the same patch.
> > Otherwise, you'll notice unused warnings. I think this function can be
> > simplified further
> > 
> > 1. Lets gid rid of MEM_CGRUP_STAT_EVENTS
> > 2. Lets rewrite mem_cgroup_soft_limit_check as
> > 
> > static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
> > {
> >      bool ret = false;
> >      int cpu = get_cpu();
> >      s64 pgin, pgout;
> >      struct mem_cgroup_stat_cpu *cpustat;
> > 
> >      cpustat = &mem->stat.cpustat[cpu];
> >      pgin = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_PGPGIN_COUNT);
> >      pgout = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_PGPGOUT_COUNT);
> >      val = pgin + pgout - mem->last_event_count;
> >      if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
> >              mem->last_event_count = pgin + pgout;
> >              ret = true;
> >      }
> >      put_cpu();
> >      return ret;
> > }
> > 
> > mem->last_event_count can either be atomic or protected using one of
> > the locks you intend to introduce. This will avoid the overhead of
> > incrementing event at every charge_statistics.
> > 
> Incrementing always hits cache.
> 
> Hmm, making mem->last_event_count as per-cpu, we can do above. And maybe no
> difference with current code. But you don't seem to like counting,
> it's ok to change the shape.
>

I was wondering as to why we were adding another EVENT counter, when
we can sum up pgpgin and pgpgout, but we already have the
infrastructure to make EVENT per-cpu, so lets stick with it for now. 

-- 
	Balbir

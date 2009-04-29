Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbZD2C0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbZD2C0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 22:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZD2C0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 22:26:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36987 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbZD2C0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 22:26:34 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       seto.hidetoshi@jp.fujitsu.com
In-Reply-To: <20090428220854.GC12698@balbir.in.ibm.com>
References: <20090428153611.EBC6.A69D9226@jp.fujitsu.com> <20090428220854.GC12698@balbir.in.ibm.com>
Message-Id: <20090429111558.4B0B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 29 Apr 2009 11:26:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thanks for reviewing.

> >  /* return cpu accounting group corresponding to this container */
> >  static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
> > @@ -10146,6 +10147,9 @@ static struct cgroup_subsys_state *cpuac
> >  	if (!ca->cpuusage)
> >  		goto out_free_ca;
> > 
> > +	if (!cpuacct_batch)
> > +		cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> > +
> 
> I expect cpuacct_batch to be a large number

Yes.


> 
> >  	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
> >  		if (percpu_counter_init(&ca->cpustat[i], 0))
> >  			goto out_free_counters;
> > @@ -10342,7 +10346,7 @@ static void cpuacct_update_stats(struct 
> >  	ca = task_ca(tsk);
> > 
> >  	do {
> > -		percpu_counter_add(&ca->cpustat[idx], val);
> > +		__percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);
> 
> This will make the end result very off the real value due to large
> batch value per cpu. If we are going to go this route, we should
> probably consider using __percpu_counter_sum so that the batch value
> does not show data that is way off.

No problem.

end-user don't see cputime itself. they see converted time.
cpuacct_stats_show() use cputime64_to_clock_t. it mean
the value less than 10msec don't display.

--------------------------------------------------------
static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
                struct cgroup_map_cb *cb)
{
        struct cpuacct *ca = cgroup_ca(cgrp);
        int i;

        for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
                s64 val = percpu_counter_read(&ca->cpustat[i]);
                val = cputime64_to_clock_t(val);
                cb->fill(cb, cpuacct_stat_desc[i], val);
        }
        return 0;
}
--------------------------------------------------------






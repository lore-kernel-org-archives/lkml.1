Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZCLEoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZCLEoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZCLEoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:44:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57831 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZCLEoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:44:11 -0400
Date: Thu, 12 Mar 2009 10:14:39 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC PATCH] cpuacct: per-cgroup utime/stime statistics - v1
Message-ID: <20090312044439.GB3344@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090310124208.GC3902@in.ibm.com> <20090311151657.GA16769@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311151657.GA16769@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 08:46:57PM +0530, Balbir Singh wrote:
> * Bharata B Rao <bharata@linux.vnet.ibm.com> [2009-03-10 18:12:08]:
> 
> Hi, Bharata,
> 
> I did a quick run of the patch on my machine. The patch applied and
> compile cleanly, here are a few comments?
> 
> 1. We could consider enhancing the patch to account for irq, softirq,
> etc time like cpustat does. Not right away, but iteratively

Yes that should not be a problem. We can add those easily if needed.

> 2. The accounting is converted to milliseconds, I would much rather
> export it in cputime to be consistent with other cpu accounting.
> I remember we used to return nanosecond accurate accounting and then
> moved to cputime based accounting for cpuacct.

Ok had thought about it but was hesitant to do because that makes
percpu_counters to work directly on cputime_t type. But I guess that is fine.

> 3. How do we deal with CPU hotplug. Since we use a per-cpu counter,
> any hotplug would mean that the data related to the offlined CPU is
> lost. That is how the current CPU accounting system seems to work.

Not a problem as percpu_counter handles hotplug events as you noted
in the other thread.

> > 
> > @@ -9462,20 +9479,33 @@ static struct cgroup_subsys_state *cpuac
> >  	struct cgroup_subsys *ss, struct cgroup *cgrp)
> >  {
> >  	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
> > +	int i;
> > 
> >  	if (!ca)
> > -		return ERR_PTR(-ENOMEM);
> > +		goto out1;
> > 
> >  	ca->cpuusage = alloc_percpu(u64);
> > -	if (!ca->cpuusage) {
> > -		kfree(ca);
> > -		return ERR_PTR(-ENOMEM);
> > -	}
> > +	if (!ca->cpuusage)
> > +		goto out2;
> > +
> > +	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
> > +		if (percpu_counter_init(&ca->cpustat[i], 0))
> > +			goto out3;
> > 
> >  	if (cgrp->parent)
> >  		ca->parent = cgroup_ca(cgrp->parent);
> > 
> >  	return &ca->css;
> > +
> > +out3:
> > +	i--;
> > +	while (i-- >= 0)
> > +		percpu_counter_destroy(&ca->cpustat[i]);
> > +	free_percpu(ca->cpuusage);
> > +out2:
> > +	kfree(ca);
> > +out1:
> > +	return ERR_PTR(-ENOMEM);
> >  }
> >
> 
> Don't like out* as labels, please let us have more meaningful labels.

Ok, I can change them if you don't like out* labels :)

Regards,
Bharata.

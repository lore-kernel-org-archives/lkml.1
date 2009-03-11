Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZCKIzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZCKIzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZCKIy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:54:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34218 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbZCKIy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:54:27 -0400
Date: Wed, 11 Mar 2009 14:24:58 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC PATCH] cpuacct: per-cgroup utime/stime statistics - v1
Message-ID: <20090311085458.GB5592@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090310124208.GC3902@in.ibm.com> <49B710C4.8040401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B710C4.8040401@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 09:15:48AM +0800, Li Zefan wrote:
> > +static const struct cpuacct_stat_desc {
> > +	const char *msg;
> > +	u64 unit;
> > +} cpuacct_stat_desc[] = {
> > +	[CPUACCT_STAT_UTIME] = { "utime", 1, },
> > +	[CPUACCT_STAT_STIME] = { "stime", 1, },
> > +};
> > +
> 
> I think we can just remove 'unit'.

Ok, they are redundant. Will do.

> 
> > +static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
> > +		struct cgroup_map_cb *cb)
> > +{
> > +	struct cpuacct *ca = cgroup_ca(cgrp);
> > +	int i;
> > +
> > +	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> > +		s64 val = percpu_counter_read(&ca->cpustat[i]);
> > +		val *= cpuacct_stat_desc[i].unit;
> > +		cb->fill(cb, cpuacct_stat_desc[i].msg, val);
> > +	}
> > +	return 0;
> > +}
> > +
> ...
> > +/*
> > + * Account the system/user time to the task's accounting group.
> > + */
> > +static void cpuacct_update_stats(struct task_struct *tsk,
> > +		enum cpuacct_stat_index idx, int val)
> > +{
> > +	struct cpuacct *ca;
> > +
> > +	if (!cpuacct_subsys.active)
> 
> if (unlikely(!cpuacct_subsys.active)))

Ok.

> 
> > +		return;
> > +
> > +	ca = task_ca(tsk);
> > +
> > +	for (; ca; ca = ca->parent)
> > +		percpu_counter_add(&ca->cpustat[idx], val);
> > +}
> > +
> 
> We can reduce one NULL check:
> 
> do (
> 	percpu_counter_add();
> 	ca = ca->parent;
> } while (ca);

Sure. Will address all these in the next iteration.

Regards,
Bharata.

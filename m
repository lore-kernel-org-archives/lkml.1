Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZCRAzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZCRAzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 20:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZCRAzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 20:55:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57545 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZCRAzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 20:55:08 -0400
Date: Wed, 18 Mar 2009 09:53:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v3
Message-Id: <20090318095336.05986cc9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090317062155.GE3314@in.ibm.com>
References: <20090317062155.GE3314@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 11:51:55 +0530
Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> Hi,
> 
> Here is the next version of the cpuacct stime/utime statistics patch.
> 
> Ingo, Could you please consider this for -tip ?
> 
> Changes for v3:
> - Fix a small race in the cpuacct hierarchy walk.
> 
> v2:
> http://lkml.org/lkml/2009/3/12/170
> 
> v1:
> http://lkml.org/lkml/2009/3/10/150
> --
> 
> cpuacct: Add stime and utime statistics
> 
> Add per-cgroup cpuacct controller statistics like the system and user
> time consumed by the group of tasks.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Signed-off-by: Balaji Rao <balajirrao@gmail.com>
> ---
>  Documentation/cgroups/cpuacct.txt |   17 +++++++
>  kernel/sched.c                    |   92 +++++++++++++++++++++++++++++++++++---
>  2 files changed, 103 insertions(+), 6 deletions(-)
> 
> --- a/Documentation/cgroups/cpuacct.txt
> +++ b/Documentation/cgroups/cpuacct.txt
> @@ -30,3 +30,20 @@ The above steps create a new group g1 an
>  process (bash) into it. CPU time consumed by this bash and its children
>  can be obtained from g1/cpuacct.usage and the same is accumulated in
>  /cgroups/cpuacct.usage also.
> +
> +cpuacct.stat file lists a few statistics which further divide the
> +CPU time obtained by the cgroup into user and system times. Currently
> +the following statistics are supported:
> +
> +utime: Time spent by tasks of the cgroup in user mode.
> +stime: Time spent by tasks of the cgroup in kernel mode.
> +
> +utime and stime are in USER_HZ unit.
> +
> +cpuacct controller uses percpu_counter interface to collect utime and
> +stime. This causes two side effects:
> +
> +- It is theoritically possible to see wrong values for stime and utime.
> +  This is because percpu_counter_read() on 32bit systems is broken.

<snip> Hmm, I don't want to say "BROKEN" but..

> +- It is possible to see slightly outdated values for stime and utime
> +  due to the batch processing nature of percpu_counter.
no objection to here. My customer will ask me "To what extent it delayes ?"
maybe I can answer...

> +static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
> +		struct cgroup_map_cb *cb)
> +{
> +	struct cpuacct *ca = cgroup_ca(cgrp);
> +	int i;
> +
> +	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> +		s64 val = percpu_counter_read(&ca->cpustat[i]);
> +		val = cputime_to_clock_t(val);
> +		cb->fill(cb, cpuacct_stat_desc[i], val);
> +	}
> +	return 0;
> +}
> +

No objection to this patch itself, but, Hmm...can this work ?

#ifdef CONFIG_32BIT
/* can be used only when update is not very frequent */
s64 percpu_counter_read_positive_slow(fbc)
{
    s64 ret;
retry:
    /* wait until it seems to be safe */
    smp_mb();
    spin_unlock_wait(&ca->lock);
    ret = fbc->count;
    if (ret < 0)
         goto retry;
    return ret;
}
#else
s64 percpu_counter_read_positive_slow(fbc)
{
   retrun fbc->count;
}
#endif

I wonder why percpu_counter_read_positive() is designed to return 1...

Thanks,
-Kame




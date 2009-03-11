Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZCKBPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZCKBPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZCKBPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:15:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61710 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbZCKBPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:15:42 -0400
Message-ID: <49B710C4.8040401@cn.fujitsu.com>
Date: Wed, 11 Mar 2009 09:15:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC PATCH] cpuacct: per-cgroup utime/stime statistics - v1
References: <20090310124208.GC3902@in.ibm.com>
In-Reply-To: <20090310124208.GC3902@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static const struct cpuacct_stat_desc {
> +	const char *msg;
> +	u64 unit;
> +} cpuacct_stat_desc[] = {
> +	[CPUACCT_STAT_UTIME] = { "utime", 1, },
> +	[CPUACCT_STAT_STIME] = { "stime", 1, },
> +};
> +

I think we can just remove 'unit'.

> +static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
> +		struct cgroup_map_cb *cb)
> +{
> +	struct cpuacct *ca = cgroup_ca(cgrp);
> +	int i;
> +
> +	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> +		s64 val = percpu_counter_read(&ca->cpustat[i]);
> +		val *= cpuacct_stat_desc[i].unit;
> +		cb->fill(cb, cpuacct_stat_desc[i].msg, val);
> +	}
> +	return 0;
> +}
> +
...
> +/*
> + * Account the system/user time to the task's accounting group.
> + */
> +static void cpuacct_update_stats(struct task_struct *tsk,
> +		enum cpuacct_stat_index idx, int val)
> +{
> +	struct cpuacct *ca;
> +
> +	if (!cpuacct_subsys.active)

if (unlikely(!cpuacct_subsys.active)))

> +		return;
> +
> +	ca = task_ca(tsk);
> +
> +	for (; ca; ca = ca->parent)
> +		percpu_counter_add(&ca->cpustat[idx], val);
> +}
> +

We can reduce one NULL check:

do (
	percpu_counter_add();
	ca = ca->parent;
} while (ca);


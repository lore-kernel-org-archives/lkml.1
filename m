Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbZEGKum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbZEGKum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZEGKuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:50:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60524 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbZEGKub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:50:31 -0400
Date: Thu, 7 May 2009 12:50:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v3] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu
	cputime count
Message-ID: <20090507105007.GA28398@elte.hu>
References: <20090507185831.9D24.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507185831.9D24.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> Changelog:
>   since v2
>   - revert using percpu_counter_sum()
> 
>   since v1
>   - use percpu_counter_sum() instead percpu_counter_read()
> 
> 
> -------------------------------------
> Subject: [PATCH v3] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
> 
> cpuacct_update_stats() is called at every tick updating. and it use percpu_counter
> for avoiding performance degression.
> 
> For archs which define VIRT_CPU_ACCOUNTING, every tick would result
> in >1000 units of cputime updates and since this is much much greater
> than percpu_batch_counter, we end up taking spinlock on every tick.
> 
> This patch change batch rule. now, any cpu can store "percpu_counter_bach * jiffies"
> cputime in per-cpu cache.
> it mean this patch don't have behavior change if VIRT_CPU_ACCOUNTING=n.
> 
> Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Cc: Balaji Rao <balajirrao@gmail.com>
> Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  kernel/sched.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: b/kernel/sched.c
> ===================================================================
> --- a/kernel/sched.c	2009-04-30 11:37:47.000000000 +0900
> +++ b/kernel/sched.c	2009-05-07 16:34:00.000000000 +0900
> @@ -10221,6 +10221,7 @@ struct cpuacct {
>  };
>  
>  struct cgroup_subsys cpuacct_subsys;
> +static s32 cpuacct_batch;

should be __read_mostly i guess.

>  
>  /* return cpu accounting group corresponding to this container */
>  static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
> @@ -10250,6 +10251,9 @@ static struct cgroup_subsys_state *cpuac
>  	if (!ca->cpuusage)
>  		goto out_free_ca;
>  
> +	if (!cpuacct_batch)
> +		cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);

So this is a once per boot condition? Why not initialize it in 
sched_init() or so? (instead of incuring this ugly check all the 
time)

	Ingo

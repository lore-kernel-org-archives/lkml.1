Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYENPNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYENPNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYENPNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:13:08 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:2772 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751072AbYENPMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:12:55 -0400
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <20080514134414.GA12693@linux.vnet.ibm.com>
References: <1210226013.3453.113.camel@ymzhang>
	 <20080508061125.GC3644@linux.vnet.ibm.com>
	 <20080509155240.GH3612@linux.vnet.ibm.com>
	 <1210556351.3151.2.camel@ymzhang>
	 <20080512023758.GN3612@linux.vnet.ibm.com>
	 <1210563200.3151.10.camel@ymzhang>
	 <20080512045246.GP3612@linux.vnet.ibm.com>
	 <1210568533.3151.13.camel@ymzhang>
	 <1210583090.7402.4.camel@marge.simson.net>
	 <1210584047.6524.12.camel@lappy.programming.kicks-ass.net>
	 <20080514134414.GA12693@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 17:12:47 +0200
Message-Id: <1210777967.10126.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +#define GROUP_SCALE	(2*1024)
> +
>  static inline void inc_cpu_load(struct rq *rq, unsigned long load)
>  {
> +	load *= GROUP_SCALE;
>  	update_load_add(&rq->load, load);
>  }
>  
>  static inline void dec_cpu_load(struct rq *rq, unsigned long load)
>  {
> +	load *= GROUP_SCALE;
>  	update_load_sub(&rq->load, load);
>  }


Yeah, this bit makes a huge difference; I do that by:

mkdir /cgroup/foo
for i in `cat /cgroup/tasks`; do echo $i > /cgroup/foo/tasks; done
echo $((1024*1024)) > /cgroup/foo/cpu.shares

I'm still pulling my hairs out on why this makes a difference though - I
eliminated all direct assumption on SCHED_LOAD_SCALE(_FUZZ) with an
average of the weight per task. - but all that doesn't help (much)

A few other things I found that make a significant difference:



+static void update_aggregate(int cpu, struct sched_domain *sd)
+{
+       aggregate_walk_tree(aggregate_get_down, aggregate_get_nop, cpu, sd);
+}


@@ -3224,6 +3189,8 @@ static int move_tasks(struct rq *this_rq, int this_cpu, st
ruct rq *busiest,
        unsigned long total_load_moved = 0;
        int this_best_prio = this_rq->curr->prio;

+       update_aggregate(this_cpu, sd);
+
        do {
                total_load_moved +=
                        class->load_balance(this_rq, this_cpu, busiest,



and

@@ -1169,7 +1168,10 @@ static unsigned long wakeup_gran(struct sched_entity *se)
         * More easily preempt - nice tasks, while not making it harder for
         * + nice tasks.
         */
-       gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
+       if (sched_feat(ASYM_GRAN))
+               gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
+       else
+               gran = calc_delta_fair(sysctl_sched_wakeup_granularity, se);

        return gran;
 }


the asym logic is wrong wrt shares - it should look at tg->weight


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXISU6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXISU6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbXISU61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:58:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:25548 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbXISU60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:58:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,275,1186383600"; 
   d="scan'208";a="144782951"
Date: Wed, 19 Sep 2007 13:58:25 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Tong Li <tong.n.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git] CFS-devel, group scheduler, fixes
In-Reply-To: <20070919193557.GD20863@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0709191350400.12420@tongli.jf.intel.com>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
 <20070919193557.GD20863@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Siddha, Suresh B wrote:

> On Tue, Sep 18, 2007 at 11:03:59PM -0700, Tong Li wrote:
>> This patch attempts to improve CFS's SMP global fairness based on the new
>> virtual time design.
>>
>> Removed vruntime adjustment in set_task_cpu() as it skews global fairness.
>>
>> Modified small_imbalance logic in find_busiest_group(). If there's small
>> imbalance, move tasks from busiest to local sched_group only if the local
>> group contains a CPU whose min_vruntime is the maximum among all CPUs in
>> the same sched_domain. This prevents any CPU from advancing too far ahead
>> in virtual time and avoids tasks thrashing between two CPUs without
>> utilizing other CPUs in the system. For example, for 10 tasks on 8 CPUs,
>> since the load is not evenly divisible by the number of CPUs, we want the
>> extra load to have a fair use of every CPU in the system.
>>
>> Tested with a microbenchmark running 10 nice-0 tasks on 8 CPUs. Each task
>
> Just as an experiment, can you run 82 tasks on 8 CPUs. Current
> imbalance_pct logic will not detect and fix the global fairness issue
> even with this patch.

Right. For 82 tasks on 8 CPUs, the max error is 7.07% and min is -14.12%. 
It could be fixed by removing the imbalance_pct check (i.e., making 
imbalance_pct effectively 1). The cost would be more migrations, so I 
wasn't sure if that was the approach people would agree on.

>
>>  	if (*imbalance < busiest_load_per_task) {
>> -		unsigned long tmp, pwr_now, pwr_move;
>> -		unsigned int imbn;
>> -
>>  small_imbalance:
>> -		pwr_move = pwr_now = 0;
>> -		imbn = 2;
>> -		if (this_nr_running) {
>> -			this_load_per_task /= this_nr_running;
>> -			if (busiest_load_per_task > this_load_per_task)
>> -				imbn = 1;
>> -		} else
>> -			this_load_per_task = SCHED_LOAD_SCALE;
>> -
>> -		if (max_load - this_load + SCHED_LOAD_SCALE_FUZZ >=
>> -					busiest_load_per_task * imbn) {
>> -			*imbalance = busiest_load_per_task;
>> -			return busiest;
>> -		}
>
> This patch removes quite a few lines and all this is logic is not for
> fairness :( Especially the above portion handles some of the HT/MC
> optimizations.

What are the optimizations? I was trying to simplify the code to use only 
vruntime to control balancing when there's small imbalance, but if it 
breaks non-fairness related optimizations, we can certainly add the code 
back.

   tong

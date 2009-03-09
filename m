Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbZCIHiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbZCIHiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 03:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZCIHiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 03:38:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:27445 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbZCIHh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 03:37:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,328,1233561600"; 
   d="scan'208";a="671371258"
Subject: Re: [RFC PATCH 00/19] Cleanup and optimise the page allocator V2
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20090306093918.GA20698@elte.hu>
References: <20090226110336.GC32756@csn.ul.ie>
	 <1235647139.16552.34.camel@penberg-laptop>
	 <20090226112232.GE32756@csn.ul.ie> <1235724283.11610.212.camel@minggr>
	 <20090302112122.GC21145@csn.ul.ie> <1236132307.2567.25.camel@ymzhang>
	 <20090304090740.GA27043@wotan.suse.de> <1236218198.2567.119.camel@ymzhang>
	 <20090305103403.GB32407@elte.hu>
	 <1236328388.11608.35.camel@minggr.sh.intel.com>
	 <20090306093918.GA20698@elte.hu>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 15:31:10 +0800
Message-Id: <1236583870.11608.69.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 17:39 +0800, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > Thanks, I have used "perfstat -s" to collect cache misses 
> > data.
> > 
> > 2.6.29-rc7-tip: tip/perfcounters/core (b5e8acf)
> > 2.6.29-rc7-tip-mg2: v2 patches applied to tip/perfcounters/core
> > 
> > I collected 5 times netperf UDP-U-4k data with and without 
> > mg-v2 patches applied to tip/perfcounters/core on a 4p 
> > quad-core tigerton machine, as below "value" means UDP-U-4k 
> > test result.
> > 
> > 2.6.29-rc7-tip
> > ---------------
> > value           cache misses    CPU migrations  cachemisses/migrations
> > 5329.71          391094656       1710            228710
> > 5641.59          239552767       2138            112045
> > 5580.87          132474745       2172            60992
> > 5547.19          86911457        2099            41406
> > 5626.38          196751217       2050            95976
> > 
> > 2.6.29-rc7-tip-mg2
> > -------------------
> > value           cache misses    CPU migrations  cachemisses/migrations
> > 4749.80          649929463       1132            574142
> > 4327.06          484100170       1252            386661
> > 4649.51          374201508       1489            251310
> > 5655.82          405511551       1848            219432
> > 5571.58          90222256        2159            41788
> > 
> > Lin Ming
> 
> Hm, these numbers look really interesting and give us insight 
> into this workload. The workload is fluctuating but by measuring 
> 3 metrics at once instead of just one we see the following 
> patterns:
> 
>  - Less CPU migrations means more cache misses and less 
>    performance.
> 
> The lowest-score runs had the lowest CPU migrations count, 
> coupled with a high amount of cachemisses.
> 
> This _probably_ means that in this workload migrations are 
> desired: the sooner two related tasks migrate to the same CPU 
> the better. If they stay separate (migration count is low) then 
> they interact with each other from different CPUs, creating a 
> lot of cachemisses and reducing performance.
> 
> You can reduce the migration barrier of the system by enabling 
> CONFIG_SCHED_DEBUG=y and setting sched_migration_cost to zero:
> 
>    echo 0 > /proc/sys/kernel/sched_migration_cost
> 
> This will hurt other workloads - but if this improves the 
> numbers then it proves that what this particular workload wants 
> is easy migrations.

Again, I don't bind client/server to different cpus.
./netserver
./netperf -t UDP_STREAM -l 60 -H 127.0.0.1  -- -P 15888,12384 -s 32768 -S 32768 -m 4096

2.6.29-rc7-tip-mg2
-------------------
echo 0 > /proc/sys/kernel/sched_migration_cost
value           cache misses    CPU migrations  cachemisses/migrations
2867.62          880055866       117             7521845
2920.08          884482955       122             7249860
2903.16          905450628       127             7129532
2930.94          877616337       104             8438618
5224.02          1428643167      133             10741677

if sysctl_sched_migration_cost is set to zero,
sender/receiver will have less chance to do sync wakeups. (less migrations)

wake_affine (...) {
	...
	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
                        p->se.avg_overlap > sysctl_sched_migration_cost))
                sync = 0;
	...
}

echo -1 to sched_migration_cost can improve the numbers. (more migrations)

echo -1 > /proc/sys/kernel/sched_migration_cost
value           cache misses    CPU migrations  cachemisses/migrations
5524.52          97137973        2331            41672
5454.54          92589648        2542            36423
5458.63          96943477        3968            24431
5524.40          89298489        2574            34692
5493.64          87080343        2490            34972

> 
> Now the question is, why does the mg2 patchset reduce the number 
> of migrations? It might not be an inherent property of the mg2 
> patches: maybe just unlucky timings push the workload across 
> sched_migration_cost.
> 
> Setting sched_migration_cost to either zero or to a very high 
> value and repeating the test will eliminate this source of noise 
> and will tell us about other properties of the mg2 patchset.
> 
> There might be other effects i'm missing. For example what kind 
> of UDP transport is used - localhost networking? That means that 

Yes, localhost networking.

Lin Ming

> sender and receiver really wants to be coupled strongly and what 
> controls this workload is whether such a 'pair' of tasks can 
> properly migrate to the same CPU.
> 
> 	Ingo


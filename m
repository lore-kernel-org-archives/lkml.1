Return-Path: <linux-kernel-owner+w=401wt.eu-S1761750AbZJNNfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761750AbZJNNfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 09:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760461AbZJNNfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 09:35:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60381 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760245AbZJNNfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 09:35:32 -0400
Date: Wed, 14 Oct 2009 14:34:58 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
	operations in the hotpaths
Message-ID: <20091014133457.GB5027@csn.ul.ie>
References: <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org> <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org> <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131625370.13756@gentwo.org> <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 03:53:00PM -0700, David Rientjes wrote:
> On Tue, 13 Oct 2009, Christoph Lameter wrote:
> 
> > > For an optimized fastpath, I'd expect such a workload would result in at
> > > least a slightly higher transfer rate.
> > 
> > There will be no improvements if the load is dominated by the
> > instructions in the network layer or caching issues. None of that is
> > changed by the path. It only reduces the cycle count in the fastpath.
> > 
> 
> Right, but CONFIG_SLAB shows a 5-6% improvement over CONFIG_SLUB in the 
> same workload so it shows that the slab allocator does have an impact in 
> transfer rate.  I understand that the performance gain with this patchset, 
> however, may not be representative with the benchmark since it also 
> frequently uses the slowpath for kmalloc-256 about 25% of the time and the 
> added code of the irqless patch may mask the fastpath gain.
> 

I have a bit more detailed results based on the following machine

CPU type:	AMD Phenom 9950
CPU counts:	1 CPU (4 cores)
CPU Speed:	1.3GHz
Motherboard:	Gigabyte GA-MA78GM-S2H
Memory:		8GB

The reference kernel used is mmotm-2009-10-09-01-07. The patches applied
are the patches in this thread. The headings are a bit munged but it's

SLUB-vanilla	where vanilla is mmotm-2009-10-09-01-07
SLUB-this-cpu	mmotm-2009-10-09-01-07 + patches in this thread
SLAB-*		same as above but SLAB configured instead of SLUB.
		I know it wasn't necessary to run SLAB-this-cpu but
		it gives an idea to what degree results can vary
		between reboots even if results are stable once the
		machine is running.

The benchmarks run were kernbench, netperf UDP_STREAM and TCP_STREAM and
sysbench with postgres.

Kernbench is 5 kernel compiles and an average taken. One kernel compile
is done at the start to warm the benchmark up and this result is
discarded.

Netperf is the _STREAM tests as opposed to the _RR tests reported
elsewhere. No special effort is done to bind processes to any particular
CPU. The results reported tried to be 99% confidence that the estimated
mean was within 1% of the true mean. Results where netperf failed to
achieve the necessary confidence are marked with a * and the line after
such a result states what percentage the estimated mean is to the true
mean. The test is run with different packet sizes.

Sysbench is a read-only test (to avoid IO) and is the "complex"
workload. The test is run with varying numbers of threads.

In all the results, SLUB-vanilla is the reference baseline. This allows
a comparison between SLUB-vanilla and SLAB-vanilla as well with the
patches applied.

            kernbench-SLUB-vanilla-kernbench    kernbench-SLUBkernbench-SLAB-vanilla-kernbench    kernbench-SLAB
                  SLUB-vanilla          this-cpu      SLAB-vanilla          this-cpu
Elapsed min       92.95 ( 0.00%)    92.62 ( 0.36%)    92.93 ( 0.02%)    92.62 ( 0.36%)
Elapsed mean      93.11 ( 0.00%)    92.74 ( 0.40%)    93.00 ( 0.13%)    92.82 ( 0.32%)
Elapsed stddev     0.10 ( 0.00%)     0.14 (-40.55%)     0.04 (55.47%)     0.18 (-84.33%)
Elapsed max       93.20 ( 0.00%)    92.95 ( 0.27%)    93.05 ( 0.16%)    93.09 ( 0.12%)
User    min      323.21 ( 0.00%)   322.60 ( 0.19%)   322.50 ( 0.22%)   323.26 (-0.02%)
User    mean     323.81 ( 0.00%)   323.20 ( 0.19%)   323.16 ( 0.20%)   323.54 ( 0.08%)
User    stddev     0.40 ( 0.00%)     0.46 (-15.30%)     0.48 (-20.92%)     0.29 (26.07%)
User    max      324.32 ( 0.00%)   323.72 ( 0.19%)   323.86 ( 0.14%)   323.98 ( 0.10%)
System  min       35.95 ( 0.00%)    35.50 ( 1.25%)    35.35 ( 1.67%)    36.01 (-0.17%)
System  mean      36.30 ( 0.00%)    35.96 ( 0.96%)    36.17 ( 0.36%)    36.23 ( 0.21%)
System  stddev     0.25 ( 0.00%)     0.45 (-75.60%)     0.56 (-121.14%)     0.14 (46.14%)
System  max       36.65 ( 0.00%)    36.67 (-0.05%)    36.94 (-0.79%)    36.39 ( 0.71%)
CPU     min      386.00 ( 0.00%)   386.00 ( 0.00%)   386.00 ( 0.00%)   386.00 ( 0.00%)
CPU     mean     386.25 ( 0.00%)   386.75 (-0.13%)   386.00 ( 0.06%)   387.25 (-0.26%)
CPU     stddev     0.43 ( 0.00%)     0.83 (-91.49%)     0.00 (100.00%)     0.83 (-91.49%)
CPU     max      387.00 ( 0.00%)   388.00 (-0.26%)   386.00 ( 0.26%)   388.00 (-0.26%)

Small gains in the User, System and Elapsed times with this-cpu patches
applied. It is interest to note for the mean times that the patches more
than close the gap between SLUB and SLAB for the most part - the
exception being User which has marginally better performance. This might
indicate that SLAB is still slightly better at giving back cache-hot
memory but this is speculation.

NETPERF UDP_STREAM
  Packet           netperf-udp          udp-SLUB       netperf-udp          udp-SLAB
    Size          SLUB-vanilla          this-cpu      SLAB-vanilla          this-cpu
      64       148.48 ( 0.00%)    152.03 ( 2.34%)    147.45 (-0.70%)    150.07 ( 1.06%) 
     128       294.65 ( 0.00%)    299.92 ( 1.76%)    289.20 (-1.88%)    290.15 (-1.55%) 
     256       583.63 ( 0.00%)    609.14 ( 4.19%)    590.78 ( 1.21%)    586.42 ( 0.48%) 
    1024      2217.90 ( 0.00%)   2261.99 ( 1.95%)   2219.64 ( 0.08%)   2207.93 (-0.45%) 
    2048      4164.27 ( 0.00%)   4161.47 (-0.07%)   4216.46 ( 1.24%)   4155.11 (-0.22%) 
    3312      6284.17 ( 0.00%)   6383.24 ( 1.55%)   6231.88 (-0.84%)   6243.82 (-0.65%) 
    4096      7399.42 ( 0.00%)   7686.38 ( 3.73%)   7394.89 (-0.06%)   7487.91 ( 1.18%) 
    6144     10014.35 ( 0.00%)  10199.48 ( 1.82%)   9927.92 (-0.87%)* 10067.40 ( 0.53%) 
                 1.00%             1.00%             1.08%             1.00%        
    8192     11232.50 ( 0.00%)* 11368.13 ( 1.19%)* 12280.88 ( 8.54%)* 12244.23 ( 8.26%) 
                 1.65%             1.64%             1.32%             1.00%        
   10240     12961.87 ( 0.00%)  13099.82 ( 1.05%)* 13816.33 ( 6.18%)* 13927.18 ( 6.93%) 
                 1.00%             1.03%             1.21%             1.00%        
   12288     14403.74 ( 0.00%)* 14276.89 (-0.89%)* 15173.09 ( 5.07%)* 15464.05 ( 6.86%)*
                 1.31%             1.63%             1.93%             1.55%        
   14336     15229.98 ( 0.00%)* 15218.52 (-0.08%)* 16412.94 ( 7.21%)  16252.98 ( 6.29%) 
                 1.37%             2.76%             1.00%             1.00%        
   16384     15367.60 ( 0.00%)* 16038.71 ( 4.18%)  16635.91 ( 7.62%)  17128.87 (10.28%)*
             1.29%             1.00%             1.00%             6.36%        

The patches mostly improve the performance of netperf UDP_STREAM by a good
whack so the patches are a plus here. However, it should also be noted that
SLAB was mostly faster than SLUB, particularly for large packet sizes. Refresh
my memory, how do SLUB and SLAB differ in regards to off-loading large
allocations to the page allocator these days?

NETPERF TCP_STREAM
  Packet           netperf-tcp          tcp-SLUB       netperf-tcp          tcp-SLAB
    Size          SLUB-vanilla          this-cpu      SLAB-vanilla          this-cpu
      64      1773.00 ( 0.00%)   1731.63 (-2.39%)*  1794.48 ( 1.20%)   2029.46 (12.64%) 
                 1.00%             2.43%             1.00%             1.00%        
     128      3181.12 ( 0.00%)   3471.22 ( 8.36%)   3296.37 ( 3.50%)   3251.33 ( 2.16%) 
     256      4794.35 ( 0.00%)   4797.38 ( 0.06%)   4912.99 ( 2.41%)   4846.86 ( 1.08%) 
    1024      9438.10 ( 0.00%)   8681.05 (-8.72%)*  8270.58 (-14.12%)   8268.85 (-14.14%) 
                 1.00%             7.31%             1.00%             1.00%        
    2048      9196.06 ( 0.00%)   9375.72 ( 1.92%)  11474.59 (19.86%)   9420.01 ( 2.38%) 
    3312     10338.49 ( 0.00%)* 10021.82 (-3.16%)* 12018.72 (13.98%)* 12069.28 (14.34%)*
                 9.49%             6.36%             1.21%             2.12%        
    4096      9931.20 ( 0.00%)* 10285.38 ( 3.44%)* 12265.59 (19.03%)* 10175.33 ( 2.40%)*
                 1.31%             1.38%             9.97%             8.33%        
    6144     12775.08 ( 0.00%)* 10559.63 (-20.98%)  13139.34 ( 2.77%)  13210.79 ( 3.30%)*
                 1.45%             1.00%             1.00%             2.99%        
    8192     10933.93 ( 0.00%)* 10534.41 (-3.79%)* 10876.42 (-0.53%)* 10738.25 (-1.82%)*
                14.29%             2.10%            12.50%             9.55%        
   10240     12868.58 ( 0.00%)  12991.65 ( 0.95%)  10892.20 (-18.14%)  13106.01 ( 1.81%) 
   12288     11854.97 ( 0.00%)  12122.34 ( 2.21%)* 12129.79 ( 2.27%)* 12411.84 ( 4.49%)*
                 1.00%             6.61%             5.78%             8.95%        
   14336     12552.48 ( 0.00%)* 12501.71 (-0.41%)* 12274.54 (-2.26%)  12322.63 (-1.87%)*
                 6.05%             2.58%             1.00%             2.23%        
   16384     11733.09 ( 0.00%)* 12735.05 ( 7.87%)* 13195.68 (11.08%)* 14401.62 (18.53%) 
                 1.14%             9.79%            10.30%             1.00%        

The results for the patches are a bit all over the place for TCP_STREAM
with big gains and losses depending on the packet size, particularly 6144
for some reason. SLUB vs SLAB shows SLAB often has really massive advantages
and this is not always for the larger packet sizes where the page allocator
might be a suspect.

SYSBENCH
            sysbench-SLUB-vanilla-sysbench     sysbench-SLUBsysbench-SLAB-vanilla-sysbench     sysbench-SLAB
                  SLUB-vanilla          this-cpu      SLAB-vanilla          this-cpu
           1 26950.79 ( 0.00%) 26822.05 (-0.48%) 26919.89 (-0.11%) 26746.18 (-0.77%)
           2 51555.51 ( 0.00%) 51928.02 ( 0.72%) 51370.02 (-0.36%) 51129.82 (-0.83%)
           3 76204.23 ( 0.00%) 76333.58 ( 0.17%) 76483.99 ( 0.37%) 75954.52 (-0.33%)
           4 100599.12 ( 0.00%) 101757.98 ( 1.14%) 100499.65 (-0.10%) 101605.61 ( 0.99%)
           5 100211.45 ( 0.00%) 100435.33 ( 0.22%) 100150.98 (-0.06%) 99398.11 (-0.82%)
           6 99390.81 ( 0.00%) 99840.85 ( 0.45%) 99234.38 (-0.16%) 99244.42 (-0.15%)
           7 98740.56 ( 0.00%) 98727.61 (-0.01%) 98305.88 (-0.44%) 98123.56 (-0.63%)
           8 98075.89 ( 0.00%) 98048.62 (-0.03%) 98183.99 ( 0.11%) 97587.82 (-0.50%)
           9 96502.22 ( 0.00%) 97276.80 ( 0.80%) 96819.88 ( 0.33%) 97320.51 ( 0.84%)
          10 96598.70 ( 0.00%) 96545.37 (-0.06%) 96222.51 (-0.39%) 96221.69 (-0.39%)
          11 95500.66 ( 0.00%) 95671.11 ( 0.18%) 95003.21 (-0.52%) 95246.81 (-0.27%)
          12 94572.87 ( 0.00%) 95266.70 ( 0.73%) 93807.60 (-0.82%) 94859.82 ( 0.30%)
          13 93811.85 ( 0.00%) 94309.18 ( 0.53%) 93219.81 (-0.64%) 93051.63 (-0.82%)
          14 92972.16 ( 0.00%) 93849.87 ( 0.94%) 92641.50 (-0.36%) 92916.70 (-0.06%)
          15 92276.06 ( 0.00%) 92454.94 ( 0.19%) 91094.04 (-1.30%) 91972.79 (-0.33%)
          16 90265.35 ( 0.00%) 90416.26 ( 0.17%) 89309.26 (-1.07%) 90103.89 (-0.18%)

The patches mostly gain for sysbench although the gains are very marginal
and SLUB has a minor advantage over SLAB. I haven't actually checked how
slab-intensive this workload is. The differences are no marginal, I would
guess the answer is "not very".

Overall based on these results, I would say that the patches are a "Good Thing"
for this machine at least. With the patches applied, SLUB has a marginal
advantage over SLAB for kernbench. However, netperf TCP_STREAM and UDP_STREAM
both show significant disadvantages for SLUB and this cannot be always
explained by differing behaviour with respect to page-allocator offloading.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

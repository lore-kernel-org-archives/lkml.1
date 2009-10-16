Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbZJPKuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbZJPKuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 06:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZJPKuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 06:50:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59723 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZJPKuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 06:50:50 -0400
Date: Fri, 16 Oct 2009 11:50:16 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
	operations in the hotpaths
Message-ID: <20091016105016.GB32397@csn.ul.ie>
References: <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org> <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131625370.13756@gentwo.org> <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com> <20091014133457.GB5027@csn.ul.ie> <alpine.DEB.1.10.0910141003590.9944@gentwo.org> <20091014154944.GD5027@csn.ul.ie> <4AD5F3F8.8080603@cs.helsinki.fi> <alpine.DEB.1.10.0910141154320.26476@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910141154320.26476@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 11:56:29AM -0400, Christoph Lameter wrote:
> On Wed, 14 Oct 2009, Pekka Enberg wrote:
> 
> > SLAB is able to queue lots of large objects but SLUB can't do that because it
> > has no queues. In SLUB, each CPU gets a page assigned to it that serves as a
> > "queue" but the size of the queue gets smaller as object size approaches page
> > size.
> >
> > We try to offset that with higher order allocations but IIRC we don't increase
> > the order linearly with object size and cap it to some reasonable maximum.
> 
> You can test to see if larger pages have an influence by passing
> 
> slub_max_order=6
> 
> or so on the kernel command line.
> 
> You can force a large page use in slub by setting
> 
> slub_min_order=3
> 
> f.e.
> 
> Or you can force a mininum number of objecxcts in slub through f.e.
> 
> slub_min_objects=50
> 
> 
> 
> slub_max_order=6 slub_min_objects=50
> 
> should result in pretty large slabs with lots of in page objects that
> allow slub to queue better.
> 

Here are the results of that suggestion. They are side-by-side with the
other results so the columns are

SLUB-vanilla		No other patches applied, SLUB configured
vanilla-highorder	No other patches + slub_max_order=6 slub_min_objects=50
SLUB-this-cpu		The patches in this set applied
this-cpu-higher		These patches + slub_max_order=6 slub_min_objects=50
SLAB-vanilla		No other patches, SLAB configured
SLAB-this-cpu		Thes patches, SLAB configured

                  SLUB-vanilla   vanilla-highorder     SLUB-this-cpu  this-cpu-highorder    SLAB-vanilla     SLAB-this-cpu
Elapsed min       92.95 ( 0.00%)    92.64 ( 0.33%)    92.62 ( 0.36%)    92.77 ( 0.19%)    92.93 ( 0.02%)    92.62 ( 0.36%)
Elapsed mean      93.11 ( 0.00%)    92.89 ( 0.24%)    92.74 ( 0.40%)    92.82 ( 0.31%)    93.00 ( 0.13%)    92.82 ( 0.32%)
Elapsed stddev     0.10 ( 0.00%)     0.15 (-58.74%)     0.14 (-40.55%)     0.09 ( 7.73%)     0.04 (55.47%)     0.18 (-84.33%)
Elapsed max       93.20 ( 0.00%)    93.04 ( 0.17%)    92.95 ( 0.27%)    92.98 ( 0.24%)    93.05 ( 0.16%)    93.09 ( 0.12%)
User    min      323.21 ( 0.00%)   323.38 (-0.05%)   322.60 ( 0.19%)   323.26 (-0.02%)   322.50 ( 0.22%)   323.26 (-0.02%)
User    mean     323.81 ( 0.00%)   323.64 ( 0.05%)   323.20 ( 0.19%)   323.56 ( 0.08%)   323.16 ( 0.20%)   323.54 ( 0.08%)
User    stddev     0.40 ( 0.00%)     0.38 ( 4.24%)     0.46 (-15.30%)     0.27 (33.20%)     0.48 (-20.92%)     0.29 (26.07%)
User    max      324.32 ( 0.00%)   324.30 ( 0.01%)   323.72 ( 0.19%)   323.96 ( 0.11%)   323.86 ( 0.14%)   323.98 ( 0.10%)
System  min       35.95 ( 0.00%)    35.33 ( 1.72%)    35.50 ( 1.25%)    35.95 ( 0.00%)    35.35 ( 1.67%)    36.01 (-0.17%)
System  mean      36.30 ( 0.00%)    35.99 ( 0.87%)    35.96 ( 0.96%)    36.20 ( 0.28%)    36.17 ( 0.36%)    36.23 ( 0.21%)
System  stddev     0.25 ( 0.00%)     0.41 (-59.25%)     0.45 (-75.60%)     0.15 (41.61%)     0.56 (-121.14%)     0.14 (46.14%)
System  max       36.65 ( 0.00%)    36.44 ( 0.57%)    36.67 (-0.05%)    36.32 ( 0.90%)    36.94 (-0.79%)    36.39 ( 0.71%)
CPU     min      386.00 ( 0.00%)   386.00 ( 0.00%)   386.00 ( 0.00%)   386.00 ( 0.00%)   386.00 ( 0.00%)   386.00 ( 0.00%)
CPU     mean     386.25 ( 0.00%)   386.75 (-0.13%)   386.75 (-0.13%)   386.75 (-0.13%)   386.00 ( 0.06%)   387.25 (-0.26%)
CPU     stddev     0.43 ( 0.00%)     0.83 (-91.49%)     0.83 (-91.49%)     0.43 ( 0.00%)     0.00 (100.00%)     0.83 (-91.49%)
CPU     max      387.00 ( 0.00%)   388.00 (-0.26%)   388.00 (-0.26%)   387.00 ( 0.00%)   386.00 ( 0.26%)   388.00 (-0.26%)

The high-order allocations help here, but not by a massive amount. In some
cases it made things slightly worse. However, the standard deviations are
generally high enough to file most of the results under "noise"

NETPERF UDP
              SLUB-vanilla   vanilla-highorder     SLUB-this-cpu  this-cpu-highorder    SLAB-vanilla     SLAB-this-cpu
      64   148.48 ( 0.00%)    146.28 (-1.50%)    152.03 ( 2.34%)    152.20 ( 2.44%)    147.45 (-0.70%)    150.07 ( 1.06%) 
     128   294.65 ( 0.00%)    286.80 (-2.74%)    299.92 ( 1.76%)    302.55 ( 2.61%)    289.20 (-1.88%)    290.15 (-1.55%) 
     256   583.63 ( 0.00%)    564.84 (-3.33%)    609.14 ( 4.19%)    587.53 ( 0.66%)    590.78 ( 1.21%)    586.42 ( 0.48%) 
    1024  2217.90 ( 0.00%)   2176.12 (-1.92%)   2261.99 ( 1.95%)   2312.12 ( 4.08%)   2219.64 ( 0.08%)   2207.93 (-0.45%) 
    2048  4164.27 ( 0.00%)   4154.96 (-0.22%)   4161.47 (-0.07%)   4244.60 ( 1.89%)   4216.46 ( 1.24%)   4155.11 (-0.22%) 
    3312  6284.17 ( 0.00%)   6121.32 (-2.66%)   6383.24 ( 1.55%)   6356.61 ( 1.14%)   6231.88 (-0.84%)   6243.82 (-0.65%) 
    4096  7399.42 ( 0.00%)   7327.40 (-0.98%)*  7686.38 ( 3.73%)   7633.64 ( 3.07%)   7394.89 (-0.06%)   7487.91 ( 1.18%) 
             1.00%             1.07%             1.00%             1.00%             1.00%             1.00%        
    6144 10014.35 ( 0.00%)  10061.59 ( 0.47%)  10199.48 ( 1.82%)  10223.16 ( 2.04%)   9927.92 (-0.87%)* 10067.40 ( 0.53%) 
             1.00%             1.00%             1.00%             1.00%             1.08%             1.00%        
    8192 11232.50 ( 0.00%)* 11222.92 (-0.09%)* 11368.13 ( 1.19%)* 11403.82 ( 1.50%)* 12280.88 ( 8.54%)* 12244.23 ( 8.26%) 
             1.65%             1.37%             1.64%             1.16%             1.32%             1.00%        
   10240 12961.87 ( 0.00%)  12746.40 (-1.69%)* 13099.82 ( 1.05%)* 12767.02 (-1.53%)* 13816.33 ( 6.18%)* 13927.18 ( 6.93%) 
             1.00%             2.34%             1.03%             1.26%             1.21%             1.00%        
   12288 14403.74 ( 0.00%)* 14136.36 (-1.89%)* 14276.89 (-0.89%)* 14246.18 (-1.11%)* 15173.09 ( 5.07%)* 15464.05 ( 6.86%)*
             1.31%             1.60%             1.63%             1.60%             1.93%             1.55%        
   14336 15229.98 ( 0.00%)* 14962.61 (-1.79%)* 15218.52 (-0.08%)* 15243.51 ( 0.09%)  16412.94 ( 7.21%)  16252.98 ( 6.29%) 
             1.37%             1.66%             2.76%             1.00%             1.00%             1.00%        
   16384 15367.60 ( 0.00%)* 15543.13 ( 1.13%)* 16038.71 ( 4.18%)  15870.54 ( 3.17%)* 16635.91 ( 7.62%)  17128.87 (10.28%)*
             1.29%             1.34%             1.00%             2.18%             1.00%             6.36%        

Configuring use of high-order pages actually hurt SLUB mostly on the unpatched
kernel. The results are mixed with the patches applied. Hard to draw anything
very conclusive to be honest. Based on these results, I wouldn't push the
high-order allocations aggressively.

NETPERF TCP
              SLUB-vanilla   vanilla-highorder     SLUB-this-cpu  this-cpu-highorder    SLAB-vanilla     SLAB-this-cpu
      64  1773.00 ( 0.00%)   1812.07 ( 2.16%)*  1731.63 (-2.39%)*  1717.99 (-3.20%)*  1794.48 ( 1.20%)   2029.46 (12.64%) 
             1.00%             5.88%             2.43%             2.83%             1.00%             1.00%        
     128  3181.12 ( 0.00%)   3193.06 ( 0.37%)*  3471.22 ( 8.36%)   3154.79 (-0.83%)   3296.37 ( 3.50%)   3251.33 ( 2.16%) 
             1.00%             1.70%             1.00%             1.00%             1.00%             1.00%        
     256  4794.35 ( 0.00%)   4813.37 ( 0.40%)   4797.38 ( 0.06%)   4819.16 ( 0.51%)   4912.99 ( 2.41%)   4846.86 ( 1.08%) 
    1024  9438.10 ( 0.00%)   8144.02 (-15.89%)   8681.05 (-8.72%)*  8204.11 (-15.04%)   8270.58 (-14.12%)   8268.85 (-14.14%) 
             1.00%             1.00%             7.31%             1.00%             1.00%             1.00%        
    2048  9196.06 ( 0.00%)  11233.72 (18.14%)   9375.72 ( 1.92%)  10487.89 (12.32%)* 11474.59 (19.86%)   9420.01 ( 2.38%) 
             1.00%             1.00%             1.00%             9.43%             1.00%             1.00%        
    3312 10338.49 ( 0.00%)*  9730.79 (-6.25%)* 10021.82 (-3.16%)* 10089.90 (-2.46%)* 12018.72 (13.98%)* 12069.28 (14.34%)*
             9.49%             2.51%             6.36%             5.96%             1.21%             2.12%        
    4096  9931.20 ( 0.00%)* 12447.88 (20.22%)  10285.38 ( 3.44%)* 10548.56 ( 5.85%)* 12265.59 (19.03%)* 10175.33 ( 2.40%)*
             1.31%             1.00%             1.38%             8.22%             9.97%             8.33%        
    6144 12775.08 ( 0.00%)* 10489.24 (-21.79%)* 10559.63 (-20.98%)  11033.15 (-15.79%)* 13139.34 ( 2.77%)  13210.79 ( 3.30%)*
             1.45%             8.46%             1.00%            12.65%             1.00%             2.99%        
    8192 10933.93 ( 0.00%)* 10340.42 (-5.74%)* 10534.41 (-3.79%)* 10845.36 (-0.82%)* 10876.42 (-0.53%)* 10738.25 (-1.82%)*
            14.29%             2.38%             2.10%             1.83%            12.50%             9.55%        
   10240 12868.58 ( 0.00%)  11211.60 (-14.78%)* 12991.65 ( 0.95%)  11330.97 (-13.57%)* 10892.20 (-18.14%)  13106.01 ( 1.81%) 
             1.00%            11.36%             1.00%             6.64%             1.00%             1.00%        
   12288 11854.97 ( 0.00%)  11854.51 (-0.00%)  12122.34 ( 2.21%)* 12258.61 ( 3.29%)* 12129.79 ( 2.27%)* 12411.84 ( 4.49%)*
             1.00%             1.00%             6.61%             5.69%             5.78%             8.95%        
   14336 12552.48 ( 0.00%)* 12309.15 (-1.98%)  12501.71 (-0.41%)* 13683.57 ( 8.27%)* 12274.54 (-2.26%)  12322.63 (-1.87%)*
             6.05%             1.00%             2.58%             2.46%             1.00%             2.23%        
   16384 11733.09 ( 0.00%)* 11856.66 ( 1.04%)* 12735.05 ( 7.87%)* 13482.61 (12.98%)* 13195.68 (11.08%)* 14401.62 (18.53%) 
             1.14%             1.05%             9.79%            11.52%            10.30%             1.00%        

Configuring high-rder helper in a few cases here and in one or two
cases close the gap with SLAB, particularly for large packet sizes.
However, it still suffered for the small packet sizes.

SYSBENCH
                  SLUB-vanilla  vanilla-highorder   SLUB-this-cpu  this-cpu-highorder   SLAB-vanilla     SLAB-this-cpu
           1 26950.79 ( 0.00%) 26723.98 (-0.85%) 26822.05 (-0.48%) 26877.71 (-0.27%) 26919.89 (-0.11%) 26746.18 (-0.77%)
           2 51555.51 ( 0.00%) 51231.41 (-0.63%) 51928.02 ( 0.72%) 51794.47 ( 0.46%) 51370.02 (-0.36%) 51129.82 (-0.83%)
           3 76204.23 ( 0.00%) 76060.77 (-0.19%) 76333.58 ( 0.17%) 76270.53 ( 0.09%) 76483.99 ( 0.37%) 75954.52 (-0.33%)
           4 100599.12 ( 0.00%) 100825.16 ( 0.22%) 101757.98 ( 1.14%) 100273.02 (-0.33%) 100499.65 (-0.10%) 101605.61 ( 0.99%)
           5 100211.45 ( 0.00%) 100096.77 (-0.11%) 100435.33 ( 0.22%) 101132.16 ( 0.91%) 100150.98 (-0.06%) 99398.11 (-0.82%)
           6 99390.81 ( 0.00%) 99305.36 (-0.09%) 99840.85 ( 0.45%) 99200.53 (-0.19%) 99234.38 (-0.16%) 99244.42 (-0.15%)
           7 98740.56 ( 0.00%) 98625.23 (-0.12%) 98727.61 (-0.01%) 98470.75 (-0.27%) 98305.88 (-0.44%) 98123.56 (-0.63%)
           8 98075.89 ( 0.00%) 97609.30 (-0.48%) 98048.62 (-0.03%) 97092.44 (-1.01%) 98183.99 ( 0.11%) 97587.82 (-0.50%)
           9 96502.22 ( 0.00%) 96685.39 ( 0.19%) 97276.80 ( 0.80%) 96800.23 ( 0.31%) 96819.88 ( 0.33%) 97320.51 ( 0.84%)
          10 96598.70 ( 0.00%) 96272.05 (-0.34%) 96545.37 (-0.06%) 95936.97 (-0.69%) 96222.51 (-0.39%) 96221.69 (-0.39%)
          11 95500.66 ( 0.00%) 95141.00 (-0.38%) 95671.11 ( 0.18%) 96057.84 ( 0.58%) 95003.21 (-0.52%) 95246.81 (-0.27%)
          12 94572.87 ( 0.00%) 94811.46 ( 0.25%) 95266.70 ( 0.73%) 93767.06 (-0.86%) 93807.60 (-0.82%) 94859.82 ( 0.30%)
          13 93811.85 ( 0.00%) 93597.39 (-0.23%) 94309.18 ( 0.53%) 93323.96 (-0.52%) 93219.81 (-0.64%) 93051.63 (-0.82%)
          14 92972.16 ( 0.00%) 92936.53 (-0.04%) 93849.87 ( 0.94%) 92545.83 (-0.46%) 92641.50 (-0.36%) 92916.70 (-0.06%)
          15 92276.06 ( 0.00%) 91559.63 (-0.78%) 92454.94 ( 0.19%) 91748.29 (-0.58%) 91094.04 (-1.30%) 91972.79 (-0.33%)
          16 90265.35 ( 0.00%) 89707.32 (-0.62%) 90416.26 ( 0.17%) 89253.93 (-1.13%) 89309.26 (-1.07%) 90103.89 (-0.18%)

High-order didn't really help here either.

Overall, it would appear that high-order allocations occasionally help
but the margins are pretty small.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
